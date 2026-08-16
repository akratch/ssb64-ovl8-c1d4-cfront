# Compiler provenance

## Driver proof

MIPSpro C++ 7.1's authentic `OCC` driver was invoked in dry-run mode with:

```sh
OCC -v -n -c -O2 -mips2 -irix4 input.C
```

It selected:

```text
/usr/irix4/usr/lib/acpp
/usr/irix4/usr/lib/c++/cfront
/usr/bin/cc -xansi ... -O2 -mips2 -irix4 -nocpp ...
```

The complete output is checked in as
[`evidence/OCC-IRIX4-DRIVER.txt`](../evidence/OCC-IRIX4-DRIVER.txt). This is
direct evidence that legacy C++ translation and the IRIX4 C frontend were one
supported compiler route.

SGI's C++ documentation describes `OCC` as the cfront driver and documents
`CC -use_cfront` as the equivalent route:

- [Understanding the Silicon Graphics C++ Environment](https://techpubs.jurassic.nl/library/manuals/0000/007-0704-070/sgi_html/ch01.html)
- [IRIX 5.3 OCC(1)](https://techpubs.jurassic.nl/manpages_0530/cat1/OCC.html)

## Exact IRIX4 tools

### C++ translator

The exact path named by `OCC -irix4` was recovered from SGI C++ Translator
3.2 media, part `812-0130-003`, inside the `irix4_c++` compatibility product:

```text
/usr/irix4/usr/lib/c++/cfront
SHA-256 7bd7e85fd5b029392caffa2c32e52779a826706116f1df5f3e14eb61448e202e
```

This executable is byte-identical to the `cfront` on the independently
archived C++ Translator 3.0.1 media, part `812-0001-005`. It identifies itself
in generated output as:

```text
AT&T USL C++ Language System <3.0.1> 02/03/92
```

Published media receipts:

```text
C++ Translator 3.2 ISO SHA-256
be4e149e845ae8ddee1d1efce7d95b0f2ab29a8c7312f40bbcf034995fd3444f

C++ Translator 3.0.1 ISO SHA-256
8815a92e77280201f055ea240c1ec2765791e12c99876748915b31abae28bb7f
```

The [SGI media catalog](https://jrra.zone/sgi/index-with-ids.html) records both
part numbers and hashes.

### IRIX4-compatible C frontend

The IRIX4 `acpp`/`accom` frontend was recovered from IRIS Development Option
5.1, part `812-0129-003`:

```text
ISO SHA-256
98a0eccec99cb7b06f787f3b16917386f7785133ae197c27d32eff78b9211776
```

The local ISO hash matches the published catalog exactly. Extracting the
`IRIX4/irix4_c` product produced binaries byte-identical to the frontend used
for the exact build:

```text
acpp  SHA-256 1d11da809d1a7f7bc2130d8f7fcd81ac5aa1c423c2f94b7617eaa132b962ef98
accom SHA-256 f7255b029d79d49edea98079f56f80a32922532418d694d64b09703d2695bda6
```

### MIPSpro C++ 7.1 driver

The driver came from SGI MIPSpro C++ 7.1 media, part `812-0400-005`:

```text
OCC SHA-256
7f889ad27e8c0c0005580650a347a1b9afcbc95afb8d0c6707584b3b3c7379f0
```

The same media also contains a later-built cfront 3.0.1 binary, but `-irix4`
explicitly selects the compatibility path under `/usr/irix4`. The exact result
therefore uses the old path named by the driver, not the default 7.1 cfront.

## Code-generation stages

For the static receipt, the exact historical frontend stages produced C and
ucode, followed by the project's IDO 7.1 `uopt`, `ugen`, and `as1` passes. The
faithful `accom` options were recovered from the reconstructed IDO 7.1 driver:

```text
-Xv -w -XNh8000 -mips2 -EB -Xg0 -O2 -Xprototypes -Xxansi
```

With those options, C1D4 is instruction-word exact. Omitting the full driver
option set had previously left four schedule differences, which is why the
driver-level reconstruction mattered.

## Exact C1D4 hashes

| Artifact | SHA-256 |
|---|---|
| C++ source | `d4d22a92e0a063e018871965aa8af8733f28d7454a31a18de3b85f8af894c047` |
| exact IRIX4 cfront | `7bd7e85fd5b029392caffa2c32e52779a826706116f1df5f3e14eb61448e202e` |
| generated C | `8aa3d3343711a189499dea5484a018d31d0972b2d03a1c6f26cfbae9cb375d20` |
| public reference object | `8a9fc764a7b45ab3df50b6c69e726e90e2549aeec05700c3ae764b0463f190df` |

The 240-byte function body has SHA-1
`6d2d054e964a274495bcc9953cf5b9cd340f7bcb`, identical to the target.

## Distribution and safety

MIPSpro and IDO are proprietary. This repository records source media, hashes,
driver output, generated C, and static target-code evidence without
redistributing compiler binaries. No generated target program was executed.
