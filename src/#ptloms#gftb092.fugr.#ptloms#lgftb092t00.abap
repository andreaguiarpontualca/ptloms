*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB092...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB092                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB092                 .
CONTROLS: TCTRL_/PTLOMS/TB092
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB092                 .
TABLES: /PTLOMS/TB092                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
