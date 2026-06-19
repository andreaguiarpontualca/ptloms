*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB080...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB080                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB080                 .
CONTROLS: TCTRL_/PTLOMS/TB080
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB080                 .
TABLES: /PTLOMS/TB080                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
