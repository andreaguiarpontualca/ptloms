PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/tb071 CURSOR nextline.
    MODULE liste_show_liste.
    MODULE z_busca_descricao.
  ENDLOOP.
*
PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/tb071-aplicacao .
      FIELD /ptloms/tb071-formulario .
      FIELD /ptloms/tb071-tp_vinculo .
      FIELD /ptloms/tb071-descr_vinculo .
      FIELD /ptloms/tb071-identificacao .
      FIELD /ptloms/tb071-ernam .
      FIELD /ptloms/tb071-erdat .
      FIELD /ptloms/tb071-erzeit .
      FIELD /ptloms/tb071-aenam .
      FIELD /ptloms/tb071-aedat .
      FIELD /ptloms/tb071-aezeit .
      MODULE set_update_flag ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/tb071-aplicacao .
      FIELD /ptloms/tb071-formulario .
      FIELD /ptloms/tb071-tp_vinculo .
      FIELD /ptloms/tb071-descr_vinculo .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.
