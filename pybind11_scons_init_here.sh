#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <python-executable-in-a-default/freethreaded-install-pair>" >&2
    exit 1
fi

source_dir="$(pwd -P)"
harness_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
catch2_dir="$(dirname -- "$harness_dir")/Catch2"
build_dir="$source_dir/build_scons"
python_executable="$(realpath -- "$1")"

if [[ ! -f "$source_dir/include/pybind11/pybind11.h" ||
      ! -f "$source_dir/tests/requirements.txt" ]]; then
    echo "Run this helper from the root of a pybind11 checkout/worktree." >&2
    exit 1
fi
if [[ -e "$build_dir" || -L "$build_dir" ]]; then
    echo "Build directory already exists: $build_dir" >&2
    exit 1
fi
if [[ ! -x "$python_executable" ||
      ! -f "$catch2_dir/single_include/catch2/catch.hpp" ]]; then
    echo "Need an executable Python and Catch2 v2 beside pybind11_scons." >&2
    exit 1
fi

install_dir="$("$python_executable" -c 'import sys; print(sys.base_prefix)')"
case "$install_dir" in
    *_default) install_prefix="${install_dir%_default}" ;;
    *_freethreaded) install_prefix="${install_dir%_freethreaded}" ;;
    *)
        echo "Python installation must end in _default or _freethreaded: $install_dir" >&2
        exit 1
        ;;
esac

# Check both interpreters before creating either build directory.
for variant in default freethreaded; do
    python_variant="${install_prefix}_${variant}/bin/python3"
    if [[ ! -x "$python_variant" ]]; then
        echo "Missing paired interpreter: $python_variant" >&2
        exit 1
    fi
    is_freethreaded="$("$python_variant" -c 'import sysconfig; print(int(bool(sysconfig.get_config_var("Py_GIL_DISABLED"))))')"
    expected=0
    if [[ "$variant" == freethreaded ]]; then expected=1; fi
    if [[ "$is_freethreaded" != "$expected" ]]; then
        echo "Interpreter does not match its $variant installation name: $python_variant" >&2
        exit 1
    fi
done

# repr() quotes the absolute paths correctly in the generated Python files.
"$python_executable" - "$source_dir" "$harness_dir" "$catch2_dir" <<'PY'
from pathlib import Path
import sys

source, harness, catch2 = map(Path, sys.argv[1:])
for variant in ("default", "freethreaded"):
    build = source / "build_scons" / variant
    build.mkdir(parents=True)
    config = {
        "python_executable": str(build / "TestVenv/bin/python3"),
        "compiler": "linux_gcc",
        "cxx_std": "c++20",
    }
    (build / "SConstruct").write_text(
        f"VariantDir('#pybind11', {str(source)!r}, duplicate=0)\n"
        f"VariantDir('#Catch2', {str(catch2)!r}, duplicate=0)\n"
        f"pybind11_build_config = {config!r}\n"
        'Export("pybind11_build_config")\n'
        f"SConscript({str(harness / 'SConscript')!r})\n",
        encoding="utf-8",
    )
PY

for variant in default freethreaded; do
    echo "Setting up $build_dir/$variant"
    "${install_prefix}_${variant}/bin/python3" -m venv "$build_dir/$variant/TestVenv"
    venv_python="$build_dir/$variant/TestVenv/bin/python3"
    "$venv_python" -m pip install --upgrade pip
    "$venv_python" -m pip install -r "$source_dir/tests/requirements.txt" pytest-xdist
done

printf '\nReady: %s/default and %s/freethreaded\n' "$build_dir" "$build_dir"
