 ( $Id$ )
 ( Copyright{2004}: Albert van der Horst, HCC FIG Holland by GNU Public License)
 ( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( # decimal_numbers_denotation ) \ AvdH A1apr15

\ DEFINITIONS PREVIOUS doesn't work because DEF.. is
\ found in the DENOTATION wordlist (!)
'DENOTATION >WID CURRENT !
\ Define # as a prefix to force one decimal number, possibly double.
: # BASE @ >R DECIMAL (NUMBER) R> BASE ! POSTPONE SDLITERAL ;
12 LATEST >FFA !
DEFINITIONS
