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

