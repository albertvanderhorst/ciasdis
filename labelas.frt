( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( Handle labels )

REQUIRE BAG             \ Simple bag facility
REQUIRE DO-BAG          \ More advanced bag facility
REQUIRE POSTFIX

( Make sure undefined labels don't fool up the first pass of the        )
(   assembly                                                            )
\ Replace not found FLAG , by a valid DEA with the stack effect of a label.
\ The result is that unknown words are compiled as a _ , i.e. it
\ generates a don't care value.
\ Supposedly these are labels that have not been defined yet.
\ Go on compiling.
\ Loading the same code another time will give correct code.
: FIX-DEA DROP '_ ;
( Make sure undefined labels that looks like numbers,                   )
(   don't fool up the first pass of the assembly.                       )
( Not that we endorse the idea to name labels like 250HUP.              )
\ All of a word may have been scanned, so before using (WORD) ,
\ we backspace one char.
\ Afterwards we backspace again, such that the number routine we return
\ to concludes it is ready.
\ We leave some random number, which is okay, but it must be single precision!
: FIX-NMB   -1 IN +!   (WORD) 2DROP   -1 IN +!   0 DPL ! ;

\ If FLAG we have a misspelled number, skip its remainder.
: ERROR10 DROP IF  FIX-NMB THEN ;
\ If FLAG we have an unknown word, treat it as a label.
: ERROR12 DROP IF  FIX-DEA THEN ;

REQUIRE OLD:
\ Replacement for ?ERROR, if FLAG, give error NUMBER.
\ Fix up errors, see FIX-NMB FIX-DEA.
: ?ERROR-FIXING
    DUP 10 = IF ERROR10 ELSE
    DUP 12 = IF ERROR12 ELSE
    OLD: ?ERROR
    THEN THEN   ;

\ Ignore undefined labels during first pass ...
: FIRSTPASS   '?ERROR-FIXING >DFA @ '?ERROR >DFA ! ;
\   but not any more in the second pass.
: SECONDPASS   '?ERROR RESTORED ;

\ For NAME: "name REPRESENTS a label."
: IS-A-LABEL? FOUND DUP IF >CFA @ 'BL >CFA @ = THEN ;

\ For NAME: NAME and "it is a KNOWN label."
\ We don't need to define it if there is already a label of that name.
\ If it has not the value of the programpointer we must report a phase error.
: KNOWN-LABEL?   2DUP IS-A-LABEL? >R
    R@ IF 2DUP FOUND EXECUTE _AP_ <> IF "ERROR: phase error defining label "
    ETYPE 2DUP ETYPE CR THEN THEN
R> ;

( Make a denotation for labels. They look like `` :LABEL ''             )
( Put `` : '' in the ONLY wordlist, such that it doesn't                )
( interfere with the normal semicolon.                                  )
\ A word starting with a ``:'' is a label definition denotation.
\ The part after the ``:'' may be defined already, but if it is
\ a label it must have the value of the current program counter.
\ So it is possible to redefine words as labels (heed the warnings.)
\ This is very tricky, but the assembler programmer must not be
\ restricted by what words are in Forth.
\ Note: this is actually an abuse of the denotation mechanism.
'ONLY >WID CURRENT !  \ Making ONLY the CONTEXT is dangerous! This will do.
: : (WORD)
    KNOWN-LABEL? IF 2DROP ELSE 2>R _AP_ 2R> POSTFIX CONSTANT THEN
; PREFIX IMMEDIATE    DEFINITIONS

( Handle constant data in assembler )

\ Contains the data on the remainder of the line in reverse order.
100 BAG DX-SET

: !DX-SET DX-SET !BAG ;

\ Fill ``DX-SET'' from the remainder of the line in reverse order.
: GET-DX-SET    DEPTH >R   ^J (PARSE) EVALUATE DEPTH R> ?DO DX-SET BAG+! LOOP ;

\ Output ``DX-SET'' as bytes.
: C,-DX-SET  BEGIN DX-SET BAG@- AS-C,  DX-SET BAG? 0= UNTIL ;

\ Add remainder of line to codespace, as bytes.
: db   !DX-SET  GET-DX-SET    C,-DX-SET  ;

\ NOTE: The following assumes (W,) and (L,) are defined in the specific assembler.
\ These must not be commaers, just lay down 16 or 32 bits entities in the
\ right endian format.

ASSEMBLER
\ Output ``DX-SET'' as words (16-bits)
: W,-DX-SET  BEGIN DX-SET BAG@- (W,)  DX-SET BAG? 0= UNTIL ;

\ Add remainder of line to codespace, as words.
: dw   !DX-SET  GET-DX-SET    W,-DX-SET  ;

\ Output ``DX-SET'' as longs (32-bits)
: L,-DX-SET  BEGIN DX-SET BAG@- (L,)  DX-SET BAG? 0= UNTIL ;

\ Add remainder of line to codespace, as longs (or, mostly, cells).
: dl   !DX-SET  GET-DX-SET    L,-DX-SET  ;

\ Lay down a STRING in assembler memory.
: ($,) AS-HERE SWAP DUP AS-ALLOT MOVE ;

\ Output ``DX-SET'' as longs (32-bits)
: $,-DX-SET  BEGIN DX-SET BAG@- DUP 255 > IF DX-SET BAG@- ($,) ELSE AS-C, THEN
    DX-SET BAG? 0= UNTIL ;

\ Add remainder of line to codespace, as strings.
: d$   !DX-SET  GET-DX-SET    $,-DX-SET  ;
PREVIOUS
