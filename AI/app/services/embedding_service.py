import numpy as np
from numpy.linalg import norm
from app.models.model_loader import embedding_model

def normalize(vec):
    return vec / (norm(vec) + 1e-10)

def compute_embedding(arr):
    emb = embedding_model.predict(arr, verbose=0).flatten()
    return normalize(emb)