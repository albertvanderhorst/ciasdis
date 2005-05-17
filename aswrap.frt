( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ This file hot patches some words in the prelude of asgen.frt.
\ It must be called after asgen.frt.

\ ------------------------- library definitions -------------------------
\ Copy the behaviour of the latest definition into "name" affecting all
\ words already using that word.
: HOT-PATCH   LATEST   (WORD) FOUND   3 CELLS MOVE ;

VARIABLE STUB   \ Example for `` DELAYED-BUFFFER ''.
\ Create a buffer of N items with "name" Execute: return buffer address.
\ The buffer is allocated at run time, preventing static buffers in load
\ images.
: DELAYED-BUFFER   CREATE ,   DOES>   >R HERE 'STUB >DFA !
    R@ BODY>  'STUB SWAP 3 CELLS MOVE   HERE R> @ ALLOT ;

\ ------------------------- library definitions end ---------------------

\ Length of the code buffer.
VARIABLE CODE-LENGTH
2,000,000 CODE-LENGTH !

\ A bag with the dea's of all segments.
100 BAG SEGMENT-REGISTRY

\ Create segment with FILEOFFSET TARGETADDRESS and CODESPACE
0 0 0  \ Overwritten anyway
class SEGMENT
LATEST SEGMENT-REGISTRY BAG+!
M: CP M; DUP ,           \ The local dictionary pointer ("code pointer")
M: CODE-SPACE @ M;  ,    \ Start of the code space
\ M: (TARGET-START)  M;
M: -ORG- ! M;            \ Define corresponding target addres.
M: TARGET-START @ M; ,   \ Return corresponding target addres.
M: FILE-OFFSET @ M; ,      \ Return corresponding files addres.
endclass

SEGMENT-REGISTRY !BAG       \ Get rid of dummy registration.

\ ``HERE'' such as used in assembly.
: NEW-AS-HERE    CP @ ;   HOT-PATCH AS-HERE

\ Address in target associated with the start of ``CODE-SPACE''.
\ Where the code is to be located during execution.



\ Use only while disassembling.
\ Return the END of the file as a target address (non-inclusive).
: TARGET-END   TARGET-START   CP @ CODE-SPACE - + ;

\ For ADDR return "it IS a pointing into the target space"
: PLAUSIBLE-LABEL?    TARGET-START TARGET-END WITHIN ;

\ Use only while disassembling.
\ The end of the code area while disassembling: a host address.
: HOST-END CP @ ;

\ Associate target ADDRESS with start of ``CODE-BUFFER''
\ The valid range from the code buffer goes to ``CP @'' and is not
\ affected.

\ Associate ADDRESS with the start of ``CODE-SPACE''.
: ORG      -ORG-              CODE-SPACE CP ! ;

\ Convert host memory ADDRESS. Leave target memory ADDRESS.
: HOST>TARGET  CODE-SPACE - TARGET-START + ;

\ Convert target memory ADDRESS. Leave host memory ADDRESS.
: TARGET>HOST   TARGET-START -   CODE-SPACE +   ;

\ Abbreviation.
'TARGET>HOST ALIAS th

\ Instruction pointer in assembly. View used in branches etc.
: NEW-_AP_    CP @ HOST>TARGET ;   HOT-PATCH _AP_


\ Swap dictionary pointer back and forth to assembler area.
: SWAP-AS CP @ DP @    CP ! DP !  ;

\ Wrapper for ``ALLOT'' such as used in assembly.
: NEW-AS-ALLOT    SWAP-AS ALLOT SWAP-AS ;   HOT-PATCH AS-ALLOT

\ Only Needed. Maybe ``CP C! 1 CP +!''
\ Wrapper for ``C,'' such as used in assembly.
: NEW-AS-C,    SWAP-AS C, SWAP-AS ;  HOT-PATCH AS-C,

\ Reserve X bytes, without specifying a content.
: RESB   AS-HERE OVER AS-ALLOT    SWAP ERASE ;

\ Reserve bytes till target ADDRES. (Compare ``ORG''.)
: RES-TIL   _AP_ -   AS-ALLOT ;

\ Align to a target address, that is multiple of N.
: AS-ALIGN   _AP_   BEGIN 2DUP SWAP MOD WHILE 1+ REPEAT   RES-TIL DROP ;
