# Maintainer handoff

## Did the comment help?

Yes. The maintainer suggested that a C++ build capable of producing the
four-case jump tables might explain more of the overlay than a separate IRIX4
region, and asked whether the MIPSpro route could emit those tables.

It identified the right missing experiment. We had been treating the C++ and
IRIX4 results as alternatives. Running authentic MIPSpro C++ 7.1 `OCC -irix4`
showed that they are one historical driver route: cfront translates the C++,
then `cc -irix4` selects `accom`, followed by the 7.1 optimizer/backend.

It also led directly to checking the whole object rather than only C1D4. That
check found all four dense four-entry jump tables under the same route.

## Answer

Yes. The historical MIPSpro route produces the four-case jump tables, and it
also gives `func_ovl8_8037C1D4` a proper byte-perfect C++ match.

The key is that “C++” and “IRIX4 `accom`” are not competing explanations.
Authentic MIPSpro C++ 7.1 `OCC -irix4` prints this pipeline:

```text
/usr/irix4/usr/lib/acpp
/usr/irix4/usr/lib/c++/cfront
/usr/bin/cc ... -irix4 -nocpp
```

The final driver step selects the IRIX4 `accom` frontend before the IDO 7.1
optimizer/backend. This is one supported C++ compiler configuration.

## Direct measurements

- C1D4: 60 instructions, 240 bytes, zero differing words.
- Whole current catalog: 64 of 74 compiled functions are instruction-word
  exact; BF68 was omitted for one old-parser source incompatibility.
- Jump-table section: `0x50` bytes with 16 `R_MIPS_32` entries, arranged as
  four dense four-entry tables.
- `803773CC`, `803781A4`, and `80379D74`: zero instruction-word differences.
- `80379070`: emits the fourth dense table and the correct 524-instruction
  function size, but the current cfront source spelling remains 179 words off.

That last result is important: it proves capability and table geometry, not a
finished one-compiler reconstruction for every function.

## Provenance

The `OCC` driver came from authentic MIPSpro C++ 7.1 media. The exact
`/usr/irix4/usr/lib/c++/cfront` named by the driver came from SGI C++
Translator 3.2's `irix4_c++` compatibility product and is byte-identical to
the standalone C++ Translator 3.0.1 executable. The IRIX4 C frontend came from
IRIS Development Option 5.1.

The repository includes hashes, generated C, static objects, the exact driver
transcript, and the whole-object census. It does not redistribute SGI tools or
ROM-derived targets.

## Recommendation

Do not add a third C file at C1D4 merely to make the function match. The exact
C++ source and a historically coherent compiler route now exist.

Also do not claim yet that every `ovl8_8` function is proven to use one
compiler. The unified route is now a strong candidate, but the remaining
source residues—especially `80379070`, `8037ACAC`, and `8037B760`—still need
to be closed under that route before changing the overlay's final splits.

## Suggested reply

> That suggestion helped a lot—it exposed the missing compiler route. MIPSpro
> C++ 7.1 `OCC -irix4` does not choose between C++ and IRIX4: it runs the IRIX4
> preprocessor, translates the C++ with legacy cfront, then invokes
> `cc -irix4`/`accom` before the 7.1 backend. Using the exact period components,
> C1D4 is now a proper C++ zero: 60 instructions / 240 bytes with no differing
> words. I also checked the jump-table question directly. The same route emits
> all four dense four-entry tables; three table functions are instruction-exact,
> and 80379070 has the correct 524-instruction/table shape but still has source
> residue. The current whole-source census is 64/74 exact, with BF68 omitted for
> an old-parser incompatibility. So your one-C++-route theory is now strongly
> supported, and there is no reason to add a fake C split for C1D4. I would stop
> just short of calling the whole overlay proven until the remaining source
> residues close. The repo contains the exact object, source, driver transcript,
> hashes, jump-table receipt, and census.
