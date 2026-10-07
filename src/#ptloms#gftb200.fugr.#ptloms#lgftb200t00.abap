*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB200...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB200                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB200                 .
CONTROLS: TCTRL_/PTLOMS/TB200
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB200                 .
TABLES: /PTLOMS/TB200                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
