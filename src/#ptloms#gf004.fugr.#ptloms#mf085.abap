FUNCTION /ptloms/mf085.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO_APP) TYPE  CHAR12
*"  CHANGING
*"     VALUE(IT_RETORNO_CATALOGO) TYPE  /PTLOMS/CT063
*"     VALUE(IT_ORDEM_CATALOGO) TYPE  /PTLOMS/CT114
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.
  DATA: ls_tb033 TYPE /ptloms/tb033.

  CREATE OBJECT o_oms.

  SELECT SINGLE * FROM /ptloms/tb033 INTO ls_tb033.

  IF ls_tb033-cesto IS INITIAL.

    CALL METHOD o_oms->out_ordem_catalogo
      EXPORTING
        iv_usuario_app    = im_usuario_app
        im_ordem_catalogo = it_ordem_catalogo
      IMPORTING
        ex_ordem_catalogo = it_ordem_catalogo
        et_return         = it_retorno_catalogo.

  ELSE.

    CALL METHOD o_oms->out_ordem_catalogo_cesto
      EXPORTING
        iv_usuario_app    = im_usuario_app
        im_ordem_catalogo = it_ordem_catalogo
      IMPORTING
        ex_ordem_catalogo = it_ordem_catalogo
        et_return         = it_retorno_catalogo.

  ENDIF.

ENDFUNCTION.
