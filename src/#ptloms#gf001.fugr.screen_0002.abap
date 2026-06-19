PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/v001 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/v001-bukrs .
      FIELD /ptloms/v001-butxt .
      FIELD /ptloms/v001-werks .
      FIELD /ptloms/v001-name1 .
      MODULE set_update_flag ON CHAIN-REQUEST.
      MODULE complete_/ptloms/v001 ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/v001-bukrs .
      FIELD /ptloms/v001-werks .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.

PROCESS ON VALUE-REQUEST.
  FIELD: /ptloms/v001-bukrs MODULE f_help_v001, "f_help_cod_bukrs,
         /ptloms/v001-werks MODULE f_help_v001. "f_help_cod_werks.
