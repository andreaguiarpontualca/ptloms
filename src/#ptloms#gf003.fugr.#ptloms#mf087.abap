FUNCTION /ptloms/mf087.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_AUFNR) TYPE  /PTLOMS/ET129
*"  EXPORTING
*"     VALUE(IT_RETORNO) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  /ptloms/cl008=>validar_transferencia( EXPORTING im_ordem = im_aufnr RECEIVING re_retorno = it_retorno ).

  CALL METHOD /ptloms/cl008=>validar_transferencia
    EXPORTING
      im_ordem   = im_aufnr
    IMPORTING
      re_retorno = it_retorno.

ENDFUNCTION.
