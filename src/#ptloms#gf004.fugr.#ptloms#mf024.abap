FUNCTION /ptloms/mf024.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_BUKRS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_IWERK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_INGRP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_BEBER) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_LGWID) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_EQART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_FLTYP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(IM_TOP) TYPE  INT4 OPTIONAL
*"     VALUE(IM_SKIP) TYPE  INT4 OPTIONAL
*"  EXPORTING
*"     VALUE(IT_LOCAL_INST) TYPE  /PTLOMS/CT018
*"     VALUE(IT_IMAGENS_LOCAL_INST) TYPE  /PTLOMS/CT072
*"     VALUE(EX_QUANTIDADE_LOCAL_INST) TYPE  INT4
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_local_instalacao( EXPORTING rt_bukrs                    = rt_bukrs
                                         rt_iwerk                    = rt_iwerk
                                         rt_ingrp                    = rt_ingrp
                                         rt_beber                    = rt_beber
                                         rt_lgwid                    = rt_lgwid
                                         rt_eqart                    = rt_eqart
                                         rt_fltyp                    = rt_fltyp
                                         rt_usuario_app              = rt_usuario_app
                                         im_top                      = im_top
                                         im_skip                     = im_skip
                               IMPORTING et_local_instalacao         = it_local_inst
                                         et_imagens_local_instalacao = it_imagens_local_inst
                                         ex_quantidade_local_inst    = ex_quantidade_local_inst ).

ENDFUNCTION.
