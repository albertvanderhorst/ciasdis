( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( REVERSE ENGINEERING ASSEMBLER  cias cidis                             )

( This file `asgen.frt' contains generic tools and has been used to     )
( make assemblers for 8080 8086 80386 Alpha 6809 and should be          )
( usable for Pentium 68000 6502 8051.                                   )
( It should run on ISO Forth's provided some ciforth facilities are     )
( present or emulated.                                                  )
( The assemblers -- with some care -- have the property that the        )
( disassembled code can be assembled to the exact same code.            )

( Most instruction set follow this basic idea that it contains of three )
( distinct parts:                                                       )
(   1. the opcode that identifies the operation                         )
(   2. modifiers such as the register working on                        )
(   3. data, as a bit field in the instruction.                         )
(   4. data, including addresses or offsets.                            )
( This assembler goes through three stages for each instruction:        )
(   1. postit: assemblers the opcode with holes for the modifiers.      )
(      This has a fixed length. Also posts requirements for commaers.   )
(   2. fixup: fill up the holes, either from the beginning or the       )
(     end of the post. These can also post required commaers            )
(   3. fixup's with data. It has user supplied data in addition to      )
(      opcode bits. Both together fill up bits left by a postit.        )
(   4. The commaers. Any user supplied data in addition to              )
(      opcode, that can be added as separate bytes. Each has a          )
(      separate command, where checks are built in.                     )
( Keeping track of this is done by bit arrays, similar to the a.i.      )
( blackboard concept. This is ONLY to notify the user of mistakes,      )
( they are NOT needed for the assembler proper.                         )
( This setup allows a complete check of validity of code and complete   )
( control over what code is generated. Even so all checks can be        )
( defeated if need be.                                                  )

( The generic tools include:                                            )
(   - the defining words for 1 2 3 4 byte postits,                      )
(   -                    for fixups from front and behind               )
(   -                    for comma-ers,                                 )
(   - showing a list of possible instructions, for all opcodes or       )
(   -  for a single one.                                                )
(   -  disassembly of a single instruction or a range                   )
(   - hooks for more tools, e.g. print the opcode map as postscript.    )
(   - hooks for prefix instructions                                     )
(   - hooks for classes of instructions, to be turned off as a whole    )
( To write an assembler, make the tables, generate the complete list    )
( of instructions, assemble it and disassemble it again. If equal, you  )
( have a starting point for confidence in your work.                    )

( This code was at some time big-endian dependant and assumed a 32 bit  )
( machine! It is not sure that all traces of this have vanished.        )
( You cannot use this program as a cross-assembler if there are         )
( instructions that don't fit in a hosts cell {Its postit that is.}     )
( IT USES THE VOCABULARY AS A LINKED LIST OF STRUCTS: ciforth!
( IT USED KNOWLEDGE OF THE INTERPRETER AND THE HEADERS!                 )
( Now if you think that this makes this code non-portable, think again. )
( You have to change about 8 lines to adapt. Now if you only have to    )
( adapt 8 lines in a 40k lines c-program with the same functionality,   )
( it would smack portable. Wouldn't it?

( The blackboard consist of three bit arrays. At the start of an        )
( instruction they are all zero. `TALLY-BI' `TALLY-BY' `TALLY-BA' keep  )
( track of instruction bits, instruction byte and bad things            )
( respectively.                                                         )

( An instructions generally has a single postit that defines the        )
( opcode. It assembles the opcode, advancing `HERE' leaving zero bits   )
( that needs still filling in by fixups. It sets these bits in          )
( `TALLY-BI'. It may also post that commaers are required by setting a  )
( bit in `TALLY-BY'.                                                    )

( Then comes the fixups. They fill up the holes left in the             )
( instruction -- before `HERE' -- by or-ing and maintain `TALLY-BI' ,   )
( resetting bits. They end in `|' where the other assembly actions end  )
( in `,'. They may require more commaers, posting to `TALLY-BY'. The    )
( commaers advance `HERE' by a whole number of bytes assembling user    )
( supplied information and reset the corresponding bits in `TALLY-BY'.  )

( All parts of an instruction can add bits to `TALLY-BA'. If any two    )
( consecutive bits are up this is bad. Its bits can never be reset but  )
( `TALLY-BA' is reset as a whole at the start of an instruction.        )

( An example: load an index register with a 16 bit value, 8080.         )
(    TALLY-BI  TALLY-BY   TALLY-BA     HERE     8A43 4  DUMP            )
(    0000      0000       0801         8A43     .. .. .. ..    LXI,     )
(    0030      0002       0002         8A44     01 .. .. ..    SP|      )
(    0000      0002       0002         8A44     31 .. .. ..    SP0 @ X, )
(    0000      0000       0002         8A46     31 00 FE ..    HLT,     )
(    0000      0000       0000         8A47     31 00 FE 76    ...      )
( The bit in `TALLY-BA' means a 16 bit operation. Now if `TALLY-BA'     )
( contains 3 it would mean that it is at the same time an 8 bit and 16  )
( bit operation. Bad!                                                   )

( The following problems can be detected:                               )
( - postit when `TALLY-BI' or `TALLY-BY' contains bits up               )
( - setting or resetting bits for the second time in `TALLY-BI' or      )
(     `TALLY-BY'                                                        )
( - commaing when `TALLY-BI' still contains bits up                     )
( - setting `TALLY-BA' bad                                              )

( A prefix PostIt has its prefix field filled in with an execution      )
( token. This token represents the action performed on the TALLY-BA     )
( flags, that is used instead of resetting it. This can be used for     )
( example for the OS -- operand size -- prefix in the Pentium. Instead  )
( of putting the information that we are in a 16 bit operand segment    )
( in TALLY-BA , it transforms that information to 32 bit.               )

( ############### PRELUDE ############################################# )

( Wrapper for asgen, when we want to test without label mechanisms.     )
( These are hot patched for reverse engineering.                        )

REQUIRE ALIAS
REQUIRE @+ ( Fetch from ADDRES. Leave incremented ADDRESS and DATA )
REQUIRE BAG
REQUIRE POSTFIX
REQUIRE class

'HERE  ALIAS AS-HERE
'C,    ALIAS AS-C,
'ALLOT  ALIAS AS-ALLOT
'HERE  ALIAS _AP_
: ADORN-ADDRESS DROP CR ;   ( Action between two disassembled instr.    )

( ############### PART I ASSEMBLER #################################### )
( MAYBE NOT PRESENT UTILITIES                                           )

: !+ >R R@ ! R> CELL+ ; ( Store DATA to ADDRES. Leave incremented ADDRESS)
( Fetch from decremented ADDRES. Leave DATA and ADDRESS)
: @- 0 CELL+ - >R R@ @ R>  ;
( CHAR - CONSTANT &-     CHAR ~ CONSTANT &~                             )
CREATE TABLE 1 , 1 , ( x TABLE + @ yields $100^[-x mod 4] )
( Rotate X by I bytes left leaving X' Left i.e. such as it appears in )
( memory! Not as printed on a big endian machine! )
: ROTLEFT TABLE + @ UM* OR ;   ( aqa " 8 * LSHIFT" on bigendian. )
'TABLE HIDDEN

( ------------- UTILITIES, SYSTEM DEPENDANT ----------------------------)
: %ID. >NFA @ $@ TYPE SPACE ;   ( Print a definitions name from its DEA.)
VOCABULARY ASSEMBLER IMMEDIATE   ASSEMBLER DEFINITIONS HEX
( We use the abstraction of a dea "dictionary entry address". aqa "xt" )
( Return the DEA from "word". 1]                                         )

\ Make an alias for "'" in the minimum search order called "%".
'ONLY >WID CURRENT !    \ Making ONLY the CONTEXT is dangerous! This will do.
"'" 'ONLY >WID (FIND)   ALIAS %         ( "'" ) 2DROP
CONTEXT @ CURRENT !     \ Restore current.

: %>BODY >CFA >BODY ; ( From DEA to the DATA field of a created word )
: %BODY> BODY> CFA> ; ( Reverse of above)
: %>DOES >DFA @ ; ( From DEA to the DOES> pointer for a ``DOES>'' word )
( Leave for DEA : it IS to be ignored in disassemblies. This is used    )
( for supressing the bare bones of the sib mechanism in i586.           )
: IGNORE? >NFA @ CELL+ C@ &~ = ;

: (>NEXT%) >LFA @ ; ( Given a DEA, return the next DEA. )
( For a DEA as returned from (>NEXT%} : it IS the end, not a real dea.  )
: VOCEND? >LFA @ 0= ;
( As (>NEXT%} but skip holes, i.e. words with names starting in ``-''   )
: >NEXT% BEGIN  (>NEXT%) DUP >NFA @ CELL+ C@ &- - UNTIL ;
( Leave the first DEA of the assembler vocabulary.                      )
: STARTVOC ['] ASSEMBLER >WID >LFA @ ;

( Build: allocate place to remember a DOES> address of a `CREATE'd word )
( Leave that ADDRESS  to be filled in by ``REMEMBER''                   )
( Execution: Leave for DEA : it IS of same type as the remembered DOES> )
: IS-A CREATE HERE 1 CELLS ALLOT DOES> @ SWAP %>DOES @ = ;
( Patch up the data field of a preceeding word defined by `IS-A'        )
( To be called when sitting at the DOES> address                        )
( The !CSP / ?CSP detects stack changes. Now split it into 2 checks.    )
: REMEMBER ?CSP HERE SWAP ! !CSP ; IMMEDIATE

( Also needed : ?ERROR                                                  )
(   `` : ?ERROR DROP DROP ; '' defeats all checks.                      )

( Behaves as ``CREATE'' except, if the word to be created has name "--" )
( it is ignored, by making the header unfindable. Not strictly needed.  )
: CREATE--   (WORD) 2DUP POSTFIX CREATE
    2 = SWAP "--" CORA 0= AND IF LATEST HIDDEN THEN ;

( ------------- UTILITIES, SYSTEM INDEPENDANT ------------------------- )
( Note that the assembler works with multi-character bigendian numbers  )

(   The FIRST bitset is contained in the SECOND one, leaving it IS      )
: CONTAINED-IN OVER AND = ;
( Compile the ls 8 bits of X at here, leaving the REMAINING bits.       )
: lsbyte, DUP AS-C, 0008 RSHIFT ;
( For X and ADDRESS , add the byte below address to x at l.s. place.    )
( Leave X and decremented ADDRESS.                                      )
: lsbyte@ 1- SWAP 8 LSHIFT OVER C@ OR SWAP ;
( For X ADDRESS LENGTH , return the NUMBER that at address {bigendian}. )
( x provides a filler, -1 results in sign extension.                    )
: lsbytes  >R R@ + BEGIN R> DUP WHILE 1- >R  lsbyte@ REPEAT 2DROP ;
( For ADDRESS LENGTH , return the NUMBER that is there {bigendian}.     )
( "Multiple byte fetch".                                                )
: MC@ 0 ROT ROT lsbytes ;
( For ADDRESS LENGTH , return the "number there IS negative"            )
: MC<0 + 1- C@ 80 AND 80 = ;
( For ADDRESS LENGTH , return the NUMBER that is there. bigendian and   )
( signextended.                                                         )
( "Multiple byte fetch, signed".                                        )
: MC@-S 2DUP MC<0 ROT ROT lsbytes ;

( ------------- ASSEMBLER, BOOKKEEPING -------------------------------- )
( The bookkeeping is needed for error detection and disassembly.        )
VARIABLE TALLY-BI  ( Bits that needs fixed up)
VARIABLE TALLY-BY  ( Bits represent a commaer that is to be supplied)
VARIABLE TALLY-BA  ( State bits, bad if two consequitive bits are up)
( Bits set in the default can be used to exclude certain classes of     )
( instructions, e.g. because they are not implemented.                  )
VARIABLE BA-DEFAULT    0 BA-DEFAULT !
VARIABLE OLDCOMMA ( Previous comma, or zero)
VARIABLE ISS  ( Start of current instruction)
VARIABLE ISL  ( Lenghth of current instruction)
( To be executed instead of reset BA between prefix and instruction )
VARIABLE BA-XT
( Reset ``BA'' to default for begin instruction, unless prefix.         )
: RESET-BAD   BA-XT @ DUP IF EXECUTE ELSE
   DROP  BA-DEFAULT @ TALLY-BA ! THEN ;
( Initialise ``TALLY''                                                  )
: !TALLY   0 TALLY-BI !   0 TALLY-BY !   RESET-BAD   0 OLDCOMMA ! ;
   0 BA-XT !   !TALLY
( Return: instruction IS complete, or not started)
: AT-REST? TALLY-BI @ 0=   TALLY-BY @ 0=  AND ;
( For N : it CONTAINS bad pairs)
: BADPAIRS? DUP 1 LSHIFT AND AAAAAAAAAAAAAAAA AND ;
: BAD? TALLY-BA @ BADPAIRS? ;  ( The state of assembling IS inconsistent)
( If STATUS were added to `TALLY-BA' would that CREATE a bad situation? )
: COMPATIBLE? TALLY-BA @ OR BADPAIRS? 0= ;
DECIMAL
( Generate errors. None have net stack effects, such that they may be   )
( replaced by NULL definitions.                                         )
: CHECK26 AT-REST? 0= 26 ?ERROR ;  ( Error at postit time )
: CHECK32 BAD? 32 ?ERROR ; ( Always an error )
( Generate error for fixup, if for the BI, some of the BITS would       )
( stick out it. Leave MASK and BITS . Programming error!                )
: CHECK31 2DUP SWAP CONTAINED-IN 0= 31 ?ERROR ;
( Generate error for ``FIXUP-DATA'' , if the BI and the LEN             )
( are not compatible. Leave BI and LEN . Programming error!             )
: CHECK31A 2DUP OVER >R RSHIFT 1 OR OVER LSHIFT R> <> 31 ?ERROR ;
( The part of BITS outside of BITFIELD must be either all ones or       )
( zeros. This checks for a shifted signed field.                        )
: CHECK32B  2DUP OR INVERT 0= ( all ones) >R
            INVERT AND 0= ( all zero's ) R> OR ( okay)
            0= 32 ?ERROR ;
( Generate error for postit, if for the inverted BI , some of the the   )
( BITS would stick out it. Leave MASK and BITS . Programming error!     )
: CHECK33 2DUP SWAP INVERT CONTAINED-IN 0= 31 ?ERROR ;
( BITS would stick out it. Leave MASK and BITS . Programming error!     )
( Generate error on data for postit/fixup, if some BITS to fill in      )
( are already in the MASK. Leave BITS and MASK.                         )
: CHECK28 2DUP AND 28 ?ERROR ;
( Generate error on data for commaer, if the BITS to reset are not      )
( present in the MASK. Leave BITS and MASK.                             )
: CHECK29 2DUP OR -1 - 29 ?ERROR   ;
( Generate error if COMMAMASK is not in ascending order. Leave IT.      )
: CHECK30 DUP OLDCOMMA @ < 30 ?ERROR DUP OLDCOMMA ! ;
HEX
( Or DATA into ADDRESS. If bits were already up its wrong.)
: OR! >R R@ @  CHECK28 OR R> ! ;
: OR!U >R R@ @  OR R> ! ; ( Or DATA into ADDRESS. Unchecked.)
( Reset bits of DATA into ADDRESS. If bits were already down it's wrong )
: AND! >R INVERT R@ @ CHECK29 AND R> ! ;

( ------------- ASSEMBLER, DEFINING WORDS    ----------------------------)

( Common fields in the defining words for posits fixups and commaers.   )
( All leave a single ADDRESS.                                           )

( A PIFU is what is common to all parts of an assembler instruction.    )
( Define an pifu by BA BY BI and the PAYLOAD opcode/fixup bits/xt       )
( Two more fields CNT and DSP are typically filled in immediately.      )
( These are never to change after creation!                             )
( Work on TALLY-BI etc.
(           Effects  for posits fixups and commaers.                    )
(                         |||    |||       |||                          )
_ _ _ _ _
class PIFU
  M: DATA^      M;
  M: DATA    @  M; ,    ( OR!    AND!      EXECUTE   )
  M: BI^        M;
  M: BI      @  M; ,    ( OR!    AND!      --        )
  M: BY      @  M; ,    ( OR!    OR!       AND!      )
  M: BA^        M;
  M: BA      @  M; ,    ( OR!U   OR!U      OR!U      )
  M: CNT^       M;
  M: CNT     @  M; 0 , (  `HERE' advances with count )
  M: DSP   ( @) M;      ( displayer only for COMMA , 0 -> default     OVERLAYED )
  M: PRF   ( @) M; 0 ,  ( prefix flag, only for PI ,    0 -> default  OVERLAYED )
endclass

( Make POINTER the current ``PIFU'' object.                             )
: PIFU!   ^PIFU ! ;
( Have a new pifu and make it current, for filling in fields            )
: NEW-PIFU   ( BA BY BI PL -- ) BUILD-PIFU PIFU! ;
( The first data field for a postit/fixup contains instruction bits,    )
( for a commaer it contains the xt of the coma action                   )
( for a data fixup it contains the position of the bits                 )
( It may be necessary to access the fields from the DEA some time       )
\ Make the DEA the current ``PIFU'' object, such that fields can
\ be used.
: PIFU!! %>BODY PIFU! ;
\ From DEA return a field ADDRESS like the above.
: >DATA PIFU!! DATA^ ;
\ : >BI   PIFU!! BI^  ;
\ : >BY   PIFU!! BY^  ;
: >BA   PIFU!! BA^  ;      \ Needed in asalpha.frt
: >CNT  PIFU!! CNT^  ;      ( `HERE' advances with count )
: >DSP  PIFU!! DSP  ;      ( displayer only for COMMA , 0 -> default  )
: >PRF  PIFU!! PRF  ;      ( prefix flag, only for PI , 0 -> default  )

( Assemble INSTRUCTION for ``ISL'' bytes. ls byte first.                )
: assemble, ISL @ 0 DO lsbyte, LOOP DROP ;
: !POSTIT  AS-HERE ISS !  0 OLDCOMMA ! ;  ( Initialise in behalf of postit )
( Bookkeeping for a commaer that is the current PIFU                    )
( Is also used for disassembling.                                       )
: TALLY:,   BI TALLY-BI !   BY TALLY-BY !   BA TALLY-BA OR!U
    CNT ISL !   DSP @ BA-XT ! ;
( Post the instruction using a POINTER to a postit pifu                  )
: POSTIT   CHECK26 PIFU!   !POSTIT !TALLY TALLY:,   DATA assemble, ;
( For DEA : it REPRESENTS some kind of opcode.                          )
IS-A IS-PI   \ Awaiting REMEMBER.
( Define an instruction by BA BY BI and the OPCODE plus COUNT           )
: PI  >R CHECK33 CREATE--  NEW-PIFU R> CNT^ ! DOES> REMEMBER POSTIT ;
( 1 .. 4 byte instructions ( BA BY BI OPCODE : - )
: 1PI   1 PI ;     : 2PI   2 PI ;    : 3PI   3 PI ;    : 4PI   4 PI ;
( Bookkeeping for a fixup that is the current pifu                      )
( Is also used for disassembling.                                       )
: TALLY:|   BI TALLY-BI AND!   BY TALLY-BY OR!   BA TALLY-BA OR!U ;
( Fix up the instruction using a POINTER to a fixup pifu                )
: FIXUP>   PIFU! DATA ISS @ OR!   TALLY:|   CHECK32 ;
( Define a fixup by BA BY BI and the FIXUP bits )
( Because of the or character of the operations, the bytecount is dummy )
IS-A IS-xFI   : xFI   CHECK31 CREATE-- NEW-PIFU DOES> REMEMBER FIXUP> ;

( For a signed DATA item a LENGTH and a BITFIELD. Shift the data item   )
( into the bit field and leave IT. Check if it doesn't fit.             )
: TRIM-SIGNED >R   2DUP R@ SWAP RSHIFT CHECK32B   LSHIFT R> AND ;
( Fix up the instruction using a POINTER to a data fixup pifu           )
: FIXUP-DATA PIFU!   DATA LSHIFT ISS @ OR!   TALLY:| CHECK32 ;
( Fix up the instruction using a POINTER to a signed data fixup pifu    )
: FIXUP-SIGNED PIFU!   DATA BI TRIM-SIGNED   ISS @ OR!
    TALLY:| CHECK32 ;
( Define a data fixup by BA BY BI, and LEN the bit position.            )
( At assembly time: expect DATA that is shifted before use              )
( Because of the or character of the operations, the bytecount is dummy )
IS-A IS-DFI  : DFI   CHECK31A CREATE-- NEW-PIFU DOES> REMEMBER
    FIXUP-DATA ;
( Same, but for signed data.                                    )
IS-A IS-DFIs : DFIs  CHECK31A CREATE-- NEW-PIFU DOES> REMEMBER
FIXUP-SIGNED ;

( *************** OBSOLESCENT ***********************************       )
\ Reverses bytes in a WORD. Return IT.
: REVERSE-BYTES     1 CELLS 0 DO DUP  FF AND SWAP 8 RSHIFT   LOOP
                    8 CELLS 0 DO SWAP I LSHIFT OR       8 +LOOP ;

( Rotate the MASK etc from a fixup-from-reverse into a NEW mask fit )
( for using from the start of the instruction. We know the length!  )
: CORRECT-R 0 CELL+ ISL @ - ROTLEFT ;
( Bookkeeping for a fixup-from-reverse that is the current pifu         )
( Is also used for disassembling.                                       )
: TALLY:|R  BI CORRECT-R TALLY-BI AND!   BY TALLY-BY OR!
    BA TALLY-BA OR!U ;
( Fix up the instruction from reverse with DATA. )
: FIXUP<   CORRECT-R ISS @ OR!   ;
( Define a fixup-from-reverse by BA BY BI and the FIXUP bits )
( One size fits all, because of the character of the or-operations. )
( bi and fixup are specified that last byte is lsb, such as you read it )
IS-A IS-FIR   : FIR   CHECK31 CREATE--
   REVERSE-BYTES SWAP REVERSE-BYTES SWAP NEW-PIFU
   DOES> REMEMBER PIFU! DATA FIXUP< TALLY:|R  CHECK32 ;

( Define a data fixup-from-reverse by BA BY BI and LEN to shift )
( One size fits all, because of the character of the or-operations. )
( bi and fixup are specified that last byte is lsb, such as you read it )
IS-A IS-DFIR   : DFIR   CHECK31 CREATE--   SWAP REVERSE-BYTES SWAP NEW-PIFU
    DOES> ( data -- )REMEMBER PIFU! DATA LSHIFT REVERSE-BYTES FIXUP<
    TALLY:|R CHECK32 ;

( Bookkeeping for a commaer that is the current pifu                    )
( Is also used for disassembling.                                       )
: TALLY:,,   BY CHECK30 TALLY-BY AND!   BA TALLY-BA OR!U ;
( Expand the instruction in accordance with the POINTER to a commaer    )
: COMMA PIFU!   TALLY:,,   CHECK32   DATA EXECUTE ;
( Build with an display ROUTINE, with the LENGTH to comma, the BA       )
(  BY information and the XT of a comma-word like `` L, ''               )
: BUILD-COMMA   0 ( BI) SWAP NEW-PIFU   CNT^ !   DSP ! ;
( A disassembly routine gets the ``DEA'' of the commaer on stack.       )
IS-A  IS-COMMA   : COMMAER   CREATE BUILD-COMMA   DOES> REMEMBER COMMA ;

( ------------- ASSEMBLER, SUPER DEFINING WORDS ----------------------)

CREATE PRO-TALLY 3 CELLS ALLOT  ( Prototype for TALLY-BI BY BA )
( Fill in the tally prototype with BA BY BI information                 )
: T! PRO-TALLY !+ !+ !+ DROP ;
( Get the data from the tally prototype back BA BY BI )
: T@ PRO-TALLY 3 CELLS +  @- @- @- DROP ;
( Add INCREMENT to the OPCODE a NUMBER of times, and generate as much   )
( instructions, all with the same BI-BA-BY from ``PRO-TALLY''           )
( For each assembler defining word there is a corresponding family word )
( Words named "--" are mere placeholders. )
: 1FAMILY,    0 DO   DUP >R T@ R> 1PI   OVER + LOOP DROP DROP ;
: 2FAMILY,    0 DO   DUP >R T@ R> 2PI   OVER + LOOP DROP DROP ;
: 3FAMILY,    0 DO   DUP >R T@ R> 3PI   OVER + LOOP DROP DROP ;
: 4FAMILY,    0 DO   DUP >R T@ R> 4PI   OVER + LOOP DROP DROP ;
: xFAMILY|    0 DO   DUP >R T@ R> xFI   OVER + LOOP DROP DROP ;
: FAMILY|R    0 DO   DUP >R T@ R> FIR   OVER + LOOP DROP DROP ;
: xFAMILY|F   0 DO   DUP >R T@ R> DFI   OVER + LOOP DROP DROP ;

( ############### PART II DISASSEMBLER #################################### )

( Tryers try to construct an instruction from current bookkeeping.      )
( They can backtrack to show all possibilities.                         )
( Disassemblers try to reconstruct an instruction from current          )
( bookkeeping. They are similar but disassemblers take one more aspect  )
( into account, a piece of actual code. They do not backtrack but fail. )

( ------------- DATA STRUCTURES -----------------------------------------)
12 BAG DISS          ( A row of dea's representing a disassembly. )
: !DISS DISS !BAG ;
: .DISS-AUX DISS @+ SWAP DO
    I @ DUP IS-COMMA OVER IS-DFI OR OVER IS-DFIs OR IF I DISS - . THEN ID.
 0 CELL+ +LOOP CR ;
( DISS-VECTOR can be redefined to generate testsets)
VARIABLE DISS-VECTOR    ['] .DISS-AUX DISS-VECTOR !
: +DISS DISS BAG+! ;
: DISS? DISS BAG? ;
: DISS- 0 CELL+ NEGATE DISS +! ; ( Discard last item of `DISS' )

( ------------- TRYERS --------------------------------------------------)

( These tryers are quite similar:
( if the DEA on the stack is of the right type and if the precondition  )
( is fullfilled it does the reassuring actions toward the tally as with )
( assembling and add the fixup/posti/commaer to the disassembly struct. )
( as if this instruction were assembled.                                )
( Leave the DEA.                                                        )
: TRY-PI  DUP PIFU!!
    DUP IS-PI IF
    AT-REST? IF
        TALLY:,
        DUP +DISS
    THEN
    THEN
;

: TRY-xFI   DUP PIFU!!
   DUP IS-xFI IF
   BI TALLY-BI @ CONTAINED-IN IF
       TALLY:|
       DUP +DISS
   THEN
   THEN
;
: TRY-DFI   DUP PIFU!!
   DUP IS-DFI OVER IS-DFIs OR IF
   BI TALLY-BI @ CONTAINED-IN IF
       TALLY:|
       DUP +DISS
   THEN
   THEN
;
: TRY-FIR   DUP PIFU!!
   DUP IS-FIR IF
   BI CORRECT-R TALLY-BI @ CONTAINED-IN IF
       TALLY:|R
       DUP +DISS
   THEN
   THEN
;
: TRY-COMMA   DUP PIFU!!
   DUP IS-COMMA IF
   BY TALLY-BY @ CONTAINED-IN IF
       TALLY:,,
       DUP +DISS
   THEN
   THEN
;

( Generate bookkeeping such as to correspond with `DISS'.               )
: REBUILD
    !TALLY
    DISS? IF
        DISS @+ SWAP !DISS DO  ( Get bounds before clearing)
            I @ TRY-PI TRY-xFI TRY-DFI TRY-FIR TRY-COMMA DROP
        0 CELL+ +LOOP
    THEN
;

( Discard the last item of the disassembly -- it is either used up or   )
( incorrect --. Replace DEA with the proper DEA to inspect from here.   )
: BACKTRACK
(   ." BACKTRACKING"                                                    )
    DROP DISS @ @- DISS !
(   DROP DISS @ 0 CELL+ - @                                             )
(   "Failed at :" TYPE DUP ID. CR                                       )
    >NEXT%
(   DISS-                                                               )
    REBUILD
;

( If the disassembly contains something: `AT-REST?' means               )
( we have gone full cycle rest->postits->fixups->commaers               )
( Return: the disassembly CONTAINS a result.                             )
: RESULT? AT-REST? DISS? AND   BAD? 0= AND ;

( If present, print a result and continue searching for a new last item )
: .RESULT
    RESULT? IF
        DISS-VECTOR @ EXECUTE
        DISS-
        REBUILD
    THEN
;

( Try to expand the current instruction in `DISS' by looking whether    )
( DEA fits. Leave the NEXT dea.                                         )
: SHOW-STEP
        TRY-PI TRY-DFI TRY-xFI TRY-FIR TRY-COMMA
        .RESULT
        >NEXT%
(       DUP ID.                                                         )
        BAD? IF BACKTRACK THEN
        BEGIN DUP VOCEND? DISS? AND WHILE BACKTRACK REPEAT
;

( Show all the instructions present in the assembler vocabulary )
: SHOW-ALL
    !DISS   !TALLY
    STARTVOC BEGIN
       SHOW-STEP
    DUP VOCEND? UNTIL DROP
;

( Show all the opcodes present in the assembler vocabulary )
: SHOW-OPCODES
    !DISS   !TALLY
    STARTVOC BEGIN
       DUP IS-PI IF DUP %ID. THEN >NEXT%
    DUP VOCEND? UNTIL DROP
;

( Show at least all instructions valid for the "OPCODE" given. )
: SHOW:
    !DISS   !TALLY
    ' DUP BEGIN
        SHOW-STEP
     OVER DISS CELL+ @ - OVER VOCEND? OR UNTIL DROP DROP
;

( ------------- DISASSEMBLERS ------------------------------------------------)

( Contains the position that is being disassembled                      )
VARIABLE AS-POINTER       HERE AS-POINTER !

( Get the valid part of the INSTRUCTION under examination               )
: INSTRUCTION  ISS @   ISL @   MC@ ;

\ This is kept up to date during disassembly.
\ It is useful for intelligent disassemblers.
VARIABLE LATEST-INSTRUCTION

( These disassemblers are quite similar:                                )
( if the DEA on the stack is of the right type and if the               )
( precondition is fullfilled and if the dissassembly fits,              )
( it does the reassuring actions toward the tally as with               )
( assembling and add the fixup/posti/commaer to the                     )
( disassembly struct.                                                   )
( Leave the DEA.                                                        )
: DIS-PI
    DUP IS-PI IF
    AT-REST? IF
    BI^ CNT MC@ INVERT
    >R AS-POINTER @ CNT MC@ R>   AND
    DATA = IF
        TALLY:,
        DUP +DISS
        DUP LATEST-INSTRUCTION !
        AS-POINTER @ ISS !
        CNT AS-POINTER +!
    THEN
    THEN
    THEN
;
: DIS-xFI
   DUP IS-xFI IF
   BI TALLY-BI @ CONTAINED-IN IF
   BI INSTRUCTION AND   DATA = IF
   BA COMPATIBLE? IF
       TALLY:|
       DUP +DISS
   THEN
   THEN
   THEN
   THEN
;
: DIS-DFI
   DUP IS-DFI OVER IS-DFIs OR IF
   BI TALLY-BI @ CONTAINED-IN IF
   BA COMPATIBLE? IF
       TALLY:|
       DUP +DISS
   THEN
   THEN
   THEN
;
: DIS-DFIR
   DUP IS-DFIR IF
   BI CORRECT-R   TALLY-BI @ CONTAINED-IN IF
   BA COMPATIBLE? IF
       TALLY:|R
       DUP +DISS
   THEN
   THEN
   THEN
;
: DIS-FIR
   DUP IS-FIR IF
   BI CORRECT-R   TALLY-BI @ CONTAINED-IN IF
   BI CORRECT-R   INSTRUCTION AND   DATA CORRECT-R = IF
   BA COMPATIBLE? IF
       TALLY:|R
       DUP +DISS
   THEN
   THEN
   THEN
   THEN
;

: DIS-COMMA
   DUP IS-COMMA IF
   BY TALLY-BY @ CONTAINED-IN IF
   BA COMPATIBLE? IF
       TALLY:,,
       DUP +DISS
   THEN
   THEN
   THEN
;

( Print a disassembly for the data-fixup DEA.                           )
: .DFI   DUP PIFU!!
    INSTRUCTION   BI AND   DATA RSHIFT   U.
    %ID.                         ( DEA -- )
;

( Print a disassembly for the data-fixup from reverse DEA.              )
: .DFIR   DUP PIFU!!
    INSTRUCTION   BI CORRECT-R AND   DATA RSHIFT
    REVERSE-BYTES CORRECT-R U.
    %ID.                         ( DEA -- )
;

( Print a standard disassembly for the commaer DEA.                     )
: .COMMA-STANDARD   DUP PIFU!!
    AS-POINTER @ CNT MC@ U.
    CNT AS-POINTER +!
    %ID.                         ( DEA -- )
;

( Print a signed disassembly for the commaer DEA.                       )
: .COMMA-SIGNED   DUP PIFU!!
    AS-POINTER @ CNT MC@ .
    CNT AS-POINTER +!
    %ID.                         ( DEA -- )
;

( Print the disassembly for the commaer DEA, advancing `AS-POINTER' past   )
( the comma-content                                                     )
: .COMMA   DUP PIFU!!
    DSP @ IF   DSP @ EXECUTE   ELSE .COMMA-STANDARD   THEN ;

( Print the DEA but with suppression, i.e. ignore those starting in '~' )
: %~ID. DUP IGNORE? IF DROP ELSE %ID. THEN  ;

( Print the disassembly `DISS'                                          )
: .DISS   DISS @+ SWAP DO
    I @
    DUP IS-COMMA IF
        .COMMA
    ELSE DUP IS-DFI IF
        .DFI
    ELSE DUP IS-DFIs IF
        .DFI            \ For the moment.
    ELSE DUP IS-DFIR IF
        .DFIR
    ELSE
        %~ID.
    THEN THEN THEN THEN
 0 CELL+ +LOOP
;

VARIABLE I-ALIGNMENT    1 I-ALIGNMENT !   ( Instruction alignment )

( From AS-POINTER show memory because the code there can't be              )
( disassembled. Leave incremented AS-POINTER.                              )
: SHOW-MEMORY  BEGIN COUNT . ."  C, " DUP I-ALIGNMENT @ MOD WHILE REPEAT ;

( Dissassemble one instruction from AS-POINTER starting at DEA. )
( Based on what is currently left in `TALLY!' )
( Leave a AS-POINTER pointing after that instruction. )
: ((DISASSEMBLE))
    SWAP
    DUP AS-POINTER !   >R
    3 SPACES
    ( startdea -- ) BEGIN  DUP PIFU!!
        DIS-PI DIS-xFI DIS-DFI DIS-DFIR DIS-FIR DIS-COMMA
        >NEXT%
(       DUP ID. ." : "  DISS-VECTOR @ EXECUTE                                 )
    DUP VOCEND? RESULT? OR UNTIL DROP
    RESULT? IF
      .DISS     \ Advances pointer past commaers
      LATEST-INSTRUCTION @ >PRF @ BA-XT !
      RDROP AS-POINTER @
    ELSE
      R> SHOW-MEMORY
    THEN
;

( Dissassemble one instruction from ADDRESS using the whole instruction set )
( and starting with a clean slate. )
( Leave an ADDRESS pointing after that instruction.                     )
: (DISASSEMBLE)   !DISS !TALLY STARTVOC ((DISASSEMBLE)) ;

( Forced dissassembly of one instruction from `AS-POINTER'. )
( Force interpretation as DEA instruction. )
( This is useful for instructions that are known or hidden by an other  )
( instruction that is found first.                             )
: FORCED-DISASSEMBLY
    !DISS   !TALLY   AS-POINTER @ SWAP ((DISASSEMBLE)) DROP ;

( Dissassemble one instruction from address ONE to address TWO. )
: DISASSEMBLE-RANGE
    SWAP   BEGIN DUP ADORN-ADDRESS    (DISASSEMBLE) 2DUP > 0= UNTIL   2DROP
;

( ********************* DEFINING WORDS FRAMEWORK ********************** )
( Close an assembly definition: restore and check.)
: END-CODE
    ?CSP ?EXEC CHECK26 CHECK32 PREVIOUS
; IMMEDIATE

( FIXME : we must get rid of this one )
: ;C POSTPONE END-CODE "WARNING: get rid of C;" TYPE CR ; IMMEDIATE

\ The following two definitions must *NOT* be in the assembler wordlist.
PREVIOUS DEFINITIONS DECIMAL

ASSEMBLER
( Define "word" using assembly instructions up till END-CODE )
( One could put a ``SMUDGE'' in both. )
: CODE
    ?EXEC (WORD) (CREATE) POSTPONE ASSEMBLER !TALLY !CSP
; IMMEDIATE

( Like ``DOES>'' but assembly code follows, closed by END-CODE )
: ;CODE
    ?CSP   POSTPONE (;CODE)   POSTPONE [   POSTPONE ASSEMBLER
; IMMEDIATE

( ************************* CONVENIENCES ****************************** )

( Abbreviations for interactive use. In the current dictionary. )
    : DDD (DISASSEMBLE) ;
    : D-R DISASSEMBLE-RANGE ;

( *********************************** NOTES *************************** )
( 1. A DEA is an address that allows to get at header data like flags   )
(     and names. In ciforth an xt will do.                              )

PREVIOUS
