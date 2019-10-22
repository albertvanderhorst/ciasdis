( $ Id: $ )
( Copyright{2000,2002}: Albert van der Horst, HCC FIG Holland by GNU Public License)

This is the archive of the assembler to complement the aiforth and
ciforth Forth implementations.
See http://home.hccnet.nl/a.w.m.van.der.horst/forthimpl.frt
The current version of ciasdis is 2.0 and it is based on version
5.3.0 of 32 bits lina and the beta release of 64 bits lina of
2017oct29. To understand the mnemonics you need the documentation of
these Forth's.
(Version 1.0.0 are based on lina 32 bits 4.0.# , some in as a deb package.)

From day one the reverse engineering assembler had the property that
disassembly was based on the same tables as assembly, and that disassembled
binaries, could be reassembled to the exact same binary.
This is complemented by consult files that supply the disassembler with
information to generate a readable and documented source with label names.
Consult files can be built up incrementally.

The files marked % are generated

-----------------SOURCES ----------------------------------------

Generic source
asgen.frt      Generic assembler / disassembler.

Antique
ass.frt        The 8086 prototype of the postit/fixup principle
               Blocks, extremely compact, hardly documented,
               no error detection

Plug ins
as*.frt        Assembler plugins e.g.
asi86.frt      8086 plug in
as*s.frt       Assembler screen version e.g.
as8086s.frt    minimal 8086 assembler

------------- TEST SETS ------------------------------
testset*        Assembler testsets

------------- QUICK REFERENCE ------------------------
ps.frt         Source that generates postscript
qr8080.ps%     8080
qr8086.ps%     8086
p0.asi386.ps%  80386 main page
p0F.asi386.ps% 80386 instructions starting with 0F

---------------- CIASDIS --------------------------
Reverse engineering tool for i86
ciasdis.frt    Main program and glue, uses asgen.frt and
asi386.frt     i86 specific
asipentium.frt i86 specific
crawl.frt      Code crawler: finds code via jumps and calls.
aswrap.frt     Must be loaded before plugin to turn into two pass assembler.
labelas.frt    Make generic assembler into a classic two pass assembler
labeldis.frt   Label database generation for ciasdis (386 specific!)
access.frt     Auxiliary : i.a. memory access w.r.t. target space.
tools.frt      Auxiliary low level

Generated
ciasdis%       reverse engineering
                ``computer intelligence assembler/disassembler''.
cias%         assembler (link to ciasdis)
cidis%         disassembler (link to ciasdis)

--------------------- AUXILIARY ------------------------
Consult files for ciasdis
elf.cul         Analysis of elf headers
exeheader.cul   Analysis of simple .exe headers (non-Windows)

Test of reverse engineering tool

Cludge in behalf of Microsoft
cias.frt       Main program for assembler
cidis.frt      Main program for disassembler

Documentation
[The suffix ``mi'' is about files to be processed by m4 then texinfo.]
assembler.mi   Contained in ciforth/lina documentation.
cias.1         manual page for
cul.5          the underlying language for reverse engineering

Files as a test source and/or to compare with.
testcmp/*
This contains i.a..
test.asm       Test: asm --> bin --> asm --> bin
test.cul        Consult file for test.asm
lina405         Test binary: lina 4.0.5
linacrawl.cul   Test: dedicated crawler for ciforth, adapted to lina 4.0.5
lina405equ.cul+ Equ's generated via linacrawl.cul ,
                  must be included in lina405.asm
lina405.cul    Labels's generated via linacrawl.cul ,
                      need not be included in lina405.asm
lina405.asm*    Generated from lina405 by 2 preceeding cul files.
rf751*         Similar for retroforth 7.5.1
