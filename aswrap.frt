( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )


\ Length of the code buffer.
VARIABLE CODE-LENGTH
2,000,000 CODE-LENGTH !

CREATE CODE-SPACE     CODE-LENGTH @ ALLOT

\ Point into CODE-SPACE, used to assemble
VARIABLE CP                 CODE-SPACE CP !

\ ``HERE'' such as used in assembly.
: AS-HERE  CP @ ;

\ Address in target associated with the start of ``CODE-SPACE''.
\ Where the code is to be located during execution.
VARIABLE TARGET-START

\ Associate ADDRESS with the start of ``CODE-SPACE''.
: ORG      TARGET-START !   CODE-SPACE CP ! ;

\ Convert host memory ADDRESS. Leave target memory ADDRESS.
: HOST>TARGET  CODE-SPACE - TARGET-START @ + ;

\ Instruction pointer in assembly. View used in branches etc.
: _AP_    CP @ HOST>TARGET ;

\ Swap dictionary pointer back and forth to assembler area.
: SWAP-AS CP @ DP @    CP ! DP !  ;

\ Wrapper for ``ALLOT'' such as used in assembly.
: AS-ALLOT   SWAP-AS ALLOT SWAP-AS ;

\ NOT NEEDED
\ Wrapper for ``,'' such as used in assembly.
: AS-,       SWAP-AS , SWAP-AS ;


\ Only Needed. Maybe ``CP C! 1 CP +!''
\ Wrapper for ``C,'' such as used in assembly.
: AS-C,       SWAP-AS C, SWAP-AS ;

\ Adorn the ADDRESS we are currently disassembling with data
\ from a disassembly data file.
: ADORN-ADDRESS DROP CR ;
