# Why the ordinary NCC route stopped at two words

Before the cfront result, the best IDO 7.1 NCC source already had the correct
60-instruction shape. It differed in only two instruction words:

```text
target:    negu  t0,a2
target:    andi  t0,t0,0xff

NCC best:  negu  t2,a2
NCC best:  andi  t0,t2,0xff
```

Every other instruction, register, branch, delay slot, and loop schedule was
exact.

## Optimizer diagnosis

The register choice appears in `uopt` output, before UGEN. The relevant NCC
webs are:

- an anonymous unary-negation producer, allocated to `t2`;
- the narrowed true-branch `run_length`, allocated to `t0`.

The named result is the producer's only already-colored `t0` neighbor. The ROM
requires the negation and narrowing to share `t0`; NCC represents them as two
interfering ranges.

Forcing the producer to another legal register changes exactly the two words
above. Forcing the named result away from `t0` makes the producer fall into
`t0`, which confirms the interference relationship. Attempts to assign both
current webs to `t0` violate optimizer graph invariants: the frontend must
create one propagated value rather than two conflicting values.

## Closed compiler axes

The same two-word result was reproduced through UOPT 4.1, 5.3, 6.0, 7.1, and
7.4.4, each followed by the IDO 7.1 backend. It also survived the authenticated
NCC compatibility and language controls tested for this function, including
`+p`, `+pp`, `-signed`, and plain `char`.

Source experiments covered declaration order and scope, integer widths,
casts, nested and split assignments, explicit masks, branch-phi locals,
references, wrappers, templates, macros, source-line placement, equivalent
CFG spellings, and controlled register-pressure variants. Shape-preserving
forms converged to the same two-word allocation or moved the producer forward
through `t1`/`t3`/`t4`/`t5`; none produced `t0 -> t0`.

## Why cfront succeeds

The exact cfront-generated C passes the unary-negation and byte-narrowing
expression directly into the named result web. The separate anonymous producer
seen in NCC is absent. The IDO C optimizer can therefore keep the complete
chain in `t0`.

This is a frontend-lowering distinction, not an unresolved algorithm or loop
reconstruction issue. The legacy cfront result supplies the missing C++
provenance without an allocator hack.
