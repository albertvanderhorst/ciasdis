( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

( Wrapper for asgen, when we want to test without label mechanisms. )
'HERE  ALIAS AS-HERE
'C,    ALIAS AS-C,
'ALLOT  ALIAS AS-ALLOT
'HERE  ALIAS _AP_

\ Adorn the ADDRESS we are currently disassembling with data
\ from a disassembly data file.
: ADORN-ADDRESS DROP CR ;
