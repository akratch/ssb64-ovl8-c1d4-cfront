# Maintainer summary

`func_ovl8_8037C1D4` has an exact C match, a two-word ordinary NCC C++
residual, and an exact legacy-cfront experiment. It does not yet have a
zero-difference `ido7.1_c++` NCC match.

The legacy-cfront source is valid C++ and exports the expected mangled symbol.
It passes through SGI's cfront 3.0.1 translator, then through the project's IDO
7.1 C backend. The resulting function is exactly 60 instructions / `0xF0`
bytes, with zero opcode, register, schedule, or raw-word differences. This is a
compiler-mechanism result, not a conventional NCC or hosted decomp.me match.

The conservative integration is a third C split at C1D4:

- retain the first IRIX4 region;
- retain the established IDO 7.1 NCC C++ region;
- compile C1D4 alone as C with the stock IDO 7.1 C frontend.

The narrow split matters. A surrounding NCC anchor, `func_ovl8_8037B760`, was
compiled through the same cfront route and failed structurally (32 instructions
versus the ROM's 36, with 27 opcode differences). The result does not imply
that the whole second region should use cfront.

Two physical backslash-newline splices in the source are required. Removing
them retains the instruction multiset but leaves eight schedule differences.
The unused local and explicit post-decrement temporaries are likewise part of
the tested source geometry.

The repository root also contains `scratch.c`, freshly verified against the
exported challenge ZIP's exact context and target. It is the downstream IDO
7.1 C-stage zero. The ZIP's ordinary NCC preset does not match that file.

The only provenance caveat is the translator package. The local IDO 7.1
extraction omitted its optional OCC/cfront subsystem, so the exact receipt uses
an authentic IRIX 7.4.4 cfront binary whose emitted banner identifies the same
AT&T USL cfront 3.0.1 translator, followed by the target IDO 7.1 backend. A
complete 7.1 OCC/cfront package would be required before promoting the cfront
experiment from provenance evidence to a stronger production claim.

Start with [the integration note](docs/INTEGRATION.md), then use the
[exact-match receipt](evidence/EXACT-MATCH.md) and
[compiler provenance](docs/COMPILER-PROVENANCE.md) for review.
