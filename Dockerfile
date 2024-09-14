FROM ubuntu:latest

RUN apt update && apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    git \
    libjpeg-dev \
    libpng-dev \   
    libtiff-dev \  
    libopenexr-dev \
    cmake

RUN git clone https://projects.blender.org/blender/blender.git

WORKDIR blender

RUN mkdir ../build_linux_bpy

RUN cmake -C ../blender/build_files/cmake/config/bpy_module.cmake ../blender -B ../build_linux_bpy
RUN cmake --build ../build_linux_bpy --target install

RUN python3 ./build_files/utils/make_bpy_wheel.py ../build_linux_bpy/bin/
RUN pip3 install ../build_linux_bpy/bin/bpy*.whl

RUN python3 -m venv /opt/venv

RUN /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install fastapi uvicorn[standard] python-multipart

ENV PATH="/opt/venv/bin:$PATH"

RUN mkdir -p tmp-usdz

COPY ./ ./

CMD ["uvicorn", "main.py:app", "--host", "0.0.0.0", "--port", "8000"]
