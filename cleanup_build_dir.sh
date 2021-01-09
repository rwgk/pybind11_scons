#! /usr/bin/bash
if [ -f SConstruct -a -d bin -a -d lib -a -d pybind11 ]; then
  set -x
  rm -r bin lib pybind11
  if [ -f a.out ]; then
    rm a.out
  fi
else
  echo "UNCERTAINTY: NO ACTION"
fi
