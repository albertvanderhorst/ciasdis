( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( REVERSE ENGINEERING ASSEMBLER  cias cidis for 80386                   )

\ Officially named computer_intelligence_assembler_386
\                  computer_intelligence_disassembler_386
\ this file is installed under the name cias and cidis to behave
\ as an assembler or disassembler.

\ This is a main build. For details see asgen.frt

INCLUDE asgen.frt
INCLUDE aswrap.frt
INCLUDE asi586.frt

\ These two files could be incorporated in 2 previous ones.
\ A problem is getting rid of the labels if we don't want them.
INCLUDE labelas.frt
INCLUDE labeldis.frt


REQUIRE ARGC    REQUIRE OLD:    REQUIRE SRC>EXEC        REQUIRE INCLUDED

\ Assemble file NAME. Leave compiled BUFFER LENGTH.
: ASSEMBLED   FIRSTPASS 2DUP INCLUDED  SECONDPASS INCLUDED
   CODE-SPACE CP @ OVER - ;

\ Return the NAME of the target file.
: TARGET 2 ARG[] ;

: MAIN
    'ERROR RESTORED     'INCLUDED RESTORED
     ARGC 2 4 WITHIN 0= 13 ?ERROR
     1 ARG[] ASSEMBLED   TARGET PUT-FILE
;
