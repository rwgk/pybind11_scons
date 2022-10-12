#! /usr/bin/bash
set -x

cd $HOME/forked/pybind11
git checkout master_before_cuda_fix2
cd $HOME/forked/build_clang
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_before_cuda_fix2_00.txt
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_before_cuda_fix2_01.txt
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_before_cuda_fix2_02.txt
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_before_cuda_fix2_03.txt

cd $HOME/forked/pybind11
git checkout master_after_cuda_fix2
cd $HOME/forked/build_clang
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_after_cuda_fix2_00.txt
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_after_cuda_fix2_01.txt
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_after_cuda_fix2_02.txt
$HOME/clone/pybind11_scons/cleanup_build_dir.sh
scons meta_opts=ltos >& master_after_cuda_fix2_03.txt
