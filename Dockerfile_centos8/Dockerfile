# cp .../pybind11/tests/requirements.txt .
# docker build -t pybind11_centos8 .

# cmake -S /mounted_pybind11/ -B build -DDOWNLOAD_EIGEN=ON -DDOWNLOAD_CATCH=ON -DCMAKE_CXX_STANDARD=11
# cmake --build build -j 16 -- --keep-going
# cmake --build build --target pytest

FROM centos:8
RUN yum update -y && yum install -y python3-devel gcc-c++ make git vim
RUN python3 -m pip install --upgrade pip
COPY requirements.txt .
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
