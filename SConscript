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

def arguments_get_split(key, sep=","):
  s = ARGUMENTS.get(key)
  if s is None:
    return []
  return  s.split(sep)

cxx = "clang++"
std_opt = ["-std=%s" % pybind11_build_config["cxx_std"]]
vis_opt = ["-fvisibility=hidden"]
opt_opt = ["-O0", "-g"]
wrn_opt = ["-Wall", "-Wextra", "-Wconversion", "-Wcast-qual", "-Wdeprecated", "-Wnon-virtual-dtor"]
if "python2" in python_lib:
  if pybind11_build_config["cxx_std"] >= "c++17":
    wrn_opt.append("-Wno-register")
  else:
    wrn_opt.append("-Wno-deprecated-register")

extra_defines = arguments_get_split("extra_defines")
extra_defines.append("PYBIND11_STRICT_ASSERTS_CLASS_HOLDER_VS_TYPE_CASTER_MIX")

def process_meta_opts():
  meta_opts = arguments_get_split("meta_opts")

  def have_meta_opt(*names):
    result = False
    for name in names:
      if name in meta_opts:
        meta_opts.remove(name)
        result = True
    return result

  if have_meta_opt("lto"):
    opt_opt.extend(["-flto", "-fno-fat-lto-objects"])
  if have_meta_opt("limitless_diagnostics", "bio"):  # bring it on
    wrn_opt.extend(["-ferror-limit=0", "-ftemplate-backtrace-limit=0"])

  assert not meta_opts, meta_opts

process_meta_opts()

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
      CPPDEFINES = extra_defines + [
          "PYBIND11_TEST_BOOST"],
      CPPPATH=["#pybind11/include",
               python_include,
               "/usr/include/eigen3"],
      CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt,
      LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
      LIBPREFIX="").SharedLibrary(
          target=target,
          source=build_paths_in_subdir("#pybind11/tests", sources))

test_cpp = ARGUMENTS.get("selected_test_cpp", "test_*.cpp")
pybind11_tests_shared_library(
    target="#lib/pybind11_tests",
    sources=["pybind11_tests.cpp", test_cpp])

for main_module in [
    "cross_module_gil_utils",
    "pybind11_cross_module_tests",
    "class_sh_module_local_0",
    "class_sh_module_local_1",
    "class_sh_module_local_2",
]:
  if Glob("#pybind11/tests/%s.cpp" % main_module):
    pybind11_tests_shared_library(
        target="#lib/%s" % main_module,
        sources=["%s.cpp" % main_module])

env_base.Clone(
    CPPDEFINES = extra_defines,
    CPPPATH=["#pybind11/include",
             python_include],
    CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt,
    LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
    LIBPREFIX="").SharedLibrary(
        target="#lib/external_module",
        source=["#pybind11/tests/test_embed/external_module.cpp"])

env_base.Clone(
    CPPDEFINES = extra_defines,
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
