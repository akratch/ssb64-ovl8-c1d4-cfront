# Maintainer note

You were right to question the split. The actual historical route makes the
C++ and IRIX4 observations compatible: MIPSpro C++ 7.1 `OCC -irix4` invokes
the IRIX4 preprocessor, legacy cfront, and then `cc -irix4` (`accom`) before
the IDO 7.1 optimizer/backend.

Using the exact period tools, `func_ovl8_8037C1D4` is a proper C++ zero: 60
instructions / 240 bytes with no differing words.

The same route emits all four dense four-entry jump tables. Three table
functions are already instruction-exact. `func_ovl8_80379070` emits the fourth
table and the correct 524-instruction shape, but its current source remains
179 words off after cfront, so that is source work rather than a table-capability
failure.

A current whole-source census is 64 exact functions out of 74 compiled. BF68
was omitted because its reconstructed spelling is not accepted by the 1992
parser. This is strong evidence for a unified historical C++/IRIX4 route, but
not yet proof that every function used it.

I would therefore avoid a third C split at C1D4. I would also hold off on
changing the whole overlay to one compiler until the remaining source residues
are closed. The repository contains the authentic driver transcript, exact
C1D4 source/object, tool and media hashes, jump-table evidence, and the full
census.
