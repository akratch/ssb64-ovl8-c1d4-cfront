#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: CFRONT=/path/to/cfront [QEMU_IRIX=/path/to/qemu-irix IRIX_ROOT=/path/to/root] $0 OUTPUT.c" >&2
    exit 2
fi

if [ -z "${CFRONT:-}" ]; then
    echo "CFRONT must name an authentic MIPSpro C++ 7.1 cfront executable" >&2
    exit 2
fi

output=$1
repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
input="$repo_dir/generated/input-exact.i"
reference="$repo_dir/generated/cfront-output.c"

if [ ! -f "$CFRONT" ]; then
    echo "cfront not found: $CFRONT" >&2
    exit 2
fi

if [ -e "$output" ]; then
    echo "refusing to overwrite existing output: $output" >&2
    exit 2
fi

if [ -n "${QEMU_IRIX:-}" ]; then
    if [ -z "${IRIX_ROOT:-}" ]; then
        echo "IRIX_ROOT is required when QEMU_IRIX is set" >&2
        exit 2
    fi
    nice -n 10 "$QEMU_IRIX" -silent -L "$IRIX_ROOT" "$CFRONT" \
        +finput-exact.C < "$input" > "$output"
else
    nice -n 10 "$CFRONT" +finput-exact.C < "$input" > "$output"
fi

if ! cmp "$output" "$reference"; then
    echo "mismatch: translator output differs from generated/cfront-output.c" >&2
    exit 1
fi

echo "exact translator output"
shasum -a 256 "$output"
