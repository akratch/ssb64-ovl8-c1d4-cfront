# Authentic MIPSpro C++ 7.1 receipt

## Source media

The missing legacy translator was recovered from:

```text
SGI part: 812-0400-005
product:  MIPSpro C++ 7.1
date:     November 1996
systems:  IRIX 6.2, 6.3, and 6.4
```

The archival distribution is available as a
[filesystem tar](https://jrra.zone/sgi/tar/MIPSpro%20C%2b%2b%207.1.tar)
and an [ISO](https://jrra.zone/sgi/cds/MIPSpro%20C%2b%2b%207.1.iso).
The [catalog](https://jrra.zone/sgi/index-with-ids.html) records the SGI part
number and date. SGI's own
[installation table](https://techpubs.jurassic.nl/library/manuals/2000/007-2852-002/sgi_html/apa.html)
maps `c++_dev` to the MIPSpro C++ 7.1 CD.

The downloaded filesystem tar was assembled and checked before extraction:

```text
bytes:   505663488
MD5:     4ce49331d9dbc93e09d107597286cff3
SHA-256: 91e386a0e5509488f734e05d3833ca8cd66d117b18dcff28150d39aa29a6400a
```

Its `RELEASE.info` identifies `c++_dev` as C++ 7.1 for IRIX 6.2. The
`c++_dev.idb` inventory places the legacy tools in subsystem
`c++_dev.sw.c++`.

## Extracted tools

```text
c569d619b3711860dd2f9a8d783f53bb54dafa00658a1eaaf93cff68975ae0af  usr/lib/acpp
7f889ad27e8c0c0005580650a347a1b9afcbc95afb8d0c6707584b3b3c7379f0  usr/lib/OCC
173f6cf0dfeba2b667c83a650f83e0ccc4612365455957ce27bf60d42576e157  usr/lib/c++/cfront
```

The recovered `cfront` is an ELF32 big-endian MIPS-II IRIX executable. Its
embedded identifiers are:

```text
AT&T USL C++ Language System <3.0.1> 02/03/92
IRIX 6.4:1263370533 built 11/12/96
```

For comparison, the previously tested 7.4.4 cfront has SHA-256
`9904ad5c2b51563839be78acbb1e00aa015ca19d0b69d5b2f44522eade16e3d4`.
The two executables are not the same binary.

## Translation result

The exact C++ source was preprocessed by the matching 7.1 `acpp`:

```sh
acpp -+ input-exact.C > generated/input-exact.i
```

Here `input-exact.C` is a staged copy of `src/func_ovl8_8037C1D4.C`; the name
is preserved because cfront includes source attribution in its output. The
preprocessor output is byte-for-byte identical to the checked-in 1,176-byte input,
SHA-256
`dcb2abeb37bd78784147d91120865f76a49af1ec699e08ad27dab00928c92c08`.
The authentic 7.1 translator was then invoked with the original filename
attribution:

```sh
cfront +finput-exact.C < generated/input-exact.i > generated/cfront-output.c
```

The resulting C file is 1,794 bytes and has SHA-256:

```text
8aeeda992c66f6d2195f38fff78d122ab306740b31b33c37d60e17ca6ce32bc3
```

It is byte-for-byte identical to the checked-in generated C and to the output
of the independently tested 7.4.4 translator.

A fresh sequential `cfe -> uopt -> ugen -> as1` build with the project IDO 7.1
backend produced exactly 240 function bytes. The candidate and target both
have SHA-1:

```text
6d2d054e964a274495bcc9953cf5b9cd340f7bcb
```

No generated program was executed. All comparison was static.

## Distribution note

MIPSpro is proprietary software. This repository records hashes, source media,
and generated evidence, but does not redistribute SGI compiler binaries.
