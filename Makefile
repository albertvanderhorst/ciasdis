# $Id$
# Copyright(2000): Albert van der Horst, HCC FIG Holland by GNU Public License
#
# This defines the usage of ciforth to build assemblers and reverse
# engineering tools.

# FIXME: Bear with me. This was adapted from the Makefile of ciforth
# and contains a lot of stuff that has to be cleaned out.
# It distracts but does no harm, other than that non-assembler targets
# don't build.

#.SUFFIXES:
#.SUFFIXES:.bin.asm.m4.v.o.c

# Applicable suffixes : * are generated files
# + are generated files if they are mentionned on the next line
#
#* .dvi .tex .ps : as usual (See TeX)
#+ .texinfo : texinfo
#   menu.texinfo gloss.texinfo
#* .asm : input file for `nasm' assembler
#* .BLK : contains blocks usable by Forth
# .frt : text file : contains blocks in an \n separated stream
#* .msm : input file for `MASM' and `tasm' assembler
#* .s : input file for `gas' assembler  Experimental
#* .pres : file to be pre-processed generating .s Experimental
#* .bin : a binary image without header (useful i.a. for msdos .com)
#* .gas : input file for `gas' assembler
#* .rawdoc : unsorted glossary items from the generic source.
#* .rawtest : unsorted and unexpanded tests.
#+ .m4 : m4 macro's possibly including other macro's
#   except constant.m4
# .cfg : m4 macro's generating files ( ci86.%.x + %.cfg -> ci86.%.y)
# .mi : files that after processed by m4 give a .texinfo file
# .mig : Currently in use for the wordset, which is a .mi file (WRONG!)
# It could be, but it has been stolen.

# ALL FILES STARTING IN ``ci86'' (OUTHER ``ci86.gnr'') ARE GENERATED

INGREDIENTS = \
header.m4       \
postlude.m4      \
prelude.m4       \
protect.m4       \
width16.m4       \
width32.m4       \
# That's all folks!

DOCTRANSFORMS = \
gloss.m4        \
glosshtml.m4    \
indexhtml.m4    \
manual.m4       \
menu.m4  \
names.m4        \
wordset.m4      \
# That's all folks!

# Normally tools are not supplied with the release.
# But this is a tool not otherwise available.
TOOLS=  \
ssort   \
# That's all folks!

# Index files used by info, some are empty for ciforth.
INDICES= cp fn ky pg tp vr

# Different assemblers should generate equivalent Forth's.
ASSEMBLERS= masm nasm gas
# The kinds of Forth assembler sources that can be made using any assembler
TARGETS= lina wina mina alone linux alonehd msdos32
# The kinds of Forth's binaries that can be made using NASM (not used)
BINTARGETS= mina alone
# If this makefile runs under Linux, the following forth's can be made and
# subsequently run
LINUXFORTHS= ciforthc lina
# Auxiliary targets. Because of GNU make bug, keep constant.m4.
OTHERTARGETS= forth.lab forth.lab.lina forth.lab.wina toblock fromblock constant.m4 namescooked.m4
# C-sources with various aims. FIXME: start with .c names.
ASTARGETS= cias cidis ciasdis test.bin test2.bin test2.asm
CSRCAUX= toblock fromblock stealconstant
CSRCFORTH= ciforth stealconstant
CSRC= $(CSRCAUX) $(CSRCFORTH)

# Texinfo files still to be processed by m4.
SRCMI= \
assembler.mi    \
# That's all folks!
# cifgen.mi \
# ciforth.mi \
# intro.mi    \
# manual.mi   \
# rational.mi  \
# That's all folks!

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

# Plug ins for stand alone assembler
PGSRC= \
as6809s.frt \
as80.frt        \
asi86.frt       \
asi386.frt      \
asalpha.frt     \
# That's all folks!

# Other Forth source.
#   Quick reference sheet generator
#   Complete small, stand alone assemblers
UNPSRC= \
ps.frt    \
ass.frt  \
#as6809s.frt \
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
cias.1          \
README.assembler \
assembler.itxt  \
p0.asi386.ps    \
p0F.asi386.ps   \
qr8086.ps       \
qr8080.ps       \
# That's all folks!
# $(SRCMI)

# Test files for assemblers.
TESTAS= \
testset8080     \
testset8086     \
testset386      \
testset386a     \
testsetpentium  \
testset6809     \
testsetalpha    \
asm386endtest   \
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



# The following must be updated on the website, whenever
# any typo's are fixed. Unfortunately, it has become a separate
# maintenance chore, and is in effect a separate project.
DOCOLD = \
figdoc.zip    \
# That's all folks!

# These files can easily be generated, if you have linux.
EXAMPLES = \
ci86.alone.asm  \
ci86.mina.msm  \
ci86.wina.asm  \
ci86.linux.asm  \
ci86.lina.asm  \
ci86.alonehd.asm  \
# That's all folks!

RELEASECONTENT = \
COPYING   \
README.assembler.txt \
cias.1          \
cul.5           \
$(ASSRC)        \
# That's all folks!

# 4.0 ### Version : an official release 4.0
# Left out : beta, revision number is taken from rcs e.g. 3.154
VERSION=  # Because normally VERSION is passed via the command line.
DATE=2030     # To get the newest version


TEMPFILE=/tmp/ciforthscratch

MASK=FF
PREFIX=0
TITLE=QUICK REFERENCE PAGE FOR 80386 ASSEMBLER
TESTTARGETS=*.ps testas* testlina.[0-9] testmina.[0-9] testlinux.[0-9]

# How to check out, anything
%:RCS/%,v
	co -r$(RCSVERSION) $<

# Define NASM as *the* assembler generating bin files.
%.bin:%.asm
	nasm -fbin $< -o $@ -l $*.lst


# mina.cfg and alone.cfg are present (at least via RCS)
# allow to generate ci86.mina.bin etc.
ci86.%.rawdoc ci86.%.rawtest : ci86.%.asm ;

VERSION : ; echo 'define({M4_VERSION},$(VERSION))' >VERSION

ci86.%.asm : %.cfg VERSION nasm.m4 ci86.gnr
	make constant.m4
	cat $+ | m4 >$(TEMPFILE)
	sed $(TEMPFILE) -e '/Split here for doc/,$$d' >$@
	sed $(TEMPFILE) -e '1,/Split here for doc/d' | \
	sed -e '/Split here for test/,$$d' >$(@:%.asm=%.rawdoc)
	sed $(TEMPFILE) -e '1,/Split here for test/d' >$(@:%.asm=%.rawtest)
	rm $(TEMPFILE)

ci86.%.msm : VERSION %.cfg masm.m4 ci86.gnr ; \
	cat $+ | m4 >$(TEMPFILE)
	sed $(TEMPFILE) -e '/Split here for doc/,$$d' >$@
	sed $(TEMPFILE) -e '1,/Split here for doc/d' | \
	sed -e '/Split here for test/,$$d' >$(@:%.msm=%.rawdoc)
	sed $(TEMPFILE) -e '/Split here for test/,$$d' >$(@:%.msm=%.rawtest)
	rm $(TEMPFILE)

ci86.%pres  : %.cfg gas.m4  ci86.gnr ; cat $+ | m4 >$@
ci86.%     : %.cfg       ci86.gnr ; cat $+ | m4 >$@

# gas needs extra transformations that m4 cannot handle.
# In particular the order of operands.
%.s : %pres ; sed -f transforms <$+ >$@

.PRECIOUS: ci86.%.rawdoc rf751.asm lina405.asm test.bin

.PHONY: default all clean releaseproof zip mslinks release regressiontest
# Default target for convenience
default : lina
ci86.$(s).bin :

# Put include type of dependancies here
$(TARGETS:%=%.cfg) : $(INGREDIENTS) ; if [ -f $@ ] ; then touch $@ ; else co $@ ; fi

# Some of these targets make no sense and will fail
all: $(TARGETS:%=ci86.%.asm) $(TARGETS:%=ci86.%.msm) $(BINTARGETS:%=ci86.%.bin) \
    $(LINUXFORTHS) $(OTHERTARGETS)

clean: \
; rm -f $(TARGETS:%=ci86.%.*)  $(CSRCS:%=%.o) $(LINUXFORTHS) VERSION spy\
; for i in $(INDICES) ; do rm -f *.$$i *.$$i's' ; done

cleanall: clean  testclean asclean ; \
    rcsclean ; \
    rm -f $(OTHERTARGETS) ; \
    rm -f *.aux *.log *.ps *.toc *.pdf


#msdos32.zip doesn't work yet.
release : strip figdoc.zip zip msdos.zip lina.zip # as.zip

#Install it. To be run as root
install: ; @echo 'There is no "make install" ; use "lina -i <binpath> <libpath>"'

# Get the library file that is used while compiling.
forth.lab : ; echo 'BLOCK-FILE $$@ GET-FILE "'$@'" PUT-FILE'|lina

zip : $(RELEASECONTENT) ; echo cias-$(VERSION).tar.gz $+ | xargs tar -cvzf

releaseproof : ; for i in $(RELEASECONTENT); do  rcsdiff -w $$i ; done

testclean: ; rm -f $(TESTTARGETS)

asclean: ; rm -f $(ASTARGETS)

# WARNING : the generation of postscript and pdf use the same files
# for indices, but with different content.

%.ps:%.dvi  ;
	for i in $(INDICES) ; do texindex  $(@:%.ps=%.$$i) ; done
	 dvips -ta4 $< -o$@
#       dvips -A -r -i       -S10 $< -oA$@
#       dvips -B -i -T 1.8cm,0.0cm -S10 $< -oB$@

%.pdf:%.texinfo  ;
	pdftex $<
	for i in $(INDICES) ; do texindex  $(@:%.pdf=%.$$i) ; done
	pdftex $<
	# Don't leave invalid indices for postscript!
	for i in $(INDICES) ; do rm $(@:%.pdf=%.$$i) ; done

%.ps : asgen.frt %.frt ps.frt ; \
    ( \
	echo 5 LOAD; \
	cat $+ ;\
	echo 'PRELUDE' ;\
	echo 'HEX $(MASK) MASK ! $(PREFIX) PREFIX ! DECIMAL ' ;\
	echo ' "$(TITLE)"   TITLE $$!' ;\
	echo ' QUICK-REFERENCE BYE' \
    )|\
    lina |\
    sed '1,/SNIP TILL HERE/d' |\
    sed '/SI[MB]/d' |\
    sed '/OK/d' >p$(PREFIX).$@

qr8080.ps       :; make as80.ps TITLE='QUICK REFERENCE PAGE FOR 8080 ASSEMBLER'; mv p0.as80.ps $@
qr8086.ps       :; make asi86.ps TITLE='QUICK REFERENCE PAGE FOR 8086 ASSEMBLER'; mv p0.asi86.ps $@
p0.asi386    :; make asi386.ps PREFIX=0 MASK=FF
p0F.asi386.ps   :; make asi386.ps PREFIX=0F MASK=FFFF
p0F.asiP.ps   :; make asiP.ps PREFIX=0F MASK=FFFF

do : ci86.mina.msm
		diff -w ci86.mina.msm orig/FORTH > masm.dif ||true
		more masm.dif

da : ci86.alone.asm
		diff -w ci86.alone.asm cmp > asm.dif ||true
		wc asm.dif

cm :
		cmp ci86.alone.bin cmp2/ci86.alone.bin

did: ci86.mina.msm
		diff -w ci86.mina.msm $(cd)/compare.asm

#ci86.mina.asm : header.m4 mina.m4 nasm.m4 ci86.gnr ; m4 $+ >$@

#copy: $(TARGETS:%=ci86.%.bin) $(TARGETS:%=ci86.%.msm)
copy:
		cp ci86.mina.bin  $(cd)/../test/mina.com
		cp ci86.alone.bin  $(cd)/../test/alone.com
		cp ci86.mina.asm  $(cd)/../test/mina.asm
		cp ci86.alone.asm  $(cd)/../test/alone.asm
		cp ci86.mina.msm  $(cd)/../test/mina.msm
		cp ci86.msdos1.msm  $(cd)/../test/msdos1.msm
		cp ci86.msdos2.msm  $(cd)/../test/msdos2.msm
		cp ci86.msdos3.msm  $(cd)/../test/msdos3.msm
		cp ci86.alone.msm  $(cd)/../test/alone.msm
		cp forth.lab       $(cd)/../test/forth.lab
		cp genboot.bat      $(cd)/../test/genboot.bat

cmp: ci86.mina.bin ci86.alone.bin ciforth lina
		strip lina
		strip ciforth
		cmp ci86.mina.bin  cmp/ci86.mina.bin
		cmp ci86.alone.bin  cmp/ci86.alone.bin
		cmp lina cmp/lina
		cmp ciforth cmp/ciforth

strip : lina
	strip lina -s -R .bss -R .comment

copy1: $(TARGETS:%=ci86.%.bin)
		mount /mnt/dosa
		cp ci86.alone.bin  /mnt/dosa/alone.com
		cp ci86.mina.bin  /mnt/dosa/mina.com
		cp genboot.bat    /mnt/dosa
		cp /mnt/dosc/project/ci86/install/tlink.exe /mnt/dosa
		cp /mnt/dosc/project/ci86/install/tasm.exe  /mnt/dosa
		umount /mnt/dosa

test : ci86.alone.bin   ; cmp $+ cmp/$+

test1: ci86.alone.msm   ; diff -w $+ fortha.asm

ff2 : ci86.linux.o ciforth.c
		gcc -ggdb ciforth.c -c
				ld ci86.linux.o -Tlink.script -r -o ci86.linux2.o
		gcc ciforth.o ci86.linux2.o -o ciforth

x : ; echo $(RELEASECONTENT)
y : ; echo $(RELEASECONTENT) |\
sed -e's/\<ci86\.//g' |\
sed -e's/\<gnr\>/ci86.gnr/' |\
sed -e's/ \([^ .]\{1,8\}\)[^ .]*\./ \1./g'

fina : fina.c ci86.lina.o ; $(CC) $(CFLAGS) $+ -static -Wl,-Tlink.script -o $@

ci86.lina.lis : ci86.lina.mac ;
		as ci86.lina.mac -a=ci86.lina.lis  ;\
		objcopy a.out -O binary

ci86.lina.mac : ci86.lina.asm transforms ; \
		sed -f transforms < ci86.lina.asm > $@

lina2 : ci86.lina.s ; gcc $+ -l 2>aap

ci86.lina.s :

testasalpha: asgen.frt asalpha.frt testsetalpha ; \
    echo CR REQUIRE INCLUDE REQUIRE DUMP REQUIRE ALIAS \'\$$\@ ALIAS @+ INCLUDE asgen.frt INCLUDE asalpha.frt INCLUDE testrunalpha|\
    lina -a    |\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testsetalpha >$@.diff ;\
    diff $@.diff testresults

testas80: asgen.frt as80.frt testset8080 ; \
    cat $+|\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset8080 >$@.diff ;\
    diff $@.diff testresults

testas86: asgen.frt asi86.frt testset8086 ; \
    cat $+|\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset8086 >$@.diff ;\
    diff $@.diff testresults

testas386: asgen.frt asi386.frt testset386 ; \
    cat $+|\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset386 >$@.diff ;\
    diff $@.diff testresults

testaspentium: asgen.frt asi386.frt asipentium.frt testsetpentium ; \
    cat $+|\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testsetpentium >$@.diff ;\
    diff $@.diff testresults

test386: asgen.frt asi386.frt ; \
    (cat $+;echo ASSEMBLER HEX BITS-32   SHOW-ALL)|\
    lina -e|\
    sed 's/~SIB|   10 SIB,,/[DX +1* DX]/' |\
    sed 's/~SIB|   18 SIB,,/[DX +1* BX]/' |\
    sed 's/~SIB|   1C SIB,,/[AX +1* 0]/' |\
    sed 's/~SIB|   14 SIB,,/[AX +1* BX]/' >$@       ;\
    diff -w $@ testset386 >$@.diff ;\
    diff $@.diff testresults

testallpentium : testas86 testas386 test386 testaspentium

testasses : testasalpa testas80 testallpentium

# There is a problem here: SHOW-ALL shows almost nothing
# because asi386.frt is not loaded.
# testpentium: asgen.frt asipentium.frt ; \
#     (cat $+;echo ASSEMBLER HEX SHOW-ALL)|\
#     lina -e|\
#     sed 's/~SIB|   10 SIB,,/[DX +1* DX]/' |\
#     sed 's/~SIB|   18 SIB,,/[DX +1* BX]/' |\
#     sed 's/~SIB|   1C SIB,,/[AX +1* 0]/' |\
#     sed 's/~SIB|   14 SIB,,/[AX +1* BX]/' >$@       ;\
#     diff -w $@ testsetpentium >$@.diff ;\
#     diff $@.diff testresults

test386-16: asgen.frt asi386.frt ; \
    (cat $+;echo ASSEMBLER HEX BITS-16   SHOW-ALL)|\
    lina -e >$@       ;
#   diff -w $@ testset386 >$@.diff ;\
#   diff $@.diff testresults

# Special test to exercise otherwise hidden instructions.
testas386a: asgen.frt asi386.frt testset386a ; \
    cat $+|\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed '/^OK$$/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset386a >$@.diff ;\
    diff $@.diff testresults

testas6809: asgen.frt as6809.frt testset6809 ; \
    (echo 5 LOAD; cat $+)|\
    lina |\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset6809 >$@.diff ;\
    diff $@.diff testresults

as.tgz : $(RELEASEASSEMBLER) cias ciasdis cidis ; echo as$(VERSION).tgz $+ |\
 xargs tar cfz

msdos32.zip : forth32.asm forth32.com msdos32.txt msdos9.cfg config.sys ; \
    make mslinks ; \
    echo ms$(VERSION) $+ |xargs zip

########################## DOCUMENTATION ########################################
#
# The documentation generates tex, info and html automatically for any version.
# They still go through a common texinfo file, but because of the restrictions
# of info regarding names, some tex-output is spoiled unecessarily.
# In particular forth words with what the c-people find strange characters,
# can not occur in chapter headers: ' : @ ( ) e.a.


# Sort the raw information and add the wordset chapter ends
# A .mig file has its @ duplicated!
%.mig : %.rawdoc ;
	ssort $+ -e '^worddoc[a-z]*($${@},{@}.*\n$$worddoc' -m 1s2s |\
	sed -e 's/@/@@/g' >$@

namescooked.m4 : names.m4 ci86.gnr ; \
	cat names.m4 >$@ ; \
	echo "define({ci86gnrversion}, ifelse(M4_VERSION,,\
{snapshot `rlog -r -h -N ci86.gnr|grep head|sed -e s/head://`},\
{M4_VERSION}\
))dnl" >>$@

# Make the worddoc macro's into glossary paragraphs to our liking
%.mim : gloss.m4 %.mig ; \
    ( cat $(@:ci86.%.mim=%.cfg) ; m4 $+ )| m4 |\
    sed -e '/Split here for documentation/,$$d' > $@

# Make the worddoc macro's into glossary html items to our liking
ci86.%.html : %.cfg glosshtml.m4 indexhtml.m4 ci86.%.mig namescooked.m4
	ssort $(@:%.html=%.mig) -e '^worddoc[a-z]*($${@},{@}.*\n$$worddoc' -m 2s1s |\
	m4 indexhtml.m4 - > $@
	cat $(@:%.html=%.mig)|\
	sed -e 's/@@/@/g'               |\
	sed -e s'/worddocsafe/worddoc/g'  |\
	sed -e 's/</\&lt\;/g'   > temp.html
	( \
	    cat namescooked.m4 indexhtml.m4 ; \
	    ssort temp.html -e '^worddoc[a-z]*($${@},{@}.*\n$$worddoc' -m 2s1s \
	)| m4 |\
	sed -e 's/thisforth/$(@:ci86.%.html=%)/g' > $@
	m4 $(@:ci86.%.html=%.cfg) glosshtml.m4 namescooked.m4 temp.html >> $@

%.info : %.texinfo  ; makeinfo --no-split $< -o $@

# For tex we do not need to use the safe macro's
ci86.%.texinfo : %.cfg $(SRCMI) ci86.%.mim ci86.%.mig manual.m4 wordset.m4 menu.m4 namescooked.m4
	m4 menu.m4 $(@:%.texinfo=%.mig) > menu.texinfo
	m4 wordset.m4 $(@:%.texinfo=%.mim)  $(@:%.texinfo=%.mig) |m4 >wordset.mi
	echo 'define({thisfilename},{$@})' >>namescooked.m4
	( \
	    cat $(@:ci86.%.texinfo=%.cfg) manual.m4 namescooked.m4 ciforth.mi \
	)| tee spy | m4 |\
	sed -e '/Split here for documentation/,$$d' |\
	sed -e 's/thisforth/$(@:ci86.%.texinfo=%)/g' > $@
#        rm wordset.mi menu.texinfo

cifgen.texinfo : cifgen.mi manual.m4 namescooked.m4 lina.cfg
	m4 lina.cfg manual.m4 namescooked.m4 cifgen.mi |\
	sed -e 's/_lbracket_/@{/g'                 |\
	sed -e 's/_rbracket_/@}/g'                 |\
	sed -e 's/_comat_/@@/g'          > $@

TESTLINA= \
test.m4 \
ci86.lina.rawtest

TESTLINUX= \
test.m4 \
ci86.linux.rawtest

# No output expected, except for an official version (VERSION=A.B.C)
# The version number shows up in the diff.
testlina : $(TESTLINA) ci86.lina.rawtest lina forth.lab.lina tsuite.frt ;
	rm forth.lab
	cp forth.lab.lina forth.lab
	m4 $(TESTLINA)  >$(TEMPFILE)
	sed $(TEMPFILE) -e '/Split here for test/,$$d' >$@.1
	sed $(TEMPFILE) -e '1,/Split here for test/d' >$@.2
	lina <$@.1 2>&1| grep -v RCSfile >$@.3
	diff -b -B $@.2 $@.3 || true
	lina -a <tsuite.frt 2>&1 |cat >tsuite.out
	diff -b -B tsuite.out testresults || true
	ln -sf forth.lab.lina  forth.lab
	rm $(TEMPFILE)

%.test : ci86.%.rawtest test.m4 ;
	m4 test.m4 $<  >$(TEMPFILE)
	sed $(TEMPFILE) -e '/Split here for test/,$$d' >$@.1
	sed $(TEMPFILE) -e '1,/Split here for test/d' >$@.2
	rm $(TEMPFILE)

# Preliminary until it is clear whether we want other disassemblers.
ciasdis : $(ASSRC) asi386.frt asipentium.frt ; lina -c ciasdis.frt
cias : ciasdis ; ln -f ciasdis cias
cidis : ciasdis ; ln -f ciasdis cidis

test.bin : cidis cias test.asm test.cul
	cias test.asm test.bin
	cidis test.bin test.cul > test2.asm
	cias test2.asm test2.bin
	diff test2.bin test.bin
	rcsdiff -r$(RCSVERSION) test.bin
	rcsdiff -b -B -r$(RCSVERSION) test2.asm

lina405.asm : cidis lina405 lina405equ.cul lina405.cul
	cidis lina405 lina405.cul| sed -e 's/. DROP-THIS//' >$@
	cias lina405.asm lina405
	rcsdiff -r$(RCSVERSION) lina405
	rcsdiff -b -B -r$(RCSVERSION) lina405.asm

# Test case, reverse engineer retroforth version 7.5.1.
rf751.cul : cidis rf751 rf751equ.cul rfcrawl.cul
	echo FETCH rf751 INCLUDE rfcrawl.cul | cidis >$@
	rcsdiff -bBw -r$(RCSVERSION) $@

rf751.asm : cidis rf751 rf751equ.cul rf751.cul
	cidis rf751 rf751.cul| sed -e 's/. DROP-THIS//' >$@
	cias rf751.asm rf751
	rcsdiff -r$(RCSVERSION) rf751
	rcsdiff -bBw -r$(RCSVERSION) rf751.asm

%.bin : %.asm ; cias $< $@

cidis386.zip : $(ASSRC) asi386.frt asipentium.frt ;  zip $@ $+

testciasdis : test.bin lina405.asm rf751.asm

# -----------------
regressiontest : testasses testciasdis
