from tensorflow.keras.models import load_model, Model
from app.core.config import MODEL_PATH

base_model = load_model(MODEL_PATH, compile=False)

embedding_model = Model(
    inputs=base_model.input,
    outputs=base_model.layers[-2].output
)