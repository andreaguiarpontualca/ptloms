FUNCTION /ptloms/mf102.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_VORNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(ET_ASSOCIACOES) TYPE  /PTLOMS/CT118
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->out_associacoes
    EXPORTING
      rt_aufnr       = rt_aufnr
      rt_usuario     = rt_usuario
      rt_vornr       = rt_vornr
    IMPORTING
      et_associacoes = et_associacoes.

ENDFUNCTION.
