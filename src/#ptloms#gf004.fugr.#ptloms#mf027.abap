FUNCTION /ptloms/mf027.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_QMNUM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_QMART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_IWERK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_INGRP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_BEBER) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ARBPL) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_PARNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_EQFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_STRMN) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_STTXT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ASTEX) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_NOTAS) TYPE  /PTLOMS/CT021
*"     VALUE(IT_ITENS_NOTA) TYPE  /PTLOMS/CT022
*"     VALUE(IT_TEXTOS_NOTA) TYPE  /PTLOMS/CT023
*"     VALUE(IT_MEDIDAS_NOTA) TYPE  /PTLOMS/CT024
*"     VALUE(IT_CAUSAS_NOTA) TYPE  /PTLOMS/CT025
*"     VALUE(IT_ATIVIDADES_NOTA) TYPE  /PTLOMS/CT026
*"     VALUE(IT_IMAGENS_NOTA) TYPE  /PTLOMS/CT072
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_nota(
    EXPORTING
      rt_qmnum           = rt_qmnum
      rt_qmart           = rt_qmart
      rt_iwerk           = rt_iwerk
      rt_ingrp           = rt_ingrp
      rt_beber           = rt_beber
      rt_arbpl           = rt_arbpl
      rt_parnr           = rt_parnr
      rt_eqfnr           = rt_eqfnr
      rt_strmn           = rt_strmn
      rt_sttxt           = rt_sttxt
      rt_astex           = rt_astex
    IMPORTING
      et_notas           = it_notas
      et_itens_nota      = it_itens_nota
      et_textos_nota     = it_textos_nota
      et_medidas_nota    = it_medidas_nota
      et_causas_nota     = it_causas_nota
      et_atividades_nota = it_atividades_nota
      et_imagens_nota    = it_imagens_nota ).

ENDFUNCTION.
