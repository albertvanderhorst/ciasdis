( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( $Id$)

( ############## GENERIC PART OF ASSEMBER ############################# )

: \   ^J WORD DROP ; IMMEDIATE

: ALIAS CREATE , DOES> @ EXECUTE ;

( --assembler_postit_fixup_1 ) \ A2oct21 AvdH
\ REQUIRE ASSEMBLER
\ ASSEMBLER DEFINITIONS
VARIABLE ISS ( Instruction start )

( --assembler_postit_fixup_2 ) \ A2oct21 AvdH
: <POST HERE ISS ! ;
 VARIABLE IDP
: <FIX HERE IDP ! ; : IHERE IDP @ ;
: C|, -1 IDP +! IHERE C@ OR IHERE C! ;  ( c.f. C, )
: C@+ COUNT ;  : C@- 1 - DUP C@ ; ( : C!+ >R R@ ! R> 1+ ;)
: POST, C@+ C, ;       : FIX| C@- C|, ;

\ If the input is "--" skip it, leave " there WAS no skip".
: NO--? SOURCE DROP >IN @ + C@ &- = DUP
    IF BL WORD DROP THEN INVERT ;

: 1PI CREATE C, DOES> <POST POST, DROP ;
: 2PI CREATE C, C, DOES> <POST POST, POST, DROP ;

: 1FI CREATE C, DOES> 1+ <FIX FIX| DROP ;

: DFI ( 0 LSHIFT) <FIX C|, ;

( --assembler_postit_fixup_3 ) \ A2oct21 AvdH
: SPLIT DUP 8 RSHIFT ; ( To handle two bytes at once )

( INCREMENT, OPCODE , COUNT -- )
: 1FAMILY, 0 DO NO--? IF DUP 1PI THEN OVER + LOOP DROP DROP ;
: 2FAMILY, 0 DO NO--? IF DUP SPLIT SWAP 2PI THEN OVER + LOOP DROP DROP ;

: 1FAMILY| 0 DO NO--? IF DUP 1FI THEN OVER + LOOP DROP DROP ;

\ PREVIOUS


( ############## 8089 ASSEMBLER ADDITIONS ############################# )

\ ASSEMBLER DEFINITIONS
HEX
: W,   DUP 8 RSHIFT C,   C, ;

( ############## 6809 ASSEMBLER PROPER ################################ )
' C,   ALIAS #,     ( immediate byte data)
' W,   ALIAS ##,    ( immediate data : cell)
' C,   ALIAS CO,    ( address: byte offset)
' W,   ALIAS WO,    ( cell: address or offset)
' C,   ALIAS DO,    ( direct page offset )
' W,   ALIAS E,     ( extended address )
' C,   ALIAS STACK, ( what to push or pop)

\ Adressing modes go here
( 30 ) 00 1FI #|                  ( 30 ) 00 1FI A|
( 30 ) 10 1FI DP|                 ( 30 ) 10 1FI B|
( 30 ) 20 1FI []|
( 30 ) 30 1FI E|


( --------------- Handling of the index byte. ------------------------- )
' DFI ALIAS (|#,)    \ Incorporate 5 bit unsigned DATA.

\ Incorporate signed DATA. Cut off negative values at 5 bits.
: |#, DUP -10 +10 WITHIN 0= ABORT" offset > 5 bits"  1F AND   (|#,) ;
20 0 4 1FAMILY| X Y U S
( FF ) 9F 1FI [##]

01 80 07 1FAMILY| ,R+ ,R++ ,-R ,--R ,R B,R A,R
01 91 06 1FAMILY| [,R++] -- [,--R] [,R] [B,R] [A,R]
10 8B 02 1FAMILY| D,R [D,R]

\ The don't care bits translate to underscores
10 88 02 1FAMILY| #,R [#,R]
10 89 02 1FAMILY| ##,R [##,R]

20 8C 04 1FAMILY| #,PCR  #,PCR_  #,PCR__  #,PCR___
20 9C 04 1FAMILY| [#,PCR] [#,PCR]_  [#,PCR]__ [#,PCR]___

20 8D 04 1FAMILY| ##,PCR  ##,PCR_  ##,PCR__  ##,PCR___
20 9D 04 1FAMILY| [##,PCR] [##,PCR]_  [##,PCR]__ [##,PCR]___

( ---- Exchanges, transfer -------------------------------------------- )
01 08 4 1FAMILY| =>A =>B =>CCR =>DPR
01 00 6 1FAMILY| =>D =>X =>Y =>US =>SP =>PC
10 80 4 1FAMILY| A== B== CCR== DPR==
10 00 6 1FAMILY| D== X== Y== US== SP== PC==
01 1E 2 2FAMILY, EXG, TFR,

\ One operand instruction

01 40 10 1FAMILY, NEG, -- -- COM, LSR, -- ROR, ASR, ASL, ROL, DEC, -- INC, TST, -- CLR,

01 00 8 1FAMILY, NEG|D, -- -- COM|D, LSR|D, -- ROR|D, ASR|D,
01 08 8 1FAMILY, ASL|D, ROL|D, DEC|D, -- INC|D, TST|D, JMP|D, CLR|D,

\ Two operand instruction

01 80 0C 1FAMILY, SUBA, CMPA, SBCA, -- ANDA, BITA, LDA, -- EORA, ADCA, ORA, ADDA,
01 C0 0C 1FAMILY, SUBB, CMPB, SBCB, -- ANDB, BITB, LDB, -- EORB, ADCB, ORB, ADDB,

40 87 2 1FAMILY, STA, STB,

40 8F 2 1FAMILY, STX, STU,

40 83 2 1FAMILY, SUBD, ADDD,
40 8C 2 1FAMILY, CMPX, LDD,
40 8E 2 1FAMILY, LDX, LDU,
( 30 ) CD 1PI STD,

0001 8310 2 2FAMILY, CMPD, CMPU,
0001 8C10 2 2FAMILY, CMPY, CMPS,
4000 8E10 2 2FAMILY, LDY, LDS,

4000 8F10 2 2FAMILY, STY, STS,

\ Branches, control flow

01 00 10 1FAMILY| Y| N| U>| U<=| U>=| U<| =| <>| VC| VS| 0>=| 0<| >=| <| >| <=|
( 30 ) 4E 1PI JMP,
( 30 ) 8D 1PI JSR,
( 00 ) 16 1PI LBRA,           ( 00 ) 17 1PI LBRS,
( 00 ) 8D 1PI BSR,
( 0F ) 20 1PI BR,             ( 0F00 ) 20 10 2PI LBR,

\ Miscellaneous, no operands
( 0 ) 12 1PI NOP,       ( 0 ) 13 1PI SYNC,      ( 0 ) 19 1PI DAA,       ( 0 ) 1D 1PI SEX,
01 39 7 1FAMILY, RTS, ABX, RTI, -- MUL, -- SWI,
0001 3F10 2 2FAMILY, SWI2, SWI3,

\ Miscellaneous, cc operand.
( 0 ) 1A 1PI ORCC,    ( 0 ) 1C 1PI ANDCC,   ( 0 ) 3C 1PI CWAI,

\ The Index byte is integrated into those instruction
01 30 4 2FAMILY, LEAX, LEAY, LEAS, LEAU,
\ Requiring extra byte with special syntax.
01 34 4 1FAMILY, PSHS, PULS, PSHU, PULU,

\ Convenience for stack sets
\ Usage : PUSHS, (& B& C& ... X& )S,
: | CREATE DUP C, 1 LSHIFT DOES> C@ OR ;
1 | CCR&  | A&   | B&   | DPR&   | X&   | Y&   | U&   | PC&   DROP
\ '| HIDDEN
\ : (& DSP@ 0 ;    : )S, STACK, ?CSP ;
: (& 0 ;    : )S, STACK, ;

\ The indirection require another byte to fixup.
: [] []| 0 C, ;

\ None of the essential
' ASL, ALIAS LSL,

( ############## ACTUAL GENERATION OF CODE ############################# )

: NEXT,   JMP, [] [,R++] Y   ;

: CODE CREATE -3 ALLOT HIDE ( ALSO ASSEMBLER) ;

: END-CODE REVEAL ( PREVIOUS ) ;

: ;CODE REVEAL POSTPONE (DOES>)   POSTPONE [   ; IMMEDIATE

\ Example of usage
\ : var  CREATE 0 ,
\     ;CODE LDX, [] ,R S   STD, [] ,R S   TFR, X== =>D   NEXT, ;
