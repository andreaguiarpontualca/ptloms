FUNCTION /ptloms/mf038.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(IT_CONFIGURACAO_SISTEMA) TYPE  /PTLOMS/CT074
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_configuracao_sistema(
    IMPORTING
      et_configuracao_sistema = it_configuracao_sistema ).

ENDFUNCTION.
