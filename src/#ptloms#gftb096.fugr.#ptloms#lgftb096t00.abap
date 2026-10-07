*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB096...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB096                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB096                 .
CONTROLS: TCTRL_/PTLOMS/TB096
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB096                 .
TABLES: /PTLOMS/TB096                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
