*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP003_TOP
*&---------------------------------------------------------------------*
PROGRAM /ptloms/mp003 MESSAGE-ID /ptloms/cm001.

*TABLES /ptloms/tb013.

TYPES: BEGIN OF ty_usuario.
         INCLUDE STRUCTURE /ptloms/tb013.
         TYPES: descricao_perfil TYPE /ptloms/tb012-descricao.
TYPES: arbpl             TYPE crhd-arbpl.
TYPES: desc_dia_inicio   TYPE dd07d-ddtext.
*TYPES: senha_usuario_sap TYPE char32.
*TYPES: status_senha      TYPE icon_text.
TYPES: END OF ty_usuario.

*----------------------------------------------------------------------*
* Tabelas interna
*----------------------------------------------------------------------*
DATA: gt_usuario TYPE STANDARD TABLE OF ty_usuario.

*----------------------------------------------------------------------*
* Estruturas
*----------------------------------------------------------------------*
DATA: wa_usuario     TYPE ty_usuario,
      wa_confirmacao TYPE /ptloms/ed017.

*----------------------------------------------------------------------*
* Variáveis
*----------------------------------------------------------------------*
DATA: gv_acao                  TYPE char1,
      gv_text                  TYPE char100,
      gv_primeiro_carreg_dados TYPE char1,
      gv_texto_unidade         TYPE char10.

*----------------------------------------------------------------------*
* Variáveis de Tela
*----------------------------------------------------------------------*
DATA: gv_radio1 TYPE char1 VALUE 'X',
      gv_radio2 TYPE char1.

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
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.                    "clique_link


  METHOD user_command.

    DATA: p_erro TYPE flag.

    CASE e_salv_function.
      WHEN 'ADM_USUARIO'.
        CLEAR: wa_usuario, gv_acao.

        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS NOT INITIAL.
*          DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
          DATA lv_qtde TYPE i.
          DESCRIBE TABLE o_rows LINES lv_qtde.
          IF lv_qtde > 1.
            MESSAGE s000(su) WITH 'Selecionar apenas um registro'(022) DISPLAY LIKE 'E'.
            RETURN.
          ENDIF.

          gv_acao = 'E'. "Editar
*          READ TABLE o_rows INTO DATA(lv_index) INDEX 1.
          DATA lv_index LIKE LINE OF o_rows.
          READ TABLE o_rows INTO lv_index INDEX 1.
          READ TABLE gt_usuario INTO wa_usuario INDEX lv_index.

        ELSE.
          gv_acao = 'I'. "Inserir
        ENDIF.

        gv_primeiro_carreg_dados = 'X'.
*        CALL SCREEN '0200' STARTING AT 15  3 ENDING AT 75 18.
*        CALL SCREEN '0200' STARTING AT 15  3 ENDING AT 77 27.
        CALL SCREEN '0200' STARTING AT 25  1 ENDING AT 87 24.
        CLEAR gv_primeiro_carreg_dados.

      WHEN 'ELI_USUARIO'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(021) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*          IF lines( o_rows ) > 1.
        CLEAR lv_qtde.
        DESCRIBE TABLE o_rows LINES lv_qtde.
        IF lv_qtde > 1.
          MESSAGE e007(/ptloms/cm001).
        ENDIF.

        PERFORM f_valida_elimina_usuario CHANGING p_erro.

        IF p_erro IS INITIAL.
          PERFORM f_deleta_usuario.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

    o_alv->refresh( ) .

  ENDMETHOD.                    "user_command

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION
