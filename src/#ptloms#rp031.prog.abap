REPORT /ptloms/rp031
  LINE-SIZE 255
  LINE-COUNT 65.

*---------------------------------------------------------------------*
* Relatório de controle de emissão de licenças OMS
*
* Tabela:
*   /PTLOMS/TB099
*
* Objetivos:
*   - Consultar o histórico de emissão de licenças;
*   - Acompanhar licenças geradas, exportadas e revogadas;
*   - Identificar licenças vencidas ou próximas do vencimento;
*   - Fornecer rastreabilidade para auditoria interna.
*
* Segurança:
*   - O campo TOKEN não é selecionado;
*   - O relatório apresenta somente o hash do token;
*   - Recomenda-se proteger a execução com objeto de autorização.
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* Constantes
*---------------------------------------------------------------------*
CONSTANTS:
  gc_status_generated TYPE /ptloms/ed140 VALUE 'GENERATED',
  gc_status_exported  TYPE /ptloms/ed140 VALUE 'EXPORTED',
  gc_status_revoked   TYPE /ptloms/ed140 VALUE 'REVOKED',

  gc_life_valid       TYPE char20 VALUE 'VALID',
  gc_life_expiring    TYPE char20 VALUE 'EXPIRING',
  gc_life_today       TYPE char20 VALUE 'EXPIRES_TODAY',
  gc_life_expired     TYPE char20 VALUE 'EXPIRED',
  gc_life_revoked     TYPE char20 VALUE 'REVOKED',
  gc_life_inactive    TYPE char20 VALUE 'INACTIVE',
  gc_life_invalid     TYPE char20 VALUE 'INVALID_DATE',

  gc_icon_red         TYPE char1 VALUE '1',
  gc_icon_yellow      TYPE char1 VALUE '2',
  gc_icon_green       TYPE char1 VALUE '3'.

*---------------------------------------------------------------------*
* Variáveis auxiliares da tela de seleção
*
* Utilizam os elementos de dados diretamente, evitando a referência:
*
*   /PTLOMS/TB099-LICENSE_ID
*
* que apresentou erro de sintaxe no ambiente.
*---------------------------------------------------------------------*
DATA:
  gv_license_id   TYPE sysuuid_c32,
  gv_werks        TYPE werks_d,
  gv_active       TYPE boole_d,
  gv_valid_from   TYPE sydatum,
  gv_valid_to     TYPE sydatum,
  gv_customer_id  TYPE char20,
  gv_environment  TYPE /ptloms/ed139,
  gv_product_id   TYPE char10,
  gv_generated_by TYPE syuname,
  gv_generated_on TYPE sydatum,
  gv_exported_by  TYPE syuname,
  gv_exported_on  TYPE sydatum,
  gv_status       TYPE /ptloms/ed140,
  gv_revoked_by   TYPE syuname,
  gv_revoked_on   TYPE sydatum,
  gv_ssf_appl     TYPE ssfappl.

*---------------------------------------------------------------------*
* Tela de seleção
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01
  WITH FRAME TITLE text-t01.

SELECT-OPTIONS:
  s_licid FOR gv_license_id,
  s_cust  FOR gv_customer_id,
  s_env   FOR gv_environment,
  s_werks FOR gv_werks,
  s_prod  FOR gv_product_id,
  s_stat  FOR gv_status,
  s_activ FOR gv_active.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02
  WITH FRAME TITLE text-t02.

SELECT-OPTIONS:
  s_vfrom FOR gv_valid_from,
  s_vto   FOR gv_valid_to,
  s_guser FOR gv_generated_by,
  s_gdate FOR gv_generated_on,
  s_euser FOR gv_exported_by,
  s_edate FOR gv_exported_on,
  s_ruser FOR gv_revoked_by,
  s_rdate FOR gv_revoked_on,
  s_ssf   FOR gv_ssf_appl.

SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN BEGIN OF BLOCK b03
  WITH FRAME TITLE text-t03.

PARAMETERS:
  p_warn TYPE i DEFAULT 30 OBLIGATORY,
  p_only AS CHECKBOX DEFAULT abap_false.

SELECTION-SCREEN END OF BLOCK b03.

*---------------------------------------------------------------------*
* Estrutura de saída
*---------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_output,

    alert_icon       TYPE char1,
    lifecycle_status TYPE char20,
    days_remaining   TYPE i,
    alert_message    TYPE char255,

    license_id       TYPE sysuuid_c32,
    werks            TYPE werks_d,
    active           TYPE boole_d,
    valid_from       TYPE sydatum,
    valid_to         TYPE sydatum,
    customer_id      TYPE char20,
    environment      TYPE /ptloms/ed139,
    product_id       TYPE char10,
    format_version   TYPE char2,

    generated_by     TYPE syuname,
    generated_on     TYPE sydatum,
    generated_at     TYPE syuzeit,

    exported_by      TYPE syuname,
    exported_on      TYPE sydatum,
    exported_at      TYPE syuzeit,

    status           TYPE /ptloms/ed140,
    token_hash       TYPE char64,
    file_name        TYPE char128,

    revoked_by       TYPE syuname,
    revoked_on       TYPE sydatum,
    revoked_at       TYPE syuzeit,
    revoke_reason    TYPE string,

    ssf_application  TYPE ssfappl,
    ssf_profile_id   TYPE char255,
    ssf_crc          TYPE int4,
    signature_length TYPE int4,

  END OF ty_output.

TYPES:
  ty_t_output TYPE STANDARD TABLE OF ty_output
              WITH DEFAULT KEY.

*---------------------------------------------------------------------*
* Dados globais
*---------------------------------------------------------------------*
DATA:
  gt_output TYPE ty_t_output,
  gs_output TYPE ty_output,

  go_alv    TYPE REF TO cl_salv_table.

*---------------------------------------------------------------------*
* Validação da tela
*---------------------------------------------------------------------*
AT SELECTION-SCREEN.

  PERFORM validate_selection_screen.

*---------------------------------------------------------------------*
* Processamento principal
*---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM check_authorization.
  PERFORM select_data.

  IF gt_output IS INITIAL.

    MESSAGE
      'Nenhuma emissão de licença foi encontrada.'
      TYPE 'S'
      DISPLAY LIKE 'E'.

    RETURN.

  ENDIF.

  PERFORM calculate_lifecycle.
  PERFORM apply_calculated_filters.

  IF gt_output IS INITIAL.

    MESSAGE
      'Nenhuma licença atende aos critérios de alerta informados.'
      TYPE 'S'
      DISPLAY LIKE 'E'.

    RETURN.

  ENDIF.

  PERFORM display_alv.

*---------------------------------------------------------------------*
* Validar parâmetros
*---------------------------------------------------------------------*
FORM validate_selection_screen.

  IF p_warn < 0.

    MESSAGE
      'A quantidade de dias para alerta não pode ser negativa.'
      TYPE 'E'.

  ENDIF.

  IF p_warn > 3650.

    MESSAGE
      'A quantidade de dias para alerta não pode exceder 3650.'
      TYPE 'E'.

  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
* Verificação de autorização
*---------------------------------------------------------------------*
FORM check_authorization.

*---------------------------------------------------------------------*
* Recomendação:
*
* Criar na SU21 o objeto:
*
*   ZOMS_LIC
*
* Campo:
*
*   ACTVT
*
* Valor:
*
*   03 = Exibir relatório de emissão de licenças
*
* Após criar o objeto e atribuí-lo às funções, habilitar:
*---------------------------------------------------------------------*
*
* AUTHORITY-CHECK OBJECT 'ZOMS_LIC'
*   ID 'ACTVT' FIELD '03'.
*
* IF sy-subrc <> 0.
*
*   MESSAGE
*     'Usuário não autorizado a consultar emissões OMS.'
*     TYPE 'E'.
*
* ENDIF.

ENDFORM.

* IA - IuryFSilva - Pontual - 20.07.2026 - Retrofit Solar
FORM select_data.

  REFRESH gt_output.

  SELECT
    license_id
    werks
    active
    valid_from
    valid_to
    customer_id
    environment
    product_id
    format_version
    generated_by
    generated_on
    generated_at
    exported_by
    exported_on
    exported_at
    status
    token_hash
    file_name
    revoked_by
    revoked_on
    revoked_at
    revoke_reason
    ssf_application
    ssf_profile_id
    ssf_crc
    signature_length
    INTO CORRESPONDING FIELDS OF TABLE gt_output
    FROM /ptloms/tb099
    WHERE license_id      IN s_licid
      AND customer_id     IN s_cust
      AND environment     IN s_env
      AND werks           IN s_werks
      AND product_id      IN s_prod
      AND status          IN s_stat
      AND active          IN s_activ
      AND valid_from      IN s_vfrom
      AND valid_to        IN s_vto
      AND generated_by    IN s_guser
      AND generated_on    IN s_gdate
      AND exported_by     IN s_euser
      AND exported_on     IN s_edate
      AND revoked_by      IN s_ruser
      AND revoked_on      IN s_rdate
      AND ssf_application IN s_ssf.

  IF sy-subrc <> 0.
    REFRESH gt_output.
  ENDIF.

ENDFORM.
****---------------------------------------------------------------------*
**** Selecionar dados
****---------------------------------------------------------------------*
***FORM select_data.
***
***  CLEAR gt_output.
***
****---------------------------------------------------------------------*
**** O campo TOKEN não é selecionado intencionalmente.
****
**** O campo TOKEN_HASH pode ser apresentado para auditoria e validação
**** sem expor a chave de ativação completa.
****---------------------------------------------------------------------*
***  SELECT
***    license_id
***    werks
***    active
***    valid_from
***    valid_to
***    customer_id
***    environment
***    product_id
***    format_version
***    generated_by
***    generated_on
***    generated_at
***    exported_by
***    exported_on
***    exported_at
***    status
***    token_hash
***    file_name
***    revoked_by
***    revoked_on
***    revoked_at
***    revoke_reason
***    ssf_application
***    ssf_profile_id
***    ssf_crc
***    signature_length
***    INTO CORRESPONDING FIELDS OF TABLE gt_output
***    FROM /ptloms/tb099
***    WHERE license_id      IN s_licid
***      AND customer_id     IN s_cust
***      AND environment     IN s_env
***      AND werks           IN s_werks
***      AND product_id      IN s_prod
***      AND status          IN s_stat
***      AND active          IN s_activ
***      AND valid_from      IN s_vfrom
***      AND valid_to        IN s_vto
***      AND generated_by    IN s_guser
***      AND generated_on    IN s_gdate
***      AND exported_by     IN s_euser
***      AND exported_on     IN s_edate
***      AND revoked_by      IN s_ruser
***      AND revoked_on      IN s_rdate
***      AND ssf_application IN s_ssf.
***
***  IF sy-subrc <> 0.
***    CLEAR gt_output.
***  ENDIF.
***
***ENDFORM.
* FA - IuryFSilva - Pontual - 20.07.2026 - Retrofit Solar


*---------------------------------------------------------------------*
* Calcular situação atual da licença
*---------------------------------------------------------------------*
FORM calculate_lifecycle.

  FIELD-SYMBOLS:
    <ls_output> TYPE ty_output.

  DATA:
    lv_date_text TYPE char10,
    lv_days_text TYPE char12.

  LOOP AT gt_output ASSIGNING <ls_output>.

    CLEAR:
      <ls_output>-alert_icon,
      <ls_output>-lifecycle_status,
      <ls_output>-days_remaining,
      <ls_output>-alert_message,
      lv_date_text,
      lv_days_text.

*-------------------------------------------------------------------*
* Licença revogada
*
* A revogação prevalece sobre validade, status de exportação e flag
* ACTIVE.
*-------------------------------------------------------------------*
    IF <ls_output>-status = gc_status_revoked.

      <ls_output>-alert_icon       = gc_icon_red.
      <ls_output>-lifecycle_status = gc_life_revoked.

      CONCATENATE
        'A licença do centro'
        <ls_output>-werks
        'está revogada.'
        INTO <ls_output>-alert_message
        SEPARATED BY space.

      CONTINUE.

    ENDIF.

*-------------------------------------------------------------------*
* Licença inativa
*-------------------------------------------------------------------*
    IF <ls_output>-active IS INITIAL.

      <ls_output>-alert_icon       = gc_icon_red.
      <ls_output>-lifecycle_status = gc_life_inactive.

      CONCATENATE
        'A licença do centro'
        <ls_output>-werks
        'está inativa.'
        INTO <ls_output>-alert_message
        SEPARATED BY space.

      CONTINUE.

    ENDIF.

*-------------------------------------------------------------------*
* Data de validade inválida ou ausente
*-------------------------------------------------------------------*
    IF <ls_output>-valid_to IS INITIAL.

      <ls_output>-alert_icon       = gc_icon_red.
      <ls_output>-lifecycle_status = gc_life_invalid.
      <ls_output>-alert_message =
        'A licença não possui uma data final de validade.'.

      CONTINUE.

    ENDIF.

    PERFORM format_date
      USING    <ls_output>-valid_to
      CHANGING lv_date_text.

*-------------------------------------------------------------------*
* Diferença de datas em dias
*-------------------------------------------------------------------*
    <ls_output>-days_remaining =
      <ls_output>-valid_to - sy-datum.

    WRITE <ls_output>-days_remaining
      TO lv_days_text.

    CONDENSE lv_days_text NO-GAPS.

*-------------------------------------------------------------------*
* Licença vencida
*-------------------------------------------------------------------*
    IF <ls_output>-days_remaining < 0.

      <ls_output>-alert_icon       = gc_icon_red.
      <ls_output>-lifecycle_status = gc_life_expired.

      CONCATENATE
        'A licença do centro'
        <ls_output>-werks
        'venceu em'
        lv_date_text
        '.'
        INTO <ls_output>-alert_message
        SEPARATED BY space.

      CONTINUE.

    ENDIF.

*-------------------------------------------------------------------*
* Licença vence hoje
*-------------------------------------------------------------------*
    IF <ls_output>-days_remaining = 0.

      <ls_output>-alert_icon       = gc_icon_red.
      <ls_output>-lifecycle_status = gc_life_today.

      CONCATENATE
        'A licença do centro'
        <ls_output>-werks
        'vence hoje.'
        INTO <ls_output>-alert_message
        SEPARATED BY space.

      CONTINUE.

    ENDIF.

*-------------------------------------------------------------------*
* Licença vence amanhã
*-------------------------------------------------------------------*
    IF <ls_output>-days_remaining = 1.

      <ls_output>-alert_icon       = gc_icon_yellow.
      <ls_output>-lifecycle_status = gc_life_expiring.

      CONCATENATE
        'Falta 1 dia para o vencimento da licença do centro'
        <ls_output>-werks
        'em'
        lv_date_text
        '.'
        INTO <ls_output>-alert_message
        SEPARATED BY space.

      CONTINUE.

    ENDIF.

*-------------------------------------------------------------------*
* Licença dentro da janela de alerta
*-------------------------------------------------------------------*
    IF <ls_output>-days_remaining <= p_warn.

      <ls_output>-alert_icon       = gc_icon_yellow.
      <ls_output>-lifecycle_status = gc_life_expiring.

      CONCATENATE
        'Faltam'
        lv_days_text
        'dias para o vencimento da licença do centro'
        <ls_output>-werks
        'em'
        lv_date_text
        '.'
        INTO <ls_output>-alert_message
        SEPARATED BY space.

      CONTINUE.

    ENDIF.

*-------------------------------------------------------------------*
* Licença válida
*-------------------------------------------------------------------*
    <ls_output>-alert_icon       = gc_icon_green.
    <ls_output>-lifecycle_status = gc_life_valid.

    CONCATENATE
      'Licença válida até'
      lv_date_text
      '. Dias restantes:'
      lv_days_text
      INTO <ls_output>-alert_message
      SEPARATED BY space.

  ENDLOOP.

ENDFORM.

*---------------------------------------------------------------------*
* Aplicar filtro calculado
*---------------------------------------------------------------------*
FORM apply_calculated_filters.

  IF p_only = abap_false.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* Quando P_ONLY estiver marcado, manter apenas registros que exigem
* atenção operacional ou administrativa.
*---------------------------------------------------------------------*
  DELETE gt_output
    WHERE lifecycle_status = gc_life_valid.

ENDFORM.

*---------------------------------------------------------------------*
* Formatar data no padrão DD/MM/AAAA
*---------------------------------------------------------------------*
FORM format_date
  USING
    iv_date TYPE sydatum
  CHANGING
    cv_text TYPE char10.

  CLEAR cv_text.

  IF iv_date IS INITIAL.
    RETURN.
  ENDIF.

  CONCATENATE
    iv_date+6(2)
    iv_date+4(2)
    iv_date(4)
    INTO cv_text
    SEPARATED BY '/'.

ENDFORM.

* IA - IuryFSilva - Pontual - 20.07.2026 - Retrofit Solar
FORM display_alv.

  DATA:
    lx_salv    TYPE REF TO cx_salv_msg,
    lv_message TYPE string.

  TRY.

      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_output.

      PERFORM configure_alv.
      PERFORM configure_columns.
      PERFORM configure_sorts.

      CALL METHOD go_alv->display.

    CATCH cx_salv_msg INTO lx_salv.

      lv_message = lx_salv->get_text( ).

      MESSAGE lv_message
        TYPE 'S'
        DISPLAY LIKE 'E'.

  ENDTRY.

ENDFORM.
****---------------------------------------------------------------------*
**** Exibir ALV
****---------------------------------------------------------------------*
***FORM display_alv.
***
***  DATA:
***    lx_salv TYPE REF TO cx_salv_msg.
***
***  TRY.
***
***      cl_salv_table=>factory(
***        IMPORTING
***          r_salv_table = go_alv
***        CHANGING
***          t_table      = gt_output ).
***
***      PERFORM configure_alv.
***      PERFORM configure_columns.
***      PERFORM configure_sorts.
***
***      go_alv->display( ).
***
***    CATCH cx_salv_msg INTO lx_salv.
***
***      MESSAGE lx_salv->get_text( )
***        TYPE 'S'
***        DISPLAY LIKE 'E'.
***
***  ENDTRY.
***
***ENDFORM.
* FA - IuryFSilva - Pontual - 20.07.2026 - Retrofit Solar


*---------------------------------------------------------------------*
* Configurar ALV
*---------------------------------------------------------------------*
FORM configure_alv.

  DATA:
    lo_functions  TYPE REF TO cl_salv_functions_list,
    lo_display    TYPE REF TO cl_salv_display_settings,
    lo_columns    TYPE REF TO cl_salv_columns_table,
    lo_layout     TYPE REF TO cl_salv_layout,
    ls_layout_key TYPE salv_s_layout_key,
    lv_header     TYPE lvc_title,
    lv_count      TYPE i,
    lv_count_text TYPE char12.

*-------------------------------------------------------------------*
* Funções standard
*-------------------------------------------------------------------*
  lo_functions = go_alv->get_functions( ).

  lo_functions->set_all(
    value = abap_true ).

*-------------------------------------------------------------------*
* Configuração visual
*-------------------------------------------------------------------*
  lo_display = go_alv->get_display_settings( ).

  lo_display->set_striped_pattern(
    value = abap_true ).

  DESCRIBE TABLE gt_output
    LINES lv_count.

  WRITE lv_count TO lv_count_text.
  CONDENSE lv_count_text NO-GAPS.

  CONCATENATE
    'Controle de emissão de licenças OMS - Registros:'
    lv_count_text
    INTO lv_header
    SEPARATED BY space.

  lo_display->set_list_header(
    value = lv_header ).

*-------------------------------------------------------------------*
* Colunas
*-------------------------------------------------------------------*
  lo_columns = go_alv->get_columns( ).

  lo_columns->set_optimize(
    value = abap_true ).

*-------------------------------------------------------------------*
* Semáforo:
*
*   1 = vermelho
*   2 = amarelo
*   3 = verde
*-------------------------------------------------------------------*
  TRY.

      lo_columns->set_exception_column(
        value = 'ALERT_ICON' ).

    CATCH cx_salv_data_error.
*-------------------------------------------------------------------*
* A ausência do semáforo não deve impedir a execução do relatório.
*-------------------------------------------------------------------*
  ENDTRY.

*-------------------------------------------------------------------*
* Layout e variantes
*-------------------------------------------------------------------*
  lo_layout = go_alv->get_layout( ).

  ls_layout_key-report = sy-repid.

  lo_layout->set_key(
    value = ls_layout_key ).

  lo_layout->set_save_restriction(
    value = if_salv_c_layout=>restrict_none ).

  lo_layout->set_default(
    value = abap_true ).

ENDFORM.

*---------------------------------------------------------------------*
* Configurar textos das colunas
*---------------------------------------------------------------------*
FORM configure_columns.

  PERFORM set_column_text
    USING 'LIFECYCLE_STATUS'
          'Situação'
          'Situação atual'
          'Situação atual calculada'.

  PERFORM set_column_text
    USING 'DAYS_REMAINING'
          'Dias'
          'Dias restantes'
          'Quantidade de dias restantes'.

  PERFORM set_column_text
    USING 'ALERT_MESSAGE'
          'Mensagem'
          'Mensagem'
          'Mensagem de validade da licença'.

  PERFORM set_column_text
    USING 'LICENSE_ID'
          'Licença'
          'ID licença'
          'Identificador único da licença'.

  PERFORM set_column_text
    USING 'CUSTOMER_ID'
          'Cliente'
          'Cliente'
          'Identificador do cliente'.

  PERFORM set_column_text
    USING 'ENVIRONMENT'
          'Amb.'
          'Ambiente'
          'Ambiente da licença'.

  PERFORM set_column_text
    USING 'WERKS'
          'Centro'
          'Centro'
          'Centro de manutenção'.

  PERFORM set_column_text
    USING 'ACTIVE'
          'Ativa'
          'Licença ativa'
          'Indicador de licença ativa'.

  PERFORM set_column_text
    USING 'PRODUCT_ID'
          'Produto'
          'Produto'
          'Identificador do produto'.

  PERFORM set_column_text
    USING 'FORMAT_VERSION'
          'Versão'
          'Versão formato'
          'Versão do formato do token'.

  PERFORM set_column_text
    USING 'VALID_FROM'
          'Início'
          'Válida desde'
          'Data inicial de validade'.

  PERFORM set_column_text
    USING 'VALID_TO'
          'Vencimento'
          'Vencimento'
          'Data final de validade'.

  PERFORM set_column_text
    USING 'STATUS'
          'Status'
          'Status gravado'
          'Status persistido da emissão'.

  PERFORM set_column_text
    USING 'GENERATED_BY'
          'Gerado por'
          'Gerado por'
          'Usuário responsável pela geração'.

  PERFORM set_column_text
    USING 'GENERATED_ON'
          'Dt.geração'
          'Data geração'
          'Data de geração da licença'.

  PERFORM set_column_text
    USING 'GENERATED_AT'
          'Hr.geração'
          'Hora geração'
          'Hora de geração da licença'.

  PERFORM set_column_text
    USING 'EXPORTED_BY'
          'Exportado'
          'Exportado por'
          'Usuário responsável pela exportação'.

  PERFORM set_column_text
    USING 'EXPORTED_ON'
          'Dt.export.'
          'Data exportação'
          'Data da exportação do arquivo'.

  PERFORM set_column_text
    USING 'EXPORTED_AT'
          'Hr.export.'
          'Hora exportação'
          'Hora da exportação do arquivo'.

  PERFORM set_column_text
    USING 'FILE_NAME'
          'Arquivo'
          'Nome arquivo'
          'Nome do arquivo exportado'.

  PERFORM set_column_text
    USING 'REVOKED_BY'
          'Revogado'
          'Revogado por'
          'Usuário responsável pela revogação'.

  PERFORM set_column_text
    USING 'REVOKED_ON'
          'Dt.revog.'
          'Data revogação'
          'Data da revogação da licença'.

  PERFORM set_column_text
    USING 'REVOKED_AT'
          'Hr.revog.'
          'Hora revogação'
          'Hora da revogação da licença'.

  PERFORM set_column_text
    USING 'REVOKE_REASON'
          'Motivo'
          'Motivo revogação'
          'Motivo informado para a revogação'.

  PERFORM set_column_text
    USING 'TOKEN_HASH'
          'Hash'
          'Hash token'
          'Hash SHA do token da licença'.

  PERFORM set_column_text
    USING 'SSF_APPLICATION'
          'SSF'
          'Aplicação SSF'
          'Aplicação SSF utilizada na assinatura'.

  PERFORM set_column_text
    USING 'SSF_PROFILE_ID'
          'Perfil SSF'
          'Perfil SSF'
          'Identificador do perfil SSF'.

  PERFORM set_column_text
    USING 'SSF_CRC'
          'SSF CRC'
          'SSF CRC'
          'Código de retorno criptográfico SSF'.

  PERFORM set_column_text
    USING 'SIGNATURE_LENGTH'
          'Tam.ass.'
          'Tam. assinatura'
          'Tamanho da assinatura digital'.

ENDFORM.

*---------------------------------------------------------------------*
* Definir textos de uma coluna
*---------------------------------------------------------------------*
FORM set_column_text
  USING
    iv_column TYPE lvc_fname
    iv_short  TYPE scrtext_s
    iv_medium TYPE scrtext_m
    iv_long   TYPE scrtext_l.

  DATA:
    lo_columns TYPE REF TO cl_salv_columns_table,
    lo_column  TYPE REF TO cl_salv_column_table.

  TRY.

      lo_columns = go_alv->get_columns( ).

      lo_column ?=
        lo_columns->get_column(
          columnname = iv_column ).

      lo_column->set_short_text(
        value = iv_short ).

      lo_column->set_medium_text(
        value = iv_medium ).

      lo_column->set_long_text(
        value = iv_long ).

    CATCH cx_salv_not_found.
*-------------------------------------------------------------------*
* Uma coluna ausente não deve interromper o relatório.
*-------------------------------------------------------------------*
  ENDTRY.

ENDFORM.

*---------------------------------------------------------------------*
* Configurar ordenação inicial
*---------------------------------------------------------------------*
FORM configure_sorts.

  DATA:
    lo_sorts TYPE REF TO cl_salv_sorts.

  TRY.

      lo_sorts = go_alv->get_sorts( ).

*-------------------------------------------------------------------*
* Situação calculada
*-------------------------------------------------------------------*
      lo_sorts->add_sort(
        columnname = 'LIFECYCLE_STATUS'
        position   = 1
        sequence   = if_salv_c_sort=>sort_up
        subtotal   = abap_false ).

*-------------------------------------------------------------------*
* Data de vencimento
*-------------------------------------------------------------------*
      lo_sorts->add_sort(
        columnname = 'VALID_TO'
        position   = 2
        sequence   = if_salv_c_sort=>sort_up
        subtotal   = abap_false ).

*-------------------------------------------------------------------*
* Cliente
*-------------------------------------------------------------------*
      lo_sorts->add_sort(
        columnname = 'CUSTOMER_ID'
        position   = 3
        sequence   = if_salv_c_sort=>sort_up
        subtotal   = abap_false ).

*-------------------------------------------------------------------*
* Centro
*-------------------------------------------------------------------*
      lo_sorts->add_sort(
        columnname = 'WERKS'
        position   = 4
        sequence   = if_salv_c_sort=>sort_up
        subtotal   = abap_false ).

    CATCH cx_salv_existing.
    CATCH cx_salv_not_found.
    CATCH cx_salv_data_error.
  ENDTRY.

ENDFORM.
