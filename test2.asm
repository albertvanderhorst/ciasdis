BITS-32
4FE  ORG

\ 

\ #################### "WELCOME" he said ####################

\ Here it all starts
\ Fasten Your Seat Belts (tm)   
( 0000,04FE )   :START    CLD, \ First instruction
( 0000,04FF )   :L0000,04FF    MOV, X| T| DI'| MEM| XXX L, 
( 0000,0505 )   :QQQ    POP|ES, 
( 0000,0506 )                  ADD, B| F| AL'| ZO| [SI] 
( 0000,0508 )                  MOV, X| T| DI'| MEM| XXX L, 
( 0000,050E )                  RET, 
( 0000,050F )   :RRR   db 1 3 43 
( 0000,0512 )   :RRRR   db 41 41 50 

( 0000,0515 )                 d$  1  3  "CAAP"

( 0000,051B )                 dw 0001 0003 0043 0041 0041 0050 

( 0000,0527 )                 dl 1 3 43 41 
( 0000,0537 )                 dl 41 L0000,04FF 

\ XXX is a target for backward jumps:   
( 0000,053F )   :XXX    MOV, X| T| DI'| MEM| QQQ L, \   Move a xell to register DI from memory at QQQ
( 0000,0545 )                  JMP, XXX RL,
( 0000,054A )                  AS:, 
( 0000,054B )                  JMP, XXX RW,
( 0000,054E )                  JMP, XXX RL,
( 0000,0553 )                  JMP, -1A (RL,) 
( 0000,0558 )                  JMPS, XXX RB,
( 0000,055A )                  JMPS, -1E (RB,) 
( 0000,055C )                  JMP, YYY RL,
( 0000,0561 )                  JMP, 78 (RL,) 
( 0000,0566 )                  JMPS, YYY RB,
( 0000,0568 )                  JMPS, 74 (RB,) 
\ YYY is a target for forward jumps:   
( 0000,056A )                  LEA, AX'| BO|    [AX +4* AX] 0 B, 
( 0000,056E )                  LEA, AX'| XO|    [AX +4* AX] 0C L, 
( 0000,0575 )                  OS:, 
( 0000,0576 )                  LEA, AX'| XO|    [AX +4* AX] 0D L, 
( 0000,057D )                  AS:, 
( 0000,057E )                  LEA, AX'| XO| [BX+SI]% 0E W, 
( 0000,0582 )                  AS:, 
( 0000,0583 )                  OS:, 
( 0000,0584 )                  LEA, AX'| XO| [BX+SI]% 0F W, 
( 0000,0588 )                  OS:, 
( 0000,0589 )                  AS:, 
( 0000,058A )                  LEA, AX'| XO| [BX+SI]% 10 W, 
( 0000,058E )                  RET, 
( 0000,058F )                  INC|X, AX| 
( 0000,0590 )                  MOVI, X| XO| [BX] 0E L, 12 IL, 
( 0000,059A )                  INC|X, AX| 
( 0000,059B )                  OS:, 
( 0000,059C )                  MOVI, X| XO| [BX] 0E L, 12 IW, 
( 0000,05A4 )                  INC|X, AX| 
( 0000,05A5 )                  AS:, 
( 0000,05A6 )                  MOVI, X| XO| [BX]% 14 W, 18 IL, 
( 0000,05AE )                  AS:, 
( 0000,05AF )                  OS:, 
( 0000,05B0 )                  MOVI, X| XO| [BX]% 14 W, 18 IW, 
( 0000,05B6 )                  RET, 
BITS-16
( 0000,05B7 )                  INC|X, AX| 
( 0000,05B8 )                  AS:, 
( 0000,05B9 )                  OS:, 
( 0000,05BA )                  MOVI, X| XO| [BX] 0E L, 12 IL, 
( 0000,05C4 )                  INC|X, AX| 
( 0000,05C5 )                  AS:, 
( 0000,05C6 )                  MOVI, X| XO| [BX] 0E L, 12 IW, 
( 0000,05CE )                  INC|X, AX| 
( 0000,05CF )                  OS:, 
( 0000,05D0 )                  MOVI, X| XO| [BX]% 14 W, 18 IL, 
( 0000,05D8 )                  MOVI, X| XO| [BX]% 14 W, 18 IW, 
( 0000,05DE )                  RET, 
BITS-32
( 0000,05DF )   :YYY :END 
