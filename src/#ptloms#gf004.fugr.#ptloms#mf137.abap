FUNCTION /ptloms/mf137.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_ASSINATURA_IN) TYPE  /PTLOMS/CT157
*"  EXPORTING
*"     VALUE(E_ASSINATURA_OUT) TYPE  /PTLOMS/CT157
*"     VALUE(E_RETORNO_OUT) TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_anexar_assinatura(
    EXPORTING
      it_assinaturas = i_assinatura_in
    IMPORTING
      et_assinaturas = e_assinatura_out
      et_retorno     = e_retorno_out
  ).

ENDFUNCTION.
