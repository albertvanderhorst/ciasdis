( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Crawling is the process of following jumps to determine code space.

\ ------------------------------------------------------------------------

REQUIRE H.
REQUIRE BAG

\ : \D ;

\ Make ADDRESS return some label NAME, static memory so use immediately.
: INVENT-NAME   "L" PAD $!   0 8 (DH.) PAD $+! PAD $@ ;

\D HEX 42 INVENT-NAME TYPE ." EXPECT: L0000,0042 " CR

\ Insert the equ-label ADDRESS1 with an invented name.
\ If equ labels was sorted, it remains so.
: INSERT-EQU DUP EQU-LABELS WHERE-LABEL >R   DUP INVENT-NAME LABELED
    R> ROLL-LABEL ;

\ Add target ADDRESS to the equ labels if it is not there. Invent a name.
: ?INSERT-EQU?    EQU-LABELS DUP >LABEL IF DROP ELSE INSERT-EQU THEN ;

\D EQU-LABELS LABELS !BAG
\D ." EXPECT: empty " EQU-LABELS .LABELS  CR
\D 44 ?INSERT-EQU?
\D ." EXPECT: L0000,0042 added " EQU-LABELS .LABELS     CR
\D 44 ?INSERT-EQU?
\D ." EXPECT: L0000,0042 NOT added again " EQU-LABELS .LABELS     CR .S

\D SECTION-LABELS       LABELS !BAG
\D 4FE 510 -dc-
\D 520 530 -dc: oops
\D 530 570 -dc-
\D 560 590 -db: bytes
\D ." EXPECT: 4 sections :" .LABELS CR .S

\ Section INDEX1 and INDEX2 are of the same type.
: COMPATIBLE?  OVER MAKE-CURRENT DIS-XT   OVER MAKE-CURRENT DIS-XT = >R
              OVER MAKE-CURRENT DIS-CR-XT OVER MAKE-CURRENT DIS-CR-XT  = >R
    2DROP   R> R> AND ;

\D  ." EXPECT: -1 :" 1 2 COMPATIBLE? .  CR
\D  ." EXPECT: -1 :" 2 3 COMPATIBLE? .  CR
\D  ." EXPECT: 0 :"  3 4 COMPATIBLE? .  CR .S

\ Section INDEX1 and INDEX2 have overlap or are adjacent.
\ Index1 must have a lower start than index2
: OVERLAP?  SWAP MAKE-CURRENT DIS-END SWAP MAKE-CURRENT DIS-START >= ;

\D ." EXPECT: 0 :"  1 2 OVERLAP? .     CR
\D ." EXPECT: -1 :" 2 3 OVERLAP? .     CR
\D ." EXPECT: 0 :"  1 3 OVERLAP? .     CR
\D ." EXPECT: -1 :" 3 4 OVERLAP? .     CR .S

\ Get the name of section INDEX.
: SECTION-NAME LABELS[] CELL+ @ >NFA @ $@ ;

\D  ." EXPECT: NONAME :" 1 SECTION-NAME TYPE CR
\D ." EXPECT: oops :"    2 SECTION-NAME TYPE   CR .S

\ For INDEX1 and INDEX2 leave INDEX1 and INDEX2 . Return a new NAME for
\ the section, plus "not both ARE named"
: NEW-NAME 2DUP SECTION-NAME 2DUP NONAME$ $= IF 2DROP SECTION-NAME -1 ELSE
           ROT SECTION-NAME NONAME$ $= THEN ;

\D  ." EXPECT -1 oops : " 1 2 NEW-NAME  . TYPE 2DROP CR
\D  ." EXPECT -1 oops : " 2 3 NEW-NAME  . TYPE 2DROP CR
\D  ." EXPECT -1 bytes : " 3 4 NEW-NAME  . TYPE 2DROP CR
\D 590 5A0 -db: byt2
\D  ." EXPECT 0 <anything> :" 3 4 NEW-NAME  . TYPE 2DROP CR .S

\ For a collapsible pair of section with INDEX1 and INDEX2 return INDEX1 and
\ INDEX2 plus a new START for the combined section.
: NEW-DIS-START OVER MAKE-CURRENT DIS-START  OVER MAKE-CURRENT DIS-START   MIN ;

\ For a collapsible pair of section with INDEX1 and INDEX2 return INDEX1 and
\ INDEX2 plus a new END for the combined section.
: NEW-DIS-END OVER MAKE-CURRENT DIS-END  OVER MAKE-CURRENT DIS-END   MAX ;

\D  ." EXPECT 520 : " 2 3 NEW-DIS-START . 2DROP CR
\D  ." EXPECT 590 : " 3 4 NEW-DIS-END  . 2DROP CR .S

\ For a pair of sections with INDEX1 and INDEX2 return INDEX1 and
\ INDEX2 plus "they CAN be collapsed."
: COLLAPSIBLE?  2DUP OVERLAP? IF 2DUP COMPATIBLE? ELSE 0 THEN ;

\D  ." EXPECT 0 : " 1 2 COLLAPSIBLE?    . 2DROP CR
\D  ." EXPECT -1 : " 2 3 COLLAPSIBLE?   . 2DROP CR
\D  ." EXPECT 0 : " 3 4 COLLAPSIBLE?   . 2DROP CR .S

\ Try to collapse a pair of sections with INDEX1 and INDEX2 return INDEX1 and
\ INDEX2 plus "they WERE collapsed."
\ Don't collapse sections that have been carefully given names,
\ but collapse a noname section into a named section.
: COMBINE  COLLAPSIBLE? 0= IF 0 EXIT THEN
    NEW-NAME 0= IF 2DROP 0 EXIT THEN   2>R
    DIS-CR-XT >R DIS-XT >R NEW-DIS-END >R NEW-DIS-START >R
   R> R> R> R> 2R> POSTFIX SECTION -1 ;

\D  .LABELS
\D  ." EXPECT 0  SAME ; " 3 4 COMBINE . .LABELS 2DROP CR  .S
\D  ." EXPECT -1 1 MORE : " 2 3 COMBINE . .LABELS 2DROP CR .S
\D  ." EXPECT 0  SAME : " 1 2 COMBINE . .LABELS  2DROP CR .S

\ Replace the two sections INDEX1 and INDEX2 with the last section.
\ Place it at index1 (which has the correct start address.)
: REPLACE  OVER >R REMOVE-LABEL REMOVE-LABEL R> ROLL-LABEL ;

\D  ." EXPECT 1 LESS : " 2 3 REPLACE .LABELS CR .S

\ Collapse INDEX1 and INDEX2 if possible.
\ It should work for increasing, but is tested for consequitive.
: COLLAPSE(I1,I2) COMBINE IF REPLACE ELSE 2DROP THEN ;

\D 59F 800 -db- .LABELS
\D  ." EXPECT 1 LESS : " 2 3 COLLAPSE(I1,I2) .LABELS CR .S

\ Collapse the label at INDEX with the next and or previous labels.
: COLLAPSE(I1) SECTION-LABELS
    DUP LAB-UPB < IF DUP OVER 1+ COLLAPSE(I1,I2) THEN
    DUP 1 > IF DUP 1- OVER COLLAPSE(I1,I2) THEN
    DROP ;

\D LABELS !BAG
\D 4FE 520 -dc-
\D 520 530 -dc: oops
\D 52A 570 -dc-
\D 560 590 -db: bytes
\D .LABELS
\D  ." EXPECT 1 LESS : " 2 COLLAPSE(I1) .LABELS CR .S
\ This looks like a proper design.
\ - sort on the start address, type (disassembler) and end address.
\ - start with the last section and work down until the second
\     - if it overlaps with or borders at the previous one and has the
\       same type and alignment, and the second one is not named
\       collapse the sections.
\     - if it overlaps with the previous one and has the same type and
\       alignment, and the second one is named, trim the first section.
\     - if it overlaps with the previous and has different type,
\         issue warning
\     - if it has a gap, introduce a character section
\   This may lead to an extra section, one less section, or no change
\   in the number of sections, but only at or after the current section.
\ - As a last action, introduce extra sections at the beginning and end.
\
\ This leads to words: SAME-TYPE SAME-ALIGN OVERLAP BORDER GAP IS-NAMED

\ For section INDEX: "It HAS the same type and alignment as the previous one."
: SAME-ALIGN    DUP MAKE-CURRENT  DIS-START SWAP
    1- MAKE-CURRENT   DIS-START - DIS-STRIDE MOD 0=   ;

\D INIT-ALL SECTION-LABELS  HEX
\D 12 34 -dc-
\D 34 65 -db: AAP
\D 38 80 -dl-
\D 82 90 -dl-
\D 88 94 -dl-

\D ." EXPECT: -1 :" 2 SAME-ALIGN . CR
\D ." EXPECT: -1 :" 3 SAME-ALIGN . CR \ Must become 0
\D ." EXPECT: -1 :" 4 SAME-ALIGN . CR

\ Redefine it to apply to one INDEX.
: COMPATIBLE?' DUP 1- SWAP  COMPATIBLE?   ;
\D ." EXPECT: 0 :" 2 COMPATIBLE?' . CR
\D ." EXPECT: 0 :" 3 COMPATIBLE?' . CR \ Must become 0
\D ." EXPECT: -1 :" 4 COMPATIBLE?' . CR

\ For section INDEX return END of previous, START of this one,
: END+START DUP MAKE-CURRENT DIS-START SWAP 1- MAKE-CURRENT DIS-END SWAP ;
\D ." EXPECT: 34 34 :" 2 END+START SWAP . . CR
\D ." EXPECT: 65 38 :" 3 END+START SWAP . . CR

\ Section INDEX overlaps with previous one.
: OVERLAP? END+START > ;
\D ." EXPECT: 0 :" 2 OVERLAP? . CR
\D ." EXPECT: -1 :" 3 OVERLAP? . CR
\D ." EXPECT: 0 :" 4 OVERLAP? . CR

\ Section INDEX overlaps or borders with the previous one.
: OVERLAP-OR-BORDER? END+START >= ;
\D ." EXPECT: -1 :" 2 OVERLAP-OR-BORDER? . CR
\D ." EXPECT: -1 :" 3 OVERLAP-OR-BORDER? . CR
\D ." EXPECT: 0 :" 4 OVERLAP-OR-BORDER? . CR

\ Section INDEX has a gap with the previous one.
: GAP?' END+START < ;
\D ." EXPECT: 0 :" 2 GAP?' . CR
\D ." EXPECT: 0 :" 3 GAP?' . CR
\D ." EXPECT: -1 :" 4 GAP?' . CR

\ For section INDEX: "It HAS a name"
: IS-NAMED   LABELS[] CELL+ @ ( xt) >NFA @ $@ "NONAME" $= 0= ;
\D ." EXPECT: -1 :" 2 IS-NAMED . CR
\D ." EXPECT: 0 :" 3 IS-NAMED . CR

\ Collapse section I into the previous section, that determines the properties.
: COLLAPSE DUP MAKE-CURRENT DIS-END OVER 1- MAKE-CURRENT DIS-END MAX DIS-END!
         REMOVE-LABEL ;
\D ." EXPECT: 5 82 94 4 :"
\D LAB-UPB . 5 COLLAPSE 4 MAKE-CURRENT DIS-START . DIS-END .  LAB-UPB . CR

\ Trim the section previous to INDEX, such that it borders to section index.
: TRIM-SECTION DUP MAKE-CURRENT DIS-START SWAP 1- MAKE-CURRENT DIS-END! ;
\D 90 1000 -dl-
\D ." EXPECT: 82 90 :" 5 TRIM-SECTION 4 MAKE-CURRENT DIS-START . DIS-END .  CR

\ Combine section INDEX with the previous one.
: COMBINE
    DUP OVERLAP-OR-BORDER? OVER IS-NAMED 0= AND IF DUP COLLAPSE THEN
    DUP OVERLAP? OVER IS-NAMED AND IF DUP TRIM-SECTION THEN  DROP ;
\D INIT-ALL
\D 10  30 -dl-
\D 20  40 -dl-
\D 30 50  -dl: aap
\D 60 80  -dl-
\D 90 100 -dl: noot
\D ." EXPECT: 5 5 :" LAB-UPB . 5 COMBINE LAB-UPB . CR
\D ." EXPECT: 5 5 :" LAB-UPB . 4 COMBINE LAB-UPB . CR
\D ." EXPECT: 5 5 20 30 :" LAB-UPB . 3 COMBINE LAB-UPB . 2 MAKE-CURRENT DIS-START . DIS-END . CR
\D ." EXPECT: 5 4 10 30 :" LAB-UPB . 2 COMBINE LAB-UPB . 1 MAKE-CURRENT DIS-START . DIS-END . CR

\ Combine section INDEX with a previous overlapping or bordering section.
: KILL-OVERLAP DUP SAME-ALIGN OVER COMPATIBLE?' AND IF DUP COMBINE THEN DROP ;
\D INIT-ALL
\D 10  30 -dl-
\D 20  40 -dl-
\D 30 50  -dl: aap
\D 60 80  -dl-
\D 90 100 -dl: noot
\D ." EXPECT: 5 5 :" LAB-UPB . 5 KILL-OVERLAP LAB-UPB . CR
\D ." EXPECT: 5 5 :" LAB-UPB . 4 KILL-OVERLAP LAB-UPB . CR
\D ." EXPECT: 5 5 20 30 :" LAB-UPB . 3 KILL-OVERLAP LAB-UPB . 2 MAKE-CURRENT DIS-START . DIS-END . CR
\D ." EXPECT: 5 4 10 30 :" LAB-UPB . 2 KILL-OVERLAP LAB-UPB . 1 MAKE-CURRENT DIS-START . DIS-END . CR
\D INIT-ALL
\D 10  30 -dl-
\D 20  28 -db-
\D 30 70  -dl: aap
\D 60 80  -dl-
\D 7F 10F -dl-
\ The following is actually wrong because the aligning is not tested yet.
\D ." EXPECT: 5 4 60 10F :" LAB-UPB . 5 KILL-OVERLAP LAB-UPB . 4 MAKE-CURRENT DIS-START . DIS-END . CR
\D ." EXPECT: 4 3 30 10F :" LAB-UPB . 4 KILL-OVERLAP LAB-UPB . 3 MAKE-CURRENT DIS-START . DIS-END . CR
\D ." EXPECT: 3 3 20 28 :" LAB-UPB . 3 KILL-OVERLAP LAB-UPB . 2 MAKE-CURRENT DIS-START . DIS-END . CR
\D ." EXPECT: 3 3 10 30 :" LAB-UPB . 2 KILL-OVERLAP LAB-UPB . 1 MAKE-CURRENT DIS-START . DIS-END . CR

\ Introduce char section to fill the gap at INDEX. Note that the result is unordered.
: FILL-GAP DUP GAP?' IF   DUP END+START -d$-   DUP 1+ LAB-UPB MAX KILL-OVERLAP
    DUP KILL-OVERLAP THEN DROP ;
\D ." EXPECT: 3 4 28 30 :" LAB-UPB . 3 FILL-GAP LAB-UPB . 4 MAKE-CURRENT DIS-START . DIS-END . CR
\D ." EXPECT: 4 4 20 28 :" LAB-UPB . 2 FILL-GAP LAB-UPB . 2 MAKE-CURRENT DIS-START . DIS-END . CR

\ Clean up the section labels, from behind.
\ Although the bounds may not be valid after a clean up, this works
\ because a clean up of a section only concerns higher sections, no
\ longer considered.
\ So a section can comfortably be removed using the regular removal
\ mechanism for bags. A newly introduced section automatically falls
\ into place, because of the conditions regarding the start addresses.
: CLEANUP-SECTIONS SECTION-LABELS
    2 LAB-UPB 2DUP <= IF DO I .S KILL-OVERLAP -1 +LOOP THEN ;

\ Fill any holes with character sections.
: PLUG-HOLES  SECTION-LABELS LAB-UPB 1+ 2 ?DO I .S FILL-GAP LOOP SORT-LABELS ;

\ ------------------------------------------------------------------------
ASSEMBLER

        \ Jump targets that are starting points for further crawling.
\ Adding and removing from this bag ressembles a recursive action.
\ Recursion will not do here! This is because sections are not added
\ until the end is detected.
1000 BAG STARTERS

VARIABLE (R-XT)        \ Required xt.
\ Return the XT that is required for the current disassembly.
: REQUIRED-XT (R-XT) @ ;
\ Specify normal disassembly.
: NORMAL-DISASSEMBLY 'D-R-T (R-XT) ! BITS-32 ;
NORMAL-DISASSEMBLY

\ Add the information that ADDRESS1 to ADDRESS2 is a code section.
\ If section labels was sorted, it remains so.
: INSERT-SECTION   OVER SECTION-LABELS WHERE-LABEL >R
    REQUIRED-XT 'CR+LABEL ANON-SECTION   R@ ROLL-LABEL   R> COLLAPSE(I1) ;

\ The following are auxiliary words for `` KNOWN-CODE? '' mainly.
\ For all those section labels must be current and sorted.
\ Prepend `` SECTION-LABELS '' if you want to use the auxiliary words.

\ For ADDRESS : "it IS in a current code section"
: IN-CURRENT-CODE?   DIS-START DIS-END WITHIN   DIS-XT REQUIRED-XT =   AND ;

\ For ADDRESS and section number N: "address SITS in code section n"
: IN-CODE-N? MAKE-CURRENT IN-CURRENT-CODE? ;

\ For ADDRESS and section I : "It IS code and address is part of it,
\  or same holds for previous section."
: IN-CODE?  DUP 0 = IF 2DROP 0 ELSE   \ Not present.
            2DUP IN-CODE-N? IF 2DROP -1 ELSE
            DUP 1 = IF 2DROP 0 ELSE   \ Previous not present.
            1- IN-CODE-N? THEN THEN THEN ;

\ For ADDRESS: "It IS known code, according to ``SECTION-LABELS''".
: KNOWN-CODE?   SECTION-LABELS DUP WHERE-LABEL LAB-UPB MIN IN-CODE? ;

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

\ Analyse the code range from ADDRESS up to an unconditional transfer.
\ Add information about jumps to ``STARTERS'' and new sections to ``LABELS''.
: CRAWL-ONE  DUP >R TARGET>HOST BEGIN (DISASSEMBLE) ANALYSE-INSTRUCTION
    DUP HOST-END >=   LATEST-INSTRUCTION @ UNCONDITIONAL-TRANSFERS IN-BAG?   OR
  UNTIL     R> SWAP HOST>TARGET INSERT-SECTION
  CR ." STARTERS:" STARTERS .BAG CR ;

\ Analyse code from ADDRESS , unless already known.
: ?CRAWL-ONE? DUP KNOWN-CODE? 0= IF CRAWL-ONE _ THEN DROP ;

\ Crawl through code from all points in ``STARTERS''.
: (CRAWL)   BEGIN STARTERS BAG? WHILE STARTERS BAG@- ?CRAWL-ONE? REPEAT ;

\ ADDRESS points into code. Crawl through code from there, i.e. add
\ all information about code ranges that can be derived from that.
: CRAWL   SECTION-LABELS SORT-LABELS   STARTERS DUP !BAG BAG+!   (CRAWL) ;

\ ------------------------ INTEL 80386 ------------------------------
\ Intel specific. There is a need to specify the disassembly xt.
\ Crawl with normal disassembly (observing `` TALLY-BA '')
\ resp. crawl through 16 / 32 bits code.
\ The other owns change it all the time.
: CRAWL16  'D-R-T-16 (R-XT) ! BITS-16 CRAWL NORMAL-DISASSEMBLY ;

PREVIOUS
