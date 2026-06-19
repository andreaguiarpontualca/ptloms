*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB078...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB078                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB078                 .
CONTROLS: TCTRL_/PTLOMS/TB078
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB078                 .
TABLES: /PTLOMS/TB078                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
