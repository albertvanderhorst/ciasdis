
INCLUDE aswrap.frt
INCLUDE asgen.frt
INCLUDE asi586.frt

INCLUDE labelas.frt

FIRSTPASS

INCLUDE test.asm

SECONDPASS

INCLUDE test.asm


CODE-SPACE CP @ D-R

INCLUDE labeldis.frt
