FUNCTION /ptloms/mf141.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_GUID) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET188-DATACRIACAO OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET188-DATADESSAC OPTIONAL
*"  EXPORTING
*"     VALUE(ET_ASSOCIACOES) TYPE  /PTLOMS/CT162
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl014.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->obter_lista_status_exec_operac
    EXPORTING
      rt_guid        = rt_guid
      rt_aufnr       = rt_aufnr
      i_data_ini     = i_data_ini
      i_data_fim     = i_data_fim
    IMPORTING
      et_associacoes = et_associacoes.

ENDFUNCTION.
