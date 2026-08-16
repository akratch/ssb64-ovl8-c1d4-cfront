# decomp.me integration status

## What works today

decomp.me's `ido7.1_c++` preset uses NCC/EDG. The best C1D4 source under that
preset is structurally exact but differs in two temporary-register words.
There is no source-only change that can select the historical cfront/IRIX4
route inside that preset.

For a zero on the existing service, use the downstream C control in
[`../scratch.c`](../scratch.c) with the IDO 7.1 C preset. That demonstrates the
target code but does not establish the original language or compiler route.

The historically supported result is the C++ source in
[`scratch.cxx`](scratch.cxx). It is already proven exact locally with the
period route below; decomp.me needs a separate preset before it can reproduce
that result.

## Required historical preset

The evidence-backed preset should model MIPSpro C++ 7.1:

```text
OCC -irix4
  -> IRIX4 acpp in C++ mode
  -> /usr/irix4/usr/lib/c++/cfront 3.0.1
  -> IRIX4 accom
  -> IDO 7.1 uopt / ugen / as1
```

The preset must be implemented as a separate compiler entry. It should not
replace or masquerade as `ido7.1_c++`, because NCC/EDG and legacy cfront are
different frontends. decomp.me already has the IDO 7.1/IRIX4 `accom` component;
the missing stage is the exact IRIX4 legacy cfront route identified by the
authentic driver transcript.

Once deployed:

1. import the original `mdYYe` scratch or exported ZIP;
2. select the new legacy-cfront/IRIX4 compiler;
3. retain `-O2 -mips2`;
4. paste [`scratch.cxx`](scratch.cxx), preserving its leading blank lines and
   physical backslash-newline splices;
5. compile; the expected function result is zero words.

The authoritative stage order and binary provenance are in
[`../evidence/OCC-IRIX4-DRIVER.txt`](../evidence/OCC-IRIX4-DRIVER.txt) and
[`../docs/COMPILER-PROVENANCE.md`](../docs/COMPILER-PROVENANCE.md). This branch
does not include an earlier experimental wrapper because it used a different
final C frontend and would obscure the route now supported by the evidence.

No proprietary compiler binary is stored in this repository.
