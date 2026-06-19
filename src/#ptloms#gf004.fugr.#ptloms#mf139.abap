FUNCTION /ptloms/mf139.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_USUARIO) TYPE  /PTLOMS/ET184-USUARIO_APP OPTIONAL
*"     VALUE(I_OPERACAO) TYPE  /PTLOMS/ET184-ACTIVITY OPTIONAL
*"     VALUE(I_ORDEM) TYPE  /PTLOMS/ET184-ORDERID OPTIONAL
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET184-DATA_CRIACAO_APP OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET184-DATA_CRIACAO_APP OPTIONAL
*"  EXPORTING
*"     VALUE(E_HISTORICO_ASSINATURA) TYPE  /PTLOMS/CT159
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_historico_assinaturas(
    EXPORTING
     i_usuario                = i_usuario
     i_operacao               = i_operacao
     i_ordem                  = i_ordem
     i_data_ini               = i_data_ini
     i_data_fim               = i_data_fim
    IMPORTING
      e_historico_assinatura = e_historico_assinatura
      e_retorno = e_retorno
    ).

ENDFUNCTION.
