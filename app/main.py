import os
import sys

# Get the current script's directory
current_script_directory = os.path.dirname(os.path.abspath(__file__))

# Get the project root path
project_root = os.path.abspath(os.path.join(current_script_directory, os.pardir))

sys.path.append(project_root)
sys.path.append(current_script_directory)

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"Nginx": "I'm alive"}

@app.post("/txt2img", status_code=HTTP_201_CREATED)
async def t2i(prompt: str):
    result = txt2img(prompt)
    result.save("output.png")

    # Return the image file as the response content
    with open("output.png", "rb") as f:
        file_content = f.read()

    return Response(content=file_content, media_type="image/png")