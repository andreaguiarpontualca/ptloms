FUNCTION /PTLOMS/MF115.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_LISTA) TYPE  /PTLOMS/CT123
*"  EXPORTING
*"     VALUE(ET_LISTA) TYPE  /PTLOMS/CT123
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_Lista_Associar(
    EXPORTING
      it_lista    = it_lista
    IMPORTING
      et_lista    = et_lista
       ).

ENDFUNCTION.
