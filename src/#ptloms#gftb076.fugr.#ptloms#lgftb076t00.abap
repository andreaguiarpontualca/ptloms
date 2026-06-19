*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB076...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB076                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB076                 .
CONTROLS: TCTRL_/PTLOMS/TB076
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB076                 .
TABLES: /PTLOMS/TB076                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
