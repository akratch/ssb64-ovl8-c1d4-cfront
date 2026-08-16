# Proof: exact C++ match for `func_ovl8_8037C1D4`

## Claim

[`src/func_ovl8_8037C1D4.C`](src/func_ovl8_8037C1D4.C) is valid C++ source.
Compiled through the historical MIPSpro C++ `OCC -irix4` route, its complete
`0xF0`-byte function body is byte-for-byte identical to the target from the
exported decomp.me challenge.

This proves C1D4. It does not claim that every function in `ovl8_8` is already
matched under the same route.

## 1. Target identity

The target is the `target.o` member from
`func_ovl8_8037C1D4 (1).zip`:

```text
target.o SHA-256
a41b7f9169582dc480b9177b2664f7fb309a94d35aa70eeef21bbd2ce0eab0cb
```

Its `.text` section is `0x100` bytes. The function occupies the first `0xF0`
bytes; the remaining `0x10` bytes are four alignment NOPs outside the function.

## 2. The source passes through a C++ compiler

The input is not merely compiled as C. Legacy cfront accepts the `.C` source,
performs C++ translation, and emits the cfront-mangled symbol:

```text
func_ovl8_8037C1D4__FPPUcT1l
```

The translated output is retained as
[`generated/cfront-output.c`](generated/cfront-output.c). Its header identifies
the frontend as:

```text
AT&T USL C++ Language System <3.0.1> 02/03/92
```

## 3. The driver selects one historical C++/IRIX4 route

Authentic MIPSpro C++ 7.1 `OCC` was invoked in dry-run mode with:

```sh
OCC -v -n -c -O2 -mips2 -irix4 input.C
```

Its unedited output is
[`evidence/OCC-IRIX4-DRIVER.txt`](evidence/OCC-IRIX4-DRIVER.txt). The driver
selects:

```text
/usr/irix4/usr/lib/acpp
/usr/irix4/usr/lib/c++/cfront
/usr/bin/cc ... -O2 -mips2 -irix4 -nocpp ...
```

The last stage invokes IRIX4 `accom`, followed by the IDO 7.1 optimizer and
backend. Therefore C++ source provenance and IRIX4 code-generation behavior
are part of the same supported compiler configuration.

## 4. Exact compiler components

The binaries used for the matching build are pinned by hash:

```text
IRIX4 acpp
1d11da809d1a7f7bc2130d8f7fcd81ac5aa1c423c2f94b7617eaa132b962ef98

IRIX4 cfront 3.0.1
7bd7e85fd5b029392caffa2c32e52779a826706116f1df5f3e14eb61448e202e

IRIX4 accom
f7255b029d79d49edea98079f56f80a32922532418d694d64b09703d2695bda6
```

The cfront executable is the file installed at the exact path named by OCC in
the `irix4_c++` compatibility product. It is byte-identical to the independently
archived standalone C++ Translator 3.0.1 executable.

The `acpp` and `accom` binaries extracted from IRIS Development Option 5.1 are
byte-identical to those used in the build. Media part numbers and ISO hashes
are recorded in
[`docs/COMPILER-PROVENANCE.md`](docs/COMPILER-PROVENANCE.md).

## 5. Byte comparison

The checked-in reference object is
[`artifacts/func_ovl8_8037C1D4.o`](artifacts/func_ovl8_8037C1D4.o). Its
function `.text` and the target function are both exactly 240 bytes:

```text
candidate function SHA-1
6d2d054e964a274495bcc9953cf5b9cd340f7bcb

target function SHA-1
6d2d054e964a274495bcc9953cf5b9cd340f7bcb

cmp result
identical
```

The instruction-aware comparison independently reports:

```text
verdict=instruction-words-identical
words=0 raw=0 opcodes=0 gaps=0 reloc_syms=0 regs=0
insns=60 function_sha1=71173e393c58
```

The raw comparator receipt is
[`evidence/OCC-IRIX4-EXACT-MATCH.txt`](evidence/OCC-IRIX4-EXACT-MATCH.txt),
and the complete candidate disassembly is
[`evidence/candidate-disassembly.txt`](evidence/candidate-disassembly.txt).

Anyone holding the exported `target.o` can repeat the byte comparison without
executing either object:

```sh
./scripts/verify.sh /path/to/target.o
```

Expected output:

```text
exact match: 240 bytes / 60 instructions
6d2d054e964a274495bcc9953cf5b9cd340f7bcb
```

## Conclusion

C1D4 has a proper, exact C++ match through an authenticated historical
compiler route. A C-only source split is not required to explain this
function.

The public decomp.me `ido7.1_c++` preset still uses NCC/EDG, so it cannot show
this result without a new legacy-cfront/IRIX4 compiler preset. That hosting
limitation does not change the static object identity established above.
