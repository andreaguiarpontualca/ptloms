  PROCESS BEFORE OUTPUT.

    MODULE status_0012.
    MODULE disable_icons.
    MODULE bloqueia_perfil.

    MODULE liste_initialisieren.
    LOOP AT extract WITH CONTROL
     tctrl_/ptloms/tb012 CURSOR nextline.
      MODULE liste_show_liste.
    ENDLOOP.

    MODULE define_guia.

    CALL SUBSCREEN tabstrip_sca
        INCLUDING g_tabstrip-prog g_tabstrip-subscreen.
*
  PROCESS AFTER INPUT.
    MODULE liste_exit_command AT EXIT-COMMAND.
    MODULE liste_before_loop.

    LOOP AT extract.
      MODULE liste_init_workarea.
      CHAIN.
        FIELD /ptloms/tb012-perfil .
        FIELD /ptloms/tb012-descricao .
        FIELD /ptloms/tb012-inativo .
        MODULE set_update_flag ON CHAIN-REQUEST.
      ENDCHAIN.
      FIELD vim_marked MODULE liste_mark_checkbox.
      CHAIN.
        FIELD /ptloms/tb012-perfil .
        MODULE liste_update_liste.
      ENDCHAIN.
    ENDLOOP.
    MODULE liste_after_loop.

    MODULE sair AT EXIT-COMMAND.
    MODULE user_command_0012.

    CHAIN.
      FIELD: gv_perfil,
             gv_desc_perfil
      MODULE valida_perfil.
    ENDCHAIN.

    CALL SUBSCREEN tabstrip_sca.

* Determinação da aba clicada
    MODULE tabstrip_active_tab_get.

  PROCESS ON VALUE-REQUEST.
    FIELD: gv_perfil MODULE f_help_perfil.
