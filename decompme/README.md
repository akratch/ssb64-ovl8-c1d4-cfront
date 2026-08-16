# decomp.me integration status

## Current public preset

decomp.me's `ido7.1_c++` preset uses NCC/EDG. The best C1D4 source under that
preset is structurally exact but differs in two temporary-register words.
There is no source-only change that can select the historical cfront/IRIX4
route inside that preset.

## Required historical preset

The evidence-backed preset should model MIPSpro C++ 7.1:

```text
OCC -irix4
  -> IRIX4 acpp in C++ mode
  -> /usr/irix4/usr/lib/c++/cfront 3.0.1
  -> IRIX4 accom
  -> IDO 7.1 uopt / ugen / as1
```

decomp.me already carries the component logic for IDO 7.1 with the IRIX4
`accom` frontend. The remaining integration is to place legacy cfront before
that route and expose a distinct OLD_CXX compiler ID.

Once deployed:

1. import the original `mdYYe` scratch or exported ZIP;
2. select the new legacy-cfront/IRIX4 compiler;
3. retain `-O2 -mips2`;
4. paste [`scratch.cxx`](scratch.cxx), preserving its leading blank lines and
   physical backslash-newline splices;
5. compile; the expected function result is zero words.

## Existing prototype

[`cc-cfront`](cc-cfront), [`build-local-package.sh`](build-local-package.sh),
and the two patch files under `patches/` are the earlier hosted prototype. That
prototype proved that decomp.me can host cfront and reproduced the scratch at
zero, but it sent generated C through the ordinary IDO 7.1 C frontend.

The authentic `OCC -irix4` transcript found later is a stronger provenance
result. The prototype patches are retained as implementation reference, not as
the final upstream recommendation. Before submission, replace their final C
stage with decomp.me's existing IRIX4 `accom` wrapper and source the exact
`irix4_c++` cfront identified in
[`docs/COMPILER-PROVENANCE.md`](../docs/COMPILER-PROVENANCE.md).

No proprietary compiler binary is stored in this repository.
