
\ Crawling is the process of following jumps to determine code space.
\ During crawling always the section labels must be current and sorted.

\ Jump targets that are starting points for further crawling.
1000 BAG STARTERS

VARIABLE (R-XT)        \ Required xt.
\ Return the XT that is required for the current disassembly.
: REQUIRED-XT (RX-T) @ ;
\ Specify normal disassembly.
: NORMAL-DISASSEMBLY 'D-R-T (RX-T) ! ;
NORMAL-DISASSEMBLY

\ Where the code ends in the target space.
\ FIXME! Knullig.
: END-TARGET  _AP_ ;

\ Swap the ITH and last label.
\ A label occupies two consecutive places!
: SWAP-LABEL   DUP   LABELS[]  DUP LABELS BAG-HOLE   LABELS BAG-HOLE
   LAB-BOUNDS 1- SWAP DROP   LAB<->   LABELS BAG@- DROP ;

\ Add the information that ADDRESS1 to ADDRESS2 is a code section.
\ It is added to the end, then swapped to the right place.
: ADD-SECTION   OVER FIND-LABEL >R   REQUIRED-XT ANON-SECTION
    R> DUP IF SWAP-LABEL _ THEN DROP ;

\ Make section I current.
: MAKE-CURRENT LABELS[] CELL+ @ EXECUTE ;

\ For ADDRESS : "it IS in a current code segment"
\ FIXME: if the jumps are not to the same type of disassembly segment
\ this definitely signals a problem. Now it is ignored.
: IN-CURRENT-CODE?   START END WITHIN   DIS-XT REQUIRED-XT =   AND ;

\ For ADDRESS and segment number N: "address SITS in code segment n"
: IN-CODE-N? MAKE-CURRENT IN-CURRENT-CODE? ;

\ For ADDRESS and section I : "It IS code and address is part of it,
\  or same holds for previous section."
: IN-CODE?  2DUP IN-CODE-N? IF 2DROP -1 ELSE
            DUP 1 = IF 2DROP 0 ELSE
            1- IN-CODE-N? THEN THEN ;

\ For ADDRESS" "It IS known code, according to ``SECTION-LABELS''".
: KNOWN-CODE?   DUP FIND-LABEL DUP IF IN-CODE? ELSE 2DROP 0 THEN ;

\ Return the target ADDRESS of the current instruction.
\ (It must be a jump of course.
: JUMP-TARGET 1234 ;

\ Analyse current instruction after disassembly.
\ DISS LATEST-INSTRUCTION ISS ISL are all valid.
: ANALYSE-INSTRUCTION   LATEST-INSTRUCTION JUMPS @ IN-BAG? IF
    TARGET-ADDRESS KNOWN-CODE? IF TARGET-ADDRESS STARTERS +! THEN THEN ;

\ Analyse the code range from ADDRESS up to an unconditional transfer.
\ Add information about jumps to ``STARTERS'' and new sections to ``LABELS''.
: CRAWL-ONE  DUP >R BEGIN (DISASSEMBLE) ANALYSE-INSTRUCTION
    DUP _AP_ >=   LATEST-INSTRUCTION @ UNCONDITIONAL-TRANSFERS IN-BAG?   OR
  UNTIL     R> SWAP ADD-SECTION ;

\ Analyse code from ADDRESS , unless already known.
: ?CRAWL-ONE? DUP KNOWN-CODE? 0= IF CRAWL-ONE _ THEN DROP ;

\ Crawl through code from all points in ``STARTERS''.
: (CRAWL)   BEGIN STARTERS BAG? WHILE STARTERS BAG@- CRAWL-ONE REPEAT ;

\ ADDRESS points into code. Crawl through code from there, i.e. add
\ all information about code ranges that can be derived from that.
: CRAWL   SECTION-LABELS SORT-LABELS   STARTERS BAG+! (CRAWL) ;

\ ------------------------ INTEL 80386 ------------------------------
\ Intel specific. There is a need to specify the disassembly xt.
\ Crawl with normal disassembly (observing `` TALLY-BA '')
\ resp. crawl through 16 / 32 bits code.
\ without altering it. The other owns change it all the time.
: CRAWL    NORMAL-DISASSEMBLY CRAWL ;
: CRAWL16  'D-R-T-16 (RX-T) ! CRAWL ;
: CRAWL32  'D-R-T-32 (RX-T) ! CRAWL ;
