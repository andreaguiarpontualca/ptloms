FUNCTION /ptloms/mf124.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_DETALHE) TYPE  /PTLOMS/CT127
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT132
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->busca_detalhes_ordem
    EXPORTING
      i_detalhe = i_detalhe
    IMPORTING
      e_detalhe = e_detalhe.

ENDFUNCTION.
