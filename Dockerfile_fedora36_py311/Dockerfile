# docker build -t fedora36_py311 .
# https://github.com/python/cpython/issues/96046

FROM fedora:36
RUN dnf -y install gcc
RUN dnf -y install g++
RUN dnf -y install gdb
RUN dnf -y install git
RUN dnf -y install qpdf-devel
RUN dnf -y install python3.11
RUN dnf -y install python3.11-devel

# docker run --rm -v $HOME/forked/pybind11:/mounted_pybind11 -it fedora36_py311

# python3.11 -m venv env
# source /env/bin/activate
# python -m pip install --upgrade pip
# python -m pip install pytest
# python -m pip install IPython
# python -m pip install sphinx sphinx_issues sphinx_design sphinx_rtd_theme
# git clone https://github.com/pikepdf/pikepdf
# cd pikepdf/
# python -m pip install .
# cd docs
# /env/bin/sphinx-build . ../html
# gdb /usr/bin/python3.11 core
