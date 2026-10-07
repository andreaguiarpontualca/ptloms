*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB084...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB084                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB084                 .
CONTROLS: TCTRL_/PTLOMS/TB084
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB084                 .
TABLES: /PTLOMS/TB084                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
