*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB070...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB070                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB070                 .
CONTROLS: TCTRL_/PTLOMS/TB070
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB070                 .
TABLES: /PTLOMS/TB070                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
