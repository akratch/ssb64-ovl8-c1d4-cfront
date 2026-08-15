# `func_ovl8_8037C1D4`: compiler-provenance handoff

This repository records three compiler results for Super Smash Bros. function
`func_ovl8_8037C1D4`. The missing historical compiler has now been recovered
from the original MIPSpro C++ 7.1 distribution.

| Route | Result | Status |
|---|---:|---|
| IDO 7.1 C | **0 words** | Exact downstream C control |
| IDO 7.1 NCC/EDG C++ | **2 words** | Best ordinary NCC result |
| Authentic MIPSpro C++ 7.1 legacy cfront -> IDO 7.1 C backend | **0 words** | Exact C++ match |

The evidence-backed integration is a narrow third **C++** split at C1D4 using
MIPSpro C++ 7.1's documented legacy `-use_cfront` route. It is a proper C++
match, but it is not produced by decomp.me's current `ido7.1_c++` preset,
which selects NCC/EDG.

See [STATUS.md](STATUS.md) for the decision in compact form.

## Exact C++ route

The exact path is:

```text
valid C++ source
    -> MIPSpro C++ 7.1 legacy cfront 3.0.1
    -> generated C
    -> IDO 7.1 C backend
    -> exact MIPS-II object
```

The translator was extracted from SGI CD `812-0400-005`, MIPSpro C++ 7.1,
November 1996. Its generated C is byte-for-byte identical to the earlier
legacy-cfront control. A fresh IDO 7.1 backend build produces all 240 target
bytes exactly.

This does not make the existing decomp.me scratch a zero: its compiler ID is
the ordinary NCC frontend. A separate legacy-cfront preset is required. This
repository now includes apply-ready patches for both decomp.me repositories,
and the resulting compiler image has reproduced the original scratch context
and all 240 target bytes exactly.

## Recommended split

Keep the established IRIX4 and NCC spans unchanged, then split once more at
`func_ovl8_8037C1D4` and compile that final C++ source with MIPSpro C++ 7.1's
legacy cfront route.

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
`ido7.1_c++` NCC; compiling this source through that frontend does not match.
For an immediately hosted decomp.me zero, use a C scratch with the same target,
context, and flags. For the historically stronger C++ result, decomp.me must
first add a MIPSpro C++ 7.1 legacy-cfront preset.

## Repository contents

- [Legacy-cfront C++ input](src/func_ovl8_8037C1D4.C)
- [ZIP-compatible C scratch](scratch.c)
- [Generated cfront C](generated/cfront-output.c)
- [Legacy-cfront reference object](artifacts/func_ovl8_8037C1D4.o)
- [Exact-match receipt](evidence/EXACT-MATCH.md)
- [Candidate disassembly](evidence/candidate-disassembly.txt)
- [Authentic 7.1 receipt](evidence/AUTHENTIC-71.md)
- [Compiler provenance](docs/COMPILER-PROVENANCE.md)
- [NCC investigation](docs/NCC-INVESTIGATION.md)
- [Static verifier](scripts/verify.sh)
- [cfront output verifier](scripts/verify-cfront-output.sh)
- [Scratch rebuild script](scripts/build-scratch.sh)
- [decomp.me compiler integration](decompme/README.md)
- [decomp.me-ready C++ scratch](decompme/scratch.cxx)
- [decomp.me application patch](patches/decompme-app.patch)
- [decomp.me compiler-image patch](patches/decompme-compilers.patch)
- [Hosted-style compiler image receipt](evidence/DECOMPME-IMAGE.md)
- [Maintainer handoff](HANDOFF.md)

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

The exact translator came from SGI part `812-0400-005`, MIPSpro C++ 7.1. It
identifies itself in its output as:

```text
AT&T USL C++ Language System <3.0.1> 02/03/92
```

The 7.1 executable has SHA-256
`173f6cf0dfeba2b667c83a650f83e0ccc4612365455957ce27bf60d42576e157`
and an embedded SGI build stamp dated November 12, 1996. It emits the checked-in
[generated C](generated/cfront-output.c) byte for byte. All target code
generation used the IDO 7.1 C pipeline.

No SGI compiler binaries, ROM data, target objects, or optimizer intermediates
are distributed here.

## Project context

- [SSB64 ovl8 IRIX4 catalogue](https://github.com/akratch/ssb64-ovl8-irix4)
- [ovl8 split 1/2 — IRIX](https://decomp.me/scratch/0h1gs)
- [ovl8 split 2/2 — C++](https://decomp.me/scratch/6k57x)
