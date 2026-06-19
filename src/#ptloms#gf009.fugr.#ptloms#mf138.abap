FUNCTION /PTLOMS/MF138.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_USUARIO) TYPE  /PTLOMS/ET092-USUARIO
*"     VALUE(I_OPERACAO) TYPE  /PTLOMS/ET092-OPERACAO
*"     VALUE(I_ORDEM) TYPE  /PTLOMS/ET092-ORDEM
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET092-DATA_INI
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET092-DATA_FIM
*"  EXPORTING
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT156
*"     VALUE(E_RESPOSTAS) TYPE  /PTLOMS/CT089
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl019.

  CREATE OBJECT o_oms.

  o_oms->consulta_respostas(
    EXPORTING
      i_usuario  = i_usuario
      i_operacao = i_operacao
      i_ordem    = i_ordem
      i_data_ini = i_data_ini
      i_data_fim = i_data_fim
    IMPORTING
      e_respostas = e_respostas
      e_retorno   = e_retorno
  ).

ENDFUNCTION.
