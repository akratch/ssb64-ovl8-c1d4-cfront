# decomp.me compiler-image receipt

> **Historical prototype:** this image proves hosted cfront integration and an
> exact C++ result, but its generated C uses the ordinary IDO 7.1 C frontend.
> The later authentic `OCC -irix4` transcript selects IRIX4 `accom` instead.
> Retain this receipt as an implementation control; revise the final frontend
> before upstreaming the preset.

## Patch bases

```text
decompme/compilers  9083bacade9276cf6b48a5a628adcbeee53499a6
decompme/decomp.me  95329db504c88750fa932c81fd405834ffb372d8
```

The corresponding format-patch files are checked in under `patches/`.

## Media extraction

The image downloads only these data ranges from the uncompressed MIPSpro C++
7.1 filesystem tar:

```text
125260288-125423674  dist/c++_dev.idb  163387 bytes
126331392-135482843  dist/c++_dev.sw   9151452 bytes
```

The exact extracted payload hashes are:

```text
84bba65ed2165ef335b09024b28c80fb5601e54c37255e7cf556c48f99564623  c++_dev.idb
878e6bef1d45a67a9c5aa4e14c7433e2e7dbe01de3f5cef92ebc44c9b9da3531  c++_dev.sw
```

The build then extracts only the `usr/lib/c++/cfront` inventory entry. Every
download used by the custom image is pinned by URL and SHA-256.

## Image build

The generated Dockerfile built successfully for `linux/amd64` from the
`decompme/compilers` patch. The resulting compiler directory contains the IDO
7.1 static-recomp backend, authentic MIPSpro C++ 7.1 cfront, an IRIX userspace
runner and its minimal runtime libraries, and the `cc-cfront` wrapper.

No generated target program was executed.

## Hosted-style reproduction

The compiler image was used on the exact source composition exported by
decomp.me scratch `mdYYe`:

```text
#line 1 "ctx.c"
<219539-byte ctx.c++>
#line 1 "src.cxx"
<decompme/scratch.cxx>
```

The wrapper received decomp.me's standard O32 options plus `-O2 -mips2`:

```text
-c -Xcpluscomm -G0 -non_shared -Wab,-r4300_mul
-woff 649,838,712 -32 -O2 -mips2
```

Static extraction and comparison produced:

```text
candidate .text: 240 bytes
target function: 240 bytes
candidate SHA-1: 6d2d054e964a274495bcc9953cf5b9cd340f7bcb
target SHA-1:    6d2d054e964a274495bcc9953cf5b9cd340f7bcb
byte comparison: identical
```

The full context produces several unused-definition warnings from legacy
cfront. They do not affect the object and are expected for an isolated
decomp.me scratch context.
