# Status

## What is solved

`func_ovl8_8037C1D4` has an exact C++ match through the authentic MIPSpro C++
7.1 legacy-cfront route. The translator came from SGI CD `812-0400-005`, emits
the checked-in generated C byte for byte, and the IDO 7.1 backend produces:

```text
60 instructions / 0xF0 bytes
0 differing words
0 opcode differences
0 register differences
```

The root `scratch.c` independently reproduces the same target as a stock IDO
7.1 C-stage control against the exported decomp.me ZIP.

## decomp.me status

The current `ido7.1_c++` preset selects NCC/EDG, not legacy cfront. The
strongest NCC candidate preserves the complete 60-instruction structure and
differs only here:

```text
target:    negu  t0,a2
target:    andi  t0,t0,0xff

NCC best:  negu  t2,a2
NCC best:  andi  t0,t2,0xff
```

That is a two-word NCC register-allocation residue. It does not invalidate the
exact C++ result; it demonstrates that decomp.me needs a distinct compiler
preset.

Apply-ready changes for that preset are included in
[`patches/decompme-compilers.patch`](patches/decompme-compilers.patch) and
[`patches/decompme-app.patch`](patches/decompme-app.patch). The compiler image
built from those changes reproduces the original `mdYYe` context and target at
zero words. Production decomp.me still needs to merge and deploy the preset
before a public zero-score scratch can be created.

## Recommended decision

Use a third C++ split at `func_ovl8_8037C1D4` and route it through MIPSpro C++
7.1 legacy cfront. Keep the preceding translation unit on NCC; compiling a
surrounding anchor through cfront fails structurally.
