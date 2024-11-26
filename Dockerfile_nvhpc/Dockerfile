# docker build -t pybind11_nvhpc .

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_nvhpc
# cat how_to.txt

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get install -y curl gpg vim
# https://developer.nvidia.com/hpc-sdk-downloads
RUN curl https://developer.download.nvidia.com/hpc-sdk/ubuntu/DEB-GPG-KEY-NVIDIA-HPC-SDK | gpg --dearmor -o /usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/nvidia-hpcsdk-archive-keyring.gpg] https://developer.download.nvidia.com/hpc-sdk/ubuntu/amd64 /' | tee /etc/apt/sources.list.d/nvhpc.list
RUN apt-get update -y
RUN apt-get install -y cmake environment-modules git python3-dev python3-pip python3-numpy
RUN apt-get install -y --no-install-recommends nvhpc-23-5
RUN rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade pytest
COPY how_to.txt .
