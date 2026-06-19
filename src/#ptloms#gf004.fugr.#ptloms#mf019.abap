FUNCTION /ptloms/mf019.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_RBNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_CATALOGOS) TYPE  /PTLOMS/CT002
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->out_catalogo
    EXPORTING
      rt_rbnr        = rt_rbnr
      rt_usuario_app = rt_usuario_app
    RECEIVING
      rt_catalogos   = it_catalogos.

ENDFUNCTION.
