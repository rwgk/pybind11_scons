# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_clang-dev .

# docker run --rm -v $HOME:/mounted_home -it pybind11_clang-dev
# cat how_to.txt

FROM silkeh/clang:dev
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y python3-dev python3-pip python3-numpy python3-pytest libeigen3-dev make git vim
RUN python3 -m pip install --upgrade pip
COPY requirements.txt .
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
RUN python3 -m pip install scons
COPY how_to.txt .
