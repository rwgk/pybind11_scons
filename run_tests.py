"""."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import subprocess
import sys


def build_list_of_test_py(substrings):
  """."""
  all_test_py = [
      "test_buffers.py",
      "test_builtin_casters.py",
      "test_call_policies.py",
      "test_callbacks.py",
      "test_chrono.py",
      "test_class.py",
      "test_constants_and_functions.py",
      "test_copy_move.py",
      "test_docstring_options.py",
      "test_eigen.py",
      "test_enum.py",
      "test_eval.py",
      "test_exceptions.py",
      "test_factory_constructors.py",
      "test_gil_scoped.py",
      "test_iostream.py",
      "test_kwargs_and_defaults.py",
      "test_local_bindings.py",
      "test_methods_and_attributes.py",
      "test_modules.py",
      "test_multiple_inheritance.py",
      "test_numpy_array.py",
      "test_numpy_dtypes.py",
      "test_numpy_vectorize.py",
      "test_opaque_types.py",
      "test_operator_overloading.py",
      "test_pickling.py",
      "test_pytypes.py",
      "test_sequences_and_iterators.py",
      "test_smart_ptr.py",
      "test_stl.py",
      "test_stl_binders.py",
      "test_tagbased_polymorphic.py",
      "test_union.py",
      "test_virtual_functions.py",
  ]
  if (sys.version_info.major >= 3 and
      sys.version_info.minor >= 5):
    all_test_py.append("test_async.py")
  if not substrings:
    return all_test_py
  list_of_test_py = []
  for test_py in all_test_py:
    for substr in substrings:
      if substr in test_py:
        list_of_test_py.append(test_py)
  return list_of_test_py


def run(args):
  """."""
  n_opt = []
  substrings = set()
  for arg in args:
   if arg.isdigit():
     assert not n_opt
     n_opt = ["-n", arg]
   else:
     substrings.add(arg)
  pybind11_dirpath = os.path.normpath(os.path.abspath("../pybind11"))
  tests_dirpath = os.path.join(pybind11_dirpath, "tests")
  test_embed_dirpath = os.path.join(tests_dirpath, "test_embed")
  env = {"PYTHONPATH": os.path.abspath("lib")}
  subprocess.call(
      [os.path.abspath("bin/test_embed")],
      cwd=test_embed_dirpath,
      env=env)
  list_of_test_py = build_list_of_test_py(substrings)
  subprocess.call(
      [sys.executable, "-m", "pytest"] + n_opt + list_of_test_py,
      cwd=tests_dirpath,
      env=env)


if __name__ == "__main__":
  run(args=sys.argv[1:])
