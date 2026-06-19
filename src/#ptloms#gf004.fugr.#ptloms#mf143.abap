FUNCTION /ptloms/mf143.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_RASTREAMENTO_USUARIO_IN)  TYPE  /PTLOMS/CT163
*"  EXPORTING
*"     VALUE(E_RASTREAMENTO_USUARIO_OUT) TYPE  /PTLOMS/CT163
*"     VALUE(E_RETORNO_OUT)              TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_anexar_rastreamento_usuario(
    EXPORTING
      it_rastreamento_usuario = i_rastreamento_usuario_in
    IMPORTING
      et_rastreamento_usuario = e_rastreamento_usuario_out
      et_retorno     = e_retorno_out
  ).

ENDFUNCTION.
