FUNCTION /ptloms/mf039.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"     VALUE(IM_SENHA) TYPE  CHAR32
*"  EXPORTING
*"     VALUE(EX_AUTENTICADO) TYPE  CHAR1
*"----------------------------------------------------------------------

  DATA: o_sessao TYPE REF TO /ptloms/cl005.

  CREATE OBJECT o_sessao.

  o_sessao->autentica( EXPORTING im_usuario     = im_usuario
                                 im_senha       = im_senha
                       IMPORTING ex_autenticado = ex_autenticado ).

ENDFUNCTION.
