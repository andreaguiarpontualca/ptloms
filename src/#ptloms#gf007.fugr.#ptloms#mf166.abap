FUNCTION /ptloms/mf166.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"     VALUE(IM_SENHA_ATUAL) TYPE  CHAR32
*"     VALUE(IM_NOVA_SENHA) TYPE  CHAR32
*"     VALUE(IM_CONF_SENHA) TYPE  CHAR32
*"  EXPORTING
*"     VALUE(EX_SENHA_ALTERADA) TYPE  CHAR1
*"     VALUE(EX_MENSAGEM) TYPE  BAPI_MSG
*"----------------------------------------------------------------------

  DATA: lo_sessao TYPE REF TO /ptloms/cl005.

  CREATE OBJECT lo_sessao.

  lo_sessao->atualiza_senha_v2(
    EXPORTING
      im_usuario        = im_usuario
      im_senha_atual    = im_senha_atual
      im_nova_senha     = im_nova_senha
      im_conf_senha     = im_conf_senha
    IMPORTING
      ex_senha_alterada = ex_senha_alterada
      ex_mensagem       = ex_mensagem ).

ENDFUNCTION.
