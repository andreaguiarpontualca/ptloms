FUNCTION /ptloms/mf127.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_DETALHE) TYPE  /PTLOMS/CT138
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT139
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->desassociar_operacao
    EXPORTING
      i_detalhe = i_detalhe
    IMPORTING
      e_detalhe = e_detalhe.

ENDFUNCTION.
