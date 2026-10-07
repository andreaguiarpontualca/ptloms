CLASS /ptloms/cl026 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_payload_data,
        product           TYPE char3,
        version           TYPE char2,
        customer_id       TYPE char20,
        environment       TYPE /ptloms/ed139,
        maintenance_plant TYPE char4,
        valid_to          TYPE dats,
        license_id        TYPE sysuuid_c32,
      END OF ty_payload_data .
    TYPES:
      BEGIN OF ty_build_result,
        success      TYPE abap_bool,
        reason_code  TYPE char30,
        message      TYPE string,
        payload_data TYPE ty_payload_data,
        payload_text TYPE string,
        payload_raw  TYPE xstring,
      END OF ty_build_result .
    TYPES:
      BEGIN OF ty_parse_result,
        success      TYPE abap_bool,
        reason_code  TYPE char30,
        message      TYPE string,
        payload_data TYPE ty_payload_data,
      END OF ty_parse_result .

    CONSTANTS gc_product TYPE char3 VALUE 'OMS'.            "#EC NOTEXT
    CONSTANTS gc_version TYPE char2 VALUE '01'.             "#EC NOTEXT

    METHODS build
      IMPORTING
        !iv_customer_id       TYPE char20
        !iv_environment       TYPE /ptloms/ed139
        !iv_maintenance_plant TYPE char4
        !iv_valid_to          TYPE dats
      RETURNING
        VALUE(rs_result)      TYPE ty_build_result .
    METHODS parse
      IMPORTING
        !iv_payload_text TYPE string
      RETURNING
        VALUE(rs_result) TYPE ty_parse_result .
private section.

  methods NORMALIZE_CUSTOMER
    importing
      !IV_CUSTOMER_ID type CHAR20
    returning
      value(RV_RESULT) type STRING .
  methods NORMALIZE_ENVIRONMENT
    importing
      !IV_ENVIRONMENT type /PTLOMS/ED139
    returning
      value(RV_RESULT) type STRING .
  methods NORMALIZE_PLANT
    importing
      !IV_MAINTENANCE_PLANT type CHAR4
    returning
      value(RV_RESULT) type STRING .
  methods IS_VALID_ENVIRONMENT
    importing
      !IV_ENVIRONMENT type STRING
    returning
      value(RV_VALID) type ABAP_BOOL .
  methods IS_VALID_DATE
    importing
      !IV_DATE type DATS
    returning
      value(RV_VALID) type ABAP_BOOL .
  methods STRING_TO_UTF8
    importing
      !IV_TEXT type STRING
    exporting
      !EV_SUCCESS type ABAP_BOOL
      !EV_MESSAGE type STRING
      value(RV_DATA) type XSTRING .
ENDCLASS.



CLASS /PTLOMS/CL026 IMPLEMENTATION.


METHOD build.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************


  DATA:
    lv_customer        TYPE string,
    lv_environment     TYPE string,
    lv_plant           TYPE string,
    lv_license_id      TYPE sysuuid_c32,
    lv_valid_to        TYPE char8,
    lv_convert_ok      TYPE abap_bool,
    lv_convert_message TYPE string,
    lx_uuid            TYPE REF TO cx_uuid_error,
    lv_uuid_message    TYPE string.

  CLEAR rs_result.
  rs_result-success = abap_false.

*--------------------------------------------------------------------*
* Cliente
*--------------------------------------------------------------------*
  lv_customer =
    normalize_customer(
      iv_customer_id = iv_customer_id ).

  IF lv_customer IS INITIAL.

    rs_result-reason_code = 'EMPTY_CUSTOMER'.
    rs_result-message =
      'Código do cliente não informado.'.

    RETURN.

  ENDIF.

  IF strlen( lv_customer ) > 20.

    rs_result-reason_code = 'CUSTOMER_TOO_LONG'.
    rs_result-message =
      'Código do cliente deve possuir no máximo 20 caracteres.'.

    RETURN.

  ENDIF.

  IF lv_customer CN
     'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.

    rs_result-reason_code = 'INVALID_CUSTOMER'.

    CONCATENATE
      'Código do cliente possui caracteres não permitidos:'
      lv_customer
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Ambiente
*--------------------------------------------------------------------*
  lv_environment =
    normalize_environment(
      iv_environment = iv_environment ).

  IF lv_environment IS INITIAL.

    rs_result-reason_code = 'EMPTY_ENVIRONMENT'.
    rs_result-message =
      'Ambiente não informado.'.

    RETURN.

  ENDIF.

  IF strlen( lv_environment ) > 5.

    rs_result-reason_code = 'ENVIRONMENT_TOO_LONG'.
    rs_result-message =
      'Ambiente deve possuir no máximo 5 caracteres.'.

    RETURN.

  ENDIF.

  IF is_valid_environment(
       iv_environment = lv_environment ) = abap_false.

    rs_result-reason_code = 'INVALID_ENVIRONMENT'.

    CONCATENATE
      'Ambiente inválido:'
      lv_environment
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Centro de manutenção
*--------------------------------------------------------------------*
  lv_plant =
    normalize_plant(
      iv_maintenance_plant = iv_maintenance_plant ).

  IF lv_plant IS INITIAL.

    rs_result-reason_code = 'EMPTY_PLANT'.
    rs_result-message =
      'Centro de manutenção não informado.'.

    RETURN.

  ENDIF.

  IF strlen( lv_plant ) > 4.

    rs_result-reason_code = 'PLANT_TOO_LONG'.
    rs_result-message =
      'Centro de manutenção deve possuir no máximo 4 caracteres.'.

    RETURN.

  ENDIF.

  IF lv_plant CN
     'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.

    rs_result-reason_code = 'INVALID_PLANT'.

    CONCATENATE
      'Centro de manutenção possui caracteres não permitidos:'
      lv_plant
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Data de validade
*--------------------------------------------------------------------*
  IF is_valid_date(
       iv_date = iv_valid_to ) = abap_false.

    rs_result-reason_code = 'INVALID_VALID_TO'.
    rs_result-message =
      'Data de validade inválida.'.

    RETURN.

  ENDIF.

  IF iv_valid_to < sy-datum.

    rs_result-reason_code = 'EXPIRED_VALID_TO'.
    rs_result-message =
      'A data de validade já está vencida.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Geração do GUID
*--------------------------------------------------------------------*
  TRY.

      lv_license_id =
        cl_system_uuid=>create_uuid_c32_static( ).

    CATCH cx_uuid_error INTO lx_uuid.

      CLEAR lv_uuid_message.
      lv_uuid_message = lx_uuid->get_text( ).

      rs_result-reason_code = 'UUID_ERROR'.

      CONCATENATE
        'Falha ao gerar GUID da licença:'
        lv_uuid_message
        INTO rs_result-message
        SEPARATED BY space.

      RETURN.

  ENDTRY.

  IF lv_license_id IS INITIAL.

    rs_result-reason_code = 'EMPTY_UUID'.
    rs_result-message =
      'A geração do GUID retornou valor vazio.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Montagem do payload
*--------------------------------------------------------------------*
  lv_valid_to = iv_valid_to.

  "Formato:
  "OMS|01|CLIENTE|AMBIENTE|CENTRO|VALIDADE|GUID
  CONCATENATE
    gc_product
    gc_version
    lv_customer
    lv_environment
    lv_plant
    lv_valid_to
    lv_license_id
    INTO rs_result-payload_text
    SEPARATED BY '|'.

  IF rs_result-payload_text IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD'.
    rs_result-message =
      'Não foi possível montar o payload da licença.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Conversão para UTF-8
*--------------------------------------------------------------------*
  CALL METHOD me->string_to_utf8
    EXPORTING
      iv_text    = rs_result-payload_text
    IMPORTING
      ev_success = lv_convert_ok
      ev_message = lv_convert_message
      rv_data    = rs_result-payload_raw.

  IF lv_convert_ok = abap_false.

    rs_result-reason_code = 'UTF8_CONVERSION_ERROR'.
    rs_result-message     = lv_convert_message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Dados estruturados do payload
*--------------------------------------------------------------------*
  rs_result-payload_data-product =
    gc_product.

  rs_result-payload_data-version =
    gc_version.

  "Conversão implícita compatível com ABAP 7.31
  rs_result-payload_data-customer_id =
    lv_customer.

  rs_result-payload_data-environment =
    lv_environment.

  rs_result-payload_data-maintenance_plant =
    lv_plant.

  rs_result-payload_data-valid_to =
    iv_valid_to.

  rs_result-payload_data-license_id =
    lv_license_id.

*--------------------------------------------------------------------*
* Retorno de sucesso
*--------------------------------------------------------------------*
  rs_result-success     = abap_true.
  rs_result-reason_code = 'SUCCESS'.
  rs_result-message =
    'Payload da licença criado com sucesso.'.

ENDMETHOD.
***  METHOD build.
***
***    DATA:
***      lv_customer        TYPE string,
***      lv_environment     TYPE string,
***      lv_plant           TYPE string,
***      lv_license_id      TYPE sysuuid_c32,
***      lv_valid_to        TYPE char8,
***      lv_convert_ok      TYPE abap_bool,
***      lv_convert_message TYPE string,
***      lx_uuid            TYPE REF TO cx_uuid_error.
***
***    CLEAR rs_result.
***    rs_result-success = abap_false.
***
***    lv_customer =
***      normalize_customer(
***        iv_customer_id = iv_customer_id ).
***
***    IF lv_customer IS INITIAL.
***      rs_result-reason_code = 'EMPTY_CUSTOMER'.
***      rs_result-message =
***        'Código do cliente não informado.'.
***      RETURN.
***    ENDIF.
***
***    IF strlen( lv_customer ) > 20.
***      rs_result-reason_code = 'CUSTOMER_TOO_LONG'.
***      rs_result-message =
***        'Código do cliente deve possuir no máximo 20 caracteres.'.
***      RETURN.
***    ENDIF.
***
***    IF lv_customer CN
***       'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.
***
***      rs_result-reason_code = 'INVALID_CUSTOMER'.
***      rs_result-message =
***        |Código do cliente possui caracteres não permitidos: | &&
***        |{ lv_customer }.|.
***      RETURN.
***
***    ENDIF.
***
***    lv_environment =
***      normalize_environment(
***        iv_environment = iv_environment ).
***
***    IF lv_environment IS INITIAL.
***      rs_result-reason_code = 'EMPTY_ENVIRONMENT'.
***      rs_result-message =
***        'Ambiente não informado.'.
***      RETURN.
***    ENDIF.
***
***    IF strlen( lv_environment ) > 5.
***      rs_result-reason_code = 'ENVIRONMENT_TOO_LONG'.
***      rs_result-message =
***        'Ambiente deve possuir no máximo 5 caracteres.'.
***      RETURN.
***    ENDIF.
***
***    IF is_valid_environment(
***         iv_environment = lv_environment ) = abap_false.
***
***      rs_result-reason_code = 'INVALID_ENVIRONMENT'.
***      rs_result-message =
***        |Ambiente inválido: { lv_environment }.|.
***      RETURN.
***
***    ENDIF.
***
***    lv_plant =
***      normalize_plant(
***        iv_maintenance_plant = iv_maintenance_plant ).
***
***    IF lv_plant IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PLANT'.
***      rs_result-message =
***        'Centro de manutenção não informado.'.
***      RETURN.
***    ENDIF.
***
***    IF strlen( lv_plant ) > 4.
***      rs_result-reason_code = 'PLANT_TOO_LONG'.
***      rs_result-message =
***        'Centro de manutenção deve possuir no máximo 4 caracteres.'.
***      RETURN.
***    ENDIF.
***
***    IF lv_plant CN
***       'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.
***
***      rs_result-reason_code = 'INVALID_PLANT'.
***      rs_result-message =
***        |Centro de manutenção possui caracteres não permitidos: | &&
***        |{ lv_plant }.|.
***      RETURN.
***
***    ENDIF.
***
***    IF is_valid_date(
***         iv_date = iv_valid_to ) = abap_false.
***
***      rs_result-reason_code = 'INVALID_VALID_TO'.
***      rs_result-message =
***        'Data de validade inválida.'.
***      RETURN.
***
***    ENDIF.
***
***    IF iv_valid_to < sy-datum.
***      rs_result-reason_code = 'EXPIRED_VALID_TO'.
***      rs_result-message =
***        'A data de validade já está vencida.'.
***      RETURN.
***    ENDIF.
***
***    TRY.
***
***        lv_license_id =
***          cl_system_uuid=>create_uuid_c32_static( ).
***
***      CATCH cx_uuid_error INTO lx_uuid.
***
***        rs_result-reason_code = 'UUID_ERROR'.
***        rs_result-message =
***          |Falha ao gerar GUID da licença: | &&
***          lx_uuid->get_text( ).
***        RETURN.
***
***    ENDTRY.
***
***    IF lv_license_id IS INITIAL.
***      rs_result-reason_code = 'EMPTY_UUID'.
***      rs_result-message =
***        'A geração do GUID retornou valor vazio.'.
***      RETURN.
***    ENDIF.
***
***    lv_valid_to = iv_valid_to.
***
***    "Formato oficial:
***    "OMS|01|CLIENTE|AMBIENTE|CENTRO|VALIDADE|GUID
***    CONCATENATE
***      gc_product
***      gc_version
***      lv_customer
***      lv_environment
***      lv_plant
***      lv_valid_to
***      lv_license_id
***      INTO rs_result-payload_text
***      SEPARATED BY '|'.
***
***    IF rs_result-payload_text IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PAYLOAD'.
***      rs_result-message =
***        'Não foi possível montar o payload da licença.'.
***      RETURN.
***    ENDIF.
***
***    rs_result-payload_raw =
***      string_to_utf8(
***        EXPORTING
***          iv_text    = rs_result-payload_text
***        IMPORTING
***          ev_success = lv_convert_ok
***          ev_message = lv_convert_message ).
***
***    IF lv_convert_ok = abap_false.
***      rs_result-reason_code = 'UTF8_CONVERSION_ERROR'.
***      rs_result-message     = lv_convert_message.
***      RETURN.
***    ENDIF.
***
***    rs_result-payload_data-product =
***      gc_product.
***
***    rs_result-payload_data-version =
***      gc_version.
***
***    rs_result-payload_data-customer_id =
***      CONV char20( lv_customer ).
***
***    rs_result-payload_data-environment =
***      CONV char5( lv_environment ).
***
***    rs_result-payload_data-maintenance_plant =
***      CONV char4( lv_plant ).
***
***    rs_result-payload_data-valid_to =
***      iv_valid_to.
***
***    rs_result-payload_data-license_id =
***      lv_license_id.
***
***    rs_result-success     = abap_true.
***    rs_result-reason_code = 'SUCCESS'.
***    rs_result-message =
***      'Payload da licença criado com sucesso.'.
***
***  ENDMETHOD.

*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************


  METHOD is_valid_date.

    rv_valid = abap_false.

    IF iv_date IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
      EXPORTING
        date                      = iv_date
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.

    IF sy-subrc = 0.
      rv_valid = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD is_valid_environment.

    rv_valid = abap_false.

    CASE iv_environment.
      WHEN 'DEV'
        OR 'QAS'
        OR 'PRD'
        OR 'TST'
        OR 'SBX'.

        rv_valid = abap_true.

    ENDCASE.

  ENDMETHOD.


  METHOD normalize_customer.

    rv_result = iv_customer_id.

    CONDENSE rv_result NO-GAPS.
    TRANSLATE rv_result TO UPPER CASE.

  ENDMETHOD.


  METHOD normalize_environment.

    rv_result = iv_environment.

    CONDENSE rv_result NO-GAPS.
    TRANSLATE rv_result TO UPPER CASE.

  ENDMETHOD.


  METHOD normalize_plant.

    rv_result = iv_maintenance_plant.

    CONDENSE rv_result NO-GAPS.
    TRANSLATE rv_result TO UPPER CASE.

  ENDMETHOD.


METHOD parse.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************


  DATA:
    lt_parts       TYPE STANDARD TABLE OF string
                   WITH DEFAULT KEY,
    lv_product     TYPE string,
    lv_version     TYPE string,
    lv_customer    TYPE string,
    lv_environment TYPE string,
    lv_plant       TYPE string,
    lv_date        TYPE string,
    lv_valid_to    TYPE dats,
    lv_license_id  TYPE string,
    lv_lines       TYPE i,
    lv_lines_text  TYPE char10.

  CLEAR rs_result.
  rs_result-success = abap_false.

*--------------------------------------------------------------------*
* Validação inicial
*--------------------------------------------------------------------*
  IF iv_payload_text IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD'.
    rs_result-message =
      'Payload não informado.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Separação dos campos
*--------------------------------------------------------------------*
  REFRESH lt_parts.

  SPLIT iv_payload_text AT '|'
    INTO TABLE lt_parts.

  DESCRIBE TABLE lt_parts LINES lv_lines.

  IF lv_lines <> 7.

    rs_result-reason_code = 'INVALID_FIELD_COUNT'.

    WRITE lv_lines TO lv_lines_text.
    CONDENSE lv_lines_text NO-GAPS.

    CONCATENATE
      'Payload possui'
      lv_lines_text
      'campos; esperado: 7.'
      INTO rs_result-message
      SEPARATED BY space.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Formato:
* OMS|01|CLIENTE|AMBIENTE|CENTRO|VALIDADE|GUID
*--------------------------------------------------------------------*
  READ TABLE lt_parts INDEX 1 INTO lv_product.

  IF sy-subrc <> 0.
    rs_result-reason_code = 'READ_ERROR'.
    rs_result-message =
      'Não foi possível ler o produto do payload.'.
    RETURN.
  ENDIF.

  READ TABLE lt_parts INDEX 2 INTO lv_version.

  IF sy-subrc <> 0.
    rs_result-reason_code = 'READ_ERROR'.
    rs_result-message =
      'Não foi possível ler a versão do payload.'.
    RETURN.
  ENDIF.

  READ TABLE lt_parts INDEX 3 INTO lv_customer.

  IF sy-subrc <> 0.
    rs_result-reason_code = 'READ_ERROR'.
    rs_result-message =
      'Não foi possível ler o cliente do payload.'.
    RETURN.
  ENDIF.

  READ TABLE lt_parts INDEX 4 INTO lv_environment.

  IF sy-subrc <> 0.
    rs_result-reason_code = 'READ_ERROR'.
    rs_result-message =
      'Não foi possível ler o ambiente do payload.'.
    RETURN.
  ENDIF.

  READ TABLE lt_parts INDEX 5 INTO lv_plant.

  IF sy-subrc <> 0.
    rs_result-reason_code = 'READ_ERROR'.
    rs_result-message =
      'Não foi possível ler o centro do payload.'.
    RETURN.
  ENDIF.

  READ TABLE lt_parts INDEX 6 INTO lv_date.

  IF sy-subrc <> 0.
    rs_result-reason_code = 'READ_ERROR'.
    rs_result-message =
      'Não foi possível ler a validade do payload.'.
    RETURN.
  ENDIF.

  READ TABLE lt_parts INDEX 7 INTO lv_license_id.

  IF sy-subrc <> 0.
    rs_result-reason_code = 'READ_ERROR'.
    rs_result-message =
      'Não foi possível ler o GUID do payload.'.
    RETURN.
  ENDIF.

*--------------------------------------------------------------------*
* Produto
*--------------------------------------------------------------------*
  IF lv_product <> gc_product.

    rs_result-reason_code = 'WRONG_PRODUCT'.

    CONCATENATE
      'Produto inválido no payload:'
      lv_product
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Versão
*--------------------------------------------------------------------*
  IF lv_version <> gc_version.

    rs_result-reason_code = 'UNSUPPORTED_VERSION'.

    CONCATENATE
      'Versão do payload não suportada:'
      lv_version
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Cliente
*--------------------------------------------------------------------*
  IF lv_customer IS INITIAL.

    rs_result-reason_code = 'EMPTY_CUSTOMER'.
    rs_result-message =
      'Código do cliente está vazio no payload.'.

    RETURN.

  ENDIF.

  IF strlen( lv_customer ) > 20.

    rs_result-reason_code = 'CUSTOMER_TOO_LONG'.
    rs_result-message =
      'Código do cliente excede 20 caracteres.'.

    RETURN.

  ENDIF.

  IF lv_customer CN
     'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.

    rs_result-reason_code = 'INVALID_CUSTOMER'.

    CONCATENATE
      'Código do cliente possui caracteres inválidos:'
      lv_customer
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Ambiente
*--------------------------------------------------------------------*
  IF lv_environment IS INITIAL.

    rs_result-reason_code = 'EMPTY_ENVIRONMENT'.
    rs_result-message =
      'Ambiente está vazio no payload.'.

    RETURN.

  ENDIF.

  IF strlen( lv_environment ) > 5.

    rs_result-reason_code = 'ENVIRONMENT_TOO_LONG'.
    rs_result-message =
      'Ambiente excede 5 caracteres.'.

    RETURN.

  ENDIF.

  IF is_valid_environment(
       iv_environment = lv_environment ) = abap_false.

    rs_result-reason_code = 'INVALID_ENVIRONMENT'.

    CONCATENATE
      'Ambiente contido no payload é inválido:'
      lv_environment
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Centro de manutenção
*--------------------------------------------------------------------*
  IF lv_plant IS INITIAL.

    rs_result-reason_code = 'EMPTY_PLANT'.
    rs_result-message =
      'Centro de manutenção está vazio no payload.'.

    RETURN.

  ENDIF.

  IF strlen( lv_plant ) > 4.

    rs_result-reason_code = 'PLANT_TOO_LONG'.
    rs_result-message =
      'Centro de manutenção excede 4 caracteres.'.

    RETURN.

  ENDIF.

  IF lv_plant CN
     'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.

    rs_result-reason_code = 'INVALID_PLANT'.

    CONCATENATE
      'Centro de manutenção possui caracteres inválidos:'
      lv_plant
      INTO rs_result-message
      SEPARATED BY space.

    CONCATENATE
      rs_result-message
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Data no formato interno AAAAMMDD
*--------------------------------------------------------------------*
  IF strlen( lv_date ) <> 8
     OR lv_date CN '0123456789'.

    rs_result-reason_code = 'INVALID_DATE_FORMAT'.
    rs_result-message =
      'Data contida no payload possui formato inválido.'.

    RETURN.

  ENDIF.

  lv_valid_to = lv_date.

  IF is_valid_date(
       iv_date = lv_valid_to ) = abap_false.

    rs_result-reason_code = 'INVALID_DATE'.
    rs_result-message =
      'Data contida no payload não é plausível.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* GUID da licença
*--------------------------------------------------------------------*
  IF lv_license_id IS INITIAL.

    rs_result-reason_code = 'EMPTY_LICENSE_ID'.
    rs_result-message =
      'GUID da licença está vazio no payload.'.

    RETURN.

  ENDIF.

  IF strlen( lv_license_id ) <> 32
     OR lv_license_id CN
        '0123456789ABCDEFabcdef'.

    rs_result-reason_code = 'INVALID_LICENSE_ID'.
    rs_result-message =
      'GUID da licença possui formato inválido.'.

    RETURN.

  ENDIF.

  TRANSLATE lv_license_id TO UPPER CASE.

*--------------------------------------------------------------------*
* Preenchimento dos dados interpretados
*
* As atribuições implícitas substituem CONV, indisponível no 7.31.
*--------------------------------------------------------------------*
  rs_result-payload_data-product =
    lv_product.

  rs_result-payload_data-version =
    lv_version.

  rs_result-payload_data-customer_id =
    lv_customer.

  rs_result-payload_data-environment =
    lv_environment.

  rs_result-payload_data-maintenance_plant =
    lv_plant.

  rs_result-payload_data-valid_to =
    lv_valid_to.

  rs_result-payload_data-license_id =
    lv_license_id.

*--------------------------------------------------------------------*
* Retorno de sucesso
*--------------------------------------------------------------------*
  rs_result-success     = abap_true.
  rs_result-reason_code = 'SUCCESS'.
  rs_result-message =
    'Payload interpretado com sucesso.'.

ENDMETHOD.

***  METHOD parse.
***
***    DATA:
***      lt_parts       TYPE STANDARD TABLE OF string
***                     WITH DEFAULT KEY,
***      lv_product     TYPE string,
***      lv_version     TYPE string,
***      lv_customer    TYPE string,
***      lv_environment TYPE string,
***      lv_plant       TYPE string,
***      lv_date        TYPE string,
***      lv_valid_to    TYPE dats,
***      lv_license_id  TYPE string.
***
***    CLEAR rs_result.
***    rs_result-success = abap_false.
***
***    IF iv_payload_text IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PAYLOAD'.
***      rs_result-message =
***        'Payload não informado.'.
***      RETURN.
***    ENDIF.
***
***    SPLIT iv_payload_text AT '|'
***      INTO TABLE lt_parts.
***
***    IF lines( lt_parts ) <> 7.
***      rs_result-reason_code = 'INVALID_FIELD_COUNT'.
***      rs_result-message =
***        |Payload possui { lines( lt_parts ) } campos; esperado: 7.|.
***      RETURN.
***    ENDIF.
***
***    "OMS|01|CLIENTE|AMBIENTE|CENTRO|VALIDADE|GUID
***    READ TABLE lt_parts INDEX 1 INTO lv_product.
***    READ TABLE lt_parts INDEX 2 INTO lv_version.
***    READ TABLE lt_parts INDEX 3 INTO lv_customer.
***    READ TABLE lt_parts INDEX 4 INTO lv_environment.
***    READ TABLE lt_parts INDEX 5 INTO lv_plant.
***    READ TABLE lt_parts INDEX 6 INTO lv_date.
***    READ TABLE lt_parts INDEX 7 INTO lv_license_id.
***
***    IF lv_product <> gc_product.
***      rs_result-reason_code = 'WRONG_PRODUCT'.
***      rs_result-message =
***        |Produto inválido no payload: { lv_product }.|.
***      RETURN.
***    ENDIF.
***
***    IF lv_version <> gc_version.
***      rs_result-reason_code = 'UNSUPPORTED_VERSION'.
***      rs_result-message =
***        |Versão do payload não suportada: { lv_version }.|.
***      RETURN.
***    ENDIF.
***
***    IF lv_customer IS INITIAL.
***      rs_result-reason_code = 'EMPTY_CUSTOMER'.
***      rs_result-message =
***        'Código do cliente está vazio no payload.'.
***      RETURN.
***    ENDIF.
***
***    IF strlen( lv_customer ) > 20.
***      rs_result-reason_code = 'CUSTOMER_TOO_LONG'.
***      rs_result-message =
***        'Código do cliente excede 20 caracteres.'.
***      RETURN.
***    ENDIF.
***
***    IF lv_customer CN
***       'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.
***
***      rs_result-reason_code = 'INVALID_CUSTOMER'.
***      rs_result-message =
***        |Código do cliente possui caracteres inválidos: | &&
***        |{ lv_customer }.|.
***      RETURN.
***
***    ENDIF.
***
***    IF lv_environment IS INITIAL.
***      rs_result-reason_code = 'EMPTY_ENVIRONMENT'.
***      rs_result-message =
***        'Ambiente está vazio no payload.'.
***      RETURN.
***    ENDIF.
***
***    IF strlen( lv_environment ) > 5.
***      rs_result-reason_code = 'ENVIRONMENT_TOO_LONG'.
***      rs_result-message =
***        'Ambiente excede 5 caracteres.'.
***      RETURN.
***    ENDIF.
***
***    IF is_valid_environment(
***         iv_environment = lv_environment ) = abap_false.
***
***      rs_result-reason_code = 'INVALID_ENVIRONMENT'.
***      rs_result-message =
***        |Ambiente contido no payload é inválido: | &&
***        |{ lv_environment }.|.
***      RETURN.
***
***    ENDIF.
***
***    IF lv_plant IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PLANT'.
***      rs_result-message =
***        'Centro de manutenção está vazio no payload.'.
***      RETURN.
***    ENDIF.
***
***    IF strlen( lv_plant ) > 4.
***      rs_result-reason_code = 'PLANT_TOO_LONG'.
***      rs_result-message =
***        'Centro de manutenção excede 4 caracteres.'.
***      RETURN.
***    ENDIF.
***
***    IF lv_plant CN
***       'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'.
***
***      rs_result-reason_code = 'INVALID_PLANT'.
***      rs_result-message =
***        |Centro de manutenção possui caracteres inválidos: | &&
***        |{ lv_plant }.|.
***      RETURN.
***
***    ENDIF.
***
***    IF strlen( lv_date ) <> 8
***       OR lv_date CN '0123456789'.
***
***      rs_result-reason_code = 'INVALID_DATE_FORMAT'.
***      rs_result-message =
***        'Data contida no payload possui formato inválido.'.
***      RETURN.
***
***    ENDIF.
***
***    lv_valid_to = lv_date.
***
***    IF is_valid_date(
***         iv_date = lv_valid_to ) = abap_false.
***
***      rs_result-reason_code = 'INVALID_DATE'.
***      rs_result-message =
***        'Data contida no payload não é plausível.'.
***      RETURN.
***
***    ENDIF.
***
***    IF lv_license_id IS INITIAL.
***      rs_result-reason_code = 'EMPTY_LICENSE_ID'.
***      rs_result-message =
***        'GUID da licença está vazio no payload.'.
***      RETURN.
***    ENDIF.
***
***    IF strlen( lv_license_id ) <> 32
***       OR lv_license_id CN
***          '0123456789ABCDEFabcdef'.
***
***      rs_result-reason_code = 'INVALID_LICENSE_ID'.
***      rs_result-message =
***        'GUID da licença possui formato inválido.'.
***      RETURN.
***
***    ENDIF.
***
***    TRANSLATE lv_license_id TO UPPER CASE.
***
***    rs_result-payload_data-product =
***      CONV char3( lv_product ).
***
***    rs_result-payload_data-version =
***      CONV char2( lv_version ).
***
***    rs_result-payload_data-customer_id =
***      CONV char20( lv_customer ).
***
***    rs_result-payload_data-environment =
***      CONV char5( lv_environment ).
***
***    rs_result-payload_data-maintenance_plant =
***      CONV char4( lv_plant ).
***
***    rs_result-payload_data-valid_to =
***      lv_valid_to.
***
***    rs_result-payload_data-license_id =
***      CONV sysuuid_c32( lv_license_id ).
***
***    rs_result-success     = abap_true.
***    rs_result-reason_code = 'SUCCESS'.
***    rs_result-message =
***      'Payload interpretado com sucesso.'.
***
***  ENDMETHOD.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************


METHOD string_to_utf8.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************


  DATA:
    lv_subrc      TYPE sysubrc,
    lv_subrc_text TYPE char10.

  CLEAR:
    rv_data,
    ev_success,
    ev_message.

  ev_success = abap_false.

  IF iv_text IS INITIAL.
    ev_message = 'Texto do payload está vazio.'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      text     = iv_text
      mimetype = 'text/plain; charset=utf-8'
      encoding = '4110'
    IMPORTING
      buffer   = rv_data
    EXCEPTIONS
      failed   = 1
      OTHERS   = 2.

  lv_subrc = sy-subrc.

  IF lv_subrc <> 0.

    WRITE lv_subrc TO lv_subrc_text.
    CONDENSE lv_subrc_text NO-GAPS.

    CONCATENATE
      'Falha ao converter payload para UTF-8. SY-SUBRC='
      lv_subrc_text
      '.'
      INTO ev_message.

    RETURN.

  ENDIF.

  IF rv_data IS INITIAL.
    ev_message = 'Conversão UTF-8 retornou conteúdo vazio.'.
    RETURN.
  ENDIF.

  ev_success = abap_true.

ENDMETHOD.
***  METHOD string_to_utf8.
***
***    CLEAR:
***      rv_data,
***      ev_success,
***      ev_message.
***
***    ev_success = abap_false.
***
***    IF iv_text IS INITIAL.
***      ev_message = 'Texto do payload está vazio.'.
***      RETURN.
***    ENDIF.
***
***    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
***      EXPORTING
***        text     = iv_text
***        mimetype = 'text/plain; charset=utf-8'
***        encoding = '4110'
***      IMPORTING
***        buffer   = rv_data
***      EXCEPTIONS
***        failed   = 1
***        OTHERS   = 2.
***
***    IF sy-subrc <> 0.
***      ev_message =
***        |Falha ao converter payload para UTF-8. | &&
***        |SY-SUBRC={ sy-subrc }.|.
***      RETURN.
***    ENDIF.
***
***    IF rv_data IS INITIAL.
***      ev_message =
***        'Conversão UTF-8 retornou conteúdo vazio.'.
***      RETURN.
***    ENDIF.
***
***    ev_success = abap_true.
***
***  ENDMETHOD.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
ENDCLASS.
