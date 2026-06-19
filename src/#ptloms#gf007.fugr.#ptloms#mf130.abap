FUNCTION /ptloms/mf130.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_DETALHE) TYPE  /PTLOMS/CT144
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT142
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->recusar_operacao
    EXPORTING
      i_detalhe = i_detalhe
    IMPORTING
      e_detalhe = e_detalhe.

ENDFUNCTION.
