( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ This file hot patches some words in the prelude of asgen.frt.
\ It must be called after asgen.frt.


\ Length of the code buffer.
VARIABLE CODE-LENGTH
2,000,000 CODE-LENGTH !

CREATE CODE-SPACE     CODE-LENGTH @ ALLOT

\ Copy the behaviour of the latest definition into "name" affecting all
\ words already using DEA2 .
: HOT-PATCH   LATEST   (WORD) FOUND   3 CELLS MOVE ;

\ Point into CODE-SPACE, used to assemble
VARIABLE CP                 CODE-SPACE CP !

\ ``HERE'' such as used in assembly.
: NEW-AS-HERE    CP @ ;   HOT-PATCH AS-HERE

\ Address in target associated with the start of ``CODE-SPACE''.
\ Where the code is to be located during execution.
VARIABLE TARGET-START

\ Associate ADDRESS with the start of ``CODE-SPACE''.
: ORG      TARGET-START !   CODE-SPACE CP ! ;

\ Convert host memory ADDRESS. Leave target memory ADDRESS.
: HOST>TARGET  CODE-SPACE - TARGET-START @ + ;

\ Convert target memory ADDRESS. Leave host memory ADDRESS.
: TARGET>HOST   TARGET-START @ -   CODE-SPACE +   ;

\ Instruction pointer in assembly. View used in branches etc.
: NEW-_AP_    CP @ HOST>TARGET ;   HOT-PATCH _AP_

\ Swap dictionary pointer back and forth to assembler area.
: SWAP-AS CP @ DP @    CP ! DP !  ;

\ Wrapper for ``ALLOT'' such as used in assembly.
: NEW-AS-ALLOT    SWAP-AS ALLOT SWAP-AS ;   HOT-PATCH AS-ALLOT

\ Only Needed. Maybe ``CP C! 1 CP +!''
\ Wrapper for ``C,'' such as used in assembly.
: NEW-AS-C,    SWAP-AS C, SWAP-AS ;  HOT-PATCH AS-C,
