FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

# Set time zone
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Set keyboard country
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt update && apt install -y python3-pip jupyter

RUN pip3 install numpy scipy matplotlib opencv-python pyarrow

EXPOSE 8888

# WORKDIR /app

CMD jupyter notebook --ip=0.0.0.0 --allow-root
