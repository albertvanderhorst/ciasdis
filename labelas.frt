( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( Handle labels )

( Make sure undefined labels don't fool up the first pass of the        )
(   assembly                                                            )
\ Compile words that are unknown or look like malformed
\ numbers as a _ ,i.e. it generates a don't care value.
\ Supposedly these are labels that have not been compiled.
\ Go on compiling.
\ Loading the same code another time will give correct code.
: FIX-DEA DROP '_ ;
: FIX-NMB FIX-DEA (WORD) 2DROP ;

: ERROR10 DROP IF  FIX-NMB THEN ;
: ERROR12 DROP IF  FIX-DEA THEN ;

REQUIRE OLD:
\ Replacement for ?ERROR. Fix up errors, see FIX-NMB FIX-DEA.
: ?ERROR-FIXING
    DUP 10 = IF ERROR10 ELSE
    DUP 12 = IF ERROR12 ELSE
    OLD: ?ERROR
    THEN THEN   ;

\ Try to automatically load missing words.
: FIRSTPASS '?ERROR-FIXING >DFA @ '?ERROR >DFA ! ;
: SECONDPASS '?ERROR RESTORED ;  \ And off again. 

( Make a denotation for labels. They look like `` :LABEL ''             )
( Put `` : ''them in the DENOTATION wordlist, such that it not          )
(   interferes with the normal semicolon.                               )
REQUIRE POSTFIX

( Making DENOTATION the CONTEXT is dangerous! This will do.             )
'DENOTATION >WID CURRENT !

: (:) _AP_ (WORD) 2DUP FOUND IF FOUND EXECUTE = 123 ?ERROR
124 THROW ELSE   POSTFIX CONSTANT THEN ;
: : '(:) CATCH 124 = IF ." PHASE ERROR " THEN ;
LATEST >FFA 12 TOGGLE

CONTEXT @ CURRENT !