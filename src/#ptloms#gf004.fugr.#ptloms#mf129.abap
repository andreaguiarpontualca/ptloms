FUNCTION /PTLOMS/MF129.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_ANEXO) TYPE  /PTLOMS/CT145
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/CT146
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_lista_anexo_ordem(
    EXPORTING
      it_lista     = i_anexo
    IMPORTING
      et_lista     = e_detalhe
       ).

ENDFUNCTION.
