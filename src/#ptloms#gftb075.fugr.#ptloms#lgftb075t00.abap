*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB075...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB075                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB075                 .
CONTROLS: TCTRL_/PTLOMS/TB075
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB075                 .
TABLES: /PTLOMS/TB075                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
