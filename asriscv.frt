( $Id: asriscv.frt,v 1.7 2025/10/27 23:40:53 albert Exp $)
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Reference Alpha Architecture Handbook Order Number EX-QD2KC-TE )
( Also down loadable as .pdf file from dec sites.                       )

\ Define % as a prefix for binary. Despite . it is single.
\ 'ONLY >WID CURRENT !
: %% BASE @ >R 2 BASE ! (NUMBER) R> BASE ! DROP POSTPONE LITERAL ;
PREFIX IMMEDIATE                     DEFINITIONS

( ############## RISCV ASSEMBLER PROPER ################################ )
ASSEMBLER DEFINITIONS  HEX

(  General note. The order of this source matters, if only for          )
(  cosmetic reasons. Although all parts of an instruction can be        )
(  ordered arbitrarily, this source is organised in order to make the   )
(  disassembly pleasant to read.                                        )

\ Template
\ %%00000000.00000.00000.000.00000.0000000

%%0000000.11111.11111.000.11111.0000000 CONSTANT r-mask   \ r% r> >r
%%0000001.11111.11111.000.11111.0000000 CONSTANT sa-mask   \ sa r> >r
%%1111111.11111.11111.000.11111.0000000 CONSTANT i-mask   \ ## r> >r
%%1111111.11111.11111.000.11111.0000000 CONSTANT b-mask   \ im/2 r% r.
%%1111111.11111.11111.111.11111.0000000 CONSTANT u-mask   \ im24 >r .

%%0000000.00000.00000.000.11111.0000000  CONSTANT >r-mask
%%0000000.00000.11111.000.00000.0000000  CONSTANT r>-mask
%%0000000.11111.00000.000.00000.0000000  CONSTANT r%-mask

( Meaning of the bits in TALLY-BA :                                     )
\ *    0000,0001 Interesting required       0000,0002 Instruction part isn't
\ *    0000,0004 32 bit also                0000,0008 64 bit only
\ *    0000,0010 >R register                0000,0020 immediate data  br#2|
\ *   0000,0040  R> register               0000,0080 immediate data in rs1
\ *   0000,0100  R% register               0000,0200 data in rs2
\ *   0000,0400  no shift instruction       0000,0800 shift data
\ *   0000,1000 20 bits number             0000,2000 no 20 bits number
\ *   0000,4000 uim number                 0000,8000 no uim bits number

\ For DEA set and individual MASK to bad (or back).
: !BAD    SWAP >BA SWAP TOGGLE ;
: !IS64   >BA 0C TOGGLE ;
( ***************************** register fixups *********************** )
\ Note all registers are set to uninteresting by default.
\ Otherwise a ``SHOW:'' would generate 32^3 lines.

12 0  >r-mask  T!
\ The destination register
80 0 20 xFAMILY|
  >Rz >R1 >R2 >R3 >R4 >R5 >R6 >R7 >R8 >R9 >R10 >R11 >R12 >R13 >R14 >R15 >R16
  >R17 >R18 >R19 >R20 >R21 >R22 >R23 >R24 >R25 >R26 >R27 >R28 >R29 >R30 >R31

\
\ The primary source register
42  0  r>-mask  T!
8000 0 20 xFAMILY|
    Rz> R1> R2> R3> R4> R5> R6> R7> R8> R9> R10> R11> R12> R13> R14> R15> R16>
    R17> R18> R19> R20> R21> R22> R23> R24> R25> R26> R27> R28> R29> R30> R31>

102  0  r%-mask  T!
\ The secondary register
100000 0 20 xFAMILY|
   Rz% R1% R2% R3% R4% R5% R6% R7% R8% R9% R10% R11% R12% R13% R14% R15% R16%
   R17% R18% R19% R20% R21% R22% R23% R24% R25% R26% R27% R28% R29% R30% R31%
\
( Toggle some register fixup's back to interesting, i.e. make it show   )
( up in disassembly.                                                    )
' >R1 2 !BAD             ' >R7 2 !BAD             ' >Rz 2 !BAD
' R1> 2 !BAD             ' R7> 2 !BAD             ' Rz> 2 !BAD
' R1% 2 !BAD             ' R7% 2 !BAD             ' Rz% 2 !BAD

: DFIs DFI ;
2000 0  FE00,0000 19 DFIs sd7|
20 0  0000,0F80 7 DFIs br#2|
\ The two register instructions. Format I , load
1200 0  FFF0,0000 14 DFIs sd#| \ signed data / offset
4080 0  000F,8000 0F DFIs uim#| \ data for CSR

\ One register instruction, for now, missing data fixup.
1000 0 FFFF,F000 0C DFI n#|    ( 20 bits number built in)
1254 0  u-mask %%0110111 4PI LUI,
1254 0  u-mask %%0010111 4PI AUIPC,
1254 0  u-mask %%1101111 4PI JAL,


A164 0 b-mask T!                 \ br#
%%1.00000.0000000 %%000.00000.1100011 8
    4FAMILY, BEQ, BNE, -- -- BLT, BGE, BLTU, BGEU,

\ The two register instructions. Format I
9654 0  i-mask        %%1100111 4PI JALR,


9654 0  i-mask T!    \ sd#|
%%1.00000.0000000 %%000.00000.0000011 7
    4FAMILY, LB, LH, LW, LD, LBU, LHU, LWU,
    'LD, !IS64    'LWU, !IS64
564 0  b-mask T!
%%1.00000.0000000 %%000.00000.0100011 4
    4FAMILY, SB, SH, SW, SD,
    'SD, !IS64


9654 0  i-mask T!        \ sd#|
%%1.00000.0000000 %%000.00000.0010011 8
    4FAMILY, ADDI, -- SLTI, SLTIU, XORI, -- ORI, ANDI,


\ The two register instructions. Format sa, shift
\ Take 6 bits for the offset even for 32 bits instruction.
800 0  03F0,0000 14 DFIs shift#| \ signed data / offset


\ R% is a shamt field
A54 0 sa-mask %%0000000.00000.00000.001.00000.0010011 4PI SLLI,
A54 0 sa-mask %%0000000.00000.00000.101.00000.0010011 4PI SRLI,
A54 0 sa-mask %%0100000.00000.00000.101.00000.0010011 4PI SRAI,
\ Note: Those instruction are in the 32I base and in 64I Base.
\ Maybe their interpretation is slightly different.

9654 0  i-mask  %%0000000.00000.00000.000.00000.0011011 4PI ADDIW, \ sd#|

A58 0 sa-mask %%0000000.00000.00000.001.00000.0110011 4PI SLLIW,
A58 0 sa-mask %%0000000.00000.00000.101.00000.0110011 4PI SRLIW,
A58 0 sa-mask %%0100000.00000.00000.101.00000.0110011 4PI SRAIW,

\ Regular three reg instructions
554 0 r-mask %%0100000.00000.00000.000.00000.0110011 4PI SUB,
554 0 r-mask %%0100000.00000.00000.101.00000.0110011 4PI SRA,

554 0 r-mask T!
%%1.00000.0000000 %%0000000.00000.00000.000.00000.0110011 8
     4FAMILY, ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND,

558 0 r-mask T!
%%1.00000.0000000 %%0000000.00000.00000.000.00000.0111011 6
     4FAMILY, ADDW, SLLW, -- -- -- SRLW,
558 0 r-mask %%0100000.00000.00000.000.00000.0111011 4PI SUBW,
558 0 r-mask %%0100000.00000.00000.101.00000.0111011 4PI SRAW,

9654 0 i-mask  %%0000000.00000.00000.000.00000.0001111 4PI FENCE,
9658 0 i-mask  %%0000000.00000.00000.001.00000.0001111 4PI FENCEI,
4 0 0 %%0000000.00000.00000.000.00000.1110011 4PI ECALL,
4 0 0 %%0000001.00000.00000.000.00000.1110011 4PI EBREAK,

\ R32 Zicsr standard extension
9654 0 i-mask T!
%%1.00000.0000000 %%0000000.00000.00000.000.00000.1111011 4
     4FAMILY, -- CSRRW, CSRRS, CSRRC,
5694 0 i-mask T!
%%1.00000.0000000 %%0000000.00000.00000.100.00000.1111011 4
     4FAMILY, -- CSRRWI, CSRRSI, CSRRCI,
\ R32M Multiplication and division
554 0 r-mask T!
%%1.00000.0000000 %%0000001.00000.00000.000.00000.0110011 8
     4FAMILY, MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU,
\ RV64M Multiplication and division
558 0 r-mask T!
%%1.00000.0000000 %%0000001.00000.00000.000.00000.0111011 8
     4FAMILY, MULW, --    --      --     DIVW, DIVUW, REMW, REMUW,

\ ---------------- All the pseudo stuff comes here. -------------------------
\ We count the offset in bytes. 13 bits.
: br#|  1 AND 40 ?ERROR 1 RSHIFT DUP 1F AND br#2| 16 LSHIFT sd7| ;


\ ---------------- All the pseudo stuff end -------------------------

4 I-ALIGNMENT !

\ Toggle the bit that suppress uninteresting instructions in the disassembly.
: TOGGLE-TRIM    BA-DEFAULT 1 TOGGLE ;
\
: SHOW:   TOGGLE-TRIM SHOW: TOGGLE-TRIM ;
: SHOW-ALL   TOGGLE-TRIM SHOW-ALL TOGGLE-TRIM ;

PREVIOUS DEFINITIONS
DECIMAL
