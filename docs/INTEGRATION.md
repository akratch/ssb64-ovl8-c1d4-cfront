# Integration

## Compiler model

The strongest current model is a historical C++ route, not a C/C++ language
exception at C1D4:

```text
MIPSpro C++ 7.1 OCC -irix4
  -> IRIX4 acpp
  -> legacy cfront 3.0.1
  -> IRIX4 accom
  -> IDO 7.1 uopt / ugen / as1
```

This compiler configuration emits the exact C1D4 object and the overlay's four
dense jump tables. It should be evaluated before adding another source split.

## Current evidence boundary

The unified route compiles 74 functions from the current catalog source; 64
are instruction-word exact. BF68 is omitted because the legacy parser rejects
its current reconstructed source form.

The table-function results are:

| Function | Result |
|---|---:|
| `803773CC` | 0 words |
| `803781A4` | 0 words |
| `80379070` | 179 words, correct 524-instruction/table shape |
| `80379D74` | 0 words |

These measurements justify continued work on the unified route. They do not
yet justify declaring the entire overlay one translation unit or removing all
existing splits.

## C1D4 source constraints

Use [`src/func_ovl8_8037C1D4.C`](../src/func_ovl8_8037C1D4.C) verbatim for the
first integration build:

- preserve the unused `next` local;
- preserve both explicit `temp_t1 = run_length--` loops;
- preserve both physical backslash-newline splices;
- compile at `-O2`, MIPS-II, big-endian O32;
- use cfront followed by the IRIX4 `accom` frontend and IDO 7.1 backend.

The expected cfront symbol is:

```text
func_ovl8_8037C1D4__FPPUcT1l
```

The matching function is exactly `0xF0` bytes and has no relocations.

## Recommended project decision

1. Do not create a C-only file at C1D4.
2. Add or prototype an `OCC -irix4` compiler configuration in the build.
3. Compile the existing overlay source through it and compare at function
   boundaries.
4. Integrate the externally solved `803787C0` source before repeating the
   census.
5. Work `80379070`, `8037ACAC`, and `8037B760` under the unified route.
6. Change Splat boundaries only after those discriminator functions either
   match or decisively falsify the one-route hypothesis.

The downstream C-stage `scratch.c` remains useful as a decomp.me control, but
it is not the preferred project-language explanation.
