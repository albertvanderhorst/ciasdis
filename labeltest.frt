
INCLUDE aswrap.frt
INCLUDE asgen.frt
INCLUDE asi586.frt

\ These two files could be incorporated in 2 previous ones.
\ A problem is getting rid of the labels if we don't want them.
INCLUDE labelas.frt
INCLUDE labeldis.frt

\ Test of assembly
FIRSTPASS

INCLUDE test.asm

SECONDPASS

INCLUDE test.asm

\ Test of dis-assembly
CONSULT test.asm.dat
