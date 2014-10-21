( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( REVERSE ENGINEERING ASSEMBLER  cias cidis for 80386                   )

\ Officially named computer_intelligence_assembler_386
\                  computer_intelligence_disassembler_386
\ this file is installed under the name cias and cidis to behave
\ as an assembler or disassembler.

\ This is a main build. For details see asgen.frt

'$@   ALIAS @+

WANT OLD:    WANT $=      WANT class   WANT W/O

\ ------------------Disgraceful adaptations. -------------------

\ Put here to draw attention.
\ This name might later be changed.
: NONAME$ "NONAME" ;

\ Patch the word ``PRESENT'' such that no name words are no longer
\ considered present. This prevent zillion error messages.
: NEW-PRESENT   OLD: PRESENT DUP IF DUP >NFA @ $@ NONAME$ $= 0= AND THEN ;
' NEW-PRESENT ' PRESENT 3 CELLS MOVE

\ --------------------------------------------------------------

INCLUDE tools.frt
INCLUDE asgen.frt
INCLUDE aswrap.frt
INCLUDE asi386.frt
INCLUDE asipentium.frt

\ Tools
INCLUDE access.frt

\ INCLUDE aswrap.frt      \ neater if put here
INCLUDE labelas.frt
INCLUDE labeldis.frt
INCLUDE crawl.frt

\ In behalf of user.
WANT #-PREFIX
\ In behalf of building an executable.
WANT ARGC

\ Write current section to FILEHANDLE. Leave FILEHANDLE.
: WRITE-ONE-SECTION
   >R   FILE-OFFSET 0 R@ REPOSITION-FILE THROW
   CODE-SPACE CP @ OVER - R@ WRITE-FILE THROW R> ;

\ Write all sections to FILEHANDLE. Leave FILEHANDLE.
: WRITE-SECTIONS   SECTION-REGISTRY DO-BAG I @ EXECUTE WRITE-ONE-SECTION
    LOOP-BAG ;

\ Open NAME, return FILEHANDLE.
: OPEN-IT $1ED CREATE-FILE THROW ;

\ Close FILEHANDLE.
: CLOSE-IT CLOSE-FILE THROW ;

\ Return the NAME of the source file.
: SOURCE-AS 1 ARG[] ;

\ Return the NAME of the target file.
: TARGET-AS 2 ARG[] ;

\ Write all sections to file NAME.
: WRITE-IT   OPEN-IT WRITE-SECTIONS CLOSE-IT ;

\ Assemble file NAME. Leave in default or file-specified sections.
: ASSEMBLED
   ONLY FORTH ASSEMBLER HEX
    FIRSTPASS 2DUP INCLUDED  SECONDPASS INCLUDED ;

\ Perform the action of the program as per the spec's of ``cias''
: cias   SOURCE-AS ASSEMBLED   TARGET-AS WRITE-IT ;

\ Fetch file NAME to the code buffer.
: FETCHED    GET-FILE CODE-SPACE SWAP    2DUP + CP !   MOVE ;

\ Fetch file "name" to the code buffer.
: FETCH    NAME FETCHED ;

\ Return the NAME of the target file.
: TARGET-DIS 2 ARG[] ;

WANT DUMP
\ Using (only) information from file with NAME,
\ disassemble the current program as stored in the ``CODE-BUFFER''.
: CONSULTED   INIT-ALL   HEX INCLUDED ( file)   SORT-ALL
    PLUG-HOLES ALL-L-LABELS DISASSEMBLE-TARGET DECIMAL ;

\ Consult "file" as per ``CONSULT''
: CONSULT   NAME CONSULTED ;

\ Perform the action of the program as per the spec's of ``cidis''

: cidis   1 ARG[] FETCHED TARGET-DIS CONSULTED ;

\ Restore all revectoring done while compiling to stand alone.
: RESTORE-ALL  'ERROR RESTORED     'INCLUDED RESTORED      'ABORT RESTORED ;

\ The prompt we want to use.
: PROMPT    CR "ci>" TYPE ;

\ Change the prompt to "Hurry up, dummy!" style.
: CHANGE-PROMPT   'PROMPT 'OK 3 CELLS MOVE ;

\ Start an interactive session or a filter.
\ The startup code has changed ``OK'' for a filter.
\ In that case suppress the splat screen.
\ Note that ``QUIT'' is the command interpreter.
: INTERACTIVE    'OK DUP >DFA @ SWAP >PHA = IF 0 LIST CHANGE-PROMPT OK THEN
        ASSEMBLER   0 ORG   QUIT ;

\ Print usage, then go bye with EXITCODE.
: USAGE
" Usage:
    start interactive system: ciasdis
    help:        ciasdis -h
    assemble:    [cias  | ciasdis -a ]    <source> <binary>
    disassemble: [cidis  | ciasdis -d ]   <binary> <consult>
    install:     ciasdis -i <executable> <library> [ <shell> ]
" TYPE   EXIT-CODE !   BYE ;

\ Abort on error.
: CHECK-ARGS   ARGC 3 4 WITHIN 0= IF 1 USAGE THEN ;

: -a   SHIFT-ARGS   CHECK-ARGS  1 ;
: -d   SHIFT-ARGS   CHECK-ARGS  2 ;
: -i   ^I LOAD ;
: -h   0 USAGE ;

\ For STRING: "It CONTAINS a `d' or a `D' "
: CONTAINS-D?    2DUP &D $^ >R  &d $^ R>  OR ;

\ Handle arguments, start interactive system if no arguments.
: HANDLE-ARG   ARGC 1 = IF INTERACTIVE 0 EXIT THEN
    1 ARG[] OVER C@ &- = IF EVALUATE EXIT THEN
    0 ARG[] CONTAINS-D? IF CHECK-ARGS 2 ELSE CHECK-ARGS 1 THEN ;

\ Fetch the library file from the current directory.
\ We can't assume lina has been installed so forth.lab is supplied with
\ the ciasdis program.
"forth.lab" BLOCK-FILE $!

\ Make a cold start silent.
'TASK >DFA @   '.SIGNON >DFA !

\ The name determines what to do.
: MAIN   RESTORE-ALL DEFAULT-SECTION HANDLE-ARG CHANGE-PROMPT
        DUP 0 = IF DROP INTERACTIVE
   ELSE DUP 1 = IF DROP cias
   ELSE DUP 2 = IF DROP cidis
   THEN THEN THEN DROP ;
