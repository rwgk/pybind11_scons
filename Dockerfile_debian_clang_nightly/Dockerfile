# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t debian_clang_nightly .
# rm requirements.txt

# docker run --rm -v $HOME:/mounted_home -it debian_clang_nightly
# cat how_to.txt

FROM debian
RUN apt update && apt install -y apt-utils
RUN apt install -y lsb-release wget software-properties-common gnupg
RUN apt install -y python3-dev python3-pip python3-numpy python3-pytest libeigen3-dev make git vim
RUN python3 -m pip install --upgrade pip
COPY requirements.txt .
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
RUN python3 -m pip install scons
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod 755 llvm.sh
RUN ./llvm.sh 15
RUN ./llvm.sh 16
COPY how_to.txt .
