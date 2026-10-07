CLASS /ptloms/cl022 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CONSTANTS:
      gc_token_prefix        TYPE char4   VALUE 'OMS1',
      gc_ssf_application_vfy TYPE ssfappl VALUE 'ZOMSVFY'.
*      gc_ssf_application_vfy TYPE ssfappl VALUE 'ZOMSLI'.

    TYPES:
      BEGIN OF ty_validation_result,
        valid             TYPE abap_bool,
        reason_code       TYPE char30,
        message           TYPE string,

        product           TYPE char3,
        version           TYPE char2,
        customer_id       TYPE char20,
        environment       TYPE char5,
        maintenance_plant TYPE char4,
        valid_to          TYPE dats,
        license_id        TYPE sysuuid_c32,
        days_remaining    TYPE i,

        payload_text      TYPE string,

        ssf_subrc         TYPE sysubrc,
        ssf_crc           TYPE i,
        signer_count      TYPE i,
        certificate_count TYPE i,
      END OF ty_validation_result.

    METHODS constructor
      IMPORTING
        iv_ssf_application TYPE ssfappl
          DEFAULT gc_ssf_application_vfy.

    METHODS validate
      IMPORTING
        iv_activation_key    TYPE string
        iv_customer_id       TYPE char20 OPTIONAL
        iv_environment       TYPE char5 OPTIONAL
        iv_maintenance_plant TYPE char4 OPTIONAL
      RETURNING
        VALUE(rs_result)     TYPE ty_validation_result.

  PRIVATE SECTION.

    DATA:
      mv_ssf_application TYPE ssfappl,
      mo_crypto          TYPE REF TO /ptloms/cl027,
      mo_payload         TYPE REF TO /ptloms/cl026.

    METHODS decode_base64url
      IMPORTING
        iv_value   TYPE string
      EXPORTING
        ev_result  TYPE xstring
        ev_success TYPE abap_bool
        ev_message TYPE string.

    METHODS utf8_to_string
      IMPORTING
        iv_data    TYPE xstring
      EXPORTING
        ev_result  TYPE string
        ev_success TYPE abap_bool
        ev_message TYPE string.

    METHODS normalize_value
      IMPORTING
        iv_value         TYPE string
      RETURNING
        VALUE(rv_result) TYPE string.

ENDCLASS.



CLASS /PTLOMS/CL022 IMPLEMENTATION.


  METHOD constructor.

    IF iv_ssf_application IS INITIAL.
      mv_ssf_application = gc_ssf_application_vfy.
    ELSE.
      mv_ssf_application = iv_ssf_application.
    ENDIF.

    CREATE OBJECT mo_crypto
      EXPORTING
        iv_ssf_application = mv_ssf_application.

    CREATE OBJECT mo_payload.

  ENDMETHOD.


  METHOD decode_base64url.

    DATA:
      lv_base64 TYPE string,
      lv_modulo TYPE i,
      lv_error  TYPE string,
      lx_root   TYPE REF TO cx_root.

    CLEAR:
      ev_result,
      ev_success,
      ev_message.

    ev_success = abap_false.

    lv_base64 = iv_value.
    CONDENSE lv_base64 NO-GAPS.

    IF lv_base64 IS INITIAL.
      ev_message = 'Conteúdo Base64URL vazio.'.
      RETURN.
    ENDIF.

    IF lv_base64 CN
       'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'.

      ev_message =
        'Conteúdo Base64URL possui caracteres inválidos.'.
      RETURN.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '-'
      IN lv_base64
      WITH '+'.

    REPLACE ALL OCCURRENCES OF '_'
      IN lv_base64
      WITH '/'.

    lv_modulo = strlen( lv_base64 ) MOD 4.

    CASE lv_modulo.
      WHEN 0.
        " Nenhum padding necessário.

      WHEN 2.
        CONCATENATE lv_base64 '=='
          INTO lv_base64.

      WHEN 3.
        CONCATENATE lv_base64 '='
          INTO lv_base64.

      WHEN OTHERS.
        ev_message = 'Comprimento Base64URL inválido.'.
        RETURN.
    ENDCASE.

    TRY.

        ev_result =
          cl_http_utility=>decode_x_base64(
            encoded = lv_base64 ).

      CATCH cx_root INTO lx_root.

        lv_error = lx_root->get_text( ).

        CONCATENATE
          'Falha ao decodificar Base64URL:'
          lv_error
          INTO ev_message
          SEPARATED BY space.

        RETURN.

    ENDTRY.

    IF ev_result IS INITIAL.
      ev_message =
        'A decodificação Base64URL retornou conteúdo vazio.'.
      RETURN.
    ENDIF.

    ev_success = abap_true.

  ENDMETHOD.


  METHOD normalize_value.

    rv_result = iv_value.

    CONDENSE rv_result NO-GAPS.
    TRANSLATE rv_result TO UPPER CASE.

  ENDMETHOD.


  METHOD utf8_to_string.

    DATA:
      lo_converter TYPE REF TO cl_abap_conv_in_ce,
      lx_root      TYPE REF TO cx_root,
      lv_error     TYPE string.

    CLEAR:
      ev_result,
      ev_success,
      ev_message.

    ev_success = abap_false.

    IF iv_data IS INITIAL.
      ev_message = 'Conteúdo UTF-8 vazio.'.
      RETURN.
    ENDIF.

    TRY.

        lo_converter =
          cl_abap_conv_in_ce=>create(
            input       = iv_data
            encoding    = 'UTF-8'
            replacement = '#'
            ignore_cerr = abap_false ).

        lo_converter->read(
          IMPORTING
            data = ev_result ).

      CATCH cx_root INTO lx_root.

        CLEAR lv_error.
        lv_error = lx_root->get_text( ).

        CONCATENATE
          'Falha ao converter UTF-8 para texto:'
          lv_error
          INTO ev_message
          SEPARATED BY space.

        RETURN.

    ENDTRY.

    IF ev_result IS INITIAL.
      ev_message = 'A conversão UTF-8 retornou texto vazio.'.
      RETURN.
    ENDIF.

    ev_success = abap_true.

  ENDMETHOD.


METHOD validate.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************


  DATA:
    lt_token_parts          TYPE STANDARD TABLE OF string
                            WITH DEFAULT KEY,

    lv_token                TYPE string,
    lv_prefix               TYPE string,
    lv_payload_b64          TYPE string,
    lv_sign_b64             TYPE string,

    lv_payload_raw          TYPE xstring,
    lv_sign_raw             TYPE xstring,
    lv_payload_text         TYPE string,

    lv_success              TYPE abap_bool,
    lv_message              TYPE string,

    lv_customer_expected    TYPE string,
    lv_environment_expected TYPE string,
    lv_plant_expected       TYPE string,

    lv_customer_license     TYPE string,
    lv_environment_license  TYPE string,
    lv_plant_license        TYPE string,

    lv_part_count           TYPE i,
    lv_part_count_text      TYPE char10,
    lv_valid_to_text        TYPE char10,

    ls_crypto               TYPE /ptloms/cl027=>ty_verify_result,
    ls_payload              TYPE /ptloms/cl026=>ty_parse_result.

  CLEAR rs_result.
  rs_result-valid = abap_false.

*---------------------------------------------------------------------*
* 1. Verificar dependências
*---------------------------------------------------------------------*
  IF mo_crypto IS NOT BOUND.

    rs_result-reason_code = 'CRYPTO_SERVICE_NOT_BOUND'.
    rs_result-message =
      'Serviço criptográfico não está disponível.'.

    RETURN.

  ENDIF.

  IF mo_payload IS NOT BOUND.

    rs_result-reason_code = 'PAYLOAD_SERVICE_NOT_BOUND'.
    rs_result-message =
      'Serviço de payload não está disponível.'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 2. Normalizar a chave recebida
*---------------------------------------------------------------------*
  lv_token = iv_activation_key.
  CONDENSE lv_token NO-GAPS.

  IF lv_token IS INITIAL.

    rs_result-reason_code = 'EMPTY_ACTIVATION_KEY'.
    rs_result-message =
      'Chave de ativação não informada.'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 3. Separar prefixo, payload e assinatura
*---------------------------------------------------------------------*
  REFRESH lt_token_parts.

  SPLIT lv_token AT '.'
    INTO TABLE lt_token_parts.

  DESCRIBE TABLE lt_token_parts
    LINES lv_part_count.

  IF lv_part_count <> 3.

    WRITE lv_part_count TO lv_part_count_text.
    CONDENSE lv_part_count_text NO-GAPS.

    rs_result-reason_code = 'INVALID_TOKEN_FORMAT'.

    CONCATENATE
      'A chave possui'
      lv_part_count_text
      'partes; esperado: 3.'
      INTO rs_result-message
      SEPARATED BY space.

    RETURN.

  ENDIF.

  READ TABLE lt_token_parts
    INDEX 1
    INTO lv_prefix.

  IF sy-subrc <> 0.

    rs_result-reason_code = 'TOKEN_PREFIX_NOT_FOUND'.
    rs_result-message =
      'Prefixo da chave não foi localizado.'.

    RETURN.

  ENDIF.

  READ TABLE lt_token_parts
    INDEX 2
    INTO lv_payload_b64.

  IF sy-subrc <> 0.

    rs_result-reason_code = 'TOKEN_PAYLOAD_NOT_FOUND'.
    rs_result-message =
      'Payload da chave não foi localizado.'.

    RETURN.

  ENDIF.

  READ TABLE lt_token_parts
    INDEX 3
    INTO lv_sign_b64.

  IF sy-subrc <> 0.

    rs_result-reason_code = 'TOKEN_SIGNATURE_NOT_FOUND'.
    rs_result-message =
      'Assinatura da chave não foi localizada.'.

    RETURN.

  ENDIF.

  IF lv_prefix <> gc_token_prefix.

    rs_result-reason_code = 'INVALID_TOKEN_PREFIX'.

    CONCATENATE
      'Prefixo da chave inválido:'
      lv_prefix
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

  IF lv_payload_b64 IS INITIAL
     OR lv_sign_b64 IS INITIAL.

    rs_result-reason_code = 'EMPTY_TOKEN_COMPONENT'.
    rs_result-message =
      'Payload ou assinatura está vazio na chave.'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 4. Decodificar payload
*---------------------------------------------------------------------*
  CLEAR:
    lv_payload_raw,
    lv_success,
    lv_message.

  CALL METHOD me->decode_base64url
    EXPORTING
      iv_value   = lv_payload_b64
    IMPORTING
      ev_result  = lv_payload_raw
      ev_success = lv_success
      ev_message = lv_message.

  IF lv_success = abap_false.

    rs_result-reason_code = 'PAYLOAD_DECODE_ERROR'.
    rs_result-message     = lv_message.

    RETURN.

  ENDIF.

  IF lv_payload_raw IS INITIAL.

    rs_result-reason_code = 'EMPTY_DECODED_PAYLOAD'.
    rs_result-message =
      'A decodificação retornou um payload vazio.'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 5. Decodificar assinatura
*---------------------------------------------------------------------*
  CLEAR:
    lv_sign_raw,
    lv_success,
    lv_message.

  CALL METHOD me->decode_base64url
    EXPORTING
      iv_value   = lv_sign_b64
    IMPORTING
      ev_result  = lv_sign_raw
      ev_success = lv_success
      ev_message = lv_message.

  IF lv_success = abap_false.

    rs_result-reason_code = 'SIGNATURE_DECODE_ERROR'.
    rs_result-message     = lv_message.

    RETURN.

  ENDIF.

  IF lv_sign_raw IS INITIAL.

    rs_result-reason_code = 'EMPTY_DECODED_SIGNATURE'.
    rs_result-message =
      'A decodificação retornou uma assinatura vazia.'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 6. Verificar assinatura antes de confiar no payload
*---------------------------------------------------------------------*
  CLEAR ls_crypto.

  CALL METHOD mo_crypto->verify
    EXPORTING
      iv_payload   = lv_payload_raw
      iv_signature = lv_sign_raw
    RECEIVING
      rs_result    = ls_crypto.

  rs_result-ssf_subrc =
    ls_crypto-ssf_subrc.

  rs_result-ssf_crc =
    ls_crypto-ssf_crc.

  rs_result-signer_count =
    ls_crypto-signer_count.

  rs_result-certificate_count =
    ls_crypto-certificate_count.

  IF ls_crypto-success = abap_false.

    rs_result-reason_code = ls_crypto-reason_code.
    rs_result-message     = ls_crypto-message.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 7. Converter payload UTF-8 para STRING
*---------------------------------------------------------------------*
  CLEAR:
    lv_success,
    lv_message,
    lv_payload_text.

  CALL METHOD me->utf8_to_string
    EXPORTING
      iv_data    = lv_payload_raw
    IMPORTING
      ev_result  = lv_payload_text
      ev_success = lv_success
      ev_message = lv_message.

  IF lv_success = abap_false.

    rs_result-reason_code = 'PAYLOAD_UTF8_ERROR'.
    rs_result-message     = lv_message.

    RETURN.

  ENDIF.

  IF lv_payload_text IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD_TEXT'.
    rs_result-message =
      'O payload convertido para texto está vazio.'.

    RETURN.

  ENDIF.

  rs_result-payload_text = lv_payload_text.

*---------------------------------------------------------------------*
* 8. Interpretar o conteúdo do payload
*---------------------------------------------------------------------*
  CLEAR ls_payload.

  CALL METHOD mo_payload->parse
    EXPORTING
      iv_payload_text = lv_payload_text
    RECEIVING
      rs_result       = ls_payload.

  IF ls_payload-success = abap_false.

    rs_result-reason_code = ls_payload-reason_code.
    rs_result-message     = ls_payload-message.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 9. Preencher resultado com os dados assinados
*---------------------------------------------------------------------*
  rs_result-product =
    ls_payload-payload_data-product.

  rs_result-version =
    ls_payload-payload_data-version.

  rs_result-customer_id =
    ls_payload-payload_data-customer_id.

  rs_result-environment =
    ls_payload-payload_data-environment.

  rs_result-maintenance_plant =
    ls_payload-payload_data-maintenance_plant.

  rs_result-valid_to =
    ls_payload-payload_data-valid_to.

  rs_result-license_id =
    ls_payload-payload_data-license_id.

*---------------------------------------------------------------------*
* 10. Validar campos obrigatórios do payload
*---------------------------------------------------------------------*
  IF rs_result-product IS INITIAL.

    rs_result-reason_code = 'EMPTY_PRODUCT'.
    rs_result-message =
      'Produto não informado no payload da licença.'.

    RETURN.

  ENDIF.

  IF rs_result-version IS INITIAL.

    rs_result-reason_code = 'EMPTY_VERSION'.
    rs_result-message =
      'Versão não informada no payload da licença.'.

    RETURN.

  ENDIF.

  IF rs_result-customer_id IS INITIAL.

    rs_result-reason_code = 'EMPTY_CUSTOMER'.
    rs_result-message =
      'Cliente não informado no payload da licença.'.

    RETURN.

  ENDIF.

  IF rs_result-environment IS INITIAL.

    rs_result-reason_code = 'EMPTY_ENVIRONMENT'.
    rs_result-message =
      'Ambiente não informado no payload da licença.'.

    RETURN.

  ENDIF.

  IF rs_result-maintenance_plant IS INITIAL.

    rs_result-reason_code = 'EMPTY_PLANT'.
    rs_result-message =
      'Centro de manutenção não informado no payload da licença.'.

    RETURN.

  ENDIF.

  IF rs_result-valid_to IS INITIAL.

    rs_result-reason_code = 'EMPTY_VALID_TO'.
    rs_result-message =
      'Data de validade não informada no payload da licença.'.

    RETURN.

  ENDIF.

  IF rs_result-license_id IS INITIAL.

    rs_result-reason_code = 'EMPTY_LICENSE_ID'.
    rs_result-message =
      'Identificador da licença não informado no payload.'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 11. Calcular dias restantes
*---------------------------------------------------------------------*
  rs_result-days_remaining =
    rs_result-valid_to - sy-datum.

*---------------------------------------------------------------------*
* 12. Normalizar os dados assinados
*
* As atribuições anteriores substituem CONV STRING, indisponível
* no ABAP 7.31.
*---------------------------------------------------------------------*
  lv_customer_license =
    ls_payload-payload_data-customer_id.

  lv_customer_license =
    normalize_value(
      iv_value = lv_customer_license ).

  lv_environment_license =
    ls_payload-payload_data-environment.

  lv_environment_license =
    normalize_value(
      iv_value = lv_environment_license ).

  lv_plant_license =
    ls_payload-payload_data-maintenance_plant.

  lv_plant_license =
    normalize_value(
      iv_value = lv_plant_license ).

*---------------------------------------------------------------------*
* 13. Validar cliente esperado
*---------------------------------------------------------------------*
  IF iv_customer_id IS NOT INITIAL.

    lv_customer_expected = iv_customer_id.

    lv_customer_expected =
      normalize_value(
        iv_value = lv_customer_expected ).

    IF lv_customer_expected IS INITIAL.

      rs_result-reason_code = 'EMPTY_CUSTOMER_PARAMETER'.
      rs_result-message =
        'Código do cliente informado é inválido.'.

      RETURN.

    ENDIF.

    IF lv_customer_license <> lv_customer_expected.

      rs_result-reason_code = 'WRONG_CUSTOMER'.
      rs_result-message =
        'A chave não pertence ao cliente informado.'.

      RETURN.

    ENDIF.

  ENDIF.

*---------------------------------------------------------------------*
* 14. Validar ambiente esperado
*---------------------------------------------------------------------*
  IF iv_environment IS NOT INITIAL.

    lv_environment_expected = iv_environment.

    lv_environment_expected =
      normalize_value(
        iv_value = lv_environment_expected ).

    IF lv_environment_expected IS INITIAL.

      rs_result-reason_code = 'EMPTY_ENVIRONMENT_PARAMETER'.
      rs_result-message =
        'Ambiente informado é inválido.'.

      RETURN.

    ENDIF.

    IF lv_environment_license <> lv_environment_expected.

      rs_result-reason_code = 'WRONG_ENVIRONMENT'.
      rs_result-message =
        'A chave não pertence ao ambiente informado.'.

      RETURN.

    ENDIF.

  ENDIF.

*---------------------------------------------------------------------*
* 15. Validar centro esperado
*---------------------------------------------------------------------*
  IF iv_maintenance_plant IS NOT INITIAL.

    lv_plant_expected = iv_maintenance_plant.

    lv_plant_expected =
      normalize_value(
        iv_value = lv_plant_expected ).

    IF lv_plant_expected IS INITIAL.

      rs_result-reason_code = 'EMPTY_PLANT_PARAMETER'.
      rs_result-message =
        'Centro de manutenção informado é inválido.'.

      RETURN.

    ENDIF.

    IF lv_plant_license <> lv_plant_expected.

      rs_result-reason_code = 'WRONG_PLANT'.
      rs_result-message =
        'A chave não pertence ao centro de manutenção informado.'.

      RETURN.

    ENDIF.

  ENDIF.

*---------------------------------------------------------------------*
* 16. Validar vencimento
*---------------------------------------------------------------------*
  IF sy-datum > rs_result-valid_to.

    rs_result-reason_code = 'EXPIRED'.

    WRITE rs_result-valid_to
      TO lv_valid_to_text
      DD/MM/YYYY.

    CONCATENATE
      'A chave expirou em'
      lv_valid_to_text
      '.'
      INTO rs_result-message
      SEPARATED BY space.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* 17. Resultado válido
*---------------------------------------------------------------------*
  rs_result-valid       = abap_true.
  rs_result-reason_code = 'VALID'.
  rs_result-message     =
    'Chave de ativação OMS válida.'.

ENDMETHOD.
***  METHOD validate.
***
***    DATA:
***      lt_token_parts          TYPE STANDARD TABLE OF string
***                     WITH DEFAULT KEY,
***
***      lv_token                TYPE string,
***      lv_prefix               TYPE string,
***      lv_payload_b64          TYPE string,
***      lv_sign_b64             TYPE string,
***
***      lv_payload_raw          TYPE xstring,
***      lv_sign_raw             TYPE xstring,
***      lv_payload_text         TYPE string,
***
***      lv_success              TYPE abap_bool,
***      lv_message              TYPE string,
***
***      lv_customer_expected    TYPE string,
***      lv_environment_expected TYPE string,
***      lv_plant_expected       TYPE string,
***
***      lv_customer_license     TYPE string,
***      lv_environment_license  TYPE string,
***      lv_plant_license        TYPE string,
***
***      ls_crypto               TYPE /ptloms/cl027=>ty_verify_result,
***      ls_payload              TYPE /ptloms/cl026=>ty_parse_result.
***
***    CLEAR rs_result.
***
***    rs_result-valid = abap_false.
***
****---------------------------------------------------------------------*
**** 1. Verificar dependências
****---------------------------------------------------------------------*
***    IF mo_crypto IS NOT BOUND.
***      rs_result-reason_code = 'CRYPTO_SERVICE_NOT_BOUND'.
***      rs_result-message =
***        'Serviço criptográfico não está disponível.'.
***      RETURN.
***    ENDIF.
***
***    IF mo_payload IS NOT BOUND.
***      rs_result-reason_code = 'PAYLOAD_SERVICE_NOT_BOUND'.
***      rs_result-message =
***        'Serviço de payload não está disponível.'.
***      RETURN.
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 2. Normalizar a chave recebida
****---------------------------------------------------------------------*
***    lv_token = iv_activation_key.
***    CONDENSE lv_token NO-GAPS.
***
***    IF lv_token IS INITIAL.
***      rs_result-reason_code = 'EMPTY_ACTIVATION_KEY'.
***      rs_result-message =
***        'Chave de ativação não informada.'.
***      RETURN.
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 3. Separar prefixo, payload e assinatura
****---------------------------------------------------------------------*
***    SPLIT lv_token AT '.'
***      INTO TABLE lt_token_parts.
***
***    IF lines( lt_token_parts ) <> 3.
***      rs_result-reason_code = 'INVALID_TOKEN_FORMAT'.
***      rs_result-message =
***        |A chave possui { lines( lt_token_parts ) } partes; esperado: 3.|.
***      RETURN.
***    ENDIF.
***
***    READ TABLE lt_token_parts
***      INDEX 1
***      INTO lv_prefix.
***
***    IF sy-subrc <> 0.
***      rs_result-reason_code = 'TOKEN_PREFIX_NOT_FOUND'.
***      rs_result-message =
***        'Prefixo da chave não foi localizado.'.
***      RETURN.
***    ENDIF.
***
***    READ TABLE lt_token_parts
***      INDEX 2
***      INTO lv_payload_b64.
***
***    IF sy-subrc <> 0.
***      rs_result-reason_code = 'TOKEN_PAYLOAD_NOT_FOUND'.
***      rs_result-message =
***        'Payload da chave não foi localizado.'.
***      RETURN.
***    ENDIF.
***
***    READ TABLE lt_token_parts
***      INDEX 3
***      INTO lv_sign_b64.
***
***    IF sy-subrc <> 0.
***      rs_result-reason_code = 'TOKEN_SIGNATURE_NOT_FOUND'.
***      rs_result-message =
***        'Assinatura da chave não foi localizada.'.
***      RETURN.
***    ENDIF.
***
***    IF lv_prefix <> gc_token_prefix.
***      rs_result-reason_code = 'INVALID_TOKEN_PREFIX'.
***      rs_result-message =
***        |Prefixo da chave inválido: { lv_prefix }.|.
***      RETURN.
***    ENDIF.
***
***    IF lv_payload_b64 IS INITIAL
***       OR lv_sign_b64 IS INITIAL.
***
***      rs_result-reason_code = 'EMPTY_TOKEN_COMPONENT'.
***      rs_result-message =
***        'Payload ou assinatura está vazio na chave.'.
***      RETURN.
***
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 4. Decodificar payload
****---------------------------------------------------------------------*
***    CLEAR:
***      lv_success,
***      lv_message.
***
***    CALL METHOD decode_base64url
***      EXPORTING
***        iv_value   = lv_payload_b64
***      IMPORTING
***        ev_result  = lv_payload_raw
***        ev_success = lv_success
***        ev_message = lv_message.
***
***    IF lv_success = abap_false.
***      rs_result-reason_code = 'PAYLOAD_DECODE_ERROR'.
***      rs_result-message     = lv_message.
***      RETURN.
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 5. Decodificar assinatura
****---------------------------------------------------------------------*
***    CLEAR:
***      lv_success,
***      lv_message.
***
***    CALL METHOD decode_base64url
***      EXPORTING
***        iv_value   = lv_sign_b64
***      IMPORTING
***        ev_result  = lv_sign_raw
***        ev_success = lv_success
***        ev_message = lv_message.
***
***    IF lv_success = abap_false.
***      rs_result-reason_code = 'SIGNATURE_DECODE_ERROR'.
***      rs_result-message     = lv_message.
***      RETURN.
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 6. Verificar assinatura antes de confiar no payload
****---------------------------------------------------------------------*
***    ls_crypto =
***      mo_crypto->verify(
***        iv_payload   = lv_payload_raw
***        iv_signature = lv_sign_raw ).
***
***    rs_result-ssf_subrc =
***      ls_crypto-ssf_subrc.
***
***    rs_result-ssf_crc =
***      ls_crypto-ssf_crc.
***
***    rs_result-signer_count =
***      ls_crypto-signer_count.
***
***    rs_result-certificate_count =
***      ls_crypto-certificate_count.
***
***    IF ls_crypto-success = abap_false.
***      rs_result-reason_code = ls_crypto-reason_code.
***      rs_result-message     = ls_crypto-message.
***      RETURN.
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 7. Converter payload UTF-8 para STRING
****---------------------------------------------------------------------*
***    CLEAR:
***      lv_success,
***      lv_message,
***      lv_payload_text.
***
***    CALL METHOD utf8_to_string
***      EXPORTING
***        iv_data    = lv_payload_raw
***      IMPORTING
***        ev_result  = lv_payload_text
***        ev_success = lv_success
***        ev_message = lv_message.
***
***    IF lv_success = abap_false.
***      rs_result-reason_code = 'PAYLOAD_UTF8_ERROR'.
***      rs_result-message     = lv_message.
***      RETURN.
***    ENDIF.
***
***    rs_result-payload_text = lv_payload_text.
***
***    IF lv_success = abap_false.
***      rs_result-reason_code = 'PAYLOAD_UTF8_ERROR'.
***      rs_result-message     = lv_message.
***      RETURN.
***    ENDIF.
***
***    rs_result-payload_text = lv_payload_text.
***
****---------------------------------------------------------------------*
**** 8. Interpretar o conteúdo do payload
****---------------------------------------------------------------------*
***    ls_payload =
***      mo_payload->parse(
***        iv_payload_text = lv_payload_text ).
***
***    IF ls_payload-success = abap_false.
***      rs_result-reason_code = ls_payload-reason_code.
***      rs_result-message     = ls_payload-message.
***      RETURN.
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 9. Preencher o resultado com os dados assinados
****
**** Neste ponto:
**** - a assinatura já foi validada;
**** - o payload já foi interpretado;
**** - os campos abaixo são confiáveis.
****---------------------------------------------------------------------*
***    rs_result-product =
***      ls_payload-payload_data-product.
***
***    rs_result-version =
***      ls_payload-payload_data-version.
***
***    rs_result-customer_id =
***      ls_payload-payload_data-customer_id.
***
***    rs_result-environment =
***      ls_payload-payload_data-environment.
***
***    rs_result-maintenance_plant =
***      ls_payload-payload_data-maintenance_plant.
***
***    rs_result-valid_to =
***      ls_payload-payload_data-valid_to.
***
***    rs_result-license_id =
***      ls_payload-payload_data-license_id.
***
***    rs_result-days_remaining =
***      ls_payload-payload_data-valid_to - sy-datum.
***
****---------------------------------------------------------------------*
**** 10. Normalizar os dados assinados
****---------------------------------------------------------------------*
***    lv_customer_license =
***      normalize_value(
***        iv_value =
***          CONV string(
***            ls_payload-payload_data-customer_id ) ).
***
***    lv_environment_license =
***      normalize_value(
***        iv_value =
***          CONV string(
***            ls_payload-payload_data-environment ) ).
***
***    lv_plant_license =
***      normalize_value(
***        iv_value =
***          CONV string(
***            ls_payload-payload_data-maintenance_plant ) ).
***
****---------------------------------------------------------------------*
**** 11. Validar cliente esperado, quando informado
****---------------------------------------------------------------------*
***    IF iv_customer_id IS NOT INITIAL.
***
***      lv_customer_expected =
***        normalize_value(
***          iv_value =
***            CONV string( iv_customer_id ) ).
***
***      IF lv_customer_expected IS INITIAL.
***        rs_result-reason_code = 'EMPTY_CUSTOMER_PARAMETER'.
***        rs_result-message =
***          'Código do cliente informado é inválido.'.
***        RETURN.
***      ENDIF.
***
***      IF lv_customer_license <> lv_customer_expected.
***        rs_result-reason_code = 'WRONG_CUSTOMER'.
***        rs_result-message =
***          'A chave não pertence ao cliente informado.'.
***        RETURN.
***      ENDIF.
***
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 12. Validar ambiente esperado, quando informado
****---------------------------------------------------------------------*
***    IF iv_environment IS NOT INITIAL.
***
***      lv_environment_expected =
***        normalize_value(
***          iv_value =
***            CONV string( iv_environment ) ).
***
***      IF lv_environment_expected IS INITIAL.
***        rs_result-reason_code = 'EMPTY_ENVIRONMENT_PARAMETER'.
***        rs_result-message =
***          'Ambiente informado é inválido.'.
***        RETURN.
***      ENDIF.
***
***      IF lv_environment_license <> lv_environment_expected.
***        rs_result-reason_code = 'WRONG_ENVIRONMENT'.
***        rs_result-message =
***          'A chave não pertence ao ambiente informado.'.
***        RETURN.
***      ENDIF.
***
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 13. Validar centro esperado, quando informado
****---------------------------------------------------------------------*
***    IF iv_maintenance_plant IS NOT INITIAL.
***
***      lv_plant_expected =
***        normalize_value(
***          iv_value =
***            CONV string( iv_maintenance_plant ) ).
***
***      IF lv_plant_expected IS INITIAL.
***        rs_result-reason_code = 'EMPTY_PLANT_PARAMETER'.
***        rs_result-message =
***          'Centro de manutenção informado é inválido.'.
***        RETURN.
***      ENDIF.
***
***      IF lv_plant_license <> lv_plant_expected.
***        rs_result-reason_code = 'WRONG_PLANT'.
***        rs_result-message =
***          'A chave não pertence ao centro de manutenção informado.'.
***        RETURN.
***      ENDIF.
***
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 14. Validar campos obrigatórios do payload
****---------------------------------------------------------------------*
***    IF rs_result-product IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PRODUCT'.
***      rs_result-message =
***        'Produto não informado no payload da licença.'.
***      RETURN.
***    ENDIF.
***
***    IF rs_result-version IS INITIAL.
***      rs_result-reason_code = 'EMPTY_VERSION'.
***      rs_result-message =
***        'Versão não informada no payload da licença.'.
***      RETURN.
***    ENDIF.
***
***    IF rs_result-customer_id IS INITIAL.
***      rs_result-reason_code = 'EMPTY_CUSTOMER'.
***      rs_result-message =
***        'Cliente não informado no payload da licença.'.
***      RETURN.
***    ENDIF.
***
***    IF rs_result-environment IS INITIAL.
***      rs_result-reason_code = 'EMPTY_ENVIRONMENT'.
***      rs_result-message =
***        'Ambiente não informado no payload da licença.'.
***      RETURN.
***    ENDIF.
***
***    IF rs_result-maintenance_plant IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PLANT'.
***      rs_result-message =
***        'Centro de manutenção não informado no payload da licença.'.
***      RETURN.
***    ENDIF.
***
***    IF rs_result-valid_to IS INITIAL.
***      rs_result-reason_code = 'EMPTY_VALID_TO'.
***      rs_result-message =
***        'Data de validade não informada no payload da licença.'.
***      RETURN.
***    ENDIF.
***
***    IF rs_result-license_id IS INITIAL.
***      rs_result-reason_code = 'EMPTY_LICENSE_ID'.
***      rs_result-message =
***        'Identificador da licença não informado no payload.'.
***      RETURN.
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 15. Validar vencimento
****---------------------------------------------------------------------*
***    IF sy-datum > rs_result-valid_to.
***
***      rs_result-reason_code = 'EXPIRED'.
***      rs_result-message =
***        |A chave expirou em { rs_result-valid_to DATE = USER }.|.
***
***      RETURN.
***
***    ENDIF.
***
****---------------------------------------------------------------------*
**** 16. Resultado válido
****---------------------------------------------------------------------*
***    rs_result-valid       = abap_true.
***    rs_result-reason_code = 'VALID'.
***    rs_result-message     =
***      'Chave de ativação OMS válida.'.
***
***  ENDMETHOD.

*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
ENDCLASS.
