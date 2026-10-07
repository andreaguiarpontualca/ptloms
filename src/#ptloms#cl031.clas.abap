CLASS /ptloms/cl031 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS validar_login_oms
      IMPORTING
        iv_usuario     TYPE /ptloms/ed108
        iv_senha       TYPE char32
        is_client_info TYPE /ptloms/et211
      EXPORTING
        es_result      TYPE /ptloms/et210.

    METHODS validar_login_sap
      IMPORTING
        is_client_info TYPE /ptloms/et211
      EXPORTING
        es_result      TYPE /ptloms/et210.

    METHODS buscar_dados_usuario
      IMPORTING
        iv_usuario TYPE /ptloms/ed108
      EXPORTING
        es_usuario TYPE /ptloms/et212
        es_result  TYPE /ptloms/et213.

    METHODS buscar_autorizacoes
      IMPORTING
        iv_usuario     TYPE /ptloms/ed108
      EXPORTING
        et_autorizacao TYPE /ptloms/ct076
        es_result      TYPE /ptloms/et213.

    METHODS buscar_config_perfil
      IMPORTING
        iv_usuario       TYPE /ptloms/ed108
      EXPORTING
        et_config_perfil TYPE /ptloms/ct078
        es_result        TYPE /ptloms/et213.

    METHODS buscar_config_sistema
      IMPORTING
        iv_usuario        TYPE /ptloms/ed108
      EXPORTING
        et_config_sistema TYPE /ptloms/ct074
        es_result         TYPE /ptloms/et213.

  PRIVATE SECTION.

    METHODS buscar_usuario_contexto
      IMPORTING
        iv_usuario    TYPE /ptloms/ed108
      EXPORTING
        ev_usuario    TYPE /ptloms/ed108
        es_usuario_db TYPE /ptloms/tb013
        es_result     TYPE /ptloms/et213.

    METHODS registrar_auditoria
      IMPORTING
        iv_usuario      TYPE /ptloms/ed108
        iv_tipo_usuario TYPE /ptloms/ed164
        iv_sucesso      TYPE xfeld
        iv_reason_code  TYPE /ptloms/ed167
        iv_mensagem     TYPE bapi_msg
        is_client_info  TYPE /ptloms/et211
      EXPORTING
        ev_log_id       TYPE /ptloms/ed118
        es_result       TYPE /ptloms/et213.

ENDCLASS.



CLASS /PTLOMS/CL031 IMPLEMENTATION.


  METHOD buscar_autorizacoes.

*---------------------------------------------------------------------*
* Recupera exclusivamente as autorizações do usuário.
*
* Retorno:
* - /PTLOMS/CT076
* - linha /PTLOMS/ET108
*---------------------------------------------------------------------*

    DATA:
      lv_usuario        TYPE /ptloms/ed108,
      ls_usuario_db     TYPE /ptloms/tb013,
      ls_validacao      TYPE /ptloms/et213,

      lt_autorizacao_db TYPE TABLE OF /ptloms/tb043,
      ls_autorizacao_db TYPE /ptloms/tb043,
      ls_autorizacao    LIKE LINE OF et_autorizacao,

      lt_values         TYPE STANDARD TABLE OF dd07v,
      ls_value          TYPE dd07v,
      lv_val_dominio    TYPE val_single.

    CLEAR:
      es_result,
      lv_usuario,
      ls_usuario_db,
      ls_validacao,
      ls_autorizacao_db,
      ls_autorizacao,
      ls_value,
      lv_val_dominio.

    REFRESH:
      et_autorizacao,
      lt_autorizacao_db,
      lt_values.

    CALL METHOD me->buscar_usuario_contexto
      EXPORTING
        iv_usuario    = iv_usuario
      IMPORTING
        ev_usuario    = lv_usuario
        es_usuario_db = ls_usuario_db
        es_result     = ls_validacao.

    IF ls_validacao-valid IS INITIAL.

      es_result = ls_validacao.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Autorizações do perfil
*---------------------------------------------------------------------*
    SELECT *
      FROM /ptloms/tb043
      INTO TABLE lt_autorizacao_db
      WHERE perfil = ls_usuario_db-perfil.

*---------------------------------------------------------------------*
* Textos do domínio
*---------------------------------------------------------------------*
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM011'
        text            = 'X'
      TABLES
        values_tab      = lt_values
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

*---------------------------------------------------------------------*
* Montagem do retorno
*---------------------------------------------------------------------*
    LOOP AT lt_autorizacao_db INTO ls_autorizacao_db.

      CLEAR:
        ls_autorizacao,
        lv_val_dominio,
        ls_value.

      ls_autorizacao-usuario =
        lv_usuario.

      ls_autorizacao-autorizacao =
        ls_autorizacao_db-autorizacao.

      lv_val_dominio =
        ls_autorizacao_db-autorizacao.

      CONDENSE lv_val_dominio NO-GAPS.

      READ TABLE lt_values
        INTO ls_value
        WITH KEY domvalue_l = lv_val_dominio.

      IF sy-subrc EQ 0.

        ls_autorizacao-desc_autorizacao =
          ls_value-ddtext.

      ENDIF.

      APPEND ls_autorizacao
        TO et_autorizacao.

    ENDLOOP.

    es_result-valid       = 'X'.
    es_result-reason_code = 'OK'.
    es_result-message =
      'Autorizações do usuário carregadas com sucesso.'.

  ENDMETHOD.


  METHOD buscar_config_perfil.

*---------------------------------------------------------------------*
* Recupera exclusivamente as configurações associadas ao perfil.
*
* Retorno:
* - /PTLOMS/CT078
* - linha /PTLOMS/ET109
*---------------------------------------------------------------------*

    DATA:
      lv_usuario     TYPE /ptloms/ed108,
      ls_usuario_db  TYPE /ptloms/tb013,
      ls_validacao   TYPE /ptloms/et213,

      lt_config_db   TYPE TABLE OF /ptloms/tb044,
      ls_config_db   TYPE /ptloms/tb044,
      ls_config      LIKE LINE OF et_config_perfil,

      lt_values      TYPE STANDARD TABLE OF dd07v,
      ls_value       TYPE dd07v,
      lv_val_dominio TYPE val_single.

    CLEAR:
      es_result,
      lv_usuario,
      ls_usuario_db,
      ls_validacao,
      ls_config_db,
      ls_config,
      ls_value,
      lv_val_dominio.

    REFRESH:
      et_config_perfil,
      lt_config_db,
      lt_values.

    CALL METHOD me->buscar_usuario_contexto
      EXPORTING
        iv_usuario    = iv_usuario
      IMPORTING
        ev_usuario    = lv_usuario
        es_usuario_db = ls_usuario_db
        es_result     = ls_validacao.

    IF ls_validacao-valid IS INITIAL.

      es_result = ls_validacao.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Configurações do perfil
*---------------------------------------------------------------------*
    SELECT *
      FROM /ptloms/tb044
      INTO TABLE lt_config_db
      WHERE perfil = ls_usuario_db-perfil.

*---------------------------------------------------------------------*
* Textos do domínio
*---------------------------------------------------------------------*
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM012'
        text            = 'X'
      TABLES
        values_tab      = lt_values
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

*---------------------------------------------------------------------*
* Montagem do retorno
*---------------------------------------------------------------------*
    LOOP AT lt_config_db INTO ls_config_db.

      CLEAR:
        ls_config,
        lv_val_dominio,
        ls_value.

      ls_config-perfil =
        ls_usuario_db-perfil.

      ls_config-configuracao =
        ls_config_db-configuracao.

      lv_val_dominio =
        ls_config_db-configuracao.

      CONDENSE lv_val_dominio NO-GAPS.

      READ TABLE lt_values
        INTO ls_value
        WITH KEY domvalue_l = lv_val_dominio.

      IF sy-subrc EQ 0.

        ls_config-desc_configuracao =
          ls_value-ddtext.

      ENDIF.

      APPEND ls_config
        TO et_config_perfil.

    ENDLOOP.

    es_result-valid       = 'X'.
    es_result-reason_code = 'OK'.
    es_result-message =
      'Configurações do perfil carregadas com sucesso.'.

  ENDMETHOD.


  METHOD buscar_config_sistema.

*---------------------------------------------------------------------*
* Recupera configuração geral do sistema e aplica as configurações
* específicas do perfil.
*
* Mapeamento:
* 04 -> DESPACHO_ORDEM
* 05 -> DESPACHO_OPER
* 06 -> CHAVE_MODELO
* 07 -> APONT_MANUAL
* 08 -> TIPO_ATIVIDADE
*
* Retorno:
* - /PTLOMS/CT074
* - linha /PTLOMS/ET074
*---------------------------------------------------------------------*

    DATA:
      lv_usuario        TYPE /ptloms/ed108,
      ls_usuario_db     TYPE /ptloms/tb013,
      ls_validacao      TYPE /ptloms/et213,

      lt_config_db      TYPE TABLE OF /ptloms/tb044,
      ls_config_db      TYPE /ptloms/tb044,
      ls_config_sistema LIKE LINE OF et_config_sistema,

      lv_04             TYPE xfeld,
      lv_05             TYPE xfeld,
      lv_06             TYPE xfeld,
      lv_07             TYPE xfeld,
      lv_08             TYPE xfeld.

    CLEAR:
      es_result,
      lv_usuario,
      ls_usuario_db,
      ls_validacao,
      ls_config_db,
      ls_config_sistema,
      lv_04,
      lv_05,
      lv_06,
      lv_07,
      lv_08.

    REFRESH:
      et_config_sistema,
      lt_config_db.

    CALL METHOD me->buscar_usuario_contexto
      EXPORTING
        iv_usuario    = iv_usuario
      IMPORTING
        ev_usuario    = lv_usuario
        es_usuario_db = ls_usuario_db
        es_result     = ls_validacao.

    IF ls_validacao-valid IS INITIAL.

      es_result = ls_validacao.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Configurações do perfil necessárias para composição
*---------------------------------------------------------------------*
    SELECT *
      FROM /ptloms/tb044
      INTO TABLE lt_config_db
      WHERE perfil = ls_usuario_db-perfil.

    LOOP AT lt_config_db INTO ls_config_db.

      IF ls_config_db-configuracao EQ '04'.
        lv_04 = 'X'.
      ENDIF.

      IF ls_config_db-configuracao EQ '05'.
        lv_05 = 'X'.
      ENDIF.

      IF ls_config_db-configuracao EQ '06'.
        lv_06 = 'X'.
      ENDIF.

      IF ls_config_db-configuracao EQ '07'.
        lv_07 = 'X'.
      ENDIF.

      IF ls_config_db-configuracao EQ '08'.
        lv_08 = 'X'.
      ENDIF.

    ENDLOOP.

*---------------------------------------------------------------------*
* Configuração geral
*---------------------------------------------------------------------*
    SELECT *
      FROM /ptloms/tb033
      INTO CORRESPONDING FIELDS OF TABLE et_config_sistema.

*---------------------------------------------------------------------*
* Aplicação do perfil
*---------------------------------------------------------------------*
    LOOP AT et_config_sistema INTO ls_config_sistema.

      IF lv_04 EQ 'X'.
        ls_config_sistema-despacho_ordem = 'X'.
      ENDIF.

      IF lv_05 EQ 'X'.
        ls_config_sistema-despacho_oper = 'X'.
      ENDIF.

      IF lv_06 EQ 'X'.
        ls_config_sistema-chave_modelo = 'X'.
      ENDIF.

      IF lv_07 EQ 'X'.
        ls_config_sistema-apont_manual = 'X'.
      ENDIF.

      IF lv_08 EQ 'X'.
        ls_config_sistema-tipo_atividade = 'X'.
      ENDIF.

      MODIFY et_config_sistema
        FROM ls_config_sistema
        INDEX sy-tabix.

    ENDLOOP.

    es_result-valid       = 'X'.
    es_result-reason_code = 'OK'.
    es_result-message =
      'Configurações do sistema carregadas com sucesso.'.

  ENDMETHOD.


  METHOD buscar_dados_usuario.

*---------------------------------------------------------------------*
* Recupera exclusivamente os dados funcionais do usuário.
*
* Retorno:
* - /PTLOMS/ET212
* - /PTLOMS/ET213
*---------------------------------------------------------------------*

    TYPES:
      BEGIN OF ty_centro,
        werks TYPE /ptloms/tb015-iwerk,
      END OF ty_centro.

    DATA:
      lv_usuario    TYPE /ptloms/ed108,
      ls_usuario_db TYPE /ptloms/tb013,
      ls_validacao  TYPE /ptloms/et213,
      lt_centros    TYPE TABLE OF ty_centro,
      ls_centro     TYPE ty_centro,
      lv_separador  TYPE char2,
      lv_arbpl      TYPE crhd-arbpl.

    CLEAR:
      es_usuario,
      es_result,
      lv_usuario,
      ls_usuario_db,
      ls_validacao,
      lv_separador,
      lv_arbpl.

    REFRESH lt_centros.

    CALL METHOD me->buscar_usuario_contexto
      EXPORTING
        iv_usuario    = iv_usuario
      IMPORTING
        ev_usuario    = lv_usuario
        es_usuario_db = ls_usuario_db
        es_result     = ls_validacao.

    IF ls_validacao-valid IS INITIAL.

      es_result = ls_validacao.
      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Estrutura sanitizada.
* ET212 não contém SENHA nem CONF_SENHA.
*---------------------------------------------------------------------*
    MOVE-CORRESPONDING ls_usuario_db TO es_usuario.

*---------------------------------------------------------------------*
* Unidade de tempo padrão
*---------------------------------------------------------------------*
    IF es_usuario-unidade_tempo IS INITIAL.

      SELECT SINGLE confirmacao
        FROM /ptloms/tb033
        INTO es_usuario-unidade_tempo.

    ENDIF.

*---------------------------------------------------------------------*
* Centros associados ao perfil
*---------------------------------------------------------------------*
    SELECT DISTINCT iwerk
      FROM /ptloms/tb015
      INTO TABLE lt_centros
      WHERE perfil = ls_usuario_db-perfil.

    CLEAR:
      es_usuario-centros,
      lv_separador.

    LOOP AT lt_centros INTO ls_centro.

      CONCATENATE
        es_usuario-centros
        lv_separador
        ls_centro-werks
        INTO es_usuario-centros.

      lv_separador = ', '.

    ENDLOOP.

*---------------------------------------------------------------------*
* Centro de trabalho
*---------------------------------------------------------------------*
    IF ls_usuario_db-objid IS NOT INITIAL.

      SELECT SINGLE arbpl
        FROM crhd
        INTO lv_arbpl
        WHERE objid = ls_usuario_db-objid.

      IF sy-subrc EQ 0.
        es_usuario-arbpl = lv_arbpl.
      ENDIF.

    ENDIF.

    es_result-valid       = 'X'.
    es_result-reason_code = 'OK'.
    es_result-message =
      'Dados do usuário carregados com sucesso.'.

  ENDMETHOD.


  METHOD buscar_usuario_contexto.

*---------------------------------------------------------------------*
* Validação comum utilizada pelas quatro operações de contexto.
*---------------------------------------------------------------------*

    CLEAR:
      ev_usuario,
      es_usuario_db,
      es_result.

    IF iv_usuario IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'EMPTY_USER'.
      es_result-message     = 'Informe o usuário.'.

      RETURN.

    ENDIF.

    ev_usuario = iv_usuario.

    TRANSLATE ev_usuario TO UPPER CASE.

    SELECT SINGLE *
      FROM /ptloms/tb013
      INTO es_usuario_db
      WHERE usuario = ev_usuario.

    IF sy-subrc NE 0.

      es_result-valid       = space.
      es_result-reason_code = 'USER_NOT_REGISTERED'.
      es_result-message =
        'Usuário não cadastrado para utilização do OMS.'.

      RETURN.

    ENDIF.

    IF es_usuario_db-bloqueado EQ 'X'.

      es_result-valid       = space.
      es_result-reason_code = 'USER_BLOCKED'.
      es_result-message     = 'Usuário bloqueado.'.

      RETURN.

    ENDIF.

    IF es_usuario_db-eliminado EQ 'X'.

      es_result-valid       = space.
      es_result-reason_code = 'USER_INACTIVE'.
      es_result-message     = 'Usuário não está ativo.'.

      RETURN.

    ENDIF.

    IF es_usuario_db-matricula IS INITIAL
       OR es_usuario_db-perfil IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'USER_PROFILE_INCOMPLETE'.
      es_result-message =
        'Cadastro funcional do usuário incompleto.'.

      RETURN.

    ENDIF.

    es_result-valid       = 'X'.
    es_result-reason_code = 'OK'.
    es_result-message     = 'Usuário validado com sucesso.'.

  ENDMETHOD.


  METHOD registrar_auditoria.

*---------------------------------------------------------------------*
* Centraliza a auditoria por meio da façade MF170.
*---------------------------------------------------------------------*

    CLEAR:
      ev_log_id,
      es_result.

    CALL FUNCTION '/PTLOMS/MF170'
      EXPORTING
        iv_usuario      = iv_usuario
        iv_tipo_usuario = iv_tipo_usuario
        is_client_info  = is_client_info
        iv_sucesso      = iv_sucesso
        iv_reason_code  = iv_reason_code
        iv_mensagem     = iv_mensagem
      IMPORTING
        ev_log_id       = ev_log_id
        es_result       = es_result.

  ENDMETHOD.


  METHOD validar_login_oms.

*---------------------------------------------------------------------*
* Login OMS
*---------------------------------------------------------------------*

    DATA:
      lv_usuario         TYPE /ptloms/ed108,
      lv_senha_hash      TYPE /ptloms/tb013-senha,
      ls_usuario         TYPE /ptloms/tb013,
      lo_license_service TYPE REF TO /ptloms/cl024,
      ls_license_result  TYPE /ptloms/cl024=>ty_check_result,
      lv_audit_id        TYPE /ptloms/ed118,
      ls_audit_result    TYPE /ptloms/et213,
      lx_root            TYPE REF TO cx_root,
      lv_message         TYPE string.

    CLEAR:
      es_result,
      lv_usuario,
      lv_senha_hash,
      ls_usuario,
      ls_license_result,
      lv_audit_id,
      ls_audit_result,
      lv_message.

*---------------------------------------------------------------------*
* Usuário
*---------------------------------------------------------------------*
    IF iv_usuario IS INITIAL.

      es_result-valid       = space.
      es_result-user_type   = 'OMS'.
      es_result-reason_code = 'EMPTY_USER'.
      es_result-message     = 'Informe o usuário.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = iv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Senha
*---------------------------------------------------------------------*
    IF iv_senha IS INITIAL.

      es_result-valid       = space.
      es_result-user_name   = iv_usuario.
      es_result-user_type   = 'OMS'.
      es_result-reason_code = 'EMPTY_PASSWORD'.
      es_result-message     = 'Informe a senha.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = iv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Normalização
*---------------------------------------------------------------------*
    lv_usuario = iv_usuario.

    TRANSLATE lv_usuario TO UPPER CASE.

    es_result-user_name = lv_usuario.
    es_result-user_type = 'OMS'.

*---------------------------------------------------------------------*
* Cadastro
*---------------------------------------------------------------------*
    SELECT SINGLE *
      FROM /ptloms/tb013
      INTO ls_usuario
      WHERE usuario = lv_usuario.

    IF sy-subrc NE 0.

      es_result-valid       = space.
      es_result-reason_code = 'INVALID_CREDENTIAL'.
      es_result-message     = 'Usuário ou senha inválidos.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Hash
*---------------------------------------------------------------------*
    CALL FUNCTION 'MD5_CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        data   = iv_senha
      IMPORTING
        hash   = lv_senha_hash
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.

      es_result-valid       = space.
      es_result-reason_code = 'INTERNAL_ERROR'.
      es_result-message =
        'Erro ao validar a credencial OMS.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Credencial
*---------------------------------------------------------------------*
    IF lv_senha_hash NE ls_usuario-senha.

      es_result-valid       = space.
      es_result-reason_code = 'INVALID_CREDENTIAL'.
      es_result-message     = 'Usuário ou senha inválidos.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Bloqueio
*---------------------------------------------------------------------*
    IF ls_usuario-bloqueado EQ 'X'.

      es_result-valid       = space.
      es_result-reason_code = 'USER_BLOCKED'.
      es_result-message     = 'Usuário bloqueado.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Inatividade
*---------------------------------------------------------------------*
    IF ls_usuario-eliminado EQ 'X'.

      es_result-valid       = space.
      es_result-reason_code = 'USER_INACTIVE'.
      es_result-message     = 'Usuário não está ativo.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Cadastro funcional
*---------------------------------------------------------------------*
    IF ls_usuario-matricula IS INITIAL
       OR ls_usuario-perfil IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'USER_PROFILE_INCOMPLETE'.
      es_result-message =
        'Cadastro funcional do usuário incompleto.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Troca obrigatória de senha
*---------------------------------------------------------------------*
    IF ls_usuario-atualizar_senha EQ 'X'.
      es_result-password_change_required = 'X'.
    ELSE.
      CLEAR es_result-password_change_required.
    ENDIF.

*---------------------------------------------------------------------*
* Licença
*---------------------------------------------------------------------*
    TRY.

        CREATE OBJECT lo_license_service.

        ls_license_result =
          lo_license_service->check_user(
            iv_user = lv_usuario ).

      CATCH cx_root INTO lx_root.

        lv_message =
          lx_root->get_text( ).

        es_result-valid       = space.
        es_result-reason_code = 'LICENSE_SERVICE_ERROR'.

        IF lv_message IS INITIAL.

          es_result-message =
            'Erro ao validar a licença OMS.'.

        ELSE.

          es_result-message =
            lv_message.

        ENDIF.

        CALL METHOD me->registrar_auditoria
          EXPORTING
            iv_usuario      = lv_usuario
            iv_tipo_usuario = 'OMS'
            iv_sucesso      = space
            iv_reason_code  = es_result-reason_code
            iv_mensagem     = es_result-message
            is_client_info  = is_client_info
          IMPORTING
            ev_log_id       = lv_audit_id
            es_result       = ls_audit_result.

        es_result-audit_id = lv_audit_id.

        RETURN.

    ENDTRY.

    es_result-license_valid_to =
      ls_license_result-valid_to.

    es_result-days_remaining =
      ls_license_result-days_remaining.

    IF ls_license_result-valid IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'LICENSE_INVALID'.

      IF ls_license_result-message IS INITIAL.

        es_result-message =
          'Licença OMS inválida.'.

      ELSE.

        es_result-message =
          ls_license_result-message.

      ENDIF.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'OMS'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Auditoria sucesso
*---------------------------------------------------------------------*
    CALL METHOD me->registrar_auditoria
      EXPORTING
        iv_usuario      = lv_usuario
        iv_tipo_usuario = 'OMS'
        iv_sucesso      = 'X'
        iv_reason_code  = 'OK'
        iv_mensagem     = 'Login OMS realizado com sucesso.'
        is_client_info  = is_client_info
      IMPORTING
        ev_log_id       = lv_audit_id
        es_result       = ls_audit_result.

    es_result-audit_id = lv_audit_id.

    es_result-valid       = 'X'.
    es_result-user_name   = lv_usuario.
    es_result-user_type   = 'OMS'.
    es_result-reason_code = 'OK'.
    es_result-message =
      'Login OMS realizado com sucesso.'.

  ENDMETHOD.


  METHOD validar_login_sap.

*---------------------------------------------------------------------*
* Login SAP
*---------------------------------------------------------------------*

    DATA:
      lv_usuario         TYPE /ptloms/ed108,
      ls_usuario         TYPE /ptloms/tb013,
      lo_license_service TYPE REF TO /ptloms/cl024,
      ls_license_result  TYPE /ptloms/cl024=>ty_check_result,
      lv_audit_id        TYPE /ptloms/ed118,
      ls_audit_result    TYPE /ptloms/et213,
      lx_root            TYPE REF TO cx_root,
      lv_message         TYPE string.

    CLEAR:
      es_result,
      lv_usuario,
      ls_usuario,
      ls_license_result,
      lv_audit_id,
      ls_audit_result,
      lv_message.

*---------------------------------------------------------------------*
* Identidade efetiva
*---------------------------------------------------------------------*
    lv_usuario = sy-uname.

    IF lv_usuario IS INITIAL.

      es_result-valid       = space.
      es_result-user_type   = 'SAP'.
      es_result-reason_code =
        'SAP_SESSION_USER_NOT_FOUND'.

      es_result-message =
        'Não foi possível identificar o usuário da sessão SAP.'.

      RETURN.

    ENDIF.

    TRANSLATE lv_usuario TO UPPER CASE.

    es_result-user_name = lv_usuario.
    es_result-user_type = 'SAP'.

*---------------------------------------------------------------------*
* Cadastro OMS
*---------------------------------------------------------------------*
    SELECT SINGLE *
      FROM /ptloms/tb013
      INTO ls_usuario
      WHERE usuario = lv_usuario.

    IF sy-subrc NE 0.

      es_result-valid       = space.
      es_result-reason_code = 'USER_NOT_REGISTERED'.

      es_result-message =
        'Usuário SAP não cadastrado para utilização do OMS.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'SAP'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Bloqueio
*---------------------------------------------------------------------*
    IF ls_usuario-bloqueado EQ 'X'.

      es_result-valid       = space.
      es_result-reason_code = 'USER_BLOCKED'.
      es_result-message     = 'Usuário bloqueado.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'SAP'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Inatividade
*---------------------------------------------------------------------*
    IF ls_usuario-eliminado EQ 'X'.

      es_result-valid       = space.
      es_result-reason_code = 'USER_INACTIVE'.
      es_result-message     = 'Usuário não está ativo.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'SAP'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Cadastro funcional
*---------------------------------------------------------------------*
    IF ls_usuario-matricula IS INITIAL
       OR ls_usuario-perfil IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'USER_PROFILE_INCOMPLETE'.

      es_result-message =
        'Cadastro funcional do usuário incompleto.'.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'SAP'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Licenciamento
*---------------------------------------------------------------------*
    TRY.

        CREATE OBJECT lo_license_service.

        ls_license_result =
          lo_license_service->check_user(
            iv_user = lv_usuario ).

      CATCH cx_root INTO lx_root.

        lv_message =
          lx_root->get_text( ).

        es_result-valid       = space.
        es_result-reason_code =
          'LICENSE_SERVICE_ERROR'.

        IF lv_message IS INITIAL.

          es_result-message =
            'Erro ao validar a licença OMS.'.

        ELSE.

          es_result-message =
            lv_message.

        ENDIF.

        CALL METHOD me->registrar_auditoria
          EXPORTING
            iv_usuario      = lv_usuario
            iv_tipo_usuario = 'SAP'
            iv_sucesso      = space
            iv_reason_code  = es_result-reason_code
            iv_mensagem     = es_result-message
            is_client_info  = is_client_info
          IMPORTING
            ev_log_id       = lv_audit_id
            es_result       = ls_audit_result.

        es_result-audit_id = lv_audit_id.

        RETURN.

    ENDTRY.

    es_result-license_valid_to =
      ls_license_result-valid_to.

    es_result-days_remaining =
      ls_license_result-days_remaining.

    IF ls_license_result-valid IS INITIAL.

      es_result-valid       = space.
      es_result-reason_code = 'LICENSE_INVALID'.

      IF ls_license_result-message IS INITIAL.

        es_result-message =
          'Licença OMS inválida.'.

      ELSE.

        es_result-message =
          ls_license_result-message.

      ENDIF.

      CALL METHOD me->registrar_auditoria
        EXPORTING
          iv_usuario      = lv_usuario
          iv_tipo_usuario = 'SAP'
          iv_sucesso      = space
          iv_reason_code  = es_result-reason_code
          iv_mensagem     = es_result-message
          is_client_info  = is_client_info
        IMPORTING
          ev_log_id       = lv_audit_id
          es_result       = ls_audit_result.

      es_result-audit_id = lv_audit_id.

      RETURN.

    ENDIF.

*---------------------------------------------------------------------*
* Auditoria sucesso
*---------------------------------------------------------------------*
    CALL METHOD me->registrar_auditoria
      EXPORTING
        iv_usuario      = lv_usuario
        iv_tipo_usuario = 'SAP'
        iv_sucesso      = 'X'
        iv_reason_code  = 'OK'
        iv_mensagem     = 'Login SAP realizado com sucesso.'
        is_client_info  = is_client_info
      IMPORTING
        ev_log_id       = lv_audit_id
        es_result       = ls_audit_result.

    es_result-audit_id = lv_audit_id.

    es_result-valid       = 'X'.
    es_result-user_name   = lv_usuario.
    es_result-user_type   = 'SAP'.
    es_result-reason_code = 'OK'.
    es_result-message =
      'Login SAP realizado com sucesso.'.

    CLEAR es_result-password_change_required.

  ENDMETHOD.
ENDCLASS.
