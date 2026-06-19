FUNCTION /ptloms/mf092.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_TPLNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_LISTA_TECNICA_LOC_INST) TYPE  /PTLOMS/CT032
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_lista_tecnica_loc_instala(
    EXPORTING
      rt_tplnr                  = rt_tplnr
     IMPORTING
      et_lista_tecnica_loc_inst = it_lista_tecnica_loc_inst ).

ENDFUNCTION.
