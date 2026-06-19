PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_causa_desvio-werks,
           wa_causa_desvio-name1,
           wa_causa_desvio-grund,
           wa_causa_desvio-grdtx.
    MODULE valida_causa_desvio.
  ENDCHAIN.

  MODULE user_command_0231.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_causa_desvio-grund MODULE f_help_cod_adm_grund,
         wa_causa_desvio-werks MODULE f_help_cod_adm_grund.
