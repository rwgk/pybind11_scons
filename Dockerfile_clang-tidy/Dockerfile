# cp $HOME/forked/pybind11/tests/requirements.txt .
# docker build -t pybind11_clang-tidy_18 .
# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_clang-tidy_18

FROM silkeh/clang:18-bookworm
RUN apt-get update && apt-get install -y python3-dev python3-pip python3-pytest libeigen3-dev make git vim
COPY requirements.txt .
RUN python3 -m pip install --break-system-packages --upgrade pip
RUN python3 -m pip install --break-system-packages cmake -r requirements.txt --prefer-binary
COPY how_to.txt .
