PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_cat_loc_inst-fltyp,
           wa_cat_loc_inst-typtx.
    MODULE valida_cat_loc_inst.
  ENDCHAIN.

  MODULE user_command_0141.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_cat_loc_inst-fltyp MODULE f_help_cod_adm_fltyp.
