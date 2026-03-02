from fastapi import APIRouter, UploadFile, File, HTTPException
import numpy as np
from sklearn.metrics import roc_curve, auc
from itertools import combinations
from numpy.linalg import norm

from app.services.database_service import load_db, build_database
from app.services.embedding_service import compute_embedding
from app.utils.image_utils import preprocess_eye
from app.core.config import COSINE_THRESHOLD

router = APIRouter()

# ---------------- Register ----------------
@router.post("/register_db")
def register_db():
    n = build_database()
    return {"status": "ok", "n_images": n}

# ---------------- Predict ----------------
@router.post("/predict")
async def predict(file: UploadFile = File(...)):
    db_emb, db_names = load_db()

    if db_emb is None:
        raise HTTPException(400, "Database not built. Run /register_db first.")

    arr = preprocess_eye(await file.read())
    emb = compute_embedding(arr)

    sims = db_emb @ emb
    best_idx = int(np.argmax(sims))
    best_score = float(sims[best_idx])

    if best_score < COSINE_THRESHOLD:
        return {"name": "Unknown", "score": best_score}

    return {"name": str(db_names[best_idx]), "score": best_score}

# ---------------- Debug ----------------
@router.post("/debug_predict")
async def debug_predict(file: UploadFile = File(...)):
    arr = preprocess_eye(await file.read())
    emb = compute_embedding(arr)

    return {
        "embedding_dim": int(emb.shape[0]),
        "sample_values": emb[:8].tolist()
    }

# ---------------- Evaluate ----------------
@router.post("/evaluate")
def evaluate():
    db_emb, db_names = load_db()

    if db_emb is None:
        raise HTTPException(400, "Database not built.")

    correct = 0
    N = db_emb.shape[0]

    for i in range(N):
        sims = db_emb @ db_emb[i]
        sims[i] = -1
        best_idx = int(np.argmax(sims))

        if db_names[best_idx] == db_names[i]:
            correct += 1

    accuracy = correct / N

    return {
        "n_images": N,
        "identification_accuracy": round(float(accuracy), 4)
    }