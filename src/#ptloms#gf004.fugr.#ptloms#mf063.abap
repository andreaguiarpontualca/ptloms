FUNCTION /ptloms/mf063.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_USUARIO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_VAR_ID) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(RT_VAR_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"  EXPORTING
*"     VALUE(IT_VARIANT) TYPE  /PTLOMS/CT081
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_variant(
    EXPORTING
      rt_var_usuario = rt_usuario
      rt_var_id      = rt_var_id
      rt_var_app     = rt_var_app
    IMPORTING
      it_variant = it_variant ).

ENDFUNCTION.
