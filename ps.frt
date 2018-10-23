( $Id$)
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Generate postscript data sheet. )
( Instructions to compare with, last byte 0..FF )
ALSO ASSEMBLER
DECIMAL
VARIABLE PREFIX     0 PREFIX  !
( Mask to compare with, contains valid bytes of PREFIX )
VARIABLE MASK       255 MASK !
CREATE TITLE 256 CELL+ ALLOT
: DEFAULT "QUICK REFERENCE PAGE FOR 8086 ASSEMBLER" ;
DEFAULT TITLE $!
: PRELUDE
  CR
  ." SNIP TILL HERE" CR
  ." %!" CR
  ." /Helvetica findfont 10 scalefont setfont " CR
  ." 60 60 translate /wt 60 def /ht 23 def " CR
;
( Calculate for the N-th line: WHAT number is to printed in the margin )
HEX
: SIDENOTE
   1F SWAP - 8 * ( last byte)
   MASK @ FFFF = IF
       PREFIX @ 100 * +
   ELSE MASK @ FFFFFF = IF
       PREFIX @ 100 /MOD 100 * ROT + SWAP 10000 * +
   THEN THEN ( Else nothing)
;
DECIMAL

: FRAME
  9 0 DO
    I . ." wt mul 0 ht mul moveto 0 ht 32 mul rlineto stroke" CR
  LOOP
  8 0 DO
    I . ." .3 add wt mul ht 32.3 mul moveto" CR
    HEX &( EMIT I U. &/ EMIT SPACE I 8 + U. &) EMIT ." show" CR DECIMAL
  LOOP
  33 0 DO
    ." 0 wt mul " I . ." ht mul moveto wt 8 mul 0 rlineto stroke" CR
  LOOP
  32 0 DO
    I . ." .3 add wt mul ht 32.3 mul moveto" CR
    ." -40 " I . ." .5 add ht mul 5 sub moveto" CR
    HEX &( EMIT I SIDENOTE 6 .R &) EMIT
    ." show" CR DECIMAL
  LOOP
;
: POSTLUDE
  ." 0 wt mul 33 ht mul moveto " CR
  ." /Times-Roman findfont 14 scalefont setfont" CR
    &( EMIT   TITLE $@ TYPE &) EMIT  ." show" CR
  ." /Times-Roman findfont 6 scalefont setfont" CR
  ." 6.5 wt mul -12 moveto " CR
  ." (By Albert van der Horst DFW Holland) show" CR
  ." showpage" CR
;

( Print the opcode of the current pifu at place N in the opcode map )
: OPCODE
   8 /MOD 31 SWAP - SWAP
   . ." .15 add wt mul " . ." .5 add ht mul 5 sub moveto " CR
   &( EMIT this %~ID. &) EMIT ." show" CR
;


VARIABLE INCREMENT
( For DEA and N : this dea FITS in box n )
: MATCH? 1+
    INCREMENT @ * PREFIX @ + ( Opcode)
    DAT XOR ( Difference)
    SWAP BI INVERT AND ( Valid bits)
    MASK @ AND ( Relevant byte)
    0=
;


( Fill in a box of the opcode wherever cuurent pifu fits.               )
: OPCODES
  MASK @ 1+ 256 / INCREMENT !
  256 -1 DO
    DUP I MATCH? IF DUP I OPCODE THEN
  LOOP
  DROP
;

: QUICK-REFERENCE
    FRAME
    !DISS   !TALLY
    pifustart BEGIN
        this IS-PI IF
           OPCODES
        THEN
        >next
    pifuend? UNTIL
    POSTLUDE
;
PREVIOUS
