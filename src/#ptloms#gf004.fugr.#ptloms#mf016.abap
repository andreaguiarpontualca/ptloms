FUNCTION /ptloms/mf016.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"  EXPORTING
*"     VALUE(IT_RETORNO_FINALIZAR_SESSAO) TYPE  /PTLOMS/CT063
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_finalizar_sessao(
    EXPORTING
      im_usuario = im_usuario
    IMPORTING
      et_return   = it_retorno_finalizar_sessao ).

ENDFUNCTION.
