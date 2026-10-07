*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB093...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB093                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB093                 .
CONTROLS: TCTRL_/PTLOMS/TB093
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB093                 .
TABLES: /PTLOMS/TB093                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
