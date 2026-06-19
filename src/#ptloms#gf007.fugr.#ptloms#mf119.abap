FUNCTION /ptloms/mf119.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_GUID) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_UNAME) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_VORNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_CRIADOPOR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATACRIACAO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_HORACRIACAO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ALTERADOPOR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_DATADESSAC) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_HORADESSAC) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_MOTIVO) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_ASSOCIACOES) TYPE  /PTLOMS/CT161
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl015.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->busca_historico_associacoes
    EXPORTING
      rt_guid        = rt_guid
      rt_aufnr       = rt_aufnr
      rt_uname       = rt_uname
      rt_vornr       = rt_vornr
      rt_criadopor   = rt_criadopor
      rt_datacriacao = rt_datacriacao
      rt_horacriacao = rt_horacriacao
      rt_alteradopor = rt_alteradopor
      rt_datadessac  = rt_datadessac
      rt_horadessac  = rt_horadessac
      rt_motivo      = rt_motivo
    IMPORTING
      associacoes    = it_associacoes.



ENDFUNCTION.
