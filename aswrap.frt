( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Where the code is to be located during execution.
VARIABLE CODE-START

\ Length of the code buffer.
VARIABLE CODE-LENGTH
2,000,000 CODE-LENGTH !

CREATE CODE-SPACE     CODE-LENGTH @ ALLOT

\ Point into CODE-SPACE, used to assemble
VARIABLE CP                 CODE-SPACE CP !

\ ``HERE'' such as used in assembly.
: AS-HERE  CP @ ;

\ Address in target associated with the start of ``CODE-SPACE''.
VARIABLE TARGET-START

\ Associate ADDRESS with the start of ``CODE-SPACE''.
: ORG      TARGET-START !   CODE-SPACE CP ! ;

\ Instruction pointer in assembly. View used in branches etc.
: _AP_    AS-HERE   TARGET-START @ + ;

\ Swap dictionary pointer back and forth to assembler area.
: SWAP-AS CP @ DP @    CP ! DP !  ;


\ NOT NEEDED
\ Wrapper for ``ALLOT'' such as used in assembly.
: AS-ALLOT   SWAP-AS ALLOT SWAP-AS ;

\ NOT NEEDED
\ Wrapper for ``,'' such as used in assembly.
: AS-,       SWAP-AS , SWAP-AS ;


\ Only Needed. Maybe ``CP C! 1 CP +!''
\ Wrapper for ``C,'' such as used in assembly.
: AS-C,       SWAP-AS C, SWAP-AS ;
