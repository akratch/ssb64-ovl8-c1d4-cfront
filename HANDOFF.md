# Maintainer handoff

## Short answer

Yes: `func_ovl8_8037C1D4` has a proper, byte-perfect C++ match.

MIPSpro C++ 7.1 provided two distinct C++ routes. The current decomp.me
`ido7.1_c++` preset uses NCC/EDG. The exact result uses the historically
supported legacy `-use_cfront` route: cfront 3.0.1 translates valid C++ to C,
then the IDO 7.1 C backend emits the object. Authentic November 1996 MIPSpro
C++ 7.1 media was recovered and independently confirms the result.

The exact candidate is 60 instructions and 240 bytes, with zero opcode,
register, or raw-word differences.

## Why a third split is justified

The surrounding C++ translation unit remains correctly modeled by NCC. A
representative surrounding function compiled through legacy cfront changes
from 36 to 32 instructions and fails structurally. C1D4 has no calls, literals,
or relocations tying it to that preceding unit, and it sits at the natural end
boundary. The smallest evidence-backed layout is therefore:

```text
existing IRIX4 region  -> unchanged
existing NCC C++ span  -> unchanged
func_ovl8_8037C1D4     -> C++, MIPSpro 7.1 legacy cfront
```

This is not relabeling a C match as C++. The checked-in input is accepted as
C++, emits the expected cfront-mangled symbol, and passes through the authentic
C++ translator before the matching IDO backend.

## decomp.me status

The current public compiler list cannot express the legacy route, so the old
`mdYYe` scratch cannot show zero under `ido7.1_c++`. This repository includes
reviewable patches for a separate `ido7.1_cfront` compiler image and app preset.
That exact image has already reproduced the exported `mdYYe` context and target
at zero words.

After the two patches are merged and deployed, select `IDO 7.1 C++ (legacy
cfront)`, retain `-O2 -mips2`, and paste [`decompme/scratch.cxx`](decompme/scratch.cxx).

## Suggested reply

> We found the missing compiler path. The function does have a byte-perfect
> C++ match, but not under the current NCC-based `ido7.1_c++` preset. Authentic
> MIPSpro C++ 7.1 media confirms it matches through the documented legacy
> cfront 3.0.1 route followed by the IDO 7.1 C backend: 60 instructions, 240
> bytes, zero differences. The preceding C++ span still belongs on NCC, so the
> evidence supports a narrow third C++ split at C1D4. The repo includes the
> exact source, provenance, static receipts, and apply-ready decomp.me compiler
> and application patches. Once that preset is deployed, the exported scratch
> reproduces a zero.
