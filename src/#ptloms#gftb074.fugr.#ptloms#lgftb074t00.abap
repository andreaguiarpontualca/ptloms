*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB074...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB074                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB074                 .
CONTROLS: TCTRL_/PTLOMS/TB074
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB074                 .
TABLES: /PTLOMS/TB074                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
