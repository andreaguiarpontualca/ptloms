FUNCTION /ptloms/mf114.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_WERKS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_VORNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(RT_AUART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_QMNUM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_PRIOK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_TPLNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_EQUNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_KOSTLEQUNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_KOSTLFUNCL) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_IWERK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_INGPR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ILART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GEWRK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUAPP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GSTRP_INI) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATOPE_INI) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GSTRP_FIM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATOPE_FIM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_VLSCH) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_DESPACHO) TYPE  /PTLOMS/CT119
*"     VALUE(IT_FILTRO) TYPE  /PTLOMS/CT103
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  o_oms->busca_lista_operacoes(
    EXPORTING
      rt_werks      = rt_werks
      rt_aufnr      = rt_aufnr
      rt_vornr      = rt_vornr
      rt_auart      = rt_auart
      rt_qmnum      = rt_qmnum
      rt_priok      = rt_priok
      rt_tplnr      = rt_tplnr
      rt_equnr      = rt_equnr
      rt_iwerk      = rt_iwerk
      rt_ingpr      = rt_ingpr
      rt_ilart      = rt_ilart
      rt_gewrk      = rt_gewrk
      rt_usuapp     = rt_usuapp
      rt_gstrp_ini  = rt_gstrp_ini
      rt_gstrp_fim  = rt_gstrp_fim
      rt_datope_ini = rt_datope_ini
      rt_datope_fim = rt_datope_fim
      rt_vlsch      = rt_vlsch
      rt_kostlequnr = rt_kostlequnr
      rt_kostlfuncl = rt_kostlfuncl
    IMPORTING
      it_despacho = it_despacho
      it_filtro   = it_filtro
      ).

ENDFUNCTION.
