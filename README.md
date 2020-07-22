# pybind11_scons
Enables concurrent testing of pybind11 with multiple build environments.

Status: a minimal working start, no bells or whistles.

Example usage:

```
mkdir workspace
git clone https://github.com/rwgk/pybind11_scons.git
git clone https://github.com/catchorg/Catch2.git
git clone https://github.com/pybind/pybind11.git
mkdir build_py3_clang
cd build_py3_clang
cp ../pybind11_scons/SConstruct .
# Edit SConstruct to define python executable and compiler.
scons -j 8
/usr/bin/python3 ../pybind11_scons/run_tests.py ../pybind11
```

Note: this creates NO artifacts in `../pybind11`.
