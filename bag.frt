 ( $Id$ )
 ( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
 ( Uses Richard Stallmans convention. Uppercased word are parameters.    )
\ Belongs in library
( BAG !BAG BAG? BAG+! BAG@- BAG-REMOVE ) \ AvdH A4apr29
REQUIRE @+
( Build a bag with X items. )
: BUILD-BAG   HERE CELL+ , CELLS ALLOT ;
( Create a bag "x" with X items. )
: BAG   CREATE HERE CELL+ , CELLS ALLOT DOES> ;
: !BAG   DUP CELL+ SWAP ! ;   ( Make the BAG empty )
: BAG?   @+ = 0= ;   ( For the BAG : it IS non-empty )
: BAG+!   DUP >R @ ! 0 CELL+ R> +! ;   ( Push ITEM to the BAG )
: BAG@- 0 CELL+ NEGATE OVER +! @ @ ;   ( From BAG: pop ITEM )
( Remove entry at ADDRESS from BAG. )
: BAG-REMOVE   >R   DUP CELL+ SWAP  OVER R@ @ SWAP -   MOVE
    -1 CELLS R> +! ;
( Make hole at ADDRESS in BAG. )
: BAG-HOLE    >R   DUP CELL+   OVER R@ @ SWAP -   MOVE
    0 CELL+ R> +! ;
( Insert VALUE at ADDRESS in BAG. )
: BAG-INSERT   OVER SWAP BAG-HOLE   ! ;


( DO-BAG LOOP-BAG .BAG BAG-WHERE IN-BAG? BAG- ) \ AvdH A3apr25
: |BAG|   @+ SWAP - 0 CELL+ / ; ( For BAG : NUMBER of items )
\ Loop over a bag, see ``.BAG'' for an example.
: DO-BAG  POSTPONE @+ POSTPONE SWAP POSTPONE ?DO ; IMMEDIATE
: LOOP-BAG 0 CELL+ POSTPONE LITERAL POSTPONE +LOOP ; IMMEDIATE
: .BAG   DO-BAG I ? LOOP-BAG ; ( Print BAG )
( For VALUE and BAG : ADDRESS of value in bag/nill.)
: BAG-WHERE DO-BAG DUP I @ = IF DROP I UNLOOP EXIT THEN
    LOOP-BAG  DROP 0 ;
( For VALUE and BAG : value IS present in bag.)
: IN-BAG? BAG-WHERE 0= 0= ;
( Remove VALUE from BAG. )
: BAG-   DUP >R   BAG-WHERE   R> BAG-REMOVE ;
( Add VALUE to bag, used as a SET, i.e. no duplicates.)
: SET+   2DUP IN-BAG? IF 2DROP ELSE BAG+! THEN ;
(   : BAG+ BAG+! ;    : SET- BAG- ;                           )
