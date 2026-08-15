# `func_ovl8_8037C1D4`: compiler-provenance handoff

This repository records three different compiler results for Super Smash Bros.
function `func_ovl8_8037C1D4`. They should not be conflated.

| Route | Result | Status |
|---|---:|---|
| IDO 7.1 C | **0 words** | Exact and reproducible with the exported decomp.me context |
| IDO 7.1 NCC/EDG C++ | **2 words** | Best ordinary C++ result; not solved |
| Legacy cfront 3.0.1 -> IDO 7.1 C backend | **0 words** | Exact local experiment; not an ordinary NCC or hosted decomp.me match |

The conservative integration recommendation is a third **C** split at C1D4.
The legacy-cfront result is useful provenance evidence, but it should not be
presented as a completed `ido7.1_c++` match.

See [STATUS.md](STATUS.md) for the decision in compact form.

## Legacy-cfront experiment

The experimental exact path is:

```text
valid C++ source
    -> SGI legacy cfront 3.0.1
    -> generated C
    -> IDO 7.1 C backend
    -> exact MIPS-II object
```

This demonstrates a plausible reason that C++ source could produce C-like
codegen: legacy cfront translates C++ into C before the IDO optimizer. It does
not demonstrate that the ordinary IDO 7.1 NCC/EDG compiler selected by the
existing decomp.me scratch produces the match.

## Recommended split

Keep the established IRIX4 and NCC spans unchanged, then split once more at
`func_ovl8_8037C1D4` and compile that final function as C with the stock IDO
7.1 C route.

If a complete IDO 7.1 OCC/cfront installation later reproduces the local
cfront result, the third split can be reconsidered as legacy-cfront C++.
Do not apply cfront to the surrounding NCC translation unit: a control build of
`func_ovl8_8037B760` emits 32 instructions instead of the ROM's 36 and has 27
opcode differences.

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
`ido7.1_c++` NCC; compiling `scratch.c` through that frontend does not match.
For a decomp.me zero, create a C scratch with the same target, context, and
flags. The corresponding legacy-cfront C++ experiment remains
[src/func_ovl8_8037C1D4.C](src/func_ovl8_8037C1D4.C), which must first pass
through legacy cfront.

## Repository contents

- [Legacy-cfront C++ input](src/func_ovl8_8037C1D4.C)
- [ZIP-compatible C scratch](scratch.c)
- [Generated cfront C](generated/cfront-output.c)
- [Legacy-cfront reference object](artifacts/func_ovl8_8037C1D4.o)
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
reproducible compiler-mechanism experiment, not a conventional IDO 7.1 C++
match and not proof that a particular 7.4.4 binary built the original game.
SGI documented the legacy translator as an available `-32 -use_cfront` path;
an exact 7.1 OCC/cfront package would be required to strengthen that provenance
claim.

No SGI compiler binaries, ROM data, target objects, or optimizer intermediates
are distributed here.

## Project context

- [SSB64 ovl8 IRIX4 catalogue](https://github.com/akratch/ssb64-ovl8-irix4)
- [ovl8 split 1/2 — IRIX](https://decomp.me/scratch/0h1gs)
- [ovl8 split 2/2 — C++](https://decomp.me/scratch/6k57x)
