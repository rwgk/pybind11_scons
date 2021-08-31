# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t ubuntu18_py2

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it ubuntu18_py2
# cmake -S /mounted_pybind11/ -B build -DDOWNLOAD_EIGEN=ON -DDOWNLOAD_CATCH=ON -DCMAKE_CXX_STANDARD=17
# cmake --build build --verbose -j 16 -- --keep-going
# cmake --build build --target pytest

FROM ubuntu:18.04
RUN apt update -y && apt install -y python-dev python-pip make gcc git vim
RUN python -m pip install --upgrade pip
COPY requirements.txt .
RUN python -m pip install cmake -r requirements.txt --prefer-binary
