# docker build -t fedora36_py311 .
# https://github.com/python/cpython/issues/96046

FROM fedora:36
RUN dnf -y install gcc
RUN dnf -y install g++
RUN dnf -y install gdb
RUN dnf -y install libffi-devel
RUN dnf -y install openssl-devel
RUN dnf -y install sqlite-devel
RUN dnf -y install git
RUN dnf -y install vim
RUN dnf -y install qpdf-devel
# RUN dnf -y install python3.11-devel

# docker run --rm -v $HOME:/ghome -it fedora36_py311
