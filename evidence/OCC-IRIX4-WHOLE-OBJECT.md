# Whole-object and jump-table receipt

## Source snapshot

The compiler census uses the natural/current catalog source from
`ssb64-ovl8-irix4`, prepared only for legacy C++ declarations and incomplete
callback types. `func_ovl8_8037BF68` is omitted because cfront 3.0.1 rejects
one modern reconstructed source construct.

The build uses legacy cfront, IRIX4 `accom`, and the IDO 7.1 backend at `-O2`
for big-endian MIPS-II O32. For this header-heavy census only, native IDO 7.1
`acpp` is used as the preprocessing stand-in because the exact IRIX4
preprocessor stalls under nested host emulation while expanding the full
reconstructed header closure. Earlier full-TU controls found the two
preprocessors byte-identical after normalizing source attribution. The exact
C1D4 receipt itself does use the IRIX4 `acpp` named by OCC.

## Census

```text
functions in target:       75
functions compiled:        74
instruction-word exact:    64
nonzero compiled:          10
omitted:                   1 (8037BF68)
```

The full function list is
[`OCC-IRIX4-WHOLE-CENSUS.tsv`](OCC-IRIX4-WHOLE-CENSUS.tsv).

The nonzero set is dominated by source forms already known to have been tuned
for other frontends, an externally solved function not yet present in the
catalog checkout, and generic callback declarations in the reconstructed
context. The census therefore measures compiler reachability; it is not a
claim that all 75 current bodies are original source.

## Dense jump tables

The candidate object has:

```text
.rodata size:     0x50 bytes
.rel.rodata:      16 R_MIPS_32 entries
table starts:     0x08, 0x18, 0x28, 0x38
entries/table:    4
```

Each table load uses an indexed word from those offsets:

```text
803773CC: lw ..., 0x08(table_base)
803781A4: lw ..., 0x18(table_base)
80379070: lw ..., 0x28(table_base)
80379D74: lw ..., 0x38(table_base)
```

The function-level results are:

| Function | Size | Words | Verdict |
|---|---:|---:|---|
| `func_ovl8_803773CC` | `0x720` | 0 | relocation symbol names only |
| `func_ovl8_803781A4` | `0x61c` | 0 | relocation symbol names only |
| `func_ovl8_80379070` | `0x830` | 179 | structure/source residue |
| `func_ovl8_80379D74` | `0x388` | 0 | relocation symbol names only |

For the three zero rows, “relocation symbol names only” means the emitted
instruction words are exact while the standalone candidate names its table by
the anonymous `.rodata` section rather than the target object's recovered
symbol. The table relocation kind and layout are present.

`80379070` is the bounded negative control. The route emits the correct dense
four-way table and the correct 524-instruction function size, but cfront's
generated C changes the line/source geometry of an allocator-tuned body. Its
179-word residue is not evidence that the compiler cannot emit four-case
tables; it is evidence that this source form is not yet solved through cfront.
