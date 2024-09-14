FROM ubuntu:latest

# Install necessary packages, including python3-venv for creating virtual environments
RUN apt update && apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    git

RUN git clone https://projects.blender.org/blender/blender.git

RUN cd blender/build_linux_bpy/ && make install 
# Create a directory for the virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and install FastAPI and Uvicorn
RUN /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install fastapi uvicorn[standard] python-multipart

# Ensure the virtual environment is activated by default
ENV PATH="/opt/venv/bin:$PATH"

# Create the directory for temporary USDZ files
RUN mkdir -p tmp-usdz

COPY ./ ./

CMD ["uvicorn", "main.py:app", "--host", "0.0.0.0", "--port", "8000"]
