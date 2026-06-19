FUNCTION /ptloms/mf086.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WA_CONFIRMACAO) TYPE  /PTLOMS/ET051
*"     VALUE(IM_USUARIO_APP) TYPE  CHAR12 OPTIONAL
*"  CHANGING
*"     VALUE(IT_RETORNO) TYPE  /PTLOMS/CT062
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_confirmacao_catalogo(
    EXPORTING
      im_usuario_app = im_usuario_app
      im_confirmacao = wa_confirmacao
    IMPORTING
      rt_return      = it_retorno ).

ENDFUNCTION.
