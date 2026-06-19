FUNCTION /ptloms/mf148.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATA_CRIACAO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET188-DATACRIACAO OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET188-DATADESSAC OPTIONAL
*"  EXPORTING
*"     VALUE(ET_HISTORICO) TYPE  /PTLOMS/CT162
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl014.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->obter_historico_atendimento
    EXPORTING
      rt_aufnr       = rt_aufnr
      rt_datacriacao = rt_data_criacao
    IMPORTING
      et_historico = et_historico.

ENDFUNCTION.
