FUNCTION /ptloms/mf091.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_EQUNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_LISTA_TECNICA_EQUI) TYPE  /PTLOMS/CT054
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_lista_tecnica_equipamento(
    EXPORTING
      rt_equnr                  = rt_equnr
     IMPORTING
      et_lista_tecnica_equi     = it_lista_tecnica_equi ).

ENDFUNCTION.
