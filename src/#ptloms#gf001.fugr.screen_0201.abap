PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_tipo_atv_ordem-ilart,
           wa_tipo_atv_ordem-ilatx.
    MODULE valida_tipo_atv_ordem.
  ENDCHAIN.

  MODULE user_command_0201.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_tipo_atv_ordem-ilart MODULE f_help_cod_adm_ilart.
