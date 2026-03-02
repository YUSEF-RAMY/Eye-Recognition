import io
import cv2
import numpy as np
from PIL import Image
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.resnet50 import preprocess_input
from app.core.config import IMG_SIZE

def preprocess_eye(img_bytes):
    pil = Image.open(io.BytesIO(img_bytes)).convert("RGB")
    img = np.array(pil)
    img = cv2.resize(img, IMG_SIZE)
    arr = np.expand_dims(image.img_to_array(img), axis=0)
    return preprocess_input(arr)