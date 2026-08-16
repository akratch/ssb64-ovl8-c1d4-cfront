# `ovl8_8`: C1D4 and the historical C++/IRIX4 route

This repository records an exact C++ match for
`func_ovl8_8037C1D4` and the compiler-provenance investigation behind it.

The important result is that the two working theories were not mutually
exclusive. Authentic MIPSpro C++ 7.1 `OCC -irix4` is one C++ driver route:

```text
C++ source
  -> /usr/irix4/usr/lib/acpp
  -> /usr/irix4/usr/lib/c++/cfront
  -> cc -irix4 -nocpp
  -> /usr/irix4/usr/lib/accom
  -> IDO 7.1 uopt / ugen / as1
```

In other words, a file can be C++ and still have the IRIX4 `accom` codegen
characteristics seen in the overlay.

## Results

| Question | Measured result |
|---|---|
| Is C1D4 a proper C++ match? | **Yes: 60 instructions, 0 differing words** |
| Does the historical C++ route make the four dense switch tables? | **Yes: four 4-entry tables in one `0x50`-byte `.rodata` section** |
| Are the table functions exact? | Three are exact now; `80379070` has the correct 524-instruction/table shape but a 179-word source residue |
| Does one route compile the current catalog well? | **64 of 74 compiled functions are instruction-word exact**; BF68 was omitted because the 1992 parser rejects its current reconstructed spelling |
| Is a single compiler for every function proven? | No. The evidence makes it credible, but several reconstructed bodies still need source work under this route |

The four table owners are:

| Function | Current result through `OCC -irix4` |
|---|---:|
| `func_ovl8_803773CC` | 0 words |
| `func_ovl8_803781A4` | 0 words |
| `func_ovl8_80379070` | 179 words, same 524 instructions and dense table |
| `func_ovl8_80379D74` | 0 words |

The whole-object census is in
[`evidence/OCC-IRIX4-WHOLE-CENSUS.tsv`](evidence/OCC-IRIX4-WHOLE-CENSUS.tsv).
It is evidence about compiler reachability, not a claim that the current
reconstructed source is original. Its full-header preprocessing uses the
native 7.1 `acpp` stand-in documented in the
[whole-object receipt](evidence/OCC-IRIX4-WHOLE-OBJECT.md); the exact C1D4
receipt uses the historical IRIX4 `acpp` itself.

## Exact C1D4 source

[`src/func_ovl8_8037C1D4.C`](src/func_ovl8_8037C1D4.C) is valid C++ and emits
the expected cfront-mangled symbol:

```text
func_ovl8_8037C1D4__FPPUcT1l
```

The exact historical route produces:

```text
verdict=instruction-words-identical
words=0 raw=0 opcodes=0 gaps=0 regs=0
insns=60 function_sha1=71173e393c58
```

The two physical backslash-newline splices in the source are intentional.
They affect source-line attribution and scheduling. Removing them keeps the
same instruction multiset but leaves eight schedule differences.

## Compiler provenance

The driver proof is direct, not reconstructed from filenames. The authentic
MIPSpro C++ 7.1 `OCC` dry run is checked in as
[`evidence/OCC-IRIX4-DRIVER.txt`](evidence/OCC-IRIX4-DRIVER.txt). It explicitly
selects the IRIX4 preprocessor, cfront translator, and `cc -irix4`.

The exact translator named by that route was recovered from SGI's
`irix4_c++` compatibility product on C++ Translator 3.2 media. It is
byte-identical to the independently archived C++ Translator 3.0.1 executable:

```text
SHA-256 7bd7e85fd5b029392caffa2c32e52779a826706116f1df5f3e14eb61448e202e
banner   AT&T USL C++ Language System <3.0.1> 02/03/92
```

The IRIX4 C frontend comes from IRIS Development Option 5.1. The media hashes
match the public archival catalog. No proprietary compiler binary is included
here; see [Compiler provenance](docs/COMPILER-PROVENANCE.md).

## What this changes

The previous recommendation was a narrow third C++ split at C1D4 using cfront
followed by the ordinary IDO 7.1 C frontend. That route is still an exact
existence proof, but it is no longer the best historical explanation.

The stronger model is the documented `OCC -irix4` route: legacy C++ translation
followed by IRIX4 `accom`, with the IDO 7.1 optimizer/backend. It explains both
C++ source provenance and the four dense jump tables in one compiler
configuration. A third split should not be added merely to make C1D4 C.

This repository does not claim that the entire overlay has already been
proven under one compiler. `80379070`, `8037ACAC`, `8037B760`, the externally
solved `803787C0`, and several callback/context-sensitive functions still need
their final source forms tested in the unified route.

## decomp.me

The current public `ido7.1_c++` preset uses NCC/EDG and remains two register
words short. A public zero therefore needs a distinct compiler preset that
models `OCC -irix4`; changing only the source pane cannot make the NCC preset
use cfront and `accom`.

The existing decomp.me prototype in this repository proves that a hosted
legacy-cfront preset is practical and yields a C++ zero. Its backend was the
ordinary IDO 7.1 C frontend. It should now be revised to use the already
available IRIX4 `accom` frontend wrapper so the hosted preset follows the
authentic `OCC -irix4` transcript.

For an immediate hosted zero today, the downstream C control in
[`scratch.c`](scratch.c) works with an IDO 7.1 C scratch. For the historically
stronger C++ result, use [`decompme/scratch.cxx`](decompme/scratch.cxx) after a
combined legacy-cfront/IRIX4 preset is deployed.

## Repository map

- [Exact C++ input](src/func_ovl8_8037C1D4.C)
- [Generated IRIX4-cfront C](generated/cfront-output.c)
- [Reference object](artifacts/func_ovl8_8037C1D4.o)
- [Exact comparison](evidence/OCC-IRIX4-EXACT-MATCH.txt)
- [Authentic driver transcript](evidence/OCC-IRIX4-DRIVER.txt)
- [Whole-object census](evidence/OCC-IRIX4-WHOLE-CENSUS.tsv)
- [Whole-object and jump-table receipt](evidence/OCC-IRIX4-WHOLE-OBJECT.md)
- [Compiler provenance](docs/COMPILER-PROVENANCE.md)
- [Integration guidance](docs/INTEGRATION.md)
- [Maintainer handoff](HANDOFF.md)
- [NCC investigation](docs/NCC-INVESTIGATION.md)

The ROM-derived target and SGI compiler binaries are not redistributed. No
generated program or target object was executed; all validation was static.

## Project context

- [SSB64 ovl8 IRIX4 catalogue](https://github.com/akratch/ssb64-ovl8-irix4)
- [ovl8 split 1/2 — IRIX](https://decomp.me/scratch/0h1gs)
- [ovl8 split 2/2 — C++](https://decomp.me/scratch/6k57x)
