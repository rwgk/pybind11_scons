# pybind11_scons

Enables concurrent testing of pybind11 with multiple build environments and
easy experimenting. Linux only. No bells or whistles.

## Worktree setup

Keep the main pybind11 checkout on `master` and do development/reviews in
worktrees. From the root of a worktree:

```bash
cd /wrk/forked/pybind11
git_swrp 6198
# git_swrp leaves you in /wrk/forked/pr6198

"$C/pybind11_scons/pybind11_scons_init_here.sh" \
    /wrk/cpython_installs/v3.14.4_23116f998f6_default/bin/python3
```

The helper accepts either executable in an existing CPython installation pair
named `<prefix>_default` and `<prefix>_freethreaded`. It uses
`sys.base_prefix` to find the pair, then checks that each interpreter has the
expected GIL configuration. Catch2 v2 must be checked out beside this harness,
at `../Catch2`.

It creates `build_scons/default` and `build_scons/freethreaded`, each with:

- a `SConstruct` recording absolute paths to this worktree, this harness,
  Catch2, and its own Python;
- a fresh `TestVenv`, with pip upgraded and the worktree's
  `tests/requirements.txt` plus `pytest-xdist` installed.

The generated builds use GCC and C++20; edit their `SConstruct` to change
these. No venv activation or `W` setting is needed. `build_scons` is already
ignored by pybind11's `.gitignore`. The helper refuses to overwrite an existing
`build_scons`; remove it when you want to initialize a different Python pair.
The recorded paths require the worktree and harness to stay at those locations.

## Build and test

Run from each build directory, one environment at a time:

```bash
cd build_scons/default
scons -j "$(nproc)" &&
    TestVenv/bin/python3 "$C/pybind11_scons/run_tests.py" ../.. 24

cd ../freethreaded
scons -j "$(nproc)" &&
    TestVenv/bin/python3 "$C/pybind11_scons/run_tests.py" ../.. 24
```

SCons writes objects and binaries inside the selected build directory.
The source and headers come from this worktree, without falling back to the
main checkout. pytest may create caches in the source tree.

Incremental builds are fine while iterating. For a clean rebuild, run
`"$C/pybind11_scons/cleanup_build_dir.sh"` from the selected build directory,
then rebuild. It preserves `TestVenv` and `SConstruct`; inspect its output,
because `UNCERTAINTY: NO ACTION` means it did not clean anything.

For focused runs, use `selected_test_cpp=test_callbacks.cpp` with scons and
pass a test-name substring, such as `callbacks`, to `run_tests.py`.
Helper translation units without a matching Python file are skipped by test
discovery. Catch2 failures stop the runner before pytest.

The existing `SConstruct` and `bootstrap_bld_pybind11.sh` remain available for
the older shared build-directory setup.

`smart_holder_poc_test.cpp` still needs to be built manually, for example:

```bash
clang++ -fsanitize=address -std=c++11 -O0 -g -Wall -Wextra -Wconversion -Wcast-qual -Wdeprecated -Wnon-virtual-dtor -Iinclude -I"$C/Catch2/single_include/catch2" -I/usr/include/python3.12 tests/pure_cpp/smart_holder_poc_test.cpp && ./a.out
```
