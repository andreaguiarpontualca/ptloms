*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB089...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB089                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB089                 .
CONTROLS: TCTRL_/PTLOMS/TB089
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB089                 .
TABLES: /PTLOMS/TB089                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
