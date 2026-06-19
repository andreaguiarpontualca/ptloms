FUNCTION /ptloms/mf116.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_VORNR) TYPE  VORNR
*"  EXPORTING
*"     VALUE(E_DETALHE) TYPE  /PTLOMS/ET147
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_detalhe_ordem(
    EXPORTING
      i_aufnr     = i_aufnr
      i_vornr     = i_vornr
    IMPORTING
      e_detalhe   = e_detalhe
       ).

ENDFUNCTION.
