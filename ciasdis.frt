( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( REVERSE ENGINEERING ASSEMBLER  cias cidis for 80386                   )

\ Officially named computer_intelligence_assembler_386
\                  computer_intelligence_disassembler_386
\ this file is installed under the name cias and cidis to behave
\ as an assembler or disassembler.

\ This is a main build. For details see asgen.frt

\ ------------------Disgraceful adaptations. -------------------
\ Put here to draw attention.
\ This name might later be changed.
: NONAME$ "NONAME" ;

REQUIRE OLD:    REQUIRE $=
\ Patch the word ``PRESENT'' such that no name words are no longer
\ considered present. This prevent zillion error messages.
: NEW-PRESENT   OLD: PRESENT DUP IF DUP >NFA @ $@ NONAME$ $= 0= AND THEN ;
' NEW-PRESENT ' PRESENT 3 CELLS MOVE

\ Patch the word ``L@'' with the name "FAR@". Such that it no longer
\ conflicts with the ``L@'' we have.
: FAR@ L@ ;    HIDE L@

\ --------------------------------------------------------------

INCLUDE class.frt
INCLUDE tools.frt
INCLUDE asgen.frt
INCLUDE aswrap.frt      \ neater if put here
INCLUDE asi386.frt
INCLUDE asipentium.frt

\ Tools
INCLUDE access.frt

\ INCLUDE aswrap.frt      \ neater if put here
INCLUDE labelas.frt
INCLUDE labeldis.frt
INCLUDE crawl.frt

\ In behalf of user.
REQUIRE #-PREFIX
\ In behalf of building an executable.
REQUIRE ARGC    REQUIRE OLD:    REQUIRE SRC>EXEC        REQUIRE INCLUDED

\ Assemble file NAME. Leave compiled BUFFER LENGTH.
: ASSEMBLED
   ONLY POSTPONE FORTH POSTPONE ASSEMBLER HEX
    FIRSTPASS 2DUP INCLUDED  SECONDPASS INCLUDED
   CODE-SPACE CP @ OVER - ;

\ Return the NAME of the target file.
: TARGET-AS 2 ARG[] ;

\ Perform the action of the program as per the spec's of ``cias''
: cias   1 ARG[] ASSEMBLED   TARGET-AS PUT-FILE ;

\ Fetch file NAME to the code buffer.
: FETCHED    GET-FILE CODE-SPACE SWAP    2DUP + CP !   MOVE ;

\ Fetch file "name" to the code buffer.
: FETCH    (WORD) FETCHED ;

\ Return the NAME of the target file.
: TARGET-DIS 2 ARG[] ;

REQUIRE DUMP
\ Using (only) information from file with NAME,
\ disassemble the current program as stored in the ``CODE-BUFFER''.
: CONSULTED   INIT-ALL   HEX INCLUDED ( file)   SORT-ALL
    PLUG-HOLES ALL-L-LABELS DISASSEMBLE-TARGET DECIMAL ;

\ Consult "file" as per ``CONSULT''
: CONSULT   (WORD) CONSULTED ;

\ Perform the action of the program as per the spec's of ``cidis''
: cidis   1 ARG[] FETCHED TARGET-DIS CONSULTED ;

\ Restore all revectoring done while compiling to stand alone.
: RESTORE-ALL  'ERROR RESTORED     'INCLUDED RESTORED      'ABORT RESTORED ;

\ Start an interactive session or a filter.
\ The startup code has changed ``OK'' for a filter.
\ In that case suppress the splat screen.
\ Note that ``QUIT'' is the command interpreter.
: INTERACTIVE    'OK DUP >DFA @ SWAP >PHA = IF 0 LIST OK THEN
        ASSEMBLER   0 ORG   QUIT ;

\ Handle arguments, start interactive system if no arguments.
: HANDLE-ARG   ARGC 1 = IF INTERACTIVE THEN
    \ second argument still obligatory for the moment.
    ARGC ( 2) 3 4 WITHIN 0= 13 ?ERROR ;

\ For STRING: "It CONTAINS a `d' or a `D' "
: CONTAINS-D?    2DUP &D $I >R  &d $I R>  OR ;

\ Fetch the library file from the current directory.
\ We can't assume lina has been installed so forth.lab is supplied with
\ the ciasdis program.
"forth.lab" BLOCK-FILE $!

\ The name determines what to do.
: MAIN   RESTORE-ALL  HANDLE-ARG   0 ARG[] CONTAINS-D? IF cidis ELSE cias THEN ;
