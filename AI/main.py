import os
import io
import cv2
import csv
import pickle
import numpy as np
from datetime import datetime
from collections import defaultdict
from itertools import combinations
from fastapi import FastAPI, File, UploadFile, HTTPException, Query
from fastapi.responses import JSONResponse
from PIL import Image
from tensorflow.keras.models import load_model, Model
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.resnet50 import preprocess_input
from numpy.linalg import norm
from sklearn.metrics import roc_curve, auc
import uvicorn
import logging

# ================= CONFIG =================
MODEL_PATH = r"final_improved_resnet50_model_1_1_1.h5"
DATASET_DIR = r"DataSet_Y_Y_A_H"
EMB_DB_PATH = "embeddings_db.npy"         # saved as (N_images, D)
EMB_NAMES_PATH = "embeddings_names.npy"   # saved as list length N_images
META_PATH = "emb_meta.pkl"
LOG_DIR = "logs"
LOG_FILE = os.path.join(LOG_DIR, "predictions.csv")
IMG_SIZE = (224, 224)
COSINE_THRESHOLD = 0.85
PAIRWISE_EVAL_LIMIT = 4000  # max images for pairwise evaluation to avoid explosion

# Eyes-only mode (ArcFace removed)
USE_ARCFACE = False

os.makedirs(LOG_DIR, exist_ok=True)

# ---------------- Logging setup ----------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s - %(message)s",
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger("eyes_api")

app = FastAPI(title="Eyes-Only Recognition API (ResNet embeddings only)")

# ---------------- Load Models ----------------
logger.info("📦 Loading ResNet50 model...")

# Load your trained ResNet model (expects input shape compatible with IMG_SIZE)
try:
    base_model = load_model(MODEL_PATH, compile=False)
    logger.info("✅ Model file loaded from %s", MODEL_PATH)
except Exception as e:
    logger.exception("Failed to load model from %s", MODEL_PATH)
    raise

# --------- Select embedding layer intelligently ----------
embedding_model = None
try:
    # Try common candidate names first
    for candidate in ("dense_2", "dense", "fc", "flatten", "global_average_pooling2d", "avg_pool"):
        try:
            layer = base_model.get_layer(candidate)
            embedding_model = Model(inputs=base_model.input, outputs=layer.output)
            logger.info("Using layer '%s' as embedding layer (by name). output_shape=%s", candidate, getattr(layer, "output_shape", None))
            break
        except Exception:
            continue

    # If not found, fallback to the layer before the final layer
    if embedding_model is None:
        final_idx = len(base_model.layers) - 1
        pre_final_idx = max(0, final_idx - 1)
        layer = base_model.layers[pre_final_idx]
        embedding_model = Model(inputs=base_model.input, outputs=layer.output)
        logger.info("Using fallback layer index %d (%s) as embedding. output_shape=%s", pre_final_idx, layer.name, getattr(layer, "output_shape", None))

    logger.info("embedding_model.output_shape = %s", getattr(embedding_model, "output_shape", None))
except Exception as e:
    logger.exception("Failed to construct embedding_model. Falling back to full model output.")
    embedding_model = base_model
    logger.info("embedding_model.output_shape = %s", getattr(embedding_model, "output_shape", None))

logger.info("✅ ResNet ready.")

# ---------------- Helpers ----------------
def normalize(vec):
    vec = np.array(vec, dtype=np.float32)
    n = norm(vec)
    if n < 1e-10:
        return vec
    return vec / n


def preprocess_eye(img_bytes, save_failed_path=os.path.join(LOG_DIR, "failed_images")):
    os.makedirs(save_failed_path, exist_ok=True)
    try:
        pil = Image.open(io.BytesIO(img_bytes)).convert("RGB")
        img = np.array(pil)
    except Exception as e:
        fname = f"invalid_{datetime.utcnow().strftime('%Y%m%d%H%M%S%f')}.jpg"
        p = os.path.join(save_failed_path, fname)
        try:
            with open(p, "wb") as ff:
                ff.write(img_bytes)
        except Exception:
            pass
        logger.exception("preprocess_eye: failed to open image. Saved to %s", p)
        raise HTTPException(status_code=400, detail="Invalid image format.")

    try:
        img_resized = cv2.resize(img, IMG_SIZE)
    except Exception as e:
        fname = f"resize_error_{datetime.utcnow().strftime('%Y%m%d%H%M%S%f')}.jpg"
        p = os.path.join(save_failed_path, fname)
        try:
            cv2.imwrite(p, img)
        except Exception:
            pass
        logger.exception("preprocess_eye: resize failed, saved to %s", p)
        raise HTTPException(status_code=400, detail="Failed to resize image.")

    arr = np.expand_dims(image.img_to_array(Image.fromarray(img_resized)), axis=0)
    try:
        arr = preprocess_input(arr)
    except Exception:
        logger.exception("preprocess_eye: preprocess_input failed.")
        raise HTTPException(status_code=400, detail="Preprocess failed.")
    return arr


def compute_resnet_emb(img_array):
    try:
        emb = embedding_model.predict(img_array, verbose=0)
    except Exception as e:
        logger.exception("compute_resnet_emb: model.predict failed.")
        raise
    emb = np.array(emb).flatten()
    logger.info("compute_resnet_emb: produced emb shape=%s sample=%s", emb.shape, emb.flatten()[:6].tolist())
    return normalize(emb)


def concat_fuse(emb_resnet, emb_arcface=None):
    if emb_resnet is None:
        return None
    return normalize(np.asarray(emb_resnet))


def cosine_similarity(a, b):
    a = np.array(a, dtype=np.float32)
    b = np.array(b, dtype=np.float32)
    den = (norm(a) * norm(b) + 1e-10)
    return float(np.dot(a, b) / den)


def save_log_row(filename, predicted, best_score, top_classes):
    ts = datetime.utcnow().isoformat()
    row = [ts, filename or "", predicted, round(best_score, 4), ";".join([f"{n}:{round(s,4)}" for n, s in top_classes])]
    header = ["timestamp", "filename", "prediction", "best_score", "top_classes"]
    write_header = not os.path.exists(LOG_FILE)
    try:
        with open(LOG_FILE, "a", newline="", encoding="utf8") as f:
            writer = csv.writer(f)
            if write_header:
                writer.writerow(header)
            writer.writerow(row)
    except Exception:
        logger.exception("Failed to write log row to %s", LOG_FILE)

# ---------------- Register DB (per-image) ----------------
@app.post("/register_db")
def register_db():
    image_embeddings = []
    image_names = []
    failed_files = []

    if not os.path.exists(DATASET_DIR):
        raise HTTPException(status_code=400, detail=f"Dataset not found: {DATASET_DIR}")

    logger.info("📂 Scanning dataset: %s", DATASET_DIR)
    for person_name in sorted(os.listdir(DATASET_DIR)):
        person_path = os.path.join(DATASET_DIR, person_name)
        if not os.path.isdir(person_path):
            continue
        logger.info("  ▶ Processing person: %s", person_name)
        n_added = 0
        for fname in sorted(os.listdir(person_path)):
            if not fname.lower().endswith((".jpg", ".jpeg", ".png")):
                continue
            img_path = os.path.join(person_path, fname)
            try:
                with open(img_path, "rb") as f:
                    b = f.read()
                arr = preprocess_eye(b)
                emb_res = compute_resnet_emb(arr)
                fused = concat_fuse(emb_res, None)
                if fused is None:
                    logger.warning("    ⚠ Skipped %s — no embedding.", img_path)
                    failed_files.append((img_path, "no_embedding"))
                    continue
                image_embeddings.append(np.asarray(fused, dtype=np.float32))
                image_names.append(person_name)
                n_added += 1
            except Exception as e:
                failed_files.append((img_path, str(e)))
                logger.exception("    ⚠ Skipped %s: %s", img_path, e)
        logger.info("    → added %d images for %s.", n_added, person_name)

    if len(image_embeddings) == 0:
        logger.error("No images processed. Check dataset and failed_files.")
        raise HTTPException(status_code=400, detail="No images processed. Check dataset.")

    emb_array = np.stack(image_embeddings, axis=0)
    try:
        np.save(EMB_DB_PATH, emb_array)
        np.save(EMB_NAMES_PATH, np.array(image_names, dtype=object), allow_pickle=True)
        meta = {"dim": emb_array.shape[1], "n_images": emb_array.shape[0], "method": "resnet_eyes_only", "timestamp": datetime.utcnow().isoformat()}
        with open(META_PATH, "wb") as mf:
            pickle.dump(meta, mf)
        logger.info("💾 Saved %s shape=%s and %s (n=%d)", EMB_DB_PATH, emb_array.shape, EMB_NAMES_PATH, len(image_names))
        logger.info("📎 Saved metadata to %s", META_PATH)
    except Exception as e:
        logger.exception("Failed saving DB files: %s", e)
        raise HTTPException(status_code=500, detail="Failed saving DB files.")

    if failed_files:
        failure_log = os.path.join(LOG_DIR, "register_failed.txt")
        try:
            with open(failure_log, "w", encoding="utf8") as ff:
                for p, why in failed_files:
                    ff.write(f"{p}\t{why}\n")
            logger.info("register_db: failures written to %s", failure_log)
        except Exception:
            logger.exception("Failed to write register failures to %s", failure_log)

    return {"status": "ok", "n_images": emb_array.shape[0], "dim": emb_array.shape[1], "n_failed": len(failed_files)}

# ---------------- Predict (with logging) ----------------
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        if not os.path.exists(EMB_DB_PATH) or not os.path.exists(EMB_NAMES_PATH):
            raise HTTPException(status_code=400, detail="Database missing. Run /register_db first.")

        db_emb = np.load(EMB_DB_PATH)
        db_names = np.load(EMB_NAMES_PATH, allow_pickle=True)

        logger.info("predict: loaded DB shape=%s, n_names=%s", db_emb.shape, db_names.shape)

        img_bytes = await file.read()
        filename = getattr(file, "filename", "")
        arr = preprocess_eye(img_bytes)
        emb_res = compute_resnet_emb(arr)

        fused = concat_fuse(emb_res, None)
        if fused is None:
            return JSONResponse({"error": "Could not extract embedding (no eye detected)."}, status_code=400)

        logger.info("predict: fused shape=%s sample=%s", fused.shape, fused.flatten()[:6].tolist())

        if fused.shape[0] != db_emb.shape[1]:
            if db_emb.shape[1] > fused.shape[0]:
                fused = np.concatenate([fused, np.zeros(db_emb.shape[1] - fused.shape[0], dtype=np.float32)])
                fused = normalize(fused)
                logger.info("🔧 Padded fused embedding to match DB dimension.")
            else:
                fused = fused[:db_emb.shape[1]]
                fused = normalize(fused)
                logger.info("🔧 Truncated fused embedding to match DB dimension.")

        sims = (db_emb @ fused) / (np.linalg.norm(db_emb, axis=1) * (np.linalg.norm(fused) + 1e-10))
        best_idx = int(np.argmax(sims))
        best_score = float(sims[best_idx])
        best_name = str(db_names[best_idx])

        class_best = defaultdict(lambda: -1.0)
        for i, name in enumerate(db_names):
            s = float(sims[i])
            if s > class_best[name]:
                class_best[name] = s
        sorted_classes = sorted(class_best.items(), key=lambda x: x[1], reverse=True)

        top5 = sorted_classes[:5]
        save_log_row(filename, best_name if best_score >= COSINE_THRESHOLD else "Unknown", best_score, top5)

        if best_score < COSINE_THRESHOLD:
            return JSONResponse({
                "name": "Unknown",
                "best_score": round(best_score, 4),
                "top_classes": [(k, round(v, 4)) for k, v in top5]
            })
        return JSONResponse({
            "name": best_name,
            "best_score": round(best_score, 4),
            "top_classes": [(k, round(v, 4)) for k, v in top5]
        })
    except Exception as e:
        logger.exception("predict: unexpected error")
        return JSONResponse({"error": str(e)}, status_code=500)


# ---------------- Debug endpoint ----------------
@app.post("/debug_predict")
async def debug_predict(file: UploadFile = File(...)):
    img_bytes = await file.read()
    filename = getattr(file, "filename", "")
    try:
        arr = preprocess_eye(img_bytes)
    except Exception as e:
        logger.exception("debug_predict: preprocess failed")
        return {"error": f"preprocess_eye failed: {e}"}
    try:
        emb_res = compute_resnet_emb(arr)
    except Exception as e:
        logger.exception("debug_predict: compute_resnet_emb failed")
        return {"error": f"compute_resnet_emb failed: {e}"}

    fused_example = concat_fuse(emb_res, None)
    fused_shape = None if fused_example is None else int(fused_example.shape[0])

    return {
        "filename": filename,
        "arcface_detected": False,
        "resnet_emb_shape": None if emb_res is None else int(emb_res.shape[0]),
        "resnet_emb_sample": None if emb_res is None else emb_res.flatten()[:8].tolist(),
        "fused_example_dim": fused_shape
    }


# ---------------- Evaluate endpoint ----------------
@app.post("/evaluate")
def evaluate(threshold: float = Query(COSINE_THRESHOLD), sample_limit: int = Query(None)):
    try:
        if not os.path.exists(EMB_DB_PATH) or not os.path.exists(EMB_NAMES_PATH):
            raise HTTPException(status_code=400, detail="Database missing. Run /register_db first.")

        db_emb = np.load(EMB_DB_PATH)
        db_names = np.load(EMB_NAMES_PATH, allow_pickle=True)

        N = db_emb.shape[0]
        if sample_limit is not None:
            N = min(N, int(sample_limit))
            db_emb = db_emb[:N]
            db_names = db_names[:N]

        if N > PAIRWISE_EVAL_LIMIT:
            return JSONResponse({"error": f"Too many images ({N}) for pairwise evaluation. Limit is {PAIRWISE_EVAL_LIMIT}."}, status_code=400)

        correct = 0
        for i in range(N):
            sims = (db_emb @ db_emb[i]) / (np.linalg.norm(db_emb, axis=1) * (np.linalg.norm(db_emb[i]) + 1e-10))
            sims[i] = -1.0
            best_idx = int(np.argmax(sims))
            pred = str(db_names[best_idx])
            true = str(db_names[i])
            if pred == true:
                correct += 1
        id_acc = correct / N

        y = []
        scores = []
        for (i, j) in combinations(range(N), 2):
            same = 1 if str(db_names[i]) == str(db_names[j]) else 0
            s = float(np.dot(db_emb[i], db_emb[j]) / (norm(db_emb[i]) * norm(db_emb[j]) + 1e-10))
            y.append(same)
            scores.append(s)
        y = np.array(y)
        scores = np.array(scores)

        fpr, tpr, thr = roc_curve(y, scores)
        roc_auc = auc(fpr, tpr)

        fnr = 1 - tpr
        abs_diffs = np.abs(fpr - fnr)
        idx_eer = np.argmin(abs_diffs)
        eer = (fpr[idx_eer] + fnr[idx_eer]) / 2.0
        eer_thresh = thr[idx_eer]

        neg_mask = (y == 0)
        pos_mask = (y == 1)
        far = float(np.sum((scores[neg_mask] >= threshold)) / (np.sum(neg_mask) + 1e-10)) if np.sum(neg_mask) > 0 else 0.0
        frr = float(np.sum((scores[pos_mask] < threshold)) / (np.sum(pos_mask) + 1e-10)) if np.sum(pos_mask) > 0 else 0.0

        return {
            "n_images": int(N),
            "identification_accuracy": round(float(id_acc), 4),
            "roc_auc": round(float(roc_auc), 4),
            "eer": round(float(eer), 4),
            "eer_threshold": float(eer_thresh),
            "far_at_threshold": round(float(far), 4),
            "frr_at_threshold": round(float(frr), 4),
            "threshold_used": float(threshold)
        }
    except Exception as e:
        logger.exception("evaluate: unexpected error")
        return JSONResponse({"error": str(e)}, status_code=500)


# ---------------- Root ----------------
@app.get("/")
def root():
    return {"message": "Eyes-Only Recognition API (ResNet embeddings only) running"}

# ---------------- Main ----------------
if __name__ == "__main__":
    uvicorn.run("app_eye_1:app", host="0.0.0.0", port=8000, reload=False)
