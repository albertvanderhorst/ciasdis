( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)

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
  0 2  0000 0,0100 ' (W,) COMMAER OW,    ( obligatory word     )
  0 4  8000 0,0080 ' (L,) COMMAER (RL,)  ( cell relative to IP )
  0 2  4000 0,0080 ' (W,) COMMAER (RW,)  ( cell relative to IP )
  0 1  0000 0,0040 ' AS-C, COMMAER (RB,) ( byte relative to IP )
  0 2  0000 0,0020 ' (W,) COMMAER SG,    (  Segment: WORD      )
  0 1  0000 0,0010 ' AS-C, COMMAER P,    ( port number ; byte     )
  0 1  0000 0,0008 ' AS-C, COMMAER IS,   ( Single -obl-  byte )
  0 4 20002 0,0004 ' (L,) COMMAER IL,    ( immediate data : cell)
  0 2 10002 0,0004 ' (W,) COMMAER IW,    ( immediate data : cell)
  0 1  0001 0,0004 ' AS-C, COMMAER IB,   ( immediate byte data)
  0 4  8008 0,0002 ' (L,) COMMAER L,     ( immediate data : address/offset )
  0 2  4008 0,0002 ' (W,) COMMAER W,     ( immediate data : address/offset )
  0 1  0004 0,0002 ' AS-C, COMMAER B,    ( immediate byte : address/offset )
  _ 1  0000 0,0001 _    COMMAER SIB,, ( An instruction with in an instruction )


( Meaning of the bits in TALLY-BA :                                     )
( Inconsistent:  0001 OPERAND IS BYTE     0002 OPERAND IS CELL  W/L     )
(                0004 OFFSET  IS BYTE     0008 OFFSET  IS CELL  W/L
( By setting 0020 an opcode can force a memory reference, e.g. CALLFARO )
(               0010 Register op         0020 Memory op                 )
(               0040 D0|                 0080 [BP]' {16} [BP] [BP  {32} )
(  sib:         0100 no ..             0200 [AX +8*| DI]                )
(  logical      0400 no ..             0800 Y| Y'| Z| Z'|               )
(  segment      1000 no ..             2000 ES| ..                      )
(  AS:          4000 16 bit Addr       8000 32 bit Address              )
(  OS:         1,0000 16 bit Op      2,0000 32 bit Operand              )
(  Use debug   4,0000 no ..          8,0000 CR0 ..DB0                   )

( Names *ending* in primes BP|' -- not BP'| the prime registers -- are  )
( only valid for 16 bits mode, or with an address overwite. Use W, L,   )
( appropriately.                                                        )

8200 0 38 T!R
 08 00 8 FAMILY|R AX] CX] DX] BX] 0] BP] SI] DI]
8200 0 C0 T!R
 40 00 4 FAMILY|R  +1* +2* +4* +8*
8200 0 0700,0001 T!
 01 00 8 FAMILY|R [AX [CX [DX [BX [SP -- [SI [DI
8280 00 0100,0007 05 FIR [BP   ( Fits in the hole, safe inconsistency check)
8240 02 0100,0007 05 FIR [MEM  ( Fits in the hole, safe inconsistency check)

4120 0 07 T!R
  01 00 8
    FAMILY|R [BX+SI]' [BX+DI]' [BP+SI]' [BP+DI]' [SI]' [DI]' -- [BX]'
40A0 0000 07 06 FIR [BP]'  ( Fits in the hole, safe inconsistency check)
8120 0 07 T!R
 01 00 4 FAMILY|R [AX] [CX] [DX] [BX]
8120 01 07 04 FIR ~SIB|   ( Fits in the hole, but requires ~SIB, )
81A0 00 07 05 FIR [BP]   ( Fits in the hole, but disallow D0| )
8120 0 07 T!R
 01 06 2 FAMILY|R [SI] [DI]

0111 0 07 T!R
 01 00 8 FAMILY|R AL| CL| DL| BL| AH| CH| DH| BH|
0112 0 07 T!R
 01 00 8 FAMILY|R AX| CX| DX| BX| SP| BP| SI| DI|
0160 00 C0 00 FIR      D0|
0124 02 C0 40 FIR      DB|
0128 02 C0 80 FIR      DW|
0110 00 C0 C0 FIR      R|
4048 02 C7 06 FIR      MEM|' ( Overrules D0| [BP]')
8108 02 C7 05 FIR      MEM| ( Overrules D0| [BP] )

04,1101 0000 38 T!R
 08 00 8 FAMILY|R AL'| CL'| DL'| BL'| AH'| CH'| DH'| BH'|
04,1102 0000 38 T!R
 08 00 8 FAMILY|R AX'| CX'| DX'| BX'| SP'| BP'| SI'| DI'|
04,2100 0000  38 T!R   08 00 6 FAMILY|R ES| CS| SS| DS| FS| GS|
08,0002 0000 3801,0000 T!   ( 3)
 08 00 5 FAMILY|R CR0| -- CR2| CR3| CR4|                 ( 3)
 0008 0100 8 FAMILY|R DR0| DR1| DR2| DR3| DR4| DR5| DR6| DR7| ( 3)

0000 0000 0200 T!R  0200 00 2 FAMILY|R F| T|
04,0401 0000 0100 0000 FIR B|
04,0402 0000 0100 0100 FIR X|

( --------- These must be found last -------)
0600 0 01FF 0000 1PI ~SIB,
( --------- two fixup operands ----------)
04,1000 0000 FF03 T!
 0008 0000 8 2FAMILY, ADD, OR, ADC, SBB, AND, SUB, XOR, CMP,
04,1000 0000 FF01 T!
 0002 0084 2 2FAMILY, TEST, XCHG,
04,1000 0000 FF03 0088 2PI MOV,
1022 0 FF00 008D 2PI LEA,
1022 0 FF00 T!   0001 00C4 2 2FAMILY, LES, LDS,
1022 0 FF00 0062 2PI BOUND,  ( 3)
1002 0 FF00 0063 2PI ARPL,   ( 3)
1002 04 FF00 0069 2PI IMULI, ( 3)
1002 08 FF00 006B 2PI IMULSI, ( 3)
1002 0 FF,0000 T! 0100 00,020F 2 3FAMILY, LAR, LSL, ( 3)
1002 0 FF,0000 T! 0800 00,A30F 4 3FAMILY, BT, BTS, BTR, BTC, ( 3)
1002 0 FF,0000 T! 0800 00,A50F 2 3FAMILY, SHLD|C, SHRD|C,    ( 3)
1002 0 FF,0000 T! 0100 00,BC0F 2 3FAMILY, BSF, BSR,          ( 3)
1002 08 FF,0000 T! 0800 00,A40F 2 3FAMILY, SHLDI, SHRDI,    ( 3)
1022 0 FF,0000 T! 0100 00,B20F 4 3FAMILY, LSS, -- LFS, LGS, ( 3)
1501 0 FF,0000 T! 0800 00,B60F 2 3FAMILY, MOVZX|B, MOVSX|B,  ( 3)
1502 0 FF,0000 T! 0800 00,B70F 2 3FAMILY, MOVZX|W, MOVSX|W,  ( 3)
1002 0 FF,0000 00,AF0F 3PI IMUL,                     ( 3)
( --------- one fixup operands ----------)
0 04 C701 00C6 2PI MOVI,
0012 0 0007 T!   0008 40 4 1FAMILY, INC|X, DEC|X, PUSH|X, POP|X,
0012 0 0007 90 1PI XCHG|AX,
0011 04 0007 B0 1PI MOVI|BR,
0012 04 0007 B8 1PI MOVI|XR,
0 04 C701 T!
 0800 0080 8 2FAMILY, ADDI, ORI, ADCI, SBBI, ANDI, SUBI, XORI, CMPI,
0002 08 C700 T!
 0800 0083 8 2FAMILY, ADDSI, -- ADCSI, SBBSI, -- SUBSI, -- CMPSI,
0000 0 C701 T!
 0800 10F6 6 2FAMILY, NOT, NEG, MUL|AD, IMUL|AD, DIV|AD, IDIV|AD,
 0800 00FE 2 2FAMILY, INC, DEC,
0 04 C701 00F6 2PI TESTI,
0002 0 C700 008F 2PI POP,
0002 0 C700 30FF 2PI PUSH,
0002 0 C700 T!  1000 10FF 2 2FAMILY, CALLO, JMPO,
0022 0 C700 T!  1000 18FF 2 2FAMILY, CALLFARO, JMPFARO,
0002 08 C7,0000 T!  08,0000 20,BA0F 4 3FAMILY, BTI, BTSI, BTRI, BTCI, ( 3)
0002 0 C7,0000 T! ( It says X but in fact W : descriptor mostly - ) ( 3)
  08,0000 00,000F 6 3FAMILY, SLDT, STR, LLDT, LTR, VERR, VERW,  ( 3)
0022 0 C7,0000 T! ( It says X but in fact memory of different sizes) ( 3)
  08,0000 00,010F 7 3FAMILY, SGDT, SIDT, LGDT, LIDT, SMSW, -- LMSW,       ( 3)

( --------- no fixup operands ----------)
0001 0 0200,0001 00 FIR B'|
0002 0 0200,0001 01 FIR X'|
0008 02 0201 T!    0002 A0 2 1FAMILY, MOV|TA, MOV|FA,
0 04 0201 T!
 0008 04 8 1FAMILY, ADDI|A, ORI|A, ADCI|A, SBBI|A, ANDI|A, SUBI|A, XORI|A, CMPI|A,
0000 04 0201 00A8 1PI TESTI|A,
0000 0 0201 T!  0002 A4 6 1FAMILY, MOVS, CMPS, -- STOS, LODS, SCAS,
0 10 0201 T!   0002 E4 2 1FAMILY, IN|P, OUT|P,
0 00 0201 T!   0002 EC 2 1FAMILY, IN|D, OUT|D,
0 00 0201 T!   0002 6C 2 1FAMILY, INS, OUTS,     ( 3)

( --------- special fixups ----------)

0800     0000 0100,0001 T!R     01 00 2 FAMILY|R Y| N|
0800     0000 0400,000E T!R     02 00 8 FAMILY|R O| C| Z| CZ| S| P| L| LE|
0800 40 050F 0070 1PI J,

2102 0 FF02 008C 2PI MOV|SG,

0000 0 0200,0200 0000 FIR 1|   0000 0 0200,0200 0200 FIR V|          ( 3)
0100 0 2,C703 T! ( 2,0000 is a lockin for 1| V|)                   ( 3)
 0800 00D0 8 2FAMILY, ROL, ROR, RCL, RCR, SHL, SHR, -- SAR,  ( 3)
8,0012 0000 3F,0300 C0,200F 3PI  MOV|CD,  ( 3)

0800 80 5,0F00 800F 2PI J|X,                                           ( 3)
0800 0 0100 T!R  0100 0000 2 FAMILY|R Y'| N'|                          ( 3)
0800 0 0E00 T!R  0200 0000 8 FAMILY|R O'| C'| Z'| CZ'| S'| P'| L'| LE'| ( 3)
0901 0 C7,0F00 00,900F 3PI SET,  ( 3)

( --------- no fixups ---------------)

2000 0000 0 T!  0008 06 4 1FAMILY, PUSH|ES, PUSH|CS, PUSH|SS, PUSH|DS,
2000 0000 0 T!  0008 07 4 1FAMILY, POP|ES, -- POP|SS, POP|DS,

0001 04 0000 T!    0001 D4 2 1FAMILY, AAM, AAD,
0001 04 0000 CD 1PI INT,
0008 22 0000 9A 1PI CALLFAR,
0008 22 0000 EA 1PI JMPFAR,
0 0100 0000 T!   0008 C2 2 1FAMILY, RET+, RETFAR+,
0004 80 0000 T!   0001 E8 2 1FAMILY, CALL, JMP,
0 40 0000 EB 1PI JMPS,
0 40 0000 T!   0001 E0 4 1FAMILY, LOOPNZ, LOOPZ, LOOP, JCXZ,
0000 0 0000 T!
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
      0000 0 00   00C9 1PI LEAVE, ( 3)
      0000 0 00   00D7 1PI XLAT,  ( 3)
      0000 0 00 060F 2PI CLTS,  ( 3)

( ############## HANDLING THE SIB BYTE ################################ )

( Handle a `sib' bytes as an instruction-within-an-instruction )
( This is really straightforward, we say the sib commaer is a sib       )
( instruction. as per -- error checking omitted -- " 1,0000 ' ~SIB, >CFA )
( COMMAER SIB,,"                                                        )
( All the rest is to nest the state in this recursive situation:        )
( Leaving BY would flag commaers to be done after the sib byte as errors)
: (SIB),,   TALLY-BY @   0 TALLY-BY !
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
 ' DIS-SIB    % SIB,, >DIS !

( Redefine some fixups, such that the user may say                      )
( "[AX" instead of " ~SIB| SIB,, [AX"                                   )
( Note that the disassembly is made to look like the same. The ~SIB|    )
( and the ~SIB, inside the SIB,, are print-suppressed.                  )
: [AX   ~SIB| SIB,, [AX ;       : [SP   ~SIB| SIB,, [SP ;
: [CX   ~SIB| SIB,, [CX ;       : [BP   ~SIB| SIB,, [BP ;
: [DX   ~SIB| SIB,, [DX ;       : [SI   ~SIB| SIB,, [SI ;
: [BX   ~SIB| SIB,, [BX ;       : [DI   ~SIB| SIB,, [DI ;
: [MEM  ~SIB| SIB,, [MEM ;

( Fill in the transformation to TALLY-BA for `` AS:, OS:, ''            )
( This flags them as prefixes.                                          )
( The toggle inverts the 16 and 32 bits at the same time.               )
: AS16<->32   TALLY-BA  C000 TOGGLE ;  LATEST 'AS:, >PRF !
: OS16<->32   TALLY-BA 30000 TOGGLE ;  LATEST 'OS:, >PRF !

( ############## 80386 ASSEMBLER PROPER END ########################### )
( You may want to use these always instead of (Rx,)
    : RB, _AP_ 1 + - (RB,) ;    ' .COMMA-SIGNED   % (RB,) >DIS !
    : RW, _AP_ 2 + - (RW,) ;    ' .COMMA-SIGNED   % (RW,) >DIS !
    : RL, _AP_ 4 + - (RL,) ;    ' .COMMA-SIGNED   % (RL,) >DIS !

( Require instructions as per a 32 resp. 16 bits segment.               )
: BITS-32   2,8000 BA-DEFAULT ! ;
: BITS-16   1,4000 BA-DEFAULT ! ;

BITS-32
PREVIOUS DEFINITIONS DECIMAL
( ############## 8086 ASSEMBLER POST ################################## )
