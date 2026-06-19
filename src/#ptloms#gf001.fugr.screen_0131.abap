PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_centro_trabalho-objid,
           wa_centro_trabalho-arbpl,
           wa_centro_trabalho-werks,
           wa_centro_trabalho-name1.
    MODULE valida_centro_trabalho.
  ENDCHAIN.

  MODULE user_command_0131.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_centro_trabalho-objid MODULE f_help_cod_adm_objid,
         wa_centro_trabalho-werks MODULE f_help_cod_adm_objid.
                                         "f_help_cod_adm_centro_ct.
