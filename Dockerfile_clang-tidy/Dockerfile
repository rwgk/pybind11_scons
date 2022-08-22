# docker build -t pybind11_clang-tidy_13 .
# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it pybind11_clang-tidy_13

FROM silkeh/clang:13
RUN apt-get update && apt-get install -y python3-dev python3-pytest vim
COPY how_to.txt .
