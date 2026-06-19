FUNCTION /PTLOMS/MF043.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"     VALUE(IM_SENHA) TYPE  CHAR32
*"     VALUE(IM_CONFSENHA) TYPE  CHAR32
*"  EXPORTING
*"     VALUE(EX_SENHA_ALTERADA) TYPE  CHAR1
*"----------------------------------------------------------------------

  DATA: o_sessao TYPE REF TO /ptloms/cl005.

  CREATE OBJECT o_sessao.

  o_sessao->atualiza_senha( EXPORTING im_usuario        = im_usuario
                                      im_senha          = im_senha
                                      im_confsenha      = im_confsenha
                            IMPORTING ex_senha_alterada = ex_senha_alterada ).

ENDFUNCTION.
