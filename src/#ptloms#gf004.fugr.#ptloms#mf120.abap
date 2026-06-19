FUNCTION /PTLOMS/MF120.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_CODIGO) TYPE  /PTLOMS/ET117-CODIGO
*"  EXPORTING
*"     VALUE(E_MOTIVO) TYPE  /PTLOMS/CT086
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_motivo(
    EXPORTING
      i_codigo   = i_codigo
    IMPORTING
      e_motivo   = e_motivo
       ).

ENDFUNCTION.
