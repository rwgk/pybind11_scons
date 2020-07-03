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
python_lib = os.path.basename(python_include)

cxx = "clang++"
std_opt = ["-std=%s" % pybind11_build_config["cxx_std"]]
vis_opt = ["-fvisibility=hidden"]
opt_opt = ["-O0", "-g"]
wrn_opt = ["-Wall", "-Wextra", "-Wconversion", "-Wcast-qual", "-Wdeprecated"]
if 'python2' in python_lib:
  wrn_opt.append("-Wno-deprecated-register")

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
  return [
      os.path.normpath(os.path.join(subdir, filename))
      for filename in filenames]

def pybind11_tests_shared_library(target, addl_cppdefines, sources):
  env_base.Clone(
      CPPDEFINES = [
          "NDEBUG",
          "PYBIND11_TEST_BOOST",
          "PYBIND11_TEST_EIGEN"] + addl_cppdefines,
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
    addl_cppdefines=["pybind11_tests_EXPORTS"],
    sources=[
        "pybind11_tests.cpp",
        "test_async.cpp",
        "test_buffers.cpp",
        "test_builtin_casters.cpp",
        "test_call_policies.cpp",
        "test_callbacks.cpp",
        "test_chrono.cpp",
        "test_class.cpp",
        "test_constants_and_functions.cpp",
        "test_copy_move.cpp",
        "test_docstring_options.cpp",
        "test_eigen.cpp",
        "test_enum.cpp",
        "test_eval.cpp",
        "test_exceptions.cpp",
        "test_factory_constructors.cpp",
        "test_gil_scoped.cpp",
        "test_iostream.cpp",
        "test_kwargs_and_defaults.cpp",
        "test_local_bindings.cpp",
        "test_methods_and_attributes.cpp",
        "test_modules.cpp",
        "test_multiple_inheritance.cpp",
        "test_numpy_array.cpp",
        "test_numpy_dtypes.cpp",
        "test_numpy_vectorize.cpp",
        "test_opaque_types.cpp",
        "test_operator_overloading.cpp",
        "test_pickling.cpp",
        "test_pytypes.cpp",
        "test_sequences_and_iterators.cpp",
        "test_smart_ptr.cpp",
        "test_stl.cpp",
        "test_stl_binders.cpp",
        "test_tagbased_polymorphic.cpp",
        "test_union.cpp",
        "test_virtual_functions.cpp"])

pybind11_tests_shared_library(
    target="#lib/cross_module_gil_utils",
    addl_cppdefines=["cross_module_gil_utils_EXPORTS"],
    sources=["cross_module_gil_utils.cpp"])

pybind11_tests_shared_library(
    target="#lib/pybind11_cross_module_tests",
    addl_cppdefines=["pybind11_cross_module_tests_EXPORTS"],
    sources=["pybind11_cross_module_tests.cpp"])

env_base.Clone(
    CPPDEFINES = ["NDEBUG", "external_module_EXPORTS"],
    CPPPATH=["#pybind11/include",
             python_include],
    CXXFLAGS=std_opt + ["-fPIC"] + vis_opt + opt_opt + wrn_opt,
    LINKFLAGS=["-shared", "-fPIC"] + opt_opt,
    LIBPREFIX="").SharedLibrary(
        target="#lib/external_module",
        source=["#pybind11/tests/test_embed/external_module.cpp"])

env_base.Clone(
    CPPDEFINES = ["NDEBUG"],
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
