# Exact-match receipt

This receipt is for the authentic MIPSpro C++ 7.1 legacy-cfront route. The
ordinary IDO 7.1 NCC/EDG route remains two words short of the target.

## Candidate

```text
object:   artifacts/func_ovl8_8037C1D4.o
format:   ELF32, big-endian MIPS-II, relocatable
symbol:   func_ovl8_8037C1D4__FPPUcT1l
size:     240 bytes / 60 instructions
relocs:   none in the function
```

The distributed object has its path-bearing `.mdebug` section removed. This
does not change `.text`, the function symbol, MIPS options, or register data.

## Static comparison

```text
verdict=instruction-words-identical
words=0
raw=0
opcodes=0
gaps=0
reloc_syms=0
regs=0
insns=60
function_sha1=71173e393c58
```

The extracted candidate `.text` and the target's first `0xF0` bytes both have
SHA-1:

```text
6d2d054e964a274495bcc9953cf5b9cd340f7bcb
```

The standalone target object has four additional alignment NOPs after the
function. They are not part of C1D4 and are excluded from the comparison.

## Causal controls

| Control | Instructions | Residual |
|---|---:|---:|
| Exact C++ source, cfront, two line splices | 60 | **0 words** |
| Same route, line splices removed | 60 | 8 schedule words |
| Prior best NCC topology translated by cfront | 53 | structural mismatch |
| Surrounding `func_ovl8_8037B760` through cfront | 32 vs 36 | 31 words / 27 opcodes |

These controls establish both the source-line causality of the exact candidate
and the narrow scope of the cfront compiler split.

## Authentic 7.1 reproduction

The `cfront` extracted from SGI CD `812-0400-005` generated
`generated/cfront-output.c` byte for byte. A fresh IDO 7.1 backend build then
produced a 240-byte `.text` section identical to the target:

```text
candidate bytes: 240
target bytes:    240
candidate SHA-1: 6d2d054e964a274495bcc9953cf5b9cd340f7bcb
target SHA-1:    6d2d054e964a274495bcc9953cf5b9cd340f7bcb
```

See [AUTHENTIC-71.md](AUTHENTIC-71.md) for media and tool hashes.
