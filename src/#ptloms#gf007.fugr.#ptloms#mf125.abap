FUNCTION /PTLOMS/MF125.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_DETALHE) TYPE  /PTLOMS/CT133
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT135
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->confirmar_operacoes
    EXPORTING
      i_detalhe = i_detalhe
    IMPORTING
      e_detalhe = e_detalhe.

ENDFUNCTION.
