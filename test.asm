ASSEMBLER
0 #1278 SECTION mine:
\ mine: not needed.
\ Here it all starts
\ Fasten Your Seat Belts (tm)
BITS-32
:START
    CLD,                  \ First instruction
    MOV, X| T| DI'| MEM| XXX L,
:QQQ
    POP|ES,
    ADD, B| F| AL'| ZO| [SI]
    MOV, X| T| DI'| MEM| XXX L,
    RET,
\ XXX is a target for backward jumps:
:RRR
        db  1 ^C &C  #65 #65 #80
        d$  1 ^C &C  "AAP"
\        db  1 ^C &C  #65 #65 #80
        dw  1 ^C &C  #65 #65 #80
        dl  1 ^C &C  #65 #65 #1279
:XXX
    MOV, X| T| DI'| MEM| QQQ L,
    JMP, XXX RL,
AS:, JMP, XXX RW,
    JMP, XXX _AP_ 4 + - (RL,)
    JMP, XXX 1- RL,
    JMPS, XXX RB,
    JMPS, XXX 1+ RB,
    JMP, YYY RL,
    JMP, YYY 9 - RL,
    JMPS, YY RB,
    JMPS, YY 1- RB,
:YY
    10 AS-ALIGN
:BUFFER10
    _AP_ 10 + RES-TIL
:BUFFERTILL
    0EA RESB
:BUFFERTILL-END

    LEA, AX'| BO| [AX +4* AX] 0 B,
    LEA, AX'| XO| [AX +4* AX] #12 L,
OS:,
    LEA, AX'| XO| [AX +4* AX] #13 L,
AS:,
    LEA, AX'| XO| [BX+SI]% #14 W,
AS:,
OS:,
    LEA, AX'| XO| [BX+SI]%   #15    W,
OS:,
AS:,
    LEA, AX'| XO| [BX+SI]%   #16 W,
    RET,
BITS-32
INC|X,  AX|
    MOVI,   X|   XO|   [BX]   #14 L,   #18 IL,
INC|X,  AX|
OS:,
    MOVI,   X|   XO|   [BX]   #14 L,   #18 IW,
INC|X,  AX|
AS:,
    MOVI,   X|   XO|   [BX]%   #20 W,   #24 IL,
AS:, OS:,
    MOVI,   X|   XO|   [BX]%   #20 W,   #24 IW,
    RET,
BITS-16
INC|X,  AX|
AS:, OS:,
    MOVI,   X|   XO|   [BX]   #14 L,   #18 IL,
INC|X,  AX|
AS:,
    MOVI,   X|   XO|   [BX]   #14 L,   #18 IW,
INC|X,  AX|
OS:,
    MOVI,   X|   XO|   [BX]%   #20 W,   #24 IL,
    MOVI,   X|   XO|   [BX]%   #20 W,   #24 IW,
    RET,
BITS-32
\ Y Y is a target for forward jumps:
:YYY
1000 0A7B8,C7D8 SECTION fives:
    dl   5555,5555 5555,5555
PREVIOUS
