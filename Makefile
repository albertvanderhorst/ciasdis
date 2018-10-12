# $Id$
# Copyright(2000): Albert van der Horst, HCC FIG Holland by GNU Public License
#
# This defines the usage of ciforth to build assemblers and reverse
# engineering tools.

# Conventions:
#    testset<arc> : a comprehensive set of opcodes plus addressing modes.
#    testas<arc>  : the outcome of a partical test on testset<arc>
#       - it is assembled, and the code dumped
#       - the result is disassembled
#       Outcome:
#           - the difference with testset<arc> should only be the code
#           - the code should agree with what is stored.
#      The mere presence of an opcode in the set, implies that the binary
#      code has been checked, manually or against other assemblers.
#    gset<arc> : The outcome of a SHOW-ALL.
#         It must be the same than in the archive, except after a
#         fix of a defect. Then it must be updated.
#         It can be checked against testset<arc>. Any additions must
#         be incorporated into testset<arc> and checked.
#
# This is lifted from the ciforth makefile. Some non-valid
# targets may still not be removed.

#.SUFFIXES:
#.SUFFIXES:.bin.asm.v.o.c

# Applicable suffixes : * are generated files
# + are generated files if they are mentionned on the next line
#
#* .ps : as usual (See TeX)
# .frt : text file containing Forth code
#* .bin : a binary image without header

FORTH=./lina
DIFF_TXT=rcsdiff -bBw -r$(RCSVERSION)
DIFF_BIN=rcsdiff -r$(RCSVERSION)

# The following directory are supposedly in line with the
# Debian FHS directory philosophy.
INSTALLDIR=/
INSTALLED_LAB=$(INSTALLDIR)/usr/lib/ciasdis.lab
INSTALLED_BIN=$(INSTALLDIR)/usr/bin/ciasdis

MISC_DOC= \
RCS_changelog \
README.assembler.txt \
# That's all folks!

ASTARGETS= cias cidis ciasdis test.bin test2.bin test2.asm
TESTTARGETS= test.bin lina405.asm rf751.asm rf751.cul

# Generic source for assembler
# Include two pass, reverse engineering.
ASSRC= \
access.frt   \
aswrap.frt   \
asgen.frt    \
ciasdis.frt  \
crawl.frt    \
labelas.frt  \
labeldis.frt \
tools.frt    \
# That's all folks!

# Extra source for MS os.
ASSRCCLUDGE= \
cias.frt \
cidis.frt \
# That's all folks!

# Plug ins for generic assembler
PGSRC= \
as6809.frt \
as80.frt        \
asi86.frt       \
asi386.frt      \
asipentium.frt      \
asalpha.frt     \
# That's all folks!

# Test files for assemblers.
TESTSETS= \
testset386   \
testset386a  \
testset6809  \
testset8080  \
testset8086  \
testsetalpha   \
testsetpentium \
# That's all folks!

# asm386endtest is burned down, very early test.

# Output of running testsets, they should be the same
# as the testset itself, except for the binary code.
TESTAS= \
testas386       \
testas386a      \
testas6809      \
testas80        \
testas86        \
testasalpha     \
testaspentium   \
# That's all folks!

#  Complete small, stand alone assemblers without error detection
# for export to SBC or .lab files.
PGSRC= \
as6809s.frt \
as8086s.frt \
# That's all folks!

# Other Forth source.
#   Quick reference sheet generator
UNPSRC= \
ps.frt    \
# That's all folks!

# Consult files for general use
CUL= \
elf.cul \
exeheader.cul \
# That's all folks!

# Documentation files and archives
# Formally forth.lab is for error messages, but
# you can load debug tools from it too.
DOC = \
COPYING   \
forth.lab      \
cul.5           \
ciasdis.1          \
README.assembler \
assembler.itxt  \
p0.asi386.ps    \
p0F.asi386.ps   \
qr8086.ps       \
qr8080.ps       \
# That's all folks!

# Test files for reverse engineering and two pass.
TESTRV= \
test.asm        \
test.cul        \
lina405         \
linacrawl.cul   \
lina405equ.cul  \
lina405.cul     \
# That's all folks!

# Test output references
TESTREF=        \
lina405.asm     \
# That's all folks!

RELEASEASSEMBLER=      \
Makefile        \
$(ASSRC)        \
$(PGSRC)        \
$(UNPSRC)       \
$(CUL)          \
$(DOC)          \
$(TESTRV)         \
# That's all folks!

RELEASECONTENT = \
COPYING   \
README.assembler \
ciasdis.1          \
cul.5           \
$(ASSRC)        \
# That's all folks!

BINRELEASE = \
COPYING   \
README.assembler \
ciasdis.1          \
cul.5           \
ciasdis         \
ciasdis.lab       \
# That's all folks!

# 4.0 ### Version : an official release 4.0
# Left out : beta, revision number is taken from rcs e.g. 3.154
VERSION=  # Because normally VERSION is passed via the command line.

TEMPFILE=/tmp/ciforthscratch

MASK=FF
PREFIX=0
TITLE=QUICK REFERENCE PAGE FOR 80386 ASSEMBLER
DEBIANFILES=control

# How to check out, anything
%:RCS/%,v
	co -r$(RCSVERSION) $<

# Using the elective screen requires the exact library coming
# with the assembler!
%.ps : asgen.frt %.frt ps.frt ; \
    ( \
	echo  \"INCLUDE\" WANTED  \"DUMP\" WANTED ;\
	cat $+ ;\
	echo 'PRELUDE' ;\
	echo 'HEX $(MASK) MASK ! $(PREFIX) PREFIX ! DECIMAL ' ;\
	echo ' "$(TITLE)"   TITLE $$!' ;\
	echo ' QUICK-REFERENCE BYE' \
    )|\
    $(FORTH) -a |\
    sed '1,/SNIP TILL HERE/d' |\
    cat >p$(PREFIX).$@

#     sed '/SI[MB]/d' |\
#     sed '/OK/d' |\

# Default target for convenience
default : ciasdis ciasdis.lab

# Install a configured binary.
# Burn in the address where the library resides in a special copy.
install_bin: ciasdis_tbi
	mkdir -p $(INSTALLDIR)/usr/bin
	cp $< $(INSTALLED_BIN)

install:  default $(MISC_DOC) ciasdis.1 cul.5 install_bin
	mkdir -p $(INSTALLDIR)/usr/lib
	cp ciasdis.lab  $(INSTALLED_LAB)
	mkdir -p $(INSTALLDIR)/DEBIAN
	cp -f control $(INSTALLDIR)/DEBIAN
	mkdir -p $(INSTALLDIR)/usr/share/man/man1
	mkdir -p $(INSTALLDIR)/usr/share/man/man5
	cp -f ciasdis.1 $(INSTALLDIR)/usr/share/man/man1
	cp -f cul.5 $(INSTALLDIR)/usr/share/man/man5
	mkdir -p $(INSTALLDIR)/usr/share/doc/ciasdis
	cp -f $(MISC_DOC) $(INSTALLDIR)/usr/share/doc/ciasdis
	find $(INSTALLDIR) -type d | xargs chmod 755
	find $(INSTALLDIR) -type f | xargs chmod 644
	chmod 755 $(INSTALLDIR)/usr/bin/ciasdis
	gzip -9 -r $(INSTALLDIR)/usr/share
	cp -f copyright $(INSTALLDIR)/usr/share/doc/ciasdis

# If tests fails, test targets must be inspected.
.PRECIOUS: rf751.asm rf751.cul lina405.asm test.bin
.PRECIOUS: $(TESTAS)

.PHONY: RELEASE default all clean releaseproof zip \
    regressiontest testexamples debian

# Some of these targets make no sense and will fail
all: regressiontest

clean: testclean install_clean
	rcsclean
	rm -f ciasdis.lab
	rm -f *.bin
	rm -f ciasdis_tbi*

# How to get rid of the Debian test directory
install_clean:

# Get the library file to be used, trim it.
ciasdis.lab :
	echo 'BLOCK-FILE $$@ GET-FILE TYPE' |\
	$(FORTH) -a | sed -e '/ciforth examples \**)/,$$d' >$@
	echo '( *************** ciforth examples etc. trimmed ************* )'>>$@

# Get the binary to be used, burn in the correct library.
ciasdis_tbi : $(ASSRC) asi386.frt asipentium.frt
	sed -e /BLOCK-FILE/s?forth.lab?/usr/lib/ciasdis.lab? ciasdis.frt >$@.frt
	$(FORTH) -c $@.frt

# Make a source distribution.
srczip : $(RELEASECONTENT) ; echo ciasdis-dev-$(VERSION).tar.gz $+ | xargs tar -cvzf
# Make a normal, binary distribution.
zip : $(BINRELEASE) ; echo ciasdis-$(VERSION).tar.gz $+ | xargs tar -cvzf

testclean: ; rm -f $(TESTAS) $(TESTTARGETS) $(ASTARGETS)

releaseproof : ; for i in $(RELEASECONTENT); do  rcsdiff -w $$i ; done

# WARNING : the generation of postscript and pdf use the same files
# for indices, but with different content.

qr8080.ps       :; make as80.ps TITLE='QUICK REFERENCE PAGE FOR 8080 ASSEMBLER'; mv p0.as80.ps $@
qr8086.ps       :; make asi86.ps TITLE='QUICK REFERENCE PAGE FOR 8086 ASSEMBLER'; mv p0.asi86.ps $@
p0.asi386    :; make asi386.ps PREFIX=0 MASK=FF
p0F.asi386.ps   :; make asi386.ps PREFIX=0F MASK=FFFF
p0F.asiP.ps   :; make asiP.ps PREFIX=0F MASK=FFFF

showcontent : ; echo $(RELEASECONTENT)

# ------------------- TARGET TESTS ---------------------------------
# All the test<target> assemble a testset<target> with virtually
# all combinations of instructions, then disassemble then compared.
# A previous diff file is in RCS

testasalpha: asgen.frt asalpha.frt testsetalpha ; \
	rm -f $@.diff ;\
	echo CR  \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE asalpha.frt INCLUDE testsetalpha |\
	$(FORTH) -a |\
	sed '1,/TEST STARTS HERE/d' |\
	sed 's/^[0-9A-F \.,]*://' >$@ ;\
	diff -w $@ testsetalpha >$@.diff ;\
	$(DIFF_TXT) $@.diff

testas6809: asgen.frt as6809.frt testset6809 ; \
	rm -f $@.diff ;\
	echo CR  \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE as6809.frt INCLUDE testset6809 |\
	$(FORTH) -a |\
	sed '1,/TEST STARTS HERE/d' |\
	sed 's/^[0-9A-F \.,]*://' >$@ ;\
	diff -w $@ testset6809 >$@.diff ;\
	$(DIFF_TXT) $@.diff

testas80: asgen.frt as80.frt testset8080 ; \
	rm -f $@.diff ;\
    echo CR  \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE as80.frt INCLUDE testset8080 |\
    $(FORTH) -a|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset8080 >$@.diff ;\
    $(DIFF_TXT) $@.diff

testas86: asgen.frt asi86.frt testset8086 ; \
    rm -f $@.diff ;\
    echo CR  \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE asi86.frt INCLUDE testset8086 |\
    $(FORTH) -a|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset8086 >$@.diff ;\
    $(DIFF_TXT) $@.diff

testas386: asgen.frt asi386.frt testset386 ; \
    rm -f $@.diff ;\
    echo CR  \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE asi386.frt INCLUDE testset386 |\
    $(FORTH) -a|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset386 >$@.diff ;\
    $(DIFF_TXT) $@.diff

# This is limited to pentium instructions common to all pemtiums,
# excluded those tested by testas386
testaspentium: asgen.frt asi386.frt asipentium.frt testsetpentium ; \
    rm -f $@.diff ;\
    echo CR  \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE asi386.frt INCLUDE asipentium.frt INCLUDE testsetpentium | \
    $(FORTH) -a|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testsetpentium >$@.diff ;\
    $(DIFF_TXT) $@.diff

# Special test to exercise otherwise hidden instructions.
testas386a: asgen.frt asi386.frt testset386a ; \
    rm -f $@.diff ;\
    echo CR  \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE asi386.frt INCLUDE testset386a | \
    $(FORTH) -a|\
    sed '1,/TEST STARTS HERE/d' |\
    sed '/^OK$$/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset386a >$@.diff ;\
    $(DIFF_TXT) $@.diff


testasses : testasalpha testas6809 testas80 testas86 testallpentium

testallpentium : testas386 testas386a testaspentium

# ---------------------------------------


# Extra test for the precious 386 subset
gset386.diff: gset386 ; \
    diff -w $+ testset386 >$@ ;\
    $(DIFF_TXT) $@;\


# ------------------- generating testsets --------------------------

# Testsets are generated by the SHOW-ALL command.
# Once testsets are present, they can be used to test SHOW-ALL

gsetall : gsetalpha gset6809 gset80 gset86 gset386-16 gsetallpentium
gsetallpentium : gset386 gsetpentium

# gsetxxx contains all instruction that can be accepted.
# This can be checked against expectation. Once that is done
# it can be used as a testsetxxx.
gset386: asgen.frt asi386.frt ; \
    (echo CR; cat $+;echo ASSEMBLER HEX BITS-32   SHOW-ALL)|\
    $(FORTH) -a|\
    sed 's/~SIB|   10 SIB,,/[DX +1* DX]/' |\
    sed 's/~SIB|   18 SIB,,/[DX +1* BX]/' |\
    sed 's/~SIB|   1C SIB,,/[AX +1* 0]/' |\
    sed 's/~SIB|   14 SIB,,/[AX +1* BX]/'|\
    grep -v ciforth >$@;\
    $(DIFF_TXT) $@

gset386-16: asgen.frt asi386.frt ; \
    (cat $+;echo ASSEMBLER HEX BITS-16   SHOW-ALL)|\
    $(FORTH) -a >$@       ; \
    $(DIFF_TXT) $@

gset6809: asgen.frt as6809.frt ; \
    (cat $+;echo ASSEMBLER HEX SHOW-ALL)|\
    $(FORTH) -a >$@       ;\
    $(DIFF_TXT) $@

gsetalpha: asgen.frt asalpha.frt ; \
    echo CR \"INCLUDE\" WANTED  \"DUMP\" WANTED INCLUDE asgen.frt INCLUDE asalpha.frt ASSEMBLER HEX SHOW-ALL |\
    $(FORTH) -a >$@       ; \
    $(DIFF_TXT) $@

#  (cat $+;echo ASSEMBLER HEX SHOW-ALL)|\

gset80: asgen.frt as80.frt ; \
    (cat $+;echo ASSEMBLER HEX SHOW-ALL)|\
    $(FORTH) -a >$@       ; \
    $(DIFF_TXT) $@

gset86: asgen.frt asi86.frt ; \
    (cat $+;echo ASSEMBLER HEX SHOW-ALL)|\
    $(FORTH) -a >$@       ;  \
    $(DIFF_TXT) $@

gsetpentium: asgen.frt asi386.frt asipentium.frt ; \
    (cat $+;echo ASSEMBLER HEX SHOW-ALL)|\
    $(FORTH) -a >$@       ;   \
    $(DIFF_TXT) $@

# ---------------------------------------
# As by : make RELEASE VERSION=1-0-0
RELEASE: $(RELEASEASSEMBLER) cias ciasdis cidis $(ASSRCCLUDGE) ;\
    echo ciasdis-$(VERSION).tgz $+ | xargs tar cfz

# Preliminary until it is clear whether we want other disassemblers.
# Note: this will use a copy of forth.lab to the local directory as ciasdis.lab
ciasdis : $(ASSRC) asi386.frt asipentium.frt ; $(FORTH) -c $@.frt
cias : ciasdis ; ln -f ciasdis cias
cidis : ciasdis ; ln -f ciasdis cidis

test.bin : ciasdis cidis cias test.asm test.cul
	ciasdis -a test.asm test.bin
	ciasdis -d test.bin test.cul > test2.asm
	ciasdis -a test2.asm test2.bin
	diff test2.bin test.bin
	$(DIFF_BIN) test.bin
	$(DIFF_TXT) test2.asm
	cias test.asm test.bin
	cidis test.bin test.cul > test2.asm
	cias test2.asm test2.bin
	diff test2.bin test.bin
	$(DIFF_BIN) test.bin
	$(DIFF_TXT) test2.asm

lina405.asm : ciasdis lina405equ.cul lina405.cul
	co -p lina405  > lina405
	ciasdis -d lina405 lina405.cul >$@
	ciasdis -a $@ lina405
	$(DIFF_BIN) lina405
	$(DIFF_TXT) $@

# Test case, reverse engineer retroforth version 7.5.1.
rf751.cul : ciasdis rf751equ.cul rfcrawl.cul elf.cul
	co -p rf751  > rf751
	echo FETCH rf751 INCLUDE rfcrawl.cul | ciasdis >$@
	$(DIFF_TXT) $@

rf751.asm : ciasdis rf751equ.cul rf751.cul
	co -p rf751  > rf751
	ciasdis -d rf751 rf751.cul >$@
	$(DIFF_TXT) $@
	ciasdis -a $@ rf751
	$(DIFF_BIN) rf751

%.bin : %.asm ; ciasdis -a $< $@

cidis386.zip : $(ASSRC) asi386.frt asipentium.frt ;  zip $@ $+

testexamples : test.bin lina405.asm rf751.asm

# -----------------
regressiontest : testasses testexamples gsetall gset386.diff
