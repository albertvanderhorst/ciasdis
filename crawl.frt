( $Id: crawl.frt,v 1.38 2018/07/24 11:44:49 albert Exp $ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Crawling is the process of following jumps to determine code space.

\ ------------------------------------------------------------------------

WANT H.
WANT BAG
: BAG DATA BUILD-BAG ;

\ : \D ;

\ Insert the equ-label ADDRESS1 with an NAME.
\ If equ labels was sorted, it remains so.
: INSERT-EQU 2>R DUP EQU-LABELS WHERE-LABEL SWAP 2R> LABELED
    ROLL-LABEL ;

\ Insert the equ-label ADDRESS1 with an invented name.
\ If equ labels was sorted, it remains so.
: INSERT-EQU-INVENT DUP INVENT-NAME INSERT-EQU ;

\ Add target ADDRESS to the equ labels if it is not there. Invent a name.
: ?INSERT-EQU?    EQU-LABELS DUP >LABEL IF DROP ELSE INSERT-EQU-INVENT THEN ;

\D EQU-LABELS LABELS !BAG
\D ." EXPECT: empty " EQU-LABELS .LABELS  CR
\D 42 ?INSERT-EQU?
\D ." EXPECT: L0000,0042 added " EQU-LABELS .LABELS     CR
\D 42 ?INSERT-EQU?
\D ." EXPECT: L0000,0042 NOT added again " EQU-LABELS .LABELS     CR .S

\D HEX
\D RANGE-LABELS       LABELS !BAG
\D 4FE 510 -dc-
\D 520 530 -dc: oops
\D 530 570 -dc-
\D 560 590 -db: bytes
\D ." EXPECT: 4 ranges :" .LABELS CR .S
\D DECIMAL

\ For range INDEX : "it IS of the same type as the previous one".
: COMPATIBLE?   DUP MAKE-CURRENT RANGE-XT   SWAP 1- MAKE-CURRENT RANGE-XT  = ;

\D ." EXPECT: -1 :" 2 COMPATIBLE? . CR
\D ." EXPECT: -1 :" 3 COMPATIBLE? . CR
\D ." EXPECT: 0 :" 4 COMPATIBLE? . CR

\ Get the name of range INDEX.
: RANGE-NAME LABELS[] CELL+ @ >NFA @ $@ ;

\D  ." EXPECT: NONAME :" 1 RANGE-NAME TYPE CR
\D ." EXPECT: oops :"    2 RANGE-NAME TYPE   CR .S

\ For a collapsible pair of range with INDEX1 and INDEX2 return INDEX1 and
\ INDEX2 plus a new START for the combined range.
: NEW-RANGE-START OVER MAKE-CURRENT RANGE-START  OVER MAKE-CURRENT RANGE-START
    MIN ;

\ For a collapsible pair of range with INDEX1 and INDEX2 return INDEX1 and
\ INDEX2 plus a new END for the combined range.
: NEW-RANGE-END OVER MAKE-CURRENT RANGE-END  OVER MAKE-CURRENT RANGE-END
    MAX ;

\D WANT H.
\D  ." EXPECT 520 : " 2 3 NEW-RANGE-START H. 2DROP CR
\D  ." EXPECT 590 : " 3 4 NEW-RANGE-END  H. 2DROP CR .S

\ Replace the two ranges INDEX1 and INDEX2 with the last range.
\ Place it at index1 (which has the correct start address.)
: REPLACE  OVER >R REMOVE-LABEL REMOVE-LABEL R> ROLL-LABEL ;

\D  ." EXPECT 1 LESS : " 2 3 REPLACE .LABELS CR .S

\ This looks like a proper design.
\ - sort on the start address, type (disassembler) and end address.
\ - start with the last range and work down until the second
\     - if it overlaps with or borders at the previous one and has the
\       same type and alignment, and the second one is not named
\       collapse the ranges.
\     - if it overlaps with the previous one and has the same type and
\       alignment, and the second one is named, trim the first range.
\     - if it overlaps with the previous and has different type,
\         issue warning
\     - if it has a gap, introduce a character range
\   This may lead to an extra range, one less range, or no change
\   in the number of ranges, but only at or after the current range.
\ - As a last action, introduce extra ranges at the beginning and end.
\
\ This leads to words: SAME-TYPE SAME-ALIGN OVERLAP BORDER GAP IS-NAMED

\ For range INDEX: "It HAS the same type and alignment as the previous one."
: SAME-ALIGN    DUP MAKE-CURRENT  RANGE-START SWAP
    1- MAKE-CURRENT   RANGE-START - RANGE-STRIDE MOD 0=   ;

\D INIT-ALL RANGE-LABELS  HEX
\D 12 34 -dc-
\D 34 65 -db: AAP
\D 38 80 -dl-
\D 82 90 -dl-
\D 88 94 -dl-

\D ." EXPECT: -1 :" 2 SAME-ALIGN . CR
\D ." EXPECT: -1 :" 3 SAME-ALIGN . CR \ Must become 0
\D ." EXPECT: -1 :" 4 SAME-ALIGN . CR

\ For range INDEX return END of previous, START of this one,
: END+START DUP MAKE-CURRENT RANGE-START SWAP 1- MAKE-CURRENT RANGE-END SWAP ;
\D ." EXPECT: 34 34 :" 2 END+START SWAP . . CR
\D ." EXPECT: 65 38 :" 3 END+START SWAP . . CR

\ Range INDEX overlaps with previous one.
: OVERLAP? END+START > ;
\D ." EXPECT: 0 :" 2 OVERLAP? . CR
\D ." EXPECT: -1 :" 3 OVERLAP? . CR
\D ." EXPECT: 0 :" 4 OVERLAP? . CR

\ Range INDEX overlaps or borders with the previous one.
: OVERLAP-OR-BORDER? END+START >= ;
\D ." EXPECT: -1 :" 2 OVERLAP-OR-BORDER? . CR
\D ." EXPECT: -1 :" 3 OVERLAP-OR-BORDER? . CR
\D ." EXPECT: 0 :" 4 OVERLAP-OR-BORDER? . CR

\ Range INDEX has a gap with the previous one.
: GAP? END+START < ;
\D ." EXPECT: 0 :" 2 GAP? . CR
\D ." EXPECT: 0 :" 3 GAP? . CR
\D ." EXPECT: -1 :" 4 GAP? . CR

\ For range INDEX: "It HAS a name"
: IS-NAMED   RANGE-NAME NONAME$ $= 0= ;
\D ." EXPECT: -1 :" 2 IS-NAMED . CR
\D ." EXPECT: 0 :" 3 IS-NAMED . CR

\ Collapse range I into the previous range, that determines the properties.
: COLLAPSE DUP MAKE-CURRENT RANGE-END OVER 1- MAKE-CURRENT RANGE-END MAX RANGE-END!
         REMOVE-LABEL ;
\D ." EXPECT: 5 82 94 4 :"
\D LAB-UPB . 5 COLLAPSE 4 MAKE-CURRENT RANGE-START . RANGE-END .  LAB-UPB . CR

\ Trim the range previous to INDEX, such that it borders to range index.
: TRIM-RANGE DUP MAKE-CURRENT RANGE-START SWAP 1- MAKE-CURRENT RANGE-END! ;
\D 90 1000 -dl-
\D ." EXPECT: 82 90 :" 5 TRIM-RANGE 4 MAKE-CURRENT RANGE-START . RANGE-END .  CR

\ Combine range INDEX with the previous one.
: COMBINE
    DUP OVERLAP-OR-BORDER? OVER IS-NAMED 0= AND IF DUP COLLAPSE THEN
    DUP OVERLAP? OVER IS-NAMED AND IF DUP TRIM-RANGE THEN  DROP ;
\D INIT-ALL
\D 10  30 -dl-
\D 20  40 -dl-
\D 30 50  -dl: aap
\D 60 80  -dl-
\D 90 100 -dl: noot
\D ." EXPECT: 5 5 :" LAB-UPB . 5 COMBINE LAB-UPB . CR
\D ." EXPECT: 5 5 :" LAB-UPB . 4 COMBINE LAB-UPB . CR
\D ." EXPECT: 5 5 20 30 :" LAB-UPB . 3 COMBINE LAB-UPB . 2 MAKE-CURRENT RANGE-START . RANGE-END . CR
\D ." EXPECT: 5 4 10 30 :" LAB-UPB . 2 COMBINE LAB-UPB . 1 MAKE-CURRENT RANGE-START . RANGE-END . CR

\ Combine range INDEX with a previous overlapping or bordering range.
: KILL-OVERLAP DUP SAME-ALIGN OVER COMPATIBLE? AND IF DUP COMBINE THEN DROP ;
\D INIT-ALL
\D 10  30 -dl-
\D 20  40 -dl-
\D 30 50  -dl: aap
\D 60 80  -dl-
\D 90 100 -dl: noot
\D ." EXPECT: 5 5 :" LAB-UPB . 5 KILL-OVERLAP LAB-UPB . CR
\D ." EXPECT: 5 5 :" LAB-UPB . 4 KILL-OVERLAP LAB-UPB . CR
\D ." EXPECT: 5 5 20 30 :" LAB-UPB . 3 KILL-OVERLAP LAB-UPB . 2 MAKE-CURRENT RANGE-START . RANGE-END . CR
\D ." EXPECT: 5 4 10 30 :" LAB-UPB . 2 KILL-OVERLAP LAB-UPB . 1 MAKE-CURRENT RANGE-START . RANGE-END . CR
\D INIT-ALL
\D 10  30 -dl-
\D 20  28 -db-
\D 30 70  -dl: aap
\D 60 80  -dl-
\D 7F 10F -dl-
\ The following is actually wrong because the aligning is not tested yet.
\D ." EXPECT: 5 4 60 10F :" LAB-UPB . 5 KILL-OVERLAP LAB-UPB . 4 MAKE-CURRENT RANGE-START . RANGE-END . CR
\D ." EXPECT: 4 3 30 10F :" LAB-UPB . 4 KILL-OVERLAP LAB-UPB . 3 MAKE-CURRENT RANGE-START . RANGE-END . CR
\D ." EXPECT: 3 3 20 28 :" LAB-UPB . 3 KILL-OVERLAP LAB-UPB . 2 MAKE-CURRENT RANGE-START . RANGE-END . CR
\D ." EXPECT: 3 3 10 30 :" LAB-UPB . 2 KILL-OVERLAP LAB-UPB . 1 MAKE-CURRENT RANGE-START . RANGE-END . CR

\ Introduce char range to fill the gap at INDEX. Note that the result is unordered.
: FILL-GAP DUP GAP? IF   DUP END+START -ddef-   DUP 1+ LAB-UPB MAX KILL-OVERLAP
    DUP KILL-OVERLAP THEN DROP ;
\D ." EXPECT: 3 4 28 30 :" LAB-UPB . 3 FILL-GAP LAB-UPB . 4 MAKE-CURRENT RANGE-START . RANGE-END . CR
\D ." EXPECT: 4 4 20 28 :" LAB-UPB . 2 FILL-GAP LAB-UPB . 2 MAKE-CURRENT RANGE-START . RANGE-END . CR

\ Clean up the range labels, from behind.
\ Although the bounds may not be valid after a clean up, this works
\ because a clean up of a range only concerns higher ranges, no
\ longer considered.
\ So a range can comfortably be removed using the regular removal
\ mechanism for bags. A newly introduced range automatically falls
\ into place, because of the conditions regarding the start addresses.
: CLEANUP-RANGES RANGE-LABELS
    2 LAB-UPB 2DUP <= IF DO I KILL-OVERLAP -1 +LOOP THEN ;

\ Plug a hole at the first range.
: PLUG-FIRST   1 MAKE-CURRENT TARGET-START RANGE-START 2DUP <> IF
   -ddef- _ _ THEN 2DROP ;

\ Plug a hole at the last range.
: PLUG-LAST    LAB-UPB MAKE-CURRENT RANGE-END TARGET-END 2DUP <> IF
   -ddef- _ _ THEN 2DROP ;

\ If there are no ranges at all, make the buffer into a default range.
\ Else check last and first ranges.
\ Note that plugging results in a change of the number of ranges,
\ interfering with other plugging.
: PLUG-SPECIAL  LAB-UPB IF PLUG-LAST PLUG-FIRST ELSE
    TARGET-START TARGET-END -ddef- THEN ;

\ Fill any holes with character ranges.
: PLUG-HOLES  RANGE-LABELS LAB-UPB 1+ 2
  2DUP > IF DO I FILL-GAP LOOP ELSE 2DROP THEN SORT-LABELS PLUG-SPECIAL SORT-LABELS ;

\ ------------------------------------------------------------------------
ASSEMBLER

\ Jump targets that are starting points for further crawling.
\ Adding and removing from this bag ressembles a recursive action.
\ Recursion will not do here! This is because ranges are not added
\ until the end is detected.
1000 BAG STARTERS

VARIABLE (R-XT)        \ Required xt.
\ Return the XT that is required for the current disassembly.
: REQUIRED-XT (R-XT) @ ;
\ Specify normal disassembly.
: NORMAL-DISASSEMBLY 'D-R-T (R-XT) ! BITS-32 ;
NORMAL-DISASSEMBLY

\ The following are auxiliary words for `` KNOWN-CODE? '' mainly.
\ For all those range labels must be current and sorted.
\ Prepend `` RANGE-LABELS '' if you want to use the auxiliary words.

\ For ADDRESS : "it IS in a current code range"
: IN-CURRENT-CODE?   RANGE-START RANGE-END WITHIN   RANGE-XT REQUIRED-XT =   AND ;

\ For ADDRESS and range number N: "address SITS in code range n"
: IN-CODE-N? MAKE-CURRENT IN-CURRENT-CODE? ;

\ For ADDRESS and range I : "It IS code and address is part of it,
\  or same holds for previous range."
: IN-CODE?  DUP 0 = IF 2DROP 0 ELSE   \ Not present.
            2DUP IN-CODE-N? IF 2DROP -1 ELSE
            DUP 1 = IF 2DROP 0 ELSE   \ Previous not present.
            1- IN-CODE-N? THEN THEN THEN ;

\ For ADDRESS: "It IS known code, according to ``RANGE-LABELS''".
: KNOWN-CODE?   RANGE-LABELS DUP WHERE-LABEL LAB-UPB MIN IN-CODE? ;

\ For ADDRESS : "it FALLS within the binary image"
: IN-CODE-SPACE?   TARGET-START TARGET-END WITHIN ;

\ For ADDRESS: "It IS usable as a new starter"
: STARTER?   DUP KNOWN-CODE? 0=  SWAP IN-CODE-SPACE? AND ;

\ Return the target ADDRESS of the current instruction.
\ (It must be a jump of course.
: JUMP-TARGET   AS-POINTER @   LATEST-OFFSET @  + HOST>TARGET ;

\ Analyse current instruction after disassembly.
\ DISS LATEST-INSTRUCTION ISS ISL are all valid.

: ANALYSE-INSTRUCTION   LATEST-INSTRUCTION @ JUMPS IN-BAG? IF
    JUMP-TARGET DUP ?INSERT-EQU?
    STARTER? IF JUMP-TARGET STARTERS SET+ THEN THEN ;

\ Collapse the label at INDEX with the next and or previous labels.
: COLLAPSE(I1) RANGE-LABELS
    DUP LAB-UPB < IF DUP 1+ KILL-OVERLAP THEN
    DUP 1 > IF DUP KILL-OVERLAP THEN
    DROP ;

\D LABELS !BAG
\D 4FE 520 -dc-
\D 520 530 -dc: oops
\D 52A 570 -dc-
\D 560 590 -db: bytes
\D .LABELS
\D  ." EXPECT 1 LESS : " 2 COLLAPSE(I1) .LABELS CR .S

\ Add the information that ADDRESS1 to ADDRESS2 is a code range.
\ If range labels was sorted, it remains so.
: INSERT-RANGE   OVER RANGE-LABELS WHERE-LABEL >R
    REQUIRED-XT ANON-RANGE   R@ ROLL-LABEL   R> COLLAPSE(I1) ;

\ Analyse the code range from ADDRESS up to an unconditional transfer.
\ Add information about jumps to ``STARTERS'' and new ranges to ``LABELS''.
: CRAWL-ONE  DUP >R TARGET>HOST BEGIN (DISASSEMBLE) ANALYSE-INSTRUCTION
    DUP HOST-END >=   LATEST-INSTRUCTION @ UNCONDITIONAL-TRANSFERS IN-BAG?   OR
  UNTIL     R> SWAP HOST>TARGET INSERT-RANGE ;

\ Analyse code from ADDRESS , unless already known.
: ?CRAWL-ONE? DUP STARTER? IF CRAWL-ONE _ THEN DROP ;

\ Crawl through code from all points in ``STARTERS''.
: (CRAWL)   BEGIN STARTERS BAG? WHILE STARTERS BAG@- ?CRAWL-ONE? REPEAT ;

\ ADDRESS points into code. Crawl through code from there, i.e. add
\ all information about code ranges that can be derived from that.
: CRAWL   DUP ?INSERT-EQU?   RANGE-LABELS SORT-LABELS
    STARTERS DUP !BAG BAG+!   SHUTUP (CRAWL) ;

\ ------------------------ dl range  ------------------------------

\ For ADDR create a label if it points in the target space.
: NEW-LABEL?    DUP PLAUSIBLE-LABEL? IF ?INSERT-EQU? _ THEN DROP ;

\ For dl-range from ADDR1 to ADDR2 add all plausible labels found in data.
: ADD-L-LABELS   SWAP DO   I L@ NEW-LABEL?   0 CELL+ +LOOP ;

\ For all dl-ranges add all plausible labels.
: ALL-L-LABELS
    RANGE-LABELS DO-LAB   I CELL+ @ EXECUTE
        RANGE-XT 'DUMP-L =   IF   RANGE-START RANGE-END ADD-L-LABELS   THEN
    LOOP-LAB ;

\ ------------------------ INTEL 80386 ------------------------------
\ Intel specific. There is a need to specify the disassembly xt.
\ Crawl with normal disassembly (observing `` TALLY-BA '')
\ resp. crawl through 16 / 32 bits code.
\ The other owns change it all the time.
: CRAWL16  'D-R-T-16 (R-XT) ! BITS-16 CRAWL NORMAL-DISASSEMBLY ;

PREVIOUS
: \D ;
