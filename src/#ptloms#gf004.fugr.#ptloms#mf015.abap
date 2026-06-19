FUNCTION /ptloms/mf015.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WA_COMPONENTE) TYPE  /PTLOMS/ET039
*"  EXPORTING
*"     VALUE(IT_RETORNO_COMPONENTE) TYPE  /PTLOMS/CT063
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_componente_ordem(
    EXPORTING
      im_componente = wa_componente
    IMPORTING
      et_return     = it_retorno_componente ).

ENDFUNCTION.
