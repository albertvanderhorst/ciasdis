( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( Handle labels as far as disassembly is concerned.                     )
( There is a separate one for the assembler.                            )

REQUIRE ALIAS
REQUIRE @+
REQUIRE SET
REQUIRE QSORT
REQUIRE PAIR[]
REQUIRE BIN-SEARCH

: \D ;

\ Contains labels, i.e. dea's of things that leave a number
   1000 SET LABELS   LABELS !SET

\ Associate ADDRES with "NAME". (Store it in ``LABELS'')
: LABEL   CONSTANT   LATEST LABELS SET+! ;

\ For I return the dea of the ith LABEL . 1 returns the first label.
\ All indices are compatible with this.
: LABELS[]   CELLS LABELS + @ ;

\D 12 LABEL AAP
\D 5 LABEL NOOT
\D 2 LABEL MIES
\D 123 LABEL POPI

\ Print the names and values of the LABELS ( a bag as ``LABELS'').
: .LABELS @+ SWAP ?DO I @ DUP EXECUTE . ID. CR 0 CELL+ +LOOP ;

\ For a BAG of labels return LOWER and UPPER indices, inclusive.
\ The lower index is 1 and the upper index is corresponding.
: BAG-BOUNDS  @+ SWAP - 0 CELL+ / 1 SWAP ;

\ In behalf of qsort.
\ For INDEX1 and INDEX2: "the value of the first
\ label IS less than that of the second"
: LAB<  LABELS[] EXECUTE  SWAP LABELS[] EXECUTE  SWAP < ;

\ In behalf of qsort.
\ Exchange the labels with INDEX1 and INDEX2 .
: LAB<->  LABELS PAIR[] 0 CELL+ EXCHANGE ;

\ Sort the labels of ``LABELS'' in ascending order.
: SORT-LABELS   LABELS BAG-BOUNDS   'LAB<   'LAB<->   QSORT ;

\ In behalf of bin-search.
\ Comparant
VARIABLE C

\ In behalf of bin-search.
\ For INDEX1 : "the value of the label IS less than ``C''"
: L<    LABELS[] EXECUTE   C @   < ;

\ Find the first label that is equal to (or greater than) VALUE
\ Return INDEX or zero if not found.
\ Note ``BIN-SEARCH'' returns the non-inclusive upper bound if not found.
: FIND-LABEL   C !   LABELS BAG-BOUNDS 1+  DUP >R
    'L<   BIN-SEARCH   DUP R> <> AND ;

\ Find ADDRESS in the label table. Return DEA of an exact
\ matching label or zero if not found.
: >LABEL   FIND-LABEL DUP IF LABELS[]  DUP EXECUTE C @ - IF DROP 0 THEN THEN ;

\ Adorn the ADDRESS we are currently disassembling with a label
\ if any.
: ADORN-WITH-LABEL   HOST>TARGET  >LABEL DUP IF &: EMIT ID. CR _ THEN DROP ;

'ADORN-WITH-LABEL >DFA @   'ADORN-ADDRESS >DFA !

\D LABELS .LABELS CR
\D SORT-LABELS
\D LABELS .LABELS CR

\D 200 FIND-LABEL . CR
\D AAP FIND-LABEL  LABELS[] ID. CR
\D AAP 1- FIND-LABEL  LABELS[] ID. CR
\D AAP >LABEL ID. CR
\D AAP 1- >LABEL H. CR
\D AAP ADORN-WITH-LABEL  .S CR  \ Should fail!
\D AAP 0 HOST>TARGET - ADORN-WITH-LABEL  CR

: DISASSEMBLE-TARGET
    TARGET-START @ .  " ORG" TYPE CR
    CODE-SPACE CP @ D-R
    CP @ ADORN-WITH-LABEL ;

( ----------------------------------                                    )
( asi386 dependant part, doesn't belong here                            )

ALSO ASSEMBLER DEFINITIONS
( Print X as a symbolic label if possible, else as a number             )
: .LABEL/.   DUP >LABEL DUP IF ID. DROP ELSE DROP U. THEN ;

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
  >LABEL DUP IF   ID. ID.-NO() ELSE   DROP DUP GET-OFFSET . %ID. THEN  ;

( Print a disassembly for a relative branch DEA .                       )
( This relies on the convention that the commaer that consumes an       )
( absolute address has the name of that with a relative address         )
( surrounded with brackets.                                             )
: .COMMA-REL
   DUP  DUP GOAL-RB HOST>TARGET  .BRANCH/.
   >CNT @ POINTER +! ;

\D NOOT .LABEL/. CR
\D NOOT .LABEL/. CR
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
