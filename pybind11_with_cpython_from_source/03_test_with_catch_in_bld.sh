#!/bin/bash
set -euo pipefail

export W="$HOME/wrk"

short_sha="$(git -C "$W/forked/cpython" rev-parse --short HEAD)"
cp_install="$W/cpython_installs/v3.14_${short_sha}"
bld_dir="$W/bld/pybind11_gcc_v3.14_${short_sha}"

if [ ! -x "$bld_dir/bin/test_with_catch" ]; then
    echo "Missing test_with_catch binary at ${bld_dir}/bin/test_with_catch." >&2
    echo "Run 02_scons_in_bld.sh first." >&2
    exit 125
fi

cd "$W/forked/pybind11/tests/test_with_catch"

export LD_LIBRARY_PATH="${cp_install}/lib"
export PYTHONPATH="${bld_dir}/lib"
export PATH=

# Use a timeout so hangs are automatically treated as failures (useful for bisect).
TIMEOUT_BIN=/usr/bin/timeout
if [ ! -x "$TIMEOUT_BIN" ]; then
    echo "Missing $TIMEOUT_BIN; cannot enforce timeout" >&2
    exit 125
fi

"$TIMEOUT_BIN" 5s "${bld_dir}/bin/test_with_catch"
