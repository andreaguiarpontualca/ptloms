FUNCTION /PTLOMS/MF034.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_DADOS_USUARIO_APP) TYPE  /PTLOMS/CT101
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_usuario(
    EXPORTING
      rt_usuario_app       = rt_usuario_app
    IMPORTING
      et_dados_usuario_app = it_dados_usuario_app ).

ENDFUNCTION.
