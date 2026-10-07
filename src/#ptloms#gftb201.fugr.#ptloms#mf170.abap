FUNCTION /ptloms/mf170.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_USUARIO) TYPE  /PTLOMS/ED108 OPTIONAL
*"     VALUE(IV_TIPO_USUARIO) TYPE  /PTLOMS/ED164 OPTIONAL
*"     VALUE(IS_CLIENT_INFO) TYPE  /PTLOMS/ET211 OPTIONAL
*"     VALUE(IV_SUCESSO) TYPE  XFELD OPTIONAL
*"     VALUE(IV_REASON_CODE) TYPE  /PTLOMS/ED167 OPTIONAL
*"     VALUE(IV_MENSAGEM) TYPE  BAPI_MSG OPTIONAL
*"  EXPORTING
*"     VALUE(EV_LOG_ID) TYPE  /PTLOMS/ED118
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET213
*"----------------------------------------------------------------------

  DATA:
    lo_auditoria TYPE REF TO /ptloms/cl032.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
  CLEAR:
    ev_log_id,
    es_result.

*---------------------------------------------------------------------*
* A Function Module atua somente como façade.
*
* Toda a regra de auditoria permanece centralizada na
* /PTLOMS/CL032.
*
* Esse desenho permite utilizar o mesmo contrato tanto em arquitetura
* Embedded quanto Hub, mantendo a regra de negócio exclusivamente no
* backend.
*---------------------------------------------------------------------*
  CREATE OBJECT lo_auditoria.

  CALL METHOD lo_auditoria->registrar_acesso
    EXPORTING
      iv_usuario      = iv_usuario
      iv_tipo_usuario = iv_tipo_usuario
      is_client_info  = is_client_info
      iv_sucesso      = iv_sucesso
      iv_reason_code  = iv_reason_code
      iv_mensagem     = iv_mensagem
    IMPORTING
      ev_log_id       = ev_log_id
      es_result       = es_result.

ENDFUNCTION.
