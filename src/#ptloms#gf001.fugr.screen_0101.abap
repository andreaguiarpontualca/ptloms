PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  chain.
    field: wa_empresa_centro-bukrs,
           wa_empresa_centro-butxt,
           wa_empresa_centro-werks,
           wa_empresa_centro-name1.
    MODULE valida_empresa_centro.
  endchain.

  MODULE user_command_0101.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_empresa_centro-bukrs MODULE f_help_cod_adm_centro,
                                       "f_help_cod_adm_empresa,
         wa_empresa_centro-werks MODULE f_help_cod_adm_centro.
