PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/v004 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/v004-objid .
      FIELD /ptloms/v004-name1 .
      FIELD /ptloms/v004-learr .
      FIELD /ptloms/v004-werks .
      FIELD /ptloms/v004-arbpl .
      MODULE set_update_flag ON CHAIN-REQUEST.
      MODULE complete_/ptloms/v004 ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/v004-objid .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.

PROCESS ON VALUE-REQUEST.
  FIELD: /ptloms/v004-objid MODULE f_help_v004, "f_help_cod_objid,
         /ptloms/v004-werks MODULE f_help_v004, "f_help_cod_werks_3.
         /ptloms/v004-learr MODULE f_help_v004_2.
