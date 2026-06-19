FUNCTION /ptloms/mf097.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(IT_RETORNO_COMPONENTE) TYPE  /PTLOMS/CT063
*"  CHANGING
*"     VALUE(WA_COMPONENTE) TYPE  /PTLOMS/ET134
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  " Novo sincronimos reserva, substitui componente_ordem_dele
*  o_oms->in_reserva_delete(
*    IMPORTING
*      et_return     = it_retorno_componente
*    CHANGING
*      im_componente = wa_componente
*      ).

  CALL METHOD o_oms->in_reserva_delete
    EXPORTING
      im_componente = wa_componente
    IMPORTING
      ex_componente = wa_componente
      et_return     = it_retorno_componente.


ENDFUNCTION.
