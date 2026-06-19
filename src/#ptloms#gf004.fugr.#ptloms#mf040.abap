FUNCTION /ptloms/mf040.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"  EXPORTING
*"     VALUE(EX_SESSAO_CRIADA) TYPE  CHAR1
*"----------------------------------------------------------------------

  DATA: o_sessao TYPE REF TO /ptloms/cl005.

  CREATE OBJECT o_sessao.

  o_sessao->cria_sessao( EXPORTING im_usuario       = im_usuario
                         IMPORTING ex_sessao_criada = ex_sessao_criada ).

ENDFUNCTION.
