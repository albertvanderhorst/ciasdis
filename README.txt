This is the CVS archive of ciasdis, the ci assembler disassembler,
(or possibly a git copy of the cvs archive).

From
"
 The package ciasdis contains an assembler-disassembler
 combination that allows to reassemble to a byte-for-byte
 same binary. This is useful for modifying programs where
 the source was lost, analysing viruses, etc. and general
 curiosity. Knowledge about a binary can be build up
 automatically, using scripts, or interactively and can be
 stored for continued use in .cul files.
 .
 The assembler chapter of the ciforth documentation is all but
 mandatory. For cross assembling to other targets, such as
 DEC Alpha or M6809, use the source package.
"

In order to build ciasdis:
  make ciasdis FORTH=<ciforth-path>
FORTH shall on Linux contain the path of lina. The default for FORTH is
./lina.
FORTH shall on MS-Windows Linux contain the path of wina.
In the following ciforth refers to lina lina64 wina wina64 whatever
is appropriate for you OS.

In order to do a regressiontest:
  make regressiontest
which include Intel's 8086, 80386,Pentium I, the 8080, the 6809 and
the DEC Alpha and for Pentium the disassembly and reassembly of 3
executables.

In order to install
  make install INSTALL_DIR=<debian-install-path>
If the installation is not to a proposed .deb archive,
debian-related lines in the Makefile must be removed.
Binary installation involves only two files, one being
optional. The remainder of the files is documentation and examples.

Hex code sheets in Postscript format:
inspect the targets with extension .ps in the Makefile.

Actual reverse engineering.
For actual reverse engineering you must study the man page of
ciasdis, as well as the man page of cul, the consult file format.
Consult files are the scripts that accumulate the knowledge gained
through reverse engineering, and govern the actual diassembly.
Assembly mnemonics are redesigned for reverse engineering.
A guide is found in the ciforth documentation.

The binary is for Intel Pentium only.
For other processors you must load the assembler from within ciforth,
then proceed as with a a compiled binary.
