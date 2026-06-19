FUNCTION /ptloms/mf032.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_MATNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_WERKS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_LGORT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"  EXPORTING
*"     VALUE(IT_SALDO) TYPE  /PTLOMS/CT064
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_estoque_material(
    EXPORTING
      rt_matnr       = rt_matnr
      rt_werks       = rt_werks
      rt_lgort       = rt_lgort
      rt_usuario_app = rt_usuario_app
    IMPORTING
      et_saldo = it_saldo ).

ENDFUNCTION.
