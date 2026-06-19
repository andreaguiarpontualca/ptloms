PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_caract_equipamento-atnam,
           wa_caract_equipamento-atbez.
    MODULE valida_caract_equipamento.
  ENDCHAIN.

  MODULE user_command_0252.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_caract_equipamento-atnam MODULE f_help_cod_adm_caract.
