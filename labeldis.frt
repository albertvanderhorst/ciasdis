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
REQUIRE struct

: \D POSTPONE \ ;

\ -------------------- INTRODUCTION --------------------------------


\ -------------------- generic definition of labels ----------------

\ A bag with the dea's of all labelstruct 's.
100 BAG THE-REGISTER

\ Labels are bags of two cell structs, a target address and a pointer
\ to the payload (mostly a string).
\ They are sorted on target address for convenience.

\ Define a structure for label-like things of length N.
\ A label-like thing is two cells: address and a payload.
1 'DROP \ Dummy printer, dummy length
struct LABELSTRUCT
  F: DECOMP , FDOES> @ EXECUTE ;        \ (Re)generate source for INDEX.
  F: .PAY , FDOES> @ EXECUTE ;          \ Print payload
  F: LAB+!  FDOES> SET+! ;              \ Add to ``LABELS''
  F: LABELS   2* BUILD-BAG   LATEST THE-REGISTER BAG+! FDOES> ;
endstruct

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

\ Return highest INDEX allowed in labels.
: LAB-UPB   LABELS |BAG| 2/ ;

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


\ Find the INDEX where ADDRESS belongs in a sorted array.
\ This may be outside, if it is larger than any.
: WHERE-LABEL   CONT !   LAB-BOUNDS 1+   'L<   BIN-SEARCH   ;

VARIABLE LABEL-CACHE    \ Index of next label.
\ Find the first label that is equal to (or greater than) VALUE
\ Return INDEX or zero if not found. Put it in the label-cache too.
\ Note ``BIN-SEARCH'' returns the non-inclusive upper bound if not found.
: FIND-LABEL   WHERE-LABEL   DUP LAB-UPB 1+ <> AND    DUP LABEL-CACHE ! ;

\ Find ADDRESS in the label table. Return DEA of an exact
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

\ Contains equ labels, i.e. structs as associate with ``LABEL''
1000 '.PAY-DEA '.EQU LABELSTRUCT EQU-LABELS        LABELS !BAG

\ Generate a equ label at (target) ADDRESS with "NAME", this can be
\ any symbolic constant in fact.
\ The payload is the dea of a constant leaving that address.
: LABEL   EQU-LABELS   DUP LAB+!   CONSTANT   LATEST LAB+! ;

\ Generate a equ label at (target) ADDRESS with NAME. Like ``LABEL''.
: LABELED   POSTFIX CONSTANT   EQU-LABELS   LATEST DUP EXECUTE LAB+! LAB+! ;

'LABEL ALIAS EQU


\ For host ADDRESS return an associated equ LABEL (target) or 0.
: =EQU-LABEL   HOST>TARGET  EQU-LABELS >LABEL ;

\ Print an equ LABEL as an assembly line label. Accept zero.
: .EQU-LABEL   DUP IF &: EMIT .PAY ELSE DROP 12 SPACES THEN ;

\ Adorn the ADDRESS we are currently disassembling with a named label
\ if any.
: ADORN-WITH-LABEL   =EQU-LABEL .EQU-LABEL ;

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

\ ---------------- Comment till remainder of line ------------------------------

\ Decompile comment: label INDEX.
: .COMMENT:   LABELS[] DUP @ H. " COMMENT: " TYPE  CELL+ @ $@ TYPE CR ;

\ Contains comment labels, i.e. structs as associate with ``COMMENT:''
1000 '.PAY$ '.COMMENT: LABELSTRUCT COMMENT:-LABELS LABELS !BAG

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
    "\ " TYPE   $@ TYPE _ THEN DROP ;

\ Remember what comment to put after the disassembly of ADDRESS .
: REMEMBER-COMMENT:   COMMENT:-LABELS   HOST>TARGET >LABEL
    DUP IF CELL+ @ THEN   COMMENT:-TO-BE ! ;

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

\ Contains multiple line comment labels, i.e. structs as associate with ``COMMENT''
1000 '.PAY$ '.MCOMMENT LABELSTRUCT MCOMMENT-LABELS LABELS !BAG

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


\ Display the non-printable character.
: .C   .ACCU SPACE DUP IS-CTRL IF &^ EMIT &@ + EMIT ELSE 0 <# #S #> TYPE THEN  ;

\D ." EXPECT ^J: "  ^J .C CR .S
\D ." EXPECT 0: "  0 .C CR .S
\D ." EXPECT 9A: "  9A .C CR .S

\ Print all chars from ADDR1 to ADDR2 appropriately.
\ Try to combine.
: (DUMP-$)   DO I DUP ADORN-ADDRESS C@ DUP IS-PRINT IF
    ACCU $C+ ELSE .C THEN LOOP .ACCU ;

\D "AAP" $, ^J C, ^M C, &A C, &A C, BL C, &P C, 0 C, 1 C, BL C, 2 C, 3 C,
\D HERE
\D ." EXPECT"  "``3 0 0 0 ""AAP"" XX ^J ^M ""AA P"" 0 1 BL 2 3 '':" TYPE
\D .S (DUMP-$) CR .S


\ ---------------- Things to print at the start of a line --------------------------------------


: .TARGET-ADDRESS "( " TYPE DUP HOST>TARGET H. " )   " TYPE ;
\ Start a new line, with printing the decompiled ADDRESS as seen
: CR+ADDRESS CR .TARGET-ADDRESS ;

VARIABLE NEXT-CUT       \ Host address where to separate db etc. in chunks.

\ Initialise to the start of the code space.
: NEXT-CUT!   CODE-SPACE NEXT-CUT ! ;

\ For ADDRESS: "it IS at next cut." If so, advance.
: NEXT-CUT?   NEXT-CUT @ =  DUP IF 16 NEXT-CUT +! THEN ;

\ For ADDRESS and assembler directive STRING (such "db") ,
\ interrupt the laying down of memory structures by a new line and possibly
\ a label, when appropriate.
: CR+GENERIC   2>R DUP =EQU-LABEL >R DUP NEXT-CUT?   R> OR IF
     CR+ADDRESS  ADORN-WITH-LABEL 2R@ TYPE _ THEN DROP RDROP RDROP ;

: CR+$         2>R DUP =EQU-LABEL >R DUP NEXT-CUT?   R> OR IF .ACCU
     CR+ADDRESS  ADORN-WITH-LABEL 2R@ TYPE _ THEN DROP RDROP RDROP ;

\ For ADDRESS : interupt byte display.
: CR+db   "  db" CR+GENERIC ;
: CR+dw   "  dw" CR+GENERIC ;
: CR+dl   "  dl" CR+GENERIC ;
: CR+d$   "  d$" CR+$ ;
: CR+LABEL   CR+ADDRESS ADORN-WITH-LABEL ;


\ ---------------- Specifiers of disassembly ranges ----------------------

\ A section, as we all know, is a range of addresses that is kept
\ together, even during relocation and such.
\ Section ADDRESS1 .. ADDRESS2 always refers to a target range,
\ where address2 is exclusive.

\ Define a section.
12 34 '2DROP 'DROP
struct DIS-STRUCT
   F: REVERSE-ORDER >R >R >R >R FDOES> ; \ Cludge, not actually executed.
   F: DIS-START R> , FDOES> @ ;     \ Start of range
   F: DIS-END R> , FDOES> @ ;       \ End of range
   F: DIS-XT FDOES> @ ;
   F: DIS-RANGE R> , FDOES> @ >R DIS-START DIS-END R> EXECUTE ;       \ End of range
   F: DIS-CR-XT FDOES> @ ;       \ Which xt?
   F: DIS-CR R> , FDOES> @ EXECUTE ;       \ What to do at line boundaries.
endstruct

\ To be shown at the end of each range.
        ASSEMBLER
: SHOW-END AS-POINTER @ ADORN-ADDRESS CR ;
        PREVIOUS

: .PAY-SECTION CELL+ @ DUP EXECUTE
   DIS-START H.  SPACE DIS-END H.  " BY " TYPE DIS-XT %ID.  %ID. ;

20 BAG SECTION-TYPES  \ Contains dea of dumper, creator, alternating.

\ DEA of dump belongs to DEA of creator. Add to ``SECTION-TYPES''.
: BELONGS-TO-CREATOR SWAP SECTION-TYPES BAG+! SECTION-TYPES BAG+! ;

\ For current section, return the XT of a proper defining word.
: CREATOR-XT   DIS-XT SECTION-TYPES BAG-WHERE CELL+ @ ;

\ Display section INDEX in a reconsumable form.
: DECOMP-SECTION   DUP MAKE-CURRENT DIS-START H. SPACE DIS-END H. SPACE
    CREATOR-XT ID. LABEL-NAME TYPE CR ;

\ Contains sector specification, range plus type.
1000 '.PAY-SECTION 'DECOMP-SECTION   LABELSTRUCT SECTION-LABELS   LABELS !BAG

\ Specify that section "name" from AD1 to AD2 uses dis-assembler DEA
: SECTION   SECTION-LABELS DIS-STRUCT DIS-START LAB+!  LATEST LAB+!  ;
\ Specify that from AD1 to AD2 dis-assembler DEA is used. (anonymous).
: ANON-SECTION "NONAME" POSTFIX SECTION ;

\ Disassemble from target ADDRESS1 to ADDRESS2.
: D-R-T SWAP TARGET>HOST SWAP TARGET>HOST  D-R SHOW-END ;

\ Section ADDRESS1 .. ADDRESS2 is code with name "name".
: -dc:    'D-R-T   'CR+LABEL SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is code with name NAME.
: -dc    2>R 'D-R-T   'CR+LABEL 2R> POSTFIX  SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous code section.
: -dc-    'D-R-T   'CR+LABEL ANON-SECTION ;

'D-R-T     '-dc:   BELONGS-TO-CREATOR

\ Dump bytes from target ADDRESS1 to ADDRESS2 plain.
: (DUMP-B)   DO I DUP ADORN-ADDRESS C@ 3 .R LOOP CR ;

\ Dump bytes from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-B   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-B) ;

\ Section ADDRESS1 .. ADDRESS2 are bytes with name "name".
: -db:    'DUMP-B   'CR+db SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are bytes with name NAME.
: -db    2>R 'DUMP-B 'CR+db 2R> POSTFIX  SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous byte section.
: -db-    'DUMP-B   'CR+db ANON-SECTION ;

'DUMP-B    '-db:   BELONGS-TO-CREATOR  \ Register the decompiler.

\ Print X as a word (4 hex digits).
: W. 0 4 (DH.) TYPE ;

\ Dump words from target ADDRESS1 to ADDRESS2, plain.
: (DUMP-W)   DO I DUP ADORN-ADDRESS @ SPACE W. 2 +LOOP CR ;

\ Dump words from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-W   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-W) ;

\ Section ADDRESS1 .. ADDRESS2 are words with name "name".
: -dw:    'DUMP-W   'CR+dw SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are words with name NAME.
: -dw    2>R 'DUMP-W 'CR+db 2R> POSTFIX  SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous word section.
: -dw-    'DUMP-W   'CR+dw ANON-SECTION ;

'DUMP-W    '-dw:   BELONGS-TO-CREATOR

\ Dump words from target ADDRESS1 to ADDRESS2.
: (DUMP-L)   DO I DUP ADORN-ADDRESS @ SPACE H. 4 +LOOP CR ;

\ Dump words from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-L   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-L) ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name "name".
: -dl:    'DUMP-L   'CR+dl SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name NAME.
: -dl    2>R 'DUMP-L 'CR+dl 2R> POSTFIX  SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous long section.
: -dl-    'DUMP-L   'CR+dl ANON-SECTION ;

'DUMP-L    '-dl:   BELONGS-TO-CREATOR

\ Dump words from target ADDRESS1 to ADDRESS2 adorned with labels.
: DUMP-$   TARGET>HOST SWAP TARGET>HOST  DUP NEXT-CUT ! (DUMP-$) ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name "name".
: -d$:    'DUMP-$   'CR+d$ SECTION ;

\ Section ADDRESS1 .. ADDRESS2 are longs with name NAME.
: -d$    2>R 'DUMP-$ 'CR+d$ 2R> POSTFIX  SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous long section.
: -d$-    'DUMP-$   'CR+d$ ANON-SECTION ;

'DUMP-$    '-d$:   BELONGS-TO-CREATOR

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

\ Abort if END of last section greater than START of new section.
: OVERLAP-CHECK
   OVER < IF 0 8 (DH.) ETYPE 1 ABORT"  is an address that runs into next section" THEN DROP ;

\ Check whether START and END fit. Plug a new section in
\ if there is a hole. Abort on overlaps.
: PLUG-HOLE   2DUP < IF -d$- ELSE  OVERLAP-CHECK THEN ;

\ Add sectors of type string where there are holes. section-labels must be
\ sorted on entry, and are sorted on exit.
: PLUG-HOLES   TARGET-START SECTION-LABELS DO-LAB
        I CELL+ @ EXECUTE DIS-START   PLUG-HOLE   I CELL+ @ EXECUTE DIS-END
    LOOP-LAB   TARGET-END PLUG-HOLE   SORT-LABELS ;

\ Disassemble all those sectors as if they were code.
: DISASSEMBLE-ALL   NEXT-CUT!   TARGET-START
    SECTION-LABELS DO-LAB I CELL+ @ EXECUTE   HOW-FIT DIS-RANGE LOOP-LAB
    HOW-FIT-END ;

\ ------------------- Generic again -------------------

\ Print out everything we know about ADDRESS.
: (ADORN-ADDRESS)
    PRINT-OLD-COMMENT:
    DUP PRINT-COMMENT
    DUP REMEMBER-COMMENT:
    DIS-CR ( disassembly type dependant action ) ;

\ Revector ``ADORN-ADDRESS'' used in "asgen.frt".
'(ADORN-ADDRESS) >DFA @   'ADORN-ADDRESS >DFA !

\ Initialise all registered labelstructs.
: INIT-ALL   THE-REGISTER DO-BAG   I @ EXECUTE LABELS !BAG   LOOP-BAG
    INIT-COMMENT: ;

\ Sort all registered labelstructs.
: SORT-ALL   THE-REGISTER DO-BAG   I @ EXECUTE SORT-LABELS   LOOP-BAG ;

\ Decompile all labels of current labelstruct.
: DECOMP-ONE  LAB-UPB 1+ 1 ?DO I DECOMP LOOP ;

\ Generate the source of all labelstructs.
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
: DISASSEMBLE-TARGET "BITS-32" TYPE CR  DISASSEMBLE-TARGET ;

\ Using (only) information from file with NAME,
\ disassemble the current program as stored in the ``CODE-BUFFER''.
: CONSULTED   INIT-ALL   HEX INCLUDED ( file)   SORT-ALL
    PLUG-HOLES DISASSEMBLE-TARGET DECIMAL ;

\ Consult "file" as per ``CONSULT''
: CONSULT   (WORD) CONSULTED ;

( ----------------------------------                                    )
( asi386 dependant part, does it belong here?                           )


ASSEMBLER
( Not yet definitions, these thingies must be visible in the            )
( disassembler.                                                         )

(                       SECTIONS                                        )

\ Disassemble from target ADDRESS1 to ADDRESS2 as 16 bit.
: D-R-T-16  BITS-16 CR "BITS-16" TYPE D-R-T BITS-32 CR "BITS-32" TYPE SHOW-END ;

\ Section ADDRESS1 .. ADDRESS2 is 16-bit code with name "name".
: -dc16:    'D-R-T-16   'CR+LABEL SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is 16-bit code with name NAME.
: -dc16    2>R 'D-R-T-16   'CR+LABEL 2R> POSTFIX  SECTION ;

\ Section ADDRESS1 .. ADDRESS2 is an anonymous 16-bit code-section.
: -dc16-    'D-R-T-16   'CR+LABEL ANON-SECTION ;

'D-R-T-16   '-dc16:   BELONGS-TO-CREATOR

DEFINITIONS

(                       INSTRUCTIONS                                    )

\ This is kept up to date during disassembly.
\ It is useful for the code crawler.
VARIABLE LATEST-OFFSET

( Print X as a symbolic label if possible, else as a number             )
: .LABEL/.   EQU-LABELS DUP >LABEL DUP IF .PAY DROP ELSE DROP H. SPACE THEN ;

( Print a disassembly, for a commaer DEA , taking into account labels,  )
( {suitable for e.g. the commaer ``IX,''}                               )
: .COMMA-LABEL
    AS-POINTER @ OVER >CNT @ MC@ .LABEL/.
    DUP >CNT @ AS-POINTER +!
    %ID.                         ( DEA --)
;

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

\ Contains all instruction that represent intra-segment jumps.
0 BAG JUMPS
   'CALL, , 'J, , 'JCXZ, , 'JMP, , 'JMPS, , 'J|X, , 'LOOP, , 'LOOPNZ,
   , 'LOOPZ, ,
HERE JUMPS !

PREVIOUS DEFINITIONS
