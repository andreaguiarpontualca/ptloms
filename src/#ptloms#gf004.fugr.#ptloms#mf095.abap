FUNCTION /PTLOMS/MF095.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(IM_TOP) TYPE  INT4 OPTIONAL
*"     VALUE(IM_SKIP) TYPE  INT4 OPTIONAL
*"  EXPORTING
*"     VALUE(IT_LOCAL_INST) TYPE  /PTLOMS/CT018
*"     VALUE(EX_QUANTIDADE_LOCAL_INST) TYPE  INT4
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_local_instalacao_novo( EXPORTING rt_usuario_app         = rt_usuario_app
                                         im_top                      = im_top
                                         im_skip                     = im_skip
                               IMPORTING et_local_instalacao         = it_local_inst
                                         ex_quantidade_local_inst    = ex_quantidade_local_inst ).

ENDFUNCTION.
