#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: IDO71_DIR=... CXX71_ROOT=... IRIX_RUNTIME_ROOT=... IRIX6_ROOT=... $0 OUTPUT_DIR" >&2
    exit 2
fi

for variable in IDO71_DIR CXX71_ROOT IRIX_RUNTIME_ROOT IRIX6_ROOT; do
    eval "value=\${$variable:-}"
    if [ -z "$value" ]; then
        echo "$variable is required" >&2
        exit 2
    fi
done

output=$1
repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)

if [ -e "$output" ]; then
    echo "refusing to overwrite existing output directory: $output" >&2
    exit 2
fi

for file in \
    "$IDO71_DIR/acpp" \
    "$IDO71_DIR/cc" \
    "$CXX71_ROOT/usr/lib/c++/cfront" \
    "$IRIX_RUNTIME_ROOT/usr/bin/qemu-irix" \
    "$IRIX_RUNTIME_ROOT/lib/rld" \
    "$IRIX_RUNTIME_ROOT/lib/libmalloc.so" \
    "$IRIX_RUNTIME_ROOT/lib/libc.so.1" \
    "$IRIX6_ROOT/usr/lib/libC.so"; do
    if [ ! -f "$file" ]; then
        echo "missing package component: $file" >&2
        exit 2
    fi
done

mkdir -p \
    "$output/irix/usr/lib/c++" \
    "$output/irix/usr/lib" \
    "$output/irix/lib" \
    "$output/irix/usr/tmp"

cp -R "$IDO71_DIR"/. "$output/"
cp "$repo_dir/decompme/cc-cfront" "$output/cc-cfront"
cp "$IRIX_RUNTIME_ROOT/usr/bin/qemu-irix" "$output/qemu-irix"
cp "$CXX71_ROOT/usr/lib/c++/cfront" "$output/irix/usr/lib/c++/cfront"
cp "$IRIX6_ROOT/usr/lib/libC.so" "$output/irix/usr/lib/libC.so"
cp "$IRIX_RUNTIME_ROOT/lib/rld" "$output/irix/lib/rld"
cp "$IRIX_RUNTIME_ROOT/lib/libmalloc.so" "$output/irix/lib/libmalloc.so"
cp "$IRIX_RUNTIME_ROOT/lib/libc.so.1" "$output/irix/lib/libc.so.1"
cp "$IRIX_RUNTIME_ROOT/lib/libc.so.1" "$output/irix/usr/lib/libc.so.1"

chmod +x \
    "$output/cc-cfront" \
    "$output/qemu-irix" \
    "$output/irix/usr/lib/c++/cfront"

expected_cfront=173f6cf0dfeba2b667c83a650f83e0ccc4612365455957ce27bf60d42576e157
actual_cfront=$(shasum -a 256 "$output/irix/usr/lib/c++/cfront" | awk '{print $1}')
if [ "$actual_cfront" != "$expected_cfront" ]; then
    echo "unexpected cfront SHA-256: $actual_cfront" >&2
    exit 1
fi

echo "compiler package created: $output"
echo "cfront SHA-256: $actual_cfront"
