*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB104...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB104                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB104                 .
CONTROLS: TCTRL_/PTLOMS/TB104
            TYPE TABLEVIEW USING SCREEN '9104'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB104                 .
TABLES: /PTLOMS/TB104                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
