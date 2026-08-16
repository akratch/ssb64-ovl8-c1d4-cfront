# Status

## Solved

`func_ovl8_8037C1D4` has an exact C++ match through the authentic historical
`OCC -irix4` route:

```text
60 instructions / 0xF0 bytes
0 differing words
0 opcode differences
0 register differences
```

The route is C++ cfront followed by IRIX4 `accom`, then the IDO 7.1
optimizer/backend. It is directly printed by the MIPSpro C++ 7.1 OCC driver.

## Jump tables

The same whole-object build emits four dense four-entry tables. The candidate
has a `0x50`-byte `.rodata` section and 16 table relocations at four consecutive
four-word ranges.

Three table functions are instruction-word exact. `80379070` emits the fourth
table and retains the correct 524-instruction function size, with 179 current
source differences.

## Whole-source census

The current catalog source gives 64 exact functions out of 74 compiled. BF68
was omitted because the legacy parser rejects one current reconstructed source
construct. The remaining mismatches are not evidence that the compiler cannot
emit the ROM; several are known alternate-frontend or incomplete-context
source forms.

## Decision

Do not make C1D4 a C file solely to obtain a match. A proper historical C++
zero now exists.

Treat a single `OCC -irix4` compiler for the overlay as a strong working
hypothesis, not a settled conclusion. Close the remaining source residues
before changing the final Splat boundaries.

## decomp.me

The ordinary `ido7.1_c++` preset remains two register words short because it
uses NCC/EDG. A public C++ zero needs a separate preset that chains legacy
cfront into the existing IRIX4 `accom` route. The checked-in hosted prototype
proves feasibility but predates this stronger driver-provenance result and
should be revised before upstream submission.
