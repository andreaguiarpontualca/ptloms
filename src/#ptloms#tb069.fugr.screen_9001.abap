PROCESS BEFORE OUTPUT.
  MODULE liste_initialisieren.
  LOOP AT extract WITH CONTROL
   tctrl_/ptloms/tb069 CURSOR nextline.
    MODULE liste_show_liste.
  ENDLOOP.

PROCESS AFTER INPUT.
  MODULE liste_exit_command AT EXIT-COMMAND.
  MODULE liste_before_loop.
  LOOP AT extract.
    MODULE liste_init_workarea.
    CHAIN.
      FIELD /ptloms/tb069-id .
      FIELD /ptloms/tb069-descricao .
      FIELD /ptloms/tb069-ernam .
      FIELD /ptloms/tb069-erdat .
      FIELD /ptloms/tb069-erzeit .
      FIELD /ptloms/tb069-aenam .
      FIELD /ptloms/tb069-aedat .
      FIELD /ptloms/tb069-aezeit .
      MODULE set_update_flag ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD vim_marked MODULE liste_mark_checkbox.
    CHAIN.
      FIELD /ptloms/tb069-id .
      MODULE liste_update_liste.
    ENDCHAIN.
  ENDLOOP.
  MODULE liste_after_loop.
