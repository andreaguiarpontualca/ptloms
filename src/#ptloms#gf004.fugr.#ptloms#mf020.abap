FUNCTION /ptloms/mf020.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_OBJNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_PONTO_MEDICAO) TYPE  /PTLOMS/CT003
*"  EXCEPTIONS
*"      ENVIRONMENT_NOT_AVAILABLE
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  it_ponto_medicao = o_oms->out_ponto_medicao( rt_objnr       = rt_objnr
                                               rt_usuario_app = rt_usuario_app ).

ENDFUNCTION.
