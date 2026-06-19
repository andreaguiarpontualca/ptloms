class /PTLOMS/CL020 definition
  public
  final
  create public .

public section.

  types:
    tt_werks TYPE RANGE OF /ptloms/et006-werks .
  types:
    tt_auart      TYPE RANGE OF /ptloms/et011-auart .
  types:
    tt_usuperfil TYPE RANGE OF /ptloms/tb013-usuario .
  types:
    tt_eqtyp TYPE RANGE OF equi-eqtyp .
  types:
    tt_fltyp TYPE RANGE OF fltyp .

  class-methods ANALISAR_CHECKLIST
    importing
      value(IV_PROMPT_USUARIO) type STRING
      value(IV_JSON_DADOS) type STRING
    returning
      value(RS_RESULT) type /PTLOMS/ET202 .
  class-methods BUILD_PROMPT
    importing
      !IV_JSON_DADOS type STRING
      !IV_PROMPT_USUARIO type STRING optional
    returning
      value(RV_PROMPT) type STRING .
  class-methods CALL_OPENAI
    importing
      !IV_PROMPT type STRING
    returning
      value(RV_RESULT) type STRING .
protected section.
private section.

  data IT_LISTA type /PTLOMS/CT123 .
  data IT_RETORNO type /PTLOMS/CT060 .
ENDCLASS.



CLASS /PTLOMS/CL020 IMPLEMENTATION.


  METHOD analisar_checklist.

    DATA: lv_prompt TYPE string,
          lv_return TYPE string.

    TRY.
        lv_prompt = build_prompt(
          iv_json_dados      = iv_json_dados
          iv_prompt_usuario = iv_prompt_usuario
        ).

        lv_return = call_openai( lv_prompt ).

        rs_result-success       = abap_true.
        rs_result-response_json = lv_return.

      CATCH cx_root INTO DATA(lo_error).
        rs_result-success       = abap_false.
        rs_result-error_message = lo_error->get_text( ).
    ENDTRY.

  ENDMETHOD.


METHOD build_prompt.

  CONSTANTS:
    lc_aplicacao TYPE /ptloms/tb083-aplicacao VALUE '01',
    lc_cenario   TYPE /ptloms/tb083-cenario   VALUE '01'.

  DATA:
    lv_nl     TYPE string,
    lt_prompt TYPE STANDARD TABLE OF /ptloms/tb083,
    ls_prompt TYPE /ptloms/tb083.

  CLEAR rv_prompt.

  lv_nl = cl_abap_char_utilities=>newline.

  SELECT *
    FROM /ptloms/tb083
    INTO TABLE @lt_prompt
    WHERE aplicacao = @lc_aplicacao
      AND cenario   = @lc_cenario
      AND active    = @abap_true
    ORDER BY tipo_prompt,
             sequencia,
             versao.

  IF lt_prompt IS INITIAL.
    CONCATENATE
      'Erro: prompt nao configurado na tabela /PTLOMS/TB083.'
      'Aplicacao: OMS.'
      'Cenario: Análise Checklist.'
      INTO rv_prompt
      SEPARATED BY space.
    RETURN.
  ENDIF.

  LOOP AT lt_prompt INTO ls_prompt.

    IF ls_prompt-prompt IS INITIAL.
      CONTINUE.
    ENDIF.

    IF rv_prompt IS INITIAL.
      rv_prompt = ls_prompt-prompt.
    ELSE.
      CONCATENATE
        rv_prompt
        lv_nl
        lv_nl
        ls_prompt-prompt
        INTO rv_prompt.
    ENDIF.

  ENDLOOP.

  IF iv_prompt_usuario IS NOT INITIAL.
    CONCATENATE
      rv_prompt
      lv_nl
      lv_nl
      'Instrucoes adicionais do usuario:'
      lv_nl
      iv_prompt_usuario
      INTO rv_prompt.
  ENDIF.

  IF iv_json_dados IS NOT INITIAL.
    CONCATENATE
      rv_prompt
      lv_nl
      lv_nl
      'Dados estruturados do checklist em JSON:'
      lv_nl
      iv_json_dados
      INTO rv_prompt.
  ENDIF.

ENDMETHOD.


METHOD call_openai.

  TYPES: BEGIN OF ty_msg,
           role    TYPE string,
           content TYPE string,
         END OF ty_msg.

  TYPES ty_t_msg TYPE STANDARD TABLE OF ty_msg WITH EMPTY KEY.

  TYPES: BEGIN OF ty_resp_format,
           type TYPE string,
         END OF ty_resp_format.

  TYPES: BEGIN OF ty_body,
           model                 TYPE string,
           temperature           TYPE f,
           max_completion_tokens TYPE i,
           response_format       TYPE ty_resp_format,
           messages              TYPE ty_t_msg,
         END OF ty_body.

  TYPES: BEGIN OF ty_resp_message,
           role    TYPE string,
           content TYPE string,
         END OF ty_resp_message.

  TYPES: BEGIN OF ty_choice,
           index         TYPE i,
           message       TYPE ty_resp_message,
           finish_reason TYPE string,
         END OF ty_choice.

  TYPES ty_t_choice TYPE STANDARD TABLE OF ty_choice WITH EMPTY KEY.

  TYPES: BEGIN OF ty_api_response,
           id      TYPE string,
           object  TYPE string,
           model   TYPE string,
           choices TYPE ty_t_choice,
         END OF ty_api_response.

  TYPES: BEGIN OF ty_error,
           error  TYPE string,
           status TYPE string,
           reason TYPE string,
           detail TYPE string,
           subrc  TYPE string,
           raw    TYPE string,
         END OF ty_error.

  CONSTANTS:
    lc_aplicacao TYPE /ptloms/tb081-aplicacao VALUE 'OMS',
    lc_provider  TYPE /ptloms/tb081-provider  VALUE '01'.

  DATA:
    lo_http_client TYPE REF TO if_http_client,
    lv_api_key     TYPE string,
    lv_body        TYPE string,
    lv_response    TYPE string,
    lv_status      TYPE i,
    lv_reason      TYPE string,
    lv_last_error  TYPE string,
    lv_timeout     TYPE i,
    ls_config      TYPE /ptloms/tb081,
    ls_body        TYPE ty_body,
    ls_msg         TYPE ty_msg,
    ls_api_resp    TYPE ty_api_response,
    ls_error       TYPE ty_error.

  CLEAR rv_result.

  IF iv_prompt IS INITIAL.
    CLEAR ls_error.
    ls_error-error = 'Prompt vazio'.

    rv_result = /ui2/cl_json=>serialize(
      data     = ls_error
      compress = abap_true ).
    RETURN.
  ENDIF.

  SELECT SINGLE *
    FROM /ptloms/tb081
    INTO @ls_config
    WHERE aplicacao = @lc_aplicacao
      AND provider  = @lc_provider
      AND active    = @abap_true.

  IF sy-subrc <> 0.
    CLEAR ls_error.
    ls_error-error  = 'Configuracao IA nao encontrada em /PTLOMS/TB081'.
    ls_error-detail = 'Aplicacao OMS, Provider 01 - OpenAI'.

    rv_result = /ui2/cl_json=>serialize(
      data     = ls_error
      compress = abap_true ).
    RETURN.
  ENDIF.

  IF ls_config-destination IS INITIAL.
    CLEAR ls_error.
    ls_error-error = 'DESTINATION nao configurado em /PTLOMS/TB081'.

    rv_result = /ui2/cl_json=>serialize(
      data     = ls_error
      compress = abap_true ).
    RETURN.
  ENDIF.

  IF ls_config-model IS INITIAL.
    CLEAR ls_error.
    ls_error-error = 'MODEL nao configurado em /PTLOMS/TB081'.

    rv_result = /ui2/cl_json=>serialize(
      data     = ls_error
      compress = abap_true ).
    RETURN.
  ENDIF.

  DATA ls_cred TYPE /ptloms/tb082.

  SELECT SINGLE *
    FROM /ptloms/tb082
    INTO @ls_cred
    WHERE provider = @ls_config-provider
      AND active   = @abap_true.

  IF sy-subrc <> 0.
    CLEAR ls_error.
    ls_error-error  = 'API key nao encontrada em /PTLOMS/TB082'.
    ls_error-detail = ls_config-provider.

    rv_result = /ui2/cl_json=>serialize(
      data     = ls_error
      compress = abap_true ).

    RETURN.
  ENDIF.

  lv_api_key = ls_cred-api_key.

  IF lv_api_key IS INITIAL.
    CLEAR ls_error.
    ls_error-error  = 'API key vazia em /PTLOMS/TB082'.
    ls_error-detail = ls_config-provider.

    rv_result = /ui2/cl_json=>serialize(
      data     = ls_error
      compress = abap_true ).

    RETURN.
  ENDIF.

  CLEAR ls_msg.
  ls_msg-role = 'system'.

  IF ls_config-system_prompt IS INITIAL.
    ls_msg-content = 'Voce e um assistente corporativo SAP. Responda sempre em JSON valido.'.
  ELSE.
    ls_msg-content = ls_config-system_prompt.
  ENDIF.

  APPEND ls_msg TO ls_body-messages.

  CLEAR ls_msg.
  ls_msg-role    = 'user'.
  ls_msg-content = iv_prompt.
  APPEND ls_msg TO ls_body-messages.

  DATA(lv_model) = ls_config-model.

  TRANSLATE lv_model TO LOWER CASE.
  CONDENSE lv_model NO-GAPS.

  ls_body-model = lv_model.

  IF ls_config-temperature IS INITIAL.
    ls_body-temperature = '0.2'.
  ELSE.
    ls_body-temperature = ls_config-temperature.
  ENDIF.

  IF ls_config-max_tokens IS INITIAL.
    ls_body-max_completion_tokens = 800.
  ELSE.
    ls_body-max_completion_tokens = ls_config-max_tokens.
  ENDIF.

  IF ls_config-response_format IS INITIAL.
    ls_body-response_format-type = 'json_object'.
  ELSE.
    ls_body-response_format-type = ls_config-response_format.
  ENDIF.

  DATA lv_response_format TYPE string.

  lv_response_format = ls_config-response_format.

  TRANSLATE lv_response_format TO LOWER CASE.
  CONDENSE lv_response_format NO-GAPS.

  IF lv_response_format IS INITIAL.
    lv_response_format = 'json_object'.
  ENDIF.

  ls_body-response_format-type = lv_response_format.

  IF ls_config-timeout_seconds IS INITIAL.
    lv_timeout = 120.
  ELSE.
    lv_timeout = ls_config-timeout_seconds.
  ENDIF.

  lv_body = /ui2/cl_json=>serialize(
    data        = ls_body
    compress    = abap_true
    pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

  TRY.

      cl_http_client=>create_by_destination(
        EXPORTING
          destination              = ls_config-destination
        IMPORTING
          client                   = lo_http_client
        EXCEPTIONS
          argument_not_found       = 1
          destination_not_found    = 2
          destination_no_authority = 3
          plugin_not_active        = 4
          internal_error           = 5
          OTHERS                   = 6 ).

      IF sy-subrc <> 0 OR lo_http_client IS INITIAL.
        CLEAR ls_error.
        ls_error-error  = 'Erro ao criar HTTP client via SM59'.
        ls_error-subrc  = sy-subrc.
        ls_error-detail = ls_config-destination.

        rv_result = /ui2/cl_json=>serialize(
          data     = ls_error
          compress = abap_true ).
        RETURN.
      ENDIF.

      lo_http_client->propertytype_logon_popup = lo_http_client->co_disabled.

      lo_http_client->request->set_method( 'POST' ).

      lo_http_client->request->set_header_field(
        name  = 'Content-Type'
        value = 'application/json; charset=utf-8' ).

      lo_http_client->request->set_header_field(
        name  = 'Accept'
        value = 'application/json' ).

      lo_http_client->request->set_header_field(
        name  = 'Authorization'
        value = |Bearer { lv_api_key }| ).

      lo_http_client->request->set_cdata( lv_body ).

      lo_http_client->send(
        EXPORTING
          timeout = lv_timeout
        EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          OTHERS                     = 4 ).

      IF sy-subrc <> 0.
        lo_http_client->get_last_error(
          IMPORTING
            message = lv_last_error ).

        CLEAR ls_error.
        ls_error-error  = 'Erro no SEND HTTP'.
        ls_error-detail = lv_last_error.
        ls_error-subrc  = sy-subrc.

        rv_result = /ui2/cl_json=>serialize(
          data     = ls_error
          compress = abap_true ).

        lo_http_client->close( ).
        RETURN.
      ENDIF.

      lo_http_client->receive(
        EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          OTHERS                     = 4 ).

      IF sy-subrc <> 0.
        lo_http_client->get_last_error(
          IMPORTING
            message = lv_last_error ).

        CLEAR ls_error.
        ls_error-error  = 'Erro no RECEIVE HTTP'.
        ls_error-detail = lv_last_error.
        ls_error-subrc  = sy-subrc.

        rv_result = /ui2/cl_json=>serialize(
          data     = ls_error
          compress = abap_true ).

        lo_http_client->close( ).
        RETURN.
      ENDIF.

      lo_http_client->response->get_status(
        IMPORTING
          code   = lv_status
          reason = lv_reason ).

      lv_response = lo_http_client->response->get_cdata( ).

      lo_http_client->close( ).

      CASE lv_status.

        WHEN 200.

          /ui2/cl_json=>deserialize(
            EXPORTING
              json = lv_response
            CHANGING
              data = ls_api_resp ).

          READ TABLE ls_api_resp-choices INDEX 1 INTO DATA(ls_choice).

          IF sy-subrc = 0 AND ls_choice-message-content IS NOT INITIAL.
            rv_result = ls_choice-message-content.
          ELSE.
            CLEAR ls_error.
            ls_error-error = 'Resposta sem content'.
            ls_error-raw   = lv_response.

            rv_result = /ui2/cl_json=>serialize(
              data     = ls_error
              compress = abap_true ).
          ENDIF.

        WHEN 400.
          CLEAR ls_error.
          ls_error-error  = 'Bad Request'.
          ls_error-status = lv_status.
          ls_error-detail = lv_response.

          rv_result = /ui2/cl_json=>serialize(
            data     = ls_error
            compress = abap_true ).

        WHEN 401.
          CLEAR ls_error.
          ls_error-error  = 'Nao autorizado. Verifique API key.'.
          ls_error-status = lv_status.
          ls_error-detail = lv_response.

          rv_result = /ui2/cl_json=>serialize(
            data     = ls_error
            compress = abap_true ).

        WHEN 402.
          CLEAR ls_error.
          ls_error-error  = 'Sem saldo ou billing nao habilitado.'.
          ls_error-status = lv_status.
          ls_error-detail = lv_response.

          rv_result = /ui2/cl_json=>serialize(
            data     = ls_error
            compress = abap_true ).

        WHEN 429.
          CLEAR ls_error.
          ls_error-error  = 'Rate limit excedido.'.
          ls_error-status = lv_status.
          ls_error-detail = lv_response.

          rv_result = /ui2/cl_json=>serialize(
            data     = ls_error
            compress = abap_true ).

        WHEN 500 OR 502 OR 503 OR 504.
          CLEAR ls_error.
          ls_error-error  = 'Erro temporario OpenAI'.
          ls_error-status = lv_status.
          ls_error-detail = lv_response.

          rv_result = /ui2/cl_json=>serialize(
            data     = ls_error
            compress = abap_true ).

        WHEN OTHERS.
          CLEAR ls_error.
          ls_error-error  = 'Erro HTTP'.
          ls_error-status = lv_status.
          ls_error-reason = lv_reason.
          ls_error-detail = lv_response.

          rv_result = /ui2/cl_json=>serialize(
            data     = ls_error
            compress = abap_true ).

      ENDCASE.

    CATCH cx_root INTO DATA(lx_error).

      IF lo_http_client IS BOUND.
        lo_http_client->close( ).
      ENDIF.

      CLEAR ls_error.
      ls_error-error  = 'Excecao ABAP'.
      ls_error-detail = lx_error->get_text( ).

      rv_result = /ui2/cl_json=>serialize(
        data     = ls_error
        compress = abap_true ).

  ENDTRY.

ENDMETHOD.
ENDCLASS.
