FUNCTION /ptloms/mf066.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_ID_LAYOUT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_LAYOUT_VALUES) TYPE  /PTLOMS/CT084
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_layout_values(
    EXPORTING
      rt_id_layout    = rt_id_layout
    IMPORTING
      it_layout_values = it_layout_values ).

ENDFUNCTION.
