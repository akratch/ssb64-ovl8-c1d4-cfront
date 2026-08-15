# Compiler provenance

> **Status:** Authentic MIPSpro C++ 7.1 legacy cfront reproduces the function
> exactly. This compiler route is not currently available on decomp.me.

## Proven route

The exact object was produced in two compiler stages:

1. The legacy C++ translator from MIPSpro C++ 7.1 converted
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

## Authentic 7.1 acquisition

The translator was recovered from SGI part `812-0400-005`, **MIPSpro C++
7.1**, November 1996. The distribution identifies its compiler subsystem as
`c++_dev.sw.c++` and contains `usr/lib/OCC` and
`usr/lib/c++/{cfront,markc++,ptcomp,ptlink}`.

The complete archival filesystem tar was 505,663,488 bytes:

```text
MD5     4ce49331d9dbc93e09d107597286cff3
SHA-256 91e386a0e5509488f734e05d3833ca8cd66d117b18dcff28150d39aa29a6400a
```

The extracted 7.1 translator is a big-endian MIPS-II IRIX executable with:

```text
SHA-256 173f6cf0dfeba2b667c83a650f83e0ccc4612365455957ce27bf60d42576e157
banner  AT&T USL C++ Language System <3.0.1> 02/03/92
stamp   IRIX 6.4:1263370533 built 11/12/96
```

The matching 7.1 `acpp` has SHA-256
`c569d619b3711860dd2f9a8d783f53bb54dafa00658a1eaaf93cff68975ae0af`
and produces the checked-in 1,176-byte preprocessed input byte for byte.

The 7.1 cfront binary is distinct from the later 7.4.4 binary. Nevertheless,
both translate this source to the exact same 1,794-byte C file, SHA-256
`8aeeda992c66f6d2195f38fff78d122ab306740b31b33c37d60e17ca6ce32bc3`.

The archival catalog and direct media are linked in
[the authentic receipt](../evidence/AUTHENTIC-71.md). MIPSpro remains
proprietary software; no compiler binary is distributed here.

## Tool receipt

| Component | Receipt SHA-256 |
|---|---|
| MIPSpro 7.1 `acpp` | `c569d619b3711860dd2f9a8d783f53bb54dafa00658a1eaaf93cff68975ae0af` |
| MIPSpro C++ 7.1 `OCC` | `7f889ad27e8c0c0005580650a347a1b9afcbc95afb8d0c6707584b3b3c7379f0` |
| MIPSpro C++ 7.1 `cfront` | `173f6cf0dfeba2b667c83a650f83e0ccc4612365455957ce27bf60d42576e157` |
| IRIX 6.0 O32 `libC.so` | `6017cc3bc1ea7b1793425b19456b3cbc87d80393011f70fa50b12f5ae3fc0cea` |
| Project IDO 7.1 `cc` wrapper | `fdc7cbaa936e11b731c9b50118d106efae71a299d59f1e8e2cd126306acbf78f` |

These proprietary components are identified for provenance only and are not
part of this repository.

## Runtime note

`libC.so` belongs to the separate IRIX C++ execution-environment product, not
the `c++_dev` compiler CD. The translator was run in an ephemeral IRIX root
using an authentic O32 `libC.so` from the local IRIX 6.0 package. That shared
library only allows the translator executable to start; the recovered 7.1
translator itself produced the generated C. All target code generation used
the IDO 7.1 C pipeline.

## What the receipt establishes

It establishes a complete, exact C++ compiler route using the authentic 7.1
translator and the target IDO 7.1 backend. It does not by itself prove which
per-file compiler flags HAL used, but it removes the former 7.4.4-version
caveat and satisfies the matching requirement.

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
- [SGI media catalog](https://jrra.zone/sgi/index-with-ids.html)
- [SGI installation table](https://techpubs.jurassic.nl/library/manuals/2000/007-2852-002/sgi_html/apa.html)
