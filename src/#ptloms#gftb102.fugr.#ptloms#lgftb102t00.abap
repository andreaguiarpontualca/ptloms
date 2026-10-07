*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB102...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB102                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB102                 .
CONTROLS: TCTRL_/PTLOMS/TB102
            TYPE TABLEVIEW USING SCREEN '9102'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB102                 .
TABLES: /PTLOMS/TB102                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
