( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Contains access words and other little utilities that complement
\ ciasdis. In particular regarding unexpected missing words.

ASSEMBLER
: B@ TARGET>HOST C@ ;
: W@ TARGET>HOST 2 MC@ ;
: L@ TARGET>HOST 4 MC@ ;
PREVIOUS

\ Missing.
\ I1 I2 : F
: >= < 0= ;
\ I1 I2 : F
: <= > 0= ;

\ If FLAG is not zero, output STRING on the error channel and exit
\ with an error code of 2.
: ?ABORT ROT IF ETYPE 2 EXIT-CODE ! BYE THEN ;

\ For STRING1 and STRING2 : "they ARE equal".
: $= ROT OVER = IF CORA 0 = ELSE DROP DROP DROP 0 THEN ;

\ Print STRING, as a quoted string, duly doubling the ``"'' if present.
: ."$" BEGIN &" $S &" EMIT TYPE &" EMIT OVER 0= UNTIL 2DROP ;


