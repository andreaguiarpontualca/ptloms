*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB103...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB103                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB103                 .
CONTROLS: TCTRL_/PTLOMS/TB103
            TYPE TABLEVIEW USING SCREEN '9103'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB103                 .
TABLES: /PTLOMS/TB103                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
