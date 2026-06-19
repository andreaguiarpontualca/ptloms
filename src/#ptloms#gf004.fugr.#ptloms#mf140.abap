FUNCTION /ptloms/mf140.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_PERFIL) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(ET_DADO_CENTRO_PERFIL) TYPE  /PTLOMS/CT160
*"----------------------------------------------------------------------
  DATA: o_oms TYPE REF TO /ptloms/cl006.

  CREATE OBJECT o_oms.

  o_oms->busca_dados_centro_perfil(
    EXPORTING
      rt_perfil = rt_perfil
    IMPORTING
      et_dado_centro_perfil = et_dado_centro_perfil
      ).

ENDFUNCTION.
