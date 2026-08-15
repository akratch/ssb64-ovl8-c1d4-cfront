#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: $0 /path/to/standalone-target.o" >&2
    exit 2
fi

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
candidate="$repo_dir/artifacts/func_ovl8_8037C1D4.o"
target=$1

if [ ! -f "$target" ]; then
    echo "target object not found: $target" >&2
    exit 2
fi

if [ -n "${MIPS_OBJCOPY:-}" ]; then
    objcopy=$MIPS_OBJCOPY
elif command -v mips-linux-gnu-objcopy >/dev/null 2>&1; then
    objcopy=$(command -v mips-linux-gnu-objcopy)
elif [ -x /opt/homebrew/bin/mips-linux-gnu-objcopy ]; then
    objcopy=/opt/homebrew/bin/mips-linux-gnu-objcopy
else
    echo "mips-linux-gnu-objcopy not found; set MIPS_OBJCOPY" >&2
    exit 2
fi

work_dir=$(mktemp -d "${TMPDIR:-/tmp}/ssb-c1d4-verify.XXXXXX")
trap 'rm -rf "$work_dir"' EXIT HUP INT TERM

"$objcopy" -j .text -O binary "$candidate" "$work_dir/candidate.text"
"$objcopy" -j .text -O binary "$target" "$work_dir/target.text"

candidate_size=$(wc -c < "$work_dir/candidate.text" | tr -d ' ')
target_size=$(wc -c < "$work_dir/target.text" | tr -d ' ')

if [ "$candidate_size" -ne 240 ]; then
    echo "candidate .text is $candidate_size bytes; expected 240" >&2
    exit 1
fi

if [ "$target_size" -lt 240 ]; then
    echo "target .text is only $target_size bytes; expected at least 240" >&2
    exit 1
fi

dd if="$work_dir/target.text" of="$work_dir/target-function.text" \
    bs=240 count=1 2>/dev/null

if ! cmp "$work_dir/candidate.text" "$work_dir/target-function.text"; then
    echo "mismatch: the first 240 .text bytes differ" >&2
    exit 1
fi

echo "exact match: 240 bytes / 60 instructions"
shasum "$work_dir/candidate.text"
