# `scratch.c` verification receipt

## Archive

```text
file:    func_ovl8_8037C1D4 (1).zip
sha256:  dd61b5a365c75e69ceea114ea986875a2504db8149e267c36e73a94c4a02d770
slug:    mdYYe
target:  func_ovl8_8037C1D4
flags:   -O2 -mips2
```

Relevant member hashes:

```text
dc19d87afdab909e719edaa41292df0c8d03a0ef347a0d2951ba315b583ce610  ctx.c++
a41b7f9169582dc480b9177b2664f7fb309a94d35aa70eeef21bbd2ce0eab0cb  target.o
```

## Exact C-stage build

`ctx.c++` was concatenated verbatim with the repository's root `scratch.c`.
The result was compiled sequentially through the project IDO 7.1 C pipeline:

```text
cfe -> uopt -> ugen -> as1
```

The build used the project O32 definitions and include paths with `-O2`,
MIPS-II, big-endian output, `-G 0`, and `-non_shared`. No generated code was
executed.

```text
fd19f2dfc7198dac4b1f200b2a007e41eeac982657dc0a5257038f859ceef84c  scratch.c
6f45982fab2d6342f68a7f46b4a3ff7bedf8c2f62819ebaef6c7167a69270c74  function .text
```

The complete compiler object includes path-bearing `.mdebug`, so its whole-file
hash changes with the chosen output directory. The function `.text` hash above
is stable and is the relevant match receipt.

Static result:

```text
target function:    240 bytes
scratch function:   240 bytes
relocations:        none
byte comparison:    identical
both .text SHA-1:   6d2d054e964a274495bcc9953cf5b9cd340f7bcb
```

## Compiler boundary

The archive metadata selects `ido7.1_c++`, which is the ordinary NCC/EDG
frontend. That frontend is not the matching route for this source. As a
negative control, the same context and `scratch.c` compiled under the archive's
NCC preset produced 57 true instructions and a structural mismatch of 54 words
and 43 opcodes.

This is expected and is central to the provenance result:

```text
production C++ source -> legacy cfront -> exact C-stage source -> IDO 7.1 CFE
```

The root `scratch.c` preserves the exact downstream stage so the challenge can
be checked deterministically. It must not be presented as an NCC match.
