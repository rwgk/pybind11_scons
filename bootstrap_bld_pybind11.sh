#!/bin/bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

usage() {
    cat >&2 <<EOF
Usage: $SCRIPT_NAME <cpython-install-dir> <bld-pybind11-dir>

Bootstrap a pybind11 build directory with a virtual environment configured
for a specific CPython installation.

Arguments:
    cpython-install-dir  Path to the CPython installation directory
                         (must contain bin/python3)
    bld-pybind11-dir     Path to a template build directory
                         (must contain a SConstruct file)

The script will create a new build directory named after the CPython
installation, set up a virtual environment, and install test dependencies.
EOF
    exit 1
}

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check argument count
if [[ $# -ne 2 ]]; then
    usage
fi

cpython_install_dir="$(realpath "$1")"
template_bld_dir="$(realpath "$2")"

py_exe="$cpython_install_dir/bin/python3"

if [[ ! -x "$py_exe" ]]; then
    error_exit "Python executable not found or not executable: $py_exe"
fi

template_sconstruct="$template_bld_dir/SConstruct"

if [[ ! -d "$template_bld_dir" ]]; then
    error_exit "Template build directory not found: $template_bld_dir"
fi

if [[ ! -f "$template_sconstruct" ]]; then
    error_exit "SConstruct not found in template directory: $template_sconstruct"
fi

# Construct new build directory name using CPython installation basename
cpython_basename="$(basename "$cpython_install_dir")"
new_bld_dir="${template_bld_dir}_${cpython_basename}"

if [[ -e "$new_bld_dir" ]]; then
    error_exit "Target build directory already exists: $new_bld_dir"
fi

# Validate pybind11 repository
pybind11_repo="$(realpath "$new_bld_dir/../../forked/pybind11" 2>/dev/null || true)"
if [[ -z "$pybind11_repo" || ! -d "$pybind11_repo" ]]; then
    # Try to construct the path even if new_bld_dir doesn't exist yet
    pybind11_repo="$(realpath "$(dirname "$new_bld_dir")/../forked/pybind11" 2>/dev/null || true)"
    if [[ -z "$pybind11_repo" || ! -d "$pybind11_repo" ]]; then
        error_exit "pybind11 repository not found at expected location relative to build directory"
    fi
fi

pybind11_tests_requirements="$pybind11_repo/tests/requirements.txt"
if [[ ! -f "$pybind11_tests_requirements" ]]; then
    error_exit "pybind11 test requirements file not found: $pybind11_tests_requirements"
fi

# Create new build directory and set up virtual environment
echo "Creating build directory: $new_bld_dir"
mkdir "$new_bld_dir"
cd "$new_bld_dir"
cp -a "$template_sconstruct" .

echo "Creating virtual environment with: $py_exe"
"$py_exe" -m venv TestVenv

echo "Activating virtual environment and installing dependencies..."
# shellcheck source=/dev/null
. TestVenv/bin/activate
pip install --upgrade pip
pip install -r "$pybind11_tests_requirements"
pip install pytest-xdist
pip install numpy

echo "Done."
echo
echo "$new_bld_dir is ready for use."
