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
( 0000,0553 )                  JMP, XXX 1 - RL,
( 0000,0558 )                  JMPS, XXX RB,
( 0000,055A )                  JMPS, XXX 1 + RB,
( 0000,055C )                  JMP, END RL,
( 0000,0561 )                  JMP, 170 (RL,) 
( 0000,0566 )                  JMPS, YY RB,
( 0000,0568 )                  JMPS, YY 1 - RB,
( 0000,056A )   :YY   db 0 0 0 0 0 0 
( 0000,0570 )   :BUFFER10   db 0 0 0 0 0 0 0 0 0 0 
( 0000,057A )                 db 0 0 0 0 0 0 
   10 AS-ALIGN   
( 0000,0580 )   :BUFFERTILL   db 0 0 0 0 0 0 0 0 0 0 
( 0000,058A )                 db 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
( 0000,059A )                 db 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
( 0000,05AA )                 db 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
( 0000,05BA )                 db 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
( 0000,05CA )                 db 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
( 0000,05DA )                 db 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 

( 0000,05EA )                 80  RESB

\ YYY is a target for forward jumps:   
( 0000,066A )   :BUFFERTILL-END    LEA, AX'| BO|    [AX +4* AX] 0 B, 
( 0000,066E )                  LEA, AX'| XO|    [AX +4* AX] 0C L, 
( 0000,0675 )                  OS:, 
( 0000,0676 )                  LEA, AX'| XO|    [AX +4* AX] 0D L, 
( 0000,067D )                  AS:, 
( 0000,067E )                  LEA, AX'| XO| [BX+SI]% 0E W, 
( 0000,0682 )                  AS:, 
( 0000,0683 )                  OS:, 
( 0000,0684 )                  LEA, AX'| XO| [BX+SI]% 0F W, 
( 0000,0688 )                  OS:, 
( 0000,0689 )                  AS:, 
( 0000,068A )                  LEA, AX'| XO| [BX+SI]% 10 W, 
( 0000,068E )                  RET, 
( 0000,068F )                  INC|X, AX| 
( 0000,0690 )                  MOVI, X| XO| [BX] 0E L, 12 IL, 
( 0000,069A )                  INC|X, AX| 
( 0000,069B )                  OS:, 
( 0000,069C )                  MOVI, X| XO| [BX] 0E L, 12 IW, 
( 0000,06A4 )                  INC|X, AX| 
( 0000,06A5 )                  AS:, 
( 0000,06A6 )                  MOVI, X| XO| [BX]% 14 W, 18 IL, 
( 0000,06AE )                  AS:, 
( 0000,06AF )                  OS:, 
( 0000,06B0 )                  MOVI, X| XO| [BX]% 14 W, 18 IW, 
( 0000,06B6 )                  RET, 
BITS-16
( 0000,06B7 )                  INC|X, AX| 
( 0000,06B8 )                  AS:, 
( 0000,06B9 )                  OS:, 
( 0000,06BA )                  MOVI, X| XO| [BX] 0E L, 12 IL, 
( 0000,06C4 )                  INC|X, AX| 
( 0000,06C5 )                  AS:, 
( 0000,06C6 )                  MOVI, X| XO| [BX] 0E L, 12 IW, 
( 0000,06CE )                  INC|X, AX| 
( 0000,06CF )                  OS:, 
( 0000,06D0 )                  MOVI, X| XO| [BX]% 14 W, 18 IL, 
( 0000,06D8 )                  MOVI, X| XO| [BX]% 14 W, 18 IW, 
( 0000,06DE )                  RET, 
BITS-32
( 0000,06DF )   :YYY :END 
