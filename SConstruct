PYROOT=open("PYROOT").read().rstrip()
Repository("/usr/local/google/home/rwgk/forked")
Repository("/usr/local/google/home/rwgk/clone")
pybind11_build_config = {
    "python_executable": f"{PYROOT}/bin/python3",
    "compiler": "linux_clang",
    "cxx_std": "c++17",
}
Export("pybind11_build_config")
SConscript("pybind11_scons/SConscript")
