FUNCTION /ptloms/mf042.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"  EXPORTING
*"     VALUE(EX_GUID) TYPE  CHAR32
*"----------------------------------------------------------------------

  DATA: o_sessao TYPE REF TO /ptloms/cl005.

  CREATE OBJECT o_sessao.

  o_sessao->busca_sessao( EXPORTING im_usuario = im_usuario
                          IMPORTING ex_guid    = ex_guid ).

ENDFUNCTION.
