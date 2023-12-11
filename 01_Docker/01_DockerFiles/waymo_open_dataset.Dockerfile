FROM tensorflow/tensorflow:latest-py3

RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Set keyboard country
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt update && apt install -y \
  git build-essential wget vim findutils curl \
  pkg-config zip g++ zlib1g-dev unzip \
  python3 python3-pip jupyter
  

# RUN apt-get install -y wget golang openjdk-11-jdk
# RUN apt install -y npm
# COPY ./01_Docker/02_Requirements/bazelisk-linux-amd64 /usr/local/bin/bazelisk
# RUN chmod +x /usr/local/bin/bazelisk
# RUN /usr/local/bin/bazelisk
# RUN npm install -g @bazel/bazelisk

RUN python3 -m pip install --upgrade pip

RUN python3 -m pip install numpy scipy matplotlib opencv-python pyarrow jupyter
# RUN python3 -m pip install jupyter matplotlib jupyter_http_over_ws numpy scipy 
# RUN python3 -m pip install opencv-python pyarrow
# RUN jupyter serverextension enable --py jupyter_http_over_ws 

# RUN git clone https://github.com/waymo-research/waymo-open-dataset.git waymo-od
# WORKDIR /waymo-od/src/waymo_open_dataset

# RUN pip_pkg_scripts/build.sh

EXPOSE 8888
# RUN python3 -m ipykernel.kernelspec

# CMD ["bash", "-c", "source /etc/bash.bashrc && bazel run -c opt //waymo_open_dataset/tutorial:jupyter_kernel"]
CMD jupyter notebook --ip=0.0.0.0 --allow-root
