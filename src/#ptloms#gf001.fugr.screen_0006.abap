PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/v005 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/v005-fltyp .
      FIELD /ptloms/v005-typtx .
      MODULE set_update_flag ON CHAIN-REQUEST.
      MODULE complete_/ptloms/v005 ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/v005-fltyp .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.

*PROCESS ON VALUE-REQUEST.
*  FIELD: /ptloms/v005-fltyp MODULE f_help_cod_fltyp.
