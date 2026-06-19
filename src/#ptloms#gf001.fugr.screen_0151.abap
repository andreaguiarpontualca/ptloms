PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_cat_equipamento-eqtyp,
           wa_cat_equipamento-typtx.
    MODULE valida_cat_equipamento.
  ENDCHAIN.

  MODULE user_command_0151.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_cat_equipamento-eqtyp MODULE f_help_cod_adm_eqtyp.
