# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_valgrind .

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_valgrind
# cat how_to.txt

FROM ubuntu:focal
RUN apt update -y && apt install -y make gcc g++ git curl wget vim libc6-dbg

RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN apt install -y software-properties-common
RUN apt update -y && add-apt-repository --yes ppa:deadsnakes/ppa

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
RUN apt install kitware-archive-keyring
RUN apt update -y && apt install -y cmake

RUN apt install -y --no-install-recommends python3.9-dev python3.9-venv python3.9-distutils python3.9-dbg && python3.9-dbg -mvenv /venv-3.9 && /venv-3.9/bin/pip install --upgrade pip setuptools wheel

RUN export VALGRIND_VERSION=3.16.1 && curl https://sourceware.org/pub/valgrind/valgrind-$VALGRIND_VERSION.tar.bz2 -o - | tar xj && mv valgrind-$VALGRIND_VERSION valgrind && cd valgrind && ./configure && make -j 24 install

COPY requirements.txt .
RUN /venv-3.9/bin/python -m pip install cmake -r requirements.txt --prefer-binary

COPY how_to.txt .
