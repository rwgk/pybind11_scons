# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_cuda117 .

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_cuda117
# cat how_to.txt

FROM nvidia/cuda:11.7.0-devel-ubuntu22.04
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y cmake git python3-dev python3-pip python3-pytest python3-numpy git vim
COPY requirements.txt .
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
COPY how_to.txt .
