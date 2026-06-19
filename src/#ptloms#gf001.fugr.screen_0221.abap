PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_deposito-werks,
           wa_deposito-name1,
           wa_deposito-lgort,
           wa_deposito-lgobe.
    MODULE valida_deposito.
  ENDCHAIN.

  MODULE user_command_0221.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_deposito-lgort MODULE f_help_cod_adm_lgort,
         wa_deposito-werks MODULE f_help_cod_adm_lgort.
