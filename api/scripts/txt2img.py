import os
import sys

import torch
from PIL import Image
from utils.load_sdxl_base_model import load_sdxl_base_model
from utils.load_sdxl_refiner_model import load_sdxl_refiner_model

MODEL_TYPE = "server"
MODEL_LOAD_TYPE = "pretrained"
MODEL = "base"
OUTPUT_PATH = "output"


def txt2img(prompt):
    # Load stable diffusion xl model
    if MODEL == "base":
        model = load_sdxl_base_model(MODEL_TYPE, MODEL_LOAD_TYPE)
    elif MODEL == "refiner":
        model = load_sdxl_refiner_model(MODEL_TYPE, MODEL_LOAD_TYPE)

    # txt2img
    image = model(prompt).images[0]

    return image
    # # Save the result
    # image.save(f"{OUTPUT_PATH}/{args.prompt}.png")
