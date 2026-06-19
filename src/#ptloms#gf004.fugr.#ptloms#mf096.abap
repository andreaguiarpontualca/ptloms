FUNCTION /ptloms/mf096.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(IT_RETORNO_COMPONENTE) TYPE  /PTLOMS/CT063
*"  CHANGING
*"     VALUE(WA_COMPONENTE) TYPE  /PTLOMS/ET134
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  " Novo sincronimos reserva, substitui IN_COMPONENTE_ORDEM
*  o_oms->in_reserva(
*    IMPORTING
*      et_return     = it_retorno_componente
*    CHANGING
*      im_componente = wa_componente
*      ).

  CALL METHOD o_oms->in_reserva
    EXPORTING
      im_componente = wa_componente
    IMPORTING
      ex_componente = wa_componente
      et_return     = it_retorno_componente.



ENDFUNCTION.
