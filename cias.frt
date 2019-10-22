( $Id: cias.frt,v 1.1 2004/05/23 09:50:08 albert Exp $ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Wrapper for DPMI that can't inspect argument 0.

INCLUDE ciasdis.frt

: MAIN   RESTORE-ALL  HANDLE-ARG   cias ;
