FUNCTION /ptloms/mf118.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_UNAME) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_ASSOCIACOES) TYPE  /PTLOMS/CT125
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  o_oms->busca_lista_associacoes(
    EXPORTING
      rt_aufnr        = rt_aufnr
      rt_uname        = rt_uname
    IMPORTING
      associacoes     = it_associacoes
      ).

ENDFUNCTION.
