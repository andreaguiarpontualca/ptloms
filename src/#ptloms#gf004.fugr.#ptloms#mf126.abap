FUNCTION /PTLOMS/MF126.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_ANEXO) TYPE  /PTLOMS/CT130
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT136
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_lista_anexo(
    EXPORTING
      it_lista     = i_anexo
    IMPORTING
      et_lista     = e_detalhe
       ).

ENDFUNCTION.
