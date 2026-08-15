# decomp.me compiler integration

The current decomp.me `ido7.1_c++` preset runs NCC/EDG. C1D4's exact C++
result uses the different, historically supported MIPSpro 7.1 legacy-cfront
route. It therefore needs a separate compiler ID, proposed as
`ido7.1_cfront`.

## Verified wrapper

[`cc-cfront`](cc-cfront) performs the same stages as the matching local
receipt:

```text
IDO 7.1 acpp
-> authentic MIPSpro C++ 7.1 cfront
-> IDO 7.1 cc backend
```

The wrapper accepts the same basic driver form used by decomp.me:

```sh
cc-cfront -c -G0 -non_shared -32 -O2 -mips2 -o output.o input.cxx
```

It forwards `-D`, `-U`, and `-I` options to the preprocessor and sends the
remaining driver flags to the IDO 7.1 C backend. The input source must be the
last argument.

The package layout is:

```text
ido7.1_cfront/
  acpp, cc, cfe, uopt, ugen, as1, ...
  cc-cfront
  qemu-irix
  irix/
    lib/{rld,libc.so.1,libmalloc.so}
    usr/lib/libC.so
    usr/lib/libc.so.1
    usr/lib/c++/cfront
```

[`build-local-package.sh`](build-local-package.sh) assembles this layout from
an IDO 7.1 static-recomp package, the extracted MIPSpro C++ 7.1 product, an
IRIX runtime root containing qemu and loader libraries, and the O32 `libC.so`
runtime. It verifies the authentic cfront hash before accepting the package.
No proprietary files are stored in this repository.

## Hosted-style match receipt

The wrapper was invoked on the exact decomp.me composition:

```text
#line 1 "ctx.c"
<219,539-byte ctx.c++ from the challenge ZIP>
#line 1 "src.cxx"
<decompme/scratch.cxx>
```

Using `-O2 -mips2` and the standard IDO O32 driver flags produced:

```text
candidate .text: 240 bytes
target function: 240 bytes
candidate SHA-1: 6d2d054e964a274495bcc9953cf5b9cd340f7bcb
target SHA-1:    6d2d054e964a274495bcc9953cf5b9cd340f7bcb
```

This is the source to paste into an `ido7.1_cfront` scratch after the preset is
deployed:
[`scratch.cxx`](scratch.cxx). Its five leading blank lines and two physical
backslash-newline splices are intentional.

## Ready-to-apply patches

Two format-patch files are included:

- [`decompme-compilers.patch`](../patches/decompme-compilers.patch), based on
  `decompme/compilers` commit `9083bacade9276cf6b48a5a628adcbeee53499a6`;
- [`decompme-app.patch`](../patches/decompme-app.patch), based on
  `decompme/decomp.me` commit `95329db504c88750fa932c81fd405834ffb372d8`.

The compiler patch downloads only the two required `c++_dev` byte ranges from
the uncompressed archival media tar (9,314,839 bytes total), verifies both by
SHA-256, extracts only `cfront`, and assembles a minimal compiler directory.
No SGI binary is committed to either patch or this repository.

The generated image was built and then used with the exact exported `mdYYe`
context, source composition, flags, and target. The result was byte-identical;
see [`DECOMPME-IMAGE.md`](../evidence/DECOMPME-IMAGE.md).

## Application changes

decomp.me needs three small application changes:

1. Define an `IDOCompiler` named `ido7.1_cfront`, based on IDO 7.1 and using
   `Language.OLD_CXX`.
2. Add its compiler image to the N64 Linux compiler list.
3. Add a UI label such as `IDO 7.1 C++ (legacy cfront)`.

The compiler image is built from archival media at deployment time because
MIPSpro is proprietary. The source media and exact tool hashes are recorded in
[`AUTHENTIC-71.md`](../evidence/AUTHENTIC-71.md).

## Creating the hosted scratch

Once both patches are deployed:

1. Import the original `mdYYe` scratch or its exported ZIP.
2. Select `IDO 7.1 C++ (legacy cfront)`.
3. Keep flags `-O2 -mips2`.
4. Replace only the source pane with [`scratch.cxx`](scratch.cxx), preserving
   its leading blank lines and trailing backslashes.
5. Compile. The expected score is zero.

Until the new preset is deployed, ordinary `IDO 7.1 C++` continues to use NCC
and cannot host this exact result.
