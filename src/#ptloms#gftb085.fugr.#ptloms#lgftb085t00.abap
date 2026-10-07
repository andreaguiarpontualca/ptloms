*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB085...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB085                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB085                 .
CONTROLS: TCTRL_/PTLOMS/TB085
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB085                 .
TABLES: /PTLOMS/TB085                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
