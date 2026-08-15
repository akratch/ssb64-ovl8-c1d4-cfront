# Integration

## Proposed compiler layout

The conservative integration uses three source/compiler regions for this
portion of `ovl8_8`:

1. Keep the established IRIX4 C span on its current compiler route.
2. Keep the coherent C++ span on IDO 7.1 NCC.
3. Start a final C source at `func_ovl8_8037C1D4` and compile it through stock
   IDO 7.1 CFE.

The third region contains only C1D4. This is the smallest split supported by
the compiler evidence.

The root `scratch.c` is the byte-verified source for that third C region.

## Source constraints

Use [the tested C source](../scratch.c) verbatim for the first integration
build. In particular:

- Preserve the unused `next` local. It is part of the matching source geometry.
- Preserve the explicit `temp_t1 = run_length--` form in both loops.
- Preserve both physical backslash-newline splices. They join each pointer
  declaration to the following `temp_t1` assignment on one preprocessing
  logical line.
- Keep the optimization and target settings on the established project values:
  IDO 7.1 C backend, `-O2`, MIPS-II, big-endian O32.

The backslashes are not decorative matching noise. The same compiler path
without them produces the correct instruction multiset and register choices,
but eight instructions are scheduled differently.

## Legacy-cfront alternative

The checked-in [experimental C++ input](../src/func_ovl8_8037C1D4.C) is valid
C++ and cfront emits the expected mangled symbol:

```text
func_ovl8_8037C1D4__FPPUcT1l
```

Legacy cfront is a C++-to-C translator. Its generated C then passes through the
IDO C optimizer and backend. That explains why C++ provenance is plausible,
but this route is not available in the current decomp.me preset and was not
reproduced with a complete IDO 7.1 OCC/cfront installation. Treat it as an
alternative provenance experiment, not the default integration.

## Boundary control

The cfront route was also applied to `func_ovl8_8037B760`, a representative
function from the surrounding C++ span. It failed structurally:

| Control | ROM | cfront candidate |
|---|---:|---:|
| True instructions | 36 | 32 |
| Differing words | — | 31 |
| Opcode differences | — | 27 |

This rules out converting the entire second C++ span to cfront. NCC remains the
correct model there; the cfront experiment is narrowly scoped to C1D4, while
the default C1D4 integration remains the verified C split.

## Final integration checks

After adding the split:

1. Confirm the linked symbol and section boundary.
2. Compare exactly `0xF0` function bytes; ignore the target object's four
   trailing alignment NOPs.
3. Confirm there are no relocations in the function.
4. Confirm the full overlay still uses NCC for the preceding C++ functions.

The checked-in object is a static reference artifact only. Do not link it into
the project in place of a source build.
