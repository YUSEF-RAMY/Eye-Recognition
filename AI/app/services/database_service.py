import os
import numpy as np
from app.core.config import EMB_DB_PATH, EMB_NAMES_PATH, DATASET_DIR
from app.services.embedding_service import compute_embedding
from app.utils.image_utils import preprocess_eye

def save_db(embeddings, names):
    np.save(EMB_DB_PATH, embeddings)
    np.save(EMB_NAMES_PATH, names)

def load_db():
    if not os.path.exists(EMB_DB_PATH):
        return None, None
    return (
        np.load(EMB_DB_PATH),
        np.load(EMB_NAMES_PATH, allow_pickle=True)
    )

def build_database():
    embeddings = []
    names = []

    if not os.path.exists(DATASET_DIR):
        raise Exception("Dataset folder not found")

    for person in os.listdir(DATASET_DIR):
        person_path = os.path.join(DATASET_DIR, person)
        if not os.path.isdir(person_path):
            continue

        for img_name in os.listdir(person_path):
            if not img_name.lower().endswith(("jpg", "jpeg", "png")):
                continue

            img_path = os.path.join(person_path, img_name)
            with open(img_path, "rb") as f:
                arr = preprocess_eye(f.read())

            emb = compute_embedding(arr)
            embeddings.append(emb)
            names.append(person)

    embeddings = np.stack(embeddings)
    save_db(embeddings, np.array(names, dtype=object))

    return embeddings.shape[0]