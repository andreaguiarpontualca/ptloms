FUNCTION /PTLOMS/MF131.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_LISTA) TYPE  /PTLOMS/CT147
*"  EXPORTING
*"     VALUE(ET_LISTA) TYPE  /PTLOMS/CT148
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_lista_detalhe_nota(
    EXPORTING
      it_lista     = it_lista
    IMPORTING
      et_lista     = et_lista
       ).

ENDFUNCTION.
