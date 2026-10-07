class /PTLOMS/CL024 definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_check_result,
        valid             TYPE abap_bool,
        reason_code       TYPE char30,
        message           TYPE string,

        user_name         TYPE syuname,
        maintenance_plant TYPE werks_d,

        product           TYPE char3,
        version           TYPE char2,
        customer_id       TYPE char20,
        environment       TYPE char5,
        valid_to          TYPE dats,
        license_id        TYPE sysuuid_c32,
        days_remaining    TYPE i,

        ssf_subrc         TYPE sysubrc,
        ssf_crc           TYPE i,
        signer_count      TYPE i,
        certificate_count TYPE i,
      END OF ty_check_result .
  types:
    BEGIN OF ty_expiration_alert,
        werks          TYPE werks_d,
        license_id     TYPE sysuuid_c32,
        valid_to       TYPE dats,
        days_remaining TYPE i,
        status         TYPE char15,
        message        TYPE string,
      END OF ty_expiration_alert .
  types:
    ty_t_expiration_alert TYPE STANDARD TABLE OF ty_expiration_alert
                            WITH DEFAULT KEY .

  methods CONSTRUCTOR
    importing
      !IV_SSF_APPLICATION type SSFAPPL optional .
  methods CHECK_USER
    importing
      !IV_USER type SYUNAME default SY-UNAME
    returning
      value(RS_RESULT) type TY_CHECK_RESULT .
  methods CHECK_PLANT
    importing
      !IV_WERKS type WERKS_D
    returning
      value(RS_RESULT) type TY_CHECK_RESULT .
  methods GET_EXPIRATION_ALERTS
    importing
      !IV_DAYS_WARNING type I default 1000
      !IV_INCLUDE_EXPIRED type ABAP_BOOL default ABAP_TRUE
    returning
      value(RT_ALERTS) type TY_T_EXPIRATION_ALERT .
  PRIVATE SECTION.

    DATA:
      mv_ssf_application TYPE ssfappl,
      mo_repository      TYPE REF TO /ptloms/cl023,
      mo_validator       TYPE REF TO /ptloms/cl022.

    METHODS get_user_plant
      IMPORTING
        iv_user        TYPE syuname
      EXPORTING
        ev_werks       TYPE werks_d
        ev_success     TYPE abap_bool
        ev_reason_code TYPE char30
        ev_message     TYPE string.

    METHODS validate_persisted_data
      IMPORTING
        is_license     TYPE /ptloms/tb098
        is_validation  TYPE /ptloms/cl022=>ty_validation_result
      EXPORTING
        ev_success     TYPE abap_bool
        ev_reason_code TYPE char30
        ev_message     TYPE string.

ENDCLASS.



CLASS /PTLOMS/CL024 IMPLEMENTATION.


  METHOD check_plant.

    DATA:
      ls_repository_result TYPE /ptloms/cl023=>ty_read_result,
      ls_validation        TYPE /ptloms/cl022=>ty_validation_result,

      lv_success           TYPE abap_bool,
      lv_reason_code       TYPE char30,
      lv_message           TYPE string,

      lv_plant             TYPE char4.

    CLEAR rs_result.
    rs_result-valid             = abap_false.
    rs_result-maintenance_plant = iv_werks.

    IF iv_werks IS INITIAL.
      rs_result-reason_code = 'EMPTY_PLANT'.
      rs_result-message =
        'Centro não informado para validação da licença.'.
      RETURN.
    ENDIF.

    IF mo_repository IS NOT BOUND.
      rs_result-reason_code = 'REPOSITORY_NOT_BOUND'.
      rs_result-message =
        'Repositório de licenças não está disponível.'.
      RETURN.
    ENDIF.

    IF mo_validator IS NOT BOUND.
      rs_result-reason_code = 'VALIDATOR_NOT_BOUND'.
      rs_result-message =
        'Validador de licenças não está disponível.'.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* 1. Recuperar licença ativa
*---------------------------------------------------------------------*
    ls_repository_result =
      mo_repository->get_active_by_plant(
        iv_werks = iv_werks ).

    IF ls_repository_result-success = abap_false.
      rs_result-reason_code =
        ls_repository_result-reason_code.

      rs_result-message =
        ls_repository_result-message.

      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* 2. Verificações preliminares do registro
*---------------------------------------------------------------------*
    IF ls_repository_result-license_data-token IS INITIAL.
      rs_result-reason_code = 'EMPTY_STORED_TOKEN'.
      rs_result-message =
        |A licença ativa do centro { iv_werks } não possui token armazenado.|.
      RETURN.
    ENDIF.

    IF ls_repository_result-license_data-active <> abap_true.
      rs_result-reason_code = 'INACTIVE_LICENSE'.
      rs_result-message =
        |A licença do centro { iv_werks } não está ativa.|.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* 3. Validação criptográfica do token
*---------------------------------------------------------------------*
    lv_plant = iv_werks.

    ls_validation =
      mo_validator->validate(
        iv_activation_key    =
          ls_repository_result-license_data-token
        iv_maintenance_plant = lv_plant ).

    rs_result-ssf_subrc         = ls_validation-ssf_subrc.
    rs_result-ssf_crc           = ls_validation-ssf_crc.
    rs_result-signer_count      = ls_validation-signer_count.
    rs_result-certificate_count = ls_validation-certificate_count.

    IF ls_validation-valid = abap_false.
      rs_result-reason_code = ls_validation-reason_code.
      rs_result-message     = ls_validation-message.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* 4. Comparar dados assinados com os dados persistidos
*---------------------------------------------------------------------*
    validate_persisted_data(
      EXPORTING
        is_license     = ls_repository_result-license_data
        is_validation  = ls_validation
      IMPORTING
        ev_success     = lv_success
        ev_reason_code = lv_reason_code
        ev_message     = lv_message ).

    IF lv_success = abap_false.
      rs_result-reason_code = lv_reason_code.
      rs_result-message     = lv_message.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* 5. Retorno válido
*---------------------------------------------------------------------*
    rs_result-valid             = abap_true.
    rs_result-reason_code       = 'VALID'.
    rs_result-message           = 'Licença OMS válida.'.

    rs_result-maintenance_plant =
      ls_validation-maintenance_plant.

    rs_result-product =
      ls_validation-product.

    rs_result-version =
      ls_validation-version.

    rs_result-customer_id =
      ls_validation-customer_id.

    rs_result-environment =
      ls_validation-environment.

    rs_result-valid_to =
      ls_validation-valid_to.

    rs_result-license_id =
      ls_validation-license_id.

    rs_result-days_remaining =
      ls_validation-days_remaining.

  ENDMETHOD.


  METHOD check_user.

    DATA:
      lv_werks       TYPE werks_d,
      lv_success     TYPE abap_bool,
      lv_reason_code TYPE char30,
      lv_message     TYPE string.

    CLEAR rs_result.
    rs_result-valid     = abap_false.
    rs_result-user_name = iv_user.

    IF iv_user IS INITIAL.
      rs_result-reason_code = 'EMPTY_USER'.
      rs_result-message =
        'Usuário SAP não informado para validação da licença.'.
      RETURN.
    ENDIF.

    get_user_plant(
      EXPORTING
        iv_user        = iv_user
      IMPORTING
        ev_werks       = lv_werks
        ev_success     = lv_success
        ev_reason_code = lv_reason_code
        ev_message     = lv_message ).

    IF lv_success = abap_false.
      rs_result-reason_code = lv_reason_code.
      rs_result-message     = lv_message.
      RETURN.
    ENDIF.

    rs_result = check_plant(
      iv_werks = lv_werks ).

    rs_result-user_name = iv_user.

  ENDMETHOD.


  METHOD constructor.

    CLEAR mv_ssf_application.

    IF iv_ssf_application IS INITIAL.

*---------------------------------------------------------------------*
* No ambiente emissor atual, a aplicação configurada e testada é
* ZOMSLI. No cliente, troque por ZOMSVFY quando essa aplicação estiver
* criada e configurada com o certificado público.
*---------------------------------------------------------------------*
      mv_ssf_application = 'ZOMSLI'.

    ELSE.
      mv_ssf_application = iv_ssf_application.
    ENDIF.

    CREATE OBJECT mo_repository.

    CREATE OBJECT mo_validator
      EXPORTING
        iv_ssf_application = mv_ssf_application.

  ENDMETHOD.


  METHOD get_expiration_alerts.

    TYPES:
      BEGIN OF ty_license_db,
        werks      TYPE werks_d,
        license_id TYPE sysuuid_c32,
        valid_to   TYPE dats,
      END OF ty_license_db.

    DATA:
      lt_license      TYPE STANDARD TABLE OF ty_license_db
                      WITH DEFAULT KEY,
      ls_license      TYPE ty_license_db,
      ls_alert        TYPE ty_expiration_alert,
      lv_days_warning TYPE i,
      lv_limit_date   TYPE dats,
      lv_date_text    TYPE char10.

    CLEAR rt_alerts.

*---------------------------------------------------------------------*
* 1. Normalizar período de aviso
*---------------------------------------------------------------------*
    lv_days_warning = iv_days_warning.

    IF lv_days_warning < 0.
      lv_days_warning = 0.
    ENDIF.

    lv_limit_date = sy-datum + lv_days_warning.

*---------------------------------------------------------------------*
* 2. Buscar somente os campos necessários
*
* Não carregar TOKEN, pois é STRING e pode possuir conteúdo grande.
*---------------------------------------------------------------------*
    IF iv_include_expired = abap_true.

      SELECT werks
             license_id
             valid_to
        FROM /ptloms/tb098
        INTO TABLE lt_license
        WHERE active   = abap_true
          AND valid_to <= lv_limit_date
        ORDER BY werks
                 valid_to
                 license_id.

    ELSE.

      SELECT werks
             license_id
             valid_to
        FROM /ptloms/tb098
        INTO TABLE lt_license
        WHERE active   = abap_true
          AND valid_to >= sy-datum
          AND valid_to <= lv_limit_date
        ORDER BY werks
                 valid_to
                 license_id.

    ENDIF.

    IF sy-subrc <> 0 OR lt_license IS INITIAL.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* 3. Montar alertas
*---------------------------------------------------------------------*
    LOOP AT lt_license INTO ls_license.

      CLEAR:
        ls_alert,
        lv_date_text.

      ls_alert-werks      = ls_license-werks.
      ls_alert-license_id = ls_license-license_id.
      ls_alert-valid_to   = ls_license-valid_to.

*-------------------------------------------------------------------*
* Data inválida ou não preenchida
*-------------------------------------------------------------------*
      IF ls_license-valid_to IS INITIAL.

        ls_alert-days_remaining = 0.
        ls_alert-status         = 'INVALID_DATE'.
        ls_alert-message =
          |A licença do centro { ls_license-werks } não possui data de vencimento válida.|.

        APPEND ls_alert TO rt_alerts.
        CONTINUE.

      ENDIF.

*-------------------------------------------------------------------*
* Calcular dias restantes
*
* Resultado negativo significa licença vencida.
*-------------------------------------------------------------------*
      ls_alert-days_remaining =
        ls_license-valid_to - sy-datum.

*-------------------------------------------------------------------*
* Formatar data no padrão do usuário SAP
*-------------------------------------------------------------------*
      WRITE ls_license-valid_to TO lv_date_text.

*-------------------------------------------------------------------*
* Classificar situação
*-------------------------------------------------------------------*
      IF ls_alert-days_remaining < 0.

        ls_alert-status = 'EXPIRED'.

        ls_alert-message =
          |A licença do centro { ls_license-werks } venceu em { lv_date_text }.|.

      ELSEIF ls_alert-days_remaining = 0.

        ls_alert-status = 'EXPIRES_TODAY'.

        ls_alert-message =
          |A licença do centro { ls_license-werks } vence hoje, { lv_date_text }.|.

      ELSEIF ls_alert-days_remaining <= lv_days_warning.

        ls_alert-status = 'EXPIRING'.

        IF ls_alert-days_remaining = 1.

          ls_alert-message =
            |Falta 1 dia para o vencimento da licença do centro { ls_license-werks } em { lv_date_text }.|.

        ELSE.

          ls_alert-message =
            |Faltam { ls_alert-days_remaining } dias para o vencimento da licença do centro { ls_license-werks } em { lv_date_text }.|.

        ENDIF.

      ELSE.

        ls_alert-status = 'VALID'.

        ls_alert-message =
          |A licença do centro { ls_license-werks } é válida até { lv_date_text }.|.

      ENDIF.

      APPEND ls_alert TO rt_alerts.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_user_plant.

    CLEAR:
      ev_werks,
      ev_success,
      ev_reason_code,
      ev_message.

    ev_success = abap_false.

    IF iv_user IS INITIAL.
      ev_reason_code = 'EMPTY_USER'.
      ev_message =
        'Usuário SAP não informado.'.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* ATENÇÃO:
* O código abaixo assume que /PTLOMS/TB013 possui:
*
*   BNAME - usuário SAP
*   WERKS - centro
*
* Caso sua tabela utilize outros nomes, ajuste somente este SELECT.
*---------------------------------------------------------------------*
    SELECT SINGLE swerk
      FROM /ptloms/tb013
      INTO ev_werks
      WHERE usuario = iv_user.

    IF sy-subrc <> 0 OR ev_werks IS INITIAL.
      ev_reason_code = 'USER_PLANT_NOT_FOUND'.
      ev_message =
        |Não foi encontrado centro OMS para o usuário { iv_user }.|.
      RETURN.
    ENDIF.

    ev_success     = abap_true.
    ev_reason_code = 'SUCCESS'.
    ev_message     =
      'Centro do usuário localizado.'.

  ENDMETHOD.


  METHOD validate_persisted_data.

    DATA:
      lv_db_plant TYPE char4.

    CLEAR:
      ev_success,
      ev_reason_code,
      ev_message.

    ev_success = abap_false.

    lv_db_plant = is_license-werks.

*---------------------------------------------------------------------*
* Centro
*---------------------------------------------------------------------*
    IF is_validation-maintenance_plant <> lv_db_plant.
      ev_reason_code = 'PERSISTED_PLANT_MISMATCH'.
      ev_message =
        'O centro gravado não corresponde ao centro contido no token.'.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* GUID da licença
*---------------------------------------------------------------------*
    IF is_license-license_id <>
       is_validation-license_id.

      ev_reason_code = 'PERSISTED_ID_MISMATCH'.
      ev_message =
        'O GUID gravado não corresponde ao GUID contido no token.'.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Cliente
*---------------------------------------------------------------------*
    IF is_license-customer_id <>
       is_validation-customer_id.

      ev_reason_code = 'PERSISTED_CUSTOMER_MISMATCH'.
      ev_message =
        'O cliente gravado não corresponde ao cliente contido no token.'.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Ambiente
*---------------------------------------------------------------------*
    IF is_license-environment <>
       is_validation-environment.

      ev_reason_code = 'PERSISTED_ENVIRONMENT_MISMATCH'.
      ev_message =
        'O ambiente gravado não corresponde ao ambiente contido no token.'.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Produto
*---------------------------------------------------------------------*
    IF is_license-product_id <>
       is_validation-product.

      ev_reason_code = 'PERSISTED_PRODUCT_MISMATCH'.
      ev_message =
        'O produto gravado não corresponde ao produto contido no token.'.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Versão
*---------------------------------------------------------------------*
    IF is_license-format_version <>
       is_validation-version.

      ev_reason_code = 'PERSISTED_VERSION_MISMATCH'.
      ev_message =
        'A versão gravada não corresponde à versão contida no token.'.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Validade
*---------------------------------------------------------------------*
    IF is_license-valid_to <>
       is_validation-valid_to.

      ev_reason_code = 'PERSISTED_VALIDITY_MISMATCH'.
      ev_message =
        'A validade gravada não corresponde à validade contida no token.'.
      RETURN.

    ENDIF.

    ev_success     = abap_true.
    ev_reason_code = 'SUCCESS'.
    ev_message     =
      'Dados persistidos correspondem ao conteúdo assinado.'.

  ENDMETHOD.
ENDCLASS.
