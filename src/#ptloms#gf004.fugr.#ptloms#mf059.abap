FUNCTION /ptloms/mf059.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_DATE_FROM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATE_TO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_TIME_FROM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_TIME_TO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USER_ID) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_BUKRS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(RT_WERKS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(RT_INGRP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"  EXPORTING
*"     VALUE(ET_LOG) TYPE  /PTLOMS/CT077
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_log(
    EXPORTING
      rt_date_from = rt_date_from
      rt_date_to   = rt_date_to
      rt_time_from = rt_time_from
      rt_time_to   = rt_time_to
      rt_user_id   = rt_user_id
      rt_bukrs     = rt_bukrs
      rt_werks     = rt_werks
      rt_ingrp     = rt_ingrp
    IMPORTING
      et_log       = et_log ).

ENDFUNCTION.
