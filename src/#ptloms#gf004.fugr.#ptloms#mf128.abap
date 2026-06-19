FUNCTION /PTLOMS/MF128.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_ANEXO) TYPE  /PTLOMS/CT140
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT141
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_lista_anexo_instalacao(
    EXPORTING
      it_lista     = i_anexo
    IMPORTING
      et_lista     = e_detalhe
       ).

ENDFUNCTION.
