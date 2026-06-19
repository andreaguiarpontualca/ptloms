FUNCTION /ptloms/mf063.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_VARIANT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_VARIANT) TYPE  /PTLOMS/CT081
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_variant(
    EXPORTING
      rt_var_usuario  = rt_variant
    IMPORTING
      it_variant = it_variant ).

ENDFUNCTION.
