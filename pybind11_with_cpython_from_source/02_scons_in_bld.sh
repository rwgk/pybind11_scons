#!/bin/bash
set -euo pipefail

export W="$HOME/wrk"

short_sha="$(git -C "$W/forked/cpython" rev-parse --short HEAD)"
cp_install="$W/cpython_installs/v3.14_${short_sha}"
bld_dir="$W/bld/pybind11_gcc_v3.14_${short_sha}"

if [ ! -d "$bld_dir/TestVenv" ]; then
    echo "Build directory or TestVenv missing at ${bld_dir}." >&2
    echo "Run 01_bootstrap_in_bld.sh first." >&2
    exit 125
fi

cd "$bld_dir"

export LD_LIBRARY_PATH="${cp_install}/lib"
. TestVenv/bin/activate

scons -j "$(nproc)"
