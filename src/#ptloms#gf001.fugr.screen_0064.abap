PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/v018 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/v018-objid .
      FIELD /ptloms/v018-arbpl .
      FIELD /ptloms/v018-werks .
      FIELD /ptloms/v018-name1 .
      FIELD /ptloms/v018-learr .
      MODULE set_update_flag ON CHAIN-REQUEST.
      MODULE complete_/ptloms/v018 ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/v018-objid .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.

PROCESS ON VALUE-REQUEST.

  FIELD: /ptloms/v018-objid MODULE f_help_v018, "f_help_cod_objid,
         /ptloms/v018-werks MODULE f_help_v018, "f_help_cod_werks_3.
         /ptloms/v018-learr MODULE f_help_v018_2.
