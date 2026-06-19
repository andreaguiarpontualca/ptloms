*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB073...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB073                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB073                 .
CONTROLS: TCTRL_/PTLOMS/TB073
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB073                 .
TABLES: /PTLOMS/TB073                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
