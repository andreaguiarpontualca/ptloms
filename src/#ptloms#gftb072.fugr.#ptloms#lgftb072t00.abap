*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /PTLOMS/TB072...................................*
DATA:  BEGIN OF STATUS_/PTLOMS/TB072                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/PTLOMS/TB072                 .
CONTROLS: TCTRL_/PTLOMS/TB072
            TYPE TABLEVIEW USING SCREEN '9001'.
*.........table declarations:.................................*
TABLES: */PTLOMS/TB072                 .
TABLES: /PTLOMS/TB072                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
