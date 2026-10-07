FUNCTION /ptloms/mf156.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_DATA) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(IT_ORDEM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(IT_USUARIO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETORNO) TYPE  /PTLOMS/CT173
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl014.

  CREATE OBJECT o_oms.

  et_retorno = o_oms->obter_consulta_analitica( rt_data = it_data rt_ordem = it_ordem rt_usuario = it_usuario ).

ENDFUNCTION.
