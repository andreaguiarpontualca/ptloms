FUNCTION /ptloms/mf010.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(IT_RETORNO_DOC_MED) TYPE  /PTLOMS/CT063
*"  CHANGING
*"     VALUE(WA_DOCUMENTO_MEDICAO) TYPE  /PTLOMS/ET050
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

*  it_retorno_doc_med = o_oms->in_documento_medicao( CHANGING im_ponto_medicao = wa_documento_medicao ).

  CALL METHOD o_oms->in_documento_medicao
    EXPORTING
      im_ponto_medicao = wa_documento_medicao
    IMPORTING
      ex_ponto_medicao = wa_documento_medicao
      rt_return        = it_retorno_doc_med.


ENDFUNCTION.
