FUNCTION /PTLOMS/MF065.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_TABELA) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_PADRAO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_LAYOUT) TYPE  /PTLOMS/CT083
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_layout(
    EXPORTING
      rt_tabela = rt_tabela
      rt_usario = rt_usuario
      rt_padrao = rt_padrao
    IMPORTING
      it_layout = it_layout ).

ENDFUNCTION.
