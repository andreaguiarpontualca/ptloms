*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB086...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB086                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB086                 .
CONTROLS: TCTRL_/PTLOMS/TB086
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB086                 .
TABLES: /PTLOMS/TB086                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
