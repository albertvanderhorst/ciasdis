 ( $Id$ )
 ( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
 ( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( Handle labels as far as disassembly is concerned.                     )
( There is a separate one for the assembler.                            )

INCLUDE struct.frt
INCLUDE bag.frt

REQUIRE ALIAS
REQUIRE @+
REQUIRE QSORT
REQUIRE EXCHANGE
REQUIRE BIN-SEARCH

: \D ;

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
  F: .PAY , FDOES> @ EXECUTE ;          \ Print payload
  F: LABELS   2* BUILD-BAG   LATEST THE-REGISTER BAG+! FDOES> ;
endstruct

THE-REGISTER !BAG       \ Get rid of dummy registration.

\ For I return the ith LABEL . 1 returns the first label.
\ All indices are compatible with this.
: LABELS[]   1- 2* CELLS LABELS CELL+ + ;

\ Print the payload of the label at ADDRESS , provided it is a string.
: .PAY$     CELL+ @ $@ TYPE   3 SPACES ;

\ Print the payload of the label at ADDRESS , provided it is a string.
: .LAB     CELL+ @ $@ TYPE   3 SPACES ;

\ Print the name of the label at ADDRESS , provided it is a dea.
\ This applies to plain labels that are in fact fact constants.
: .PAY-DEA  CELL+ @ ID. ;

\ Print the addresses and payloads of the labels.
: .LABELS  LABELS @+ SWAP ?DO I @ .  I .PAY CR 2 CELLS +LOOP ;

\ Return LOWER and UPPER indices of the labels , inclusive.
\ The lower index is 1 and the upper index is corresponding.
: LAB-BOUNDS   1   LABELS |BAG| 2/ ;

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
VARIABLE C

\ In behalf of bin-search.
\ For INDEX1 : "the value of the label IS less than ``C''"
: L<    LABELS[] @   C @   < ;

\ Find the first label that is equal to (or greater than) VALUE
\ Return INDEX or zero if not found.
\ Note ``BIN-SEARCH'' returns the non-inclusive upper bound if not found.
: FIND-LABEL   C !   LAB-BOUNDS 1+   DUP >R
    'L<   BIN-SEARCH   DUP R> <> AND ;

\ Find ADDRESS in the label table. Return DEA of an exact
\ matching label or zero if not found.
: >LABEL   FIND-LABEL DUP IF LABELS[]  DUP @  C @ - IF DROP 0 THEN THEN ;


\ ---------------- Names of labels ------------------------------

\ Contains equ labels, i.e. structs as associate with ``LABEL''
1000 '.PAY-DEA LABELSTRUCT EQU-LABELS        LABELS !BAG

\ Generate a equ label at (target) ADDRESS with "NAME", this can be
\ any symbolic constant in fact.
\ The payload is the dea of a constant leaving that address.
: LABEL   EQU-LABELS   DUP LABELS BAG+!   CONSTANT   LATEST LABELS BAG+! ;

\ Adorn the ADDRESS we are currently disassembling with a named label
\ if any.
: ADORN-WITH-LABEL   EQU-LABELS HOST>TARGET  >LABEL DUP IF
    &: EMIT .PAY ELSE DROP 12 SPACES THEN  ;

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

\ Contains comment labels, i.e. structs as associate with ``LABEL''
1000 '.PAY$ LABELSTRUCT COMMENT:-LABELS LABELS !BAG

\ Generate a comment label at ADDRESS. A pointer to the
\ remainder of the line is the payload.
: COMMENT:   COMMENT:-LABELS   LABELS BAG+!  ^J (PARSE) $, LABELS BAG+! ;

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

\ Contains comment labels, i.e. structs as associate with ``LABEL''
1000 '.PAY$ LABELSTRUCT MCOMMENT-LABELS LABELS !BAG

\ Make STRING the comment in front of label at ADDRESS. A pointer to this
\ string the payload.
: COMMENT   MCOMMENT-LABELS   LABELS BAG+!  $, LABELS BAG+! ;

\ Print comment for instruction at ADDRESS , if any.
: PRINT-COMMENT MCOMMENT-LABELS  HOST>TARGET  >LABEL DUP IF
   CR   "\ " TYPE   .PAY _ THEN DROP ;

\D "AAP" 12 COMMENT
\D "NOOT" 5 COMMENT
\D "MIES" 2 COMMENT
\D "POPI
JOPI"
123 COMMENT

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

\ ------------------- Generic again -------------------

\ Start a new line, with printing the decompiled ADDRESS as seen
: CR+ADDRESS CR "( " TYPE DUP HOST>TARGET 4 .R " )   " TYPE ;

\ Print out everything we know about ADDRESS.
: (ADORN-ADDRESS)
    PRINT-OLD-COMMENT:
    DUP PRINT-COMMENT
    DUP REMEMBER-COMMENT:
    CR+ADDRESS ADORN-WITH-LABEL ;

\ Revector ``ADORN-ADDRESS'' used in "asgen.frt".
'(ADORN-ADDRESS) >DFA @   'ADORN-ADDRESS >DFA !

\ Initialise all registered labelstructs.
: INIT-ALL   THE-REGISTER DO-BAG   I @ EXECUTE LABELS !BAG   LOOP-BAG
    INIT-COMMENT: ;

\ Sort all registered labelstructs.
: SORT-ALL   THE-REGISTER DO-BAG   I @ EXECUTE SORT-LABELS   LOOP-BAG ;

\ Disassemble the current program as stored in the ``CODE-BUFFER''.
\ Using what is known about it.
: DISASSEMBLE-TARGET
    TARGET-START @ .  " ORG" TYPE CR    \ FIXME
    CODE-SPACE CP @ D-R
    CP @ ADORN-ADDRESS CR ;

\ Using (only) information from "file",
\ disassemble the current program as stored in the ``CODE-BUFFER''.
: CONSULT   INIT-ALL   INCLUDE ( file)   SORT-ALL   DISASSEMBLE-TARGET ;

( ----------------------------------                                    )
( asi386 dependant part, does it belong here?                           )

ASSEMBLER DEFINITIONS
( Print X as a symbolic label if possible, else as a number             )
: .LABEL/.   EQU-LABELS DUP >LABEL DUP IF .PAY DROP ELSE DROP U. THEN ;

( Print a disassembly, for a commaer DEA , taking into account labels,  )
( {suitable for e.g. the commaer ``IX,''}                               )
: .COMMA-LABEL
    POINTER @ OVER >CNT @ MC@ .LABEL/.
    DUP >CNT @ POINTER +!
    %ID.                         ( DEA --)
;

(  For DEA print the name without the surrounding brackets.             )
: ID.-NO()   >NFA @ $@  2 - SWAP 1 + SWAP TYPE ;

(  Assuming the disassembly sits at the offset of a relative branch     )
(  assembled by commaer DEA , return the host space ADDRESS of the next )
(  instruction.                                                         )
: NEXT-INSTRUCTION  >CNT @ POINTER @ + ;

(  Assuming the disassembly sits at the offset of a relative branch     )
(  assembled by commaer DEA , return that OFFSET.                       )
: GET-OFFSET   POINTER @ SWAP >CNT @ MC@-S ;

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
   >CNT @ POINTER +! ;

\D 5 .LABEL/. CR
\D 5 .LABEL/. CR
\D '(RB,) ID.-NO() CR

'.COMMA-LABEL  'OW,   >DIS ! ( obligatory word     )
'.COMMA-REL    '(RX,) >DIS !  ( cell relative to IP )
'.COMMA-REL    '(RB,) >DIS !  ( byte relative to IP )
'.COMMA-LABEL  'SG,   >DIS !  (  Segment: WORD      )
'.COMMA-LABEL  'P,    >DIS !  ( port number ; byte     )
'.COMMA-LABEL  'IS,   >DIS !  ( Single -obl-  byte )
'.COMMA-LABEL  'IX,   >DIS !  ( immediate data : cell)
'.COMMA-LABEL  'IB,   >DIS !  ( immediate byte data)
'.COMMA-LABEL  'X,    >DIS !  ( immediate data : address/offset )
'.COMMA-LABEL  'B,    >DIS !  ( immediate byte : address/offset )

PREVIOUS DEFINITIONS
