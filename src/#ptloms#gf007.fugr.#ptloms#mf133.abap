FUNCTION /ptloms/mf133.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(HIST_CONFIR_IN) TYPE  /PTLOMS/CT154
*"  EXPORTING
*"     VALUE(HIST_CONFIR_OUT) TYPE  /PTLOMS/CT154
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->busca_historico_confirmacao
    EXPORTING
      histor_confirm_in  = hist_confir_in
    IMPORTING
      histor_confirm_out = hist_confir_out.

ENDFUNCTION.
