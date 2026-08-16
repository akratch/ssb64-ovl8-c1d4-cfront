# Exact-match receipt

## Route

```text
valid C++ source
-> exact /usr/irix4/usr/lib/acpp
-> exact /usr/irix4/usr/lib/c++/cfront 3.0.1
-> exact /usr/irix4/usr/lib/accom
-> IDO 7.1 uopt / ugen / as1
```

This is the route printed by authentic MIPSpro C++ 7.1 `OCC -irix4`.

## Candidate

```text
object:   artifacts/func_ovl8_8037C1D4.o
format:   ELF32, big-endian MIPS-II, relocatable
symbol:   func_ovl8_8037C1D4__FPPUcT1l
size:     240 bytes / 60 instructions
relocs:   none in the function
```

The distributed object has its path-bearing `.mdebug` section removed. Its
function code, symbol, MIPS options, and register metadata are unchanged.

## Static comparison

```text
verdict=instruction-words-identical
words=0 raw=0 opcodes=0 gaps=0 reloc_syms=0 regs=0
insns=60 function_sha1=71173e393c58
```

The candidate function and target's first `0xF0` bytes both have SHA-1:

```text
6d2d054e964a274495bcc9953cf5b9cd340f7bcb
```

The standalone target has four alignment NOPs after the function. They are not
part of C1D4 and are excluded.

## Causal controls

| Control | Instructions | Residual |
|---|---:|---:|
| Exact C++ source, historical `OCC -irix4` stages, two line splices | 60 | **0 words** |
| Same source geometry without the two splices | 60 | 8 schedule words in the earlier cfront control |
| Best ordinary NCC/EDG C++ source | 60 | 2 register words |
| Stock IDO 7.1 C control | 60 | 0 words |

The ordinary NCC result differs only in the temporary register used by
`negu`/`andi`. The historical cfront/`accom` route removes that residue while
preserving C++ source provenance.

## Reproduction evidence

- [`OCC-IRIX4-DRIVER.txt`](OCC-IRIX4-DRIVER.txt): authentic driver dry run.
- [`OCC-IRIX4-EXACT-MATCH.txt`](OCC-IRIX4-EXACT-MATCH.txt): complete comparator line.
- [`candidate-disassembly.txt`](candidate-disassembly.txt): static candidate disassembly.
- [`AUTHENTIC-71.md`](AUTHENTIC-71.md): MIPSpro C++ 7.1 media receipt.
- [`../docs/COMPILER-PROVENANCE.md`](../docs/COMPILER-PROVENANCE.md): exact compatibility-product and IRIX4 frontend receipts.

No generated object was executed.
