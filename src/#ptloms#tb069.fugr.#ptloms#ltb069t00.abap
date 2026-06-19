*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB069...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB069                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB069                 .
CONTROLS: TCTRL_/PTLOMS/TB069
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB069                 .
TABLES: /PTLOMS/TB069                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
