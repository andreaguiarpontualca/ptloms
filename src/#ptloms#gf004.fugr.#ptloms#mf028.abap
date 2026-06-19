FUNCTION /ptloms/mf028.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_MTART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_WERKS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_LGORT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(IM_TOP) TYPE  INT4 OPTIONAL
*"     VALUE(IM_SKIP) TYPE  INT4 OPTIONAL
*"  EXPORTING
*"     VALUE(RT_MATERIAIS) TYPE  /PTLOMS/CT030
*"     VALUE(EX_QUANTIDADE_MATERIAL) TYPE  INT4
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_material( EXPORTING rt_mtart               = rt_mtart
                                 rt_werks               = rt_werks
                                 rt_lgort               = rt_lgort
                                 rt_usuario_app         = rt_usuario_app
                                 im_top                 = im_top
                                 im_skip                = im_skip
                       IMPORTING rt_materiais           = rt_materiais
                                 ex_quantidade_material = ex_quantidade_material ).

ENDFUNCTION.
