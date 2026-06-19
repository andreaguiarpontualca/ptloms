FUNCTION /ptloms/mf075.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_VARIANT) TYPE  /PTLOMS/ET122
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_variant_update(
    EXPORTING
      iv_variant = iv_variant ).

ENDFUNCTION.
