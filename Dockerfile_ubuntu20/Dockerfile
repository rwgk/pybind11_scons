# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_ubuntu20 .

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_ubuntu20
# cat how_to.txt

FROM ubuntu:focal
RUN apt update -y && apt install -y python3-dev python3-pip make gcc git vim
RUN python3 -m pip install --upgrade pip
COPY requirements.txt .
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
COPY how_to.txt .
