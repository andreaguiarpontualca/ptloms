class /PTLOMS/CL029 definition
  public
  final
  create public .

public section.

  types:
    tt_werks TYPE RANGE OF viaufks-werks .
  types:
    tt_auart      TYPE RANGE OF viaufks-auart .
  types:
    tt_usuperfil TYPE RANGE OF /ptloms/tb013-usuario .
  types:
    tt_eqtyp TYPE RANGE OF equi-eqtyp .
  types:
    tt_fltyp TYPE RANGE OF fltyp .
  types:
    BEGIN OF ty_destinatario,
        usuario     TYPE /ptloms/tb013-usuario,
        email_ativo TYPE /ptloms/tb103-email,
        whats_ativo TYPE /ptloms/tb103-whatsapp,
      END OF ty_destinatario .
  types:
    tt_destinatario TYPE STANDARD TABLE OF ty_destinatario WITH DEFAULT KEY .
  types:
    tt_tb105 TYPE STANDARD TABLE OF /ptloms/tb105 WITH DEFAULT KEY .
  types:
    BEGIN OF ty_notificacao,
        id_notificacao   TYPE /ptloms/ed154,
        tipo_notificacao TYPE /ptloms/ed144,
        tipo_evento      TYPE /ptloms/ed143,
        tipo_documento   TYPE /ptloms/ed155,
        documento        TYPE /ptloms/ed156,
        item_documento   TYPE /ptloms/ed157,
        ordem            TYPE /ptloms/tb104-ordem,
        operacao         TYPE /ptloms/tb104-operacao,
        tipo_objeto      TYPE /ptloms/ed142,
        objeto           TYPE /ptloms/ed158,
        id_lista         TYPE /ptloms/ed152,
        titulo           TYPE /ptloms/ed159,
        mensagem         TYPE /ptloms/ed160,
        data_criacao     TYPE /ptloms/tb104-data_criacao,
        hora_criacao     TYPE /ptloms/tb104-hora_criacao,
        lido             TYPE /ptloms/ed163,
        data_leitura     TYPE /ptloms/tb105-data_leitura,
        hora_leitura     TYPE /ptloms/tb105-hora_leitura,
      END OF ty_notificacao .
  types:
    tt_notificacao TYPE STANDARD TABLE OF ty_notificacao WITH DEFAULT KEY .
  types:
    BEGIN OF ty_pendente,
        id_notificacao   TYPE /ptloms/ed154,
        usuario          TYPE /ptloms/tb013-usuario,
        email            TYPE /ptloms/tb105-email,
        status_email     TYPE /ptloms/ed145,
        tent_email       TYPE /ptloms/ed161,
        tipo_notificacao TYPE /ptloms/ed144,
        titulo           TYPE /ptloms/ed159,
        mensagem         TYPE /ptloms/ed160,
      END OF ty_pendente .
  types:
    tt_pendente TYPE STANDARD TABLE OF ty_pendente WITH DEFAULT KEY .
  types:
    BEGIN OF ty_log,
             id_notificacao TYPE /ptloms/ed154,
             usuario        TYPE /ptloms/tb013-usuario,
             status         TYPE /ptloms/ed145,
             mensagem       TYPE /ptloms/ed162,
           END OF ty_log .
  types:
    tt_log TYPE STANDARD TABLE OF ty_log WITH DEFAULT KEY .

  constants C_TIPO_ALERTA type /PTLOMS/ED144 value 'A'. "#EC NOTEXT
  constants C_TIPO_DESPACHO type /PTLOMS/ED144 value 'D'. "#EC NOTEXT
  constants C_STATUS_PENDENTE type /PTLOMS/ED145 value 'P'. "#EC NOTEXT
  constants C_STATUS_SUCESSO type /PTLOMS/ED145 value 'S'. "#EC NOTEXT
  constants C_STATUS_ERRO type /PTLOMS/ED145 value 'E'. "#EC NOTEXT
  constants C_STATUS_NA type /PTLOMS/ED145 value 'N'. "#EC NOTEXT
  constants C_MAX_TENT_EMAIL type I value 3. "#EC NOTEXT
  constants C_SNRO type INRI-OBJECT value '/PTLOMS/NF'. "#EC NOTEXT

  class-methods REGISTRAR
    importing
      !IS_NOTIFICACAO type /PTLOMS/TB104
      !IT_DESTINATARIOS type TT_DESTINATARIO
      !IV_INTERVALO type INRI-NRRANGENR
      !IV_SUBOBJETO type INRI-SUBOBJECT optional
      !IV_ANO type INRI-TOYEAR optional
    exporting
      !EV_ID_NOTIFICACAO type /PTLOMS/ED154
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods ADICIONAR_DESTINATARIO
    importing
      !IV_ID_NOTIFICACAO type /PTLOMS/ED154
      !IV_USUARIO type /PTLOMS/TB013-USUARIO
      !IV_EMAIL_ATIVO type /PTLOMS/TB103-EMAIL
      !IV_WHATS_ATIVO type /PTLOMS/TB103-WHATSAPP
      !IV_SOMENTE_PREPARAR type XFELD
    exporting
      !ES_DESTINATARIO type /PTLOMS/TB105
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods PROCESSAR_PENDENTES
    importing
      !IV_ALERTAS_ATIVOS type /PTLOMS/ED150
      !IV_MAX type I default 500
      !IV_FM_ENQUEUE type RS38L_FNAM
      !IV_FM_DEQUEUE type RS38L_FNAM
    exporting
      !EV_PROCESSADOS type I
      !ET_LOG type TT_LOG
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods ENVIAR_EMAIL
    importing
      !IV_ID_NOTIFICACAO type /PTLOMS/TB104-ID_NOTIFICACAO
      !IV_USUARIO type /PTLOMS/TB105-USUARIO
    exporting
      !EV_SUCESSO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods ENVIAR_WHATSAPP
    importing
      !IV_ID_NOTIFICACAO type /PTLOMS/ED154
      !IV_USUARIO type /PTLOMS/TB013-USUARIO
    exporting
      !EV_SUCESSO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods MARCAR_LIDO
    importing
      !IV_ID_NOTIFICACAO type /PTLOMS/ED154
      !IV_USUARIO type /PTLOMS/TB013-USUARIO
    exporting
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods OBTER_NOTIFICACOES
    importing
      !IV_USUARIO type /PTLOMS/TB013-USUARIO
      !IV_LEITURA type XFELD
      !IV_TIPO type /PTLOMS/ED144 optional
      !IV_DATA_DE type SY-DATUM optional
      !IV_DATA_ATE type SY-DATUM optional
      !IV_LIMITE type I default 200
    exporting
      !ET_NOTIFICACOES type TT_NOTIFICACAO
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods OBTER_NAO_LIDAS
    importing
      !IV_USUARIO type /PTLOMS/TB013-USUARIO
    exporting
      !EV_QUANTIDADE type I
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL029 IMPLEMENTATION.


  METHOD adicionar_destinatario.

    DATA: lv_error_text TYPE string, ls_d TYPE /ptloms/tb105,
          lv_id         TYPE /ptloms/ed154,
          lx_error      TYPE REF TO cx_root.
    CLEAR: es_destinatario,
           ev_erro,
           ev_mensagem, ls_d.
    IF  iv_usuario IS INITIAL OR
      ( iv_email_ativo <> space AND iv_email_ativo <> 'X' ) OR
      ( iv_whats_ativo <> space AND iv_whats_ativo <> 'X' ) OR
      ( iv_somente_preparar <> space AND
        iv_somente_preparar <> 'X' ).
      ev_erro = 'X'.
      ev_mensagem = 'Usuario ou flags invalidos'.
      RETURN.
    ENDIF.
    TRY.
        SELECT SINGLE email telefone
          INTO (ls_d-email, ls_d-telefone)
          FROM /ptloms/tb013
          WHERE usuario = iv_usuario.
        IF sy-subrc <> 0.
          ev_erro = 'X'.
          ev_mensagem = 'Usuario OMS nao encontrado'.
          RETURN.
        ENDIF.
        ls_d-mandt = sy-mandt.
        ls_d-id_notificacao = iv_id_notificacao.
        ls_d-usuario = iv_usuario.
        ls_d-status_email = c_status_na.
        ls_d-status_whats = c_status_na.
        IF iv_email_ativo = 'X' AND ls_d-email IS NOT INITIAL.
          ls_d-status_email = c_status_pendente.
        ENDIF.
        IF iv_somente_preparar = 'X'.
          es_destinatario = ls_d.
          RETURN.
        ENDIF.
        IF iv_id_notificacao IS INITIAL.
          ev_erro = 'X'.
          ev_mensagem = 'ID da notificacao obrigatorio'.
          RETURN.
        ENDIF.
        SELECT SINGLE id_notificacao INTO lv_id
          FROM /ptloms/tb104
          WHERE id_notificacao = iv_id_notificacao.
        IF sy-subrc <> 0.
          ev_erro = 'X'.
          ev_mensagem = 'Cabecalho nao encontrado'.
          RETURN.
        ENDIF.
        INSERT /ptloms/tb105 FROM ls_d.
        IF sy-subrc <> 0.
          ev_erro = 'X'.
          ev_mensagem = 'Destinatario ja existe ou nao foi gravado'.
          RETURN.
        ENDIF.
        es_destinatario = ls_d.
      CATCH cx_root INTO lx_error.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text
          RECEIVING
            result = lv_error_text.
        ev_mensagem = lv_error_text.
    ENDTRY.

  ENDMETHOD.


  METHOD enviar_email.

    DATA:
      ls_notificacao  TYPE /ptloms/tb104,
      ls_destinatario TYPE /ptloms/tb105,
      lo_send_request TYPE REF TO cl_bcs,
      lo_document     TYPE REF TO cl_document_bcs,
      lo_recipient    TYPE REF TO if_recipient_bcs,
      lx_bcs          TYPE REF TO cx_bcs,
      lt_text         TYPE bcsy_text,
      ls_text         TYPE soli,
      lv_subject      TYPE so_obj_des,
      lv_email        TYPE ad_smtpadr,
      lv_sent         TYPE os_boolean,
      lv_error        TYPE string.

    CLEAR: ev_sucesso,
          ev_mensagem.

* Valida parâmetros
    IF iv_id_notificacao IS INITIAL.
      ev_mensagem = 'ID da notificação não informado'.
      RETURN.
    ENDIF.

    IF iv_usuario IS INITIAL.
      ev_mensagem = 'Usuário não informado'.
      RETURN.
    ENDIF.

* Busca destinatário
    CLEAR ls_destinatario.
    SELECT SINGLE *
      INTO ls_destinatario
      FROM /ptloms/tb105
      WHERE id_notificacao = iv_id_notificacao
        AND usuario = iv_usuario.
    IF sy-subrc <> 0.
      ev_mensagem = 'Destinatário da notificação não encontrado'.
      RETURN.
    ENDIF.

* Valida e-mail
    IF ls_destinatario-email IS INITIAL.
      ev_mensagem = 'Destinatário sem endereço de e-mail'.
      RETURN.
    ENDIF.
    lv_email = ls_destinatario-email.

* Busca cabeçalho
    CLEAR ls_notificacao.
    SELECT SINGLE *
      INTO ls_notificacao
      FROM /ptloms/tb104
      WHERE id_notificacao = iv_id_notificacao.
    IF sy-subrc <> 0.
      ev_mensagem = 'Notificação não encontrada'.
      RETURN.
    ENDIF.
    lv_subject = ls_notificacao-titulo.

* Monta corpo
    REFRESH lt_text.
    CLEAR ls_text.
    ls_text-line = ls_notificacao-mensagem.
    APPEND ls_text TO lt_text.

* Envio BCS
    TRY.

      lo_send_request = cl_bcs=>create_persistent( ).

      lo_document = cl_document_bcs=>create_document( i_type = 'RAW'
                                                      i_text = lt_text
                                                      i_subject = lv_subject ).

      lo_send_request->set_document( lo_document ).

      lo_recipient = cl_cam_address_bcs=>create_internet_address( i_address_string = lv_email ).

      lo_send_request->add_recipient( i_recipient = lo_recipient
                                      i_express = space ).

      lo_send_request->set_status_attributes( i_requested_status = 'E'
                                              i_status_mail = 'E' ).

      lv_sent = lo_send_request->send( i_with_error_screen = space ).

      IF lv_sent = abap_true.
        ev_sucesso = 'X'.
        ev_mensagem = 'E-mail encaminhado para processamento'.
      ELSE.
        CLEAR ev_sucesso.
        ev_mensagem = 'Não foi possível encaminhar o e-mail'.
      ENDIF.

      CATCH cx_bcs INTO lx_bcs.
        CLEAR ev_sucesso.
        lv_error = lx_bcs->get_text( ).
        ev_mensagem = lv_error.

    ENDTRY.

  ENDMETHOD.


  method ENVIAR_WHATSAPP.

    CLEAR: ev_sucesso, ev_mensagem.
    ev_mensagem = 'WhatsApp reservado para evolucao futura'.

  endmethod.


  METHOD marcar_lido.

    DATA: lv_error_text TYPE string,
          lv_lido TYPE /ptloms/ed163,
          lx_error TYPE REF TO cx_root.

    CLEAR: ev_erro,
           ev_mensagem.
    IF iv_id_notificacao IS INITIAL OR
       iv_usuario IS INITIAL.
      ev_erro = 'X'.
      ev_mensagem = 'Notificacao e usuario obrigatorios'.
      RETURN.
    ENDIF.
    TRY.
      UPDATE /ptloms/tb105
        SET lido = 'X' data_leitura = sy-datum
            hora_leitura = sy-uzeit
        WHERE id_notificacao = iv_id_notificacao
          AND usuario = iv_usuario
          AND lido = space.
        IF sy-subrc <> 0.
          SELECT SINGLE lido INTO lv_lido
            FROM /ptloms/tb105
            WHERE id_notificacao = iv_id_notificacao
              AND usuario = iv_usuario.
          IF sy-subrc <> 0 OR
             lv_lido <> 'X'.
            ev_erro = 'X'.
            ev_mensagem = 'Destinatario ausente ou leitura invalida'.
          ENDIF.
        ENDIF.
      CATCH cx_root INTO lx_error.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text
          RECEIVING
            result = lv_error_text.
        ev_mensagem = lv_error_text.
    ENDTRY.

  ENDMETHOD.


  METHOD obter_nao_lidas.

    DATA: lv_error_text TYPE string,
          lx_error TYPE REF TO cx_root.

    CLEAR: ev_quantidade,
           ev_erro,
           ev_mensagem.

    IF iv_usuario IS INITIAL.
      ev_erro = 'X'.
      ev_mensagem = 'Usuario obrigatorio'.
      RETURN.
    ENDIF.

    TRY.
        SELECT COUNT( * ) INTO ev_quantidade
          FROM /ptloms/tb105
          WHERE usuario = iv_usuario
            AND lido = space.

      CATCH cx_root INTO lx_error.

      CLEAR ev_quantidade.
      ev_erro = 'X'.
      CALL METHOD lx_error->get_text
        RECEIVING
          result = lv_error_text.
      ev_mensagem = lv_error_text.

    ENDTRY.

  ENDMETHOD.


  METHOD obter_notificacoes.
    DATA: lv_error_text TYPE string, lx_error TYPE REF TO cx_root.
    DATA: lr_lido TYPE RANGE OF /ptloms/ed163,
          lr_tipo TYPE RANGE OF /ptloms/ed144,
          lr_data TYPE RANGE OF sy-datum.
    DATA: ls_lido LIKE LINE OF lr_lido,
          ls_tipo LIKE LINE OF lr_tipo,
          ls_data LIKE LINE OF lr_data.

    REFRESH et_notificacoes.
    CLEAR: ev_erro, ev_mensagem.

    IF iv_usuario IS INITIAL OR iv_limite <= 0 OR
     ( iv_leitura <> space AND iv_leitura <> 'X' AND iv_leitura <> 'N' ) OR
     ( iv_tipo <> space AND iv_tipo <> c_tipo_alerta AND iv_tipo <> c_tipo_despacho ) OR
     ( iv_data_de IS NOT INITIAL AND iv_data_ate IS NOT INITIAL AND iv_data_de > iv_data_ate ).
      ev_erro = 'X'.
      ev_mensagem = 'Filtros de consulta invalidos'.
      RETURN.
    ENDIF.
    IF iv_leitura IS NOT INITIAL.
      ls_lido-sign = 'I'.
      ls_lido-option = 'EQ'.
      ls_lido-low = space.
      IF iv_leitura = 'X'.
        ls_lido-low = 'X'.
      ENDIF.
      APPEND ls_lido TO lr_lido.
    ENDIF.
    IF iv_tipo IS NOT INITIAL.
      ls_tipo-sign = 'I'.
      ls_tipo-option = 'EQ'.
      ls_tipo-low = iv_tipo.
      APPEND ls_tipo TO lr_tipo.
    ENDIF.
    IF iv_data_de IS NOT INITIAL OR iv_data_ate IS NOT INITIAL.
      ls_data-sign = 'I'.
      ls_data-option = 'BT'.
      ls_data-low = iv_data_de.
      ls_data-high = iv_data_ate.
      IF ls_data-low IS INITIAL.
        ls_data-low = '00010101'.
      ENDIF.
      IF ls_data-high IS INITIAL.
        ls_data-high = '99991231'.
      ENDIF.
      APPEND ls_data TO lr_data.
    ENDIF.
    TRY.
        SELECT a~id_notificacao
               a~tipo_notificacao
               a~tipo_evento
               a~tipo_documento
               a~documento
               a~item_documento
               a~ordem
               a~operacao
               a~tipo_objeto
               a~objeto
               a~id_lista
               a~titulo a~mensagem
               a~data_criacao
               a~hora_criacao
               b~lido
               b~data_leitura
               b~hora_leitura
          INTO TABLE et_notificacoes UP TO iv_limite ROWS
          FROM /ptloms/tb104 AS a
          INNER JOIN /ptloms/tb105 AS b
          ON b~id_notificacao = a~id_notificacao
          WHERE b~usuario = iv_usuario
            AND b~lido IN lr_lido
            AND a~tipo_notificacao IN lr_tipo
            AND a~data_criacao IN lr_data
          ORDER BY a~data_criacao DESCENDING
                   a~hora_criacao DESCENDING
                   a~id_notificacao DESCENDING.

      CATCH cx_root INTO lx_error.

        REFRESH et_notificacoes.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text
          RECEIVING
            result = lv_error_text.

        ev_mensagem = lv_error_text.

    ENDTRY.

  ENDMETHOD.


  METHOD processar_pendentes.

    DATA: lv_error_text TYPE string, lt_keys TYPE tt_pendente,
          ls_key        TYPE ty_pendente,
          ls_p          TYPE ty_pendente,
          ls_log        TYPE ty_log,
          lv_locked     TYPE xfeld,
          lv_ok         TYPE xfeld,
          lv_msg        TYPE /ptloms/ed162,
          lv_status     TYPE /ptloms/ed145,
          lv_tent       TYPE /ptloms/ed161,
          lv_date       TYPE /ptloms/tb105-data_email,
          lv_time       TYPE /ptloms/tb105-hora_email,
          lx_error      TYPE REF TO cx_root.

    DATA lr_origem TYPE RANGE OF /ptloms/ed144.
    DATA ls_origem LIKE LINE OF lr_origem.

    CLEAR: ev_processados, ev_erro, ev_mensagem.
    REFRESH et_log.

    IF iv_max <= 0 OR
       iv_fm_enqueue IS INITIAL OR
       iv_fm_dequeue IS INITIAL OR
     ( iv_alertas_ativos <> space AND iv_alertas_ativos <> 'X' ).
      ev_erro = 'X'.
      ev_mensagem = 'Configuracao de processamento invalida'.
      RETURN.
    ENDIF.

    ls_origem-sign = 'I'. ls_origem-option = 'EQ'.
    ls_origem-low = c_tipo_despacho.
    APPEND ls_origem TO lr_origem.
    IF iv_alertas_ativos = 'X'.
      ls_origem-low = c_tipo_alerta.
      APPEND ls_origem TO lr_origem.
    ENDIF.

    TRY.
        SELECT b~id_notificacao b~usuario
          INTO CORRESPONDING FIELDS OF TABLE lt_keys
          UP TO iv_max ROWS
          FROM /ptloms/tb105 AS b
          INNER JOIN /ptloms/tb104 AS a
          ON a~id_notificacao = b~id_notificacao
          WHERE b~status_email = c_status_pendente
            AND b~tent_email < c_max_tent_email
            AND a~tipo_notificacao IN lr_origem
            ORDER BY b~id_notificacao b~usuario.
      CATCH cx_root INTO lx_error.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text
          RECEIVING
            result = lv_error_text.
        ev_mensagem = lv_error_text.
        RETURN.
    ENDTRY.
    LOOP AT lt_keys INTO ls_key.
      CLEAR: ls_log,
             lv_locked,
             ls_p,
             lv_ok,
             lv_msg,
             lv_date,
             lv_time,
             lv_status,
             lv_tent.

      ls_log-id_notificacao = ls_key-id_notificacao.
      ls_log-usuario = ls_key-usuario.

      TRY.
          CALL FUNCTION iv_fm_enqueue
            EXPORTING
              mandt          = sy-mandt
              id_notificacao = ls_key-id_notificacao
              usuario        = ls_key-usuario
              _scope         = '1'
              _wait          = space
            EXCEPTIONS
              foreign_lock   = 1
              system_failure = 2
              OTHERS         = 3.
          IF sy-subrc = 1.
            ls_log-mensagem = 'Bloqueado; sem tentativa nesta rodada'.
            APPEND ls_log TO et_log.
            CONTINUE.
          ELSEIF sy-subrc <> 0.
            ev_erro = 'X'.
            ev_mensagem = 'Falha no servico de enqueue'.
            ls_log-mensagem = ev_mensagem.
            APPEND ls_log TO et_log.
            EXIT.
          ENDIF.
          lv_locked = 'X'.
          DO 1 TIMES.
            SELECT SINGLE b~id_notificacao
                          b~usuario
                          b~email
                          b~status_email
                          b~tent_email
                          a~tipo_notificacao
                          a~titulo a~mensagem
              INTO ls_p FROM /ptloms/tb105 AS b
              INNER JOIN /ptloms/tb104 AS a
              ON a~id_notificacao = b~id_notificacao
              WHERE b~id_notificacao = ls_key-id_notificacao
                AND b~usuario = ls_key-usuario.
              IF sy-subrc <> 0 OR
                 ls_p-status_email <> c_status_pendente OR
                 ls_p-tent_email >= c_max_tent_email.
                ls_log-mensagem = 'Registro nao elegivel apos lock'.
                EXIT.
              ENDIF.
            IF ls_p-tipo_notificacao = c_tipo_alerta AND
               iv_alertas_ativos <> 'X'.
              ls_log-mensagem = 'Alerta suspenso pela configuracao'.
              EXIT.
            ENDIF.
            IF ls_p-tipo_notificacao <> c_tipo_alerta AND
               ls_p-tipo_notificacao <> c_tipo_despacho.
              ls_log-mensagem = 'Origem nao suportada'.
              EXIT.
            ENDIF.
            CALL METHOD /ptloms/cl029=>enviar_email
              EXPORTING
                iv_id_notificacao = ls_p-id_notificacao
                iv_usuario        = ls_key-usuario
              IMPORTING
                ev_sucesso        = lv_ok
                ev_mensagem       = lv_msg.
            lv_tent = ls_p-tent_email.
            IF lv_ok = 'X'.
              lv_status = c_status_sucesso.
              lv_date = sy-datum.
              lv_time = sy-uzeit.
              CLEAR lv_msg.
            ELSE.
* Exclusivamente a LUW de canais; mantem lock de escopo 1.
              ROLLBACK WORK.
              ADD 1 TO lv_tent.
              lv_status = c_status_pendente.
              IF lv_tent >= c_max_tent_email.
                lv_status = c_status_erro.
              ENDIF.
            ENDIF.
            UPDATE /ptloms/tb105
              SET status_email = lv_status tent_email = lv_tent
                  data_email = lv_date hora_email = lv_time
                  erro_email = lv_msg
              WHERE id_notificacao = ls_key-id_notificacao
                AND usuario = ls_key-usuario
                AND status_email = c_status_pendente
                AND tent_email = ls_p-tent_email.
            IF sy-subrc <> 0 OR
               sy-dbcnt <> 1.
              ROLLBACK WORK.
              ev_erro = 'X'.
              ev_mensagem = 'Atualizacao concorrente ou linha ausente'.
              ls_log-mensagem = ev_mensagem.
              EXIT.
            ENDIF.
            COMMIT WORK AND WAIT.
            IF sy-subrc <> 0.
              ev_erro = 'X'.
              ev_mensagem = 'Falha no commit; conciliar SM13 e SOST'.
              ls_log-mensagem = ev_mensagem.
              EXIT.
            ENDIF.
            ADD 1 TO ev_processados.
            ls_log-status = lv_status.
            ls_log-mensagem = lv_msg.
            IF lv_ok = 'X'.
              ls_log-mensagem = 'Solicitacao aceita pelo BCS'.
            ENDIF.
          ENDDO.
        CATCH cx_root INTO lx_error.

        ROLLBACK WORK.

        ev_erro = 'X'.
        CALL METHOD lx_error->get_text
          RECEIVING
            result = lv_error_text.
        ev_mensagem = lv_error_text.
        ls_log-mensagem = ev_mensagem.
      ENDTRY.
      IF lv_locked = 'X'.
        TRY.
            CALL FUNCTION iv_fm_dequeue
              EXPORTING
                mandt          = sy-mandt
                id_notificacao = ls_key-id_notificacao
                usuario        = ls_key-usuario
                _scope         = '1'
                _synchron      = 'X'.
          CATCH cx_root INTO lx_error.
            ev_erro = 'X'.
            ev_mensagem = 'Falha ao liberar lock; encerrar job'.
            ls_log-mensagem = ev_mensagem.
        ENDTRY.
      ENDIF.
      APPEND ls_log TO et_log.
      IF ev_erro = 'X'.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD registrar.

    DATA: lv_error_text TYPE string, ls_h TYPE /ptloms/tb104,
          ls_d          TYPE /ptloms/tb105,
          ls_in         TYPE ty_destinatario,
          lt_d          TYPE tt_tb105,
          lt_in         TYPE tt_destinatario,
          lv_number     TYPE nriv-nrlevel,
          lv_id         TYPE /ptloms/ed154,
          lv_inserted   TYPE xfeld,
          lx_error      TYPE REF TO cx_root.
    CLEAR: ev_id_notificacao,
           ev_erro,
           ev_mensagem.

    ls_h = is_notificacao.
    IF ( ls_h-tipo_notificacao <> c_tipo_alerta AND
         ls_h-tipo_notificacao <> c_tipo_despacho ) OR
         ls_h-titulo IS INITIAL OR ls_h-mensagem IS INITIAL OR
          it_destinatarios IS INITIAL OR iv_intervalo IS INITIAL.
      ev_erro = 'X'.
      ev_mensagem = 'Dados obrigatorios invalidos'.
      RETURN.
    ENDIF.
    lt_in = it_destinatarios.
    SORT lt_in BY usuario.
    DELETE ADJACENT DUPLICATES FROM lt_in COMPARING usuario.
    IF lines( lt_in ) <> lines( it_destinatarios ).
      ev_erro = 'X'.
      ev_mensagem = 'Consolidar canais por usuario antes do registro'.
      RETURN.
    ENDIF.
    LOOP AT lt_in INTO ls_in.
      CALL METHOD /ptloms/cl029=>adicionar_destinatario
        EXPORTING
          iv_id_notificacao   = '0000000000'
          iv_usuario          = ls_in-usuario
          iv_email_ativo      = ls_in-email_ativo
          iv_whats_ativo      = ls_in-whats_ativo
          iv_somente_preparar = 'X'
        IMPORTING
          es_destinatario     = ls_d
          ev_erro             = ev_erro
          ev_mensagem         = ev_mensagem.
      IF ev_erro = 'X'.
        RETURN.
      ENDIF.
      APPEND ls_d TO lt_d.
    ENDLOOP.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        object                  = c_snro
        nr_range_nr             = iv_intervalo
        subobject               = iv_subobjeto
        toyear                  = iv_ano
      IMPORTING
        number                  = lv_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0 OR lv_number > 9999999999 OR
    lv_number = 0.
      ev_erro = 'X'.
      ev_mensagem = 'Falha SNRO /PTLOMS/NF ou numero fora de NUMC10'.
      RETURN.
    ENDIF.
    lv_id = lv_number.
    ls_h-mandt = sy-mandt.
    ls_h-id_notificacao = lv_id.
    ls_h-data_criacao = sy-datum.
    ls_h-hora_criacao = sy-uzeit.
    LOOP AT lt_d INTO ls_d.
      ls_d-id_notificacao = lv_id.
      MODIFY lt_d FROM ls_d.
    ENDLOOP.
    TRY.
        INSERT /ptloms/tb104 FROM ls_h.
        IF sy-subrc = 0.
          lv_inserted = 'X'.
          INSERT /ptloms/tb105 FROM TABLE lt_d
          ACCEPTING DUPLICATE KEYS.
          IF sy-subrc <> 0.
            ev_erro = 'X'.
            ev_mensagem = 'Falha ao gravar destinatarios'.
          ENDIF.
        ELSE.
          ev_erro = 'X'.
          ev_mensagem = 'Falha ao gravar cabecalho'.
        ENDIF.
      CATCH cx_root INTO lx_error.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text
          RECEIVING
            result = lv_error_text.
        ev_mensagem = lv_error_text.
    ENDTRY.
    IF ev_erro = 'X'.
      IF lv_inserted = 'X'.
        TRY.
            DELETE FROM /ptloms/tb105
              WHERE id_notificacao = lv_id.
            DELETE FROM /ptloms/tb104
              WHERE id_notificacao = lv_id.
          CATCH cx_root INTO lx_error.
            CONCATENATE 'Falha de compensacao; suporte; ID' lv_id
            INTO ev_mensagem SEPARATED BY space.
        ENDTRY.
      ENDIF.
      RETURN.
    ENDIF.
    ev_id_notificacao = lv_id.

  ENDMETHOD.
ENDCLASS.
