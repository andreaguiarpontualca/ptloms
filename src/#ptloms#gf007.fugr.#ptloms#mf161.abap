FUNCTION /ptloms/mf161.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_USER) TYPE  SYUNAME OPTIONAL
*"     VALUE(IV_SSF_APPLICATION) TYPE  SSFAPPL OPTIONAL
*"  EXPORTING
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET207
*"----------------------------------------------------------------------

  DATA:
    lo_service        TYPE REF TO /ptloms/cl024,
    ls_service_result TYPE /ptloms/cl024=>ty_check_result,
    lv_user           TYPE syuname,
    lv_message        TYPE string,
    lx_root           TYPE REF TO cx_root.

  CLEAR es_result.

*---------------------------------------------------------------------*
* 1. Determinar usuário
*---------------------------------------------------------------------*
  IF iv_user IS INITIAL.
    lv_user = sy-uname.
  ELSE.
    lv_user = iv_user.
  ENDIF.

  es_result-user_name = lv_user.

  IF lv_user IS INITIAL.
    es_result-valid       = abap_false.
    es_result-reason_code = 'EMPTY_USER'.
    es_result-message     =
      'Usuário SAP não informado para validação da licença.'.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* 2. Instanciar serviço
*---------------------------------------------------------------------*
  TRY.

      IF iv_ssf_application IS INITIAL.

*-------------------------------------------------------------------*
* O construtor do serviço aplica a configuração SSF padrão.
*-------------------------------------------------------------------*
        CREATE OBJECT lo_service.

      ELSE.

        CREATE OBJECT lo_service
          EXPORTING
            iv_ssf_application = iv_ssf_application.

      ENDIF.

    CATCH cx_root INTO lx_root.

      lv_message = lx_root->get_text( ).

      es_result-valid       = abap_false.
      es_result-reason_code = 'SERVICE_CREATE_ERROR'.

      IF lv_message IS INITIAL.
        es_result-message =
          'Falha ao inicializar o serviço de licenciamento.'.
      ELSE.
        es_result-message = lv_message.
      ENDIF.

      RETURN.

  ENDTRY.

  IF lo_service IS NOT BOUND.
    es_result-valid       = abap_false.
    es_result-reason_code = 'SERVICE_NOT_BOUND'.
    es_result-message =
      'O serviço de licenciamento não foi inicializado.'.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* 3. Executar validação
*---------------------------------------------------------------------*
  TRY.

      ls_service_result =
        lo_service->check_user(
          iv_user = lv_user ).

    CATCH cx_root INTO lx_root.

      lv_message = lx_root->get_text( ).

      es_result-valid       = abap_false.
      es_result-reason_code = 'LICENSE_CHECK_ERROR'.

      IF lv_message IS INITIAL.
        es_result-message =
          'Erro inesperado durante a validação da licença OMS.'.
      ELSE.
        es_result-message = lv_message.
      ENDIF.

      RETURN.

  ENDTRY.

*---------------------------------------------------------------------*
* 4. Mapear resultado
*---------------------------------------------------------------------*
  es_result-valid =
    ls_service_result-valid.

  es_result-reason_code =
    ls_service_result-reason_code.

  es_result-message =
    ls_service_result-message.

  es_result-user_name =
    ls_service_result-user_name.

  es_result-maintenance_plant =
    ls_service_result-maintenance_plant.

  es_result-product =
    ls_service_result-product.

  es_result-version =
    ls_service_result-version.

  es_result-customer_id =
    ls_service_result-customer_id.

  es_result-environment =
    ls_service_result-environment.

  es_result-valid_to =
    ls_service_result-valid_to.

  es_result-license_id =
    ls_service_result-license_id.

  es_result-days_remaining =
    ls_service_result-days_remaining.

  es_result-ssf_subrc =
    ls_service_result-ssf_subrc.

  es_result-ssf_crc =
    ls_service_result-ssf_crc.

  es_result-signer_count =
    ls_service_result-signer_count.

  es_result-certificate_count =
    ls_service_result-certificate_count.

ENDFUNCTION.
