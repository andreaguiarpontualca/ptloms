*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB101...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB101                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB101                 .
CONTROLS: TCTRL_/PTLOMS/TB101
            TYPE TABLEVIEW USING SCREEN '9101'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB101                 .
TABLES: /PTLOMS/TB101                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
