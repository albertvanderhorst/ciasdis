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
INCLUDE crawl.frt


REQUIRE ARGC    REQUIRE OLD:    REQUIRE SRC>EXEC        REQUIRE INCLUDED

\ Assemble file NAME. Leave compiled BUFFER LENGTH.
: ASSEMBLED
   ONLY POSTPONE FORTH POSTPONE ASSEMBLER HEX
    FIRSTPASS 2DUP INCLUDED  SECONDPASS INCLUDED
   CODE-SPACE CP @ OVER - ;

\ Return the NAME of the target file.
: TARGET-AS 2 ARG[] ;


\ Perform the action of the program as per the spec's of ``cias''
: cias   1 ARG[] ASSEMBLED   TARGET-AS PUT-FILE ;

\ Fetch file NAME to the code buffer.
: FETCHED    GET-FILE CODE-SPACE SWAP    2DUP + CP !   MOVE ;

\ Return the NAME of the target file.
: TARGET-DIS 2 ARG[] ;

REQUIRE DUMP
\ Perform the action of the program as per the spec's of ``cidis''
: cidis   1 ARG[] FETCHED TARGET-DIS CONSULTED ;

\ The name determines what to do.
: MAIN   'ERROR RESTORED     'INCLUDED RESTORED      'ABORT RESTORED
    ARGC 1 = IF OK QUIT THEN
    ARGC ( 2) 3 4 WITHIN 0= 13 ?ERROR   \ second argument still obligatory.
    0 ARG[] &d $I IF cidis ELSE cias THEN ;
