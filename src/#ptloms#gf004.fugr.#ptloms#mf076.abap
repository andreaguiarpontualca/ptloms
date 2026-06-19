FUNCTION /ptloms/mf076.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_VAR_KEY) TYPE  STRING
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_variant_delete(
    EXPORTING
      iv_var_key = iv_var_key ).

ENDFUNCTION.
