*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB079...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB079                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB079                 .
CONTROLS: TCTRL_/PTLOMS/TB079
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB079                 .
TABLES: /PTLOMS/TB079                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
