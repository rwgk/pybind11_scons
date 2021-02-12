"""."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import collections
import os
import subprocess
import sys


def build_list_of_tests(tests_dirpath, substrings):
  """."""
  all_test_py = []
  for node in os.listdir(tests_dirpath):
    if node.startswith("test_class_sh_") and node.endswith(".py"):
      all_test_py.append(node)
      continue
    if not node.startswith("test_") or not node.endswith(".cpp"):
      continue
    cpp_filepath = os.path.join(tests_dirpath, node)
    py_filepath = cpp_filepath[:-3] + "py"
    assert os.path.isfile(cpp_filepath), cpp_filepath
    assert os.path.isfile(py_filepath), py_filepath
    all_test_py.append(node[:-3] + "py")
  all_test_py = list(sorted(set(all_test_py)))
  if (sys.version_info.major >= 3 and
      sys.version_info.minor >= 5):
    assert "test_async.py" in all_test_py
  else:
    all_test_py.remove("test_async.py")
  if not substrings:
    return True, all_test_py
  substrings_used = set()
  def substring_match(test_name):
    in_out_seen = set()
    in_out_matching = set()
    for substr in substrings:
      if substr.startswith("-"):
        plain_substr = substr[1:]
        in_out = -1
      else:
        plain_substr = substr
        in_out = 1
      in_out_seen.add(in_out)
      if plain_substr in test_name:
        substrings_used.add(substr)
        in_out_matching.add(in_out)
    if -1 in in_out_matching:
      return False
    if 1 in in_out_matching:
      return True
    if 1 in in_out_seen:
      return False
    return -1 in in_out_seen
  test_embed = substring_match("test_embed")
  list_of_test_py = []
  for test_py in all_test_py:
    if substring_match(test_py):
      list_of_test_py.append(test_py)
  substring_unused = substrings - substrings_used
  if substring_unused:
    raise RuntimeError(
        "Unused command-line argument%s: %s" % (
            plural_s(len(substring_unused)),
            " ".join(sorted(substring_unused))))
  return test_embed, list_of_test_py


def plural_s(num, suffix="s"):
  return "" if num == 1 else suffix


def normabspath(path, *paths):
  return os.path.normpath(os.path.abspath(os.path.join(path, *paths)))


def is_pybind11_source_dirpath(dirpath):
  if not os.path.isdir(dirpath):
    return False
  pybind11_h = normabspath(dirpath, "include/pybind11/pybind11.h")
  return os.path.isfile(pybind11_h)


def run(args):
  """."""
  pybind11_dirpath = None
  n_opt = []
  f_opt = []
  pytest_no_faulthandler = ["-p", "no:faulthandler"]
  g_opt = False
  k_opt = []
  s_opt = []
  v_opt = []
  count_opt = []
  i_opt = False
  substrings = set()
  args_iter = iter(args)
  for arg in args_iter:
    if arg.isdigit():
      assert not n_opt
      n_opt = ["-n", arg]
    elif arg.startswith("-f"):
      assert not f_opt
      f_opt = pytest_no_faulthandler
    elif arg.startswith("-g"):
      assert not g_opt
      g_opt = True
    elif arg.startswith("-k"):
      assert not k_opt
      k_opt = [arg, next(args_iter)]
    elif arg.startswith("-s"):
      assert not s_opt
      s_opt = [arg]
    elif arg.startswith("-v"):
      assert not v_opt
      v_opt = [arg]
    elif arg.startswith("--count"):
      assert not count_opt
      i = arg.find("=")
      assert i >= 0
      assert arg[i + 1:].isdigit()
      count_opt = [arg]
    elif is_pybind11_source_dirpath(arg):
      assert pybind11_dirpath is None
      pybind11_dirpath = normabspath(arg)
    elif arg.startswith("-i"):
      assert not i_opt
      i_opt = True
    else:
      substrings.add(arg)
  assert pybind11_dirpath is not None
  tests_dirpath = os.path.join(pybind11_dirpath, "tests")
  test_embed_dirpath = os.path.join(tests_dirpath, "test_embed")
  test_embed, list_of_test_py = build_list_of_tests(tests_dirpath, substrings)
  env = {"PYTHONPATH": normabspath("lib")}
  if test_embed:
    print('Running tests in directory "%s":' % test_embed_dirpath)
    sys.stdout.flush()
    subprocess.call(
        [normabspath("bin/test_embed")],
        cwd=test_embed_dirpath,
        env=env)
  if i_opt:
    print('Running %d individual test(s) in directory "%s":'
          % (len(list_of_test_py), tests_dirpath))
    sys.stdout.flush()
    return_code_counts = collections.defaultdict(int)
    common_args = ["-m", "pytest"] + s_opt + v_opt
    for test_py in list_of_test_py:
      print('Running individual test "%s":' % test_py)
      sys.stdout.flush()
      return_code = subprocess.call(
          [sys.executable] + common_args + [test_py],
          cwd=tests_dirpath,
          env=env)
      print('Return code for individual test "%s": %d' % (test_py, return_code))
      sys.stdout.flush()
      return_code_counts[return_code] += 1
    print("Frequency of return codes (total is %d):" % len(return_code_counts))
    for return_code, count in sorted(return_code_counts.items()):
      print("  %3d: %d" % (return_code, count))
    sys.stdout.flush()
  elif list_of_test_py:
    if g_opt and not f_opt:
      f_opt = pytest_no_faulthandler
    common_args = (
        ["-m", "pytest"]
        + n_opt + f_opt + k_opt + s_opt + v_opt + count_opt
        + list_of_test_py)
    print('Running tests in directory "%s":' % tests_dirpath)
    sys.stdout.flush()
    if not g_opt:
      subprocess.call(
          [sys.executable] + common_args,
          cwd=tests_dirpath,
          env=env)
    else:
      bash_env = " ".join(["%s='%s'" % kv for kv in sorted(env.items())])
      gdb_ex = " ".join(["run"] + common_args)
      bash_gdb_command = "%s gdb --cd '%s' '%s' -ex '%s'" % (
          bash_env, tests_dirpath, sys.executable, gdb_ex)
      print(bash_gdb_command)
      print()
      sys.stdout.flush()
      subprocess.call(bash_gdb_command, shell=True)


if __name__ == "__main__":
  run(args=sys.argv[1:])
