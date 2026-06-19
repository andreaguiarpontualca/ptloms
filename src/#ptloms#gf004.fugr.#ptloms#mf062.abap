FUNCTION /ptloms/mf062.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_WERKS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_AUART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_QMNUM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_PRIOK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_TPLNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_EQUNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_IWERK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_INGPR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ILART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GEWRK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GSTRP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATOPE) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUAPP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_F_TREE) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_MAT_AT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_OPER) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ORDENS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GSTRP_INI) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATOPE_INI) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GSTRP_FIM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATOPE_FIM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_DESPACHO_TREE) TYPE  /PTLOMS/CT080
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_programacao_usuarios(
    EXPORTING
      rt_werks    = rt_werks
      rt_aufnr    = rt_aufnr
      rt_auart    = rt_auart
      rt_qmnum    = rt_qmnum
      rt_priok    = rt_priok
      rt_tplnr    = rt_tplnr
      rt_equnr    = rt_equnr
      rt_iwerk    = rt_iwerk
      rt_ingpr    = rt_ingpr
      rt_ilart    = rt_ilart
      rt_gewrk    = rt_gewrk
      rt_gstrp    = rt_gstrp
      rt_datope   = rt_datope
      rt_usuapp   = rt_usuapp
      rt_f_tree   = rt_f_tree
      rt_mat_at   = rt_mat_at
      rt_oper     = rt_oper
      rt_ordens   = rt_ordens
      rt_gstrp_ini    = rt_gstrp_ini
      rt_datope_ini   = rt_datope_ini
      rt_gstrp_fim    = rt_gstrp_fim
      rt_datope_fim   = rt_datope_fim
    IMPORTING
      it_despacho_tree = it_despacho_tree ).

ENDFUNCTION.
