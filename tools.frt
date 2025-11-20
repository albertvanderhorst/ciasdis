( $Id: tools.frt,v 1.6 2025/10/25 17:12:51 albert Exp $ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Tools are those auxiliary thingies that are not appropriate elsewhere.

\ ------------------------------------------------------------------------

WANT HEX:
WANT RESTORED
WANT UNUSED
WANT $-PREFIX
'% HIDDEN
\ Print N in hex with comma separator and leaving out groups of zeroes.
: (H.-)  0 <# BEGIN # # # # 2DUP OR WHILE &, HOLD REPEAT #> ;

: H.- (H.-) TYPE ;

: |W| $FFFF AND ;
: |L| $FFFF,FFFF AND ;

\ Sign extend a 32 bit value into a cell.
: L>C    DUP $8000,0000 AND 0= 0= $FFFF,FFFF INVERT AND OR ;

: .^   .S R@ @ >NFA @ $@ TYPE ;

: \D POSTPONE \ ; IMMEDIATE
\ : \D ;

\ Make QSORT safe by allowing an empty range.
\ Not tested and maybe not necessary.
\ : QSORT-SAFE 2>R 2DUP < IF 2R> QSORT ELSE 2DROP RDROP RDROP THEN ;

\ Make the output disappear till the end of the calling word.
    : 2DROP'  2DROP ;      \ Need a high level word here.
: SHUTUP   '2DROP' >DFA @  'TYPE >DFA !    CO   'TYPE RESTORED ;

\ Make ADDRESS return some label NAME, static memory so use immediately.
: INVENT-NAME   "L" PAD $!   (H.-) PAD $+! PAD $@ ;

\ For ADDRESS and NAME: "that name WAS invented".
: INVENTED-NAME?  10 <> IF 2DROP 0 ELSE SWAP INVENT-NAME CORA 0= THEN ;

\D HEX ." EXPECT: L0000,0042 " 42 INVENT-NAME TYPE .S CR
\D HEX ." EXPECT: 0 " 42 "L0000,0043" INVENTED-NAME? . .S CR
\D HEX ." EXPECT: -1 " 42 "L0000,0042" INVENTED-NAME? . .S CR
\D DECIMAL

\ Missing.
\ I1 I2 : F
: >= < 0= ;
\ I1 I2 : F
: <= > 0= ;

\ If FLAG is not zero, output STRING on the error channel and exit
\ with an error code of 2.
: ?ABORT ROT IF ETYPE 2 EXIT-CODE ! BYE ELSE 2DROP THEN ;


WANT $=
WANT ."$"
