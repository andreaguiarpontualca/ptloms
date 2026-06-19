class /PTLOMS/CL016 definition
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

  methods BUSCA_LISTA_ASSOCIAR
    importing
      value(IT_LISTA) type /PTLOMS/CT123
    exporting
      value(ET_LISTA) type /PTLOMS/CT123 .
  methods BUSCA_DETALHE_ORDEM
    importing
      value(I_AUFNR) type AUFNR
      value(I_VORNR) type VORNR
    exporting
      value(E_DETALHE) type /PTLOMS/ET147 .
  methods BUSCA_MOTIVO
    importing
      value(I_CODIGO) type /PTLOMS/ET117-CODIGO
    exporting
      value(E_MOTIVO) type /PTLOMS/CT086 .
  methods BUSCA_DETALHE_OPERACAO
    importing
      value(I_DETALHE) type /PTLOMS/CT127
    exporting
      value(E_DETALHE) type /PTLOMS/CT126 .
  methods BUSCA_DETALHE_CLIENTE
    importing
      value(I_CLIENTE) type /PTLOMS/CT130
    exporting
      value(E_DETALHE) type /PTLOMS/CT129 .
  methods BUSCA_LISTA_ANEXO
    importing
      value(IT_LISTA) type /PTLOMS/CT130
    exporting
      value(ET_LISTA) type /PTLOMS/CT136 .
  methods BUSCA_LISTA_ANEXO_INSTALACAO
    importing
      value(IT_LISTA) type /PTLOMS/CT140
    exporting
      value(ET_LISTA) type /PTLOMS/CT141 .
  methods BUSCA_LISTA_ANEXO_ORDEM
    importing
      value(IT_LISTA) type /PTLOMS/CT145
    exporting
      value(ET_LISTA) type /PTLOMS/CT146 .
  methods BUSCA_LISTA_DETALHE_NOTA
    importing
      value(IT_LISTA) type /PTLOMS/CT147
    exporting
      value(ET_LISTA) type /PTLOMS/CT148 .
  methods BUSCA_HISTORICO_RASTREA_USR
    importing
      value(I_USUARIO) type /PTLOMS/ET192-USUARIO optional
      value(I_MATRICULA) type /PTLOMS/ET192-MATRICULA optional
      value(I_GUID) type /PTLOMS/ET192-GUID optional
      value(I_PERFIL) type /PTLOMS/ET192-PERFIL optional
      value(I_DATA_INI) type /PTLOMS/ET192-DATA_INI optional
      value(I_DATA_FIM) type /PTLOMS/ET192-DATA_FIM optional
    exporting
      value(E_HISTORICO_RASTREA_USR) type /PTLOMS/CT164
      value(E_RETORNO) type /PTLOMS/CT156 .
  methods BUSCA_HISTORICO_ASSINATURAS
    importing
      value(I_USUARIO) type /PTLOMS/ET184-USUARIO_APP optional
      value(I_OPERACAO) type /PTLOMS/ET184-ACTIVITY optional
      value(I_ORDEM) type /PTLOMS/ET184-ORDERID optional
      value(I_DATA_INI) type /PTLOMS/ET184-DATA_CRIACAO_APP optional
      value(I_DATA_FIM) type /PTLOMS/ET184-DATA_CRIACAO_APP optional
    exporting
      value(E_HISTORICO_ASSINATURA) type /PTLOMS/CT159
      value(E_RETORNO) type /PTLOMS/CT156 .
  methods BUSCA_DADOS_RASTREA_USR
    importing
      value(I_USUARIO) type /PTLOMS/ET194-USUARIO optional
      value(I_MATRICULA) type /PTLOMS/ET194-MATRICULA optional
      value(I_DATA_INI) type /PTLOMS/ET194-DATA_INI optional
      value(I_DATA_FIM) type /PTLOMS/ET194-DATA_FIM optional
    exporting
      value(E_DADOS_RASTREA_USR) type /PTLOMS/CT165
      value(E_RETORNO) type /PTLOMS/CT156 .
protected section.
private section.

  data IT_LISTA type /PTLOMS/CT123 .
  data IT_RETORNO type /PTLOMS/CT060 .
ENDCLASS.



CLASS /PTLOMS/CL016 IMPLEMENTATION.


  METHOD busca_dados_rastrea_usr.

    DATA: lt_tb078    TYPE TABLE OF /ptloms/tb078,
          ls_tb078    TYPE /ptloms/tb078,
          ls_registro LIKE LINE OF e_dados_rastrea_usr,
          ls_retorno  TYPE /ptloms/et060,
          lv_where    TYPE string.

    DATA: r_usuario   TYPE RANGE OF /ptloms/et192-usuario,
          r_matricula TYPE RANGE OF /ptloms/et192-matricula,
          r_erdat     TYPE RANGE OF /ptloms/et192-data_criacao.

    DATA: ls_usuario   LIKE LINE OF r_usuario,
          ls_matricula LIKE LINE OF r_matricula,
          ls_erdat     LIKE LINE OF r_erdat.

    DATA: lv_date_str      TYPE char10,
          lv_time_str      TYPE char8,
          lv_date_time_str TYPE char30.


    FIELD-SYMBOLS: <fs_e_dados_rastrea_usr> LIKE LINE OF e_dados_rastrea_usr.

    CLEAR lv_where.

    IF i_usuario IS NOT INITIAL.

      ls_usuario-sign = 'I'.
      ls_usuario-option = 'EQ'.
      ls_usuario-low = i_usuario.
      APPEND ls_usuario TO r_usuario.

      IF lv_where IS INITIAL.
        lv_where = 'usuario IN r_usuario'.
      ELSE.
        CONCATENATE lv_where 'AND usuario IN r_usuario' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    IF i_matricula IS NOT INITIAL.

      ls_matricula-sign = 'I'.
      ls_matricula-option = 'EQ'.
      ls_matricula-low = i_matricula.
      APPEND ls_matricula TO r_matricula.

      IF lv_where IS INITIAL.
        lv_where = 'matricula IN r_matricula'.
      ELSE.
        CONCATENATE lv_where 'AND matricula IN r_matricula' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    IF i_data_ini IS NOT INITIAL OR i_data_fim IS NOT INITIAL.
      ls_erdat-sign = 'I'.
      ls_erdat-option = 'BT'.
      IF i_data_ini IS NOT INITIAL.
        ls_erdat-low = i_data_ini.
      ELSE.
        ls_erdat-low = '00000000'.
      ENDIF.

      IF i_data_fim IS NOT INITIAL.
        ls_erdat-high = i_data_fim.
      ELSE.
        ls_erdat-high = sy-datum.
      ENDIF.
      APPEND ls_erdat TO r_erdat.

      IF lv_where IS INITIAL.
        lv_where = 'data_criacao IN r_erdat'.
      ELSE.
        CONCATENATE lv_where 'AND data_criacao IN r_erdat' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    SELECT *
      FROM /ptloms/tb078
      INTO CORRESPONDING FIELDS OF TABLE e_dados_rastrea_usr
      WHERE (lv_where).

    IF sy-subrc <> 0.
      ls_retorno-chave   = 'X'.
      ls_retorno-type    = 'W'.
      ls_retorno-message = 'Nenhum dado encontrado na Tab. /PTLOMS/TB079'.
      APPEND ls_retorno TO e_retorno.
      EXIT.
    ENDIF.

    LOOP AT e_dados_rastrea_usr ASSIGNING <fs_e_dados_rastrea_usr>.

      CLEAR: lv_time_str, lv_date_str, lv_date_time_str.
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = <fs_e_dados_rastrea_usr>-data_coleta
        IMPORTING
          output = lv_date_str.

      REPLACE ALL OCCURRENCES OF '.' IN lv_date_str WITH '/'.

      lv_time_str = <fs_e_dados_rastrea_usr>-hora_coleta(2)   && ':' &&
                    <fs_e_dados_rastrea_usr>-hora_coleta+3(2) && ':' &&
                    <fs_e_dados_rastrea_usr>-hora_coleta+4(2).

      CONCATENATE lv_date_str ',' INTO lv_date_time_str.
      CONCATENATE lv_date_time_str lv_time_str INTO <fs_e_dados_rastrea_usr>-data_hora_coleta_str SEPARATED BY space.

      CLEAR: lv_time_str, lv_date_str, lv_date_time_str.
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = <fs_e_dados_rastrea_usr>-data_criacao
        IMPORTING
          output = lv_date_str.

      REPLACE ALL OCCURRENCES OF '.' IN lv_date_str WITH '/'.

      lv_time_str = <fs_e_dados_rastrea_usr>-hora_criacao(2)   && ':' &&
                    <fs_e_dados_rastrea_usr>-hora_criacao+3(2) && ':' &&
                    <fs_e_dados_rastrea_usr>-hora_criacao+4(2).

      CONCATENATE lv_date_str ',' INTO lv_date_time_str.
      CONCATENATE lv_date_time_str lv_time_str INTO <fs_e_dados_rastrea_usr>-data_hora_criacao_str SEPARATED BY space.

    ENDLOOP.

    ls_retorno-chave   = 'X'.
    ls_retorno-type    = 'S'.
    ls_retorno-message = 'Sucesso'.
    APPEND ls_retorno TO e_retorno.

    UNASSIGN <fs_e_dados_rastrea_usr>.

  ENDMETHOD.


  METHOD busca_detalhe_cliente.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 11/12/2025 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************

    DATA:
      w_cliente LIKE LINE OF i_cliente,
      y_detalhe LIKE LINE OF e_detalhe,
      ls_ihpa   TYPE ihpa,
      ls_ihpap  TYPE ihpa,
      lv_objnr  TYPE equi-objnr,
      lv_kunnr  TYPE kna1-kunnr,
      lv_parvw  TYPE ihpa-parvw.

    CONSTANTS: c_ag  TYPE ihpa-parvw VALUE 'AG',   " Valor interno = AG, Valor Externo (rot. conversão) = SP Emissor da Ordem
               c_ieq TYPE ihpa-obtyp VALUE 'IEQ'.

* Dados do cliente
    LOOP AT i_cliente      INTO w_cliente.

      CLEAR:
        y_detalhe.

      MOVE w_cliente-equinr   TO y_detalhe-equinr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = y_detalhe-equinr
        IMPORTING
          output = w_cliente-equinr.

      SELECT SINGLE kunnr
        FROM eqbs
        INTO lv_kunnr
        WHERE equnr EQ w_cliente-equinr.

      IF sy-subrc IS INITIAL.

        SELECT SINGLE name1
                      name2
                      telf1
                      stras
                      ort01
                      pstlz
                      regio
                      adrnr
                      ort02
          FROM kna1
          INTO (y_detalhe-name1,y_detalhe-name2,y_detalhe-telfl,y_detalhe-stras,y_detalhe-ort01,y_detalhe-pstlz,y_detalhe-regio,y_detalhe-adrnr,y_detalhe-ort02)
          WHERE kunnr EQ lv_kunnr.

        IF sy-subrc IS INITIAL.

          SELECT street house_num1
            UP TO 1 ROWS
            FROM adrc
            INTO (y_detalhe-street,y_detalhe-house_num1)
            WHERE addrnumber = y_detalhe-adrnr.
          ENDSELECT.

          y_detalhe-tiporetorno   = 'S'.
        ELSE.
          y_detalhe-tiporetorno   = 'E'.
        ENDIF.

      ELSE.

        SELECT SINGLE objnr
          FROM equi
          INTO lv_objnr
          WHERE equnr EQ w_cliente-equinr.

        IF sy-subrc IS INITIAL.
          SELECT objnr parvw counter parnr
            UP TO 1 ROWS
            FROM ihpa
            INTO CORRESPONDING FIELDS OF ls_ihpa
            WHERE objnr    EQ lv_objnr
              AND parvw    EQ c_ag
              AND kzloesch EQ space.
          ENDSELECT.

          IF sy-subrc IS INITIAL.

* Busca Equipamentos do Cliente
            SELECT objnr parvw counter parnr
              UP TO 1 ROWS
              FROM ihpa
              INTO CORRESPONDING FIELDS OF ls_ihpap
              WHERE parvw    = c_ag
                AND obtyp    = c_ieq
                AND parnr    = ls_ihpa-parnr
                AND kzloesch = space.
            ENDSELECT.

            IF sy-subrc IS INITIAL.

*              SELECT SINGLE kunnr
*                            name1
*                            name2
*                            telf1
*                            ort01
*                            pstlz
*                            regio
*                            adrnr
*                            ort02
*                FROM kna1
*                INTO ( lv_kunnr,y_detalhe-name1,y_detalhe-name2,y_detalhe-telfl,y_detalhe-ort01,y_detalhe-pstlz,y_detalhe-regio,y_detalhe-adrnr,y_detalhe-ort02 )
*                WHERE kunnr EQ ls_ihpap-parnr.

              SELECT SINGLE kunnr
                            name1
                            name2
                            telf1
                            ort01
                            pstlz
                            regio
                            adrnr
                            ort02
                FROM kna1
                INTO (lv_kunnr,y_detalhe-name1,y_detalhe-name2,y_detalhe-telfl,y_detalhe-ort01,y_detalhe-pstlz,y_detalhe-regio,y_detalhe-adrnr,y_detalhe-ort02)
                WHERE kunnr EQ ls_ihpap-parnr.

              " Buscar o endereço completo comn 60 caracteres da ADRC - 23/03/2023
              IF sy-subrc IS INITIAL.

                SELECT name1 street house_num1
                  UP TO 1 ROWS
                  FROM adrc
                  INTO (y_detalhe-name1,y_detalhe-stras,y_detalhe-house_num1)
                  WHERE addrnumber EQ y_detalhe-adrnr.
                ENDSELECT.

                y_detalhe-tiporetorno   = 'S'.

              ELSE.
                y_detalhe-tiporetorno   = 'E'.
              ENDIF.

            ELSE.
              y_detalhe-tiporetorno   = 'E'.
            ENDIF.

          ELSE.
            y_detalhe-tiporetorno   = 'E'.
          ENDIF.

        ELSE.
          y_detalhe-tiporetorno   = 'E'.
        ENDIF.

      ENDIF.

      APPEND y_detalhe      TO e_detalhe.

    ENDLOOP.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
  ENDMETHOD.


  METHOD busca_detalhe_operacao.

    DATA: e_operations  TYPE bapi_alm_order_operation_e,
          lt_text_lines TYPE TABLE OF bapi_alm_text_lines,
          ls_text_lines TYPE bapi_alm_text_lines,
          lt_text       TYPE TABLE OF bapi_alm_text,
          w_detalhe     LIKE LINE OF i_detalhe,
          s_detalhe     LIKE LINE OF e_detalhe,
          v_aufnr       TYPE aufnr,
          v_vornr       TYPE vornr,
          lt_retorno    TYPE bapiret2_t,
          ls_retorno    LIKE LINE OF lt_retorno.

    DATA: lt_tb022 TYPE TABLE OF /ptloms/tb022,
          ls_tb022 LIKE LINE OF lt_tb022.

    SELECT *
      FROM /ptloms/tb022
      INTO TABLE lt_tb022
      WHERE perfil NE ' '.

    CLEAR e_detalhe.

    LOOP AT i_detalhe   INTO w_detalhe.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = w_detalhe-aufnr
        IMPORTING
          output = v_aufnr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = w_detalhe-vornr
        IMPORTING
          output = v_vornr.

      CLEAR:
        e_operations.

      REFRESH:
        lt_retorno,
        lt_text,
        lt_text_lines.

      CALL FUNCTION 'BAPI_ALM_OPERATION_GET_DETAIL'
        EXPORTING
          iv_orderid    = v_aufnr
          iv_activity   = v_vornr
        IMPORTING
          es_operation  = e_operations
        TABLES
          return        = lt_retorno
          et_text       = lt_text
          et_text_lines = lt_text_lines.

      IF  sy-subrc      = 0.

        MOVE:
          w_detalhe-aufnr   TO s_detalhe-aufnr,
          w_detalhe-vornr   TO s_detalhe-vornr.

        MOVE-CORRESPONDING e_operations TO s_detalhe.

        READ TABLE lt_tb022 INTO ls_tb022 WITH KEY auart = s_detalhe-control_key.

        IF sy-subrc IS INITIAL.
          s_detalhe-filtro_catalogo = ls_tb022-filtro_catalogo.
        ENDIF.

        LOOP AT lt_text_lines INTO ls_text_lines.

          CONCATENATE s_detalhe-tdline ls_text_lines INTO s_detalhe-tdline.

        ENDLOOP.

        APPEND s_detalhe    TO e_detalhe.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD busca_detalhe_ordem.

    DATA: e_operations  TYPE bapi_alm_order_operation_e,
          lt_text_lines TYPE TABLE OF bapi_alm_text_lines,
          ls_text_lines TYPE bapi_alm_text_lines,
          lt_text       TYPE TABLE OF bapi_alm_text,
          lt_retorno    TYPE bapiret2_t,
          ls_retorno    LIKE LINE OF lt_retorno.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_aufnr
      IMPORTING
        output = i_aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_vornr
      IMPORTING
        output = i_vornr.

    CALL FUNCTION 'BAPI_ALM_OPERATION_GET_DETAIL'
      EXPORTING
        iv_orderid    = i_aufnr
        iv_activity   = i_vornr
      IMPORTING
        es_operation  = e_operations
      TABLES
        return        = lt_retorno
        et_text       = lt_text
        et_text_lines = lt_text_lines.

    IF  sy-subrc      = 0.
      CLEAR e_detalhe.
      MOVE-CORRESPONDING e_operations TO e_detalhe.
      MOVE:
        i_aufnr   TO e_detalhe-aufnr,
        i_vornr   TO e_detalhe-vornr.

      LOOP AT lt_text_lines INTO ls_text_lines.

        CONCATENATE e_detalhe-tdline ls_text_lines INTO e_detalhe-tdline.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD busca_historico_assinaturas.

    DATA: lt_tb077    TYPE TABLE OF /ptloms/tb077,
          ls_tb077    TYPE /ptloms/tb077,
          ls_registro LIKE LINE OF e_historico_assinatura,
          ls_retorno  TYPE /ptloms/et060,
          lv_where    TYPE string,
          lv_ordem    TYPE /ptloms/tb077-aufnr,
          lv_operacao TYPE /ptloms/tb077-vornr.

    DATA: r_usuario  TYPE RANGE OF /ptloms/et184-usuario_app,
          r_operacao TYPE RANGE OF /ptloms/et184-activity,
          r_ordem    TYPE RANGE OF /ptloms/et184-orderid,
          r_erdat    TYPE RANGE OF /ptloms/et184-data_criacao_app.

    DATA: ls_usuario  LIKE LINE OF r_usuario,
          ls_operacao LIKE LINE OF r_operacao,
          ls_ordem    LIKE LINE OF r_ordem,
          ls_erdat    LIKE LINE OF r_erdat.

*    IF i_usuario IS NOT INITIAL.
*      ls_usuario-sign = 'I'.
*      ls_usuario-option = 'EQ'.
*      ls_usuario-low = i_usuario.
*      APPEND ls_usuario TO r_usuario.
*    ENDIF.
*
*    IF i_operacao IS NOT INITIAL.
*      ls_operacao-sign = 'I'.
*      ls_operacao-option = 'EQ'.
*      ls_operacao-low = i_operacao.
*
**      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
**        EXPORTING
**          input  = i_operacao
**        IMPORTING
**          output = ls_operacao-low.
*
*      APPEND ls_operacao TO r_operacao.
*    ENDIF.
*
*    IF i_ordem IS NOT INITIAL.
*      ls_ordem-sign = 'I'.
*      ls_ordem-option = 'EQ'.
*
**      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
**        EXPORTING
**          input  = i_ordem
**        IMPORTING
**          output = ls_ordem-low.
*
*      ls_ordem-low = i_ordem.
*      APPEND ls_ordem TO r_ordem.
*    ENDIF.
*
*    ls_erdat-sign = 'I'.
*    ls_erdat-option = 'BT'.
*    IF i_data_ini IS NOT INITIAL.
*      ls_erdat-low = i_data_ini.
*    ELSE.
*      ls_erdat-low = '00000000'.
*    ENDIF.
*
*    IF i_data_fim IS NOT INITIAL.
*      ls_erdat-high = i_data_fim.
*    ELSE.
*      ls_erdat-high = sy-datum.
*    ENDIF.
*    APPEND ls_erdat TO r_erdat.
*
*    SELECT *
*      FROM /ptloms/tb077
*     INTO TABLE lt_tb077
*     WHERE "usuario_app      IN r_usuario
*        vornr            IN r_operacao
*       AND aufnr            IN r_ordem.
**       AND data_criacao_app IN r_erdat.

    CLEAR lv_where.

    IF i_usuario IS NOT INITIAL.
      ls_usuario-sign = 'I'.
      ls_usuario-option = 'EQ'.
      ls_usuario-low = i_usuario.
      APPEND ls_usuario TO r_usuario.

      IF lv_where IS INITIAL.
        lv_where = 'usuario_app IN r_usuario'.
      ELSE.
        CONCATENATE lv_where 'AND usuario_app IN r_usuario' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    IF i_operacao IS NOT INITIAL.
      ls_operacao-sign = 'I'.
      ls_operacao-option = 'EQ'.
*      ls_operacao-low = i_operacao.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_operacao
        IMPORTING
          output = lv_operacao.

      ls_operacao-low = lv_operacao.

      APPEND ls_operacao TO r_operacao.

      IF lv_where IS INITIAL.
        lv_where = 'vornr IN r_operacao'.
      ELSE.
        CONCATENATE lv_where 'AND vornr IN r_operacao' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    IF i_ordem IS NOT INITIAL.
      ls_ordem-sign = 'I'.
      ls_ordem-option = 'EQ'.
*      ls_ordem-low = i_ordem.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_ordem
        IMPORTING
          output = lv_ordem.

      ls_ordem-low = lv_ordem.

      APPEND ls_ordem TO r_ordem.

      IF lv_where IS INITIAL.
        lv_where = 'aufnr IN r_ordem'.
      ELSE.
        CONCATENATE lv_where 'AND aufnr IN r_ordem' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.


    IF i_data_ini IS NOT INITIAL OR i_data_fim IS NOT INITIAL.
      ls_erdat-sign = 'I'.
      ls_erdat-option = 'BT'.
      IF i_data_ini IS NOT INITIAL.
        ls_erdat-low = i_data_ini.
      ELSE.
        ls_erdat-low = '00000000'.
      ENDIF.

      IF i_data_fim IS NOT INITIAL.
        ls_erdat-high = i_data_fim.
      ELSE.
        ls_erdat-high = sy-datum.
      ENDIF.
      APPEND ls_erdat TO r_erdat.

      IF lv_where IS INITIAL.
        lv_where = 'data_criacao_app IN r_erdat'.
      ELSE.
        CONCATENATE lv_where 'AND data_criacao_app IN r_erdat' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    SELECT *
      FROM /ptloms/tb077
      INTO TABLE lt_tb077
      WHERE (lv_where).

    IF sy-subrc <> 0.
      ls_retorno-chave   = 'X'.
      ls_retorno-type    = 'W'.
      ls_retorno-message = 'Nenhum dado encontrado na Tab. /PTLOMS/TB077'.
      APPEND ls_retorno TO e_retorno.
      EXIT.
    ENDIF.

    ls_retorno-chave   = 'X'.
    ls_retorno-type    = 'S'.
    ls_retorno-message = 'Sucesso'.
    APPEND ls_retorno TO e_retorno.

    IF lt_tb077[] IS NOT INITIAL.

      CLEAR ls_tb077.
      LOOP AT lt_tb077 INTO ls_tb077.

        CLEAR ls_registro.
        MOVE-CORRESPONDING ls_tb077 TO ls_registro.

        ls_registro-chave = 'X'.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_tb077-aufnr
          IMPORTING
            output = ls_registro-orderid.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_tb077-vornr
          IMPORTING
            output = ls_registro-activity.

        ls_registro-nome = ls_tb077-nome_assinante.
        ls_registro-tipo_identificacao = ls_tb077-tipo_doc_id.
        ls_registro-identificacao = ls_tb077-doc_id.
        ls_registro-assinatura_base64 = ls_tb077-arquivo_assinatura.
        ls_registro-usuario_criacao = ls_tb077-usuario.

        ls_registro-data_criacao_app = |{ ls_tb077-data_criacao_app+6(2) }/{ ls_tb077-data_criacao_app+4(2) }/{ ls_tb077-data_criacao_app(4) }|.
        ls_registro-hora_criacao_app = |{ ls_tb077-hora_criacao_app(2) }:{ ls_tb077-hora_criacao_app+2(2) }:{ ls_tb077-hora_criacao_app+4(2) }|.
        ls_registro-data_criacao     = |{ ls_tb077-data_criacao+6(2) }/{ ls_tb077-data_criacao+4(2) }/{ ls_tb077-data_criacao(4) }|.
        ls_registro-hora_criacao     = |{ ls_tb077-hora_criacao(2) }:{ ls_tb077-hora_criacao+2(2) }:{ ls_tb077-hora_criacao+4(2) }|.

        APPEND ls_registro TO e_historico_assinatura.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD busca_historico_rastrea_usr.

    DATA: lt_tb079    TYPE TABLE OF /ptloms/tb079,
          ls_tb079    TYPE /ptloms/tb079,
          ls_registro LIKE LINE OF e_historico_rastrea_usr,
          ls_retorno  TYPE /ptloms/et060,
          lv_where    TYPE string.

    DATA: r_guid      TYPE RANGE OF /ptloms/et192-guid,
          r_usuario   TYPE RANGE OF /ptloms/et192-usuario,
          r_matricula TYPE RANGE OF /ptloms/et192-matricula,
          r_perfil    TYPE RANGE OF /ptloms/et192-perfil,
          r_erdat     TYPE RANGE OF /ptloms/et192-data_criacao.

    DATA: ls_usuario   LIKE LINE OF r_usuario,
          ls_matricula LIKE LINE OF r_matricula,
          ls_guid      LIKE LINE OF r_guid,
          ls_perfil    LIKE LINE OF r_perfil,
          ls_erdat     LIKE LINE OF r_erdat.

    DATA: lv_date_str      TYPE char10,
          lv_time_str      TYPE char8,
          lv_date_time_str TYPE char30.


    FIELD-SYMBOLS: <fs_e_historico_rastrea_usr> LIKE LINE OF e_historico_rastrea_usr.

    CLEAR lv_where.

*    IF i_usuario IS NOT INITIAL.
*
*      ls_usuario-sign = 'I'.
*      ls_usuario-option = 'EQ'.
*      ls_usuario-low = i_usuario.
*      APPEND ls_usuario TO r_usuario.
*
*      IF lv_where IS INITIAL.
*        lv_where = 'usuario_app IN r_usuario'.
*      ELSE.
*        CONCATENATE lv_where 'AND usuario_app IN r_usuario' INTO lv_where SEPARATED BY space.
*      ENDIF.
*
*    ENDIF.
*
*    IF i_usuario IS NOT INITIAL.
*
*      ls_usuario-sign = 'I'.
*      ls_usuario-option = 'EQ'.
*      ls_usuario-low = i_usuario.
*      APPEND ls_usuario TO r_usuario.
*
*      IF lv_where IS INITIAL.
*        lv_where = 'usuario_app IN r_usuario'.
*      ELSE.
*        CONCATENATE lv_where 'AND usuario_app IN r_usuario' INTO lv_where SEPARATED BY space.
*      ENDIF.
*
*    ENDIF.

    IF i_guid IS NOT INITIAL.

      ls_guid-sign = 'I'.
      ls_guid-option = 'EQ'.
      CONDENSE i_guid NO-GAPS.
      ls_guid-low = i_guid.
      APPEND ls_guid TO r_guid.

      IF lv_where IS INITIAL.
        lv_where = 'guid IN r_guid'.
      ELSE.
        CONCATENATE lv_where 'AND guid IN r_guid' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.



    IF i_usuario IS NOT INITIAL.

      ls_usuario-sign = 'I'.
      ls_usuario-option = 'EQ'.
      ls_usuario-low = i_usuario.
      APPEND ls_usuario TO r_usuario.

      IF lv_where IS INITIAL.
        lv_where = 'usuario IN r_usuario'.
      ELSE.
        CONCATENATE lv_where 'AND usuario IN r_usuario' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    IF i_matricula IS NOT INITIAL.

      ls_matricula-sign = 'I'.
      ls_matricula-option = 'EQ'.
      ls_matricula-low = i_matricula.
      APPEND ls_matricula TO r_matricula.

      IF lv_where IS INITIAL.
        lv_where = 'matricula IN r_matricula'.
      ELSE.
        CONCATENATE lv_where 'AND matricula IN r_matricula' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    IF i_perfil IS NOT INITIAL.

      ls_perfil-sign = 'I'.
      ls_perfil-option = 'EQ'.
      ls_perfil-low = i_perfil.
      APPEND ls_perfil TO r_perfil.

      IF lv_where IS INITIAL.
        lv_where = 'perfil IN r_perfil'.
      ELSE.
        CONCATENATE lv_where 'AND perfil IN r_perfil' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    IF i_data_ini IS NOT INITIAL OR i_data_fim IS NOT INITIAL.
      ls_erdat-sign = 'I'.
      ls_erdat-option = 'BT'.
      IF i_data_ini IS NOT INITIAL.
        ls_erdat-low = i_data_ini.
      ELSE.
        ls_erdat-low = '00000000'.
      ENDIF.

      IF i_data_fim IS NOT INITIAL.
        ls_erdat-high = i_data_fim.
      ELSE.
        ls_erdat-high = sy-datum.
      ENDIF.
      APPEND ls_erdat TO r_erdat.

      IF lv_where IS INITIAL.
        lv_where = 'data_criacao IN r_erdat'.
      ELSE.
        CONCATENATE lv_where 'AND data_criacao IN r_erdat' INTO lv_where SEPARATED BY space.
      ENDIF.

    ENDIF.

    SELECT *
      FROM /ptloms/tb079
*      INTO TABLE lt_tb079
      INTO CORRESPONDING FIELDS OF TABLE e_historico_rastrea_usr
      WHERE (lv_where).

    IF sy-subrc <> 0.
      ls_retorno-chave   = 'X'.
      ls_retorno-type    = 'W'.
      ls_retorno-message = 'Nenhum dado encontrado na Tab. /PTLOMS/TB079'.
      APPEND ls_retorno TO e_retorno.
      EXIT.
    ENDIF.

    ls_retorno-chave   = 'X'.
    ls_retorno-type    = 'S'.
    ls_retorno-message = 'Sucesso'.
    APPEND ls_retorno TO e_retorno.

    IF e_historico_rastrea_usr[] IS NOT INITIAL.

      CLEAR ls_tb079.

      LOOP AT e_historico_rastrea_usr ASSIGNING <fs_e_historico_rastrea_usr>.

        <fs_e_historico_rastrea_usr>-chave = 'X'.
*
*        <fs_e_historico_rastrea_usr>-data_coleta   = |{ ls_tb079-data_coleta+6(2) }/{ ls_tb079-data_coleta+4(2) }/{ ls_tb079-data_coleta(4) }|.
*        <fs_e_historico_rastrea_usr>-hora_coleta   = |{ ls_tb079-hora_coleta(2) }:{ ls_tb079-hora_coleta+2(2) }:{ ls_tb079-hora_coleta+4(2) }|.
*        <fs_e_historico_rastrea_usr>-data_criacao  = |{ ls_tb079-data_criacao+6(2) }/{ ls_tb079-data_criacao+4(2) }/{ ls_tb079-data_criacao(4) }|.
*        <fs_e_historico_rastrea_usr>-hora_criacao  = |{ ls_tb079-hora_criacao(2) }:{ ls_tb079-hora_criacao+2(2) }:{ ls_tb079-hora_criacao+4(2) }|.



        CLEAR: lv_time_str, lv_date_str, lv_date_time_str.
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = <fs_e_historico_rastrea_usr>-data_coleta
          IMPORTING
            output = lv_date_str.

        REPLACE ALL OCCURRENCES OF '.' IN lv_date_str WITH '/'.

        lv_time_str = <fs_e_historico_rastrea_usr>-hora_coleta(2)   && ':' &&
                      <fs_e_historico_rastrea_usr>-hora_coleta+3(2) && ':' &&
                      <fs_e_historico_rastrea_usr>-hora_coleta+4(2).

        CONCATENATE lv_date_str ',' INTO lv_date_time_str.
        CONCATENATE lv_date_time_str lv_time_str INTO <fs_e_historico_rastrea_usr>-data_hora_coleta_str SEPARATED BY space.

        CLEAR: lv_time_str, lv_date_str, lv_date_time_str.
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = <fs_e_historico_rastrea_usr>-data_criacao
          IMPORTING
            output = lv_date_str.

        REPLACE ALL OCCURRENCES OF '.' IN lv_date_str WITH '/'.

        lv_time_str = <fs_e_historico_rastrea_usr>-hora_criacao(2)   && ':' &&
                      <fs_e_historico_rastrea_usr>-hora_criacao+3(2) && ':' &&
                      <fs_e_historico_rastrea_usr>-hora_criacao+4(2).

        CONCATENATE lv_date_str ',' INTO lv_date_time_str.
        CONCATENATE lv_date_time_str lv_time_str INTO <fs_e_historico_rastrea_usr>-data_hora_criacao_str SEPARATED BY space.

      ENDLOOP.

    ENDIF.

    UNASSIGN <fs_e_historico_rastrea_usr>.

  ENDMETHOD.


  METHOD busca_lista_anexo.

    DATA:
      w_anexo     LIKE LINE OF it_lista,
      y_detalhe   LIKE LINE OF et_lista,
      r_instid_a  TYPE /iwbep/t_cod_select_options,
      r_typeid_a  TYPE /iwbep/t_cod_select_options,
      ls_instid_a LIKE LINE OF r_instid_a,
      ls_typeid_a LIKE LINE OF r_typeid_a,
      lt_anexo    TYPE /ptloms/ct072.

    DATA: o_cl001 TYPE REF TO /ptloms/cl001.

    CREATE OBJECT o_cl001.

* Dados do cliente
    LOOP AT it_lista      INTO w_anexo.

      CLEAR:
        y_detalhe.

      MOVE w_anexo-equinr   TO y_detalhe-equnr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = y_detalhe-equnr
        IMPORTING
          output = w_anexo-equinr.

* Carrega imagens do Equipamento associado a ordem
      IF w_anexo-equinr IS NOT INITIAL.

        CLEAR: ls_instid_a, ls_typeid_a.
        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.

        ls_instid_a-sign    = 'I'.
        ls_instid_a-option  = 'EQ'.
        ls_instid_a-low     = w_anexo-equinr.
        APPEND ls_instid_a TO r_instid_a.

        ls_typeid_a-sign    = 'I'.
        ls_typeid_a-option  = 'EQ'.
        ls_typeid_a-low     = 'EQUI'.
        APPEND ls_typeid_a TO r_typeid_a.

        lt_anexo = o_cl001->out_imagem(
                                   rt_instid_a = r_instid_a
                                   rt_typeid_a = r_typeid_a ).

        FIELD-SYMBOLS: <fs_anexo> LIKE LINE OF lt_anexo.

        IF lt_anexo[] IS NOT INITIAL.

          LOOP AT lt_anexo ASSIGNING <fs_anexo>.

            MOVE-CORRESPONDING <fs_anexo> TO y_detalhe.
            y_detalhe-tiporetorno   = 'S'.
            APPEND y_detalhe TO et_lista.

          ENDLOOP.

        ENDIF.

      ELSE.
        y_detalhe-tiporetorno   = 'E'.
        APPEND y_detalhe      TO et_lista.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD BUSCA_LISTA_ANEXO_INSTALACAO.

    DATA:
      w_anexo     LIKE LINE OF it_lista,
      y_detalhe   LIKE LINE OF et_lista,
      r_instid_a  TYPE /iwbep/t_cod_select_options,
      r_typeid_a  TYPE /iwbep/t_cod_select_options,
      ls_instid_a LIKE LINE OF r_instid_a,
      ls_typeid_a LIKE LINE OF r_typeid_a,
      lt_anexo    TYPE /ptloms/ct072.

    DATA: o_cl001 TYPE REF TO /ptloms/cl001.

    CREATE OBJECT o_cl001.

* Dados do cliente
    LOOP AT it_lista      INTO w_anexo.

      CLEAR:
        y_detalhe.

      MOVE w_anexo-tplnr   TO y_detalhe-tplnr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = y_detalhe-tplnr
        IMPORTING
          output = w_anexo-tplnr.

* Carrega imagens do Local de Instalação associado a ordem
      IF w_anexo-tplnr IS NOT INITIAL.

        CLEAR: ls_instid_a, ls_typeid_a.
        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.

        ls_instid_a-sign    = 'I'.
        ls_instid_a-option  = 'EQ'.
        ls_instid_a-low     = w_anexo-tplnr.
        APPEND ls_instid_a TO r_instid_a.

        ls_typeid_a-sign    = 'I'.
        ls_typeid_a-option  = 'EQ'.
        ls_typeid_a-low     = 'BUS0010'.
        APPEND ls_typeid_a TO r_typeid_a.

        lt_anexo = o_cl001->out_imagem(
                                   rt_instid_a = r_instid_a
                                   rt_typeid_a = r_typeid_a ).

        FIELD-SYMBOLS: <fs_anexo> LIKE LINE OF lt_anexo.

        IF lt_anexo[] IS NOT INITIAL.

          LOOP AT lt_anexo ASSIGNING <fs_anexo>.

            MOVE-CORRESPONDING <fs_anexo> TO y_detalhe.
            y_detalhe-tiporetorno   = 'S'.
            APPEND y_detalhe TO et_lista.

          ENDLOOP.

        ENDIF.

      ELSE.
        y_detalhe-tiporetorno   = 'E'.
        APPEND y_detalhe      TO et_lista.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  method BUSCA_LISTA_ANEXO_ORDEM.

    DATA:
      w_anexo     LIKE LINE OF it_lista,
      y_detalhe   LIKE LINE OF et_lista,
      r_instid_a  TYPE /iwbep/t_cod_select_options,
      r_typeid_a  TYPE /iwbep/t_cod_select_options,
      ls_instid_a LIKE LINE OF r_instid_a,
      ls_typeid_a LIKE LINE OF r_typeid_a,
      lt_anexo    TYPE /ptloms/ct072.

    DATA: o_cl001 TYPE REF TO /ptloms/cl001.

    CREATE OBJECT o_cl001.

* Dados do cliente
    LOOP AT it_lista      INTO w_anexo.

      CLEAR:
        y_detalhe.

      MOVE w_anexo-aufnr   TO y_detalhe-aufnr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = y_detalhe-aufnr
        IMPORTING
          output = w_anexo-aufnr.

* Carrega imagens do Local de Instalação associado a ordem
      IF w_anexo-aufnr IS NOT INITIAL.

        CLEAR: ls_instid_a, ls_typeid_a.
        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.

        ls_instid_a-sign    = 'I'.
        ls_instid_a-option  = 'EQ'.
        ls_instid_a-low     = w_anexo-aufnr.
        APPEND ls_instid_a TO r_instid_a.

        ls_typeid_a-sign    = 'I'.
        ls_typeid_a-option  = 'EQ'.
        ls_typeid_a-low     = 'BUS2007'.
        APPEND ls_typeid_a TO r_typeid_a.

        lt_anexo = o_cl001->out_imagem(
                                   rt_instid_a = r_instid_a
                                   rt_typeid_a = r_typeid_a ).

        FIELD-SYMBOLS: <fs_anexo> LIKE LINE OF lt_anexo.

        IF lt_anexo[] IS NOT INITIAL.

          LOOP AT lt_anexo ASSIGNING <fs_anexo>.

            MOVE-CORRESPONDING <fs_anexo> TO y_detalhe.
            y_detalhe-tiporetorno   = 'S'.
            APPEND y_detalhe TO et_lista.

          ENDLOOP.

        ENDIF.

      ELSE.
        y_detalhe-tiporetorno   = 'E'.
        APPEND y_detalhe      TO et_lista.

      ENDIF.

    ENDLOOP.

  endmethod.


  METHOD busca_lista_associar.

    DATA: ls_lista       LIKE LINE OF it_lista,
          lt_tb065       TYPE TABLE OF /ptloms/tb065,
          ls_tb065       TYPE /ptloms/tb065,
          ls_tb066       TYPE /ptloms/tb066,
          lt_retorno     TYPE /ptloms/ct060,
          ls_retorno     LIKE LINE OF lt_retorno,
          lt_retorno_aux TYPE bapiret2_t,
          lt_return      TYPE bapiret2_t,
          ls_return      LIKE LINE OF lt_return,
          ls_retorno_aux LIKE LINE OF lt_retorno_aux,
          lv_matricula   TYPE /ptloms/tb013-matricula,
          lv_guid        TYPE char75,
          lv_tabix       TYPE sy-tabix,
          lv_tabix2      TYPE sy-tabix,
          lv_rfcdest     TYPE bdbapidst,
          lv_aufnr       TYPE aufnr,
          lv_vornr       TYPE vornr,
          ls_header      TYPE bapi_alm_order_header_e,
          lt_operations  TYPE TABLE OF bapi_alm_order_operation_e,
          ls_operations  TYPE bapi_alm_order_operation_e.

    FIELD-SYMBOLS: <fs_lista> LIKE LINE OF et_lista.

*--> Valida se existe dados na tabela

    et_lista[] = it_lista[].

    LOOP AT it_lista ASSIGNING <fs_lista>.

      CLEAR: lv_aufnr, lv_vornr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_lista>-aufnr
        IMPORTING
          output = lv_aufnr.

      <fs_lista>-aufnr = lv_aufnr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_lista>-vornr
        IMPORTING
          output = lv_vornr.

      <fs_lista>-vornr = lv_vornr.

    ENDLOOP.

*--> Valida se existe dados na tabela
    SELECT *
      FROM /ptloms/tb065
      INTO TABLE lt_tb065
      FOR ALL ENTRIES IN it_lista
      WHERE aufnr EQ it_lista-aufnr
        AND vornr EQ it_lista-vornr
        AND uname EQ it_lista-uname.

    LOOP AT it_lista INTO ls_lista.

      lv_tabix2 = sy-tabix.

      READ TABLE lt_tb065 INTO ls_tb065 WITH KEY aufnr = ls_lista-aufnr
                                                 vornr = ls_lista-vornr
                                                 uname = ls_lista-uname.

      IF sy-subrc EQ 0.
        lv_tabix = sy-tabix.

        REFRESH lt_retorno.

        "monta mensagem de retorno.
        MOVE:
          ls_lista-chave          TO ls_retorno-chave,
          'E'                     TO ls_retorno-type,
          '    '                  TO ls_retorno-id,
          0                       TO ls_retorno-number,
*          'Existe(m) registros já cadastrados, verifique!' TO ls_retorno-message.
          'Operação já associada para este usuário' TO ls_retorno-message.

        APPEND ls_retorno TO lt_retorno.

        ls_lista-retorno[] = lt_retorno[].
        ls_lista-tiporetorno = 'E'.
        MODIFY et_lista FROM ls_lista INDEX lv_tabix.

        CONTINUE.

      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_lista-aufnr
        IMPORTING
          output = lv_aufnr.

      CALL FUNCTION '/PTLOMS/MF082'
        DESTINATION lv_rfcdest
        EXPORTING
          im_aufnr   = lv_aufnr
          origem     = 'APP'
        IMPORTING
          it_retorno = lt_retorno_aux.

      IF lt_retorno_aux IS INITIAL.

        " Chamar méthod VALIDAR_PERMISSAO_USUARIO
        CALL METHOD /ptloms/cl008=>validar_permissao_usuario(
          EXPORTING
            im_usuario             = ls_lista-uname
          EXCEPTIONS
            erro_usuario_permissao = 1
            OTHERS                 = 2 ).

        IF sy-subrc IS INITIAL.
          CLEAR:
            ls_header.

          REFRESH:
            lt_operations,
            lt_retorno_aux.

          CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
            EXPORTING
              number        = lv_aufnr
            IMPORTING
              es_header     = ls_header
            TABLES
              et_operations = lt_operations
              return        = lt_retorno_aux.

          IF  ls_header-sys_status CS 'LIB'.

            READ TABLE lt_operations INTO ls_operations WITH KEY activity = ls_lista-vornr.

            IF  sy-subrc         EQ 0
            AND NOT ls_operations-system_status_text CS 'CONF'.

              CALL FUNCTION '/PTLOMS/MF036'
                DESTINATION lv_rfcdest
                EXPORTING
                  im_aufnr   = lv_aufnr
                  im_vornr   = ls_lista-vornr
                  im_usuario = ls_lista-uname
                TABLES
                  it_return  = lt_retorno_aux.

              READ TABLE lt_retorno_aux TRANSPORTING NO FIELDS WITH KEY type = 'E'.
              IF sy-subrc IS NOT INITIAL.

                lv_guid = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).

                CLEAR ls_tb065.
                MOVE lv_guid                TO ls_lista-guid.
                MOVE-CORRESPONDING ls_lista TO ls_tb065.
                ls_tb065-aufnr =  |{ ls_tb065-aufnr ALPHA = IN }|.
                MODIFY /ptloms/tb065      FROM ls_tb065.

                CLEAR ls_tb066.
                MOVE-CORRESPONDING ls_lista TO ls_tb066.
                ls_tb066-aufnr        = |{ ls_tb065-aufnr ALPHA = IN }|.
                ls_tb066-criadopor    = sy-uname.
                ls_tb066-datacriacao  = sy-datum.
                ls_tb066-horacriacao  = sy-uzeit.
                ls_tb066-status       = 1.
                MODIFY /ptloms/tb066 FROM ls_tb066.

                COMMIT WORK AND WAIT.
                REFRESH lt_retorno.
                LOOP AT lt_retorno_aux INTO ls_retorno_aux.
                  CLEAR ls_retorno.
                  MOVE-CORRESPONDING ls_retorno_aux TO ls_retorno.
                  APPEND ls_retorno TO lt_retorno.
                  ls_lista-retorno[] = lt_retorno[].
                ENDLOOP.

                ls_lista-tiporetorno = 'S'.
                MODIFY et_lista FROM ls_lista INDEX lv_tabix2 .

                CONTINUE.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

      REFRESH lt_retorno.

      LOOP AT lt_retorno_aux INTO ls_retorno_aux.

        MOVE-CORRESPONDING ls_retorno_aux TO ls_retorno.
        APPEND ls_retorno TO lt_retorno.

      ENDLOOP.

      ls_lista-retorno[]   = lt_retorno[].
      ls_lista-tiporetorno = 'E'.
      MODIFY et_lista FROM ls_lista INDEX lv_tabix2.

    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM it_lista COMPARING chave guid aufnr vornr.
    LOOP AT it_lista INTO ls_lista.
*------------------------------------------------------------*
*               Atualizar capacidade técnica
*------------------------------------------------------------*
      CALL FUNCTION '/PTLOMS/MF132'
        EXPORTING
          im_aufnr  = ls_lista-aufnr
          im_vornr  = ls_lista-vornr
        TABLES
          it_return = lt_return.

      CLEAR ls_retorno.
      LOOP AT lt_return INTO ls_return.
        MOVE-CORRESPONDING ls_return TO ls_retorno.
        APPEND ls_retorno TO ls_lista-retorno[].
      ENDLOOP.
*------------------------------------------------------------*
    ENDLOOP.

  ENDMETHOD.


  METHOD busca_lista_detalhe_nota.

    DATA:
      w_nota      LIKE LINE OF it_lista,
      y_detalhe   LIKE LINE OF et_lista,
      ls_detnota2 TYPE /ptloms/et174,
      ls_detnota3 TYPE /ptloms/et175,
      ls_detnota4 TYPE /ptloms/et176,
      ls_detnota5 TYPE /ptloms/et177,
      ls_detnota6 TYPE /ptloms/et178,
      ls_retorno  TYPE /ptloms/et060.

* Declaração para BAPI
    DATA:
      ls_header             TYPE bapi_alm_order_header_e,
      ls_notifheader_export TYPE bapi2080_nothdre,
      ls_nothdtxte          TYPE bapi2080_nothdtxte,
      lt_notlongtxt         TYPE STANDARD TABLE OF bapi2080_notfulltxte,
      ls_notlongtxt         LIKE LINE OF lt_notlongtxt,
      lt_notitem            TYPE STANDARD TABLE OF bapi2080_notiteme,
      ls_notitem            LIKE LINE OF lt_notitem,
      lt_notifcaus          TYPE STANDARD TABLE OF bapi2080_notcause,
      ls_notifcaus          LIKE LINE OF lt_notifcaus,
      lt_notiftask          TYPE STANDARD TABLE OF bapi2080_nottaske,
      ls_notiftask          LIKE LINE OF lt_notiftask,
      lt_notifpartnr        TYPE STANDARD TABLE OF bapi2080_notpartnre,
      ls_notifpartnr        LIKE LINE OF lt_notifpartnr,
      lt_return             TYPE STANDARD TABLE OF bapiret2,
      ls_return             LIKE LINE OF lt_return.

** Dados da nota
    LOOP AT it_lista      INTO w_nota.

      CLEAR:
       y_detalhe.

      MOVE w_nota-notif_no   TO y_detalhe-notif_no.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = y_detalhe-notif_no
        IMPORTING
          output = ls_header-notif_no.

      CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
        EXPORTING
          number             = ls_header-notif_no
        IMPORTING
          notifheader_export = ls_notifheader_export
          notifhdtext        = ls_nothdtxte
        TABLES
          notlongtxt         = lt_notlongtxt
          notitem            = lt_notitem
          notifcaus          = lt_notifcaus
          notiftask          = lt_notiftask
          notifpartnr        = lt_notifpartnr
          return             = lt_return.

      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF sy-subrc  IS NOT INITIAL.

        MOVE-CORRESPONDING ls_notifheader_export TO y_detalhe.
        MOVE-CORRESPONDING ls_nothdtxte          TO y_detalhe.

        LOOP AT lt_notlongtxt                  INTO ls_notlongtxt.

          CLEAR ls_detnota2.
          MOVE-CORRESPONDING ls_notlongtxt       TO ls_detnota2.
          APPEND ls_detnota2                     TO y_detalhe-detalhe2.

        ENDLOOP.

        LOOP AT lt_notitem                     INTO ls_notitem.

          CLEAR ls_detnota3.
          MOVE-CORRESPONDING ls_notitem          TO ls_detnota3.
          APPEND ls_detnota3                     TO y_detalhe-detalhe3.

        ENDLOOP.

        LOOP AT lt_notifcaus                   INTO ls_notifcaus.

          CLEAR ls_detnota4.
          MOVE-CORRESPONDING ls_notifcaus        TO ls_detnota4.
          APPEND ls_detnota4                     TO y_detalhe-detalhe4.

        ENDLOOP.

        LOOP AT lt_notiftask                   INTO ls_notiftask.

          CLEAR ls_detnota5.
          MOVE-CORRESPONDING ls_notiftask        TO ls_detnota5.
          APPEND ls_detnota5                     TO y_detalhe-detalhe5.

        ENDLOOP.

        LOOP AT lt_notifpartnr                 INTO ls_notifpartnr.

          CLEAR ls_detnota6.
          MOVE-CORRESPONDING ls_notifpartnr      TO ls_detnota6.
          APPEND ls_detnota6                     TO y_detalhe-detalhe6.

        ENDLOOP.

        IF  lt_return[]                      IS NOT INITIAL.
          REFRESH y_detalhe-retorno.

          LOOP AT lt_return                    INTO ls_return.

            CLEAR ls_retorno.
            MOVE-CORRESPONDING ls_return         TO ls_retorno.
            APPEND ls_retorno                    TO y_detalhe-retorno.

          ENDLOOP.

        ENDIF.

        y_detalhe-tiporetorno = 'S'.
        APPEND y_detalhe      TO et_lista.

      ELSE.

        y_detalhe-tiporetorno = 'E'.
        APPEND y_detalhe      TO et_lista.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD busca_motivo.

    DATA:
      gt_description TYPE TABLE OF dd07v,
      gs_descr       LIKE LINE OF gt_description,
      s_motivo       TYPE /ptloms/et117.

    REFRESH:
      gt_description.

    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM006'   "Domínio
        text            = 'X'
      TABLES
        values_tab      = gt_description
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

    IF  i_codigo                 IS INITIAL.

      LOOP AT  gt_description  INTO gs_descr.
        s_motivo-codigo           = gs_descr-valpos.
        s_motivo-descricao        = gs_descr-ddtext.
        APPEND s_motivo          TO e_motivo.
      ENDLOOP.

    ELSE.

      READ TABLE gt_description  INTO gs_descr  WITH KEY domvalue_l = i_codigo.

      IF  sy-subrc    EQ 0 .
        s_motivo-descricao = gs_descr-ddtext.
      ELSE.
        s_motivo-descricao = 'Motivo Inexistente !'.
      ENDIF.

      s_motivo-codigo           = i_codigo.
      APPEND s_motivo          TO e_motivo.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
