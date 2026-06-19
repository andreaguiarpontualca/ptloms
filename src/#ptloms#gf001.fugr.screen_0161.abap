PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_tipo_objeto-eqart,
           wa_tipo_objeto-eartx.
    MODULE valida_tipo_objeto.
  ENDCHAIN.

  MODULE user_command_0161.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_tipo_objeto-eqart MODULE f_help_cod_adm_eqart.
