# Authentic MIPSpro C++ 7.1 driver receipt

## Source media

```text
SGI part: 812-0400-005
product:  MIPSpro C++ 7.1
date:     November 1996
systems:  IRIX 6.2, 6.3, and 6.4
```

The distribution contains `usr/lib/OCC`, the default 7.1 C++ frontends, and
the documented legacy-cfront route. The extracted driver has:

```text
OCC SHA-256
7f889ad27e8c0c0005580650a347a1b9afcbc95afb8d0c6707584b3b3c7379f0
```

The public archival catalog and media are available at:

- [SGI media catalog](https://jrra.zone/sgi/index-with-ids.html)
- [MIPSpro C++ 7.1 ISO](https://jrra.zone/sgi/cds/MIPSpro%20C%2b%2b%207.1.iso)
- [MIPSpro C++ 7.1 filesystem tar](https://jrra.zone/sgi/tar/MIPSpro%20C%2b%2b%207.1.tar)

## Driver result

The authentic driver was run without compilation:

```sh
OCC -v -n -c -O2 -mips2 -irix4 input.C
```

It printed the IRIX4 C++ compatibility route exactly:

```text
/usr/irix4/usr/lib/acpp
/usr/irix4/usr/lib/c++/cfront
/usr/bin/cc ... -O2 -mips2 -irix4 -nocpp ...
```

See [`OCC-IRIX4-DRIVER.txt`](OCC-IRIX4-DRIVER.txt) for the unabridged output.

This establishes that cfront and IRIX4 `accom` belong to one supported C++
compiler configuration. The exact compatibility binaries and media hashes are
recorded in [Compiler provenance](../docs/COMPILER-PROVENANCE.md).

## Distribution note

MIPSpro is proprietary. This repository records the public media location,
hashes, and driver output but does not redistribute compiler binaries.
