FUNCTION /PTLOMS/MF121.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_DETALHE) TYPE  /PTLOMS/CT127
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT126
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_detalhe_operacao(
    EXPORTING
      i_detalhe   = i_detalhe
    IMPORTING
      e_detalhe   = e_detalhe
       ).

ENDFUNCTION.
