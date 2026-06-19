FUNCTION /ptloms/mf064.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_VARIANT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_VARIANT_VALUES) TYPE  /PTLOMS/CT082
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_variant_values(
    EXPORTING
      rt_variant        = rt_variant
    IMPORTING
      it_variant_values = it_variant_values ).

ENDFUNCTION.
