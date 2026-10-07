*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB087...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB087                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB087                 .
CONTROLS: TCTRL_/PTLOMS/TB087
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB087                 .
TABLES: /PTLOMS/TB087                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
