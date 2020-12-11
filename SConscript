Import("pybind11_build_config")

import os
import subprocess

blob = subprocess.check_output([
    pybind11_build_config["python_executable"],
    "-c",
    "from __future__ import print_function;"
    " import sysconfig;"
    " print(sysconfig.get_paths())"
], universal_newlines=True)
python_paths = eval(blob)
python_include = python_paths["include"]
if (not os.path.isdir(python_include) and
    python_include.startswith("/usr/local/include/")):
  # sysconfig can be unreliable.
  python_include = python_include.replace(
      "/usr/local/include/",
      "/usr/include/")
python_lib = os.path.basename(python_include)

cxx = "clang++"
std_opt = ["-std=%s" % pybind11_build_config["cxx_std"]]
vis_opt = ["-fvisibility=hidden"]
opt_opt = ["-O0", "-g", "-flto", "-fno-fat-lto-objects"][:2]
wrn_opt = ["-Wall", "-Wextra", "-Wconversion", "-Wcast-qual", "-Wdeprecated", "-Wnon-virtual-dtor"]
if "python2" in python_lib:
  if pybind11_build_config["cxx_std"] >= "c++17":
    wrn_opt.append("-Wno-register")
  else:
    wrn_opt.append("-Wno-deprecated-register")

ndebug = ["NDEBUG"][:0]

env_base = Environment(
    ENV=os.environ,
    tools=["cxx","link"])
env_base.Replace(
    CXX=cxx,
    LINK=cxx,
    SHCXX=cxx,
    SHLINK=cxx,
    SHLIBSUFFIX=".so")

def build_paths_in_subdir(subdir, filenames):
  paths = []
  for filename in filenames:
    sf = os.path.normpath(os.path.join(subdir, filename))
    if "*" in filename or "?" in filename:
      paths.extend(Glob(sf))
    else:
      paths.append(sf)
  return paths

def pybind11_tests_shared_library(target, sources):
  env_base.Clone(
      CPPDEFINES = ndebug + [
          "PYBIND11_TEST_BOOST"],
      CPPPATH=["#pybind11/include",
               python_include,
               "/usr/include/eigen3"],
      CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt,
      LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
      LIBPREFIX="").SharedLibrary(
          target=target,
          source=build_paths_in_subdir("#pybind11/tests", sources))

pybind11_tests_shared_library(
    target="#lib/pybind11_tests",
    sources=["pybind11_tests.cpp", "test_*.cpp"])

pybind11_tests_shared_library(
    target="#lib/cross_module_gil_utils",
    sources=["cross_module_gil_utils.cpp"])

pybind11_tests_shared_library(
    target="#lib/pybind11_cross_module_tests",
    sources=["pybind11_cross_module_tests.cpp"])

env_base.Clone(
    CPPDEFINES = ndebug,
    CPPPATH=["#pybind11/include",
             python_include],
    CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt,
    LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
    LIBPREFIX="").SharedLibrary(
        target="#lib/external_module",
        source=["#pybind11/tests/test_embed/external_module.cpp"])

env_base.Clone(
    CPPDEFINES = ndebug,
    CPPPATH=["#pybind11/include",
             python_include,
             "#Catch2/single_include/catch2"],
    CXXFLAGS=std_opt + opt_opt + wrn_opt,
    LINKFLAGS=["-rdynamic"] + opt_opt,
    LIBS=["pthread", python_lib]).Program(
        target="#bin/test_embed",
        source=build_paths_in_subdir(
            "#pybind11/tests/test_embed",
            ["test_interpreter.cpp",
             "catch.cpp"]))
