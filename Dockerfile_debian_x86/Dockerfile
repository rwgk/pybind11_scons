# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_debian_x86 .

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_debian_x86
# cat how_to.txt

FROM i386/debian:buster
RUN apt update
RUN apt install -y git make cmake g++ libeigen3-dev python3-dev python3-pip vim
RUN pip3 install "pytest==6.*"
COPY requirements.txt .
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
COPY how_to.txt .
