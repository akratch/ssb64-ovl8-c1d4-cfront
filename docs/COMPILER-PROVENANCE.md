# Compiler provenance

## Proven route

The exact object was produced in two compiler stages:

1. SGI's legacy C++ translator converted
   `src/func_ovl8_8037C1D4.C` into `generated/cfront-output.c`.
2. The generated C was compiled by the project's IDO 7.1 C pipeline
   (`cfe -> uopt -> ugen -> as1`) at `-O2` for big-endian MIPS-II O32.

The translator identifies itself in the generated file as:

```text
AT&T USL C++ Language System <3.0.1> 02/03/92
```

The final relocatable object contains one 240-byte function:

```text
func_ovl8_8037C1D4__FPPUcT1l
```

## Tool receipt

| Component | Receipt SHA-256 |
|---|---|
| IRIX 7.4.4 `acpp` | `ef9c554e2ede3fb81998dd7917abb416bd0f7be7e05a1dc55bf00970ea52b915` |
| IRIX 7.4.4 `cfront` | `9904ad5c2b51563839be78acbb1e00aa015ca19d0b69d5b2f44522eade16e3d4` |
| IRIX 6.0 O32 `libC.so` | `6017cc3bc1ea7b1793425b19456b3cbc87d80393011f70fa50b12f5ae3fc0cea` |
| Project IDO 7.1 `cc` wrapper | `fdc7cbaa936e11b731c9b50118d106efae71a299d59f1e8e2cd126306acbf78f` |

These proprietary components are identified for provenance only and are not
part of this repository.

## Packaging caveat

The available local IDO 7.1 extraction lacked the optional OCC/cfront files.
The authentic cfront binary available locally was from an IRIX 7.4.4 package.
That package's `usr/lib/libC.so` was a zero-byte placeholder, so cfront was run
in an ephemeral IRIX root containing the authentic O32 `libC.so` from the 6.0
package. The archived compiler trees were not modified.

This runtime substitution only allowed the translator to start. The generated
C is checked in and identifies the translator version directly. All target
code generation used the IDO 7.1 C pipeline.

## What the receipt establishes

It establishes that a documented legacy-cfront C++ route can produce the exact
function and expected C++ linkage. It does not establish that the original
build used the specific 7.4.4 executable copied in this experiment.

The strongest remaining provenance check is to repeat the translation with a
complete IDO 7.1 OCC/cfront installation. Any result should be recorded with
the translator banner, binary hashes, generated-C hash, and final function
hash.

## Source and artifact hashes

| File | SHA-256 |
|---|---|
| Exact C++ source | `d4d22a92e0a063e018871965aa8af8733f28d7454a31a18de3b85f8af894c047` |
| Preprocessed cfront input | `dcb2abeb37bd78784147d91120865f76a49af1ec699e08ad27dab00928c92c08` |
| Generated cfront C | `8aeeda992c66f6d2195f38fff78d122ab306740b31b33c37d60e17ca6ce32bc3` |
| Unstripped build object | `520b17c334339a068093604932e3258ae0cbcffc252f8e81cae17fdd6dbc7f5c` |
| Public object (`.mdebug` removed) | `e3dfd21abb1f880443eb0f66d3b7a87acb83464e0709a1ccfd4c40d38f1c002e` |

The extracted 240-byte `.text` has SHA-1
`6d2d054e964a274495bcc9953cf5b9cd340f7bcb`, identical to the target function.
The public object differs from the build receipt only by removal of `.mdebug`,
which contained a local build path; its `.text`, symbol, MIPS options, and
register metadata are unchanged.

## Historical references

- [SGI C++ release notes](https://archive.irixnet.org/siliconsurf/tech/relnotes/6_0rel/cpp_dev.html)
- [IRIX 5.3 CC/NCC manual](https://techpubs.jurassic.nl/manpages_0530/cat1/CC.html)
