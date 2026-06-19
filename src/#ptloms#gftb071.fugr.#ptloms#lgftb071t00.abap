*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB071...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB071                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB071                 .
CONTROLS: TCTRL_/PTLOMS/TB071
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB071                 .
TABLES: /PTLOMS/TB071                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
