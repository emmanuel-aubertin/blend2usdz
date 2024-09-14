from fastapi import FastAPI, File, UploadFile, HTTPException
import multipart
import bpy
import random
import string

app = FastAPI()
VERSION = "1.0.0"

def generate_random_string(length=8):
    """Generates a random string of the specified length."""
    return ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(length))

@app.get("/version")
def read_version():
    return {"version": VERSION}

@app.post("/convert")
async def convert_file(file: UploadFile = File(...)):
    if file.filename.endswith(".blend"):
        contents = await file.read()
        bpy.ops.import_scene.blend(contents)
        bpy.ops.object.select_all(action='SELECT')
        ran_filename = f"file_{generate_random_string()}.usdz"
        bpy.ops.export.usd(filepath=f"tmp-usdz/{ran_filename}", selected=True)
        return {"filename": ran_filename, "file": open(f"tmp-usdz/{ran_filename}", "rb").read()}
    else:
        raise HTTPException(status_code=400, detail="Invalid file extension. Only .blend files are allowed.")