( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
( Uses Richard Stallmans convention. Uppercased word are parameters.    )

\ Wrapper for DPMI that can't inspect argument 0.

INCLUDE ciasdis.frt

: MAIN   RESTORE-ALL  HANDLE-ARG   cidis ;
