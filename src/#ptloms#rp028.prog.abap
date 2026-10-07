REPORT /ptloms/rp028.

*---------------------------------------------------------------------*
* Programa : /PTLOMS/RP028
* Objetivo : Instalação de licença do produto OMS
*---------------------------------------------------------------------*


*---------------------------------------------------------------------*
* Tela de seleção
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01.

PARAMETERS:
  p_file TYPE rlgrap-filename OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

*---------------------------------------------------------------------*
* Tipos locais
*---------------------------------------------------------------------*
TYPES:
  ty_t_string TYPE STANDARD TABLE OF string
              WITH DEFAULT KEY.

*---------------------------------------------------------------------*
* Dados globais
*---------------------------------------------------------------------*
DATA:
  gv_activation_key TYPE string,

  go_validator      TYPE REF TO /ptloms/cl022,

  gs_validation     TYPE /ptloms/cl022=>ty_validation_result,

  gs_license        TYPE /ptloms/tb098,

  gv_lock_active    TYPE abap_bool.

*---------------------------------------------------------------------*
* Ajuda de pesquisa do arquivo
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM select_file
    CHANGING p_file.

*---------------------------------------------------------------------*
* Processamento principal
*---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM initialize.

  PERFORM load_activation_key
    USING    p_file
    CHANGING gv_activation_key.

  PERFORM validate_license
    USING    gv_activation_key
    CHANGING gs_validation.

  PERFORM prepare_license_record
    USING    gv_activation_key
             gs_validation
    CHANGING gs_license.

  PERFORM confirm_installation
    USING gs_validation.

  PERFORM install_license
    USING gs_license.

  PERFORM display_result
    USING gs_validation.

*---------------------------------------------------------------------*
* Finalização defensiva
*---------------------------------------------------------------------*
END-OF-SELECTION.

  IF gv_lock_active = abap_true.
    PERFORM dequeue_license
      USING gs_license-werks.
  ENDIF.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
FORM initialize.

  CLEAR:
    gv_activation_key,
    gs_validation,
    gs_license,
    gv_lock_active.

ENDFORM.

*---------------------------------------------------------------------*
* Seleção do arquivo
*---------------------------------------------------------------------*
FORM select_file
  CHANGING
    cv_file TYPE rlgrap-filename.

  DATA:
    lt_file_table  TYPE filetable,
    ls_file        TYPE file_table,
    lv_rc          TYPE i,
    lv_user_action TYPE i.

  CLEAR:
    lt_file_table,
    ls_file,
    lv_rc,
    lv_user_action.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Selecionar arquivo de licença OMS'
      default_extension       = 'txt'
      file_filter             = 'Arquivos de texto (*.txt)|*.txt|Todos os arquivos (*.*)|*.*|'
      multiselection          = abap_false
    CHANGING
      file_table              = lt_file_table
      rc                      = lv_rc
      user_action             = lv_user_action
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Não foi possível abrir a seleção de arquivo.' TYPE 'E'.
  ENDIF.

  IF lv_user_action <> cl_gui_frontend_services=>action_ok.
    RETURN.
  ENDIF.

  IF lv_rc <= 0.
    RETURN.
  ENDIF.

  READ TABLE lt_file_table
    INTO ls_file
    INDEX 1.

  IF sy-subrc <> 0.
    MESSAGE 'Nenhum arquivo foi selecionado.' TYPE 'E'.
  ENDIF.

  cv_file = ls_file-filename.

ENDFORM.

*---------------------------------------------------------------------*
* Carregamento do arquivo de licença
*---------------------------------------------------------------------*
FORM load_activation_key
  USING
    iv_file           TYPE rlgrap-filename
  CHANGING
    cv_activation_key TYPE string.

  DATA:
    lt_lines TYPE ty_t_string,
    lv_line  TYPE string,
    lv_file  TYPE string.

  CLEAR:
    cv_activation_key,
    lt_lines,
    lv_file.

  lv_file = iv_file.

  IF lv_file IS INITIAL.
    MESSAGE 'Informe o arquivo da licença.' TYPE 'E'.
  ENDIF.

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = lv_file
      filetype                = 'ASC'
      read_by_line            = abap_true
    CHANGING
      data_tab                = lt_lines
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.

  IF sy-subrc <> 0.
    MESSAGE 'Não foi possível ler o arquivo da licença.' TYPE 'E'.
  ENDIF.

  IF lt_lines IS INITIAL.
    MESSAGE 'O arquivo da licença está vazio.' TYPE 'E'.
  ENDIF.

  LOOP AT lt_lines INTO lv_line.

    CONCATENATE
      cv_activation_key
      lv_line
      INTO cv_activation_key.

  ENDLOOP.

  PERFORM normalize_activation_key
    CHANGING cv_activation_key.

  IF cv_activation_key IS INITIAL.
    MESSAGE 'O arquivo não contém uma chave de ativação válida.' TYPE 'E'.
  ENDIF.

  IF cv_activation_key NP 'OMS1.*.*'.
    MESSAGE 'O conteúdo do arquivo não possui o formato de licença OMS.' TYPE 'E'.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
* Normalização do token
*---------------------------------------------------------------------*
FORM normalize_activation_key
  CHANGING
    cv_activation_key TYPE string.

  DATA:
    lv_tab TYPE c LENGTH 1,
    lv_cr  TYPE c LENGTH 1,
    lv_lf  TYPE c LENGTH 1.

  lv_tab = cl_abap_char_utilities=>horizontal_tab.
  lv_cr  = cl_abap_char_utilities=>cr_lf+0(1).
  lv_lf  = cl_abap_char_utilities=>newline.

  REPLACE ALL OCCURRENCES OF lv_tab
    IN cv_activation_key
    WITH ''.

  REPLACE ALL OCCURRENCES OF lv_cr
    IN cv_activation_key
    WITH ''.

  REPLACE ALL OCCURRENCES OF lv_lf
    IN cv_activation_key
    WITH ''.

  CONDENSE cv_activation_key NO-GAPS.

ENDFORM.

*---------------------------------------------------------------------*
* Validação criptográfica
*---------------------------------------------------------------------*
FORM validate_license
  USING
    iv_activation_key TYPE string
  CHANGING
    cs_validation
      TYPE /ptloms/cl022=>ty_validation_result.

  CLEAR cs_validation.

*---------------------------------------------------------------------*
* Criar o validador
*
* O construtor de /PTLOMS/CL022 já utiliza ZOMSVFY como padrão.
*---------------------------------------------------------------------*
  CREATE OBJECT go_validator.

  IF go_validator IS NOT BOUND.
    MESSAGE 'Não foi possível criar o serviço de validação.' TYPE 'E'.
  ENDIF.

*---------------------------------------------------------------------*
* Validar somente a licença
*
* Cliente, ambiente e centro são obtidos do payload assinado.
*---------------------------------------------------------------------*
  cs_validation =
    go_validator->validate(
      iv_activation_key = iv_activation_key ).

  IF cs_validation-valid <> abap_true.

    IF cs_validation-message IS INITIAL.
      MESSAGE 'A licença informada é inválida.' TYPE 'E'.
    ELSE.
      MESSAGE cs_validation-message TYPE 'E'.
    ENDIF.

  ENDIF.

*---------------------------------------------------------------------*
* Validações defensivas adicionais
*---------------------------------------------------------------------*
  IF cs_validation-maintenance_plant IS INITIAL.
    MESSAGE 'A licença não contém centro de manutenção.' TYPE 'E'.
  ENDIF.

  IF cs_validation-valid_to IS INITIAL.
    MESSAGE 'A licença não contém data de validade.' TYPE 'E'.
  ENDIF.

  IF cs_validation-license_id IS INITIAL.
    MESSAGE 'A licença não contém identificador GUID.' TYPE 'E'.
  ENDIF.

  IF cs_validation-valid_to < sy-datum.
    MESSAGE 'A licença está expirada.' TYPE 'E'.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
* Preparar estrutura da tabela
*---------------------------------------------------------------------*
FORM prepare_license_record
  USING
    iv_activation_key TYPE string
    is_validation
      TYPE /ptloms/cl022=>ty_validation_result
  CHANGING
    cs_license TYPE /ptloms/tb098.

  DATA:
    ls_existing TYPE /ptloms/tb098.

  CLEAR:
    cs_license,
    ls_existing.

*---------------------------------------------------------------------*
* Verificar se a mesma licença já foi instalada anteriormente
*---------------------------------------------------------------------*
  SELECT SINGLE *
    FROM /ptloms/tb098
    INTO ls_existing
    WHERE werks      = is_validation-maintenance_plant
      AND license_id = is_validation-license_id.

  IF sy-subrc = 0.
    cs_license = ls_existing.
  ENDIF.

*---------------------------------------------------------------------*
* Chave e informações assinadas
*---------------------------------------------------------------------*
  cs_license-mandt          = sy-mandt.
  cs_license-werks          = is_validation-maintenance_plant.
  cs_license-license_id     = is_validation-license_id.
  cs_license-active         = abap_true.

  cs_license-valid_to       = is_validation-valid_to.
  cs_license-customer_id    = is_validation-customer_id.
  cs_license-environment    = is_validation-environment.
  cs_license-product_id     = is_validation-product.
  cs_license-format_version = is_validation-version.
  cs_license-token          = iv_activation_key.

*---------------------------------------------------------------------*
* A versão atual do payload não possui VALID_FROM.
* Consideramos a data de instalação como início operacional.
*---------------------------------------------------------------------*
  IF cs_license-valid_from IS INITIAL.
    cs_license-valid_from = sy-datum.
  ENDIF.

*---------------------------------------------------------------------*
* Auditoria da instalação inicial
*---------------------------------------------------------------------*
  IF ls_existing IS INITIAL.

    cs_license-installed_by = sy-uname.
    cs_license-installed_on = sy-datum.
    cs_license-installed_at = sy-uzeit.

  ENDIF.

*---------------------------------------------------------------------*
* Auditoria da última alteração
*---------------------------------------------------------------------*
  cs_license-changed_by = sy-uname.
  cs_license-changed_on = sy-datum.
  cs_license-changed_at = sy-uzeit.

ENDFORM.

*---------------------------------------------------------------------*
* Confirmação da instalação
*---------------------------------------------------------------------*
FORM confirm_installation
  USING
    is_validation
      TYPE /ptloms/cl022=>ty_validation_result.

  DATA:
    lv_question TYPE string,
    lv_answer   TYPE c LENGTH 1.

  CONCATENATE
    'Instalar a licença do centro'
    is_validation-maintenance_plant
    'com validade até'
    is_validation-valid_to
    '?'
    INTO lv_question
    SEPARATED BY space.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = 'Instalação de licença OMS'
      text_question         = lv_question
      text_button_1         = 'Sim'
      icon_button_1         = 'ICON_OKAY'
      text_button_2         = 'Não'
      icon_button_2         = 'ICON_CANCEL'
      default_button        = '2'
      display_cancel_button = abap_false
    IMPORTING
      answer                = lv_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Não foi possível apresentar a confirmação.' TYPE 'E'.
  ENDIF.

  IF lv_answer <> '1'.
    MESSAGE 'Instalação cancelada pelo usuário.' TYPE 'S'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
* Instalação da licença
*---------------------------------------------------------------------*
FORM install_license
  USING
    is_license TYPE /ptloms/tb098.

  DATA:
    ls_database TYPE /ptloms/tb098,
    lv_werks    TYPE werks_d.

  lv_werks = is_license-werks.

*---------------------------------------------------------------------*
* Bloquear o centro
*---------------------------------------------------------------------*
  PERFORM enqueue_license
    USING lv_werks.

*---------------------------------------------------------------------*
* Verificar novamente a situação após o bloqueio
*---------------------------------------------------------------------*
  CLEAR ls_database.

  SELECT SINGLE *
    FROM /ptloms/tb098
    INTO ls_database
    WHERE werks      = is_license-werks
      AND license_id = is_license-license_id.

*---------------------------------------------------------------------*
* Desativar todas as licenças anteriores do centro
*---------------------------------------------------------------------*
  UPDATE /ptloms/tb098
    SET active     = abap_false
        changed_by = sy-uname
        changed_on = sy-datum
        changed_at = sy-uzeit
    WHERE werks      = is_license-werks
      AND active     = abap_true
      AND license_id <> is_license-license_id.

  IF sy-subrc <> 0 AND sy-subrc <> 4.

    ROLLBACK WORK.

    PERFORM dequeue_license
      USING lv_werks.

    MESSAGE 'Erro ao desativar a licença anterior.' TYPE 'E'.

  ENDIF.

*---------------------------------------------------------------------*
* Inserir ou atualizar a licença
*
* MODIFY utiliza a chave primária da tabela:
* MANDT + WERKS + LICENSE_ID
*---------------------------------------------------------------------*
  MODIFY /ptloms/tb098 FROM is_license.

  IF sy-subrc <> 0.

    ROLLBACK WORK.

    PERFORM dequeue_license
      USING lv_werks.

    MESSAGE 'Erro ao gravar a licença na tabela.' TYPE 'E'.

  ENDIF.

*---------------------------------------------------------------------*
* Confirmar a unidade lógica de trabalho
*---------------------------------------------------------------------*
  COMMIT WORK AND WAIT.

  IF sy-subrc <> 0.

    PERFORM dequeue_license
      USING lv_werks.

    MESSAGE 'A licença foi gravada, mas houve erro no COMMIT WORK.' TYPE 'E'.

  ENDIF.

*---------------------------------------------------------------------*
* Liberar o bloqueio
*---------------------------------------------------------------------*
  PERFORM dequeue_license
    USING lv_werks.

ENDFORM.

*---------------------------------------------------------------------*
* Bloqueio exclusivo por centro
*---------------------------------------------------------------------*
FORM enqueue_license
  USING
    iv_werks TYPE werks_d.

  CALL FUNCTION 'ENQUEUE_/PTLOMS/ELIC'
    EXPORTING
      mandt          = sy-mandt
      werks          = iv_werks
      _scope         = '2'
      _wait          = abap_true
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.

  CASE sy-subrc.

    WHEN 0.
      gv_lock_active = abap_true.

    WHEN 1.
      MESSAGE
        'O centro está sendo atualizado por outro usuário.'
        TYPE 'E'.

    WHEN 2.
      MESSAGE
        'Falha interna ao solicitar o bloqueio da licença.'
        TYPE 'E'.

    WHEN OTHERS.
      MESSAGE
        'Não foi possível bloquear o centro para instalação.'
        TYPE 'E'.

  ENDCASE.

ENDFORM.

*---------------------------------------------------------------------*
* Liberação do bloqueio
*---------------------------------------------------------------------*
FORM dequeue_license
  USING
    iv_werks TYPE werks_d.

  IF gv_lock_active <> abap_true.
    RETURN.
  ENDIF.

  CALL FUNCTION 'DEQUEUE_/PTLOMS/ELIC'
    EXPORTING
      mandt = sy-mandt
      werks = iv_werks.

  gv_lock_active = abap_false.

ENDFORM.

*---------------------------------------------------------------------*
* Resultado
*---------------------------------------------------------------------*
FORM display_result
  USING
    is_validation
      TYPE /ptloms/cl022=>ty_validation_result.

  SKIP 2.

  WRITE:
    / 'Licença OMS instalada com sucesso.'.

  ULINE.

  WRITE:
    / 'Produto..............:', is_validation-product,
    / 'Versão...............:', is_validation-version,
    / 'Cliente..............:', is_validation-customer_id,
    / 'Ambiente.............:', is_validation-environment,
    / 'Centro de manutenção.:', is_validation-maintenance_plant,
    / 'Validade.............:', is_validation-valid_to,
    / 'Dias restantes.......:', is_validation-days_remaining,
    / 'GUID da licença......:', is_validation-license_id.

  ULINE.

  WRITE:
    / 'SSF SUBRC............:', is_validation-ssf_subrc,
    / 'SSF CRC..............:', is_validation-ssf_crc,
    / 'Signatários..........:', is_validation-signer_count,
    / 'Certificados.........:', is_validation-certificate_count.

ENDFORM.
