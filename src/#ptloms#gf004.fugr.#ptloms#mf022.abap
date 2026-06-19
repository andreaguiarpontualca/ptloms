FUNCTION /ptloms/mf022.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_OBJNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_PARCEIRO_NEGOCIO) TYPE  /PTLOMS/CT005
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  it_parceiro_negocio = o_oms->out_parceiro_negocio( rt_objnr = rt_objnr ).

ENDFUNCTION.
