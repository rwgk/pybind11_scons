#!/bin/bash
set -euo pipefail

export W="$HOME/wrk"

# Determine current CPython 3.14 commit (short SHA) and matching install.
short_sha="$(git -C "$W/forked/cpython" rev-parse --short HEAD)"
cp_install="$W/cpython_installs/v3.14_${short_sha}"

if [ ! -x "$cp_install/bin/python3" ]; then
    echo "Missing CPython install for ${short_sha} at ${cp_install}." >&2
    echo "Run 00_build_cpython_from_git.sh in the CPython repo first." >&2
    exit 125
fi

# Per-commit SCons build directory for pybind11.
bld_dir="$W/bld/pybind11_gcc_v3.14_${short_sha}"
template_bld_dir="$W/bld/pybind11_gcc_v3.14_7297d3a98d3"

mkdir -p "$bld_dir"

# Seed the build directory with the known-good SConstruct if not present yet.
if [ ! -f "$bld_dir/SConstruct" ]; then
    if [ ! -f "$template_bld_dir/SConstruct" ]; then
        echo "Template SConstruct not found at ${template_bld_dir}/SConstruct." >&2
        exit 125
    fi
    cp "$template_bld_dir/SConstruct" "$bld_dir/SConstruct"
fi

cd "$bld_dir"

export LD_LIBRARY_PATH="${cp_install}/lib"

"${cp_install}/bin/python3" -m venv TestVenv
. TestVenv/bin/activate
python -V
