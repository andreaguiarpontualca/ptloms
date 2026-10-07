class /PTLOMS/CL030 definition
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
    BEGIN OF ty_config,
             tipo_objeto TYPE /ptloms/ed142,
             objeto      TYPE /ptloms/ed158,
             tipo_evento TYPE /ptloms/ed143,
             id_lista    TYPE /ptloms/ed152,
             email       TYPE /ptloms/tb103-email,
             whatsapp    TYPE /ptloms/tb103-whatsapp,
           END OF ty_config .
  types:
    tt_config TYPE STANDARD TABLE OF ty_config
    WITH DEFAULT KEY .
  types:
    BEGIN OF ty_dest_regra,
             tipo_objeto TYPE /ptloms/ed142,
             objeto      TYPE /ptloms/ed158,
             tipo_evento TYPE /ptloms/ed143,
             id_lista    TYPE /ptloms/ed152,
             usuario     TYPE /ptloms/tb013-usuario,
             email_ativo TYPE /ptloms/tb103-email,
             whats_ativo TYPE /ptloms/tb103-whatsapp,
           END OF ty_dest_regra .
  types:
    tt_dest_regra TYPE STANDARD TABLE OF ty_dest_regra
    WITH DEFAULT KEY .
  types:
    BEGIN OF ty_resultado,
             tipo_objeto    TYPE /ptloms/ed142,
             objeto         TYPE /ptloms/ed158,
             id_lista       TYPE /ptloms/ed152,
             id_notificacao TYPE /ptloms/ed154,
             situacao       TYPE char1,
             mensagem       TYPE /ptloms/ed162,
           END OF ty_resultado .
  types:
    tt_resultado TYPE STANDARD TABLE OF ty_resultado
    WITH DEFAULT KEY .

  constants C_EVENTO_NOTA type /PTLOMS/ED143 value 'N'. "#EC NOTEXT
  constants C_EVENTO_ORDEM type /PTLOMS/ED143 value 'O'. "#EC NOTEXT
  constants C_EVENTO_RESERVA type /PTLOMS/ED143 value 'R'. "#EC NOTEXT
  constants C_OBJ_EQUIP type /PTLOMS/ED142 value 'E'. "#EC NOTEXT
  constants C_OBJ_LOCAL type /PTLOMS/ED142 value 'L'. "#EC NOTEXT
  constants C_OBJ_MATERIAL type /PTLOMS/ED142 value 'M'. "#EC NOTEXT
  constants C_TIPO_ALERTA type /PTLOMS/ED144 value 'A'. "#EC NOTEXT

  class-methods ALERTAS_HABILITADOS
    importing
      !IS_CONTEXTO_TB033 type /PTLOMS/TB033
    exporting
      !EV_HABILITADO type /PTLOMS/ED150
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods REGISTRAR_ALERTA
    importing
      !IS_CONTEXTO_TB033 type /PTLOMS/TB033
      !IV_TIPO_EVENTO type /PTLOMS/ED143
      !IV_TIPO_DOCUMENTO type /PTLOMS/ED155
      !IV_DOCUMENTO type /PTLOMS/ED156
      !IV_ITEM_DOCUMENTO type /PTLOMS/ED157 optional
      !IV_EQUIPAMENTO type EQUNR optional
      !IV_LOCAL_INSTALACAO type TPLNR optional
      !IV_MATERIAL type MATNR optional
      !IV_USUARIO type /PTLOMS/TB013-USUARIO
      !IV_TITULO type /PTLOMS/ED159
      !IV_MENSAGEM type /PTLOMS/ED160
      !IV_INTERVALO type INRI-NRRANGENR
      !IV_SUBOBJETO type INRI-SUBOBJECT optional
      !IV_ANO type INRI-TOYEAR optional
    exporting
      !ET_RESULTADO type TT_RESULTADO
      !EV_CHAVE_LOCK type RSTABLE-VARKEY
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods BUSCAR_CONFIGURACOES
    importing
      !IV_TIPO_EVENTO type /PTLOMS/ED143
      !IV_EQUIPAMENTO type EQUNR optional
      !IV_LOCAL_INSTALACAO type TPLNR optional
      !IV_MATERIAL type MATNR optional
    exporting
      !ET_CONFIGURACOES type TT_CONFIG
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
  class-methods BUSCAR_DESTINATARIOS
    importing
      !IT_CONFIGURACOES type TT_CONFIG
    exporting
      !ET_DESTINATARIOS type TT_DEST_REGRA
      !EV_ERRO type XFELD
      !EV_MENSAGEM type /PTLOMS/ED162 .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL030 IMPLEMENTATION.


  METHOD alertas_habilitados.

    DATA: lt_fields TYPE STANDARD TABLE OF dfies,
          ls_field  TYPE dfies,
          lt_where  TYPE STANDARD TABLE OF string,
          lv_value  TYPE string,
          lv_cond   TYPE string,
          lv_quote  TYPE c LENGTH 1 VALUE '''',
          lv_double TYPE c LENGTH 2 VALUE '''''',
          lv_text   TYPE string,
          lx_error  TYPE REF TO cx_root.
    FIELD-SYMBOLS <lv_key> TYPE any.
    CLEAR: ev_habilitado, ev_erro, ev_mensagem.
    IF is_contexto_tb033-mandt IS NOT INITIAL AND
    is_contexto_tb033-mandt <> sy-mandt.
      ev_erro = 'X'.
      ev_mensagem = 'Contexto TB033 de outro mandante'.
      RETURN.
    ENDIF.
    TRY.
        CALL FUNCTION 'DDIF_FIELDINFO_GET'
          EXPORTING
            tabname        = '/PTLOMS/TB033'
            langu          = sy-langu
          TABLES
            dfies_tab      = lt_fields
          EXCEPTIONS
            not_found      = 1
            internal_error = 2
            OTHERS         = 3.
        IF sy-subrc <> 0 OR lt_fields IS INITIAL.
          ev_erro = 'X'.
          ev_mensagem = 'Nao foi possivel ler chave DDIC da TB033'.
          RETURN.
        ENDIF.
        LOOP AT lt_fields INTO ls_field WHERE keyflag = 'X'.
          IF ls_field-fieldname = 'MANDT'. CONTINUE. ENDIF.
          ASSIGN COMPONENT ls_field-fieldname
          OF STRUCTURE is_contexto_tb033 TO <lv_key>.
          IF sy-subrc <> 0.
            ev_erro = 'X'.
            ev_mensagem = 'Campo-chave nao encontrado no contexto'.
            RETURN.
          ENDIF.
          lv_value = <lv_key>.
          REPLACE ALL OCCURRENCES OF lv_quote IN lv_value
          WITH lv_double.
          CONCATENATE ls_field-fieldname ' = '
          lv_quote lv_value lv_quote INTO lv_cond.
          IF lt_where IS NOT INITIAL.
            CONCATENATE 'AND' lv_cond INTO lv_cond
            SEPARATED BY space.
          ENDIF.
          APPEND lv_cond TO lt_where.
        ENDLOOP.
        SELECT SINGLE alertas INTO ev_habilitado
        FROM /ptloms/tb033 WHERE (lt_where).
        IF sy-subrc <> 0.
          CLEAR ev_habilitado.
          ev_mensagem = 'Contexto TB033 sem configuracao'.
        ELSEIF ev_habilitado <> 'X' AND ev_habilitado <> space.
          CLEAR ev_habilitado.
          ev_erro = 'X'.
          ev_mensagem = 'Valor ALERTAS invalido na TB033'.
        ENDIF.
      CATCH cx_root INTO lx_error.
        CLEAR ev_habilitado.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text RECEIVING result = lv_text.
        ev_mensagem = lv_text.
    ENDTRY.

  ENDMETHOD.


  METHOD buscar_configuracoes.

    TYPES: BEGIN OF ty_obj,
             tipo_objeto TYPE /ptloms/ed142,
             objeto      TYPE /ptloms/ed158,
           END OF ty_obj.
    DATA: lt_obj   TYPE STANDARD TABLE OF ty_obj,
          ls_obj   TYPE ty_obj,
          lv_equip TYPE equnr,
          lv_local TYPE tplnr,
          lv_mat   TYPE matnr,
          lv_text  TYPE string,
          lx_error TYPE REF TO cx_root.
    CLEAR: ev_erro, ev_mensagem.
    REFRESH et_configuracoes.
    IF iv_tipo_evento <> c_evento_nota AND
    iv_tipo_evento <> c_evento_ordem AND
    iv_tipo_evento <> c_evento_reserva.
      ev_erro = 'X'. ev_mensagem = 'Tipo de evento invalido'.
      RETURN.
    ENDIF.
    TRY.
        IF iv_tipo_evento = c_evento_nota OR
        iv_tipo_evento = c_evento_ordem.
          IF iv_equipamento IS NOT INITIAL.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = iv_equipamento
              IMPORTING
                output = lv_equip.
            CLEAR ls_obj.
            ls_obj-tipo_objeto = c_obj_equip.
            ls_obj-objeto = lv_equip.
            APPEND ls_obj TO lt_obj.
          ENDIF.
          IF iv_local_instalacao IS NOT INITIAL.
            CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
              EXPORTING
                input  = iv_local_instalacao
              IMPORTING
                output = lv_local
              EXCEPTIONS
                OTHERS = 1.
            IF sy-subrc <> 0.
              ev_erro = 'X'.
              ev_mensagem = 'Local de Instalacao invalido'.
              RETURN.
            ENDIF.
            CLEAR ls_obj.
            ls_obj-tipo_objeto = c_obj_local.
            ls_obj-objeto = lv_local.
            APPEND ls_obj TO lt_obj.
          ENDIF.
        ELSEIF iv_material IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
            EXPORTING
              input        = iv_material
            IMPORTING
              output       = lv_mat
            EXCEPTIONS
              length_error = 1
              OTHERS       = 2.
          IF sy-subrc <> 0.
            ev_erro = 'X'. ev_mensagem = 'Material invalido'.
            RETURN.
          ENDIF.
          CLEAR ls_obj.
          ls_obj-tipo_objeto = c_obj_material.
          ls_obj-objeto = lv_mat.
          APPEND ls_obj TO lt_obj.
        ENDIF.
        IF lt_obj IS INITIAL. RETURN. ENDIF.
        SELECT a~tipo_objeto a~objeto a~tipo_evento a~id_lista a~email a~whatsapp
          INTO TABLE et_configuracoes
          FROM /ptloms/tb103 AS a
          INNER JOIN /ptloms/tb101 AS b ON b~id_lista = a~id_lista
          FOR ALL ENTRIES IN lt_obj
          WHERE a~tipo_objeto = lt_obj-tipo_objeto
            AND a~objeto = lt_obj-objeto(18)
            AND a~tipo_evento = iv_tipo_evento
            AND a~ativo = 'X' AND b~ativo = 'X'.
        SORT et_configuracoes BY tipo_objeto objeto id_lista.
      CATCH cx_root INTO lx_error.
        REFRESH et_configuracoes.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text RECEIVING result = lv_text.
        ev_mensagem = lv_text.
    ENDTRY.

  ENDMETHOD.


  METHOD buscar_destinatarios.

    TYPES: BEGIN OF ty_membro,
             id_lista TYPE /ptloms/ed152,
             usuario  TYPE /ptloms/tb013-usuario,
           END OF ty_membro.
    DATA: lt_membros TYPE STANDARD TABLE OF ty_membro,
          ls_membro  TYPE ty_membro,
          ls_cfg     TYPE ty_config,
          ls_dest    TYPE ty_dest_regra,
          lv_text    TYPE string,
          lx_error   TYPE REF TO cx_root.
    REFRESH et_destinatarios.
    CLEAR: ev_erro, ev_mensagem.
    IF it_configuracoes IS INITIAL. RETURN. ENDIF.
    LOOP AT it_configuracoes INTO ls_cfg.
      IF ( ls_cfg-email <> space AND ls_cfg-email <> 'X' ) OR
      ( ls_cfg-whatsapp <> space AND ls_cfg-whatsapp <> 'X' ).
        ev_erro = 'X'. ev_mensagem = 'Flags de canal invalidas'.
        RETURN.
      ENDIF.
    ENDLOOP.
    TRY.
        SELECT a~id_lista a~usuario INTO TABLE lt_membros
        FROM /ptloms/tb102 AS a
        INNER JOIN /ptloms/tb101 AS b ON b~id_lista = a~id_lista
        FOR ALL ENTRIES IN it_configuracoes
        WHERE a~id_lista = it_configuracoes-id_lista
        AND b~ativo = 'X'.
        SORT lt_membros BY id_lista usuario.
        DELETE ADJACENT DUPLICATES FROM lt_membros
        COMPARING id_lista usuario.
        LOOP AT it_configuracoes INTO ls_cfg.
          LOOP AT lt_membros INTO ls_membro
          WHERE id_lista = ls_cfg-id_lista.
            CLEAR ls_dest.
            ls_dest-tipo_objeto = ls_cfg-tipo_objeto.
            ls_dest-objeto = ls_cfg-objeto.
            ls_dest-tipo_evento = ls_cfg-tipo_evento.
            ls_dest-id_lista = ls_cfg-id_lista.
            ls_dest-usuario = ls_membro-usuario.
            ls_dest-email_ativo = ls_cfg-email.
            ls_dest-whats_ativo = ls_cfg-whatsapp.
            APPEND ls_dest TO et_destinatarios.
          ENDLOOP.
        ENDLOOP.
        SORT et_destinatarios BY tipo_objeto objeto tipo_evento id_lista usuario.
        DELETE ADJACENT DUPLICATES FROM et_destinatarios COMPARING tipo_objeto objeto tipo_evento id_lista usuario.
      CATCH cx_root INTO lx_error.
        REFRESH et_destinatarios.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text RECEIVING result = lv_text.
        ev_mensagem = lv_text.
    ENDTRY.

  ENDMETHOD.


  METHOD registrar_alerta.

    TYPES: BEGIN OF ty_hist,
             tipo_objeto    TYPE /ptloms/ed142,
             objeto         TYPE /ptloms/ed158,
             id_lista       TYPE /ptloms/ed152,
             id_notificacao TYPE /ptloms/ed154,
           END OF ty_hist.
    TYPES: BEGIN OF ty_owner,
             usuario TYPE /ptloms/tb013-usuario,
           END OF ty_owner.
    DATA: lt_cfg    TYPE tt_config,
          ls_cfg    TYPE ty_config,
          lt_dest   TYPE tt_dest_regra,
          ls_dest   TYPE ty_dest_regra,
          lt_hist   TYPE STANDARD TABLE OF ty_hist,
          ls_hist   TYPE ty_hist,
          lt_owner  TYPE SORTED TABLE OF ty_owner
           WITH UNIQUE KEY usuario,
          ls_owner  TYPE ty_owner,
          lt_send   TYPE /ptloms/cl029=>tt_destinatario,
          ls_send   TYPE /ptloms/cl029=>ty_destinatario,
          ls_h      TYPE /ptloms/tb104,
          ls_result TYPE ty_resultado,
          lv_ativo  TYPE /ptloms/ed150,
          lv_doc    TYPE /ptloms/ed156,
          lv_item   TYPE /ptloms/ed157,
          lv_qmnum  TYPE qmnum,
          lv_aufnr  TYPE aufnr,
          lv_rsnum  TYPE rsnum,
          lv_rspos  TYPE rspos,
          lv_lock   TYPE rstable-varkey,
          lv_id     TYPE /ptloms/ed154,
          lv_error  TYPE xfeld,
          lv_msg    TYPE /ptloms/ed162,
          lv_text   TYPE string,
          lx_error  TYPE REF TO cx_root.
    CLEAR: ev_chave_lock, ev_erro, ev_mensagem.
    REFRESH et_resultado.
    CALL METHOD /ptloms/cl030=>alertas_habilitados
      EXPORTING
        is_contexto_tb033 = is_contexto_tb033
      IMPORTING
        ev_habilitado     = lv_ativo
        ev_erro           = ev_erro
        ev_mensagem       = ev_mensagem.
    IF ev_erro = 'X' OR
       lv_ativo <> 'X'.
      RETURN.
    ENDIF.
    IF iv_documento IS INITIAL OR
       iv_documento(1) = '%' OR
       iv_documento CA '*@#' OR
       iv_item_documento CA '*@#' OR
       iv_tipo_documento IS INITIAL OR
       iv_usuario IS INITIAL OR
       iv_titulo IS INITIAL OR
       iv_mensagem IS INITIAL OR
       iv_intervalo IS INITIAL.
      ev_erro = 'X'.
      ev_mensagem = 'Dados do evento invalidos'.
      RETURN.
    ENDIF.
    TRY.
        CASE iv_tipo_evento.
          WHEN c_evento_nota.
            IF strlen( iv_documento ) > 12 OR
            iv_item_documento IS NOT INITIAL.
              ev_erro = 'X'. ev_mensagem = 'Nota ou item invalidos'.
              RETURN.
            ENDIF.
            lv_qmnum = iv_documento.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_qmnum
              IMPORTING
                output = lv_qmnum.
            lv_doc = lv_qmnum.
          WHEN c_evento_ordem.
            IF strlen( iv_documento ) > 12 OR
            iv_item_documento IS NOT INITIAL.
              ev_erro = 'X'. ev_mensagem = 'Ordem ou item invalidos'.
              RETURN.
            ENDIF.
            lv_aufnr = iv_documento.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_aufnr
              IMPORTING
                output = lv_aufnr.
            lv_doc = lv_aufnr.
          WHEN c_evento_reserva.
            IF strlen( iv_documento ) > 10 OR
              strlen( iv_item_documento ) > 4 OR
              iv_documento CN '0123456789 ' OR
              iv_item_documento CN '0123456789 '.
              ev_erro = 'X'. ev_mensagem = 'Reserva ou item invalidos'.
              RETURN.
            ENDIF.
            lv_rsnum = iv_documento.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_rsnum
              IMPORTING
                output = lv_rsnum.
            lv_doc = lv_rsnum.
            IF iv_item_documento IS NOT INITIAL.
              lv_rspos = iv_item_documento.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lv_rspos
                IMPORTING
                  output = lv_rspos.
              lv_item = lv_rspos.
            ENDIF.
          WHEN OTHERS.
            ev_erro = 'X'. ev_mensagem = 'Evento invalido'.
            RETURN.
        ENDCASE.
        IF lv_doc CO '0 '.
          ev_erro = 'X'. ev_mensagem = 'Documento nulo'.
          RETURN.
        ENDIF.
        CLEAR lv_lock.
        lv_lock+0(3) = sy-mandt.
        lv_lock+3(1) = c_tipo_alerta.
        lv_lock+4(1) = iv_tipo_evento.
        lv_lock+5(20) = lv_doc.
        lv_lock+25(10) = lv_item.
        lv_lock+35(1) = '#'.
        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = 'E'
            tabname        = '/PTLOMS/TB104'
            varkey         = lv_lock
            _scope         = '1'
            _wait          = space
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc <> 0.
          ev_erro = 'X'.
          ev_mensagem = 'Evento bloqueado ou servico indisponivel'.
          RETURN.
        ENDIF.
        ev_chave_lock = lv_lock.
        CALL METHOD /ptloms/cl030=>buscar_configuracoes
          EXPORTING
            iv_tipo_evento      = iv_tipo_evento
            iv_equipamento      = iv_equipamento
            iv_local_instalacao = iv_local_instalacao
            iv_material         = iv_material
          IMPORTING
            et_configuracoes    = lt_cfg
            ev_erro             = ev_erro
            ev_mensagem         = ev_mensagem.
        IF ev_erro = 'X' OR
           lt_cfg IS INITIAL.
          RETURN.
        ENDIF.
        CALL METHOD /ptloms/cl030=>buscar_destinatarios
          EXPORTING
            it_configuracoes = lt_cfg
          IMPORTING
            et_destinatarios = lt_dest
            ev_erro          = ev_erro
            ev_mensagem      = ev_mensagem.
        IF ev_erro = 'X'.
          RETURN.
        ENDIF.
        SELECT tipo_objeto objeto id_lista id_notificacao
          INTO TABLE lt_hist FROM /ptloms/tb104
          WHERE tipo_notificacao = c_tipo_alerta
            AND tipo_evento = iv_tipo_evento
            AND documento = lv_doc AND item_documento = lv_item.
        SELECT DISTINCT b~usuario INTO TABLE lt_owner
          FROM /ptloms/tb104 AS a
          INNER JOIN /ptloms/tb105 AS b
          ON b~id_notificacao = a~id_notificacao
          WHERE a~tipo_notificacao = c_tipo_alerta
            AND a~tipo_evento = iv_tipo_evento
            AND a~documento = lv_doc AND a~item_documento = lv_item
            AND ( b~status_email = 'P' OR b~status_email = 'S' OR
                  b~status_email = 'E' ).
        LOOP AT lt_cfg INTO ls_cfg.
          CLEAR: ls_result, ls_h, lv_error, lv_msg, lv_id.
          REFRESH lt_send.
          ls_result-tipo_objeto = ls_cfg-tipo_objeto.
          ls_result-objeto = ls_cfg-objeto.
          ls_result-id_lista = ls_cfg-id_lista.
          READ TABLE lt_hist INTO ls_hist WITH KEY
          tipo_objeto = ls_cfg-tipo_objeto objeto = ls_cfg-objeto
          id_lista = ls_cfg-id_lista.
          IF sy-subrc = 0.
            ls_result-id_notificacao = ls_hist-id_notificacao.
            ls_result-situacao = 'J'.
            ls_result-mensagem = 'Regra ja registrada para o evento'.
            APPEND ls_result TO et_resultado.
            CONTINUE.
          ENDIF.
          LOOP AT lt_dest INTO ls_dest
            WHERE tipo_objeto = ls_cfg-tipo_objeto
              AND objeto = ls_cfg-objeto
              AND id_lista = ls_cfg-id_lista.
            CLEAR ls_send.
            ls_send-usuario = ls_dest-usuario.
            ls_send-email_ativo = ls_dest-email_ativo.
            ls_send-whats_ativo = ls_dest-whats_ativo.
            READ TABLE lt_owner TRANSPORTING NO FIELDS
              WITH TABLE KEY usuario = ls_dest-usuario.
            IF sy-subrc = 0.
              CLEAR ls_send-email_ativo.
            ENDIF.
            APPEND ls_send TO lt_send.
          ENDLOOP.
          IF lt_send IS INITIAL.
            ls_result-situacao = 'V'.
            ls_result-mensagem = 'Lista sem destinatarios'.
            APPEND ls_result TO et_resultado.
            CONTINUE.
          ENDIF.
          ls_h-tipo_notificacao = c_tipo_alerta.
          ls_h-tipo_evento = iv_tipo_evento.
          ls_h-tipo_documento = iv_tipo_documento.
          ls_h-documento = lv_doc. ls_h-item_documento = lv_item.
          ls_h-ordem = lv_aufnr.
          ls_h-tipo_objeto = ls_cfg-tipo_objeto.
          ls_h-objeto = ls_cfg-objeto. ls_h-id_lista = ls_cfg-id_lista.
          ls_h-titulo = iv_titulo. ls_h-mensagem = iv_mensagem.
          ls_h-usuario_criacao = iv_usuario.
          CALL METHOD /ptloms/cl029=>registrar
            EXPORTING
              is_notificacao    = ls_h
              it_destinatarios  = lt_send
              iv_intervalo      = iv_intervalo
              iv_subobjeto      = iv_subobjeto
              iv_ano            = iv_ano
            IMPORTING
              ev_id_notificacao = lv_id
              ev_erro           = lv_error
              ev_mensagem       = lv_msg.
          IF lv_error = 'X'.
            ls_result-situacao = 'F'. ls_result-mensagem = lv_msg.
            APPEND ls_result TO et_resultado.
            ev_erro = 'X'.
            ev_mensagem = lv_msg.
            EXIT.
          ENDIF.
          ls_result-situacao = 'C'.
          ls_result-id_notificacao = lv_id.
          APPEND ls_result TO et_resultado.
          LOOP AT lt_send INTO ls_send
            WHERE email_ativo = 'X'.
            ls_owner-usuario = ls_send-usuario.
            INSERT ls_owner INTO TABLE lt_owner.
          ENDLOOP.
        ENDLOOP.
      CATCH cx_root INTO lx_error.
        ev_erro = 'X'.
        CALL METHOD lx_error->get_text RECEIVING result = lv_text.
        ev_mensagem = lv_text.
    ENDTRY.
* Nao liberar aqui: o chamador ainda nao confirmou sua LUW.

  ENDMETHOD.
ENDCLASS.
