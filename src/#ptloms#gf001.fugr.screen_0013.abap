PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/tb013 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/tb013-usuario .
      FIELD /ptloms/tb013-perfil .
      FIELD /ptloms/tb013-nome .
      FIELD /ptloms/tb013-matricula .
      FIELD /ptloms/tb013-objid .
      FIELD /ptloms/tb013-sincroniza .
      FIELD /ptloms/tb013-encerra .
      FIELD /ptloms/tb013-limite_conf .
      FIELD /ptloms/tb013-senha .
      FIELD /ptloms/tb013-conf_senha .
      FIELD /ptloms/tb013-associa .
      FIELD /ptloms/tb013-bloqueado .
      FIELD /ptloms/tb013-atualizar_senha .
      FIELD /ptloms/tb013-material_saldo .
      FIELD /ptloms/tb013-dia_inicio .
      FIELD /ptloms/tb013-dias_retroativos .
      FIELD /ptloms/tb013-dias_progressivos .
      FIELD /ptloms/tb013-eliminado .
      FIELD /ptloms/tb013-unidade_tempo .
      MODULE set_update_flag ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/tb013-usuario .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.
