FUNCTION /PTLOMS/MF123.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_CLIENTE) TYPE  /PTLOMS/CT130
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT129
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_detalhe_cliente(
    EXPORTING
      i_cliente   = i_cliente
    IMPORTING
      e_detalhe   = e_detalhe
       ).

ENDFUNCTION.
