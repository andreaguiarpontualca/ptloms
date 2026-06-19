PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  chain.
    field: wa_area_operacional-werks,
           wa_area_operacional-name1,
           wa_area_operacional-beber,
           wa_area_operacional-fing.
    MODULE valida_area_operacional.
  endchain.

  MODULE user_command_0121.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_area_operacional-werks MODULE f_help_cod_adm_cento_ao,
         wa_area_operacional-beber MODULE f_help_cod_adm_cento_ao.
                                          "f_help_cod_adm_beber.
