FUNCTION /ptloms/mf090.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_BUKRS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_IWERK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_INGRP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_BEBER) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GEWRK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_EQART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_EQTYP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(IM_TOP) TYPE  INT4 OPTIONAL
*"     VALUE(IM_SKIP) TYPE  INT4 OPTIONAL
*"  EXPORTING
*"     VALUE(IT_IMAGEMS_EQUIPAMENTO) TYPE  /PTLOMS/CT072
*"     VALUE(IT_EQUIPAMENTO) TYPE  /PTLOMS/CT019
*"     VALUE(IT_FILTRO_EQUNR) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_EQKTX) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_INVNR) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_TIDNR) TYPE  /PTLOMS/CT056
*"     VALUE(EX_QUANTIDADE_EQUIPAMENTO) TYPE  INT4
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl012.

  CREATE OBJECT o_oms.

  o_oms->out_equipamento( EXPORTING rt_bukrs                  = rt_bukrs
                                    rt_iwerk                  = rt_iwerk
                                    rt_ingrp                  = rt_ingrp
                                    rt_beber                  = rt_beber
                                    rt_gewrk                  = rt_gewrk
                                    rt_eqart                  = rt_eqart
                                    rt_eqtyp                  = rt_eqtyp
                                    rt_usuario_app            = rt_usuario_app
                                    im_top                    = im_top
                                    im_skip                   = im_skip
                          IMPORTING et_equipamento            = it_equipamento
                                    et_imagems_equipamento    = it_imagems_equipamento
                                    et_filtro_equnr           = it_filtro_equnr
                                    et_filtro_eqktx           = it_filtro_eqktx
                                    et_filtro_invnr           = it_filtro_invnr
                                    et_filtro_tidnr           = it_filtro_tidnr
                                    ex_quantidade_equipamento = ex_quantidade_equipamento ).

ENDFUNCTION.
