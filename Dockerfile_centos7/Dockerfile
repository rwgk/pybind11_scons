# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_centos7 .

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_centos7
# cat how_to.txt

FROM centos:7
RUN yum update -y && yum install -y python3-devel gcc-c++ make git vim
RUN python3 -m pip install --upgrade pip
COPY requirements.txt .
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
COPY how_to.txt .
