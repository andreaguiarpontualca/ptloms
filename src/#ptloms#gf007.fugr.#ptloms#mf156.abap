FUNCTION /ptloms/mf156.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_DATA) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(ET_RETORNO) TYPE  /PTLOMS/CT173
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl014.

  CREATE OBJECT o_oms.

  et_retorno = o_oms->obter_consulta_analitica( it_data ).

ENDFUNCTION.
