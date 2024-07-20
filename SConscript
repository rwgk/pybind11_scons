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

build_config_compiler = pybind11_build_config["compiler"]
if build_config_compiler == "linux_clang":
  cxx = "clang++"
elif build_config_compiler == "linux_gcc":
  cxx = "g++"
std_opt = ["-std=%s" % pybind11_build_config["cxx_std"]]
vis_opt = ["-fvisibility=hidden"]
opt_opt = ["-O0", "-g"]
wrn_opt = ["-Wall", "-Wextra", "-Wconversion", "-Wcast-qual", "-Wdeprecated",
           "-Wundef", "-Wnon-virtual-dtor", "-Wunused-result", "-Werror"]

extra_defines = arguments_get_split("extra_defines")
extra_defines.append("PYBIND11_INTERNALS_VERSION=" +
                     pybind11_build_config.get(
                         "PYBIND11_INTERNALS_VERSION", "10000000"))
extra_defines.append("PYBIND11_STRICT_ASSERTS_CLASS_HOLDER_VS_TYPE_CASTER_MIX")
extra_defines.append("PYBIND11_ENABLE_TYPE_CASTER_ODR_GUARD_IF_AVAILABLE")

def process_meta_opts():
  meta_opts = arguments_get_split("meta_opts")

  def have_meta_opt(*names):
    result = False
    for name in names:
      if name in meta_opts:
        meta_opts.remove(name)
        result = True
    return result

  global opt_opt
  lto = False
  if have_meta_opt("ltos"):
    opt_opt = ["-Os"]
    lto = True
  elif have_meta_opt("lto3"):
    opt_opt = ["-O3"]
    lto = True
  if lto:
    opt_opt.append("-flto")
    if build_config_compiler == "linux_gcc":
      opt_opt.append("-fno-fat-lto-objects")
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

def use_isystem(include_dirs):
  """This is to suppress warnings for external (non-pybind11) code."""
  # https://stackoverflow.com/questions/2579576/i-dir-vs-isystem-dir
  # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
  opts = []
  for d in include_dirs:
    opts.extend(["-isystem", d])
  return opts

def pybind11_tests_shared_library(target, sources, special_defines=[]):
  env_base.Clone(
      CPPDEFINES=extra_defines + ["PYBIND11_TEST_BOOST"] + special_defines,
      CPPPATH=["#pybind11/include"],
      CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt +
               use_isystem([python_include, "/usr/include/eigen3"]),
      LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
      LIBPREFIX="").SharedLibrary(
          target=target,
          source=build_paths_in_subdir("#pybind11/tests", sources))

test_cpp = ARGUMENTS.get("selected_test_cpp", "test_*.cpp").split(",")
pybind11_tests_shared_library(
    target="#lib/pybind11_tests",
    sources=["pybind11_tests.cpp"] + test_cpp)

for main_module in [
    "cross_module_gil_utils",
    "cross_module_interleaved_error_already_set",
    "eigen_tensor_avoid_stl_array",
    "pybind11_cross_module_tests",
    "class_sh_module_local_0",
    "class_sh_module_local_1",
    "class_sh_module_local_2",
    "namespace_visibility_2",
]:
  if Glob("#pybind11/tests/%s.cpp" % main_module):
    pybind11_tests_shared_library(
        target="#lib/%s" % main_module,
        sources=["%s.cpp" % main_module])

if Glob("#pybind11/tests/namespace_visibility_1.cpp"):
  pybind11_tests_shared_library(
      target="#lib/namespace_visibility_1",
      sources=["namespace_visibility_1.cpp", "namespace_visibility_1s.cpp"])

env_base.Clone(
    CPPDEFINES=extra_defines,
    CPPPATH=["#pybind11/include",
             python_include],
    CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt,
    LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
    LIBPREFIX="").SharedLibrary(
        target="#lib/external_module",
        source=["#pybind11/tests/test_embed/external_module.cpp"])

env_base.Clone(
    CPPDEFINES=extra_defines,
    CPPPATH=["#pybind11/include",
             python_include,
             "#Catch2/single_include/catch2"],
    CXXFLAGS=std_opt + opt_opt + wrn_opt,
    LINKFLAGS=["-Llib", "-rdynamic"] + opt_opt,
    LIBS=[python_lib, "pthread", "dl", "util"]).Program(
        target="#bin/test_embed",
        source=build_paths_in_subdir(
            "#pybind11/tests/test_embed",
            ["test_interpreter.cpp",
             "catch.cpp"]))

if Glob("#pybind11/ubench/holder_comparison.cpp"):
  env_base.Clone(
      CPPDEFINES=extra_defines,
      CPPPATH=["#pybind11/include",
               python_include],
      CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt,
      LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
      LIBPREFIX="").SharedLibrary(
          target="#lib/pybind11_ubench_holder_comparison",
          source=["#pybind11/ubench/holder_comparison.cpp"])
