 ( $Id$ )
 ( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
 ( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( Handle labels as far as disassembly is concerned.                     )
( There is a separate one for the assembler.                            )

INCLUDE struct.frt

REQUIRE ALIAS
REQUIRE @+
REQUIRE SET
REQUIRE QSORT
REQUIRE PAIR[]
REQUIRE BIN-SEARCH

: \D ;

\ -------------------- generic definition of labels ----------------

\ Labels are bags of two cell structs, a target address and a pointer
\ to the payload (mostly a string).
\ They are sorted on target address for convenience.

\ Define a structure for label-like things of length N.
1 \ Dummy length
struct LABELSTRUCT
  F: LABELS HERE CELL+ , 2* CELLS ALLOT FDOES> ;
endstruct

\ For I return the ith LABEL . 1 returns the first label.
\ All indices are compatible with this.
: LABELS[]   1- 2* CELLS LABELS CELL+ + ;

\ Print the name of the LABEL at address.
: .LAB     CELL+ @ $@ TYPE   3 SPACES ;

\ Print the names and values of the LABELS ( a bag as ``LABELS'').
: .LABELS @+ SWAP ?DO I @ .  I .LAB CR 2 CELLS +LOOP ;

\ For return LOWER and UPPER indices of the labels , inclusive.
\ The lower index is 1 and the upper index is corresponding.
: LAB-BOUNDS  LABELS @+ SWAP - 2 CELLS / 1 SWAP ;

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

\ Contains plain labels, i.e. structs as associate with ``LABEL''
1000 LABELSTRUCT PLAIN-LABELS        LABELS !SET

\ Generate a plain label at ADDRESS.
\ The payload is a pointer to a string with "NAME".
: LABEL   PLAIN-LABELS   LABELS SET+!   (WORD) $, LABELS SET+! ;

\ Adorn the ADDRESS we are currently disassembling with a named label
\ if any.
: ADORN-WITH-LABEL   HOST>TARGET  >LABEL DUP IF
    &: EMIT .LAB CR _   THEN DROP ;

\D 12 LABEL AAP
\D 5 LABEL NOOT
\D 2 LABEL MIES
\D 123 LABEL POPI

\D LABELS .LABELS CR
\D SORT-LABELS
\D LABELS .LABELS CR

\D 200 FIND-LABEL . CR
\D 12 FIND-LABEL  LABELS[] .LAB CR
\D 12 1- FIND-LABEL  LABELS[] .LAB CR
\D 12 >LABEL .LAB CR
\D 12 1- >LABEL H. CR
\D 12 ADORN-WITH-LABEL  .S CR  \ Should give zero, not found!
\D 12 0 HOST>TARGET - ADORN-WITH-LABEL  CR

( ----------------------------------                                    )
( asi386 dependant part, does it belong here?                           )

ALSO ASSEMBLER DEFINITIONS
( Print X as a symbolic label if possible, else as a number             )
: .LABEL/.   DUP >LABEL DUP IF .LAB DROP ELSE DROP U. THEN ;

( Print a disassembly, for a commaer DEA , taking into account labels,  )
( {suitable for e.g. the commaer ``IX,''}                               )
: .COMMA-LABEL
    POINTER @ OVER >CNT @ MC@ .LABEL/.
    DUP >CNT @ POINTER +!
    %ID.                         ( DEA -- )
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
: .BRANCH/.
  >LABEL DUP IF   .LAB ID.-NO() ELSE   DROP DUP GET-OFFSET . %ID. THEN  ;

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

\ ------------------- Generic again -------------------


\ Print out everything we know about ADDRESS.
: (ADORN-ADDRESS) ADORN-WITH-LABEL ( .. ADORN-THIS ADORN-THAT ) ;

\ Revector ``ADORN-ADDRESS'' used in "asgen.frt".
'(ADORN-ADDRESS) >DFA @   'ADORN-ADDRESS >DFA !

\ Disassemble the current program as stored in the ``CODE-BUFFER''.
: DISASSEMBLE-TARGET
    TARGET-START @ .  " ORG" TYPE CR
    CODE-SPACE CP @ D-R
    CP @ ADORN-ADDRESS ;
