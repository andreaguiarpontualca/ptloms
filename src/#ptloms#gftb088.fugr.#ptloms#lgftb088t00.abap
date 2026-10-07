*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB088...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB088                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB088                 .
CONTROLS: TCTRL_/PTLOMS/TB088
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB088                 .
TABLES: /PTLOMS/TB088                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
