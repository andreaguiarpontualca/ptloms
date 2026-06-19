PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_tipo_nota-qmart,
           wa_tipo_nota-qmtyp,
           wa_tipo_nota-rbnr,
           wa_tipo_nota-qmart.
    MODULE valida_tipo_nota.
  ENDCHAIN.

  MODULE user_command_0171.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_tipo_nota-qmart MODULE f_help_cod_adm_qmart.
