REPORT /ptloms/rp012.

PARAMETERS:
  p_prov TYPE /ptloms/tb082-provider OBLIGATORY,
  p_desc TYPE /ptloms/tb082-descricao,
  p_act  TYPE /ptloms/tb082-active AS CHECKBOX DEFAULT 'X',
  p_file TYPE rlgrap-filename.

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
      window_title      = 'Selecione o arquivo TXT com a API Key'
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
    ls_cfg       TYPE /ptloms/tb082,
    ls_old       TYPE /ptloms/tb082,
    lv_api_key   TYPE string,
    lt_lines     TYPE STANDARD TABLE OF string,
    lv_file      TYPE string,
    lv_timestamp TYPE timestampl,
    lv_masked    TYPE string,
    lv_len       TYPE i,
    lv_keep      TYPE i,
    lv_exists    TYPE abap_bool.

  GET TIME STAMP FIELD lv_timestamp.

  IF p_show = abap_true.

    SELECT SINGLE *
      FROM /ptloms/tb082
      INTO @ls_cfg
      WHERE provider = @p_prov.

    IF sy-subrc <> 0.
      WRITE: / 'Credencial não encontrada:', p_prov.
      RETURN.
    ENDIF.

    lv_len = strlen( ls_cfg-api_key ).

    IF lv_len > 8.
      lv_keep = lv_len - 4.
      lv_masked = ls_cfg-api_key.
      REPLACE SECTION OFFSET 4 LENGTH lv_keep OF lv_masked WITH '****'.
    ELSEIF lv_len > 0.
      lv_masked = '****'.
    ELSE.
      CLEAR lv_masked.
    ENDIF.

    FORMAT COLOR COL_HEADING.
    WRITE: / 'CREDENCIAL IA'.
    FORMAT RESET.
    ULINE.

    WRITE: / 'Provider.....:', ls_cfg-provider.
    WRITE: / 'Descrição....:', ls_cfg-descricao.
    WRITE: / 'Ativo........:', ls_cfg-active.
    WRITE: / 'API Key......:', lv_masked.
    WRITE: / 'Criado por...:', ls_cfg-created_by.
    WRITE: / 'Criado em....:', ls_cfg-created_at.
    WRITE: / 'Alterado por.:', ls_cfg-changed_by.
    WRITE: / 'Alterado em..:', ls_cfg-changed_at.

    RETURN.

  ENDIF.

  IF p_del = abap_true.

    DELETE FROM /ptloms/tb082
      WHERE provider = @p_prov.

    IF sy-subrc = 0.
      COMMIT WORK.
      WRITE: / 'Credencial excluída:', p_prov.
    ELSE.
      ROLLBACK WORK.
      WRITE: / 'Credencial não encontrada para exclusão:', p_prov.
    ENDIF.

    RETURN.

  ENDIF.

  IF p_save = abap_true.

    SELECT SINGLE *
      FROM /ptloms/tb082
      INTO @ls_old
      WHERE provider = @p_prov.

    lv_exists = xsdbool( sy-subrc = 0 ).

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
        WRITE: / 'Erro ao carregar arquivo da API Key:', p_file.
        RETURN.
      ENDIF.

      CONCATENATE LINES OF lt_lines INTO lv_api_key.

      CONDENSE lv_api_key NO-GAPS.

    ELSEIF lv_exists = abap_true.

      lv_api_key = ls_old-api_key.

    ENDIF.

    IF lv_api_key IS INITIAL.
      WRITE: / 'API Key não informada. Selecione um arquivo TXT ou mantenha um registro existente.'.
      RETURN.
    ENDIF.

    CLEAR ls_cfg.

    ls_cfg-provider   = p_prov.
    ls_cfg-descricao  = p_desc.
    ls_cfg-active     = p_act.
    ls_cfg-api_key    = lv_api_key.
    ls_cfg-changed_by = sy-uname.
    ls_cfg-changed_at = lv_timestamp.

    IF lv_exists = abap_true.
      ls_cfg-created_by = ls_old-created_by.
      ls_cfg-created_at = ls_old-created_at.
    ELSE.
      ls_cfg-created_by = sy-uname.
      ls_cfg-created_at = lv_timestamp.
    ENDIF.

    MODIFY /ptloms/tb082 FROM ls_cfg.

    IF sy-subrc = 0.
      COMMIT WORK.

      lv_len = strlen( lv_api_key ).

      IF lv_len > 8.
        lv_keep = lv_len - 4.
        lv_masked = lv_api_key.
        REPLACE SECTION OFFSET 4 LENGTH lv_keep OF lv_masked WITH '****'.
      ELSE.
        lv_masked = '****'.
      ENDIF.

      WRITE: / 'Credencial gravada com sucesso:', p_prov.
      WRITE: / 'API Key:', lv_masked.
    ELSE.
      ROLLBACK WORK.
      WRITE: / 'Erro ao gravar credencial:', p_prov.
    ENDIF.

  ENDIF.
