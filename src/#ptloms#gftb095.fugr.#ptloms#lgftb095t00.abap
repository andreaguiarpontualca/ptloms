*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB095...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB095                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB095                 .
CONTROLS: TCTRL_/PTLOMS/TB095
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB095                 .
TABLES: /PTLOMS/TB095                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
