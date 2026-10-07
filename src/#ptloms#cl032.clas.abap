CLASS /ptloms/cl032 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS registrar_acesso
      IMPORTING
        iv_usuario      TYPE /ptloms/ed108
        iv_tipo_usuario TYPE /ptloms/ed164
        is_client_info  TYPE /ptloms/et211
        iv_sucesso      TYPE xfeld
        iv_reason_code  TYPE /ptloms/ed167
        iv_mensagem     TYPE bapi_msg
      EXPORTING
        ev_log_id       TYPE /ptloms/ed118
        es_result       TYPE /ptloms/et213.

ENDCLASS.



CLASS /PTLOMS/CL032 IMPLEMENTATION.


  METHOD registrar_acesso.

*---------------------------------------------------------------------*
* REGISTRAR_ACESSO
*
* Responsabilidade:
* - consolidar dados de auditoria;
* - gerar LOG_ID;
* - determinar timestamps;
* - persistir evento em /PTLOMS/TB201.
*
* A classe NÃO executa COMMIT WORK ou ROLLBACK WORK.
* A LUW permanece sob responsabilidade do chamador.
*---------------------------------------------------------------------*

    DATA:
      ls_event     TYPE /ptloms/et214,
      ls_tb201     TYPE /ptloms/tb201,
      lv_timestamp TYPE timestampl,
      lv_guid_32   TYPE guid_32.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
    CLEAR:
      ev_log_id,
      es_result,
      ls_event,
      ls_tb201,
      lv_timestamp,
      lv_guid_32.

*---------------------------------------------------------------------*
* 1. Validar usuário
*---------------------------------------------------------------------*
    IF iv_usuario IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'EMPTY_USER'.
      es_result-message     =
        'Usuário não informado para auditoria.'.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* 2. Recuperar informações do cliente
*---------------------------------------------------------------------*
    MOVE-CORRESPONDING is_client_info TO ls_event.

*---------------------------------------------------------------------*
* 3. Preencher informações funcionais
*---------------------------------------------------------------------*
    ls_event-user_name =
      iv_usuario.

    ls_event-user_type =
      iv_tipo_usuario.

    ls_event-login_type =
      is_client_info-login_type.

    ls_event-success =
      iv_sucesso.

    ls_event-reason_code =
      iv_reason_code.

    ls_event-message =
      iv_mensagem.

*---------------------------------------------------------------------*
* 4. Timestamp oficial do backend
*---------------------------------------------------------------------*
    GET TIME STAMP FIELD lv_timestamp.

    ls_event-server_timestamp =
      lv_timestamp.

*---------------------------------------------------------------------*
* 5. Timestamp do evento
*
* OFF_LINE = X:
* preservar o timestamp recebido do dispositivo, quando disponível.
*
* Online:
* utilizar o timestamp do servidor.
*---------------------------------------------------------------------*
    IF is_client_info-off_line EQ 'X'
       AND is_client_info-event_timestamp IS NOT INITIAL.

      ls_event-event_timestamp =
        is_client_info-event_timestamp.

    ELSE.

      ls_event-event_timestamp =
        lv_timestamp.

    ENDIF.

*---------------------------------------------------------------------*
* 6. Gerar identificador único
*---------------------------------------------------------------------*
    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_32 = lv_guid_32.

    IF lv_guid_32 IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'INTERNAL_ERROR'.
      es_result-message =
        'Não foi possível gerar o identificador da auditoria.'.

      RETURN.

    ENDIF.

    ls_event-log_id =
      lv_guid_32.

*---------------------------------------------------------------------*
* 7. Campos reservados
*
* IP_ADDRESS será tratado posteriormente na camada capaz de obter
* o endereço de forma confiável.
*
* MAINTENANCE_PLANT será integrado posteriormente ao contexto do
* usuário/licenciamento.
*---------------------------------------------------------------------*
    CLEAR:
      ls_event-ip_address,
      ls_event-maintenance_plant.

*---------------------------------------------------------------------*
* 8. Preparar persistência
*---------------------------------------------------------------------*
    MOVE-CORRESPONDING ls_event TO ls_tb201.

    ls_tb201-mandt =
      sy-mandt.

*---------------------------------------------------------------------*
* 9. Persistir evento
*---------------------------------------------------------------------*
    INSERT /ptloms/tb201
      FROM ls_tb201.

    IF sy-subrc NE 0.

      CLEAR ev_log_id.

      es_result-valid       = space.
      es_result-reason_code = 'AUDIT_WRITE_ERROR'.
      es_result-message =
        'Não foi possível registrar a auditoria de acesso.'.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* 10. Resultado
*---------------------------------------------------------------------*
    ev_log_id =
      ls_event-log_id.

    es_result-valid =
      'X'.

    es_result-reason_code =
      'OK'.

    es_result-message =
      'Auditoria de acesso registrada com sucesso.'.

  ENDMETHOD.
ENDCLASS.
