

ASSEMBLER
1278 ORG
\ Here it all starts
\ Fasten Your Seat Belts (tm)
    CLD,                  \ First instruction
    MOV, X| T| DI'| MEM| XXX X,
:QQQ
    POP|ES,
    ADD, B| F| AL'| D0| [SI]
    MOV, X| T| DI'| MEM| XXX X,
\ XXX is a target for backward jumps:
:RRR
        DB  1 ^C &C  65 65 80
        DW  1 ^C &C  65 65 80
        DL  1 ^C &C  65 65 80
        DB  144  144  144  144  144  144  144
:XXX
    MOV, X| T| DI'| MEM| QQQ X,
    JMP, XXX RX,
    JMP, XXX _AP_ 4 + - (RX,)
    JMP, XXX 1- RX,
    JMPS, XXX RB,
    JMPS, XXX 1- RB,
    JMP, YYY RX,
    JMP, YYY 1- RX,
    JMPS, YYY RB,
    JMPS, YYY 1- RB,
    LEA, AX'| DB| [AX +4* AX] 0 B,
\ YYY is a target for forward jumps:
:YYY

PREVIOUS
