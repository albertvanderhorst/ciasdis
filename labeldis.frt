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

\ Contains labels, i.e. dea's tokens of things that leave a number.
   1000 SET LABELS   LABELS !SET

\ Associate ADDRES with "NAME". (Store it in ``LABELS'')
: LABEL CONSTANT   LATEST LABELS SET+! ;

\ For I return the dea of the ith LABEL . 1 returns the first label.
\ All indices are compatible with this.
: LABELS[] CELLS LABELS + @ ;

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
\ Return INDEX.
: FIND-LABEL   C !   LABELS BAG-BOUNDS 1+ 'L<   BIN-SEARCH ;

\ Find ADDRESS in the label table. Return DEA of an exact
\ matching label or zero if not found.
: >LABEL   FIND-LABEL LABELS[]  DUP EXECUTE C @ - IF DROP 0 THEN ;

\D LABELS .LABELS
\D SORT-LABELS
\D LABELS .LABELS

\D AAP FIND-LABEL  LABELS[] ID. CR
\D AAP >LABEL H. CR
\D AAP 1- >LABEL H. CR
