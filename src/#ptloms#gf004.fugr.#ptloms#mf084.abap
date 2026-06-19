FUNCTION /ptloms/mf084.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(IT_RETORNO_CATALOGO) TYPE  /PTLOMS/CT063
*"  CHANGING
*"     VALUE(WA_ORDEM_CATALOGO) TYPE  /PTLOMS/ET128
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

*  o_oms->in_ordem_catalogo(
*    IMPORTING
*      et_return     = it_retorno_catalogo
*     CHANGING
*      im_ordem_catalogo = wa_ordem_catalogo
*       ).

  CALL METHOD o_oms->in_ordem_catalogo
    EXPORTING
      im_ordem_catalogo = wa_ordem_catalogo
    IMPORTING
      ex_ordem_catalogo = wa_ordem_catalogo
      et_return         = it_retorno_catalogo.


ENDFUNCTION.
