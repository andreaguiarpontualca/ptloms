FUNCTION /PTLOMS/MF110.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_USUARIO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_LISTA) TYPE  /PTLOMS/CT121
*"----------------------------------------------------------------------
  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_lista_tarefa(
    EXPORTING
      rt_usuario  = rt_usuario
    IMPORTING
      et_lista = it_lista ).

ENDFUNCTION.
