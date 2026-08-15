# `func_ovl8_8037C1D4`: exact legacy-cfront match

This repository contains a zero-difference C++ match for Super Smash Bros.
function `func_ovl8_8037C1D4`.

| Result | Value |
|---|---:|
| Function size | 60 instructions / `0xF0` bytes |
| Differing instruction words | **0** |
| Opcode differences | **0** |
| Register differences | **0** |
| Candidate text SHA-1 | `6d2d054e964a274495bcc9953cf5b9cd340f7bcb` |
| Decomp-workbench function hash | `71173e393c58` |

The matching path is:

```text
valid C++ source
    -> SGI legacy cfront 3.0.1
    -> generated C
    -> IDO 7.1 C backend
    -> exact MIPS-II object
```

This resolves the apparent contradiction around the overlay split. The source
can remain in a C++ region and retain the expected C++ symbol, while the legacy
C++ compiler lowers it through C. It is not necessary to relabel the function
as C merely because the stock C frontend was previously the only known exact
route.

## Recommended split

Keep the established IRIX4 and NCC spans unchanged, then split once more at
`func_ovl8_8037C1D4` and compile that final function as C++ through the legacy
`-use_cfront` route.

Do not apply cfront to the surrounding NCC translation unit. A control build
of `func_ovl8_8037B760` through the same route emits 32 instructions instead of
the ROM's 36 and has 27 opcode differences. The cfront result is therefore a
narrow mechanism for C1D4, not a replacement for the coherent NCC span.

See [Integration](docs/INTEGRATION.md) for the proposed layout and the source
details that must be preserved.

## ZIP-compatible `scratch.c`

The root [scratch.c](scratch.c) is a clean downstream C-stage source for the
exported `func_ovl8_8037C1D4 (1).zip` challenge. It was rebuilt using:

- the ZIP's `ctx.c++`, byte for byte;
- the ZIP's `target.o`;
- the same `-O2 -mips2` target settings;
- the stock IDO 7.1 C pipeline.

The fresh object has a 240-byte `.text` section identical to the target
function and contains no relocations. See the
[scratch receipt](evidence/SCRATCH-RECEIPT.md), or rebuild it with:

```sh
SSB_REPO=/path/to/ssb-decomp-re \
./scripts/build-scratch.sh '/path/to/func_ovl8_8037C1D4 (1).zip' /tmp/c1d4-build
```

The compiler distinction is essential. The ZIP metadata selects ordinary
`ido7.1_c++` NCC; compiling `scratch.c` directly through that frontend does
not match. `scratch.c` is the exact C-stage control produced by the compiler
model described here. The corresponding valid C++ input remains
[src/func_ovl8_8037C1D4.C](src/func_ovl8_8037C1D4.C), which must first pass
through legacy cfront.

## Repository contents

- [Exact C++ source](src/func_ovl8_8037C1D4.C)
- [ZIP-compatible C scratch](scratch.c)
- [Generated cfront C](generated/cfront-output.c)
- [Matching object](artifacts/func_ovl8_8037C1D4.o)
- [Exact-match receipt](evidence/EXACT-MATCH.md)
- [Candidate disassembly](evidence/candidate-disassembly.txt)
- [Compiler provenance](docs/COMPILER-PROVENANCE.md)
- [NCC investigation](docs/NCC-INVESTIGATION.md)
- [Static verifier](scripts/verify.sh)
- [Scratch rebuild script](scripts/build-scratch.sh)

The two physical backslash-newline splices in the source are intentional and
measured. Removing them keeps the same 60 instructions but leaves eight
schedule-only differences.

## Verification

The ROM-derived target is deliberately not included. Given the standalone
challenge `target.o`, verify the checked-in candidate without executing it:

```sh
./scripts/verify.sh /path/to/target.o
```

The script extracts `.text` from both relocatable objects and compares the
first `0xF0` bytes. The challenge target contains four trailing alignment NOPs;
those are outside the function and are ignored.

## Scope and provenance

The local IDO 7.1 extraction used for this work does not contain SGI's optional
OCC/cfront subsystem. The available authentic translator came from an IRIX
7.4.4 package and identifies itself in its output as:

```text
AT&T USL C++ Language System <3.0.1> 02/03/92
```

Its generated C was compiled with the project's IDO 7.1 C pipeline. This is a
reproducible compiler-mechanism result, not proof that a particular 7.4.4
binary built the original game. SGI documented the legacy translator as an
available `-32 -use_cfront` path; an exact 7.1 OCC/cfront package would be the
preferred final provenance check.

No SGI compiler binaries, ROM data, target objects, or optimizer intermediates
are distributed here.

## Project context

- [SSB64 ovl8 IRIX4 catalogue](https://github.com/akratch/ssb64-ovl8-irix4)
- [ovl8 split 1/2 — IRIX](https://decomp.me/scratch/0h1gs)
- [ovl8 split 2/2 — C++](https://decomp.me/scratch/6k57x)
