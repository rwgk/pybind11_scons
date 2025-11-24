#! /usr/bin/bash
# OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED
# OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED
# OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED
set -x
cd $HOME/forked/cpython
git clean -fdx
rm -rf $HOME/usr_local_like/cpython_git_bisect
./configure --prefix=$HOME/usr_local_like/cpython_git_bisect
make -j 48 install
$HOME/usr_local_like/cpython_git_bisect/bin/python3 -m pip install setuptools
cd $HOME/clone/pytest
$HOME/usr_local_like/cpython_git_bisect/bin/python3 setup.py install
cd $HOME/forked/build_gcc_cpython_git_bisect
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
mkdir -p lib && cp "$(cat PYROOT)"/lib/libpython3.*.a lib/
./repro.sh
# scons -j 48
exit $?
