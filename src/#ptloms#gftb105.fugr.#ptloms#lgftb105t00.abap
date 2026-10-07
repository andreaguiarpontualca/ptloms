*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB105...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB105                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB105                 .
CONTROLS: TCTRL_/PTLOMS/TB105
            TYPE TABLEVIEW USING SCREEN '9105'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB105                 .
TABLES: /PTLOMS/TB105                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
