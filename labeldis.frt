 ( $Id$ )
 ( Copyright{2004}: Albert van der Horst, HCC FIG Holland by GNU Public License)
 ( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( Handle labels as far as disassembly is concerned.                     )
( There is a separate one for the assembler.                            )

REQUIRE ALIAS
REQUIRE @+
REQUIRE QSORT
REQUIRE EXCHANGE
REQUIRE BIN-SEARCH
REQUIRE POSTFIX
REQUIRE H.      \ In behalf of (DH.)
REQUIRE 2>R
REQUIRE BAG             \ Simple bag facility

1000 CONSTANT MAX-LABEL

\ : \D ;

\ -------------------- INTRODUCTION --------------------------------


\ -------------------- generic definition of labels ----------------

\ A bag with the dea's of all labelclasses.
100 BAG THE-REGISTER

\ Labels are bags of two cell structs, a target address and a pointer
\ to the payload (mostly a string).
\ They are sorted on target address for convenience.

\ Realloc ADDRESS to new LENGTH, return new ADDRESS.
\ Ignoring old length, we may copy garbage, too bad.
: REALLOC   HERE >R   DUP ALLOT   R@ SWAP MOVE   R> ;

\ Realloc POINTER to old buffer to new LENGTH. Afterwards pointer points to
\ new buffer.
: REALLOC-POINTER   >R    DUP @ R> REALLOC   SWAP ! ;

\ Define a class for label-like things of length N.
\ A label-like thing is two cells: address and a payload.
1 'DROP 'DROP \ Reverse of: Dummy decompiler, printer, length.
class LABELSTRUCT
\ Return the DEA of the current label class.
  LATEST
  M: CURRENT-LABEL @ M; DUP ,   THE-REGISTER BAG+!

  M: DECOMP @ EXECUTE M; ,       \ (Re)generate source for INDEX.
  M: .PAY @ EXECUTE M; ,        \ Print payload

\ Remember that from now on two times as much labels are allowed.
  M: DOUBLE-SIZE DUP @ 2* SWAP ! M;
\ Return a VARIABLE containing the max labels allowed.
  M: MAX-LAB @ M;
  DUP ,

  M: LABELS   M;   \ Return ADDRESS
  M: >RELOCATABLE DUP @   OVER - SWAP ! M; \ Make labelclass relocatable
  M: RELOCATABLE> DUP +! M;           \    and back. Don't use in between!
\ Return largest INDEX of labels present.
  M: LAB-UPB |BAG| 2/ M;
\ Reallocate if the class is full. 6 cells : does> pointer, 4 fields and
\ upperbound of bag.
  M: ?REALLOC?
  DROP MAX-LAB LAB-UPB = IF DOUBLE-SIZE
       >RELOCATABLE   CURRENT-LABEL >DFA MAX-LAB 2* 6 + CELLS REALLOC-POINTER
       CURRENT-LABEL EXECUTE   RELOCATABLE> THEN M;
  M: LAB+!   BAG+! ?REALLOC? M;              \ Add to ``LABELS''
  2* BUILD-BAG
endclass

THE-REGISTER !BAG       \ Get rid of dummy registration.


\ For I return the ith LABEL . 1 returns the first label.
\ All indices are compatible with this.
: LABELS[]   1- 2* CELLS LABELS CELL+ + ;

\ Remove label I.
: REMOVE-LABEL   LABELS[] LABELS   2DUP BAG-REMOVE BAG-REMOVE ;

\ Loop through all ``LABELS'', similar to ``DO-BAG .. DO-LOOP'' but with
\ a stride of 2 cells and the bag built-in.
: DO-LAB POSTPONE LABELS POSTPONE DO-BAG ; IMMEDIATE
: LOOP-LAB   2 CELLS POSTPONE LITERAL POSTPONE +LOOP ; IMMEDIATE

\ A simple printout of the payload.
: .PAY. CELL+ ? ;

\ Print the payload of the label at ADDRESS , provided it is a string.
: .PAY$     CELL+ @ $@ TYPE   3 SPACES ;

\ Print the name of the label at ADDRESS , provided it is a dea.
\ This applies to plain labels that are in fact fact constants.
: .PAY-DEA  CELL+ @ %ID. ;

\ Make section I current, provided the payload is a dea.
: MAKE-CURRENT LABELS[] CELL+ @ EXECUTE ;

\ For label INDEX return the label NAME, provided it is a dea.
: LABEL-NAME   LABELS[] CELL+ @ >NFA @ $@ ;

\ Print the addresses and payloads of the labels.
: .LABELS  DO-LAB I @ .  I .PAY CR LOOP-LAB ;


\ Return LOWER and UPPER indices of the labels , inclusive.
\ The lower index is 1 and the upper index is corresponding.
: LAB-BOUNDS   1 LAB-UPB ;

\ In behalf of qsort.
\ For INDEX1 and INDEX2: "the value of the first
\ label IS less than that of the second"
: LAB<  LABELS[] @ SWAP LABELS[] @ SWAP < ;

\ In behalf of qsort.
\ Exchange the labels with INDEX1 and INDEX2 .
: LAB<->  LABELS[] SWAP LABELS[]  2 CELLS   EXCHANGE ;

\ Sort the labels of ``LABELS'' in ascending order.
: SORT-LABELS   LAB-BOUNDS   'LAB<   'LAB<->   QSORT ;

\ In behalf of bin-search.
\ Comparant
VARIABLE CONT

\ In behalf of bin-search.
\ For INDEX1 : "the value of the label IS less than ``CONT''"
: L<    LABELS[] @   CONT @   < ;


\ Find where ADDRESS belongs in a sorted array. Return the INDEX.
\ If address is already present, its index is returned.
\ This may be outside, if it is larger than any.
: WHERE-LABEL   CONT !   LAB-BOUNDS 1+   'L<   BIN-SEARCH   ;

VARIABLE LABEL-CACHE    \ Index of next label.
\ Find the first label that is equal to (or greater than) VALUE
\ Return INDEX or zero if not found. Put it in the label-cache too.
\ Note ``BIN-SEARCH'' returns the non-inclusive upper bound if not found.
: FIND-LABEL   WHERE-LABEL   DUP LAB-UPB 1+ <> AND    DUP LABEL-CACHE ! ;

\ Find ADDRESS in the label table. Return ADDRESS of an exact
\ matching label or zero if not found.
: >LABEL   FIND-LABEL DUP IF LABELS[]  DUP @  CONT @ - IF DROP 0 THEN THEN ;

\ Roll the last label to place INDEX.
\ A label occupies two consecutive places!
: ROLL-LABEL   DUP   LABELS[]  DUP LABELS BAG-HOLE   LABELS BAG-HOLE
   LAB-BOUNDS SWAP DROP   LAB<->   -2 CELLS LABELS  +! ;

\ FIXME: The following is dead code. (As is LABEL-CACHE).
\ Return the next label or 0.
: NEXT-LABEL   LABEL-CACHE @   DUP IF
   1+ DUP LAB-BOUNDS + = IF DROP 0 THEN
   DUP LABEL-CACHE ! THEN ;

\ ---------------- Names of labels ------------------------------

\ Decompile label INDEX.
: .EQU    LABELS[] DUP @ H. " EQU " TYPE  CELL+ @ %ID. CR ;

\ Contains equ labels, i.e. classes as associate with ``LABEL''
MAX-LABEL '.PAY-DEA '.EQU LABELSTRUCT EQU-LABELS        LABELS !BAG

\ Generate a equ label at (target) ADDRESS with "NAME", this can be
\ any symbolic constant in fact.
\ The payload is the dea of a constant leaving that address.
: LABEL   EQU-LABELS   DUP LAB+!   CONSTANT   LATEST LAB+! ;

\ Generate a equ label at (target) ADDRESS with NAME. Like ``LABEL''.
: LABELED   POSTFIX CONSTANT   EQU-LABELS   LATEST DUP EXECUTE LAB+! LAB+! ;

'LABEL ALIAS EQU


\ For host ADDRESS return an associated equ LABEL or 0.
\ CAVEAT: if there are more than one label for the same addres,
\ just the first one is returned.
: =EQU-LABEL   HOST>TARGET  EQU-LABELS >LABEL ;

\ For host ADDRES print all labels at that addres,
\ return the NUMBER of labels printed.
: .EQU-ALL   HOST>TARGET  EQU-LABELS   0 ( no labels printed) SWAP
   LAB-UPB 1+ OVER WHERE-LABEL ?DO
       DUP I LABELS[] @ <> IF LEAVE THEN
       SWAP 1+ SWAP
       &: EMIT I LABELS[] .PAY
   LOOP DROP ;

\ Adorn the ADDRESS we are currently disassembling with a named label
\ if any.
: ADORN-WITH-LABEL   .EQU-ALL    0= IF 12 SPACES THEN ;

HEX FFFF0000 CONSTANT LARGE-NUMBER-MASK

\ Prevent leading hex letter for NUMBER by printing a zero.
: .0?   DUP 0A0 100 WITHIN SWAP 0A 10 WITHIN OR IF &0 EMIT THEN ;

\ Print a NUMBER in hex in a smart way.
: SMART.   DUP ABS 100 < IF DUP .0? . ELSE
    LARGE-NUMBER-MASK OVER AND IF H. ELSE 0 4 (DH.) TYPE THEN SPACE THEN ;

DECIMAL
( Print X as a symbolic label if possible, else as a number             )
: .LABEL/.   EQU-LABELS DUP >LABEL DUP IF .PAY DROP ELSE DROP SMART. THEN ;

\D 12 LABEL AAP
\D 5 LABEL NOOT
\D 2 LABEL MIES
\D 123 LABEL POPI

\D .LABELS CR
\D SORT-LABELS
\D .LABELS CR

\D 200 FIND-LABEL . CR
\D 12 FIND-LABEL  LABELS[] .PAY CR
\D 12 1- FIND-LABEL  LABELS[] .PAY CR
\D 12 >LABEL .PAY CR
\D 12 1- >LABEL H. CR
\D 12 ADORN-WITH-LABEL  .S CR  \ Should give zero, not found!
\D 12 0 HOST>TARGET - ADORN-WITH-LABEL  CR

\ For label INDEX , return its XT.
: @LABEL    LABELS[] CELL+ @ ;

\D 5 DUP INVENT-NAME LABELED
\D SORT-LABELS .LABELS .S CR
\D .LABELS .S CR
\D ." EXPECT 5: " 5 FIND-LABEL @LABEL EXECUTE . .S CR

\ For labels INDEX1 and INDEX2 return "they ARE equal".
: LABEL=   @LABEL EXECUTE   SWAP @LABEL EXECUTE   = ;

\D ." EXPECT -1:" 5 FIND-LABEL .S DUP 1+ .S LABEL= .S CR

\ Get rid of a label with INDEX if trivial . Return next INDEX to try.
: REMOVE-TRIVIAL   DUP @LABEL DUP EXECUTE SWAP >NFA @ $@ INVENTED-NAME? IF
    DUP REMOVE-LABEL ELSE 1+ THEN ;

\D 5 FIND-LABEL DUP REMOVE-TRIVIAL   REMOVE-TRIVIAL
\D .LABELS .S CR

\ Get rid of superfluous equ labels
: CLEAN-LABELS   EQU-LABELS
    2 BEGIN DUP LAB-UPB < WHILE DUP DUP 1- LABEL= >R DUP DUP 1+ LABEL= R> OR IF
    REMOVE-TRIVIAL ELSE 1+ THEN REPEAT DROP ;

\D 5 DUP INVENT-NAME LABELED  SORT-LABELS
\D .LABELS .S CR
\D CLEAN-LABELS
\D .LABELS .S CR

\ ---------------- Comment till remainder of line ------------------------------

\ Decompile comment: label INDEX.
: .COMMENT:   LABELS[] DUP @ H. " COMMENT: " TYPE  CELL+ @ $@ TYPE CR ;

\ Contains comment labels, i.e. classes as associate with ``COMMENT:''
MAX-LABEL '.PAY$ '.COMMENT: LABELSTRUCT COMMENT:-LABELS LABELS !BAG

\ Generate a comment label at ADDRESS. A pointer to the
\ remainder of the line is the payload.
: COMMENT:   COMMENT:-LABELS   LAB+!  ^J (PARSE) $, LAB+! ;

\ Remember the comment at the end of this instruction.
\ Zero means no comment.
VARIABLE COMMENT:-TO-BE

\ Initialise to no comment.
: INIT-COMMENT:   0 COMMENT:-TO-BE ! ;

  INIT-COMMENT:

\ Print comment at the end of previous instruction.
: PRINT-OLD-COMMENT:   COMMENT:-TO-BE @ DUP IF
    "\ " TYPE   $@ TYPE _ THEN DROP    INIT-COMMENT: ;

\ Remember what comment to put after the disassembly of ADDRESS .
: REMEMBER-COMMENT:   COMMENT:-LABELS   HOST>TARGET >LABEL
    DUP IF CELL+ @ COMMENT:-TO-BE ! _ THEN DROP  ;

\D 12 COMMENT: AAP
\D 115 COMMENT: NOOTJE
\D 2 COMMENT: MIES
\D 123 COMMENT: POPI

\D .LABELS CR
\D SORT-LABELS
\D .LABELS CR

\D 200 FIND-LABEL . CR
\D 12 FIND-LABEL  LABELS[] .PAY CR
\D 12 1- FIND-LABEL  LABELS[] .PAY CR
\D 12 >LABEL .PAY CR
\D 12 1- >LABEL H. CR

\D 12 REMEMBER-COMMENT: PRINT-OLD-COMMENT: CR  \ Should give nothing, not found!
\D 12 0 HOST>TARGET - REMEMBER-COMMENT: PRINT-OLD-COMMENT: CR

\ ---------------- Multiple line comment in front ----------------------------

\ Decompile mcomment label INDEX.
: .MCOMMENT   LABELS[] DUP CELL+ @ $@ ."$" SPACE @ H. " COMMENT " TYPE  CR ;

\ Contains multiple line comment labels, i.e. classes as associate with ``COMMENT''
MAX-LABEL '.PAY$ '.MCOMMENT LABELSTRUCT MCOMMENT-LABELS LABELS !BAG

\ Make STRING the comment in front of label at ADDRESS. A pointer to this
\ string the payload.
: COMMENT   MCOMMENT-LABELS   LAB+!  $, LAB+! ;

\ Print comment for instruction at ADDRESS , if any.
: PRINT-COMMENT MCOMMENT-LABELS  HOST>TARGET  >LABEL DUP IF
   CR   "\ " TYPE   .PAY _ THEN DROP ;

\D "AAP" 12 COMMENT
\D "NOOT" 5 COMMENT
\D "MIES" 2 COMMENT
\D "POPI
\D JOPI"
\D 123 COMMENT

\D .LABELS CR
\D SORT-LABELS
\D .LABELS CR

\D 200 FIND-LABEL . CR
\D 12 FIND-LABEL  LABELS[] .PAY CR
\D 12 1- FIND-LABEL  LABELS[] .PAY CR
\D 12 >LABEL .PAY CR
\D 12 1- >LABEL H. CR

\D 12 PRINT-COMMENT CR  \ Should give nothing, not found!
\D 12 0 HOST>TARGET - PRINT-COMMENT CR

\ ---------------- The special printing of strings.     --------------------------------------

REQUIRE NEW-IF

\ Contains a printing indicator :
\ 0 as hex                      8A
\ 1 control character           ^J
\ 2 a blank                     BL  "xxx xxx"
\ 3 normal printable            &Z  "xxxZxxx"
CREATE TABLE 256 ALLOT      TABLE 256 ERASE
&~ 1 + BL 1 + DO 3 TABLE I + C! LOOP
2 BL TABLE + C!
1 ^I TABLE + C!
1 ^J TABLE + C!
1 ^M TABLE + C!
1 ^L TABLE + C!

\ For CHAR: " it IS control"
: IS-CTRL   TABLE + C@ 1 = ;

\D ." EXPECT 0 -1 :" &A IS-CTRL .   ^J IS-CTRL . CR .S

\ For CHAR: " it IS printable"
: IS-PRINT   TABLE + C@ 1 > ;

\D ." EXPECT 0 -1 -1 :" ^A IS-PRINT .   &A IS-PRINT . BL IS-PRINT . CR .S

\ Accumulates characters that may form a string.
CREATE ACCU 100 ALLOT           ACCU 100 ERASE

\D ." Expect "  """ AA""""AA """ TYPE &: EMIT " AA""AA " ."$" CR .S

\ Print the accumulated chars, if any.
: .ACCU   ACCU $@
    OVER C@ BL = OVER 1 = AND IF 2DROP SPACE &B EMIT &L EMIT ELSE
    DUP 1 > IF SPACE ."$" ELSE
    IF SPACE && EMIT C@ EMIT ELSE DROP THEN THEN THEN 0 0 ACCU $! ;

\D ." EXPECT "  """XY""" TYPE &: EMIT "XY" ACCU $! .ACCU CR .S
\D ." EXPECT BL :"   " " ACCU $!   .ACCU CR .S
\D ." EXPECT &Y :"   "Y" ACCU $!   .ACCU CR .S

\ Display a BYTE in clean hex.
: .B-CLEAN   DUP .0? 0 <# BL HOLD #S #> TYPE ;
\ Display the non-printable character.
: .C   .ACCU SPACE DUP IS-CTRL IF &^ EMIT &@ + EMIT ELSE .B-CLEAN THEN  ;

\D ." EXPECT ^J: "  ^J .C CR .S
\D ." EXPECT 0: "  0 .C CR .S
\D ." EXPECT 9A: "  HEX 9A .C CR .S DECIMAL
\D ." EXPECT 0FA: "  HEX FA .C CR .S DECIMAL

\ FIXME: to be renamd in WHERE-FLUSH
VARIABLE NEXT-CUT       \ Host address where to separate db etc. in chunks.

\ For ADDR of a (printable) char, add it to the accumulated range.
\ Force an immediate flush, if the range is full.
\ Otherwise postpone the flush at least one char.
\ If the character following is a string ender, this is a desirable
\ place to break. (String enders like ^J and 0 are not printable.)
: ACCU-$C+   DUP C@ ACCU $C+   ACCU @ 64 = IF 1+ ELSE 2 + THEN NEXT-CUT ! ;


\ ---------------- Things to print at the start of a line --------------------------------------

\ Print the ADDRES as target address in hex.
: .TARGET-ADDRESS "( " TYPE DUP HOST>TARGET H. " )   " TYPE ;

\ Start a new line, with printing the decompiled ADDRESS as seen
: CR-ADORNED
    PRINT-OLD-COMMENT:
    DUP PRINT-COMMENT
    CR .TARGET-ADDRESS
    ADORN-WITH-LABEL ;


\ For ADDRESS: "it IS at next cut." If so, advance.
: NEXT-CUT?   NEXT-CUT @ =  DUP IF 16 NEXT-CUT +! THEN ;

\ For ADDRESS and assembler directive STRING (such "db") ,
\ interrupt the laying down of memory classes by a new line and possibly
\ a label, when appropriate.

: CR+GENERIC   2>R DUP =EQU-LABEL >R DUP NEXT-CUT?   R> OR IF
     DUP CR-ADORNED  2R@ TYPE THEN REMEMBER-COMMENT: RDROP RDROP ;

: CR+$         2>R DUP =EQU-LABEL >R DUP NEXT-CUT?   R> OR IF .ACCU
     DUP CR-ADORNED  2R@ TYPE THEN REMEMBER-COMMENT: RDROP RDROP ;

\ For ADDRESS : interupt byte display.
: CR+db   "  db " CR+GENERIC ;
: CR+dw   "  dw " CR+GENERIC ;
: CR+dl   "  dl " CR+GENERIC ;
: CR+d$   "  d$ " CR+$ ;


\ ---------------- Specifiers of disassembly ranges ----------------------

\ A section, as we all know, is a range of addresses that is kept
\ together, even during relocation and such.
\ Section ADDRESS1 .. ADDRESS2 always refers to a target range,
\ where address2 is exclusive.

\ Define a section.
12 34 '2DROP
class DIS-STRUCT
   >R >R >R          \ Get them in reverse order.
   M: DIS-START @ M; R> ,     \ Start of range
   M: DIS-END! ! M;       \ End of range
   M: DIS-END   @ M; R> ,       \ End of range
   M: DIS-STRIDE   @ M; 1 ,  \ For the moment FIXME!
   M: DIS-XT   @ M;
   M: DIS-RANGE   @ >R DIS-START DIS-END R> EXECUTE M; R> ,       \ End of range
endclass

\ Print the section LAB as a matter of testing.
: .PAY-SECTION CELL+ @ DUP EXECUTE
   DIS-START H.  SPACE DIS-END H.  " BY " TYPE DIS-XT %ID.  %ID. ;

20 BAG SECTION-TYPES  \ Contains dea of dumper, creator, alternating.

\ DEA of dump belongs to DEA of creator. Add to ``SECTION-TYPES''.
: ARE-COUPLED   SWAP SECTION-TYPES BAG+! SECTION-TYPES BAG+! ;

\ For current section, return the XT of a proper defining word.
: CREATOR-XT   DIS-XT SECTION-TYPES BAG-WHERE CELL+ @ ;

\ Display section INDEX in a reconsumable form.
: DECOMP-SECTION   DUP MAKE-CURRENT DIS-START H. SPACE DIS-END H. SPACE
    CREATOR-XT ID. LABEL-NAME TYPE CR ;

\ Contains sector specification, range plus type.
MAX-LABEL '.PAY-SECTION 'DECOMP-SECTION   LABELSTRUCT SECTION-LABELS   LABELS !BAG

\ Create a disassembly section from AD1 to AD2 using dis-assembler DEA1
\ with NAME. Register it as a labeled section.
: SECTION   POSTFIX  DIS-STRUCT   SECTION-LABELS   DIS-START LAB+!   LATEST LAB+! ;
\ Create a disassembly section from AD1 to AD2 using dis-assembler DEA1 and
\ end-of-line action DEA2 without a name. Register it as a labeled section.
: ANON-SECTION   NONAME$ SECTION ;

\ Disassemble from target ADDRESS1 to ADDRESS2.
: D-R-T SWAP TARGET>HOST SWAP TARGET>HOST  D-R ;

\ Section ADDRESS1 .. ADDRESS2 is code with name NAME.
: -dc    2>R 'D-R-T   2R> SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is code with name "name".
: -dc:    (WORD) -dc ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous code section.
: -dc-    NONAME$ -dc ;

'D-R-T     '-dc:   ARE-COUPLED

\ Dump bytes from target ADDRESS1 to ADDRESS2 plain.
: (DUMP-B)   DO I DUP CR+db C@ .B-CLEAN LOOP   PRINT-OLD-COMMENT: CR ;

\ Dump bytes from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-B   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-B) ;

\ Section ADDRESS1 .. ADDRESS2 are bytes with name NAME.
: -db    2>R 'DUMP-B 2R> SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are bytes with name "name".
: -db:    (WORD) -db ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous byte section.
: -db-    NONAME$ -db ;

'DUMP-B    '-db:   ARE-COUPLED \ Register the decompiler.

\ Print X as a word (4 hex digits).
: W. 0 4 (DH.) TYPE SPACE ;

\ Dump words from target ADDRESS1 to ADDRESS2, plain.
: (DUMP-W)   DO I DUP CR+dw @ W. 2 +LOOP   PRINT-OLD-COMMENT: CR ;

\ Dump words from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-W   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-W) ;

\ Section ADDRESS1 .. ADDRESS2 are words with name NAME.
: -dw    2>R 'DUMP-W 2R> SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are words with name "name".
: -dw:    (WORD) -dw ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous word section.
: -dw-    NONAME$ -dw ;

'DUMP-W    '-dw:   ARE-COUPLED

\ Dump words from target ADDRESS1 to ADDRESS2.
: (DUMP-L)   DO I DUP CR+dl @ .LABEL/. 4 +LOOP PRINT-OLD-COMMENT: CR   ;

\ Dump words from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-L   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-L) ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name NAME.
: -dl    2>R 'DUMP-L 2R> SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name "name".
: -dl:    (WORD) -dl ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous long section.
: -dl-    NONAME$ -dl ;

'DUMP-L    '-dl:   ARE-COUPLED

\ Print all chars to ADDR1 from ADDR2 appropriately.
\ Try to combine, playing with the next flush.
: (DUMP-$)
    DO  I CR+d$
        I C@ IS-PRINT   IF I ACCU-$C+ ELSE I C@ .C THEN
    LOOP  .ACCU   PRINT-OLD-COMMENT: CR ;

\D "AAP" $, ^J C, ^M C, &A C, &A C, BL C, &P C, 0 C, 1 C, BL C, 2 C, 3 C,
\D HERE
\D " EXPECT  ``3 0 0 0 ""AAP"" XX ^J ^M ""AA P"" 0 1 BL 2 3 '':" TYPE
\D .S SWAP (DUMP-$) CR .S

\ Dump words from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-$   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-$) ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name NAME.
: -d$    2>R 'DUMP-$ 2R> SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name "name".
: -d$:    (WORD) -d$ ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous long section.
: -d$-    NONAME$ -d$ ;

'DUMP-$    '-d$:   ARE-COUPLED

\ Print a remark about whether START and END fit.
: .HOW-FIT   2DUP = IF 2DROP ELSE
   > IF "\ WARNING: This section overlaps with the previous one." ELSE
   "\ WARNING: There is hole between this section and the previous one" THEN
   CR TYPE CR THEN ;

\ Print a remark about whether start of the current range fits to the
\ END of the previous range. Leave END of current range for the next check.
: HOW-FIT   DIS-START .HOW-FIT DIS-END ;

\ Print a remark about whether the END of the previous range is really
\ the end of the input file.
: HOW-FIT-END    TARGET-END .HOW-FIT ;

\ Disassemble all those sectors with their own disassemblers.
\ No section will print their end labels, which is no problem if everything
\ fits, except for the last section. Do that expressly.
: DISASSEMBLE-ALL   TARGET-START
    SECTION-LABELS DO-LAB I CELL+ @ EXECUTE   HOW-FIT DIS-RANGE LOOP-LAB
    HOW-FIT-END   HOST-END CR-ADORNED ;

\ ------------------- Generic again -------------------

\ During assembly there is no decision needed whether to have a new line.
\ Just do new line at ADDRESS, and get the eol-comment, if any.
: (ADORN-ADDRESS)       DUP CR-ADORNED   REMEMBER-COMMENT: ;

\ Revector ``ADORN-ADDRESS'' used in "asgen.frt".
'(ADORN-ADDRESS) >DFA @   'ADORN-ADDRESS >DFA !

\ Initialise all registered labelclasses.
: INIT-ALL   THE-REGISTER DO-BAG   I @ EXECUTE LABELS !BAG   LOOP-BAG
    INIT-COMMENT: ;

\ Sort all registered labelclasses.
: SORT-ALL   THE-REGISTER DO-BAG   I @ EXECUTE SORT-LABELS   LOOP-BAG ;

\ Decompile all labels of current labelclass.
: DECOMP-ONE  LAB-UPB 1+ 1 ?DO I DECOMP LOOP ;

\ Generate the source of all labelclasss.
: DECOMP-ALL THE-REGISTER DO-BAG   I @ EXECUTE DECOMP-ONE   LOOP-BAG ;

\ Make a full blown cul file from the internal data.
: MAKE-CUL  TARGET-START H. " -ORG-" TYPE CR DECOMP-ALL ;

\ Show what type of labels there are.
: SHOW-REGISTER   THE-REGISTER DO-BAG I @ %ID. LOOP-BAG ;

\ Disassemble the current program as stored in the ``CODE-BUFFER''.
\ Using what is known about it.
: DISASSEMBLE-TARGET
    TARGET-START . " ORG" TYPE CR   DISASSEMBLE-ALL   ;

\ i386 dependant, should somehow be separated out.
: DISASSEMBLE-TARGET "BITS-32" TYPE CR  DISASSEMBLE-TARGET CR  ;

( ----------------------------------                                    )
( asi386 dependant part, does it belong here?                           )


ASSEMBLER
( Not yet definitions, these thingies must be visible in the            )
( disassembler.                                                         )

(                       SECTIONS                                        )

\ Disassemble from target ADDRESS1 to ADDRESS2 as 16 bit.
: D-R-T-16  BITS-16 CR "BITS-16" TYPE D-R-T BITS-32 CR "BITS-32" TYPE ;

\ Section ADDRESS1 .. ADDRESS2 is 16-bit code with name NAME.
: -dc16    2>R 'D-R-T-16   2R> SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is 16-bit code with name "name".
: -dc16:   (WORD) -dc16 ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous 16-bit code-section.
: -dc16-   NONAME$ -dc16 ;

'D-R-T-16   '-dc16:   ARE-COUPLED

DEFINITIONS

( ----------------------------------                                    )
( generic again                                                         )

\ ------------------- INSTRUCTIONS -------------------

\ DEA is a commaer. Fetch proper DATA from autoincremented
\ ``AS-POINTER''
: AS-@+   >CNT @ >R   AS-POINTER @ R@ MC@   R> AS-POINTER +! ;

\D HEX
\D ." EXPECT 34 12 " 1234 PAD ! PAD AS-POINTER ! 'IB, DUP AS-@+ . AS-@+ .
\D DECIMAL

\ DEA is a commaer. Fetch proper signed DATA from autoincremented
\ ``AS-POINTER''
: AS-S-@+   >CNT @ >R   AS-POINTER @ R@ MC@-S   R> AS-POINTER +! ;

\D HEX
\D ." EXPECT -1 12 " 12FF PAD ! PAD AS-POINTER ! 'IB, DUP AS-S-@+ . AS-S-@+ .
\D DECIMAL

\ This is kept up to date during disassembly.
\ It is useful for the code crawler.
VARIABLE LATEST-OFFSET

( Print a disassembly, for a commaer DEA , taking into account labels,  )
( {suitable for e.g. the commaer ``IX,''}                               )
: .COMMA-LABEL   DUP AS-@+ .LABEL/. %ID. ;

(  For DEA print the name without the surrounding brackets.             )
: ID.-NO()   >NFA @ $@  2 - SWAP 1 + SWAP TYPE ;

(  Assuming the disassembly sits at the offset of a relative branch     )
(  assembled by commaer DEA , return the host space ADDRESS of the next )
(  instruction.                                                         )
: NEXT-INSTRUCTION  >CNT @ AS-POINTER @ + ;

(  Assuming the disassembly sits at the offset of a relative branch     )
(  assembled by commaer DEA , return that OFFSET.                       )
: GET-OFFSET   AS-POINTER @ SWAP >CNT @ MC@-S DUP LATEST-OFFSET ! ;

( For the commaer DEA return ADDRESS in host space that is the target   )
( of the current relative jump.                                         )
: GOAL-RB   DUP GET-OFFSET SWAP NEXT-INSTRUCTION + ;

( For the relative branch commaer DEA print the target ADDRESS as a     )
( symbolic label if possible else print the branch offset, followed     )
( by an appropriate commaer for each case.                              )
: .BRANCH/.  EQU-LABELS
  >LABEL DUP IF   .PAY ID.-NO() ELSE   DROP DUP GET-OFFSET . %ID. THEN  ;

( Print a disassembly for a relative branch DEA .                       )
( This relies on the convention that the commaer that consumes an       )
( absolute address has the name of that with a relative address         )
( surrounded with brackets.                                             )
: .COMMA-REL
   DUP  DUP GOAL-RB HOST>TARGET  .BRANCH/.
   >CNT @ AS-POINTER +! ;

\D 5 .LABEL/. CR
\D 5 .LABEL/. CR
\D '(RB,) ID.-NO() CR

'.COMMA-LABEL  'OW,   >DIS ! ( obligatory word     )
'.COMMA-REL    '(RL,) >DIS !  ( cell relative to IP )
'.COMMA-REL    '(RW,) >DIS !  ( cell relative to IP )
'.COMMA-REL    '(RB,) >DIS !  ( byte relative to IP )
'.COMMA-LABEL  'SG,   >DIS !  (  Segment: WORD      )
'.COMMA-LABEL  'P,    >DIS !  ( port number ; byte     )
'.COMMA-LABEL  'IS,   >DIS !  ( Single -obl-  byte )
'.COMMA-LABEL  'IL,   >DIS !  ( immediate data : cell)
'.COMMA-LABEL  'IW,   >DIS !  ( immediate data : cell)
'.COMMA-LABEL  'IB,   >DIS !  ( immediate byte data)
'.COMMA-LABEL  'L,    >DIS !  ( immediate data : address/offset )
'.COMMA-LABEL  'W,    >DIS !  ( immediate data : address/offset )
'.COMMA-LABEL  'B,    >DIS !  ( immediate byte : address/offset )


\ Contains all instruction that represent an unconditional transfer
\ of control. It may be followed by data instead of code.
0 BAG UNCONDITIONAL-TRANSFERS
\   'CALL, , 'CALLFAR, , 'CALLFARO, , 'CALLO, , 'INT, , 'INT3, , 'INTO, ,
  'IRET, , 'JMP, , 'JMPFAR, , 'JMPFARO, , 'JMPO, , 'JMPS, , 'RET+, ,
  'RET, , 'RETFAR+, , 'RETFAR, ,
HERE UNCONDITIONAL-TRANSFERS !

\ Contains all instructions that represent intra-segment jumps.
0 BAG JUMPS
   'CALL, , 'J, , 'JCXZ, , 'JMP, , 'JMPS, , 'J|X, , 'LOOP, , 'LOOPNZ,
   , 'LOOPZ, ,
HERE JUMPS !

PREVIOUS DEFINITIONS
