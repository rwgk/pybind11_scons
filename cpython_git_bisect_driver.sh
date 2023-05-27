#! /usr/bin/bash
set -x
cd $HOME/forked/cpython
git bisect start
git bisect good ceaa4c3476ac49b5b31954fec53796c7a3b40349
git bisect bad ffe47cb623999db05959ec4b5168d1c87a1e40ef
git bisect run $HOME/clone/pybind11_scons/cpython_git_bisect_helper.sh
