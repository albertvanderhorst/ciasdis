( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( The proper way to do struct's in Forth, at last! )

4096 CONSTANT LEN
\ : IN@ SRC DROP >IN @ + ; use instead of ``IN @ '' for ISO.
\ : EVALUATE  &* EMIT TYPE &* EMIT ;
\ The name of the struct.
CREATE NAME$ 128  ALLOT
\ The name of the struct pointer.

\ To be executed, to generate the struct.
\ This action will get the name ``CREATE-<struct>''.
CREATE CRS$ LEN ALLOT

\ To be executed, to give names to ``DOES>'' actions.
CREATE DOES>$ LEN ALLOT

\ Clear ``CRS$'' by setting its length to zero.
: !CRS$ 0 CRS$ ! ;

\ Add STRING and the name of the current struct to CRS$.
: +NAME$   CRS$ $+!    NAME$ $@ CRS$ $+!   BL CRS$ $C+ ;

\ Start of the code to be executed later.
VARIABLE LAST-IN

\ Remember last value of ``IN''.
: RLI IN @ LAST-IN ! ;
\ Trim N chars from the input since ``RLI'', return as a STRING.
: GLI >R LAST-IN @ IN @  R> - OVER - ;

\ Start of the example struct.
VARIABLE start

\ Transform an INT to a STRING.
: itoa 0 <# #S BL HOLD #> ;

\ Add the first part of a definition of a field to DOES>$.
\ (That part looks like "F: field-name 12 ^MYSTRUCT @ +". in a
\ deompilation.).
: F:
    " : " DOES>$ $+! (WORD) DOES>$ $+!
    RLI
    HERE start @ - itoa DOES>$ $+!
    " ^" DOES>$ $+!   NAME$ $@ DOES>$ $+!    " @ + " DOES>$ $+!
;

\ Add the create part and does part to respective strings.
: FDOES>  7 ( length of " FDOES>") GLI CRS$ $+!
    &; (PARSE) 1+ DOES>$ $+!
;

\ Prepare to create a defining word with "name", that creates a structure.
\ Create a variable "^name" that is a pointer to the instance
\ of the struct that is currrent.
\ The actual creation is postponed, till the end of the
\ structure because it would interfere with the
\ memory allocations foreseen.
\ Construct a sample structure for the purpose of finding
\ the offsets of the fields.
\ Directly after creation the new structure is current.
\ This is convenient for filling in fields afterwards.
: struct
    (WORD) NAME$ $!
    !CRS$   "VARIABLE ^" +NAME$   CRS$ $@ EVALUATE
    HERE start !
    !CRS$  ": CREATE-" +NAME$    " HERE >R " CRS$ $+!
    "" DOES>$ $!
;

\ Create a defining word for the struct as a whole.
\ Then create words for the fields.
\ Also recover the memory of the sample structure.
: endstruct ?EXEC
   start @ HERE - ALLOT
   " R> ;" CRS$ $+! CRS$ $@ EVALUATE
   DOES>$ $@ EVALUATE
   !CRS$ ": " +NAME$   " CREATE CREATE-" +NAME$
   " ^" +NAME$   " !  DOES> ^" +NAME$   " ! ; " CRS$ $+!
   CRS$ $@ EVALUATE
; IMMEDIATE
