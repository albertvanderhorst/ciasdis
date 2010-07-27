( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( REVERSE ENGINEERING ASSEMBLER  cias cidis                             )

( This file `asgen.frt' contains generic tools and has been used to     )
( make assemblers for 8080 8086 80386 Pentium Alpha 6809 and should     )
( be usable for 68000 6502 8051.                                        )
( It should be possible to port it to ISO Forth's but some ciforth      )
( facilities must be present or need to be emulated.                    )
( The assemblers have the property that the disassembled code is        )
( assembled to the exact same code.                                     )

( Most instruction set follow this basic idea that it contains of three )
( distinct parts:                                                       )
(   1. the opcode that identifies the operation                         )
(   2a. modifiers such as the register working on                       )
(   2b. data, as a bit field in the instruction.                        )
(   3. data, including addresses or offsets.                            )
( These parts have properties. There is only one opcode. Modifiers      )
( and data-as-bitfields essentially have no order. And data such as     )
( addresses, offsets, immediate data has to be supplied in an exact     )
( order.                                                          )

( This assembler goes through three stages for each instruction:        )
(   1. postit: assembles the opcode with holes for the modifiers.       )
(      This has a fixed length. Also posts requirements for commaers.   )
(   2a. fixup: fill up the holes, either from the beginning or the      )
(     end of the post. These can also post required commaers            )
(   2b. fixup's with data. It has user supplied data in addition to     )
(      opcode bits. Both together fill up the holes left by a postit.   )
(   3. The commaers. Any user supplied data in addition to              )
(      opcode, that can be added as separate whole bytes. Each sort     )
(      of data has a separate command, where the checks are built       )
(      in.                                                              )
( Keeping track of this is done by bit arrays, similar to the a.i.      )
( blackboard concept. This is ONLY to notify the user of mistakes,      )
( they are NOT needed for the assembler proper.                         )
( A fast assembler for trusted source can be extracted where all        )
( checks are ommitted. The result is compact indeed.                    )
( This setup allows a complete check of validity of code and complete   )
( control over what code is generated. Even so all checks can be        )
( defeated if need be.                                                  )

( The generic tools include:                                            )
(   - the defining words for 1 2 3 4 byte postits,                      )
(                        for fixups from front and behind               )
(                        for data fixups from front and behind          )
(                        for comma-ers,                                 )
(   - showing a list of possible instructions, for all opcodes or       )
(      for a single one.                                                )
(   - disassembly of a single instruction or a range                    )
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
( resetting bits. They conventionally end in `|' where the other        )
( assembly actions end in `,' to stress that they advance HERE. They    )
( may demand more commaers, posting to `TALLY-BY'.                      )

( The commaers advance `HERE' by a whole number of bytes assembling     )
( user supplied information and reset the corresponding bits in         )
( `TALLY-BY'                                                            )

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

( A prefix is an instruction in its own right. It communicates only     )
( through the BAD bits to restrict the instructions following.          )
( A prefix PostIt has its prefix field filled in with an execution      )
( token. This token represents the action performed on the TALLY-BA     )
( flags, that the next POSTIT uses, instead of resetting it. This       )
( can be used for example for the OS -- operand size -- prefix in       )
( the Pentium. Instead of putting the information that we are in a      )
( 16 bit operand segment in TALLY-BA , it transforms that information   )
( to 32 bit.                                                            )

( ############### PRELUDE ############################################# )

\ Facilities
REQUIRE ALIAS
REQUIRE @+ ( Fetch from ADDRES. Leave incremented ADDRESS and DATA )
REQUIRE BAG
REQUIRE DO-BAG
REQUIRE POSTFIX
REQUIRE class

( If we are to use sections and the label mechanisms, these are hot     )
( patched. Note that these words get separate headers such that the     )
( original remain functional.                                           )

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
( We use the abstraction of a dea "dictionary entry address" of a       )
( wor to find properties of a word, like its name. In ciforth this      )
( DEA serves as an execution token.                                     )
( Return the DEA from "word". 1]                                        )

( Find a DEA for "name" , this is a porting convenience, for in ciforth )
( it is just an alias for ' .                                           )
' ' ALIAS %

: %ID. >NFA @ $@ TYPE SPACE ;   ( Print a definitions name from its DEA.)
VOCABULARY ASSEMBLER IMMEDIATE   ASSEMBLER DEFINITIONS HEX

: %>BODY   >BODY ; ( From DEA to the DATA field of a created word )
: %BODY>   BODY> ; ( Reverse of above)
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
( Note that the assembler works with multi-character l.s. byte first    )
( numbers. This means that the l.s byte of a postit is commaed in       )
( first. With fixups-from-reverse it means that HERE-1 is fixed up      )
( with the l.s. byte, then going back.                                  )
( See the word ``assemble,'' .                                          )

( Is the FIRST bitset contained in the SECOND one? Leaving:"it IS"      )
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
( Generate error for ``FIXUP-NUMBER'' , if the BI and the LEN           )
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

( ############### PART II DISASSEMBLER #################################### )

( Tryers try to construct an instruction from current bookkeeping.      )
( They can backtrack to show all possibilities.                         )
( Disassemblers try to reconstruct an instruction from current          )
( bookkeeping. They are similar but disassemblers take one more aspect  )
( into account, a piece of actual code. They do not backtrack but fail. )

( ------------- DATA STRUCTURES -----------------------------------------)
20 BAG DISS          ( A row of dea's representing a disassembly. )
: !DISS DISS !BAG ;
: +DISS DISS BAG+! ;
: DISS? DISS BAG? ;
: DISS- DISS BAG@- DROP ; ( Discard last item of `DISS' )
: DISS@- DISS BAG@- ;

( Contains the position that is being disassembled                      )
VARIABLE AS-POINTER       HERE AS-POINTER !

( Get the valid part of the INSTRUCTION under examination               )
: INSTRUCTION  ISS @   ISL @   MC@ ;

\ This is kept up to date during disassembly.
\ It is useful for intelligent disassemblers.
VARIABLE LATEST-INSTRUCTION

( ############### DEFINING WORDS  ASSEMBLER, DISASSEMBLER ############# )

( Common fields in the defining words for posits fixups and commaers.   )
( ^ means an address. Others are mostly constant data.                  )
( Note that there are several fields for the same offset, so although
( e.g. BA should be considered constant after creation of the pifu      )
( object, it can sometimes be changed through the pointer.              )

( Print the DEA but with suppression, i.e. ignore those starting in '~' )
: %~ID. DUP IGNORE? IF DROP ELSE %ID. THEN  ;

( A PIFU is what is common to all parts of an assembler instruction.    )
( Define an pifu by BA BY BI and the PAYLOAD opcode/fixup bits/xt       )
( Two more fields CNT and DSP are typically filled in immediately.      )
( These are never to change after creation!                             )
( Work on TALLY-BI etc.
(        Effects  for posits fixups and commaers.                    )
(                      |||    |||       |||                          )
(   DATA                OR!    AND!      EXECUTE                        )
( M: BI    @  M; ,      OR!    AND!      --                             )
( M: BY    @  M; ,      OR!    OR!       AND!                           )
( M: BA    @  M; ,      OR!U   OR!U      OR!U                           )
( Indented fields are aliases. `^' indicate a pointer                   )

( Rotate the MASK etc from a fixup-from-reverse into a NEW mask fit )
( for using from the start of the instruction. We know its length!  )
: CORRECT-R 0 CELL+ ISL @ - ROTLEFT ;
_ _ _ _ _       ( BI BA BY DAT )
class PIFU
   M: DAT^     M;
   M: DAT-R   @ CORRECT-R M;  ( data if "from-reverse" )
   M: SHT   @  M;             ( shift count )
  M: DAT  @   M; ,            ( regular data )
   M: BI^      M;
   M: BI-R   @ CORRECT-R M;   ( fixup bit if "from-reverse" )
  M: BI    @  M; ,            ( postit or regular fixup bits)
  M: BY    @  M; ,            ( bytes, mask for commaers )
   M: BA^      M;
  M: BA    @  M; ,            ( Bad mask)
   M: CNT^     M;
  M: CNT   @  M; 0 , (  `HERE' advances with count, commaer or postit )
  M: DSP^     M; '%~ID. ,   ( display and advance while disassembling )
  M: PRF      M; 0 ,  ( prefix xt, only for PI ,  0 -> default )
  M: DIS^     M; 0 ,  ( Disassembly action )
  M: TRY^     M; 0 ,  ( Attempted disassembly action )
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
: >DATA PIFU!! DAT^ ;
\ : >BI   PIFU!! BI^  ;
\ : >BY   PIFU!! BY^  ;
: >BA   PIFU!! BA^  ;      \ Needed in asalpha.frt
: >CNT  PIFU!! CNT^  ;      ( `HERE' advances with count )
: >DSP  PIFU!! DSP^  ;
: >PRF  PIFU!! PRF  ;      ( prefix flag, only for PI , 0 -> default  )

( All pifu words have a defining word, such as PI, a tally word such    )
( as TALLY:, , a doer like POSTIT, a builder mostly directly after      )
( the CREATE, a disassembler like DIS-PI, a tryer to fit words together )
( during disassembly like TRY-PI and an identification that tell        )
( whether a DEA is of this pifu subclass.                               )
( Only commaers generally have a stack effect during execution.         )
( If there is a stack effect for non-comma words, it is indicated       )
( after the DOES>.                                                      )

( ------------- PIFU's : PI ---------------------------------------------)
( Assemble INSTRUCTION for ``ISL'' bytes. ls byte first.                )
: assemble, ISL @ 0 DO lsbyte, LOOP DROP ;
: !POSTIT  AS-HERE ISS !  0 OLDCOMMA ! ;  ( Initialise in behalf of postit )
( Bookkeeping for a commaer that is the current PIFU                    )
( Is also used for disassembling.                                       )
: TALLY:,   BI TALLY-BI !   BY TALLY-BY !   BA TALLY-BA OR!U
    CNT ISL !   PRF @ BA-XT ! ;
( Post the instruction using a POINTER to a postit pifu                  )
: POSTIT   CHECK26 PIFU!   !POSTIT !TALLY TALLY:,   DAT assemble, ;
( A disassembler for the current, postit PIFU. leave IT.                )
: DIS-PI   AT-REST? IF   BI^ CNT MC@ INVERT   >R AS-POINTER @ CNT MC@ R>
    AND   DAT = IF   TALLY:, DUP +DISS   DUP LATEST-INSTRUCTION !
    AS-POINTER @ ISS !   CNT AS-POINTER +! THEN THEN ;
\ Match the tally to PIFU, a (current) postit. Leave IT.
: TRY-PI AT-REST? IF TALLY:, DUP +DISS THEN ;
( For DEA : it REPRESENTS some kind of opcode.                          )
IS-A IS-PI   \ Awaiting REMEMBER.
( Define an instruction by BA BY BI and the OPCODE plus COUNT           )
: PI  >R CHECK33 CREATE--  NEW-PIFU R> CNT^ !   'DIS-PI DIS^ !
    'TRY-PI TRY^ !   DOES> REMEMBER POSTIT ;
( 1 .. 4 byte instructions ( BA BY BI OPCODE : - )
: 1PI   1 PI ;     : 2PI   2 PI ;    : 3PI   3 PI ;    : 4PI   4 PI ;

( ------------- PIFU's : xFI---------------------------------------------)
( Bookkeeping for a fixup that is the current pifu                      )
( Is also used for disassembling.                                       )
: TALLY:|   BI TALLY-BI AND!   BY TALLY-BY OR!   BA TALLY-BA OR!U ;
( Fix up the instruction using a POINTER to a fixup pifu                )
: FIXUP>   PIFU! DAT ISS @ OR!   TALLY:|   CHECK32 ;
: DIS-xFI   BI TALLY-BI @ CONTAINED-IN IF   BI INSTRUCTION AND   DAT = IF
   BA COMPATIBLE? IF   TALLY:| DUP +DISS THEN THEN THEN ;
\ Match the tally to PIFU, a (current) fixup. Leave IT.
: TRY-xFI   BI TALLY-BI @ CONTAINED-IN IF TALLY:| DUP +DISS THEN ;
( Define a fixup by BA BY BI and the FIXUP bits )
( Because of the or character of the operations, the bytecount is dummy )
IS-A IS-xFI   : xFI   CHECK31 CREATE-- NEW-PIFU   'DIS-xFI DIS^ !
    'TRY-xFI TRY^ !   DOES> REMEMBER FIXUP> ;

( ------------- PIFU's : DFI DFIs ---------------------------------------)
( For a signed DATA item a LENGTH and a BITFIELD. Shift the data item   )
( into the bit field and leave IT. Check if it doesn't fit.             )
: TRIM-SIGNED >R   2DUP R@ SWAP RSHIFT CHECK32B   LSHIFT R> AND ;
( Fix up with UNSIGNED using a POINTER to a data fixup pifu             )
: FIXUP-NUMBER PIFU!   SHT LSHIFT ISS @ OR!   TALLY:| CHECK32 ;
( Fix up with SIGNED using a POINTER to a signed data fixup pifu        )
: FIXUP-SIGNED PIFU!   SHT BI TRIM-SIGNED ISS @ OR!   TALLY:| CHECK32 ;
( Print a disassembly for the data-fixup DEA that must be current )
: .DFI    INSTRUCTION   BI AND   SHT RSHIFT   U. %ID. ;
( A disassembler for the current, data fixup PIFU. leave IT             )
: DIS-DFI   BI TALLY-BI @ CONTAINED-IN IF   BA COMPATIBLE? IF
    TALLY:| DUP +DISS THEN THEN ;
\ Match the tally to PIFU, a (current) fixup. Leave IT.
: TRY-DFI   BI TALLY-BI @ CONTAINED-IN IF TALLY:| DUP +DISS THEN ;
( Define a data fixup by BA BY BI, and LEN the bit position.            )
( At assembly time: expect DATA that is shifted before use              )
( Because of the or character of the operations, the bytecount is dummy )
IS-A IS-DFI  : DFI   CHECK31A CREATE-- NEW-PIFU   '.DFI DSP^ !
   'DIS-DFI DIS^ !   'TRY-DFI TRY^ !
    DOES> ( u -- )REMEMBER FIXUP-NUMBER ;
( Same, but for signed data, a convenience. Disassembly shows unsigned  )
IS-A IS-DFIs : DFIs  CHECK31A CREATE-- NEW-PIFU   '.DFI DSP^ !
    'DIS-DFI DIS^ !   'TRY-DFI TRY^ !
    DOES> ( n -- ) REMEMBER FIXUP-SIGNED ;

( ------------- PIFU's : FIR DFIR ---------------------------------------)
\ Reverses bytes in a WORD. Return IT.
: REVERSE-BYTES     1 CELLS 0 DO DUP  FF AND SWAP 8 RSHIFT   LOOP
                    8 CELLS 0 DO SWAP I LSHIFT OR       8 +LOOP ;

( Bookkeeping for a fixup-from-reverse that is the current pifu         )
( Is also used for disassembling.                                       )
: TALLY:|R  BI-R TALLY-BI AND!   BY TALLY-BY OR!
    BA TALLY-BA OR!U ;
( Fix up the instruction using a POINTER to a reverse fixup pifu    )
: FIXUP-REVERSE PIFU!   DAT-R ISS @ OR!   TALLY:|R  CHECK32 ;
( Fix up the instruction from reverse with DATA. )
: FIXUP-N-REVERSE   PIFU! SHT LSHIFT REVERSE-BYTES CORRECT-R   ISS @ OR!
    TALLY:|R CHECK32 ;
( A disassembler for the current, fixup from reverse PIFU. leave IT     )
: DIS-FIR   BI-R   TALLY-BI @ CONTAINED-IN IF   BI-R
  INSTRUCTION AND   DAT-R = IF   BA COMPATIBLE? IF TALLY:|R
  DUP +DISS THEN THEN THEN ;
\ Match the tally to PIFU, a (current) fixup from reverse. Leave IT.
: TRY-FIR   BI-R TALLY-BI @ CONTAINED-IN IF   TALLY:|R DUP +DISS THEN ;
( Define a fixup-from-reverse by BA BY BI and the FIXUP bits )
( One size fits all, because of the character of the or-operations. )
( bi and fixup are specified that last byte is lsb, such as you read it )
IS-A IS-FIR   : FIR   CHECK31 CREATE--
   REVERSE-BYTES SWAP REVERSE-BYTES SWAP NEW-PIFU   'DIS-FIR DIS^ !
   'TRY-FIR TRY^ !   DOES> REMEMBER FIXUP-REVERSE ;
( Print a disassembly for the current, 'data-fixup from reverse' DEA     )
: .DFIR   INSTRUCTION   BI-R AND   SHT RSHIFT   REVERSE-BYTES
    CORRECT-R U.   %ID. ;
( Disassemble the current, data fixup from reverse PIFU. leave IT     )
: DIS-DFIR   BI-R   TALLY-BI @ CONTAINED-IN IF   BA COMPATIBLE? IF
    TALLY:|R DUP +DISS THEN THEN ;
( Define a data fixup-from-reverse by BA BY BI and LEN to shift )
( One size fits all, because of the character of the or-operations. )
( bi and fixup are specified that last byte is lsb, such as you read it )
IS-A IS-DFIR   : DFIR   CHECK31 CREATE--   SWAP REVERSE-BYTES SWAP NEW-PIFU
    '.DFIR DSP^ !   'DIS-DFIR DIS^ !
    DOES> ( data -- )REMEMBER FIXUP-N-REVERSE ;

( ------------- PIFU's : COMMAER ----------------------------------------)
( Bookkeeping for a commaer that is the current pifu                    )
( Is also used for disassembling.                                       )
: TALLY:,,   BY CHECK30 TALLY-BY AND!   BA TALLY-BA OR!U ;
( Expand the instruction in accordance with the POINTER to a commaer    )
: COMMA PIFU!   TALLY:,,   CHECK32   DAT EXECUTE ;
( Print a standard disassembly for the commaer DEA that must be current )
: .COMMA-STANDARD   AS-POINTER @ CNT MC@ U.   CNT AS-POINTER +!   %ID. ;
( Print a signed disassembly for the commaer DEA that must be current )
: .COMMA-SIGNED   AS-POINTER @ CNT MC@ .   CNT AS-POINTER +!   %ID. ;
( A disassembler for the current, commaer PIFU. leave IT                )
: DIS-COMMA   BY TALLY-BY @ CONTAINED-IN IF   BA COMPATIBLE? IF
     TALLY:,, DUP +DISS THEN THEN ;
\ Match the tally to PIFU, a (current) commaer. Leave IT.
: TRY-COMMA   BY TALLY-BY @ CONTAINED-IN IF TALLY:,, DUP +DISS THEN ;
( Build with an display ROUTINE, with the LENGTH to comma, the BA       )
(  BY information and the XT of a comma-word like `` L, ''               )
: BUILD-COMMA   0 ( BI) SWAP NEW-PIFU   CNT^ !   DUP 0= IF
    DROP '.COMMA-STANDARD THEN DSP^ !   'DIS-COMMA DIS^ !
    'TRY-COMMA TRY^ ! ;
( A disassembly routine gets the ``DEA'' of the commaer on stack.       )
( The stack diagram of DOES> is inherited from the XT passed.           )
IS-A  IS-COMMA   : COMMAER   CREATE BUILD-COMMA  DOES> REMEMBER COMMA ;

( For DEA: leave IT and:"it IS some pifu"                               )
( This could be replaced by a link field in pifu's to link them together)
( Dea's have the advantage of access to the name, so we need this to     )
( allow regular definitions amongst the pifu's                          )
: IS-PIFU   DUP IS-PI   OVER IS-xFI OR   OVER IS-DFI OR   OVER IS-DFIs OR
  OVER IS-DFIR OR   OVER IS-FIR OR   OVER IS-COMMA OR ;

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

( ################## DISASSEMBLER ################################# )

: .DISS-AUX DISS @+ SWAP DO
    I @ DUP IS-COMMA OVER IS-DFI OR OVER IS-DFIs OR IF I DISS - . THEN ID.
 0 CELL+ +LOOP CR ;
( DISS-VECTOR can be redefined to generate testsets)
VARIABLE DISS-VECTOR    ['] .DISS-AUX DISS-VECTOR !

( ------------- fitting pieces together -----------------------------)

( A tryer does the following :                                          )
( if the DEA on the stack is of the right type and if the precondition  )
( is fullfilled it does the reassuring actions toward the tally as with )
( assembling and add the fixup/posti/commaer to the disassembly struct. )
( as if this instruction were assembled.                                )
( Leave the DEA.                                                        )

( Generate bookkeeping such as to correspond with `DISS'.               )
: REBUILD
    !TALLY
    DISS? IF
        DISS @+ SWAP !DISS DO  ( Get bounds before clearing)
            I @ DUP PIFU!!
            IS-PIFU IF TRY^ @ EXECUTE THEN DROP
        0 CELL+ +LOOP
    THEN
;

( Discard the last item of the disassembly -- it is either used twice   )
( or incorrect. Replace DEA with the proper DEA to inspect from here.   )
: BACKTRACK
\      DROP DISS @ @- DISS !
      DROP DISS@-
>NEXT%   REBUILD ;

( If the disassembly contains something: `AT-REST?' means               )
( we have gone full cycle rest->postits->fixups->commaers               )
( Return: the disassembly CONTAINS a result.                             )
: RESULT? AT-REST? DISS? AND   BAD? 0= AND ;

( If present, print a result and continue searching for a new last item )
: .RESULT   RESULT? IF DISS-VECTOR @ EXECUTE   DISS- REBUILD THEN ;

( Try to expand the current instruction in `DISS' by looking whether    )
( DEA fits. Leave the next DEA, or vocend to stop.                                         )
: SHOW-STEP   DUP PIFU!!   IS-PIFU IF TRY^ @ EXECUTE THEN   .RESULT
   >NEXT% ( DUP ID. )   BAD? IF BACKTRACK THEN
   BEGIN DUP VOCEND? DISS? AND WHILE BACKTRACK REPEAT
;

( Show all the instructions present in the assembler vocabulary )
: SHOW-ALL   !DISS !TALLY   STARTVOC BEGIN SHOW-STEP   DUP VOCEND? UNTIL
    DROP ;

( Show all the opcodes present in the assembler vocabulary )
: SHOW-OPCODES   !DISS !TALLY   STARTVOC BEGIN   DUP IS-PI IF DUP %ID. THEN
    >NEXT%   DUP VOCEND? UNTIL DROP ;

( Show at least all instructions valid for the "OPCODE" given. )
: SHOW:
    !DISS !TALLY   ' ( "OPCODE")
    DUP BEGIN SHOW-STEP   OVER DISS CELL+ @ <>   OVER VOCEND? OR UNTIL
    DROP DROP ;

( ------------- DISASSEMBLERS ------------------------------------------------)

( Disassemblers -- DIS fields --are quite similar:                      )
( if the DEA on the stack is of the right type and if the               )
( precondition is fullfilled and if the dissassembly fits,              )
( it does the reassuring actions toward the tally as with               )
( assembling and add the fixup/posti/commaer to the                     )
( disassembly struct.                                                   )
( Leave the DEA.                                                        )

( Print the disassembly `DISS'                                          )
( All commaers must advance `AS-POINTER''                               )
: .DISS   DISS DO-BAG I @   DUP PIFU!!   DSP^ @ EXECUTE LOOP-BAG ;

VARIABLE I-ALIGNMENT    1 I-ALIGNMENT !   ( Instruction alignment )

( From AS-POINTER show memory because the code there can't be              )
( disassembled. Leave incremented AS-POINTER.                              )
: SHOW-MEMORY  BEGIN COUNT . ."  C, " DUP I-ALIGNMENT @ MOD WHILE REPEAT ;

( Dissassemble one instruction from AS-POINTER using the pifu's from    )
( PIFU on. Build on what is currently left in `TALLY!'                  )
( Leave a AS-POINTER pointing after that instruction.                   )
: ((DISASSEMBLE))
    SWAP
    DUP AS-POINTER !   >R
    3 SPACES
    ( startdea -- ) BEGIN  DUP PIFU!!
        IS-PIFU IF DIS^ @ EXECUTE THEN
        >NEXT%
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
( Force interpretation as PIFU instruction. )
( This is useful for instructions that are known or hidden by an other  )
( instruction that is found first.                             )
: FORCED-DISASSEMBLY
    !DISS   !TALLY   AS-POINTER @ SWAP ((DISASSEMBLE)) DROP ;

( Dissassemble instructions from address ONE to address TWO. )
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
