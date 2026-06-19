FUNCTION /ptloms/mf122.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_UNAME) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(DETALHES_ORDENS) TYPE  /PTLOMS/CT132
*"----------------------------------------------------------------------

*  DATA: o_oms TYPE REF TO /ptloms/cl015.
*
*  CREATE OBJECT o_oms.
*
*  CALL METHOD o_oms->busca_detalhes_ordens
*    EXPORTING
*      rt_aufnr       = rt_aufnr
*      rt_uname       = rt_uname
*    IMPORTING
*      detalhes_ordem = detalhes_ordens.

ENDFUNCTION.
