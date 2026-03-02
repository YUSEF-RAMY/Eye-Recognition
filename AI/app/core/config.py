import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


MODEL_PATH = r"C:\Users\yusuf\jupyter\E_R\eye_recognition_model.h5"

DATASET_DIR = r"C:\Users\yusuf\jupyter\E_R\DataSet_Y_Y_A_H"

STORAGE_DIR = os.path.join(BASE_DIR, "storage")
LOG_DIR = os.path.join(BASE_DIR, "logs")

EMB_DB_PATH = os.path.join(STORAGE_DIR, "embeddings_db.npy")
EMB_NAMES_PATH = os.path.join(STORAGE_DIR, "embeddings_names.npy")

IMG_SIZE = (224, 224)
COSINE_THRESHOLD = 0.7

os.makedirs(STORAGE_DIR, exist_ok=True)
os.makedirs(LOG_DIR, exist_ok=True)