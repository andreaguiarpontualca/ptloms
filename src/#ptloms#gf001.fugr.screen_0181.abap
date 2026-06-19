PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_tipo_ordem-auart,
           wa_tipo_ordem-autyp,
           wa_tipo_ordem-txt.
    MODULE valida_tipo_ordem.
  ENDCHAIN.

  MODULE user_command_0181.

PROCESS ON VALUE-REQUEST.

  FIELD: wa_tipo_ordem-auart MODULE f_help_cod_adm_auart.

  FIELD: wa_tipo_ordem-filtro_catalogo MODULE f_help_filtro_catalogo.
