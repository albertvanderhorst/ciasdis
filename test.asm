

ASSEMBLER
1278 ORG
    CLD,                  \ First instruction
    MOV, X| T| DI'| MEM| XXX X,
:QQQ
    POP|ES,
    ADD, B| F| AL'| D0| [SI]
    MOV, X| T| DI'| MEM| XXX X,
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
:YYY

PREVIOUS
