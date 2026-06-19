PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/v008 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/v008-qmart .
      FIELD /ptloms/v008-qmtyp .
      FIELD /ptloms/v008-rbnr .
      FIELD /ptloms/v008-qmartx .
      MODULE set_update_flag ON CHAIN-REQUEST.
      MODULE complete_/ptloms/v008 ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/v008-qmart .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.

*PROCESS ON VALUE-REQUEST.
*  FIELD: /ptloms/v008-qmart MODULE f_help_cod_qmart.
