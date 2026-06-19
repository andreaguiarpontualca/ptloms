REPORT /ptloms/rp011.

PARAMETERS:
  p_app   TYPE /ptloms/tb081-aplicacao OBLIGATORY,
  p_prov  TYPE /ptloms/tb081-provider,
  p_model TYPE /ptloms/tb081-model,
  p_desc  TYPE /ptloms/tb081-descricao,
  p_act   TYPE /ptloms/tb081-active AS CHECKBOX DEFAULT 'X',
  p_dest  TYPE /ptloms/tb081-destination,
  p_temp  TYPE /ptloms/tb081-temperature DEFAULT '0.20',
  p_tok   TYPE /ptloms/tb081-max_tokens DEFAULT 800,
  p_time  TYPE /ptloms/tb081-timeout_seconds DEFAULT 120,
  p_resp  TYPE /ptloms/tb081-response_format DEFAULT 'json_object',
  p_file  TYPE rlgrap-filename.

PARAMETERS:
  p_save RADIOBUTTON GROUP ac DEFAULT 'X',
  p_show RADIOBUTTON GROUP ac,
  p_del  RADIOBUTTON GROUP ac.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  DATA:
    lt_filetable TYPE filetable,
    lv_rc        TYPE i.

  cl_gui_frontend_services=>file_open_dialog(
    EXPORTING
      window_title      = 'Selecione o arquivo TXT do system prompt'
      default_extension = 'txt'
      file_filter       = 'Texto (*.txt)|*.txt|Todos (*.*)|*.*'
    CHANGING
      file_table        = lt_filetable
      rc                = lv_rc
    EXCEPTIONS
      OTHERS            = 1 ).

  IF sy-subrc = 0 AND lv_rc > 0.
    READ TABLE lt_filetable INDEX 1 INTO DATA(ls_file).
    IF sy-subrc = 0.
      p_file = ls_file-filename.
    ENDIF.
  ENDIF.

START-OF-SELECTION.

  DATA:
    ls_cfg       TYPE /ptloms/tb081,
    ls_old       TYPE /ptloms/tb081,
    lv_prompt    TYPE string,
    lt_lines     TYPE STANDARD TABLE OF string,
    lv_file      TYPE string,
    lv_timestamp TYPE timestampl.

  GET TIME STAMP FIELD lv_timestamp.

  IF p_show = abap_true.

    SELECT SINGLE *
      FROM /ptloms/tb081
      INTO @ls_cfg
      WHERE aplicacao = @p_app.

    IF sy-subrc <> 0.
      WRITE: / 'Configuração não encontrada:', p_app.
      RETURN.
    ENDIF.

    FORMAT COLOR COL_HEADING.
    WRITE: / 'CONFIGURAÇÃO IA'.
    FORMAT RESET.
    ULINE.

    WRITE: / 'Aplicação.......:', ls_cfg-aplicacao.
    WRITE: / 'Provider........:', ls_cfg-provider.
    WRITE: / 'Model...........:', ls_cfg-model.
    WRITE: / 'Descrição.......:', ls_cfg-descricao.
    WRITE: / 'Ativo...........:', ls_cfg-active.
    WRITE: / 'Destination.....:', ls_cfg-destination.
    WRITE: / 'Temperature.....:', ls_cfg-temperature.
    WRITE: / 'Max Tokens......:', ls_cfg-max_tokens.
    WRITE: / 'Timeout.........:', ls_cfg-timeout_seconds.
    WRITE: / 'Response Format.:', ls_cfg-response_format.
    WRITE: / 'Criado por......:', ls_cfg-created_by.
    WRITE: / 'Alterado por....:', ls_cfg-changed_by.
    ULINE.
    WRITE: / 'System Prompt:'.
    WRITE: / ls_cfg-system_prompt.

    RETURN.

  ENDIF.

  IF p_del = abap_true.

    DELETE FROM /ptloms/tb081
      WHERE aplicacao = @p_app.

    IF sy-subrc = 0.
      COMMIT WORK.
      WRITE: / 'Configuração excluída:', p_app.
    ELSE.
      ROLLBACK WORK.
      WRITE: / 'Configuração não encontrada para exclusão:', p_app.
    ENDIF.

    RETURN.

  ENDIF.

  IF p_save = abap_true.

    IF p_file IS NOT INITIAL.

      lv_file = p_file.

      cl_gui_frontend_services=>gui_upload(
        EXPORTING
          filename = lv_file
          filetype = 'ASC'
        CHANGING
          data_tab = lt_lines
        EXCEPTIONS
          OTHERS   = 1 ).

      IF sy-subrc <> 0.
        WRITE: / 'Erro ao carregar arquivo de prompt:', p_file.
        RETURN.
      ENDIF.

      CONCATENATE LINES OF lt_lines INTO lv_prompt
        SEPARATED BY cl_abap_char_utilities=>newline.

    ENDIF.

    SELECT SINGLE *
      FROM /ptloms/tb081
      INTO @ls_old
      WHERE aplicacao = @p_app.

    DATA(lv_exists) = xsdbool( sy-subrc = 0 ).

    CLEAR ls_cfg.

    ls_cfg-aplicacao       = p_app.
    ls_cfg-provider        = p_prov.
    ls_cfg-model           = p_model.
    ls_cfg-descricao       = p_desc.
    ls_cfg-active          = p_act.
    ls_cfg-destination     = p_dest.
    ls_cfg-temperature     = p_temp.
    ls_cfg-max_tokens      = p_tok.
    ls_cfg-timeout_seconds = p_time.
    ls_cfg-response_format = p_resp.
    ls_cfg-changed_by      = sy-uname.
    ls_cfg-changed_at      = lv_timestamp.

    IF lv_prompt IS NOT INITIAL.
      ls_cfg-system_prompt = lv_prompt.
    ELSEIF lv_exists = abap_true.
      ls_cfg-system_prompt = ls_old-system_prompt.
    ENDIF.

    IF lv_exists = abap_true.
      ls_cfg-created_by = ls_old-created_by.
      ls_cfg-created_at = ls_old-created_at.
    ELSE.
      ls_cfg-created_by = sy-uname.
      ls_cfg-created_at = lv_timestamp.
    ENDIF.

    MODIFY /ptloms/tb081 FROM ls_cfg.

    IF sy-subrc = 0.
      COMMIT WORK.
      WRITE: / 'Configuração gravada com sucesso:', p_app.
    ELSE.
      ROLLBACK WORK.
      WRITE: / 'Erro ao gravar configuração:', p_app.
    ENDIF.

  ENDIF.
