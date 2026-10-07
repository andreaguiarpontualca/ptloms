*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB091...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB091                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB091                 .
CONTROLS: TCTRL_/PTLOMS/TB091
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB091                 .
TABLES: /PTLOMS/TB091                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
