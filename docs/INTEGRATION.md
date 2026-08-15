# Integration

## Proposed compiler layout

The compiler evidence supports three source/compiler regions for this portion
of `ovl8_8`:

1. Keep the established IRIX4 C span on its current compiler route.
2. Keep the coherent C++ span on IDO 7.1 NCC.
3. Start a final C++ source at `func_ovl8_8037C1D4` and compile it through
   MIPSpro C++ 7.1 legacy cfront.

The third region contains only C1D4. This is the smallest split supported by
the compiler evidence. The tested input is
[src/func_ovl8_8037C1D4.C](../src/func_ovl8_8037C1D4.C).

The root `scratch.c` is the byte-verified generated-C-stage control, not the
recommended source-language integration.

## Source constraints

Use [the tested C++ source](../src/func_ovl8_8037C1D4.C) verbatim for the first
integration build. In particular:

- Preserve the unused `next` local. It is part of the matching source geometry.
- Preserve the explicit `temp_t1 = run_length--` form in both loops.
- Preserve both physical backslash-newline splices. They join each pointer
  declaration to the following `temp_t1` assignment on one preprocessing
  logical line.
- Keep the optimization and target settings on the established project values:
  MIPSpro C++ 7.1 legacy cfront, followed by the IDO 7.1 C backend, `-O2`,
  MIPS-II, big-endian O32.

The backslashes are not decorative matching noise. The same compiler path
without them produces the correct instruction multiset and register choices,
but eight instructions are scheduled differently.

## decomp.me compiler boundary

The C++ input is valid C++ and cfront emits the expected mangled symbol:

```text
func_ovl8_8037C1D4__FPPUcT1l
```

Legacy cfront is a C++-to-C translator. Its generated C then passes through the
IDO C optimizer and backend. The current decomp.me `ido7.1_c++` compiler uses
NCC/EDG instead and cannot reproduce this result. A hosted zero requires a new,
separate compiler preset, such as `ido7.1_cfront`; changing only the scratch
source cannot turn the NCC preset into the matching route.

## Boundary control

The cfront route was also applied to `func_ovl8_8037B760`, a representative
function from the surrounding C++ span. It failed structurally:

| Control | ROM | cfront candidate |
|---|---:|---:|
| True instructions | 36 | 32 |
| Differing words | — | 31 |
| Opcode differences | — | 27 |

This rules out converting the entire second C++ span to cfront. NCC remains the
correct model there; the legacy-cfront route is narrowly scoped to C1D4.

## Final integration checks

After adding the split:

1. Confirm the linked symbol and section boundary.
2. Compare exactly `0xF0` function bytes; ignore the target object's four
   trailing alignment NOPs.
3. Confirm there are no relocations in the function.
4. Confirm the full overlay still uses NCC for the preceding C++ functions.

The checked-in object is a static reference artifact only. Do not link it into
the project in place of a source build.
