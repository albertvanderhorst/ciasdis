\ CREATE testing
REQUIRE [DEFINED]
REQUIRE SWAP-DP
\ : EVALUATE ." **< " .S 2DUP TYPE EVALUATE ." **>" CR ;

\ Transform an INT to a STRING.
: itoa 0 <# #S BL HOLD #> ;

4096 CONSTANT LEN
\ : IN @ SRC DROP >IN @ + ; use instead of ``IN @ '' for ISO.
\ : EVALUATE  &* EMIT TYPE &* EMIT ;
\ The name of the class.
CREATE NAME$ 128  ALLOT

VARIABLE start
\ First used to evaluate "VARIABLE ^<class>"
\ Then ": BUILD-<class> CREATE HERE >R X , Y ALLOT .. R> ;"
\ Then ": <class>   CREATE BUILD-<class> ^<class> ! DOES>    ^<class> ! ;
CREATE CRS$ LEN ALLOT

\ Add the name.
: +NAME   NAME$ $@ CRS$ $+! ;
\ Add the name and a STRING.
: +NAME+$  +NAME CRS$ $+! ;

\ Start of the code that is executed, but also added to ``BUILD-<class>''.
VARIABLE LAST-IN

\ Compile the pointer variable for class ``NAME$''.
: COMPILE-CLASS-POINTER   "VARIABLE ^" CRS$ $! +NAME CRS$  $@ EVALUATE ;

\ Fill the first part of a string to build class ``NAME$''.
: START-BUILD-STRING ": BUILD-" CRS$ $! " HERE >R " +NAME+$  ;

\ Add the input stream since the last marking, but trim a last word
\ of N characters. This is what the user wants to do to build his class.
: ADD-SINCE-LAST   1+ >R LAST-IN @ IN @ R> - OVER - CRS$ $+! ;

\ To contain "^<class> @ <offset> +" to be evaluated as the first part
\ of a method, for different <offset>.
CREATE F$ 100 ALLOT

\ 1. Add the last interpreted words to the build-string
\ 2. Start compiling a method in the regular compilation area.
\ 3. Compile the address upon which the method works.
: M: 2 ( aqa "M:" NIP ) ADD-SINCE-LAST
     " ^" F$ $! NAME$ $@ F$ $+! " @ " F$ $+!
     HERE start @ - itoa F$ $+! " + " F$ $+!
     SWAP-DP :
     F$ $@  EVALUATE
;

\ 1. End compiling a method.
\ 2. Continue interpreting pro forma build commands to the alternative
\     dictionary space and remember where the interpreting started.
: M;
    POSTPONE ;
    SWAP-DP
    IN @  LAST-IN !
; IMMEDIATE

\ 1. Remember the name of the class.
\ 2. Compile the class pointer.
\ 3. Start the build-string, a colon definition to be evaluated later.
\ 4. Start interpreting pro forma build commands to the alternative
\     dictionary space and remember where the interpreting started.
\ 5. Remember the start of the alternative dictionary area.
\  (To calculate offsets, and recover the space.)
: class
    (WORD) NAME$ $!
    COMPILE-CLASS-POINTER START-BUILD-STRING
    SWAP-DP HERE start !
    IN @  LAST-IN !
;

\ 1. Recover space used in alternative area, and switch back
\   to regular compilation.
\ 1. Add the last interpreted words to the build-string
\ 2. Terminate it and evaluate it to create the build word.
\ 3. Make and evaluate the class-creation-string
: endclass ?EXEC
   start @ HERE - ALLOT SWAP-DP
   8 ( aqa "endclass" NIP) ADD-SINCE-LAST
   " R> ;" CRS$ $+! CRS$ $@  EVALUATE
   ": " CRS$ $!
   " CREATE BUILD-" +NAME+$
   " ^" +NAME+$  " ! DOES> ^" +NAME+$  " ! ;" +NAME+$
    CRS$ $@ EVALUATE
;
\ --------------- test section ----------------------------
[DEFINED] testing [IF]

 1         \ Dummy data
class JAN
 M: one     @ . M; ,
 M: two     @ . M; 2 ,
 endclass


1 JAN JAN1
12345 JAN JAN2

 1      \ Dummy data
class PIET
 M: onep @ . M;  ,
 M: twop @ . M; 4 ,
 endclass

1 PIET PIET1
12 PIET PIET2

                       \ To be expected :
.( Expect  1 2 : )
JAN1 one two CR
.( Expect  12345 2 : )
JAN2 one two CR
.( Expect  1 4     : )
PIET1 onep twop CR
.( Expect  12 4    : )
PIET2 onep twop CR
.( Expect  1 2     : )
JAN1 one two CR
.( Expect  12345 2 : )
JAN2 one two CR

.( Expect  ": PIET CREATE BUILD-PIET ^PIET ! DOES> ^PIET ! ;" : )
CR CRS$ $@ TYPE CR
.( Expect  "^PIET @ 4 +" : )
CR F$ $@ TYPE  CR
[THEN]
