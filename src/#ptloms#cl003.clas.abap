class /PTLOMS/CL003 definition
  public
  final
  create public .

public section.

  methods IN_NOTA
    importing
      !IM_NOTA type /PTLOMS/ET043
      !IT_TEXTO type /PTLOMS/CT044
      !IT_ITEM type /PTLOMS/CT045
      !IT_ITEM_CAUSA type /PTLOMS/CT046
      !IT_ITEM_ATIVIDADE type /PTLOMS/CT047
      !IT_ITEM_TAREFA type /PTLOMS/CT048
      !IT_ANEXO type /PTLOMS/CT072
      !IT_ITEM_MEDIDAS type /PTLOMS/CT024
    exporting
      !EX_NOTF_NO type QMNUM
      !ET_RETURN type /PTLOMS/CT060 .
  methods IN_DOCUMENTO_MEDICAO
    importing
      !IM_PONTO_MEDICAO type /PTLOMS/ET050
    exporting
      !EX_PONTO_MEDICAO type /PTLOMS/ET050
      value(RT_RETURN) type /PTLOMS/CT063 .
  methods IN_CONFIRMACAO
    importing
      !IM_CONFIRMACAO type /PTLOMS/ET051
      !IT_TEXTO type /PTLOMS/CT061
    exporting
      !RT_RETURN type /PTLOMS/CT062 .
  methods IN_ORDEM
    importing
      !IM_ORDEM type /PTLOMS/ET057
      !IM_NOTA type CHAR12 optional
      !IM_NOCOMMIT type CHAR1 optional
      !IT_OPERACAO type /PTLOMS/CT058 optional
      !IT_TEXTO_ORDEM type /PTLOMS/CT059
      !IT_ANEXO type /PTLOMS/CT072
    exporting
      !ET_OPERACAO type /PTLOMS/CT058
      !EX_AUFNR type AUFNR
      !ET_RETURN type /PTLOMS/CT063 .
  methods IN_OPERACAO_ORDEM
    importing
      !IM_OPERACAO type /PTLOMS/ET067
    exporting
      !ET_RETURN type /PTLOMS/CT063
      !WA_OPERACAO type /PTLOMS/ET067 .
  methods IN_COMPONENTE_ORDEM_DELE
    importing
      !IM_COMPONENTE type /PTLOMS/ET039
    exporting
      !ET_RETURN type /PTLOMS/CT063 .
  methods IN_COMPONENTE_ORDEM
    importing
      !IM_COMPONENTE type /PTLOMS/ET039
    exporting
      !ET_RETURN type /PTLOMS/CT063 .
  methods IN_FINALIZAR_SESSAO
    importing
      !IM_USUARIO type XUBNAME
    exporting
      !ET_RETURN type /PTLOMS/CT063 .
  methods IN_ANEXAR_IMAGEM
    importing
      !IM_OBJKEY type SWO_TYPEID
      !IM_OBJTYP type SWO_OBJTYP
      !IM_USER type SY-UNAME optional
      !IT_ANEXO type /PTLOMS/CT072
    exporting
      !ET_RETURN type /PTLOMS/CT063 .
  methods IN_ANEXAR_RASTREAMENTO_USUARIO
    importing
      value(IT_RASTREAMENTO_USUARIO) type /PTLOMS/CT163
    exporting
      value(ET_RETORNO) type /PTLOMS/CT156
      value(ET_RASTREAMENTO_USUARIO) type /PTLOMS/CT163 .
  methods IN_ANEXAR_ASSINATURA
    importing
      !IT_ASSINATURAS type /PTLOMS/CT157
    exporting
      !ET_RETORNO type /PTLOMS/CT156
      !ET_ASSINATURAS type /PTLOMS/CT157 .
  methods IN_LAYOUT
    importing
      !IM_LAYOUT type /PTLOMS/ET082
      !IT_LAYOUT_VALUES type /PTLOMS/CT084 .
  methods IN_ORDEM_CATALOGO
    importing
      value(IM_ORDEM_CATALOGO) type /PTLOMS/ET128
    exporting
      !EX_ORDEM_CATALOGO type /PTLOMS/ET128
      value(ET_RETURN) type /PTLOMS/CT063 .
  methods OUT_ORDEM_CATALOGO
    importing
      value(IV_USUARIO_APP) type CHAR12
      value(IM_ORDEM_CATALOGO) type /PTLOMS/CT114
    exporting
      !EX_ORDEM_CATALOGO type /PTLOMS/CT114
      value(ET_RETURN) type /PTLOMS/CT063 .
  methods IN_CONFIRMACAO_CATALOGO
    importing
      !IM_CONFIRMACAO type /PTLOMS/ET051
      !IM_USUARIO_APP type CHAR12 optional
    exporting
      !RT_RETURN type /PTLOMS/CT062 .
  methods IN_RESERVA_DELETE
    importing
      !IM_COMPONENTE type /PTLOMS/ET134
    exporting
      !EX_COMPONENTE type /PTLOMS/ET134
      !ET_RETURN type /PTLOMS/CT063 .
  methods IN_RESERVA
    importing
      !IM_COMPONENTE type /PTLOMS/ET134
    exporting
      !EX_COMPONENTE type /PTLOMS/ET134
      !ET_RETURN type /PTLOMS/CT063 .
  methods IN_CONFIRMACAO_CESTO
    importing
      !IM_CONFIRMACAO type /PTLOMS/ET051
      !IT_TEXTO type /PTLOMS/CT061
    exporting
      !RT_RETURN type /PTLOMS/CT062 .
  methods IN_ORDEM_LISTA_TAREFA
    importing
      !IM_ORDEM type /PTLOMS/ET087
      !IM_NOTA type CHAR12 optional
      !IM_NOCOMMIT type CHAR1 optional
      !IT_TEXTO_ORDEM type /PTLOMS/CT059
      !IT_ANEXO type /PTLOMS/CT072
    exporting
      !EX_AUFNR type AUFNR
      !ET_RETURN type /PTLOMS/CT063 .
  methods OUT_ORDEM_CATALOGO_CESTO
    importing
      value(IV_USUARIO_APP) type CHAR12
      value(IM_ORDEM_CATALOGO) type /PTLOMS/CT114
    exporting
      !EX_ORDEM_CATALOGO type /PTLOMS/CT114
      value(ET_RETURN) type /PTLOMS/CT063 .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL003 IMPLEMENTATION.


  METHOD in_anexar_assinatura.

    DATA: ls_assinatura LIKE LINE OF it_assinaturas,
          ls_tb077      TYPE /ptloms/tb077,
          ls_retorno    TYPE /ptloms/et060.

    DATA: lv_erro     TYPE boolean,
          lv_mensagem TYPE string,
          lv_orderid  TYPE string,
          lv_activity TYPE string,
          lv_data     TYPE string,
          lv_hora     TYPE string.

    lv_erro = abap_false.

    IF it_assinaturas[] IS NOT INITIAL.

      CLEAR ls_assinatura.
      LOOP AT it_assinaturas INTO ls_assinatura WHERE assinatura_base64 IS NOT INITIAL.

        CLEAR ls_tb077.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_assinatura-orderid
          IMPORTING
            output = ls_tb077-aufnr.

        CONDENSE ls_tb077-aufnr NO-GAPS.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_assinatura-activity
          IMPORTING
            output = ls_tb077-vornr.

        CONDENSE ls_tb077-vornr NO-GAPS.
*        ls_tb077-aufnr              = ls_assinatura-orderid.
*        ls_tb077-vornr              = ls_assinatura-activity.

        ls_tb077-arquivo_assinatura = ls_assinatura-assinatura_base64.
        ls_tb077-doc_id             = ls_assinatura-identificacao.
        ls_tb077-nome_assinante     = ls_assinatura-nome.
        ls_tb077-latitude           = ls_assinatura-latitude.
        ls_tb077-longitude          = ls_assinatura-longitude.
        ls_tb077-tipo_doc_id        = ls_assinatura-tipo_identificacao.
        ls_tb077-usuario_app        = ls_assinatura-usuario.
        ls_tb077-adrnr              = ls_assinatura-adrnr.

        ls_tb077-guid_associacao    = ls_assinatura-guid_associacao.

        lv_data = ls_assinatura-data_local.
        REPLACE ALL OCCURRENCES OF '/' IN lv_data WITH '.'.

        lv_hora = ls_assinatura-hora_local.

        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external = lv_data
          IMPORTING
            date_internal = ls_tb077-data_criacao_app.

        CALL FUNCTION 'CONVERT_TIME_INPUT'
          EXPORTING
            input  = lv_hora
          IMPORTING
            output = ls_tb077-hora_criacao_app.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_assinatura-orderid
          IMPORTING
            output = lv_orderid.

        CONDENSE lv_orderid NO-GAPS.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_assinatura-activity
          IMPORTING
            output = lv_activity.

        CONDENSE lv_activity NO-GAPS.

        ls_tb077-usuario      = sy-uname.
        ls_tb077-data_criacao = sy-datum.
        ls_tb077-hora_criacao = sy-uzeit.

        ls_assinatura-status  = 'Sucesso'.
        ls_tb077-status       = ls_assinatura-status.

*       Grava os dados da assinatura na tb077
        MODIFY /ptloms/tb077 FROM ls_tb077.

        IF sy-subrc = 0.

          APPEND ls_assinatura TO et_assinaturas.
          CONCATENATE 'Assinatura gravada com sucesso ordem' lv_orderid 'operação' lv_activity
             INTO lv_mensagem SEPARATED BY space.
          ls_retorno-chave = 'X'.
          ls_retorno-type  = 'S'.

        ELSE.

          ls_assinatura-status = 'Erro'.
          APPEND ls_assinatura TO et_assinaturas.
          CONCATENATE 'Falha na gravação assinatura ordem' lv_orderid 'operação' lv_activity
             INTO lv_mensagem SEPARATED BY space.
          ls_retorno-chave = 'X'.
          ls_retorno-type  = 'E'.

        ENDIF.

        ls_retorno-message = lv_mensagem.
        ls_retorno-message_v1 = ls_assinatura-orderid.
        ls_retorno-message_v2 = ls_assinatura-activity.
        APPEND ls_retorno TO et_retorno.
        CLEAR: ls_retorno, lv_mensagem.

      ENDLOOP.

    ELSE.

      lv_erro = abap_true.

    ENDIF.

    IF lv_erro EQ abap_false.

      COMMIT WORK.
      lv_mensagem = 'Assinaturas anexadas'.
      ls_retorno-chave = 'X'.
      ls_retorno-type  = 'S'.

    ELSE.

      ROLLBACK WORK.
      lv_mensagem = 'Nenhuma assinatura para anexar'.
      ls_retorno-chave = 'X'.
      ls_retorno-type  = 'E'.

    ENDIF.

    ls_retorno-message = lv_mensagem.
    APPEND ls_retorno TO et_retorno.
    CLEAR: ls_retorno, lv_mensagem.

  ENDMETHOD.


  METHOD in_anexar_imagem.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declarações para geração do anexo
    DATA: lt_objhead    TYPE STANDARD TABLE OF soli,
          lt_content    TYPE STANDARD TABLE OF soli,
          ls_folder_id  TYPE soodk,
          lv_xstring    TYPE xstring,
          ls_obj_data   TYPE sood1,
          ls_obj_id     TYPE soodk,
          ls_folmem_k   TYPE sofmk,
          ls_object     TYPE borident,
          ls_note       TYPE borident,
          lv_ep_note    TYPE borident-objkey,
          lv_nota       TYPE qmnum,
          lv_media(100) TYPE c,
          lv_type(50)   TYPE c.

* Declaração de estrutura
    DATA: ls_return LIKE LINE OF et_return.

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type_log  TYPE symsgty,
          lv_user      TYPE sy-uname.

    DATA ls_anexo LIKE LINE OF it_anexo.

    IF im_objkey IS NOT INITIAL.

      LOOP AT it_anexo INTO ls_anexo WHERE arquivo IS NOT INITIAL.


*    LOOP AT it_anexo INTO DATA(ls_anexo) WHERE arquivo IS NOT INITIAL.

        ls_object-objkey  = im_objkey.
        ls_object-objtype = im_objtyp.

        lv_xstring = ls_anexo-arquivo.

*    "Decodificar base64 para Hexadecimal
*    CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
*      EXPORTING
*        input  = ls_anexo-arquivo
*      IMPORTING
*        output = lv_xstring
*      EXCEPTIONS
*        failed = 1
*        OTHERS = 2.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*      ex_message = 'Falha ao decodificar base64'.
*      RETURN.
*    ENDIF.

        FREE: lt_content.
        "Converter de hexadecimal para binario
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer          = lv_xstring
            append_to_table = 'X'
*    IMPORTING
*           output_length   = vl_size
          TABLES
            binary_tab      = lt_content.

        IF lt_content IS INITIAL.
          ls_return-type = 'E'.
          ls_return-type_desc = 'Error'(025).
          ls_return-message = 'Falha na conversão de hexadecimal para binário'(026).
          APPEND ls_return TO et_return.
          CONTINUE.
        ENDIF.

        CALL FUNCTION 'SO_CONVERT_CONTENTS_BIN'
          EXPORTING
            it_contents_bin = lt_content[]
          IMPORTING
            et_contents_bin = lt_content[].


        CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
          EXPORTING
            region                = 'B'
          IMPORTING
            folder_id             = ls_folder_id
          EXCEPTIONS
            communication_failure = 1
            owner_not_exist       = 2
            system_failure        = 3
            x_error               = 4
            OTHERS                = 5.
        IF sy-subrc <> 0.
          ls_return-type = 'E'.
          ls_return-type_desc = 'Error'(025).
          ls_return-message = 'Falha ao criar ID da pasta. (SO_FOLDER_ROOT_ID_GET)'(027).
          APPEND ls_return TO et_return.
          CONTINUE.
        ENDIF.

        SPLIT ls_anexo-media_type AT '/' INTO lv_media lv_type.

        CASE ls_anexo-media_type.
          WHEN 'application/vnd.ms-excel'.
            lv_type = 'xls'.
          WHEN 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'.
            lv_type = 'xlsx'.
          WHEN 'application/msword'.
            lv_type = 'doc'.
          WHEN 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'.
            lv_type = 'docx'.
          WHEN 'application/vnd.ms-powerpoint'.
            lv_type = 'ppt'.
          WHEN 'application/vnd.openxmlformats-officedocument.presentationml.presentation'.
            lv_type = 'pptx'.
        ENDCASE.

        ls_obj_data-objsns   = 'O'.
        ls_obj_data-objla    = sy-langu.
        ls_obj_data-objdes   = ls_anexo-file_name.
        ls_obj_data-file_ext = lv_type."'PNG'."'JPG'.
*      ls_obj_data-objlen   = lines( lt_content ) * 255.
        DATA: lv_lines     TYPE i.
        CLEAR lv_lines.
        DESCRIBE TABLE lt_content LINES lv_lines.
        ls_obj_data-objlen   = lv_lines * 255.

        CALL FUNCTION 'SO_OBJECT_INSERT'
          EXPORTING
            folder_id             = ls_folder_id
            object_type           = 'EXT'
            object_hd_change      = ls_obj_data
          IMPORTING
            object_id             = ls_obj_id
          TABLES
            objhead               = lt_objhead
            objcont               = lt_content
          EXCEPTIONS
            active_user_not_exist = 35
            folder_not_exist      = 6
            object_type_not_exist = 17
            owner_not_exist       = 22
            parameter_error       = 23
            OTHERS                = 1000.

        IF sy-subrc <> 0.
          ls_return-type = 'E'.
          ls_return-type_desc = 'Error'(025).
          ls_return-message = 'Falha ao criar ID da pasta. (SO_FOLDER_ROOT_ID_GET)'(027).
          APPEND ls_return TO et_return.
          CONTINUE.
        ENDIF.

        ls_folmem_k-foltp = ls_folder_id-objtp.
        ls_folmem_k-folyr = ls_folder_id-objyr.
        ls_folmem_k-folno = ls_folder_id-objno.
        ls_folmem_k-doctp = ls_obj_id-objtp.
        ls_folmem_k-docyr = ls_obj_id-objyr.
        ls_folmem_k-docno = ls_obj_id-objno.
        lv_ep_note        = ls_folmem_k.
        ls_note-objtype   = 'MESSAGE'.
        ls_note-objkey    = lv_ep_note.

        CALL FUNCTION 'BINARY_RELATION_CREATE_COMMIT'
          EXPORTING
            obj_rolea    = ls_object
            obj_roleb    = ls_note
            relationtype = 'ATTA'
          EXCEPTIONS
            OTHERS       = 1.

        IF sy-subrc = 0.
          ls_return-type = 'S'.
          ls_return-type_desc = 'Success'(028).
          ls_return-message = 'Anexo gravado com sucesso!'(029).
          APPEND ls_return TO et_return.
        ELSE.
          ls_return-type = 'E'.
          ls_return-type_desc = 'Error'(025).
          ls_return-message = 'Erro ao criar relacionamento do anexo com a Ordem'(030).
          APPEND ls_return TO et_return.
        ENDIF.

      ENDLOOP.

    ELSE.
      ls_return-type = 'E'.
      ls_return-type_desc = 'Error'(025).
      ls_return-message = 'Erro ao criar relacionamento do anexo com a Ordem'(030).
      APPEND ls_return TO et_return.
    ENDIF.

* Grava Log
    IF et_return[] IS NOT INITIAL.
      IF im_objtyp = 'BUS2007'.
        lv_subobject = '/PTLOMS/ORDEM'.
      ELSEIF im_objtyp = 'BUS2038'.
        lv_subobject = '/PTLOMS/NOTA'.
      ENDIF.

      lv_extnumber = im_objkey.
      lv_user      = im_user.

* Instancia objeto de Log
      CREATE OBJECT o_log
        EXPORTING
          i_subobject = lv_subobject
          i_extnumber = lv_extnumber
          i_user      = lv_user.

* Grava mensagens de retorno
      LOOP AT et_return INTO ls_return.
        lv_type_log = ls_return-type.
        lv_msg      = ls_return-message.
        o_log->add( EXPORTING i_type = lv_type_log
                              i_text = lv_msg ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD in_anexar_rastreamento_usuario.

    DATA: lt_rastreamento_usr     LIKE it_rastreamento_usuario,
          ls_rastreamento_usuario LIKE LINE OF it_rastreamento_usuario,
          ls_tb078                TYPE /ptloms/tb078,
          ls_tb079                TYPE /ptloms/tb079,
          ls_retorno              TYPE /ptloms/et060.

    DATA: lv_erro             TYPE boolean,
          lv_gravou_registro  TYPE boolean,
          lv_gravou_historico TYPE boolean,
          lv_mensagem         TYPE string,
          lv_data             TYPE string,
          lv_hora             TYPE string,
          lv_timestamp        TYPE timestamp,
          lv_guid             TYPE guid.

    DATA: lv_iso_string TYPE string, "VALUE '2026-04-29T18:11:51.875Z',
          lv_date_tmp   TYPE char10,
          lv_time_tmp   TYPE char8,
          lv_date       TYPE sy-datum,
          lv_time       TYPE sy-uzeit.

    lv_erro = abap_false.

    IF it_rastreamento_usuario[] IS NOT INITIAL.

      lt_rastreamento_usr[] = it_rastreamento_usuario[].

      SORT lt_rastreamento_usr BY usuario     ASCENDING
                                  matricula   ASCENDING
                                  data_coleta DESCENDING
                                  hora_coleta DESCENDING.

      DELETE ADJACENT DUPLICATES FROM lt_rastreamento_usr COMPARING usuario matricula.

      CLEAR ls_rastreamento_usuario.

      LOOP AT lt_rastreamento_usr INTO ls_rastreamento_usuario.

        CLEAR: ls_tb078, lv_timestamp, lv_iso_string, lv_date, lv_time, lv_date_tmp, lv_time_tmp.

        MOVE-CORRESPONDING ls_rastreamento_usuario TO ls_tb078.

        lv_timestamp = ls_rastreamento_usuario-data_hora_coleta.

        lv_iso_string = ls_rastreamento_usuario-data_hora_coleta_str.

* 1. Extrair as partes da string via Offset
        lv_date_tmp = lv_iso_string(10).
        lv_time_tmp = lv_iso_string+12(8).
*        lv_date_tmp = lv_iso_string(10).
*        lv_time_tmp = lv_iso_string+11(8).

* 2. Limpar os separadores para que o SAP aceite nos tipos de Data e Hora
* Isso transforma '2026/04/29' em '20260429'
        REPLACE ALL OCCURRENCES OF '/' IN lv_date_tmp WITH ''.
        REPLACE ALL OCCURRENCES OF ':' IN lv_time_tmp WITH ''.

* 3. Atribuir às variáveis tipadas
        lv_date = lv_date_tmp. " Formato interno: 20260429
        lv_time = lv_time_tmp. " Formato interno: 181151

*        ls_tb078-data_coleta = lv_date.
*        ls_tb078-hora_coleta = lv_time.

        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external = lv_date
          IMPORTING
            date_internal = ls_tb078-data_coleta.
*
*        lv_hora = ls_rastreamento_usuario-hora_coleta.
*
        CALL FUNCTION 'CONVERT_TIME_INPUT'
          EXPORTING
            input  = lv_time
          IMPORTING
            output = ls_tb078-hora_coleta.

        ls_tb078-data_criacao = sy-datum.
        ls_tb078-hora_criacao = sy-uzeit.

        ls_rastreamento_usuario-data_coleta = ls_tb078-data_coleta.
        ls_rastreamento_usuario-hora_coleta = ls_tb078-hora_coleta.


*       Insere/Atualiza os dados do rastreamento na tb078
        MODIFY /ptloms/tb078 FROM ls_tb078.

        IF sy-subrc = 0.
          APPEND ls_rastreamento_usuario TO et_rastreamento_usuario.
          CONCATENATE 'Registro de rastreamento gravado com sucesso, usuário' ls_rastreamento_usuario-usuario INTO lv_mensagem SEPARATED BY space.
          ls_retorno-chave = 'X'.
          ls_retorno-type  = 'S'.
        ELSE.
          APPEND ls_rastreamento_usuario TO et_rastreamento_usuario.
          CONCATENATE 'Falha na gravação do rastreamento do usuário' ls_rastreamento_usuario-usuario INTO lv_mensagem SEPARATED BY space.
          ls_retorno-chave = 'X'.
          ls_retorno-type  = 'E'.
        ENDIF.

        ls_retorno-message = lv_mensagem.
        ls_retorno-message_v1 = ls_rastreamento_usuario-usuario.
        ls_retorno-message_v2 = ls_rastreamento_usuario-matricula.
        APPEND ls_retorno TO et_retorno.
        CLEAR: ls_retorno, lv_mensagem.

      ENDLOOP.

      CLEAR ls_rastreamento_usuario.

      LOOP AT it_rastreamento_usuario INTO ls_rastreamento_usuario.

        CLEAR: ls_tb079, lv_timestamp, lv_iso_string, lv_date, lv_time, lv_date_tmp, lv_time_tmp.

*        lv_guid = ls_rastreamento_usuario-guid.
*        ls_tb079-guid = lv_guid.
        TRANSLATE ls_rastreamento_usuario-guid TO UPPER CASE.
        CONDENSE ls_rastreamento_usuario-guid NO-GAPS.
        ls_tb079-guid = ls_rastreamento_usuario-guid.

        MOVE-CORRESPONDING ls_rastreamento_usuario TO ls_tb079.

        lv_timestamp = ls_rastreamento_usuario-data_hora_coleta.

        lv_iso_string = ls_rastreamento_usuario-data_hora_coleta_str.

* 1. Extrair as partes da string via Offset
        lv_date_tmp = lv_iso_string(10).
        lv_time_tmp = lv_iso_string+12(8).
*        lv_date_tmp = lv_iso_string(10).
*        lv_time_tmp = lv_iso_string+11(8).

* 2. Limpar os separadores para que o SAP aceite nos tipos de Data e Hora
* Isso transforma '2026-04-29' em '20260429'
        REPLACE ALL OCCURRENCES OF '/' IN lv_date_tmp WITH ''.
        REPLACE ALL OCCURRENCES OF ':' IN lv_time_tmp WITH ''.

* 3. Atribuir às variáveis tipadas
        lv_date = lv_date_tmp. " Formato interno: 20260429
        lv_time = lv_time_tmp. " Formato interno: 181151

*        ls_tb079-data_coleta = lv_date.
*        ls_tb079-hora_coleta = lv_time.

        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external = lv_date
          IMPORTING
            date_internal = ls_tb079-data_coleta.

        CALL FUNCTION 'CONVERT_TIME_INPUT'
          EXPORTING
            input  = lv_time
          IMPORTING
            output = ls_tb079-hora_coleta.



        ls_tb079-data_criacao = sy-datum.
        ls_tb079-hora_criacao = sy-uzeit.

*       Grava os dados do rastreamento no histórico da tb079
        INSERT /ptloms/tb079 FROM ls_tb079.

        IF sy-subrc = 0.

          CONCATENATE 'Rastreamento gravado no histórico com sucesso, usuário' ls_rastreamento_usuario-usuario INTO lv_mensagem SEPARATED BY space.
          ls_retorno-chave = 'X'.
          ls_retorno-type  = 'S'.

        ELSE.

          CONCATENATE 'O registro não foi gravado no histórico do rastreamento do usuário' ls_rastreamento_usuario-usuario INTO lv_mensagem SEPARATED BY space.
          ls_retorno-chave = 'X'.
          ls_retorno-type  = 'W'.

        ENDIF.

        READ TABLE et_rastreamento_usuario TRANSPORTING NO FIELDS WITH KEY usuario = ls_rastreamento_usuario-usuario
                                                                           matricula = ls_rastreamento_usuario-matricula.
        IF sy-subrc <> 0.
          ls_rastreamento_usuario-data_coleta = ls_tb079-data_coleta.
          ls_rastreamento_usuario-hora_coleta = ls_tb079-hora_coleta.
          APPEND ls_rastreamento_usuario TO et_rastreamento_usuario.
        ENDIF.

        ls_retorno-message = lv_mensagem.
        ls_retorno-message_v1 = ls_rastreamento_usuario-usuario.
        ls_retorno-message_v2 = ls_rastreamento_usuario-matricula.
        APPEND ls_retorno TO et_retorno.
        CLEAR: ls_retorno, lv_mensagem.

      ENDLOOP.

    ELSE.

      lv_erro = abap_true.

    ENDIF.

    DELETE ADJACENT DUPLICATES FROM et_rastreamento_usuario COMPARING usuario matricula.

    IF lv_erro EQ abap_false.

      COMMIT WORK.
      lv_mensagem = 'Rastreamentos anexados'.
      ls_retorno-chave = 'X'.
      ls_retorno-type  = 'S'.

    ELSE.

      ROLLBACK WORK.
      lv_mensagem = 'Nenhuma assinatura para anexar'.
      ls_retorno-chave = 'X'.
      ls_retorno-type  = 'E'.

    ENDIF.

    ls_retorno-message = lv_mensagem.
    APPEND ls_retorno TO et_retorno.
    CLEAR: ls_retorno, lv_mensagem.

  ENDMETHOD.


  METHOD in_componente_ordem.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declaração de tabela interna
    DATA: lt_return TYPE STANDARD TABLE OF bapiret2.

* Declaração de estrutura
    DATA: ls_return_aux TYPE /ptloms/et063.

* Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_user      TYPE sy-uname.

    CALL FUNCTION '/PTLOMS/MF004'
      EXPORTING
        im_componente = im_componente
      TABLES
        it_return     = lt_return.

    lv_subobject = '/PTLOMS/COMP_ORDEM'.
    lv_user      = im_componente-usuario_app.
    lv_extnumber = im_componente-orderid.

* Instancia objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

* Grava mensagens de retorno
*    LOOP AT lt_return INTO DATA(ls_return).
    DATA ls_return  like LINE OF lt_return.
    LOOP AT lt_return INTO ls_return.
      lv_type = ls_return-type.
      IF ls_return-id = 'IW' AND ( ls_return-number = '085' OR ls_return-number = '080' ).
        CONCATENATE ls_return-message 'Componente' im_componente-material INTO lv_msg SEPARATED BY space.
      ELSE.
        lv_msg = ls_return-message.
      ENDIF.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

* Dados de retorno
    LOOP AT lt_return INTO ls_return.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return TO ls_return_aux.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO et_return.
    ENDLOOP.

  ENDMETHOD.


  METHOD in_componente_ordem_dele.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declaração de tabela interna
    DATA: lt_return TYPE STANDARD TABLE OF bapiret2.

* Declaração de estrutura
    DATA: ls_return_aux TYPE /ptloms/et063.

* Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_user      TYPE sy-uname.

    CALL FUNCTION '/PTLOMS/MF005'
      EXPORTING
        im_componente = im_componente
      TABLES
        it_return     = lt_return.

    lv_subobject = '/PTLOMS/COMP_ORDEM_D'.
    lv_extnumber = im_componente-orderid.
    lv_user      = im_componente-usuario_app.

* Instancia objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

* Grava mensagens de retorno
*    LOOP AT lt_return INTO DATA(ls_return).
    DATA ls_return LIKE LINE OF lt_return.
    LOOP AT lt_return INTO  ls_return.
      lv_type = ls_return-type.
      lv_msg = ls_return-message.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

* Dados de retorno
    LOOP AT lt_return INTO ls_return.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return TO ls_return_aux.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO et_return.
    ENDLOOP.

  ENDMETHOD.


  METHOD in_confirmacao.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declarações para BAPI
    DATA: lt_timetickets        TYPE STANDARD TABLE OF bapi_alm_timeconfirmation,
          lt_detail_return      TYPE STANDARD TABLE OF bapi_alm_return,
          lt_textlines          TYPE TABLE OF tline,
          lt_textlines_aux      TYPE STANDARD TABLE OF bapi_alm_text_lines,
          lt_return_aux         TYPE /ptloms/ct062,
          lt_return_conf        TYPE STANDARD TABLE OF bapiret2,
          lt_return_status_oper TYPE STANDARD TABLE OF bapiret2,
          lt_return_fim_avaria  TYPE STANDARD TABLE OF bapiret2,
          lt_texto_longo        TYPE TABLE OF string.

* Declaração de estrutura
    DATA: ls_timetickets       LIKE LINE OF lt_timetickets,
          ls_return            LIKE LINE OF rt_return,
          ls_textlines         LIKE LINE OF lt_textlines,
          ls_header            TYPE thead,
          ls_return_aux        TYPE /ptloms/et062,
          ls_confirmacao       TYPE /ptloms/et051,
          ls_detail_return_aux LIKE LINE OF lt_detail_return.

* Declaração de variáveis
    DATA: lv_aufnr      TYPE aufnr,
          lv_ente       TYPE char1,
          lv_usuario    TYPE /ptloms/tb013-usuario,
          lv_duration   TYPE f,
          lv_un_work(7) TYPE p DECIMALS 1,
          lv_user       TYPE sy-uname.

* Campos auxiliares da nova estrutura da tabela /ptloms/tb031
    DATA:
      lv_conf_no  TYPE /ptloms/tb031-conf_no,
      lv_conf_cnt TYPE /ptloms/tb031-conf_cnt.

* Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_contador  TYPE i,
          lv_continua  TYPE c LENGTH 1 VALUE 'X'.

* Verifica se parâmetro de entrada foi preenchido
    IF im_confirmacao          IS INITIAL OR
       im_confirmacao-orderid  IS INITIAL OR
       im_confirmacao-activity IS INITIAL.

      CLEAR ls_detail_return_aux.
      ls_detail_return_aux-type = 'E'.
      ls_detail_return_aux-message = 'Parâmetros obrigatórios não preenchidos'(001).
      APPEND ls_detail_return_aux TO lt_detail_return.
*      DATA(lv_erro_par_obrig) = 'X'.
      DATA lv_erro_par_obrig TYPE c.
      lv_erro_par_obrig  = abap_true.
*      RETURN.
    ENDIF.

    IF lv_erro_par_obrig IS INITIAL.

* Verifica se data/hora início da confirmação foi preenchido
      IF im_confirmacao-data_hora_inicio IS INITIAL.
        CLEAR ls_detail_return_aux.
        ls_detail_return_aux-type = 'E'.
        ls_detail_return_aux-message = 'Data/Hora Início da Confirmação não preenchido'(011).
        APPEND ls_detail_return_aux TO lt_detail_return.
*        DATA(lv_erro_dt_ini) = 'X'.
        DATA lv_erro_dt_ini TYPE c.
        lv_erro_dt_ini  = abap_true.
      ENDIF.
* Verifica se data/hora fim da confirmação foi preenchido
      IF im_confirmacao-data_hora_fim IS INITIAL.
        CLEAR ls_detail_return_aux.
        ls_detail_return_aux-type = 'E'.
        ls_detail_return_aux-message = 'Data/Hora Fim da Confirmação não preenchido'(012).
        APPEND ls_detail_return_aux TO lt_detail_return.
*        DATA(lv_erro_dt_fim) = 'X'.
        DATA lv_erro_dt_fim TYPE c.
        lv_erro_dt_fim  = abap_true.
      ENDIF.

      IF lv_erro_dt_ini IS INITIAL AND lv_erro_dt_fim IS INITIAL.

* Monta matrícula
        IF im_confirmacao-usuario_app IS NOT INITIAL.
          lv_usuario = im_confirmacao-usuario_app.
        ELSE.
          lv_usuario = sy-uname.
        ENDIF.

        lv_usuario = /ptloms/cl006=>busca_usuario( lv_usuario ).

* Busca matrícula do usuário
*        SELECT SINGLE matricula FROM /ptloms/tb013 INTO @DATA(lv_matricula) WHERE usuario = @lv_usuario.
        DATA lv_matricula TYPE /ptloms/tb013-matricula .
        CLEAR lv_matricula.
        SELECT SINGLE matricula FROM /ptloms/tb013 INTO lv_matricula WHERE usuario = lv_usuario.

        MOVE-CORRESPONDING im_confirmacao TO ls_confirmacao.

        IF lv_matricula IS NOT INITIAL.
          ls_confirmacao-pers_no = lv_matricula.
*      ELSEIF lv_usuario IS NOT INITIAL.
*        ls_confirmacao-pers_no = lv_usuario.
        ENDIF.

*        lv_aufnr = |{ im_confirmacao-orderid ALPHA = IN }|.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = im_confirmacao-orderid
          IMPORTING
            output = lv_aufnr.

*    LOOP AT it_confirmacao INTO DATA(ls_confirmacao).

* Limpa variáveis
        CLEAR: ls_timetickets.

* Limpa tabelas
        REFRESH: lt_timetickets[], lt_detail_return[].

        IF ls_confirmacao-conf_text IS INITIAL.
          ls_confirmacao-conf_text = 'Informação no Texto Longo'(013).
        ENDIF.

* Atribui campos da confirmação
        MOVE-CORRESPONDING: ls_confirmacao TO ls_timetickets.
        ls_timetickets-act_work_2 = ls_confirmacao-act_work.

        CLEAR ls_timetickets-act_work.
        ls_timetickets-orderid = lv_aufnr.
        ls_timetickets-sub_oper = ls_confirmacao-sub_activity.
        ls_timetickets-operation = ls_confirmacao-activity.

**        ls_timetickets-exec_start_date = ls_confirmacao-data_hora_inicio+6(4) &&
**                                         ls_confirmacao-data_hora_inicio+3(2) &&
**                                         ls_confirmacao-data_hora_inicio(2).
**        ls_timetickets-exec_start_time = ls_confirmacao-data_hora_inicio+11(2) &&
**                                         ls_confirmacao-data_hora_inicio+14(2) &&
**                                         ls_confirmacao-data_hora_inicio+17(2).
**        ls_timetickets-exec_fin_date =   ls_confirmacao-data_hora_fim+6(4) &&
**                                         ls_confirmacao-data_hora_fim+3(2) &&
**                                         ls_confirmacao-data_hora_fim(2).
**        ls_timetickets-exec_fin_time =   ls_confirmacao-data_hora_fim+11(2) &&
**                                         ls_confirmacao-data_hora_fim+14(2) &&
**                                         ls_confirmacao-data_hora_fim+17(2).

        CONCATENATE ls_confirmacao-data_hora_inicio+6(4)
                    ls_confirmacao-data_hora_inicio+3(2)
                    ls_confirmacao-data_hora_inicio(2) INTO ls_timetickets-exec_start_date.

        CONCATENATE ls_confirmacao-data_hora_inicio+11(2)
                    ls_confirmacao-data_hora_inicio+14(2)
                    ls_confirmacao-data_hora_inicio+17(2) INTO ls_timetickets-exec_start_time.

        CONCATENATE ls_confirmacao-data_hora_fim+6(4)
                    ls_confirmacao-data_hora_fim+3(2)
                    ls_confirmacao-data_hora_fim(2)   INTO ls_timetickets-exec_fin_date.

        CONCATENATE ls_confirmacao-data_hora_fim+11(2)
                    ls_confirmacao-data_hora_fim+14(2)
                    ls_confirmacao-data_hora_fim+17(2) INTO ls_timetickets-exec_fin_time.

*      IF ls_timetickets-act_work = 0 AND ls_confirmacao-status_mobile = 5.
*        CLEAR ls_detail_return_aux.
*        ls_detail_return_aux-type = 'E'.
*        ls_detail_return_aux-message = 'Não é possível efetuar confirmação para Trabalho Real igual a zero'.
*        APPEND ls_detail_return_aux TO lt_detail_return.
*        DATA(lv_erro_conf_zero) = 'X'.
*      ENDIF.

*      IF lv_erro_conf_zero IS INITIAL.
        IF ls_timetickets-act_work_2 = 0 AND ls_timetickets-dev_reason IS INITIAL.
          CALL FUNCTION 'COPF_DETERMINE_DURATION'
            EXPORTING
              i_start_date       = ls_timetickets-exec_start_date
              i_start_time       = ls_timetickets-exec_start_time
              i_end_date         = ls_timetickets-exec_fin_date
              i_end_time         = ls_timetickets-exec_fin_time
              i_unit_of_duration = ls_timetickets-un_work
*             I_FACTORY_CALENDAR =
            IMPORTING
              e_duration         = lv_duration
            EXCEPTIONS
              exception_raised   = 1
              OTHERS             = 2.

          IF sy-subrc EQ 0.
            lv_un_work = lv_duration.
            ls_timetickets-act_work_2 = lv_un_work.
          ENDIF.
        ENDIF.

        "Preenche Trabalho Real
        IF ls_timetickets-act_work = 0 AND ls_confirmacao-data_hora_inicio IS NOT INITIAL AND ls_confirmacao-data_hora_fim IS NOT INITIAL.

          CLEAR: lv_duration, lv_un_work.
          CALL FUNCTION 'COPF_DETERMINE_DURATION'
            EXPORTING
              i_start_date       = ls_timetickets-exec_start_date
              i_start_time       = ls_timetickets-exec_start_time
              i_end_date         = ls_timetickets-exec_fin_date
              i_end_time         = ls_timetickets-exec_fin_time
              i_unit_of_duration = ls_timetickets-un_work
*             I_FACTORY_CALENDAR =
            IMPORTING
              e_duration         = lv_duration
            EXCEPTIONS
              exception_raised   = 1
              OTHERS             = 2.

          IF sy-subrc EQ 0.
            lv_un_work = lv_duration.
            ls_timetickets-act_work = lv_un_work.
          ENDIF.

        ENDIF.

*      IF ls_timetickets-un_work = 'H'.
*        SELECT SINGLE limite_conf FROM /ptloms/tb013 INTO @DATA(lv_limite_conf) WHERE usuario = @lv_usuario.
        DATA: lv_limite_conf   TYPE /ptloms/tb013-limite_conf,
              lv_unidade_tempo TYPE /ptloms/tb013-unidade_tempo.

******************************************************************************************************************************************
*** Pontual - Gbretz - 17/06/2025 - Ajustes em função do DUMP ocorrido na SOLAR ao informar limite de confirmação igual a 600 minutos.
*** INICIO
******************************************************************************************************************************************
***        SELECT SINGLE limite_conf FROM /ptloms/tb013 INTO lv_limite_conf WHERE usuario = lv_usuario.
***        IF ls_timetickets-un_work EQ 'MIN'.
***          "  ls_timetickets-act_work_2 = ls_timetickets-act_work_2 / 60.
***          lv_limite_conf = lv_limite_conf * 60.
***        ENDIF.

        CLEAR: lv_limite_conf, lv_unidade_tempo.
        SELECT SINGLE limite_conf unidade_tempo INTO (lv_limite_conf, lv_unidade_tempo)
          FROM /ptloms/tb013
          WHERE usuario = lv_usuario.

        IF ls_timetickets-un_work EQ 'MIN' AND lv_unidade_tempo = 'H'.
          lv_limite_conf = lv_limite_conf * 60.
        ELSEIF ls_timetickets-un_work EQ 'H' AND lv_unidade_tempo = 'MIN'.
          lv_limite_conf = lv_limite_conf / 60.
        ENDIF.
******************************************************************************************************************************************
*** FIM
********************************************************************************************************************************************

        IF ls_timetickets-act_work_2 > lv_limite_conf.
          CLEAR ls_detail_return_aux.
          ls_detail_return_aux-type = 'E'.
          ls_detail_return_aux-message = 'Horas confirmadas maiores que o máximo permitido'(014).
          APPEND ls_detail_return_aux TO lt_detail_return.
*          DATA(lv_erro_conf_max) = 'X'.
          DATA lv_erro_conf_max TYPE c.
          CLEAR lv_erro_conf_max.
          lv_erro_conf_max   = abap_true.
        ENDIF.

        DATA lv_conf_dt_lanc TYPE /ptloms/tb033-conf_dt_lanc.
        CLEAR lv_conf_dt_lanc.
        SELECT SINGLE conf_dt_lanc FROM /ptloms/tb033 INTO lv_conf_dt_lanc.
        IF sy-subrc EQ 0 AND lv_conf_dt_lanc = 'X'.
          ls_timetickets-postg_date = ls_timetickets-exec_start_date.
        ENDIF.

*       Carrega tipo de atividade
        DATA lv_aufpl TYPE afko-aufpl.
        CLEAR lv_aufpl.
        SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = lv_aufnr.
        IF sy-subrc EQ 0.
*          SELECT aufpl, aplzl, arbid, werks, larnt
*            FROM afvc
*            INTO TABLE @DATA(lt_afvc)
*            WHERE aufpl = @lv_aufpl
*              AND vornr = @im_confirmacao-activity.
*          READ TABLE lt_afvc INTO DATA(ls_afvc) INDEX 1.
          DATA: lt_afvc TYPE TABLE OF afvc,
                ls_afvc TYPE afvc.
          REFRESH lt_afvc.
          SELECT aufpl aplzl arbid werks larnt
            FROM afvc
            APPENDING CORRESPONDING FIELDS OF TABLE lt_afvc
            WHERE aufpl = lv_aufpl
              AND vornr = im_confirmacao-activity.
          READ TABLE lt_afvc INTO ls_afvc INDEX 1.
          IF sy-subrc EQ 0.
            ls_timetickets-act_type = ls_afvc-larnt.
          ENDIF.
        ENDIF.
        IF ls_timetickets-act_type IS INITIAL.
          IF ls_afvc-arbid IS NOT INITIAL AND ls_afvc-werks IS NOT INITIAL.
            SELECT SINGLE learr FROM /ptloms/tb005 INTO ls_timetickets-act_type WHERE objid = ls_afvc-arbid AND werks = ls_afvc-werks.
          ENDIF.
        ENDIF.

* Insere na tabela para Confirmar Mão de Obra
        APPEND ls_timetickets TO lt_timetickets.

* Verifica se houve alguma confirmação para a Ordem/Operação na mesma Data/Hora
*        SELECT SINGLE *
*          FROM afru
*          INTO @DATA(ls_afru)
*          WHERE rueck = @ls_timetickets-conf_no
*            AND isdd = @ls_timetickets-exec_start_date
*            AND isdz = @ls_timetickets-exec_start_time
*            AND iedd = @ls_timetickets-exec_fin_date
*            AND iedz = @ls_timetickets-exec_fin_time.

        DATA ls_afru    TYPE afru.
        CLEAR ls_afru.
        SELECT SINGLE *
                      FROM afru
                      INTO ls_afru
          WHERE rueck = ls_timetickets-conf_no
            AND isdd  = ls_timetickets-exec_start_date
            AND isdz  = ls_timetickets-exec_start_time
            AND iedd  = ls_timetickets-exec_fin_date
            AND iedz  = ls_timetickets-exec_fin_time.

        IF sy-subrc EQ 0.
          CLEAR ls_detail_return_aux.
          ls_detail_return_aux-type = 'E'.
          ls_detail_return_aux-message = 'Confirmação já realizada para Data/Hora Início/Fim'(002).
          APPEND ls_detail_return_aux TO lt_detail_return.
*          DATA(lv_erro_data) = 'X'.
          DATA lv_erro_data TYPE c.
          lv_erro_data  = 'X'.
        ENDIF.

        IF lv_erro_conf_max IS INITIAL.
          IF lv_erro_data IS INITIAL.

            WAIT UP TO 1 SECONDS.
* Confirma Mão de Obra
            CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
              TABLES
                timetickets   = lt_timetickets
                detail_return = lt_detail_return.

*            READ TABLE lt_detail_return INTO DATA(ls_detail_return) WITH KEY type = 'E'.
            DATA ls_detail_return LIKE LINE OF lt_detail_return.
            READ TABLE lt_detail_return INTO ls_detail_return WITH KEY type = 'E'.

            IF sy-subrc NE 0.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = 'X'.

* Busca CONF_CNT
              CLEAR:
                lv_conf_no ,
                lv_conf_cnt.

              LOOP AT lt_detail_return INTO ls_detail_return WHERE conf_cnt IS NOT INITIAL.
                lv_conf_no   = ls_detail_return-conf_no .      "Nova estrutura da tabela TB031
                lv_conf_cnt  = ls_detail_return-conf_cnt.      "Nova estrutura da tabela TB031
                EXIT.
              ENDLOOP.

* Composição do HEADER do texto
              CLEAR ls_header.
              ls_header-tdname   = sy-mandt && ls_confirmacao-conf_no && ls_detail_return-conf_cnt.
              ls_header-tdobject = 'AUFK'.
              ls_header-tdid     = 'RMEL'.
              ls_header-tdspras  = sy-langu.

* Carrega tabela com texto Longo
*            IF ls_confirmacao-conf_text IS NOT INITIAL.
              CLEAR ls_textlines.
              ls_textlines-tdformat = '*'.
              ls_textlines-tdline   = ls_confirmacao-conf_text.
              APPEND ls_textlines TO lt_textlines.
*            ENDIF.

*            SPLIT ls_confirmacao-texto_longo AT '<p>' INTO TABLE lt_texto_longo.
*            LOOP AT lt_texto_longo INTO DATA(ls_texto).
*              CLEAR ls_textlines.
*              ls_textlines-tdformat = '*'.
*              ls_textlines-tdline   = ls_texto.
*              APPEND ls_textlines TO lt_textlines.
*            ENDLOOP.

              lt_textlines_aux[] = lt_textlines[].

* Monta Texto Longo
              CALL FUNCTION '/PTLOMS/MF054'
                EXPORTING
                  im_texto_longo = ls_confirmacao-texto_longo
                TABLES
                  it_texto       = lt_textlines_aux.

              lt_textlines[] = lt_textlines_aux[].

*      LOOP AT it_texto INTO DATA(ls_texto).
*        CLEAR ls_textlines.
*        ls_textlines-tdformat = ls_texto-tdformat.
*        ls_textlines-tdline   = ls_texto-tdline.
*        APPEND ls_textlines TO lt_textlines.
*      ENDLOOP.

              CALL FUNCTION 'SAVE_TEXT'
                EXPORTING
                  client          = sy-mandt
                  header          = ls_header
                  savemode_direct = 'X'
                TABLES
                  lines           = lt_textlines
                EXCEPTIONS
                  id              = 1
                  language        = 2
                  name            = 3
                  object          = 4
                  OTHERS          = 5.

              CALL FUNCTION 'COMMIT_TEXT'.

* Busca ordem referente à confirmação
*              READ TABLE lt_detail_return INTO DATA(ls_detail_return_ordem) WITH KEY type = 'I'
              DATA ls_detail_return_ordem LIKE LINE OF lt_detail_return.
              READ TABLE lt_detail_return INTO ls_detail_return_ordem       WITH KEY type = 'I'
                                                                                     message_id = 'RU'
                                                                                     message_number = 100.
              IF sy-subrc EQ 0.
*                lv_aufnr = |{ ls_detail_return_ordem-message_v1 ALPHA = IN }|.

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = ls_detail_return_ordem-message_v1
                  IMPORTING
                    output = lv_aufnr.

* Atualizar Data Fim Avaria
                CALL FUNCTION '/PTLOMS/MF053'
                  EXPORTING
                    im_aufnr       = lv_aufnr
                    im_endmlfndate = ls_timetickets-exec_fin_date
                    im_endmlfntime = ls_timetickets-exec_fin_time
                  TABLES
                    it_return      = lt_return_fim_avaria.

* Encerrar Ordem Tecnicamente (Caso tenha Status I0009 [Confirmado] )
                IF 1 = 2.
                  CALL FUNCTION '/PTLOMS/MF006'
                    EXPORTING
                      im_aufnr          = lv_aufnr
                      im_usuario_mobile = lv_usuario "im_confirmacao-usuario_app
                      im_date           = ls_timetickets-exec_fin_date
                      im_time           = ls_timetickets-exec_fin_time
                    IMPORTING
                      ex_ente           = lv_ente
                    TABLES
                      it_return         = lt_return_conf.
                ENDIF.

                CALL FUNCTION '/PTLOMS/MF052'
                  EXPORTING
                    im_aufnr          = lv_aufnr
                    im_usuario_mobile = lv_usuario "im_confirmacao-usuario_app
                    im_date           = ls_timetickets-exec_fin_date
                    im_time           = ls_timetickets-exec_fin_time
                  IMPORTING
                    ex_ente           = lv_ente
                  TABLES
                    it_return         = lt_return_conf.

* Atualiza status da operação
                CALL FUNCTION '/PTLOMS/MF007'
                  EXPORTING
                    im_aufnr            = lv_aufnr
                    im_vornr            = ls_confirmacao-activity
                    im_suboper          = ls_confirmacao-sub_activity
                    im_usuario_mobile   = lv_usuario "ls_confirmacao-usuario_app "ls_confirmacao-usuario_mobile
                    im_date_ini         = sy-datum "ls_timetickets-exec_start_date
                    im_time_ini         = sy-uzeit "ls_timetickets-exec_start_time
                    im_date_fim         = sy-datum "ls_timetickets-exec_fin_date
                    im_time_fim         = sy-uzeit "ls_timetickets-exec_fin_time
                    im_dev_reason       = ls_confirmacao-dev_reason
                    im_fin_conf         = ls_confirmacao-fin_conf
                    im_despacho_anulado = space
                    im_status_mobile    = ls_confirmacao-status_mobile
                    im_enc_tec          = lv_ente
                    im_conf_no          = lv_conf_no               "Nova estrutura da tabela /ptloms/tb031
                    im_conf_cnt         = lv_conf_cnt
                  TABLES
                    it_return           = lt_return_status_oper.

*Limpa numero da matricula da operação quando há recusa.
                IF ls_confirmacao-status_mobile EQ '5'.
                  CALL FUNCTION '/PTLOMS/MF056'
                    EXPORTING
                      aufnr   = lv_aufnr
                      vornr   = ls_confirmacao-activity
                      suboper = ls_confirmacao-sub_activity
                      usuario = lv_usuario. "ls_confirmacao-usuario_app.
                ENDIF.

              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*      ENDIF.
    ENDIF.

    lv_subobject = '/PTLOMS/CONF'.
    lv_extnumber = ls_confirmacao-conf_no.
    lv_user      = lv_usuario. "ls_confirmacao-usuario_app.

* Instancia objeto de Log por Confirmação
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

    LOOP AT lt_detail_return INTO ls_detail_return.
      lv_type = ls_detail_return-type.
      CONCATENATE ls_detail_return-message 'Usuário SAP: '(015) sy-uname INTO lv_msg SEPARATED BY space.
***   lv_msg = ls_detail_return-message && |Usuário SAP: | && sy-uname.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

*    LOOP AT lt_return_conf INTO DATA(ls_return_conf).
    DATA ls_return_conf LIKE LINE OF lt_return_conf.
    LOOP AT lt_return_conf INTO ls_return_conf.
      lv_type = ls_return_conf-type.
      lv_msg = ls_return_conf-message.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

*    LOOP AT lt_return_status_oper INTO DATA(ls_return_status_oper).
    DATA ls_return_status_oper LIKE LINE OF lt_return_status_oper.
    LOOP AT lt_return_status_oper INTO ls_return_status_oper.
      lv_type = ls_return_status_oper-type.
      lv_msg = ls_return_status_oper-message.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

    LOOP AT lt_detail_return INTO ls_detail_return.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_detail_return TO ls_return_aux.
      ls_return_aux-message_v3 = lv_aufnr.
      ls_return_aux-message_v4 = ls_confirmacao-activity.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO rt_return."lt_return_aux.
    ENDLOOP.

    LOOP AT lt_return_conf INTO ls_return_conf.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return_conf TO ls_return_aux.
      ls_return_aux-message_id = ls_return_conf-id.
      ls_return_aux-message_number = ls_return_conf-number.
      ls_return_aux-log_number = ls_return_conf-log_no.
      ls_return_aux-message_v3 = lv_aufnr.
      ls_return_aux-message_v4 = ls_confirmacao-activity.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO rt_return."lt_return_aux.
    ENDLOOP.

    LOOP AT lt_return_status_oper INTO ls_return_status_oper.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return_status_oper TO ls_return_aux.
      ls_return_aux-message_id = ls_return_conf-id.
      ls_return_aux-message_number = ls_return_conf-number.
      ls_return_aux-log_number = ls_return_conf-log_no.
      ls_return_aux-message_v3 = lv_aufnr.
      ls_return_aux-message_v4 = ls_confirmacao-activity.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO rt_return."lt_return_aux.
    ENDLOOP.

*    ls_return-it_return = lt_return_aux.

*    APPEND ls_return TO rt_return.
*    ENDLOOP.

  ENDMETHOD.


  METHOD in_confirmacao_catalogo.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: ls_return_aux TYPE /ptloms/et062.

    IF im_confirmacao-fin_conf IS NOT INITIAL.

      IF im_confirmacao-orderid IS NOT INITIAL.

***     DATA(aufnr) = |{ im_confirmacao-orderid ALPHA = IN }|.

        DATA: aufnr LIKE im_confirmacao-orderid.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = im_confirmacao-orderid
          IMPORTING
            output = aufnr.

        " Buscar nota referente a ordem
        DATA: qmnum TYPE qmel-qmnum.

        SELECT SINGLE qmnum
          FROM qmel
          INTO qmnum
          WHERE aufnr = aufnr.

***        SELECT SINGLE qmnum
***          FROM qmel
***          INTO @DATA(qmnum)
***          WHERE aufnr = @aufnr.

        IF sy-subrc IS INITIAL.

          " Buscar tipo da nota

          DATA: auart TYPE aufk-auart.

          SELECT SINGLE auart
            FROM aufk
            INTO auart
            WHERE aufnr = aufnr.

***          SELECT SINGLE auart
***            FROM aufk
***            INTO @DATA(auart)
***            WHERE aufnr = @aufnr.

          IF sy-subrc IS INITIAL.

            " Buscar o perfil
            DATA: perfil TYPE /ptloms/tb013-perfil.

            SELECT SINGLE perfil
              FROM /ptloms/tb013
              INTO perfil
              WHERE usuario = im_confirmacao-usuario_app.

***            SELECT SINGLE perfil
***              FROM /ptloms/tb013
***              INTO @DATA(perfil)
***              WHERE usuario = @im_confirmacao-usuario_app.

            IF sy-subrc IS INITIAL.

              " Verificar se o tipo da ordem tem a obrigatoriedade de inserir catálogo na nota
              DATA: wa_tb010 TYPE /ptloms/tb022.

              SELECT SINGLE *
                FROM /ptloms/tb022
                INTO CORRESPONDING FIELDS OF wa_tb010
                WHERE perfil          = perfil
                  AND auart           = auart
                  AND filtro_catalogo = '02'. " Catálogo obrigatório

***              SELECT SINGLE *
***                FROM /ptloms/tb022
***                INTO @DATA(wa_tb010)
***                WHERE perfil = @perfil AND
***                      auart = @auart   AND
***            filtro_catalogo = '02'. " Catálogo obrigatório

              IF sy-subrc IS INITIAL.

                " Verificar na tabela de controle de catálogo
                TYPES: BEGIN OF ty_tb050,
                         qmnum TYPE /ptloms/tb050-qmnum,
                       END OF ty_tb050.

                DATA: lt_tb050 TYPE TABLE OF ty_tb050.

                SELECT qmnum
                  FROM /ptloms/tb050
                  INTO TABLE lt_tb050
                  WHERE aufnr = aufnr
                    AND usuario_app = im_confirmacao-usuario_app.

***                SELECT qmnum FROM
***                  /ptloms/tb050
***                  INTO TABLE @DATA(lt_tb050)
***                  WHERE aufnr = @aufnr AND
***                  usuario_app = @im_confirmacao-usuario_app.

                IF sy-subrc IS NOT INITIAL.

                  ls_return_aux-type           = 'E'.
                  ls_return_aux-message_id     = 'SU'.
                  ls_return_aux-message_number = '000'.
                  ls_return_aux-message        = 'Catálogo deve ser informado antes da confirmação final'(031).
                  ls_return_aux-message_v3     = im_confirmacao-orderid.
                  ls_return_aux-type_desc      = 'Error'.

                  APPEND ls_return_aux TO rt_return.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD in_confirmacao_cesto.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declarações para BAPI
    DATA: lt_timetickets        TYPE STANDARD TABLE OF bapi_alm_timeconfirmation,
          lt_detail_return      TYPE STANDARD TABLE OF bapi_alm_return,
          lt_textlines          TYPE TABLE OF tline,
          lt_textlines_aux      TYPE STANDARD TABLE OF bapi_alm_text_lines,
          lt_return_aux         TYPE /ptloms/ct062,
          lt_return_conf        TYPE STANDARD TABLE OF bapiret2,
          lt_return_status_oper TYPE STANDARD TABLE OF bapiret2,
          lt_return_fim_avaria  TYPE STANDARD TABLE OF bapiret2,
          lt_texto_longo        TYPE TABLE OF string,
          lt_tb031              TYPE TABLE OF /ptloms/tb031.

* Declaração de estrutura
    DATA: ls_timetickets       LIKE LINE OF lt_timetickets,
          ls_return            LIKE LINE OF rt_return,
          ls_textlines         LIKE LINE OF lt_textlines,
          ls_header            TYPE thead,
          ls_return_aux        TYPE /ptloms/et062,
          ls_confirmacao       TYPE /ptloms/et051,
          ls_detail_return_aux LIKE LINE OF lt_detail_return,
          ls_tb031             LIKE LINE OF lt_tb031,
          ls_im_confirmacao    TYPE /ptloms/et051.

* Declaração de variáveis
    DATA: lv_aufnr      TYPE aufnr,
          lv_ente       TYPE char1,
          lv_usuario    TYPE /ptloms/tb013-usuario,
          lv_duration   TYPE f,
          lv_un_work(7) TYPE p DECIMALS 1,
          lv_user       TYPE sy-uname.

* Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_contador  TYPE i,
          lv_continua  TYPE c LENGTH 1 VALUE 'X',
          lv_qte_conf  TYPE i,
          lv_fin_conf  TYPE c LENGTH 1.

    ls_im_confirmacao = im_confirmacao.

* Verifica se parâmetro de entrada foi preenchido
    IF ls_im_confirmacao          IS INITIAL OR
       ls_im_confirmacao-orderid  IS INITIAL OR
       ls_im_confirmacao-activity IS INITIAL.

      CLEAR ls_detail_return_aux.
      ls_detail_return_aux-type = 'E'.
      ls_detail_return_aux-message = 'Parâmetros obrigatórios não preenchidos'(001).
      APPEND ls_detail_return_aux TO lt_detail_return.
*      DATA(lv_erro_par_obrig) = 'X'.
      DATA lv_erro_par_obrig TYPE c.
      lv_erro_par_obrig  = abap_true.
*      RETURN.
    ENDIF.

    IF lv_erro_par_obrig IS INITIAL.

* Verifica se data/hora início da confirmação foi preenchido
      IF ls_im_confirmacao-data_hora_inicio IS INITIAL.
        CLEAR ls_detail_return_aux.
        ls_detail_return_aux-type = 'E'.
        ls_detail_return_aux-message = 'Data/Hora Início da Confirmação não preenchido'(011).
        APPEND ls_detail_return_aux TO lt_detail_return.
*        DATA(lv_erro_dt_ini) = 'X'.
        DATA lv_erro_dt_ini TYPE c.
        lv_erro_dt_ini  = abap_true.
      ENDIF.
* Verifica se data/hora fim da confirmação foi preenchido
      IF ls_im_confirmacao-data_hora_fim IS INITIAL.
        CLEAR ls_detail_return_aux.
        ls_detail_return_aux-type = 'E'.
        ls_detail_return_aux-message = 'Data/Hora Fim da Confirmação não preenchido'(012).
        APPEND ls_detail_return_aux TO lt_detail_return.
*        DATA(lv_erro_dt_fim) = 'X'.
        DATA lv_erro_dt_fim TYPE c.
        lv_erro_dt_fim  = abap_true.
      ENDIF.

      IF lv_erro_dt_ini IS INITIAL AND lv_erro_dt_fim IS INITIAL.

* Monta matrícula
        IF ls_im_confirmacao-usuario_app IS NOT INITIAL.
          lv_usuario = ls_im_confirmacao-usuario_app.
        ELSE.
          lv_usuario = sy-uname.
        ENDIF.

        lv_usuario = /ptloms/cl006=>busca_usuario( lv_usuario ).

* Busca matrícula do usuário
*        SELECT SINGLE matricula FROM /ptloms/tb013 INTO @DATA(lv_matricula) WHERE usuario = @lv_usuario.
        DATA lv_matricula TYPE /ptloms/tb013-matricula .
        CLEAR lv_matricula.
        SELECT SINGLE matricula FROM /ptloms/tb013 INTO lv_matricula WHERE usuario = lv_usuario.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_im_confirmacao-orderid
          IMPORTING
            output = lv_aufnr.

        SELECT DISTINCT usuario
          FROM /ptloms/tb031
          INTO CORRESPONDING FIELDS OF TABLE lt_tb031
          WHERE aufnr = lv_aufnr
            AND vornr = ls_im_confirmacao-activity
            AND conf_final = ''.

        IF sy-subrc IS INITIAL.

          IF ls_im_confirmacao-fin_conf IS NOT INITIAL.

            lv_fin_conf = 'X'.

            DESCRIBE TABLE lt_tb031 LINES lv_qte_conf.

            IF lv_qte_conf > 1.
              CLEAR ls_im_confirmacao-fin_conf.
              CLEAR ls_im_confirmacao-complete.
            ENDIF.

          ENDIF.

        ENDIF.

        MOVE-CORRESPONDING ls_im_confirmacao TO ls_confirmacao.

        IF lv_matricula IS NOT INITIAL.
          ls_confirmacao-pers_no = lv_matricula.
*      ELSEIF lv_usuario IS NOT INITIAL.
*        ls_confirmacao-pers_no = lv_usuario.
        ENDIF.

*        lv_aufnr = |{ ls_im_confirmacao-orderid ALPHA = IN }|.



*    LOOP AT it_confirmacao INTO DATA(ls_confirmacao).

* Limpa variáveis
        CLEAR: ls_timetickets.

* Limpa tabelas
        REFRESH: lt_timetickets[], lt_detail_return[].

        IF ls_confirmacao-conf_text IS INITIAL.
          ls_confirmacao-conf_text = 'Informação no Texto Longo'(013).
        ENDIF.

* Atribui campos da confirmação
        MOVE-CORRESPONDING: ls_confirmacao TO ls_timetickets.

        ls_timetickets-act_work_2 = ls_confirmacao-act_work.
        CLEAR ls_timetickets-act_work.

        ls_timetickets-orderid = lv_aufnr.

        ls_timetickets-sub_oper = ls_confirmacao-sub_activity.

        ls_timetickets-operation = ls_confirmacao-activity.

**        ls_timetickets-exec_start_date = ls_confirmacao-data_hora_inicio+6(4) &&
**                                         ls_confirmacao-data_hora_inicio+3(2) &&
**                                         ls_confirmacao-data_hora_inicio(2).
**        ls_timetickets-exec_start_time = ls_confirmacao-data_hora_inicio+11(2) &&
**                                         ls_confirmacao-data_hora_inicio+14(2) &&
**                                         ls_confirmacao-data_hora_inicio+17(2).
**        ls_timetickets-exec_fin_date =   ls_confirmacao-data_hora_fim+6(4) &&
**                                         ls_confirmacao-data_hora_fim+3(2) &&
**                                         ls_confirmacao-data_hora_fim(2).
**        ls_timetickets-exec_fin_time =   ls_confirmacao-data_hora_fim+11(2) &&
**                                         ls_confirmacao-data_hora_fim+14(2) &&
**                                         ls_confirmacao-data_hora_fim+17(2).

        CONCATENATE ls_confirmacao-data_hora_inicio+6(4)
                    ls_confirmacao-data_hora_inicio+3(2)
                    ls_confirmacao-data_hora_inicio(2) INTO ls_timetickets-exec_start_date.

        CONCATENATE ls_confirmacao-data_hora_inicio+11(2)
                    ls_confirmacao-data_hora_inicio+14(2)
                    ls_confirmacao-data_hora_inicio+17(2) INTO ls_timetickets-exec_start_time.

        CONCATENATE ls_confirmacao-data_hora_fim+6(4)
                    ls_confirmacao-data_hora_fim+3(2)
                    ls_confirmacao-data_hora_fim(2)   INTO ls_timetickets-exec_fin_date.

        CONCATENATE ls_confirmacao-data_hora_fim+11(2)
                    ls_confirmacao-data_hora_fim+14(2)
                    ls_confirmacao-data_hora_fim+17(2) INTO ls_timetickets-exec_fin_time.

*      IF ls_timetickets-act_work = 0 AND ls_confirmacao-status_mobile = 5.
*        CLEAR ls_detail_return_aux.
*        ls_detail_return_aux-type = 'E'.
*        ls_detail_return_aux-message = 'Não é possível efetuar confirmação para Trabalho Real igual a zero'.
*        APPEND ls_detail_return_aux TO lt_detail_return.
*        DATA(lv_erro_conf_zero) = 'X'.
*      ENDIF.

*      IF lv_erro_conf_zero IS INITIAL.
        IF ls_timetickets-act_work_2 = 0 AND ls_timetickets-dev_reason IS INITIAL.
          CALL FUNCTION 'COPF_DETERMINE_DURATION'
            EXPORTING
              i_start_date       = ls_timetickets-exec_start_date
              i_start_time       = ls_timetickets-exec_start_time
              i_end_date         = ls_timetickets-exec_fin_date
              i_end_time         = ls_timetickets-exec_fin_time
              i_unit_of_duration = ls_timetickets-un_work
*             I_FACTORY_CALENDAR =
            IMPORTING
              e_duration         = lv_duration
            EXCEPTIONS
              exception_raised   = 1
              OTHERS             = 2.

          IF sy-subrc EQ 0.
            lv_un_work = lv_duration.
            ls_timetickets-act_work_2 = lv_un_work.
          ENDIF.
        ENDIF.

         IF ls_timetickets-act_work_2 = 0.
           ls_timetickets-act_work_2 = '0.01'.
         ENDIF.

*      IF ls_timetickets-un_work = 'H'.
*        SELECT SINGLE limite_conf FROM /ptloms/tb013 INTO @DATA(lv_limite_conf) WHERE usuario = @lv_usuario.
        DATA lv_limite_conf TYPE /ptloms/tb013-limite_conf.
        SELECT SINGLE limite_conf FROM /ptloms/tb013 INTO lv_limite_conf WHERE usuario = lv_usuario.
        IF ls_timetickets-un_work EQ 'MIN'.
          "  ls_timetickets-act_work_2 = ls_timetickets-act_work_2 / 60.
          lv_limite_conf = lv_limite_conf * 60.
        ENDIF.
        IF ls_timetickets-act_work_2 > lv_limite_conf.
          CLEAR ls_detail_return_aux.
          ls_detail_return_aux-type = 'E'.
          ls_detail_return_aux-message = 'Horas Confirmadas maior que o máximo permitido'(014).
          APPEND ls_detail_return_aux TO lt_detail_return.
*          DATA(lv_erro_conf_max) = 'X'.
          DATA lv_erro_conf_max TYPE c.
          CLEAR lv_erro_conf_max.
          lv_erro_conf_max   = abap_true.
        ENDIF.
*      ENDIF.

*        SELECT SINGLE conf_dt_lanc FROM /ptloms/tb033 INTO @DATA(lv_conf_dt_lanc).
        DATA lv_conf_dt_lanc TYPE /ptloms/tb033-conf_dt_lanc.
        CLEAR lv_conf_dt_lanc.
        SELECT SINGLE conf_dt_lanc FROM /ptloms/tb033 INTO lv_conf_dt_lanc.
        IF sy-subrc EQ 0 AND lv_conf_dt_lanc = 'X'.
          ls_timetickets-postg_date = ls_timetickets-exec_start_date.
        ENDIF.

* Carrega tipo de atividade
*        SELECT SINGLE aufpl FROM afko INTO @DATA(lv_aufpl) WHERE aufnr = @lv_aufnr.
        DATA lv_aufpl TYPE afko-aufpl.
        CLEAR lv_aufpl.
        SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = lv_aufnr.
        IF sy-subrc EQ 0.
*          SELECT aufpl, aplzl, arbid, werks, larnt
*            FROM afvc
*            INTO TABLE @DATA(lt_afvc)
*            WHERE aufpl = @lv_aufpl
*              AND vornr = @ls_im_confirmacao-activity.
*          READ TABLE lt_afvc INTO DATA(ls_afvc) INDEX 1.
          DATA: lt_afvc TYPE TABLE OF afvc,
                ls_afvc TYPE afvc.
          REFRESH lt_afvc.
          SELECT aufpl aplzl arbid werks larnt
            FROM afvc
            APPENDING CORRESPONDING FIELDS OF TABLE lt_afvc
            WHERE aufpl = lv_aufpl
              AND vornr = ls_im_confirmacao-activity.
          READ TABLE lt_afvc INTO ls_afvc INDEX 1.
          IF sy-subrc EQ 0.
            ls_timetickets-act_type = ls_afvc-larnt.
          ENDIF.
        ENDIF.
        IF ls_timetickets-act_type IS INITIAL.
          IF ls_afvc-arbid IS NOT INITIAL AND ls_afvc-werks IS NOT INITIAL.
            SELECT SINGLE learr FROM /ptloms/tb005 INTO ls_timetickets-act_type WHERE objid = ls_afvc-arbid AND werks = ls_afvc-werks.
          ENDIF.
        ENDIF.

* Insere na tabela para Confirmar Mão de Obra
        APPEND ls_timetickets TO lt_timetickets.

* Verifica se houve alguma confirmação para a Ordem/Operação na mesma Data/Hora
*        SELECT SINGLE *
*          FROM afru
*          INTO @DATA(ls_afru)
*          WHERE rueck = @ls_timetickets-conf_no
*            AND isdd = @ls_timetickets-exec_start_date
*            AND isdz = @ls_timetickets-exec_start_time
*            AND iedd = @ls_timetickets-exec_fin_date
*            AND iedz = @ls_timetickets-exec_fin_time.

        DATA ls_afru    TYPE afru.
        CLEAR ls_afru.
        SELECT SINGLE *
                      FROM afru
                      INTO ls_afru
          WHERE rueck = ls_timetickets-conf_no
            AND isdd  = ls_timetickets-exec_start_date
            AND isdz  = ls_timetickets-exec_start_time
            AND iedd  = ls_timetickets-exec_fin_date
            AND iedz  = ls_timetickets-exec_fin_time.

        IF sy-subrc EQ 0.
          CLEAR ls_detail_return_aux.
          ls_detail_return_aux-type = 'E'.
          ls_detail_return_aux-message = 'Confirmação já realizada para Data/Hora Início/Fim'(002).
          APPEND ls_detail_return_aux TO lt_detail_return.
*          DATA(lv_erro_data) = 'X'.
          DATA lv_erro_data TYPE c.
          lv_erro_data  = 'X'.
        ENDIF.

        IF lv_erro_conf_max IS INITIAL.
          IF lv_erro_data IS INITIAL.

            WAIT UP TO 1 SECONDS.
* Confirma Mão de Obra
            CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
              TABLES
                timetickets   = lt_timetickets
                detail_return = lt_detail_return.

*            READ TABLE lt_detail_return INTO DATA(ls_detail_return) WITH KEY type = 'E'.
            DATA ls_detail_return LIKE LINE OF lt_detail_return.
            READ TABLE lt_detail_return INTO ls_detail_return WITH KEY type = 'E'.

            IF sy-subrc NE 0.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = 'X'.

* Busca CONF_CNT
              LOOP AT lt_detail_return INTO ls_detail_return WHERE conf_cnt IS NOT INITIAL.
                EXIT.
              ENDLOOP.

* Composição do HEADER do texto
              CLEAR ls_header.
              ls_header-tdname   = sy-mandt && ls_confirmacao-conf_no && ls_detail_return-conf_cnt.
              ls_header-tdobject = 'AUFK'.
              ls_header-tdid     = 'RMEL'.
              ls_header-tdspras  = sy-langu.

* Carrega tabela com texto Longo
*            IF ls_confirmacao-conf_text IS NOT INITIAL.
              CLEAR ls_textlines.
              ls_textlines-tdformat = '*'.
              ls_textlines-tdline   = ls_confirmacao-conf_text.
              APPEND ls_textlines TO lt_textlines.
*            ENDIF.

*            SPLIT ls_confirmacao-texto_longo AT '<p>' INTO TABLE lt_texto_longo.
*            LOOP AT lt_texto_longo INTO DATA(ls_texto).
*              CLEAR ls_textlines.
*              ls_textlines-tdformat = '*'.
*              ls_textlines-tdline   = ls_texto.
*              APPEND ls_textlines TO lt_textlines.
*            ENDLOOP.

              lt_textlines_aux[] = lt_textlines[].

* Monta Texto Longo
              CALL FUNCTION '/PTLOMS/MF054'
                EXPORTING
                  im_texto_longo = ls_confirmacao-texto_longo
                TABLES
                  it_texto       = lt_textlines_aux.

              lt_textlines[] = lt_textlines_aux[].

*      LOOP AT it_texto INTO DATA(ls_texto).
*        CLEAR ls_textlines.
*        ls_textlines-tdformat = ls_texto-tdformat.
*        ls_textlines-tdline   = ls_texto-tdline.
*        APPEND ls_textlines TO lt_textlines.
*      ENDLOOP.

              CALL FUNCTION 'SAVE_TEXT'
                EXPORTING
                  client          = sy-mandt
                  header          = ls_header
                  savemode_direct = 'X'
                TABLES
                  lines           = lt_textlines
                EXCEPTIONS
                  id              = 1
                  language        = 2
                  name            = 3
                  object          = 4
                  OTHERS          = 5.

              CALL FUNCTION 'COMMIT_TEXT'.

* Busca ordem referente à confirmação
*              READ TABLE lt_detail_return INTO DATA(ls_detail_return_ordem) WITH KEY type = 'I'
              DATA ls_detail_return_ordem LIKE LINE OF lt_detail_return.
              READ TABLE lt_detail_return INTO ls_detail_return_ordem       WITH KEY type = 'I'
                                                                                     message_id = 'RU'
                                                                                     message_number = 100.
              IF sy-subrc EQ 0.
*                lv_aufnr = |{ ls_detail_return_ordem-message_v1 ALPHA = IN }|.

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = ls_detail_return_ordem-message_v1
                  IMPORTING
                    output = lv_aufnr.

* Atualizar Data Fim Avaria
                CALL FUNCTION '/PTLOMS/MF053'
                  EXPORTING
                    im_aufnr       = lv_aufnr
                    im_endmlfndate = ls_timetickets-exec_fin_date
                    im_endmlfntime = ls_timetickets-exec_fin_time
                  TABLES
                    it_return      = lt_return_fim_avaria.

* Encerrar Ordem Tecnicamente (Caso tenha Status I0009 [Confirmado] )
                IF 1 = 2.
                  CALL FUNCTION '/PTLOMS/MF006'
                    EXPORTING
                      im_aufnr          = lv_aufnr
                      im_usuario_mobile = lv_usuario "ls_im_confirmacao-usuario_app
                      im_date           = ls_timetickets-exec_fin_date
                      im_time           = ls_timetickets-exec_fin_time
                    IMPORTING
                      ex_ente           = lv_ente
                    TABLES
                      it_return         = lt_return_conf.
                ENDIF.

                CALL FUNCTION '/PTLOMS/MF052'
                  EXPORTING
                    im_aufnr          = lv_aufnr
                    im_usuario_mobile = lv_usuario "ls_im_confirmacao-usuario_app
                    im_date           = ls_timetickets-exec_fin_date
                    im_time           = ls_timetickets-exec_fin_time
                  IMPORTING
                    ex_ente           = lv_ente
                  TABLES
                    it_return         = lt_return_conf.

* Atualiza status da operação
                CALL FUNCTION '/PTLOMS/MF007'
                  EXPORTING
                    im_aufnr            = lv_aufnr
                    im_vornr            = ls_confirmacao-activity
                    im_suboper          = ls_confirmacao-sub_activity
                    im_usuario_mobile   = lv_usuario "ls_confirmacao-usuario_app "ls_confirmacao-usuario_mobile
                    im_date_ini         = sy-datum "ls_timetickets-exec_start_date
                    im_time_ini         = sy-uzeit "ls_timetickets-exec_start_time
                    im_date_fim         = sy-datum "ls_timetickets-exec_fin_date
                    im_time_fim         = sy-uzeit "ls_timetickets-exec_fin_time
                    im_dev_reason       = ls_confirmacao-dev_reason
                    im_fin_conf         = ls_confirmacao-fin_conf
                    im_despacho_anulado = space
                    im_status_mobile    = ls_confirmacao-status_mobile
                    im_enc_tec          = lv_ente
                  TABLES
                    it_return           = lt_return_status_oper.

                IF lv_fin_conf EQ 'X'.

                  UPDATE /ptloms/tb031
                  SET conf_final = 'X'
                          status = 6
                  WHERE aufnr = lv_aufnr
                  AND vornr = ls_im_confirmacao-activity
                  AND usuario = lv_usuario.

                  COMMIT WORK AND WAIT.

                  UPDATE /ptloms/tb026
                      SET desassociado         = 'X'
                          motivo_desassociacao = 6
                          data_desassociacao   = sy-datum
                          hora_desassociacao   = sy-uzeit
                      WHERE aufnr = lv_aufnr
                      AND vornr = ls_im_confirmacao-activity
                      AND usuario = lv_usuario.

                  COMMIT WORK AND WAIT.

                ENDIF.

*Limpa numero da matricula da operação quando há recusa.
                IF ls_confirmacao-status_mobile EQ '5'.
                  CALL FUNCTION '/PTLOMS/MF056'
                    EXPORTING
                      aufnr   = lv_aufnr
                      vornr   = ls_confirmacao-activity
                      suboper = ls_confirmacao-sub_activity
                      usuario = lv_usuario. "ls_confirmacao-usuario_app.
                ENDIF.

              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*      ENDIF.
    ENDIF.

    lv_subobject = '/PTLOMS/CONF'.
    lv_extnumber = ls_confirmacao-conf_no.
    lv_user      = lv_usuario. "ls_confirmacao-usuario_app.

* Instancia objeto de Log por Confirmação
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

    LOOP AT lt_detail_return INTO ls_detail_return.
      lv_type = ls_detail_return-type.
      CONCATENATE ls_detail_return-message 'Usuário SAP: '(015) sy-uname INTO lv_msg SEPARATED BY space.
***   lv_msg = ls_detail_return-message && |Usuário SAP: | && sy-uname.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

*    LOOP AT lt_return_conf INTO DATA(ls_return_conf).
    DATA ls_return_conf LIKE LINE OF lt_return_conf.
    LOOP AT lt_return_conf INTO ls_return_conf.
      lv_type = ls_return_conf-type.
      lv_msg = ls_return_conf-message.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

*    LOOP AT lt_return_status_oper INTO DATA(ls_return_status_oper).
    DATA ls_return_status_oper LIKE LINE OF lt_return_status_oper.
    LOOP AT lt_return_status_oper INTO ls_return_status_oper.
      lv_type = ls_return_status_oper-type.
      lv_msg = ls_return_status_oper-message.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

    LOOP AT lt_detail_return INTO ls_detail_return.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_detail_return TO ls_return_aux.
      ls_return_aux-message_v3 = lv_aufnr.
      ls_return_aux-message_v4 = ls_confirmacao-activity.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO rt_return."lt_return_aux.
    ENDLOOP.

    LOOP AT lt_return_conf INTO ls_return_conf.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return_conf TO ls_return_aux.
      ls_return_aux-message_id = ls_return_conf-id.
      ls_return_aux-message_number = ls_return_conf-number.
      ls_return_aux-log_number = ls_return_conf-log_no.
      ls_return_aux-message_v3 = lv_aufnr.
      ls_return_aux-message_v4 = ls_confirmacao-activity.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO rt_return."lt_return_aux.
    ENDLOOP.

    LOOP AT lt_return_status_oper INTO ls_return_status_oper.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return_status_oper TO ls_return_aux.
      ls_return_aux-message_id = ls_return_conf-id.
      ls_return_aux-message_number = ls_return_conf-number.
      ls_return_aux-log_number = ls_return_conf-log_no.
      ls_return_aux-message_v3 = lv_aufnr.
      ls_return_aux-message_v4 = ls_confirmacao-activity.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO rt_return."lt_return_aux.
    ENDLOOP.

*    ls_return-it_return = lt_return_aux.

*    APPEND ls_return TO rt_return.
*    ENDLOOP.

  ENDMETHOD.


  METHOD in_documento_medicao.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Bretz
*********************************************************************************************************

*   Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

*   Declaração de estrutura
    DATA: ls_return        LIKE LINE OF rt_return,
          ls_bapiret2      TYPE bapiret2,
          ls_ponto_medicao TYPE /ptloms/et050,
          ls_return_aux    TYPE bapiret2,
          ls_imrg_ref      TYPE imrg.

*   Declarações para retorno da BAPI
    DATA: lv_mdocnum TYPE imrg-mdocm,
          lv_nota    TYPE qmel-qmnum,
          lv_iind    TYPE iref-iind,
          ls_imrg    TYPE imrg,
          lv_msgno   TYPE t100-msgnr,
          lv_point   TYPE imptt-point,
          lv_user    TYPE sy-uname.

*   Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_data_hora TYPE bapi_msg.

*   Se parâmetros vazios, então retorna.
    IF im_ponto_medicao IS INITIAL.
      RETURN.
    ENDIF.

    MOVE-CORRESPONDING im_ponto_medicao TO ls_ponto_medicao.

*   Limpa variáveis
    CLEAR: ls_return, lv_mdocnum, ls_imrg, lv_nota, lv_iind.

    REPLACE '.' IN ls_ponto_medicao-recorded_value WITH ','.

*   Valida Última Data/Hora e Último Valor Medido - Início
*** lv_point = |{ ls_ponto_medicao-measurement_point ALPHA = IN }|.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_ponto_medicao-measurement_point
      IMPORTING
        output = lv_point.

    DATA: lt_imrg_aux TYPE imrg.

    SELECT * FROM imrg
       INTO lt_imrg_aux
       UP TO 1 ROWS
       WHERE point =  lv_point    AND
             cancl =  space       AND
             mdocm <> space.
    ENDSELECT.

***    SELECT * FROM imrg
***       INTO @DATA(lt_imrg_aux)
***       UP TO 1 ROWS
***       WHERE point =  @lv_point    AND
***             cancl =  @space       AND
***             mdocm <> @space.
***    ENDSELECT.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'MEASUREM_DOCUM_READ_LAST'
        EXPORTING
          point            = lv_point
          offset_date      = '99991231'
          offset_time      = '235959'
          offset_inclusive = 'X'
        IMPORTING
          imrg_wa          = ls_imrg_ref
        EXCEPTIONS
          imrg_not_found   = 1
          imptt_not_found  = 2
          OTHERS           = 3.

      IF sy-subrc EQ 0.

        DATA: lv_erro_data TYPE c.

        IF ls_ponto_medicao-reading_date < ls_imrg_ref-idate.
***     DATA(lv_erro_data) = 'X'.
          lv_erro_data = 'X'.

        ELSEIF ls_ponto_medicao-reading_date = ls_imrg_ref-idate.
          IF ls_ponto_medicao-reading_time < ls_imrg_ref-itime.
            lv_erro_data = 'X'.
          ENDIF.
          IF lv_erro_data = 'X'.

***         DATA(lv_erro_cricao_doc_med) = 'X'.
            DATA: lv_erro_cricao_doc_med TYPE c.
            lv_erro_cricao_doc_med = 'X'.

            ls_return_aux-type = 'E'.

            CLEAR lv_data_hora.
            CONCATENATE ls_imrg_ref-idate+6(2) '.' ls_imrg_ref-idate+4(2) '.' ls_imrg_ref-idate(2)
                        ls_imrg_ref-itime(2)   ':' ls_imrg_ref-itime+2(2) ':' ls_imrg_ref-itime+4(2)
                        INTO lv_data_hora.

            CONCATENATE 'Documento de Medição com data anterior ao último Documento de Medição não permitido.'(007)
                        'Favor considerar'(006) lv_data_hora
                        'Equip.:'(008)          ls_ponto_medicao-equnr
                        'Pt.Med.'(009)          ls_ponto_medicao-measurement_point
                        'Data/Hora:'(010)       ls_ponto_medicao-data_hora_inicio
                         INTO ls_return_aux-message SEPARATED BY space.

***            ls_return_aux-message = | Documento de Medição com data anterior ao último Documento de Medição não permitido. | &&
***                                    | Favor considerar | &&
***                                    ls_imrg_ref-idate+6(2) && |.| && ls_imrg_ref-idate+4(2) && |.| && ls_imrg_ref-idate(2) &&
***                                    ls_imrg_ref-itime(2) && |:| && ls_imrg_ref-itime+2(2) && |:| && ls_imrg_ref-itime+4(2) &&
***                                    | Equip.: | && ls_ponto_medicao-equnr &&
***                                    | Pt.Med.: | && ls_ponto_medicao-measurement_point &&
***                                    | Data/Hora: | && ls_ponto_medicao-data_hora_inicio.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


    "Formatar número negativo
    DATA: lv_value TYPE string,
          lv_corrected_value TYPE string.


  IF ls_ponto_medicao-recorded_value CP '*-'.

    lv_value = ls_ponto_medicao-recorded_value.

    SHIFT lv_value RIGHT DELETING TRAILING '-'.

    lv_corrected_value = '-' && lv_value.

    CONDENSE lv_corrected_value.

    ls_ponto_medicao-recorded_value = lv_corrected_value.

    "ls_ponto_medicao-valor_medido = lv_corrected_value.

  ENDIF.


**** Valida Última Data/Hora e Último Valor Medido - Fim
    IF lv_erro_cricao_doc_med IS INITIAL.

*     Função que cria documento de medição
      CALL FUNCTION 'MEASUREM_DOCUM_RFC_SINGLE_001'
        EXPORTING
          measurement_point     = ls_ponto_medicao-measurement_point
          reading_date          = ls_ponto_medicao-reading_date
          reading_time          = ls_ponto_medicao-reading_time
          short_text            = ls_ponto_medicao-short_text
          reader                = ls_ponto_medicao-reader
          origin_indicator      = ls_ponto_medicao-origin_indicator
          recorded_value        = ls_ponto_medicao-recorded_value
          code_catalogue        = ls_ponto_medicao-code_catalogue
          code_group            = ls_ponto_medicao-code_group
          valuation_code        = ls_ponto_medicao-valuation_code
          prepare_update        = 'X'
          commit_work           = 'X'
          wait_after_commit     = 'X'
        IMPORTING
          measurement_document  = lv_mdocnum
          complete_document     = ls_imrg
          notification          = lv_nota
          custom_duprec_occured = lv_iind
        EXCEPTIONS
          no_authority          = 1
          point_not_found       = 2
          index_not_unique      = 3
          type_not_found        = 4
          point_locked          = 5
          point_inactive        = 6
          timestamp_in_future   = 7
          timestamp_duprec      = 8
          unit_unfit            = 9
          value_not_fltp        = 10
          value_overflow        = 11
          value_unfit           = 12
          value_missing         = 13
          code_not_found        = 14
          notif_type_not_found  = 15
          notif_prio_not_found  = 16
          notif_gener_problem   = 17
          update_failed         = 18
          OTHERS                = 19.

      IF sy-subrc <> 0.
        lv_erro_cricao_doc_med = 'X'.
        lv_msgno = sy-msgno.
        CALL FUNCTION 'MESSAGE_PREPARE'
          EXPORTING
            language               = sy-langu
            msg_id                 = sy-msgid
            msg_no                 = lv_msgno
            msg_var1               = sy-msgv1
            msg_var2               = sy-msgv2
            msg_var3               = sy-msgv3
            msg_var4               = sy-msgv4
          IMPORTING
            msg_text               = ls_return_aux-message
          EXCEPTIONS
            function_not_completed = 1
            message_not_found      = 2
            OTHERS                 = 3.

        CONCATENATE ls_return_aux-message
                    'Equip.:'(008)    ls_ponto_medicao-equnr
                    'Pt.Med.:'(022)   ls_ponto_medicao-measurement_point
                    'Data/Hora:'(010) ls_ponto_medicao-data_hora_inicio
                    INTO ls_return_aux-message SEPARATED BY space.

      ENDIF.
    ENDIF.

    lv_subobject = '/PTLOMS/MDOCM'.
    lv_extnumber = ls_ponto_medicao-measurement_point.
    lv_user      = ls_ponto_medicao-usuario_app.

*   Instancia objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

    IF lv_erro_cricao_doc_med = 'X'.

      ls_return_aux-type       = sy-msgty.
      ls_return_aux-id         = sy-msgid.
      ls_return_aux-number     = sy-msgno.
      ls_return_aux-message_v1 = sy-msgv1.
      ls_return_aux-message_v2 = sy-msgv2.
      ls_return_aux-message_v3 = sy-msgv3.
      ls_return_aux-message_v4 = sy-msgv4.

      MOVE-CORRESPONDING ls_return_aux TO ls_return.
      CASE ls_return-type.
        WHEN 'E'.
          ls_return-type_desc = 'Error'.
        WHEN 'W'.
          ls_return-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return-type_desc = 'Success'.
        WHEN 'I'.
          ls_return-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return TO rt_return.

      lv_type = ls_return_aux-type.
      lv_msg  = ls_return_aux-message.
      ex_ponto_medicao-status = 'Erro'(035).

    ELSE.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_mdocnum
        IMPORTING
          output = lv_mdocnum.

      ex_ponto_medicao-status = 'Criado'(036).
      lv_type = 'S'.
      CONCATENATE 'Documento de Medição'(023)    lv_mdocnum
                  'criada pelo usuário SAP'(004) sy-uname
                   INTO lv_msg SEPARATED BY space.

      ls_return-type      = 'S'.
      ls_return-message   = lv_msg.
      ls_return-type_desc = 'Success'.
      APPEND ls_return TO rt_return.

    ENDIF.

    o_log->add( EXPORTING i_type = lv_type
                          i_text = lv_msg ).
  ENDMETHOD.


  METHOD in_finalizar_sessao.

* Declaração de objeto
    DATA: o_sessao TYPE REF TO /ptloms/cl005.

* Declaração de estrutura
    DATA: ls_return LIKE LINE OF et_return.

* Declaração de variável
    DATA: lv_sessao_finalizada TYPE char1.

* Verifica se parâmetro de entrada foi preenchido
    IF im_usuario IS INITIAL.
      RETURN.
    ENDIF.

* Instacia objeto
    CREATE OBJECT o_sessao.

* Finzaliza sessão
    o_sessao->finaliza_sessao( EXPORTING im_usuario           = im_usuario
                               IMPORTING ex_sessao_finalizada = lv_sessao_finalizada ).

* Verifica se sessão foi finalizada
    IF lv_sessao_finalizada IS INITIAL.
      ls_return-id = 'E'.
      ls_return-message = 'Erro ao finalizar sessão'(020).
***   ls_return-message = 'Erro ao finalizar sessão'.
    ELSE.
      ls_return-id = 'S'.
      ls_return-message = 'Sessão finalizada com sucesso'(021).
***   ls_return-message = 'Sessão finalizada com sucesso'.
    ENDIF.

* Atualiza tabela de retorno
    APPEND ls_return TO et_return.

  ENDMETHOD.


  METHOD in_layout.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de Tabela Interna
    DATA: lt_tb047 TYPE TABLE OF /ptloms/tb047.

* Declaração de Estrutura
    DATA: ls_tb046 TYPE /ptloms/tb046,
          ls_tb047 TYPE /ptloms/tb047.

* Declaração de variáveis
    DATA: lv_guid_16 TYPE  guid_16,
          lv_guid_22 TYPE  guid_22,
          lv_guid_32 TYPE  guid_32.

    IF im_layout IS NOT INITIAL.
      MOVE-CORRESPONDING im_layout TO ls_tb046.

* Criação
      IF im_layout-id IS INITIAL.

        cl_reca_guid=>guid_create( IMPORTING ed_guid_16 = lv_guid_16
                                             ed_guid_22 = lv_guid_22
                                             ed_guid_32 = lv_guid_32 ).

        ls_tb046-id              = lv_guid_32.
        ls_tb046-data_criacao    = sy-datum.
        ls_tb046-hora_criacao    = sy-uzeit.
        ls_tb046-usuario_criacao = sy-uname.
      ELSE.

        SELECT SINGLE *
          FROM /ptloms/tb046
          INTO ls_tb046
          WHERE tabela EQ im_layout-tabela
            AND id     EQ im_layout-id.
        IF sy-subrc EQ 0.
* Modificação
          ls_tb046-data_alteracao    = sy-datum.
          ls_tb046-hora_alteracao    = sy-uzeit.
          ls_tb046-usuario_alteracao = sy-uname.
        ELSE.
          ls_tb046-id              = lv_guid_32.
          ls_tb046-data_criacao    = sy-datum.
          ls_tb046-hora_criacao    = sy-uzeit.
          ls_tb046-usuario_criacao = sy-uname.
        ENDIF.

      ENDIF.

      MODIFY /ptloms/tb046 FROM ls_tb046.
      DATA: lv_commit TYPE flag.
      lv_commit = 'X'.
    ENDIF.

*    LOOP AT it_layout_values INTO DATA(ls_layout_values).
    DATA: ls_layout_values LIKE LINE OF it_layout_values.
    LOOP AT it_layout_values INTO ls_layout_values.
      CLEAR ls_tb047.
      MOVE-CORRESPONDING ls_layout_values TO ls_tb047.
      IF ls_tb047-id_layout IS INITIAL.
        ls_tb047-id_layout = lv_guid_32.
      ENDIF.
      APPEND ls_tb047 TO lt_tb047.
    ENDLOOP.
    IF lt_tb047[] IS NOT INITIAL.
      MODIFY /ptloms/tb047 FROM TABLE lt_tb047.
      lv_commit = 'X'.
    ENDIF.

    IF lv_commit = 'X'.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD in_nota.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declaração de tabela
    DATA: lt_return  TYPE STANDARD TABLE OF bapiret2,
          lt_retorno TYPE /ptloms/ct063.

* Declaração de estrutura
    DATA: ls_return_par LIKE LINE OF et_return.

* Declaração de variável
    DATA: lv_notif_no TYPE qmnum,
          lv_erro     TYPE char1,
          lv_objkey   TYPE swo_typeid,
          lv_user     TYPE sy-uname.

* Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty.

    DATA: lv_nota type /ptloms/et043.

* Verifica se critério de seleção foi preenchido
    IF im_nota IS INITIAL.
      RETURN.
    ENDIF.

    lv_nota = im_nota.

*   Conversão local de instalação
    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = lv_nota-funct_loc
      IMPORTING
        output = lv_nota-funct_loc
      EXCEPTIONS
*       not_found = 1
*       OTHERS = 2.
        OTHERS = 0.

* Chama função para criação de Nota
    CALL FUNCTION '/PTLOMS/MF001'
      EXPORTING
        im_nota           = lv_nota
        it_texto          = it_texto
        it_item           = it_item
        it_item_causa     = it_item_causa
        it_item_medidas   = it_item_medidas
        it_item_atividade = it_item_atividade
        it_item_tarefa    = it_item_tarefa
      IMPORTING
        ex_notif_no       = lv_notif_no
      TABLES
        it_return         = lt_return.

    lv_subobject = '/PTLOMS/NOTA'.
    lv_extnumber = lv_notif_no.
    lv_user      = im_nota-usuario_app.

* Anexar arquivos
    IF lv_notif_no IS NOT INITIAL AND it_anexo[] IS NOT INITIAL.

*      lv_notif_no = |{ lv_notif_no ALPHA = IN }|.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_notif_no
        IMPORTING
          output = lv_notif_no.

      lv_objkey   = lv_notif_no.
      me->in_anexar_imagem( EXPORTING im_objkey  = lv_objkey
                                      im_objtyp  = 'BUS2038'
                                      im_user    = lv_user
                                      it_anexo   = it_anexo
                            IMPORTING et_return  = lt_retorno ).
    ENDIF.

* Instancia objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

* Grava mensagens de retorno no log da SLG1
    IF lt_return[] IS INITIAL AND lv_notif_no IS NOT INITIAL.
      lv_type = 'S'.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_notif_no
        IMPORTING
          output = lv_notif_no.

      CONCATENATE 'Nota'(003) lv_notif_no 'criada pelo usuário SAP'(004) sy-uname INTO lv_msg SEPARATED BY space.
***   lv_msg = |Nota | && lv_notif_no && | criada pelo usuário SAP | && sy-uname.

      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ELSEIF lt_return[] IS INITIAL AND lv_notif_no IS INITIAL.
      lv_type = 'E'.
      lv_msg = 'Erro ao criar nota'(005).
***   lv_msg = |Erro ao criar nota|.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ELSE.
*      LOOP AT lt_return INTO DATA(ls_return).
      DATA ls_return    LIKE LINE OF lt_return.
      LOOP AT lt_return INTO ls_return.
        lv_type = ls_return-type.
        lv_msg = ls_return-message.
        o_log->add( EXPORTING i_type = lv_type
                              i_text = lv_msg ).
      ENDLOOP.
    ENDIF.

* Dados de retorno
    ex_notf_no  = lv_notif_no.

    IF ex_notf_no IS NOT INITIAL AND lt_return[] IS INITIAL.
      ls_return_par-type = 'S'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_notif_no
        IMPORTING
          output = lv_notif_no.

      CONCATENATE 'Nota'(003) lv_notif_no 'criada pelo usuário SAP'(004) sy-uname INTO lv_msg SEPARATED BY space.
      ls_return_par-message = lv_msg.
      ls_return_par-type_desc = 'Success'.
      APPEND ls_return_par TO et_return.
    ELSEIF ex_notf_no IS INITIAL AND lt_return[] IS INITIAL.
      ls_return_par-type = 'E'.
      lv_msg = 'Erro ao criar nota'(005).
      ls_return_par-message = lv_msg.
      ls_return_par-type_desc = 'Error'.
      APPEND ls_return_par TO et_return.
    ELSE.
*      LOOP AT lt_return INTO DATA(ls_return_aux).
      DATA ls_return_aux LIKE LINE OF lt_return.
      LOOP AT lt_return INTO ls_return_aux.
        CLEAR ls_return_par.
        MOVE-CORRESPONDING ls_return_aux TO ls_return_par.
        CASE ls_return_par-type.
          WHEN 'E'.
            ls_return_par-type_desc = 'Error'.
          WHEN 'W'.
            ls_return_par-type_desc = 'Warning'.
          WHEN 'S'.
            ls_return_par-type_desc = 'Success'.
          WHEN 'I'.
            ls_return_par-type_desc = 'Information'.
          WHEN OTHERS.
            ls_return_par-type_desc = 'Success'.
        ENDCASE.
        APPEND ls_return_par TO et_return.
      ENDLOOP.
    ENDIF.

* Inclui mensagens do anexo de arquivo
*    LOOP AT lt_retorno INTO DATA(ls_retorno).
    DATA ls_retorno LIKE LINE OF lt_retorno.
    LOOP AT lt_retorno INTO ls_retorno.
      CLEAR ls_return_par.
      MOVE-CORRESPONDING ls_retorno TO ls_return_par.
      CASE ls_return_par-type.
        WHEN 'E'.
          ls_return_par-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_par-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_par-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_par-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_par-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_par TO et_return.
    ENDLOOP.
*    et_return[] = lt_return[].

  ENDMETHOD.


  METHOD in_operacao_ordem.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declaração de tabela interna
    DATA: lt_return             TYPE STANDARD TABLE OF bapiret2,
          lt_return_assoc_mat   TYPE STANDARD TABLE OF bapiret2,
          lt_return_status_oper TYPE STANDARD TABLE OF bapiret2,
          lt_tb026              TYPE STANDARD TABLE OF /ptloms/tb026,
          lt_tb033              TYPE STANDARD TABLE OF /ptloms/tb033.

    DATA: lt_operacoes TYPE /ptloms/ct058,
          lt_lista     TYPE /ptloms/ct123.

* Declaração de estrutura
    DATA: ls_return_aux  TYPE /ptloms/et063,
          ls_return_aux2 TYPE bapiret2,
          ls_026         TYPE /ptloms/tb026,
          ls_033         TYPE /ptloms/tb033.

    DATA: ls_operacoes TYPE /ptloms/et058,
          ls_lista     TYPE /ptloms/et146,
          ls_retorno   TYPE /ptloms/et060.

* Declaração de variáveis para Log
    DATA: lv_aufnr     TYPE aufnr,
          lv_vornr     TYPE vornr,
          lv_suboper   TYPE uvorn,
          lv_data      TYPE datum,
          lv_hora      TYPE uzeit,
          lv_usuario   TYPE xubname,
          lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_user      TYPE sy-uname.

* Atribuir número da ordem
*    lv_aufnr = |{ im_operacao-orderid ALPHA = IN }|.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_operacao-orderid
      IMPORTING
        output = lv_aufnr.

    wa_operacao = im_operacao.

* Verifica se Ordem foi despachada Totalmente
*    SELECT SINGLE aufnr, usuario
*      FROM /ptloms/tb026
*      INTO @DATA(ls_026_aux)
*      WHERE aufnr        = @lv_aufnr
*        AND vornr        = @space
*        AND desassociado = @space.
    TYPES: BEGIN OF ty_tb026,
             aufnr   TYPE /ptloms/tb026-aufnr,
             usuario TYPE /ptloms/tb026-usuario,
           END OF ty_tb026.
    DATA ls_026_aux TYPE ty_tb026.
    SELECT SINGLE aufnr usuario
      FROM /ptloms/tb026
      INTO ls_026_aux
      WHERE aufnr        = lv_aufnr
        AND vornr        = space
        AND desassociado = space.

    SELECT SINGLE * FROM  /ptloms/tb033 INTO CORRESPONDING FIELDS OF ls_033.

    IF ls_033-cesto IS NOT INITIAL.
      CLEAR: wa_operacao-usuario, wa_operacao-sname.
    ENDIF.

* Se ordem já estiver despachado Completamente, não é possível criar operação
    IF ls_026_aux-aufnr IS INITIAL.

***      CLEAR: im_operacao-funct_loc_description, im_operacao-equipment, im_operacao-equipment_description.

* Cria operação da ordem
      CALL FUNCTION '/PTLOMS/MF003'
        EXPORTING
          im_operacao = im_operacao
        IMPORTING
          ex_vornr    = lv_vornr
        TABLES
          it_return   = lt_return.

      wa_operacao-activity = lv_vornr.

* Realiza despacho automático
      IF lv_vornr IS NOT INITIAL.

**        IF im_operacao-usuario IS NOT INITIAL.
**          lv_usuario = im_operacao-usuario.
**        ELSE.

        IF wa_operacao-usuario_app IS NOT INITIAL.
          lv_usuario = wa_operacao-usuario_app.
        ELSE.
          lv_usuario = sy-uname.
***            lv_usuario = sy-uname.
        ENDIF.
*            lv_usuario = /ptloms/cl006=>busca_usuario( lv_usuario ).

*        SELECT SINGLE usuario, perfil
*          FROM /ptloms/tb013
*          INTO @DATA(ls_tb013)
*          WHERE usuario EQ @lv_usuario.
        TYPES: BEGIN OF ty_tb013,
                 usuario TYPE /ptloms/tb013-usuario,
                 perfil  TYPE /ptloms/tb013-perfil,
               END OF ty_tb013.
        DATA ls_tb013 TYPE ty_tb013.
        SELECT SINGLE usuario perfil
          FROM /ptloms/tb013
          INTO ls_tb013
          WHERE usuario EQ lv_usuario.
        IF sy-subrc EQ 0.
*          SELECT SINGLE configuracao FROM /ptloms/tb044 INTO @DATA(lv_configuracao) WHERE perfil EQ @ls_tb013-perfil AND configuracao EQ '05'.
          DATA: lv_configuracao TYPE /ptloms/tb044-configuracao.
          SELECT SINGLE configuracao FROM /ptloms/tb044 INTO lv_configuracao WHERE perfil EQ ls_tb013-perfil AND configuracao EQ '04'.
          IF sy-subrc NE 0.
            SELECT SINGLE configuracao FROM /ptloms/tb044 INTO lv_configuracao WHERE perfil EQ ls_tb013-perfil AND configuracao EQ '05'.
          ENDIF.
*          SELECT SINGLE configuracao FROM /ptloms/tb044 INTO lv_configuracao_04 WHERE perfil EQ ls_tb013-perfil AND configuracao EQ '04'.
*          SELECT SINGLE configuracao FROM /ptloms/tb044 INTO lv_configuracao_05 WHERE perfil EQ ls_tb013-perfil AND configuracao EQ '05'.
        ENDIF.

        IF lv_configuracao = '05' OR lv_configuracao = '04'.

          IF ls_033-cesto IS INITIAL.

            IF wa_operacao-usuario IS NOT INITIAL.
              lv_data = sy-datum.
              lv_hora = sy-uzeit.

**          Ajuste despacho.
              lv_usuario = im_operacao-usuario.


* Atualiza tabela de Despacho
              ls_026-aufnr           = lv_aufnr.
              CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
                EXPORTING
                  input  = lv_vornr
                IMPORTING
                  output = lv_vornr.
              ls_026-vornr           = lv_vornr.
              ls_026-usuario         = lv_usuario.
              ls_026-data_associacao = lv_data.
              ls_026-hora_associacao = lv_hora.
              ls_026-mobile          = 'X'.
              APPEND ls_026 TO lt_tb026.
              MODIFY /ptloms/tb026 FROM TABLE lt_tb026.

              IF sy-subrc EQ 0.
* Associa Matrícula à Operação
                CALL FUNCTION '/PTLOMS/MF036'
                  EXPORTING
                    im_aufnr   = lv_aufnr
                    im_vornr   = lv_vornr
                    im_usuario = lv_usuario
                  TABLES
                    it_return  = lt_return_assoc_mat.

                APPEND LINES OF lt_return_assoc_mat TO lt_return.

* Atualiza status da operação
                CALL FUNCTION '/PTLOMS/MF007'
                  EXPORTING
                    im_aufnr            = lv_aufnr
                    im_vornr            = lv_vornr
                    im_suboper          = lv_suboper
                    im_usuario_mobile   = lv_usuario
                    im_date_ini         = lv_data
                    im_time_ini         = lv_hora
                    im_date_fim         = lv_data
                    im_time_fim         = lv_hora
                    im_dev_reason       = space
                    im_fin_conf         = space
                    im_despacho_anulado = space
                    im_associar         = abap_true
                  TABLES
                    it_return           = lt_return_status_oper.

                APPEND LINES OF lt_return_status_oper TO lt_return.

              ENDIF.

            ENDIF.

          ELSE.

**          Ajuste despacho (Rotina Cesto)
            MOVE-CORRESPONDING im_operacao TO ls_operacoes.
            ls_operacoes-aufnr = im_operacao-orderid.
            ls_operacoes-vornr = lv_vornr.
            APPEND ls_operacoes TO lt_operacoes.

*             Despacho automático
            CALL FUNCTION '/PTLOMS/MF134'
              EXPORTING
                i_operacoes = lt_operacoes
              IMPORTING
                e_lista     = lt_lista.

            LOOP AT lt_lista INTO ls_lista.

              LOOP AT ls_lista-retorno INTO ls_retorno.
                MOVE-CORRESPONDING ls_retorno TO ls_return_aux2.
                APPEND ls_return_aux2 TO lt_return.
                CLEAR ls_return_aux2.
              ENDLOOP.

            ENDLOOP.

            CLEAR: lt_operacoes,
                   ls_operacoes,
                   lt_lista,
                   ls_lista,
                   ls_retorno.

          ENDIF.
        ENDIF.
      ENDIF.

    ELSE.
      CLEAR ls_return_aux.
      ls_return_aux2-type = 'E'.
*      lv_aufnr = |{ lv_aufnr ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_aufnr
        IMPORTING
          output = lv_aufnr.

      CONCATENATE 'Ordem'(017) lv_aufnr 'já foi despachada completamente'(018) 'para o usuário'(019) ls_026_aux-usuario
                  INTO ls_return_aux2-message SEPARATED BY space.

      APPEND ls_return_aux2 TO lt_return.
    ENDIF.

    lv_subobject = '/PTLOMS/OPER_ORDEM'.
    lv_extnumber = im_operacao-objectkey.
    lv_user      = im_operacao-usuario_app.

* Instancia objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

    SORT lt_return BY type ASCENDING id ASCENDING number ASCENDING message ASCENDING message_v1 ASCENDING message_v2 ASCENDING message_v3 DESCENDING message_v4 DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_return COMPARING type id number message message_v1 message_v2.

* Grava mensagens de retorno
*   LOOP AT lt_return INTO DATA(ls_return).
    DATA ls_return LIKE LINE OF lt_return.
    LOOP AT lt_return INTO ls_return.
      lv_type = ls_return-type.
      lv_msg = ls_return-message.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.
*********************************************************************************************************
***  FIM - Nádia Rodrigues
*********************************************************************************************************

* Dados de retorno
    CLEAR ls_return.
    LOOP AT lt_return INTO ls_return.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return TO ls_return_aux.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO et_return.
    ENDLOOP.

  ENDMETHOD.


  METHOD in_ordem.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************
*   declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

*   Declaração de tabela
    DATA: lt_return           TYPE STANDARD TABLE OF bapiret2,
          lt_return_despacho  TYPE STANDARD TABLE OF bapiret2,
          lt_return_lib_ordem TYPE STANDARD TABLE OF bapiret2,
          lt_retorno          TYPE /ptloms/ct063.

*  Declaração de estrutura
    DATA: ls_return_aux TYPE /ptloms/et063.

*   Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_aufnr     TYPE aufnr,
          lv_objkey    TYPE swo_typeid,
          lv_erro      TYPE char1,
          lv_text1     TYPE string,
          lv_text2     TYPE string,
          lv_user      TYPE sy-uname.

    DATA: lv_ordem TYPE /ptloms/et057.

*   Verifica se critério de seleção foi preenchido
    IF im_ordem IS INITIAL.
      RETURN.
    ENDIF.

    lv_ordem = im_ordem.

*   Conversão local de instalação
    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = lv_ordem-funct_loc
      IMPORTING
        output = lv_ordem-funct_loc
      EXCEPTIONS
*       not_found = 1
*       OTHERS = 2.
        OTHERS = 0.

*   Chama função para criação de Ordem
*** DATA(lt_operacao) = it_operacao.
    DATA: lt_operacao LIKE it_operacao.
    lt_operacao = it_operacao.

    CALL FUNCTION '/PTLOMS/MF002'
      EXPORTING
        im_ordem       = lv_ordem
        im_nocommit    = im_nocommit
*       it_operacao    = it_operacao
        im_nota        = im_nota
        it_texto_ordem = it_texto_ordem
      TABLES
        it_return      = lt_return
      CHANGING
        it_operacao    = lt_operacao.

    et_operacao = lt_operacao.

    lv_subobject = '/PTLOMS/ORDEM'.

*   Busca número da ordem criada
*** READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'S'
***                                                    id   = 'IWO_BAPI2'
***                                                  number = 126.

    DATA: ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return WITH KEY type = 'S'
                                                 id   = 'IWO_BAPI2'
                                               number = 126.


    IF sy-subrc EQ 0.
      ex_aufnr     = ls_return-message_v2.
      lv_extnumber = ls_return-message_v2.

    ELSE.

      READ TABLE lt_return INTO ls_return WITH KEY type = 'S'
                                                   id   = 'IWO_BAPI2'
                                                 number = 112.

      IF sy-subrc EQ 0.
        ex_aufnr     = ls_return-message_v2.
        lv_extnumber = ls_return-message_v2.
      ENDIF.
    ENDIF.

    lv_user = im_ordem-usuario_app.

    IF im_nocommit IS INITIAL.

*     Realizar despacho automático para as operações criadas
      IF ex_aufnr IS NOT INITIAL AND lt_operacao[] IS NOT INITIAL.

        DATA: ls_tb013 TYPE /ptloms/tb013.

        SELECT SINGLE usuario perfil
          FROM /ptloms/tb013
          INTO CORRESPONDING FIELDS OF ls_tb013
          WHERE usuario EQ lv_user.

***        SELECT SINGLE usuario, perfil
***          FROM /ptloms/tb013
***          INTO @DATA(ls_tb013)
***          WHERE usuario EQ @lv_user.

        IF sy-subrc EQ 0.

          DATA: lv_configuracao TYPE /ptloms/tb044-configuracao.

          SELECT SINGLE configuracao
            FROM /ptloms/tb044
            INTO lv_configuracao
            WHERE perfil EQ ls_tb013-perfil
              AND configuracao EQ '04'.

***          SELECT SINGLE configuracao FROM /ptloms/tb044 INTO @DATA(lv_configuracao) WHERE perfil EQ @ls_tb013-perfil AND configuracao EQ '04'.

        ENDIF.

**      Busca configuração do sistema
*       SELECT SINGLE despacho_ordem FROM /ptloms/tb033 INTO @DATA(lv_despacho_ordem).

*       IF lv_despacho_ordem = 'X'.
        IF lv_configuracao = '04'.
          DATA ls_operacao LIKE LINE OF lt_operacao.

          READ TABLE lt_operacao INTO ls_operacao INDEX 1.
          IF ls_operacao-usuario IS NOT INITIAL.

*         Despacho automático
              CALL FUNCTION '/PTLOMS/MF037'
                EXPORTING
                  im_aufnr    = ex_aufnr
                  it_operacao = lt_operacao
                TABLES
                  it_return   = lt_return_despacho.
          ENDIF.

*         Libera Ordem
          CALL FUNCTION '/PTLOMS/MF051'
            EXPORTING
              im_aufnr  = ex_aufnr
            TABLES
              it_return = lt_return_lib_ordem.
        ENDIF.
      ENDIF.

*     Anexar arquivos
      IF ex_aufnr IS NOT INITIAL AND it_anexo[] IS NOT INITIAL.

***     lv_aufnr   = |{ ex_aufnr ALPHA = IN }|.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ex_aufnr
          IMPORTING
            output = lv_aufnr.

        lv_objkey  = lv_aufnr.
        me->in_anexar_imagem( EXPORTING im_objkey  = lv_objkey
                                        im_objtyp  = 'BUS2007'
                                        im_user    = lv_user
                                        it_anexo   = it_anexo
                              IMPORTING et_return  = lt_retorno ).
      ENDIF.

    ENDIF.

    IF ( im_nocommit IS INITIAL ) OR
       ( im_nocommit IS NOT INITIAL AND ex_aufnr IS INITIAL ).

*     Instancia objeto de Log
      CREATE OBJECT o_log
        EXPORTING
          i_subobject = lv_subobject
          i_extnumber = lv_extnumber
          i_user      = lv_user.

*     Grava mensagens de retorno
      LOOP AT lt_return INTO ls_return.
        lv_type = ls_return-type.
        lv_msg = ls_return-message.
        o_log->add( EXPORTING i_type = lv_type
                              i_text = lv_msg ).
      ENDLOOP.

*    o_log->add_table( et_return ).

    ENDIF.

*   Dados de retorno
    LOOP AT lt_return INTO ls_return.

      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return TO ls_return_aux.

      IF ls_return_aux-type   = 'S'         AND
         ls_return_aux-id     = 'IWO_BAPI2' AND
         ls_return_aux-number = 126.
        CLEAR: lv_text1, lv_text2.
        SPLIT ls_return_aux-message AT '%00000000001' INTO lv_text1 lv_text2.
        ls_return_aux-message = lv_text1 && lv_text2.
      ENDIF.

      IF ls_return_aux-type   = 'S'         AND
         ls_return_aux-id     = 'IWO_BAPI2' AND
         ls_return_aux-number = 112.
        CLEAR: lv_text1, lv_text2.
        SPLIT ls_return_aux-message AT '%00000000001' INTO lv_text1 lv_text2.
        ls_return_aux-message = lv_text1 && lv_text2.
      ENDIF.

      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO et_return.
    ENDLOOP.

*   Inclui mensagens do anexo de arquivo
*   LOOP AT lt_retorno INTO DATA(ls_retorno).
    DATA: ls_retorno LIKE LINE OF lt_retorno.
    LOOP AT lt_retorno INTO ls_retorno.

      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_retorno TO ls_return_aux.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.
      APPEND ls_return_aux TO et_return.
    ENDLOOP.

  ENDMETHOD.


  METHOD in_ordem_catalogo.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declaração de estrutura
    DATA: ls_return           LIKE LINE OF et_return,
          ls_ordem_catalogo   TYPE /ptloms/et128,
          ls_return_aux       TYPE bapiret2,

* Declarações para retorno da BAPI
          lv_user             TYPE sy-uname,

* Declaração de variáveis para Log
          lv_subobject        TYPE balsubobj,
          lv_extnumber        TYPE balnrext,
          lv_msg              TYPE bapi_msg,
          lv_number           TYPE bapi2080_nothdre-notif_no,
          ls_notifheader_save TYPE bapi2080_nothdre,
          lt_return	          TYPE TABLE OF bapiret2,
          lt_notif_items_mi   TYPE TABLE OF bapi2080_notitemi,
          ls_notif_items_mi   TYPE bapi2080_notitemi,
          lt_notif_items_me   TYPE TABLE OF bapi2080_notiteme,
          lt_notifcaus_se     TYPE TABLE OF bapi2080_notcause,
          lt_notifcaus_si     TYPE TABLE OF bapi2080_notcausi,
          ls_notifcaus_si     TYPE bapi2080_notcausi,
          lt_notif_task       TYPE TABLE OF bapi2080_nottaski,
          ls_notif_task       TYPE bapi2080_nottaski,
          lv_togheter         TYPE qm00-qkz,
          ls_header_get       TYPE bapi2080_nothdre,
          ls_header_add       TYPE bapi2080_nothdre,
          ls_header_add_ri    TYPE bapi2080_nothdri,
          ls_usuario_nota     TYPE /ptloms/tb050.

    IF im_ordem_catalogo IS INITIAL.
      RETURN.
    ENDIF.

    MOVE-CORRESPONDING im_ordem_catalogo TO ls_ordem_catalogo.

*    lv_number = |{ ls_ordem_catalogo-notifno ALPHA = IN }|.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_ordem_catalogo-notifno
      IMPORTING
        output = lv_number.

    CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
      EXPORTING
        number             = lv_number
      IMPORTING
        notifheader_export = ls_header_get
      TABLES
        notitem            = lt_notif_items_me
        notifcaus          = lt_notifcaus_se
        return             = lt_return.

    " Leitura dos dados da tabela NOTITEM
*    LOOP AT lt_notif_items_me INTO DATA(ls_notif_item).
*    ENDLOOP.

*    DATA(item_key) = ls_notif_item-item_key.

    SORT lt_notif_items_me BY item_sort_no DESCENDING.

*    DATA(item_sort_no) = VALUE #( lt_notif_items_me[ 1 ]-item_sort_no OPTIONAL ).

    DATA:
      item_key      TYPE felfd,
      item_sort_no  TYPE qlfdpos,
      ls_notif_item LIKE LINE OF lt_notif_items_me.

    CLEAR:
      item_key,
      item_sort_no.

    READ TABLE lt_notif_items_me INTO ls_notif_item INDEX 1.
    IF  sy-subrc     EQ 0.
      item_key     = ls_notif_item-item_key.
      item_sort_no = ls_notif_item-item_sort_no.
    ENDIF.

    ADD 10 TO item_sort_no.

    CLEAR: ls_notif_item.

    SELECT SINGLE objnr
      FROM qmel
      INTO (ls_notif_items_mi-refobjectkey)
    WHERE qmnum = lv_number.

    IF ls_ordem_catalogo-sintomadanocode IS NOT INITIAL OR ls_ordem_catalogo-parteobjetocode IS NOT INITIAL OR ls_ordem_catalogo-causacodegroup IS NOT INITIAL.

      ADD 1 TO item_key.

      ls_notif_items_mi-item_key     = item_key.
      ls_notif_items_mi-item_sort_no = item_sort_no.

      IF ls_ordem_catalogo-sintomadanocode IS NOT INITIAL.

        ls_notif_items_mi-d_code       = ls_ordem_catalogo-sintomadanocode.
        ls_notif_items_mi-d_codegrp    = ls_ordem_catalogo-sintomadanocodegroup.
        ls_notif_items_mi-descript     = ls_ordem_catalogo-textoitem.

      ENDIF.

      IF ls_ordem_catalogo-parteobjetocode IS NOT INITIAL.

        ls_notif_items_mi-dl_code      = ls_ordem_catalogo-parteobjetocode.
        ls_notif_items_mi-dl_codegrp   = ls_ordem_catalogo-parteobjetocodegroup.

      ENDIF.

      APPEND ls_notif_items_mi TO lt_notif_items_mi.

      " Controle de usuários por Nota
      ls_usuario_nota-qmnum       = lv_number.
      ls_usuario_nota-item        = item_key.
      ls_usuario_nota-usuario_app = im_ordem_catalogo-usuario_app.
      ls_usuario_nota-erdat       = sy-datum.

      SELECT SINGLE aufnr FROM
        qmel INTO ls_usuario_nota-aufnr
        WHERE qmnum = lv_number.

    ENDIF.

    IF ls_ordem_catalogo-task_code IS NOT INITIAL OR ls_ordem_catalogo-task_codegrp IS NOT INITIAL OR ls_ordem_catalogo-task_text IS NOT INITIAL.

      ADD 1 TO item_key.

      ls_notif_task-task_key = item_key.
      ls_notif_task-task_sort_no = item_sort_no.

      IF ls_ordem_catalogo-task_code IS NOT INITIAL.

        ls_notif_task-task_code       = ls_ordem_catalogo-task_code.
        ls_notif_task-task_codegrp    = ls_ordem_catalogo-task_codegrp.
        ls_notif_task-task_text       = ls_ordem_catalogo-task_text.

      ENDIF.

      ls_notif_task-refobjectkey  = ls_notif_items_mi-refobjectkey.


      APPEND ls_notif_task TO lt_notif_task.

    ENDIF.

    IF ls_ordem_catalogo-causacodegroup IS NOT INITIAL.

*      DATA(lines) = lines( lt_notifcaus_se ).
*      DATA(ls_notifcaus) = VALUE #( lt_notifcaus_se[ 1 ] OPTIONAL ).
*
*      DATA(cause_key) = ls_notifcaus-cause_key.
*
*      SORT lt_notifcaus_se BY cause_sort_no DESCENDING.
*      DATA(cause_sort_no) = VALUE #( lt_notifcaus_se[ 1 ]-cause_sort_no OPTIONAL ).

      DATA:
        lv_lines      TYPE i,
        cause_key     TYPE urnum,
        cause_sort_no TYPE qurnum,
        ls_notifcaus  LIKE LINE OF lt_notifcaus_se.

      READ TABLE lt_notifcaus_se INTO ls_notifcaus INDEX 1.
      IF  sy-subrc         EQ 0.
        cause_key  = ls_notifcaus-cause_key.
      ENDIF.

      ADD 1 TO cause_key.

      SORT lt_notifcaus_se BY cause_sort_no DESCENDING.
      READ TABLE lt_notifcaus_se INTO ls_notifcaus INDEX 1.
      IF  sy-subrc         EQ 0.
        cause_sort_no  = ls_notifcaus-cause_sort_no.
      ENDIF.

      ADD 1 TO cause_sort_no.

      ls_notifcaus_si-cause_key     = cause_key.
      ls_notifcaus_si-refobjectkey  = ls_notif_items_mi-refobjectkey.
      ls_notifcaus_si-item_key      = ls_notif_items_mi-item_key.
      ls_notifcaus_si-cause_sort_no = cause_sort_no.
      ls_notifcaus_si-item_sort_no  = item_sort_no.
      ls_notifcaus_si-cause_codegrp = ls_ordem_catalogo-causacodegroup.
      ls_notifcaus_si-cause_code    = ls_ordem_catalogo-causacode.
      ls_notifcaus_si-causetext     = ls_ordem_catalogo-textocausa.

      APPEND ls_notifcaus_si TO lt_notifcaus_si.

    ENDIF.

    MOVE-CORRESPONDING ls_header_get TO ls_header_add.

    ls_header_add-reportedby = im_ordem_catalogo-usuario_app.
    ls_header_add-reportedby = im_ordem_catalogo-usuario_app.

    MOVE-CORRESPONDING ls_header_get TO ls_header_add_ri.

    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_ADD' DESTINATION 'NONE'
      EXPORTING
        number             = lv_number
        notifheader        = ls_header_add_ri
      IMPORTING
        notifheader_export = ls_header_add
      TABLES
        notitem            = lt_notif_items_mi
        notifcaus          = lt_notifcaus_si
        notiftask          = lt_notif_task
        return             = lt_return.

    READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.

    IF sy-subrc IS NOT INITIAL.

      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE' DESTINATION 'NONE'
        EXPORTING
          number              = lv_number
          together_with_order = 'X'
*         iv_refresh_complete = 'X'
        IMPORTING
          notifheader         = ls_notifheader_save
        TABLES
          return              = lt_return.

      READ TABLE et_return INTO ls_return WITH KEY type = 'E'.

      IF sy-subrc NE 0.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
          EXPORTING
            wait = 'X'.

        im_ordem_catalogo-status = 'Criado'(024).
        " Inserir o registro de catálogo de usuário para validação se obrigatório ou opcional
        MODIFY /ptloms/tb050 FROM ls_usuario_nota.

      ENDIF.

    ELSE.

      im_ordem_catalogo-status = 'Erro'(032).

    ENDIF.

*    et_return[] = CORRESPONDING #( lt_return ).
    DATA wa_return LIKE LINE OF lt_return.
    DATA return LIKE LINE OF et_return.
    LOOP AT lt_return INTO wa_return.
      MOVE-CORRESPONDING wa_return TO return .
      APPEND return TO et_return.
    ENDLOOP.


    lv_subobject = '/PTLOMS/ORDEM_CATALO'.
    lv_extnumber = lv_number.
    lv_user      = im_ordem_catalogo-usuario_app.

* Instância objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

    "ls_return_aux-message_v1 = ls_ordem_catalogo-notifno.

    ls_return_aux-id         = 'IM'.

    IF im_ordem_catalogo-status = 'Criado'(024).

      ls_return_aux-type       = 'S'.
      ls_return_aux-number     = '405'.
*      ls_return_aux-message    = |{ 'Catálogo criado'(034) }| & | | & |{ 'para a nota' }| & | | & |{ lv_number ALPHA = OUT }|.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_number
        IMPORTING
          output = lv_number.

      CONCATENATE 'Catálogo criado para a nota ' lv_number INTO ls_return_aux-message SEPARATED BY space.

    ELSE.

      ls_return_aux-type       = 'E'.
      ls_return_aux-number     = '277'.
      ls_return_aux-message    = 'Ocorrência de erro durante o processamento da nota'(033).

    ENDIF.

    ex_ordem_catalogo = im_ordem_catalogo.
    MOVE-CORRESPONDING ls_return_aux TO ls_return.
    lv_msg = ls_return_aux-message.
    APPEND ls_return TO et_return.

*    o_log->add( EXPORTING i_type = ls_return_aux-type
*                          i_text = lv_msg ).
    o_log->add( i_type = ls_return_aux-type
                i_text = lv_msg ).

  ENDMETHOD.


  METHOD IN_ORDEM_LISTA_TAREFA.

*   declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

*   Declaração de tabela
    DATA: lt_return           TYPE STANDARD TABLE OF bapiret2,
          lt_return_despacho  TYPE STANDARD TABLE OF bapiret2,
          lt_return_lib_ordem TYPE STANDARD TABLE OF bapiret2,
          lt_retorno          TYPE /ptloms/ct063.

*  Declaração de estrutura
    DATA: ls_return_aux TYPE /ptloms/et063.

*   Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_aufnr     TYPE aufnr,
          lv_objkey    TYPE swo_typeid,
          lv_erro      TYPE char1,
          lv_text1     TYPE string,
          lv_text2     TYPE string,
          lv_user      TYPE sy-uname.

    DATA: lv_ordem TYPE /ptloms/et087.

*   Verifica se critério de seleção foi preenchido
    IF im_ordem IS INITIAL.
      RETURN.
    ENDIF.

    lv_ordem = im_ordem.

*   Conversão local de instalação
    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = lv_ordem-funct_loc
      IMPORTING
        output = lv_ordem-funct_loc.

*   Chama função para criação de Ordem

    CALL FUNCTION '/PTLOMS/MF113'
      EXPORTING
        im_ordem       = lv_ordem
        im_aufnr       = im_nota
        im_nocommit    = im_nocommit
        it_texto_ordem = it_texto_ordem
      TABLES
        it_return      = lt_return.

    lv_subobject = '/PTLOMS/ORDEM'.

*   Busca número da ordem criada

    DATA: ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return WITH KEY type = 'S'
                                                 id   = 'IWO_BAPI2'
                                               number = 126.

    IF sy-subrc EQ 0.

      ex_aufnr     = ls_return-message_v2.
      lv_extnumber = ls_return-message_v2.

    ELSE.

      READ TABLE lt_return INTO ls_return WITH KEY type = 'S'
                                                   id   = 'IWO_BAPI2'
                                                 number = 112.

      IF sy-subrc EQ 0.
        ex_aufnr     = ls_return-message_v2.
        lv_extnumber = ls_return-message_v2.
      ENDIF.

    ENDIF.

    lv_user = im_ordem-usuario_app.

    IF im_nocommit IS INITIAL.

*     Realizar despacho automático para as operações criadas
      IF ex_aufnr IS NOT INITIAL .

        DATA: ls_tb013 TYPE /ptloms/tb013.

        SELECT SINGLE usuario perfil
          FROM /ptloms/tb013
          INTO CORRESPONDING FIELDS OF ls_tb013
          WHERE usuario EQ lv_user.

        IF sy-subrc EQ 0.

          DATA: lv_configuracao TYPE /ptloms/tb044-configuracao.

          SELECT SINGLE configuracao
            FROM /ptloms/tb044
            INTO lv_configuracao
            WHERE perfil EQ ls_tb013-perfil
              AND configuracao EQ '04'.

        ENDIF.

**      Busca configuração do sistema
        IF lv_configuracao = '04'.

*         Libera Ordem
          CALL FUNCTION '/PTLOMS/MF051'
            EXPORTING
              im_aufnr  = ex_aufnr
            TABLES
              it_return = lt_return_lib_ordem.

        ENDIF.

      ENDIF.

*     Anexar arquivos
      IF ex_aufnr IS NOT INITIAL AND it_anexo[] IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ex_aufnr
          IMPORTING
            output = lv_aufnr.

        lv_objkey  = lv_aufnr.
        me->in_anexar_imagem( EXPORTING im_objkey  = lv_objkey
                                        im_objtyp  = 'BUS2007'
                                        im_user    = lv_user
                                        it_anexo   = it_anexo
                              IMPORTING et_return  = lt_retorno ).
      ENDIF.

    ENDIF.

    IF ( im_nocommit IS INITIAL ) OR
       ( im_nocommit IS NOT INITIAL AND ex_aufnr IS INITIAL ).

*     Instancia objeto de Log
      CREATE OBJECT o_log
        EXPORTING
          i_subobject = lv_subobject
          i_extnumber = lv_extnumber
          i_user      = lv_user.

*     Grava mensagens de retorno
      LOOP AT lt_return INTO ls_return.
        lv_type = ls_return-type.
        lv_msg = ls_return-message.
        o_log->add( EXPORTING i_type = lv_type
                              i_text = lv_msg ).
      ENDLOOP.

    ENDIF.

*   Dados de retorno
    LOOP AT lt_return INTO ls_return.

      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return TO ls_return_aux.

      IF ls_return_aux-type   = 'S'         AND
         ls_return_aux-id     = 'IWO_BAPI2' AND
         ls_return_aux-number = 126.
        CLEAR: lv_text1, lv_text2.
        SPLIT ls_return_aux-message AT '%00000000001' INTO lv_text1 lv_text2.
        ls_return_aux-message = lv_text1 && lv_text2.
      ENDIF.

      IF ls_return_aux-type   = 'S'         AND
         ls_return_aux-id     = 'IWO_BAPI2' AND
         ls_return_aux-number = 112.
        CLEAR: lv_text1, lv_text2.
        SPLIT ls_return_aux-message AT '%00000000001' INTO lv_text1 lv_text2.
        ls_return_aux-message = lv_text1 && lv_text2.
      ENDIF.

      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.

      APPEND ls_return_aux TO et_return.

    ENDLOOP.

*   Inclui mensagens do anexo de arquivo
    DATA: ls_retorno LIKE LINE OF lt_retorno.
    LOOP AT lt_retorno INTO ls_retorno.

      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_retorno TO ls_return_aux.

      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
      ENDCASE.

      APPEND ls_return_aux TO et_return.

    ENDLOOP.

  ENDMETHOD.


  METHOD in_reserva.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

* Declaração de tabela interna
    DATA: lt_return TYPE STANDARD TABLE OF bapiret2.

* Declaração de estrutura
    DATA: ls_return_aux TYPE /ptloms/et063.

* Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_user      TYPE sy-uname.

    CALL FUNCTION '/PTLOMS/MF098'
      TABLES
        it_return     = lt_return
      CHANGING
        im_componente = ex_componente.

    lv_subobject = '/PTLOMS/COMP_ORDEM'.
    lv_user      = im_componente-usuario_app.
    lv_extnumber = im_componente-orderid.

* Instancia objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

* Grava mensagens de retorno
*   LOOP AT lt_return INTO DATA(ls_return).
    DATA: ls_return LIKE LINE OF lt_return.
    LOOP AT lt_return INTO ls_return.

      lv_type = ls_return-type.
      IF ls_return-id = 'IW' AND ( ls_return-number = '085' OR ls_return-number = '080' ).
        CONCATENATE ls_return-message 'Componente' im_componente-material INTO lv_msg SEPARATED BY space.
      ELSE.
        lv_msg = ls_return-message.
      ENDIF.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

* Dados de retorno
    LOOP AT lt_return INTO ls_return.
      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return TO ls_return_aux.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
          ex_componente-status    = 'Erro'(035).
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
          ex_componente-status    = 'Criado'(036).
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
          ex_componente-status    = 'Criado'(036).
      ENDCASE.
      APPEND ls_return_aux TO et_return.
    ENDLOOP.

  ENDMETHOD.


  METHOD in_reserva_delete.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

*   Declaração de objeto
    DATA: o_log TYPE REF TO /ptloms/cl004.

*   Declaração de tabela interna
    DATA: lt_return TYPE STANDARD TABLE OF bapiret2.

*   Declaração de estrutura
    DATA: ls_return_aux TYPE /ptloms/et063.

*   Declaração de variáveis para Log
    DATA: lv_subobject TYPE balsubobj,
          lv_extnumber TYPE balnrext,
          lv_msg       TYPE bapi_msg,
          lv_type      TYPE symsgty,
          lv_user      TYPE sy-uname.

    CALL FUNCTION '/PTLOMS/MF099'
      EXPORTING
        im_componente = im_componente
      TABLES
        it_return     = lt_return.

    lv_subobject = '/PTLOMS/COMP_ORDEM_D'.
    lv_extnumber = im_componente-orderid.
    lv_user      = im_componente-usuario_app.

*   Instancia objeto de Log
    CREATE OBJECT o_log
      EXPORTING
        i_subobject = lv_subobject
        i_extnumber = lv_extnumber
        i_user      = lv_user.

*   Grava mensagens de retorno
*** LOOP AT lt_return INTO DATA(ls_return).
    DATA: ls_return LIKE LINE OF lt_return.
    LOOP AT lt_return INTO ls_return.
      lv_type = ls_return-type.
      lv_msg = ls_return-message.
      o_log->add( EXPORTING i_type = lv_type
                            i_text = lv_msg ).
    ENDLOOP.

* Dados de retorno

*** LOOP AT lt_return INTO ls_return.
    LOOP AT lt_return INTO ls_return.

      CLEAR ls_return_aux.
      MOVE-CORRESPONDING ls_return TO ls_return_aux.
      CASE ls_return_aux-type.
        WHEN 'E'.
          ls_return_aux-type_desc = 'Error'.
          ex_componente-status    = 'Erro'(035).
        WHEN 'W'.
          ls_return_aux-type_desc = 'Warning'.
        WHEN 'S'.
          ls_return_aux-type_desc = 'Success'.
          ex_componente-status    = 'Criado'(036).
        WHEN 'I'.
          ls_return_aux-type_desc = 'Information'.
        WHEN OTHERS.
          ls_return_aux-type_desc = 'Success'.
          ex_componente-status    = 'Criado'(036).
      ENDCASE.
      APPEND ls_return_aux TO et_return.
    ENDLOOP.

  ENDMETHOD.


  METHOD out_ordem_catalogo.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log             TYPE REF TO /ptloms/cl004,
* Declaração de estrutura
          ls_return         LIKE LINE OF et_return,
          ls_bapiret2       TYPE bapiret2,
          ls_ordem_catalogo TYPE /ptloms/et128,
          ls_return_aux     TYPE bapiret2,
* Declaração de variáveis para Log
          lv_number         TYPE bapi2080_nothdre-notif_no,
          lt_return	        TYPE TABLE OF bapiret2,
          lt_item           TYPE TABLE OF bapi2080_notiteme,
          lt_cause          TYPE TABLE OF bapi2080_notcause,
          lt_task           TYPE TABLE OF bapi2080_nottaske,
          ls_header         TYPE bapi2080_nothdre.

    IF iv_usuario_app IS INITIAL.
      RETURN.
    ENDIF.

*    DATA(rt_data_conf_usuario) = me->out_monta_range_data_usuario( lv_usuario ).

*    SELECT b~aufnr, c~vornr
*      FROM /ptloms/tb026 AS a INNER JOIN afko AS b
*      ON a~aufnr = b~aufnr
*      INNER JOIN afvc AS c
*      ON b~aufpl = c~aufpl
*      INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
*      AND a~vornr = c~vornr
*      INTO TABLE @DATA(lt_tb026)
*      WHERE a~usuario    = @iv_usuario_app
*      AND a~desassociado = @space
*      AND c~phflg        = @space.
    TYPES: BEGIN OF ty_tb026,
             aufnr TYPE afko-aufnr,
             vornr TYPE afvc-vornr,
           END OF ty_tb026.
    DATA lt_tb026 TYPE TABLE OF ty_tb026.

    SELECT b~aufnr c~vornr
      FROM /ptloms/tb026 AS a INNER JOIN afko AS b
      ON a~aufnr = b~aufnr
      INNER JOIN afvc AS c
      ON b~aufpl = c~aufpl
      INNER JOIN afvv AS d ON c~aufpl = d~aufpl
                          AND c~aplzl = d~aplzl
*     AND a~vornr = c~vornr
      INTO TABLE lt_tb026
      WHERE a~usuario    = iv_usuario_app
         AND a~vornr = c~vornr
      AND a~desassociado = space
      AND c~phflg        = space.

    IF sy-subrc IS INITIAL.

      SORT lt_tb026 BY aufnr.
      DELETE ADJACENT DUPLICATES FROM lt_tb026 COMPARING aufnr.

*      SELECT * FROM
*        qmel INTO TABLE @DATA(lt_qmel)
*        FOR ALL ENTRIES IN @lt_tb026
*        WHERE aufnr = @lt_tb026-aufnr.
      DATA lt_qmel TYPE TABLE OF qmel.
      SELECT * FROM
        qmel INTO TABLE lt_qmel
        FOR ALL ENTRIES IN lt_tb026
        WHERE aufnr = lt_tb026-aufnr.

*      SELECT a~aufnr, a~equnr, a~tplnr, a~auart, a~ktext, b~pltxt
*        FROM viaufks AS a LEFT OUTER JOIN iflotx AS b
*        ON a~tplnr = b~tplnr
*        INTO TABLE @DATA(lt_aufk)
*        FOR ALL ENTRIES IN @lt_tb026
*        WHERE aufnr = @lt_tb026-aufnr.
      TYPES: BEGIN OF ty_aufk,
               aufnr TYPE viaufks-aufnr,
               equnr TYPE viaufks-equnr,
               tplnr TYPE viaufks-tplnr,
               auart TYPE viaufks-auart,
               ktext TYPE viaufks-ktext,
               pltxt TYPE iflotx-pltxt,
             END OF ty_aufk.
      DATA lt_aufk TYPE TABLE OF ty_aufk.
      SELECT a~aufnr a~equnr a~tplnr a~auart a~ktext b~pltxt
        FROM viaufks AS a LEFT OUTER JOIN iflotx AS b
        ON a~tplnr = b~tplnr
        INTO TABLE lt_aufk
        FOR ALL ENTRIES IN lt_tb026
        WHERE aufnr = lt_tb026-aufnr.

*      SELECT equnr, eqktx
*        FROM eqkt
*        INTO TABLE @DATA(lt_eqkt)
*        FOR ALL ENTRIES IN @lt_aufk
*        WHERE equnr = @lt_aufk-equnr.
      TYPES: BEGIN OF ty_eqkt,
               equnr TYPE eqkt-equnr,
               eqktx TYPE eqkt-eqktx,
             END OF ty_eqkt.
      DATA lt_eqkt TYPE TABLE OF ty_eqkt.
      SELECT equnr eqktx
        FROM eqkt
        INTO TABLE lt_eqkt
        FOR ALL ENTRIES IN lt_aufk
        WHERE equnr = lt_aufk-equnr.

      SORT lt_aufk BY aufnr.

      "Renato
      DATA: lt_causes_processed TYPE STANDARD TABLE OF string WITH DEFAULT KEY. "Tabela para armazenar causas processadas

      FIELD-SYMBOLS: <fs_cause> LIKE LINE OF lt_cause.

*       LOOP AT lt_qmel ASSIGNING FIELD-SYMBOL(<fs_qmel>).
      FIELD-SYMBOLS: <fs_qmel> LIKE LINE OF lt_qmel.
      LOOP AT lt_qmel ASSIGNING <fs_qmel>.

*        lv_number = |{ <fs_qmel>-qmnum ALPHA = IN }|.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_qmel>-qmnum
          IMPORTING
            output = lv_number.

        CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
          EXPORTING
            number             = lv_number
          IMPORTING
            notifheader_export = ls_header
          TABLES
            notitem            = lt_item
            notifcaus          = lt_cause
            notiftask          = lt_task
            return             = lt_return.

        ls_ordem_catalogo-qmtxt                = ls_header-short_text.
        ls_ordem_catalogo-qmart                = ls_header-notif_type.

*        ls_ordem_catalogo-notifno              = |{ lv_number ALPHA = OUT }|.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lv_number
          IMPORTING
            output = ls_ordem_catalogo-notifno.

*        READ TABLE lt_aufk ASSIGNING FIELD-SYMBOL(<fs_aufk>) WITH KEY aufnr = <fs_qmel>-aufnr BINARY SEARCH.
        FIELD-SYMBOLS: <fs_aufk> LIKE LINE OF lt_aufk.
        READ TABLE lt_aufk ASSIGNING <fs_aufk> WITH KEY aufnr = <fs_qmel>-aufnr BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          ls_ordem_catalogo-ordertype = <fs_aufk>-auart.
*          ls_ordem_catalogo-orderid   = |{ <fs_qmel>-aufnr ALPHA = OUT }|.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_qmel>-aufnr
            IMPORTING
              output = ls_ordem_catalogo-orderid.

*          ls_ordem_catalogo-equipment = |{ <fs_aufk>-equnr ALPHA = OUT }|.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_aufk>-equnr
            IMPORTING
              output = ls_ordem_catalogo-equipment.

          ls_ordem_catalogo-functloc  = <fs_aufk>-tplnr.
          ls_ordem_catalogo-pltxt     = <fs_aufk>-pltxt.
          ls_ordem_catalogo-shorttext = <fs_aufk>-ktext.

*          READ TABLE lt_eqkt ASSIGNING FIELD-SYMBOL(<fs_eqkt>) WITH KEY equnr = <fs_aufk>-equnr BINARY SEARCH.
          FIELD-SYMBOLS: <fs_eqkt> LIKE LINE OF lt_eqkt.
          READ TABLE lt_eqkt ASSIGNING <fs_eqkt> WITH KEY equnr = <fs_aufk>-equnr BINARY SEARCH.

          IF sy-subrc IS INITIAL.

            ls_ordem_catalogo-eqktx = <fs_eqkt>-eqktx.

          ENDIF.

        ENDIF.

        DATA: lv_item  TYPE string.

*          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE notif_no = lv_number.
        FIELD-SYMBOLS: <fs_item> LIKE LINE OF lt_item.
        LOOP AT lt_item ASSIGNING <fs_item> WHERE notif_no = lv_number.

          ls_ordem_catalogo-sintomadanodescricao = <fs_item>-txt_probcd.
          ls_ordem_catalogo-sintomadanocode      = <fs_item>-d_code.
          ls_ordem_catalogo-sintomadanocodegroup = <fs_item>-d_codegrp.
          ls_ordem_catalogo-textoitem            = <fs_item>-descript.
          ls_ordem_catalogo-parteobjetocode      = <fs_item>-dl_code.
          ls_ordem_catalogo-parteobjetocodegroup = <fs_item>-dl_codegrp.
          ls_ordem_catalogo-parteobjetodescricao = <fs_item>-txt_objptcd.

          " Verificar se os campos de Sintoma de Dano e Parte do Objeto estão preenchidos
          DATA: lv_sintoma_dano TYPE string.
          DATA: lv_parte_objeto TYPE string.
          DATA: lv_causa        TYPE string.

          IF <fs_item>-txt_probcd IS NOT INITIAL.
            lv_sintoma_dano = <fs_item>-txt_probcd.
          ELSE.
            lv_sintoma_dano = ''. " Sintoma de dano vazio
          ENDIF.

          IF <fs_item>-txt_objptcd IS NOT INITIAL.
            lv_parte_objeto = <fs_item>-txt_objptcd.
          ELSE.
            lv_parte_objeto = ''. " Parte do objeto vazio
          ENDIF.

*----------------------Inicio CAUSA -------------------
*          LOOP AT lt_cause ASSIGNING FIELD-SYMBOL(<fs_cause>) WHERE notif_no = <fs_item>-notif_no AND
*                                                                    item_key = <fs_item>-item_key.

**          LOOP AT lt_cause ASSIGNING <fs_cause> WHERE notif_no = <fs_item>-notif_no
**                                                  AND item_key = <fs_item>-item_key.
          lv_causa = ''.
          " Caso a causa não esteja preenchida, adiciona a linha sem os campos de causa
          ls_ordem_catalogo-causacodegroup = ''.
          ls_ordem_catalogo-causacode      = ''.
          ls_ordem_catalogo-textocausa     = ''.
          ls_ordem_catalogo-causadescricao = ''.

          READ TABLE lt_cause ASSIGNING <fs_cause> WITH KEY notif_no = <fs_item>-notif_no
                                                            item_key = <fs_item>-item_key.
          IF  sy-subrc      EQ 0.

            " Adiciona o código da causa à tabela de causas processadas

            " Verifica se a causa está preenchida
            IF <fs_cause>-cause_code IS NOT INITIAL.

              lv_causa = <fs_cause>-cause_codegrp.
              " Adiciona a linha com a causa preenchida
              ls_ordem_catalogo-causacodegroup = <fs_cause>-cause_codegrp.
              ls_ordem_catalogo-causacode      = <fs_cause>-cause_code.
              ls_ordem_catalogo-textocausa     = <fs_cause>-causetext.
              ls_ordem_catalogo-causadescricao = <fs_cause>-txt_causecd.

            ENDIF.

            " Preenche os dados de Sintoma de Dano e Parte do Objeto
            ls_ordem_catalogo-sintomadanodescricao = lv_sintoma_dano.
            ls_ordem_catalogo-parteobjetodescricao = lv_parte_objeto.

*            " Adiciona a linha na tabela de resultado
*            APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
*
*          ENDLOOP.
*          IF sy-subrc <> 0.
*            ls_ordem_catalogo-causacodegroup = ''.
*            ls_ordem_catalogo-causacode      = ''.
*            ls_ordem_catalogo-textocausa     = ''.
*            ls_ordem_catalogo-causadescricao = ''.
*
*            APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
*
*          ENDIF.
          ENDIF.
*-------------------------------------------FIm CAUSA -----------

*------------------------Início TASK
          CLEAR:
          ls_ordem_catalogo-task_codegrp    ,
          ls_ordem_catalogo-task_code       ,
          ls_ordem_catalogo-task_text       ,
          ls_ordem_catalogo-task_description.

          FIELD-SYMBOLS: <fs_task> LIKE LINE OF lt_task.
          IF  lt_task[]  IS NOT INITIAL.

*            LOOP AT lt_task ASSIGNING <fs_task> WHERE notif_no = <fs_item>-notif_no
*                                                  AND task_key = <fs_item>-item_key.
            READ TABLE lt_task ASSIGNING <fs_task> WITH KEY notif_no = <fs_item>-notif_no
                                                  task_key = <fs_item>-item_key.
            IF  sy-subrc   EQ 0.

              ls_ordem_catalogo-task_codegrp     = <fs_task>-task_codegrp.
              ls_ordem_catalogo-task_code        = <fs_task>-task_code.
              ls_ordem_catalogo-task_text        = <fs_task>-task_text.
              ls_ordem_catalogo-task_description = <fs_task>-txt_taskcd.

*              APPEND ls_ordem_catalogo TO ex_ordem_catalogo.

*            ENDLOOP.
            ENDIF.

          ENDIF.

          APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
*------------------ fim TASK ----------
        ENDLOOP.

      ENDLOOP.

**      FIELD-SYMBOLS: <fs_task> LIKE LINE OF lt_task.
**      IF  lt_task[]  IS NOT INITIAL.
**
**        LOOP AT lt_task ASSIGNING <fs_task> WHERE notif_no = <fs_item>-notif_no
**                                              AND task_key = <fs_item>-item_key.
**
**          ls_ordem_catalogo-task_codegrp     = <fs_task>-task_codegrp.
**          ls_ordem_catalogo-task_code        = <fs_task>-task_code.
**          ls_ordem_catalogo-task_text        = <fs_task>-task_text.
**          ls_ordem_catalogo-task_description = <fs_task>-txt_taskcd.
**
**          APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
**
**        ENDLOOP.

**      ENDIF.

*********************************************************************************************************
***  Fim - Nádia Rodrigues
*********************************************************************************************************
      IF sy-subrc IS NOT INITIAL.

        APPEND ls_ordem_catalogo TO ex_ordem_catalogo.

      ENDIF.

      "ENDLOOP.

      IF sy-subrc IS NOT INITIAL.

        APPEND ls_ordem_catalogo TO ex_ordem_catalogo.

      ENDIF.

      "ENDLOOP.

    ENDIF.

    CLEAR: ls_ordem_catalogo, lt_item, lt_cause, lt_return, ls_header.

  ENDMETHOD.


  METHOD out_ordem_catalogo_cesto.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************

* Declaração de objeto
    DATA: o_log             TYPE REF TO /ptloms/cl004,
* Declaração de estrutura
          ls_return         LIKE LINE OF et_return,
          ls_bapiret2       TYPE bapiret2,
          ls_ordem_catalogo TYPE /ptloms/et128,
          ls_return_aux     TYPE bapiret2,
* Declaração de variáveis para Log
          lv_number         TYPE bapi2080_nothdre-notif_no,
          lt_return	        TYPE TABLE OF bapiret2,
          lt_item           TYPE TABLE OF bapi2080_notiteme,
          lt_cause          TYPE TABLE OF bapi2080_notcause,
          lt_task           TYPE TABLE OF bapi2080_nottaske,
          ls_header         TYPE bapi2080_nothdre.

    IF iv_usuario_app IS INITIAL.
      RETURN.
    ENDIF.

*--- Definição das Estruturas ---*
    TYPES: BEGIN OF ty_temp_z,
             aufnr TYPE afko-aufnr,
             vornr TYPE afvc-vornr,
           END OF ty_temp_z.

    DATA: lt_z_data TYPE TABLE OF ty_temp_z,
          ls_z_data TYPE ty_temp_z.

    TYPES: BEGIN OF ty_tb026,
             aufnr TYPE afko-aufnr,
             vornr TYPE afvc-vornr,
           END OF ty_tb026.

    DATA: lt_tb026 TYPE TABLE OF ty_tb026.

*--- 1. Busca os dados brutos da sua tabela Z ---*
    SELECT aufnr vornr
      FROM /ptloms/tb065
      INTO TABLE lt_z_data
      WHERE uname = iv_usuario_app.

    IF lt_z_data IS NOT INITIAL.

*--- 2. normalização (crucial para o sucesso do join/for all entries) ---*
* como a aufnr na z não tem zeros, preenchemos aqui para igualar à afko
      LOOP AT lt_z_data INTO ls_z_data.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_z_data-aufnr
          IMPORTING
            output = ls_z_data-aufnr.

        MODIFY lt_z_data FROM ls_z_data TRANSPORTING aufnr.
      ENDLOOP.

*--- 3. preenchimento da lt_tb026 via banco de dados ---*
* usamos as chaves da lt_z_data (já corrigidas) para buscar na afko/afvc
      SELECT b~aufnr,
             c~vornr
        FROM afko AS b
        INNER JOIN afvc AS c ON c~aufpl = b~aufpl
        INNER JOIN afvv AS d ON d~aufpl = c~aufpl
                            AND d~aplzl = c~aplzl
        FOR ALL ENTRIES IN @lt_z_data
        WHERE b~aufnr = @lt_z_data-aufnr
          AND c~vornr = @lt_z_data-vornr
          AND c~phflg = @space " Garante que não venham sub-operações
        INTO TABLE @lt_tb026.

    ENDIF.


    IF sy-subrc IS INITIAL.

      SORT lt_tb026 BY aufnr.
      DELETE ADJACENT DUPLICATES FROM lt_tb026 COMPARING aufnr.

*      SELECT * FROM
*        qmel INTO TABLE @DATA(lt_qmel)
*        FOR ALL ENTRIES IN @lt_tb026
*        WHERE aufnr = @lt_tb026-aufnr.
      DATA lt_qmel TYPE TABLE OF qmel.
      SELECT * FROM
        qmel INTO TABLE lt_qmel
        FOR ALL ENTRIES IN lt_tb026
        WHERE aufnr = lt_tb026-aufnr.

*      SELECT a~aufnr, a~equnr, a~tplnr, a~auart, a~ktext, b~pltxt
*        FROM viaufks AS a LEFT OUTER JOIN iflotx AS b
*        ON a~tplnr = b~tplnr
*        INTO TABLE @DATA(lt_aufk)
*        FOR ALL ENTRIES IN @lt_tb026
*        WHERE aufnr = @lt_tb026-aufnr.
      TYPES: BEGIN OF ty_aufk,
               aufnr TYPE viaufks-aufnr,
               equnr TYPE viaufks-equnr,
               tplnr TYPE viaufks-tplnr,
               auart TYPE viaufks-auart,
               ktext TYPE viaufks-ktext,
               pltxt TYPE iflotx-pltxt,
             END OF ty_aufk.
      DATA lt_aufk TYPE TABLE OF ty_aufk.
      SELECT a~aufnr a~equnr a~tplnr a~auart a~ktext b~pltxt
        FROM viaufks AS a LEFT OUTER JOIN iflotx AS b
        ON a~tplnr = b~tplnr
        INTO TABLE lt_aufk
        FOR ALL ENTRIES IN lt_tb026
        WHERE aufnr = lt_tb026-aufnr.

*      SELECT equnr, eqktx
*        FROM eqkt
*        INTO TABLE @DATA(lt_eqkt)
*        FOR ALL ENTRIES IN @lt_aufk
*        WHERE equnr = @lt_aufk-equnr.
      TYPES: BEGIN OF ty_eqkt,
               equnr TYPE eqkt-equnr,
               eqktx TYPE eqkt-eqktx,
             END OF ty_eqkt.
      DATA lt_eqkt TYPE TABLE OF ty_eqkt.
      SELECT equnr eqktx
        FROM eqkt
        INTO TABLE lt_eqkt
        FOR ALL ENTRIES IN lt_aufk
        WHERE equnr = lt_aufk-equnr.

      SORT lt_aufk BY aufnr.

      "Renato
      DATA: lt_causes_processed TYPE STANDARD TABLE OF string WITH DEFAULT KEY. "Tabela para armazenar causas processadas

      FIELD-SYMBOLS: <fs_cause> LIKE LINE OF lt_cause.

*       LOOP AT lt_qmel ASSIGNING FIELD-SYMBOL(<fs_qmel>).
      FIELD-SYMBOLS: <fs_qmel> LIKE LINE OF lt_qmel.
      LOOP AT lt_qmel ASSIGNING <fs_qmel>.

*        lv_number = |{ <fs_qmel>-qmnum ALPHA = IN }|.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_qmel>-qmnum
          IMPORTING
            output = lv_number.

        CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
          EXPORTING
            number             = lv_number
          IMPORTING
            notifheader_export = ls_header
          TABLES
            notitem            = lt_item
            notifcaus          = lt_cause
            notiftask          = lt_task
            return             = lt_return.

        ls_ordem_catalogo-qmtxt                = ls_header-short_text.
        ls_ordem_catalogo-qmart                = ls_header-notif_type.

*        ls_ordem_catalogo-notifno              = |{ lv_number ALPHA = OUT }|.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lv_number
          IMPORTING
            output = ls_ordem_catalogo-notifno.

*        READ TABLE lt_aufk ASSIGNING FIELD-SYMBOL(<fs_aufk>) WITH KEY aufnr = <fs_qmel>-aufnr BINARY SEARCH.
        FIELD-SYMBOLS: <fs_aufk> LIKE LINE OF lt_aufk.
        READ TABLE lt_aufk ASSIGNING <fs_aufk> WITH KEY aufnr = <fs_qmel>-aufnr BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          ls_ordem_catalogo-ordertype = <fs_aufk>-auart.
*          ls_ordem_catalogo-orderid   = |{ <fs_qmel>-aufnr ALPHA = OUT }|.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_qmel>-aufnr
            IMPORTING
              output = ls_ordem_catalogo-orderid.

*          ls_ordem_catalogo-equipment = |{ <fs_aufk>-equnr ALPHA = OUT }|.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_aufk>-equnr
            IMPORTING
              output = ls_ordem_catalogo-equipment.

          ls_ordem_catalogo-functloc  = <fs_aufk>-tplnr.
          ls_ordem_catalogo-pltxt     = <fs_aufk>-pltxt.
          ls_ordem_catalogo-shorttext = <fs_aufk>-ktext.

*          READ TABLE lt_eqkt ASSIGNING FIELD-SYMBOL(<fs_eqkt>) WITH KEY equnr = <fs_aufk>-equnr BINARY SEARCH.
          FIELD-SYMBOLS: <fs_eqkt> LIKE LINE OF lt_eqkt.
          READ TABLE lt_eqkt ASSIGNING <fs_eqkt> WITH KEY equnr = <fs_aufk>-equnr BINARY SEARCH.

          IF sy-subrc IS INITIAL.

            ls_ordem_catalogo-eqktx = <fs_eqkt>-eqktx.

          ENDIF.

        ENDIF.

        DATA: lv_item  TYPE string.

*          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE notif_no = lv_number.
        FIELD-SYMBOLS: <fs_item> LIKE LINE OF lt_item.
        LOOP AT lt_item ASSIGNING <fs_item> WHERE notif_no = lv_number.

          ls_ordem_catalogo-sintomadanodescricao = <fs_item>-txt_probcd.
          ls_ordem_catalogo-sintomadanocode      = <fs_item>-d_code.
          ls_ordem_catalogo-sintomadanocodegroup = <fs_item>-d_codegrp.
          ls_ordem_catalogo-textoitem            = <fs_item>-descript.
          ls_ordem_catalogo-parteobjetocode      = <fs_item>-dl_code.
          ls_ordem_catalogo-parteobjetocodegroup = <fs_item>-dl_codegrp.
          ls_ordem_catalogo-parteobjetodescricao = <fs_item>-txt_objptcd.

          " Verificar se os campos de Sintoma de Dano e Parte do Objeto estão preenchidos
          DATA: lv_sintoma_dano TYPE string.
          DATA: lv_parte_objeto TYPE string.
          DATA: lv_causa        TYPE string.

          IF <fs_item>-txt_probcd IS NOT INITIAL.
            lv_sintoma_dano = <fs_item>-txt_probcd.
          ELSE.
            lv_sintoma_dano = ''. " Sintoma de dano vazio
          ENDIF.

          IF <fs_item>-txt_objptcd IS NOT INITIAL.
            lv_parte_objeto = <fs_item>-txt_objptcd.
          ELSE.
            lv_parte_objeto = ''. " Parte do objeto vazio
          ENDIF.

*----------------------Inicio CAUSA -------------------
*          LOOP AT lt_cause ASSIGNING FIELD-SYMBOL(<fs_cause>) WHERE notif_no = <fs_item>-notif_no AND
*                                                                    item_key = <fs_item>-item_key.

**          LOOP AT lt_cause ASSIGNING <fs_cause> WHERE notif_no = <fs_item>-notif_no
**                                                  AND item_key = <fs_item>-item_key.
          lv_causa = ''.
          " Caso a causa não esteja preenchida, adiciona a linha sem os campos de causa
          ls_ordem_catalogo-causacodegroup = ''.
          ls_ordem_catalogo-causacode      = ''.
          ls_ordem_catalogo-textocausa     = ''.
          ls_ordem_catalogo-causadescricao = ''.

          READ TABLE lt_cause ASSIGNING <fs_cause> WITH KEY notif_no = <fs_item>-notif_no
                                                            item_key = <fs_item>-item_key.
          IF  sy-subrc      EQ 0.

            " Adiciona o código da causa à tabela de causas processadas

            " Verifica se a causa está preenchida
            IF <fs_cause>-cause_code IS NOT INITIAL.

              lv_causa = <fs_cause>-cause_codegrp.
              " Adiciona a linha com a causa preenchida
              ls_ordem_catalogo-causacodegroup = <fs_cause>-cause_codegrp.
              ls_ordem_catalogo-causacode      = <fs_cause>-cause_code.
              ls_ordem_catalogo-textocausa     = <fs_cause>-causetext.
              ls_ordem_catalogo-causadescricao = <fs_cause>-txt_causecd.

            ENDIF.

            " Preenche os dados de Sintoma de Dano e Parte do Objeto
            ls_ordem_catalogo-sintomadanodescricao = lv_sintoma_dano.
            ls_ordem_catalogo-parteobjetodescricao = lv_parte_objeto.

*            " Adiciona a linha na tabela de resultado
*            APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
*
*          ENDLOOP.
*          IF sy-subrc <> 0.
*            ls_ordem_catalogo-causacodegroup = ''.
*            ls_ordem_catalogo-causacode      = ''.
*            ls_ordem_catalogo-textocausa     = ''.
*            ls_ordem_catalogo-causadescricao = ''.
*
*            APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
*
*          ENDIF.
          ENDIF.
*-------------------------------------------FIm CAUSA -----------

*------------------------Início TASK
          CLEAR:
          ls_ordem_catalogo-task_codegrp    ,
          ls_ordem_catalogo-task_code       ,
          ls_ordem_catalogo-task_text       ,
          ls_ordem_catalogo-task_description.

          FIELD-SYMBOLS: <fs_task> LIKE LINE OF lt_task.
          IF  lt_task[]  IS NOT INITIAL.

*            LOOP AT lt_task ASSIGNING <fs_task> WHERE notif_no = <fs_item>-notif_no
*                                                  AND task_key = <fs_item>-item_key.
            READ TABLE lt_task ASSIGNING <fs_task> WITH KEY notif_no = <fs_item>-notif_no
                                                  task_key = <fs_item>-item_key.
            IF  sy-subrc   EQ 0.

              ls_ordem_catalogo-task_codegrp     = <fs_task>-task_codegrp.
              ls_ordem_catalogo-task_code        = <fs_task>-task_code.
              ls_ordem_catalogo-task_text        = <fs_task>-task_text.
              ls_ordem_catalogo-task_description = <fs_task>-txt_taskcd.

*              APPEND ls_ordem_catalogo TO ex_ordem_catalogo.

*            ENDLOOP.
            ENDIF.

          ENDIF.

          APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
*------------------ fim TASK ----------
        ENDLOOP.

      ENDLOOP.

**      FIELD-SYMBOLS: <fs_task> LIKE LINE OF lt_task.
**      IF  lt_task[]  IS NOT INITIAL.
**
**        LOOP AT lt_task ASSIGNING <fs_task> WHERE notif_no = <fs_item>-notif_no
**                                              AND task_key = <fs_item>-item_key.
**
**          ls_ordem_catalogo-task_codegrp     = <fs_task>-task_codegrp.
**          ls_ordem_catalogo-task_code        = <fs_task>-task_code.
**          ls_ordem_catalogo-task_text        = <fs_task>-task_text.
**          ls_ordem_catalogo-task_description = <fs_task>-txt_taskcd.
**
**          APPEND ls_ordem_catalogo TO ex_ordem_catalogo.
**
**        ENDLOOP.

**      ENDIF.

*********************************************************************************************************
***  Fim - Nádia Rodrigues
*********************************************************************************************************
      IF sy-subrc IS NOT INITIAL.

        APPEND ls_ordem_catalogo TO ex_ordem_catalogo.

      ENDIF.

      "ENDLOOP.

      IF sy-subrc IS NOT INITIAL.

        APPEND ls_ordem_catalogo TO ex_ordem_catalogo.

      ENDIF.

      "ENDLOOP.

    ENDIF.

    CLEAR: ls_ordem_catalogo, lt_item, lt_cause, lt_return, ls_header.

  ENDMETHOD.
ENDCLASS.
