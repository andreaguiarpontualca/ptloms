PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_tipo_material-mtart,
           wa_tipo_material-mtbez.
    MODULE valida_tipo_material.
  ENDCHAIN.

  MODULE user_command_0191.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_tipo_material-mtart MODULE f_help_cod_adm_mtart.
