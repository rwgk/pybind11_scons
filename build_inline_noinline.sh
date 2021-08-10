#! /usr/bin/bash
set -e
set -x
for build_dir in build_py3_inline build_py3 build_py3_gcc_inline build_py3_gcc; do
  LOG=$PWD/${build_dir}_scons.log
  cd $build_dir
  $HOME/clone/pybind11_scons/cleanup_build_dir.sh
  uname -a > $LOG
  echo >> $LOG
  if [[ $build_dir == *_gcc_* ]]; then
    g++ --version >> $LOG
  else
    clang++ --version >> $LOG
  fi
  echo >> $LOG
  if [[ $build_dir == *_inline ]]; then
    scons -j 16 meta_opts=lto extra_defines=NDEBUG,PYBIND11_NOINLINE_DISABLED >> $LOG 2>&1
  else
    scons -j 16 meta_opts=lto extra_defines=NDEBUG >> $LOG 2>&1
  fi
  cd ..
done
