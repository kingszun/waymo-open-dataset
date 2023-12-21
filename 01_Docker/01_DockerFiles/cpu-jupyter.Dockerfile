# FROM tensorflow/tensorflow:latest-py3
# FROM tensorflow/tensorflow:latest-gpu-jupyter
# FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04
# FROM nvidia/cudagl:11.1.1-devel-ubuntu18.04
FROM nvidia/cudagl:11.1.1-base-ubuntu18.04

SHELL ["/bin/bash", "-c"]

# Set time zone
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Set keyboard country
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt update && apt install -y \
  git build-essential wget vim findutils curl \
  pkg-config zip g++ zlib1g-dev unzip





RUN git config --global http.postBuffer 524288000
RUN git config --global http.maxRequestBuffer 524288000
RUN git config --global core.compression 0

# Download and compile Python3.10.13
# enable speed optimization of Python binaries
# enable shared libraries
ARG PYTHON3_VERSION_MAIN=3.10 \
PYTHON3_VERSION_PATCH=13

RUN apt install -y openssl apt-transport-https \
build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget \
make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev tk-dev

RUN wget https://www.python.org/ftp/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz \
-O /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz \
&& tar -xzf /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz -C /tmp/
WORKDIR /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}

# enable shared libraries: --enable-shared
# enable speed optimization of Python binaries: --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi
RUN ./configure --prefix=/opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/ --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi --enable-shared LDFLAGS="-WL, -rpath /usr/local/lib" \
&& make -j $($(nproc)-1) \
&& make altinstall \
&& rm /tmp/Python-${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}.tgz

ENV LD_LIBRARY_PATH=/opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/lib \
PATH=${PATH}:/opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin

# update Pip, Setuptools and Wheel packages
RUN /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN} -m pip install --upgrade pip setuptools wheel

# add some soft links for comfortable usage
RUN ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python3 \
&& ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip3 \
# && ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pip \
RUN ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pydoc${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/pydoc \ 
&& ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/idle${PYTHON3_VERSION_MAIN} /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/idle \
&& ln -s /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN}-config /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python-config \
&& ln -Tfs /opt/python/${PYTHON3_VERSION_MAIN}.${PYTHON3_VERSION_PATCH}/bin/python${PYTHON3_VERSION_MAIN} /usr/bin/python3

RUN python3 --version

RUN python3 -m pip install --upgrade pip setuptools wheel

WORKDIR /tmp
RUN wget -q https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run -O /tmp/cuda_11.1.1_455.32.00_linux.run \
&& chmod +x /tmp/cuda_11.1.1_455.32.00_linux.run \
&& sh /tmp/cuda_11.1.1_455.32.00_linux.run --silent --toolkit
# WORKDIR /tmp/ad-adrt-ffsir-setup-lib-cudnn
RUN cp -r cudnn-linux-x86_64-8.9.5.30_cuda11-archive/include /usr/local/cuda-11.1/targets/x86_64-linux/ \
&& cp -r cudnn-linux-x86_64-8.9.5.30_cuda11-archive/lib/* /usr/local/cuda-11.1/targets/x86_64-linux/lib \
&& chmod a+r /usr/local/cuda-11.1/targets/x86_64-linux/include/cudnn* /usr/local/cuda-11.1/targets/x86_64-linux/lib/libcudnn*
RUN mkdir -p /TensorRT && tar -xvf ./TensorRT-7.2.3.4.Ubuntu-18.04.x86_64-gnu.cuda-11.1.cudnn8.1.tar.gz -C /TensorRT
# RUN rm -r /tmp/*

ENV CUDA_HOME=/usr/local/cuda \
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/TensorRT/TensorRT-7.2.3.4/targets/x86_64-linux-gnu/lib \
PATH=${PATH}:/usr/local/cuda/bin:/TensorRT/TensorRT-7.2.3.4/targets/x86_64-linux-gnu/bin://TensorRT/TensorRT-7.2.3.4/targets/x86_64-linux-gnu/include



RUN apt install -y golang python3 clang libopenexr-dev
# RUN go install github.com/bazelbuild/bazelisk@latest
COPY ./01_Docker/02_Requirements/bazelisk-linux-amd64 /usr/bin/bazelisk

# RUN python3 -m pip install --upgrade pip
# RUN python3 -m pip install jupyter_http_over_ws 
# # RUN python3 -m pip install jupyter 
# # # RUN python3 -m pip install jupyter-core==4.4.0
# RUN python3 -m pip install matplotlib 
# RUN apt install -y jupyter
# RUN jupyter serverextension enable --py jupyter_http_over_ws

COPY ./ /waymo-od
WORKDIR /waymo-od/src/

EXPOSE 8888

# RUN ./waymo_open_dataset/pip_pkg_scripts/build.sh

# RUN python3 -m ipykernel.kernelspec

# CMD ["bash", "-c", "source /etc/bash.bashrc && bazel run -c opt //waymo_open_dataset/tutorial:jupyter_kernel"]