#! /usr/bin/bash
# OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED
# OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED
# OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED OUTDATED
if [ ! -f pyconfig.h.in -o ! -f .git/config ]; then
  echo 'REQUIREMENT: Please run this command from a top-level cpython git directory.'
  exit 1
fi
set -x
branch="$(git rev-parse --abbrev-ref HEAD)"
revhex="$(git rev-parse --short HEAD)"
nowish="$(date "+%Y-%m-%d+%H%M")"
vname=cpython_"$branch"_"$revhex"_"$nowish"
prefix="$HOME"/usr_local_like/"$vname"
build="$HOME"/forked/build_gcc_"$vname"
if [ -d "$prefix" ]; then
  echo 'FATAL: "'"$prefix"'" exists already.'
  exit 1
fi
git clean -fdx
./configure --prefix="$prefix"
make -j 48 install
mkdir "$build"
cd "$build"
echo "$prefix" > PYROOT
"$(cat PYROOT)"/bin/python3 -m pip install pytest pytest-parallel
mkdir -p lib && cp "$(cat PYROOT)"/lib/libpython3.*.a lib/
sed 's/linux_clang/linux_gcc/' $HOME/clone/pybind11_scons/SConstruct > SConstruct
scons -j 48 && "$(cat PYROOT)"/bin/python3 $HOME/clone/pybind11_scons/run_tests.py ../pybind11
exit $?
