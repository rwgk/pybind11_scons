# pybind11_scons
Enables concurrent testing of pybind11 with multiple build environments and
easy experimenting.

Status: Linux only. No bells or whistles.

Example usage:

Starting from scratch:

```
sudo apt install scons  # Or similar, depending on platform (if not installed already).

mkdir workspace
git clone https://github.com/rwgk/pybind11_scons.git
git clone https://github.com/catchorg/Catch2.git
git clone https://github.com/pybind/pybind11.git
```

Starting a new build directory:

```
mkdir build_clang
cd build_clang
echo "/usr" > PYROOT
cp ../pybind11_scons/SConstruct .
# Maybe edit SConstruct to change compiler (default is linux_clang).
```

Iterating for development:

```
scons -j 8 && "$(cat PYROOT)"/bin/python3 ../pybind11_scons/run_tests.py ../pybind11
```

Note: this creates NO artifacts in `../pybind11`, although pytest might. Use `git clean -fdx` to clean up.

NOTE: smart_holder_poc_test.cpp needs to be built manually, for example:

```
clang++ -fsanitize=address -std=c++11 -O0 -g -Wall -Wextra -Wconversion -Wcast-qual -Wdeprecated -Wnon-virtual-dtor -I$HOME/forked/pybind11/include -I$HOME/clone/Catch2/single_include/catch2 -I/usr/include/python3.12 $HOME/forked/pybind11/tests/pure_cpp/smart_holder_poc_test.cpp && ./a.out
```
