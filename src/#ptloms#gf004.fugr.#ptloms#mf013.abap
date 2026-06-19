FUNCTION /ptloms/mf013.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WA_OPERACAO) TYPE  /PTLOMS/ET067
*"  EXPORTING
*"     VALUE(IT_RETORNO_OPERACAO) TYPE  /PTLOMS/CT063
*"     VALUE(E_OPERACAO) TYPE  /PTLOMS/ET067
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_operacao_ordem(
    EXPORTING
      im_operacao = wa_operacao
    IMPORTING
      et_return   = it_retorno_operacao
      wa_operacao = e_operacao ).

ENDFUNCTION.
