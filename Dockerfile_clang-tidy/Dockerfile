# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_clang-tidy_15 .
# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_clang-tidy_15

FROM silkeh/clang:15-bullseye
RUN apt-get update && apt-get install -y python3-dev python3-pip python3-pytest libeigen3-dev make git vim
COPY requirements.txt .
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install cmake -r requirements.txt --prefer-binary
COPY how_to.txt .
