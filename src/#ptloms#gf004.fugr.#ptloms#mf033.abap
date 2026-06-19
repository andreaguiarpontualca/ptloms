FUNCTION /ptloms/mf033.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATA) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_HORAS_PLAN_REL) TYPE  /PTLOMS/CT070
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_horas_plan_real(
    EXPORTING
      rt_usuario_app    = rt_usuario_app
      rt_data           = rt_data
    IMPORTING
      et_horas_plan_rel = it_horas_plan_rel ).

ENDFUNCTION.
