BITS-32
8049000  ORG

\   _end e_ident - EQU filesz      
 INCLUDE lina405equ.cul   
( 0804,9000 )   :e_ident   d$  7F  "ELF" 1 
( 0804,9005 )                 d$  1  1  0  0  0  0  0  0  0  0  0 

( 0804,9010 )   :e_type   dw 0002 
( 0804,9012 )   :e_machine   dw 0003 

( 0804,9014 )   :e_version   dl 1 
( 0804,9018 )   :e_entry   dl _start 
( 0804,901C )   :e_phoff   dl 34 
( 0804,9020 )   :e_shoff   dl 6890 
( 0804,9024 )   :e_flags   dl 0 

( 0804,9028 )   :e_ehsize   dw 0034 
( 0804,902A )   :e_phentsize   dw 0020 
( 0804,902C )   :e_phnum   dw 0001 
( 0804,902E )   :e_shentsize   dw 0028 
( 0804,9030 )   :e_shnum   dw 0006 
( 0804,9032 )   :e_shstrndx   dw 0005 

( 0804,9034 )   :p_type :e_headerend   dl 1 
( 0804,9038 )   :p_offset   dl 0 
( 0804,903C )   :p_vaddr   dl e_ident 
( 0804,9040 )   :p_paddr   dl e_ident 
( 0804,9044 )   :p_filesz   dl filesz 
( 0804,9048 )   :p_memsz   dl 0400,0078 
( 0804,904C )   :p_flags   dl 7 
( 0804,9050 )   :p_align   dl 1000 

( 0804,9054 )   :p_headerend   d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,9064 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,9074 )   :H_BM   d$  &x 90 
( 0804,9076 )                 d$  4  8 

( 0804,9078 )   :_start    CLD, 
( 0804,9079 )                  MOV, X| F| SP'| MEM| STACK_SAVE L, 
( 0804,907F )                  MOV|SG, F| DS| R| AX| 
( 0804,9081 )                  MOV|SG, T| SS| R| AX| 
( 0804,9083 )                  MOV, X| T| SP'| MEM| SP_INIT L, 
( 0804,9089 )                  MOV, X| T| BP'| MEM| RP_INIT L, 
( 0804,908F )                  MOVI|X, SI| CLD1 IL, 
( 0804,9094 )                  LODS, X'| 
( 0804,9095 )                  JMPO, ZO| [AX] 
( 0804,9097 )   :CLD1   dl X_COLD 

( 0804,909B )                  PUSH|X, DX| 
( 0804,909C )                  PUSH|X, AX| 
( 0804,909D )                  LODS, X'| 
( 0804,909E )                  MOV, X| F| AX'| R| AX| 
( 0804,90A0 )                  JMPO, ZO| [AX] 
( 0804,90A2 )                  XCHG|AX, AX| 
( 0804,90A3 )                  XCHG|AX, AX| 
( 0804,90A4 )   :N__'   d$  1  0  0  0  &' 90 
( 0804,90AA )                 d$  90  90 

( 0804,90AC )   :X__'   dl docol H_['] H_R0 0 
( 0804,90BC )                 dl N__' 0 
( 0804,90C4 )   :H_[']   dl X_' X_LITERAL 
( 0804,90CC )                 dl semis 

( 0804,90D0 )   :N_&   d$  1  0  0  0  && 90 
( 0804,90D6 )                 d$  90  90 

( 0804,90D8 )   :X_&   dl docol H_& H_R0 X__' 
( 0804,90E8 )                 dl N_& 0 
( 0804,90F0 )   :H_&   dl X_IN[] X_SWAP 
( 0804,90F8 )                 dl X_DROP X_DUP X_?BLANK X_LIT 
( 0804,9108 )                 dl 0A X_?ERROR X_LITERAL X_?DELIM 
( 0804,9118 )                 dl semis 

( 0804,911C )   :N_^   d$  1  0  0  0  &^ 90 
( 0804,9122 )                 d$  90  90 

( 0804,9124 )   :X_^   dl docol H_^ H_R0 X_& 
( 0804,9134 )                 dl N_^ 0 
( 0804,913C )   :H_^   dl X_IN[] X_SWAP 
( 0804,9144 )                 dl X_DROP X_DUP X_?BLANK X_LIT 
( 0804,9154 )                 dl 0A X_?ERROR X_LIT H_C/L 
( 0804,9164 )                 dl X_- X_LITERAL X_?DELIM semis 

( 0804,9174 )   :N__0   d$  1  0  0  0  &0 90 
( 0804,917A )                 d$  90  90 

( 0804,917C )   :X__0   dl docol donumber H_R0 X_^ 
( 0804,918C )                 dl N__0 0 

( 0804,9194 )   :N__1   d$  1  0  0  0  &1 90 
( 0804,919A )                 d$  90  90 

( 0804,919C )   :X__1   dl docol donumber H_R0 X__0 
( 0804,91AC )                 dl N__1 0 

( 0804,91B4 )   :N__2   d$  1  0  0  0  &2 90 
( 0804,91BA )                 d$  90  90 

( 0804,91BC )   :X__2   dl docol donumber H_R0 X__1 
( 0804,91CC )                 dl N__2 0 

( 0804,91D4 )   :N_3   d$  1  0  0  0  &3 90 
( 0804,91DA )                 d$  90  90 

( 0804,91DC )   :X_3   dl docol donumber H_R0 X__2 
( 0804,91EC )                 dl N_3 0 

( 0804,91F4 )   :N_4   d$  1  0  0  0  &4 90 
( 0804,91FA )                 d$  90  90 

( 0804,91FC )   :X_4   dl docol donumber H_R0 X_3 
( 0804,920C )                 dl N_4 0 

( 0804,9214 )   :N_5   d$  1  0  0  0  &5 90 
( 0804,921A )                 d$  90  90 

( 0804,921C )   :X_5   dl docol donumber H_R0 X_4 
( 0804,922C )                 dl N_5 0 

( 0804,9234 )   :N_6   d$  1  0  0  0  &6 90 
( 0804,923A )                 d$  90  90 

( 0804,923C )   :X_6   dl docol donumber H_R0 X_5 
( 0804,924C )                 dl N_6 0 

( 0804,9254 )   :N_7   d$  1  0  0  0  &7 90 
( 0804,925A )                 d$  90  90 

( 0804,925C )   :X_7   dl docol donumber H_R0 X_6 
( 0804,926C )                 dl N_7 0 

( 0804,9274 )   :N_8   d$  1  0  0  0  &8 90 
( 0804,927A )                 d$  90  90 

( 0804,927C )   :X_8   dl docol donumber H_R0 X_7 
( 0804,928C )                 dl N_8 0 

( 0804,9294 )   :N_9   d$  1  0  0  0  &9 90 
( 0804,929A )                 d$  90  90 

( 0804,929C )   :X_9   dl docol donumber H_R0 X_8 
( 0804,92AC )                 dl N_9 0 

( 0804,92B4 )   :N_A   d$  1  0  0  0  &A 90 
( 0804,92BA )                 d$  90  90 

( 0804,92BC )   :X_A   dl docol donumber H_R0 X_9 
( 0804,92CC )                 dl N_A 0 

( 0804,92D4 )   :N_B   d$  1  0  0  0  &B 90 
( 0804,92DA )                 d$  90  90 

( 0804,92DC )   :X_B   dl docol donumber H_R0 X_A 
( 0804,92EC )                 dl N_B 0 

( 0804,92F4 )   :N_C   d$  1  0  0  0  &C 90 
( 0804,92FA )                 d$  90  90 

( 0804,92FC )   :X_C   dl docol donumber H_R0 X_B 
( 0804,930C )                 dl N_C 0 

( 0804,9314 )   :N_D   d$  1  0  0  0  &D 90 
( 0804,931A )                 d$  90  90 

( 0804,931C )   :X_D   dl docol donumber H_R0 X_C 
( 0804,932C )                 dl N_D 0 

( 0804,9334 )   :N_E   d$  1  0  0  0  &E 90 
( 0804,933A )                 d$  90  90 

( 0804,933C )   :X_E   dl docol donumber H_R0 X_D 
( 0804,934C )                 dl N_E 0 

( 0804,9354 )   :N_F   d$  1  0  0  0  &F 90 
( 0804,935A )                 d$  90  90 

( 0804,935C )   :X_F   dl docol donumber H_R0 X_E 
( 0804,936C )                 dl N_F 0 

( 0804,9374 )   :N__-   d$  1  0  0  0  &- 90 
( 0804,937A )                 d$  90  90 

( 0804,937C )   :X__-   dl docol H__- H_R0 X_F 
( 0804,938C )                 dl N__- 0 
( 0804,9394 )   :H__-   dl X_(NUMBER) X_DNEGATE 
( 0804,939C )                 dl X_SDLITERAL semis 

( 0804,93A4 )   :N__+   d$  1  0  0  0  &+ 90 
( 0804,93AA )                 d$  90  90 

( 0804,93AC )   :X__+   dl docol H__+ H_R0 X__- 
( 0804,93BC )                 dl N__+ 0 
( 0804,93C4 )   :H__+   dl X_(NUMBER) X_SDLITERAL 
( 0804,93CC )                 dl semis 

( 0804,93D0 )   :N_"   d$  1  0  0  0  &" 90 
( 0804,93D6 )                 d$  90  90 

( 0804,93D8 )   :X_"   dl docol H_" H_R0 X__+ 
( 0804,93E8 )                 dl N_" 0 
( 0804,93F0 )   :H_"   dl X_LIT X_SKIP 
( 0804,93F8 )                 dl X_, X_HERE X_>R X_0 
( 0804,9408 )                 dl X_, X_LIT 22 X_(PARSE) 
( 0804,9418 )                 dl X_IN[] X_DUP X_LIT 22 
( 0804,9428 )                 dl X_= X_0BRANCH H_FENCE X_2DROP 
( 0804,9438 )                 dl X_1+ X_DUP X_ALLOT X_R@ 
( 0804,9448 )                 dl X_$+! X_BRANCH -48 X_?BLANK 
( 0804,9458 )                 dl X_0= X_LIT 0A X_?ERROR 
( 0804,9468 )                 dl X_DROP X_DUP X_ALLOT X_R@ 
( 0804,9478 )                 dl X_$+! X_ALIGN X_R> X_$@ 
( 0804,9488 )                 dl X_DLITERAL semis 

( 0804,9490 )   :N_FORTH   d$  5  0  0  0  "FORTH" 90 
( 0804,949A )                 d$  90  90 

( 0804,949C )   :X_FORTH   dl dodoes H_FORTH H_U0 UNKNOWN1 
( 0804,94AC )                 dl N_FORTH 0 
( 0804,94B4 )   :H_FORTH   dl DOVOC 0 
( 0804,94BC )                 dl 0 0 1 last_dea 
( 0804,94CC )                 dl 0 0 

( 0804,94D4 )   :N_CORE   d$  4  0  0  0  "CORE"

( 0804,94DC )   :X_CORE   dl docol H_CORE 0 0 
( 0804,94EC )                 dl N_CORE 0 
( 0804,94F4 )   :H_CORE   dl X_0 semis 

( 0804,94FC )   :N_CPU   d$  3  0  0  0  "CPU" 90 

( 0804,9504 )   :X_CPU   dl docol H_CPU 0 X_CORE 
( 0804,9514 )                 dl N_CPU 0 
( 0804,951C )   :H_CPU   dl X_LIT 00CD,1856 
( 0804,9524 )                 dl X_0 semis 

( 0804,952C )   :N_VERSION   d$  7  0  0  0  "VERSION" 90 

( 0804,9538 )   :X_VERSION   dl docol H_VERSION 0 X_CPU 
( 0804,9548 )                 dl N_VERSION 0 
( 0804,9550 )   :H_VERSION   dl X_SKIP 5 
( 0804,9558 )   :NAME1   dl 2E30,2E34 9090,9035 X_LIT NAME1 
( 0804,9568 )                 dl X_LIT 5 semis 

( 0804,9574 )   :N_NAME   d$  4  0  0  0  "NAME"

( 0804,957C )   :X_NAME   dl docol H_NAME 0 X_VERSION 
( 0804,958C )                 dl N_NAME 0 
( 0804,9594 )   :H_NAME   dl X_SKIP 7 
( 0804,959C )   :NAME2   dl 6F66,6963 9068,7472 X_LIT NAME2 
( 0804,95AC )                 dl X_LIT 7 semis 

( 0804,95B8 )   :N_SUPPLIER   d$  8  0  0  0  "SUPPLIER"

( 0804,95C4 )   :X_SUPPLIER :last_dea_envir   dl docol H_SUPPLIER 0 X_NAME 
( 0804,95D4 )                 dl N_SUPPLIER 0 
( 0804,95DC )   :H_SUPPLIER   dl X_SKIP H_RUBOUT 
( 0804,95E4 )   :NAME3   dl 6562,6C41 7620,7472 6420,6E61 4820,7265 
( 0804,95F4 )                 dl 7473,726F X_LIT NAME3 X_LIT 
( 0804,9604 )                 dl H_RUBOUT semis 

( 0804,960C )   :N_DENOTATION   d$  ^J 0  0  0  "DENOTATION" 90 
( 0804,961B )                 d$  90 

( 0804,961C )   :X_DENOTATION   dl dodoes H_DENOTATION H_U0 X_FORTH 
( 0804,962C )                 dl N_DENOTATION 0 
( 0804,9634 )   :H_DENOTATION   dl DOVOC X_FORTH 
( 0804,963C )   :UNKNOWN1   dl 0 0 1 X_" 
( 0804,964C )                 dl 0 0 

( 0804,9654 )   :N_ENVIRONMENT   d$  0B  0  0  0  "ENVIRONMENT" 90 

( 0804,9664 )   :X_ENVIRONMENT   dl dodoes H_ENVIRONMENT H_U0 X_DENOTATION 
( 0804,9674 )                 dl N_ENVIRONMENT 0 
( 0804,967C )   :H_ENVIRONMENT   dl DOVOC X_DENOTATION 
( 0804,9684 )                 dl 0 0 1 X_SUPPLIER 
( 0804,9694 )                 dl 0 0 

( 0804,969C )   :N_NOOP   d$  4  0  0  0  "NOOP"

( 0804,96A4 )   :X_NOOP   dl H_NOOP H_NOOP 0 X_ENVIRONMENT 
( 0804,96B4 )                 dl N_NOOP 0 

( 0804,96BC )   :H_NOOP    LODS, X'| 
( 0804,96BD )                  JMPO, ZO| [AX] 
( 0804,96BF )                 d$  90 

( 0804,96C0 )   :N_LIT   d$  3  0  0  0  "LIT" 90 

( 0804,96C8 )   :X_LIT   dl H_LIT H_LIT 0 X_NOOP 
( 0804,96D8 )                 dl N_LIT 0 

( 0804,96E0 )   :H_LIT    LODS, X'| 
( 0804,96E1 )                  PUSH|X, AX| 
( 0804,96E2 )                  LODS, X'| 
( 0804,96E3 )                  JMPO, ZO| [AX] 
( 0804,96E5 )                 d$  90  90  90 

( 0804,96E8 )   :N_EXECUTE   d$  7  0  0  0  "EXECUTE" 90 

( 0804,96F4 )   :X_EXECUTE   dl H_EXECUTE H_EXECUTE 0 X_LIT 
( 0804,9704 )                 dl N_EXECUTE 0 

( 0804,970C )   :H_EXECUTE    POP|X, AX| 
( 0804,970D )                  JMPO, ZO| [AX] 
( 0804,970F )                 d$  90 

( 0804,9710 )   :N_RECURSE   d$  7  0  0  0  "RECURSE" 90 

( 0804,971C )   :X_RECURSE   dl docol H_RECURSE H_U0 X_EXECUTE 
( 0804,972C )                 dl N_RECURSE 0 
( 0804,9734 )   :H_RECURSE   dl X_LATEST X_, 
( 0804,973C )                 dl semis 

( 0804,9740 )   :N_BRANCH   d$  6  0  0  0  "BRANCH" 90 
( 0804,974B )                 d$  90 

( 0804,974C )   :X_BRANCH   dl L0804,9784 N_SKIP 0 X_RECURSE 
( 0804,975C )                 dl N_BRANCH 0 

( 0804,9764 )   :N_SKIP   d$  4  0  0  0  "SKIP"

( 0804,976C )   :X_SKIP   dl L0804,9784 L0804,9784 0 X_BRANCH 
( 0804,977C )                 dl N_SKIP 0 

( 0804,9784 )   :L0804,9784    LODS, X'| 
( 0804,9785 )                  DEC|X, AX| 
( 0804,9786 )                  ORI|A, B'| 3 IB, 
( 0804,9788 )                  INC|X, AX| 
( 0804,9789 )                  ADD, X| F| AX'| R| SI| 
( 0804,978B )                  LODS, X'| 
( 0804,978C )                  JMPO, ZO| [AX] 
( 0804,978E )                 d$  90  90 

( 0804,9790 )   :N_0BRANCH   d$  7  0  0  0  "0BRANCH" 90 

( 0804,979C )   :X_0BRANCH   dl H_0BRANCH H_0BRANCH 0 X_SKIP 
( 0804,97AC )                 dl N_0BRANCH 0 

( 0804,97B4 )   :H_0BRANCH    POP|X, AX| 
( 0804,97B5 )                  OR, X| F| AX'| R| AX| 
( 0804,97B7 )                  J, Z| Y| L0804,9784 RB,
( 0804,97B9 )                  LEA, SI'| BO| [SI] H_U0 B, 
( 0804,97BC )                  LODS, X'| 
( 0804,97BD )                  JMPO, ZO| [AX] 
( 0804,97BF )                 d$  90 

( 0804,97C0 )   :N_(LOOP)   d$  6  0  0  0  "(LOOP)" 90 
( 0804,97CB )                 d$  90 

( 0804,97CC )   :X_(LOOP)   dl H_(LOOP) H_(LOOP) 0 X_0BRANCH 
( 0804,97DC )                 dl N_(LOOP) 0 

( 0804,97E4 )   :H_(LOOP)    MOVI|X, BX| 1 IL, 
( 0804,97E9 )   :L0804,97E9    ADD, X| F| BX'| BO| [BP] 0 B, 
( 0804,97EC )                  MOV, X| T| AX'| BO| [BP] 0 B, 
( 0804,97EF )                  SUB, X| T| AX'| BO| [BP] H_U0 B, 
( 0804,97F2 )                  XOR, X| F| BX'| R| AX| 
( 0804,97F4 )                  J, S| Y| L0804,9784 RB,
( 0804,97F6 )                  LEA, BP'| BO| [BP] H_R0 B, 
( 0804,97F9 )                  LEA, SI'| BO| [SI] H_U0 B, 
( 0804,97FC )                  LODS, X'| 
( 0804,97FD )                  JMPO, ZO| [AX] 
( 0804,97FF )                 d$  90 

( 0804,9800 )   :N_(+LOOP)   d$  7  0  0  0  "(+LOOP)" 90 

( 0804,980C )   :X_(+LOOP)   dl H_(+LOOP) H_(+LOOP) 0 X_(LOOP) 
( 0804,981C )                 dl N_(+LOOP) 0 

( 0804,9824 )   :H_(+LOOP)    POP|X, BX| 
( 0804,9825 )                  JMPS, L0804,97E9 RB,
( 0804,9827 )                 d$  0AD  0FF  BL 90 
( 0804,982B )                 d$  90 

( 0804,982C )   :N_(DO)   d$  4  0  0  0  "(DO)"

( 0804,9834 )   :X_(DO)   dl H_(DO) H_(DO) 0 X_(+LOOP) 
( 0804,9844 )                 dl N_(DO) 0 

( 0804,984C )   :H_(DO)    LODS, X'| 
( 0804,984D )                  ADD, X| F| SI'| R| AX| 
( 0804,984F )                  POP|X, DX| 
( 0804,9850 )                  POP|X, BX| 
( 0804,9851 )                  XCHG, X| BP'| R| SP| 
( 0804,9853 )                  PUSH|X, AX| 
( 0804,9854 )                  PUSH|X, BX| 
( 0804,9855 )                  PUSH|X, DX| 
( 0804,9856 )                  XCHG, X| BP'| R| SP| 
( 0804,9858 )                  LODS, X'| 
( 0804,9859 )                  JMPO, ZO| [AX] 
( 0804,985B )                 d$  90 

( 0804,985C )   :N_(?DO)   d$  5  0  0  0  "(?DO)" 90 
( 0804,9866 )                 d$  90  90 

( 0804,9868 )   :X_(?DO)   dl H_(?DO) H_(?DO) 0 X_(DO) 
( 0804,9878 )                 dl N_(?DO) 0 

( 0804,9880 )   :H_(?DO)    LODS, X'| 
( 0804,9881 )                  ADD, X| F| SI'| R| AX| 
( 0804,9883 )                  POP|X, DX| 
( 0804,9884 )                  POP|X, BX| 
( 0804,9885 )                  CMP, X| F| BX'| R| DX| 
( 0804,9887 )                  J, Z| Y| L0804,9893 RB,
( 0804,9889 )                  XCHG, X| BP'| R| SP| 
( 0804,988B )                  PUSH|X, AX| 
( 0804,988C )                  PUSH|X, BX| 
( 0804,988D )                  PUSH|X, DX| 
( 0804,988E )                  XCHG, X| BP'| R| SP| 
( 0804,9890 )                  LODS, X'| 
( 0804,9891 )                  JMPO, ZO| [AX] 
( 0804,9893 )   :L0804,9893    MOV, X| F| AX'| R| SI| 
( 0804,9895 )                  LODS, X'| 
( 0804,9896 )                  JMPO, ZO| [AX] 
( 0804,9898 )   :N_I   d$  1  0  0  0  &I 90 
( 0804,989E )                 d$  90  90 

( 0804,98A0 )   :X_I   dl L0804,98B8 L0804,98B8 0 X_(?DO) 
( 0804,98B0 )                 dl N_I 0 

( 0804,98B8 )   :L0804,98B8    MOV, X| T| AX'| BO| [BP] 0 B, 
( 0804,98BB )                  PUSH|X, AX| 
( 0804,98BC )                  LODS, X'| 
( 0804,98BD )                  JMPO, ZO| [AX] 
( 0804,98BF )                 d$  90 

( 0804,98C0 )   :N_J   d$  1  0  0  0  &J 90 
( 0804,98C6 )                 d$  90  90 

( 0804,98C8 )   :X_J   dl H_J H_J 0 X_I 
( 0804,98D8 )                 dl N_J 0 

( 0804,98E0 )   :H_J    MOV, X| T| AX'| BO| [BP] H_R0 B, 
( 0804,98E3 )                  PUSH|X, AX| 
( 0804,98E4 )                  LODS, X'| 
( 0804,98E5 )                  JMPO, ZO| [AX] 
( 0804,98E7 )                 d$  90 

( 0804,98E8 )   :N_UNLOOP   d$  6  0  0  0  "UNLOOP" 90 
( 0804,98F3 )                 d$  90 

( 0804,98F4 )   :X_UNLOOP   dl docol H_UNLOOP H_U0 X_J 
( 0804,9904 )                 dl N_UNLOOP 0 
( 0804,990C )   :H_UNLOOP   dl X_LIT X_RDROP 
( 0804,9914 )                 dl X_, X_LIT X_RDROP X_, 
( 0804,9924 )                 dl X_LIT X_RDROP X_, semis 

( 0804,9934 )   :N_+ORIGIN   d$  7  0  0  0  "+ORIGIN" 90 

( 0804,9940 )   :X_+ORIGIN   dl docol H_+ORIGIN 0 X_UNLOOP 
( 0804,9950 )                 dl N_+ORIGIN 0 
( 0804,9958 )   :H_+ORIGIN   dl X_LIT init_user 
( 0804,9960 )                 dl X_+ semis 
( 0804,9968 )   :init_user   dl 0C04,6F38 
( 0804,996C )   :U0_INIT   dl 0C04,6F38 
( 0804,9970 )   :SP_INIT   dl 0C03,6F38 
( 0804,9974 )   :RP_INIT   dl 0C04,6F38 0C03,6F38 H_#BUFF 
( 0804,9980 )                 dl 0 1 _end _end 
( 0804,9990 )                 dl X_ENVIRONMENT 0 0 0 
( 0804,99A0 )                 dl 0 0C03,6F38 0 0 
( 0804,99B0 )                 dl 0 0 0 0 
( 0804,99C0 )                 dl 0 0 0 0 
( 0804,99D0 )                 dl 0 0 0 0 
( 0804,99E0 )                 dl 0 
( 0804,99E4 )   :STACK_SAVE   dl 0 0 0 
( 0804,99F0 )                 dl 0 0 0 0 
( 0804,9A00 )                 dl 0 0 0 0 
( 0804,9A10 )                 dl 0 0 0 0 
( 0804,9A20 )                 dl 0 0 0 0 
( 0804,9A30 )                 dl 0 0 0 0 
( 0804,9A40 )                 dl 0 0 0 0 
( 0804,9A50 )                 dl 0 0 0 0 
( 0804,9A60 )                 dl 0 0 

( 0804,9A68 )   :N_DIGIT   d$  5  0  0  0  "DIGIT" 90 
( 0804,9A72 )                 d$  90  90 

( 0804,9A74 )   :X_DIGIT   dl H_DIGIT H_DIGIT 0 X_+ORIGIN 
( 0804,9A84 )                 dl N_DIGIT 0 

( 0804,9A8C )   :H_DIGIT    POP|X, DX| 
( 0804,9A8D )                  POP|X, AX| 
( 0804,9A8E )                  SUBI|A, B'| H_WHERE IB, 
( 0804,9A90 )                  J, C| Y| L0804,9AAD RB,
( 0804,9A92 )                  CMPI|A, B'| 9 IB, 
( 0804,9A94 )                  J, CZ| Y| L0804,9A9C RB,
( 0804,9A96 )                  SUBI|A, B'| 7 IB, 
( 0804,9A98 )                  CMPI|A, B'| 0A IB, 
( 0804,9A9A )                  J, C| Y| L0804,9AAD RB,
( 0804,9A9C )   :L0804,9A9C    CMP, B| F| DL'| R| AL| 
( 0804,9A9E )                  J, C| N| L0804,9AAD RB,
( 0804,9AA0 )                  SUB, X| F| DX'| R| DX| 
( 0804,9AA2 )                  MOV, B| F| AL'| R| DL| 
( 0804,9AA4 )                  MOVI|B, AL| 1 IB, 
( 0804,9AA6 )                  NEG, X| R| AX| 
( 0804,9AA8 )                  PUSH|X, DX| 
( 0804,9AA9 )                  PUSH|X, AX| 
( 0804,9AAA )                  LODS, X'| 
( 0804,9AAB )                  JMPO, ZO| [AX] 
( 0804,9AAD )   :L0804,9AAD    SUB, X| F| AX'| R| AX| 
( 0804,9AAF )                  PUSH|X, DX| 
( 0804,9AB0 )                  PUSH|X, AX| 
( 0804,9AB1 )                  LODS, X'| 
( 0804,9AB2 )                  JMPO, ZO| [AX] 
( 0804,9AB4 )   :N_(MATCH)   d$  7  0  0  0  "(MATCH)" 90 

( 0804,9AC0 )   :X_(MATCH)   dl docol H_(MATCH) 0 X_DIGIT 
( 0804,9AD0 )                 dl N_(MATCH) 0 
( 0804,9AD8 )   :H_(MATCH)   dl X_>R X_R@ 
( 0804,9AE0 )                 dl X_>FFA X_@ X_LIT 3 
( 0804,9AF0 )                 dl X_AND X_0= X_DUP X_0BRANCH 
( 0804,9B00 )                 dl H_(>IN) X_DROP X_R@ X_>NFA 
( 0804,9B10 )                 dl X_@ X_@ X_OVER X_- 
( 0804,9B20 )                 dl X_DUP X_0< X_R@ X_>FFA 
( 0804,9B30 )                 dl X_@ X_LIT H_#BUFF X_AND 
( 0804,9B40 )                 dl X_AND X_0= X_AND X_0= 
( 0804,9B50 )                 dl X_DUP X_0BRANCH H_FENCE X_DROP 
( 0804,9B60 )                 dl X_OVER X_R@ X_>NFA X_@ 
( 0804,9B70 )                 dl X_$@ X_CORA X_0= X_R> 
( 0804,9B80 )                 dl X_SWAP semis 

( 0804,9B88 )   :N_?BLANK   d$  6  0  0  0  "?BLANK" 90 
( 0804,9B93 )                 d$  90 

( 0804,9B94 )   :X_?BLANK   dl docol H_?BLANK 0 X_(MATCH) 
( 0804,9BA4 )                 dl N_?BLANK 0 
( 0804,9BAC )   :H_?BLANK   dl X_BL X_1+ 
( 0804,9BB4 )                 dl X_< semis 

( 0804,9BBC )   :N_IN[]   d$  4  0  0  0  "IN[]"

( 0804,9BC4 )   :X_IN[]   dl docol H_IN[] 0 X_?BLANK 
( 0804,9BD4 )                 dl N_IN[] 0 
( 0804,9BDC )   :H_IN[]   dl X_SRC X_CELL+ 
( 0804,9BE4 )                 dl X_2@ X_OVER X_= X_0BRANCH 
( 0804,9BF4 )                 dl H_R0 X_0 X_BRANCH H_RUBOUT 
( 0804,9C04 )                 dl X_DUP X_C@ X_1 X_IN 
( 0804,9C14 )                 dl X_+! semis 

( 0804,9C1C )   :N_(WORD)   d$  6  0  0  0  "(WORD)" 90 
( 0804,9C27 )                 d$  90 

( 0804,9C28 )   :X_(WORD)   dl docol H_(WORD) 0 X_IN[] 
( 0804,9C38 )                 dl N_(WORD) 0 
( 0804,9C40 )   :H_(WORD)   dl X__ X_DROP 
( 0804,9C48 )                 dl X_IN[] X_?BLANK X_OVER X_SRC 
( 0804,9C58 )                 dl X_CELL+ X_@ X_- X_AND 
( 0804,9C68 )                 dl X_0= X_0BRANCH -30 X__ 
( 0804,9C78 )                 dl X_DROP X_IN[] X_?BLANK X_0BRANCH 
( 0804,9C88 )                 dl -14 X_OVER X_- semis 

( 0804,9C98 )   :N_(PARSE)   d$  7  0  0  0  "(PARSE)" 90 

( 0804,9CA4 )   :X_(PARSE)   dl docol H_(PARSE) 0 X_(WORD) 
( 0804,9CB4 )                 dl N_(PARSE) 0 
( 0804,9CBC )   :H_(PARSE)   dl X_SRC X_CELL+ 
( 0804,9CC4 )                 dl X_2@ X_OVER X_- X_ROT 
( 0804,9CD4 )                 dl X_$S X_2SWAP X_0= X_0BRANCH 
( 0804,9CE4 )                 dl H_TIB X_DROP X_SRC X_CELL+ 
( 0804,9CF4 )                 dl X_@ X_IN X_! semis 

( 0804,9D04 )   :N_SRC   d$  3  0  0  0  "SRC" 90 

( 0804,9D0C )   :X_SRC   dl douse H_SRC 0 X_(PARSE) 
( 0804,9D1C )                 dl N_SRC 0 

( 0804,9D24 )   :N_SOURCE   d$  6  0  0  0  "SOURCE" 90 
( 0804,9D2F )                 d$  90 

( 0804,9D30 )   :X_SOURCE   dl docol H_SOURCE 0 X_SRC 
( 0804,9D40 )                 dl N_SOURCE 0 
( 0804,9D48 )   :H_SOURCE   dl X_SRC X_@ 
( 0804,9D50 )                 dl X_SRC X_CELL+ X_@ X_OVER 
( 0804,9D60 )                 dl X_- semis 

( 0804,9D68 )   :N_>IN   d$  3  0  0  0  ">IN" 90 

( 0804,9D70 )   :X_>IN   dl docol H_>IN 0 X_SOURCE 
( 0804,9D80 )                 dl N_>IN 0 
( 0804,9D88 )   :H_>IN   dl X_IN X_@ 
( 0804,9D90 )                 dl X_SRC X_@ X_- X_(>IN) 
( 0804,9DA0 )                 dl X_! X_(>IN) semis 

( 0804,9DAC )   :N_CR   d$  2  0  0  0  "CR" 90 
( 0804,9DB3 )                 d$  90 

( 0804,9DB4 )   :X_CR   dl docol H_CR 0 X_>IN 
( 0804,9DC4 )                 dl N_CR 0 
( 0804,9DCC )   :H_CR   dl X_LIT 0A 
( 0804,9DD4 )                 dl X_EMIT X_0 X_OUT X_! 
( 0804,9DE4 )                 dl semis 

( 0804,9DE8 )   :N_CMOVE   d$  5  0  0  0  "CMOVE" 90 
( 0804,9DF2 )                 d$  90  90 

( 0804,9DF4 )   :X_CMOVE   dl H_CMOVE H_CMOVE 0 X_CR 
( 0804,9E04 )                 dl N_CMOVE 0 

( 0804,9E0C )   :H_CMOVE    CLD, 
( 0804,9E0D )                  MOV, X| F| SI'| R| BX| 
( 0804,9E0F )                  POP|X, CX| 
( 0804,9E10 )                  POP|X, DI| 
( 0804,9E11 )                  POP|X, SI| 
( 0804,9E12 )                  REPZ, 
( 0804,9E13 )                  MOVS, B'| 
( 0804,9E14 )                  MOV, X| F| BX'| R| SI| 
( 0804,9E16 )                  LODS, X'| 
( 0804,9E17 )                  JMPO, ZO| [AX] 
( 0804,9E19 )                 d$  90  90  90 

( 0804,9E1C )   :N_MOVE   d$  4  0  0  0  "MOVE"

( 0804,9E24 )   :X_MOVE   dl H_MOVE H_MOVE 0 X_CMOVE 
( 0804,9E34 )                 dl N_MOVE 0 

( 0804,9E3C )   :H_MOVE    MOV, X| F| SI'| R| BX| 
( 0804,9E3E )                  POP|X, CX| 
( 0804,9E3F )                  POP|X, DI| 
( 0804,9E40 )                  POP|X, SI| 
( 0804,9E41 )                  CMP, X| F| DI'| R| SI| 
( 0804,9E43 )                  J, C| Y| L0804,9E48 RB,
( 0804,9E45 )                  CLD, 
( 0804,9E46 )                  JMPS, L0804,9E4F RB,
( 0804,9E48 )   :L0804,9E48    STD, 
( 0804,9E49 )                  ADD, X| F| CX'| R| DI| 
( 0804,9E4B )                  DEC|X, DI| 
( 0804,9E4C )                  ADD, X| F| CX'| R| SI| 
( 0804,9E4E )                  DEC|X, SI| 
( 0804,9E4F )   :L0804,9E4F    REPZ, 
( 0804,9E50 )                  MOVS, B'| 
( 0804,9E51 )                  CLD, 
( 0804,9E52 )                  MOV, X| F| BX'| R| SI| 
( 0804,9E54 )                  LODS, X'| 
( 0804,9E55 )                  JMPO, ZO| [AX] 
( 0804,9E57 )                 d$  90 

( 0804,9E58 )   :N_FARMOVE   d$  7  0  0  0  "FARMOVE" 90 

( 0804,9E64 )   :X_FARMOVE   dl H_FARMOVE H_FARMOVE 0 X_MOVE 
( 0804,9E74 )                 dl N_FARMOVE 0 

( 0804,9E7C )   :H_FARMOVE    CLD, 
( 0804,9E7D )                  MOV, X| F| SI'| R| AX| 
( 0804,9E7F )                  MOV|SG, F| DS| R| BX| 
( 0804,9E81 )                  POP|X, CX| 
( 0804,9E82 )                  POP|X, DI| 
( 0804,9E83 )                  POP|X, DX| 
( 0804,9E84 )                  AND, X| F| DX'| R| DX| 
( 0804,9E86 )                  J, Z| Y| L0804,9E8A RB,
( 0804,9E88 )                  MOV|SG, T| ES| R| DX| 
( 0804,9E8A )   :L0804,9E8A    POP|X, SI| 
( 0804,9E8B )                  POP|X, DX| 
( 0804,9E8C )                  PUSH|DS, 
( 0804,9E8D )                  PUSH|X, BX| 
( 0804,9E8E )                  AND, X| F| DX'| R| DX| 
( 0804,9E90 )                  J, Z| Y| L0804,9E94 RB,
( 0804,9E92 )                  MOV|SG, T| DS| R| DX| 
( 0804,9E94 )   :L0804,9E94    REPZ, 
( 0804,9E95 )                  MOVS, B'| 
( 0804,9E96 )                  MOV, X| F| AX'| R| SI| 
( 0804,9E98 )                  POP|ES, 
( 0804,9E99 )                  POP|DS, 
( 0804,9E9A )                  LODS, X'| 
( 0804,9E9B )                  JMPO, ZO| [AX] 
( 0804,9E9D )                 d$  90  90  90 

( 0804,9EA0 )   :N_UM*   d$  3  0  0  0  "UM*" 90 

( 0804,9EA8 )   :X_UM*   dl H_UM* H_UM* 0 X_FARMOVE 
( 0804,9EB8 )                 dl N_UM* 0 

( 0804,9EC0 )   :H_UM*    POP|X, AX| 
( 0804,9EC1 )                  POP|X, BX| 
( 0804,9EC2 )                  MUL|AD, X| R| BX| 
( 0804,9EC4 )                  XCHG|AX, DX| 
( 0804,9EC5 )                  PUSH|X, DX| 
( 0804,9EC6 )                  PUSH|X, AX| 
( 0804,9EC7 )                  LODS, X'| 
( 0804,9EC8 )                  JMPO, ZO| [AX] 
( 0804,9ECA )                 d$  90  90 

( 0804,9ECC )   :N_UM/MOD   d$  6  0  0  0  "UM/MOD" 90 
( 0804,9ED7 )                 d$  90 

( 0804,9ED8 )   :X_UM/MOD   dl H_UM/MOD H_UM/MOD 0 X_UM* 
( 0804,9EE8 )                 dl N_UM/MOD 0 

( 0804,9EF0 )   :H_UM/MOD    POP|X, BX| 
( 0804,9EF1 )                  POP|X, DX| 
( 0804,9EF2 )                  POP|X, AX| 
( 0804,9EF3 )                  DIV|AD, X| R| BX| 
( 0804,9EF5 )                  PUSH|X, DX| 
( 0804,9EF6 )                  PUSH|X, AX| 
( 0804,9EF7 )                  LODS, X'| 
( 0804,9EF8 )                  JMPO, ZO| [AX] 
( 0804,9EFA )                 d$  90  90 

( 0804,9EFC )   :N_AND   d$  3  0  0  0  "AND" 90 

( 0804,9F04 )   :X_AND   dl H_AND H_AND 0 X_UM/MOD 
( 0804,9F14 )                 dl N_AND 0 

( 0804,9F1C )   :H_AND    POP|X, AX| 
( 0804,9F1D )                  POP|X, BX| 
( 0804,9F1E )                  AND, X| F| BX'| R| AX| 
( 0804,9F20 )                  PUSH|X, AX| 
( 0804,9F21 )                  LODS, X'| 
( 0804,9F22 )                  JMPO, ZO| [AX] 
( 0804,9F24 )   :N_OR   d$  2  0  0  0  "OR" 90 
( 0804,9F2B )                 d$  90 

( 0804,9F2C )   :X_OR   dl H_OR H_OR 0 X_AND 
( 0804,9F3C )                 dl N_OR 0 

( 0804,9F44 )   :H_OR    POP|X, AX| 
( 0804,9F45 )                  POP|X, BX| 
( 0804,9F46 )                  OR, X| F| BX'| R| AX| 
( 0804,9F48 )                  PUSH|X, AX| 
( 0804,9F49 )                  LODS, X'| 
( 0804,9F4A )                  JMPO, ZO| [AX] 
( 0804,9F4C )   :N_XOR   d$  3  0  0  0  "XOR" 90 

( 0804,9F54 )   :X_XOR   dl H_XOR H_XOR 0 X_OR 
( 0804,9F64 )                 dl N_XOR 0 

( 0804,9F6C )   :H_XOR    POP|X, AX| 
( 0804,9F6D )                  POP|X, BX| 
( 0804,9F6E )                  XOR, X| F| BX'| R| AX| 
( 0804,9F70 )                  PUSH|X, AX| 
( 0804,9F71 )                  LODS, X'| 
( 0804,9F72 )                  JMPO, ZO| [AX] 
( 0804,9F74 )   :N_INVERT   d$  6  0  0  0  "INVERT" 90 
( 0804,9F7F )                 d$  90 

( 0804,9F80 )   :X_INVERT   dl H_INVERT H_INVERT 0 X_XOR 
( 0804,9F90 )                 dl N_INVERT 0 

( 0804,9F98 )   :H_INVERT    POP|X, AX| 
( 0804,9F99 )                  NOT, X| R| AX| 
( 0804,9F9B )                  PUSH|X, AX| 
( 0804,9F9C )                  LODS, X'| 
( 0804,9F9D )                  JMPO, ZO| [AX] 
( 0804,9F9F )                 d$  90 

( 0804,9FA0 )   :N_DSP@   d$  4  0  0  0  "DSP@"

( 0804,9FA8 )   :X_DSP@   dl H_DSP@ H_DSP@ 0 X_INVERT 
( 0804,9FB8 )                 dl N_DSP@ 0 

( 0804,9FC0 )   :H_DSP@    MOV, X| F| SP'| R| AX| 
( 0804,9FC2 )                  PUSH|X, AX| 
( 0804,9FC3 )                  LODS, X'| 
( 0804,9FC4 )                  JMPO, ZO| [AX] 
( 0804,9FC6 )                 d$  90  90 

( 0804,9FC8 )   :N_DSP!   d$  4  0  0  0  "DSP!"

( 0804,9FD0 )   :X_DSP!   dl H_DSP! H_DSP! 0 X_DSP@ 
( 0804,9FE0 )                 dl N_DSP! 0 

( 0804,9FE8 )   :H_DSP!    POP|X, AX| 
( 0804,9FE9 )                  MOV, X| F| AX'| R| SP| 
( 0804,9FEB )                  LODS, X'| 
( 0804,9FEC )                  JMPO, ZO| [AX] 
( 0804,9FEE )                 d$  90  90 

( 0804,9FF0 )   :N_DEPTH   d$  5  0  0  0  "DEPTH" 90 
( 0804,9FFA )                 d$  90  90 

( 0804,9FFC )   :X_DEPTH   dl docol H_DEPTH 0 X_DSP! 
( 0804,A00C )                 dl N_DEPTH 0 
( 0804,A014 )   :H_DEPTH   dl X_S0 X_@ 
( 0804,A01C )                 dl X_DSP@ X_- X_LIT H_U0 
( 0804,A02C )                 dl X_/ X_1- semis 

( 0804,A038 )   :N_RSP@   d$  4  0  0  0  "RSP@"

( 0804,A040 )   :X_RSP@   dl H_RSP@ H_RSP@ 0 X_DEPTH 
( 0804,A050 )                 dl N_RSP@ 0 

( 0804,A058 )   :H_RSP@    PUSH|X, BP| 
( 0804,A059 )                  LODS, X'| 
( 0804,A05A )                  JMPO, ZO| [AX] 
( 0804,A05C )   :N_RSP!   d$  4  0  0  0  "RSP!"

( 0804,A064 )   :X_RSP!   dl H_RSP! H_RSP! 0 X_RSP@ 
( 0804,A074 )                 dl N_RSP! 0 

( 0804,A07C )   :H_RSP!    POP|X, BP| 
( 0804,A07D )                  LODS, X'| 
( 0804,A07E )                  JMPO, ZO| [AX] 
( 0804,A080 )   :N_EXIT   d$  4  0  0  0  "EXIT"

( 0804,A088 )   :X_EXIT   dl L0804,A0A0 L0804,A0A0 0 X_RSP! 
( 0804,A098 )                 dl N_EXIT 0 

( 0804,A0A0 )   :L0804,A0A0    MOV, X| T| SI'| BO| [BP] 0 B, 
( 0804,A0A3 )                  LEA, BP'| BO| [BP] H_U0 B, 
( 0804,A0A6 )                  LODS, X'| 
( 0804,A0A7 )                  JMPO, ZO| [AX] 
( 0804,A0A9 )                 d$  90  90  90 

( 0804,A0AC )   :N_CO   d$  2  0  0  0  "CO" 90 
( 0804,A0B3 )                 d$  90 

( 0804,A0B4 )   :X_CO   dl H_CO H_CO 0 X_EXIT 
( 0804,A0C4 )                 dl N_CO 0 

( 0804,A0CC )   :H_CO    XCHG, X| SI'| BO| [BP] 0 B, 
( 0804,A0CF )                  LODS, X'| 
( 0804,A0D0 )                  JMPO, ZO| [AX] 
( 0804,A0D2 )                 d$  90  90 

( 0804,A0D4 )   :N_(;)   d$  3  0  0  0  "(;)" 90 

( 0804,A0DC )   :semis :X_(;)   dl L0804,A0A0 N_LEAVE 0 X_CO 
( 0804,A0EC )                 dl N_(;) 0 

( 0804,A0F4 )   :N_LEAVE   d$  5  0  0  0  "LEAVE" 90 
( 0804,A0FE )                 d$  90  90 

( 0804,A100 )   :X_LEAVE   dl docol H_LEAVE 0 semis 
( 0804,A110 )                 dl N_LEAVE 0 
( 0804,A118 )   :H_LEAVE   dl X_RDROP X_RDROP 
( 0804,A120 )                 dl X_RDROP semis 

( 0804,A128 )   :N_>R   d$  2  0  0  0  ">R" 90 
( 0804,A12F )                 d$  90 

( 0804,A130 )   :X_>R   dl H_>R H_>R 0 X_LEAVE 
( 0804,A140 )                 dl N_>R 0 

( 0804,A148 )   :H_>R    POP|X, BX| 
( 0804,A149 )                  LEA, BP'| BO| [BP] 0FC B, 
( 0804,A14C )                  MOV, X| F| BX'| BO| [BP] 0 B, 
( 0804,A14F )                  LODS, X'| 
( 0804,A150 )                  JMPO, ZO| [AX] 
( 0804,A152 )                 d$  90  90 

( 0804,A154 )   :N_R>   d$  2  0  0  0  "R>" 90 
( 0804,A15B )                 d$  90 

( 0804,A15C )   :X_R>   dl H_R> H_R> 0 X_>R 
( 0804,A16C )                 dl N_R> 0 

( 0804,A174 )   :H_R>    MOV, X| T| AX'| BO| [BP] 0 B, 
( 0804,A177 )                  LEA, BP'| BO| [BP] H_U0 B, 
( 0804,A17A )                  PUSH|X, AX| 
( 0804,A17B )                  LODS, X'| 
( 0804,A17C )                  JMPO, ZO| [AX] 
( 0804,A17E )                 d$  90  90 

( 0804,A180 )   :N_RDROP   d$  5  0  0  0  "RDROP" 90 
( 0804,A18A )                 d$  90  90 

( 0804,A18C )   :X_RDROP   dl H_RDROP H_RDROP 0 X_R> 
( 0804,A19C )                 dl N_RDROP 0 

( 0804,A1A4 )   :H_RDROP    LEA, BP'| BO| [BP] H_U0 B, 
( 0804,A1A7 )                  LODS, X'| 
( 0804,A1A8 )                  JMPO, ZO| [AX] 
( 0804,A1AA )                 d$  90  90 

( 0804,A1AC )   :N_R@   d$  2  0  0  0  "R@" 90 
( 0804,A1B3 )                 d$  90 

( 0804,A1B4 )   :X_R@   dl L0804,98B8 N_0= 0 X_RDROP 
( 0804,A1C4 )                 dl N_R@ 0 

( 0804,A1CC )   :N_0=   d$  2  0  0  0  "0=" 90 
( 0804,A1D3 )                 d$  90 

( 0804,A1D4 )   :X_0=   dl H_0= H_0= 0 X_R@ 
( 0804,A1E4 )                 dl N_0= 0 

( 0804,A1EC )   :H_0=    POP|X, AX| 
( 0804,A1ED )                  NEG, X| R| AX| 
( 0804,A1EF )                  CMC, 
( 0804,A1F0 )                  SBB, X| F| AX'| R| AX| 
( 0804,A1F2 )                  PUSH|X, AX| 
( 0804,A1F3 )                  LODS, X'| 
( 0804,A1F4 )                  JMPO, ZO| [AX] 
( 0804,A1F6 )                 d$  90  90 

( 0804,A1F8 )   :N_0<   d$  2  0  0  0  "0<" 90 
( 0804,A1FF )                 d$  90 

( 0804,A200 )   :X_0<   dl H_0< H_0< 0 X_0= 
( 0804,A210 )                 dl N_0< 0 

( 0804,A218 )   :H_0<    POP|X, AX| 
( 0804,A219 )                  OR, X| F| AX'| R| AX| 
( 0804,A21B )                  MOVI|X, AX| 0 IL, 
( 0804,A220 )                  J, S| N| L0804,A223 RB,
( 0804,A222 )                  DEC|X, AX| 
( 0804,A223 )   :L0804,A223    PUSH|X, AX| 
( 0804,A224 )                  LODS, X'| 
( 0804,A225 )                  JMPO, ZO| [AX] 
( 0804,A227 )                 d$  90 

( 0804,A228 )   :N_+   d$  1  0  0  0  &+ 90 
( 0804,A22E )                 d$  90  90 

( 0804,A230 )   :X_+   dl H_+ H_+ 0 X_0< 
( 0804,A240 )                 dl N_+ 0 

( 0804,A248 )   :H_+    POP|X, AX| 
( 0804,A249 )                  POP|X, BX| 
( 0804,A24A )                  ADD, X| F| BX'| R| AX| 
( 0804,A24C )                  PUSH|X, AX| 
( 0804,A24D )                  LODS, X'| 
( 0804,A24E )                  JMPO, ZO| [AX] 
( 0804,A250 )   :N_D+   d$  2  0  0  0  "D+" 90 
( 0804,A257 )                 d$  90 

( 0804,A258 )   :X_D+   dl H_D+ H_D+ 0 X_+ 
( 0804,A268 )                 dl N_D+ 0 

( 0804,A270 )   :H_D+    POP|X, AX| 
( 0804,A271 )                  POP|X, DX| 
( 0804,A272 )                  POP|X, BX| 
( 0804,A273 )                  POP|X, CX| 
( 0804,A274 )                  ADD, X| F| CX'| R| DX| 
( 0804,A276 )                  ADC, X| F| BX'| R| AX| 
( 0804,A278 )                  PUSH|X, DX| 
( 0804,A279 )                  PUSH|X, AX| 
( 0804,A27A )                  LODS, X'| 
( 0804,A27B )                  JMPO, ZO| [AX] 
( 0804,A27D )                 d$  90  90  90 

( 0804,A280 )   :N_NEGATE   d$  6  0  0  0  "NEGATE" 90 
( 0804,A28B )                 d$  90 

( 0804,A28C )   :X_NEGATE   dl H_NEGATE H_NEGATE 0 X_D+ 
( 0804,A29C )                 dl N_NEGATE 0 

( 0804,A2A4 )   :H_NEGATE    POP|X, AX| 
( 0804,A2A5 )                  NEG, X| R| AX| 
( 0804,A2A7 )                  PUSH|X, AX| 
( 0804,A2A8 )                  LODS, X'| 
( 0804,A2A9 )                  JMPO, ZO| [AX] 
( 0804,A2AB )                 d$  90 

( 0804,A2AC )   :N_DNEGATE   d$  7  0  0  0  "DNEGATE" 90 

( 0804,A2B8 )   :X_DNEGATE   dl H_DNEGATE H_DNEGATE 0 X_NEGATE 
( 0804,A2C8 )                 dl N_DNEGATE 0 

( 0804,A2D0 )   :H_DNEGATE    POP|X, BX| 
( 0804,A2D1 )                  POP|X, CX| 
( 0804,A2D2 )                  SUB, X| F| AX'| R| AX| 
( 0804,A2D4 )                  MOV, X| F| AX'| R| DX| 
( 0804,A2D6 )                  SUB, X| F| CX'| R| DX| 
( 0804,A2D8 )                  SBB, X| F| BX'| R| AX| 
( 0804,A2DA )                  PUSH|X, DX| 
( 0804,A2DB )                  PUSH|X, AX| 
( 0804,A2DC )                  LODS, X'| 
( 0804,A2DD )                  JMPO, ZO| [AX] 
( 0804,A2DF )                 d$  90 

( 0804,A2E0 )   :N_OVER   d$  4  0  0  0  "OVER"

( 0804,A2E8 )   :X_OVER   dl H_OVER H_OVER 0 X_DNEGATE 
( 0804,A2F8 )                 dl N_OVER 0 

( 0804,A300 )   :H_OVER    POP|X, DX| 
( 0804,A301 )                  POP|X, AX| 
( 0804,A302 )                  PUSH|X, AX| 
( 0804,A303 )                  PUSH|X, DX| 
( 0804,A304 )                  PUSH|X, AX| 
( 0804,A305 )                  LODS, X'| 
( 0804,A306 )                  JMPO, ZO| [AX] 
( 0804,A308 )   :N_DROP   d$  4  0  0  0  "DROP"

( 0804,A310 )   :X_DROP   dl H_DROP H_DROP 0 X_OVER 
( 0804,A320 )                 dl N_DROP 0 

( 0804,A328 )   :H_DROP    POP|X, AX| 
( 0804,A329 )                  LODS, X'| 
( 0804,A32A )                  JMPO, ZO| [AX] 
( 0804,A32C )   :N_2DROP   d$  5  0  0  0  "2DROP" 90 
( 0804,A336 )                 d$  90  90 

( 0804,A338 )   :X_2DROP   dl H_2DROP H_2DROP 0 X_DROP 
( 0804,A348 )                 dl N_2DROP 0 

( 0804,A350 )   :H_2DROP    POP|X, AX| 
( 0804,A351 )                  POP|X, AX| 
( 0804,A352 )                  LODS, X'| 
( 0804,A353 )                  JMPO, ZO| [AX] 
( 0804,A355 )                 d$  90  90  90 

( 0804,A358 )   :N_SWAP   d$  4  0  0  0  "SWAP"

( 0804,A360 )   :X_SWAP   dl H_SWAP H_SWAP 0 X_2DROP 
( 0804,A370 )                 dl N_SWAP 0 

( 0804,A378 )   :H_SWAP    POP|X, DX| 
( 0804,A379 )                  POP|X, AX| 
( 0804,A37A )                  PUSH|X, DX| 
( 0804,A37B )                  PUSH|X, AX| 
( 0804,A37C )                  LODS, X'| 
( 0804,A37D )                  JMPO, ZO| [AX] 
( 0804,A37F )                 d$  90 

( 0804,A380 )   :N_DUP   d$  3  0  0  0  "DUP" 90 

( 0804,A388 )   :X_DUP   dl H_DUP H_DUP 0 X_SWAP 
( 0804,A398 )                 dl N_DUP 0 

( 0804,A3A0 )   :H_DUP    POP|X, AX| 
( 0804,A3A1 )                  PUSH|X, AX| 
( 0804,A3A2 )                  PUSH|X, AX| 
( 0804,A3A3 )                  LODS, X'| 
( 0804,A3A4 )                  JMPO, ZO| [AX] 
( 0804,A3A6 )                 d$  90  90 

( 0804,A3A8 )   :N_2DUP   d$  4  0  0  0  "2DUP"

( 0804,A3B0 )   :X_2DUP   dl H_2DUP H_2DUP 0 X_DUP 
( 0804,A3C0 )                 dl N_2DUP 0 

( 0804,A3C8 )   :H_2DUP    POP|X, AX| 
( 0804,A3C9 )                  POP|X, DX| 
( 0804,A3CA )                  PUSH|X, DX| 
( 0804,A3CB )                  PUSH|X, AX| 
( 0804,A3CC )                  PUSH|X, DX| 
( 0804,A3CD )                  PUSH|X, AX| 
( 0804,A3CE )                  LODS, X'| 
( 0804,A3CF )                  JMPO, ZO| [AX] 
( 0804,A3D1 )                 d$  90  90  90 

( 0804,A3D4 )   :N_2SWAP   d$  5  0  0  0  "2SWAP" 90 
( 0804,A3DE )                 d$  90  90 

( 0804,A3E0 )   :X_2SWAP   dl H_2SWAP H_2SWAP 0 X_2DUP 
( 0804,A3F0 )                 dl N_2SWAP 0 

( 0804,A3F8 )   :H_2SWAP    POP|X, BX| 
( 0804,A3F9 )                  POP|X, CX| 
( 0804,A3FA )                  POP|X, AX| 
( 0804,A3FB )                  POP|X, DX| 
( 0804,A3FC )                  PUSH|X, CX| 
( 0804,A3FD )                  PUSH|X, BX| 
( 0804,A3FE )                  PUSH|X, DX| 
( 0804,A3FF )                  PUSH|X, AX| 
( 0804,A400 )                  LODS, X'| 
( 0804,A401 )                  JMPO, ZO| [AX] 
( 0804,A403 )                 d$  90 

( 0804,A404 )   :N_2OVER   d$  5  0  0  0  "2OVER" 90 
( 0804,A40E )                 d$  90  90 

( 0804,A410 )   :X_2OVER   dl H_2OVER H_2OVER 0 X_2SWAP 
( 0804,A420 )                 dl N_2OVER 0 

( 0804,A428 )   :H_2OVER    POP|X, BX| 
( 0804,A429 )                  POP|X, CX| 
( 0804,A42A )                  POP|X, AX| 
( 0804,A42B )                  POP|X, DX| 
( 0804,A42C )                  PUSH|X, DX| 
( 0804,A42D )                  PUSH|X, AX| 
( 0804,A42E )                  PUSH|X, CX| 
( 0804,A42F )                  PUSH|X, BX| 
( 0804,A430 )                  PUSH|X, DX| 
( 0804,A431 )                  PUSH|X, AX| 
( 0804,A432 )                  LODS, X'| 
( 0804,A433 )                  JMPO, ZO| [AX] 
( 0804,A435 )                 d$  90  90  90 

( 0804,A438 )   :N_+!   d$  2  0  0  0  "+!" 90 
( 0804,A43F )                 d$  90 

( 0804,A440 )   :X_+!   dl H_+! H_+! 0 X_2OVER 
( 0804,A450 )                 dl N_+! 0 

( 0804,A458 )   :H_+!    POP|X, BX| 
( 0804,A459 )                  POP|X, AX| 
( 0804,A45A )                  ADD, X| F| AX'| ZO| [BX] 
( 0804,A45C )                  LODS, X'| 
( 0804,A45D )                  JMPO, ZO| [AX] 
( 0804,A45F )                 d$  90 

( 0804,A460 )   :N_TOGGLE   d$  6  0  0  0  "TOGGLE" 90 
( 0804,A46B )                 d$  90 

( 0804,A46C )   :X_TOGGLE   dl H_TOGGLE H_TOGGLE 0 X_+! 
( 0804,A47C )                 dl N_TOGGLE 0 

( 0804,A484 )   :H_TOGGLE    POP|X, AX| 
( 0804,A485 )                  POP|X, BX| 
( 0804,A486 )                  XOR, X| F| AX'| ZO| [BX] 
( 0804,A488 )                  LODS, X'| 
( 0804,A489 )                  JMPO, ZO| [AX] 
( 0804,A48B )                 d$  90 

( 0804,A48C )   :N_@   d$  1  0  0  0  &@ 90 
( 0804,A492 )                 d$  90  90 

( 0804,A494 )   :X_@   dl H_@ H_@ 0 X_TOGGLE 
( 0804,A4A4 )                 dl N_@ 0 

( 0804,A4AC )   :H_@    POP|X, BX| 
( 0804,A4AD )                  MOV, X| T| AX'| ZO| [BX] 
( 0804,A4AF )                  PUSH|X, AX| 
( 0804,A4B0 )                  LODS, X'| 
( 0804,A4B1 )                  JMPO, ZO| [AX] 
( 0804,A4B3 )                 d$  90 

( 0804,A4B4 )   :N_C@   d$  2  0  0  0  "C@" 90 
( 0804,A4BB )                 d$  90 

( 0804,A4BC )   :X_C@   dl H_C@ H_C@ 0 X_@ 
( 0804,A4CC )                 dl N_C@ 0 

( 0804,A4D4 )   :H_C@    POP|X, BX| 
( 0804,A4D5 )                  XOR, X| F| AX'| R| AX| 
( 0804,A4D7 )                  MOV, B| T| AL'| ZO| [BX] 
( 0804,A4D9 )                  PUSH|X, AX| 
( 0804,A4DA )                  LODS, X'| 
( 0804,A4DB )                  JMPO, ZO| [AX] 
( 0804,A4DD )                 d$  90  90  90 

( 0804,A4E0 )   :N_2@   d$  2  0  0  0  "2@" 90 
( 0804,A4E7 )                 d$  90 

( 0804,A4E8 )   :X_2@   dl H_2@ H_2@ 0 X_C@ 
( 0804,A4F8 )                 dl N_2@ 0 

( 0804,A500 )   :H_2@    POP|X, BX| 
( 0804,A501 )                  MOV, X| T| AX'| ZO| [BX] 
( 0804,A503 )                  MOV, X| T| DX'| BO| [BX] H_U0 B, 
( 0804,A506 )                  PUSH|X, DX| 
( 0804,A507 )                  PUSH|X, AX| 
( 0804,A508 )                  LODS, X'| 
( 0804,A509 )                  JMPO, ZO| [AX] 
( 0804,A50B )                 d$  90 

( 0804,A50C )   :N_!   d$  1  0  0  0  &! 90 
( 0804,A512 )                 d$  90  90 

( 0804,A514 )   :X_!   dl H_! H_! 0 X_2@ 
( 0804,A524 )                 dl N_! 0 

( 0804,A52C )   :H_!    POP|X, BX| 
( 0804,A52D )                  POP|X, AX| 
( 0804,A52E )                  MOV, X| F| AX'| ZO| [BX] 
( 0804,A530 )                  LODS, X'| 
( 0804,A531 )                  JMPO, ZO| [AX] 
( 0804,A533 )                 d$  90 

( 0804,A534 )   :N_C!   d$  2  0  0  0  "C!" 90 
( 0804,A53B )                 d$  90 

( 0804,A53C )   :X_C!   dl H_C! H_C! 0 X_! 
( 0804,A54C )                 dl N_C! 0 

( 0804,A554 )   :H_C!    POP|X, BX| 
( 0804,A555 )                  POP|X, AX| 
( 0804,A556 )                  MOV, B| F| AL'| ZO| [BX] 
( 0804,A558 )                  LODS, X'| 
( 0804,A559 )                  JMPO, ZO| [AX] 
( 0804,A55B )                 d$  90 

( 0804,A55C )   :N_2!   d$  2  0  0  0  "2!" 90 
( 0804,A563 )                 d$  90 

( 0804,A564 )   :X_2!   dl H_2! H_2! 0 X_C! 
( 0804,A574 )                 dl N_2! 0 

( 0804,A57C )   :H_2!    POP|X, BX| 
( 0804,A57D )                  POP|X, AX| 
( 0804,A57E )                  MOV, X| F| AX'| ZO| [BX] 
( 0804,A580 )                  POP|X, AX| 
( 0804,A581 )                  MOV, X| F| AX'| BO| [BX] H_U0 B, 
( 0804,A584 )                  LODS, X'| 
( 0804,A585 )                  JMPO, ZO| [AX] 
( 0804,A587 )                 d$  90 

( 0804,A588 )   :N_WITHIN   d$  6  0  0  0  "WITHIN" 90 
( 0804,A593 )                 d$  90 

( 0804,A594 )   :X_WITHIN   dl docol H_WITHIN 0 X_2! 
( 0804,A5A4 )                 dl N_WITHIN 0 
( 0804,A5AC )   :H_WITHIN   dl X_OVER X_- 
( 0804,A5B4 )                 dl X_>R X_- X_R> X_U< 
( 0804,A5C4 )                 dl semis 

( 0804,A5C8 )   :N_L@   d$  2  0  0  0  "L@" 90 
( 0804,A5CF )                 d$  90 

( 0804,A5D0 )   :X_L@   dl H_L@ H_L@ 0 X_WITHIN 
( 0804,A5E0 )                 dl N_L@ 0 

( 0804,A5E8 )   :H_L@    POP|X, BX| 
( 0804,A5E9 )                  POP|X, CX| 
( 0804,A5EA )                  MOV|SG, F| DS| R| DX| 
( 0804,A5EC )                  MOV|SG, T| DS| R| CX| 
( 0804,A5EE )                  MOV, X| T| BX'| ZO| [BX] 
( 0804,A5F0 )                  MOV|SG, T| DS| R| DX| 
( 0804,A5F2 )                  PUSH|X, BX| 
( 0804,A5F3 )                  LODS, X'| 
( 0804,A5F4 )                  JMPO, ZO| [AX] 
( 0804,A5F6 )                 d$  90  90 

( 0804,A5F8 )   :N_L!   d$  2  0  0  0  "L!" 90 
( 0804,A5FF )                 d$  90 

( 0804,A600 )   :X_L!   dl H_L! H_L! 0 X_L@ 
( 0804,A610 )                 dl N_L! 0 

( 0804,A618 )   :H_L!    POP|X, BX| 
( 0804,A619 )                  POP|X, CX| 
( 0804,A61A )                  POP|X, DX| 
( 0804,A61B )                  MOV|SG, F| DS| R| AX| 
( 0804,A61D )                  MOV|SG, T| DS| R| CX| 
( 0804,A61F )                  MOV, X| F| DX'| ZO| [BX] 
( 0804,A621 )                  MOV|SG, T| DS| R| AX| 
( 0804,A623 )                  LODS, X'| 
( 0804,A624 )                  JMPO, ZO| [AX] 
( 0804,A626 )                 d$  90  90 

( 0804,A628 )   :N_:   d$  1  0  0  0  &: 90 
( 0804,A62E )                 d$  90  90 

( 0804,A630 )   :X_:   dl docol H_: 0 X_L! 
( 0804,A640 )                 dl N_: 0 
( 0804,A648 )   :H_:   dl X_!CSP X_(WORD) 
( 0804,A650 )                 dl X_(CREATE) X_LATEST X_HIDDEN X_] 
( 0804,A660 )                 dl semiscode 

( 0804,A664 )   :docol    LEA, BP'| BO| [BP] 0FC B, 
( 0804,A667 )                  MOV, X| F| SI'| BO| [BP] 0 B, 
( 0804,A66A )                  MOV, X| T| SI'| BO| [AX] H_U0 B, 
( 0804,A66D )                  LODS, X'| 
( 0804,A66E )                  JMPO, ZO| [AX] 
( 0804,A670 )   :N_;   d$  1  0  0  0  &; 90 
( 0804,A676 )                 d$  90  90 

( 0804,A678 )   :X_;   dl docol H_; H_U0 X_: 
( 0804,A688 )                 dl N_; 0 
( 0804,A690 )   :H_;   dl X_?CSP X_LIT 
( 0804,A698 )                 dl semis X_, X_LATEST X_HIDDEN 
( 0804,A6A8 )                 dl X_[ semis 

( 0804,A6B0 )   :N_CONSTANT   d$  8  0  0  0  "CONSTANT"

( 0804,A6BC )   :X_CONSTANT   dl docol H_CONSTANT 0 X_; 
( 0804,A6CC )                 dl N_CONSTANT 0 
( 0804,A6D4 )   :H_CONSTANT   dl X_(WORD) X_(CREATE) 
( 0804,A6DC )                 dl X_LATEST X_>DFA X_! semiscode 

( 0804,A6EC )   :doconstant    MOV, X| T| AX'| BO| [AX] H_U0 B, 
( 0804,A6EF )                  PUSH|X, AX| 
( 0804,A6F0 )                  LODS, X'| 
( 0804,A6F1 )                  JMPO, ZO| [AX] 
( 0804,A6F3 )                 d$  90 

( 0804,A6F4 )   :N_VARIABLE   d$  8  0  0  0  "VARIABLE"

( 0804,A700 )   :X_VARIABLE   dl docol H_VARIABLE 0 X_CONSTANT 
( 0804,A710 )                 dl N_VARIABLE 0 
( 0804,A718 )   :H_VARIABLE   dl X_(WORD) X_(CREATE) 
( 0804,A720 )                 dl X_0 X_, semiscode 

( 0804,A72C )   :dovar    MOV, X| T| AX'| BO| [AX] H_U0 B, 
( 0804,A72F )                  PUSH|X, AX| 
( 0804,A730 )                  LODS, X'| 
( 0804,A731 )                  JMPO, ZO| [AX] 
( 0804,A733 )                 d$  90 

( 0804,A734 )   :N_USER   d$  4  0  0  0  "USER"

( 0804,A73C )   :X_USER   dl docol H_USER 0 X_VARIABLE 
( 0804,A74C )                 dl N_USER 0 
( 0804,A754 )   :H_USER   dl X_CONSTANT semiscode 

( 0804,A75C )   :douse    MOV, X| T| BX'| BO| [AX] H_U0 B, 
( 0804,A75F )                  MOV, X| T| DI'| MEM| init_user L, 
( 0804,A765 )                  LEA, AX'| ZO|    [BX +1* DI] 
( 0804,A768 )                  PUSH|X, AX| 
( 0804,A769 )                  LODS, X'| 
( 0804,A76A )                  JMPO, ZO| [AX] 
( 0804,A76C )   :N__   d$  1  0  0  0  &_ 90 
( 0804,A772 )                 d$  90  90 

( 0804,A774 )   :X__   dl H__ H__ 0 X_USER 
( 0804,A784 )                 dl N__ 0 

( 0804,A78C )   :H__    PUSH|X, AX| 
( 0804,A78D )                  LODS, X'| 
( 0804,A78E )                  JMPO, ZO| [AX] 
( 0804,A790 )   :N_0   d$  1  0  0  0  &0 90 
( 0804,A796 )                 d$  90  90 

( 0804,A798 )   :X_0   dl H_0 H_0 0 X__ 
( 0804,A7A8 )                 dl N_0 0 

( 0804,A7B0 )   :H_0    XOR, X| F| AX'| R| AX| 
( 0804,A7B2 )                  PUSH|X, AX| 
( 0804,A7B3 )                  LODS, X'| 
( 0804,A7B4 )                  JMPO, ZO| [AX] 
( 0804,A7B6 )                 d$  90  90 

( 0804,A7B8 )   :N_1   d$  1  0  0  0  &1 90 
( 0804,A7BE )                 d$  90  90 

( 0804,A7C0 )   :X_1   dl H_1 H_1 0 X_0 
( 0804,A7D0 )                 dl N_1 0 

( 0804,A7D8 )   :H_1    MOVI|X, AX| 1 IL, 
( 0804,A7DD )                  PUSH|X, AX| 
( 0804,A7DE )                  LODS, X'| 
( 0804,A7DF )                  JMPO, ZO| [AX] 
( 0804,A7E1 )                 d$  90  90  90 

( 0804,A7E4 )   :N_2   d$  1  0  0  0  &2 90 
( 0804,A7EA )                 d$  90  90 

( 0804,A7EC )   :X_2   dl H_2 H_2 0 X_1 
( 0804,A7FC )                 dl N_2 0 

( 0804,A804 )   :H_2    MOVI|X, AX| 2 IL, 
( 0804,A809 )                  PUSH|X, AX| 
( 0804,A80A )                  LODS, X'| 
( 0804,A80B )                  JMPO, ZO| [AX] 
( 0804,A80D )                 d$  90  90  90 

( 0804,A810 )   :N_BL   d$  2  0  0  0  "BL" 90 
( 0804,A817 )                 d$  90 

( 0804,A818 )   :X_BL   dl doconstant H_FENCE 0 X_2 
( 0804,A828 )                 dl N_BL 0 

( 0804,A830 )   :N_$@   d$  2  0  0  0  "$@" 90 
( 0804,A837 )                 d$  90 

( 0804,A838 )   :X_$@   dl docol H_$@ 0 X_BL 
( 0804,A848 )                 dl N_$@ 0 
( 0804,A850 )   :H_$@   dl X_DUP X_CELL+ 
( 0804,A858 )                 dl X_SWAP X_@ semis 

( 0804,A864 )   :N_$!   d$  2  0  0  0  "$!" 90 
( 0804,A86B )                 d$  90 

( 0804,A86C )   :X_$!   dl docol H_$! 0 X_$@ 
( 0804,A87C )                 dl N_$! 0 
( 0804,A884 )   :H_$!   dl X_2DUP X_! 
( 0804,A88C )                 dl X_CELL+ X_SWAP X_CMOVE semis 

( 0804,A89C )   :N_$!-BD   d$  5  0  0  0  "$!-BD" 90 
( 0804,A8A6 )                 d$  90  90 

( 0804,A8A8 )   :X_$!-BD   dl docol H_$!-BD 0 X_$! 
( 0804,A8B8 )                 dl N_$!-BD 0 
( 0804,A8C0 )   :H_$!-BD   dl X_2DUP X_C! 
( 0804,A8C8 )                 dl X_1+ X_SWAP X_CMOVE semis 

( 0804,A8D8 )   :N_$+!   d$  3  0  0  0  "$+!" 90 

( 0804,A8E0 )   :X_$+!   dl docol H_$+! 0 X_$!-BD 
( 0804,A8F0 )                 dl N_$+! 0 
( 0804,A8F8 )   :H_$+!   dl X_DUP X_@ 
( 0804,A900 )                 dl X_>R X_2DUP X_+! X_CELL+ 
( 0804,A910 )                 dl X_R> X_+ X_SWAP X_CMOVE 
( 0804,A920 )                 dl semis 

( 0804,A924 )   :N_$C+   d$  3  0  0  0  "$C+" 90 

( 0804,A92C )   :X_$C+   dl docol H_$C+ 0 X_$+! 
( 0804,A93C )                 dl N_$C+ 0 
( 0804,A944 )   :H_$C+   dl X_DUP X_>R 
( 0804,A94C )                 dl X_DUP X_@ X_+ X_CELL+ 
( 0804,A95C )                 dl X_C! X_1 X_R> X_+! 
( 0804,A96C )                 dl semis 

( 0804,A970 )   :N_$,   d$  2  0  0  0  "$," 90 
( 0804,A977 )                 d$  90 

( 0804,A978 )   :X_$,   dl docol H_$, 0 X_$C+ 
( 0804,A988 )                 dl N_$, 0 
( 0804,A990 )   :H_$,   dl X_HERE X_>R 
( 0804,A998 )                 dl X_DUP X_CELL+ X_ALLOT X_R@ 
( 0804,A9A8 )                 dl X_$! X_R> X_ALIGN semis 

( 0804,A9B8 )   :N_C/L   d$  3  0  0  0  "C/L" 90 

( 0804,A9C0 )   :X_C/L   dl doconstant H_C/L 0 X_$, 
( 0804,A9D0 )                 dl N_C/L 0 

( 0804,A9D8 )   :N_FIRST   d$  5  0  0  0  "FIRST" 90 
( 0804,A9E2 )                 d$  90  90 

( 0804,A9E4 )   :X_FIRST   dl doconstant H_FIRST 0 X_C/L 
( 0804,A9F4 )                 dl N_FIRST 0 

( 0804,A9FC )   :N_LIMIT   d$  5  0  0  0  "LIMIT" 90 
( 0804,AA06 )                 d$  90  90 

( 0804,AA08 )   :X_LIMIT   dl doconstant H_EM 0 X_FIRST 
( 0804,AA18 )                 dl N_LIMIT 0 

( 0804,AA20 )   :N_EM   d$  2  0  0  0  "EM" 90 
( 0804,AA27 )                 d$  90 

( 0804,AA28 )   :X_EM   dl doconstant H_EM 0 X_LIMIT 
( 0804,AA38 )                 dl N_EM 0 

( 0804,AA40 )   :N_BM   d$  2  0  0  0  "BM" 90 
( 0804,AA47 )                 d$  90 

( 0804,AA48 )   :X_BM   dl doconstant H_BM 0 X_EM 
( 0804,AA58 )                 dl N_BM 0 

( 0804,AA60 )   :N_B/BUF   d$  5  0  0  0  "B/BUF" 90 
( 0804,AA6A )                 d$  90  90 

( 0804,AA6C )   :X_B/BUF   dl doconstant H_B/BUF 0 X_BM 
( 0804,AA7C )                 dl N_B/BUF 0 

( 0804,AA84 )   :N_U0   d$  2  0  0  0  "U0" 90 
( 0804,AA8B )                 d$  90 

( 0804,AA8C )   :X_U0   dl douse H_U0 0 X_B/BUF 
( 0804,AA9C )                 dl N_U0 0 

( 0804,AAA4 )   :N_S0   d$  2  0  0  0  "S0" 90 
( 0804,AAAB )                 d$  90 

( 0804,AAAC )   :X_S0   dl douse H_#BUFF 0 X_U0 
( 0804,AABC )                 dl N_S0 0 

( 0804,AAC4 )   :N_R0   d$  2  0  0  0  "R0" 90 
( 0804,AACB )                 d$  90 

( 0804,AACC )   :X_R0   dl douse H_R0 0 X_S0 
( 0804,AADC )                 dl N_R0 0 

( 0804,AAE4 )   :N_TIB   d$  3  0  0  0  "TIB" 90 

( 0804,AAEC )   :X_TIB   dl douse H_TIB 0 X_R0 
( 0804,AAFC )                 dl N_TIB 0 

( 0804,AB04 )   :N_RUBOUT   d$  6  0  0  0  "RUBOUT" 90 
( 0804,AB0F )                 d$  90 

( 0804,AB10 )   :X_RUBOUT   dl douse H_RUBOUT 0 X_TIB 
( 0804,AB20 )                 dl N_RUBOUT 0 

( 0804,AB28 )   :N_WARNING   d$  7  0  0  0  "WARNING" 90 

( 0804,AB34 )   :X_WARNING   dl douse H_WARNING 0 X_RUBOUT 
( 0804,AB44 )                 dl N_WARNING 0 

( 0804,AB4C )   :N_FENCE   d$  5  0  0  0  "FENCE" 90 
( 0804,AB56 )                 d$  90  90 

( 0804,AB58 )   :X_FENCE   dl douse H_FENCE 0 X_WARNING 
( 0804,AB68 )                 dl N_FENCE 0 

( 0804,AB70 )   :N_DP   d$  2  0  0  0  "DP" 90 
( 0804,AB77 )                 d$  90 

( 0804,AB78 )   :X_DP   dl douse H_DP 0 X_FENCE 
( 0804,AB88 )                 dl N_DP 0 

( 0804,AB90 )   :N_VOC-LINK   d$  8  0  0  0  "VOC-LINK"

( 0804,AB9C )   :X_VOC-LINK   dl douse H_VOC-LINK 0 X_DP 
( 0804,ABAC )                 dl N_VOC-LINK 0 

( 0804,ABB4 )   :N_OFFSET   d$  6  0  0  0  "OFFSET" 90 
( 0804,ABBF )                 d$  90 

( 0804,ABC0 )   :X_OFFSET   dl douse H_OFFSET 0 X_VOC-LINK 
( 0804,ABD0 )                 dl N_OFFSET 0 

( 0804,ABD8 )   :N_WHERE   d$  5  0  0  0  "WHERE" 90 
( 0804,ABE2 )                 d$  90  90 

( 0804,ABE4 )   :X_WHERE   dl douse H_WHERE 0 X_OFFSET 
( 0804,ABF4 )                 dl N_WHERE 0 

( 0804,ABFC )   :N_SCR   d$  3  0  0  0  "SCR" 90 

( 0804,AC04 )   :X_SCR   dl douse H_SCR 0 X_WHERE 
( 0804,AC14 )                 dl N_SCR 0 

( 0804,AC1C )   :N_STATE   d$  5  0  0  0  "STATE" 90 
( 0804,AC26 )                 d$  90  90 

( 0804,AC28 )   :X_STATE   dl douse H_STATE 0 X_SCR 
( 0804,AC38 )                 dl N_STATE 0 

( 0804,AC40 )   :N_BASE   d$  4  0  0  0  "BASE"

( 0804,AC48 )   :X_BASE   dl douse H_BASE 0 X_STATE 
( 0804,AC58 )                 dl N_BASE 0 

( 0804,AC60 )   :N_DPL   d$  3  0  0  0  "DPL" 90 

( 0804,AC68 )   :X_DPL   dl douse H_DPL 0 X_BASE 
( 0804,AC78 )                 dl N_DPL 0 

( 0804,AC80 )   :N_FLD   d$  3  0  0  0  "FLD" 90 

( 0804,AC88 )   :X_FLD   dl douse H_FLD 0 X_DPL 
( 0804,AC98 )                 dl N_FLD 0 

( 0804,ACA0 )   :N_CSP   d$  3  0  0  0  "CSP" 90 

( 0804,ACA8 )   :X_CSP   dl douse H_CSP 0 X_FLD 
( 0804,ACB8 )                 dl N_CSP 0 

( 0804,ACC0 )   :N_R#   d$  2  0  0  0  "R#" 90 
( 0804,ACC7 )                 d$  90 

( 0804,ACC8 )   :X_R#   dl douse H_R# 0 X_CSP 
( 0804,ACD8 )                 dl N_R# 0 

( 0804,ACE0 )   :N_HLD   d$  3  0  0  0  "HLD" 90 

( 0804,ACE8 )   :X_HLD   dl douse H_HLD 0 X_R# 
( 0804,ACF8 )                 dl N_HLD 0 

( 0804,AD00 )   :N_OUT   d$  3  0  0  0  "OUT" 90 

( 0804,AD08 )   :X_OUT   dl douse H_OUT 0 X_HLD 
( 0804,AD18 )                 dl N_OUT 0 

( 0804,AD20 )   :N_(BLK)   d$  5  0  0  0  "(BLK)" 90 
( 0804,AD2A )                 d$  90  90 

( 0804,AD2C )   :X_(BLK)   dl douse H_(BLK) 0 X_OUT 
( 0804,AD3C )                 dl N_(BLK) 0 

( 0804,AD44 )   :N_IN   d$  2  0  0  0  "IN" 90 
( 0804,AD4B )                 d$  90 

( 0804,AD4C )   :X_IN   dl douse H_IN 0 X_(BLK) 
( 0804,AD5C )                 dl N_IN 0 

( 0804,AD64 )   :N_(>IN)   d$  5  0  0  0  "(>IN)" 90 
( 0804,AD6E )                 d$  90  90 

( 0804,AD70 )   :X_(>IN)   dl douse H_(>IN) 0 X_IN 
( 0804,AD80 )                 dl N_(>IN) 0 

( 0804,AD88 )   :N_ARGS   d$  4  0  0  0  "ARGS"

( 0804,AD90 )   :X_ARGS   dl douse H_ARGS 0 X_(>IN) 
( 0804,ADA0 )                 dl N_ARGS 0 

( 0804,ADA8 )   :N_HANDLER   d$  7  0  0  0  "HANDLER" 90 

( 0804,ADB4 )   :X_HANDLER   dl douse H_HANDLER 0 X_ARGS 
( 0804,ADC4 )                 dl N_HANDLER 0 

( 0804,ADCC )   :N_CURRENT   d$  7  0  0  0  "CURRENT" 90 

( 0804,ADD8 )   :X_CURRENT   dl douse H_CURRENT 0 X_HANDLER 
( 0804,ADE8 )                 dl N_CURRENT 0 

( 0804,ADF0 )   :N_REMAINDER   d$  ^I 0  0  0  "REMAINDER" 90 
( 0804,ADFE )                 d$  90  90 

( 0804,AE00 )   :X_REMAINDER   dl douse H_REMAINDER 0 X_CURRENT 
( 0804,AE10 )                 dl N_REMAINDER 0 

( 0804,AE18 )   :N_CONTEXT   d$  7  0  0  0  "CONTEXT" 90 

( 0804,AE24 )   :X_CONTEXT   dl douse H_CONTEXT 0 X_REMAINDER 
( 0804,AE34 )                 dl N_CONTEXT 0 

( 0804,AE3C )   :N_1+   d$  2  0  0  0  "1+" 90 
( 0804,AE43 )                 d$  90 

( 0804,AE44 )   :X_1+   dl docol H_CHAR+ 0 X_CONTEXT 
( 0804,AE54 )                 dl N_1+ 0 
( 0804,AE5C )   :H_CHAR+   dl X_1 X_+ 
( 0804,AE64 )                 dl semis 

( 0804,AE68 )   :N_CELL+   d$  5  0  0  0  "CELL+" 90 
( 0804,AE72 )                 d$  90  90 

( 0804,AE74 )   :X_CELL+   dl docol H_CELL+ 0 X_1+ 
( 0804,AE84 )                 dl N_CELL+ 0 
( 0804,AE8C )   :H_CELL+   dl X_LIT H_U0 
( 0804,AE94 )                 dl X_+ semis 

( 0804,AE9C )   :N_CELLS   d$  5  0  0  0  "CELLS" 90 
( 0804,AEA6 )                 d$  90  90 

( 0804,AEA8 )   :X_CELLS   dl docol H_CELLS 0 X_CELL+ 
( 0804,AEB8 )                 dl N_CELLS 0 
( 0804,AEC0 )   :H_CELLS   dl X_2 X_LSHIFT 
( 0804,AEC8 )                 dl semis 

( 0804,AECC )   :N_CHAR+   d$  5  0  0  0  "CHAR+" 90 
( 0804,AED6 )                 d$  90  90 

( 0804,AED8 )   :X_CHAR+   dl docol H_CHAR+ 0 X_CELLS 
( 0804,AEE8 )                 dl N_CHAR+ 0 

( 0804,AEF0 )   :N_CHARS   d$  5  0  0  0  "CHARS" 90 
( 0804,AEFA )                 d$  90  90 

( 0804,AEFC )   :X_CHARS   dl docol H_CHARS H_U0 X_CHAR+ 
( 0804,AF0C )                 dl N_CHARS 0 
( 0804,AF14 )   :H_CHARS   dl semis 

( 0804,AF18 )   :N_ALIGN   d$  5  0  0  0  "ALIGN" 90 
( 0804,AF22 )                 d$  90  90 

( 0804,AF24 )   :X_ALIGN   dl docol H_ALIGN H_U0 X_CHARS 
( 0804,AF34 )                 dl N_ALIGN 0 
( 0804,AF3C )   :H_ALIGN   dl X_DP X_@ 
( 0804,AF44 )                 dl X_ALIGNED X_DP X_! semis 

( 0804,AF54 )   :N_ALIGNED   d$  7  0  0  0  "ALIGNED" 90 

( 0804,AF60 )   :X_ALIGNED   dl H_ALIGNED H_ALIGNED 0 X_ALIGN 
( 0804,AF70 )                 dl N_ALIGNED 0 

( 0804,AF78 )   :H_ALIGNED    POP|X, AX| 
( 0804,AF79 )                  DEC|X, AX| 
( 0804,AF7A )                  ORI|A, B'| 3 IB, 
( 0804,AF7C )                  INC|X, AX| 
( 0804,AF7D )                  PUSH|X, AX| 
( 0804,AF7E )                  LODS, X'| 
( 0804,AF7F )                  JMPO, ZO| [AX] 
( 0804,AF81 )                 d$  90  90  90 

( 0804,AF84 )   :N_HERE   d$  4  0  0  0  "HERE"

( 0804,AF8C )   :X_HERE   dl docol H_HERE 0 X_ALIGNED 
( 0804,AF9C )                 dl N_HERE 0 
( 0804,AFA4 )   :H_HERE   dl X_DP X_@ 
( 0804,AFAC )                 dl semis 

( 0804,AFB0 )   :N_ALLOT   d$  5  0  0  0  "ALLOT" 90 
( 0804,AFBA )                 d$  90  90 

( 0804,AFBC )   :X_ALLOT   dl docol H_ALLOT 0 X_HERE 
( 0804,AFCC )                 dl N_ALLOT 0 
( 0804,AFD4 )   :H_ALLOT   dl X_DP X_+! 
( 0804,AFDC )                 dl semis 

( 0804,AFE0 )   :N_,   d$  1  0  0  0  &, 90 
( 0804,AFE6 )                 d$  90  90 

( 0804,AFE8 )   :X_,   dl docol H_, 0 X_ALLOT 
( 0804,AFF8 )                 dl N_, 0 
( 0804,B000 )   :H_,   dl X_HERE X_! 
( 0804,B008 )                 dl X_LIT H_U0 X_ALLOT semis 

( 0804,B018 )   :N_C,   d$  2  0  0  0  "C," 90 
( 0804,B01F )                 d$  90 

( 0804,B020 )   :X_C,   dl docol H_C, 0 X_, 
( 0804,B030 )                 dl N_C, 0 
( 0804,B038 )   :H_C,   dl X_HERE X_C! 
( 0804,B040 )                 dl X_1 X_ALLOT semis 

( 0804,B04C )   :N_-   d$  1  0  0  0  &- 90 
( 0804,B052 )                 d$  90  90 

( 0804,B054 )   :X_-   dl H_- H_- 0 X_C, 
( 0804,B064 )                 dl N_- 0 

( 0804,B06C )   :H_-    POP|X, DX| 
( 0804,B06D )                  POP|X, AX| 
( 0804,B06E )                  SUB, X| F| DX'| R| AX| 
( 0804,B070 )                  PUSH|X, AX| 
( 0804,B071 )                  LODS, X'| 
( 0804,B072 )                  JMPO, ZO| [AX] 
( 0804,B074 )   :N_=   d$  1  0  0  0  &= 90 
( 0804,B07A )                 d$  90  90 

( 0804,B07C )   :X_=   dl docol H_= 0 X_- 
( 0804,B08C )                 dl N_= 0 
( 0804,B094 )   :H_=   dl X_- X_0= 
( 0804,B09C )                 dl semis 

( 0804,B0A0 )   :N_<   d$  1  0  0  0  &< 90 
( 0804,B0A6 )                 d$  90  90 

( 0804,B0A8 )   :X_<   dl H_< H_< 0 X_= 
( 0804,B0B8 )                 dl N_< 0 

( 0804,B0C0 )   :H_<    POP|X, DX| 
( 0804,B0C1 )                  POP|X, BX| 
( 0804,B0C2 )                  XOR, X| F| AX'| R| AX| 
( 0804,B0C4 )                  CMP, X| F| DX'| R| BX| 
( 0804,B0C6 )                  J, L| N| L0804,B0C9 RB,
( 0804,B0C8 )                  DEC|X, AX| 
( 0804,B0C9 )   :L0804,B0C9    PUSH|X, AX| 
( 0804,B0CA )                  LODS, X'| 
( 0804,B0CB )                  JMPO, ZO| [AX] 
( 0804,B0CD )                 d$  90  90  90 

( 0804,B0D0 )   :N_U<   d$  2  0  0  0  "U<" 90 
( 0804,B0D7 )                 d$  90 

( 0804,B0D8 )   :X_U<   dl H_U< H_U< 0 X_< 
( 0804,B0E8 )                 dl N_U< 0 

( 0804,B0F0 )   :H_U<    POP|X, AX| 
( 0804,B0F1 )                  POP|X, DX| 
( 0804,B0F2 )                  SUB, X| F| AX'| R| DX| 
( 0804,B0F4 )                  SBB, X| F| AX'| R| AX| 
( 0804,B0F6 )                  PUSH|X, AX| 
( 0804,B0F7 )                  LODS, X'| 
( 0804,B0F8 )                  JMPO, ZO| [AX] 
( 0804,B0FA )                 d$  90  90 

( 0804,B0FC )   :N_>   d$  1  0  0  0  &> 90 
( 0804,B102 )                 d$  90  90 

( 0804,B104 )   :X_>   dl docol H_> 0 X_U< 
( 0804,B114 )                 dl N_> 0 
( 0804,B11C )   :H_>   dl X_SWAP X_< 
( 0804,B124 )                 dl semis 

( 0804,B128 )   :N_<>   d$  2  0  0  0  "<>" 90 
( 0804,B12F )                 d$  90 

( 0804,B130 )   :X_<>   dl docol H_<> 0 X_> 
( 0804,B140 )                 dl N_<> 0 
( 0804,B148 )   :H_<>   dl X_- X_0= 
( 0804,B150 )                 dl X_0= semis 

( 0804,B158 )   :N_ROT   d$  3  0  0  0  "ROT" 90 

( 0804,B160 )   :X_ROT   dl H_ROT H_ROT 0 X_<> 
( 0804,B170 )                 dl N_ROT 0 

( 0804,B178 )   :H_ROT    POP|X, DX| 
( 0804,B179 )                  POP|X, BX| 
( 0804,B17A )                  POP|X, AX| 
( 0804,B17B )                  PUSH|X, BX| 
( 0804,B17C )                  PUSH|X, DX| 
( 0804,B17D )                  PUSH|X, AX| 
( 0804,B17E )                  LODS, X'| 
( 0804,B17F )                  JMPO, ZO| [AX] 
( 0804,B181 )                 d$  90  90  90 

( 0804,B184 )   :N_SPACE   d$  5  0  0  0  "SPACE" 90 
( 0804,B18E )                 d$  90  90 

( 0804,B190 )   :X_SPACE   dl docol H_SPACE 0 X_ROT 
( 0804,B1A0 )                 dl N_SPACE 0 
( 0804,B1A8 )   :H_SPACE   dl X_BL X_EMIT 
( 0804,B1B0 )                 dl semis 

( 0804,B1B4 )   :N_?DUP   d$  4  0  0  0  "?DUP"

( 0804,B1BC )   :X_?DUP   dl docol H_?DUP 0 X_SPACE 
( 0804,B1CC )                 dl N_?DUP 0 
( 0804,B1D4 )   :H_?DUP   dl X_DUP X_0BRANCH 
( 0804,B1DC )                 dl H_U0 X_DUP semis 

( 0804,B1E8 )   :N_LATEST   d$  6  0  0  0  "LATEST" 90 
( 0804,B1F3 )                 d$  90 

( 0804,B1F4 )   :X_LATEST   dl docol H_LATEST 0 X_?DUP 
( 0804,B204 )                 dl N_LATEST 0 
( 0804,B20C )   :H_LATEST   dl X_CURRENT X_@ 
( 0804,B214 )                 dl X_>LFA X_@ semis 

( 0804,B220 )   :N_>CFA   d$  4  0  0  0  ">CFA"

( 0804,B228 )   :X_>CFA   dl docol H_>CFA 0 X_LATEST 
( 0804,B238 )                 dl N_>CFA 0 
( 0804,B240 )   :H_>CFA   dl X_LIT 0 
( 0804,B248 )                 dl X_+ semis 

( 0804,B250 )   :N_>DFA   d$  4  0  0  0  ">DFA"

( 0804,B258 )   :X_>DFA   dl docol H_>DFA 0 X_>CFA 
( 0804,B268 )                 dl N_>DFA 0 
( 0804,B270 )   :H_>DFA   dl X_LIT H_U0 
( 0804,B278 )                 dl X_+ semis 

( 0804,B280 )   :N_>FFA   d$  4  0  0  0  ">FFA"

( 0804,B288 )   :X_>FFA   dl docol H_>FFA 0 X_>DFA 
( 0804,B298 )                 dl N_>FFA 0 
( 0804,B2A0 )   :H_>FFA   dl X_LIT H_#BUFF 
( 0804,B2A8 )                 dl X_+ semis 

( 0804,B2B0 )   :N_>LFA   d$  4  0  0  0  ">LFA"

( 0804,B2B8 )   :X_>LFA   dl docol H_>LFA 0 X_>FFA 
( 0804,B2C8 )                 dl N_>LFA 0 
( 0804,B2D0 )   :H_>LFA   dl X_LIT H_R0 
( 0804,B2D8 )                 dl X_+ semis 

( 0804,B2E0 )   :N_>NFA   d$  4  0  0  0  ">NFA"

( 0804,B2E8 )   :X_>NFA   dl docol H_>NFA 0 X_>LFA 
( 0804,B2F8 )                 dl N_>NFA 0 
( 0804,B300 )   :H_>NFA   dl X_LIT H_TIB 
( 0804,B308 )                 dl X_+ semis 

( 0804,B310 )   :N_>SFA   d$  4  0  0  0  ">SFA"

( 0804,B318 )   :X_>SFA   dl docol H_>SFA 0 X_>NFA 
( 0804,B328 )                 dl N_>SFA 0 
( 0804,B330 )   :H_>SFA   dl X_LIT H_RUBOUT 
( 0804,B338 )                 dl X_+ semis 

( 0804,B340 )   :N_>PHA   d$  4  0  0  0  ">PHA"

( 0804,B348 )   :X_>PHA   dl docol H_>PHA 0 X_>SFA 
( 0804,B358 )                 dl N_>PHA 0 
( 0804,B360 )   :H_>PHA   dl X_LIT 18 
( 0804,B368 )                 dl X_+ semis 

( 0804,B370 )   :N_>BODY   d$  5  0  0  0  ">BODY" 90 
( 0804,B37A )                 d$  90  90 

( 0804,B37C )   :X_>BODY   dl docol H_>BODY 0 X_>PHA 
( 0804,B38C )                 dl N_>BODY 0 
( 0804,B394 )   :H_>BODY   dl X_CFA> X_>DFA 
( 0804,B39C )                 dl X_@ X_CELL+ semis 

( 0804,B3A8 )   :N_BODY>   d$  5  0  0  0  "BODY>" 90 
( 0804,B3B2 )                 d$  90  90 

( 0804,B3B4 )   :X_BODY>   dl docol H_BODY> 0 X_>BODY 
( 0804,B3C4 )                 dl N_BODY> 0 
( 0804,B3CC )   :H_BODY>   dl X_LIT H_WARNING 
( 0804,B3D4 )                 dl X_- semis 

( 0804,B3DC )   :N_CFA>   d$  4  0  0  0  "CFA>"

( 0804,B3E4 )   :X_CFA>   dl docol H_CFA> 0 X_BODY> 
( 0804,B3F4 )                 dl N_CFA> 0 
( 0804,B3FC )   :H_CFA>   dl X_LIT 0 
( 0804,B404 )                 dl X_- semis 

( 0804,B40C )   :N_>WID   d$  4  0  0  0  ">WID"

( 0804,B414 )   :X_>WID   dl docol H_>WID 0 X_CFA> 
( 0804,B424 )                 dl N_>WID 0 
( 0804,B42C )   :H_>WID   dl X_>BODY X_CELL+ 
( 0804,B434 )                 dl semis 

( 0804,B438 )   :N_>VFA   d$  4  0  0  0  ">VFA"

( 0804,B440 )   :X_>VFA   dl docol H_>VFA 0 X_>WID 
( 0804,B450 )                 dl N_>VFA 0 
( 0804,B458 )   :H_>VFA   dl X_>BODY semis 

( 0804,B460 )   :N_!CSP   d$  4  0  0  0  "!CSP"

( 0804,B468 )   :X_!CSP   dl docol H_!CSP 0 X_>VFA 
( 0804,B478 )                 dl N_!CSP 0 
( 0804,B480 )   :H_!CSP   dl X_DSP@ X_CSP 
( 0804,B488 )                 dl X_! semis 

( 0804,B490 )   :N_?ERROR   d$  6  0  0  0  "?ERROR" 90 
( 0804,B49B )                 d$  90 

( 0804,B49C )   :X_?ERROR   dl docol H_?ERROR 0 X_!CSP 
( 0804,B4AC )                 dl N_?ERROR 0 
( 0804,B4B4 )   :H_?ERROR   dl X_SWAP X_0BRANCH 
( 0804,B4BC )                 dl H_DP X_IN X_@ X_SRC 
( 0804,B4CC )                 dl X_@ X_WHERE X_2! X_THROW 
( 0804,B4DC )                 dl X_BRANCH H_U0 X_DROP semis 

( 0804,B4EC )   :N_?ERRUR   d$  6  0  0  0  "?ERRUR" 90 
( 0804,B4F7 )                 d$  90 

( 0804,B4F8 )   :X_?ERRUR   dl docol H_?ERRUR 0 X_?ERROR 
( 0804,B508 )                 dl N_?ERRUR 0 
( 0804,B510 )   :H_?ERRUR   dl X_0 X_MIN 
( 0804,B518 )                 dl X_DUP X_?ERROR semis 

( 0804,B524 )   :N_?DELIM   d$  6  0  0  0  "?DELIM" 90 
( 0804,B52F )                 d$  90 

( 0804,B530 )   :X_?DELIM   dl docol H_?DELIM 0 X_?ERRUR 
( 0804,B540 )                 dl N_?DELIM 0 
( 0804,B548 )   :H_?DELIM   dl X_IN[] X_?BLANK 
( 0804,B550 )                 dl X_0= X_LIT 0A X_?ERROR 
( 0804,B560 )                 dl X_DROP semis 

( 0804,B568 )   :N_?CSP   d$  4  0  0  0  "?CSP"

( 0804,B570 )   :X_?CSP   dl docol H_?CSP 0 X_?DELIM 
( 0804,B580 )                 dl N_?CSP 0 
( 0804,B588 )   :H_?CSP   dl X_DSP@ X_CSP 
( 0804,B590 )                 dl X_@ X_- X_LIT H_RUBOUT 
( 0804,B5A0 )                 dl X_?ERROR semis 

( 0804,B5A8 )   :N_?COMP   d$  5  0  0  0  "?COMP" 90 
( 0804,B5B2 )                 d$  90  90 

( 0804,B5B4 )   :X_?COMP   dl docol H_?COMP 0 X_?CSP 
( 0804,B5C4 )                 dl N_?COMP 0 
( 0804,B5CC )   :H_?COMP   dl X_STATE X_@ 
( 0804,B5D4 )                 dl X_0= X_LIT 11 X_?ERROR 
( 0804,B5E4 )                 dl semis 

( 0804,B5E8 )   :N_?EXEC   d$  5  0  0  0  "?EXEC" 90 
( 0804,B5F2 )                 d$  90  90 

( 0804,B5F4 )   :X_?EXEC   dl docol H_?EXEC 0 X_?COMP 
( 0804,B604 )                 dl N_?EXEC 0 
( 0804,B60C )   :H_?EXEC   dl X_STATE X_@ 
( 0804,B614 )                 dl X_LIT 12 X_?ERROR semis 

( 0804,B624 )   :N_?PAIRS   d$  6  0  0  0  "?PAIRS" 90 
( 0804,B62F )                 d$  90 

( 0804,B630 )   :X_?PAIRS   dl docol H_?PAIRS 0 X_?EXEC 
( 0804,B640 )                 dl N_?PAIRS 0 
( 0804,B648 )   :H_?PAIRS   dl X_- X_LIT 
( 0804,B650 )                 dl 13 X_?ERROR semis 

( 0804,B65C )   :N_?LOADING   d$  8  0  0  0  "?LOADING"

( 0804,B668 )   :X_?LOADING   dl docol H_?LOADING 0 X_?PAIRS 
( 0804,B678 )                 dl N_?LOADING 0 
( 0804,B680 )   :H_?LOADING   dl X_BLK X_@ 
( 0804,B688 )                 dl X_0= X_LIT 16 X_?ERROR 
( 0804,B698 )                 dl semis 

( 0804,B69C )   :N_[   d$  1  0  0  0  &[ 90 
( 0804,B6A2 )                 d$  90  90 

( 0804,B6A4 )   :X_[   dl docol H_[ H_U0 X_?LOADING 
( 0804,B6B4 )                 dl N_[ 0 
( 0804,B6BC )   :H_[   dl X_0 X_STATE 
( 0804,B6C4 )                 dl X_! semis 

( 0804,B6CC )   :N_]   d$  1  0  0  0  &] 90 
( 0804,B6D2 )                 d$  90  90 

( 0804,B6D4 )   :X_]   dl docol H_] 0 X_[ 
( 0804,B6E4 )                 dl N_] 0 
( 0804,B6EC )   :H_]   dl X_1 X_STATE 
( 0804,B6F4 )                 dl X_! semis 

( 0804,B6FC )   :N_HIDDEN   d$  6  0  0  0  "HIDDEN" 90 
( 0804,B707 )                 d$  90 

( 0804,B708 )   :X_HIDDEN   dl docol H_HIDDEN 0 X_] 
( 0804,B718 )                 dl N_HIDDEN 0 
( 0804,B720 )   :H_HIDDEN   dl X_>FFA X_LIT 
( 0804,B728 )                 dl 2 X_TOGGLE semis 

( 0804,B734 )   :N_HEX   d$  3  0  0  0  "HEX" 90 

( 0804,B73C )   :X_HEX   dl docol H_HEX 0 X_HIDDEN 
( 0804,B74C )                 dl N_HEX 0 
( 0804,B754 )   :H_HEX   dl X_LIT H_TIB 
( 0804,B75C )                 dl X_BASE X_! semis 

( 0804,B768 )   :N_DECIMAL   d$  7  0  0  0  "DECIMAL" 90 

( 0804,B774 )   :X_DECIMAL   dl docol H_DECIMAL 0 X_HEX 
( 0804,B784 )                 dl N_DECIMAL 0 
( 0804,B78C )   :H_DECIMAL   dl X_LIT 0A 
( 0804,B794 )                 dl X_BASE X_! semis 

( 0804,B7A0 )   :N_(;CODE)   d$  7  0  0  0  "(;CODE)" 90 

( 0804,B7AC )   :semiscode :X_(;CODE)   dl docol H_(;CODE) 0 X_DECIMAL 
( 0804,B7BC )                 dl N_(;CODE) 0 
( 0804,B7C4 )   :H_(;CODE)   dl X_R> X_LATEST 
( 0804,B7CC )                 dl X_>CFA X_! semis 

( 0804,B7D8 )   :N_CREATE   d$  6  0  0  0  "CREATE" 90 
( 0804,B7E3 )                 d$  90 

( 0804,B7E4 )   :X_CREATE   dl docol H_CREATE 0 semiscode 
( 0804,B7F4 )                 dl N_CREATE 0 
( 0804,B7FC )   :H_CREATE   dl X_(WORD) X_(CREATE) 
( 0804,B804 )                 dl X_LIT (DODOES) X_, semiscode 

( 0804,B814 )   :dodoes    LEA, BP'| BO| [BP] 0FC B, 
( 0804,B817 )                  MOV, X| F| SI'| BO| [BP] 0 B, 
( 0804,B81A )                  MOV, X| T| SI'| BO| [AX] H_U0 B, 
( 0804,B81D )                  LEA, AX'| BO| [SI] H_U0 B, 
( 0804,B820 )                  MOV, X| T| SI'| ZO| [SI] 
( 0804,B822 )                  PUSH|X, AX| 
( 0804,B823 )                  LODS, X'| 
( 0804,B824 )                  JMPO, ZO| [AX] 
( 0804,B826 )   :(DODOES)   dl semis 

( 0804,B82A )                 d$  90  90 

( 0804,B82C )   :N_DOES>   d$  5  0  0  0  "DOES>" 90 
( 0804,B836 )                 d$  90  90 

( 0804,B838 )   :X_DOES>   dl docol H_DOES> 0 X_CREATE 
( 0804,B848 )                 dl N_DOES> 0 
( 0804,B850 )   :H_DOES>   dl X_R> X_LATEST 
( 0804,B858 )                 dl X_>DFA X_@ X_! semis 

( 0804,B868 )   :N_COUNT   d$  5  0  0  0  "COUNT" 90 
( 0804,B872 )                 d$  90  90 

( 0804,B874 )   :X_COUNT   dl docol H_COUNT 0 X_DOES> 
( 0804,B884 )                 dl N_COUNT 0 
( 0804,B88C )   :H_COUNT   dl X_DUP X_1+ 
( 0804,B894 )                 dl X_SWAP X_C@ semis 

( 0804,B8A0 )   :N_-TRAILING   d$  ^I 0  0  0  "-TRAILING" 90 
( 0804,B8AE )                 d$  90  90 

( 0804,B8B0 )   :X_-TRAILING   dl docol H_-TRAILING 0 X_COUNT 
( 0804,B8C0 )                 dl N_-TRAILING 0 
( 0804,B8C8 )   :H_-TRAILING   dl X_DUP X_0 
( 0804,B8D0 )                 dl X_(?DO) 3C X_OVER X_OVER 
( 0804,B8E0 )                 dl X_+ X_1 X_- X_C@ 
( 0804,B8F0 )                 dl X_?BLANK X_0= X_0BRANCH H_U0 
( 0804,B900 )                 dl X_LEAVE X_1 X_- X_(LOOP) 
( 0804,B910 )                 dl -3C semis 

( 0804,B918 )   :N_S"   d$  2  0  0  0  "S""" 90 
( 0804,B91F )                 d$  90 

( 0804,B920 )   :X_S"   dl docol H_S" H_U0 X_-TRAILING 
( 0804,B930 )                 dl N_S" 0 
( 0804,B938 )   :H_S"   dl X_" semis 

( 0804,B940 )   :N_."   d$  2  0  0  0  ".""" 90 
( 0804,B947 )                 d$  90 

( 0804,B948 )   :X_."   dl docol H_." H_U0 X_S" 
( 0804,B958 )                 dl N_." 0 
( 0804,B960 )   :H_."   dl X_" X_STATE 
( 0804,B968 )                 dl X_@ X_0BRANCH H_RUBOUT X_LIT 
( 0804,B978 )                 dl X_TYPE X_, X_BRANCH H_U0 
( 0804,B988 )                 dl X_TYPE semis 

( 0804,B990 )   :N_.(   d$  2  0  0  0  ".(" 90 
( 0804,B997 )                 d$  90 

( 0804,B998 )   :X_.(   dl docol H_.( H_U0 X_." 
( 0804,B9A8 )                 dl N_.( 0 
( 0804,B9B0 )   :H_.(   dl X_LIT 29 
( 0804,B9B8 )                 dl X_(PARSE) X_TYPE semis 

( 0804,B9C4 )   :N_SET-SRC   d$  7  0  0  0  "SET-SRC" 90 

( 0804,B9D0 )   :X_SET-SRC   dl docol H_SET-SRC 0 X_.( 
( 0804,B9E0 )                 dl N_SET-SRC 0 
( 0804,B9E8 )   :H_SET-SRC   dl X_OVER X_+ 
( 0804,B9F0 )                 dl X_SWAP X_SRC X_2! X_SRC 
( 0804,BA00 )                 dl X_@ X_IN X_! semis 

( 0804,BA10 )   :N_EVALUATE   d$  8  0  0  0  "EVALUATE"

( 0804,BA1C )   :X_EVALUATE   dl docol H_EVALUATE 0 X_SET-SRC 
( 0804,BA2C )                 dl N_EVALUATE 0 
( 0804,BA34 )   :H_EVALUATE   dl X_SAVE X_SET-SRC 
( 0804,BA3C )                 dl X_LIT X_INTERPRET X_CATCH X_RESTORE 
( 0804,BA4C )                 dl X_THROW semis 

( 0804,BA54 )   :N_FILL   d$  4  0  0  0  "FILL"

( 0804,BA5C )   :X_FILL   dl H_FILL H_FILL 0 X_EVALUATE 
( 0804,BA6C )                 dl N_FILL 0 

( 0804,BA74 )   :H_FILL    POP|X, AX| 
( 0804,BA75 )                  POP|X, CX| 
( 0804,BA76 )                  POP|X, DI| 
( 0804,BA77 )                  CLD, 
( 0804,BA78 )                  REPZ, 
( 0804,BA79 )                  STOS, B'| 
( 0804,BA7A )                  LODS, X'| 
( 0804,BA7B )                  JMPO, ZO| [AX] 
( 0804,BA7D )                 d$  90  90  90 

( 0804,BA80 )   :N_CORA   d$  4  0  0  0  "CORA"

( 0804,BA88 )   :X_CORA   dl H_CORA H_CORA 0 X_FILL 
( 0804,BA98 )                 dl N_CORA 0 

( 0804,BAA0 )   :H_CORA    MOV, X| F| SI'| R| DX| 
( 0804,BAA2 )                  XOR, X| F| AX'| R| AX| 
( 0804,BAA4 )                  POP|X, CX| 
( 0804,BAA5 )                  POP|X, DI| 
( 0804,BAA6 )                  POP|X, SI| 
( 0804,BAA7 )                  CLD, 
( 0804,BAA8 )                  REPZ, 
( 0804,BAA9 )                  CMPS, B'| 
( 0804,BAAA )                  J, Z| Y| L0804,BAB2 RB,
( 0804,BAAC )                  MOVI|B, AL| 1 IB, 
( 0804,BAAE )                  J, C| N| L0804,BAB2 RB,
( 0804,BAB0 )                  NEG, X| R| AX| 
( 0804,BAB2 )   :L0804,BAB2    MOV, X| F| DX'| R| SI| 
( 0804,BAB4 )                  PUSH|X, AX| 
( 0804,BAB5 )                  LODS, X'| 
( 0804,BAB6 )                  JMPO, ZO| [AX] 
( 0804,BAB8 )   :N_$I   d$  2  0  0  0  "$I" 90 
( 0804,BABF )                 d$  90 

( 0804,BAC0 )   :X_$I   dl H_$I H_$I 0 X_CORA 
( 0804,BAD0 )                 dl N_$I 0 

( 0804,BAD8 )   :H_$I    POP|X, AX| 
( 0804,BAD9 )                  POP|X, CX| 
( 0804,BADA )                  POP|X, DI| 
( 0804,BADB )                  OR, X| F| DI'| R| DI| 
( 0804,BADD )                  CLD, 
( 0804,BADE )                  REPNZ, 
( 0804,BADF )                  SCAS, B'| 
( 0804,BAE0 )                  J, Z| Y| L0804,BAE5 RB,
( 0804,BAE2 )                  XOR, X| F| DI'| R| DI| 
( 0804,BAE4 )                  INC|X, DI| 
( 0804,BAE5 )   :L0804,BAE5    DEC|X, DI| 
( 0804,BAE6 )                  PUSH|X, DI| 
( 0804,BAE7 )                  LODS, X'| 
( 0804,BAE8 )                  JMPO, ZO| [AX] 
( 0804,BAEA )                 d$  90  90 

( 0804,BAEC )   :N_$S   d$  2  0  0  0  "$S" 90 
( 0804,BAF3 )                 d$  90 

( 0804,BAF4 )   :X_$S   dl H_$S H_$S 0 X_$I 
( 0804,BB04 )                 dl N_$S 0 

( 0804,BB0C )   :H_$S    POP|X, AX| 
( 0804,BB0D )                  POP|X, CX| 
( 0804,BB0E )                  MOV, X| F| CX'| R| BX| 
( 0804,BB10 )                  POP|X, DI| 
( 0804,BB11 )                  OR, X| F| DI'| R| DI| 
( 0804,BB13 )                  MOV, X| F| DI'| R| DX| 
( 0804,BB15 )                  CLD, 
( 0804,BB16 )                  REPNZ, 
( 0804,BB17 )                  SCAS, B'| 
( 0804,BB18 )                  J, Z| Y| L0804,BB20 RB,
( 0804,BB1A )                  PUSH|X, CX| 
( 0804,BB1B )                  JMP, L0804,BB24 RL,
( 0804,BB20 )   :L0804,BB20    PUSH|X, DI| 
( 0804,BB21 )                  SUB, X| F| CX'| R| BX| 
( 0804,BB23 )                  DEC|X, BX| 
( 0804,BB24 )   :L0804,BB24    PUSH|X, CX| 
( 0804,BB25 )                  PUSH|X, DX| 
( 0804,BB26 )                  PUSH|X, BX| 
( 0804,BB27 )                  LODS, X'| 
( 0804,BB28 )                  JMPO, ZO| [AX] 
( 0804,BB2A )                 d$  90  90 

( 0804,BB2C )   :N_ERASE   d$  5  0  0  0  "ERASE" 90 
( 0804,BB36 )                 d$  90  90 

( 0804,BB38 )   :X_ERASE   dl docol H_ERASE 0 X_$S 
( 0804,BB48 )                 dl N_ERASE 0 
( 0804,BB50 )   :H_ERASE   dl X_0 X_FILL 
( 0804,BB58 )                 dl semis 

( 0804,BB5C )   :N_BLANK   d$  5  0  0  0  "BLANK" 90 
( 0804,BB66 )                 d$  90  90 

( 0804,BB68 )   :X_BLANK   dl docol H_BLANK 0 X_ERASE 
( 0804,BB78 )                 dl N_BLANK 0 
( 0804,BB80 )   :H_BLANK   dl X_BL X_FILL 
( 0804,BB88 )                 dl semis 

( 0804,BB8C )   :N_HOLD   d$  4  0  0  0  "HOLD"

( 0804,BB94 )   :X_HOLD   dl docol H_HOLD 0 X_BLANK 
( 0804,BBA4 )                 dl N_HOLD 0 
( 0804,BBAC )   :H_HOLD   dl X_LIT -1 
( 0804,BBB4 )                 dl X_HLD X_+! X_HLD X_@ 
( 0804,BBC4 )                 dl X_C! semis 

( 0804,BBCC )   :N_PAD   d$  3  0  0  0  "PAD" 90 

( 0804,BBD4 )   :X_PAD   dl docol H_PAD 0 X_HOLD 
( 0804,BBE4 )                 dl N_PAD 0 
( 0804,BBEC )   :H_PAD   dl X_HERE X_LIT 
( 0804,BBF4 )                 dl 0114 X_+ semis 

( 0804,BC00 )   :N_WORD   d$  4  0  0  0  "WORD"

( 0804,BC08 )   :X_WORD   dl docol H_WORD 0 X_PAD 
( 0804,BC18 )                 dl N_WORD 0 
( 0804,BC20 )   :H_WORD   dl X_DUP X_BL 
( 0804,BC28 )                 dl X_= X_0BRANCH H_TIB X_DROP 
( 0804,BC38 )                 dl X_(WORD) X_BRANCH H_C/L X_>R 
( 0804,BC48 )                 dl X_IN[] X_R@ X_= X_0BRANCH 
( 0804,BC58 )                 dl H_R0 X_DROP X_BRANCH -20 
( 0804,BC68 )                 dl X_DROP X_LIT -1 X_IN 
( 0804,BC78 )                 dl X_+! X_R> X_(PARSE) X_HERE 
( 0804,BC88 )                 dl X_LIT 22 X_BLANK X_HERE 
( 0804,BC98 )                 dl X_$!-BD X_HERE semis 

( 0804,BCA4 )   :N_CHAR   d$  4  0  0  0  "CHAR"

( 0804,BCAC )   :X_CHAR   dl docol H_CHAR 0 X_WORD 
( 0804,BCBC )                 dl N_CHAR 0 
( 0804,BCC4 )   :H_CHAR   dl X_(WORD) X_DROP 
( 0804,BCCC )                 dl X_C@ semis 

( 0804,BCD4 )   :N_[CHAR]   d$  6  0  0  0  "[CHAR]" 90 
( 0804,BCDF )                 d$  90 

( 0804,BCE0 )   :X_[CHAR]   dl docol H_[CHAR] H_U0 X_CHAR 
( 0804,BCF0 )                 dl N_[CHAR] 0 
( 0804,BCF8 )   :H_[CHAR]   dl X_CHAR X_LITERAL 
( 0804,BD00 )                 dl semis 

( 0804,BD04 )   :N_(NUMBER)   d$  8  0  0  0  "(NUMBER)"

( 0804,BD10 )   :X_(NUMBER)   dl docol H_(NUMBER) 0 X_[CHAR] 
( 0804,BD20 )                 dl N_(NUMBER) 0 
( 0804,BD28 )   :H_(NUMBER)   dl X_0 X_0 
( 0804,BD30 )                 dl X_0 X_DPL X_! X_IN[] 
( 0804,BD40 )                 dl X_DUP X_LIT 2E X_= 
( 0804,BD50 )                 dl X_0BRANCH 18 X_DROP X_DPL 
( 0804,BD60 )                 dl X_! X_0 X_BRANCH 9C 
( 0804,BD70 )                 dl X_DUP X_LIT H_OFFSET X_= 
( 0804,BD80 )                 dl X_0BRANCH H_TIB X_2DROP X_0 
( 0804,BD90 )                 dl X_BRANCH H_IN X_DUP X_?BLANK 
( 0804,BDA0 )                 dl X_0BRANCH H_RUBOUT X_DROP X_DROP 
( 0804,BDB0 )                 dl X_1 X_BRANCH H_DPL X_SWAP 
( 0804,BDC0 )                 dl X_DROP X_BASE X_@ X_DIGIT 
( 0804,BDD0 )                 dl X_0= X_LIT 0A X_?ERROR 
( 0804,BDE0 )                 dl X_SWAP X_BASE X_@ X_UM* 
( 0804,BDF0 )                 dl X_DROP X_ROT X_BASE X_@ 
( 0804,BE00 )                 dl X_UM* X_D+ X_0 X_0BRANCH 
( 0804,BE10 )                 dl -D8 semis 

( 0804,BE18 )   :N_NUMBER   d$  6  0  0  0  "NUMBER" 90 
( 0804,BE23 )                 d$  90 

( 0804,BE24 )   :X_NUMBER   dl docol donumber 0 X_(NUMBER) 
( 0804,BE34 )                 dl N_NUMBER 0 
( 0804,BE3C )   :donumber   dl X_LIT -1 
( 0804,BE44 )                 dl X_IN X_+! X_(NUMBER) X_SDLITERAL 
( 0804,BE54 )                 dl semis 

( 0804,BE58 )   :N_>NUMBER   d$  7  0  0  0  ">NUMBER" 90 

( 0804,BE64 )   :X_>NUMBER   dl docol H_>NUMBER 0 X_NUMBER 
( 0804,BE74 )                 dl N_>NUMBER 0 
( 0804,BE7C )   :H_>NUMBER   dl X_2DUP X_+ 
( 0804,BE84 )                 dl X_>R X_0 X_(?DO) H_(BLK) 
( 0804,BE94 )                 dl X_DUP X_C@ X_BASE X_@ 
( 0804,BEA4 )                 dl X_DIGIT X_0= X_0BRANCH H_#BUFF 
( 0804,BEB4 )                 dl X_DROP X_LEAVE X_SWAP X_>R 
( 0804,BEC4 )                 dl X_SWAP X_BASE X_@ X_UM* 
( 0804,BED4 )                 dl X_DROP X_ROT X_BASE X_@ 
( 0804,BEE4 )                 dl X_UM* X_D+ X_R> X_1+ 
( 0804,BEF4 )                 dl X_(LOOP) -68 X_R> X_OVER 
( 0804,BF04 )                 dl X_- semis 

( 0804,BF0C )   :N_FOUND   d$  5  0  0  0  "FOUND" 90 
( 0804,BF16 )                 d$  90  90 

( 0804,BF18 )   :X_FOUND   dl docol H_FOUND 0 X_>NUMBER 
( 0804,BF28 )                 dl N_FOUND 0 
( 0804,BF30 )   :H_FOUND   dl X_CONTEXT X_>R 
( 0804,BF38 )                 dl X_R@ X_@ X_(FIND) X_DUP 
( 0804,BF48 )                 dl X_0= X_0BRANCH H_REMAINDER X_DROP 
( 0804,BF58 )                 dl X_R@ X_@ X_LIT X_FORTH 
( 0804,BF68 )                 dl X_- X_0BRANCH H_RUBOUT X_R> 
( 0804,BF78 )                 dl X_CELL+ X_>R X_BRANCH -50 
( 0804,BF88 )                 dl X_0 X_RDROP X_SWAP X_DROP 
( 0804,BF98 )                 dl X_SWAP X_DROP semis 

( 0804,BFA4 )   :N_PRESENT   d$  7  0  0  0  "PRESENT" 90 

( 0804,BFB0 )   :X_PRESENT   dl docol H_PRESENT 0 X_FOUND 
( 0804,BFC0 )                 dl N_PRESENT 0 
( 0804,BFC8 )   :H_PRESENT   dl X_DUP X_>R 
( 0804,BFD0 )                 dl X_FOUND X_DUP X_0BRANCH H_WARNING 
( 0804,BFE0 )                 dl X_DUP X_>NFA X_@ X_@ 
( 0804,BFF0 )                 dl X_R@ X_= X_AND X_RDROP 
( 0804,C000 )                 dl semis 

( 0804,C004 )   :N_FIND   d$  4  0  0  0  "FIND"

( 0804,C00C )   :X_FIND   dl docol H_FIND 0 X_PRESENT 
( 0804,C01C )                 dl N_FIND 0 
( 0804,C024 )   :H_FIND   dl X_DUP X_COUNT 
( 0804,C02C )                 dl X_PRESENT X_DUP X_0BRANCH H_C/L 
( 0804,C03C )                 dl X_SWAP X_DROP X_DUP X_>CFA 
( 0804,C04C )                 dl X_SWAP X_>FFA X_@ X_LIT 
( 0804,C05C )                 dl H_U0 X_AND X_LIT -1 
( 0804,C06C )                 dl X_SWAP X_0BRANCH H_U0 X_NEGATE 
( 0804,C07C )                 dl semis 

( 0804,C080 )   :N_(FIND)   d$  6  0  0  0  "(FIND)" 90 
( 0804,C08B )                 d$  90 

( 0804,C08C )   :X_(FIND)   dl docol H_(FIND) 0 X_FIND 
( 0804,C09C )                 dl N_(FIND) 0 
( 0804,C0A4 )   :H_(FIND)   dl X_DUP X_0BRANCH 
( 0804,C0AC )                 dl H_FENCE X_(MATCH) X_0= X_0BRANCH 
( 0804,C0BC )                 dl H_TIB X_>LFA X_@ X_BRANCH 
( 0804,C0CC )                 dl -2C semis 

( 0804,C0D4 )   :N_ERROR   d$  5  0  0  0  "ERROR" 90 
( 0804,C0DE )                 d$  90  90 

( 0804,C0E0 )   :X_ERROR   dl docol H_ERROR 0 X_(FIND) 
( 0804,C0F0 )                 dl N_ERROR 0 
( 0804,C0F8 )   :H_ERROR   dl X_WHERE X_2@ 
( 0804,C100 )                 dl X_OVER X_LIT H_RUBOUT X_- 
( 0804,C110 )                 dl X_MAX X_SWAP X_OVER X_- 
( 0804,C120 )                 dl X_ETYPE X_SKIP 12 
( 0804,C12C )   :NAME4   dl 6963,203F 
( 0804,C130 )                 dl 7472,6F66 5245,2068 2052,4F52 9090,2023 
( 0804,C140 )                 dl X_LIT NAME4 X_LIT 12 
( 0804,C150 )                 dl X_ETYPE X_BASE X_@ X_DECIMAL 
( 0804,C160 )                 dl X_OVER X_S>D X_0 X_(D.R) 
( 0804,C170 )                 dl X_ETYPE X_BASE X_! X_MESSAGE 
( 0804,C180 )                 dl semis 

( 0804,C184 )   :N_CATCH   d$  5  0  0  0  "CATCH" 90 
( 0804,C18E )                 d$  90  90 

( 0804,C190 )   :X_CATCH   dl docol H_CATCH 0 X_ERROR 
( 0804,C1A0 )                 dl N_CATCH 0 
( 0804,C1A8 )   :H_CATCH   dl X_DSP@ X_CELL+ 
( 0804,C1B0 )                 dl X_>R X_HANDLER X_@ X_>R 
( 0804,C1C0 )                 dl X_RSP@ X_HANDLER X_! X_EXECUTE 
( 0804,C1D0 )                 dl X_R> X_HANDLER X_! X_RDROP 
( 0804,C1E0 )                 dl X_0 semis 

( 0804,C1E8 )   :N_THROW   d$  5  0  0  0  "THROW" 90 
( 0804,C1F2 )                 d$  90  90 

( 0804,C1F4 )   :X_THROW   dl docol H_THROW 0 X_CATCH 
( 0804,C204 )                 dl N_THROW 0 
( 0804,C20C )   :H_THROW   dl X_DUP X_0BRANCH 
( 0804,C214 )                 dl H_R# X_HANDLER X_@ X_0= 
( 0804,C224 )                 dl X_0BRANCH 18 X_ERROR X_EMPTY-BUFFERS 
( 0804,C234 )                 dl X_S0 X_@ X_DSP! X_QUIT 
( 0804,C244 )                 dl X_HANDLER X_@ X_RSP! X_R> 
( 0804,C254 )                 dl X_HANDLER X_! X_R> X_SWAP 
( 0804,C264 )                 dl X_>R X_DSP! X_R> X__ 
( 0804,C274 )                 dl X_DROP semis 

( 0804,C27C )   :N_(ABORT")   d$  8  0  0  0  "(ABORT"")"

( 0804,C288 )   :X_(ABORT")   dl docol H_(ABORT") 0 X_THROW 
( 0804,C298 )                 dl N_(ABORT") 0 
( 0804,C2A0 )   :H_(ABORT")   dl X_ROT X_0BRANCH 
( 0804,C2A8 )                 dl H_RUBOUT X_ETYPE X_.SIGNON X_ABORT 
( 0804,C2B8 )                 dl X_BRANCH H_U0 X_2DROP semis 

( 0804,C2C8 )   :N_ABORT"   d$  6  0  0  0  "ABORT""" 90 
( 0804,C2D3 )                 d$  90 

( 0804,C2D4 )   :X_ABORT"   dl docol H_ABORT" H_U0 X_(ABORT") 
( 0804,C2E4 )                 dl N_ABORT" 0 
( 0804,C2EC )   :H_ABORT"   dl X_?COMP X_" 
( 0804,C2F4 )                 dl X_LIT X_(ABORT") X_, semis 

( 0804,C304 )   :N_ID.   d$  3  0  0  0  "ID." 90 

( 0804,C30C )   :X_ID.   dl docol H_ID. 0 X_ABORT" 
( 0804,C31C )                 dl N_ID. 0 
( 0804,C324 )   :H_ID.   dl X_DUP X_>FFA 
( 0804,C32C )                 dl X_@ X_LIT 1 X_XOR 
( 0804,C33C )                 dl X_0BRANCH H_DP X_>NFA X_@ 
( 0804,C34C )                 dl X_$@ X_TYPE X_SPACE X_SPACE 
( 0804,C35C )                 dl X_SPACE X_BRANCH H_U0 X_DROP 
( 0804,C36C )                 dl semis 

( 0804,C370 )   :N_(CREATE)   d$  8  0  0  0  "(CREATE)"

( 0804,C37C )   :X_(CREATE)   dl docol H_(CREATE) 0 X_ID. 
( 0804,C38C )                 dl N_(CREATE) 0 
( 0804,C394 )   :H_(CREATE)   dl X_DUP X_0= 
( 0804,C39C )                 dl X_LIT 5 X_?ERROR X_2DUP 
( 0804,C3AC )                 dl X_PRESENT X_DUP X_0BRANCH H_FENCE 
( 0804,C3BC )                 dl X_>NFA X_@ X_$@ X_ETYPE 
( 0804,C3CC )                 dl X_LIT H_U0 X_MESSAGE X__ 
( 0804,C3DC )                 dl X_DROP X_ALIGN X_$, X_ALIGN 
( 0804,C3EC )                 dl X_HERE X_>R X_R@ X_>PHA 
( 0804,C3FC )                 dl X_, X_R@ X_>PHA X_, 
( 0804,C40C )                 dl X_0 X_, X_CURRENT X_@ 
( 0804,C41C )                 dl X_>LFA X_DUP X_@ X_, 
( 0804,C42C )                 dl X_R@ X_SWAP X_! X_, 
( 0804,C43C )                 dl X_BLK X_@ X_DUP X_0= 
( 0804,C44C )                 dl X_0BRANCH H_R0 X_DROP X_IN 
( 0804,C45C )                 dl X_@ X_, X_RDROP semis 

( 0804,C46C )   :N_[COMPILE]   d$  ^I 0  0  0  "[COMPILE]" 90 
( 0804,C47A )                 d$  90  90 

( 0804,C47C )   :X_[COMPILE]   dl docol H_[COMPILE] H_U0 X_(CREATE) 
( 0804,C48C )                 dl N_[COMPILE] 0 
( 0804,C494 )   :H_[COMPILE]   dl X_(WORD) X_PRESENT 
( 0804,C49C )                 dl X_DUP X_0= X_LIT H_TIB 
( 0804,C4AC )                 dl X_?ERROR X_>CFA X_, semis 

( 0804,C4BC )   :N_POSTPONE   d$  8  0  0  0  "POSTPONE"

( 0804,C4C8 )   :X_POSTPONE   dl docol H_POSTPONE H_U0 X_[COMPILE] 
( 0804,C4D8 )                 dl N_POSTPONE 0 
( 0804,C4E0 )   :H_POSTPONE   dl X_(WORD) X_PRESENT 
( 0804,C4E8 )                 dl X_DUP X_0= X_LIT 0F 
( 0804,C4F8 )                 dl X_?ERROR X_DUP X_>FFA X_@ 
( 0804,C508 )                 dl X_LIT H_U0 X_AND X_0= 
( 0804,C518 )                 dl X_0BRANCH H_DP X_LIT X_LIT 
( 0804,C528 )                 dl X_, X_, X_LIT X_, 
( 0804,C538 )                 dl X_, X_BRANCH H_U0 X_, 
( 0804,C548 )                 dl semis 

( 0804,C54C )   :N_LITERAL   d$  7  0  0  0  "LITERAL" 90 

( 0804,C558 )   :X_LITERAL   dl docol H_LITERAL H_U0 X_POSTPONE 
( 0804,C568 )                 dl N_LITERAL 0 
( 0804,C570 )   :H_LITERAL   dl X_STATE X_@ 
( 0804,C578 )                 dl X_0BRANCH H_TIB X_LIT X_LIT 
( 0804,C588 )                 dl X_, X_, semis 

( 0804,C594 )   :N_DLITERAL   d$  8  0  0  0  "DLITERAL"

( 0804,C5A0 )   :X_DLITERAL   dl docol H_DLITERAL H_U0 X_LITERAL 
( 0804,C5B0 )                 dl N_DLITERAL 0 
( 0804,C5B8 )   :H_DLITERAL   dl X_STATE X_@ 
( 0804,C5C0 )                 dl X_0BRANCH H_R0 X_SWAP X_LITERAL 
( 0804,C5D0 )                 dl X_LITERAL semis 

( 0804,C5D8 )   :N_SDLITERAL   d$  ^I 0  0  0  "SDLITERAL" 90 
( 0804,C5E6 )                 d$  90  90 

( 0804,C5E8 )   :X_SDLITERAL   dl docol H_SDLITERAL H_U0 X_DLITERAL 
( 0804,C5F8 )                 dl N_SDLITERAL 0 
( 0804,C600 )   :H_SDLITERAL   dl X_DPL X_@ 
( 0804,C608 )                 dl X_0BRANCH H_R0 X_DLITERAL X_BRANCH 
( 0804,C618 )                 dl H_#BUFF X_DROP X_LITERAL semis 

( 0804,C628 )   :N_?STACK   d$  6  0  0  0  "?STACK" 90 
( 0804,C633 )                 d$  90 

( 0804,C634 )   :X_?STACK   dl docol H_?STACK 0 X_SDLITERAL 
( 0804,C644 )                 dl N_?STACK 0 
( 0804,C64C )   :H_?STACK   dl X_DSP@ X_S0 
( 0804,C654 )                 dl X_@ X_SWAP X_U< X_1 
( 0804,C664 )                 dl X_?ERROR X_DSP@ X_HERE X_LIT 
( 0804,C674 )                 dl H_HANDLER X_+ X_U< X_LIT 
( 0804,C684 )                 dl 7 X_?ERROR semis 

( 0804,C690 )   :N_INTERPRET   d$  ^I 0  0  0  "INTERPRET" 90 
( 0804,C69E )                 d$  90  90 

( 0804,C6A0 )   :X_INTERPRET   dl docol H_INTERPRET 0 X_?STACK 
( 0804,C6B0 )                 dl N_INTERPRET 0 
( 0804,C6B8 )   :H_INTERPRET   dl X_(WORD) X_DUP 
( 0804,C6C0 )                 dl X_0BRANCH 0A8 X_OVER X_>R 
( 0804,C6D0 )                 dl X_FOUND X_DUP X_0= X_LIT 
( 0804,C6E0 )                 dl H_R0 X_?ERROR X_DUP X_>FFA 
( 0804,C6F0 )                 dl X_@ X_DUP X_LIT H_#BUFF 
( 0804,C700 )                 dl X_AND X_0BRANCH H_FENCE X_OVER 
( 0804,C710 )                 dl X_>NFA X_@ X_@ X_R@ 
( 0804,C720 )                 dl X_+ X_IN X_! X_RDROP 
( 0804,C730 )                 dl X_LIT H_U0 X_AND X_STATE 
( 0804,C740 )                 dl X_@ X_0= X_OR X_0BRANCH 
( 0804,C750 )                 dl H_R0 X_EXECUTE X_BRANCH H_U0 
( 0804,C760 )                 dl X_, X_?STACK X_BRANCH -B8 
( 0804,C770 )                 dl X_DROP X_DROP semis 

( 0804,C77C )   :N_IMMEDIATE   d$  ^I 0  0  0  "IMMEDIATE" 90 
( 0804,C78A )                 d$  90  90 

( 0804,C78C )   :X_IMMEDIATE   dl docol H_IMMEDIATE 0 X_INTERPRET 
( 0804,C79C )                 dl N_IMMEDIATE 0 
( 0804,C7A4 )   :H_IMMEDIATE   dl X_LATEST X_>FFA 
( 0804,C7AC )                 dl X_LIT H_U0 X_TOGGLE semis 

( 0804,C7BC )   :N_VOCABULARY   d$  ^J 0  0  0  "VOCABULARY" 90 
( 0804,C7CB )                 d$  90 

( 0804,C7CC )   :X_VOCABULARY   dl docol H_VOCABULARY 0 X_IMMEDIATE 
( 0804,C7DC )                 dl N_VOCABULARY 0 
( 0804,C7E4 )   :H_VOCABULARY   dl X_CREATE X_LATEST 
( 0804,C7EC )                 dl X_VOC-LINK X_@ X_, X_VOC-LINK 
( 0804,C7FC )                 dl X_! X_0 X_, X_0 
( 0804,C80C )                 dl X_, X_LIT 1 X_, 
( 0804,C81C )                 dl X_0 X_, X_DOES> 
( 0804,C828 )   :DOVOC   dl X_ALSO 
( 0804,C82C )                 dl X_CELL+ X_CONTEXT X_! semis 

( 0804,C83C )   :N_DEFINITIONS   d$  0B  0  0  0  "DEFINITIONS" 90 

( 0804,C84C )   :X_DEFINITIONS   dl docol H_DEFINITIONS 0 X_VOCABULARY 
( 0804,C85C )                 dl N_DEFINITIONS 0 
( 0804,C864 )   :H_DEFINITIONS   dl X_CONTEXT X_@ 
( 0804,C86C )                 dl X_CURRENT X_! semis 

( 0804,C878 )   :N_ALSO   d$  4  0  0  0  "ALSO"

( 0804,C880 )   :X_ALSO   dl docol H_ALSO 0 X_DEFINITIONS 
( 0804,C890 )                 dl N_ALSO 0 
( 0804,C898 )   :H_ALSO   dl X_CONTEXT X_DUP 
( 0804,C8A0 )                 dl X_CELL+ X_LIT H_WARNING X_MOVE 
( 0804,C8B0 )                 dl X_LIT X_FORTH X_CONTEXT X_LIT 
( 0804,C8C0 )                 dl H_FENCE X_+ X_! semis 

( 0804,C8D0 )   :N_PREVIOUS   d$  8  0  0  0  "PREVIOUS"

( 0804,C8DC )   :X_PREVIOUS   dl docol H_PREVIOUS 0 X_ALSO 
( 0804,C8EC )                 dl N_PREVIOUS 0 
( 0804,C8F4 )   :H_PREVIOUS   dl X_CONTEXT X_DUP 
( 0804,C8FC )                 dl X_CELL+ X_SWAP X_LIT H_FENCE 
( 0804,C90C )                 dl X_MOVE semis 

( 0804,C914 )   :N_ONLY   d$  4  0  0  0  "ONLY"

( 0804,C91C )   :X_ONLY   dl docol H_ONLY 0 X_PREVIOUS 
( 0804,C92C )                 dl N_ONLY 0 
( 0804,C934 )   :H_ONLY   dl X_LIT X_FORTH 
( 0804,C93C )                 dl X_CONTEXT X_! X_CONTEXT X_DUP 
( 0804,C94C )                 dl X_CELL+ X_LIT H_WARNING X_CMOVE 
( 0804,C95C )                 dl semis 

( 0804,C960 )   :N_(   d$  1  0  0  0  &( 90 
( 0804,C966 )                 d$  90  90 

( 0804,C968 )   :X_(   dl docol H_( H_U0 X_ONLY 
( 0804,C978 )                 dl N_( 0 
( 0804,C980 )   :H_(   dl X_LIT 29 
( 0804,C988 )                 dl X_(PARSE) X_2DROP semis 

( 0804,C994 )   :N_\   d$  1  0  0  0  &\ 90 
( 0804,C99A )                 d$  90  90 

( 0804,C99C )   :X_\   dl docol H_\ H_U0 X_( 
( 0804,C9AC )                 dl N_\ 0 
( 0804,C9B4 )   :H_\   dl X_LIT -1 
( 0804,C9BC )                 dl X_IN X_+! X_LIT 0A 
( 0804,C9CC )                 dl X_(PARSE) X_2DROP semis 

( 0804,C9D8 )   :N_QUIT   d$  4  0  0  0  "QUIT"

( 0804,C9E0 )   :X_QUIT   dl docol H_QUIT 0 X_\ 
( 0804,C9F0 )                 dl N_QUIT 0 
( 0804,C9F8 )   :H_QUIT   dl X_[ X_R0 
( 0804,CA00 )                 dl X_@ X_RSP! X_LIT X_(ACCEPT) 
( 0804,CA10 )                 dl X_CATCH X_0BRANCH H_U0 X_BYE 
( 0804,CA20 )                 dl X_SET-SRC X_INTERPRET X_OK X_BRANCH 
( 0804,CA30 )                 dl -38 semis 

( 0804,CA38 )   :N_OK   d$  2  0  0  0  "OK" 90 
( 0804,CA3F )                 d$  90 

( 0804,CA40 )   :X_OK   dl docol H_OK 0 X_QUIT 
( 0804,CA50 )                 dl N_OK 0 
( 0804,CA58 )   :H_OK   dl X_STATE X_@ 
( 0804,CA60 )                 dl X_0= X_0BRANCH H_DP X_SKIP 
( 0804,CA70 )                 dl 3 
( 0804,CA74 )   :NAME5   dl 904B,4F20 X_LIT NAME5 
( 0804,CA80 )                 dl X_LIT 3 X_TYPE X_CR 
( 0804,CA90 )                 dl semis 

( 0804,CA94 )   :N_ABORT   d$  5  0  0  0  "ABORT" 90 
( 0804,CA9E )                 d$  90  90 

( 0804,CAA0 )   :X_ABORT   dl docol H_ABORT 0 X_OK 
( 0804,CAB0 )                 dl N_ABORT 0 
( 0804,CAB8 )   :H_ABORT   dl X_S0 X_@ 
( 0804,CAC0 )                 dl X_DSP! X_0 X_HANDLER X_! 
( 0804,CAD0 )                 dl X_DECIMAL X_ONLY X_FORTH X_DEFINITIONS 
( 0804,CAE0 )                 dl X_QUIT semis 

( 0804,CAE8 )                  MOVI|X, SI| LWARM IL, 
( 0804,CAED )                  LODS, X'| 
( 0804,CAEE )                  JMPO, ZO| [AX] 
( 0804,CAF0 )   :LWARM   dl X_WARM 

( 0804,CAF4 )   :N_WARM   d$  4  0  0  0  "WARM"

( 0804,CAFC )   :X_WARM   dl docol H_WARM 0 X_ABORT 
( 0804,CB0C )                 dl N_WARM 0 
( 0804,CB14 )   :H_WARM   dl X_EMPTY-BUFFERS X_.SIGNON 
( 0804,CB1C )                 dl X_ABORT semis 

( 0804,CB24 )   :N_OPTIONS   d$  7  0  0  0  "OPTIONS" 90 

( 0804,CB30 )   :X_OPTIONS   dl docol H_OPTIONS 0 X_WARM 
( 0804,CB40 )                 dl N_OPTIONS 0 
( 0804,CB48 )   :H_OPTIONS   dl X_ARGS X_@ 
( 0804,CB50 )                 dl X_CELL+ X_CELL+ X_@ X_DUP 
( 0804,CB60 )                 dl X_0BRANCH H_(BLK) X_@ X_DUP 
( 0804,CB70 )                 dl X_LIT 0FF X_AND X_LIT 
( 0804,CB80 )                 dl 2D X_<> X_0BRANCH H_WARNING 
( 0804,CB90 )                 dl X_LIT 3 X_DUP X_ERROR 
( 0804,CBA0 )                 dl X_EXIT-CODE X_! X_BYE X_LIT 
( 0804,CBB0 )                 dl H_#BUFF X_RSHIFT X_LIT 1F 
( 0804,CBC0 )                 dl X_AND X_LOAD X_0 X_SWAP 
( 0804,CBD0 )                 dl X_DROP semis 

( 0804,CBD8 )   :N_COLD   d$  4  0  0  0  "COLD"

( 0804,CBE0 )   :X_COLD   dl docol H_COLD 0 X_OPTIONS 
( 0804,CBF0 )                 dl N_COLD 0 
( 0804,CBF8 )   :H_COLD   dl X_0 X_HANDLER 
( 0804,CC00 )                 dl X_! X_EMPTY-BUFFERS X_FIRST X_STALEST 
( 0804,CC10 )                 dl X_! X_FIRST X_PREV X_! 
( 0804,CC20 )                 dl X_LIT init_user X_LIT U0_INIT 
( 0804,CC30 )                 dl X_@ X_LIT 0100 X_CMOVE 
( 0804,CC40 )                 dl X_LIT 0 X_BLOCK-INIT X_DECIMAL 
( 0804,CC50 )                 dl X_ONLY X_FORTH X_DEFINITIONS X_1 
( 0804,CC60 )                 dl X_0 X_LIT 5401 X_TERMIO 
( 0804,CC70 )                 dl X_LIT 36 X_LINOS X_0< 
( 0804,CC80 )                 dl X_0BRANCH H_DP X_DROP X_0 
( 0804,CC90 )                 dl X_LIT X_NOOP X_LIT X_OK 
( 0804,CCA0 )                 dl X_LIT H_R0 X_CMOVE X_OPTIONS 
( 0804,CCB0 )                 dl X_0BRANCH H_U0 X_.SIGNON X_ABORT 
( 0804,CCC0 )                 dl X_BYE semis 

( 0804,CCC8 )   :N_S>D   d$  3  0  0  0  "S>D" 90 

( 0804,CCD0 )   :X_S>D   dl H_S>D H_S>D 0 X_COLD 
( 0804,CCE0 )                 dl N_S>D 0 

( 0804,CCE8 )   :H_S>D    POP|X, DX| 
( 0804,CCE9 )                  SUB, X| F| AX'| R| AX| 
( 0804,CCEB )                  OR, X| F| DX'| R| DX| 
( 0804,CCED )                  J, S| N| L0804,CCF0 RB,
( 0804,CCEF )                  DEC|X, AX| 
( 0804,CCF0 )   :L0804,CCF0    PUSH|X, DX| 
( 0804,CCF1 )                  PUSH|X, AX| 
( 0804,CCF2 )                  LODS, X'| 
( 0804,CCF3 )                  JMPO, ZO| [AX] 
( 0804,CCF5 )                 d$  90  90  90 

( 0804,CCF8 )   :N_ABS   d$  3  0  0  0  "ABS" 90 

( 0804,CD00 )   :X_ABS   dl docol H_ABS 0 X_S>D 
( 0804,CD10 )                 dl N_ABS 0 
( 0804,CD18 )   :H_ABS   dl X_DUP X_0< 
( 0804,CD20 )                 dl X_0BRANCH H_U0 X_NEGATE semis 

( 0804,CD30 )   :N_DABS   d$  4  0  0  0  "DABS"

( 0804,CD38 )   :X_DABS   dl docol H_DABS 0 X_ABS 
( 0804,CD48 )                 dl N_DABS 0 
( 0804,CD50 )   :H_DABS   dl X_DUP X_0< 
( 0804,CD58 )                 dl X_0BRANCH H_U0 X_DNEGATE semis 

( 0804,CD68 )   :N_MIN   d$  3  0  0  0  "MIN" 90 

( 0804,CD70 )   :X_MIN   dl docol H_MIN 0 X_DABS 
( 0804,CD80 )                 dl N_MIN 0 
( 0804,CD88 )   :H_MIN   dl X_2DUP X_> 
( 0804,CD90 )                 dl X_0BRANCH H_U0 X_SWAP X_DROP 
( 0804,CDA0 )                 dl semis 

( 0804,CDA4 )   :N_MAX   d$  3  0  0  0  "MAX" 90 

( 0804,CDAC )   :X_MAX   dl docol H_MAX 0 X_MIN 
( 0804,CDBC )                 dl N_MAX 0 
( 0804,CDC4 )   :H_MAX   dl X_2DUP X_< 
( 0804,CDCC )                 dl X_0BRANCH H_U0 X_SWAP X_DROP 
( 0804,CDDC )                 dl semis 

( 0804,CDE0 )   :N_LSHIFT   d$  6  0  0  0  "LSHIFT" 90 
( 0804,CDEB )                 d$  90 

( 0804,CDEC )   :X_LSHIFT   dl H_LSHIFT H_LSHIFT 0 X_MAX 
( 0804,CDFC )                 dl N_LSHIFT 0 

( 0804,CE04 )   :H_LSHIFT    POP|X, CX| 
( 0804,CE05 )                  POP|X, AX| 
( 0804,CE06 )                  SHL, V| X| R| AX| 
( 0804,CE08 )                  PUSH|X, AX| 
( 0804,CE09 )                  LODS, X'| 
( 0804,CE0A )                  JMPO, ZO| [AX] 
( 0804,CE0C )   :N_RSHIFT   d$  6  0  0  0  "RSHIFT" 90 
( 0804,CE17 )                 d$  90 

( 0804,CE18 )   :X_RSHIFT   dl H_RSHIFT H_RSHIFT 0 X_LSHIFT 
( 0804,CE28 )                 dl N_RSHIFT 0 

( 0804,CE30 )   :H_RSHIFT    POP|X, CX| 
( 0804,CE31 )                  POP|X, AX| 
( 0804,CE32 )                  SHR, V| X| R| AX| 
( 0804,CE34 )                  PUSH|X, AX| 
( 0804,CE35 )                  LODS, X'| 
( 0804,CE36 )                  JMPO, ZO| [AX] 
( 0804,CE38 )   :N_M*   d$  2  0  0  0  "M*" 90 
( 0804,CE3F )                 d$  90 

( 0804,CE40 )   :X_M*   dl H_M* H_M* 0 X_RSHIFT 
( 0804,CE50 )                 dl N_M* 0 

( 0804,CE58 )   :H_M*    POP|X, AX| 
( 0804,CE59 )                  POP|X, BX| 
( 0804,CE5A )                  IMUL|AD, X| R| BX| 
( 0804,CE5C )                  XCHG|AX, DX| 
( 0804,CE5D )                  PUSH|X, DX| 
( 0804,CE5E )                  PUSH|X, AX| 
( 0804,CE5F )                  LODS, X'| 
( 0804,CE60 )                  JMPO, ZO| [AX] 
( 0804,CE62 )                 d$  90  90 

( 0804,CE64 )   :N_SM/REM   d$  6  0  0  0  "SM/REM" 90 
( 0804,CE6F )                 d$  90 

( 0804,CE70 )   :X_SM/REM   dl H_SM/REM H_SM/REM 0 X_M* 
( 0804,CE80 )                 dl N_SM/REM 0 

( 0804,CE88 )   :H_SM/REM    POP|X, BX| 
( 0804,CE89 )                  POP|X, DX| 
( 0804,CE8A )                  POP|X, AX| 
( 0804,CE8B )                  IDIV|AD, X| R| BX| 
( 0804,CE8D )                  PUSH|X, DX| 
( 0804,CE8E )                  PUSH|X, AX| 
( 0804,CE8F )                  LODS, X'| 
( 0804,CE90 )                  JMPO, ZO| [AX] 
( 0804,CE92 )                 d$  90  90 

( 0804,CE94 )   :N_2/   d$  2  0  0  0  "2/" 90 
( 0804,CE9B )                 d$  90 

( 0804,CE9C )   :X_2/   dl docol H_2/ 0 X_SM/REM 
( 0804,CEAC )                 dl N_2/ 0 
( 0804,CEB4 )   :H_2/   dl X_S>D X_2 
( 0804,CEBC )                 dl X_FM/MOD X_SWAP X_DROP semis 

( 0804,CECC )   :N_2*   d$  2  0  0  0  "2*" 90 
( 0804,CED3 )                 d$  90 

( 0804,CED4 )   :X_2*   dl docol H_2* 0 X_2/ 
( 0804,CEE4 )                 dl N_2* 0 
( 0804,CEEC )   :H_2*   dl X_2 X_* 
( 0804,CEF4 )                 dl semis 

( 0804,CEF8 )   :N_1-   d$  2  0  0  0  "1-" 90 
( 0804,CEFF )                 d$  90 

( 0804,CF00 )   :X_1-   dl docol H_1- 0 X_2* 
( 0804,CF10 )                 dl N_1- 0 
( 0804,CF18 )   :H_1-   dl X_1 X_- 
( 0804,CF20 )                 dl semis 

( 0804,CF24 )   :N_FM/MOD   d$  6  0  0  0  "FM/MOD" 90 
( 0804,CF2F )                 d$  90 

( 0804,CF30 )   :X_FM/MOD   dl docol H_FM/MOD 0 X_1- 
( 0804,CF40 )                 dl N_FM/MOD 0 
( 0804,CF48 )   :H_FM/MOD   dl X_DUP X_>R 
( 0804,CF50 )                 dl X_2DUP X_XOR X_>R X_SM/REM 
( 0804,CF60 )                 dl X_R> X_0< X_0BRANCH H_OFFSET 
( 0804,CF70 )                 dl X_OVER X_0BRANCH H_FENCE X_1 
( 0804,CF80 )                 dl X_- X_SWAP X_R> X_+ 
( 0804,CF90 )                 dl X_SWAP X_BRANCH H_U0 X_RDROP 
( 0804,CFA0 )                 dl semis 

( 0804,CFA4 )   :N_*   d$  1  0  0  0  &* 90 
( 0804,CFAA )                 d$  90  90 

( 0804,CFAC )   :X_*   dl docol H_* 0 X_FM/MOD 
( 0804,CFBC )                 dl N_* 0 
( 0804,CFC4 )   :H_*   dl X_M* X_DROP 
( 0804,CFCC )                 dl semis 

( 0804,CFD0 )   :N_/MOD   d$  4  0  0  0  "/MOD"

( 0804,CFD8 )   :X_/MOD   dl docol H_/MOD 0 X_* 
( 0804,CFE8 )                 dl N_/MOD 0 
( 0804,CFF0 )   :H_/MOD   dl X_>R X_S>D 
( 0804,CFF8 )                 dl X_R> X_SM/REM semis 

( 0804,D004 )   :N_/   d$  1  0  0  0  &/ 90 
( 0804,D00A )                 d$  90  90 

( 0804,D00C )   :X_/   dl docol H_/ 0 X_/MOD 
( 0804,D01C )                 dl N_/ 0 
( 0804,D024 )   :H_/   dl X_/MOD X_SWAP 
( 0804,D02C )                 dl X_DROP semis 

( 0804,D034 )   :N_MOD   d$  3  0  0  0  "MOD" 90 

( 0804,D03C )   :X_MOD   dl docol H_MOD 0 X_/ 
( 0804,D04C )                 dl N_MOD 0 
( 0804,D054 )   :H_MOD   dl X_/MOD X_DROP 
( 0804,D05C )                 dl semis 

( 0804,D060 )   :N_*/MOD   d$  5  0  0  0  "*/MOD" 90 
( 0804,D06A )                 d$  90  90 

( 0804,D06C )   :X_*/MOD   dl docol H_*/MOD 0 X_MOD 
( 0804,D07C )                 dl N_*/MOD 0 
( 0804,D084 )   :H_*/MOD   dl X_>R X_M* 
( 0804,D08C )                 dl X_R> X_SM/REM semis 

( 0804,D098 )   :N_*/   d$  2  0  0  0  "*/" 90 
( 0804,D09F )                 d$  90 

( 0804,D0A0 )   :X_*/   dl docol H_*/ 0 X_*/MOD 
( 0804,D0B0 )                 dl N_*/ 0 
( 0804,D0B8 )   :H_*/   dl X_*/MOD X_SWAP 
( 0804,D0C0 )                 dl X_DROP semis 

( 0804,D0C8 )   :N_M/MOD   d$  5  0  0  0  "M/MOD" 90 
( 0804,D0D2 )                 d$  90  90 

( 0804,D0D4 )   :X_M/MOD   dl docol H_M/MOD 0 X_*/ 
( 0804,D0E4 )                 dl N_M/MOD 0 
( 0804,D0EC )   :H_M/MOD   dl X_>R X_0 
( 0804,D0F4 )                 dl X_R@ X_UM/MOD X_R> X_SWAP 
( 0804,D104 )                 dl X_>R X_UM/MOD X_R> semis 

( 0804,D114 )   :N_(LINE)   d$  6  0  0  0  "(LINE)" 90 
( 0804,D11F )                 d$  90 

( 0804,D120 )   :X_(LINE)   dl docol H_(LINE) 0 X_M/MOD 
( 0804,D130 )                 dl N_(LINE) 0 
( 0804,D138 )   :H_(LINE)   dl X_>R X_LIT 
( 0804,D140 )                 dl H_C/L X_M* X_B/BUF X_FM/MOD 
( 0804,D150 )                 dl X_R> X_+ X_BLOCK X_+ 
( 0804,D160 )                 dl X_LIT 3F semis 

( 0804,D16C )   :N_ERRSCR   d$  6  0  0  0  "ERRSCR" 90 
( 0804,D177 )                 d$  90 

( 0804,D178 )   :X_ERRSCR   dl dovar H_ERRSCR 0 X_(LINE) 
( 0804,D188 )                 dl N_ERRSCR 0 

( 0804,D190 )   :H_ERRSCR   d$  &0 0 
( 0804,D192 )                 d$  0  0 

( 0804,D194 )   :N_MESSAGE   d$  7  0  0  0  "MESSAGE" 90 

( 0804,D1A0 )   :X_MESSAGE   dl docol H_MESSAGE 0 X_ERRSCR 
( 0804,D1B0 )                 dl N_MESSAGE 0 
( 0804,D1B8 )   :H_MESSAGE   dl X_WARNING X_@ 
( 0804,D1C0 )                 dl X_0BRANCH 18 X_ERRSCR X_@ 
( 0804,D1D0 )                 dl X_(LINE) X_1+ X_ETYPE X__ 
( 0804,D1E0 )                 dl X_DROP semis 

( 0804,D1E8 )   :N_PC@   d$  3  0  0  0  "PC@" 90 

( 0804,D1F0 )   :X_PC@   dl H_PC@ H_PC@ 0 X_MESSAGE 
( 0804,D200 )                 dl N_PC@ 0 

( 0804,D208 )   :H_PC@    POP|X, DX| 
( 0804,D209 )                  XOR, X| F| AX'| R| AX| 
( 0804,D20B )                  IN|D, B'| 
( 0804,D20C )                  PUSH|X, AX| 
( 0804,D20D )                  LODS, X'| 
( 0804,D20E )                  JMPO, ZO| [AX] 
( 0804,D210 )   :N_PC!   d$  3  0  0  0  "PC!" 90 

( 0804,D218 )   :X_PC!   dl H_PC! H_PC! 0 X_PC@ 
( 0804,D228 )                 dl N_PC! 0 

( 0804,D230 )   :H_PC!    POP|X, DX| 
( 0804,D231 )                  POP|X, AX| 
( 0804,D232 )                  OUT|D, B'| 
( 0804,D233 )                  LODS, X'| 
( 0804,D234 )                  JMPO, ZO| [AX] 
( 0804,D236 )                 d$  90  90 

( 0804,D238 )   :N_P@   d$  2  0  0  0  "P@" 90 
( 0804,D23F )                 d$  90 

( 0804,D240 )   :X_P@   dl H_P@ H_P@ 0 X_PC! 
( 0804,D250 )                 dl N_P@ 0 

( 0804,D258 )   :H_P@    POP|X, DX| 
( 0804,D259 )                  IN|D, X'| 
( 0804,D25A )                  PUSH|X, AX| 
( 0804,D25B )                  LODS, X'| 
( 0804,D25C )                  JMPO, ZO| [AX] 
( 0804,D25E )                 d$  90  90 

( 0804,D260 )   :N_P!   d$  2  0  0  0  "P!" 90 
( 0804,D267 )                 d$  90 

( 0804,D268 )   :X_P!   dl H_P! H_P! 0 X_P@ 
( 0804,D278 )                 dl N_P! 0 

( 0804,D280 )   :H_P!    POP|X, DX| 
( 0804,D281 )                  POP|X, AX| 
( 0804,D282 )                  OUT|D, X'| 
( 0804,D283 )                  LODS, X'| 
( 0804,D284 )                  JMPO, ZO| [AX] 
( 0804,D286 )                 d$  90  90 

( 0804,D288 )   :N_STALEST   d$  7  0  0  0  "STALEST" 90 

( 0804,D294 )   :X_STALEST   dl dovar H_STALEST 0 X_P! 
( 0804,D2A4 )                 dl N_STALEST 0 

( 0804,D2AC )   :H_STALEST   d$  "8p" 4 
( 0804,D2AF )                 d$  ^L

( 0804,D2B0 )   :N_PREV   d$  4  0  0  0  "PREV"

( 0804,D2B8 )   :X_PREV   dl dovar H_PREV 0 X_STALEST 
( 0804,D2C8 )                 dl N_PREV 0 

( 0804,D2D0 )   :H_PREV   d$  "8p" 4 
( 0804,D2D3 )                 d$  ^L

( 0804,D2D4 )   :N_#BUFF   d$  5  0  0  0  "#BUFF" 90 
( 0804,D2DE )                 d$  90  90 

( 0804,D2E0 )   :X_#BUFF   dl doconstant H_#BUFF 0 X_PREV 
( 0804,D2F0 )                 dl N_#BUFF 0 

( 0804,D2F8 )   :N_+BUF   d$  4  0  0  0  "+BUF"

( 0804,D300 )   :X_+BUF   dl docol H_+BUF 0 X_#BUFF 
( 0804,D310 )                 dl N_+BUF 0 
( 0804,D318 )   :H_+BUF   dl X_LIT 0408 
( 0804,D320 )                 dl X_+ X_DUP X_LIMIT X_= 
( 0804,D330 )                 dl X_0BRANCH H_#BUFF X_DROP X_FIRST 
( 0804,D340 )                 dl X_DUP X_PREV X_@ X_- 
( 0804,D350 )                 dl semis 

( 0804,D354 )   :N_UPDATE   d$  6  0  0  0  "UPDATE" 90 
( 0804,D35F )                 d$  90 

( 0804,D360 )   :X_UPDATE   dl docol H_UPDATE 0 X_+BUF 
( 0804,D370 )                 dl N_UPDATE 0 
( 0804,D378 )   :H_UPDATE   dl X_PREV X_@ 
( 0804,D380 )                 dl X_DUP X_CELL+ X_CELL+ X_SWAP 
( 0804,D390 )                 dl X_@ X_OFFSET X_@ X_+ 
( 0804,D3A0 )                 dl X_0 X_R\W semis 

( 0804,D3AC )   :N_EMPTY-BUFFERS   d$  ^M 0  0  0  "EMPTY-BUFFERS" 90 
( 0804,D3BE )                 d$  90  90 

( 0804,D3C0 )   :X_EMPTY-BUFFERS   dl docol H_FLUSH 0 X_UPDATE 
( 0804,D3D0 )                 dl N_EMPTY-BUFFERS 0 
( 0804,D3D8 )   :H_FLUSH   dl X_FIRST X_LIMIT 
( 0804,D3E0 )                 dl X_OVER X_- X_ERASE semis 

( 0804,D3F0 )   :N_(BUFFER)   d$  8  0  0  0  "(BUFFER)"

( 0804,D3FC )   :X_(BUFFER)   dl docol H_(BUFFER) 0 X_EMPTY-BUFFERS 
( 0804,D40C )                 dl N_(BUFFER) 0 
( 0804,D414 )   :H_(BUFFER)   dl X_PREV X_@ 
( 0804,D41C )                 dl X_>R X_R@ X_@ X_OVER 
( 0804,D42C )                 dl X_= X_0BRANCH H_R0 X_DROP 
( 0804,D43C )                 dl X_R> X_EXIT X_R> X_+BUF 
( 0804,D44C )                 dl X_0= X_0BRANCH -3C X_DROP 
( 0804,D45C )                 dl X_STALEST X_@ X_>R X_R@ 
( 0804,D46C )                 dl X_+BUF X_OVER X_CELL+ X_@ 
( 0804,D47C )                 dl X_LIT -1 X_> X_AND 
( 0804,D48C )                 dl X_0BRANCH -28 X_STALEST X_! 
( 0804,D49C )                 dl X_R@ X_! X_0 X_R@ 
( 0804,D4AC )                 dl X_CELL+ X_! X_R@ X_PREV 
( 0804,D4BC )                 dl X_! X_R> semis 

( 0804,D4C8 )   :N_BLOCK   d$  5  0  0  0  "BLOCK" 90 
( 0804,D4D2 )                 d$  90  90 

( 0804,D4D4 )   :X_BLOCK   dl docol H_BLOCK 0 X_(BUFFER) 
( 0804,D4E4 )                 dl N_BLOCK 0 
( 0804,D4EC )   :H_BLOCK   dl X_(BUFFER) X_DUP 
( 0804,D4F4 )                 dl X_CELL+ X_@ X_0= X_0BRANCH 
( 0804,D504 )                 dl H_REMAINDER X_DUP X_CELL+ X_CELL+ 
( 0804,D514 )                 dl X_OVER X_@ X_OFFSET X_@ 
( 0804,D524 )                 dl X_+ X_1 X_R\W X_1 
( 0804,D534 )                 dl X_OVER X_CELL+ X_! X_DUP 
( 0804,D544 )                 dl X_PREV X_! X_CELL+ X_CELL+ 
( 0804,D554 )                 dl semis 

( 0804,D558 )   :N_FLUSH   d$  5  0  0  0  "FLUSH" 90 
( 0804,D562 )                 d$  90  90 

( 0804,D564 )   :X_FLUSH   dl docol H_FLUSH 0 X_BLOCK 
( 0804,D574 )                 dl N_FLUSH 0 

( 0804,D57C )                 dl X_LIMIT X_FIRST X_CELL+ X_(DO) 
( 0804,D58C )                 dl H_WARNING X_0 X_I X_! 
( 0804,D59C )                 dl X_LIT 0408 X_+LOOP -18 
( 0804,D5AC )                 dl semis 

( 0804,D5B0 )   :N_SAVE   d$  4  0  0  0  "SAVE"

( 0804,D5B8 )   :X_SAVE   dl docol H_SAVE 0 X_FLUSH 
( 0804,D5C8 )                 dl N_SAVE 0 
( 0804,D5D0 )   :H_SAVE   dl X_R> X_SRC 
( 0804,D5D8 )                 dl X_2@ X_IN X_@ X_>R 
( 0804,D5E8 )                 dl X_>R X_>R X_>R semis 

( 0804,D5F8 )   :N_RESTORE   d$  7  0  0  0  "RESTORE" 90 

( 0804,D604 )   :X_RESTORE   dl docol H_RESTORE 0 X_SAVE 
( 0804,D614 )                 dl N_RESTORE 0 
( 0804,D61C )   :H_RESTORE   dl X_R> X_R> 
( 0804,D624 )                 dl X_R> X_R> X_IN X_! 
( 0804,D634 )                 dl X_SRC X_2! X_>R semis 

( 0804,D644 )   :N_SAVE-INPUT   d$  ^J 0  0  0  "SAVE-INPUT" 90 
( 0804,D653 )                 d$  90 

( 0804,D654 )   :X_SAVE-INPUT   dl docol H_SAVE-INPUT 0 X_RESTORE 
( 0804,D664 )                 dl N_SAVE-INPUT 0 
( 0804,D66C )   :H_SAVE-INPUT   dl X_SRC X_2@ 
( 0804,D674 )                 dl X_IN X_@ X_LIT 3 
( 0804,D684 )                 dl semis 

( 0804,D688 )   :N_RESTORE-INPUT   d$  ^M 0  0  0  "RESTORE-INPUT" 90 
( 0804,D69A )                 d$  90  90 

( 0804,D69C )   :X_RESTORE-INPUT   dl docol H_RESTORE-INPUT 0 X_SAVE-INPUT 
( 0804,D6AC )                 dl N_RESTORE-INPUT 0 
( 0804,D6B4 )   :H_RESTORE-INPUT   dl X_DROP X_IN 
( 0804,D6BC )                 dl X_! X_SRC X_2! X_LIT 
( 0804,D6CC )                 dl -1 semis 

( 0804,D6D4 )   :N_LOCK   d$  4  0  0  0  "LOCK"

( 0804,D6DC )   :X_LOCK   dl docol H_LOCK 0 X_RESTORE-INPUT 
( 0804,D6EC )                 dl N_LOCK 0 
( 0804,D6F4 )   :H_LOCK   dl X_BLOCK X_LIT 
( 0804,D6FC )                 dl H_U0 X_- X_LIT -2 
( 0804,D70C )                 dl X_SWAP X_+! semis 

( 0804,D718 )   :N_UNLOCK   d$  6  0  0  0  "UNLOCK" 90 
( 0804,D723 )                 d$  90 

( 0804,D724 )   :X_UNLOCK   dl docol H_UNLOCK 0 X_LOCK 
( 0804,D734 )                 dl N_UNLOCK 0 
( 0804,D73C )   :H_UNLOCK   dl X_BLOCK X_LIT 
( 0804,D744 )                 dl H_U0 X_- X_2 X_SWAP 
( 0804,D754 )                 dl X_+! semis 

( 0804,D75C )   :N_LOAD   d$  4  0  0  0  "LOAD"

( 0804,D764 )   :X_LOAD   dl docol H_LOAD 0 X_UNLOCK 
( 0804,D774 )                 dl N_LOAD 0 
( 0804,D77C )   :H_LOAD   dl X_DUP X_THRU 
( 0804,D784 )                 dl semis 

( 0804,D788 )   :N_THRU   d$  4  0  0  0  "THRU"

( 0804,D790 )   :X_THRU   dl docol H_THRU 0 X_LOAD 
( 0804,D7A0 )                 dl N_THRU 0 
( 0804,D7A8 )   :H_THRU   dl X_SAVE X_1+ 
( 0804,D7B0 )                 dl X_SWAP X_(DO) H_CSP X_I 
( 0804,D7C0 )                 dl X_LOCK X_I X_BLOCK X_LIT 
( 0804,D7D0 )                 dl H_B/BUF X_SET-SRC X_LIT X_INTERPRET 
( 0804,D7E0 )                 dl X_CATCH X_I X_UNLOCK X_?DUP 
( 0804,D7F0 )                 dl X_0BRANCH H_RUBOUT X_RDROP X_RDROP 
( 0804,D800 )                 dl X_RDROP X_RESTORE X_THROW X_(LOOP) 
( 0804,D810 )                 dl -58 X_RESTORE semis 

( 0804,D81C )   :N_BLK   d$  3  0  0  0  "BLK" 90 

( 0804,D824 )   :X_BLK   dl docol H_BLK 0 X_THRU 
( 0804,D834 )                 dl N_BLK 0 
( 0804,D83C )   :H_BLK   dl X_IN X_@ 
( 0804,D844 )                 dl X_FIRST X_LIMIT X_WITHIN X_SRC 
( 0804,D854 )                 dl X_2@ X_- X_LIT H_B/BUF 
( 0804,D864 )                 dl X_= X_AND X_0BRANCH H_FENCE 
( 0804,D874 )                 dl X_SRC X_@ X_2 X_CELLS 
( 0804,D884 )                 dl X_- X_@ X_BRANCH H_U0 
( 0804,D894 )                 dl X_0 X_(BLK) X_! X_(BLK) 
( 0804,D8A4 )                 dl semis 

( 0804,D8A8 )   :N_-->   d$  3  0  0  0  "-->" 90 

( 0804,D8B0 )   :X_-->   dl docol H_--> H_U0 X_BLK 
( 0804,D8C0 )                 dl N_--> 0 
( 0804,D8C8 )   :H_-->   dl X_?LOADING X_BLK 
( 0804,D8D0 )                 dl X_@ X_DUP X_UNLOCK X_1+ 
( 0804,D8E0 )                 dl X_DUP X_LOCK X_DUP X_BLK 
( 0804,D8F0 )                 dl X_! X_BLOCK X_LIT H_B/BUF 
( 0804,D900 )                 dl X_SET-SRC semis 

( 0804,D908 )   :N_LINOS   d$  5  0  0  0  "LINOS" 90 
( 0804,D912 )                 d$  90  90 

( 0804,D914 )   :X_LINOS   dl H_LINOS H_LINOS 0 X_--> 
( 0804,D924 )                 dl N_LINOS 0 

( 0804,D92C )   :H_LINOS    POP|X, AX| 
( 0804,D92D )                  POP|X, DX| 
( 0804,D92E )                  POP|X, CX| 
( 0804,D92F )                  POP|X, BX| 
( 0804,D930 )                  INT, H_HANDLER IB, 
( 0804,D932 )                  PUSH|X, AX| 
( 0804,D933 )                  LODS, X'| 
( 0804,D934 )                  JMPO, ZO| [AX] 
( 0804,D936 )                 d$  90  90 

( 0804,D938 )   :N_LINOS5   d$  6  0  0  0  "LINOS5" 90 
( 0804,D943 )                 d$  90 

( 0804,D944 )   :X_LINOS5   dl H_LINOS5 H_LINOS5 0 X_LINOS 
( 0804,D954 )                 dl N_LINOS5 0 

( 0804,D95C )   :H_LINOS5    LEA, BP'| BO| [BP] 0FC B, 
( 0804,D95F )                  MOV, X| F| SI'| BO| [BP] 0 B, 
( 0804,D962 )                  POP|X, AX| 
( 0804,D963 )                  POP|X, DI| 
( 0804,D964 )                  POP|X, SI| 
( 0804,D965 )                  POP|X, DX| 
( 0804,D966 )                  POP|X, CX| 
( 0804,D967 )                  POP|X, BX| 
( 0804,D968 )                  INT, H_HANDLER IB, 
( 0804,D96A )                  MOV, X| T| SI'| BO| [BP] 0 B, 
( 0804,D96D )                  LEA, BP'| BO| [BP] H_U0 B, 
( 0804,D970 )                  PUSH|X, AX| 
( 0804,D971 )                  LODS, X'| 
( 0804,D972 )                  JMPO, ZO| [AX] 
( 0804,D974 )   :N_MS   d$  2  0  0  0  "MS" 90 
( 0804,D97B )                 d$  90 

( 0804,D97C )   :X_MS   dl docol H_MS 0 X_LINOS5 
( 0804,D98C )                 dl N_MS 0 
( 0804,D994 )   :H_MS   dl X_LIT 03E8 
( 0804,D99C )                 dl X_LIT 000F,4240 X_*/MOD X_LIT 
( 0804,D9AC )                 dl SOMEBUFFER1 X_2! X_0 X_0 
( 0804,D9BC )                 dl X_0 X_0 X_LIT SOMEBUFFER1 
( 0804,D9CC )                 dl X_LIT 8E X_LINOS5 X_?ERRUR 
( 0804,D9DC )                 dl semis 

( 0804,D9E0 )   :SOMEBUFFER1   d$  0  0  0  0  0  0  0  0 

( 0804,D9E8 )   :N_RWBUF   d$  5  0  0  0  "RWBUF" 90 
( 0804,D9F2 )                 d$  90  90 

( 0804,D9F4 )   :X_RWBUF   dl dovar H_RWBUF 0 X_MS 
( 0804,DA04 )                 dl N_RWBUF 0 
( 0804,DA0C )   :H_RWBUF   dl 0 0 
( 0804,DA14 )                 dl 0 0 0 0 
( 0804,DA24 )                 dl 0 0 0 0 
( 0804,DA34 )                 dl 0 0 0 0 
( 0804,DA44 )                 dl 0 0 0 0 
( 0804,DA54 )                 dl 0 0 0 0 
( 0804,DA64 )                 dl 0 0 0 0 
( 0804,DA74 )                 dl 0 0 0 0 
( 0804,DA84 )                 dl 0 0 0 0 
( 0804,DA94 )                 dl 0 0 0 0 
( 0804,DAA4 )                 dl 0 0 0 0 
( 0804,DAB4 )                 dl 0 0 0 0 
( 0804,DAC4 )                 dl 0 0 0 0 
( 0804,DAD4 )                 dl 0 0 0 0 
( 0804,DAE4 )                 dl 0 0 0 0 
( 0804,DAF4 )                 dl 0 0 0 0 
( 0804,DB04 )                 dl 0 0 0 0 
( 0804,DB14 )                 dl 0 0 0 0 
( 0804,DB24 )                 dl 0 0 0 0 
( 0804,DB34 )                 dl 0 0 0 0 
( 0804,DB44 )                 dl 0 0 0 0 
( 0804,DB54 )                 dl 0 0 0 0 
( 0804,DB64 )                 dl 0 0 0 0 
( 0804,DB74 )                 dl 0 0 0 0 
( 0804,DB84 )                 dl 0 0 0 0 
( 0804,DB94 )                 dl 0 0 0 0 
( 0804,DBA4 )                 dl 0 0 0 0 
( 0804,DBB4 )                 dl 0 0 0 0 
( 0804,DBC4 )                 dl 0 0 0 0 
( 0804,DBD4 )                 dl 0 0 0 0 
( 0804,DBE4 )                 dl 0 0 0 0 
( 0804,DBF4 )                 dl 0 0 0 0 
( 0804,DC04 )                 dl 0 0 

( 0804,DC0C )   :N_ZEN   d$  3  0  0  0  "ZEN" 90 

( 0804,DC14 )   :X_ZEN   dl docol H_ZEN 0 X_RWBUF 
( 0804,DC24 )                 dl N_ZEN 0 
( 0804,DC2C )   :H_ZEN   dl X_RWBUF X_$! 
( 0804,DC34 )                 dl X_0 X_RWBUF X_$C+ X_RWBUF 
( 0804,DC44 )                 dl X_CELL+ semis 

( 0804,DC4C )   :N_OPEN-FILE   d$  ^I 0  0  0  "OPEN-FILE" 90 
( 0804,DC5A )                 d$  90  90 

( 0804,DC5C )   :X_OPEN-FILE   dl docol H_OPEN-FILE 0 X_ZEN 
( 0804,DC6C )                 dl N_OPEN-FILE 0 
( 0804,DC74 )   :H_OPEN-FILE   dl X_>R X_ZEN 
( 0804,DC7C )                 dl X_R> X__ X_LIT 5 
( 0804,DC8C )                 dl X_LINOS X_DUP X_0 X_MIN 
( 0804,DC9C )                 dl semis 

( 0804,DCA0 )   :N_CLOSE-FILE   d$  ^J 0  0  0  "CLOSE-FILE" 90 
( 0804,DCAF )                 d$  90 

( 0804,DCB0 )   :X_CLOSE-FILE   dl docol H_CLOSE-FILE 0 X_OPEN-FILE 
( 0804,DCC0 )                 dl N_CLOSE-FILE 0 
( 0804,DCC8 )   :H_CLOSE-FILE   dl X__ X__ 
( 0804,DCD0 )                 dl X_LIT 6 X_LINOS semis 

( 0804,DCE0 )   :N_CREATE-FILE   d$  0B  0  0  0  "CREATE-FILE" 90 

( 0804,DCF0 )   :X_CREATE-FILE   dl docol H_CREATE-FILE 0 X_CLOSE-FILE 
( 0804,DD00 )                 dl N_CREATE-FILE 0 
( 0804,DD08 )   :H_CREATE-FILE   dl X_>R X_2DUP 
( 0804,DD10 )                 dl X_DELETE-FILE X_DROP X_ZEN X_R> 
( 0804,DD20 )                 dl X__ X_LIT H_#BUFF X_LINOS 
( 0804,DD30 )                 dl X_DUP X_0 X_MAX X_SWAP 
( 0804,DD40 )                 dl X_0 X_MIN semis 

( 0804,DD4C )   :N_DELETE-FILE   d$  0B  0  0  0  "DELETE-FILE" 90 

( 0804,DD5C )   :X_DELETE-FILE   dl docol H_DELETE-FILE 0 X_CREATE-FILE 
( 0804,DD6C )                 dl N_DELETE-FILE 0 
( 0804,DD74 )   :H_DELETE-FILE   dl X_ZEN X__ 
( 0804,DD7C )                 dl X__ X_LIT 0A X_LINOS 
( 0804,DD8C )                 dl semis 

( 0804,DD90 )   :N_READ-FILE   d$  ^I 0  0  0  "READ-FILE" 90 
( 0804,DD9E )                 d$  90  90 

( 0804,DDA0 )   :X_READ-FILE   dl docol H_READ-FILE 0 X_DELETE-FILE 
( 0804,DDB0 )                 dl N_READ-FILE 0 
( 0804,DDB8 )   :H_READ-FILE   dl X_ROT X_ROT 
( 0804,DDC0 )                 dl X_LIT 3 X_LINOS X_DUP 
( 0804,DDD0 )                 dl X_0 X_MAX X_SWAP X_0 
( 0804,DDE0 )                 dl X_MIN semis 

( 0804,DDE8 )   :N_REPOSITION-FILE   d$  0F  0  0  0  "REPOSITION-FILE" 90 

( 0804,DDFC )   :X_REPOSITION-FILE   dl docol H_REPOSITION-FILE 0 X_READ-FILE 
( 0804,DE0C )                 dl N_REPOSITION-FILE 0 
( 0804,DE14 )   :H_REPOSITION-FILE   dl X_>R X_DROP 
( 0804,DE1C )                 dl X_R> X_SWAP X_LIT 0 
( 0804,DE2C )                 dl X_LIT 13 X_LINOS X_0 
( 0804,DE3C )                 dl X_MIN semis 

( 0804,DE44 )   :N_WRITE-FILE   d$  ^J 0  0  0  "WRITE-FILE" 90 
( 0804,DE53 )                 d$  90 

( 0804,DE54 )   :X_WRITE-FILE   dl docol H_WRITE-FILE 0 X_REPOSITION-FILE 
( 0804,DE64 )                 dl N_WRITE-FILE 0 
( 0804,DE6C )   :H_WRITE-FILE   dl X_ROT X_ROT 
( 0804,DE74 )                 dl X_LIT H_U0 X_LINOS X_0 
( 0804,DE84 )                 dl X_MIN semis 

( 0804,DE8C )   :N_GET-FILE   d$  8  0  0  0  "GET-FILE"

( 0804,DE98 )   :X_GET-FILE   dl docol H_GET-FILE 0 X_WRITE-FILE 
( 0804,DEA8 )                 dl N_GET-FILE 0 
( 0804,DEB0 )   :H_GET-FILE   dl X_2DUP X_$, 
( 0804,DEB8 )                 dl X_DROP X_LIT 654C,6946 X_, 
( 0804,DEC8 )                 dl X_0 X_OPEN-FILE X_THROW X_>R 
( 0804,DED8 )                 dl X_HERE X_DUP X_EM X_LIT 
( 0804,DEE8 )                 dl 6 X_/ X_DUP X_ALLOT 
( 0804,DEF8 )                 dl X_LIT 03E8 X_- X_R@ 
( 0804,DF08 )                 dl X_READ-FILE X_THROW X_R> X_CLOSE-FILE 
( 0804,DF18 )                 dl X_THROW X_2DUP X_+ X_DP 
( 0804,DF28 )                 dl X_! semis 

( 0804,DF30 )   :N_PUT-FILE   d$  8  0  0  0  "PUT-FILE"

( 0804,DF3C )   :X_PUT-FILE   dl docol H_PUT-FILE 0 X_GET-FILE 
( 0804,DF4C )                 dl N_PUT-FILE 0 
( 0804,DF54 )   :H_PUT-FILE   dl X_LIT 01ED 
( 0804,DF5C )                 dl X_CREATE-FILE X_THROW X_DUP X_>R 
( 0804,DF6C )                 dl X_WRITE-FILE X_THROW X_R> X_CLOSE-FILE 
( 0804,DF7C )                 dl X_THROW semis 

( 0804,DF84 )   :N_INCLUDED   d$  8  0  0  0  "INCLUDED"

( 0804,DF90 )   :X_INCLUDED   dl docol H_INCLUDED 0 X_PUT-FILE 
( 0804,DFA0 )                 dl N_INCLUDED 0 
( 0804,DFA8 )   :H_INCLUDED   dl X_HERE X_>R 
( 0804,DFB0 )                 dl X_LIT X_GET-FILE X_CATCH X_DUP 
( 0804,DFC0 )                 dl X_0BRANCH 18 X_R> X_DP 
( 0804,DFD0 )                 dl X_! X_THROW X_BRANCH H_#BUFF 
( 0804,DFE0 )                 dl X_RDROP X_DROP X_EVALUATE semis 

( 0804,DFF0 )   :N_REFILL-TIB   d$  ^J 0  0  0  "REFILL-TIB" 90 
( 0804,DFFF )                 d$  90 

( 0804,E000 )   :X_REFILL-TIB   dl docol H_REFILL-TIB 0 X_INCLUDED 
( 0804,E010 )                 dl N_REFILL-TIB 0 
( 0804,E018 )   :H_REFILL-TIB   dl X_REMAINDER X_@ 
( 0804,E020 )                 dl X_>R X_TIB X_@ X_R@ 
( 0804,E030 )                 dl X_+ X_LIT 8000 X_R@ 
( 0804,E040 )                 dl X_- X_0 X_READ-FILE X_?ERRUR 
( 0804,E050 )                 dl X_DUP X_0= X_LIT -20 
( 0804,E060 )                 dl X_AND X_?ERRUR X_TIB X_@ 
( 0804,E070 )                 dl X_SWAP X_R> X_+ X_REMAINDER 
( 0804,E080 )                 dl X_2! semis 

( 0804,E088 )   :N_ACCEPT   d$  6  0  0  0  "ACCEPT" 90 
( 0804,E093 )                 d$  90 

( 0804,E094 )   :X_ACCEPT   dl docol H_ACCEPT 0 X_REFILL-TIB 
( 0804,E0A4 )                 dl N_ACCEPT 0 
( 0804,E0AC )   :H_ACCEPT   dl X_(ACCEPT) X_2SWAP 
( 0804,E0B4 )                 dl X_ROT X_MIN X_DUP X_>R 
( 0804,E0C4 )                 dl X_MOVE X_R> semis 

( 0804,E0D0 )   :N_(ACCEPT)   d$  8  0  0  0  "(ACCEPT)"

( 0804,E0DC )   :X_(ACCEPT)   dl docol H_(ACCEPT) 0 X_ACCEPT 
( 0804,E0EC )                 dl N_(ACCEPT) 0 
( 0804,E0F4 )   :H_(ACCEPT)   dl X_REMAINDER X_2@ 
( 0804,E0FC )                 dl X_LIT 0A X_$I X_0= 
( 0804,E10C )                 dl X_0BRANCH H_REMAINDER X_REMAINDER X_2@ 
( 0804,E11C )                 dl X_TIB X_@ X_SWAP X_MOVE 
( 0804,E12C )                 dl X_TIB X_@ X_REMAINDER X_CELL+ 
( 0804,E13C )                 dl X_! X_REFILL-TIB X_BRANCH -58 
( 0804,E14C )                 dl X_REMAINDER X_2@ X_LIT 0A 
( 0804,E15C )                 dl X_$S X_2SWAP X_REMAINDER X_2! 
( 0804,E16C )                 dl semis 

( 0804,E170 )   :N_KEY   d$  3  0  0  0  "KEY" 90 

( 0804,E178 )   :X_KEY   dl docol H_KEY 0 X_(ACCEPT) 
( 0804,E188 )                 dl N_KEY 0 
( 0804,E190 )   :H_KEY   dl X_1 X_LIT 
( 0804,E198 )                 dl 0A X_SET-TERM X_0 X_DSP@ 
( 0804,E1A8 )                 dl X_0 X_SWAP X_1 X_LIT 
( 0804,E1B8 )                 dl 3 X_LINOS X_DUP X_?ERRUR 
( 0804,E1C8 )                 dl X_0= X_LIT -20 X_AND 
( 0804,E1D8 )                 dl X_?ERRUR X_1 X_LIT 0A 
( 0804,E1E8 )                 dl X_SET-TERM semis 

( 0804,E1F0 )   :N_KEY?   d$  4  0  0  0  "KEY?"

( 0804,E1F8 )   :X_KEY?   dl docol H_KEY? 0 X_KEY 
( 0804,E208 )                 dl N_KEY? 0 
( 0804,E210 )   :H_KEY?   dl X_0 X_LIT 
( 0804,E218 )                 dl 0A X_SET-TERM X_1 X_LIT 
( 0804,E228 )                 dl L0804,E288 X_1 X_OVER X_! 
( 0804,E238 )                 dl X_0 X_0 X_0 X_0 
( 0804,E248 )                 dl X_LIT SOMEBUFFER1 X_2! X_LIT 
( 0804,E258 )                 dl SOMEBUFFER1 X_LIT 8E X_LINOS5 
( 0804,E268 )                 dl X_DUP X_?ERRUR X_NEGATE X_0 
( 0804,E278 )                 dl X_LIT 0A X_SET-TERM semis 

( 0804,E288 )   :L0804,E288   d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E298 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E2A8 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E2B8 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E2C8 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E2D8 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E2E8 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E2F8 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 

( 0804,E308 )   :N_TYPE   d$  4  0  0  0  "TYPE"

( 0804,E310 )   :X_TYPE   dl docol H_TYPE 0 X_KEY? 
( 0804,E320 )                 dl N_TYPE 0 
( 0804,E328 )   :H_TYPE   dl X_DUP X_OUT 
( 0804,E330 )                 dl X_+! X_1 X_WRITE-FILE X_DROP 
( 0804,E340 )                 dl semis 

( 0804,E344 )   :N_ETYPE   d$  5  0  0  0  "ETYPE" 90 
( 0804,E34E )                 d$  90  90 

( 0804,E350 )   :X_ETYPE   dl docol H_ETYPE 0 X_TYPE 
( 0804,E360 )                 dl N_ETYPE 0 
( 0804,E368 )   :H_ETYPE   dl X_2 X_WRITE-FILE 
( 0804,E370 )                 dl X_DROP semis 

( 0804,E378 )   :N_TERMIO   d$  6  0  0  0  "TERMIO" 90 
( 0804,E383 )                 d$  90 

( 0804,E384 )   :X_TERMIO   dl dovar H_TERMIO 0 X_ETYPE 
( 0804,E394 )                 dl N_TERMIO 0 

( 0804,E39C )   :H_TERMIO   d$  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E3A8 )   :L0804,E3A8   d$  0  0  0  0 
( 0804,E3AC )                 d$  0  0  0  0  0  0  0 
( 0804,E3B3 )   :L0804,E3B3   d$  0  0  0  0  0  0  0  0  0 
( 0804,E3BC )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E3CC )                 d$  0  0  0  0  0  0  0  0  0  0  0  0 

( 0804,E3D8 )   :N_SET-TERM   d$  8  0  0  0  "SET-TERM"

( 0804,E3E4 )   :X_SET-TERM   dl docol H_SET-TERM 0 X_TERMIO 
( 0804,E3F4 )                 dl N_SET-TERM 0 
( 0804,E3FC )   :H_SET-TERM   dl X_LIT L0804,E3A8 
( 0804,E404 )                 dl X_SWAP X_TOGGLE X_LIT L0804,E3B3 
( 0804,E414 )                 dl X_C! X_0 X_LIT 5402 
( 0804,E424 )                 dl X_TERMIO X_LIT 36 X_LINOS 
( 0804,E434 )                 dl X_?ERRUR semis 

( 0804,E43C )   :N_EMIT   d$  4  0  0  0  "EMIT"

( 0804,E444 )   :X_EMIT   dl docol H_EMIT 0 X_SET-TERM 
( 0804,E454 )                 dl N_EMIT 0 
( 0804,E45C )   :H_EMIT   dl X_DSP@ X_1 
( 0804,E464 )                 dl X_TYPE X_DROP semis 

( 0804,E470 )   :N_DISK-ERROR   d$  ^J 0  0  0  "DISK-ERROR" 90 
( 0804,E47F )                 d$  90 

( 0804,E480 )   :X_DISK-ERROR   dl dovar H_DISK-ERROR 0 X_EMIT 
( 0804,E490 )                 dl N_DISK-ERROR 0 

( 0804,E498 )   :H_DISK-ERROR   d$  0FF  0FF  0FF  0FF 

( 0804,E49C )   :N_BLOCK-FILE   d$  ^J 0  0  0  "BLOCK-FILE" 90 
( 0804,E4AB )                 d$  90 

( 0804,E4AC )   :X_BLOCK-FILE   dl dovar H_BLOCK-FILE 0 X_DISK-ERROR 
( 0804,E4BC )                 dl N_BLOCK-FILE 0 

( 0804,E4C4 )   :H_BLOCK-FILE   d$  ^I 0  0  0  "forth.lab" 0 
( 0804,E4D2 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E4E2 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E4F2 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E502 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E512 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E522 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E532 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E542 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E552 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E562 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E572 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E582 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E592 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E5A2 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E5B2 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E5C2 )                 d$  0  0 

( 0804,E5C4 )   :N_BLOCK-HANDLE   d$  ^L 0  0  0  "BLOCK-HANDLE"

( 0804,E5D4 )   :X_BLOCK-HANDLE   dl dovar H_BLOCK-HANDLE 0 X_BLOCK-FILE 
( 0804,E5E4 )                 dl N_BLOCK-HANDLE 0 

( 0804,E5EC )   :H_BLOCK-HANDLE   d$  0FF  0FF  0FF  0FF 

( 0804,E5F0 )   :N_?DISK-ERROR   d$  0B  0  0  0  "?DISK-ERROR" 90 

( 0804,E600 )   :X_?DISK-ERROR   dl docol H_?DISK-ERROR 0 X_BLOCK-HANDLE 
( 0804,E610 )                 dl N_?DISK-ERROR 0 
( 0804,E618 )   :H_?DISK-ERROR   dl X_LIT H_#BUFF 
( 0804,E620 )                 dl X_?ERROR semis 

( 0804,E628 )   :N_BLOCK-INIT   d$  ^J 0  0  0  "BLOCK-INIT" 90 
( 0804,E637 )                 d$  90 

( 0804,E638 )   :X_BLOCK-INIT   dl docol H_BLOCK-INIT 0 X_?DISK-ERROR 
( 0804,E648 )                 dl N_BLOCK-INIT 0 
( 0804,E650 )   :H_BLOCK-INIT   dl X_BLOCK-FILE X_$@ 
( 0804,E658 )                 dl X_ROT X_OPEN-FILE X_0= X_NEGATE 
( 0804,E668 )                 dl X_WARNING X_@ X_MIN X_WARNING 
( 0804,E678 )                 dl X_! X_BLOCK-HANDLE X_! semis 

( 0804,E688 )   :N_BLOCK-EXIT   d$  ^J 0  0  0  "BLOCK-EXIT" 90 
( 0804,E697 )                 d$  90 

( 0804,E698 )   :X_BLOCK-EXIT   dl docol H_BLOCK-EXIT 0 X_BLOCK-INIT 
( 0804,E6A8 )                 dl N_BLOCK-EXIT 0 
( 0804,E6B0 )   :H_BLOCK-EXIT   dl X_FLUSH X_BLOCK-HANDLE 
( 0804,E6B8 )                 dl X_@ X_CLOSE-FILE X_0 X_WARNING 
( 0804,E6C8 )                 dl X_! X_LIT -1 X_BLOCK-HANDLE 
( 0804,E6D8 )                 dl X_! X_?DISK-ERROR semis 

( 0804,E6E4 )   :N_SEEK   d$  4  0  0  0  "SEEK"

( 0804,E6EC )   :X_SEEK   dl docol H_SEEK 0 X_BLOCK-EXIT 
( 0804,E6FC )                 dl N_SEEK 0 
( 0804,E704 )   :H_SEEK   dl X_B/BUF X_UM* 
( 0804,E70C )                 dl X_BLOCK-HANDLE X_@ X_REPOSITION-FILE X_?DISK-ERROR 
( 0804,E71C )                 dl semis 

( 0804,E720 )   :N_R\W   d$  3  0  0  0  "R\W" 90 

( 0804,E728 )   :X_R\W   dl docol H_R\W 0 X_SEEK 
( 0804,E738 )                 dl N_R\W 0 
( 0804,E740 )   :H_R\W   dl X_>R X_SEEK 
( 0804,E748 )                 dl X_B/BUF X_BLOCK-HANDLE X_@ X_R> 
( 0804,E758 )                 dl X_0BRANCH H_RUBOUT X_READ-FILE X_SWAP 
( 0804,E768 )                 dl X_DROP X_BRANCH H_U0 X_WRITE-FILE 
( 0804,E778 )                 dl X_?DISK-ERROR semis 

( 0804,E780 )   :N_SHELL   d$  5  0  0  0  "SHELL" 90 
( 0804,E78A )                 d$  90  90 

( 0804,E78C )   :X_SHELL   dl dovar H_SHELL 0 X_R\W 
( 0804,E79C )                 dl N_SHELL 0 

( 0804,E7A4 )   :H_SHELL   d$  7  0  0  0 
( 0804,E7A8 )   :L0804,E7A8   d$  "/bin/sh" 0 
( 0804,E7B0 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E7C0 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E7D0 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E7E0 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E7F0 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E800 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E810 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E820 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E830 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E840 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E850 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E860 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E870 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E880 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E890 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E8A0 )                 d$  0  0  90  90 

( 0804,E8A4 )   :N_SYSTEM   d$  6  0  0  0  "SYSTEM" 90 
( 0804,E8AF )                 d$  90 

( 0804,E8B0 )   :X_SYSTEM   dl docol H_SYSTEM 0 X_SHELL 
( 0804,E8C0 )                 dl N_SYSTEM 0 
( 0804,E8C8 )   :H_SYSTEM   dl X_LIT L0804,E9C7 
( 0804,E8D0 )                 dl X_$! X_0 X_LIT L0804,E9C7 
( 0804,E8E0 )                 dl X_$C+ X_0 X_SHELL X_$C+ 
( 0804,E8F0 )                 dl X_LIT -1 X_SHELL X_+! 
( 0804,E900 )                 dl X__ X__ X__ X_LIT 
( 0804,E910 )                 dl 2 X_LINOS X_DUP X_?ERRUR 
( 0804,E920 )                 dl X_DUP X_0= X_0BRANCH 44 
( 0804,E930 )                 dl X_SHELL X_CELL+ X_LIT L0804,EACB 
( 0804,E940 )                 dl X_ARGS X_@ X_$@ X_1+ 
( 0804,E950 )                 dl X_CELLS X_+ X_LIT 0B 
( 0804,E960 )                 dl X_LINOS X_LIT -7F X_?ERRUR 
( 0804,E970 )                 dl X_BYE X_DUP X_LIT L0804,E9C0 
( 0804,E980 )                 dl X_0 X_LIT 7 X_LINOS 
( 0804,E990 )                 dl X_DUP X_LIT H_U0 X_= 
( 0804,E9A0 )                 dl X_BRANCH H_R0 X_DROP X_0BRANCH 
( 0804,E9B0 )                 dl -40 X_?ERRUR X_2DROP semis 

( 0804,E9C0 )   :L0804,E9C0   d$  0  0  0  0 
( 0804,E9C4 )   :L0804,E9C4   d$  "-c" 0 
( 0804,E9C7 )   :L0804,E9C7   d$  0  0  0  0 
( 0804,E9CB )   :L0804,E9CB   d$  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E9D7 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E9E7 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,E9F7 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA07 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA17 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA27 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA37 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA47 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA57 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA67 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA77 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA87 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EA97 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EAA7 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EAB7 )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,EAC7 )                 d$  0  0  0  0 

( 0804,EACB )   :L0804,EACB   dl L0804,E7A8 L0804,E9C4 L0804,E9CB 0 

( 0804,EADB )                 d$  90 

( 0804,EADC )   :N_'   d$  1  0  0  0  &' 90 
( 0804,EAE2 )                 d$  90  90 

( 0804,EAE4 )   :X_'   dl docol H_' 0 X_SYSTEM 
( 0804,EAF4 )                 dl N_' 0 
( 0804,EAFC )   :H_'   dl X_(WORD) X_PRESENT 
( 0804,EB04 )                 dl X_DUP X_0= X_LIT 0B 
( 0804,EB14 )                 dl X_?ERROR semis 

( 0804,EB1C )   :N_[']   d$  3  0  0  0  "[']" 90 

( 0804,EB24 )   :X_[']   dl docol H_['] H_U0 X_' 
( 0804,EB34 )                 dl N_['] 0 

( 0804,EB3C )   :N_FORGET-VOC   d$  ^J 0  0  0  "FORGET-VOC" 90 
( 0804,EB4B )                 d$  90 

( 0804,EB4C )   :X_FORGET-VOC   dl docol H_FORGET-VOC 0 X_['] 
( 0804,EB5C )                 dl N_FORGET-VOC 0 
( 0804,EB64 )   :H_FORGET-VOC   dl X_2DUP X_SWAP 
( 0804,EB6C )                 dl X_U< X_0BRANCH 44 X_SWAP 
( 0804,EB7C )                 dl X_>R X_>WID X_DUP X_>LFA 
( 0804,EB8C )                 dl X_@ X_DUP X_R@ X_U< 
( 0804,EB9C )                 dl X_0BRANCH -1C X_SWAP X_>LFA 
( 0804,EBAC )                 dl X_! X_R> X_BRANCH H_WARNING 
( 0804,EBBC )                 dl X_>VFA X_@ X_VOC-LINK X_! 
( 0804,EBCC )                 dl X_ONLY X_FORTH X_DEFINITIONS semis 

( 0804,EBDC )   :N_FORGET   d$  6  0  0  0  "FORGET" 90 
( 0804,EBE7 )                 d$  90 

( 0804,EBE8 )   :X_FORGET   dl docol H_FORGET 0 X_FORGET-VOC 
( 0804,EBF8 )                 dl N_FORGET 0 
( 0804,EC00 )   :H_FORGET   dl X__' X_DUP 
( 0804,EC08 )                 dl X_FENCE X_@ X_< X_LIT 
( 0804,EC18 )                 dl 15 X_?ERROR X_LIT X_FORGET-VOC 
( 0804,EC28 )                 dl X_FOR-VOCS X_>NFA X_@ X_DP 
( 0804,EC38 )                 dl X_! semis 

( 0804,EC40 )   :N_(BACK   d$  5  0  0  0  "(BACK" 90 
( 0804,EC4A )                 d$  90  90 

( 0804,EC4C )   :X_(BACK   dl docol H_(BACK 0 X_FORGET 
( 0804,EC5C )                 dl N_(BACK 0 
( 0804,EC64 )   :H_(BACK   dl X_HERE semis 

( 0804,EC6C )   :N_BACK)   d$  5  0  0  0  "BACK)" 90 
( 0804,EC76 )                 d$  90  90 

( 0804,EC78 )   :X_BACK)   dl docol H_BACK) 0 X_(BACK 
( 0804,EC88 )                 dl N_BACK) 0 
( 0804,EC90 )   :H_BACK)   dl X_HERE X_CELL+ 
( 0804,EC98 )                 dl X_- X_, semis 

( 0804,ECA4 )   :N_(FORWARD   d$  8  0  0  0  "(FORWARD"

( 0804,ECB0 )   :X_(FORWARD   dl docol H_(FORWARD 0 X_BACK) 
( 0804,ECC0 )                 dl N_(FORWARD 0 
( 0804,ECC8 )   :H_(FORWARD   dl X_HERE X__ 
( 0804,ECD0 )                 dl X_, semis 

( 0804,ECD8 )   :N_FORWARD)   d$  8  0  0  0  "FORWARD)"

( 0804,ECE4 )   :X_FORWARD)   dl docol H_FORWARD) 0 X_(FORWARD 
( 0804,ECF4 )                 dl N_FORWARD) 0 
( 0804,ECFC )   :H_FORWARD)   dl X_HERE X_OVER 
( 0804,ED04 )                 dl X_CELL+ X_- X_SWAP X_! 
( 0804,ED14 )                 dl semis 

( 0804,ED18 )   :N_BEGIN   d$  5  0  0  0  "BEGIN" 90 
( 0804,ED22 )                 d$  90  90 

( 0804,ED24 )   :X_BEGIN   dl docol H_BEGIN H_U0 X_FORWARD) 
( 0804,ED34 )                 dl N_BEGIN 0 
( 0804,ED3C )   :H_BEGIN   dl X_(BACK X_?COMP 
( 0804,ED44 )                 dl X_1 semis 

( 0804,ED4C )   :N_THEN   d$  4  0  0  0  "THEN"

( 0804,ED54 )   :X_THEN   dl docol H_THEN H_U0 X_BEGIN 
( 0804,ED64 )                 dl N_THEN 0 
( 0804,ED6C )   :H_THEN   dl X_?COMP X_2 
( 0804,ED74 )                 dl X_?PAIRS X_FORWARD) semis 

( 0804,ED80 )   :N_DO   d$  2  0  0  0  "DO" 90 
( 0804,ED87 )                 d$  90 

( 0804,ED88 )   :X_DO   dl docol H_DO H_U0 X_THEN 
( 0804,ED98 )                 dl N_DO 0 
( 0804,EDA0 )   :H_DO   dl X_LIT X_(DO) 
( 0804,EDA8 )                 dl X_, X_(FORWARD X_(BACK X_LIT 
( 0804,EDB8 )                 dl 3 semis 

( 0804,EDC0 )   :N_?DO   d$  3  0  0  0  "?DO" 90 

( 0804,EDC8 )   :X_?DO   dl docol H_?DO H_U0 X_DO 
( 0804,EDD8 )                 dl N_?DO 0 
( 0804,EDE0 )   :H_?DO   dl X_LIT X_(?DO) 
( 0804,EDE8 )                 dl X_, X_(FORWARD X_(BACK X_LIT 
( 0804,EDF8 )                 dl 3 semis 

( 0804,EE00 )   :N_LOOP   d$  4  0  0  0  "LOOP"

( 0804,EE08 )   :X_LOOP   dl docol H_LOOP H_U0 X_?DO 
( 0804,EE18 )                 dl N_LOOP 0 
( 0804,EE20 )   :H_LOOP   dl X_LIT 3 
( 0804,EE28 )                 dl X_?PAIRS X_LIT X_(LOOP) X_, 
( 0804,EE38 )                 dl X_BACK) X_FORWARD) semis 

( 0804,EE44 )   :N_+LOOP   d$  5  0  0  0  "+LOOP" 90 
( 0804,EE4E )                 d$  90  90 

( 0804,EE50 )   :X_+LOOP   dl docol H_+LOOP H_U0 X_LOOP 
( 0804,EE60 )                 dl N_+LOOP 0 
( 0804,EE68 )   :H_+LOOP   dl X_LIT 3 
( 0804,EE70 )                 dl X_?PAIRS X_LIT X_(+LOOP) X_, 
( 0804,EE80 )                 dl X_BACK) X_FORWARD) semis 

( 0804,EE8C )   :N_UNTIL   d$  5  0  0  0  "UNTIL" 90 
( 0804,EE96 )                 d$  90  90 

( 0804,EE98 )   :X_UNTIL   dl docol H_UNTIL H_U0 X_+LOOP 
( 0804,EEA8 )                 dl N_UNTIL 0 
( 0804,EEB0 )   :H_UNTIL   dl X_1 X_?PAIRS 
( 0804,EEB8 )                 dl X_LIT X_0BRANCH X_, X_BACK) 
( 0804,EEC8 )                 dl semis 

( 0804,EECC )   :N_AGAIN   d$  5  0  0  0  "AGAIN" 90 
( 0804,EED6 )                 d$  90  90 

( 0804,EED8 )   :X_AGAIN   dl docol H_AGAIN H_U0 X_UNTIL 
( 0804,EEE8 )                 dl N_AGAIN 0 
( 0804,EEF0 )   :H_AGAIN   dl X_1 X_?PAIRS 
( 0804,EEF8 )                 dl X_LIT X_BRANCH X_, X_BACK) 
( 0804,EF08 )                 dl semis 

( 0804,EF0C )   :N_REPEAT   d$  6  0  0  0  "REPEAT" 90 
( 0804,EF17 )                 d$  90 

( 0804,EF18 )   :X_REPEAT   dl docol H_REPEAT H_U0 X_AGAIN 
( 0804,EF28 )                 dl N_REPEAT 0 
( 0804,EF30 )   :H_REPEAT   dl X_1 X_?PAIRS 
( 0804,EF38 )                 dl X_LIT X_BRANCH X_, X_BACK) 
( 0804,EF48 )                 dl X_?COMP X_LIT H_U0 X_?PAIRS 
( 0804,EF58 )                 dl X_FORWARD) semis 

( 0804,EF60 )   :N_IF   d$  2  0  0  0  "IF" 90 
( 0804,EF67 )                 d$  90 

( 0804,EF68 )   :X_IF   dl docol H_IF H_U0 X_REPEAT 
( 0804,EF78 )                 dl N_IF 0 
( 0804,EF80 )   :H_IF   dl X_LIT X_0BRANCH 
( 0804,EF88 )                 dl X_, X_(FORWARD X_2 semis 

( 0804,EF98 )   :N_ELSE   d$  4  0  0  0  "ELSE"

( 0804,EFA0 )   :X_ELSE   dl docol H_ELSE H_U0 X_IF 
( 0804,EFB0 )                 dl N_ELSE 0 
( 0804,EFB8 )   :H_ELSE   dl X_?COMP X_2 
( 0804,EFC0 )                 dl X_?PAIRS X_LIT X_BRANCH X_, 
( 0804,EFD0 )                 dl X_(FORWARD X_SWAP X_FORWARD) X_2 
( 0804,EFE0 )                 dl semis 

( 0804,EFE4 )   :N_WHILE   d$  5  0  0  0  "WHILE" 90 
( 0804,EFEE )                 d$  90  90 

( 0804,EFF0 )   :X_WHILE   dl docol H_WHILE H_U0 X_ELSE 
( 0804,F000 )                 dl N_WHILE 0 
( 0804,F008 )   :H_WHILE   dl X_>R X_>R 
( 0804,F010 )                 dl X_LIT X_0BRANCH X_, X_(FORWARD 
( 0804,F020 )                 dl X_LIT H_U0 X_R> X_R> 
( 0804,F030 )                 dl semis 

( 0804,F034 )   :N_SPACES   d$  6  0  0  0  "SPACES" 90 
( 0804,F03F )                 d$  90 

( 0804,F040 )   :X_SPACES   dl docol H_SPACES 0 X_WHILE 
( 0804,F050 )                 dl N_SPACES 0 
( 0804,F058 )   :H_SPACES   dl X_0 X_MAX 
( 0804,F060 )                 dl X_0 X_(?DO) H_R0 X_SPACE 
( 0804,F070 )                 dl X_(LOOP) -C semis 

( 0804,F07C )   :N_<#   d$  2  0  0  0  "<#" 90 
( 0804,F083 )                 d$  90 

( 0804,F084 )   :X_<#   dl docol H_<# 0 X_SPACES 
( 0804,F094 )                 dl N_<# 0 
( 0804,F09C )   :H_<#   dl X_PAD X_HLD 
( 0804,F0A4 )                 dl X_! semis 

( 0804,F0AC )   :N_#>   d$  2  0  0  0  "#>" 90 
( 0804,F0B3 )                 d$  90 

( 0804,F0B4 )   :X_#>   dl docol H_#> 0 X_<# 
( 0804,F0C4 )                 dl N_#> 0 
( 0804,F0CC )   :H_#>   dl X_DROP X_DROP 
( 0804,F0D4 )                 dl X_HLD X_@ X_PAD X_OVER 
( 0804,F0E4 )                 dl X_- semis 

( 0804,F0EC )   :N_SIGN   d$  4  0  0  0  "SIGN"

( 0804,F0F4 )   :X_SIGN   dl docol H_SIGN 0 X_#> 
( 0804,F104 )                 dl N_SIGN 0 
( 0804,F10C )   :H_SIGN   dl X_0< X_0BRANCH 
( 0804,F114 )                 dl H_R0 X_LIT 2D X_HOLD 
( 0804,F124 )                 dl semis 

( 0804,F128 )   :N_#   d$  1  0  0  0  &# 90 
( 0804,F12E )                 d$  90  90 

( 0804,F130 )   :X_#   dl docol H_# 0 X_SIGN 
( 0804,F140 )                 dl N_# 0 
( 0804,F148 )   :H_#   dl X_BASE X_@ 
( 0804,F150 )                 dl X_M/MOD X_ROT X_LIT 9 
( 0804,F160 )                 dl X_OVER X_< X_0BRANCH H_R0 
( 0804,F170 )                 dl X_LIT 7 X_+ X_LIT 
( 0804,F180 )                 dl H_WHERE X_+ X_HOLD semis 

( 0804,F190 )   :N_#S   d$  2  0  0  0  "#S" 90 
( 0804,F197 )                 d$  90 

( 0804,F198 )   :X_#S   dl docol H_#S 0 X_# 
( 0804,F1A8 )                 dl N_#S 0 
( 0804,F1B0 )   :H_#S   dl X_# X_OVER 
( 0804,F1B8 )                 dl X_OVER X_OR X_0= X_0BRANCH 
( 0804,F1C8 )                 dl -1C semis 

( 0804,F1D0 )   :N_(D.R)   d$  5  0  0  0  "(D.R)" 90 
( 0804,F1DA )                 d$  90  90 

( 0804,F1DC )   :X_(D.R)   dl docol H_(D.R) 0 X_#S 
( 0804,F1EC )                 dl N_(D.R) 0 
( 0804,F1F4 )   :H_(D.R)   dl X_>R X_SWAP 
( 0804,F1FC )                 dl X_OVER X_DABS X_<# X_#S 
( 0804,F20C )                 dl X_ROT X_SIGN X_#> X_R> 
( 0804,F21C )                 dl X_OVER X_- X_0 X_MAX 
( 0804,F22C )                 dl X_0 X_(?DO) H_TIB X_BL 
( 0804,F23C )                 dl X_HOLD X_(LOOP) -10 X_#> 
( 0804,F24C )                 dl semis 

( 0804,F250 )   :N_D.R   d$  3  0  0  0  "D.R" 90 

( 0804,F258 )   :X_D.R   dl docol H_D.R 0 X_(D.R) 
( 0804,F268 )                 dl N_D.R 0 
( 0804,F270 )   :H_D.R   dl X_(D.R) X_TYPE 
( 0804,F278 )                 dl semis 

( 0804,F27C )   :N_.R   d$  2  0  0  0  ".R" 90 
( 0804,F283 )                 d$  90 

( 0804,F284 )   :X_.R   dl docol H_.R 0 X_D.R 
( 0804,F294 )                 dl N_.R 0 
( 0804,F29C )   :H_.R   dl X_>R X_S>D 
( 0804,F2A4 )                 dl X_R> X_D.R semis 

( 0804,F2B0 )   :N_D.   d$  2  0  0  0  "D." 90 
( 0804,F2B7 )                 d$  90 

( 0804,F2B8 )   :X_D.   dl docol H_D. 0 X_.R 
( 0804,F2C8 )                 dl N_D. 0 
( 0804,F2D0 )   :H_D.   dl X_0 X_D.R 
( 0804,F2D8 )                 dl X_SPACE semis 

( 0804,F2E0 )   :N_.   d$  1  0  0  0  &. 90 
( 0804,F2E6 )                 d$  90  90 

( 0804,F2E8 )   :X_.   dl docol H_. 0 X_D. 
( 0804,F2F8 )                 dl N_. 0 
( 0804,F300 )   :H_.   dl X_S>D X_D. 
( 0804,F308 )                 dl semis 

( 0804,F30C )   :N_?   d$  1  0  0  0  &? 90 
( 0804,F312 )                 d$  90  90 

( 0804,F314 )   :X_?   dl docol H_? 0 X_. 
( 0804,F324 )                 dl N_? 0 
( 0804,F32C )   :H_?   dl X_@ X_. 
( 0804,F334 )                 dl semis 

( 0804,F338 )   :N_U.   d$  2  0  0  0  "U." 90 
( 0804,F33F )                 d$  90 

( 0804,F340 )   :X_U.   dl docol H_U. 0 X_? 
( 0804,F350 )                 dl N_U. 0 
( 0804,F358 )   :H_U.   dl X_0 X_D. 
( 0804,F360 )                 dl semis 

( 0804,F364 )   :N_FOR-WORDS   d$  ^I 0  0  0  "FOR-WORDS" 90 
( 0804,F372 )                 d$  90  90 

( 0804,F374 )   :X_FOR-WORDS   dl docol H_FOR-WORDS 0 X_U. 
( 0804,F384 )                 dl N_FOR-WORDS 0 
( 0804,F38C )   :H_FOR-WORDS   dl X_SWAP X_>R 
( 0804,F394 )                 dl X_>R X_R> X_R@ X_OVER 
( 0804,F3A4 )                 dl X_>LFA X_@ X_>R X_EXECUTE 
( 0804,F3B4 )                 dl X_R@ X_0= X_0BRANCH -2C 
( 0804,F3C4 )                 dl X_RDROP X_RDROP semis 

( 0804,F3D0 )   :N_FOR-VOCS   d$  8  0  0  0  "FOR-VOCS"

( 0804,F3DC )   :X_FOR-VOCS   dl docol H_FOR-VOCS 0 X_FOR-WORDS 
( 0804,F3EC )                 dl N_FOR-VOCS 0 
( 0804,F3F4 )   :H_FOR-VOCS   dl X_>R X_VOC-LINK 
( 0804,F3FC )                 dl X_@ X_>R X_R> X_R@ 
( 0804,F40C )                 dl X_OVER X_>VFA X_@ X_>R 
( 0804,F41C )                 dl X_EXECUTE X_R@ X_0= X_0BRANCH 
( 0804,F42C )                 dl -2C X_RDROP X_RDROP semis 

( 0804,F43C )   :N_WORDS   d$  5  0  0  0  "WORDS" 90 
( 0804,F446 )                 d$  90  90 

( 0804,F448 )   :X_WORDS   dl docol H_WORDS 0 X_FOR-VOCS 
( 0804,F458 )                 dl N_WORDS 0 
( 0804,F460 )   :H_WORDS   dl X_C/L X_OUT 
( 0804,F468 )                 dl X_! X_LIT X_ID. X_CONTEXT 
( 0804,F478 )                 dl X_@ X_FOR-WORDS semis 

( 0804,F484 )   :N_EXIT-CODE   d$  ^I 0  0  0  "EXIT-CODE" 90 
( 0804,F492 )                 d$  90  90 

( 0804,F494 )   :X_EXIT-CODE   dl dovar H_EXIT-CODE 0 X_WORDS 
( 0804,F4A4 )                 dl N_EXIT-CODE 0 

( 0804,F4AC )   :H_EXIT-CODE   d$  0  0  0  0 

( 0804,F4B0 )   :N_BYE   d$  3  0  0  0  "BYE" 90 

( 0804,F4B8 )   :X_BYE   dl docol H_BYE 0 X_EXIT-CODE 
( 0804,F4C8 )                 dl N_BYE 0 
( 0804,F4D0 )   :H_BYE   dl X_EXIT-CODE X_@ 
( 0804,F4D8 )                 dl X__ X__ X_1 X_LINOS 
( 0804,F4E8 )                 dl semis 

( 0804,F4EC )   :N_LIST   d$  4  0  0  0  "LIST"

( 0804,F4F4 )   :X_LIST   dl docol H_LIST 0 X_BYE 
( 0804,F504 )                 dl N_LIST 0 
( 0804,F50C )   :H_LIST   dl X_SCR X_! 
( 0804,F514 )                 dl X_SKIP 6 
( 0804,F51C )   :L0804,F51C   dl 2052,4353 9090,2023 
( 0804,F524 )                 dl X_LIT L0804,F51C X_LIT 6 
( 0804,F534 )                 dl X_TYPE X_BASE X_@ X_DECIMAL 
( 0804,F544 )                 dl X_SCR X_@ X_. X_BASE 
( 0804,F554 )                 dl X_! X_SCR X_@ X_BLOCK 
( 0804,F564 )                 dl X_LIT H_B/BUF X_LIT 0A 
( 0804,F574 )                 dl X_$S X_CR X_TYPE X_OVER 
( 0804,F584 )                 dl X_0= X_0BRANCH -24 X_2DROP 
( 0804,F594 )                 dl semis 

( 0804,F598 )   :N_INDEX   d$  5  0  0  0  "INDEX" 90 
( 0804,F5A2 )                 d$  90  90 

( 0804,F5A4 )   :X_INDEX   dl docol H_INDEX 0 X_LIST 
( 0804,F5B4 )                 dl N_INDEX 0 
( 0804,F5BC )   :H_INDEX   dl X_LIT H_R0 
( 0804,F5C4 )                 dl X_EMIT X_CR X_1+ X_SWAP 
( 0804,F5D4 )                 dl X_(DO) H_C/L X_CR X_I 
( 0804,F5E4 )                 dl X_LIT 3 X_.R X_SPACE 
( 0804,F5F4 )                 dl X_0 X_I X_(LINE) X_TYPE 
( 0804,F604 )                 dl X_KEY? X_0BRANCH H_U0 X_LEAVE 
( 0804,F614 )                 dl X_(LOOP) -40 semis 

( 0804,F620 )   :N_.S   d$  2  0  0  0  ".S" 90 
( 0804,F627 )                 d$  90 

( 0804,F628 )   :X_.S   dl docol H_.S 0 X_INDEX 
( 0804,F638 )                 dl N_.S 0 
( 0804,F640 )   :H_.S   dl X_CR X_LIT 
( 0804,F648 )                 dl 53 X_EMIT X_LIT 5B 
( 0804,F658 )                 dl X_EMIT X_SPACE X_DSP@ X_S0 
( 0804,F668 )                 dl X_@ X_OVER X_OVER X_= 
( 0804,F678 )                 dl X_0= X_0BRANCH H_FENCE X_0 
( 0804,F688 )                 dl X_CELL+ X_- X_DUP X_@ 
( 0804,F698 )                 dl X_. X_BRANCH -38 X_DROP 
( 0804,F6A8 )                 dl X_DROP X_LIT 5D X_EMIT 
( 0804,F6B8 )                 dl semis 

( 0804,F6BC )   :N_ENVIRONMENT?   d$  ^L 0  0  0  "ENVIRONMENT?"

( 0804,F6CC )   :X_ENVIRONMENT?   dl docol H_ENVIRONMENT? 0 X_.S 
( 0804,F6DC )                 dl N_ENVIRONMENT? 0 
( 0804,F6E4 )   :H_ENVIRONMENT?   dl X_LIT X_ENVIRONMENT 
( 0804,F6EC )                 dl X_>WID X_(FIND) X_>R X_2DROP 
( 0804,F6FC )                 dl X_R> X_DUP X_0BRANCH H_R0 
( 0804,F70C )                 dl X_EXECUTE X_LIT -1 semis 

( 0804,F71C )   :N_TRIAD   d$  5  0  0  0  "TRIAD" 90 
( 0804,F726 )                 d$  90  90 

( 0804,F728 )   :X_TRIAD   dl docol H_TRIAD 0 X_ENVIRONMENT? 
( 0804,F738 )                 dl N_TRIAD 0 
( 0804,F740 )   :H_TRIAD   dl X_LIT H_R0 
( 0804,F748 )                 dl X_EMIT X_LIT 3 X_/ 
( 0804,F758 )                 dl X_LIT 3 X_* X_LIT 
( 0804,F768 )                 dl 3 X_OVER X_+ X_SWAP 
( 0804,F778 )                 dl X_(DO) H_DP X_CR X_I 
( 0804,F788 )                 dl X_LIST X_KEY? X_0BRANCH H_U0 
( 0804,F798 )                 dl X_LEAVE X_(LOOP) -24 X_CR 
( 0804,F7A8 )                 dl X_0 X_MESSAGE semis 

( 0804,F7B4 )   :N_.SIGNON   d$  7  0  0  0  ".SIGNON" 90 

( 0804,F7C0 )   :X_.SIGNON   dl docol H_.SIGNON 0 X_TRIAD 
( 0804,F7D0 )                 dl N_.SIGNON 0 
( 0804,F7D8 )   :H_.SIGNON   dl X_CR X_BASE 
( 0804,F7E0 )                 dl X_@ X_LIT H_DP X_BASE 
( 0804,F7F0 )                 dl X_! X_CPU X_D. X_BASE 
( 0804,F800 )                 dl X_! X_NAME X_TYPE X_SPACE 
( 0804,F810 )                 dl X_VERSION X_TYPE X_SPACE X_CR 
( 0804,F820 )                 dl semis 

( 0804,F824 )   :N_TASK   d$  4  0  0  0  "TASK"

( 0804,F82C )   :last_dea :X_TASK   dl docol H_TASK 0 X_.SIGNON 
( 0804,F83C )                 dl N_TASK 0 
( 0804,F844 )   :H_TASK   dl semis 

( 0804,F848 )   :_end   d$  0  "The Netwide Assembler 0.98" 0 
( 0804,F864 )                 d$  0  ".shstrtab" 0 
( 0804,F86F )                 d$  ".bss" 0 
( 0804,F874 )                 d$  "dictionary" 0 
( 0804,F87F )                 d$  ".comment" 0 
( 0804,F888 )                 d$  "forth" 0 
( 0804,F88E )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,F89E )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
( 0804,F8AE )                 d$  0  0  0  0  0  0  0  0  0  0  0B  0  0  0  1  0 
( 0804,F8BE )                 d$  0  0  1  0  0  0  &H 0F8 
( 0804,F8C6 )                 d$  4  8  "Hh" 0 
( 0804,F8CB )                 d$  0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0 
( 0804,F8DB )                 d$  0  0  0  0  0  10  0  0  0  8  0  0  0  7  0  0 
( 0804,F8EB )                 d$  0  &H 0F8 
( 0804,F8EE )                 d$  4  8  "Hh" 0 
( 0804,F8F3 )                 d$  0  &0 98 
( 0804,F8F6 )                 d$  0FF  3  0  0  0  0  0  0  0  0  1  0  0  0  0  0 
( 0804,F906 )                 d$  0  0  1B  0  0  0  1  0  0  0  0  0  0  0  0  0 
( 0804,F916 )                 d$  0  0  "Hh" 0 
( 0804,F91B )                 d$  0  1C  0  0  0  0  0  0  0  0  0  0  0  1  0  0 
( 0804,F92B )                 d$  0  0  0  0  0  &$ 0 
( 0804,F932 )                 d$  0  0  1  0  0  0  7  0  0  0  &t 90 
( 0804,F93E )                 d$  4  8  &t 0 
( 0804,F942 )                 d$  0  0  0D4  &g 0 
( 0804,F947 )                 d$  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0 
( 0804,F957 )                 d$  0  1  0  0  0  3  0  0  0  0  0  0  0  0  0  0 
( 0804,F967 )                 d$  0  "dh" 0 
( 0804,F96B )                 d$  0  &* 0 
( 0804,F96E )                 d$  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0 
( 0804,F97E )                 d$  0  0 

( 0804,F980 )               
