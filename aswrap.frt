( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Where the code is to be located during execution.
VARIABLE CODE-START

\ Length of the code buffer.
VARIABLE CODE-LENGTH
2,000,000 CODE-LENGTH !

CREATE CODE-SPACE     CODE-LENGTH @ ALLOT

VARIABLE CP        \ Point into CODE-SPACE, used to assemble

CODE-SPACE CP !

\ Swap
: SWAP-AS CP @ DP @    CP ! DP !  ;


\ Wrapper for ``HERE'' such as used in assembly.
: AS-HERE  CP @ ;

\ Wrapper for ``ALLOT'' such as used in assembly.
: AS-ALLOT   SWAP-AS ALLOT SWAP-AS ;

\ Wrapper for ``,'' such as used in assembly.
: AS-,       SWAP-AS , SWAP-AS ;
\ Wrapper for ``C,'' such as used in assembly.
: AS-C,       SWAP-AS C, SWAP-AS ;
