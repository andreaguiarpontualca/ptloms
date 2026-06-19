PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_grupo_mercadoria-matkl,
           wa_grupo_mercadoria-wgbez60.
    MODULE valida_grupo_mercadoria.
  ENDCHAIN.

  MODULE user_command_0211.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_grupo_mercadoria-matkl MODULE f_help_cod_adm_matkl.
