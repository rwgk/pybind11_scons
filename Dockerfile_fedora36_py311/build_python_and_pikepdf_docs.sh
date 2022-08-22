set -x
tar zxvf /ghome/cpython-3.11-4f7f83b5bdd61f01a5ad49fb4df61cab3607ab99.tar.gz
cd cpython-3.11-4f7f83b5bdd61f01a5ad49fb4df61cab3607ab99/
./configure --prefix=/Python-3.11-4f7f83b5bdd61f01a5ad49fb4df61cab3607ab99
make install -j 16
cd ..
/Python-3.11-4f7f83b5bdd61f01a5ad49fb4df61cab3607ab99/bin/python3.11 -m venv env
source /env/bin/activate
python -m pip install --upgrade pip
python -m pip install pytest
python -m pip install IPython
python -m pip install sphinx sphinx_issues sphinx_design sphinx_rtd_theme
git clone https://github.com/pikepdf/pikepdf
cd pikepdf/
python -m pip install .
cd docs/
/env/bin/sphinx-build . ../html
