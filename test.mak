# $Id$
# Copyright(2000): Albert van der Horst, HCC FIG Holland by GNU Public License
#
# Contains everything except making (that is in the makefile)

MASK=FF
PREFIX=0
TITLE=QUICK REFERENCE PAGE FOR 80386 ASSEMBLER
TESTTARGETS=*.ps testas* testlina.[0-9] testmina.[0-9] testlinux.[0-9]

# Source for stand alone assembler
ASSRC= \
access.frt   \
aswrap.frt   \
asgen.frt    \
bag.frt      \
ciasdis.frt  \
crawl.frt    \
decsharp.frt \
labelas.frt  \
labeldis.frt \
struct.frt   \
# That's all folks!

testclean: ; rm -f $(TESTTARGETS)

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

qr8080.ps       :; make as80.ps ; mv p0.as80.ps $@
qr8086.ps       :; make asi86.ps ; mv p0.asi86.ps $@
p0.asi386.ps    :; make asi386.ps PREFIX=0 MASK=FF
p0F.asi386.ps   :; make asi386.ps PREFIX=0F MASK=FFFF

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

test386: asgen.frt asi386.frt ; \
    (cat $+;echo ASSEMBLER HEX BITS-32   SHOW-ALL)|\
    lina -e|\
    sed 's/~SIB|   10 SIB,,/[DX +1* DX]/' |\
    sed 's/~SIB|   18 SIB,,/[DX +1* BX]/' |\
    sed 's/~SIB|   1C SIB,,/[AX +1* 0]/' |\
    sed 's/~SIB|   14 SIB,,/[AX +1* BX]/' >$@       ;\
    diff -w $@ testset386 >$@.diff ;\
    diff $@.diff testresults

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

# Special test to exercise otherwise hidden instructions.
testas6809a: asgen.frt as6809.frt testset6809a ; \
    (echo 5 LOAD; cat $+)|\
    lina |\
    sed '1,/TEST STARTS HERE/d' |\
    sed '/^OK$$/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset6809a >$@.diff ;\
    diff $@.diff testresults

RELEASEASSEMBLER=      \
as80.frt        \
assembler.txt   \
asgen.frt       \
asi386.frt      \
asi86.frt       \
asm386endtest   \
ass.frt  \
p0.asi386.ps    \
p0F.asi386.ps   \
ps.frt    \
qr8086.ps       \
qr8080.ps       \
testset386      \
testset8080     \
testset8086     \
test.mak        \
# That's all folks!
# testset386a    (fails)

as.zip : $(RELEASEASSEMBLER) ; echo as$(VERSION) $+ | xargs zip

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

testlinux : $(TESTLINUX) ci86.linux.rawtest ciforthc forth.lab ;
	m4 $(TESTLINUX)  >$(TEMPFILE)
	sed $(TEMPFILE) -e '/Split here for test/,$$d' >$@.1
	sed $(TEMPFILE) -e '1,/Split here for test/d' >$@.2
	ciforthc <$@.1 | grep -v RCSfile >$@.3
	diff -b -B $@.2 $@.3 || true
	rm $(TEMPFILE)

%.test : ci86.%.rawtest test.m4 ;
	m4 test.m4 $<  >$(TEMPFILE)
	sed $(TEMPFILE) -e '/Split here for test/,$$d' >$@.1
	sed $(TEMPFILE) -e '1,/Split here for test/d' >$@.2
	rm $(TEMPFILE)

# Preliminary until it is clear whether we want other disassemblers.
ciasdis : $(ASSRC) asi386.frt ; lina -c ciasdis.frt
cias : ciasdis ; ln -f ciasdis cias
cidis : ciasdis ; ln -f ciasdis cidis

test.bin : cidis cias test.asm test.cul  ;
	cias test.asm test.bin;
	cidis test.bin test.cul > test2.asm;
	cias test2.asm test2.bin;
	cmp test.bin test2.bin && cmp test.bin testresults/test.bin

cidis386.zip : $(ASSRC) asi386.frt ;  zip $@ $+
