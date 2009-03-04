( $ Id: $ )
( Copyright{2000,2002}: Albert van der Horst, HCC FIG Holland by GNU Public License)

This is the archive of the assembler to complement the aiforth and
ciforth Forth implementations.
See http://home.hccnet.nl/a.w.m.van.der.horst/forthimpl.frt
Since ciforth 4.0.5 tools like struct's and bags are no longer needed
in the assembler distribution.

Release 0.2.0 and 0.3.0 are marked REL-0-2-0 and REL-0-2-0 in the RCS archive.
They pass the full regressiontest as specified in the Makefile.
They are based on lina 4.0.6.

From day one the reverse engineering assembler had the property that
disassembly was based on the same tables as assembly, and that disassembled
binaries, could be reassembled to the exact same binary.
This is now complemented by consult files that supply the disassembler with
information to generate a readable and documented source with label names.
Consult files can be built up incrementally.

The files marked * are generated
Sources :

Generic source
asgen.frt      Generic assembler / disassembler.

Antique
ass.frt        The 8086 prototype of the postit/fixup principle
               Blocks, extremely compact, hardly documented,
               no error detection

Plug ins
as80.frt       8080 plug in
asi86.frt      8086 plug in
asi386.frt     80386 plug in
as6809.frt     6809 plug in
asalpha.frt    DEC Alpha plug in


Test sets:
testset8080     8080  testset
testset8086     8086  testset
testset386      386   testset
testset386a     386  testset for SIB byte
testset6809     6809  testset
testsetalpha    alpha testset
asm386endtest   total 386 test (not checked before this release.)

Quick reference cards:
ps.frt         Source that generates postscript
qr8080.ps*     8080
qr8086.ps*     8086
p0.asi386.ps*  80386 main page
p0F.asi386.ps* 80386 instructions starting with 0F

Reverse engineering tool
ciasdis.frt    Main program and glue.
ciasdis*       reverse engineering ``computer intelligence assembler/disassembler''.
cias*          assembler (link to ciasdis)
cidis*         disassembler (link to ciasdis)
crawl.frt      Code crawler: finds code via jumps and calls.
aswrap.frt     Must be loaded before plugin to turn into two pass assembler.
labelas.frt    Make generic assembler into a classic two pass assembler
labeldis.frt   Label database generation for ciasdis (386 specific!)
access.frt     Auxiliary : i.a. memory access w.r.t. target space.

Consult files for ciasdis
elf.cul         Analysis of elf headers
exeheader.cul   Analysis of simple .exe headers (non-Windows)

Test of reverse engineering tool
test.asm       Test: asm --> bin --> asm --> bin
test.cul        Consult file for test.asm
lina405         Test binary: lina 4.0.5
linacrawl.cul   Test: dedicated crawler for ciforth, adapted to lina 4.0.5
lina405equ.cul+ Equ's generated via linacrawl.cul , must be included in lina405.asm
lina405.cul+    Labels's generated via linacrawl.cul , need not be included in lina405.asm
lina405.asm*    Generated from lina405 by 2 preceeding cul files.

+) These files are generated using linacrawl.cul then manually adapted.

Cludges if an OS can't inspect argument 0 (MS stuff)
cias.frt       Main program for assembler
cidis.frt      Main program for disassembler

Layer to turn Forth assembler in classic two pass assembler
Documentation
The suffix ``mi'' is about files to be processed by m4 then texinfo.
assembler.mi
cias.1         manual page for
cul.5          the underlying language for reverse engineering
