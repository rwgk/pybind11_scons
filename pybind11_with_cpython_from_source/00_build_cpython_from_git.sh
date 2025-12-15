#!/bin/bash
set -x

# Determine current short git SHA and install under a per-commit prefix.
short_sha="$(git rev-parse --short HEAD)"
install_dir="$HOME/wrk/cpython_installs/v3.14_${short_sha}"

mkdir -p "$install_dir"

make distclean || true

./configure \
    --prefix="$install_dir" \
    --disable-gil \
    --enable-shared

make -j"$(nproc)"
make install
