# Maintainer summary

`func_ovl8_8037C1D4` has a proper zero-difference C++ match through the
authentic MIPSpro C++ 7.1 legacy-cfront route.

The source is valid C++ and exports the expected mangled symbol. It passes
through the `cfront` supplied on SGI's November 1996 MIPSpro C++ 7.1 CD, then
through the project's IDO 7.1 C backend. The resulting function is exactly 60
instructions / `0xF0` bytes, with zero opcode, register, schedule, or raw-word
differences.

The supported integration is a third C++ split at C1D4:

- retain the first IRIX4 region;
- retain the established IDO 7.1 NCC C++ region;
- compile C1D4 alone with MIPSpro C++ 7.1 legacy cfront.

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
7.1 C-stage control. The ZIP's ordinary NCC preset does not match that file
because decomp.me currently has no legacy-cfront preset.

Compiler provenance is now direct: the recovered 7.1 translator is distinct
from the earlier 7.4.4 binary, has a November 12, 1996 SGI build stamp, and
emits the exact same generated C byte for byte. Its final 240-byte function is
identical to the target, SHA-1
`6d2d054e964a274495bcc9953cf5b9cd340f7bcb`.

Start with [the integration note](docs/INTEGRATION.md), then use the
[exact-match receipt](evidence/EXACT-MATCH.md) and
[compiler provenance](docs/COMPILER-PROVENANCE.md) for review.
