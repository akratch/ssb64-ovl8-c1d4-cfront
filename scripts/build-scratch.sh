#!/bin/sh

set -eu

if [ "$#" -ne 2 ]; then
    echo "usage: SSB_REPO=/path/to/ssb-decomp-re $0 ARCHIVE.zip OUTPUT_DIR" >&2
    exit 2
fi

if [ -z "${SSB_REPO:-}" ]; then
    echo "SSB_REPO must name an ssb-decomp-re checkout" >&2
    exit 2
fi

archive=$1
output_dir=$2
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ido_root=${IDO71_ROOT:-"$SSB_REPO/tools/ido-recomp/7.1"}

if [ ! -f "$archive" ]; then
    echo "archive not found: $archive" >&2
    exit 2
fi

if [ -e "$output_dir" ]; then
    echo "refusing to overwrite existing output directory: $output_dir" >&2
    exit 2
fi

for tool in cfe uopt ugen as1; do
    if [ ! -x "$ido_root/$tool" ]; then
        echo "missing compiler tool: $ido_root/$tool" >&2
        exit 2
    fi
done

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

mkdir -p "$output_dir/archive" "$output_dir/build"
unzip -q "$archive" -d "$output_dir/archive"

if [ ! -f "$output_dir/archive/ctx.c++" ] || \
   [ ! -f "$output_dir/archive/target.o" ]; then
    echo "archive must contain ctx.c++ and target.o" >&2
    exit 2
fi

awk '1' "$output_dir/archive/ctx.c++" "$repo_dir/scratch.c" \
    > "$output_dir/build/combined.c"

prefix="$output_dir/build/scratch"
export USR_LIB="$ido_root"

nice -n 10 "$ido_root/cfe" \
    -D_MIPS_FPSET=16 -D_MIPS_ISA=2 -D_ABIO32=1 -D_MIPS_SIM=_ABIO32 \
    -D_MIPS_SZINT=32 -D_MIPS_SZLONG=32 -D_MIPS_SZPTR=32 \
    -D__EXTENSIONS__ -DLANGUAGE_C -D_LANGUAGE_C -D__INLINE_INTRINSICS \
    -Dsgi -D__sgi -Dunix -Dmips -Dhost_mips -D__unix -D__host_mips \
    -D_SVR4_SOURCE -D_MODERN_C -D_SGI_SOURCE -D__DSO__ -DSYSTYPE_SVR4 \
    -D_SYSTYPE_SVR4 -D_LONGLONG -D__mips=2 \
    -I"$SSB_REPO/include" -I"$SSB_REPO/src" -I"$SSB_REPO/build/us/src" \
    -D_MIPSEB -DMIPSEB -D__STDC__=1 -DF3DEX_GBI_2 -D_MIPS_SZLONG=32 \
    -DNDEBUG -DN_MICRO -D_FINALROM -DREGION_US -I/usr/include \
    "$output_dir/build/combined.c" -Xv -D_CFE '-Amachine(mips)' \
    '-Asystem(unix)' -Xwoff649,838,712,516,624,568,763 \
    -non_shared -G 0 -std -XS"$prefix.T" -Xcpluscomm -mips2 -EB -Xg0 -O2 \
    > "$prefix.B" 2> "$prefix.cfe.log"

nice -n 10 "$ido_root/uopt" -G 0 -mips2 -EB -g0 -O2 \
    "$prefix.B" "$prefix.O" -t "$prefix.T" "$prefix.uo" \
    > "$prefix.uopt.log" 2>&1

nice -n 10 "$ido_root/ugen" -G 0 -mips2 -EB -g0 -O2 \
    "$prefix.O" -o "$prefix.G" -t "$prefix.T" -temp "$prefix.ug" \
    > "$prefix.ugen.log" 2>&1

nice -n 10 "$ido_root/as1" -t5_ll_sc_bug -elf -G 0 -p0 -r4300_mul \
    -mips2 -EB -g0 -O2 "$prefix.G" -o "$prefix.o" -t "$prefix.T" \
    > "$prefix.as1.log" 2>&1

"$objcopy" -j .text -O binary "$output_dir/archive/target.o" \
    "$output_dir/build/target.text"
"$objcopy" -j .text -O binary "$prefix.o" "$prefix.text"

candidate_size=$(wc -c < "$prefix.text" | tr -d ' ')
if [ "$candidate_size" -ne 240 ]; then
    echo "candidate .text is $candidate_size bytes; expected 240" >&2
    exit 1
fi

dd if="$output_dir/build/target.text" \
    of="$output_dir/build/target-function.text" bs=240 count=1 2>/dev/null

if ! cmp "$prefix.text" "$output_dir/build/target-function.text"; then
    echo "mismatch: scratch.c does not match the first 240 target bytes" >&2
    exit 1
fi

echo "exact match: 240 bytes / 60 instructions"
shasum "$prefix.text"
