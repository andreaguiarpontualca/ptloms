*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP004_TOP
*&---------------------------------------------------------------------*
PROGRAM /ptloms/mp004 MESSAGE-ID /ptloms/cm001.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

*&---------------------------------------------------------------------*
*& Tables
*&---------------------------------------------------------------------*
TABLES: viaufks,
        afvc,
        afvv,
        crhd,
        /ptloms/tb013,
        /ptloms/tb026.

*&---------------------------------------------------------------------*
*& Constants                                                           *
*&---------------------------------------------------------------------*
CONSTANTS: c_save  TYPE char1          VALUE 'A',
           c_hande TYPE char4          VALUE 'ALV2'.

*&---------------------------------------------------------------------*
*& Range
*&---------------------------------------------------------------------*
DATA: r_objid    TYPE RANGE OF crhd-objid,
      it_message TYPE bapirettab.

*&---------------------------------------------------------------------*
*& Objeto
*&---------------------------------------------------------------------*
DATA: o_cl008 TYPE REF TO /ptloms/cl008.

*&---------------------------------------------------------------------*
*& Tabela Interna
*&---------------------------------------------------------------------*
DATA: gt_despacho TYPE /ptloms/ct079,
      gt_tb026    TYPE STANDARD TABLE OF /ptloms/tb026,
      gt_nodes    TYPE STANDARD TABLE OF /ptloms/cl008=>ty_nodes.

*----------------------------------------------------------------------*
* Estruturas
*----------------------------------------------------------------------*
DATA: wa_usuario TYPE /ptloms/cl008=>ty_usuario.

*----------------------------------------------------------------------*
* Variáveis
*----------------------------------------------------------------------*
DATA: gv_desc_motivo_desassociacao TYPE dd07d-ddtext.

*----------------------------------------------------------------------*
* Definições para o alv tree
*----------------------------------------------------------------------*
DATA: g_alv_tree         TYPE REF TO cl_gui_alv_tree,
      g_custom_container TYPE REF TO cl_gui_custom_container,
* §0.Define a reference variable for the toolbar.
      g_toolbar          TYPE REF TO cl_gui_toolbar.

DATA: gt_despacho_tree TYPE /ptloms/ct080, "OCCURS 0,      "Output-Table
      gt_fieldcatalog  TYPE lvc_t_fcat,
      ok_code          LIKE sy-ucomm,
      save_ok          LIKE sy-ucomm.           "OK-Code

*----------------------------------------------------------------------*
* §3. Define a (local) class for event handling
CLASS lcl_toolbar_event_receiver DEFINITION.

  PUBLIC SECTION.
* §4. Define an event handler method to react to fired function codes
*     of the toolbar.                   .
    METHODS: on_function_selected
                FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING fcode.

ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_toolbar_event_receiver IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_toolbar_event_receiver IMPLEMENTATION.
*
  METHOD on_function_selected.

    DATA: lv_status         TYPE /ptloms/ed011,
          lt_selected_nodes TYPE lvc_t_nkey.

    IF fcode = 'DESASSOCIA' OR fcode = 'ASSOCIA' OR fcode = 'TRANSFERE'.

      CLEAR: it_message.

      PERFORM f_validar_bloqueio_ordem CHANGING lt_selected_nodes.

      IF it_message IS NOT INITIAL.

        CALL FUNCTION 'RMSL325_DISPLAY_MSG_POPUP'
          EXPORTING
            it_message = it_message.

      ENDIF.

      IF lt_selected_nodes IS INITIAL.
        MESSAGE s000 WITH 'Nenhum registro para processamento'(111) DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

    ENDIF.

    CASE fcode.
      WHEN 'DESASSOCIA'.
        PERFORM f_validar_selecao_alv_tree.
        CLEAR: /ptloms/tb026, gv_desc_motivo_desassociacao.
        CALL SCREEN '0300' STARTING AT 15  3 ENDING AT 90 10.

      WHEN 'ASSOCIA'.
        PERFORM f_validar_selecao_alv_tree.
        CLEAR: wa_usuario-usuario, wa_usuario-nome.
        CALL SCREEN '0400' STARTING AT 15  3 ENDING AT 90 10.

      WHEN 'TRANSFERE'.
        PERFORM f_validar_selecao_alv_tree.
        CLEAR: wa_usuario-usuario, wa_usuario-nome.
        PERFORM f_valida_operacao CHANGING lv_status.

*       Transferência de ordem ou operações já iniciadas no dispositivo não podem ser efetuadas
        IF lv_status = 2.
          MESSAGE s000 WITH 'Registro já iniciado no App'(092) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.
        CALL SCREEN '0500' STARTING AT 15  3 ENDING AT 90 10.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Definições para o alv
*----------------------------------------------------------------------*
CLASS lcl_handle_events      DEFINITION DEFERRED.

DATA:
  o_alv           TYPE REF TO cl_salv_table,
  o_status        TYPE REF TO cl_salv_functions,
  o_columns       TYPE REF TO cl_salv_columns_table,
  o_column        TYPE REF TO cl_salv_column_table,
  o_events        TYPE REF TO cl_salv_events_table,
  o_handle_events TYPE REF TO lcl_handle_events,
  o_container     TYPE REF TO cl_gui_custom_container,
  o_selections    TYPE REF TO cl_salv_selections,
  o_layout        TYPE REF TO cl_salv_layout,
  o_rows          TYPE salv_t_row,
  st_key          TYPE salv_s_layout_key,
  g_default       TYPE sap_bool.
*----------------------------------------------------------------------*
* Definição da classe local lcl_handle_events
*----------------------------------------------------------------------*
CLASS lcl_handle_events DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS clique_duplo FOR EVENT double_click  "Clique duplo no alv
                OF cl_salv_events_table
      IMPORTING row column.                                 "#EC NEEDED

    METHODS clique_alv   FOR EVENT link_click    "Link, hotspot ou botão no alv
                OF cl_salv_events_table
      IMPORTING row column.                                 "#EC NEEDED

    METHODS user_command FOR EVENT added_function
                OF cl_salv_events_table
      IMPORTING e_salv_function.
ENDCLASS.                    "lcl_handle_events DEFINITION

*----------------------------------------------------------------------*
* Implementação da classe local lcl_handle_events
*----------------------------------------------------------------------*
CLASS lcl_handle_events IMPLEMENTATION.

  METHOD clique_duplo.
    CASE column.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.                    "clique_duplo

  METHOD clique_alv.
    CASE column.
      WHEN 'AUFNR'.

***     READ TABLE gt_despacho INTO DATA(ls_despacho) INDEX row.
        DATA: ls_despacho LIKE LINE OF gt_despacho.
        READ TABLE gt_despacho INTO ls_despacho INDEX row.

        IF sy-subrc EQ 0.
          SET PARAMETER ID 'ANR' FIELD ls_despacho-aufnr.
          CALL TRANSACTION 'IW32' AND SKIP FIRST SCREEN.
        ENDIF.

      WHEN 'QMNUM'.

        READ TABLE gt_despacho INTO ls_despacho INDEX row.
        IF sy-subrc EQ 0.
          SET PARAMETER ID 'IQM' FIELD ls_despacho-qmnum.
          CALL TRANSACTION 'IW22' AND SKIP FIRST SCREEN.
        ENDIF.

      WHEN 'KUNNR'.

        READ TABLE gt_despacho INTO ls_despacho INDEX row.
        IF sy-subrc EQ 0.
          SET PARAMETER ID 'KUN' FIELD ls_despacho-kunnr.
          CALL TRANSACTION 'XD03' AND SKIP FIRST SCREEN.
        ENDIF.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.                    "clique_link


  METHOD user_command.

    DATA: lv_atribuida TYPE char1,
          lv_liberada  TYPE char1.

    CASE e_salv_function.
      WHEN 'ATUALIZA'.

        COMMIT WORK.

*        PERFORM f_despacho.
        PERFORM f_busca_dados.
        PERFORM f_monta_alv.
        CALL METHOD g_alv_tree->free.
        CALL METHOD g_alv_tree->finalize.
        FREE g_alv_tree.
        PERFORM f_monta_alv_tree.

      WHEN 'ADM_DESPACHO'.

        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(089) DISPLAY LIKE 'E'.
          RETURN.
        ELSE.

          PERFORM f_verificao_inicial CHANGING lv_atribuida lv_liberada.
          IF lv_atribuida = 'X' OR lv_liberada IS INITIAL.
            RETURN.
          ENDIF.

          PERFORM f_ler_bloqueio_ordem.

          CLEAR: wa_usuario-usuario, wa_usuario-nome.

          IF o_rows IS NOT INITIAL.

            CALL SCREEN '0200' STARTING AT 15  3 ENDING AT 90 10.

          ENDIF.

        ENDIF.

      WHEN 'ADM_LIB'.

        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar um registro'(090) DISPLAY LIKE 'E'.
          RETURN.
        ELSE.

***       DESCRIBE TABLE o_rows LINES DATA(lv_qtd_reg_sel).
          DATA: lv_qtd_reg_sel TYPE i.
          DESCRIBE TABLE o_rows LINES lv_qtd_reg_sel.

          PERFORM f_ler_bloqueio_ordem.

          IF o_rows IS NOT INITIAL.

            PERFORM f_libera_ordem.

          ENDIF.

        ENDIF.

      WHEN OTHERS.
    ENDCASE.

    o_alv->refresh( ) .


  ENDMETHOD.                    "user_command

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION

*&---------------------------------------------------------------------*
*& Tela de Seleção
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_werks FOR crhd-werks NO INTERVALS OBLIGATORY,
                s_aufnr FOR viaufks-aufnr,
                s_auart FOR viaufks-auart,
                s_qmnum FOR viaufks-qmnum MATCHCODE OBJECT qmeg,
                s_priok FOR viaufks-priok,
                s_tplnr FOR viaufks-tplnr,
                s_equnr FOR viaufks-equnr,
                s_iwerk FOR viaufks-iwerk, "Centro de Planejamento
                s_ingpr FOR viaufks-ingpr, "Grupo de Planejamento
                s_ilart FOR viaufks-ilart, "Tipo de atividade de manutenção
*                s_gewrk FOR viaufks-gewrk MATCHCODE OBJECT /ptloms/sh002, " Centro de Trabalho
                s_gewrk FOR crhd-arbpl MATCHCODE OBJECT cram, " Centro de Trabalho
                s_gstrp FOR viaufks-gstrp. "OBLIGATORY. "Data Base Início
"                s_datope FOR afvv-fsavd OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-005.
SELECT-OPTIONS: s_datope FOR afvv-fsavd.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
SELECT-OPTIONS: s_usuapp FOR /ptloms/tb013-usuario MATCHCODE OBJECT /ptloms/sh001.
PARAMETERS: p_f_tree AS CHECKBOX DEFAULT 'X',
            p_mat_at AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_oper   TYPE c RADIOBUTTON GROUP r1,
            p_ordens TYPE c RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK b2.

*-- Layout
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-004.
PARAMETERS  p_vari  TYPE disvariant-variant.
PARAMETERS  p_vari2 TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK b4.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
* Ajuda de pesquisa: Variante de exibição.
  PERFORM f_f4_variant USING '' CHANGING p_vari.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari2.
* Ajuda de pesquisa: Variante de exibição.
  PERFORM f_f4_variant USING 'X' CHANGING p_vari2.
