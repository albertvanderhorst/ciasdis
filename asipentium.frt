( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
 ASSEMBLER DEFINITIONS HEX

\ Instructions that are in all Pentium's, but not in i386.

\ Morebad bits ...
(  FP:        10,0000 FP-specific   20,0000 Not FP                      )
                                HEX
\ 0F prefix
0 0 0 T!        0100 080F 2 2FAMILY, INVD, WBINVD,
0 0 0 AA0F 2PI RSM,
0 0 0 0B0F 2PI Illegal-1,
0 0 0 B90F 2PI Illegal-2,
0112 0 0700 C80F 2PI BSWAP,
0 0 0 T!        0100 300F 3 2FAMILY, WRMSR, RDTSC, RDMSR,
04,1400 0 FF0100  T!  1000 B00F 2 3FAMILY, CMPXCH, XADD,

PREVIOUS DEFINITIONS DECIMAL
          EXIT

\ 0F prefix with mod r/m byte.
\ 0 0 C700 %00111000 0F 3PI, INVLPG,
0 0 0 38000F 3PI INVLPG,
\ 0 0 C70000 %00001000 C70F 3PI, CMPXHG8B
0220 0 0 C70000 08C70F 3PI, CMPXHG8BM,

\ Floating point.
'R| >BA  0020,000 TOGGLE        \ Forbid R| together with floating point.
0010,0112 0 C7 T!R
 01 00 8 FAMILY|R ST0| ST1| ST2| ST3| ST4| ST5| ST6| ST7|
