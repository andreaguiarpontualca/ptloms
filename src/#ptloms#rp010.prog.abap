*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo         : PM                                                 *
*& Tipo           : Corretivo                                          *
*& Nome           : /PTLOMS/RP010                                      *
*& Transação      : /PTLOMS/PTLOMSN031                                 *
*& Autor          : Iury Silva                                         *
*& Funcional      : Andre Aguiar                                       *
*& Objetivo       : Programa Migração de Associações para o sistema V2 *
*&---------------------------------------------------------------------*

REPORT /ptloms/rp010 MESSAGE-ID /ptloms/cm001.

TABLES: /ptloms/tb026, /ptloms/tb065, /ptloms/tb066.

************************************************************************
** Load Class                                                         **
************************************************************************
CLASS cl_abap       DEFINITION DEFERRED.

************************************************************************
** Tela de Seleção                                                    **
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: so_dtass FOR /ptloms/tb026-data_associacao OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

************************************************************************
** Objetos                                                            **
************************************************************************
INITIALIZATION.
  DATA ob_abap TYPE REF TO cl_abap.

*************************************************************************
* Classe                                                              **
************************************************************************
CLASS cl_abap DEFINITION FINAL.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_detalhes_operacao,
             orderid            TYPE aufnr,
             activity           TYPE vornr,
             system_status_text TYPE co_sttxt,
           END OF ty_detalhes_operacao.

    DATA: ti_loghand TYPE STANDARD TABLE OF /ptloms/et193,
          wa_loghand LIKE LINE OF ti_loghand.

    DATA: ti_tb026              TYPE TABLE OF /ptloms/tb026,
          wa_tb026              LIKE LINE OF ti_tb026,
          ti_detalhes_operacoes TYPE TABLE OF ty_detalhes_operacao,
          wa_detalhe_operacao   LIKE LINE OF ti_detalhes_operacoes,
          wa_operation          TYPE bapi_alm_order_operation_e.

    DATA: ti_lista         TYPE /ptloms/ct123,
          ti_lista_retorno TYPE /ptloms/ct123,
          wa_lista         TYPE LINE OF /ptloms/ct123.

    DATA: s_data  TYPE RANGE OF sy-datum,
          so_data LIKE LINE OF s_data.

    DATA: lv_aufnr TYPE bapi_alm_order_header_e-orderid, "aufnr,
          lv_vornr TYPE bapi_alm_order_operation_e-activity. "vornr.

    DATA: ti_return     TYPE TABLE OF bapiret2,
          wa_return     TYPE bapiret2,
          ti_text       TYPE TABLE OF bapi_alm_text,
          ti_text_lines TYPE TABLE OF bapi_alm_text_lines.


    METHODS:
      get_data,
      build_data,
      connect,
      display.

ENDCLASS.                    "CL_ABAP DEFINITION

************************************************************************
* Implementação                                                       **
************************************************************************
CLASS cl_abap IMPLEMENTATION.

  METHOD get_data.

    SELECT *
      FROM /ptloms/tb026
      INTO TABLE ti_tb026
      WHERE data_associacao IN so_dtass
        AND desassociado    EQ space .

    IF sy-subrc = 0.

      IF ti_tb026[] IS NOT INITIAL.

        "- Ordena os registros de acordo com a REFERENCIA (Data)
        SORT ti_tb026 BY aufnr vornr ASCENDING.
        DELETE ti_tb026 WHERE aufnr IS INITIAL OR vornr IS INITIAL.

      ENDIF.

      me->build_data( ).

    ELSE.
      MESSAGE s000 WITH 'Nenhum registro selecionado!' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.


  ENDMETHOD.

  METHOD build_data.

    CLEAR: wa_tb026.
    LOOP AT ti_tb026 INTO wa_tb026.

      CLEAR: wa_loghand, wa_detalhe_operacao, lv_aufnr, lv_vornr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_tb026-aufnr
        IMPORTING
          output = lv_aufnr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_tb026-vornr
        IMPORTING
          output = lv_vornr.

      TRY.

          "Busca status da operação para verificar se a ordem deve ser migrada
          CLEAR: wa_operation,
                 ti_return,
                 ti_text,
                 ti_text_lines.

          CALL FUNCTION 'BAPI_ALM_OPERATION_GET_DETAIL'
            EXPORTING
              iv_orderid      = lv_aufnr
              iv_activity     = lv_vornr
              iv_sub_activity = space
            IMPORTING
              es_operation    = wa_operation
            TABLES
              return          = ti_return
              et_text         = ti_text
              et_text_lines   = ti_text_lines.

*          IF sy-subrc = 0.
*            MOVE-CORRESPONDING wa_operation TO wa_detalhe_operacao.
*          ENDIF.

        CATCH cx_message_no_source_found.

          CLEAR wa_loghand.
          MOVE-CORRESPONDING wa_tb026 TO wa_loghand.

          wa_loghand-type    = 'E'.
          wa_loghand-message = 'Status da ordem e operação não encontrado'.
          APPEND wa_loghand TO ti_loghand.

          CONTINUE.

      ENDTRY.

      "Verifica se os status da operação permitem a migração
*      IF wa_detalhe_operacao-system_status_text = 'CNPA LIB' OR wa_detalhe_operacao-system_status_text = 'CNPA LIB'.
      IF wa_operation-system_status_text CS 'CNPA LIB' OR wa_operation-system_status_text CS 'LIB'.

        CLEAR: wa_lista.
        MOVE-CORRESPONDING wa_tb026 TO wa_lista.
        wa_lista-uname = wa_tb026-usuario.
        APPEND wa_lista TO ti_lista.

      ENDIF.

    ENDLOOP.

    "Migrar dados para as novas tabelas
    me->connect( ).

  ENDMETHOD.

  METHOD connect.

    IF ti_lista[] IS NOT INITIAL.

      CALL FUNCTION '/PTLOMS/MF115'
        EXPORTING
          it_lista = ti_lista
        IMPORTING
          et_lista = ti_lista_retorno.

      CLEAR: wa_lista, wa_loghand.
      LOOP AT ti_lista_retorno INTO wa_lista.

        CLEAR: wa_loghand.

        READ TABLE ti_loghand TRANSPORTING NO FIELDS WITH KEY aufnr = wa_lista-aufnr
                                                              vornr = wa_lista-vornr.
        IF sy-subrc <> 0.
          MOVE-CORRESPONDING wa_lista TO wa_loghand.

          wa_loghand-usuario = wa_lista-uname.


          READ TABLE wa_lista-retorno INTO DATA(wa_retorno) INDEX 1.

          wa_loghand-type = wa_retorno-type.
          wa_loghand-message = wa_retorno-message.

          APPEND wa_loghand TO ti_loghand.
        ENDIF.

      ENDLOOP.

    ENDIF.
  ENDMETHOD.  " Connect

  METHOD display.

* Objetos ALV
    DATA:
      ob_alv        TYPE REF TO cl_salv_table,
      ob_colunas    TYPE REF TO cl_salv_columns_table,
      ob_coluna     TYPE REF TO cl_salv_column_table,
      ob_functions  TYPE REF TO cl_salv_functions_list,
      ob_layout     TYPE REF TO cl_salv_layout,
      ob_selections TYPE REF TO cl_salv_selections.

    DATA st_key TYPE salv_s_layout_key.

    SORT ti_loghand.
    DELETE ADJACENT DUPLICATES FROM ti_loghand COMPARING ALL FIELDS.

    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = ob_alv
          CHANGING
            t_table      = ti_loghand.

      CATCH cx_salv_msg INTO DATA(ob_salv_msg).
        DATA(vl_msg) = ob_salv_msg->get_text( ).
        MESSAGE vl_msg TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

* Habilita todos os botões genéricos do alv
    ob_functions = ob_alv->get_functions( ).
    ob_functions->set_all( abap_true ).

* Buscar todas as colunas do ALV
    ob_colunas = ob_alv->get_columns( ).
* Otimizar a largura das colunas / bloqueia largura definida no output len...
    ob_colunas->set_optimize( 'X' ).

**  Alterar atributos da coluna
*    me->change_column( EXPORTING name = 'AUFNR'       text = 'Nº ordem'              length = '5' ).
*    me->change_column( EXPORTING name = 'VORNR'       text = 'Nº operação'           length = '5' ).
*    me->change_column( EXPORTING name = 'USUARIO'     text = 'Usuário'               length = '12' ).
*    me->change_column( EXPORTING name = 'TYPE'        text = 'Tipo da Menssagem'     length = '10' ).
*    me->change_column( EXPORTING name = 'MESSAGE'     text = 'Menssagem de Retorno'  length = '10' ).

    st_key-report = sy-repid.

    ob_layout = ob_alv->get_layout( ).
    ob_layout->set_key( st_key ).
    ob_layout->set_default( abap_true ).
    ob_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

    ob_alv->display( ).

  ENDMETHOD.                    "display
ENDCLASS. "CL_ABAP IMPLEMENTATION

START-OF-SELECTION.

  CREATE OBJECT ob_abap.

  ob_abap->get_data( ).
  ob_abap->display( ).


************************************************************************
** Evento: END-OF-SELECTION                                           **
************************************************************************
END-OF-SELECTION.
