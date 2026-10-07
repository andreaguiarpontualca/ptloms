*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB090...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB090                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB090                 .
CONTROLS: TCTRL_/PTLOMS/TB090
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB090                 .
TABLES: /PTLOMS/TB090                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
