( $Id: asi386.frt,v 4.33 2018/10/09 22:13:55 albert Exp $ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)

\ For the redefinitions in connection with SIB.
WANT :2

 ASSEMBLER DEFINITIONS HEX

( ############## 80386 ASSEMBLER ADDITIONS ############################ )
( These definitions are such that they work regardless of the endianness)
( of the host. Lay down word {16 bits} and long {32} bits constants.    )
: (W,) lsbyte, lsbyte, DROP ;
: (L,) lsbyte, lsbyte, lsbyte, lsbyte, DROP ;

( ############## 80386 ASSEMBLER PROPER ############################### )
( The decreasing BY means that a decompiler hits them in the right      )
( order to reassemble.                                                  )
( Fields: a disassembly XT,      LENGTH to comma, the BA BY information )
( and the XT that puts data in the dictionary.                          )
( Where there is a placeholder ``_'' the execution token is filled in   )
( later. )
(   CNT                                                                 )
( XT   BA   BY     XT-AS          NAME                                  )
  00 02  0000 00,0100 ' (W,) COMMAER OW,    ( obligatory word     )
  00 04  8000 00,0080 ' (L,) COMMAER (RL,)  ( cell relative to IP )
  00 02  4000 00,0080 ' (W,) COMMAER (RW,)  ( cell relative to IP )
  00 01  0000 00,0040 ' AS-C, COMMAER (RB,) ( byte relative to IP )
  00 02  0000 00,0020 ' (W,) COMMAER SG,    (  Segment: WORD      )
  00 01  0000 00,0010 ' AS-C, COMMAER P,    ( port number ; byte     )
  00 01  0000 00,0008 ' AS-C, COMMAER IS,   ( Single -obl-  byte )
  00 04 20002 00,0004 ' (L,) COMMAER IL,    ( immediate data : cell)
  00 02 10002 00,0004 ' (W,) COMMAER IW,    ( immediate data : cell)
  00 01  0001 00,0004 ' AS-C, COMMAER IB,   ( immediate byte data)
  00 04  8008 00,0002 ' (L,) COMMAER L,     ( immediate data : address/offset )
  00 02  4008 00,0002 ' (W,) COMMAER W,     ( immediate data : address/offset )
  00 01  0004 00,0002 ' AS-C, COMMAER B,    ( immediate byte : address/offset )
  _ 01  0000 00,0001 _    COMMAER SIB,, ( An instruction with in an instruction )


( Meaning of the bits in TALLY-BA :                                     )
( Inconsistent:  0001 OPERAND IS BYTE     0002 OPERAND IS CELL  W/L     )
(                0004 OFFSET  IS BYTE     0008 OFFSET  IS CELL  W/L
( By setting 0020 an opcode can force a memory reference, e.g. CALLFARO )
(               0010 Register op         0020 Memory op                 )
(               0040 ZO|                 0080 [BP]% {16} [BP] [BP  {32} )
(  sib:         0100 no ..             0200 [AX +8*| DI]                )
(  logical      0400 no ..             0800 Y| Y'| Z| Z'|               )
(  segment      1000 no ..             2000 ES| ..                      )
(  AS:          4000 16 bit Addr       8000 32 bit Address              )
(  OS:         01,0000 16 bit Op      02,0000 32 bit Operand              )
(  Use debug   04,0000 no ..          08,0000 CR0 ..DB0                   )
(  FP:        10,0000 FP-specific   20,0000 Not FP                      )
\
\ The following is probably superfluous using 500/800
\ anyway           better solved with a ghost bit in SET,
(            400,0000  X| B|       800,0000 Y'| N'| SET,                )
( Names *ending* in percent BP|% -- not BP'| the prime registers -- are )
( only valid for 16 bits mode, or with an address overwite. Use W, L,   )
( appropriately.                                                        )

8200 00 38 T!
 08 00 8 FAMILY|R AX] CX] DX] BX] 0] BP] SI] DI]
8200 00 C0 T!
 40 00 4 FAMILY|R  +1* +2* +4* +8*
80 GO!
8200 00 07 T!
 01 00 8 FAMILY|R [AX [CX [DX [BX [SP -- [SI [DI
8280 00 07 05 FIR [BP   ( Fits in the hole, but disallow ZO| )
8248 02 07 05 FIR [MEM  ( Fits in the hole, but requires ZO| )
00 GO!

4120 00 07 T!
  01 00 08
    FAMILY|R [BX+SI]% [BX+DI]% [BP+SI]% [BP+DI]% [SI]% [DI]% -- [BX]%
40A0 0000 07 06 FIR [BP]%  ( Fits in the hole, safe inconsistency check)
8120 00 07 T!
 01 00 4 FAMILY|R [AX] [CX] [DX] [BX]
8120 01 07 04 FIR ~SIB|   ( Fits in the hole, but requires ~SIB, )
81A0 00 07 05 FIR [BP]   ( Fits in the hole, but disallow ZO| )
8120 00 07 T!
 01 06 2 FAMILY|R [SI] [DI]

20,0111 00 07 T!
 01 00 8 FAMILY|R AL| CL| DL| BL| AH| CH| DH| BH|
20,0112 00 07 T!
 01 00 8 FAMILY|R AX| CX| DX| BX| SP| BP| SI| DI|
0160 00 C0 00 FIR      ZO|
0124 02 C0 40 FIR      BO|
0128 02 C0 80 FIR      XO|
20,0110 00 C0 C0 FIR      R|
20,4048 02 C7 06 FIR      MEM|% ( Overrules ZO| [BP]% )
20,8108 02 C7 05 FIR      MEM| ( Overrules ZO| [BP] )

24,1101 0000 38 T!
 08 00 8 FAMILY|R AL'| CL'| DL'| BL'| AH'| CH'| DH'| BH'|
24,1102 0000 38 T!
 08 00 8 FAMILY|R AX'| CX'| DX'| BX'| SP'| BP'| SI'| DI'|
24,2100 0000  38 T!   08 00 6 FAMILY|R ES| CS| SS| DS| FS| GS|
28,0002 0000 0138 T!   ( 3)
 08 00 5 FAMILY|R CR0| -- CR2| CR3| CR4|                 ( 3)
 0008 0100 8 FAMILY|R DR0| DR1| DR2| DR3| DR4| DR5| DR6| DR7| ( 3)

0020,0000 0000 0200 T!  0200 00 2 FAMILY|R F| T|
0024,0401 0000 0100 0000 FIR B|
0024,0402 0000 0100 0100 FIR X|

( --------- These must be found last -------)
80 GO!
0600 00 FF 0000 1PI ~SIB,
00 GO!
( --------- two fixup operands ----------)
0004,1400 0000 FF03 T!
 0008 0000 8 2FAMILY, ADD, OR, ADC, SBB, AND, SUB, XOR, CMP,
0004,1400 0000 FF01 T!
 0002 0084 2 2FAMILY, TEST, XCHG,
0404,1000 0000 FF03 0088 2PI MOV,
1022 00 FF00 008D 2PI LEA,
1022 00 FF00 T!   0001 00C4 2 2FAMILY, LES, LDS,
1022 00 FF00 0062 2PI BOUND,  ( 3)
1002 00 FF00 0063 2PI ARPL,   ( 3)
1002 04 FF00 0069 2PI IMULI, ( 3)
1002 08 FF00 006B 2PI IMULSI, ( 3)
1002 00 FF,0000 T! 0100 00,020F 2 3FAMILY, LAR, LSL, ( 3)
1002 00 FF,0000 T! 0800 00,A30F 4 3FAMILY, BT, BTS, BTR, BTC, ( 3)
1002 00 FF,0000 T! 0800 00,A50F 2 3FAMILY, SHLD|C, SHRD|C,    ( 3)
1002 00 FF,0000 T! 0100 00,BC0F 2 3FAMILY, BSF, BSR,          ( 3)
1002 08 FF,0000 T! 0800 00,A40F 2 3FAMILY, SHLDI, SHRDI,    ( 3)
1022 00 FF,0000 T! 0100 00,B20F 4 3FAMILY, LSS, -- LFS, LGS, ( 3)
1501 00 FF,0000 T! 0800 00,B60F 2 3FAMILY, MOVZX|B, MOVSX|B,  ( 3)
1502 00 FF,0000 T! 0800 00,B70F 2 3FAMILY, MOVZX|W, MOVSX|W,  ( 3)
1002 00 FF,0000 00,AF0F 3PI IMUL,                     ( 3)
( --------- one fixup operands ----------)
00 04 C701 00C6 2PI MOVI,
0012 00 0007 T!   0008 40 4 1FAMILY, INC|X, DEC|X, PUSH|X, POP|X,
0012 00 0007 90 1PI XCHG|AX,
0011 04 0007 B0 1PI MOVI|B,
0012 04 0007 B8 1PI MOVI|X,
0400 04 C701 T!
 0800 0080 8 2FAMILY, ADDI, ORI, ADCI, SBBI, ANDI, SUBI, XORI, CMPI,
( It is dubious but fairly intractible whether the logical operation    )
( with sign extended bytes belong in the 386 instruction set.           )
( They are certainly there in the Pentium.                              )
0002 08 C700 T!
 0800 0083 8 2FAMILY, ADDSI, ORSI, ADCSI, SBBSI, ANDSI, SUBSI, XORSI, CMPSI,
0400 00 C701 T!
 0800 10F6 6 2FAMILY, NOT, NEG, MUL|AD, IMUL|AD, DIV|AD, IDIV|AD,
 0800 00FE 2 2FAMILY, INC, DEC,
0400 04 C701 00F6 2PI TESTI,
0002 00 C700 008F 2PI POP,
0002 00 C700 30FF 2PI PUSH,
0002 00 C700 T!  1000 10FF 2 2FAMILY, CALLO, JMPO,
0022 00 C700 T!  1000 18FF 2 2FAMILY, CALLFARO, JMPFARO,
0002 08 C7,0000 T!  08,0000 20,BA0F 4 3FAMILY, BTI, BTSI, BTRI, BTCI, ( 3)
0002 00 C7,0000 T! ( It says X but in fact W : descriptor mostly - ) ( 3)
  08,0000 00,000F 6 3FAMILY, SLDT, STR, LLDT, LTR, VERR, VERW,  ( 3)
  10,0000 20,010F 2 3FAMILY, SMSW, LMSW,       ( 3)
0022 00 C7,0000 T! ( It says X but in fact memory of different sizes) ( 3)
  08,0000 00,010F 4 3FAMILY, SGDT, SIDT, LGDT, LIDT, ( 3)

( --------- no fixup operands ----------)
02 GO!
0001 00 01 00 FIR B'|
0002 00 01 01 FIR X'|
0008 02 01 T!    0002 A0 2 1FAMILY, MOV|TA, MOV|FA,
00 04 01 T!
 0008 04 8 1FAMILY, ADDI|A, ORI|A, ADCI|A, SBBI|A, ANDI|A, SUBI|A, XORI|A, CMPI|A,
0000 04 01 00A8 1PI TESTI|A,
0000 00 01 T!  0002 A4 6 1FAMILY, MOVS, CMPS, -- STOS, LODS, SCAS,
00 10 01 T!   0002 E4 2 1FAMILY, IN|P, OUT|P,
00 00 01 T!   0002 EC 2 1FAMILY, IN|D, OUT|D,
00 00 01 T!   0002 6C 2 1FAMILY, INS, OUTS,     ( 3)

( --------- special fixups ----------)
01 GO!
0800     0000 0001 T!     01 00 2 FAMILY|R Y| N|
04 GO!
0800     0000 000E T!     02 00 8 FAMILY|R O| C| Z| CZ| S| P| L| LE|
05 GO!
0800 40 0F 0070 1PI J,
0000,0800 80 0F00 800F 2PI J|X,                                           ( 3)
00 GO!

2102 00 FF02 008C 2PI MOV|SG,

02 GO!
0000 00 0200 0000 FIR 1|          ( 3)
0000 00 0200 0200 FIR V|          ( 3)
0000,0500 00 C703 T! ( 02,0000 is a lockin for 1| V|)                   ( 3)
 0800 00D0 8 2FAMILY, ROL, ROR, RCL, RCR, SHL, SHR, -- SAR,  ( 3)
00 GO!
\ 0400,0000 08 C701 T!
0000,0400 08 C701 T!
 0800 00C0 8 2FAMILY, ROLI, RORI, RCLI, RCRI, SHLI, SHRI, -- SARI,  ( 3)
08,0012 0000 3F,0300 C0,200F 3PI  MOV|CD,  ( 3)


0800,0800 00 0100 T!  0100 0000 2 FAMILY|R Y'| N'|                      ( 3)
0800 00 0E00 T!  0200 0000 8 FAMILY|R O'| C'| Z'| CZ'| S'| P'| L'| LE'| ( 3)
0901 00 C7,0F00 00,900F 3PI SET,  ( 3)

( --------- no fixups ---------------)

2000 0000 00 T!  0008 06 4 1FAMILY, PUSH|ES, PUSH|CS, PUSH|SS, PUSH|DS,
2000 0000 00 T!  0008 07 4 1FAMILY, POP|ES, -- POP|SS, POP|DS,

0001 04 0000 T!    0001 D4 2 1FAMILY, AAM, AAD,
0001 04 0000 CD 1PI INT,
0008 22 0000 9A 1PI CALLFAR,
0008 22 0000 EA 1PI JMPFAR,
00 0100 0000 T!   0008 C2 2 1FAMILY, RET+, RETFAR+,
0004 80 0000 T!   0001 E8 2 1FAMILY, CALL, JMP,
00 40 0000 EB 1PI JMPS,
00 40 0000 T!   0001 E0 4 1FAMILY, LOOPNZ, LOOPZ, LOOP, JCXZ,
0000 00 0000 T!
   0008   0026 4 1FAMILY, ES:, CS:, SS:, DS:,
   0008   0027 4 1FAMILY, DAA, DAS, AAA, AAS,
   0001   0098 8 1FAMILY, CBW, CWD, -- WAIT, PUSHF, POPF, SAHF, LAHF,
   0008   00C3 2 1FAMILY, RET,  RETFAR,
   0001   00CC 4 1FAMILY, INT3, -- INTO, IRET,
   0001   00F0 6 1FAMILY, LOCK, -- REPNZ, REPZ, HLT, CMC,
   0001   00F8 6 1FAMILY, CLC, STC, CLI, STI, CLD, STD,
   0001   0060 2 1FAMILY, PUSH|ALL, POP|ALL, ( 3)
   0001   0064 4 1FAMILY, FS:, GS:, OS:, AS:, ( 3)
 0100 A00F 3 2FAMILY, PUSH|FS, POP|FS, CPUID,
 0100 A80F 2 2FAMILY, PUSH|GS, POP|GS, ( RSM,)
  0002 04 0000   0068 1PI PUSHI|X,  ( 3)
  0001 04 0000   006A 1PI PUSHI|B,  ( 3)
  0001 0104 0000   00C8 1PI ENTER, ( 3)
      0000 00 00   00C9 1PI LEAVE, ( 3)
      0000 00 00   00D7 1PI XLAT,  ( 3)
      0000 00 00 060F 2PI CLTS,  ( 3)

( ############## HANDLING THE SIB BYTE ################################ )

( Handle a `sib' bytes as an instruction-within-an-instruction )
( This is really straightforward, we say the sib commaer is a sib       )
( instruction. as per -- error checking omitted -- " 01,0000 ' ~SIB, >CFA )
( COMMAER SIB,,"                                                        )
( All the rest is to nest the state in this recursive situation:        )
( Leaving BY would flag commaers to be done after the sib byte as errors)
: (SIB),,   TALLY-BY @   00 TALLY-BY !
(   Handle bad bits by hand, prevent resetting of ``TALLY-BA'' which    )
(   could switch 16/32 bits modes.                                      )
(   0900 are the bad bits conflicting with ~SIB,                        )
    CHECK32 TALLY-BA @ 0900 INVERT AND TALLY-BA !   'NOOP BA-XT !
    ~SIB,   TALLY-BY !   ;

 ' (SIB),,   % SIB,, >DATA !   ( Fill in deferred data creation action  )

( Disassemble the sib byte where the disassembler sits now.             )
( [ `FORCED-DISASSEMBLY' takes care itself of incrementing the          )
(   disassembly pointer. ]                                              )
: DIS-SIB DROP
    LATEST-INSTRUCTION @        \ We don't want sib visible.
    [ % ~SIB, ] LITERAL FORCED-DISASSEMBLY
    LATEST-INSTRUCTION !
;

( Fill in deferred disassembler action.                                 )
 ' DIS-SIB    % SIB,, >DSP !

( Redefine some fixups, such that the user may say                      )
( "[AX" instead of " ~SIB| SIB,, [AX"                                   )
( Note that the disassembly is made to look like the same. The ~SIB|    )
( and the ~SIB, inside the SIB,, are print-suppressed.                  )
:2 [AX   ~SIB| SIB,, [AX ;       :2 [SP   ~SIB| SIB,, [SP ;
:2 [CX   ~SIB| SIB,, [CX ;       :2 [BP   ~SIB| SIB,, [BP ;
:2 [DX   ~SIB| SIB,, [DX ;       :2 [SI   ~SIB| SIB,, [SI ;
:2 [BX   ~SIB| SIB,, [BX ;       :2 [DI   ~SIB| SIB,, [DI ;
:2 [MEM  ~SIB| SIB,, [MEM ;

( Fill in the transformation to TALLY-BA for `` AS:, OS:, ''            )
( This flags them as prefixes.                                          )
( The toggle inverts the 16 and 32 bits at the same time.               )
: AS16<->32   TALLY-BA  C000 TOGGLE ;  ' AS16<->32 % AS:, >PRF !
: OS16<->32   TALLY-BA 30000 TOGGLE ;  ' OS16<->32 % OS:, >PRF !

( ############## 80386 ASSEMBLER PROPER END ########################### )
\ You may want to use these always instead of (Rx,)
( They accept an absolute address, convenient for using labels.         )
: RB, _AP_ 01 + - (RB,) ;    ' .COMMA-SIGNED   % (RB,) >DSP !
: RW, _AP_ 02 + - (RW,) ;    ' .COMMA-SIGNED   % (RW,) >DSP !
: RL, _AP_ 04 + - (RL,) ;    ' .COMMA-SIGNED   % (RL,) >DSP !

( Require instructions as per a 32 resp. 16 bits segment.               )
: BITS-32   02,8000 BA-DEFAULT ! ;
: BITS-16   01,4000 BA-DEFAULT ! ;

BITS-32
PREVIOUS DEFINITIONS DECIMAL
( ############## 8086 ASSEMBLER POST ################################## )
