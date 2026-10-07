FUNCTION /ptloms/mf162.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_DESPACHO) TYPE  /PTLOMS/CT119
*"     VALUE(IT_FILTRO) TYPE  /PTLOMS/CT103
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  o_oms->busca_lista_operacoes_detalhe(
    EXPORTING
      rt_aufnr      = rt_aufnr
    IMPORTING
      it_despacho = it_despacho
      it_filtro   = it_filtro
      ).

ENDFUNCTION.
