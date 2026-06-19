PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/v015 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/v015-auart .
      FIELD /ptloms/v015-artpr .
      FIELD /ptloms/v015-priok .
      FIELD /ptloms/v015-priokx .
      FIELD /ptloms/v015-urgente .
      FIELD /ptloms/v015-verde .
      FIELD /ptloms/v015-amarelo .
      FIELD /ptloms/v015-vermelho .
      MODULE set_update_flag ON CHAIN-REQUEST.
      MODULE complete_/ptloms/v015 ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/v015-auart .
      FIELD /ptloms/v015-artpr .
      FIELD /ptloms/v015-priok .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.

PROCESS ON VALUE-REQUEST.

  FIELD: /ptloms/v015-auart MODULE f_help_tipo_ordem_prioridade.
  FIELD: /ptloms/v015-priok MODULE f_help_prioridade.
