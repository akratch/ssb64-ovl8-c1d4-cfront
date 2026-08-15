# Status

## What is solved

`func_ovl8_8037C1D4` matches exactly under the stock IDO 7.1 C frontend.
The root `scratch.c` was rebuilt against the exported decomp.me ZIP's exact
context and target:

```text
60 instructions / 0xF0 bytes
0 differing words
0 opcode differences
0 register differences
```

## What is not solved

There is no zero-difference result under the ordinary `ido7.1_c++` NCC/EDG
compiler used by scratch `mdYYe` and the surrounding C++ split. The strongest
NCC candidate preserves the complete 60-instruction structure and differs only
here:

```text
target:    negu  t0,a2
target:    andi  t0,t0,0xff

NCC best:  negu  t2,a2
NCC best:  andi  t0,t2,0xff
```

That is a two-word register-allocation residue, not a completed C++ match.

## What the cfront result means

A valid C++ source compiled through authentic legacy cfront 3.0.1 and then the
IDO 7.1 C backend produces an exact object. This is evidence that a legacy
C++-to-C compiler route can explain the ROM while retaining C++ linkage.

It is not yet production-grade provenance because:

- decomp.me does not provide this legacy-cfront route;
- the locally available cfront executable came from an IRIX 7.4.4 package;
- the local IDO 7.1 package does not contain its optional OCC/cfront subsystem.

## Recommended decision

Use a third C split at `func_ovl8_8037C1D4` unless a complete IDO 7.1
OCC/cfront installation reproduces the exact C++ result. Keep the preceding
translation unit on NCC; compiling a surrounding anchor through cfront fails
structurally.
