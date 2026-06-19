FUNCTION /ptloms/mf029.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_EQUNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_TPLNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_MATNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_WERKS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_LISTA_TECNICA_EQUI) TYPE  /PTLOMS/CT031
*"     VALUE(IT_LISTA_TECNICA_LOC_INST) TYPE  /PTLOMS/CT032
*"     VALUE(IT_LISTA_TECNICA_MAT) TYPE  /PTLOMS/CT033
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_lista_tecnica(
    EXPORTING
      rt_equnr                  = rt_equnr
      rt_tplnr                  = rt_tplnr
      rt_matnr                  = rt_matnr
      rt_werks                  = rt_werks
    IMPORTING
      et_lista_tecnica_equi     = it_lista_tecnica_equi
      et_lista_tecnica_loc_inst = it_lista_tecnica_loc_inst
      et_lista_tecnica_mat      = it_lista_tecnica_mat ).

ENDFUNCTION.
