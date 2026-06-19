FUNCTION-POOL /ptloms/gf001              MESSAGE-ID sv.

* INCLUDE /PTLOMS/LGF001D...                 " Local class definition
INCLUDE lsvimdat                                . "general data decl.
INCLUDE /ptloms/lgf001t00                       . "view rel. data dcl.

CONSTANTS: BEGIN OF c_tabstrip,
             tab1  TYPE sy-ucomm VALUE 'TABSTRIP_FC1',
             tab2  TYPE sy-ucomm VALUE 'TABSTRIP_FC2',
             tab3  TYPE sy-ucomm VALUE 'TABSTRIP_FC3',
             tab4  TYPE sy-ucomm VALUE 'TABSTRIP_FC4',
             tab5  TYPE sy-ucomm VALUE 'TABSTRIP_FC5',
             tab6  TYPE sy-ucomm VALUE 'TABSTRIP_FC6',
             tab7  TYPE sy-ucomm VALUE 'TABSTRIP_FC7',
             tab8  TYPE sy-ucomm VALUE 'TABSTRIP_FC8',
             tab9  TYPE sy-ucomm VALUE 'TABSTRIP_FC9',
             tab10 TYPE sy-ucomm VALUE 'TABSTRIP_FC10',
             tab11 TYPE sy-ucomm VALUE 'TABSTRIP_FC11',
             tab12 TYPE sy-ucomm VALUE 'TABSTRIP_FC12',
             tab13 TYPE sy-ucomm VALUE 'TABSTRIP_FC13',
             tab14 TYPE sy-ucomm VALUE 'TABSTRIP_FC14',
             tab15 TYPE sy-ucomm VALUE 'TABSTRIP_FC15',
             tab16 TYPE sy-ucomm VALUE 'TABSTRIP_FC16',
             tab17 TYPE sy-ucomm VALUE 'TABSTRIP_FC17',
             tab18 TYPE sy-ucomm VALUE 'TABSTRIP_FC18',
             tab19 TYPE sy-ucomm VALUE 'TABSTRIP_FC19',
             tab20 TYPE sy-ucomm VALUE 'TABSTRIP_FC20',
           END OF c_tabstrip.

CONTROLS: tabstrip TYPE TABSTRIP.

DATA: BEGIN OF g_tabstrip,
        subscreen   TYPE sy-dynnr,
        prog        TYPE sy-repid VALUE '/PTLOMS/SAPLGF001',
        pressed_tab TYPE sy-ucomm VALUE c_tabstrip-tab1,
      END OF g_tabstrip.

* Tipo grupo de planejamento
TYPES: BEGIN OF ty_grupo_planejamento.
         INCLUDE STRUCTURE /ptloms/v002.
         TYPES: filtro_equi TYPE flag.
TYPES: filtro_locl TYPE flag,
       END OF ty_grupo_planejamento.

* Tipo área operacional
TYPES: BEGIN OF ty_area_operacional.
         INCLUDE STRUCTURE /ptloms/v003.
         TYPES: filtro_equi TYPE flag.
TYPES: filtro_locl TYPE flag,
       END OF ty_area_operacional.

* Tipo centro de trabalho
TYPES: BEGIN OF ty_centro_trabalho.
         INCLUDE STRUCTURE /ptloms/v004.
         TYPES: filtro_equi TYPE flag.
TYPES: filtro_locl TYPE flag,
       END OF ty_centro_trabalho.

* Tipo de objeto técnico
TYPES: BEGIN OF ty_tipo_objeto.
         INCLUDE STRUCTURE /ptloms/v007.
         TYPES: filtro_equi TYPE flag.
TYPES: filtro_locl TYPE flag,
       END OF ty_tipo_objeto.

* Tipo ordem
TYPES: BEGIN OF ty_tipo_ordem.
         INCLUDE STRUCTURE /ptloms/v009.
         TYPES: filtro_catalogo TYPE /ptloms/ed044,
         filtro_txt      TYPE auarttext,
       END OF ty_tipo_ordem.

* Tipo lista tarefa
TYPES: BEGIN OF ty_lista,
         plnty TYPE /ptloms/tb063-plnty,
         txt   TYPE /ptloms/tb063-txt,
         plnnr TYPE /ptloms/tb063-plnnr,
         ktext TYPE /ptloms/tb063-ktext,
         plnal TYPE /ptloms/tb063-plnal,
         zaehl TYPE /ptloms/tb063-zaehl,
         werks TYPE /ptloms/tb063-werks,
         equnr TYPE /ptloms/tb063-equnr,
         eqktx TYPE /ptloms/tb063-eqktx,
         tplnr TYPE /ptloms/tb063-tplnr,
         pltxt TYPE /ptloms/tb063-pltxt,
       END OF ty_lista.

* Tipo Autorização
TYPES: BEGIN OF ty_autorizacao,
         autorizacao      TYPE /ptloms/tb043-autorizacao,
         desc_autorizacao TYPE dd07d-ddtext,
       END OF ty_autorizacao.

* Tipo Configuração
TYPES: BEGIN OF ty_configuracao,
         configuracao      TYPE /ptloms/tb044-configuracao,
         desc_configuracao TYPE dd07d-ddtext,
       END OF ty_configuracao.

TYPES: BEGIN OF ty_status_equipamento.
         INCLUDE STRUCTURE /ptloms/tb051.
         TYPES: txt30 TYPE tj02t-txt30,
       END OF ty_status_equipamento.

TYPES: BEGIN OF ty_caract_equipamento,
         atnam TYPE cabn-atnam,
         atbez TYPE cabnt-atbez,
       END OF ty_caract_equipamento.

DATA: gv_okcode      TYPE sy-ucomm,
      gv_edit        TYPE char1,
      gv_perfil      TYPE /ptloms/ed006,
      gv_desc_perfil TYPE /ptloms/ed007.

DATA: gt_empresa_centro     TYPE STANDARD TABLE OF /ptloms/v001,
      gt_grupo_planejamento TYPE STANDARD TABLE OF ty_grupo_planejamento, "/ptloms/v002,
      gt_area_operacional   TYPE STANDARD TABLE OF ty_area_operacional,   "/ptloms/v003,
      gt_centro_trabalho    TYPE STANDARD TABLE OF ty_centro_trabalho,    "/ptloms/v004,
      gt_cat_loc_inst       TYPE STANDARD TABLE OF /ptloms/v005,
      gt_cat_equipamento    TYPE STANDARD TABLE OF /ptloms/v006,
      gt_caract_equipamento TYPE STANDARD TABLE OF /ptloms/v020,
      gt_tipo_objeto        TYPE STANDARD TABLE OF ty_tipo_objeto,        "/ptloms/v007,
      gt_tipo_nota          TYPE STANDARD TABLE OF /ptloms/v008,
      gt_tipo_ordem         TYPE STANDARD TABLE OF ty_tipo_ordem,
      gt_tipo_material      TYPE STANDARD TABLE OF /ptloms/v010,
      gt_tipo_atv_ordem     TYPE STANDARD TABLE OF /ptloms/v011,
      gt_grupo_mercadoria   TYPE STANDARD TABLE OF /ptloms/v012,
      gt_deposito           TYPE STANDARD TABLE OF /ptloms/v013,
      gt_causa_desvio       TYPE STANDARD TABLE OF /ptloms/v016,
      gt_autorizacao        TYPE STANDARD TABLE OF ty_autorizacao,
      gt_configuracao       TYPE STANDARD TABLE OF ty_configuracao,
      gt_status_inclusivo   TYPE STANDARD TABLE OF ty_status_equipamento,
      gt_status_exclusivo   TYPE STANDARD TABLE OF ty_status_equipamento,
      gt_lista              TYPE STANDARD TABLE OF ty_lista,
      gt_tb063              TYPE STANDARD TABLE OF /ptloms/tb063,
      gt_tb064              TYPE STANDARD TABLE OF /ptloms/tb064.

DATA: wa_empresa_centro     LIKE LINE OF gt_empresa_centro,
      wa_grupo_planejamento LIKE LINE OF gt_grupo_planejamento,
      wa_area_operacional   LIKE LINE OF gt_area_operacional,
      wa_centro_trabalho    LIKE LINE OF gt_centro_trabalho,
      wa_cat_loc_inst       LIKE LINE OF gt_cat_loc_inst,
      wa_cat_equipamento    LIKE LINE OF gt_cat_equipamento,
      wa_tipo_objeto        LIKE LINE OF gt_tipo_objeto,
      wa_tipo_nota          LIKE LINE OF gt_tipo_nota,
      wa_tipo_ordem         LIKE LINE OF gt_tipo_ordem,
      wa_tipo_material      LIKE LINE OF gt_tipo_material,
      wa_tipo_atv_ordem     LIKE LINE OF gt_tipo_atv_ordem,
      wa_grupo_mercadoria   LIKE LINE OF gt_grupo_mercadoria,
      wa_deposito           LIKE LINE OF gt_deposito,
      wa_causa_desvio       LIKE LINE OF gt_causa_desvio,
      wa_autorizacao        LIKE LINE OF gt_autorizacao,
      wa_configuracao       LIKE LINE OF gt_configuracao,
      wa_tb063              LIKE LINE OF gt_tb063,
      wa_tb064              LIKE LINE OF gt_tb064,
      wa_status_inclusivo   LIKE LINE OF gt_status_inclusivo,
      wa_status_exclusivo   LIKE LINE OF gt_status_exclusivo,
      gv_tipo_prioridade    TYPE t356a-artpr,
      wa_caract_equipamento LIKE LINE OF gt_caract_equipamento.

DATA lv_msg      TYPE string.

    FIELD-SYMBOLS: <fs_lista_tarefa> LIKE LINE OF gt_lista.

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

    DATA: lv_erro TYPE char1.

    IF gv_perfil IS INITIAL.
      MESSAGE s000(su) WITH 'Perfil não selecionado.'(124) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    CLEAR lv_erro.
    PERFORM f_verifica_bloqueio USING 'X' CHANGING lv_erro.
    IF lv_erro = 'X'.
      RETURN.
    ENDIF.

    CASE e_salv_function.
      WHEN 'ADM_EMP_CENTRO'.
        CLEAR wa_empresa_centro.
        CALL SCREEN '0101' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_EMP_CENTRO'.

        PERFORM f_help_cod_adm_centro USING 'X'.

      WHEN 'DEL_EMP_CENTRO'.

        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_empresa_centro.

      WHEN 'ADM_GRP_PLAN'.
        CLEAR wa_grupo_planejamento.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ELSE.
*          DESCRIBE TABLE o_rows LINES DATA(lv_qtd).
          DATA lv_qtd TYPE i.
          CLEAR lv_qtd.
          DESCRIBE TABLE o_rows LINES lv_qtd.
          IF lv_qtd > 1.
            MESSAGE s000(su) WITH 'Selecionar apenas um registro'(125) DISPLAY LIKE 'E'.
            RETURN.
          ENDIF.
        ENDIF.
*        READ TABLE o_rows INTO DATA(lv_row) INDEX 1.
        DATA lv_row  LIKE LINE OF o_rows.
        READ TABLE o_rows INTO lv_row INDEX 1.
*        READ TABLE gt_grupo_planejamento INTO DATA(ls_grupo_planejamento) INDEX lv_row.
        DATA ls_grupo_planejamento LIKE LINE OF gt_grupo_planejamento.
        READ TABLE gt_grupo_planejamento INTO ls_grupo_planejamento INDEX lv_row.
        MOVE-CORRESPONDING ls_grupo_planejamento TO wa_grupo_planejamento.
        CALL SCREEN '0111' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'EQUI_GRP_PLAN'.
        PERFORM f_filtro_equi_grp_plan.

      WHEN 'LOCL_GRP_PLAN'.
        PERFORM f_filtro_locl_grp_plan.

      WHEN 'INS_MULT_GRP_PLAN'.

        PERFORM f_help_cod_adm_centro_grp_p USING 'X'.

      WHEN 'DEL_GRP_PLAN'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_grupo_planejamento.

      WHEN 'ADM_AREA_OP'.
        CLEAR wa_area_operacional.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ELSE.
          DESCRIBE TABLE o_rows LINES lv_qtd.
          IF lv_qtd > 1.
            MESSAGE s000(su) WITH 'Selecionar apenas um registro'(125) DISPLAY LIKE 'E'.
            RETURN.
          ENDIF.
        ENDIF.
        READ TABLE o_rows INTO lv_row INDEX 1.
*        READ TABLE gt_area_operacional INTO DATA(ls_area_operacional) INDEX lv_row.
        DATA ls_area_operacional LIKE LINE OF gt_area_operacional.
        READ TABLE gt_area_operacional INTO ls_area_operacional INDEX lv_row.
        MOVE-CORRESPONDING ls_area_operacional TO wa_area_operacional.
        CALL SCREEN '0121' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_AREA_OP'.

        PERFORM f_help_cod_adm_centro_ao USING 'X'.

      WHEN 'EQUI_AREA_OP'.
        PERFORM f_filtro_equi_area_op.

      WHEN 'CATALOGO_TP_ORDEM'.

        PERFORM f_filtro_catalogo_ordem.

      WHEN 'LOCL_AREA_OP'.
        PERFORM f_filtro_locl_area_op.

      WHEN 'DEL_AREA_OP'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_area_operacional.

      WHEN 'ADM_CENTRO_TRAB'.
        CLEAR wa_centro_trabalho.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ELSE.
          DESCRIBE TABLE o_rows LINES lv_qtd.
          IF lv_qtd > 1.
            MESSAGE s000(su) WITH 'Selecionar apenas um registro'(125) DISPLAY LIKE 'E'.
            RETURN.
          ENDIF.
        ENDIF.
        READ TABLE o_rows INTO lv_row INDEX 1.
*        READ TABLE gt_centro_trabalho INTO DATA(ls_centro_trabalho) INDEX lv_row.
        DATA ls_centro_trabalho LIKE LINE OF gt_centro_trabalho.
        READ TABLE gt_centro_trabalho INTO ls_centro_trabalho INDEX lv_row.
        MOVE-CORRESPONDING ls_centro_trabalho TO wa_centro_trabalho.
        CALL SCREEN '0131' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_CENTRO_TRAB'.

        PERFORM f_help_cod_adm_objid USING 'X'.

      WHEN 'EQUI_CENTRO_TRAB'.
        PERFORM f_filtro_equi_centro_trab.

      WHEN 'LOCL_CENTRO_TRAB'.
        PERFORM f_filtro_locl_centro_trab.

      WHEN 'DEL_CENTRO_TRAB'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_centro_trabalho.

      WHEN 'ADM_CAT_LOCL'.
        CLEAR wa_cat_loc_inst.
        CALL SCREEN '0141' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_CAT_LOCL'.

        PERFORM f_help_cod_adm_fltyp USING 'X'.

      WHEN 'DEL_CAT_LOCL' .
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_cat_loc_inst.

      WHEN 'ADM_CAT_EQUI'.
        CLEAR wa_cat_equipamento.
        CALL SCREEN '0151' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_CAT_EQUI'.

        PERFORM f_help_cod_adm_eqtyp USING 'X'.

      WHEN 'DEL_CAT_EQUI'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_cat_equipamento.

      WHEN 'INS_MULT_STATUS_INCLUSIVO'.

        PERFORM f_help_status_inclusivo USING 'X'.

      WHEN 'DEL_STATUS_INCLUSIVO'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_status_inclusivo.

      WHEN 'INS_MULT_STATUS_EXCLUSIVO'.

        PERFORM f_help_status_exclusivo USING 'X'.

      WHEN 'DEL_STATUS_EXCLUSIVO'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_status_exclusivo.

      WHEN 'ADM_TP_OBJ'.
        CLEAR wa_tipo_objeto.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ELSE.
          DESCRIBE TABLE o_rows LINES lv_qtd.
          IF lv_qtd > 1.
            MESSAGE s000(su) WITH 'Selecionar apenas um registro'(125) DISPLAY LIKE 'E'.
            RETURN.
          ENDIF.
        ENDIF.
        READ TABLE o_rows INTO lv_row INDEX 1.
*        READ TABLE gt_tipo_objeto INTO DATA(ls_tipo_objeto) INDEX lv_row.
        DATA ls_tipo_objeto LIKE LINE OF gt_tipo_objeto.
        READ TABLE gt_tipo_objeto INTO ls_tipo_objeto INDEX lv_row.
        MOVE-CORRESPONDING ls_tipo_objeto TO wa_tipo_objeto.
        CALL SCREEN '0161' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_TP_OBJ'.

        PERFORM f_help_cod_adm_eqart USING 'X'.

      WHEN 'EQUI_TP_OBJ'.
        PERFORM f_filtro_equi_tp_obj.

      WHEN 'LOCL_TP_OBJ'.
        PERFORM f_filtro_locl_tp_obj.

      WHEN 'DEL_TP_OBJ'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_tipo_objeto.

      WHEN 'ADM_TP_NOTA'.
        CLEAR wa_tipo_nota.
        CALL SCREEN '0171' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_TP_NOTA'.

        PERFORM f_help_cod_adm_qmart USING 'X'.

      WHEN 'DEL_TP_NOTA'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_tipo_nota.

      WHEN 'ADM_TP_ORDEM'.
        CLEAR wa_tipo_ordem.
        CALL SCREEN '0181' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_TP_ORDEM'.

        PERFORM f_help_cod_adm_auart USING 'X'.

      WHEN 'DEL_TP_ORDEM'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_tipo_ordem.

      WHEN 'ADM_TIPO_MAT'.
        CLEAR wa_tipo_material.
        CALL SCREEN '0191' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_TP_MAT'.

        PERFORM f_help_cod_adm_mtart USING 'X'.

      WHEN 'DEL_TIPO_MAT'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_tipo_material.

      WHEN 'ADM_TP_ATV_ORDEM'.
        CLEAR wa_tipo_atv_ordem.
        CALL SCREEN '0201' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_ATV_ORDEM'.

        PERFORM f_help_cod_adm_ilart USING 'X'.

      WHEN 'DEL_TP_ATV_ORDEM'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_tipo_atv_ordem.

      WHEN 'ADM_GRP_MERC'.
        CLEAR wa_grupo_mercadoria.
        CALL SCREEN '0211' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_GRP_MERC'.

        PERFORM f_help_cod_adm_matkl USING 'X'.

      WHEN 'DEL_GRP_MERC'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_grupo_mercadoria.

      WHEN 'ADM_DEPOSITO'.
        CLEAR wa_deposito.
        CALL SCREEN '0221' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_DEPOSITO'.

        PERFORM f_help_cod_adm_lgort USING 'X'.

      WHEN 'DEL_DEPOSITO'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_deposito.

      WHEN 'ADM_CAUSA_DESVIO'.
        CLEAR wa_causa_desvio.
        CALL SCREEN '0231' STARTING AT 15  3 ENDING AT 85 10.

      WHEN 'INS_MULT_CAUSA_DESVIO'.

        PERFORM f_help_cod_adm_grund USING 'X'.

      WHEN 'DEL_CAUSA_DESVIO'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_causa_desvio.

      WHEN 'INS_MULT_AUTORIZACAO'.

        PERFORM f_help_cod_adm_autoriz USING 'X'.

      WHEN 'DEL_AUTORIZACAO'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_autorizacao.

      WHEN 'INS_MULT_CONFIGURACAO'.

        PERFORM f_help_cod_adm_config USING 'X'.

      WHEN 'DEL_CONFIGURACAO'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_configuracao.

      WHEN 'INS_MULT_LISTA_TAREFA'.

        PERFORM f_help_lista_tarefa USING 'X'.

      WHEN 'DEL_LISTA_TAREFA'.
        o_rows = o_selections->get_selected_rows( ).
        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_lista_tarefa.

      WHEN 'INS_MULT_CARACT'.

        PERFORM f_help_cod_adm_caract USING 'X'.

      WHEN 'DEL_CARACT'.

        o_rows = o_selections->get_selected_rows( ).

        IF o_rows[] IS INITIAL.
          MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

        PERFORM f_deleta_caracteristica.

      WHEN OTHERS.

    ENDCASE.

    o_alv->refresh( ) .

  ENDMETHOD.                    "user_command

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION
