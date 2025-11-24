import os
TestVenv = os.path.join(os.getcwd(), "TestVenv")
assert os.path.isdir(TestVenv)
Repository(f"{os.environ['W']}/forked")
Repository(f"{os.environ['W']}/clone")
pybind11_build_config = {
    "python_executable": f"{TestVenv}/bin/python3",
    "compiler": "linux_gcc",
    "cxx_std": "c++20",
}
Export("pybind11_build_config")
SConscript("pybind11_scons/SConscript")
