BITS-32
8048000  ORG

 INCLUDE rf751equ.cul   
( 0804,8000 )   :e_ident   d$  7F  "ELF" 1 
( 0804,8005 )                 d$  1  1  0  0  0  0  0  0  0  0  0 

( 0804,8010 )   :e_type   dw 0002 
( 0804,8012 )   :e_machine   dw 0003 

( 0804,8014 )   :e_version   dl 1 
( 0804,8018 )   :e_entry   dl p_headerend 
( 0804,801C )   :e_phoff   dl 34 
( 0804,8020 )   :e_shoff   dl 0 
( 0804,8024 )   :e_flags   dl 0 

( 0804,8028 )   :e_ehsize   dw 0034 
( 0804,802A )   :e_phentsize   dw 0020 
( 0804,802C )   :e_phnum   dw 0001 
( 0804,802E )   :e_shentsize   dw 0028 
( 0804,8030 )   :e_shnum   dw 0000 
( 0804,8032 )   :e_shstrndx   dw 0000 

( 0804,8034 )   :p_type :e_headerend   dl 1 
( 0804,8038 )   :p_offset   dl 54 
( 0804,803C )   :p_vaddr   dl p_headerend 
( 0804,8040 )   :p_paddr   dl p_headerend 
( 0804,8044 )   :p_filesz   dl filesz 
( 0804,8048 )   :p_memsz   dl 0006,2563 
( 0804,804C )   :p_flags   dl 7 
( 0804,8050 )   :p_align   dl 1000 

( 0804,8054 )   :p_headerend :filest :_start    CALL, L0804,8191 RL,
( 0804,8059 )                  CALL, L0804,81B0 RL,
( 0804,805E )   :H_emit   dl 0 X_emit 

( 0804,8066 )   :N_emit   d$  4  "emit"

( 0804,806B )   :X_emit    PUSH|X, BX| 
( 0804,806C )                  PUSH|X, CX| 
( 0804,806D )                  PUSH|X, DX| 
( 0804,806E )                  MOVI|X, BX| 1 IL, 
( 0804,8073 )                  MOV, X| F| BX'| R| DX| 
( 0804,8075 )                  LEA, CX'| BO|    [SP +1* 0] 0FC B, 
( 0804,8079 )                  MOV, X| F| AX'| ZO| [CX] 
( 0804,807B )                  MOVI|X, AX| 4 IL, 
( 0804,8080 )                  INT, 80 IB, 
( 0804,8082 )                  POP|X, DX| 
( 0804,8083 )                  POP|X, CX| 
( 0804,8084 )                  POP|X, BX| 
( 0804,8085 )                  LODS, X'| 
( 0804,8086 )                  RET, 
( 0804,8087 )   :H_key   dl H_emit X_key 

( 0804,808F )   :N_key   d$  3  "key"

( 0804,8093 )   :X_key    SUBSI, R| SI| 4 IS, 
( 0804,8096 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8098 )                  PUSH|X, BX| 
( 0804,8099 )                  PUSH|X, CX| 
( 0804,809A )                  PUSH|X, DX| 
( 0804,809B )                  SUB, X| F| BX'| R| BX| 
( 0804,809D )                  MOVI|X, DX| 1 IL, 
( 0804,80A2 )                  LEA, CX'| BO|    [SP +1* 0] 0FC B, 
( 0804,80A6 )                  MOVI|X, AX| 3 IL, 
( 0804,80AB )                  INT, 80 IB, 
( 0804,80AD )                  MOV, X| T| AX'| ZO| [CX] 
( 0804,80AF )                  POP|X, DX| 
( 0804,80B0 )                  POP|X, CX| 
( 0804,80B1 )                  POP|X, BX| 
( 0804,80B2 )                  RET, 
( 0804,80B3 )   :H_bye   dl H_key X_bye 

( 0804,80BB )   :N_bye   d$  3  "bye"

( 0804,80BF )   :X_bye :X_bye    SUB, X| F| BX'| R| BX| 
( 0804,80C1 )                  MOV, X| F| BX'| R| AX| 
( 0804,80C3 )                  INC|X, AX| 
( 0804,80C4 )                  INT, 80 IB, 
( 0804,80C6 )   :H_syscall :H_syscall   dl H_bye X_syscall 

( 0804,80CE )   :N_syscall   d$  7  "syscall"

( 0804,80D6 )   :X_syscall    PUSH|X, AX| 
( 0804,80D7 )                  LODS, X'| 
( 0804,80D8 )                  CMPSI, R| AX| 0 IS, 
( 0804,80DB )                  J, Z| Y| L0804,8102 RB,
( 0804,80DD )                  CMPSI, R| AX| 1 IS, 
( 0804,80E0 )                  J, Z| Y| L0804,8106 RB,
( 0804,80E2 )                  CMPSI, R| AX| 2 IS, 
( 0804,80E5 )                  J, Z| Y| L0804,810F RB,
( 0804,80E7 )                  CMPSI, R| AX| 3 IS, 
( 0804,80EA )                  J, Z| Y| L0804,811D RB,
( 0804,80EC )                  CMPSI, R| AX| 4 IS, 
( 0804,80EF )                  J, Z| Y| L0804,8130 RB,
( 0804,80F1 )                  CMPSI, R| AX| 5 IS, 
( 0804,80F4 )                  J, Z| Y| L0804,814A RB,
( 0804,80F6 )                  CMPSI, R| AX| 6 IS, 
( 0804,80F9 )                  J, Z| Y| L0804,816B RB,
( 0804,80FB )                  SUBSI, R| SI| 4 IS, 
( 0804,80FE )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8100 )                  POP|X, AX| 
( 0804,8101 )                  RET, 
( 0804,8102 )   :L0804,8102    POP|X, AX| 
( 0804,8103 )                  INT, 80 IB, 
( 0804,8105 )                  RET, 
( 0804,8106 )   :L0804,8106    POP|X, AX| 
( 0804,8107 )                  PUSH|X, BX| 
( 0804,8108 )                  XCHG|AX, BX| 
( 0804,8109 )                  LODS, X'| 
( 0804,810A )                  XCHG|AX, BX| 
( 0804,810B )                  INT, 80 IB, 
( 0804,810D )                  POP|X, BX| 
( 0804,810E )                  RET, 
( 0804,810F )   :L0804,810F    POP|X, AX| 
( 0804,8110 )                  PUSH|X, BX| 
( 0804,8111 )                  PUSH|X, CX| 
( 0804,8112 )                  XCHG|AX, CX| 
( 0804,8113 )                  LODS, X'| 
( 0804,8114 )                  MOV, X| F| AX'| R| BX| 
( 0804,8116 )                  LODS, X'| 
( 0804,8117 )                  XCHG|AX, CX| 
( 0804,8118 )                  INT, 80 IB, 
( 0804,811A )                  POP|X, CX| 
( 0804,811B )                  POP|X, BX| 
( 0804,811C )                  RET, 
( 0804,811D )   :L0804,811D    POP|X, AX| 
( 0804,811E )                  PUSH|X, BX| 
( 0804,811F )                  PUSH|X, CX| 
( 0804,8120 )                  PUSH|X, DX| 
( 0804,8121 )                  XCHG|AX, DX| 
( 0804,8122 )                  LODS, X'| 
( 0804,8123 )                  MOV, X| F| AX'| R| BX| 
( 0804,8125 )                  LODS, X'| 
( 0804,8126 )                  MOV, X| F| AX'| R| CX| 
( 0804,8128 )                  LODS, X'| 
( 0804,8129 )                  XCHG|AX, DX| 
( 0804,812A )                  INT, 80 IB, 
( 0804,812C )                  POP|X, DX| 
( 0804,812D )                  POP|X, CX| 
( 0804,812E )                  POP|X, BX| 
( 0804,812F )                  RET, 
( 0804,8130 )   :L0804,8130    POP|X, AX| 
( 0804,8131 )                  PUSH|X, BX| 
( 0804,8132 )                  PUSH|X, CX| 
( 0804,8133 )                  PUSH|X, DX| 
( 0804,8134 )                  XCHG|AX, DX| 
( 0804,8135 )                  LODS, X'| 
( 0804,8136 )                  MOV, X| F| AX'| R| BX| 
( 0804,8138 )                  LODS, X'| 
( 0804,8139 )                  MOV, X| F| AX'| R| CX| 
( 0804,813B )                  LODS, X'| 
( 0804,813C )                  XCHG|AX, DX| 
( 0804,813D )                  PUSH|X, AX| 
( 0804,813E )                  LODS, X'| 
( 0804,813F )                  XCHG, X| SI'| ZO|    [SP +1* 0] 
( 0804,8142 )                  XCHG|AX, SI| 
( 0804,8143 )                  INT, 80 IB, 
( 0804,8145 )                  POP|X, SI| 
( 0804,8146 )                  POP|X, DX| 
( 0804,8147 )                  POP|X, CX| 
( 0804,8148 )                  POP|X, BX| 
( 0804,8149 )                  RET, 
( 0804,814A )   :L0804,814A    POP|X, AX| 
( 0804,814B )                  PUSH|X, BX| 
( 0804,814C )                  PUSH|X, CX| 
( 0804,814D )                  PUSH|X, DX| 
( 0804,814E )                  PUSH|X, DI| 
( 0804,814F )                  PUSH|X, AX| 
( 0804,8150 )                  LODS, X'| 
( 0804,8151 )                  MOV, X| F| AX'| R| BX| 
( 0804,8153 )                  LODS, X'| 
( 0804,8154 )                  MOV, X| F| AX'| R| CX| 
( 0804,8156 )                  LODS, X'| 
( 0804,8157 )                  MOV, X| F| AX'| R| DX| 
( 0804,8159 )                  LODS, X'| 
( 0804,815A )                  MOV, X| F| AX'| R| DI| 
( 0804,815C )                  LODS, X'| 
( 0804,815D )                  XCHG|AX, SI| 
( 0804,815E )                  XCHG, X| DI'| R| SI| 
( 0804,8160 )                  XCHG, X| AX'| ZO|    [SP +1* 0] 
( 0804,8163 )                  INT, 80 IB, 
( 0804,8165 )                  POP|X, SI| 
( 0804,8166 )                  POP|X, DI| 
( 0804,8167 )                  POP|X, DX| 
( 0804,8168 )                  POP|X, CX| 
( 0804,8169 )                  POP|X, BX| 
( 0804,816A )                  RET, 
( 0804,816B )   :L0804,816B    POP|X, AX| 
( 0804,816C )                  PUSH|X, BX| 
( 0804,816D )                  PUSH|X, CX| 
( 0804,816E )                  PUSH|X, DX| 
( 0804,816F )                  PUSH|X, DI| 
( 0804,8170 )                  PUSH|X, BP| 
( 0804,8171 )                  PUSH|X, AX| 
( 0804,8172 )                  LODS, X'| 
( 0804,8173 )                  MOV, X| F| AX'| R| BX| 
( 0804,8175 )                  LODS, X'| 
( 0804,8176 )                  MOV, X| F| AX'| R| CX| 
( 0804,8178 )                  LODS, X'| 
( 0804,8179 )                  MOV, X| F| AX'| R| DX| 
( 0804,817B )                  LODS, X'| 
( 0804,817C )                  MOV, X| F| AX'| R| DI| 
( 0804,817E )                  LODS, X'| 
( 0804,817F )                  MOV, X| F| AX'| R| BP| 
( 0804,8181 )                  LODS, X'| 
( 0804,8182 )                  XCHG|AX, BP| 
( 0804,8183 )                  XCHG|AX, DI| 
( 0804,8184 )                  XCHG|AX, SI| 
( 0804,8185 )                  XCHG, X| AX'| ZO|    [SP +1* 0] 
( 0804,8188 )                  INT, 80 IB, 
( 0804,818A )                  POP|X, SI| 
( 0804,818B )                  POP|X, BP| 
( 0804,818C )                  POP|X, DI| 
( 0804,818D )                  POP|X, DX| 
( 0804,818E )                  POP|X, CX| 
( 0804,818F )                  POP|X, BX| 
( 0804,8190 )                  RET, 
( 0804,8191 )   :L0804,8191    MOVI|X, SI| s0 IL, 
( 0804,8196 )                  SUBSI, R| SI| 4 IS, 
( 0804,8199 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,819B )                  MOVI|X, AX| retroforth_f IL, 
( 0804,81A0 )                  SUBSI, R| SI| 4 IS, 
( 0804,81A3 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,81A5 )                  MOVI|X, AX| retrofilesz IL, 
( 0804,81AA )                  CALL, X_eval RL,
( 0804,81AF )                  RET, 
( 0804,81B0 )   :L0804,81B0    CALL, L0804,82DA RL,
( 0804,81B5 )   :L0804,81B5    SUBSI, R| SI| 4 IS, 
( 0804,81B8 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,81BA )                  MOVI|X, AX| 20 IL, 
( 0804,81BF )                  CALL, X_parse RL,
( 0804,81C4 )                  J, Z| N| L0804,81CA RB,
( 0804,81C6 )                  LODS, X'| 
( 0804,81C7 )                  LODS, X'| 
( 0804,81C8 )                  JMPS, L0804,81B0 RB,
( 0804,81CA )   :L0804,81CA    CALL, X_find RL,
( 0804,81CF )                  J, C| N| L0804,81DF RB,
( 0804,81D1 )                  CALL, X_>number RL,
( 0804,81D6 )                  J, C| N| L0804,81B5 RB,
( 0804,81D8 )                  CALL, L0804,8739 RL,
( 0804,81DD )                  JMPS, L0804,81B0 RB,
( 0804,81DF )   :L0804,81DF    MOV, X| F| AX'| R| DI| 
( 0804,81E1 )                  LODS, X'| 
( 0804,81E2 )                  CALLO, R| DI| 
( 0804,81E4 )                  JMPS, L0804,81B5 RB,
( 0804,81E6 )                 d$  0C3 

( 0804,81E7 )   :H_mfind   dl H_syscall X_mfind 

( 0804,81EF )   :N_mfind   d$  5  "mfind"

( 0804,81F5 )   :X_mfind    PUSH|X, BX| 
( 0804,81F6 )                  MOVI|X, BX| mlast IL, 
( 0804,81FB )                  JMPS, L0804,8210 RB,
( 0804,81FD )   :H_find   dl H_mfind X_find 

( 0804,8205 )   :N_find   d$  4  "find"

( 0804,820A )   :X_find    PUSH|X, BX| 
( 0804,820B )                  MOVI|X, BX| flast IL, 
( 0804,8210 )   :L0804,8210    PUSH|X, CX| 
( 0804,8211 )                  MOV, X| F| AX'| R| CX| 
( 0804,8213 )                  LODS, X'| 
( 0804,8214 )   :L0804,8214    MOV, X| T| BX'| ZO| [BX] 
( 0804,8216 )                  OR, X| F| BX'| R| BX| 
( 0804,8218 )                  J, Z| Y| L0804,8234 RB,
( 0804,821A )                  CMP, B| T| CL'| BO| [BX] 8 B, 
( 0804,821D )                  J, Z| N| L0804,8214 RB,
( 0804,821F )                  PUSH|X, SI| 
( 0804,8220 )                  PUSH|X, DI| 
( 0804,8221 )                  PUSH|X, CX| 
( 0804,8222 )                  MOV, X| F| AX'| R| SI| 
( 0804,8224 )                  LEA, DI'| BO| [BX] 9 B, 
( 0804,8227 )                  REPZ, 
( 0804,8228 )                  CMPS, B'| 
( 0804,8229 )                  POP|X, CX| 
( 0804,822A )                  POP|X, DI| 
( 0804,822B )                  POP|X, SI| 
( 0804,822C )                  J, Z| N| L0804,8214 RB,
( 0804,822E )                  MOV, X| T| AX'| BO| [BX] 4 B, 
( 0804,8231 )                  CLC, 
( 0804,8232 )                  JMPS, L0804,823C RB,
( 0804,8234 )   :L0804,8234    SUBSI, R| SI| 4 IS, 
( 0804,8237 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8239 )                  MOV, X| F| CX'| R| AX| 
( 0804,823B )                  STC, 
( 0804,823C )   :L0804,823C    POP|X, CX| 
( 0804,823D )                  POP|X, BX| 
( 0804,823E )                  RET, 
( 0804,823F )   :H_>number   dl H_find X_>number 

( 0804,8247 )   :N_>number   d$  7  ">number"

( 0804,824F )   :X_>number    PUSH, MEM| V_base L, 
( 0804,8255 )                  MOV, X| F| AX'| R| CX| 
( 0804,8257 )                  MOV, X| T| BX'| ZO| [SI] 
( 0804,8259 )                  SUBSI, R| SI| 4 IS, 
( 0804,825C )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,825E )                  XOR, X| F| AX'| R| AX| 
( 0804,8260 )                  XOR, X| F| DX'| R| DX| 
( 0804,8262 )                  MOV, B| T| DL'| ZO| [BX] 
( 0804,8264 )                  CMPI, B| R| DL| 2D IB, 
( 0804,8267 )                  PUSHF, 
( 0804,8268 )                  J, Z| N| L0804,826E RB,
( 0804,826A )                  INC|X, BX| 
( 0804,826B )                  DEC|X, CX| 
( 0804,826C )                  MOV, B| T| DL'| ZO| [BX] 
( 0804,826E )   :L0804,826E    SUBI, B| R| DL| 24 IB, 
( 0804,8271 )                  CMPI, B| R| DL| 4 IB, 
( 0804,8274 )                  J, CZ| N| L0804,8284 RB,
( 0804,8276 )                  MOV, B| T| DL'| XO| [DX] bases L, 
( 0804,827C )                  MOV, B| F| DL'| MEM| V_base L, 
( 0804,8282 )                  INC|X, BX| 
( 0804,8283 )                  DEC|X, CX| 
( 0804,8284 )   :L0804,8284    MOV, B| T| DL'| ZO| [BX] 
( 0804,8286 )                  INC|X, BX| 
( 0804,8287 )                  CALL, L0804,82A9 RL,
( 0804,828C )                  J, C| Y| L0804,8292 RB,
( 0804,828E )                  LOOP, L0804,8284 RB,
( 0804,8290 )                  JMPS, L0804,8299 RB,
( 0804,8292 )   :L0804,8292    ADDSI, R| SP| 4 IS, 
( 0804,8295 )                  LODS, X'| 
( 0804,8296 )                  STC, 
( 0804,8297 )                  JMPS, L0804,82A2 RB,
( 0804,8299 )   :L0804,8299    POPF, 
( 0804,829A )                  J, Z| N| L0804,829E RB,
( 0804,829C )                  NEG, X| R| AX| 
( 0804,829E )   :L0804,829E    ADDSI, R| SI| 8 IS, 
( 0804,82A1 )                  CLC, 
( 0804,82A2 )   :L0804,82A2    POP, MEM| V_base L, 
( 0804,82A8 )                  RET, 
( 0804,82A9 )   :L0804,82A9    CMPI, B| MEM| V_base L, 0FF IB, 
( 0804,82B0 )                  J, Z| Y| L0804,82CF RB,
( 0804,82B2 )                  CMPI, B| R| DL| 39 IB, 
( 0804,82B5 )                  J, CZ| Y| L0804,82C2 RB,
( 0804,82B7 )                  ANDI, B| R| DL| 5F IB, 
( 0804,82BA )                  CMPI, B| R| DL| 41 IB, 
( 0804,82BD )                  J, C| Y| L0804,82CD RB,
( 0804,82BF )                  SUBI, B| R| DL| 7 IB, 
( 0804,82C2 )   :L0804,82C2    SUBI, B| R| DL| 30 IB, 
( 0804,82C5 )                  CMP, B| T| DL'| MEM| V_base L, 
( 0804,82CB )                  J, C| Y| L0804,82CF RB,
( 0804,82CD )   :L0804,82CD    STC, 
( 0804,82CE )                  RET, 
( 0804,82CF )   :L0804,82CF    IMUL, AX'| MEM| V_base L, 
( 0804,82D6 )                  ADD, X| F| DX'| R| AX| 
( 0804,82D8 )                  CLC, 
( 0804,82D9 )                  RET, 
( 0804,82DA )   :L0804,82DA    MOV, X| T| CX'| MEM| source L, 
( 0804,82E0 )                  OR, X| F| CX'| R| CX| 
( 0804,82E2 )                  J, Z| N| L0804,8317 RB,
( 0804,82E4 )                  MOVI, X| MEM| tp L, tib IL, 
( 0804,82EE )                  MOVI, X| MEM| tin L, tib IL, 
( 0804,82F8 )   :L0804,82F8    CALL, X_key RL,
( 0804,82FD )                  CMPI|A, B'| 0D IB, 
( 0804,82FF )                  J, Z| Y| L0804,8315 RB,
( 0804,8301 )                  CMPI|A, B'| 0A IB, 
( 0804,8303 )                  J, Z| Y| L0804,8315 RB,
( 0804,8305 )                  XCHG, X| DI'| MEM| tp L, 
( 0804,830B )                  STOS, B'| 
( 0804,830C )                  XCHG, X| DI'| MEM| tp L, 
( 0804,8312 )                  LODS, X'| 
( 0804,8313 )                  JMPS, L0804,82F8 RB,
( 0804,8315 )   :L0804,8315    LODS, X'| 
( 0804,8316 )                  RET, 
( 0804,8317 )   :L0804,8317    MOV, X| T| DI'| MEM| tin L, 
( 0804,831D )                  SUBSI, R| SI| 4 IS, 
( 0804,8320 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8322 )                  MOV, X| F| DI'| R| AX| 
( 0804,8324 )                  SUBSI, R| SI| 4 IS, 
( 0804,8327 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8329 )                  CMPI, B| ZO| [DI] 0A IB, 
( 0804,832C )                  J, Z| N| L0804,832F RB,
( 0804,832E )                  INC|X, DI| 
( 0804,832F )   :L0804,832F    MOV, X| F| DI'| MEM| tin L, 
( 0804,8335 )                  SUB, X| F| DI'| R| CX| 
( 0804,8337 )                  J, CZ| Y| L0804,8351 RB,
( 0804,8339 )                  MOVI|B, AL| 0A IB, 
( 0804,833B )                  REPNZ, 
( 0804,833C )                  SCAS, B'| 
( 0804,833D )                  MOV, X| F| DI'| R| AX| 
( 0804,833F )                  J, Z| N| L0804,8349 RB,
( 0804,8341 )                  DEC|X, AX| 
( 0804,8342 )                  CMPI, B| BO| [AX] 0FF B, 0D IB, 
( 0804,8346 )                  J, Z| N| L0804,8349 RB,
( 0804,8348 )                  DEC|X, AX| 
( 0804,8349 )   :L0804,8349    MOV|FA, X'| tp L, 
( 0804,834E )                  LODS, X'| 
( 0804,834F )                  LODS, X'| 
( 0804,8350 )                  RET, 
( 0804,8351 )   :L0804,8351    LODS, X'| 
( 0804,8352 )                  LODS, X'| 
( 0804,8353 )                  ADDSI, R| SP| 4 IS, 
( 0804,8356 )                  POP, MEM| tp L, 
( 0804,835C )                  POP, MEM| tin L, 
( 0804,8362 )                  POP, MEM| source L, 
( 0804,8368 )                  RET, 
( 0804,8369 )   :H_eval   dl H_>number X_eval 

( 0804,8371 )   :N_eval   d$  4  "eval"

( 0804,8376 )   :X_eval    PUSH, MEM| source L, 
( 0804,837C )                  PUSH, MEM| tin L, 
( 0804,8382 )                  PUSH, MEM| tp L, 
( 0804,8388 )                  ADD, X| T| AX'| ZO| [SI] 
( 0804,838A )                  MOV|FA, X'| source L, 
( 0804,838F )                  LODS, X'| 
( 0804,8390 )                  MOV|FA, X'| tin L, 
( 0804,8395 )                  LODS, X'| 
( 0804,8396 )                  JMP, L0804,81B0 RL,
( 0804,839B )   :L0804,839B    RET, 
( 0804,839C )   :dovar    SUBSI, R| SI| 4 IS, 
( 0804,839F )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,83A1 )                  POP|X, AX| 
( 0804,83A2 )                  RET, 
( 0804,83A3 )   :H_,   dl H_eval X_, 

( 0804,83AB )   :N_,   d$  1  &,

( 0804,83AD )   :X_,    MOVI|X, CX| 4 IL, 
( 0804,83B2 )   :L0804,83B2    MOV, X| T| DX'| MEM| V_h0 L, 
( 0804,83B8 )                  MOV, X| F| AX'| ZO| [DX] 
( 0804,83BA )                  LODS, X'| 
( 0804,83BB )                  ADD, X| F| CX'| R| DX| 
( 0804,83BD )                  MOV, X| F| DX'| MEM| V_h0 L, 
( 0804,83C3 )                  MOVI, X| MEM| tail L, -1 IL, 
( 0804,83CD )                  RET, 
( 0804,83CE )   :H_1,   dl H_, X_1, 

( 0804,83D6 )   :N_1,   d$  2  "1,"

( 0804,83D9 )   :X_1,    MOVI|X, CX| 1 IL, 
( 0804,83DE )                  JMPS, L0804,83B2 RB,
( 0804,83E0 )   :H_2,   dl H_1, X_2, 

( 0804,83E8 )   :N_2,   d$  2  "2,"

( 0804,83EB )   :X_2,    MOVI|X, CX| 2 IL, 
( 0804,83F0 )                  JMPS, L0804,83B2 RB,
( 0804,83F2 )   :H_3,   dl H_2, X_3, 

( 0804,83FA )   :N_3,   d$  2  "3,"

( 0804,83FD )   :X_3,    MOVI|X, CX| 3 IL, 
( 0804,8402 )                  JMPS, L0804,83B2 RB,
( 0804,8404 )   :L0804,8404    SUBSI, R| SI| 4 IS, 
( 0804,8407 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8409 )                  POP|X, AX| 
( 0804,840A )                  XCHG, X| AX'| ZO|    [SP +1* 0] 
( 0804,840D )                  RET, 
( 0804,840E )   :L0804,840E    SUBSI, R| SI| 4 IS, 
( 0804,8411 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8413 )                  MOV, X| T| AX'| ZO|    [SP +1* 0] 
( 0804,8416 )                  MOV, X| T| AX'| ZO| [AX] 
( 0804,8418 )                  ADDSI, ZO|    [SP +1* 0] 4 IS, 
( 0804,841C )                  RET, 
( 0804,841D )   :H_create   dl H_3, X_create 

( 0804,8425 )   :N_create   d$  6  "create"

( 0804,842C )   :X_create    SUBSI, R| SI| 4 IS, 
( 0804,842F )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8431 )                  MOVI|X, AX| 20 IL, 
( 0804,8436 )                  CALL, X_parse RL,
( 0804,843B )                  JMPS, X_(create) RB,
( 0804,843D )   :H_(create)   dl H_create X_(create) 

( 0804,8445 )   :N_(create)   d$  8  "(create)"

( 0804,844E )   :X_(create)    PUSH|X, CX| 
( 0804,844F )                  MOV, X| T| DI'| MEM| V_d0 L, 
( 0804,8455 )                  MOV, X| T| CX'| MEM| last L, 
( 0804,845B )                  MOV, X| T| DX'| ZO| [CX] 
( 0804,845D )                  MOV, X| F| DX'| ZO| [DI] 
( 0804,845F )                  MOV, X| F| DI'| ZO| [CX] 
( 0804,8461 )                  MOV, X| T| CX'| MEM| V_h0 L, 
( 0804,8467 )                  MOV, X| F| CX'| BO| [DI] 4 B, 
( 0804,846A )                  MOV, B| F| AL'| BO| [DI] 8 B, 
( 0804,846D )                  ADDSI, R| DI| 9 IS, 
( 0804,8470 )                  MOV, X| F| AX'| R| CX| 
( 0804,8472 )                  LODS, X'| 
( 0804,8473 )                  PUSH|X, SI| 
( 0804,8474 )                  MOV, X| F| AX'| R| SI| 
( 0804,8476 )                  REPZ, 
( 0804,8477 )                  MOVS, B'| 
( 0804,8478 )                  MOV, X| F| DI'| MEM| V_d0 L, 
( 0804,847E )                  POP|X, SI| 
( 0804,847F )                  POP|X, CX| 
( 0804,8480 )                  MOVI|X, AX| dovar IL, 
( 0804,8485 )                  JMP, X_compile RL,
( 0804,848A )   :H_mdoes>   dl 0 X_mdoes> 

( 0804,8492 )   :N_mdoes>   d$  5  "does>"

( 0804,8498 )   :X_mdoes>    SUBSI, R| SI| 4 IS, 
( 0804,849B )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,849D )                  MOVI|X, AX| L0804,84B6 IL, 
( 0804,84A2 )                  CALL, X_compile RL,
( 0804,84A7 )                  SUBSI, R| SI| 4 IS, 
( 0804,84AA )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,84AC )                  MOVI|X, AX| L0804,8404 IL, 
( 0804,84B1 )                  JMP, X_compile RL,
( 0804,84B6 )   :L0804,84B6    SUBSI, R| SI| 4 IS, 
( 0804,84B9 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,84BB )                  MOV|TA, X'| last L, 
( 0804,84C0 )                  MOV, X| T| AX'| ZO| [AX] 
( 0804,84C2 )                  MOV, X| T| AX'| BO| [AX] 4 B, 
( 0804,84C5 )                  POP|X, BX| 
( 0804,84C6 )                  SUB, X| F| AX'| R| BX| 
( 0804,84C8 )   :L0804,84C8    SUBSI, R| BX| 5 IS, 
( 0804,84CB )                  MOV, X| F| BX'| BO| [AX] 1 B, 
( 0804,84CE )                  LODS, X'| 
( 0804,84CF )                  RET, 
( 0804,84D0 )   :H_]   dl H_(create) X_] 

( 0804,84D8 )   :N_]   d$  1  &]

( 0804,84DA )   :X_]    SUBSI, R| SI| 4 IS, 
( 0804,84DD )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,84DF )                  MOVI|X, AX| 20 IL, 
( 0804,84E4 )                  CALL, X_parse RL,
( 0804,84E9 )                  J, Z| N| L0804,84F4 RB,
( 0804,84EB )                  LODS, X'| 
( 0804,84EC )                  LODS, X'| 
( 0804,84ED )                  CALL, L0804,82DA RL,
( 0804,84F2 )                  JMPS, X_] RB,
( 0804,84F4 )   :L0804,84F4    CALL, X_mfind RL,
( 0804,84F9 )                  J, C| N| L0804,851F RB,
( 0804,84FB )                  CALL, X_find RL,
( 0804,8500 )                  J, C| N| L0804,8526 RB,
( 0804,8502 )                  CALL, X_>number RL,
( 0804,8507 )                  J, C| N| L0804,852D RB,
( 0804,8509 )                  CALL, L0804,8739 RL,
( 0804,850E )                  SUBSI, R| SI| 4 IS, 
( 0804,8511 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8513 )                  MOVI|X, AX| 0C3 IL, 
( 0804,8518 )                  CALL, X_1, RL,
( 0804,851D )                  JMPS, X_] RB,
( 0804,851F )   :L0804,851F    MOV, X| F| AX'| R| DI| 
( 0804,8521 )                  LODS, X'| 
( 0804,8522 )                  CALLO, R| DI| 
( 0804,8524 )                  JMPS, X_] RB,
( 0804,8526 )   :L0804,8526    CALL, X_compile RL,
( 0804,852B )                  JMPS, X_] RB,
( 0804,852D )   :L0804,852D    SUBSI, R| SI| 4 IS, 
( 0804,8530 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8532 )                  MOVI|X, AX| L0804,840E IL, 
( 0804,8537 )                  CALL, X_compile RL,
( 0804,853C )                  CALL, X_, RL,
( 0804,8541 )                  JMPS, X_] RB,
( 0804,8543 )   :H_compile   dl H_] X_compile 

( 0804,854B )   :N_compile   d$  7  "compile"

( 0804,8553 )   :X_compile    SUB, X| T| AX'| MEM| V_h0 L, 
( 0804,8559 )                  SUBSI, R| AX| 5 IS, 
( 0804,855C )                  SUBSI, R| SI| 4 IS, 
( 0804,855F )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8561 )                  MOVI|X, AX| 0E8 IL, 
( 0804,8566 )                  CALL, X_1, RL,
( 0804,856B )                  CALL, X_, RL,
( 0804,8570 )                  MOVI, X| MEM| tail L, 0 IL, 
( 0804,857A )                  RET, 
( 0804,857B )   :H_m[   dl H_mdoes> X_m[ 

( 0804,8583 )   :N_m[   d$  1  &[

( 0804,8585 )   :X_m[    ADDSI, R| SP| 4 IS, 
( 0804,8588 )                  RET, 
( 0804,8589 )   :H_m;;   dl H_m[ X_m;; 

( 0804,8591 )   :N_m;;   d$  2  ";;"

( 0804,8594 )   :X_m;;    MOV, X| T| DX'| MEM| V_h0 L, 
( 0804,859A )                  SUBSI, R| DX| 5 IS, 
( 0804,859D )                  CMPI, B| ZO| [DX] 0E8 IB, 
( 0804,85A0 )                  J, Z| N| L0804,85AE RB,
( 0804,85A2 )                  CMPSI, MEM| tail L, 0 IS, 
( 0804,85A9 )                  J, Z| N| L0804,85AE RB,
( 0804,85AB )                  INC, B| ZO| [DX] 
( 0804,85AD )                  RET, 
( 0804,85AE )   :L0804,85AE    MOVI, B| BO| [DX] 5 B, 0C3 IB, 
( 0804,85B2 )                  INC, X| MEM| V_h0 L, 
( 0804,85B8 )                  RET, 
( 0804,85B9 )   :H_m;   dl H_m;; X_m; 

( 0804,85C1 )   :N_m;   d$  1  &;

( 0804,85C3 )   :X_m;    CALL, X_m;; RL,
( 0804,85C8 )                  JMPS, X_m[ RB,
( 0804,85CA )   :H_:   dl H_compile X_: 

( 0804,85D2 )   :N_:   d$  1  &:

( 0804,85D4 )   :X_:    CALL, X_create RL,
( 0804,85D9 )                  SUBSI, MEM| V_h0 L, 5 IS, 
( 0804,85E0 )                  JMP, X_] RL,
( 0804,85E5 )   :H_mliteral :last_dea_macro   dl H_m; X_mliteral 

( 0804,85ED )   :N_mliteral   d$  7  "literal"

( 0804,85F5 )   :X_mliteral    SUBSI, R| SI| 4 IS, 
( 0804,85F8 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,85FA )                  MOVI|X, AX| L0804,840E IL, 
( 0804,85FF )                  CALL, X_compile RL,
( 0804,8604 )                  CALL, X_, RL,
( 0804,8609 )                  RET, 
( 0804,860A )   :H_forth   dl H_: X_forth 

( 0804,8612 )   :N_forth   d$  5  "forth"

( 0804,8618 )   :X_forth    MOVI, X| MEM| last L, flast IL, 
( 0804,8622 )                  RET, 
( 0804,8623 )   :H_macro   dl H_forth X_macro 

( 0804,862B )   :N_macro   d$  5  "macro"

( 0804,8631 )   :X_macro    MOVI, X| MEM| last L, mlast IL, 
( 0804,863B )                  RET, 
( 0804,863C )   :H_.   dl H_macro X_. 

( 0804,8644 )   :N_.   d$  1  &.

( 0804,8646 )   :X_.    PUSH|X, DX| 
( 0804,8647 )                  PUSH|X, DI| 
( 0804,8648 )                  MOV, X| F| SI'| R| DI| 
( 0804,864A )                  SUBSI, R| DI| 4 IS, 
( 0804,864D )                  OR, X| F| AX'| R| AX| 
( 0804,864F )                  J, S| N| L0804,8662 RB,
( 0804,8651 )                  NEG, X| R| AX| 
( 0804,8653 )                  SUBSI, R| SI| 4 IS, 
( 0804,8656 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8658 )                  MOVI|X, AX| 2D IL, 
( 0804,865D )                  CALL, X_emit RL,
( 0804,8662 )   :L0804,8662    XOR, X| F| DX'| R| DX| 
( 0804,8664 )                  DIV|AD, X| MEM| V_base L, 
( 0804,866A )                  ADDI, B| R| DL| 30 IB, 
( 0804,866D )                  CMPI, B| R| DL| 39 IB, 
( 0804,8670 )                  J, CZ| Y| L0804,8675 RB,
( 0804,8672 )                  ADDI, B| R| DL| 27 IB, 
( 0804,8675 )   :L0804,8675    DEC|X, DI| 
( 0804,8676 )                  MOV, B| F| DL'| ZO| [DI] 
( 0804,8678 )                  OR, X| F| AX'| R| AX| 
( 0804,867A )                  J, Z| N| L0804,8662 RB,
( 0804,867C )                  MOV, X| F| DI'| R| AX| 
( 0804,867E )                  SUBSI, R| SI| 4 IS, 
( 0804,8681 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8683 )                  MOV, X| F| SI'| R| AX| 
( 0804,8685 )                  SUB, X| F| DI'| R| AX| 
( 0804,8687 )                  CALL, X_type RL,
( 0804,868C )                  POP|X, DI| 
( 0804,868D )                  POP|X, DX| 
( 0804,868E )                  SUBSI, R| SI| 4 IS, 
( 0804,8691 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8693 )                  MOVI|X, AX| 20 IL, 
( 0804,8698 )                  CALL, X_emit RL,
( 0804,869D )                  RET, 
( 0804,869E )   :H_type   dl H_. X_type 

( 0804,86A6 )   :N_type   d$  4  "type"

( 0804,86AB )   :X_type    PUSH|X, BX| 
( 0804,86AC )                  PUSH|X, CX| 
( 0804,86AD )                  MOV, X| F| AX'| R| CX| 
( 0804,86AF )                  LODS, X'| 
( 0804,86B0 )                  MOV, X| F| AX'| R| BX| 
( 0804,86B2 )                  LODS, X'| 
( 0804,86B3 )                  OR, X| F| CX'| R| CX| 
( 0804,86B5 )                  J, Z| Y| L0804,86CA RB,
( 0804,86B7 )   :L0804,86B7    PUSH|X, CX| 
( 0804,86B8 )                  SUBSI, R| SI| 4 IS, 
( 0804,86BB )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,86BD )                  XOR, X| F| AX'| R| AX| 
( 0804,86BF )                  MOV, B| T| AL'| ZO| [BX] 
( 0804,86C1 )                  INC|X, BX| 
( 0804,86C2 )                  CALL, X_emit RL,
( 0804,86C7 )                  POP|X, CX| 
( 0804,86C8 )                  LOOP, L0804,86B7 RB,
( 0804,86CA )   :L0804,86CA    POP|X, CX| 
( 0804,86CB )                  POP|X, BX| 
( 0804,86CC )                  RET, 
( 0804,86CD )   :H_parse   dl H_type X_parse 

( 0804,86D5 )   :N_parse   d$  5  "parse"

( 0804,86DB )   :X_parse    MOV, X| T| DI'| MEM| tin L, 
( 0804,86E1 )                  MOV, X| T| CX'| MEM| tp L, 
( 0804,86E7 )                  SUB, X| F| DI'| R| CX| 
( 0804,86E9 )                  INC|X, CX| 
( 0804,86EA )                  REPZ, 
( 0804,86EB )                  SCAS, B'| 
( 0804,86EC )                  DEC|X, DI| 
( 0804,86ED )                  INC|X, CX| 
( 0804,86EE )                  SUBSI, R| SI| 4 IS, 
( 0804,86F1 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,86F3 )                  MOV, X| F| DI'| ZO| [SI] 
( 0804,86F5 )                  REPNZ, 
( 0804,86F6 )                  SCAS, B'| 
( 0804,86F7 )                  MOV, X| F| DI'| R| AX| 
( 0804,86F9 )                  DEC|X, AX| 
( 0804,86FA )                  SUB, X| T| AX'| ZO| [SI] 
( 0804,86FC )                  MOV, X| F| DI'| MEM| tin L, 
( 0804,8702 )                  RET, 
( 0804,8703 )   :H_reset   dl H_parse X_reset 

( 0804,870B )   :N_reset   d$  5  "reset"

( 0804,8711 )   :X_reset    MOVI|X, SI| s0 IL, 
( 0804,8716 )                  RET, 
( 0804,8717 )   :H_cmove   dl H_reset X_cmove 

( 0804,871F )   :N_cmove   d$  5  "cmove"

( 0804,8725 )   :X_cmove    MOV, X| F| AX'| R| CX| 
( 0804,8727 )                  LODS, X'| 
( 0804,8728 )                  MOV, X| F| AX'| R| DI| 
( 0804,872A )                  LODS, X'| 
( 0804,872B )                  PUSH|X, SI| 
( 0804,872C )                  MOV, X| F| AX'| R| SI| 
( 0804,872E )   :L0804,872E    MOV, B| T| DL'| ZO| [SI] 
( 0804,8730 )                  MOV, B| F| DL'| ZO| [DI] 
( 0804,8732 )                  INC|X, DI| 
( 0804,8733 )                  INC|X, SI| 
( 0804,8734 )                  LOOP, L0804,872E RB,
( 0804,8736 )                  POP|X, SI| 
( 0804,8737 )                  LODS, X'| 
( 0804,8738 )                  RET, 
( 0804,8739 )   :L0804,8739    CALL, X_type RL,
( 0804,873E )                  SUBSI, R| SI| 4 IS, 
( 0804,8741 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8743 )                  MOVI|X, AX| 3F IL, 
( 0804,8748 )                  CALL, X_emit RL,
( 0804,874D )                  SUBSI, R| SI| 4 IS, 
( 0804,8750 )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,8752 )                  MOVI|X, AX| 0A IL, 
( 0804,8757 )                  CALL, X_emit RL,
( 0804,875C )                  RET, 
( 0804,875D )   :H_last   dl H_cmove X_last 

( 0804,8765 )   :N_last   d$  4  "last"

( 0804,876A )   :X_last    SUBSI, R| SI| 4 IS, 
( 0804,876D )                  MOV, X| F| AX'| ZO| [SI] 
( 0804,876F )                  MOVI|X, AX| last IL, 
( 0804,8774 )                  RET, 
( 0804,8775 )   :H_h0   dl H_last X_h0 

( 0804,877D )   :N_h0   d$  2  "h0"

( 0804,8780 )   :X_h0    CALL, dovar RL,
( 0804,8785 )   :V_h0   dl dictend 
( 0804,8789 )   :H_d0   dl H_h0 X_d0 

( 0804,8791 )   :N_d0   d$  2  "d0"

( 0804,8794 )   :X_d0    CALL, dovar RL,
( 0804,8799 )   :V_d0   dl d0 
( 0804,879D )   :H_base :last_dea_forth   dl H_d0 X_base 

( 0804,87A5 )   :N_base   d$  4  "base"

( 0804,87AA )   :X_base    CALL, dovar RL,
( 0804,87AF )   :V_base   dl 0A 
( 0804,87B3 )   :tail   dl 0 \   Allow tail-calls?
( 0804,87B7 )   :buffer   dl 0 \   Buffer (for ports to use as needed)
( 0804,87BB )   :source   dl 0 \   Evaluate from RAM or KBD
( 0804,87BF )   :tin   dl 0 \   >IN
( 0804,87C3 )   :tp   dl tib \   TP (pointer to input buffer)

( 0804,87C7 )   :bases   db 10 2 8 0FF \   $hex %bin &oct 'ascii

( 0804,87CB )   :last   dl flast \   Last word in dictionary
( 0804,87CF )   :flast   dl H_base \   Last word in 'forth'
( 0804,87D3 )   :mlast   dl H_mliteral \   Last word in 'macro'

( 0804,87D7 )   :retroforth_f   d$  " forth" ^J
( 0804,87DE )                 d$  ": swap [ $0687 2, ] ;" ^J
( 0804,87F4 )                 d$  ": drop [ $ad 1, ] ;" ^J
( 0804,8808 )                 d$  ": dup [ $fc4689 3, $fc768d 3, ] ;" ^J
( 0804,882A )                 d$  ": nip swap drop ;" ^J
( 0804,883C )                 d$  ": and [ $0623 2, ] nip ;" ^J
( 0804,8855 )                 d$  ": or [ $060b 2, ] nip ;" ^J
( 0804,886D )                 d$  ": xor [ $0633 2, ] nip ;" ^J
( 0804,8886 )                 d$  ": >> [ $c189 2, $d3ad 2, $e8 1, ] ;" ^J
( 0804,88AA )                 d$  ": not -1 xor ;          " ^J
( 0804,88C3 )                 d$  ": @ [ $008b 2, ] ;" ^J
( 0804,88D6 )                 d$  ": ! [ $c289 2, $89ad 2, $ad02 2, ] ;" ^J
( 0804,88FB )                 d$  ": c@ @ $ff and ;" ^J
( 0804,890C )                 d$  ": c! [ $c289 2, ] drop [ $0288 2, ] drop ;" ^J
( 0804,8937 )                 d$  ": + [ $0603 2, ] nip ;" ^J
( 0804,894E )                 d$  ": * [ $26f7 2, ] nip ;" ^J
( 0804,8965 )                 d$  ": negate -1 * ;" ^J
( 0804,8975 )                 d$  ": - negate + ;" ^J
( 0804,8984 )                 d$  ": / [ $c389 2, $99ad 2, $fbf7 2, ] ;" ^J
( 0804,89A9 )                 d$  ": mod / [ $d089 2, ] ;" ^J
( 0804,89C0 )                 d$  " forth" ^J
( 0804,89C7 )                 d$  ": variable create 0 , ;" ^J
( 0804,89DF )                 d$  ": variable, create , ;" ^J
( 0804,89F6 )                 d$  ": constant create , does> @ ;" ^J
( 0804,8A14 )                 d$  ": here h0 @ ;" ^J
( 0804,8A22 )                 d$  " macro" ^J
( 0804,8A29 )                 d$  ": : create here -5 + h0 ! ;" ^J
( 0804,8A45 )                 d$  ": repeat here ;" ^J
( 0804,8A55 )                 d$  ": again compile ;" ^J
( 0804,8A67 )                 d$  ": until $48 1, $c009 2, $850f 2, here - 4 - , $ad 1, ;" ^J
( 0804,8A9E )                 d$  ": f: 32 parse find compile ;" ^J
( 0804,8ABB )                 d$  ": m: 32 parse mfind compile ;" ^J
( 0804,8AD9 )                 d$  ": >r $ad50 2, ;" ^J
( 0804,8AE9 )                 d$  ": r> $83 1, $ee 1, $04 1, $89 1, $06 1, $58 1, ;" ^J
( 0804,8B1A )                 d$  ": <>if $063b 2, $adad 2, $74 1, here 0 1, ;" ^J
( 0804,8B46 )                 d$  ": =if  $063b 2, $adad 2, $75 1, here 0 1, ;" ^J
( 0804,8B72 )                 d$  ": <if  $063b 2, $adad 2, $7e 1, here 0 1, ;" ^J
( 0804,8B9E )                 d$  ": >if  $063b 2, $adad 2, $7d 1, here 0 1, ;" ^J
( 0804,8BCA )                 d$  ": then dup here swap - 1 - swap c! $90 1, ;" ^J
( 0804,8BF6 )                 d$  ": ( ') parse drop drop ;" ^J
( 0804,8C0F )                 d$  ": | 10 parse drop drop ;" ^J
( 0804,8C28 )                 d$  ": 1+ $40 1, ;  : 1- $48 1, ;" ^J
( 0804,8C45 )                 d$  ": ['] 32 parse find m: literal ;" ^J
( 0804,8C66 )                 d$  ^J " forth" ^J
( 0804,8C6E )                 d$  ": rot >r swap r> swap ;" ^J
( 0804,8C86 )                 d$  ": -rot rot rot ;" ^J
( 0804,8C97 )                 d$  ": over swap dup -rot ;" ^J
( 0804,8CAE )                 d$  ": tuck swap over ;" ^J
( 0804,8CC1 )                 d$  ": 2dup over over ;" ^J
( 0804,8CD4 )                 d$  ": 2drop drop drop ;" ^J
( 0804,8CE8 )                 d$  ": +! over @ + swap ! ;" ^J
( 0804,8CFF )                 d$  ": hex 16 base ! ;" ^J
( 0804,8D11 )                 d$  ": decimal 10 base ! ;" ^J
( 0804,8D27 )                 d$  ": binary 2 base ! ;" ^J
( 0804,8D3B )                 d$  ": octal 8 base ! ;" ^J
( 0804,8D4E )                 d$  ": /mod over over / -rot mod ;" ^J
( 0804,8D6C )                 d$  ": */ >r * r> / ;" ^J
( 0804,8D7D )                 d$  ": pad here 1024 + ;" ^J
( 0804,8D91 )                 d$  ": allot here + h0 ! ;" ^J
( 0804,8DA7 )                 d$  ": align 0 here 4 mod allot ;" ^J
( 0804,8DC4 )                 d$  ": cell+ 4 + ;  : cells 4 * ;" ^J
( 0804,8DE1 )                 d$  ": char+ 1 + ;  : chars 1 * ;" ^J
( 0804,8DFE )                 d$  ": 2over >r >r 2dup r> -rot r> -rot ;" ^J
( 0804,8E23 )                 d$  ": 2swap rot >r rot r> ;" ^J
( 0804,8E3B )                 d$  " forth" ^J
( 0804,8E42 )                 d$  "25 variable, lines" ^J
( 0804,8E55 )                 d$  "80 variable, columns" ^J
( 0804,8E6A )                 d$  ": ' 32 parse find ;" ^J
( 0804,8E7E )                 d$  ": execute >r ;" ^J
( 0804,8E8D )                 d$  ": alias create , does> @ >r ;" ^J
( 0804,8EAB )                 d$  ": fill swap repeat >r swap 2dup c! 1+ swap r> until 2drop ;" ^J
( 0804,8EE7 )                 d$  ": 0; dup 0 =if r> 2drop ;; then ;" ^J
( 0804,8F09 )                 d$  ": << repeat >r dup + r> until ;" ^J
( 0804,8F29 )                 d$  ": cr 10 emit ;" ^J
( 0804,8F38 )                 d$  ": space 32 emit ;" ^J
( 0804,8F4A )                 d$  ": tab 9 emit ;" ^J
( 0804,8F59 )                 d$  ": del 8 emit ;" ^J
( 0804,8F68 )                 d$  ": clear lines @ repeat cr until ;" ^J
( 0804,8F8A )                 d$  ": >pad dup >r pad swap cmove pad r> ;" ^J
( 0804,8FB0 )                 d$  ": words last @ repeat @ 0; dup 8 + dup 1+ swap c@ type space aga"
( 0804,8FF0 )                 d$  "in ;" ^J
( 0804,8FF5 )                 d$  ": zt-make here over 4 / 1+ cells dup allot >r" ^J
( 0804,9023 )                 d$  "          2dup + >r dup >r" ^J
( 0804,903E )                 d$  "          swap cmove r> 0 r> c! r> ;" ^J
( 0804,9063 )                 d$  ": zt-free negate allot ;" ^J
( 0804,907C )                 d$  ": | 10 parse 2drop ;" ^J
( 0804,9091 )                 d$  " forth" ^J
( 0804,9098 )                 d$  "variable s0" ^J
( 0804,90A4 )                 d$  ": "" '"" parse >pad ;" ^J
( 0804,90B8 )                 d$  ": ."" "" type ;" ^J
( 0804,90C6 )                 d$  ": $, 2dup s0 @ swap cmove swap drop s0 @ m: literal dup s0 @ + s"
( 0804,9106 )                 d$  "0 ! m: literal ;" ^J
( 0804,9117 )                 d$  " macro" ^J
( 0804,911E )                 d$  ": s"" '"" parse $, ;" ^J
( 0804,9131 )                 d$  " forth" ^J
( 0804,9138 )                 d$  "here s0 ! 4096 allot" ^J
( 0804,914D )                 d$  ": version# 7 5 1 ;" ^J
( 0804,9160 )                 d$  ": .version s"" RetroForth "" type" ^J
( 0804,9180 )                 d$  "  version# rot . del '. emit swap . del '. emit . cr ;" ^J

( 0804,91B7 )   :tib :_end 
