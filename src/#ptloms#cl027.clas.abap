class /PTLOMS/CL027 definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_sign_result,
        success          TYPE abap_bool,
        reason_code      TYPE char30,
        message          TYPE string,
        signature        TYPE xstring,
        signature_length TYPE i,
        ssf_subrc        TYPE sysubrc,
        ssf_crc          TYPE i,
        profile_id       TYPE string,
        profile          TYPE string,
      END OF ty_sign_result .
  types:
    BEGIN OF ty_verify_result,
        success           TYPE abap_bool,
        reason_code       TYPE char30,
        message           TYPE string,
        ssf_subrc         TYPE sysubrc,
        ssf_crc           TYPE i,
        signer_count      TYPE i,
        certificate_count TYPE i,
        profile_id        TYPE string,
        profile           TYPE string,
      END OF ty_verify_result .

  methods CONSTRUCTOR
    importing
      !IV_SSF_APPLICATION type SSFAPPL default 'ZOMSLI' .
  methods SIGN
    importing
      !IV_PAYLOAD type XSTRING
    returning
      value(RS_RESULT) type TY_SIGN_RESULT .
  methods VERIFY
    importing
      !IV_PAYLOAD type XSTRING
      !IV_SIGNATURE type XSTRING
    returning
      value(RS_RESULT) type TY_VERIFY_RESULT .
private section.

  types:
    ty_t_ssfbin  TYPE STANDARD TABLE OF ssfbin
                  WITH DEFAULT KEY .
  types:
    ty_t_ssfinfo TYPE STANDARD TABLE OF ssfinfo
                   WITH DEFAULT KEY .
  types:
    BEGIN OF ty_ssf_config,
        success        TYPE abap_bool,
        reason_code    TYPE char30,
        message        TYPE string,
        toolkit        TYPE ssfparms-ssftoolkit,
        format         TYPE ssfparms-ssfformat,
        hash_algorithm TYPE ssfparms-ssfhashalg,
        profile_id     TYPE ssfargs-profileid,
        profile        TYPE ssfargs-profile,
      END OF ty_ssf_config .

  data MV_SSF_APPLICATION type SSFAPPL .

  methods GET_CONFIGURATION
    returning
      value(RS_CONFIG) type TY_SSF_CONFIG .
  methods XSTRING_TO_SSFBIN
    importing
      !IV_DATA type XSTRING
    exporting
      !EV_SUCCESS type ABAP_BOOL
      !EV_MESSAGE type STRING
      value(RT_BINARY) type TY_T_SSFBIN .
  methods SSFBIN_TO_XSTRING
    importing
      !IT_BINARY type TY_T_SSFBIN
      !IV_LENGTH type I
    exporting
      !EV_SUCCESS type ABAP_BOOL
      !EV_MESSAGE type STRING
      value(RV_DATA) type XSTRING .
ENDCLASS.



CLASS /PTLOMS/CL027 IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    IF iv_ssf_application IS INITIAL.
      mv_ssf_application = 'ZOMSLI'.
    ELSE.
      mv_ssf_application = iv_ssf_application.
    ENDIF.

  ENDMETHOD.


  METHOD GET_CONFIGURATION.

    CLEAR rs_config.
    rs_config-success = abap_false.

    CALL FUNCTION 'SSF_GET_PARAMETER'
      EXPORTING
        application             = mv_ssf_application
      IMPORTING
        ssftoolkit              = rs_config-toolkit
        str_format              = rs_config-format
        str_profileid           = rs_config-profile_id
        str_profile             = rs_config-profile
        str_hashalg             = rs_config-hash_algorithm
      EXCEPTIONS
        ssf_parameter_not_found = 1
        OTHERS                  = 2.

    IF sy-subrc <> 0.
      rs_config-reason_code = 'SSF_CONFIG_NOT_FOUND'.
      rs_config-message =
        |Aplicação SSF { mv_ssf_application } não encontrada. | &&
        |SY-SUBRC={ sy-subrc }.|.
      RETURN.
    ENDIF.

    IF rs_config-toolkit IS INITIAL.
      rs_config-reason_code = 'SSF_TOOLKIT_EMPTY'.
      rs_config-message =
        |A aplicação SSF { mv_ssf_application } não possui toolkit configurado.|.
      RETURN.
    ENDIF.

    IF rs_config-profile_id IS INITIAL.
      rs_config-reason_code = 'SSF_PROFILE_ID_EMPTY'.
      rs_config-message =
        |A aplicação SSF { mv_ssf_application } não possui Profile ID configurado.|.
      RETURN.
    ENDIF.

    IF rs_config-profile IS INITIAL.
      rs_config-reason_code = 'SSF_PROFILE_EMPTY'.
      rs_config-message =
        |A aplicação SSF { mv_ssf_application } não possui PSE/Profile configurado.|.
      RETURN.
    ENDIF.

    IF rs_config-format IS INITIAL.
      rs_config-format = 'PKCS7'.
    ENDIF.

    rs_config-success     = abap_true.
    rs_config-reason_code = 'SUCCESS'.
    rs_config-message     = 'Configuração SSF carregada com sucesso.'.

  ENDMETHOD.


METHOD sign.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************


  DATA:
    ls_config           TYPE ty_ssf_config,
    lt_input            TYPE ty_t_ssfbin,
    lt_signature        TYPE ty_t_ssfbin,
    lt_signer           TYPE ty_t_ssfinfo,
    ls_signer           TYPE ssfinfo,
    lv_convert_success  TYPE abap_bool,
    lv_convert_message  TYPE string,
    lv_payload_length   TYPE ssfparms-indatalen,
    lv_signature_length TYPE ssfparms-sigdatalen,
    lv_crc              TYPE ssfparms-ssfcrc,
    lv_subrc            TYPE sysubrc,
    lv_signature        TYPE xstring,
    lv_subrc_text       TYPE char10,
    lv_crc_text         TYPE char20.

  CLEAR rs_result.
  rs_result-success = abap_false.

*--------------------------------------------------------------------*
* Validação do payload
*--------------------------------------------------------------------*
  IF iv_payload IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD'.
    rs_result-message =
      'Payload não informado para assinatura.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Leitura da configuração SSF
*--------------------------------------------------------------------*
  ls_config = get_configuration( ).

  IF ls_config-success = abap_false.

    rs_result-reason_code = ls_config-reason_code.
    rs_result-message     = ls_config-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Conversão do payload XSTRING para SSFBIN
*--------------------------------------------------------------------*
  CLEAR:
    lt_input,
    lv_convert_success,
    lv_convert_message.

  CALL METHOD me->xstring_to_ssfbin
    EXPORTING
      iv_data    = iv_payload
    IMPORTING
      rt_binary  = lt_input
      ev_success = lv_convert_success
      ev_message = lv_convert_message.

  IF lv_convert_success = abap_false.

    rs_result-reason_code = 'INPUT_CONVERSION_ERROR'.
    rs_result-message     = lv_convert_message.

    RETURN.

  ENDIF.

  IF lt_input[] IS INITIAL.

    rs_result-reason_code = 'EMPTY_INPUT_BINARY'.
    rs_result-message =
      'A conversão do payload retornou uma tabela binária vazia.'.

    RETURN.

  ENDIF.

  lv_payload_length = xstrlen( iv_payload ).

  IF lv_payload_length IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD_LENGTH'.
    rs_result-message =
      'Não foi possível determinar o tamanho do payload.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Preparação do signatário
*--------------------------------------------------------------------*
  CLEAR:
    lt_signer,
    ls_signer.

  ls_signer-id      = ls_config-profile_id.
  ls_signer-profile = ls_config-profile.

  APPEND ls_signer TO lt_signer.

  IF lt_signer[] IS INITIAL.

    rs_result-reason_code = 'SIGNER_NOT_CONFIGURED'.
    rs_result-message =
      'Não foi possível preparar o signatário SSF.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Geração da assinatura PKCS#7
*--------------------------------------------------------------------*
  CLEAR:
    lt_signature,
    lv_signature_length,
    lv_crc,
    lv_subrc.

  CALL FUNCTION 'SSF_KRN_SIGN'
    EXPORTING
      ssftoolkit                   = ls_config-toolkit
      str_format                   = 'PKCS7'
      b_inc_certs                  = abap_true
      b_detached                   = abap_true
      b_inenc                      = abap_true
      io_spec                      = 'T'
      ostr_input_data_l            = lv_payload_length
      str_hashalg                  = 'SHA256'
    IMPORTING
      ostr_signed_data_l           = lv_signature_length
      crc                          = lv_crc
    TABLES
      ostr_input_data              = lt_input
      signer                       = lt_signer
      ostr_signed_data             = lt_signature
    EXCEPTIONS
      ssf_krn_error                = 1
      ssf_krn_noop                 = 2
      ssf_krn_nomemory             = 3
      ssf_krn_opinv                = 4
      ssf_krn_nossflib             = 5
      ssf_krn_signer_list_error    = 6
      ssf_krn_input_data_error     = 7
      ssf_krn_invalid_par          = 8
      ssf_krn_invalid_parlen       = 9
      ssf_fb_input_parameter_error = 10
      OTHERS                       = 11.

  lv_subrc = sy-subrc.

  rs_result-ssf_subrc  = lv_subrc.
  rs_result-ssf_crc    = lv_crc.
  rs_result-profile_id = ls_config-profile_id.
  rs_result-profile    = ls_config-profile.

*--------------------------------------------------------------------*
* Tratamento do SY-SUBRC
*--------------------------------------------------------------------*
  IF lv_subrc <> 0.

    rs_result-reason_code =
      'SSF_SIGN_TECHNICAL_ERROR'.

    WRITE lv_subrc TO lv_subrc_text.
    CONDENSE lv_subrc_text NO-GAPS.

    WRITE lv_crc TO lv_crc_text.
    CONDENSE lv_crc_text NO-GAPS.

    CONCATENATE
      'Erro técnico em SSF_KRN_SIGN. SY-SUBRC='
      lv_subrc_text
      ', CRC='
      lv_crc_text
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Tratamento do CRC da biblioteca criptográfica
*--------------------------------------------------------------------*
  IF lv_crc <> 0.

    rs_result-reason_code =
      'SSF_SIGN_REJECTED'.

    WRITE lv_crc TO lv_crc_text.
    CONDENSE lv_crc_text NO-GAPS.

    CONCATENATE
      'A SAP Cryptographic Library recusou a assinatura. CRC='
      lv_crc_text
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Validação da assinatura retornada
*--------------------------------------------------------------------*
  IF lv_signature_length IS INITIAL.

    rs_result-reason_code =
      'EMPTY_SIGNATURE_LENGTH'.

    rs_result-message =
      'SSF_KRN_SIGN retornou comprimento de assinatura vazio.'.

    RETURN.

  ENDIF.

  IF lt_signature[] IS INITIAL.

    rs_result-reason_code =
      'EMPTY_SIGNATURE'.

    rs_result-message =
      'SSF_KRN_SIGN não retornou dados da assinatura.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Conversão da assinatura SSFBIN para XSTRING
*--------------------------------------------------------------------*
  CLEAR:
    lv_signature,
    lv_convert_success,
    lv_convert_message.

  CALL METHOD me->ssfbin_to_xstring
    EXPORTING
      it_binary  = lt_signature
      iv_length  = lv_signature_length
    IMPORTING
      rv_data    = lv_signature
      ev_success = lv_convert_success
      ev_message = lv_convert_message.

  IF lv_convert_success = abap_false.

    rs_result-reason_code =
      'SIGNATURE_CONVERSION_ERROR'.

    rs_result-message = lv_convert_message.

    RETURN.

  ENDIF.

  IF lv_signature IS INITIAL.

    rs_result-reason_code =
      'EMPTY_SIGNATURE_XSTRING'.

    rs_result-message =
      'A conversão da assinatura retornou um XSTRING vazio.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Retorno de sucesso
*--------------------------------------------------------------------*
  rs_result-success          = abap_true.
  rs_result-reason_code      = 'SUCCESS'.
  rs_result-message          = 'Payload assinado com sucesso.'.
  rs_result-signature        = lv_signature.
  rs_result-signature_length = lv_signature_length.

ENDMETHOD.
***  METHOD SIGN.
***
***    DATA:
***      ls_config           TYPE ty_ssf_config,
***      lt_input            TYPE ty_t_ssfbin,
***      lt_signature        TYPE ty_t_ssfbin,
***      lt_signer           TYPE ty_t_ssfinfo,
***      ls_signer           TYPE ssfinfo,
***      lv_convert_success  TYPE abap_bool,
***      lv_convert_message  TYPE string,
***      lv_payload_length   TYPE ssfparms-indatalen,
***      lv_signature_length TYPE ssfparms-sigdatalen,
***      lv_crc              TYPE ssfparms-ssfcrc,
***      lv_subrc            TYPE sysubrc,
***      lv_signature        TYPE xstring.
***
***    CLEAR rs_result.
***    rs_result-success = abap_false.
***
***    IF iv_payload IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PAYLOAD'.
***      rs_result-message =
***        'Payload não informado para assinatura.'.
***      RETURN.
***    ENDIF.
***
***    ls_config = get_configuration( ).
***
***    IF ls_config-success = abap_false.
***      rs_result-reason_code = ls_config-reason_code.
***      rs_result-message     = ls_config-message.
***      RETURN.
***    ENDIF.
***
***    lt_input =
***      xstring_to_ssfbin(
***        EXPORTING
***          iv_data    = iv_payload
***        IMPORTING
***          ev_success = lv_convert_success
***          ev_message = lv_convert_message ).
***
***    IF lv_convert_success = abap_false.
***      rs_result-reason_code = 'INPUT_CONVERSION_ERROR'.
***      rs_result-message     = lv_convert_message.
***      RETURN.
***    ENDIF.
***
***    lv_payload_length = xstrlen( iv_payload ).
***
***    CLEAR ls_signer.
***
***    ls_signer-id      = ls_config-profile_id.
***    ls_signer-profile = ls_config-profile.
***
***    APPEND ls_signer TO lt_signer.
***
***    IF lt_signer IS INITIAL.
***      rs_result-reason_code = 'SIGNER_NOT_CONFIGURED'.
***      rs_result-message =
***        'Não foi possível preparar o signatário SSF.'.
***      RETURN.
***    ENDIF.
***
***    CLEAR:
***      lt_signature,
***      lv_signature_length,
***      lv_crc.
***
***    CALL FUNCTION 'SSF_KRN_SIGN'
***      EXPORTING
***        ssftoolkit                   = ls_config-toolkit
***        str_format                   = 'PKCS7'
***        b_inc_certs                  = abap_true
***        b_detached                   = abap_true
***        b_inenc                      = abap_true
***        io_spec                      = 'T'
***        ostr_input_data_l            = lv_payload_length
***        str_hashalg                  = 'SHA256'
***      IMPORTING
***        ostr_signed_data_l           = lv_signature_length
***        crc                          = lv_crc
***      TABLES
***        ostr_input_data              = lt_input
***        signer                       = lt_signer
***        ostr_signed_data             = lt_signature
***      EXCEPTIONS
***        ssf_krn_error                = 1
***        ssf_krn_noop                 = 2
***        ssf_krn_nomemory             = 3
***        ssf_krn_opinv                = 4
***        ssf_krn_nossflib             = 5
***        ssf_krn_signer_list_error    = 6
***        ssf_krn_input_data_error     = 7
***        ssf_krn_invalid_par          = 8
***        ssf_krn_invalid_parlen       = 9
***        ssf_fb_input_parameter_error = 10
***        OTHERS                       = 11.
***
***    lv_subrc = sy-subrc.
***
***    rs_result-ssf_subrc  = lv_subrc.
***    rs_result-ssf_crc    = lv_crc.
***    rs_result-profile_id = ls_config-profile_id.
***    rs_result-profile    = ls_config-profile.
***
***    IF lv_subrc <> 0.
***      rs_result-reason_code =
***        'SSF_SIGN_TECHNICAL_ERROR'.
***
***      rs_result-message =
***        |Erro técnico em SSF_KRN_SIGN. | &&
***        |SY-SUBRC={ lv_subrc }, CRC={ lv_crc }.|.
***
***      RETURN.
***    ENDIF.
***
***    IF lv_crc <> 0.
***      rs_result-reason_code =
***        'SSF_SIGN_REJECTED'.
***
***      rs_result-message =
***        |A SAP Cryptographic Library recusou a assinatura. | &&
***        |CRC={ lv_crc }.|.
***
***      RETURN.
***    ENDIF.
***
***    IF lv_signature_length IS INITIAL.
***      rs_result-reason_code =
***        'EMPTY_SIGNATURE_LENGTH'.
***
***      rs_result-message =
***        'SSF_KRN_SIGN retornou comprimento de assinatura vazio.'.
***
***      RETURN.
***    ENDIF.
***
***    IF lt_signature IS INITIAL.
***      rs_result-reason_code =
***        'EMPTY_SIGNATURE'.
***
***      rs_result-message =
***        'SSF_KRN_SIGN não retornou dados da assinatura.'.
***
***      RETURN.
***    ENDIF.
***
***    CLEAR:
***      lv_convert_success,
***      lv_convert_message.
***
***    lv_signature =
***      ssfbin_to_xstring(
***        EXPORTING
***          it_binary  = lt_signature
***          iv_length  = lv_signature_length
***        IMPORTING
***          ev_success = lv_convert_success
***          ev_message = lv_convert_message ).
***
***    IF lv_convert_success = abap_false.
***      rs_result-reason_code =
***        'SIGNATURE_CONVERSION_ERROR'.
***
***      rs_result-message = lv_convert_message.
***      RETURN.
***    ENDIF.
***
***    rs_result-success          = abap_true.
***    rs_result-reason_code      = 'SUCCESS'.
***    rs_result-message          = 'Payload assinado com sucesso.'.
***    rs_result-signature        = lv_signature.
***    rs_result-signature_length = lv_signature_length.
***
***  ENDMETHOD.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************


METHOD ssfbin_to_xstring.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************


  DATA:
    lv_subrc      TYPE sy-subrc,
    lv_subrc_text TYPE char10.

  CLEAR:
    rv_data,
    ev_success,
    ev_message.

  ev_success = abap_false.

*--------------------------------------------------------------------*
* Validação da tabela binária
*--------------------------------------------------------------------*
  IF it_binary[] IS INITIAL.

    ev_message = 'Tabela SSFBIN vazia.'.
    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Validação do comprimento
*--------------------------------------------------------------------*
  IF iv_length <= 0.

    ev_message = 'Comprimento binário inválido.'.
    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Conversão para XSTRING
*--------------------------------------------------------------------*
  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = iv_length
    IMPORTING
      buffer       = rv_data
    TABLES
      binary_tab   = it_binary
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.

  lv_subrc = sy-subrc.

*--------------------------------------------------------------------*
* Tratamento de erro
*--------------------------------------------------------------------*
  IF lv_subrc <> 0.

    CLEAR rv_data.

    WRITE lv_subrc TO lv_subrc_text.
    CONDENSE lv_subrc_text NO-GAPS.

    CONCATENATE
      'Falha ao converter SSFBIN para XSTRING. SY-SUBRC='
      lv_subrc_text
      '.'
      INTO ev_message.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Validação do resultado
*--------------------------------------------------------------------*
  IF rv_data IS INITIAL.

    ev_message =
      'A conversão de SSFBIN para XSTRING retornou conteúdo vazio.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Retorno de sucesso
*--------------------------------------------------------------------*
  ev_success = abap_true.
  ev_message =
    'Conversão de SSFBIN para XSTRING realizada com sucesso.'.

ENDMETHOD.
***  METHOD SSFBIN_TO_XSTRING.
***
***    CLEAR:
***      rv_data,
***      ev_success,
***      ev_message.
***
***    ev_success = abap_false.
***
***    IF it_binary IS INITIAL.
***      ev_message = 'Tabela SSFBIN vazia.'.
***      RETURN.
***    ENDIF.
***
***    IF iv_length <= 0.
***      ev_message = 'Comprimento binário inválido.'.
***      RETURN.
***    ENDIF.
***
***    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
***      EXPORTING
***        input_length = iv_length
***      IMPORTING
***        buffer       = rv_data
***      TABLES
***        binary_tab   = it_binary
***      EXCEPTIONS
***        failed       = 1
***        OTHERS       = 2.
***
***    IF sy-subrc <> 0.
***      ev_message =
***        |Falha ao converter SSFBIN para XSTRING. | &&
***        |SY-SUBRC={ sy-subrc }.|.
***      RETURN.
***    ENDIF.
***
***    IF rv_data IS INITIAL.
***      ev_message =
***        'A conversão de SSFBIN para XSTRING retornou conteúdo vazio.'.
***      RETURN.
***    ENDIF.
***
***    ev_success = abap_true.
***
***  ENDMETHOD.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************


METHOD verify.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************


  DATA:
    ls_config            TYPE ty_ssf_config,

    lt_payload           TYPE ty_t_ssfbin,
    lt_signature         TYPE ty_t_ssfbin,
    lt_output            TYPE ty_t_ssfbin,
    lt_signer_result     TYPE ty_t_ssfinfo,

    lt_certificate_list  TYPE STANDARD TABLE OF ssfcertlin
                        WITH DEFAULT KEY,

    lv_convert_success   TYPE abap_bool,
    lv_convert_message   TYPE string,

    lv_payload_length    TYPE ssfparms-indatalen,
    lv_signature_length  TYPE ssfparms-sigdatalen,
    lv_output_length     TYPE ssfparms-outdatalen,

    lv_crc               TYPE ssfparms-ssfcrc,
    lv_subrc             TYPE sysubrc,

    lv_pab               TYPE ssfparms-pab,
    lv_pab_password      TYPE ssfparms-pabpw,

    lv_signer_count      TYPE i,
    lv_certificate_count TYPE i,
    lv_subrc_text        TYPE char10,
    lv_crc_text          TYPE char20.

  CLEAR rs_result.
  rs_result-success = abap_false.

*-----------------------------------------------------------------------
* 1. Validar entradas
*-----------------------------------------------------------------------
  IF iv_payload IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD'.
    rs_result-message =
      'Payload não informado para validação.'.

    RETURN.

  ENDIF.

  IF iv_signature IS INITIAL.

    rs_result-reason_code = 'EMPTY_SIGNATURE'.
    rs_result-message =
      'Assinatura não informada para validação.'.

    RETURN.

  ENDIF.

*-----------------------------------------------------------------------
* 2. Ler configuração SSF/PSE
*-----------------------------------------------------------------------
  ls_config = get_configuration( ).

  IF ls_config-success = abap_false.

    rs_result-reason_code = ls_config-reason_code.
    rs_result-message     = ls_config-message.

    RETURN.

  ENDIF.

  rs_result-profile_id = ls_config-profile_id.
  rs_result-profile    = ls_config-profile.

*-----------------------------------------------------------------------
* 3. Converter payload para SSFBIN
*-----------------------------------------------------------------------
  CLEAR:
    lt_payload,
    lv_convert_success,
    lv_convert_message.

  CALL METHOD me->xstring_to_ssfbin
    EXPORTING
      iv_data    = iv_payload
    IMPORTING
      rt_binary  = lt_payload
      ev_success = lv_convert_success
      ev_message = lv_convert_message.

  IF lv_convert_success = abap_false.

    rs_result-reason_code = 'PAYLOAD_CONVERSION_ERROR'.
    rs_result-message     = lv_convert_message.

    RETURN.

  ENDIF.

  IF lt_payload[] IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD_BINARY'.
    rs_result-message =
      'A conversão do payload retornou uma tabela vazia.'.

    RETURN.

  ENDIF.

*-----------------------------------------------------------------------
* 4. Converter assinatura para SSFBIN
*-----------------------------------------------------------------------
  CLEAR:
    lt_signature,
    lv_convert_success,
    lv_convert_message.

  CALL METHOD me->xstring_to_ssfbin
    EXPORTING
      iv_data    = iv_signature
    IMPORTING
      rt_binary  = lt_signature
      ev_success = lv_convert_success
      ev_message = lv_convert_message.

  IF lv_convert_success = abap_false.

    rs_result-reason_code = 'SIGNATURE_CONVERSION_ERROR'.
    rs_result-message     = lv_convert_message.

    RETURN.

  ENDIF.

  IF lt_signature[] IS INITIAL.

    rs_result-reason_code = 'EMPTY_SIGNATURE_BINARY'.
    rs_result-message =
      'A conversão da assinatura retornou uma tabela vazia.'.

    RETURN.

  ENDIF.

*-----------------------------------------------------------------------
* 5. Determinar os comprimentos em bytes
*-----------------------------------------------------------------------
  lv_payload_length   = xstrlen( iv_payload ).
  lv_signature_length = xstrlen( iv_signature ).

  IF lv_payload_length IS INITIAL.

    rs_result-reason_code = 'EMPTY_PAYLOAD_LENGTH'.
    rs_result-message =
      'Não foi possível determinar o comprimento do payload.'.

    RETURN.

  ENDIF.

  IF lv_signature_length IS INITIAL.

    rs_result-reason_code = 'EMPTY_SIGNATURE_LENGTH'.
    rs_result-message =
      'Não foi possível determinar o comprimento da assinatura.'.

    RETURN.

  ENDIF.

*-----------------------------------------------------------------------
* 6. PAB - PSE com certificados públicos confiáveis
*-----------------------------------------------------------------------
  lv_pab = ls_config-profile.

  CLEAR:
    lv_pab_password,
    lv_output_length,
    lv_crc,
    lv_subrc,
    lt_output,
    lt_signer_result,
    lt_certificate_list.

*-----------------------------------------------------------------------
* 7. Verificar assinatura PKCS#7 detached
*-----------------------------------------------------------------------
  CALL FUNCTION 'SSF_KRN_VERIFY'
    EXPORTING
      ssftoolkit         = ls_config-toolkit
      str_format         = 'PKCS7'
      b_inc_certs        = abap_true
      b_inenc            = abap_true
      b_outdec           = abap_true
      io_spec            = 'T'
      ostr_signed_data_l = lv_signature_length
      ostr_input_data_l  = lv_payload_length
      str_pab            = lv_pab
      str_pab_password   = lv_pab_password
    IMPORTING
      ostr_output_data_l = lv_output_length
      crc                = lv_crc
    TABLES
      ostr_signed_data   = lt_signature
      ostr_input_data    = lt_payload
      signer_result_list = lt_signer_result
      ostr_output_data   = lt_output
      certificatelist    = lt_certificate_list
    EXCEPTIONS
      OTHERS             = 1.

  lv_subrc = sy-subrc.

*-----------------------------------------------------------------------
* 8. Registrar informações retornadas
*-----------------------------------------------------------------------
  DESCRIBE TABLE lt_signer_result
    LINES lv_signer_count.

  DESCRIBE TABLE lt_certificate_list
    LINES lv_certificate_count.

  rs_result-ssf_subrc         = lv_subrc.
  rs_result-ssf_crc           = lv_crc.
  rs_result-signer_count      = lv_signer_count.
  rs_result-certificate_count = lv_certificate_count.

*-----------------------------------------------------------------------
* 9. Interpretar retorno técnico
*-----------------------------------------------------------------------
  IF lv_subrc <> 0.

    rs_result-reason_code =
      'SSF_VERIFY_TECHNICAL_ERROR'.

    WRITE lv_subrc TO lv_subrc_text.
    CONDENSE lv_subrc_text NO-GAPS.

    WRITE lv_crc TO lv_crc_text.
    CONDENSE lv_crc_text NO-GAPS.

    CONCATENATE
      'Erro técnico em SSF_KRN_VERIFY. SY-SUBRC='
      lv_subrc_text
      ', CRC='
      lv_crc_text
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*-----------------------------------------------------------------------
* 10. Interpretar CRC da biblioteca criptográfica
*-----------------------------------------------------------------------
  IF lv_crc <> 0.

    rs_result-reason_code = 'INVALID_SIGNATURE'.

    WRITE lv_crc TO lv_crc_text.
    CONDENSE lv_crc_text NO-GAPS.

    CONCATENATE
      'A assinatura criptográfica é inválida ou não confiável. CRC='
      lv_crc_text
      '.'
      INTO rs_result-message.

    RETURN.

  ENDIF.

*-----------------------------------------------------------------------
* 11. Validar signatário retornado
*-----------------------------------------------------------------------
  IF lt_signer_result[] IS INITIAL.

    rs_result-reason_code = 'SIGNER_NOT_FOUND'.
    rs_result-message =
      'A verificação não retornou um signatário válido.'.

    RETURN.

  ENDIF.

*-----------------------------------------------------------------------
* 12. Retorno de sucesso
*-----------------------------------------------------------------------
  rs_result-success     = abap_true.
  rs_result-reason_code = 'SUCCESS'.
  rs_result-message =
    'Assinatura criptográfica validada com sucesso.'.

ENDMETHOD.
***  METHOD VERIFY.
***
***    DATA:
***      ls_config           TYPE ty_ssf_config,
***
***      lt_payload          TYPE ty_t_ssfbin,
***      lt_signature        TYPE ty_t_ssfbin,
***      lt_output           TYPE ty_t_ssfbin,
***      lt_signer_result    TYPE ty_t_ssfinfo,
***
***      lt_certificate_list TYPE STANDARD TABLE OF ssfcertlin
***                          WITH DEFAULT KEY,
***
***      lv_convert_success  TYPE abap_bool,
***      lv_convert_message  TYPE string,
***
***      lv_payload_length   TYPE ssfparms-indatalen,
***      lv_signature_length TYPE ssfparms-sigdatalen,
***      lv_output_length    TYPE ssfparms-outdatalen,
***
***      lv_crc              TYPE ssfparms-ssfcrc,
***      lv_subrc            TYPE sysubrc,
***
***      lv_pab              TYPE ssfparms-pab,
***      lv_pab_password     TYPE ssfparms-pabpw.
***
***    CLEAR rs_result.
***    rs_result-success = abap_false.
***
****-----------------------------------------------------------------------
**** 1. Validar entradas
****-----------------------------------------------------------------------
***    IF iv_payload IS INITIAL.
***      rs_result-reason_code = 'EMPTY_PAYLOAD'.
***      rs_result-message =
***        'Payload não informado para validação.'.
***      RETURN.
***    ENDIF.
***
***    IF iv_signature IS INITIAL.
***      rs_result-reason_code = 'EMPTY_SIGNATURE'.
***      rs_result-message =
***        'Assinatura não informada para validação.'.
***      RETURN.
***    ENDIF.
***
****-----------------------------------------------------------------------
**** 2. Ler configuração SSF/PSE
****-----------------------------------------------------------------------
***    ls_config = get_configuration( ).
***
***    IF ls_config-success = abap_false.
***      rs_result-reason_code = ls_config-reason_code.
***      rs_result-message     = ls_config-message.
***      RETURN.
***    ENDIF.
***
***    rs_result-profile_id = ls_config-profile_id.
***    rs_result-profile    = ls_config-profile.
***
****-----------------------------------------------------------------------
**** 3. Converter payload para SSFBIN
****-----------------------------------------------------------------------
***    CLEAR:
***      lv_convert_success,
***      lv_convert_message.
***
***    lt_payload =
***      xstring_to_ssfbin(
***        EXPORTING
***          iv_data    = iv_payload
***        IMPORTING
***          ev_success = lv_convert_success
***          ev_message = lv_convert_message ).
***
***    IF lv_convert_success = abap_false.
***      rs_result-reason_code = 'PAYLOAD_CONVERSION_ERROR'.
***      rs_result-message     = lv_convert_message.
***      RETURN.
***    ENDIF.
***
****-----------------------------------------------------------------------
**** 4. Converter assinatura para SSFBIN
****-----------------------------------------------------------------------
***    CLEAR:
***      lv_convert_success,
***      lv_convert_message.
***
***    lt_signature =
***      xstring_to_ssfbin(
***        EXPORTING
***          iv_data    = iv_signature
***        IMPORTING
***          ev_success = lv_convert_success
***          ev_message = lv_convert_message ).
***
***    IF lv_convert_success = abap_false.
***      rs_result-reason_code = 'SIGNATURE_CONVERSION_ERROR'.
***      rs_result-message     = lv_convert_message.
***      RETURN.
***    ENDIF.
***
***    lv_payload_length   = xstrlen( iv_payload ).
***    lv_signature_length = xstrlen( iv_signature ).
***
****-----------------------------------------------------------------------
**** 5. PAB = PSE com certificado público confiável
****-----------------------------------------------------------------------
***    lv_pab = ls_config-profile.
***
***    CLEAR:
***      lv_pab_password,
***      lv_output_length,
***      lv_crc,
***      lt_output,
***      lt_signer_result,
***      lt_certificate_list.
***
****-----------------------------------------------------------------------
**** 6. Verificar assinatura PKCS#7 detached
****-----------------------------------------------------------------------
***    CALL FUNCTION 'SSF_KRN_VERIFY'
***      EXPORTING
***        ssftoolkit         = ls_config-toolkit
***        str_format         = 'PKCS7'
***        b_inc_certs        = abap_true
***        b_inenc            = abap_true
***        b_outdec           = abap_true
***        io_spec            = 'T'
***        ostr_signed_data_l = lv_signature_length
***        ostr_input_data_l  = lv_payload_length
***        str_pab            = lv_pab
***        str_pab_password   = lv_pab_password
***      IMPORTING
***        ostr_output_data_l = lv_output_length
***        crc                = lv_crc
***      TABLES
***        ostr_signed_data   = lt_signature
***        ostr_input_data    = lt_payload
***        signer_result_list = lt_signer_result
***        ostr_output_data   = lt_output
***        certificatelist    = lt_certificate_list
***      EXCEPTIONS
***        OTHERS             = 1.
***
***    lv_subrc = sy-subrc.
***
***    rs_result-ssf_subrc         = lv_subrc.
***    rs_result-ssf_crc           = lv_crc.
***    rs_result-signer_count      = lines( lt_signer_result ).
***    rs_result-certificate_count = lines( lt_certificate_list ).
***
****-----------------------------------------------------------------------
**** 7. Interpretar resultado
****-----------------------------------------------------------------------
***    IF lv_subrc <> 0.
***      rs_result-reason_code = 'SSF_VERIFY_TECHNICAL_ERROR'.
***      rs_result-message =
***        |Erro técnico em SSF_KRN_VERIFY. | &&
***        |SY-SUBRC={ lv_subrc }, CRC={ lv_crc }.|.
***      RETURN.
***    ENDIF.
***
***    IF lv_crc <> 0.
***      rs_result-reason_code = 'INVALID_SIGNATURE'.
***      rs_result-message =
***        |A assinatura criptográfica é inválida ou não confiável. | &&
***        |CRC={ lv_crc }.|.
***      RETURN.
***    ENDIF.
***
***    IF lt_signer_result IS INITIAL.
***      rs_result-reason_code = 'SIGNER_NOT_FOUND'.
***      rs_result-message =
***        'A verificação não retornou um signatário válido.'.
***      RETURN.
***    ENDIF.
***
***    rs_result-success     = abap_true.
***    rs_result-reason_code = 'SUCCESS'.
***    rs_result-message =
***      'Assinatura criptográfica validada com sucesso.'.
***
***  ENDMETHOD.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************


METHOD xstring_to_ssfbin.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************



  DATA:
    lv_subrc_text TYPE char10.

  CLEAR:
    rt_binary,
    ev_success,
    ev_message.

  ev_success = abap_false.

*--------------------------------------------------------------------*
* Validação da entrada
*--------------------------------------------------------------------*
  IF iv_data IS INITIAL.

    ev_message =
      'Conteúdo binário vazio.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Conversão de XSTRING para tabela binária
*--------------------------------------------------------------------*
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = iv_data
    TABLES
      binary_tab = rt_binary.

*--------------------------------------------------------------------*
* Verificação do retorno
*--------------------------------------------------------------------*
  IF sy-subrc <> 0.

    WRITE sy-subrc TO lv_subrc_text.
    CONDENSE lv_subrc_text NO-GAPS.

    CONCATENATE
      'Falha ao converter XSTRING para SSFBIN. SY-SUBRC='
      lv_subrc_text
      '.'
      INTO ev_message.

    CLEAR rt_binary.
    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Verificação do conteúdo convertido
*--------------------------------------------------------------------*
  IF rt_binary[] IS INITIAL.

    ev_message =
      'A conversão de XSTRING para SSFBIN retornou uma tabela vazia.'.

    RETURN.

  ENDIF.

*--------------------------------------------------------------------*
* Retorno de sucesso
*--------------------------------------------------------------------*
  ev_success = abap_true.
  ev_message =
    'Conversão de XSTRING para SSFBIN realizada com sucesso.'.

ENDMETHOD.

***  METHOD XSTRING_TO_SSFBIN.
***
***    CLEAR:
***      rt_binary,
***      ev_success,
***      ev_message.
***
***    ev_success = abap_false.
***
***    IF iv_data IS INITIAL.
***      ev_message = 'Conteúdo binário vazio.'.
***      RETURN.
***    ENDIF.
***
***    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
***      EXPORTING
***        buffer     = iv_data
***      TABLES
***        binary_tab = rt_binary.
***
***    IF sy-subrc <> 0.
***      ev_message =
***        |Falha ao converter XSTRING para SSFBIN. | &&
***        |SY-SUBRC={ sy-subrc }.|.
***      RETURN.
***    ENDIF.
***
***    IF rt_binary IS INITIAL.
***      ev_message =
***        'A conversão de XSTRING para SSFBIN retornou uma tabela vazia.'.
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
