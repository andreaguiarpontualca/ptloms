*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGF001F01.
*----------------------------------------------------------------------*
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

*&---------------------------------------------------------------------*
*&      Form  F_HELP_V001
*&---------------------------------------------------------------------*
FORM f_help_v001.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           bukrs TYPE t001-bukrs,
           butxt TYPE t001-butxt,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: lt_tab            TYPE STANDARD TABLE OF ty_tab,
        lt_return         TYPE STANDARD TABLE OF ddshretval,
        lt_empresa_centro TYPE /ptloms/ct006,
        lt_dynpfields     TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_tabix          TYPE sy-tabix,
        lv_tc_actual_line TYPE i,
        lv_tc_actual_c    TYPE c LENGTH 10.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = 'X'
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_empresa_centro          = lt_empresa_centro ).

*  SELECT a~bukrs, a~butxt, c~werks, c~name1
*    FROM t001 AS a INNER JOIN t001k AS b ON a~bukrs = b~bukrs
*    INNER JOIN t001w AS c ON b~bwkey = c~bwkey
*    INTO CORRESPONDING FIELDS OF TABLE @lt_empresa_centro.

*  LOOP AT lt_empresa_centro INTO DATA(ls_empresa_centro).
  DATA ls_empresa_centro LIKE LINE OF lt_empresa_centro.
  LOOP AT lt_empresa_centro INTO ls_empresa_centro.

    READ TABLE gt_empresa_centro TRANSPORTING NO FIELDS WITH KEY bukrs  = ls_empresa_centro-bukrs
                                                                 werks  = ls_empresa_centro-werks.
    IF sy-subrc EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_empresa_centro TO ls_tab.
    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      CLEAR lv_tabix.

      " --- Atribui valor ao campo da tela
      REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
      MOVE ls_return-fieldval TO lv_tabix.

      READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

      MOVE lv_tc_actual_line TO lv_tc_actual_c.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_tc_actual_c
        IMPORTING
          output = lv_tc_actual_c.

      /ptloms/v001-bukrs = ls_tab-bukrs.
*      DATA(lv_nome_campo) = '/PTLOMS/V001-BUKRS(' && lv_tc_actual_line && ')'.
      DATA lv_nome_campo TYPE string.
      CONCATENATE '/PTLOMS/V001-BUKRS(' lv_tc_actual_c ')'
                INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v001-bukrs.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v001-butxt = ls_tab-butxt.
*      lv_nome_campo = '/PTLOMS/V001-BUTXT(' && lv_tc_actual_line && ')'.
      CONCATENATE '/PTLOMS/V001-BUTXT(' lv_tc_actual_c ')'
                INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v001-butxt.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v001-werks = ls_tab-werks.
*      lv_nome_campo = '/PTLOMS/V001-WERKS(' && lv_tc_actual_line && ')'.
      CONCATENATE '/PTLOMS/V001-WERKS(' lv_tc_actual_c ')'
                INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v001-werks.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v001-name1 = ls_tab-name1.
*      lv_nome_campo = '/PTLOMS/V001-NAME1(' && lv_tc_actual_line && ')'.
      CONCATENATE '/PTLOMS/V001-NAME1(' lv_tc_actual_c ')'
                INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v001-name1.
      APPEND ls_dynpfields TO lt_dynpfields.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_BUKRS
*&---------------------------------------------------------------------*
FORM f_help_cod_bukrs.

  TYPES: BEGIN OF ty_tab,
           bukrs TYPE t001-bukrs,
           butxt TYPE t001-butxt,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: lt_tab            TYPE STANDARD TABLE OF ty_tab,
        lt_return         TYPE STANDARD TABLE OF ddshretval,
        lt_empresa_centro TYPE /ptloms/ct006.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = 'X'
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_empresa_centro          = lt_empresa_centro ).

*  SELECT a~bukrs, a~butxt, c~werks, c~name1
*    FROM t001 AS a INNER JOIN t001k AS b ON a~bukrs = b~bukrs
*    INNER JOIN t001w AS c ON b~bwkey = c~bwkey
*    INTO CORRESPONDING FIELDS OF TABLE @lt_empresa_centro.

  IF /ptloms/v001-werks IS NOT INITIAL.
    DELETE lt_empresa_centro WHERE werks NE /ptloms/v001-werks.
  ENDIF.

*  LOOP AT lt_empresa_centro INTO DATA(ls_empresa_centro).
  DATA ls_empresa_centro LIKE LINE OF lt_empresa_centro.
  LOOP AT lt_empresa_centro INTO ls_empresa_centro.

    READ TABLE gt_empresa_centro TRANSPORTING NO FIELDS WITH KEY bukrs  = ls_empresa_centro-bukrs
                                                                 werks  = ls_empresa_centro-werks.
    IF  sy-subrc EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_empresa_centro TO ls_tab.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'BUKRS'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v001-bukrs = ls_return-fieldval.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_WERKS
*&---------------------------------------------------------------------*
FORM f_help_cod_werks.

  TYPES: BEGIN OF ty_tab,
           bukrs TYPE t001-bukrs,
           butxt TYPE t001-butxt,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: lt_tab            TYPE STANDARD TABLE OF ty_tab,
        lt_return         TYPE STANDARD TABLE OF ddshretval,
        lt_empresa_centro TYPE /ptloms/ct006.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = 'X'
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_empresa_centro          = lt_empresa_centro ).

*  SELECT a~bukrs, a~butxt, c~werks, c~name1
*    FROM t001 AS a INNER JOIN t001k AS b ON a~bukrs = b~bukrs
*    INNER JOIN t001w AS c ON b~bwkey = c~bwkey
*    INTO CORRESPONDING FIELDS OF TABLE @lt_empresa_centro.

  IF /ptloms/v001-bukrs IS NOT INITIAL.
    DELETE lt_empresa_centro WHERE bukrs NE /ptloms/v001-bukrs.
  ENDIF.

*  LOOP AT lt_empresa_centro INTO DATA(ls_empresa_centro).
  DATA ls_empresa_centro LIKE LINE OF lt_empresa_centro.
  LOOP AT lt_empresa_centro INTO ls_empresa_centro.

    READ TABLE gt_empresa_centro TRANSPORTING NO FIELDS WITH KEY bukrs  = ls_empresa_centro-bukrs
                                                                 werks  = ls_empresa_centro-werks.
    IF  sy-subrc EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_empresa_centro TO ls_tab.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'WERKS'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v001-werks = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_IWERK
*&---------------------------------------------------------------------*
FORM f_help_cod_iwerk .

  TYPES: BEGIN OF ty_tab,
           iwerk TYPE t024i-iwerk,
           name1 TYPE t001w-name1,
           ingrp TYPE t024i-ingrp,
           innam TYPE t024i-innam,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab                TYPE STANDARD TABLE OF ty_tab,
        lt_return             TYPE STANDARD TABLE OF ddshretval,
        lt_grupo_planejamento TYPE /ptloms/ct007.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA:
    lt_tb002 TYPE TABLE OF /ptloms/tb002,
    ls_002   TYPE /ptloms/tb002.
  SELECT *
    FROM /ptloms/tb002
    INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
    DATA:
      lt_t001w TYPE TABLE OF  t001w,
      ls_t001w TYPE t001w.
    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = 'X'
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_grupo_planejamento      = lt_grupo_planejamento ).

*  SELECT iwerk, ingrp, innam
*    FROM t024i
*    INTO CORRESPONDING FIELDS OF TABLE @lt_grupo_planejamento.

  IF /ptloms/v002-ingrp IS NOT INITIAL.
    DELETE lt_grupo_planejamento WHERE ingrp NE /ptloms/v002-ingrp.
  ENDIF.

*  LOOP AT lt_grupo_planejamento INTO DATA(ls_grupo_planejamento).
  DATA ls_grupo_planejamento LIKE LINE OF lt_grupo_planejamento.
  LOOP AT lt_grupo_planejamento INTO ls_grupo_planejamento.

    READ TABLE gt_grupo_planejamento TRANSPORTING NO FIELDS WITH KEY ingrp  = ls_grupo_planejamento-ingrp.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_grupo_planejamento-iwerk.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_grupo_planejamento TO ls_tab.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'IWERK'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v002-iwerk = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_INGRP
*&---------------------------------------------------------------------*
FORM f_help_cod_ingrp .

  TYPES: BEGIN OF ty_tab,
           iwerk TYPE t024i-iwerk,
           name1 TYPE t001w-name1,
           ingrp TYPE t024i-ingrp,
           innam TYPE t024i-innam,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab                TYPE STANDARD TABLE OF ty_tab,
        lt_return             TYPE STANDARD TABLE OF ddshretval,
        lt_grupo_planejamento TYPE /ptloms/ct007.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

* Busca todos os Empresas/Centro cadastrados
**  SELECT *
**    FROM /ptloms/tb002
**    INTO TABLE @DATA(lt_tb002)
**    WHERE bukrs IN @r_bukrs.

  DATA:
    lt_tb002 TYPE TABLE OF /ptloms/tb002,
    ls_tb002 TYPE /ptloms/tb002.
  SELECT *
              FROM /ptloms/tb002
        INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = 'X'
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_grupo_planejamento      = lt_grupo_planejamento ).

*  SELECT iwerk, ingrp, innam
*    FROM t024i
*    INTO CORRESPONDING FIELDS OF TABLE @lt_grupo_planejamento.

  IF /ptloms/v002-iwerk IS NOT INITIAL.
    DELETE lt_grupo_planejamento WHERE iwerk NE /ptloms/v002-iwerk.
  ENDIF.

*  LOOP AT lt_grupo_planejamento INTO DATA(ls_grupo_planejamento).
  DATA ls_grupo_planejamento LIKE LINE OF lt_grupo_planejamento.
  LOOP AT lt_grupo_planejamento INTO ls_grupo_planejamento.

    READ TABLE gt_grupo_planejamento TRANSPORTING NO FIELDS WITH KEY ingrp  = ls_grupo_planejamento-ingrp.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    READ TABLE lt_tb002 TRANSPORTING NO FIELDS
    WITH KEY werks = ls_grupo_planejamento-iwerk.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_grupo_planejamento TO ls_tab.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'INGRP'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v002-ingrp = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_WERKS_2
*&---------------------------------------------------------------------*
FORM f_help_cod_werks_2 .

  TYPES: BEGIN OF ty_tab,
           werks TYPE t357-werks,
           name1 TYPE t001w-name1,
           beber TYPE t357-beber,
           fing  TYPE t357-fing,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab              TYPE STANDARD TABLE OF ty_tab,
        lt_return           TYPE STANDARD TABLE OF ddshretval,
        lt_area_operacional TYPE /ptloms/ct008.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA:
    lt_tb002 TYPE TABLE OF /ptloms/tb002,
    ls_tb002 TYPE /ptloms/tb002.
  SELECT *
    FROM /ptloms/tb002
    INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = 'X'
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_area_operacional        = lt_area_operacional ).

  IF /ptloms/v003-beber IS NOT INITIAL.
    DELETE lt_area_operacional WHERE beber NE /ptloms/v003-beber.
  ENDIF.

*  LOOP AT lt_area_operacional INTO DATA(ls_area_operacional).
  DATA ls_area_operacional LIKE LINE OF lt_area_operacional.
  LOOP AT lt_area_operacional INTO ls_area_operacional.

*    READ TABLE lt_tb002 INTO DATA(ls_002)
    DATA ls_002 LIKE LINE OF lt_tb002.
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_area_operacional-werks.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_area_operacional TO ls_tab.

*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'WERKS'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v003-werks = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_BEBER
*&---------------------------------------------------------------------*
FORM f_help_cod_beber.

  TYPES: BEGIN OF ty_tab,
           werks TYPE t357-werks,
           name1 TYPE t001w-name1,
           beber TYPE t357-beber,
           fing  TYPE t357-fing,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab              TYPE STANDARD TABLE OF ty_tab,
        lt_return           TYPE STANDARD TABLE OF ddshretval,
        lt_area_operacional TYPE /ptloms/ct008.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA lt_tb002 TYPE TABLE OF /ptloms/tb002.
  DATA ls_002 TYPE /ptloms/tb002.
  SELECT *
    FROM /ptloms/tb002
    INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.

    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = 'X'
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_area_operacional        = lt_area_operacional ).

  IF /ptloms/v003-werks IS NOT INITIAL.
    DELETE lt_area_operacional WHERE werks NE /ptloms/v003-werks.
  ENDIF.

*  LOOP AT lt_area_operacional INTO DATA(ls_area_operacional).
  DATA ls_area_operacional LIKE LINE OF lt_area_operacional.
  LOOP AT lt_area_operacional INTO ls_area_operacional.
*    READ TABLE lt_tb002 INTO DATA(ls_002)
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_area_operacional-werks.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_area_operacional TO ls_tab.

*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'BEBER'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v003-beber = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_OBJID
*&---------------------------------------------------------------------*
FORM f_help_cod_objid .

  TYPES: BEGIN OF ty_tab,
           objid TYPE crhd-objid,
           arbpl TYPE crhd-arbpl,
           werks TYPE crhd-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab             TYPE STANDARD TABLE OF ty_tab,
        lt_return          TYPE STANDARD TABLE OF ddshretval,
        lt_centro_trabalho TYPE /ptloms/ct009.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA:
    lt_tb002 TYPE TABLE OF /ptloms/tb002,
    ls_002   TYPE /ptloms/tb002.
  SELECT *
    FROM /ptloms/tb002
    INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = 'X'
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_centro_trabalho         = lt_centro_trabalho ).

  IF /ptloms/v004-werks IS NOT INITIAL.
    DELETE lt_centro_trabalho WHERE werks NE /ptloms/v004-werks.
  ENDIF.

*  LOOP AT lt_centro_trabalho INTO DATA(ls_centro_trabalho).
  DATA ls_centro_trabalho LIKE LINE OF lt_centro_trabalho.
  LOOP AT lt_centro_trabalho INTO ls_centro_trabalho.
*    READ TABLE lt_tb002 INTO DATA(ls_002)
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_centro_trabalho-werks.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_centro_trabalho TO ls_tab.

*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'OBJID'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v004-objid = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_WERKS_3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_help_cod_werks_3 .

  TYPES: BEGIN OF ty_tab,
           objid TYPE crhd-objid,
           arbpl TYPE crhd-arbpl,
           werks TYPE crhd-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab             TYPE STANDARD TABLE OF ty_tab,
        lt_return          TYPE STANDARD TABLE OF ddshretval,
        lt_centro_trabalho TYPE /ptloms/ct009.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.
  DATA:
    lt_tb002 TYPE TABLE OF /ptloms/tb002,
    ls_002   TYPE /ptloms/tb002.

  SELECT *
    FROM /ptloms/tb002
    INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = 'X'
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_centro_trabalho         = lt_centro_trabalho ).

  IF /ptloms/v004-objid IS NOT INITIAL.
    DELETE lt_centro_trabalho WHERE objid NE /ptloms/v004-objid.
  ENDIF.

*  LOOP AT lt_centro_trabalho INTO DATA(ls_centro_trabalho).
  DATA ls_centro_trabalho LIKE LINE OF lt_centro_trabalho.
  LOOP AT lt_centro_trabalho INTO ls_centro_trabalho.
*    READ TABLE lt_tb002 INTO DATA(ls_002)
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_centro_trabalho-werks.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_centro_trabalho TO ls_tab.

*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'WERKS'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v004-werks = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_FLTYP
*&---------------------------------------------------------------------*
FORM f_help_cod_fltyp .

  TYPES: BEGIN OF ty_tab,
           fltyp TYPE t370f-fltyp,
           typtx TYPE t370f_t-typtx,
         END OF ty_tab.

  DATA: lt_tab                TYPE STANDARD TABLE OF ty_tab,
        lt_return             TYPE STANDARD TABLE OF ddshretval,
        lt_categoria_loc_inst TYPE /ptloms/ct040.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = 'X'
    IMPORTING
      et_categoria_loc_inst         = lt_categoria_loc_inst ).

*  LOOP AT lt_categoria_loc_inst INTO DATA(ls_categoria_loc_inst).
  DATA ls_categoria_loc_inst LIKE LINE OF lt_categoria_loc_inst.
  LOOP AT lt_categoria_loc_inst INTO ls_categoria_loc_inst.

    READ TABLE gt_cat_loc_inst TRANSPORTING NO FIELDS WITH KEY fltyp  = ls_categoria_loc_inst-fltyp.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_categoria_loc_inst TO ls_tab.
    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'FLTYP'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v005-fltyp = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_QMART
*&---------------------------------------------------------------------*
FORM f_help_cod_qmart .

  TYPES: BEGIN OF ty_tab,
           qmart  TYPE tq80-qmart,
           qmtyp  TYPE tq80-qmtyp,
           rbnr   TYPE tq80-rbnr,
           qmartx TYPE tq80_t-qmartx,
         END OF ty_tab.

  DATA: lt_tab       TYPE STANDARD TABLE OF ty_tab,
        lt_return    TYPE STANDARD TABLE OF ddshretval,
        lt_tipo_nota TYPE /ptloms/ct010.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = 'X'
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_tipo_nota               = lt_tipo_nota ).

*  LOOP AT lt_tipo_nota INTO DATA(ls_tipo_nota).
  DATA ls_tipo_nota LIKE LINE OF lt_tipo_nota.
  LOOP AT lt_tipo_nota INTO ls_tipo_nota.

    READ TABLE gt_tipo_nota TRANSPORTING NO FIELDS WITH KEY qmart  = ls_tipo_nota-qmart.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_tipo_nota TO ls_tab.
    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'QMART'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      /ptloms/v008-qmart = ls_return-fieldval.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB002
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb002.

  DATA: r_iwerk TYPE RANGE OF /ptloms/tb003-iwerk,
        r_werks TYPE RANGE OF /ptloms/tb004-werks.

  DATA: lt_empresa_centro TYPE /ptloms/ct006.

  DATA: lwa_row TYPE /ptloms/tb002.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

* Busca todos os CentroPlan./GrupoPlan. cadastrados
*  SELECT *
*    FROM /ptloms/tb003
*    INTO TABLE @DATA(lt_tb003)
*    WHERE iwerk IN @r_iwerk.

  DATA lt_tb003 TYPE TABLE OF /ptloms/tb003.
  DATA ls_003 TYPE /ptloms/tb003.
  SELECT *
    FROM /ptloms/tb003
    INTO TABLE lt_tb003
    WHERE iwerk IN r_iwerk.

* Busca todas Áreas Operacionais cadastradas
*  SELECT *
*    FROM /ptloms/tb004
*    INTO TABLE @DATA(lt_tb004)
*    WHERE werks IN @r_werks.

  DATA lt_tb004 TYPE TABLE OF /ptloms/tb004.
  DATA ls_004 TYPE /ptloms/tb004.
  SELECT *
    FROM /ptloms/tb004
    INTO TABLE lt_tb004
    WHERE werks IN r_werks.

* Busca todos Centros de Trabalho
*  SELECT *
*    FROM /ptloms/tb005
*    INTO TABLE @DATA(lt_tb005)
*    WHERE werks IN @r_werks.

  DATA lt_tb005 TYPE TABLE OF /ptloms/tb005.
  DATA ls_005 TYPE /ptloms/tb005.
  SELECT *
    FROM /ptloms/tb005
    INTO TABLE lt_tb005
    WHERE werks IN r_werks.

* Busca Empresas/Centro cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb014
*    INTO TABLE @DATA(lt_tb014).

  DATA lt_tb014 TYPE TABLE OF /ptloms/tb014.
  DATA ls_014 TYPE /ptloms/tb014.
  SELECT *
    FROM /ptloms/tb014
    INTO TABLE lt_tb014.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = 'X'
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_empresa_centro          = lt_empresa_centro ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        " Verifica se Empresa/Centro é válida
        READ TABLE lt_empresa_centro TRANSPORTING NO FIELDS
        WITH KEY bukrs = lwa_row-bukrs werks = lwa_row-werks.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Empresa/Centro: | && lwa_row-bukrs &&
***                         |/| && lwa_row-werks && | inválido|.
          CONCATENATE 'Empresa/Centro:'(073) lwa_row-bukrs '/' lwa_row-werks 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.

      ENDIF.

      IF <action> EQ 'D'.

        " Verifica se registro já foi utilizado. Se sim, não pode remover

        " Verifica na tabela /PTLOMS/TB003
*        READ TABLE lt_tb003 INTO DATA(ls_003)
        READ TABLE lt_tb003 INTO ls_003
        WITH KEY iwerk = lwa_row-werks.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Centro | && lwa_row-werks &&
***                   | utilizado no grupo de planejamento | && ls_003-ingrp.
          CONCATENATE 'Centro'(003) lwa_row-werks 'utilizado no grupo de planejamento'(075) ls_003-ingrp INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.

        " Verifica na tabela /PTLOMS/TB004
*        READ TABLE lt_tb004 INTO DATA(ls_004)
        READ TABLE lt_tb004 INTO ls_004
        WITH KEY werks = lwa_row-werks.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Centro | && lwa_row-werks &&
***                   | utilizado no Área Operacional | && ls_004-beber.
          CONCATENATE 'Centro'(003) lwa_row-werks 'utilizado na Área Operacional'(076) ls_004-beber INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.

        " Verifica na tabela /PTLOMS/TB005
*        READ TABLE lt_tb005 INTO DATA(ls_005)
        READ TABLE lt_tb005 INTO ls_005
        WITH KEY werks = lwa_row-werks.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Centro | && lwa_row-werks &&
***                   | utilizado no Cen.Trab. | && ls_005-objid.
          CONCATENATE 'Centro'(003) lwa_row-werks 'utilizado no Cen.Trab.'(077) ls_005-objid INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.

        " Verifica na tabela /PTLOMS/TB014
*        READ TABLE lt_tb014 INTO DATA(ls_014)
        READ TABLE lt_tb014 INTO ls_014
        WITH KEY bukrs = lwa_row-bukrs
                 werks = lwa_row-werks.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Empresa/Centro | && lwa_row-bukrs && |/| && lwa_row-werks &&
***                   | utilizado no Perfil | && ls_014-perfil.
          CONCATENATE 'Empresa/Centro'(078) lwa_row-bukrs '/' lwa_row-werks 'utilizado no Perfil'(079) ls_014-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB003
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb003.

  DATA: lt_grupo_planejamento TYPE /ptloms/ct007.

  DATA: lwa_row TYPE /ptloms/tb003.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

* Busca Grupo de Planejamento cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb015
*    INTO TABLE @DATA(lt_tb015).

  DATA lt_tb015 TYPE TABLE OF /ptloms/tb015.
  DATA ls_015 TYPE /ptloms/tb015.
  SELECT *
    FROM /ptloms/tb015
    INTO TABLE lt_tb015.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = 'X'
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_grupo_planejamento      = lt_grupo_planejamento ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE lt_grupo_planejamento TRANSPORTING NO FIELDS
        WITH KEY iwerk = lwa_row-iwerk ingrp = lwa_row-ingrp.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Centro/Grp.Plan.: | && lwa_row-iwerk &&
***                         |/| && lwa_row-ingrp && | inválido|.
          CONCATENATE 'Centro/Grp.Plan.:'(080) lwa_row-iwerk '/' lwa_row-ingrp 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB015
*        READ TABLE lt_tb015 INTO DATA(ls_015)
        READ TABLE lt_tb015 INTO ls_015
        WITH KEY iwerk = lwa_row-iwerk
                 ingrp = lwa_row-ingrp.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Centro/Grp.Plan | && lwa_row-iwerk && |/| && lwa_row-ingrp &&
***                   | utilizado no Perfil | && ls_015-perfil.
          CONCATENATE 'Centro/Grp.Plan.'(081)  lwa_row-iwerk '/' lwa_row-ingrp 'utilizado no Perfil'(079) ls_015-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB004
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb004.

  DATA: lt_area_operacional TYPE /ptloms/ct008.

  DATA: lwa_row TYPE /ptloms/tb004.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

** Busca Área Operacional cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb016
*    INTO TABLE @DATA(lt_tb016).

  DATA lt_tb016 TYPE TABLE OF /ptloms/tb016.
  DATA ls_016 TYPE /ptloms/tb016.
  SELECT *
    FROM /ptloms/tb016
    INTO TABLE lt_tb016.

*  SELECT werks, beber, fing
*    FROM t357
*    INTO CORRESPONDING FIELDS OF TABLE @lt_area_operacional.

  SELECT werks beber fing
    FROM t357
    INTO CORRESPONDING FIELDS OF TABLE lt_area_operacional.

*  CREATE OBJECT o_oms.
*
*  o_oms->out_demais_dados_mestres(
*    EXPORTING
*      im_empresa_centro          = ''
*      im_grupo_planejamento      = ''
*      im_area_operacional        = 'X'
*      im_centro_trabalho         = ''
*      im_tipo_nota               = ''
*      im_tipo_ordem              = ''
*      im_tipo_prioridade_ordem   = ''
*      im_tipo_prioridade_nota    = ''
*      im_tipo_atv_manutencao     = ''
*      im_centro_custo            = ''
*      im_condicao_inst_ordem     = ''
*      im_tipo_atv_operacao       = ''
*      im_tipo_material           = ''
*      im_categoria_item_material = ''
*      im_deposito                = ''
*      im_categoria_equipamento   = ''
*      im_tipo_objeto             = ''
*      im_categoria_loc_inst      = ''
*    IMPORTING
*      et_area_operacional        = lt_area_operacional ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE lt_area_operacional TRANSPORTING NO FIELDS
        WITH KEY werks = lwa_row-werks beber = lwa_row-beber.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Centro/Área.Oper.: | && lwa_row-werks &&
***                         |/| && lwa_row-beber && | inválido|.
          CONCATENATE 'Centro/Área.Oper.:'(082) lwa_row-werks '/' lwa_row-beber 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB016
*        READ TABLE lt_tb016 INTO DATA(ls_016)
        READ TABLE lt_tb016 INTO ls_016
        WITH KEY werks = lwa_row-werks
                 beber = lwa_row-beber.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Centro/Área Oper. | && lwa_row-werks && |/| && lwa_row-beber &&
***                   | utilizado no Perfil | && ls_016-perfil.
          CONCATENATE 'Centro/Área.Oper.:'(082) lwa_row-werks '/' lwa_row-beber 'utilizado no Perfil'(079) ls_016-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB005
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb005.

  DATA: lt_centro_trabalho TYPE /ptloms/ct009.

  DATA: lwa_row TYPE /ptloms/tb005.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

* Busca Centro de Trabalho cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb017
*    INTO TABLE @DATA(lt_tb017).

  DATA lt_tb017 TYPE TABLE OF /ptloms/tb017.
  DATA ls_017 TYPE /ptloms/tb017.
  SELECT *
    FROM /ptloms/tb017
    INTO TABLE lt_tb017.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = 'X'
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_centro_trabalho         = lt_centro_trabalho ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE lt_centro_trabalho TRANSPORTING NO FIELDS
        WITH KEY objid = lwa_row-objid werks = lwa_row-werks.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Cen.Trab./Centro: | && lwa_row-objid &&
***                         |/| && lwa_row-werks && | inválido|.
          CONCATENATE 'Cen.Trab./Centro:'(083) lwa_row-objid '/' lwa_row-werks  'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB017
*        READ TABLE lt_tb017 INTO DATA(ls_017)
        READ TABLE lt_tb017 INTO ls_017
        WITH KEY objid = lwa_row-objid
                 werks = lwa_row-werks.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |C.Trab./Cent. | && lwa_row-objid && |/| && lwa_row-werks &&
***                   | utilizado no Perfil | && ls_017-perfil.
          CONCATENATE 'Cen.Trab./Centro:'(083) lwa_row-objid '/' lwa_row-werks  'utilizado no Perfil'(079) ls_017-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB006
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb006.

  DATA: lt_categoria_loc_inst TYPE /ptloms/ct040.

  DATA: lwa_row TYPE /ptloms/tb006.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

* Busca Categoria de Local de Instalação cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb018
*    INTO TABLE @DATA(lt_tb018).

  DATA lt_tb018 TYPE TABLE OF /ptloms/tb018.
  DATA ls_018 TYPE /ptloms/tb018.
  SELECT *
    FROM /ptloms/tb018
    INTO TABLE lt_tb018.

*  SELECT fltyp FROM t370f
*    INTO TABLE @DATA(lt_cat_local)
*    WHERE fltyp NE ''.

  DATA lt_cat_local TYPE TABLE OF t370f.
  DATA ls_cat_local TYPE t370f.
  SELECT fltyp FROM t370f
    INTO CORRESPONDING FIELDS OF TABLE lt_cat_local
    WHERE fltyp NE ''.

*  CREATE OBJECT o_oms.
*
*  o_oms->out_demais_dados_mestres(
*    EXPORTING
*      im_empresa_centro          = ''
*      im_grupo_planejamento      = ''
*      im_area_operacional        = ''
*      im_centro_trabalho         = ''
*      im_tipo_nota               = ''
*      im_tipo_ordem              = ''
*      im_tipo_prioridade_ordem   = ''
*      im_tipo_prioridade_nota    = ''
*      im_tipo_atv_manutencao     = ''
*      im_centro_custo            = ''
*      im_condicao_inst_ordem     = ''
*      im_tipo_atv_operacao       = ''
*      im_tipo_material           = ''
*      im_categoria_item_material = ''
*      im_deposito                = ''
*      im_categoria_equipamento   = ''
*      im_tipo_objeto             = ''
*      im_categoria_loc_inst      = 'X'
*    IMPORTING
*      et_categoria_loc_inst      = lt_categoria_loc_inst ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE lt_cat_local TRANSPORTING NO FIELDS
        WITH KEY fltyp = lwa_row-fltyp.

*        READ TABLE lt_categoria_loc_inst TRANSPORTING NO FIELDS
*        WITH KEY fltyp = lwa_row-fltyp.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Catg.Loc.Inst: | && lwa_row-fltyp &&
***                         | inválido|.
          CONCATENATE 'Categ.Loc.Inst:'(084) lwa_row-fltyp 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB018
*        READ TABLE lt_tb018 INTO DATA(ls_018)
        READ TABLE lt_tb018 INTO ls_018
        WITH KEY fltyp = lwa_row-fltyp.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Cat.Loc.Inst. | && lwa_row-fltyp &&
***                   | utilizado no Perfil | && ls_018-perfil.
          CONCATENATE 'Categ.Loc.Inst:'(084) lwa_row-fltyp 'utilizado no Perfil'(079) ls_018-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB007
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb007.

  DATA: lt_categoria_equipamento TYPE /ptloms/ct034.

  DATA: lwa_row TYPE /ptloms/tb007.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

* Busca Categoria de Equipamento cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb019
*    INTO TABLE @DATA(lt_tb019).

  DATA lt_tb019 TYPE TABLE OF /ptloms/tb019.
  DATA ls_019 TYPE /ptloms/tb019.
  SELECT *
    FROM /ptloms/tb019
    INTO TABLE lt_tb019.

*  SELECT eqtyp
*    FROM t370t
*    INTO TABLE @DATA(lt_t370t)
*    WHERE eqtyp NE ' '.

  DATA lt_t370t TYPE TABLE OF t370t.
  DATA ls_t370t TYPE t370t.
  SELECT eqtyp
    FROM t370t
    INTO CORRESPONDING FIELDS OF TABLE lt_t370t
    WHERE eqtyp NE ' '.

***  CREATE OBJECT o_oms.

***  o_oms->out_demais_dados_mestres(
***    EXPORTING
***      im_empresa_centro          = ''
***      im_grupo_planejamento      = ''
***      im_area_operacional        = ''
***      im_centro_trabalho         = ''
***      im_tipo_nota               = ''
***      im_tipo_ordem              = ''
***      im_tipo_prioridade_ordem   = ''
***      im_tipo_prioridade_nota    = ''
***      im_tipo_atv_manutencao     = ''
***      im_centro_custo            = ''
***      im_condicao_inst_ordem     = ''
***      im_tipo_atv_operacao       = ''
***      im_tipo_material           = ''
***      im_categoria_item_material = ''
***      im_deposito                = ''
***      im_categoria_equipamento   = 'X'
***      im_tipo_objeto             = ''
***      im_categoria_loc_inst      = ''
***    IMPORTING
***      et_categoria_equipamento   = lt_categoria_equipamento ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

***     READ TABLE lt_categoria_equipamento TRANSPORTING NO FIELDS
        READ TABLE lt_t370t TRANSPORTING NO FIELDS WITH KEY eqtyp = lwa_row-eqtyp.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***       DATA(lv_msg) = |Catg.Equipamento: | && lwa_row-eqtyp &&
***                      | inválido|.
          CONCATENATE 'Categ.Equipamento:'(085) lwa_row-eqtyp 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB019
*        READ TABLE lt_tb019 INTO DATA(ls_019)
        READ TABLE lt_tb019 INTO ls_019
        WITH KEY eqtyp = lwa_row-eqtyp.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***       lv_msg = |Cat.Equip. | && lwa_row-eqtyp &&
***                | utilizado no Perfil | && ls_019-perfil.
          CONCATENATE 'Categ.Equipamento:'(085) lwa_row-eqtyp 'utilizado no Perfil'(079) ls_019-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB008
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb008.

  DATA: lt_tipo_objeto TYPE /ptloms/ct035.

  DATA: lwa_row TYPE /ptloms/tb008.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

* Busca Tipo de Objeto Técnico cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb020
*    INTO TABLE @DATA(lt_tb020).

  DATA lt_tb020 TYPE TABLE OF /ptloms/tb020.
  DATA ls_020 TYPE /ptloms/tb020.
  SELECT *
    FROM /ptloms/tb020
    INTO TABLE lt_tb020.

*  SELECT eqart
*    FROM t370k
*    INTO TABLE @DATA(it_tipo_objeto)
*    WHERE eqart NE ''.

  DATA it_tipo_objeto TYPE TABLE OF t370k.
  SELECT eqart
    FROM t370k
    INTO CORRESPONDING FIELDS OF TABLE it_tipo_objeto
    WHERE eqart NE ''.

*  CREATE OBJECT o_oms.
*
*  o_oms->out_demais_dados_mestres(
*    EXPORTING
*      im_empresa_centro          = ''
*      im_grupo_planejamento      = ''
*      im_area_operacional        = ''
*      im_centro_trabalho         = ''
*      im_tipo_nota               = ''
*      im_tipo_ordem              = ''
*      im_tipo_prioridade_ordem   = ''
*      im_tipo_prioridade_nota    = ''
*      im_tipo_atv_manutencao     = ''
*      im_centro_custo            = ''
*      im_condicao_inst_ordem     = ''
*      im_tipo_atv_operacao       = ''
*      im_tipo_material           = ''
*      im_categoria_item_material = ''
*      im_deposito                = ''
*      im_categoria_equipamento   = ''
*      im_tipo_objeto             = 'X'
*      im_categoria_loc_inst      = ''
*    IMPORTING
*      et_tipo_objeto             = lt_tipo_objeto ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE it_tipo_objeto TRANSPORTING NO FIELDS
        WITH KEY eqart = lwa_row-eqart.

*          READ TABLE lt_tipo_objeto TRANSPORTING NO FIELDS
*          WITH KEY eqart = lwa_row-eqart.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Tipo Objeto: | && lwa_row-eqart &&
***                         | inválido|.
          CONCATENATE 'Tp.Obj.Tec.:'(086) lwa_row-eqart 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB020
*        READ TABLE lt_tb020 INTO DATA(ls_020)
        READ TABLE lt_tb020 INTO ls_020
        WITH KEY eqart = lwa_row-eqart.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Tp.Obj.Tec. | && lwa_row-eqart &&
***                   | utilizado no Perfil | && ls_020-perfil.
          CONCATENATE 'Tp.Obj.Tec.:'(086) lwa_row-eqart 'utilizado no Perfil'(079) ls_020-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB009
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb009.

*  DATA: lt_tipo_nota TYPE /ptloms/ct010.

  DATA: lwa_row TYPE /ptloms/tb009.

  DATA: lv_msg(100) TYPE c.

*  DATA: o_oms TYPE REF TO /ptloms/cl001.
*
*  CREATE OBJECT o_oms.
*
*  o_oms->out_demais_dados_mestres(
*    EXPORTING
*      im_empresa_centro          = ''
*      im_grupo_planejamento      = ''
*      im_area_operacional        = ''
*      im_centro_trabalho         = ''
*      im_tipo_nota               = 'X'
*      im_tipo_ordem              = ''
*      im_tipo_prioridade_ordem   = ''
*      im_tipo_prioridade_nota    = ''
*      im_tipo_atv_manutencao     = ''
*      im_centro_custo            = ''
*      im_condicao_inst_ordem     = ''
*      im_tipo_atv_operacao       = ''
*      im_tipo_material           = ''
*      im_categoria_item_material = ''
*      im_deposito                = ''
*      im_categoria_equipamento   = ''
*      im_tipo_objeto             = ''
*      im_categoria_loc_inst      = ''
*    IMPORTING
*      et_tipo_nota               = lt_tipo_nota ).

* Busca Tipo de Nota cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb021
*    INTO TABLE @DATA(lt_tb021).

  DATA lt_tb021 TYPE TABLE OF /ptloms/tb021.
  DATA ls_021 TYPE /ptloms/tb021.
  SELECT *
    FROM /ptloms/tb021
    INTO TABLE lt_tb021.

*  SELECT a~qmart, a~qmtyp, a~rbnr, b~qmartx
*    FROM tq80 AS a INNER JOIN tq80_t AS b ON a~qmart = b~qmart
*    INTO TABLE @DATA(lt_tipo_nota)
*    WHERE b~spras = @sy-langu.

  TYPES:
    BEGIN OF ty_tp_nota,
      qmart  TYPE tq80-qmart,
      qmtyp  TYPE tq80-qmtyp,
      rbnr   TYPE tq80-rbnr,
      qmartx TYPE tq80_t-qmartx,
    END OF ty_tp_nota.
  DATA:
    lt_tipo_nota TYPE TABLE OF ty_tp_nota,
    ls_tipo_nota TYPE ty_tp_nota.
  SELECT a~qmart a~qmtyp a~rbnr b~qmartx
          FROM tq80 AS a
    INNER JOIN tq80_t AS b ON a~qmart = b~qmart
    INTO TABLE lt_tipo_nota
        WHERE b~spras = sy-langu.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE lt_tipo_nota TRANSPORTING NO FIELDS
        WITH KEY qmart = lwa_row-qmart.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Tipo Nota: | && lwa_row-qmart &&
***                         | inválido|.
          CONCATENATE 'Tipo Nota:'(087) lwa_row-qmart 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB021
*        READ TABLE lt_tb021 INTO DATA(ls_021)
        READ TABLE lt_tb021 INTO ls_021
        WITH KEY qmart = lwa_row-qmart.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Tp.Nota | && lwa_row-qmart &&
***                   | utilizado no Perfil | && ls_021-perfil.
          CONCATENATE 'Tipo Nota:'(087) lwa_row-qmart 'utilizado no Perfil'(079) ls_021-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB010
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb010.

*  DATA: lt_tipo_ordem TYPE /ptloms/ct011.

  DATA: lwa_row TYPE /ptloms/tb010.

  DATA: lv_msg(100) TYPE c.

*  DATA: o_oms TYPE REF TO /ptloms/cl001.
*
*  CREATE OBJECT o_oms.
*
*  o_oms->out_demais_dados_mestres(
*    EXPORTING
*      im_empresa_centro          = ''
*      im_grupo_planejamento      = ''
*      im_area_operacional        = ''
*      im_centro_trabalho         = ''
*      im_tipo_nota               = ''
*      im_tipo_ordem              = 'X'
*      im_tipo_prioridade_ordem   = ''
*      im_tipo_prioridade_nota    = ''
*      im_tipo_atv_manutencao     = ''
*      im_centro_custo            = ''
*      im_condicao_inst_ordem     = ''
*      im_tipo_atv_operacao       = ''
*      im_tipo_material           = ''
*      im_categoria_item_material = ''
*      im_deposito                = ''
*      im_categoria_equipamento   = ''
*      im_tipo_objeto             = ''
*      im_categoria_loc_inst      = ''
*    IMPORTING
*      et_tipo_ordem              = lt_tipo_ordem ).

* Busca Tipo de Ordem cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb022
*    INTO TABLE @DATA(lt_tb022).

  DATA lt_tb022 TYPE TABLE OF /ptloms/tb022.
  DATA ls_022 TYPE /ptloms/tb022.
  SELECT *
    FROM /ptloms/tb022
    INTO TABLE lt_tb022.

*  SELECT a~auart, a~autyp
*    FROM t003o AS a INNER JOIN t003p AS b ON a~auart = b~auart
*    INTO TABLE @DATA(lt_tipo_ordem)
*    WHERE b~spras = @sy-langu.
*
  DATA lt_tipo_ordem TYPE TABLE OF t003o.
  SELECT a~auart a~autyp
    FROM t003o AS a
    INNER JOIN t003p AS b ON a~auart = b~auart
    INTO CORRESPONDING FIELDS OF TABLE lt_tipo_ordem
    WHERE b~spras = sy-langu.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE lt_tipo_ordem TRANSPORTING NO FIELDS
        WITH KEY auart = lwa_row-auart.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Tipo Ordem: | && lwa_row-auart &&
***                         | inválido|.
          CONCATENATE 'Tipo Ordem:'(088) lwa_row-auart 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB022
*        READ TABLE lt_tb022 INTO DATA(ls_022)
        READ TABLE lt_tb022 INTO ls_022
        WITH KEY auart = lwa_row-auart.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Tp.Ordem | && lwa_row-auart &&
***                   | utilizado no Perfil | && ls_022-perfil.
          CONCATENATE 'Tipo Ordem:'(088) lwa_row-auart 'utilizado no Perfil'(079) ls_022-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB011
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb011.

  DATA: lt_tipo_material TYPE /ptloms/ct027.

  DATA: lwa_row TYPE /ptloms/tb011.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_msg(100) TYPE c.

* Busca Tipo de Material cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb023
*    INTO TABLE @DATA(lt_tb023).
  DATA lt_tb023 TYPE TABLE OF /ptloms/tb023.
  DATA ls_023 TYPE /ptloms/tb023.
  SELECT *
    FROM /ptloms/tb023
    INTO TABLE lt_tb023.

*  SELECT a~mtart, b~mtbez
*    FROM t134 AS a INNER JOIN t134t AS b ON a~mtart = b~mtart
*    INTO CORRESPONDING FIELDS OF TABLE @lt_tipo_material
*    WHERE b~spras = @sy-langu.

  SELECT a~mtart b~mtbez
    FROM t134 AS a INNER JOIN t134t AS b ON a~mtart = b~mtart
    INTO CORRESPONDING FIELDS OF TABLE lt_tipo_material
    WHERE b~spras = sy-langu.

*  CREATE OBJECT o_oms.
*
*  o_oms->out_demais_dados_mestres(
*    EXPORTING
*      im_empresa_centro          = ''
*      im_grupo_planejamento      = ''
*      im_area_operacional        = ''
*      im_centro_trabalho         = ''
*      im_tipo_nota               = ''
*      im_tipo_ordem              = ''
*      im_tipo_prioridade_ordem   = ''
*      im_tipo_prioridade_nota    = ''
*      im_tipo_atv_manutencao     = ''
*      im_centro_custo            = ''
*      im_condicao_inst_ordem     = ''
*      im_tipo_atv_operacao       = ''
*      im_tipo_material           = 'X'
*      im_categoria_item_material = ''
*      im_deposito                = ''
*      im_categoria_equipamento   = ''
*      im_tipo_objeto             = ''
*      im_categoria_loc_inst      = ''
*    IMPORTING
*      et_tipo_material           = lt_tipo_material ).

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        READ TABLE lt_tipo_material TRANSPORTING NO FIELDS
        WITH KEY mtart = lwa_row-mtart.

        IF sy-subrc NE 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Tipo Material: | && lwa_row-mtart &&
***                         | inválido|.
          CONCATENATE 'Tipo Material:'(089)  lwa_row-mtart 'inválido'(074) INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB023
**        READ TABLE lt_tb023 INTO DATA(ls_023)
        READ TABLE lt_tb023 INTO ls_023
                WITH KEY mtart = lwa_row-mtart.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          lv_msg = |Tp.Material | && lwa_row-mtart &&
***                   | utilizado no Perfil | && ls_023-perfil.
          CONCATENATE 'Tipo Material:'(089) lwa_row-mtart 'utilizado no Perfil'(079) ls_023-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB024
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb024.

  DATA: lwa_row TYPE /ptloms/tb024.

  DATA: lv_msg(100) TYPE c.

* Busca Tipo de Atividade Ordem cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb025
*    INTO TABLE @DATA(lt_tb025).

  DATA lt_tb025 TYPE TABLE OF /ptloms/tb025.
  DATA ls_025 TYPE /ptloms/tb025.

  SELECT *
    FROM /ptloms/tb025
    INTO TABLE lt_tb025.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB025
*        READ TABLE lt_tb025 INTO DATA(ls_025)
        READ TABLE lt_tb025 INTO ls_025
        WITH KEY ilart = lwa_row-ilart.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Tp.Atv.Ordem | && lwa_row-ilart &&
***                         | utilizado no Perfil | && ls_025-perfil.
          CONCATENATE 'Tp.Atv.Ordem'(090) lwa_row-ilart 'utilizado no Perfil'(079) ls_025-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB027
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb027.

  DATA: lwa_row TYPE /ptloms/tb027.

  DATA: lv_msg(100) TYPE c.

* Busca Grupo de Mercadoria cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb028
*    INTO TABLE @DATA(lt_tb028).

  DATA lt_tb028 TYPE TABLE OF /ptloms/tb028.
  DATA ls_028 TYPE /ptloms/tb028.
  SELECT *
    FROM /ptloms/tb028
    INTO TABLE lt_tb028.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB028
*        READ TABLE lt_tb028 INTO DATA(ls_028)
        READ TABLE lt_tb028 INTO ls_028
        WITH KEY matkl = lwa_row-matkl.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Grp.Mercadoria | && lwa_row-matkl &&
***                         | utilizado no Perfil | && ls_028-perfil.
          CONCATENATE 'Grp.Mercadoria'(091) lwa_row-matkl 'utilizado no Perfil'(079) ls_028-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB029
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb029.

  DATA: lwa_row TYPE /ptloms/tb029.

  DATA: lv_msg(100) TYPE c.

* Busca Deposito cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb030
*    INTO TABLE @DATA(lt_tb030).

  DATA lt_tb030 TYPE TABLE OF /ptloms/tb030.
  DATA ls_030 TYPE /ptloms/tb030.
  SELECT *
    FROM /ptloms/tb030
    INTO TABLE lt_tb030.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB030
*        READ TABLE lt_tb030 INTO DATA(ls_030)
        READ TABLE lt_tb030 INTO ls_030
        WITH KEY werks = lwa_row-werks
                 lgort = lwa_row-lgort.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Centro/Depósito | && lwa_row-werks && |/| && lwa_row-lgort &&
***                         | utilizado no Perfil | && ls_030-perfil.
          CONCATENATE 'Centro/Depósito'(092) lwa_row-werks '/' lwa_row-lgort 'utilizado no Perfil'(079) ls_030-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB012
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb012.

  DATA: lv_perfil_modelo    TYPE /ptloms/ed006,
        lv_id_perfil_modelo TYPE indx_srtfd VALUE '/PTLOMS/PERFIL_MODELO'.

  DATA: lt_novo_normal    TYPE STANDARD TABLE OF /ptloms/ed006,
        lv_id_novo_normal TYPE indx_srtfd VALUE '/PTLOMS/PERFIL_NOVO_NORMAL'.

  DATA: lv_perfil_criar    TYPE /ptloms/ed006,
        lv_id_perfil_criar TYPE indx_srtfd VALUE '/PTLOMS/PERFIL_CRIAR'.

  DATA: lwa_row TYPE /ptloms/tb012.

  DATA: lv_msg(100) TYPE c.

  IMPORT lt_novo_normal TO lt_novo_normal FROM DATABASE indx(za) ID lv_id_novo_normal.
  DELETE FROM DATABASE indx(za) ID lv_id_novo_normal.

* Seleciona todos os Perfis
*  SELECT *
*    FROM /ptloms/tb012
*    INTO TABLE @DATA(lt_tb012).

  DATA lt_tb012 TYPE TABLE OF /ptloms/tb012.
  DATA ls_012 TYPE TABLE OF /ptloms/tb012.
  SELECT *
    FROM /ptloms/tb012
    INTO TABLE lt_tb012.

* Seleciona todos os usuários
*  SELECT *
*    FROM /ptloms/tb013
*    INTO TABLE @DATA(lt_013).

  DATA lt_013 TYPE TABLE OF /ptloms/tb013.
  DATA ls_013 TYPE /ptloms/tb013.
  SELECT *
    FROM /ptloms/tb013
    INTO TABLE lt_013.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF <action> = 'D'.

*        READ TABLE lt_013 INTO DATA(ls_013) WITH KEY perfil = lwa_row-perfil.
        READ TABLE lt_013 INTO ls_013 WITH KEY perfil = lwa_row-perfil.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***       DATA(lv_msg) = |Perfil utilizado no usuário | && ls_013-usuario.
          CONCATENATE 'Perfil utilizado no usuário'(093) ls_013-usuario INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.

* Validação referente ao Centro
*        SELECT *
*          FROM /ptloms/tb014
*          INTO TABLE @DATA(lt_tb014)
*          WHERE perfil = @lwa_row-perfil.

        DATA lt_tb014 TYPE TABLE OF /ptloms/tb014.
        DATA ls_tb014 TYPE /ptloms/tb014.
        SELECT *
          FROM /ptloms/tb014
          INTO TABLE  lt_tb014
          WHERE perfil = lwa_row-perfil.

*        LOOP AT lt_tb014 INTO DATA(ls_tb014).
        LOOP AT lt_tb014 INTO ls_tb014.

          DATA lv_permissao TYPE c LENGTH 1.
          CALL METHOD /ptloms/cl006=>verifica_permissao_centro
            EXPORTING
              im_tcode            = sy-tcode
              im_werks            = ls_tb014-werks
            IMPORTING
              ex_possui_permissao = lv_permissao.

          IF lv_permissao IS INITIAL.
            DATA lv_exit TYPE c.
            CLEAR lv_exit.
            lv_exit  = 'X'.
            MESSAGE s002(/ptloms/cm001) WITH ls_tb014-werks DISPLAY LIKE 'E'.
          ENDIF.

*          IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                                 im_werks = ls_tb014-werks ) IS INITIAL.
*            vim_abort_saving = 'X'.
*            MESSAGE s002(/ptloms/cm001) WITH ls_tb014-werks DISPLAY LIKE 'E'.
*            DATA(lv_exit) = 'X'.
*            EXIT.
*          ENDIF.

        ENDLOOP.

        IF lv_exit = abap_true.
          CLEAR lv_exit.
          EXIT.
        ENDIF.

        DELETE FROM /ptloms/tb014 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb015 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb016 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb017 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb018 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb019 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb020 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb021 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb022 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb023 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb025 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb028 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb030 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb039 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb043 WHERE perfil = lwa_row-perfil.
        DELETE FROM /ptloms/tb044 WHERE perfil = lwa_row-perfil.

      ELSEIF <action> EQ 'U' OR <action> EQ 'N'.

        IF <action> EQ 'N'.

* Se é novo, mas não é "Novo Normal" então é "Novo Cópia" (Criado como modelo). Apenas um por vez
          READ TABLE lt_novo_normal WITH KEY table_line = lwa_row-perfil TRANSPORTING NO FIELDS.
          IF sy-subrc NE 0.
            lv_perfil_criar = lwa_row-perfil.
            EXPORT lv_perfil_criar FROM lv_perfil_criar TO DATABASE indx(za) ID lv_id_perfil_criar.
          ENDIF.

          IMPORT lv_perfil_modelo TO lv_perfil_modelo FROM DATABASE indx(za) ID lv_id_perfil_modelo.
          IF lv_perfil_modelo IS NOT INITIAL.
*            DATA(lv_perfil) = lv_perfil_modelo.
            DATA lv_perfil TYPE /ptloms/ed006.
            lv_perfil = lv_perfil_modelo.
          ENDIF.
        ELSEIF <action> EQ 'U'.
          lv_perfil = lwa_row-perfil.
        ENDIF.

* Validação referente ao Centro
        IF lv_perfil IS NOT INITIAL.
          SELECT *
            FROM /ptloms/tb014
            INTO TABLE lt_tb014
            WHERE perfil = lv_perfil.
          IF sy-subrc EQ 0.

            LOOP AT lt_tb014 INTO ls_tb014.

              DATA lv_permis TYPE c LENGTH 1.
              CALL METHOD /ptloms/cl006=>verifica_permissao_centro
                EXPORTING
                  im_tcode            = sy-tcode
                  im_werks            = ls_tb014-werks
                IMPORTING
                  ex_possui_permissao = lv_permis.

              IF lv_permis  IS INITIAL.
                DATA lv_nok TYPE c.
                CLEAR lv_nok.
                lv_nok  = 'X'.
              ENDIF.

*              IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                                     im_werks = ls_tb014-werks ) IS INITIAL.
*                DATA(lv_nok) = 'X'.
*                EXIT.
*              ENDIF.

            ENDLOOP.

            IF lv_nok IS NOT INITIAL.
              CLEAR lv_nok.
              DELETE FROM DATABASE indx(za) ID lv_id_perfil_modelo.
              vim_abort_saving = 'X'.
              MESSAGE s002(/ptloms/cm001) WITH ls_tb014-werks DISPLAY LIKE 'E'.
              EXIT.
            ENDIF.

          ENDIF.
        ENDIF.

** Validação referente ao Centro do Perfil
*        READ TABLE lt_tb012 INTO DATA(ls_tb012) WITH KEY perfil = lwa_row-perfil.
*        IF sy-subrc EQ 0.
**          IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
**                                                                 im_werks = ls_tb012-werks ) IS INITIAL.
**            vim_abort_saving = 'X'.
**            MESSAGE s002(/ptloms/cm001) WITH ls_tb012-werks DISPLAY LIKE 'E'.
**            EXIT.
**          ENDIF.
*        ENDIF.
*
*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = lwa_row-werks ) IS INITIAL.
*          vim_abort_saving = 'X'.
*          MESSAGE s002(/ptloms/cm001) WITH lwa_row-werks DISPLAY LIKE 'E'.
*          EXIT.
*        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB034
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb034.

  DATA: lwa_row TYPE /ptloms/tb034.

  DATA: lv_msg(100) TYPE c.
  DATA: lv_msg2(100) TYPE c.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF <action> NE 'D'.
        IF lwa_row-urgente = 'X'.
          IF lwa_row-verde IS NOT INITIAL OR lwa_row-vermelho IS NOT INITIAL OR lwa_row-amarelo IS NOT INITIAL.
            vim_abort_saving = 'X'.
***            DATA(lv_msg)  = |Para registro Urgente não é|.
***            DATA(lv_msg2) = |possível preencher semáforo.|.
            lv_msg  = 'Para registro Urgente não é'(094).
            lv_msg2 = 'possível preencher semáforo.'(095).
            MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RECUPERA_PERFIL
*&---------------------------------------------------------------------*
FORM f_recupera_perfil.

  DATA: lt_novo_normal    TYPE STANDARD TABLE OF /ptloms/ed006,
        lv_id_novo_normal TYPE indx_srtfd VALUE '/PTLOMS/PERFIL_NOVO_NORMAL'.

  DATA: ls_novo_normal LIKE LINE OF lt_novo_normal.

  DATA: lv_perfil_modelo    TYPE /ptloms/ed006,
        lv_id_perfil_modelo TYPE indx_srtfd VALUE '/PTLOMS/PERFIL_MODELO'.

  DATA: lwa_row TYPE /ptloms/tb012.

  IF sy-ucomm = 'KOPF'.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.
      MOVE lwa_row-perfil TO lv_perfil_modelo.
      EXPORT lv_perfil_modelo FROM lv_perfil_modelo TO DATABASE indx(za) ID lv_id_perfil_modelo.
    ENDIF.

    LOOP AT total.

      CLEAR: lwa_row.
      IF <vim_total_struc> IS ASSIGNED.
        MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.
        IF <action> = 'N'.
          ls_novo_normal = lwa_row-perfil.
          APPEND ls_novo_normal TO lt_novo_normal.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_novo_normal[] IS NOT INITIAL.
      EXPORT lt_novo_normal FROM lt_novo_normal TO DATABASE indx(za) ID lv_id_novo_normal.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COPIA_MODELO
*&---------------------------------------------------------------------*
FORM f_copia_modelo.

  DATA: lv_perfil_criar    TYPE /ptloms/ed006,
        lv_id_perfil_criar TYPE indx_srtfd VALUE '/PTLOMS/PERFIL_CRIAR'.

  DATA: lv_perfil_modelo    TYPE /ptloms/ed006,
        lv_id_perfil_modelo TYPE indx_srtfd VALUE '/PTLOMS/PERFIL_MODELO'.

  IMPORT lv_perfil_criar TO lv_perfil_criar FROM DATABASE indx(za) ID lv_id_perfil_criar.
  DELETE FROM DATABASE indx(za) ID lv_id_perfil_criar.

  IMPORT lv_perfil_modelo TO lv_perfil_modelo FROM DATABASE indx(za) ID lv_id_perfil_modelo.
  DELETE FROM DATABASE indx(za) ID lv_id_perfil_modelo.

  IF lv_perfil_criar IS INITIAL.
    RETURN.
  ENDIF.

  IF lv_perfil_modelo IS INITIAL.
    RETURN.
  ENDIF.

* Busca Perfil x Empresa/Centro
*  SELECT *
*    FROM /ptloms/tb014
*    INTO TABLE @DATA(lt_tb014)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb014 TYPE TABLE OF /ptloms/tb014.
  DATA ls_014 TYPE /ptloms/tb014.
  SELECT *
    FROM /ptloms/tb014
    INTO TABLE lt_tb014
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Grupo Planejamento
*  SELECT *
*    FROM /ptloms/tb015
*    INTO TABLE @DATA(lt_tb015)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb015 TYPE TABLE OF /ptloms/tb015.
  DATA ls_015 TYPE /ptloms/tb015.
  SELECT *
    FROM /ptloms/tb015
    INTO TABLE lt_tb015
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Área Operacional
*  SELECT *
*    FROM /ptloms/tb016
*    INTO TABLE @DATA(lt_tb016)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb016 TYPE TABLE OF /ptloms/tb016.
  DATA ls_016 TYPE /ptloms/tb016.
  SELECT *
    FROM /ptloms/tb016
    INTO TABLE lt_tb016
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Centro de Trabalho
*  SELECT *
*    FROM /ptloms/tb017
*    INTO TABLE @DATA(lt_tb017)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb017 TYPE TABLE OF /ptloms/tb017.
  DATA ls_017 TYPE /ptloms/tb017.
  SELECT *
    FROM /ptloms/tb017
    INTO TABLE lt_tb017
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Categoria Local de Instalação
*  SELECT *
*    FROM /ptloms/tb018
*    INTO TABLE @DATA(lt_tb018)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb018 TYPE TABLE OF /ptloms/tb018.
  DATA ls_018 TYPE /ptloms/tb018.
  SELECT *
    FROM /ptloms/tb018
    INTO TABLE lt_tb018
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Categoria Equipamento
*  SELECT *
*    FROM /ptloms/tb019
*    INTO TABLE @DATA(lt_tb019)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb019 TYPE TABLE OF /ptloms/tb019.
  DATA ls_019 TYPE /ptloms/tb019.
  SELECT *
    FROM /ptloms/tb019
    INTO TABLE lt_tb019
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Tipo de Objeto Técnico
*  SELECT *
*    FROM /ptloms/tb020
*    INTO TABLE @DATA(lt_tb020)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb020 TYPE TABLE OF /ptloms/tb020.
  DATA ls_020 TYPE /ptloms/tb020.
  SELECT *
    FROM /ptloms/tb020
    INTO TABLE lt_tb020
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Tipo de Nota
*  SELECT *
*    FROM /ptloms/tb021
*    INTO TABLE @DATA(lt_tb021)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb021 TYPE TABLE OF /ptloms/tb021.
  DATA ls_021 TYPE /ptloms/tb021.
  SELECT *
    FROM /ptloms/tb021
    INTO TABLE lt_tb021
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Tipo Ordem
*  SELECT *
*    FROM /ptloms/tb022
*    INTO TABLE @DATA(lt_tb022)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb022 TYPE TABLE OF /ptloms/tb022.
  DATA ls_022 TYPE /ptloms/tb022.
  SELECT *
    FROM /ptloms/tb022
    INTO TABLE lt_tb022
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Tipo Material
*  SELECT *
*    FROM /ptloms/tb023
*    INTO TABLE @DATA(lt_tb023)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb023 TYPE TABLE OF /ptloms/tb023.
  DATA ls_023 TYPE /ptloms/tb023.
  SELECT *
    FROM /ptloms/tb023
    INTO TABLE lt_tb023
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Tipo Atividade Ordem
*  SELECT *
*    FROM /ptloms/tb025
*    INTO TABLE @DATA(lt_tb025)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb025 TYPE TABLE OF /ptloms/tb025.
  DATA ls_025 TYPE /ptloms/tb025.
  SELECT *
    FROM /ptloms/tb025
    INTO TABLE lt_tb025
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Grupo de Mercadoria
*  SELECT *
*    FROM /ptloms/tb028
*    INTO TABLE @DATA(lt_tb028)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb028 TYPE TABLE OF /ptloms/tb028.
  DATA ls_028 TYPE /ptloms/tb028.
  SELECT *
    FROM /ptloms/tb028
    INTO TABLE lt_tb028
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Depósito
*  SELECT *
*    FROM /ptloms/tb030
*    INTO TABLE @DATA(lt_tb030)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb030 TYPE TABLE OF /ptloms/tb030.
  DATA ls_030 TYPE /ptloms/tb030.
  SELECT *
    FROM /ptloms/tb030
    INTO TABLE lt_tb030
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Causa Desvio
*  SELECT *
*    FROM /ptloms/tb039
*    INTO TABLE @DATA(lt_tb039)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb039 TYPE TABLE OF /ptloms/tb039.
  DATA ls_039 TYPE /ptloms/tb039.
  SELECT *
    FROM /ptloms/tb039
    INTO TABLE lt_tb039
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Autorizações
*  SELECT *
*    FROM /ptloms/tb043
*    INTO TABLE @DATA(lt_tb043)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb043 TYPE TABLE OF /ptloms/tb043.
  DATA ls_043 TYPE /ptloms/tb043.
  SELECT *
    FROM /ptloms/tb043
    INTO TABLE lt_tb043
    WHERE perfil = lv_perfil_modelo.

* Busca Perfil x Configurações
*  SELECT *
*    FROM /ptloms/tb044
*    INTO TABLE @DATA(lt_tb044)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb044 TYPE TABLE OF /ptloms/tb044.
  DATA ls_044 TYPE /ptloms/tb044.
  SELECT *
    FROM /ptloms/tb044
    INTO TABLE  lt_tb044
    WHERE perfil = lv_perfil_modelo.

* Busca - Perfil x Equipamento - Status inclusivo
*  SELECT *
*    FROM /ptloms/tb051
*    INTO TABLE @DATA(lt_tb051)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb051 TYPE TABLE OF /ptloms/tb051.
  DATA ls_051 TYPE /ptloms/tb051.
  SELECT *
    FROM /ptloms/tb051
    INTO TABLE lt_tb051
    WHERE perfil = lv_perfil_modelo.

* Busca - Perfil x Equipamento - Status exclusivo
*  SELECT *
*    FROM /ptloms/tb052
*    INTO TABLE @DATA(lt_tb052)
*    WHERE perfil = @lv_perfil_modelo.

  DATA lt_tb052 TYPE TABLE OF /ptloms/tb052.
  DATA ls_052 TYPE /ptloms/tb052.
  SELECT *
    FROM /ptloms/tb052
    INTO TABLE lt_tb052
    WHERE perfil = lv_perfil_modelo.

  DATA lt_tb063 TYPE TABLE OF /ptloms/tb063.
  DATA ls_063 TYPE /ptloms/tb063.
  SELECT *
    FROM /ptloms/tb063
    INTO TABLE lt_tb063
    WHERE perfil = lv_perfil_modelo.

*---------------------*
  FIELD-SYMBOLS:
    <fs_tb014> LIKE LINE OF lt_tb014,
    <fs_tb015> LIKE LINE OF lt_tb015,
    <fs_tb016> LIKE LINE OF lt_tb016,
    <fs_tb017> LIKE LINE OF lt_tb017,
    <fs_tb018> LIKE LINE OF lt_tb018,
    <fs_tb019> LIKE LINE OF lt_tb019,
    <fs_tb020> LIKE LINE OF lt_tb020,
    <fs_tb021> LIKE LINE OF lt_tb021,
    <fs_tb022> LIKE LINE OF lt_tb022,
    <fs_tb023> LIKE LINE OF lt_tb023,
    <fs_tb025> LIKE LINE OF lt_tb025,
    <fs_tb028> LIKE LINE OF lt_tb028,
    <fs_tb030> LIKE LINE OF lt_tb030,
    <fs_tb039> LIKE LINE OF lt_tb039,
    <fs_tb043> LIKE LINE OF lt_tb043,
    <fs_tb044> LIKE LINE OF lt_tb044,
    <fs_tb051> LIKE LINE OF lt_tb051,
    <fs_tb052> LIKE LINE OF lt_tb052,
    <fs_tb063> LIKE LINE OF lt_tb063.

* Atualiza novo perfil
**  LOOP AT lt_tb014 ASSIGNING FIELD-SYMBOL(<fs_tb014>).
**    <fs_tb014>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb015 ASSIGNING FIELD-SYMBOL(<fs_tb015>).
**    <fs_tb015>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb016 ASSIGNING FIELD-SYMBOL(<fs_tb016>).
**    <fs_tb016>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb017 ASSIGNING FIELD-SYMBOL(<fs_tb017>).
**    <fs_tb017>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb018 ASSIGNING FIELD-SYMBOL(<fs_tb018>).
**    <fs_tb018>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb019 ASSIGNING FIELD-SYMBOL(<fs_tb019>).
**    <fs_tb019>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb020 ASSIGNING FIELD-SYMBOL(<fs_tb020>).
**    <fs_tb020>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb021 ASSIGNING FIELD-SYMBOL(<fs_tb021>).
**    <fs_tb021>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb022 ASSIGNING FIELD-SYMBOL(<fs_tb022>).
**    <fs_tb022>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb023 ASSIGNING FIELD-SYMBOL(<fs_tb023>).
**    <fs_tb023>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb025 ASSIGNING FIELD-SYMBOL(<fs_tb025>).
**    <fs_tb025>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb028 ASSIGNING FIELD-SYMBOL(<fs_tb028>).
**    <fs_tb028>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb030 ASSIGNING FIELD-SYMBOL(<fs_tb030>).
**    <fs_tb030>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb039 ASSIGNING FIELD-SYMBOL(<fs_tb039>).
**    <fs_tb039>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb043 ASSIGNING FIELD-SYMBOL(<fs_tb043>).
**    <fs_tb043>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb044 ASSIGNING FIELD-SYMBOL(<fs_tb044>).
**    <fs_tb044>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb051 ASSIGNING FIELD-SYMBOL(<fs_tb051>).
**    <fs_tb051>-perfil = lv_perfil_criar.
**  ENDLOOP.
**  LOOP AT lt_tb052 ASSIGNING FIELD-SYMBOL(<fs_tb052>).
**    <fs_tb052>-perfil = lv_perfil_criar.
**  ENDLOOP.

  LOOP AT lt_tb014 ASSIGNING <fs_tb014>.
    <fs_tb014>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb015 ASSIGNING <fs_tb015>.
    <fs_tb015>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb016 ASSIGNING <fs_tb016>.
    <fs_tb016>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb017 ASSIGNING <fs_tb017>.
    <fs_tb017>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb018 ASSIGNING <fs_tb018>.
    <fs_tb018>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb019 ASSIGNING <fs_tb019>.
    <fs_tb019>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb020 ASSIGNING <fs_tb020>.
    <fs_tb020>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb021 ASSIGNING <fs_tb021>.
    <fs_tb021>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb022 ASSIGNING <fs_tb022>.
    <fs_tb022>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb023 ASSIGNING <fs_tb023>.
    <fs_tb023>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb025 ASSIGNING <fs_tb025>.
    <fs_tb025>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb028 ASSIGNING <fs_tb028>.
    <fs_tb028>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb030 ASSIGNING <fs_tb030>.
    <fs_tb030>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb039 ASSIGNING <fs_tb039>.
    <fs_tb039>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb043 ASSIGNING <fs_tb043>.
    <fs_tb043>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb044 ASSIGNING <fs_tb044>.
    <fs_tb044>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb051 ASSIGNING <fs_tb051>.
    <fs_tb051>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb052 ASSIGNING <fs_tb052>.
    <fs_tb052>-perfil = lv_perfil_criar.
  ENDLOOP.
  LOOP AT lt_tb063 ASSIGNING <fs_tb063>.
    <fs_tb063>-perfil = lv_perfil_criar.
  ENDLOOP.

* Atualiza tabela com novo Perfil
  IF lt_tb014[] IS NOT INITIAL.
    MODIFY /ptloms/tb014 FROM TABLE lt_tb014.
  ENDIF.
  IF lt_tb015[] IS NOT INITIAL.
    MODIFY /ptloms/tb015 FROM TABLE lt_tb015.
  ENDIF.
  IF lt_tb016[] IS NOT INITIAL.
    MODIFY /ptloms/tb016 FROM TABLE lt_tb016.
  ENDIF.
  IF lt_tb017[] IS NOT INITIAL.
    MODIFY /ptloms/tb017 FROM TABLE lt_tb017.
  ENDIF.
  IF lt_tb018[] IS NOT INITIAL.
    MODIFY /ptloms/tb018 FROM TABLE lt_tb018.
  ENDIF.
  IF lt_tb019[] IS NOT INITIAL.
    MODIFY /ptloms/tb019 FROM TABLE lt_tb019.
  ENDIF.
  IF lt_tb020[] IS NOT INITIAL.
    MODIFY /ptloms/tb020 FROM TABLE lt_tb020.
  ENDIF.
  IF lt_tb021[] IS NOT INITIAL.
    MODIFY /ptloms/tb021 FROM TABLE lt_tb021.
  ENDIF.
  IF lt_tb022[] IS NOT INITIAL.
    MODIFY /ptloms/tb022 FROM TABLE lt_tb022.
  ENDIF.
  IF lt_tb023[] IS NOT INITIAL.
    MODIFY /ptloms/tb023 FROM TABLE lt_tb023.
  ENDIF.
  IF lt_tb025[] IS NOT INITIAL.
    MODIFY /ptloms/tb025 FROM TABLE lt_tb025.
  ENDIF.
  IF lt_tb028[] IS NOT INITIAL.
    MODIFY /ptloms/tb028 FROM TABLE lt_tb028.
  ENDIF.
  IF lt_tb030[] IS NOT INITIAL.
    MODIFY /ptloms/tb030 FROM TABLE lt_tb030.
  ENDIF.
  IF lt_tb039[] IS NOT INITIAL.
    MODIFY /ptloms/tb039 FROM TABLE lt_tb039.
  ENDIF.
  IF lt_tb043[] IS NOT INITIAL.
    MODIFY /ptloms/tb043 FROM TABLE lt_tb043.
  ENDIF.
  IF lt_tb044[] IS NOT INITIAL.
    MODIFY /ptloms/tb044 FROM TABLE lt_tb044.
  ENDIF.
  IF lt_tb051[] IS NOT INITIAL.
    MODIFY /ptloms/tb051 FROM TABLE lt_tb051.
  ENDIF.
  IF lt_tb052[] IS NOT INITIAL.
    MODIFY /ptloms/tb052 FROM TABLE lt_tb052.
  ENDIF.
  IF lt_tb063[] IS NOT INITIAL.
    MODIFY /ptloms/tb063 FROM TABLE lt_tb063.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB038
*&---------------------------------------------------------------------*
FORM f_validar_dados_tb038.

  DATA: lwa_row TYPE /ptloms/tb038.

  DATA: lv_msg(100) TYPE c.

* Busca Causa Desvio cadastrado para Perfil
*  SELECT *
*    FROM /ptloms/tb039
*    INTO TABLE @DATA(lt_tb039).

  DATA lt_tb039 TYPE TABLE OF /ptloms/tb039.
  DATA ls_039 TYPE /ptloms/tb039.
  SELECT *
    FROM /ptloms/tb039
    INTO TABLE lt_tb039.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF <action> EQ 'D'.
        " Verifica na tabela /PTLOMS/TB039
*        READ TABLE lt_tb039 INTO DATA(ls_039)
        READ TABLE lt_tb039 INTO ls_039
        WITH KEY werks = lwa_row-werks
                 grund = lwa_row-grund.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
***          DATA(lv_msg) = |Caus.Desv./Centro | && lwa_row-grund && |/| && lwa_row-werks &&
***                         | utilizado no Perfil | && ls_039-perfil.
          CONCATENATE 'Caus.Desv./Centro'(096) lwa_row-grund '/' lwa_row-werks 'utilizado no Perfil'(079) ls_039-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DEFINE_GUIA
*&---------------------------------------------------------------------*
FORM f_define_guia .

* Determinando qual subtela será apresentada
  tabstrip-activetab = g_tabstrip-pressed_tab.

  CASE g_tabstrip-pressed_tab.

    WHEN c_tabstrip-tab1.
      g_tabstrip-subscreen = '0100'.

    WHEN c_tabstrip-tab2.
      g_tabstrip-subscreen = '0110'.

    WHEN c_tabstrip-tab3.
      g_tabstrip-subscreen = '0120'.

    WHEN c_tabstrip-tab4.
      g_tabstrip-subscreen = '0130'.

    WHEN c_tabstrip-tab5.
      g_tabstrip-subscreen = '0140'.

    WHEN c_tabstrip-tab6.
      g_tabstrip-subscreen = '0150'.

    WHEN c_tabstrip-tab7.
      g_tabstrip-subscreen = '0251'.

    WHEN c_tabstrip-tab8.
      g_tabstrip-subscreen = '0152'.

    WHEN c_tabstrip-tab9.
      g_tabstrip-subscreen = '0154'.

    WHEN c_tabstrip-tab10.
      g_tabstrip-subscreen = '0160'.

    WHEN c_tabstrip-tab11.
      g_tabstrip-subscreen = '0170'.

    WHEN c_tabstrip-tab12.
      g_tabstrip-subscreen = '0180'.

    WHEN c_tabstrip-tab13.
      g_tabstrip-subscreen = '0190'.

    WHEN c_tabstrip-tab14.
      g_tabstrip-subscreen = '0200'.

    WHEN c_tabstrip-tab15.
      g_tabstrip-subscreen = '0210'.

    WHEN c_tabstrip-tab16.
      g_tabstrip-subscreen = '0220'.

    WHEN c_tabstrip-tab17.
      g_tabstrip-subscreen = '0230'.

    WHEN c_tabstrip-tab18.
      g_tabstrip-subscreen = '0240'.

    WHEN c_tabstrip-tab19.
      g_tabstrip-subscreen = '0250'.

    WHEN c_tabstrip-tab20.
      g_tabstrip-subscreen = '0260'.

* Início aqui
*    WHEN c_tabstrip-tab7.
*      g_tabstrip-subscreen = '0152'.
*
*    WHEN c_tabstrip-tab8.
*      g_tabstrip-subscreen = '0154'.
*
*    WHEN c_tabstrip-tab9.
*      g_tabstrip-subscreen = '0160'.
*
*    WHEN c_tabstrip-tab10.
*      g_tabstrip-subscreen = '0170'.
*
*    WHEN c_tabstrip-tab11.
*      g_tabstrip-subscreen = '0180'.
*
*    WHEN c_tabstrip-tab12.
*      g_tabstrip-subscreen = '0190'.
*
*    WHEN c_tabstrip-tab13.
*      g_tabstrip-subscreen = '0200'.
*
*    WHEN c_tabstrip-tab14.
*      g_tabstrip-subscreen = '0210'.
*
*    WHEN c_tabstrip-tab15.
*      g_tabstrip-subscreen = '0220'.
*
*    WHEN c_tabstrip-tab16.
*      g_tabstrip-subscreen = '0230'.
*
*    WHEN c_tabstrip-tab17.
*      g_tabstrip-subscreen = '0240'.
*
*    WHEN c_tabstrip-tab18.
*      g_tabstrip-subscreen = '0250'.
*
*    WHEN c_tabstrip-tab19.
*      g_tabstrip-subscreen = '0251'.

* Final aqui

*    WHEN c_tabstrip-tab7.
*      g_tabstrip-subscreen = '0160'.
*
*    WHEN c_tabstrip-tab8.
*      g_tabstrip-subscreen = '0170'.
*
*    WHEN c_tabstrip-tab9.
*      g_tabstrip-subscreen = '0180'.
*
*    WHEN c_tabstrip-tab10.
*      g_tabstrip-subscreen = '0190'.
*
*    WHEN c_tabstrip-tab11.
*      g_tabstrip-subscreen = '0200'.
*
*    WHEN c_tabstrip-tab12.
*      g_tabstrip-subscreen = '0210'.
*
*    WHEN c_tabstrip-tab13.
*      g_tabstrip-subscreen = '0220'.
*
*    WHEN c_tabstrip-tab14.
*      g_tabstrip-subscreen = '0230'.
*
*    WHEN c_tabstrip-tab15.
*      g_tabstrip-subscreen = '0240'.
*
*    WHEN c_tabstrip-tab16.
*      g_tabstrip-subscreen = '0250'.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TABSTRIP_ACTIVE_TAB_GET
*&---------------------------------------------------------------------*
FORM f_tabstrip_active_tab_get .

  IF sy-ucomm NE 'KOPF'.
    ok_code = sy-ucomm.
  ENDIF.

  CASE ok_code.

    WHEN c_tabstrip-tab1.
      g_tabstrip-pressed_tab = c_tabstrip-tab1.

    WHEN c_tabstrip-tab2.
      g_tabstrip-pressed_tab = c_tabstrip-tab2.

    WHEN c_tabstrip-tab3.
      g_tabstrip-pressed_tab = c_tabstrip-tab3.

    WHEN c_tabstrip-tab4.
      g_tabstrip-pressed_tab = c_tabstrip-tab4.

    WHEN c_tabstrip-tab5.
      g_tabstrip-pressed_tab = c_tabstrip-tab5.

    WHEN c_tabstrip-tab6.
      g_tabstrip-pressed_tab = c_tabstrip-tab6.

    WHEN c_tabstrip-tab7.
      g_tabstrip-pressed_tab = c_tabstrip-tab7.

    WHEN c_tabstrip-tab8.
      g_tabstrip-pressed_tab = c_tabstrip-tab8.

    WHEN c_tabstrip-tab9.
      g_tabstrip-pressed_tab = c_tabstrip-tab9.

    WHEN c_tabstrip-tab10.
      g_tabstrip-pressed_tab = c_tabstrip-tab10.

    WHEN c_tabstrip-tab11.
      g_tabstrip-pressed_tab = c_tabstrip-tab11.

    WHEN c_tabstrip-tab12.
      g_tabstrip-pressed_tab = c_tabstrip-tab12.

    WHEN c_tabstrip-tab13.
      g_tabstrip-pressed_tab = c_tabstrip-tab13.

    WHEN c_tabstrip-tab14.
      g_tabstrip-pressed_tab = c_tabstrip-tab14.

    WHEN c_tabstrip-tab15.
      g_tabstrip-pressed_tab = c_tabstrip-tab15.

    WHEN c_tabstrip-tab16.
      g_tabstrip-pressed_tab = c_tabstrip-tab16.

    WHEN c_tabstrip-tab17.
      g_tabstrip-pressed_tab = c_tabstrip-tab17.

    WHEN c_tabstrip-tab18.
      g_tabstrip-pressed_tab = c_tabstrip-tab18.

    WHEN c_tabstrip-tab19.
      g_tabstrip-pressed_tab = c_tabstrip-tab19.

    WHEN c_tabstrip-tab20.
      g_tabstrip-pressed_tab = c_tabstrip-tab20.

    WHEN OTHERS.
*      DO NOTHING

  ENDCASE.

* Importante essa limpeza para se liberar o <ENTER>,
* senão, ficará travado com o último clique, por exemplo,
* SALVAR
*  CLEAR sy-ucomm.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_PERFIL
*&---------------------------------------------------------------------*
FORM f_help_perfil .

  DATA: r_perfil TYPE RANGE OF /ptloms/tb012-perfil.

  TYPES: BEGIN OF ty_tab,
           perfil    TYPE /ptloms/tb012-perfil,
           descricao TYPE /ptloms/tb012-descricao,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields,
        ls_tab        LIKE LINE OF lt_tab.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb012
*    INTO TABLE @DATA(lt_tb012)
*    WHERE perfil IN @r_perfil
*      AND inativo <> 'X'.

  DATA lt_tb012 TYPE TABLE OF /ptloms/tb012.
  DATA ls_012 TYPE /ptloms/tb012.
  SELECT *
    FROM /ptloms/tb012
    INTO TABLE lt_tb012
    WHERE perfil IN r_perfil
      AND inativo <> 'X'.

  IF lt_tb012[] IS INITIAL.
    RETURN.
  ENDIF.

*  LOOP AT lt_tb012 INTO DATA(ls_012).
  LOOP AT lt_tb012 INTO ls_012.
    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_012 TO ls_tab.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'PERFIL'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      gv_perfil = ls_return-fieldval.

    ENDIF.
  ENDIF.

  IF gv_perfil IS NOT INITIAL.

* Atribuindo ao valor da variável
    SELECT SINGLE descricao
      FROM /ptloms/tb012
      INTO gv_desc_perfil
      WHERE perfil = gv_perfil.

* Atualiza o campo Descrição do Perfil
    CLEAR lt_dynpfields.

    ls_dynpfields-fieldname = 'GV_DESC_PERFIL'.
    ls_dynpfields-fieldvalue = gv_desc_perfil.
    APPEND ls_dynpfields TO lt_dynpfields.

* Função que permite alterar os dados na tela da table control
    CALL FUNCTION 'DYNP_VALUES_UPDATE'
      EXPORTING
        dyname               = sy-repid
        dynumb               = sy-dynnr
      TABLES
        dynpfields           = lt_dynpfields
      EXCEPTIONS
        invalid_abapworkarea = 1
        invalid_dynprofield  = 2
        invalid_dynproname   = 3
        invalid_dynpronummer = 4
        invalid_request      = 5
        no_fielddescription  = 6
        undefind_error       = 7
        OTHERS               = 8.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_PERFIL
*&---------------------------------------------------------------------*
FORM f_valida_perfil .

*  DATA: lv_werks TYPE /ptloms/tb012-werks.

  IF gv_perfil IS NOT INITIAL.

    SELECT SINGLE descricao
      FROM /ptloms/tb012
      INTO gv_desc_perfil
      WHERE perfil = gv_perfil
       AND inativo <> 'X'.

    IF sy-subrc NE 0.
      CLEAR gv_desc_perfil.
*      MESSAGE e000(su) WITH 'Perfil inválido.'.
      MESSAGE s000(su) WITH 'Perfil inválido.' DISPLAY LIKE 'E'.
    ENDIF.

* Validação referente ao Centro
*    SELECT *
*      FROM /ptloms/tb014
*      INTO TABLE @DATA(lt_tb014)
*      WHERE perfil = @gv_perfil.
    DATA lt_tb014 TYPE TABLE OF /ptloms/tb014.
    DATA ls_tb014 TYPE /ptloms/tb014.
    SELECT *
      FROM /ptloms/tb014
      INTO TABLE lt_tb014
      WHERE perfil = gv_perfil.
    IF sy-subrc EQ 0.

*      LOOP AT lt_tb014 INTO DATA(ls_tb014).
      LOOP AT lt_tb014 INTO ls_tb014.

        DATA lv_permiss TYPE c LENGTH 1.
        CALL METHOD /ptloms/cl006=>verifica_permissao_centro
          EXPORTING
            im_tcode            = sy-tcode
            im_werks            = ls_tb014-werks
          IMPORTING
            ex_possui_permissao = lv_permiss.

        IF lv_permiss  IS INITIAL.
          DATA lv_ok TYPE c.
          CLEAR lv_ok.
          lv_ok  = 'X'.
        ENDIF.

*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = ls_tb014-werks ) IS NOT INITIAL.
*          DATA(lv_ok) = 'X'.
*          EXIT.
*        ENDIF.

      ENDLOOP.

      IF lv_ok IS NOT INITIAL.
        CLEAR: gv_perfil, gv_desc_perfil.
        MESSAGE s002(/ptloms/cm001) WITH ls_tb014-werks DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
    ENDIF.

  ELSE.

    CLEAR gv_desc_perfil.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_ALV
*&---------------------------------------------------------------------*
FORM f_monta_alv .

  IF o_container IS NOT INITIAL.
    o_container->free( ).
    FREE o_container.
  ENDIF.

  IF o_container IS INITIAL.
    PERFORM criar_instancia_alv. "Cria container e o alv
    PERFORM definir_status_alv.  "Define os botões do alv
    PERFORM modificar_colunas.   "Modifica ou define atributos das colunas
    PERFORM modificar_layout.    "Modificar opções de layout
    PERFORM registrar_eventos.   "Registra os eventos do alv
    PERFORM metodo_selecao.      "Permite selecionar somente 1 linha no ALV

* Exibe o ALV
    o_alv->display( ).
  ELSE.
    o_alv->refresh( ) .
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CRIAR_INSTANCIA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM criar_instancia_alv .

  DATA:
    o_cx_salv_msg TYPE REF TO cx_salv_msg,
    ls_message    TYPE bal_s_msg.                           "#EC NEEDED


  IF cl_salv_table=>is_offline( ) EQ if_salv_c_bool_sap=>false.

    " Cria o container somente se não estiver executando em background
    CREATE OBJECT o_container
      EXPORTING
        container_name = 'O_CONTAINER'.

  ENDIF.

* Criar a instância do alv
* =========================
  TRY.

      CASE g_tabstrip-pressed_tab.
        WHEN c_tabstrip-tab1.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_empresa_centro.

        WHEN c_tabstrip-tab2.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_grupo_planejamento.

        WHEN c_tabstrip-tab3.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_area_operacional.

        WHEN c_tabstrip-tab4.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_centro_trabalho.

        WHEN c_tabstrip-tab5.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_cat_loc_inst.

        WHEN c_tabstrip-tab6.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_cat_equipamento.

        WHEN c_tabstrip-tab7.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_caract_equipamento.

        WHEN c_tabstrip-tab8.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_status_inclusivo.

        WHEN c_tabstrip-tab9.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_status_exclusivo.

        WHEN c_tabstrip-tab10.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_tipo_objeto.

        WHEN c_tabstrip-tab11.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_tipo_nota.

        WHEN c_tabstrip-tab12.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_tipo_ordem.

        WHEN c_tabstrip-tab13.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_tipo_material.

        WHEN c_tabstrip-tab14.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_tipo_atv_ordem.

        WHEN c_tabstrip-tab15.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_grupo_mercadoria.

        WHEN c_tabstrip-tab16.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_deposito.

        WHEN c_tabstrip-tab17.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_causa_desvio.

        WHEN c_tabstrip-tab18.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_autorizacao.

        WHEN c_tabstrip-tab19.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_configuracao.

        WHEN c_tabstrip-tab20.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container    = o_container
              container_name = 'O_CONTAINER'
            IMPORTING
              r_salv_table   = o_alv
            CHANGING
              t_table        = gt_lista.

        WHEN OTHERS.
      ENDCASE.

    CATCH cx_salv_msg INTO o_cx_salv_msg.
      CALL METHOD o_cx_salv_msg->if_alv_message~get_message
        RECEIVING
          r_s_msg = ls_message.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DEFINIR_STATUS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM definir_status_alv .

* Habilita todos os botões genéricos do alv
  o_status = o_alv->get_functions( ).
  o_status->set_all( 'X' ).

  PERFORM excluir_botao
    USING '&GRAPH'.

  AUTHORITY-CHECK OBJECT '/PTLOMS/04'
           ID 'TCD' FIELD sy-tcode
           ID 'ACTVT' FIELD '02'.
  IF sy-subrc EQ 0.

    PERFORM f_verifica_bloqueio_tabela CHANGING gv_edit.

    IF gv_edit = 'X'.

      CASE g_tabstrip-pressed_tab.
        WHEN c_tabstrip-tab1.

          PERFORM adicionar_botao
          USING:
         "Okcode   Ícone                         Texto botão     Texto ao passar o mouse
         "======   ======================        =============== =======================
         'INS_MULT_EMP_CENTRO' icon_insert_multiple_lines  'Incluir'(071)      'Incluir'(071),
         'DEL_EMP_CENTRO'      icon_delete                 'Remover'(070)      'Remover'(070).

        WHEN c_tabstrip-tab2.

          PERFORM adicionar_botao
          USING:
         'EQUI_GRP_PLAN'      icon_equipment                'F. Equip.'(097)    'Filtro Equipamento'(099),
         'LOCL_GRP_PLAN'      icon_technical_place          'F. Locl'(098)      'Filtro Local Inst.'(008),
         'INS_MULT_GRP_PLAN'  icon_insert_multiple_lines    'Incluir'(071)      'Incluir'(071),
         'DEL_GRP_PLAN'       icon_delete                   'Remover'(070)      'Remover'(070).

        WHEN c_tabstrip-tab3.

          PERFORM adicionar_botao
          USING:
         'EQUI_AREA_OP'     icon_equipment                  'F. Equip.'(097)    'Filtro Equipamento'(099),
         'LOCL_AREA_OP'     icon_technical_place            'F. Locl'(098)      'Filtro Local Inst.'(008),
         'INS_MULT_AREA_OP' icon_insert_multiple_lines      'Incluir'(071)      'Incluir'(071),
         'DEL_AREA_OP'      icon_delete                     'Remover'(070)      'Remover'(070).

        WHEN c_tabstrip-tab4.

          PERFORM adicionar_botao
          USING:
         'EQUI_CENTRO_TRAB'     icon_equipment              'F. Equip.'(097)     'Filtro Equipamento'(099),
         'LOCL_CENTRO_TRAB'     icon_technical_place        'F. Locl'(098)       'Filtro Local Inst.'(008),
         'INS_MULT_CENTRO_TRAB' icon_insert_multiple_lines  'Incluir'(071)       'Incluir'(071),
         'DEL_CENTRO_TRAB'      icon_delete                 'Remover'(070)       'Remover'(070).

        WHEN c_tabstrip-tab5.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_CAT_LOCL' icon_insert_multiple_lines     'Incluir'(071)     'Incluir'(071),
         'DEL_CAT_LOCL'      icon_delete                    'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab6.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_CAT_EQUI' icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_CAT_EQUI'      icon_delete                 'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab7.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_CARACT'       icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_CARACT'            icon_delete                 'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab8.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_STATUS_INCLUSIVO' icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_STATUS_INCLUSIVO'     icon_delete                'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab9.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_STATUS_EXCLUSIVO' icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_STATUS_EXCLUSIVO'      icon_delete                'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab10.

          PERFORM adicionar_botao
          USING:
         'EQUI_TP_OBJ'     icon_equipment                 'F. Equip.'(097)    'Filtro Equipamento'(099),
         'LOCL_TP_OBJ'     icon_technical_place           'F. Locl'(098)      'Filtro Local Inst.'(008),
         'INS_MULT_TP_OBJ' icon_insert_multiple_lines     'Incluir'(071)      'Incluir'(071),
         'DEL_TP_OBJ'      icon_delete                    'Remover'(070)      'Remover'(070).

        WHEN c_tabstrip-tab11.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_TP_NOTA' icon_insert_multiple_lines    'Incluir'(071)      'Incluir'(071),
         'DEL_TP_NOTA'      icon_delete                   'Remover'(070)      'Remover'(070).

        WHEN c_tabstrip-tab12.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_TP_ORDEM' icon_insert_multiple_lines   'Incluir'(071)     'Incluir'(071),
         'DEL_TP_ORDEM'      icon_delete                  'Remover'(070)     'Remover'(070),
         'CATALOGO_TP_ORDEM' icon_catalog                 'Catálogo'(130)    'Catálogo'(130).

        WHEN c_tabstrip-tab13.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_TP_MAT' icon_insert_multiple_lines     'Incluir'(071)      'Incluir'(071),
         'DEL_TIPO_MAT'    icon_delete                    'Remover'(070)      'Remover'(070).

        WHEN c_tabstrip-tab14.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_ATV_ORDEM' icon_insert_multiple_lines  'Incluir'(071)      'Incluir'(071),
         'DEL_TP_ATV_ORDEM'   icon_delete                 'Remover'(070)      'Remover'(070).

        WHEN c_tabstrip-tab15.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_GRP_MERC' icon_insert_multiple_lines   'Incluir'(071)     'Incluir'(071),
         'DEL_GRP_MERC'      icon_delete                  'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab16.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_DEPOSITO' icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_DEPOSITO'      icon_delete                 'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab17.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_CAUSA_DESVIO' icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_CAUSA_DESVIO'      icon_delete                 'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab18.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_AUTORIZACAO' icon_insert_multiple_lines  'Incluir'(071)       'Incluir'(071),
         'DEL_AUTORIZACAO'      icon_delete                 'Remover'(070)       'Remover'(070).

        WHEN c_tabstrip-tab19.

          PERFORM adicionar_botao
          USING:
         'INS_MULT_CONFIGURACAO' icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_CONFIGURACAO'      icon_delete                 'Remover'(070)     'Remover'(070).

        WHEN c_tabstrip-tab20.

          PERFORM adicionar_botao
            USING:
         'INS_MULT_LISTA_TAREFA' icon_insert_multiple_lines  'Incluir'(071)     'Incluir'(071),
         'DEL_LISTA_TAREFA'      icon_delete                 'Remover'(070)     'Remover'(070).

        WHEN OTHERS.
      ENDCASE.

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXCLUIR_BOTAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0392   text
*----------------------------------------------------------------------*
FORM excluir_botao USING VALUE(p_name) TYPE c.

  DATA: l_name TYPE salv_de_function.

  l_name = p_name.

  TRY.

      CALL METHOD o_status->remove_function
        EXPORTING
          name = l_name.

    CATCH cx_salv_not_found .
    CATCH cx_salv_wrong_call .
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFICAR_COLUNAS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modificar_colunas .

  "Buscar todas as colunas do ALV
  o_columns = o_alv->get_columns( ).

*  "Otimizar a largura das colunas
*  o_columns->set_optimize( 'X' ).

  "Alterar título e outros atributos das colunas
  CASE g_tabstrip-pressed_tab.
    WHEN c_tabstrip-tab1.

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'        'Descrição'                          'X'     space.
               'MANDT'          'MANDT'                              space   space 10,
               'BUKRS'          'Empresa'(001)                       'X'     space 15,
               'BUTXT'          'Descrição Empresa'(002)             'X'     space 25,
               'WERKS'          'Centro Manut.'(154)                 'X'     space 12,
               'NAME1'          'Descrição Centro Manut.'(155)       'X'     space 25.

    WHEN c_tabstrip-tab2.

      PERFORM alterar_atributos_coluna
        USING:
*           'NOME_COLUNA'       'Descrição'                          'X'     space.
               'MANDT'          'MANDT'                              space   space 10,
               'IWERK'          'Centro Planej.'(003)                'X'     space 10,
               'NAME1'          'Descrição Centro Planej.'(004)      'X'     space 20,
               'INGRP'          'Grupo Planej.'(005)                 'X'     space 11,
               'INNAM'          'Descrição Grupo Planej.'(006)       'X'     space 23,
               'FILTRO_EQUI'    'Filtro Equip.'(007)                 'X'     space 15,
               'FILTRO_LOCL'    'Filtro Local Inst.'(008)            'X'     space 15.

    WHEN c_tabstrip-tab3.

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'        'Descrição'                          'X'     space.
               'MANDT'          'MANDT'                              space   space 10,
               'WERKS'          'Centro'(003)                        'X'     space 10,
               'NAME1'          'Descrição Centro'(004)              'X'     space 20,
               'BEBER'          'Área Operacional'(009)              'X'     space 15,
               'FING'           'Descrição Área Op.'(010)            'X'     space 20,
               'FILTRO_EQUI'    'Filtro Equip.'(007)                 'X'     space 15,
               'FILTRO_LOCL'    'Filtro Local Inst.'(008)            'X'     space 15.

    WHEN c_tabstrip-tab4. "Centro de Trabalho

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'        'Descrição'                          'X'     space.
               'MANDT'          'MANDT'                              space   space 10,
               'OBJID'          'Centro Trabalho'(011)               'X'     space 12,
               'ARBPL'          'Descrição Centro Trabalho'(012)     'X'     space 25,
               'WERKS'          'Centro'(003)                        'X'     space 10,
               'NAME1'          'Descrição Centro'(004)              'X'     space 20,
               'FILTRO_EQUI'    'Filtro Equip.'(007)                 'X'     space 10,
               'FILTRO_LOCL'    'Filtro Local Inst.'(008)            'X'     space 15.

    WHEN c_tabstrip-tab5. "Categoria Local Instalação

      PERFORM alterar_atributos_coluna
        USING:
*           'NOME_COLUNA'    'Descrição'                             'X'     space.
               'MANDT'       'MANDT'                                 space   space 10,
               'FLTYP'       'Categoria L.Inst.'(013)                'X'    space 20,
               'TYPTX'       'Descrição L.Inst.'(014)                'X'    space 30.

    WHEN c_tabstrip-tab6. "Categoria Equipamento

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA' 'Descrição'                                 'X'    space.
               'MANDT'       'MANDT'                                 space  space 10,
               'EQTYP'       'Categoria Equip.'(015)                 'X'    space 20,
               'TYPTX'       'Descrição Equip.'(016)                 'X'    space 30.

    WHEN c_tabstrip-tab7. "Característica de equipamento

      PERFORM alterar_atributos_coluna
        USING:
           'MANDT'               'MANDT'                    space  space 10,
           'ATNAM'               'Característica'(139)      'X'    space 25,
           'ATBEZ'               'Descrição Característica'(140)           'X'    space 25,
           'ATINN'               'Descrição'(037)           space  space 55.


    WHEN c_tabstrip-tab8. "Equipamento - Status inclusivo
      PERFORM alterar_atributos_coluna
        USING:
               'MANDT'       'MANDT'                               space  space 10,
               'PERFIL'      ''                                    space  space 10,
               'STAT'        ''                                    space  space 25,
               'TXT04'       'Status'(134)                         'X'    space 25,
               'TXT30'       'Descrição Status'(135)               'X'    space 30.

    WHEN c_tabstrip-tab9. "Equipamento - Status exclusivo
      PERFORM alterar_atributos_coluna
        USING:
               'MANDT'       'MANDT'                               space  space 10,
               'PERFIL'      ''                                    space  space 10,
               'STAT'        ''                                    space  space 25,
               'TXT04'       'Status'(134)                         'X'    space 25,
               'TXT30'       'Descrição Status'(135)               'X'    space 30.

    WHEN c_tabstrip-tab10. "Tipo de objeto técnico

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA' 'Descrição'                               'X'    space.
               'MANDT'       'MANDT'                               space  space 10,
               'EQART'       'Tipo Objeto Técnico'(017)            'X'    space 25,
               'EARTX'       'Descrição Tipo Objeto Técnico'(018)  'X'    space 30,
               'FILTRO_EQUI' 'Filtro Equip.'(007)                  'X'    space 12,
               'FILTRO_LOCL' 'Filtro Local Inst.'(008)             'X'    space 15.

    WHEN c_tabstrip-tab11. "Tipo de Nota

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'     'Descrição'                           'X'    space.
               'MANDT'       'MANDT'                               space  space 10,
               'QMART'       'Tipo Nota'(019)                      'X'    space 08,
               'QMTYP'       'Cat. Nota'(020)                      'X'    space 10,
               'RBNR'        'Perfil do catálogo'(021)             'X'    space 15,
               'QMARTX'      'Descrição Perfil catálogo'(022)      'X'    space 25.

    WHEN c_tabstrip-tab12. "Tipo de Ordem

      PERFORM alterar_atributos_coluna
        USING:
               'MANDT'            'MANDT'                                    space  space 10,
               'AUART'            'Tipo Ordem'(023)                          'X'    space 10,
               'AUTYP'            'Cat. Ordem'(024)                          'X'    space 10,
               'TXT'              'Descrição Categoria Ordem'(025)           'X'    space 20,
               'FILTRO_CATALOGO'  'Configuração Catálogo'(132)               'X'    space 12,
               'FILTRO_TXT'       'Descrição Conf.Catálogo'(133) 'X' space 13.

    WHEN c_tabstrip-tab13. "Tipo Material

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA' 'Descrição'                         'X'    space.
               'MANDT'       'MANDT'                         space  space 10,
               'MTART'       'Tipo Material'(026)            'X'    space 11,
               'MTBEZ'       'Descrição Tipo Material'(027)  'X'    space 30.

    WHEN c_tabstrip-tab14. "Tipo Atividade Manutenção
      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA' 'Descrição'                                     'X'    space.
               'MANDT'       'MANDT'                                     space  space 10,
               'ILART'       'Tipo Atividade Manut.'(028)                'X'    space 18,
               'ILATX'       'Descrição Tipo Atividade Manutenção'(029)  'X'    space 40.

    WHEN c_tabstrip-tab15. "Grupo Mercadoria

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA' 'Descrição'                             'X'    space.
               'MANDT'       'MANDT'                             space  space 10,
               'MATKL'       'Grupo Mercadorias'(030)            'X'    space 15,
               'WGBEZ'       'Descrição Grupo Mercadorias'(031)  'X'    space 40.

    WHEN c_tabstrip-tab16. "Depósito

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'     'Descrição'                  'X'    space.
               'MANDT'       'MANDT'                      space  space 10,
               'WERKS'       'Centro'(003)                'X'    space 06,
               'NAME1'       'Descrição Centro'(004)      'X'    space 30,
               'LGORT'       'Depósito'(032)              'X'    space 09,
               'LGOBE'       'Descrição Depósito'(033)    'X'    space 35.

    WHEN c_tabstrip-tab17. "Causa Desvio

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'     'Descrição'                    'X'    space.
               'MANDT'       'MANDT'                        space  space 10,
               'WERKS'       'Centro'(003)                  'X'    space 06,
               'NAME1'       'Descrição Centro'(004)        'X'    space 30,
               'GRUND'       'Causa Desvio'(034)            'X'    space 12,
               'GRDTX'       'Descrição Causa Desvio'(035)  'X'    space 30.

    WHEN c_tabstrip-tab18. "Autorizações

      PERFORM alterar_atributos_coluna
        USING:
*             'NOME_COLUNA' 'Descrição'                     'X'    space.
              'AUTORIZACAO'       'Autorizações'(036)       'X'    space 15,
              'DESC_AUTORIZACAO'  'Descrição'(037)          'X'    space 40.

    WHEN c_tabstrip-tab19. "Configurações Gerais

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'        'Descrição'                 'X'    space.
           'CONFIGURACAO'       'Configuração'              'X'    space 15,
           'DESC_CONFIGURACAO'  'Descrição'(037)            'X'    space 55.

    WHEN c_tabstrip-tab20. "Lista de Tarefa

      PERFORM alterar_atributos_coluna
        USING:
*          'NOME_COLUNA'        'Descrição'                       'X'    space.
           'NRSEQ'              'Nr. Seq.'                        ' '    space 06,
           'PLNTY'              'Tp.Rot.'                         'X'    space 05,
           'TXT'                'Tp.Roteiro - Descrição'(150)     'X'    space 25,
           'PLNNR'              'Grp.Lst.Tar.'                    'X'    space 08,
           'KTEXT'              'Lista Tarefa - Descrição '       'X'    space 25,
           'PLNAL'              'Nr.Grp.            '             'X'    space 06,
           'ZAEHL'              'Numerador interno'               ' '    space 06,
           'WERKS'              'Centro'                          'X'    space 05,
           'EQUNR'              'Equipamento'                     'X'    space 13,
           'EQKTX'              'Equipamento - Descrição '        'X'    space 25,
           'TPLNR'              'Local Instalação'                'X'    space 20,
           'PLTXT'              'Local Instalação - Descrição '   'X'    space 25.

    WHEN OTHERS.

  ENDCASE.

  "Ordenar colunas no relatório ALV
  CASE g_tabstrip-pressed_tab.
    WHEN c_tabstrip-tab1.

      PERFORM ordenar_coluna
        USING:
               'BUKRS'   '1',
               'BUTXT'   '2',
               'WERKS'   '3',
               'NAME1'   '4'.

    WHEN c_tabstrip-tab2.

      PERFORM ordenar_coluna
        USING:
               'IWERK'   '1',
               'NAME1'   '2',
               'INGRP'   '3',
               'INNAM'   '4'.

    WHEN c_tabstrip-tab3.

      PERFORM ordenar_coluna
        USING:
               'WERKS'   '1',
               'NAME1'   '2',
               'BEBER'   '3',
               'FING'    '4'.

    WHEN c_tabstrip-tab4.

      PERFORM ordenar_coluna
        USING:
               'OBJID'   '1',
               'ARBPL'   '2',
               'WERKS'   '3',
               'NAME1'   '4'.

    WHEN c_tabstrip-tab5.

      PERFORM ordenar_coluna
        USING:
               'FLTYP'   '1',
               'TYPTX'   '2'.

    WHEN c_tabstrip-tab6.

      PERFORM ordenar_coluna
        USING:
               'EQTYP'   '1',
               'TYPTX'   '2'.

    WHEN c_tabstrip-tab7.

      " Colorir colunas
      PERFORM colorir_coluna
        USING:
               "Campo       Chave  "Cor
               'ATNAM' 'X'  '7' '0' '0'.

      PERFORM ordenar_coluna
        USING:
               'ATNAM'   '1'.

    WHEN c_tabstrip-tab8.

      PERFORM ordenar_coluna
        USING:
               'STATUS'   '1'.

    WHEN c_tabstrip-tab9.

      PERFORM ordenar_coluna
        USING:
               'STATUS'   '1'.

    WHEN c_tabstrip-tab10.

      PERFORM ordenar_coluna
        USING:
               'EQART'   '1',
               'EARTX'   '2'.

    WHEN c_tabstrip-tab11.

      PERFORM ordenar_coluna
        USING:
               'QMART'   '1',
               'QMTYP'   '2',
               'RBNR'    '3',
               'QMARTX'  '4'.

    WHEN c_tabstrip-tab12.

      PERFORM ordenar_coluna
        USING:
               'AUART'   '1',
               'AUTYP'   '2',
               'TXT'     '3'.

    WHEN c_tabstrip-tab13.

      PERFORM ordenar_coluna
        USING:
               'MTART'   '1',
               'MTBEZ'   '2'.

    WHEN c_tabstrip-tab14.

      PERFORM ordenar_coluna
        USING:
               'ILART'   '1',
               'ILATX'   '2'.

    WHEN c_tabstrip-tab15.

      PERFORM ordenar_coluna
        USING:
               'MATKL'   '1',
               'WGBEZ'   '2'.

    WHEN c_tabstrip-tab16.

      PERFORM ordenar_coluna
        USING:
               'WERKS'   '1',
               'NAME1'   '2',
               'LGORT'   '3',
               'LGOBE'   '4'.

    WHEN c_tabstrip-tab17.

      PERFORM ordenar_coluna
        USING:
               'WERKS'   '1',
               'NAME1'   '2',
               'GRUND'   '3',
               'GRDTX'   '4'.

    WHEN c_tabstrip-tab18.

      " Colorir colunas
      PERFORM colorir_coluna
        USING:
               "Campo       Chave  "Cor
               'AUTORIZACAO' 'X'  '7' '0' '0'.

    WHEN c_tabstrip-tab19.

      " Colorir colunas
      PERFORM colorir_coluna
        USING:
               "Campo       Chave  "Cor
               'CONFIGURACAO' 'X'  '7' '0' '0'.

    WHEN c_tabstrip-tab20.

      " Colorir colunas
      PERFORM colorir_coluna
        USING:
               "Campo       Chave  "Cor
               'PLNTY' 'X'  '7' '0' '0'.

    WHEN OTHERS.

  ENDCASE.

*  " Colorir colunas
*  PERFORM colorir_coluna
*    USING:
*           "Campo     Chave  "Cor
*           'BUKRS' space  '7' '0' '0',
*           'BUTXT' space  '7' '0' '0',
*           'WERKS' space  '7' '0' '0',"'6' '1' '0',
*           'NAME1' space  '7' '0' '0'."'6' '1' '0'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALTERAR_ATRIBUTOS_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0435   text
*      -->P_0436   text
*      -->P_0437   text
*      -->P_SPACE  text
*----------------------------------------------------------------------*
FORM alterar_atributos_coluna USING p_coluna  TYPE c
                                    p_texto   TYPE c
                                    p_visible TYPE c
                                    p_hotspot TYPE c
                                    p_tamanho TYPE lvc_outlen.

  DATA: l_texto_l TYPE scrtext_l,
        l_texto_m TYPE scrtext_m,
        l_texto_s TYPE scrtext_s,
        l_visible TYPE sap_bool.

  PERFORM buscar_coluna USING p_coluna.

  l_texto_l = p_texto.
  l_texto_m = p_texto.
  l_texto_s = p_texto.
  l_visible = p_visible.

  " Alterar o texto do cabeçalho da coluna
  o_column->set_long_text( l_texto_l ).
  o_column->set_medium_text( l_texto_m ).
  o_column->set_short_text( l_texto_s ).
  o_column->set_output_length( p_tamanho ).

  " Oculta coluna
  o_column->set_visible( l_visible ).

  " Ativar Hotspot coluna
  IF p_hotspot = 'X'.
    o_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ORDENAR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0491   text
*      -->P_0492   text
*----------------------------------------------------------------------*
FORM ordenar_coluna USING p_column TYPE c
                          p_pos    TYPE c.


  DATA: l_column TYPE lvc_fname,
        l_pos    TYPE i.

  l_column = p_column.
  l_pos    = p_pos.

* Ordena as colunas no alv
  o_columns->set_column_position( columnname = l_column  position = l_pos ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUSCAR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_COLUNA  text
*----------------------------------------------------------------------*
FORM buscar_coluna USING VALUE(p_coluna) TYPE c.

  TRY.
      o_column ?= o_columns->get_column( p_coluna ).

    CATCH cx_salv_not_found.
*      "Coluna & não existe
*      MESSAGE ...
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFICAR_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modificar_layout .

  CLEAR: st_key, g_default.

  st_key-report = sy-repid.
  g_default     = 'X'.

  o_layout = o_alv->get_layout( ).

  o_layout->set_key( st_key ).
  o_layout->set_default( g_default ).
  o_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REGISTRAR_EVENTOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM registrar_eventos .

* Registra os eventos
  o_events = o_alv->get_event( ).

  CREATE OBJECT o_handle_events.

  SET HANDLER o_handle_events->clique_duplo FOR o_events.
  SET HANDLER o_handle_events->clique_alv   FOR o_events.
  SET HANDLER o_handle_events->user_command FOR o_events.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  METODO_SELECAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM metodo_selecao .

  o_selections = o_alv->get_selections( ).
  o_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COLORIR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0667   text
*      -->P_0668   text
*      -->P_0669   text
*      -->P_0670   text
*----------------------------------------------------------------------*
FORM colorir_coluna USING VALUE(p_coluna) TYPE salv_s_column_ref-columnname
                          VALUE(p_key)    TYPE sap_bool
                          VALUE(pi_col)   TYPE lvc_s_colo-col
                          VALUE(pi_int)   TYPE lvc_s_colo-int
                          VALUE(pi_inv)   TYPE lvc_s_colo-inv.

* Colorir coluna
* 7 Laranja
* 6 Rosa
* 5 Verde
* 4 Azul
* 3 Amarelo
* 2 Azul claro

  " Fonte
* 0-1-0 Azul
* 6-0-1 Vermelho
* 5-0-1 Verde
* 2-0-1 Cinza

  DATA: ls_color  TYPE lvc_s_colo.

  TRY.

      o_column ?= o_columns->get_column( p_coluna ).

    CATCH cx_salv_not_found. " Campo & não existe

  ENDTRY.

*  ls_color-col = pi_col.
*  ls_color-int = pi_int.
*  ls_color-inv = pi_inv.
*  o_column->set_color( ls_color ).

  o_column->set_key( p_key ).
*  o_column->set_color( VALUE lvc_s_colo( col = pi_col int = pi_int inv = pi_inv ) ).
  DATA ti_lvc_s_colo TYPE lvc_s_colo.
  ti_lvc_s_colo-col = pi_col.
  ti_lvc_s_colo-int = pi_int.
  ti_lvc_s_colo-inv = pi_inv.
  o_column->set_color( ti_lvc_s_colo ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADICIONAR_BOTAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0407   text
*      -->P_ICON_RELEASE  text
*      -->P_0409   text
*      -->P_0410   text
*----------------------------------------------------------------------*
FORM adicionar_botao USING VALUE(p_name)    TYPE c
                            p_icon          TYPE any
                            p_text          TYPE c
                           VALUE(p_tooltip) TYPE c.

  DATA: l_name    TYPE salv_de_function,
        l_icon    TYPE string,
        l_text    TYPE string,
        l_tooltip TYPE string.

  l_name    = p_name.
  l_icon    = p_icon.
  l_text    = p_text.
  l_tooltip = p_tooltip.

  TRY.
      o_status->add_function(
        name     = l_name
        icon     = l_icon
        text     = l_text
        tooltip  = l_tooltip
        position = if_salv_c_function_position=>right_of_salv_functions ).
    CATCH cx_salv_existing .
    CATCH cx_salv_wrong_call .
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_EMPRESA_CENTRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_busca_empresa_centro .

  REFRESH gt_empresa_centro[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb014
      INTO CORRESPONDING FIELDS OF TABLE gt_empresa_centro
      WHERE perfil = gv_perfil.

    IF sy-subrc EQ 0.
**      SELECT bukrs, butxt
**        FROM t001
**        INTO TABLE @DATA(lt_t001)
**        FOR ALL ENTRIES IN @gt_empresa_centro
**        WHERE bukrs = @gt_empresa_centro-bukrs.

      DATA lt_t001 TYPE TABLE OF t001.
      DATA ls_t001 TYPE t001.
      SELECT bukrs butxt
        FROM t001
        INTO CORRESPONDING FIELDS OF TABLE lt_t001
        FOR ALL ENTRIES IN gt_empresa_centro
        WHERE bukrs = gt_empresa_centro-bukrs.

*      SELECT werks, name1
*        FROM t001w
*        INTO TABLE @DATA(lt_t001w)
*        FOR ALL ENTRIES IN @gt_empresa_centro
*        WHERE werks = @gt_empresa_centro-werks.

      DATA lt_t001w TYPE TABLE OF t001w.
      DATA ls_t001w TYPE t001w.

      SELECT werks name1
        FROM t001w
        APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
        FOR ALL ENTRIES IN gt_empresa_centro
        WHERE werks = gt_empresa_centro-werks.

    ENDIF.

*    LOOP AT gt_empresa_centro ASSIGNING FIELD-SYMBOL(<fs_empresa_centro>).
    FIELD-SYMBOLS <fs_empresa_centro> LIKE LINE OF gt_empresa_centro.
    LOOP AT gt_empresa_centro ASSIGNING <fs_empresa_centro>.
*      READ TABLE lt_t001 INTO DATA(ls_t001) WITH KEY bukrs = <fs_empresa_centro>-bukrs.
      READ TABLE lt_t001 INTO ls_t001 WITH KEY bukrs = <fs_empresa_centro>-bukrs.
      IF sy-subrc EQ 0.
        <fs_empresa_centro>-butxt = ls_t001-butxt.
      ENDIF.

*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = <fs_empresa_centro>-werks.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = <fs_empresa_centro>-werks.
      IF sy-subrc EQ 0.
        <fs_empresa_centro>-name1 = ls_t001w-name1.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_EMPRESA
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_empresa.

  TYPES: BEGIN OF ty_tab,
           bukrs TYPE t001-bukrs,
           butxt TYPE t001-butxt,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA lt_tb002 TYPE TABLE OF /ptloms/tb002.
  DATA ls_002 TYPE /ptloms/tb002.
  SELECT *
    FROM /ptloms/tb002
    INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.

*    SELECT bukrs, butxt
*      FROM t001
*      INTO TABLE @DATA(lt_t001)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE bukrs = @lt_tb002-bukrs.

    DATA lt_t001 TYPE TABLE OF t001.
    DATA ls_t001 TYPE t001.
    SELECT bukrs butxt
      FROM t001
      INTO CORRESPONDING FIELDS OF TABLE lt_t001
      FOR ALL ENTRIES IN lt_tb002
      WHERE bukrs = lt_tb002-bukrs.

*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.

  ENDIF.

*  LOOP AT lt_tb002 INTO DATA(ls_002).
  LOOP AT lt_tb002 INTO ls_002.

    READ TABLE gt_empresa_centro TRANSPORTING NO FIELDS WITH KEY bukrs  = ls_002-bukrs
                                                                 werks  = ls_002-werks.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_002 TO ls_tab.
*    READ TABLE lt_t001 INTO DATA(ls_t001) WITH KEY bukrs = ls_002-bukrs.
    READ TABLE lt_t001 INTO ls_t001 WITH KEY bukrs = ls_002-bukrs.
    ls_tab-butxt = ls_t001-butxt.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'BUKRS'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      wa_empresa_centro-bukrs = ls_return-fieldval.

      ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-BUKRS'.
      ls_dynpfields-fieldvalue = wa_empresa_centro-bukrs.
      APPEND ls_dynpfields TO lt_dynpfields.

      READ TABLE lt_t001 INTO ls_t001 WITH KEY bukrs = wa_empresa_centro-bukrs.

      IF sy-subrc EQ 0.

        wa_empresa_centro-butxt = ls_t001-butxt.

        ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-BUTXT'.
        ls_dynpfields-fieldvalue = wa_empresa_centro-butxt.
        APPEND ls_dynpfields TO lt_dynpfields.

      ENDIF.

*      READ TABLE lt_tb002 INTO ls_002 WITH KEY bukrs =  wa_empresa_centro-bukrs.
*
*      IF sy-subrc EQ 0.
*        wa_empresa_centro-werks = ls_002-werks.
*
*        ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-WERKS'.
*        ls_dynpfields-fieldvalue = wa_empresa_centro-werks.
*        APPEND ls_dynpfields TO lt_dynpfields.
*
*        READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = wa_empresa_centro-werks.
*
*        IF sy-subrc EQ 0.
*          wa_empresa_centro-name1 = ls_t001w-name1.
*
*          ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-NAME1'.
*          ls_dynpfields-fieldvalue = wa_empresa_centro-name1.
*          APPEND ls_dynpfields TO lt_dynpfields.
*        ENDIF.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

*      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_CENTRO
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_centro USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           bukrs TYPE t001-bukrs,
           butxt TYPE t001-butxt,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA:
    lt_tb002 TYPE TABLE OF /ptloms/tb002,
    ls_002   TYPE /ptloms/tb002.

  SELECT *
    FROM /ptloms/tb002
    INTO TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.

*    SELECT bukrs, butxt
*      FROM t001
*      INTO TABLE @DATA(lt_t001)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE bukrs = @lt_tb002-bukrs.

    DATA lt_t001 TYPE TABLE OF t001.
    DATA ls_t001 TYPE t001.
    SELECT bukrs butxt
      FROM t001
      INTO CORRESPONDING FIELDS OF TABLE lt_t001
      FOR ALL ENTRIES IN lt_tb002
      WHERE bukrs = lt_tb002-bukrs.

*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

*  LOOP AT lt_tb002 INTO DATA(ls_002).
  LOOP AT lt_tb002 INTO ls_002.

    READ TABLE gt_empresa_centro TRANSPORTING NO FIELDS WITH KEY bukrs  = ls_002-bukrs
                                                                 werks  = ls_002-werks.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_002 TO ls_tab.
*    READ TABLE lt_t001 INTO DATA(ls_t001) WITH KEY bukrs = ls_002-bukrs.
    READ TABLE lt_t001 INTO ls_t001 WITH KEY bukrs = ls_002-bukrs.
    ls_tab-butxt = ls_t001-butxt.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
      multiple_choice = p_mult
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    IF p_mult = 'X'.

      PERFORM f_seleciona_mult_centro_adm TABLES lt_return
                                                 lt_tab.

    ELSE.

      " --- Recupera o registro selecionado pelo usuário
*      READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
      DATA ls_return LIKE LINE OF lt_return.
      READ TABLE lt_return INTO ls_return INDEX 1.

      IF sy-subrc = 0.

        CLEAR lv_tabix.

        " --- Atribui valor ao campo da tela
        REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
        MOVE ls_return-fieldval TO lv_tabix.

        READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

        wa_empresa_centro-werks = ls_tab-werks.

        ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-WERKS'.
        ls_dynpfields-fieldvalue = wa_empresa_centro-werks.
        APPEND ls_dynpfields TO lt_dynpfields.

        wa_empresa_centro-name1 = ls_tab-name1.

        ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-NAME1'.
        ls_dynpfields-fieldvalue = wa_empresa_centro-name1.
        APPEND ls_dynpfields TO lt_dynpfields.

        wa_empresa_centro-bukrs = ls_tab-bukrs.

        ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-BUKRS'.
        ls_dynpfields-fieldvalue = wa_empresa_centro-bukrs.
        APPEND ls_dynpfields TO lt_dynpfields.

        wa_empresa_centro-butxt = ls_tab-butxt.

        ls_dynpfields-fieldname = 'WA_EMPRESA_CENTRO-BUTXT'.
        ls_dynpfields-fieldvalue = wa_empresa_centro-butxt.
        APPEND ls_dynpfields TO lt_dynpfields.

        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_EMPRESA_CENTRO
*&---------------------------------------------------------------------*
FORM f_valida_empresa_centro .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Empresa/Centro é válido
    IF wa_empresa_centro-bukrs IS NOT INITIAL AND
       wa_empresa_centro-werks IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb002
*        INTO @DATA(ls_002)
*        WHERE bukrs = @wa_empresa_centro-bukrs
*          AND werks = @wa_empresa_centro-werks.

      DATA:
        ls_002 TYPE /ptloms/tb002.

      SELECT SINGLE *
        FROM /ptloms/tb002
        INTO ls_002
        WHERE bukrs = wa_empresa_centro-bukrs
          AND werks = wa_empresa_centro-werks.

      IF sy-subrc NE 0.
        CLEAR: wa_empresa_centro-bukrs, wa_empresa_centro-werks,
               wa_empresa_centro-butxt, wa_empresa_centro-name1.
        MESSAGE e000(su) WITH 'Empresa/Centro inválido'(100).
      ENDIF.

      " Verifica se Empresa/Centro já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb014
*        INTO @DATA(ls_014)
*        WHERE perfil = @gv_perfil
*          AND bukrs  = @wa_empresa_centro-bukrs
*          AND werks  = @wa_empresa_centro-werks.

      DATA ls_014 TYPE /ptloms/tb014.
      SELECT SINGLE *
        FROM /ptloms/tb014
        INTO ls_014
        WHERE perfil = gv_perfil
          AND bukrs  = wa_empresa_centro-bukrs
          AND werks  = wa_empresa_centro-werks.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição da empresa
    IF wa_empresa_centro-bukrs IS NOT INITIAL.
      SELECT SINGLE butxt
        FROM t001
        INTO wa_empresa_centro-butxt
        WHERE bukrs = wa_empresa_centro-bukrs.
    ELSE.
      CLEAR: wa_empresa_centro-bukrs, wa_empresa_centro-butxt.
      MESSAGE e000(su) WITH 'Empresa inválida'(101).
    ENDIF.

    " Busca descrição do centro
    IF wa_empresa_centro-werks IS NOT INITIAL.
      SELECT SINGLE name1
        FROM t001w
        INTO wa_empresa_centro-name1
        WHERE werks = wa_empresa_centro-werks.
    ELSE.
      CLEAR: wa_empresa_centro-werks, wa_empresa_centro-name1.
      MESSAGE e000(su) WITH 'Centro inválido'(058).
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_EMPRESA_CENTRO
*&---------------------------------------------------------------------*
FORM f_grava_empresa_centro .

  DATA: ls_014            TYPE /ptloms/tb014,
        ls_empresa_centro LIKE LINE OF gt_empresa_centro.

  ls_014-perfil = gv_perfil.
  ls_014-bukrs  = wa_empresa_centro-bukrs.
  ls_014-werks  = wa_empresa_centro-werks.

  MODIFY /ptloms/tb014 FROM ls_014.

  IF sy-subrc EQ 0.

    MOVE-CORRESPONDING wa_empresa_centro TO ls_empresa_centro.

*    MOVE-CORRESPONDING ls_014 TO ls_empresa_centro.
*
*    SELECT SINGLE butxt
*      FROM t001
*      INTO ls_empresa_centro-butxt
*      WHERE bukrs = ls_empresa_centro-bukrs.
*
*    SELECT SINGLE name1
*      FROM t001w
*      INTO ls_empresa_centro-name1
*      WHERE werks = ls_empresa_centro-werks.

    APPEND ls_empresa_centro TO gt_empresa_centro.
    SORT gt_empresa_centro BY bukrs ASCENDING werks ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_EMPRESA_CENTRO
*&---------------------------------------------------------------------*
FORM f_deleta_empresa_centro .

  DATA: lv_resposta(1) TYPE c,
        lv_qtde        TYPE i,
        lv_qtde_aux(2) TYPE c.

* READ TABLE o_rows INTO DATA(lv_rows) INDEX 1.

  DESCRIBE TABLE o_rows LINES lv_qtde.
  MOVE lv_qtde TO lv_qtde_aux.

  IF lv_qtde = 1.
    DATA: lv_msg_tela(100) TYPE c.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*   lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_empresa_centro) = gt_empresa_centro.
    DATA lt_empresa_centro TYPE TABLE OF /ptloms/v001.
    DATA ls_tab LIKE LINE OF lt_empresa_centro.
    REFRESH lt_empresa_centro.
    lt_empresa_centro[] = gt_empresa_centro[].

*    LOOP AT o_rows INTO DATA(lv_row_aux).
    DATA lv_row_aux LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row_aux.
*      READ TABLE lt_empresa_centro INTO DATA(ls_tab) INDEX lv_row_aux.
      READ TABLE lt_empresa_centro INTO ls_tab INDEX lv_row_aux.
      IF sy-subrc EQ 0.

        DATA lv_permiss TYPE c LENGTH 1.
        CALL METHOD /ptloms/cl006=>verifica_permissao_centro
          EXPORTING
            im_tcode            = sy-tcode
            im_werks            = ls_tab-werks
          IMPORTING
            ex_possui_permissao = lv_permiss.

        IF lv_permiss  IS INITIAL.
          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = ls_tab-werks ) IS INITIAL.
*          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
*          RETURN.
*        ENDIF.

*        SELECT SINGLE * FROM /ptloms/tb015 INTO @DATA(ls_tb015) WHERE perfil = @gv_perfil AND iwerk = @ls_tab-werks.
        DATA ls_tb015 TYPE /ptloms/tb015.
        SELECT SINGLE * FROM /ptloms/tb015 INTO ls_tb015 WHERE perfil = gv_perfil AND iwerk = ls_tab-werks.
        IF sy-subrc EQ 0.
          MESSAGE s004(/ptloms/cm001) WITH ls_tab-werks 'Grupo Planejamento'(126) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        SELECT SINGLE * FROM /ptloms/tb016 INTO @DATA(ls_tb016) WHERE perfil = @gv_perfil AND werks = @ls_tab-werks.
        DATA ls_tb016 TYPE /ptloms/tb016.
        SELECT SINGLE * FROM /ptloms/tb016 INTO ls_tb016 WHERE perfil = gv_perfil AND werks = ls_tab-werks.
        IF sy-subrc EQ 0.
          MESSAGE s004(/ptloms/cm001) WITH ls_tab-werks 'Área Operacional'(009) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        SELECT SINGLE * FROM /ptloms/tb017 INTO @DATA(ls_tb017) WHERE perfil = @gv_perfil AND werks = @ls_tab-werks.
        DATA ls_tb017 TYPE /ptloms/tb017.
        SELECT SINGLE * FROM /ptloms/tb017 INTO ls_tb017 WHERE perfil = gv_perfil AND werks = ls_tab-werks.
        IF sy-subrc EQ 0.
          MESSAGE s004(/ptloms/cm001) WITH ls_tab-werks 'Centro de Trabalho'(127) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        SELECT SINGLE * FROM /ptloms/tb030 INTO @DATA(ls_tb030) WHERE perfil = @gv_perfil AND werks = @ls_tab-werks.
        DATA ls_tb030 TYPE /ptloms/tb030.
        SELECT SINGLE * FROM /ptloms/tb030 INTO ls_tb030 WHERE perfil = gv_perfil AND werks = ls_tab-werks.
        IF sy-subrc EQ 0.
          MESSAGE s004(/ptloms/cm001) WITH ls_tab-werks 'Depósito'(032) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        SELECT SINGLE * FROM /ptloms/tb039 INTO @DATA(ls_tb039) WHERE perfil = @gv_perfil AND werks = @ls_tab-werks.
        DATA ls_tb039 TYPE /ptloms/tb039.
        SELECT SINGLE * FROM /ptloms/tb039 INTO ls_tb039 WHERE perfil = gv_perfil AND werks = ls_tab-werks.
        IF sy-subrc EQ 0.
          MESSAGE s004(/ptloms/cm001) WITH ls_tab-werks 'Causa Desvio'(034) DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

      ENDIF.
    ENDLOOP.

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_empresa_centro INTO DATA(ls_empresa_centro) INDEX lv_row.
      READ TABLE lt_empresa_centro INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_empresa_centro WHERE bukrs  = ls_tab-bukrs
                                   AND werks  = ls_tab-werks.

        " Remove da tabela /ptloms/tb014
        DELETE FROM /ptloms/tb014 WHERE perfil = gv_perfil
                                    AND bukrs  = ls_tab-bukrs
                                    AND werks  = ls_tab-werks.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE char1.
          lv_erro = 'X'.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_GRUPO_PLANEJAMENTO
*&---------------------------------------------------------------------*
FORM f_busca_grupo_planejamento .

  REFRESH gt_grupo_planejamento[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb015
      INTO CORRESPONDING FIELDS OF TABLE gt_grupo_planejamento
      WHERE perfil = gv_perfil.

    IF gt_grupo_planejamento[] IS NOT INITIAL.
*      SELECT werks, name1
*        FROM t001w
*        INTO TABLE @DATA(lt_t001w)
*        FOR ALL ENTRIES IN @gt_grupo_planejamento
*        WHERE werks = @gt_grupo_planejamento-iwerk.
      DATA lt_t001w TYPE TABLE OF t001w.
      DATA ls_t001w TYPE t001w.

      SELECT werks name1
        FROM t001w
        APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
        FOR ALL ENTRIES IN gt_grupo_planejamento
          WHERE werks = gt_grupo_planejamento-iwerk.

*      SELECT iwerk, ingrp, innam
*        FROM t024i
*        INTO TABLE @DATA(lt_t024i)
*        FOR ALL ENTRIES IN @gt_grupo_planejamento
*        WHERE iwerk = @gt_grupo_planejamento-iwerk
*          AND ingrp = @gt_grupo_planejamento-ingrp.
      DATA lt_t024i TYPE TABLE OF t024i.
      DATA ls_t024i TYPE t024i.
      SELECT iwerk ingrp innam
        FROM t024i
        INTO CORRESPONDING FIELDS OF TABLE lt_t024i
        FOR ALL ENTRIES IN gt_grupo_planejamento
        WHERE iwerk = gt_grupo_planejamento-iwerk
          AND ingrp = gt_grupo_planejamento-ingrp.
    ENDIF.

*    LOOP AT gt_grupo_planejamento ASSIGNING FIELD-SYMBOL(<fs_grupo_planejamento>).
    FIELD-SYMBOLS <fs_grupo_planejamento> LIKE LINE OF gt_grupo_planejamento.
    LOOP AT gt_grupo_planejamento ASSIGNING <fs_grupo_planejamento>.
*      READ TABLE lt_t001w INTO DATA(ls_t001w)
      READ TABLE lt_t001w INTO ls_t001w
      WITH KEY werks = <fs_grupo_planejamento>-iwerk.

      IF sy-subrc EQ 0.
        <fs_grupo_planejamento>-name1 = ls_t001w-name1.
      ENDIF.

*      READ TABLE lt_t024i INTO DATA(ls_t024i)
      READ TABLE lt_t024i INTO ls_t024i
      WITH KEY iwerk = <fs_grupo_planejamento>-iwerk
               ingrp = <fs_grupo_planejamento>-ingrp.

      IF sy-subrc EQ 0.
        <fs_grupo_planejamento>-innam = ls_t024i-innam.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_CENTRO_GRP_P
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_centro_grp_p USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           iwerk TYPE t024i-iwerk,
           name1 TYPE t001w-name1,
           ingrp TYPE t024i-ingrp,
           innam TYPE t024i-innam,
         END OF ty_tab.

  DATA: r_iwerk TYPE RANGE OF /ptloms/tb003-iwerk.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_tab        LIKE LINE OF lt_tab,
        ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: lv_tabix TYPE sy-tabix.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb003
*    INTO TABLE @DATA(lt_tb003)
*    WHERE iwerk IN @r_iwerk.
  DATA lt_tb003 TYPE TABLE OF /ptloms/tb003.
  DATA ls_003 TYPE /ptloms/tb003.
  SELECT *
    FROM /ptloms/tb003
    INTO TABLE lt_tb003
    WHERE iwerk IN r_iwerk.

* Busca descrição dos centros
  IF lt_tb003[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb003
*      WHERE werks = @lt_tb003-iwerk.

    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb003
      WHERE werks = lt_tb003-iwerk.

*    SELECT iwerk, ingrp, innam
*      FROM t024i
*      INTO TABLE @DATA(lt_t024i)
*      FOR ALL ENTRIES IN @lt_tb003
*      WHERE iwerk = @lt_tb003-iwerk
*        AND ingrp = @lt_tb003-ingrp.

    DATA lt_t024i TYPE TABLE OF t024i.
    DATA ls_t024i TYPE t024i.
    SELECT iwerk ingrp innam
      FROM t024i
      INTO CORRESPONDING FIELDS OF TABLE lt_t024i
      FOR ALL ENTRIES IN lt_tb003
      WHERE iwerk = lt_tb003-iwerk
        AND ingrp = lt_tb003-ingrp.
  ENDIF.

*  LOOP AT lt_tb003 INTO DATA(ls_003).
  LOOP AT lt_tb003 INTO ls_003.

    READ TABLE gt_grupo_planejamento TRANSPORTING NO FIELDS WITH KEY ingrp  = ls_003-ingrp
                                                                     iwerk  = ls_003-iwerk.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_003 TO ls_tab.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_003-iwerk.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_003-iwerk.
    IF sy-subrc EQ 0.
      ls_tab-name1 = ls_t001w-name1.
    ENDIF.
*    READ TABLE lt_t024i INTO DATA(ls_t024i)
    READ TABLE lt_t024i INTO ls_t024i
    WITH KEY iwerk = ls_003-iwerk
             ingrp = ls_003-ingrp.
    IF sy-subrc EQ 0.
      ls_tab-innam = ls_t024i-innam.
    ENDIF.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
      multiple_choice = p_mult
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    IF p_mult = 'X'.

      PERFORM f_seleciona_mult_centro_grp_p TABLES lt_return
                                                   lt_tab.

    ELSE.

      " --- Recupera o registro selecionado pelo usuário
*      READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
      DATA ls_return LIKE LINE OF lt_return.
      READ TABLE lt_return INTO ls_return INDEX 1.

      IF sy-subrc = 0.

        CLEAR lv_tabix.

        " --- Atribui valor ao campo da tela
        REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
        MOVE ls_return-fieldval TO lv_tabix.

        READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

        wa_grupo_planejamento-iwerk = ls_tab-iwerk.
        ls_dynpfields-fieldname = 'WA_GRUPO_PLANEJAMENTO-IWERK'.
        ls_dynpfields-fieldvalue = wa_grupo_planejamento-iwerk.
        APPEND ls_dynpfields TO lt_dynpfields.

        wa_grupo_planejamento-name1 = ls_tab-name1.
        ls_dynpfields-fieldname = 'WA_GRUPO_PLANEJAMENTO-NAME1'.
        ls_dynpfields-fieldvalue = wa_grupo_planejamento-name1.
        APPEND ls_dynpfields TO lt_dynpfields.


        wa_grupo_planejamento-ingrp = ls_tab-ingrp.
        ls_dynpfields-fieldname = 'WA_GRUPO_PLANEJAMENTO-INGRP'.
        ls_dynpfields-fieldvalue = wa_grupo_planejamento-ingrp.
        APPEND ls_dynpfields TO lt_dynpfields.

        wa_grupo_planejamento-innam = ls_tab-innam.
        ls_dynpfields-fieldname = 'WA_GRUPO_PLANEJAMENTO-INNAM'.
        ls_dynpfields-fieldvalue = wa_grupo_planejamento-innam.
        APPEND ls_dynpfields TO lt_dynpfields.

        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.

      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_GRP_P
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_grp_p .

  TYPES: BEGIN OF ty_tab,
           iwerk TYPE t024i-iwerk,
           name1 TYPE t001w-name1,
           ingrp TYPE t024i-ingrp,
           innam TYPE t024i-innam,
         END OF ty_tab.

  DATA: r_iwerk TYPE RANGE OF /ptloms/tb003-iwerk.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_tab        LIKE LINE OF lt_tab,
        ls_dynpfields LIKE LINE OF lt_dynpfields.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb003
*    INTO TABLE @DATA(lt_tb003)
*    WHERE iwerk IN @r_iwerk.

  DATA lt_tb003 TYPE TABLE OF /ptloms/tb003.
  DATA ls_003 TYPE /ptloms/tb003.
  SELECT *
    FROM /ptloms/tb003
    INTO TABLE lt_tb003
    WHERE iwerk IN r_iwerk.

* Busca descrição dos centros
  IF lt_tb003[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb003
*      WHERE werks = @lt_tb003-iwerk.

    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb003
      WHERE werks = lt_tb003-iwerk.

*    SELECT iwerk, ingrp, innam
*      FROM t024i
*      INTO TABLE @DATA(lt_t024i)
*      FOR ALL ENTRIES IN @lt_tb003
*      WHERE iwerk = @lt_tb003-iwerk
*        AND ingrp = @lt_tb003-ingrp.

    DATA lt_t024i TYPE TABLE OF t024i.
    DATA ls_t024i TYPE t024i.
    SELECT iwerk ingrp innam
      FROM t024i
      INTO CORRESPONDING FIELDS OF TABLE lt_t024i
      FOR ALL ENTRIES IN lt_tb003
      WHERE iwerk = lt_tb003-iwerk
        AND ingrp = lt_tb003-ingrp.
  ENDIF.

*  LOOP AT lt_tb003 INTO DATA(ls_003).
  LOOP AT lt_tb003 INTO ls_003.

    READ TABLE gt_grupo_planejamento TRANSPORTING NO FIELDS WITH KEY ingrp  = ls_003-ingrp
                                                                     iwerk  = ls_003-iwerk.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    MOVE-CORRESPONDING ls_003 TO ls_tab.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_003-iwerk.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_003-iwerk.
    IF sy-subrc EQ 0.
      ls_tab-name1 = ls_t001w-name1.
    ENDIF.

*    READ TABLE lt_t024i INTO DATA(ls_t024i)
    READ TABLE lt_t024i INTO ls_t024i
    WITH KEY iwerk = ls_003-iwerk
             ingrp = ls_003-ingrp.
    IF sy-subrc EQ 0.
      ls_tab-innam = ls_t024i-innam.
    ENDIF.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'INGRP'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      " --- Atribui valor ao campo da tela
      wa_grupo_planejamento-ingrp = ls_return-fieldval.

      READ TABLE lt_t024i INTO ls_t024i WITH KEY ingrp = wa_grupo_planejamento-ingrp.

      IF sy-subrc EQ 0.
        wa_grupo_planejamento-innam = ls_t024i-innam.

        ls_dynpfields-fieldname = 'WA_GRUPO_PLANEJAMENTO-INNAM'.
        ls_dynpfields-fieldvalue = wa_grupo_planejamento-innam.
        APPEND ls_dynpfields TO lt_dynpfields.

        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.
      ENDIF.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_LISTA_TAREFA
*&---------------------------------------------------------------------*
FORM f_help_lista_tarefa USING p_mult TYPE ddbool_d.

  TYPES:
    BEGIN OF ty_tab,
      nrseq TYPE /ptloms/tb064-nrseq,
      plnty TYPE /ptloms/tb064-plnty,
      txt   TYPE /ptloms/tb064-txt,
      plnnr TYPE /ptloms/tb064-plnnr,
      ktext TYPE /ptloms/tb064-ktext,
      plnal TYPE /ptloms/tb064-plnal,
*      zaehl TYPE /ptloms/tb064-zaehl,
      werks TYPE /ptloms/tb064-werks,
      equnr TYPE /ptloms/tb064-equnr,
      eqktx TYPE /ptloms/tb064-eqktx,
      tplnr TYPE /ptloms/tb064-tplnr,
      pltxt TYPE /ptloms/tb064-pltxt,
    END OF ty_tab.

  DATA:
    lt_return     TYPE STANDARD TABLE OF ddshretval,
    lt_dynpfields TYPE STANDARD TABLE OF dynpread,
    ls_dynpfields LIKE LINE OF lt_dynpfields,
    lt_tb064      TYPE STANDARD TABLE OF ty_tab,
    ls_tb064      TYPE ty_tab.

* Carrega tabela de escolha (POPUP)
  PERFORM f_busca_plko.

  IF gt_tb064[] IS INITIAL.
    MESSAGE i000(su) WITH 'Todas as opções já foram incluídas'.
    RETURN.
  ENDIF.

  REFRESH:
    lt_tb064.

  LOOP AT gt_tb064 INTO wa_tb064.

    MOVE-CORRESPONDING wa_tb064 TO ls_tb064.
    APPEND ls_tb064 TO lt_tb064.

  ENDLOOP.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'NRSEQ'
      value_org       = 'S'
      multiple_choice = p_mult
    TABLES
      value_tab       = lt_tb064
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    " --- Recupera o registro selecionado pelo usuário
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

      PERFORM f_seleciona_mult_lista_tarefa TABLES lt_return.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_GRUPO_PLANEJAMENTO
*&---------------------------------------------------------------------*
FORM f_valida_grupo_planejamento .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Grupo de Planejamento é válido
    IF wa_grupo_planejamento-iwerk IS NOT INITIAL AND
       wa_grupo_planejamento-ingrp IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb003
*        INTO @DATA(ls_003)
*        WHERE iwerk = @wa_grupo_planejamento-iwerk
*          AND ingrp = @wa_grupo_planejamento-ingrp.

      DATA ls_003 TYPE /ptloms/tb003.
      SELECT SINGLE *
        FROM /ptloms/tb003
        INTO ls_003
        WHERE iwerk = wa_grupo_planejamento-iwerk
          AND ingrp = wa_grupo_planejamento-ingrp.

      IF sy-subrc NE 0.
        CLEAR: wa_grupo_planejamento-iwerk, wa_grupo_planejamento-name1,
               wa_grupo_planejamento-ingrp, wa_grupo_planejamento-innam.
        MESSAGE e000(su) WITH 'Centro/Grupo Planejamento inválido'(104).
      ENDIF.

      " Verifica se Grupo de Planejamento já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb015
*        INTO @DATA(ls_015)
*        WHERE perfil = @gv_perfil
*          AND iwerk  = @wa_grupo_planejamento-iwerk
*          AND ingrp  = @wa_grupo_planejamento-ingrp.

      DATA ls_015 TYPE /ptloms/tb015.
      SELECT SINGLE *
        FROM /ptloms/tb015
        INTO ls_015
        WHERE perfil = gv_perfil
          AND iwerk  = wa_grupo_planejamento-iwerk
          AND ingrp  = wa_grupo_planejamento-ingrp.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do centro
    IF wa_grupo_planejamento-iwerk IS NOT INITIAL.
      SELECT SINGLE name1
        FROM t001w
        INTO wa_grupo_planejamento-name1
        WHERE werks = wa_grupo_planejamento-iwerk.
    ELSE.
      CLEAR: wa_grupo_planejamento-iwerk, wa_grupo_planejamento-name1.
      MESSAGE e000(su) WITH 'Centro inválido'(058).
    ENDIF.

    " Busca descrição do grupo de planejamento
    IF wa_grupo_planejamento-ingrp IS NOT INITIAL.
      SELECT SINGLE innam
        FROM t024i
        INTO wa_grupo_planejamento-innam
        WHERE ingrp = wa_grupo_planejamento-ingrp.
    ELSE.
      CLEAR: wa_grupo_planejamento-ingrp, wa_grupo_planejamento-innam.
      MESSAGE e000(su) WITH 'Grp.Planejamento inválido'(105).
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_GRUPO_PLANEJAMENTO
*&---------------------------------------------------------------------*
FORM f_deleta_grupo_planejamento .

  DATA lv_resposta(1) TYPE c.

  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_grupo_planejamento) = gt_grupo_planejamento.
    DATA lt_grupo_planejamento TYPE TABLE OF ty_grupo_planejamento.
    DATA ls_tab                TYPE ty_grupo_planejamento.
    REFRESH lt_grupo_planejamento.
    lt_grupo_planejamento[] = gt_grupo_planejamento[].

*    LOOP AT o_rows INTO DATA(lv_row_aux).
    DATA lv_row_aux LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row_aux.
*      READ TABLE lt_grupo_planejamento INTO DATA(ls_tab) INDEX lv_row_aux.
      READ TABLE lt_grupo_planejamento INTO ls_tab INDEX lv_row_aux.
      IF sy-subrc EQ 0.
        DATA lv_permiss TYPE c LENGTH 1.
        CALL METHOD /ptloms/cl006=>verifica_permissao_centro
          EXPORTING
            im_tcode            = sy-tcode
            im_werks            = ls_tab-iwerk
          IMPORTING
            ex_possui_permissao = lv_permiss.

        IF lv_permiss  IS INITIAL.
          MESSAGE s002(/ptloms/cm001) WITH ls_tab-iwerk DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.
*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = ls_tab-iwerk ) IS INITIAL.
*          MESSAGE s002(/ptloms/cm001) WITH ls_tab-iwerk DISPLAY LIKE 'E'.
*          RETURN.
*        ENDIF.
      ENDIF.
    ENDLOOP.

*    LOOP AT o_rows INTO DATA(lv_row).
    LOOP AT o_rows INTO lv_row_aux.
      READ TABLE lt_grupo_planejamento INTO ls_tab INDEX lv_row_aux.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_grupo_planejamento WHERE iwerk  = ls_tab-iwerk
                                       AND ingrp  = ls_tab-ingrp.

        " Remove da tabela /ptloms/tb015
        DELETE FROM /ptloms/tb015 WHERE perfil = gv_perfil
                                    AND iwerk  = ls_tab-iwerk
                                    AND ingrp  = ls_tab-ingrp.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_GRUPO_PLANEJAMENTO
*&---------------------------------------------------------------------*
FORM f_grava_grupo_planejamento .

  DATA: ls_015                TYPE /ptloms/tb015,
        ls_grupo_planejamento LIKE LINE OF gt_grupo_planejamento.

  ls_015-perfil = gv_perfil.
  ls_015-iwerk  = wa_grupo_planejamento-iwerk.
  ls_015-ingrp  = wa_grupo_planejamento-ingrp.
  ls_015-filtro_equi = wa_grupo_planejamento-filtro_equi.
  ls_015-filtro_locl = wa_grupo_planejamento-filtro_locl.

  MODIFY /ptloms/tb015 FROM ls_015.

  IF sy-subrc EQ 0.

*    READ TABLE gt_grupo_planejamento ASSIGNING FIELD-SYMBOL(<fs_grupo_planejamento>)
    FIELD-SYMBOLS <fs_grupo_planejamento> LIKE LINE OF gt_grupo_planejamento.
    READ TABLE gt_grupo_planejamento ASSIGNING <fs_grupo_planejamento>
    WITH KEY "perfil = gv_perfil
             iwerk = wa_grupo_planejamento-iwerk
             ingrp = wa_grupo_planejamento-ingrp.
    IF sy-subrc EQ 0.
      <fs_grupo_planejamento>-filtro_equi = wa_grupo_planejamento-filtro_equi.
      <fs_grupo_planejamento>-filtro_locl = wa_grupo_planejamento-filtro_locl.
    ENDIF.
*    MOVE-CORRESPONDING wa_grupo_planejamento TO ls_grupo_planejamento.
*
**    MOVE-CORRESPONDING ls_015 TO ls_grupo_planejamento.
**
**    SELECT SINGLE name1
**      FROM t001w
**      INTO ls_grupo_planejamento-name1
**      WHERE werks = ls_grupo_planejamento-iwerk.
**
**    SELECT SINGLE innam
**      FROM t024i
**      INTO ls_grupo_planejamento-innam
**      WHERE iwerk = ls_grupo_planejamento-iwerk
**        AND ingrp = ls_grupo_planejamento-ingrp.
*
*    APPEND ls_grupo_planejamento TO gt_grupo_planejamento.
*    SORT gt_grupo_planejamento BY iwerk ASCENDING ingrp ASCENDING.

    MESSAGE s000(su) WITH 'Registro atualizado com sucesso'(044).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao atualizar registro'(045) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_AREA_OPERACIONAL
*&---------------------------------------------------------------------*
FORM f_busca_area_operacional .

  REFRESH gt_area_operacional[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb016
      INTO CORRESPONDING FIELDS OF TABLE gt_area_operacional
      WHERE perfil = gv_perfil.

    IF gt_area_operacional[] IS NOT INITIAL.
*      SELECT werks, name1
*        FROM t001w
*        INTO TABLE @DATA(lt_t001w)
*        FOR ALL ENTRIES IN @gt_area_operacional
*        WHERE werks = @gt_area_operacional-werks.
      DATA lt_t001w TYPE TABLE OF t001w.
      DATA ls_t001w TYPE t001w.

      SELECT werks name1
        FROM t001w
        APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
        FOR ALL ENTRIES IN gt_area_operacional
          WHERE werks = gt_area_operacional-werks.

*      SELECT werks, beber, fing
*        FROM t357
*        INTO TABLE @DATA(lt_t357)
*        FOR ALL ENTRIES IN @gt_area_operacional
*        WHERE werks = @gt_area_operacional-werks.

      DATA lt_t357 TYPE TABLE OF t357.
      DATA ls_t357 TYPE t357.
      SELECT werks beber fing
        FROM t357
        INTO CORRESPONDING FIELDS OF TABLE lt_t357
        FOR ALL ENTRIES IN gt_area_operacional
        WHERE werks = gt_area_operacional-werks.
    ENDIF.

*    LOOP AT gt_area_operacional ASSIGNING FIELD-SYMBOL(<fs_area_operacional>).
    FIELD-SYMBOLS <fs_area_operacional> LIKE LINE OF gt_area_operacional.
    LOOP AT gt_area_operacional ASSIGNING <fs_area_operacional>.
*      READ TABLE lt_t001w INTO DATA(ls_t001w)
      READ TABLE lt_t001w INTO ls_t001w
      WITH KEY werks = <fs_area_operacional>-werks.

      IF sy-subrc EQ 0.
        <fs_area_operacional>-name1 = ls_t001w-name1.
      ENDIF.

*      READ TABLE lt_t357 INTO DATA(ls_t357)
      READ TABLE lt_t357 INTO ls_t357
      WITH KEY werks = <fs_area_operacional>-werks.

      IF sy-subrc EQ 0.
        <fs_area_operacional>-fing = ls_t357-fing.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_CENTRO_TRABALHO
*&---------------------------------------------------------------------*
FORM f_busca_centro_trabalho .

  REFRESH gt_centro_trabalho[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb017
      INTO CORRESPONDING FIELDS OF TABLE gt_centro_trabalho
      WHERE perfil = gv_perfil.

    IF gt_centro_trabalho[] IS NOT INITIAL.

*      SELECT *
*        FROM /ptloms/tb005
*        INTO TABLE @DATA(lt_005)
*        FOR ALL ENTRIES IN @gt_centro_trabalho
*        WHERE objid = @gt_centro_trabalho-objid
*          AND werks = @gt_centro_trabalho-werks.

      DATA lt_005 TYPE TABLE OF /ptloms/tb005.
      DATA ls_005 TYPE /ptloms/tb005.
      SELECT *
        FROM /ptloms/tb005
        INTO TABLE lt_005
        FOR ALL ENTRIES IN gt_centro_trabalho
        WHERE objid = gt_centro_trabalho-objid
          AND werks = gt_centro_trabalho-werks.

*      SELECT werks, name1
*        FROM t001w
*        INTO TABLE @DATA(lt_t001w)
*        FOR ALL ENTRIES IN @gt_centro_trabalho
*        WHERE werks = @gt_centro_trabalho-werks.
      DATA lt_t001w TYPE TABLE OF t001w.
      DATA ls_t001w TYPE t001w.

      SELECT werks name1
        FROM t001w
        APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
        FOR ALL ENTRIES IN gt_centro_trabalho
         WHERE werks = gt_centro_trabalho-werks.

*      SELECT objty, objid, arbpl
*        FROM crhd
*        INTO TABLE @DATA(lt_crhd)
*        FOR ALL ENTRIES IN @gt_centro_trabalho
*        WHERE objid = @gt_centro_trabalho-objid.
      DATA lt_crhd TYPE TABLE OF crhd.
      DATA ls_crhd TYPE crhd.
      SELECT objty objid arbpl
        FROM crhd
        INTO CORRESPONDING FIELDS OF TABLE lt_crhd
        FOR ALL ENTRIES IN gt_centro_trabalho
        WHERE objid = gt_centro_trabalho-objid.
    ENDIF.

*    LOOP AT gt_centro_trabalho ASSIGNING FIELD-SYMBOL(<fs_centro_trabalho>).
    FIELD-SYMBOLS <fs_centro_trabalho> LIKE LINE OF gt_centro_trabalho.
    LOOP AT gt_centro_trabalho ASSIGNING <fs_centro_trabalho>.
*      READ TABLE lt_t001w INTO DATA(ls_t001w)
      READ TABLE lt_t001w INTO ls_t001w
      WITH KEY werks = <fs_centro_trabalho>-werks.

      IF sy-subrc EQ 0.
        <fs_centro_trabalho>-name1 = ls_t001w-name1.
      ENDIF.

*      READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = <fs_centro_trabalho>-objid.
      READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = <fs_centro_trabalho>-objid.

      IF sy-subrc EQ 0.
        <fs_centro_trabalho>-arbpl = ls_crhd-arbpl.
      ENDIF.

*      READ TABLE lt_005 INTO DATA(ls_005) WITH KEY objid = <fs_centro_trabalho>-objid
      READ TABLE lt_005 INTO ls_005 WITH KEY objid = <fs_centro_trabalho>-objid
                                                   werks = <fs_centro_trabalho>-werks.
      IF sy-subrc EQ 0.
        <fs_centro_trabalho>-learr = ls_005-learr.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_TIPO_OBJETO
*&---------------------------------------------------------------------*
FORM f_busca_tipo_objeto .

  REFRESH gt_tipo_objeto[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb020
      INTO CORRESPONDING FIELDS OF TABLE gt_tipo_objeto
      WHERE perfil = gv_perfil.

    IF gt_tipo_objeto[] IS NOT INITIAL.
*      SELECT spras, eqart, eartx
*        FROM t370k_t
*        INTO TABLE @DATA(lt_t370k_t)
*        FOR ALL ENTRIES IN @gt_tipo_objeto
*        WHERE spras = @sy-langu
*          AND eqart = @gt_tipo_objeto-eqart.
      DATA lt_t370k_t TYPE TABLE OF t370k_t.
      DATA ls_t370k_t TYPE t370k_t.
      SELECT spras eqart eartx
        FROM t370k_t
        INTO CORRESPONDING FIELDS OF TABLE lt_t370k_t
        FOR ALL ENTRIES IN gt_tipo_objeto
        WHERE spras = sy-langu
          AND eqart = gt_tipo_objeto-eqart.
    ENDIF.

*    LOOP AT gt_tipo_objeto ASSIGNING FIELD-SYMBOL(<fs_tipo_objeto>).
    FIELD-SYMBOLS <fs_tipo_objeto> LIKE LINE OF gt_tipo_objeto.
    LOOP AT gt_tipo_objeto ASSIGNING <fs_tipo_objeto>.
*      READ TABLE lt_t370k_t INTO DATA(ls_t370k_t) WITH KEY eqart = <fs_tipo_objeto>-eqart.
      READ TABLE lt_t370k_t INTO ls_t370k_t WITH KEY eqart = <fs_tipo_objeto>-eqart.

      IF sy-subrc EQ 0.
        <fs_tipo_objeto>-eartx = ls_t370k_t-eartx.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_CAT_LOC_INST
*&---------------------------------------------------------------------*
FORM f_busca_cat_loc_inst .

  REFRESH gt_cat_loc_inst[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb018
      INTO CORRESPONDING FIELDS OF TABLE gt_cat_loc_inst
      WHERE perfil = gv_perfil.

    IF gt_cat_loc_inst[] IS NOT INITIAL.
*      SELECT spras, fltyp, typtx
*        FROM t370f_t
*        INTO TABLE @DATA(lt_t370f_t)
*        FOR ALL ENTRIES IN @gt_cat_loc_inst
*        WHERE spras = @sy-langu
*          AND fltyp = @gt_cat_loc_inst-fltyp.
      DATA lt_t370f_t TYPE TABLE OF t370f_t.
      DATA ls_t370f_t TYPE t370f_t.
      SELECT spras fltyp typtx
        FROM t370f_t
        INTO CORRESPONDING FIELDS OF TABLE lt_t370f_t
        FOR ALL ENTRIES IN gt_cat_loc_inst
        WHERE spras = sy-langu
          AND fltyp = gt_cat_loc_inst-fltyp.
    ENDIF.

*    LOOP AT gt_cat_loc_inst ASSIGNING FIELD-SYMBOL(<fs_cat_loc_inst>).
    FIELD-SYMBOLS <fs_cat_loc_inst> LIKE LINE OF gt_cat_loc_inst.
    LOOP AT gt_cat_loc_inst ASSIGNING <fs_cat_loc_inst>.
*      READ TABLE lt_t370f_t INTO DATA(ls_t370f_t) WITH KEY fltyp = <fs_cat_loc_inst>-fltyp.
      READ TABLE lt_t370f_t INTO ls_t370f_t WITH KEY fltyp = <fs_cat_loc_inst>-fltyp.

      IF sy-subrc EQ 0.
        <fs_cat_loc_inst>-typtx = ls_t370f_t-typtx.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_busca_equip_status_especific.

*  REFRESH gt_status_especifico[].
*
*  IF gv_perfil IS NOT INITIAL.
*
*    SELECT *
*      FROM /ptloms/tb051
*      INTO CORRESPONDING FIELDS OF TABLE gt_status_especifico
*      WHERE perfil = gv_perfil.
*
*    IF gt_status_especifico[] IS NOT INITIAL.
*
*      SELECT *
*        FROM tj02t
*        INTO TABLE @DATA(lt_tj02t)
*        FOR ALL ENTRIES IN @gt_status_especifico
*        WHERE spras = @sy-langu
*          AND istat = @gt_status_especifico-stat.
*
*    ENDIF.
*
*    LOOP AT gt_status_especifico ASSIGNING FIELD-SYMBOL(<fs_status_especifico>).
*
*      READ TABLE lt_tj02t INTO DATA(ls_tj02t) WITH KEY istat = <fs_status_especifico>-stat.
*
*      IF sy-subrc EQ 0.
*
*        <fs_status_especifico>-txt04 = ls_tj02t-txt04.
*        <fs_status_especifico>-txt30 = ls_tj02t-txt30.
*
*      ENDIF.
*
*    ENDLOOP.
*
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_busca_cat_equipamento .

  REFRESH gt_cat_equipamento[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb019
      INTO CORRESPONDING FIELDS OF TABLE gt_cat_equipamento
      WHERE perfil = gv_perfil.

    IF gt_cat_equipamento[] IS NOT INITIAL.
*      SELECT spras, eqtyp, typtx
*        FROM t370u
*        INTO TABLE @DATA(lt_t370u)
*        FOR ALL ENTRIES IN @gt_cat_equipamento
*        WHERE spras = @sy-langu
*          AND eqtyp = @gt_cat_equipamento-eqtyp.
      DATA lt_t370u TYPE TABLE OF t370u.
      DATA ls_t370u TYPE t370u.
      SELECT spras eqtyp typtx
        FROM t370u
        INTO CORRESPONDING FIELDS OF TABLE lt_t370u
        FOR ALL ENTRIES IN gt_cat_equipamento
        WHERE spras = sy-langu
          AND eqtyp = gt_cat_equipamento-eqtyp.
    ENDIF.

*    LOOP AT gt_cat_equipamento ASSIGNING FIELD-SYMBOL(<fs_cat_equipamento>).
    FIELD-SYMBOLS <fs_cat_equipamento> LIKE LINE OF gt_cat_equipamento.
    LOOP AT gt_cat_equipamento ASSIGNING <fs_cat_equipamento>.
*      READ TABLE lt_t370u INTO DATA(ls_t370u) WITH KEY eqtyp = <fs_cat_equipamento>-eqtyp.
      READ TABLE lt_t370u INTO ls_t370u WITH KEY eqtyp = <fs_cat_equipamento>-eqtyp.

      IF sy-subrc EQ 0.
        <fs_cat_equipamento>-typtx = ls_t370u-typtx.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_CARACT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_busca_caract_equipamento .

  REFRESH gt_caract_equipamento[].

  IF gv_perfil IS NOT INITIAL.

*    SELECT a~atnam, b~atinn
*      FROM /ptloms/tb059 AS a RIGHT OUTER JOIN /ptloms/tb058 AS b
*      ON a~atnam = b~atnam
*      INTO CORRESPONDING FIELDS OF TABLE @gt_caract_equipamento
*      WHERE perfil = @gv_perfil.

    SELECT  a~atnam a~atinn
                  FROM /ptloms/tb058 AS a
             INNER JOIN /ptloms/tb059 AS b
                    ON b~atnam  EQ a~atnam
                   AND b~perfil EQ gv_perfil
            INTO CORRESPONDING FIELDS OF TABLE gt_caract_equipamento.

    IF gt_caract_equipamento IS NOT INITIAL.

*      SELECT atinn, atbez
*        FROM cabnt
*        INTO TABLE @DATA(lt_cabnt)
*        FOR ALL ENTRIES IN @gt_caract_equipamento
*        WHERE spras = @sy-langu AND
*              atinn = @gt_caract_equipamento-atinn.

      DATA lt_cabnt TYPE TABLE OF cabnt.
      DATA ls_cabnt TYPE cabnt.
      SELECT atinn atbez
        FROM cabnt
        INTO CORRESPONDING FIELDS OF TABLE lt_cabnt
        FOR ALL ENTRIES IN gt_caract_equipamento
        WHERE spras = sy-langu AND
              atinn = gt_caract_equipamento-atinn.

    ENDIF.

*    LOOP AT gt_caract_equipamento ASSIGNING FIELD-SYMBOL(<fs_caract_equipamento>).
    FIELD-SYMBOLS  <fs_caract_equipamento> LIKE LINE OF gt_caract_equipamento.
    LOOP AT gt_caract_equipamento ASSIGNING <fs_caract_equipamento>.
*      READ TABLE lt_cabnt INTO DATA(ls_cabnt) WITH KEY atinn = <fs_caract_equipamento>-atinn.
      READ TABLE lt_cabnt INTO ls_cabnt WITH KEY atinn = <fs_caract_equipamento>-atinn.

      IF sy-subrc EQ 0.
        <fs_caract_equipamento>-atbez = ls_cabnt-atbez.
      ENDIF.

    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_TIPO_ATV_ORDEM
*&---------------------------------------------------------------------*
FORM f_busca_tipo_atv_ordem .

  REFRESH gt_tipo_atv_ordem[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb025
      INTO CORRESPONDING FIELDS OF TABLE gt_tipo_atv_ordem
      WHERE perfil = gv_perfil.

    IF gt_tipo_atv_ordem[] IS NOT INITIAL.
*      SELECT spras, ilart, ilatx
*        FROM t353i_t
*        INTO TABLE @DATA(lt_t353i_t)
*        FOR ALL ENTRIES IN @gt_tipo_atv_ordem
*        WHERE spras = @sy-langu
*          AND ilart = @gt_tipo_atv_ordem-ilart.

      DATA lt_t353i_t TYPE TABLE OF t353i_t.
      DATA ls_t353i_t TYPE t353i_t.
      SELECT spras ilart ilatx
        FROM t353i_t
        INTO CORRESPONDING FIELDS OF TABLE lt_t353i_t
        FOR ALL ENTRIES IN gt_tipo_atv_ordem
        WHERE spras = sy-langu
          AND ilart = gt_tipo_atv_ordem-ilart.
    ENDIF.

*    LOOP AT gt_tipo_atv_ordem ASSIGNING FIELD-SYMBOL(<fs_tipo_atv_ordem>).
    FIELD-SYMBOLS <fs_tipo_atv_ordem> LIKE LINE OF gt_tipo_atv_ordem.
    LOOP AT gt_tipo_atv_ordem ASSIGNING <fs_tipo_atv_ordem>.
*      READ TABLE lt_t353i_t INTO DATA(ls_t353i_t) WITH KEY ilart = <fs_tipo_atv_ordem>-ilart.
      READ TABLE lt_t353i_t INTO ls_t353i_t WITH KEY ilart = <fs_tipo_atv_ordem>-ilart.

      IF sy-subrc EQ 0.
        <fs_tipo_atv_ordem>-ilatx = ls_t353i_t-ilatx.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_TIPO_NOTA
*&---------------------------------------------------------------------*
FORM f_busca_tipo_nota .

  REFRESH gt_tipo_nota[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb021
      INTO CORRESPONDING FIELDS OF TABLE gt_tipo_nota
      WHERE perfil = gv_perfil.

    IF gt_tipo_nota[] IS NOT INITIAL.
*      SELECT qmart, qmtyp, rbnr
*        FROM tq80
*        INTO TABLE @DATA(lt_tq80)
*        FOR ALL ENTRIES IN @gt_tipo_nota
*        WHERE qmart = @gt_tipo_nota-qmart.

      DATA lt_tq80 TYPE TABLE OF tq80.
      DATA ls_tq80 TYPE tq80.
      SELECT qmart qmtyp rbnr
        FROM tq80
        INTO CORRESPONDING FIELDS OF TABLE lt_tq80
        FOR ALL ENTRIES IN gt_tipo_nota
        WHERE qmart = gt_tipo_nota-qmart.

*      SELECT spras, qmart, qmartx
*        FROM tq80_t
*        INTO TABLE @DATA(lt_tq80_t)
*        FOR ALL ENTRIES IN @gt_tipo_nota
*        WHERE spras = @sy-langu
*          AND qmart = @gt_tipo_nota-qmart.

      DATA lt_tq80_t TYPE TABLE OF tq80_t.
      DATA ls_tq80_t TYPE tq80_t.
      SELECT spras qmart qmartx
        FROM tq80_t
        INTO CORRESPONDING FIELDS OF TABLE lt_tq80_t
        FOR ALL ENTRIES IN gt_tipo_nota
        WHERE spras = sy-langu
          AND qmart = gt_tipo_nota-qmart.
    ENDIF.

*    LOOP AT gt_tipo_nota ASSIGNING FIELD-SYMBOL(<fs_tipo_nota>).
    FIELD-SYMBOLS <fs_tipo_nota> LIKE LINE OF gt_tipo_nota.
    LOOP AT gt_tipo_nota ASSIGNING <fs_tipo_nota>.
*      READ TABLE lt_tq80 INTO DATA(ls_tq80) WITH KEY qmart = <fs_tipo_nota>-qmart.
      READ TABLE lt_tq80 INTO ls_tq80 WITH KEY qmart = <fs_tipo_nota>-qmart.

      IF sy-subrc EQ 0.
        <fs_tipo_nota>-qmtyp = ls_tq80-qmtyp.
        <fs_tipo_nota>-rbnr = ls_tq80-rbnr.
      ENDIF.

*      READ TABLE lt_tq80_t INTO DATA(ls_tq80_t) WITH KEY qmart = <fs_tipo_nota>-qmart.
      READ TABLE lt_tq80_t INTO ls_tq80_t WITH KEY qmart = <fs_tipo_nota>-qmart.

      IF sy-subrc EQ 0.
        <fs_tipo_nota>-qmartx = ls_tq80_t-qmartx.
      ENDIF.

    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_TIPO_ORDEM
*&---------------------------------------------------------------------*
FORM f_busca_tipo_ordem .

  DATA: it_values TYPE TABLE OF dd07v.

  REFRESH gt_tipo_ordem[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb022
      INTO CORRESPONDING FIELDS OF TABLE gt_tipo_ordem
      WHERE perfil = gv_perfil.

    IF gt_tipo_ordem[] IS NOT INITIAL.
*      SELECT auart, autyp
*        FROM t003o
*        INTO TABLE @DATA(lt_t003o)
*        FOR ALL ENTRIES IN @gt_tipo_ordem
*        WHERE auart = @gt_tipo_ordem-auart.

      DATA lt_t003o TYPE TABLE OF t003o.
      DATA ls_t003o TYPE t003o.
      SELECT auart autyp
        FROM t003o
        INTO CORRESPONDING FIELDS OF TABLE lt_t003o
        FOR ALL ENTRIES IN gt_tipo_ordem
        WHERE auart = gt_tipo_ordem-auart.

*      SELECT spras, auart, txt
*        FROM t003p
*        INTO TABLE @DATA(lt_t003p)
*        FOR ALL ENTRIES IN @gt_tipo_ordem
*        WHERE spras = @sy-langu
*          AND auart = @gt_tipo_ordem-auart.

      DATA lt_t003p TYPE TABLE OF t003p.
      DATA ls_t003p TYPE t003p.
      SELECT spras auart txt
        FROM t003p
        INTO CORRESPONDING FIELDS OF TABLE lt_t003p
        FOR ALL ENTRIES IN gt_tipo_ordem
        WHERE spras = sy-langu
          AND auart = gt_tipo_ordem-auart.

*      SELECT *
*        FROM /ptloms/tb010
*        INTO TABLE @DATA(lt_t010)
*        FOR ALL ENTRIES IN @gt_tipo_ordem
*        WHERE auart = @gt_tipo_ordem-auart.

      DATA lt_t010 TYPE TABLE OF /ptloms/tb010.
      DATA ls_t010 TYPE /ptloms/tb010.
      SELECT *
        FROM /ptloms/tb010
        INTO TABLE lt_t010
        FOR ALL ENTRIES IN gt_tipo_ordem
        WHERE auart = gt_tipo_ordem-auart.

      CALL FUNCTION 'DDUT_DOMVALUES_GET'
        EXPORTING
          name          = '/PTLOMS/DM014'
          langu         = sy-langu
*         TEXTS_ONLY    = ' '
        TABLES
          dd07v_tab     = it_values
        EXCEPTIONS
          illegal_input = 1
          OTHERS        = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

    ENDIF.

*    LOOP AT gt_tipo_ordem ASSIGNING FIELD-SYMBOL(<fs_tipo_ordem>).
    FIELD-SYMBOLS <fs_tipo_ordem> LIKE LINE OF gt_tipo_ordem.
    LOOP AT gt_tipo_ordem ASSIGNING <fs_tipo_ordem>.
*      READ TABLE lt_t003o INTO DATA(ls_t003o) WITH KEY auart = <fs_tipo_ordem>-auart.
      READ TABLE lt_t003o INTO ls_t003o WITH KEY auart = <fs_tipo_ordem>-auart.

      IF sy-subrc EQ 0.
        <fs_tipo_ordem>-autyp = ls_t003o-autyp.
      ENDIF.

*      READ TABLE lt_t003p INTO DATA(ls_t003p) WITH KEY auart = <fs_tipo_ordem>-auart.
      READ TABLE lt_t003p INTO ls_t003p WITH KEY auart = <fs_tipo_ordem>-auart.

      IF sy-subrc EQ 0.
        <fs_tipo_ordem>-txt = ls_t003p-txt.
      ENDIF.

*      READ TABLE it_values ASSIGNING FIELD-SYMBOL(<fs_values>) WITH KEY domvalue_l = <fs_tipo_ordem>-filtro_catalogo.
      FIELD-SYMBOLS <fs_values> LIKE LINE OF it_values.
      READ TABLE it_values ASSIGNING <fs_values> WITH KEY domvalue_l = <fs_tipo_ordem>-filtro_catalogo.

      IF sy-subrc IS INITIAL.
        <fs_tipo_ordem>-filtro_txt = <fs_values>-ddtext.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_TIPO_MATERIAL
*&---------------------------------------------------------------------*
FORM f_busca_tipo_material .

  REFRESH gt_tipo_material[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb023
      INTO CORRESPONDING FIELDS OF TABLE gt_tipo_material
      WHERE perfil = gv_perfil.

    IF gt_tipo_material[] IS NOT INITIAL.
*      SELECT spras, mtart, mtbez
*        FROM t134t
*        INTO TABLE @DATA(lt_t134t)
*        FOR ALL ENTRIES IN @gt_tipo_material
*        WHERE spras = @sy-langu
*          AND mtart = @gt_tipo_material-mtart.

      DATA lt_t134t TYPE TABLE OF t134t.
      DATA ls_t134t TYPE t134t.
      SELECT spras mtart mtbez
        FROM t134t
        INTO CORRESPONDING FIELDS OF TABLE lt_t134t
        FOR ALL ENTRIES IN gt_tipo_material
        WHERE spras = sy-langu
          AND mtart = gt_tipo_material-mtart.
    ENDIF.

*    LOOP AT gt_tipo_material ASSIGNING FIELD-SYMBOL(<fs_tipo_material>).
    FIELD-SYMBOLS <fs_tipo_material> LIKE LINE OF gt_tipo_material.
    LOOP AT gt_tipo_material ASSIGNING <fs_tipo_material>.
*      READ TABLE lt_t134t INTO DATA(ls_t134t) WITH KEY mtart = <fs_tipo_material>-mtart.
      READ TABLE lt_t134t INTO ls_t134t WITH KEY mtart = <fs_tipo_material>-mtart.

      IF sy-subrc EQ 0.
        <fs_tipo_material>-mtbez = ls_t134t-mtbez.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_AREA_OPERACIONAL
*&---------------------------------------------------------------------*
FORM f_deleta_area_operacional .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_area_operacional) = gt_area_operacional.
    DATA: lt_area_operacional TYPE TABLE OF ty_area_operacional.
    DATA: ls_tab TYPE ty_area_operacional.
    lt_area_operacional[] = gt_area_operacional[].

*    LOOP AT o_rows INTO DATA(lv_row_aux).
    DATA lv_row_aux LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row_aux.
*      READ TABLE lt_area_operacional INTO DATA(ls_tab) INDEX lv_row_aux.
      READ TABLE lt_area_operacional INTO ls_tab INDEX lv_row_aux.
      IF sy-subrc EQ 0.

        DATA lv_permiss TYPE c LENGTH 1.
        CALL METHOD /ptloms/cl006=>verifica_permissao_centro
          EXPORTING
            im_tcode            = sy-tcode
            im_werks            = ls_tab-werks
          IMPORTING
            ex_possui_permissao = lv_permiss.

        IF lv_permiss  IS INITIAL.
          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = ls_tab-werks ) IS INITIAL.
*          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
*          RETURN.
*        ENDIF.

      ENDIF.
    ENDLOOP.

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_area_operacional INTO DATA(ls_area_operacional) INDEX lv_row.
      READ TABLE lt_area_operacional INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_area_operacional WHERE werks = ls_tab-werks
                                     AND beber = ls_tab-beber.

        " Remove da tabela /ptloms/tb016
        DELETE FROM /ptloms/tb016 WHERE perfil = gv_perfil
                                    AND werks  = ls_tab-werks
                                    AND beber  = ls_tab-beber.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CENTRO_TRABALHO
*&---------------------------------------------------------------------*
FORM f_deleta_centro_trabalho .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.
*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_centro_trabalho) = gt_centro_trabalho.
    DATA: lt_centro_trabalho TYPE TABLE OF ty_centro_trabalho.
    DATA: ls_tab TYPE ty_centro_trabalho.
    lt_centro_trabalho[] = gt_centro_trabalho[].

*    LOOP AT o_rows INTO DATA(lv_row_aux).
    DATA lv_row_aux LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row_aux.
*      READ TABLE lt_centro_trabalho INTO DATA(ls_tab) INDEX lv_row_aux.
      READ TABLE lt_centro_trabalho INTO ls_tab INDEX lv_row_aux.
      IF sy-subrc EQ 0.

        DATA lv_permiss TYPE c LENGTH 1.
        CALL METHOD /ptloms/cl006=>verifica_permissao_centro
          EXPORTING
            im_tcode            = sy-tcode
            im_werks            = ls_tab-werks
          IMPORTING
            ex_possui_permissao = lv_permiss.

        IF lv_permiss  IS INITIAL.
          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = ls_tab-werks ) IS INITIAL.
*          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
*          RETURN.
*        ENDIF.

      ENDIF.
    ENDLOOP.

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_centro_trabalho INTO DATA(ls_centro_trabalho) INDEX lv_row.
      READ TABLE lt_centro_trabalho INTO  ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_centro_trabalho WHERE objid = ls_tab-objid
                                    AND werks = ls_tab-werks.

        " Remove da tabela /ptloms/tb017
        DELETE FROM /ptloms/tb017 WHERE perfil = gv_perfil
                                    AND objid  = ls_tab-objid
                                    AND werks  = ls_tab-werks.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CAT_LOC_INST
*&---------------------------------------------------------------------*
FORM f_deleta_cat_loc_inst .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.
*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_cat_loc_inst) = gt_cat_loc_inst.
    DATA: lt_cat_loc_inst TYPE TABLE OF /ptloms/v005.
    DATA: ls_tab TYPE /ptloms/v005.
    lt_cat_loc_inst[] = gt_cat_loc_inst[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_cat_loc_inst INTO DATA(ls_cat_loc_inst) INDEX lv_row.
      READ TABLE lt_cat_loc_inst INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_cat_loc_inst WHERE fltyp = ls_tab-fltyp.

        " Remove da tabela /ptloms/tb018
        DELETE FROM /ptloms/tb018 WHERE perfil = gv_perfil
                                    AND fltyp  = ls_tab-fltyp.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_deleta_status_inclusivo.

  DATA: lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_status_inclusivo) = gt_status_inclusivo.
    DATA: lt_status_inclusivo TYPE TABLE OF ty_status_equipamento.
    DATA: ls_tab TYPE ty_status_equipamento.
    lt_status_inclusivo[] = gt_status_inclusivo[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_status_inclusivo INTO DATA(ls_status_inclusivo) INDEX lv_row.
      READ TABLE lt_status_inclusivo INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_status_inclusivo WHERE stat = ls_tab-stat.

        " Remove da tabela /ptloms/tb051
        DELETE FROM /ptloms/tb051 WHERE perfil = gv_perfil
                                      AND stat = ls_tab-stat.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_deleta_status_exclusivo.

  DATA: lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_status_exclusivo) = gt_status_exclusivo.
    DATA: lt_status_exclusivo TYPE TABLE OF ty_status_equipamento.
    DATA: ls_tab TYPE ty_status_equipamento.
    lt_status_exclusivo[] = gt_status_exclusivo[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_status_exclusivo INTO DATA(ls_status_exclusivo) INDEX lv_row.
      READ TABLE lt_status_exclusivo INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_status_exclusivo WHERE stat = ls_tab-stat.

        " Remove da tabela /ptloms/tb051
        DELETE FROM /ptloms/tb052 WHERE perfil = gv_perfil
                                      AND stat = ls_tab-stat.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_deleta_cat_equipamento .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_cat_equipamento) = gt_cat_equipamento.
    DATA: lt_cat_equipamento TYPE TABLE OF /ptloms/v006.
    DATA: ls_tab TYPE /ptloms/v006.
    lt_cat_equipamento[] = gt_cat_equipamento[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_cat_equipamento INTO DATA(ls_cat_equipamento) INDEX lv_row.
      READ TABLE lt_cat_equipamento INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_cat_equipamento WHERE eqtyp = ls_tab-eqtyp.

        " Remove da tabela /ptloms/tb019
        DELETE FROM /ptloms/tb019 WHERE perfil = gv_perfil
                                    AND eqtyp  = ls_tab-eqtyp.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_TIPO_OBJETO
*&---------------------------------------------------------------------*
FORM f_deleta_tipo_objeto .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_tipo_objeto) = gt_tipo_objeto.
    DATA: lt_tipo_objeto TYPE TABLE OF ty_tipo_objeto.
    DATA: ls_tab TYPE ty_tipo_objeto.
    lt_tipo_objeto[] = gt_tipo_objeto[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_tipo_objeto INTO DATA(ls_tipo_objeto) INDEX lv_row.
      READ TABLE lt_tipo_objeto INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_tipo_objeto WHERE eqart = ls_tab-eqart.

        " Remove da tabela /ptloms/tb020
        DELETE FROM /ptloms/tb020 WHERE perfil = gv_perfil
                                    AND eqart  = ls_tab-eqart.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_TIPO_NOTA
*&---------------------------------------------------------------------*
FORM f_deleta_tipo_nota .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_tipo_nota) = gt_tipo_nota.
    DATA: lt_tipo_nota TYPE TABLE OF /ptloms/v008.
    DATA: ls_tab TYPE /ptloms/v008.
    lt_tipo_nota[] = gt_tipo_nota[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_tipo_nota INTO DATA(ls_tipo_nota) INDEX lv_row.
      READ TABLE lt_tipo_nota INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_tipo_nota WHERE qmart = ls_tab-qmart.

        " Remove da tabela /ptloms/tb021
        DELETE FROM /ptloms/tb021 WHERE perfil = gv_perfil
                                    AND qmart  = ls_tab-qmart.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_TIPO_ORDEM
*&---------------------------------------------------------------------*
FORM f_deleta_tipo_ordem .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_tipo_ordem) = gt_tipo_ordem.
    DATA: lt_tipo_ordem TYPE TABLE OF ty_tipo_ordem.
    DATA: ls_tab TYPE ty_tipo_ordem.
    lt_tipo_ordem[] = gt_tipo_ordem[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_tipo_ordem INTO DATA(ls_tipo_ordem) INDEX lv_row.
      READ TABLE lt_tipo_ordem INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_tipo_ordem WHERE auart = ls_tab-auart.

        " Remove da tabela /ptloms/tb022
        DELETE FROM /ptloms/tb022 WHERE perfil = gv_perfil
                                    AND auart  = ls_tab-auart.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_TIPO_ATV_ORDEM
*&---------------------------------------------------------------------*
FORM f_deleta_tipo_atv_ordem .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_tipo_atv_ordem) = gt_tipo_atv_ordem.
    DATA: lt_tipo_atv_ordem TYPE TABLE OF /ptloms/v011.
    DATA: ls_tab TYPE /ptloms/v011.
    lt_tipo_atv_ordem[] = gt_tipo_atv_ordem[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_tipo_atv_ordem INTO DATA(ls_tipo_atv_ordem) INDEX lv_row.
      READ TABLE lt_tipo_atv_ordem INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_tipo_atv_ordem WHERE ilart = ls_tab-ilart.

        " Remove da tabela /ptloms/tb025
        DELETE FROM /ptloms/tb025 WHERE perfil = gv_perfil
                                    AND ilart  = ls_tab-ilart.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_GRUPO_MERCADORIA
*&---------------------------------------------------------------------*
FORM f_deleta_grupo_mercadoria .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_grupo_mercadoria) = gt_grupo_mercadoria.
    DATA: lt_grupo_mercadoria TYPE TABLE OF /ptloms/v012.
    DATA: ls_tab TYPE /ptloms/v012.
    lt_grupo_mercadoria[] = gt_grupo_mercadoria[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_grupo_mercadoria INTO DATA(ls_grupo_mercadoria) INDEX lv_row.
      READ TABLE lt_grupo_mercadoria INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_grupo_mercadoria WHERE matkl = ls_tab-matkl.

        " Remove da tabela /ptloms/tb028
        DELETE FROM /ptloms/tb028 WHERE perfil = gv_perfil
                                    AND matkl  = ls_tab-matkl.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_DEPOSITO
*&---------------------------------------------------------------------*
FORM f_deleta_deposito.

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_deposito) = gt_deposito.
    DATA: lt_deposito TYPE TABLE OF /ptloms/v013.
    DATA: ls_tab TYPE /ptloms/v013.
    lt_deposito[] = gt_deposito[].

*    LOOP AT o_rows INTO DATA(lv_row_aux).
    DATA lv_row_aux LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row_aux.
*      READ TABLE lt_deposito INTO DATA(ls_tab) INDEX lv_row_aux.
      READ TABLE lt_deposito INTO ls_tab INDEX lv_row_aux.
      IF sy-subrc EQ 0.

        DATA lv_permiss TYPE c LENGTH 1.
        CALL METHOD /ptloms/cl006=>verifica_permissao_centro
          EXPORTING
            im_tcode            = sy-tcode
            im_werks            = ls_tab-werks
          IMPORTING
            ex_possui_permissao = lv_permiss.

        IF lv_permiss  IS INITIAL.
          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.

*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = ls_tab-werks ) IS INITIAL.
*          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
*          RETURN.
*        ENDIF.

      ENDIF.
    ENDLOOP.

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_deposito INTO DATA(ls_deposito) INDEX lv_row.
      READ TABLE lt_deposito INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_deposito WHERE werks = ls_tab-werks
                             AND lgort = ls_tab-lgort.

        " Remove da tabela /ptloms/tb030
        DELETE FROM /ptloms/tb030 WHERE perfil = gv_perfil
                                    AND werks  = ls_tab-werks
                                    AND lgort  = ls_tab-lgort.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CAUSA_DESVIO
*&---------------------------------------------------------------------*
FORM f_deleta_causa_desvio.

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_causa_desvio) = gt_causa_desvio.
    DATA: lt_causa_desvio TYPE TABLE OF /ptloms/v016.
    DATA: ls_tab TYPE /ptloms/v016.
    lt_causa_desvio[] = gt_causa_desvio[].

*    LOOP AT o_rows INTO DATA(lv_row_aux).
    DATA lv_row_aux LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row_aux.
*      READ TABLE lt_causa_desvio INTO DATA(ls_tab) INDEX lv_row_aux.
      READ TABLE lt_causa_desvio INTO ls_tab INDEX lv_row_aux.
      IF sy-subrc EQ 0.

        DATA lv_permiss TYPE c LENGTH 1.
        CALL METHOD /ptloms/cl006=>verifica_permissao_centro
          EXPORTING
            im_tcode            = sy-tcode
            im_werks            = ls_tab-werks
          IMPORTING
            ex_possui_permissao = lv_permiss.

        IF lv_permiss  IS INITIAL.
          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.
*        IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                               im_werks = ls_tab-werks ) IS INITIAL.
*          MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
*          RETURN.
*        ENDIF.

      ENDIF.
    ENDLOOP.

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_causa_desvio INTO DATA(ls_causa_desvio) INDEX lv_row.
      READ TABLE lt_causa_desvio INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_causa_desvio WHERE werks = ls_tab-werks
                                 AND grund = ls_tab-grund.

        " Remove da tabela /ptloms/tb039
        DELETE FROM /ptloms/tb039 WHERE perfil = gv_perfil
                                    AND werks  = ls_tab-werks
                                    AND grund  = ls_tab-grund.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_AUTORIZACAO
*&---------------------------------------------------------------------*
FORM f_deleta_autorizacao.

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

  DATA: lt_tb043 TYPE TABLE OF /ptloms/tb043.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_autorizacao) = gt_autorizacao.
    DATA: lt_autorizacao TYPE TABLE OF ty_autorizacao.
    DATA: ls_tab TYPE ty_autorizacao.
    lt_autorizacao[] = gt_autorizacao[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.

    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_autorizacao INTO DATA(ls_autorizacao) INDEX lv_row.
      READ TABLE lt_autorizacao INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_autorizacao WHERE autorizacao = ls_tab-autorizacao.

        " Remove da tabela /ptloms/tb043
        DELETE FROM /ptloms/tb043 WHERE perfil      = gv_perfil
                                    AND autorizacao = ls_tab-autorizacao.

        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ELSE.

          COMMIT WORK AND WAIT.

          CASE ls_tab-autorizacao.

            WHEN '10'.
              DELETE gt_autorizacao WHERE autorizacao = '11'.

              " Remove da tabela /ptloms/tb043
              DELETE FROM /ptloms/tb043 WHERE perfil      = gv_perfil
                                          AND autorizacao = '11'.

            WHEN '07'.
              DELETE gt_autorizacao WHERE autorizacao = '13'.

              " Remove da tabela /ptloms/tb043
              DELETE FROM /ptloms/tb043 WHERE perfil      = gv_perfil
                                          AND autorizacao = '13'.

            WHEN '09'.
              DELETE gt_autorizacao WHERE autorizacao = '15'.

              " Remove da tabela /ptloms/tb043
              DELETE FROM /ptloms/tb043 WHERE perfil      = gv_perfil
                                          AND autorizacao = '15'.

            WHEN '03' OR '04' OR '08' OR '14'.
              REFRESH lt_tb043.

              SELECT * INTO TABLE lt_tb043
                FROM /ptloms/tb043
                WHERE perfil      EQ gv_perfil
*                 AND autorizacao IN ( '03', '04', '08', '14' ).   "Alterado em função da versão da Solar.
                  AND ( autorizacao EQ '03' OR autorizacao EQ '04' OR  autorizacao EQ '08' OR autorizacao EQ  '14' ).


              IF  lt_tb043[]      IS INITIAL.

                DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                            AND configuracao = '04'.

                DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                            AND configuracao = '05'.

                DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                            AND configuracao = '06'.

                DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                            AND configuracao = '08'.

                DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                            AND configuracao = '11'.

                DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                            AND configuracao = '18'.

              ELSEIF ls_tab-autorizacao  EQ '03'
                  OR ls_tab-autorizacao  EQ '04'.

                READ TABLE lt_tb043  TRANSPORTING NO FIELDS WITH KEY autorizacao = '03'.
                IF  sy-subrc        NE 0.

                  READ TABLE lt_tb043  TRANSPORTING NO FIELDS WITH KEY autorizacao = '04'.
                  IF  sy-subrc        NE 0.

                    DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                                AND configuracao = '04'.

                    DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                                AND configuracao = '08'.

                    DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                                AND configuracao = '11'.

                  ENDIF.

                ENDIF.

              ENDIF.

          ENDCASE.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CONFIGURACAO
*&---------------------------------------------------------------------*
FORM f_deleta_configuracao.

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_configuracao) = gt_configuracao.
    DATA: lt_configuracao TYPE TABLE OF ty_configuracao.
    DATA: ls_tab TYPE ty_configuracao.
    lt_configuracao[] = gt_configuracao[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_configuracao INTO DATA(ls_configuracao) INDEX lv_row.
      READ TABLE lt_configuracao INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_configuracao WHERE configuracao = ls_tab-configuracao.

        " Remove da tabela /ptloms/tb044
        DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                    AND configuracao = ls_tab-configuracao.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.

        IF  ls_tab-configuracao      EQ '04'.
          READ TABLE gt_configuracao TRANSPORTING NO FIELDS WITH KEY configuracao = '19'.
          IF  sy-subrc               EQ 0.
            READ TABLE gt_configuracao TRANSPORTING NO FIELDS WITH KEY configuracao = '05'.
            IF  sy-subrc             NE 0.
              " Remove da tabela interna
              DELETE gt_configuracao WHERE configuracao = '19'.
              " Remove da tabela /ptloms/tb044
              DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                          AND configuracao = '19'.
            ENDIF.
          ENDIF.

        ELSEIF ls_tab-configuracao   EQ '05'.
          READ TABLE gt_configuracao TRANSPORTING NO FIELDS WITH KEY configuracao = '19'.
          IF  sy-subrc               EQ 0.
            READ TABLE gt_configuracao TRANSPORTING NO FIELDS WITH KEY configuracao = '04'.
            IF  sy-subrc             NE 0.
              " Remove da tabela interna
              DELETE gt_configuracao WHERE configuracao = '19'.
              " Remove da tabela /ptloms/tb044
              DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                          AND configuracao = '19'.
            ENDIF.
          ENDIF.

        ELSEIF ls_tab-configuracao   EQ '13'.
          READ TABLE gt_configuracao TRANSPORTING NO FIELDS WITH KEY configuracao = '12'.
          IF  sy-subrc               EQ 0.
            " Remove da tabela interna
            DELETE gt_configuracao WHERE configuracao = '12'.
            " Remove da tabela /ptloms/tb044
            DELETE FROM /ptloms/tb044 WHERE perfil       = gv_perfil
                                        AND configuracao = '12'.
          ENDIF.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_LISTA_TAREFA
*&---------------------------------------------------------------------*
FORM f_deleta_lista_tarefa.

  DATA  lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
    DATA lv_row LIKE LINE OF o_rows.
    SORT o_rows   DESCENDING.

    LOOP AT o_rows INTO lv_row.

      READ TABLE gt_tb063 INTO wa_tb063 INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_tb063
          WHERE nrseq        = wa_tb063-nrseq.

        " Remove da tabela /ptloms/tb063
        DELETE FROM /ptloms/tb063
          WHERE perfil  = gv_perfil
            AND nrseq   = wa_tb063-nrseq.

        IF sy-subrc NE 0.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  COMMIT WORK AND WAIT.

  PERFORM f_busca_lista_tarefa.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_TIPO_MATERIAL
*&---------------------------------------------------------------------*
FORM f_deleta_tipo_material .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  CLEAR lv_qtde.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
*** DATA(lv_msg_tela) = |Remover o registro selecionado|.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
*** lv_msg_tela = |Remover os | && lv_qtde && | registros selecionados|.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
*    DATA(lt_tipo_material) = gt_tipo_material.
    DATA: lt_tipo_material TYPE TABLE OF /ptloms/v010.
    DATA: ls_tab TYPE /ptloms/v010.
    lt_tipo_material[] = gt_tipo_material[].

*    LOOP AT o_rows INTO DATA(lv_row).
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
*      READ TABLE lt_tipo_material INTO DATA(ls_tipo_material) INDEX lv_row.
      READ TABLE lt_tipo_material INTO ls_tab INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_tipo_material WHERE mtart = ls_tab-mtart.

        " Remove da tabela /ptloms/tb023
        DELETE FROM /ptloms/tb023 WHERE perfil = gv_perfil
                                    AND mtart  = ls_tab-mtart.
        IF sy-subrc NE 0.
*          DATA(lv_erro) = 'X'.
          DATA lv_erro TYPE c.
          CLEAR lv_erro.
          lv_erro  = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_AREA_OPERACIONAL
*&---------------------------------------------------------------------*
FORM f_grava_area_operacional .

  DATA: ls_016              TYPE /ptloms/tb016,
        ls_area_operacional LIKE LINE OF gt_area_operacional.

  ls_016-perfil = gv_perfil.
  ls_016-werks  = wa_area_operacional-werks.
  ls_016-beber  = wa_area_operacional-beber.
  ls_016-filtro_equi  = wa_area_operacional-filtro_equi.
  ls_016-filtro_locl  = wa_area_operacional-filtro_locl.

  MODIFY /ptloms/tb016 FROM ls_016.

  IF sy-subrc EQ 0.
*    READ TABLE gt_area_operacional ASSIGNING FIELD-SYMBOL(<fs_area_operacional>)
    FIELD-SYMBOLS <fs_area_operacional> LIKE LINE OF gt_area_operacional.
    READ TABLE gt_area_operacional ASSIGNING <fs_area_operacional>
    WITH KEY werks = wa_area_operacional-werks
             beber  = wa_area_operacional-beber.
    IF sy-subrc EQ 0.
      <fs_area_operacional>-filtro_equi = wa_area_operacional-filtro_equi.
      <fs_area_operacional>-filtro_locl = wa_area_operacional-filtro_locl.
    ENDIF.
*    MOVE-CORRESPONDING wa_area_operacional TO ls_area_operacional.
*
*    APPEND ls_area_operacional TO gt_area_operacional.
*    SORT gt_area_operacional BY werks ASCENDING beber ASCENDING.

    MESSAGE s000(su) WITH 'Registro atualizado com sucesso'(044).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao atualizar registro'(045) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_CENTRO_TRABALHO
*&---------------------------------------------------------------------*
FORM f_grava_centro_trabalho .

  DATA: ls_017             TYPE /ptloms/tb017,
        ls_centro_trabalho LIKE LINE OF gt_centro_trabalho.

  ls_017-perfil = gv_perfil.
  ls_017-objid  = wa_centro_trabalho-objid.
  ls_017-werks  = wa_centro_trabalho-werks.
  ls_017-filtro_equi = wa_centro_trabalho-filtro_equi.
  ls_017-filtro_locl = wa_centro_trabalho-filtro_locl.

  MODIFY /ptloms/tb017 FROM ls_017.

  IF sy-subrc EQ 0.
*    READ TABLE gt_centro_trabalho ASSIGNING FIELD-SYMBOL(<fs_centro_trabalho>)
    FIELD-SYMBOLS <fs_centro_trabalho> LIKE LINE OF gt_centro_trabalho.
    READ TABLE gt_centro_trabalho ASSIGNING <fs_centro_trabalho>
    WITH KEY objid  = wa_centro_trabalho-objid
             werks  = wa_centro_trabalho-werks.
    IF sy-subrc EQ 0.
      <fs_centro_trabalho>-filtro_equi = wa_centro_trabalho-filtro_equi.
      <fs_centro_trabalho>-filtro_locl = wa_centro_trabalho-filtro_locl.
    ENDIF.
*    MOVE-CORRESPONDING wa_centro_trabalho TO ls_centro_trabalho.
*
*    APPEND ls_centro_trabalho TO gt_centro_trabalho.
*    SORT gt_centro_trabalho BY objid ASCENDING werks ASCENDING.

    MESSAGE s000(su) WITH 'Registro atualizado com sucesso'(044).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao atualizar registro'(045) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_CAT_LOC_INST
*&---------------------------------------------------------------------*
FORM f_grava_cat_loc_inst .

  DATA: ls_018          TYPE /ptloms/tb018,
        ls_cat_loc_inst LIKE LINE OF gt_cat_loc_inst.

  ls_018-perfil = gv_perfil.
  ls_018-fltyp  = wa_cat_loc_inst-fltyp.

  MODIFY /ptloms/tb018 FROM ls_018.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_cat_loc_inst TO ls_cat_loc_inst.

    APPEND ls_cat_loc_inst TO gt_cat_loc_inst.
    SORT gt_cat_loc_inst BY fltyp ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_grava_cat_equipamento .

  DATA: ls_019             TYPE /ptloms/tb019,
        ls_cat_equipamento LIKE LINE OF gt_cat_equipamento.

  ls_019-perfil = gv_perfil.
  ls_019-eqtyp  = wa_cat_equipamento-eqtyp.

  MODIFY /ptloms/tb019 FROM ls_019.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_cat_equipamento TO ls_cat_equipamento.

    APPEND ls_cat_equipamento TO gt_cat_equipamento.
    SORT gt_cat_equipamento BY eqtyp ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_GRUPO_TIPO_OBJETO
*&---------------------------------------------------------------------*
FORM f_grava_grupo_tipo_objeto .

  DATA: ls_020         TYPE /ptloms/tb020,
        ls_tipo_objeto LIKE LINE OF gt_tipo_objeto.

  ls_020-perfil = gv_perfil.
  ls_020-eqart  = wa_tipo_objeto-eqart.
  ls_020-filtro_equi  = wa_tipo_objeto-filtro_equi.
  ls_020-filtro_locl  = wa_tipo_objeto-filtro_locl.

  MODIFY /ptloms/tb020 FROM ls_020.

  IF sy-subrc EQ 0.

*    READ TABLE gt_tipo_objeto ASSIGNING FIELD-SYMBOL(<fs_tipo_objeto>)
    FIELD-SYMBOLS <fs_tipo_objeto> LIKE LINE OF gt_tipo_objeto.
    READ TABLE gt_tipo_objeto ASSIGNING <fs_tipo_objeto>
    WITH KEY eqart = wa_tipo_objeto-eqart.
    IF sy-subrc EQ 0.
      <fs_tipo_objeto>-filtro_equi = wa_tipo_objeto-filtro_equi.
      <fs_tipo_objeto>-filtro_locl = wa_tipo_objeto-filtro_locl.
    ENDIF.
*    MOVE-CORRESPONDING wa_tipo_objeto TO ls_tipo_objeto.
*
*    APPEND ls_tipo_objeto TO gt_tipo_objeto.
*    SORT gt_tipo_objeto BY eqart ASCENDING.

    MESSAGE s000(su) WITH 'Registro atualizado com sucesso'(044).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao atualizar registro'(045) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_TIPO_NOTA
*&---------------------------------------------------------------------*
FORM f_grava_tipo_nota .

  DATA: ls_021       TYPE /ptloms/tb021,
        ls_tipo_nota LIKE LINE OF gt_tipo_nota.

  ls_021-perfil = gv_perfil.
  ls_021-qmart  = wa_tipo_nota-qmart.

  MODIFY /ptloms/tb021 FROM ls_021.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_tipo_nota TO ls_tipo_nota.

    APPEND ls_tipo_nota TO gt_tipo_nota.
    SORT gt_tipo_nota BY qmart ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_TIPO_ORDEM
*&---------------------------------------------------------------------*
FORM f_grava_tipo_ordem .

  DATA: ls_022        TYPE /ptloms/tb022,
        ls_tipo_ordem LIKE LINE OF gt_tipo_ordem.

  ls_022-perfil          = gv_perfil.
  ls_022-auart           = wa_tipo_ordem-auart.
  ls_022-filtro_catalogo = wa_tipo_ordem-filtro_catalogo.

  MODIFY /ptloms/tb022 FROM ls_022.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_tipo_ordem TO ls_tipo_ordem.

    APPEND ls_tipo_ordem TO gt_tipo_ordem.
    SORT gt_tipo_ordem BY auart ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_TIPO_ATV_ORDEM
*&---------------------------------------------------------------------*
FORM f_grava_tipo_atv_ordem .

  DATA: ls_025            TYPE /ptloms/tb025,
        ls_tipo_atv_ordem LIKE LINE OF gt_tipo_atv_ordem.

  ls_025-perfil = gv_perfil.
  ls_025-ilart  = wa_tipo_atv_ordem-ilart.

  MODIFY /ptloms/tb025 FROM ls_025.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_tipo_atv_ordem TO ls_tipo_atv_ordem.

    APPEND ls_tipo_atv_ordem TO gt_tipo_atv_ordem.
    SORT gt_tipo_atv_ordem BY ilart ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_GRUPO_MERCADORIA
*&---------------------------------------------------------------------*
FORM f_grava_grupo_mercadoria .

  DATA: ls_028              TYPE /ptloms/tb028,
        ls_grupo_mercadoria LIKE LINE OF gt_grupo_mercadoria.

  ls_028-perfil = gv_perfil.
  ls_028-matkl  = wa_grupo_mercadoria-matkl.

  MODIFY /ptloms/tb028 FROM ls_028.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_grupo_mercadoria TO ls_grupo_mercadoria.

    APPEND ls_grupo_mercadoria TO gt_grupo_mercadoria.
    SORT gt_grupo_mercadoria BY matkl ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_DEPOSITO
*&---------------------------------------------------------------------*
FORM f_grava_deposito.

  DATA: ls_030      TYPE /ptloms/tb030,
        ls_deposito LIKE LINE OF gt_deposito.

  ls_030-perfil = gv_perfil.
  ls_030-werks  = wa_deposito-werks.
  ls_030-lgort  = wa_deposito-lgort.

  MODIFY /ptloms/tb030 FROM ls_030.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_deposito TO ls_deposito.

    APPEND ls_deposito TO gt_deposito.
    SORT gt_deposito BY werks ASCENDING lgort ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_CAUSA_DESVIO
*&---------------------------------------------------------------------*
FORM f_grava_causa_desvio.

  DATA: ls_039          TYPE /ptloms/tb039,
        ls_causa_desvio LIKE LINE OF gt_causa_desvio.

  ls_039-perfil = gv_perfil.
  ls_039-werks  = wa_causa_desvio-werks.
  ls_039-grund  = wa_causa_desvio-grund.

  MODIFY /ptloms/tb039 FROM ls_039.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_causa_desvio TO ls_causa_desvio.

    APPEND ls_causa_desvio TO gt_causa_desvio.
    SORT gt_causa_desvio BY werks ASCENDING grund ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_CARACTERISTICA
*&---------------------------------------------------------------------*
FORM f_grava_caracteristica.

  DATA: ls_059                TYPE /ptloms/tb059,
        ls_caract_equipamento LIKE LINE OF gt_caract_equipamento.

  ls_059-perfil = gv_perfil.
  ls_059-atnam  = wa_caract_equipamento-atnam.

  MODIFY /ptloms/tb059 FROM ls_059.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_caract_equipamento TO ls_caract_equipamento.

    APPEND ls_caract_equipamento TO gt_caract_equipamento.
    SORT gt_caract_equipamento BY atnam.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_TIPO_MATERIAL
*&---------------------------------------------------------------------*
FORM f_grava_tipo_material .

  DATA: ls_023           TYPE /ptloms/tb023,
        ls_tipo_material LIKE LINE OF gt_tipo_material.

  ls_023-perfil = gv_perfil.
  ls_023-mtart  = wa_tipo_material-mtart.

  MODIFY /ptloms/tb023 FROM ls_023.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_tipo_material TO ls_tipo_material.

    APPEND ls_tipo_material TO gt_tipo_material.
    SORT gt_tipo_material BY mtart ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_AREA_OPERACIONAL
*&---------------------------------------------------------------------*
FORM f_valida_area_operacional .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Área Operacional é válido
    IF wa_area_operacional-werks IS NOT INITIAL AND
       wa_area_operacional-beber IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb004
*        INTO @DATA(ls_004)
*        WHERE werks = @wa_area_operacional-werks
*          AND beber = @wa_area_operacional-beber.

      DATA ls_004 TYPE /ptloms/tb004.
      SELECT SINGLE *
        FROM /ptloms/tb004
        INTO ls_004
        WHERE werks = wa_area_operacional-werks
          AND beber = wa_area_operacional-beber.

      IF sy-subrc NE 0.
        CLEAR: wa_area_operacional-werks, wa_area_operacional-name1,
               wa_area_operacional-beber, wa_area_operacional-fing.
        MESSAGE e000(su) WITH 'Centro/Área Operacioanl inválido'(106).
      ENDIF.

      " Verifica se Área Operacional já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb016
*        INTO @DATA(ls_016)
*        WHERE perfil = @gv_perfil
*          AND werks = @wa_area_operacional-werks
*          AND beber = @wa_area_operacional-beber.

      DATA ls_016 TYPE /ptloms/tb016.
      SELECT SINGLE *
        FROM /ptloms/tb016
        INTO ls_016
        WHERE perfil = gv_perfil
          AND werks = wa_area_operacional-werks
          AND beber = wa_area_operacional-beber.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do centro
    IF wa_area_operacional-werks IS NOT INITIAL.
      SELECT SINGLE name1
        FROM t001w
        INTO wa_area_operacional-name1
        WHERE werks = wa_area_operacional-werks.
    ELSE.
      CLEAR: wa_area_operacional-werks, wa_area_operacional-name1.
      MESSAGE e000(su) WITH 'Centro inválido'(058).
    ENDIF.

    " Busca descrição da área operacional
    IF wa_area_operacional-beber IS NOT INITIAL.
      SELECT SINGLE fing
        FROM t357
        INTO wa_area_operacional-fing
        WHERE beber = wa_area_operacional-beber.
    ELSE.
      CLEAR: wa_area_operacional-beber, wa_area_operacional-fing.
      MESSAGE e000(su) WITH 'Área Operacional inválida'(057).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_CENTRO_TRABALHO
*&---------------------------------------------------------------------*
FORM f_valida_centro_trabalho .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Centro de Trabalho é válido
    IF wa_centro_trabalho-objid IS NOT INITIAL AND
       wa_centro_trabalho-werks IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb005
*        INTO @DATA(ls_005)
*        WHERE objid = @wa_centro_trabalho-objid
*          AND werks = @wa_centro_trabalho-werks.

      DATA ls_005 TYPE /ptloms/tb005.
      SELECT SINGLE *
        FROM /ptloms/tb005
        INTO ls_005
        WHERE objid = wa_centro_trabalho-objid
          AND werks = wa_centro_trabalho-werks.

      IF sy-subrc NE 0.
        CLEAR: wa_centro_trabalho-objid, wa_centro_trabalho-arbpl,
               wa_centro_trabalho-werks, wa_centro_trabalho-name1.
        MESSAGE e000(su) WITH 'Centro Trabalho/Centro inválido'(059).
      ENDIF.

      " Verifica se Centro de Trabalho já existe
**      SELECT SINGLE *
**        FROM /ptloms/tb017
**        INTO @DATA(ls_017)
**        WHERE perfil = @gv_perfil
**          AND objid = @wa_centro_trabalho-objid
**          AND werks = @wa_centro_trabalho-werks.

      DATA ls_017 TYPE /ptloms/tb017.
      SELECT SINGLE *
        FROM /ptloms/tb017
        INTO ls_017
        WHERE perfil = gv_perfil
          AND objid = wa_centro_trabalho-objid
          AND werks = wa_centro_trabalho-werks.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do centro de trabalho
    IF wa_centro_trabalho-objid IS NOT INITIAL.
      SELECT SINGLE arbpl
        FROM crhd
        INTO wa_centro_trabalho-arbpl
        WHERE objid = wa_centro_trabalho-objid.
    ELSE.
      CLEAR: wa_centro_trabalho-objid, wa_centro_trabalho-arbpl.
      MESSAGE e000(su) WITH 'Centro Trabalho inválido'(060).
    ENDIF.

    " Busca descrição do centro
    IF wa_centro_trabalho-werks IS NOT INITIAL.
      SELECT SINGLE name1
        FROM t001w
        INTO wa_centro_trabalho-name1
        WHERE werks = wa_centro_trabalho-werks.
    ELSE.
      CLEAR: wa_centro_trabalho-werks, wa_centro_trabalho-name1.
      MESSAGE e000(su) WITH 'Centro inválido'(058).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_CAT_LOC_INST
*&---------------------------------------------------------------------*
FORM f_valida_cat_loc_inst .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Área Operacional é válido
    IF wa_cat_loc_inst-fltyp IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb006
*        INTO @DATA(ls_006)
*        WHERE fltyp = @wa_cat_loc_inst-fltyp.
      DATA ls_006 TYPE /ptloms/tb006.
      SELECT SINGLE *
        FROM /ptloms/tb006
        INTO ls_006
        WHERE fltyp = wa_cat_loc_inst-fltyp.

      IF sy-subrc NE 0.
        CLEAR: wa_cat_loc_inst-fltyp, wa_cat_loc_inst-typtx.
        MESSAGE e000(su) WITH 'Ctg.Loc.Inst. inválido'(048).
      ENDIF.

      " Verifica se Categoria de Loc.Inst. já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb018
*        INTO @DATA(ls_018)
*        WHERE perfil = @gv_perfil
*          AND fltyp = @wa_cat_loc_inst-fltyp.

      DATA ls_018 TYPE /ptloms/tb018.
      SELECT SINGLE *
        FROM /ptloms/tb018
        INTO ls_018
        WHERE perfil = gv_perfil
          AND fltyp = wa_cat_loc_inst-fltyp.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição da categoria do local de instalação
    IF wa_cat_loc_inst-fltyp IS NOT INITIAL.
      SELECT SINGLE typtx
        FROM t370f_t
        INTO wa_cat_loc_inst-typtx
        WHERE spras = sy-langu
          AND fltyp = wa_cat_loc_inst-fltyp.
    ELSE.
      CLEAR: wa_cat_loc_inst-fltyp, wa_cat_loc_inst-typtx.
      MESSAGE e000(su) WITH 'Ctg.Loc.Inst. inválido'(048).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_valida_caract_equipamento .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se a característica é válida
    IF wa_caract_equipamento-atnam IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb058
*        INTO @DATA(ls_058)
*        WHERE atnam = @wa_caract_equipamento-atnam.
      DATA ls_058 TYPE /ptloms/tb058.
      SELECT SINGLE *
        FROM /ptloms/tb058
        INTO ls_058
        WHERE atnam = wa_caract_equipamento-atnam.

      IF sy-subrc NE 0.
        CLEAR: wa_caract_equipamento-atnam, wa_caract_equipamento-atinn.
        MESSAGE e000(su) WITH 'Característica Equipamento inválido'(141).
      ENDIF.

      " Verifica se característica de Equipamento já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb059
*        INTO @DATA(ls_059)
*        WHERE perfil = @gv_perfil
*          AND atnam = @wa_caract_equipamento-atnam.
      DATA ls_059 TYPE /ptloms/tb059.
      SELECT SINGLE *
        FROM /ptloms/tb059
        INTO ls_059
        WHERE perfil = gv_perfil
          AND atnam = wa_caract_equipamento-atnam.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição da característica do Equipamento
    IF wa_caract_equipamento-atnam IS NOT INITIAL.

*      SELECT a~atinn, b~atbez UP TO 1 ROWS
*        FROM cabn AS a INNER JOIN cabnt AS b
*        ON a~atinn = b~atinn
*        INTO ( @wa_caract_equipamento-atinn, @wa_caract_equipamento-atbez )
*        WHERE a~atnam = @wa_caract_equipamento-atnam AND
*              b~spras = @sy-langu.
*      ENDSELECT.

      SELECT a~atinn b~atbez UP TO 1 ROWS
        FROM cabn AS a INNER JOIN cabnt AS b
        ON a~atinn = b~atinn
        INTO (wa_caract_equipamento-atinn, wa_caract_equipamento-atbez)
        WHERE a~atnam = wa_caract_equipamento-atnam AND
              b~spras = sy-langu.
      ENDSELECT.
    ELSE.
      CLEAR: wa_caract_equipamento-atnam, wa_caract_equipamento-atinn, wa_caract_equipamento-atbez.
      MESSAGE e000(su) WITH 'Característica Equipamento inválido'(141).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_CAT_EQUIPAMENTO
*&---------------------------------------------------------------------*
FORM f_valida_cat_equipamento .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Área Operacional é válido
    IF wa_cat_equipamento-eqtyp IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb007
*        INTO @DATA(ls_007)
*        WHERE eqtyp = @wa_cat_equipamento-eqtyp.

      DATA ls_007 TYPE /ptloms/tb007.
      SELECT SINGLE *
        FROM /ptloms/tb007
        INTO ls_007
        WHERE eqtyp = wa_cat_equipamento-eqtyp.

      IF sy-subrc NE 0.
        CLEAR: wa_cat_equipamento-eqtyp, wa_cat_equipamento-typtx.
        MESSAGE e000(su) WITH 'Ctg.Equipamento inválido'(050).
      ENDIF.

      " Verifica se Categoria de Equipamento já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb019
*        INTO @DATA(ls_019)
*        WHERE perfil = @gv_perfil
*          AND eqtyp = @wa_cat_equipamento-eqtyp.

      DATA ls_019 TYPE /ptloms/tb019.
      SELECT SINGLE *
        FROM /ptloms/tb019
        INTO ls_019
        WHERE perfil = gv_perfil
          AND eqtyp = wa_cat_equipamento-eqtyp.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição da categoria do Equipamento
    IF wa_cat_equipamento-eqtyp IS NOT INITIAL.
      SELECT SINGLE typtx
        FROM t370u
        INTO wa_cat_equipamento-typtx
        WHERE spras = sy-langu
          AND eqtyp = wa_cat_equipamento-eqtyp.
    ELSE.
      CLEAR: wa_cat_equipamento-eqtyp, wa_cat_equipamento-typtx.
      MESSAGE e000(su) WITH 'Ctg.Equipamento inválido'(050).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_TIPO_OBJETO
*&---------------------------------------------------------------------*
FORM f_valida_tipo_objeto .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Tipo de Objeto é válido
    IF wa_tipo_objeto-eqart IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb008
*        INTO @DATA(ls_008)
*        WHERE eqart = @wa_tipo_objeto-eqart.

      DATA ls_008 TYPE /ptloms/tb008.
      SELECT SINGLE *
        FROM /ptloms/tb008
        INTO ls_008
        WHERE eqart = wa_tipo_objeto-eqart.

      IF sy-subrc NE 0.
        CLEAR: wa_tipo_objeto-eqart, wa_tipo_objeto-eartx.
        MESSAGE e000(su) WITH 'Tipo de Objeto inválido'(051).
      ENDIF.

      " Verifica se Tipo de Objeto já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb020
*        INTO @DATA(ls_020)
*        WHERE perfil = @gv_perfil
*          AND eqart = @wa_tipo_objeto-eqart.

      DATA ls_020 TYPE /ptloms/tb020.
      SELECT SINGLE *
        FROM /ptloms/tb020
        INTO ls_020
        WHERE perfil = gv_perfil
          AND eqart = wa_tipo_objeto-eqart.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Tipo de Objeto
    IF wa_tipo_objeto-eqart IS NOT INITIAL.
      SELECT SINGLE eartx
        FROM t370k_t
        INTO wa_tipo_objeto-eartx
        WHERE spras = sy-langu
          AND eqart = wa_tipo_objeto-eqart.
    ELSE.
      CLEAR: wa_tipo_objeto-eqart, wa_tipo_objeto-eartx.
      MESSAGE e000(su) WITH 'Tipo de Objeto inválido'(051).
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_TIPO_NOTA
*&---------------------------------------------------------------------*
FORM f_valida_tipo_nota .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Tipo de Nota é válido
    IF wa_tipo_nota-qmart IS NOT INITIAL.

**      SELECT SINGLE *
**        FROM /ptloms/tb009
**        INTO @DATA(ls_009)
**        WHERE qmart = @wa_tipo_nota-qmart.

      DATA ls_009 TYPE /ptloms/tb009.
      SELECT SINGLE *
        FROM /ptloms/tb009
        INTO ls_009
        WHERE qmart = wa_tipo_nota-qmart.

      IF sy-subrc NE 0.
        CLEAR: wa_tipo_nota-qmart, wa_tipo_nota-qmtyp,
               wa_tipo_nota-rbnr,  wa_tipo_nota-qmartx.
        MESSAGE e000(su) WITH 'Tipo de nota inválido'(061).
      ENDIF.

      " Verifica se Tipo de Nota já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb021
*        INTO @DATA(ls_021)
*        WHERE perfil = @gv_perfil
*          AND qmart = @wa_tipo_nota-qmart.

      DATA ls_021 TYPE /ptloms/tb021.
      SELECT SINGLE *
        FROM /ptloms/tb021
        INTO ls_021
        WHERE perfil = gv_perfil
          AND qmart = wa_tipo_nota-qmart.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Tipo de Nota
    IF wa_tipo_nota-qmart IS NOT INITIAL.
*      SELECT SINGLE qmtyp, rbnr
*        FROM tq80
*        INTO ( @wa_tipo_nota-qmtyp, @wa_tipo_nota-rbnr )
*        WHERE qmart = @wa_tipo_nota-qmart.

      SELECT SINGLE qmtyp rbnr
        FROM tq80
        INTO (wa_tipo_nota-qmtyp, wa_tipo_nota-rbnr)
        WHERE qmart = wa_tipo_nota-qmart.

      SELECT SINGLE qmartx
        FROM tq80_t
        INTO wa_tipo_nota-qmartx
        WHERE spras = sy-langu
          AND qmart = wa_tipo_nota-qmart.
    ELSE.
      CLEAR: wa_tipo_nota-qmart, wa_tipo_nota-qmtyp,
             wa_tipo_nota-rbnr,  wa_tipo_nota-qmartx.
      MESSAGE e000(su) WITH 'Tipo de Nota inválido'(062).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_TIPO_ORDEM
*&---------------------------------------------------------------------*
FORM f_valida_tipo_ordem .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Tipo de Ordem é válido
    IF wa_tipo_ordem-auart IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb010
*        INTO @DATA(ls_010)
*        WHERE auart = @wa_tipo_ordem-auart.
      DATA ls_010 TYPE /ptloms/tb010.
      SELECT SINGLE *
        FROM /ptloms/tb010
        INTO ls_010
        WHERE auart = wa_tipo_ordem-auart.

      IF sy-subrc NE 0.
        CLEAR: wa_tipo_ordem-auart, wa_tipo_ordem-autyp,
               wa_tipo_ordem-txt.
        MESSAGE e000(su) WITH 'Tipo de ordem inválido'(052).
      ENDIF.

      " Verifica se Tipo de Ordem já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb022
*        INTO @DATA(ls_022)
*        WHERE perfil = @gv_perfil
*          AND auart = @wa_tipo_ordem-auart.
      DATA ls_022 TYPE /ptloms/tb022.
      SELECT SINGLE *
        FROM /ptloms/tb022
        INTO ls_022
        WHERE perfil = gv_perfil
          AND auart = wa_tipo_ordem-auart.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Tipo de Ordem
    IF wa_tipo_ordem-auart IS NOT INITIAL.
      SELECT SINGLE autyp
        FROM t003o
        INTO wa_tipo_ordem-autyp
        WHERE auart = wa_tipo_ordem-auart.

      SELECT SINGLE txt
        FROM t003p
        INTO wa_tipo_ordem-txt
        WHERE spras = sy-langu
          AND auart = wa_tipo_ordem-auart.
    ELSE.
      CLEAR: wa_tipo_ordem-auart, wa_tipo_ordem-autyp,
             wa_tipo_ordem-txt.
      MESSAGE e000(su) WITH 'Tipo de ordem inválido'(052).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_TIPO_ATV_ORDEM
*&---------------------------------------------------------------------*
FORM f_valida_tipo_atv_ordem .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Tipo Atv de Ordem é válido
    IF wa_tipo_atv_ordem-ilart IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb024
*        INTO @DATA(ls_024)
*        WHERE ilart = @wa_tipo_atv_ordem-ilart.
      DATA ls_024 TYPE /ptloms/tb024.
      SELECT SINGLE *
        FROM /ptloms/tb024
        INTO ls_024
        WHERE ilart = wa_tipo_atv_ordem-ilart.

      IF sy-subrc NE 0.
        CLEAR: wa_tipo_atv_ordem-ilart, wa_tipo_atv_ordem-ilatx,
               wa_tipo_ordem-txt.
        MESSAGE e000(su) WITH 'Tipo de Atv. ordem inválido'(053).
      ENDIF.

      " Verifica se Tipo de Atv. Ordem já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb025
*        INTO @DATA(ls_025)
*        WHERE perfil = @gv_perfil
*          AND ilart = @wa_tipo_atv_ordem-ilart.
      DATA ls_025 TYPE /ptloms/tb025.
      SELECT SINGLE *
        FROM /ptloms/tb025
        INTO ls_025
        WHERE perfil = gv_perfil
          AND ilart = wa_tipo_atv_ordem-ilart.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Tipo de Ordem
    IF wa_tipo_atv_ordem-ilart IS NOT INITIAL.

      SELECT SINGLE ilatx
        FROM t353i_t
        INTO wa_tipo_atv_ordem-ilatx
        WHERE spras = sy-langu
          AND ilart = wa_tipo_atv_ordem-ilart.
    ELSE.
      CLEAR: wa_tipo_atv_ordem-ilart, wa_tipo_atv_ordem-ilatx,
             wa_tipo_ordem-txt.
      MESSAGE e000(su) WITH 'Tipo de Atv. ordem inválido'(053).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_GRUPO_MERCADORIA
*&---------------------------------------------------------------------*
FORM f_valida_grupo_mercadoria .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Grupo Mercadoria é válido
    IF wa_grupo_mercadoria-matkl IS NOT INITIAL.

**      SELECT SINGLE *
**        FROM /ptloms/tb027
**        INTO @DATA(ls_027)
**        WHERE matkl = @wa_grupo_mercadoria-matkl.
      DATA ls_027 TYPE /ptloms/tb027.
      SELECT SINGLE *
        FROM /ptloms/tb027
        INTO ls_027
        WHERE matkl = wa_grupo_mercadoria-matkl.

      IF sy-subrc NE 0.
        CLEAR: wa_grupo_mercadoria-matkl, wa_grupo_mercadoria-wgbez.
        MESSAGE e000(su) WITH 'Grupo de Mercadoria inválido'(063).
      ENDIF.

      " Verifica se Grupo de Mercadoria já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb028
*        INTO @DATA(ls_028)
*        WHERE perfil = @gv_perfil
*          AND matkl = @wa_grupo_mercadoria-matkl.

      DATA ls_028 TYPE /ptloms/tb028.
      SELECT SINGLE *
        FROM /ptloms/tb028
        INTO ls_028
        WHERE perfil = gv_perfil
          AND matkl = wa_grupo_mercadoria-matkl.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Grupo Mercadoria
    IF wa_grupo_mercadoria-matkl IS NOT INITIAL.

      SELECT SINGLE wgbez
        FROM t023t
        INTO wa_grupo_mercadoria-wgbez
        WHERE spras = sy-langu
          AND matkl = wa_grupo_mercadoria-matkl.
    ELSE.
      CLEAR: wa_grupo_mercadoria-matkl, wa_grupo_mercadoria-wgbez.
      MESSAGE e000(su) WITH 'Grupo de Mercadoria inválido'(063).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_DEPOSITO
*&---------------------------------------------------------------------*
FORM f_valida_deposito .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Depósito é válido
    IF wa_deposito-werks IS NOT INITIAL AND
       wa_deposito-lgort IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb029
*        INTO @DATA(ls_029)
*        WHERE werks = @wa_deposito-werks
*          AND lgort = @wa_deposito-lgort.
      DATA ls_029 TYPE /ptloms/tb029.
      SELECT SINGLE *
        FROM /ptloms/tb029
        INTO ls_029
        WHERE werks = wa_deposito-werks
          AND lgort = wa_deposito-lgort.

      IF sy-subrc NE 0.
        CLEAR: wa_deposito-werks, wa_deposito-name1,
               wa_deposito-lgort, wa_deposito-lgobe.
        MESSAGE e000(su) WITH 'Depósito inválido'(064).
      ENDIF.

      " Verifica se Depósito já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb030
*        INTO @DATA(ls_030)
*        WHERE perfil = @gv_perfil
*          AND werks = @wa_deposito-werks
*          AND lgort = @wa_deposito-lgort.

      DATA ls_030 TYPE /ptloms/tb030.
      SELECT SINGLE *
        FROM /ptloms/tb030
        INTO ls_030
        WHERE perfil = gv_perfil
          AND werks = wa_deposito-werks
          AND lgort = wa_deposito-lgort.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Depósito
    IF wa_deposito-werks IS NOT INITIAL AND
       wa_deposito-lgort IS NOT INITIAL.

      SELECT SINGLE lgobe
        FROM t001l
        INTO wa_deposito-lgobe
        WHERE werks = wa_deposito-werks
          AND lgort = wa_deposito-lgort.
    ELSE.
      CLEAR: wa_deposito-werks, wa_deposito-name1,
             wa_deposito-lgort, wa_deposito-lgobe.
      MESSAGE e000(su) WITH 'Depósito inválido'(064).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_CAUSA_DESVIO
*&---------------------------------------------------------------------*
FORM f_valida_causa_desvio .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Causa Desvio é válido
    IF wa_causa_desvio-werks IS NOT INITIAL AND
       wa_causa_desvio-grund IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb038
*        INTO @DATA(ls_038)
*        WHERE werks = @wa_causa_desvio-werks
*          AND grund = @wa_causa_desvio-grund.
      DATA ls_038 TYPE /ptloms/tb038.
      SELECT SINGLE *
        FROM /ptloms/tb038
        INTO ls_038
        WHERE werks = wa_causa_desvio-werks
          AND grund = wa_causa_desvio-grund.

      IF sy-subrc NE 0.
        CLEAR: wa_causa_desvio-werks, wa_causa_desvio-name1,
               wa_causa_desvio-grund, wa_causa_desvio-grdtx.
        MESSAGE e000(su) WITH 'Causa Desvio inválido'(065).
      ENDIF.

      " Verifica se Causa Desvio já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb039
*        INTO @DATA(ls_039)
*        WHERE perfil = @gv_perfil
*          AND werks = @wa_causa_desvio-werks
*          AND grund = @wa_causa_desvio-grund.
      DATA ls_039 TYPE /ptloms/tb039.
      SELECT SINGLE *
        FROM /ptloms/tb039
        INTO ls_039
        WHERE perfil = gv_perfil
          AND werks = wa_causa_desvio-werks
          AND grund = wa_causa_desvio-grund.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Causa Desvio
    IF wa_causa_desvio-werks IS NOT INITIAL AND
       wa_causa_desvio-grund IS NOT INITIAL.

      SELECT SINGLE grdtx
        FROM trugt
        INTO wa_causa_desvio-grdtx
        WHERE spras = sy-langu
          AND werks = wa_causa_desvio-werks
          AND grund = wa_causa_desvio-grund.

      SELECT SINGLE name1
        FROM t001w
        INTO wa_causa_desvio-name1
        WHERE werks = wa_causa_desvio-werks.
    ELSE.
      CLEAR: wa_causa_desvio-werks, wa_causa_desvio-name1,
             wa_causa_desvio-grund, wa_causa_desvio-grdtx.
      MESSAGE e000(su) WITH 'Causa Desvio inválido'(065).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_TIPO_MATERIAL
*&---------------------------------------------------------------------*
FORM f_valida_tipo_material .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Tipo de Material é válido
    IF wa_tipo_material-mtart IS NOT INITIAL.

*      SELECT SINGLE *
*        FROM /ptloms/tb011
*        INTO @DATA(ls_011)
*        WHERE mtart = @wa_tipo_material-mtart.
      DATA ls_011 TYPE /ptloms/tb011.
      SELECT SINGLE *
        FROM /ptloms/tb011
        INTO ls_011
        WHERE mtart = wa_tipo_material-mtart.

      IF sy-subrc NE 0.
        CLEAR: wa_tipo_material-mtart, wa_tipo_material-mtbez.
        MESSAGE e000(su) WITH 'Tipo de material inválido'(066).
      ENDIF.

      " Verifica se Tipo de Material já existe
*      SELECT SINGLE *
*        FROM /ptloms/tb023
*        INTO @DATA(ls_023)
*        WHERE perfil = @gv_perfil
*          AND mtart = @wa_tipo_material-mtart.
      DATA ls_023 TYPE /ptloms/tb023.
      SELECT SINGLE *
        FROM /ptloms/tb023
        INTO ls_023
        WHERE perfil = gv_perfil
          AND mtart = wa_tipo_material-mtart.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.
    ENDIF.

    " Busca descrição do Tipo de Material
    IF wa_tipo_material-mtart IS NOT INITIAL.
      SELECT SINGLE mtbez
        FROM t134t
        INTO wa_tipo_material-mtbez
        WHERE spras = sy-langu
          AND mtart = wa_tipo_material-mtart.
    ELSE.
      CLEAR: wa_tipo_material-mtart, wa_tipo_material-mtbez.
      MESSAGE e000(su) WITH 'Tipo de material inválido'(066).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_Centro_AO
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_centro_ao USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
           beber TYPE t357-beber,
           fing  TYPE t357-fing,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb004
*    INTO TABLE @DATA(lt_tb004).
  DATA lt_tb004 TYPE TABLE OF /ptloms/tb004.
  DATA ls_004 TYPE /ptloms/tb004.
  SELECT *
    FROM /ptloms/tb004
    INTO TABLE lt_tb004.

* Busca descrição dos centros
  IF lt_tb004[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb004
*      WHERE werks = @lt_tb004-werks.

    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb004
      WHERE werks = lt_tb004-werks.

*    SELECT werks, beber, fing
*      FROM t357
*      INTO TABLE @DATA(lt_t357)
*      FOR ALL ENTRIES IN @lt_tb004
*      WHERE werks = @lt_tb004-werks.

    DATA lt_t357 TYPE TABLE OF t357.
    DATA ls_t357 TYPE t357.
    SELECT werks beber fing
      FROM t357
      INTO CORRESPONDING FIELDS OF TABLE lt_t357
      FOR ALL ENTRIES IN lt_tb004
      WHERE werks = lt_tb004-werks.

*    LOOP AT lt_tb004 INTO DATA(ls_004).
    LOOP AT lt_tb004 INTO ls_004.

      READ TABLE gt_area_operacional TRANSPORTING NO FIELDS WITH KEY werks  = ls_004-werks.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_004 TO ls_tab.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_004-werks.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_004-werks.
      ls_tab-name1 = ls_t001w-name1.
*      READ TABLE lt_t357 INTO DATA(ls_t357) WITH KEY werks = ls_004-werks
      READ TABLE lt_t357 INTO ls_t357 WITH KEY werks = ls_004-werks
                                                     beber = ls_004-beber.
      ls_tab-fing = ls_t357-fing.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TABIX'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_centro_ao TABLES lt_return
                                                  lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc EQ 0.

          CLEAR lv_tabix.

          " --- Atribui valor ao campo da tela
          REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
          MOVE ls_return-fieldval TO lv_tabix.

          READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

          wa_area_operacional-werks = ls_tab-werks.
          ls_dynpfields-fieldname = 'WA_AREA_OPERACIONAL-WERKS'.
          ls_dynpfields-fieldvalue = wa_area_operacional-werks.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_area_operacional-name1 = ls_tab-name1.
          ls_dynpfields-fieldname = 'WA_AREA_OPERACIONAL-NAME1'.
          ls_dynpfields-fieldvalue = wa_area_operacional-name1.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_area_operacional-beber = ls_tab-beber.
          ls_dynpfields-fieldname = 'WA_AREA_OPERACIONAL-BEBER'.
          ls_dynpfields-fieldvalue = wa_area_operacional-beber.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_area_operacional-fing = ls_tab-fing.
          ls_dynpfields-fieldname = 'WA_AREA_OPERACIONAL-FING'.
          ls_dynpfields-fieldvalue = wa_area_operacional-fing.
          APPEND ls_dynpfields TO lt_dynpfields.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_BEBER
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_beber .

  TYPES: BEGIN OF ty_tab,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
           beber TYPE t357-beber,
           fing  TYPE t357-fing,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

*  SELECT *
*    FROM /ptloms/tb004
*    INTO TABLE @DATA(lt_tb004).
  DATA lt_tb004 TYPE TABLE OF /ptloms/tb004.
  DATA ls_004 TYPE /ptloms/tb004.
  SELECT *
    FROM /ptloms/tb004
    INTO TABLE lt_tb004.

* Busca descrição dos centros
  IF lt_tb004[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb004
*      WHERE werks = @lt_tb004-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    DATA ls_t001w TYPE t001w.

    SELECT werks name1
      FROM t001w
      APPENDING CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb004
      WHERE werks = lt_tb004-werks.

*    SELECT werks, beber, fing
*      FROM t357
*      INTO TABLE @DATA(lt_t357)
*      FOR ALL ENTRIES IN @lt_tb004
*      WHERE werks = @lt_tb004-werks.
    DATA lt_t357 TYPE TABLE OF t357.
    DATA ls_t357 TYPE t357.
    SELECT werks beber fing
      FROM t357
      INTO CORRESPONDING FIELDS OF TABLE lt_t357
      FOR ALL ENTRIES IN lt_tb004
      WHERE werks = lt_tb004-werks.

*    LOOP AT lt_tb004 INTO DATA(ls_004).
    LOOP AT lt_tb004 INTO ls_004.

      READ TABLE gt_area_operacional TRANSPORTING NO FIELDS WITH KEY werks  = ls_004-werks.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      MOVE-CORRESPONDING ls_004 TO ls_tab.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_004-werks.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_004-werks.
      ls_tab-name1 = ls_t001w-name1.
*      READ TABLE lt_t357 INTO DATA(ls_t357) WITH KEY werks = ls_004-werks
      READ TABLE lt_t357 INTO ls_t357 WITH KEY werks = ls_004-werks
                                                     beber = ls_004-beber.
      ls_tab-fing = ls_t357-fing.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'BEBER'
        value_org       = 'S'
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.
      " --- Recupera o registro selecionado pelo usuário
*      READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
      DATA ls_return LIKE LINE OF lt_return.
      READ TABLE lt_return INTO ls_return INDEX 1.

      IF sy-subrc = 0.
        " --- Atribui valor ao campo da tela
        wa_area_operacional-beber = ls_return-fieldval.

        ls_dynpfields-fieldname = 'WA_AREA_OPERACIONAL-BEBER'.
        ls_dynpfields-fieldvalue = wa_area_operacional-beber.
        APPEND ls_dynpfields TO lt_dynpfields.

        READ TABLE lt_t357 INTO ls_t357 WITH KEY beber = wa_area_operacional-beber.
        IF sy-subrc EQ 0.
          wa_area_operacional-fing = ls_t357-fing.

          ls_dynpfields-fieldname = 'WA_AREA_OPERACIONAL-FING'.
          ls_dynpfields-fieldvalue = wa_area_operacional-fing.
          APPEND ls_dynpfields TO lt_dynpfields.
        ENDIF.

        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.

      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_OBJID
*&---------------------------------------------------------------------*
******************************* By Nádia - Start
FORM f_help_cod_adm_objid USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           objid TYPE crhd-objid,
           arbpl TYPE crhd-arbpl,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb005
*    INTO TABLE @DATA(lt_tb005).
  DATA lt_tb005 TYPE TABLE OF /ptloms/tb005.
  SELECT *
    FROM /ptloms/tb005
    INTO TABLE lt_tb005.

* Busca descrição dos centros
  IF lt_tb005[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb005
*      WHERE werks = @lt_tb005-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    SELECT werks name1
      FROM t001w
      INTO CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb005
      WHERE werks = lt_tb005-werks.

*    SELECT objty, objid, arbpl
*      FROM crhd
*      INTO TABLE @DATA(lt_crhd)
*      FOR ALL ENTRIES IN @lt_tb005
*      WHERE objid = @lt_tb005-objid.
    TYPES: BEGIN OF ty_crhd,
             objty TYPE crhd-objty,
             objid TYPE crhd-objid,
             arbpl TYPE crhd-arbpl,
           END OF ty_crhd.
    DATA lt_crhd TYPE TABLE OF ty_crhd.
    SELECT objty objid arbpl
      FROM crhd
      INTO TABLE lt_crhd
      FOR ALL ENTRIES IN lt_tb005
      WHERE objid = lt_tb005-objid.

*  LOOP AT lt_tb005 INTO DATA(ls_005).
    DATA ls_005 LIKE LINE OF lt_tb005.
    LOOP AT lt_tb005 INTO ls_005.

      READ TABLE gt_centro_trabalho TRANSPORTING NO FIELDS WITH KEY objid  = ls_005-objid.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_005 TO ls_tab.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_005-werks.
      DATA ls_t001w LIKE LINE OF lt_t001w.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_005-werks.
      ls_tab-name1 = ls_t001w-name1.
*      READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = ls_005-objid.
      DATA ls_crhd LIKE LINE OF lt_crhd.
      READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = ls_005-objid.
      ls_tab-arbpl = ls_crhd-arbpl.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TABIX'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_objid TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          CLEAR lv_tabix.

          " --- Atribui valor ao campo da tela
          REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
          MOVE ls_return-fieldval TO lv_tabix.

          READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

          wa_centro_trabalho-objid = ls_tab-objid.

          ls_dynpfields-fieldname = 'WA_CENTRO_TRABALHO-OBJID'.
          ls_dynpfields-fieldvalue = wa_centro_trabalho-objid.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_centro_trabalho-arbpl = ls_tab-arbpl.
          ls_dynpfields-fieldname = 'WA_CENTRO_TRABALHO-ARBPL'.
          ls_dynpfields-fieldvalue = wa_centro_trabalho-arbpl.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_centro_trabalho-werks = ls_tab-werks.
          ls_dynpfields-fieldname = 'WA_CENTRO_TRABALHO-WERKS'.
          ls_dynpfields-fieldvalue = wa_centro_trabalho-werks.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_centro_trabalho-name1 = ls_tab-name1.
          ls_dynpfields-fieldname = 'WA_CENTRO_TRABALHO-NAME1'.
          ls_dynpfields-fieldvalue = wa_centro_trabalho-name1.
          APPEND ls_dynpfields TO lt_dynpfields.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_CENTRO_CT
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_centro_ct .

  TYPES: BEGIN OF ty_tab,
           objid TYPE crhd-objid,
           arbpl TYPE crhd-arbpl,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

*  SELECT *
*    FROM /ptloms/tb005
*    INTO TABLE @DATA(lt_tb005).
  DATA lt_tb005 TYPE TABLE OF /ptloms/tb005.
  SELECT *
    FROM /ptloms/tb005
    INTO TABLE lt_tb005.

* Busca descrição dos centros
  IF lt_tb005[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb005
*      WHERE werks = @lt_tb005-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    SELECT werks name1
      FROM t001w
      INTO CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb005
      WHERE werks = lt_tb005-werks.

*    SELECT objty, objid, arbpl
*      FROM crhd
*      INTO TABLE @DATA(lt_crhd)
*      FOR ALL ENTRIES IN @lt_tb005
*      WHERE objid = @lt_tb005-objid.
    TYPES: BEGIN OF ty_crhd,
             objty TYPE crhd-objty,
             objid TYPE crhd-objid,
             arbpl TYPE crhd-arbpl,
           END OF ty_crhd.
    DATA lt_crhd TYPE TABLE OF ty_crhd.
    SELECT objty objid arbpl
      FROM crhd
      INTO TABLE lt_crhd
      FOR ALL ENTRIES IN lt_tb005
      WHERE objid = lt_tb005-objid.

* LOOP AT lt_tb005 INTO DATA(ls_005).
    DATA ls_005 LIKE LINE OF lt_tb005.
    LOOP AT lt_tb005 INTO ls_005.

      READ TABLE gt_centro_trabalho TRANSPORTING NO FIELDS WITH KEY objid  = ls_005-objid.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      MOVE-CORRESPONDING ls_005 TO ls_tab.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_005-werks.
      DATA ls_t001w LIKE LINE OF lt_t001w.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_005-werks.
      ls_tab-name1 = ls_t001w-name1.
*      READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = ls_005-objid.
      DATA ls_crhd LIKE LINE OF lt_crhd.
      READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = ls_005-objid.
      ls_tab-arbpl = ls_crhd-arbpl.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'WERKS'
        value_org       = 'S'
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.
      " --- Recupera o registro selecionado pelo usuário
*      READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
      DATA ls_return LIKE LINE OF lt_return.
      READ TABLE lt_return INTO ls_return INDEX 1.

      IF sy-subrc = 0.
        " --- Atribui valor ao campo da tela
        wa_centro_trabalho-werks = ls_return-fieldval.

        ls_dynpfields-fieldname = 'WA_CENTRO_TRABALHO-WERKS'.
        ls_dynpfields-fieldvalue = wa_centro_trabalho-werks.
        APPEND ls_dynpfields TO lt_dynpfields.

        READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = wa_centro_trabalho-werks.
        IF sy-subrc EQ 0.
          wa_centro_trabalho-name1 = ls_t001w-name1.

          ls_dynpfields-fieldname = 'WA_CENTRO_TRABALHO-NAME1'.
          ls_dynpfields-fieldvalue = wa_centro_trabalho-name1.
          APPEND ls_dynpfields TO lt_dynpfields.
        ENDIF.

        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.

      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_FLTYP
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_fltyp USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           fltyp TYPE t370f-fltyp,
           typtx TYPE t370f_t-typtx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb006
*    INTO TABLE @DATA(lt_tb006).
  DATA lt_tb006 TYPE TABLE OF /ptloms/tb006.
  SELECT *
    FROM /ptloms/tb006
    INTO TABLE lt_tb006.

  IF lt_tb006[] IS NOT INITIAL.
*    SELECT spras, fltyp, typtx
*      FROM t370f_t
*      INTO TABLE @DATA(lt_t370f_t)
*      FOR ALL ENTRIES IN @lt_tb006
*      WHERE spras = @sy-langu
*        AND fltyp = @lt_tb006-fltyp.
    TYPES: BEGIN OF ty_t370f_t,
             spras TYPE t370f_t-spras,
             fltyp TYPE t370f_t-fltyp,
             typtx TYPE t370f_t-typtx,
           END OF ty_t370f_t.
    DATA lt_t370f_t TYPE TABLE OF ty_t370f_t.
    SELECT spras fltyp typtx
      FROM t370f_t
      INTO TABLE lt_t370f_t
      FOR ALL ENTRIES IN lt_tb006
      WHERE spras = sy-langu
        AND fltyp = lt_tb006-fltyp.

*    LOOP AT lt_tb006 INTO DATA(ls_006).
    DATA ls_006 LIKE LINE OF lt_tb006.
    LOOP AT lt_tb006 INTO ls_006.

      READ TABLE gt_cat_loc_inst TRANSPORTING NO FIELDS WITH KEY fltyp  = ls_006-fltyp.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_006 TO ls_tab.
*      READ TABLE lt_t370f_t INTO DATA(ls_t370f_t) WITH KEY fltyp = ls_006-fltyp.
      DATA ls_t370f_t LIKE LINE OF lt_t370f_t.
      READ TABLE lt_t370f_t INTO ls_t370f_t WITH KEY fltyp = ls_006-fltyp.
      ls_tab-typtx = ls_t370f_t-typtx.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'FLTYP'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_fltyp TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_cat_loc_inst-fltyp = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_CAT_LOC_INST-FLTYP'.
          ls_dynpfields-fieldvalue = wa_cat_loc_inst-fltyp.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_t370f_t INTO ls_t370f_t WITH KEY fltyp = wa_cat_loc_inst-fltyp.
          IF sy-subrc EQ 0.
            wa_cat_loc_inst-typtx = ls_t370f_t-typtx.

            ls_dynpfields-fieldname = 'WA_CAT_LOC_INST-TYPTX'.
            ls_dynpfields-fieldvalue = wa_cat_loc_inst-typtx.
            APPEND ls_dynpfields TO lt_dynpfields.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_EQTYP
*&---------------------------------------------------------------------*
FORM f_help_status_inclusivo USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
*           txt04 TYPE /ptloms/tb051-txt04,
           txt04 TYPE /ptloms/ed045,
           stat  TYPE j_istat,
*           stat  TYPE char5,
           txt30 TYPE tj02t-txt30,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields LIKE LINE OF lt_dynpfields,
        ls_tab        LIKE LINE OF lt_tab,
        it_values     TYPE TABLE OF dd07v,
        lv_tabix      TYPE sy-tabix,
        lt_fields     TYPE TABLE OF dfies,
        ls_fields     TYPE dfies.

*  SELECT *
*    FROM tj05
*    INTO TABLE @DATA(it_tj05)
*    WHERE obtyp = 'IEQ'.
  DATA it_tj05 TYPE TABLE OF tj05.
  SELECT *
    FROM tj05
    INTO TABLE it_tj05
    WHERE obtyp = 'IEQ'.

  IF sy-subrc IS INITIAL.

*    SELECT *
*      FROM tj06
*      INTO TABLE @DATA(it_tj06)
*      FOR ALL ENTRIES IN @it_tj05
*      WHERE vrgng = @it_tj05-vrgng AND
*            inact <> 'X'.
    DATA it_tj06 TYPE TABLE OF tj06.
    SELECT *
      FROM tj06
      INTO TABLE it_tj06
      FOR ALL ENTRIES IN it_tj05
      WHERE vrgng = it_tj05-vrgng AND
            inact <> 'X'.

    IF sy-subrc IS INITIAL.

*      SELECT *
*        FROM tj02t
*        INTO TABLE @DATA(it_tj02t)
*        FOR ALL ENTRIES IN @it_tj06
*        WHERE istat = @it_tj06-istat AND
*              spras = @sy-langu      AND
*      ( txt04 <> 'INAT' AND txt04 <> 'MREL' AND txt04 <> 'BLOQ' AND txt04 <> 'ELIM' ).
      DATA it_tj02t TYPE TABLE OF tj02t.
      SELECT *
        FROM tj02t
        INTO TABLE it_tj02t
        FOR ALL ENTRIES IN it_tj06
        WHERE istat = it_tj06-istat AND
              spras = sy-langu      AND
      ( txt04 <> 'INAT' AND txt04 <> 'MREL' AND txt04 <> 'BLOQ' AND txt04 <> 'ELIM' ).

    ENDIF.

  ENDIF.

* Busca Perfil x Status equipamento específico
  DATA lt_tb051 TYPE TABLE OF /ptloms/tb051.
  REFRESH lt_tb051.

  SELECT *
    FROM /ptloms/tb051
    INTO TABLE lt_tb051
    WHERE perfil = gv_perfil.

*LOOP AT it_tj02t ASSIGNING FIELD-SYMBOL(<fs_values>).
  FIELD-SYMBOLS: <fs_values> LIKE LINE OF it_tj02t.

  LOOP AT it_tj02t ASSIGNING <fs_values>.

    READ TABLE lt_tb051 TRANSPORTING NO FIELDS WITH KEY stat  = <fs_values>-istat.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    ls_tab-stat  = <fs_values>-istat.
    ls_tab-txt04 = <fs_values>-txt04.
    ls_tab-txt30 = <fs_values>-txt30.

    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TXT04'
      value_org       = 'S'
      multiple_choice = p_mult
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
      field_tab       = lt_fields
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_status_incl TABLES lt_return
                                                     lt_tab.

      ELSE.

*        READ TABLE lt_tab ASSIGNING FIELD-SYMBOL(<fs_tab>) WITH KEY txt04 = ls_return-fieldval.
        FIELD-SYMBOLS: <fs_tab> LIKE LINE OF lt_tab.
        READ TABLE lt_tab ASSIGNING <fs_tab> WITH KEY txt04 = ls_return-fieldval.

        IF sy-subrc IS INITIAL.
          ls_dynpfields-fieldvalue = <fs_tab>-txt04.
        ENDIF.

        " --- Atribui valor ao campo da tela
        ls_dynpfields-fieldname  = 'WA_EQUIP_STATUS_ESPECIFICO-TXT04'.
        APPEND ls_dynpfields TO lt_dynpfields.

        " --- Atribui valor ao campo da tela
        ls_dynpfields-fieldname  = 'WA_EQUIP_STATUS_ESPECIFICO-STAT'.
        ls_dynpfields-fieldvalue = ls_return-fieldval.
        APPEND ls_dynpfields TO lt_dynpfields.

        " --- Atribui valor ao campo da tela
        ls_dynpfields-fieldname  = 'WA_EQUIP_STATUS_ESPECIFICO-TXT30'.
        ls_dynpfields-fieldvalue = ls_return-fieldval.
        APPEND ls_dynpfields TO lt_dynpfields.


        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_EQTYP
*&---------------------------------------------------------------------*
FORM f_help_tipo_ordem_prioridade USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           auart TYPE /ptloms/tb010-auart,
           txt   TYPE t003p-txt,
         END OF ty_tab.

  DATA: lt_tab            TYPE STANDARD TABLE OF ty_tab,
        lt_return         TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields     TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields     LIKE LINE OF lt_dynpfields,
        ls_tab            LIKE LINE OF lt_tab,
        it_values         TYPE TABLE OF dd07v,
        lv_tabix          TYPE sy-tabix,
        lt_fields         TYPE TABLE OF dfies,
        ls_fields         TYPE dfies,
        lv_tc_actual_line TYPE i.

  CLEAR: gv_tipo_prioridade.

*  SELECT a~auart, b~txt
*    FROM /ptloms/tb010 AS a INNER JOIN t003p AS b
*    ON a~auart = b~auart
*    INTO TABLE @DATA(it_prioridade)
*    WHERE spras = @sy-langu.
  TYPES: BEGIN OF ty_prioridade,
           auart TYPE /ptloms/tb010-auart,
           txt   TYPE t003p-txt,
         END OF ty_prioridade.
  DATA it_prioridade TYPE TABLE OF ty_prioridade.
  SELECT a~auart b~txt
    FROM /ptloms/tb010 AS a INNER JOIN t003p AS b
    ON a~auart = b~auart
    INTO TABLE it_prioridade
    WHERE spras = sy-langu.

*LOOP AT it_prioridade ASSIGNING FIELD-SYMBOL(<fs_values>).
  FIELD-SYMBOLS: <fs_values> LIKE LINE OF it_prioridade.

  LOOP AT it_prioridade ASSIGNING <fs_values>.

    READ TABLE gt_tipo_ordem TRANSPORTING NO FIELDS WITH KEY auart  = <fs_values>-auart.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    lv_tabix     = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    ls_tab-auart = <fs_values>-auart.
    ls_tab-txt   = <fs_values>-txt.

    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

*  SELECT auart, artpr
*    FROM t350
*    INTO TABLE @DATA(it_t350)
*    FOR ALL ENTRIES IN @lt_tab
*    WHERE auart = @lt_tab-auart.
  TYPES: BEGIN OF ty_t350,
           auart TYPE t350-auart,
           artpr TYPE t350-artpr,
         END OF ty_t350.

  DATA it_t350 TYPE TABLE OF ty_t350.
  SELECT auart artpr
    FROM t350
    INTO TABLE it_t350
    FOR ALL ENTRIES IN lt_tab
    WHERE auart = lt_tab-auart.

  SORT it_t350 BY auart.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'AUART'
      value_org       = 'S'
      multiple_choice = p_mult
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
      field_tab       = lt_fields
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_status_incl TABLES lt_return
                                                     lt_tab.

      ELSE.
*        READ TABLE lt_tab ASSIGNING FIELD-SYMBOL(<fs_tab>) WITH KEY auart = ls_return-fieldval.
        FIELD-SYMBOLS: <fs_tab> LIKE LINE OF lt_tab.
        READ TABLE lt_tab ASSIGNING <fs_tab> WITH KEY auart = ls_return-fieldval.
        IF sy-subrc IS INITIAL.
          ls_dynpfields-fieldvalue = <fs_tab>-auart.
          SELECT SINGLE artpr
            FROM t350
            INTO gv_tipo_prioridade
            WHERE auart = <fs_tab>-auart.
          IF sy-subrc IS NOT INITIAL.
            CLEAR: gv_tipo_prioridade.
          ENDIF.
        ENDIF.

        " --- Atribui valor ao campo da tela
*        ls_dynpfields-fieldname  = '/PTLOMS/V015-AUART'.


*        DATA(lv_nome_campo) = '/PTLOMS/V015-AUART(' && lv_tc_actual_line && ')'.
        DATA lv_nome_campo TYPE dynfnam.
        lv_nome_campo = '/PTLOMS/V015-AUART(' && lv_tc_actual_line && ')'.
        ls_dynpfields-fieldname = lv_nome_campo.

        ls_dynpfields-stepl      = lv_tc_actual_line.
        APPEND ls_dynpfields TO lt_dynpfields.

        " --- Atribui valor ao campo da tela
*        ls_dynpfields-fieldname  = '/PTLOMS/V015-ARTPR'.
        lv_nome_campo = '/PTLOMS/V015-ARTPR(' && lv_tc_actual_line && ')'.
        ls_dynpfields-fieldname = lv_nome_campo.

        ls_dynpfields-fieldvalue = gv_tipo_prioridade.
        ls_dynpfields-stepl      = lv_tc_actual_line.
        APPEND ls_dynpfields TO lt_dynpfields.

        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_EQTYP
*&---------------------------------------------------------------------*
FORM f_help_prioridade USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix  TYPE sy-tabix,
           priok  TYPE t356-priok,
           priokx TYPE t356_t-priokx,
         END OF ty_tab.

  DATA: lt_tab            TYPE STANDARD TABLE OF ty_tab,
        lt_return         TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields     TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields     LIKE LINE OF lt_dynpfields,
        ls_tab            LIKE LINE OF lt_tab,
        it_values         TYPE TABLE OF dd07v,
        lv_tabix          TYPE sy-tabix,
        lt_fields         TYPE TABLE OF dfies,
        ls_fields         TYPE dfies,
        lv_tc_actual_line TYPE i.

*  SELECT * FROM
*    t356_t
*    INTO TABLE @DATA(it_356)
*    WHERE spras = @sy-langu AND
*          artpr = @gv_tipo_prioridade.
  DATA it_356 TYPE TABLE OF t356_t.
  SELECT * FROM t356_t
    INTO TABLE it_356
    WHERE spras = sy-langu AND
          artpr = gv_tipo_prioridade.

* Busca Perfil x Status equipamento específico
  DATA lt_tb051 TYPE TABLE OF /ptloms/tb051.
  SELECT *
    FROM /ptloms/tb051
    INTO TABLE lt_tb051
    WHERE perfil = gv_perfil.

*  LOOP AT it_356 ASSIGNING FIELD-SYMBOL(<fs_values>).
  FIELD-SYMBOLS: <fs_values> LIKE LINE OF it_356.
  LOOP AT it_356 ASSIGNING <fs_values>.

*    READ TABLE lt_tb051 TRANSPORTING NO FIELDS WITH KEY txt04  = <fs_values>-txt04.
*    IF  sy-subrc      EQ 0.
*      CONTINUE.
*    ENDIF.

    lv_tabix      = lv_tabix + 1.
    ls_tab-tabix  = lv_tabix.
    ls_tab-priok  = <fs_values>-priok.
    ls_tab-priokx = <fs_values>-priokx.

    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'PRIOK'
      value_org       = 'S'
      multiple_choice = p_mult
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
      field_tab       = lt_fields
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_status_incl TABLES lt_return
                                                     lt_tab.

      ELSE.

*        READ TABLE lt_tab ASSIGNING FIELD-SYMBOL(<fs_tab>) WITH KEY priok = ls_return-fieldval.
        FIELD-SYMBOLS: <fs_tab> LIKE LINE OF lt_tab.
        READ TABLE lt_tab ASSIGNING <fs_tab> WITH KEY priok = ls_return-fieldval.
        IF sy-subrc IS INITIAL.
          " --- Atribui valor ao campo da tela
          ls_dynpfields-fieldname  = '/PTLOMS/V015-PRIOK'.
          ls_dynpfields-fieldvalue = <fs_tab>-priok.
          ls_dynpfields-stepl      = lv_tc_actual_line.
          APPEND ls_dynpfields TO lt_dynpfields.

*          READ TABLE it_356 ASSIGNING FIELD-SYMBOL(<fs_t356>) WITH KEY priok = <fs_tab>-priok.
          FIELD-SYMBOLS: <fs_t356> LIKE LINE OF it_356.
          READ TABLE it_356 ASSIGNING <fs_t356> WITH KEY priok = <fs_tab>-priok.
          IF sy-subrc IS INITIAL.
            " --- Atribui valor ao campo da tela
            ls_dynpfields-fieldname  = '/PTLOMS/V015-PRIOKX'.
            ls_dynpfields-fieldvalue = <fs_t356>-priokx.
            ls_dynpfields-stepl      = lv_tc_actual_line.
            APPEND ls_dynpfields TO lt_dynpfields.
          ENDIF.
        ENDIF.

        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_EQTYP
*&---------------------------------------------------------------------*
FORM f_help_status_exclusivo USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
*           txt04 TYPE /ptloms/tb051-txt04,
           txt04 TYPE /ptloms/ed045,
           stat  TYPE j_istat,
*           stat  TYPE char5,
           txt30 TYPE tj02t-txt30,
         END OF ty_tab.


  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields LIKE LINE OF lt_dynpfields,
        ls_tab        LIKE LINE OF lt_tab,
        it_values     TYPE TABLE OF dd07v,
        lv_tabix      TYPE sy-tabix.

*  SELECT *
*    FROM tj05
*    INTO TABLE @DATA(it_tj05)
*    WHERE obtyp = 'IEQ'.
  DATA it_tj05 TYPE TABLE OF tj05.
  SELECT *
    FROM tj05
    INTO TABLE it_tj05
    WHERE obtyp = 'IEQ'.

  IF sy-subrc IS INITIAL.
*
*    SELECT *
*      FROM tj06
*      INTO TABLE @DATA(it_tj06)
*      FOR ALL ENTRIES IN @it_tj05
*      WHERE vrgng = @it_tj05-vrgng AND
*            inact <> 'X'.
    DATA it_tj06 TYPE TABLE OF tj06.
    SELECT *
      FROM tj06
      INTO TABLE it_tj06
      FOR ALL ENTRIES IN it_tj05
      WHERE vrgng = it_tj05-vrgng AND
            inact <> 'X'.

    IF sy-subrc IS INITIAL.

*      SELECT *
*        FROM tj02t
*        INTO TABLE @DATA(it_tj02t)
*        FOR ALL ENTRIES IN @it_tj06
*        WHERE istat = @it_tj06-istat AND
*              spras = @sy-langu      AND
*      ( txt04 <> 'INAT' AND txt04 <> 'MREL' AND txt04 <> 'BLOQ' AND txt04 <> 'ELIM' ).
      DATA it_tj02t TYPE TABLE OF tj02t.
      SELECT *
        FROM tj02t
        INTO TABLE it_tj02t
        FOR ALL ENTRIES IN it_tj06
        WHERE istat = it_tj06-istat AND
              spras = sy-langu      AND
      ( txt04 <> 'INAT' AND txt04 <> 'MREL' AND txt04 <> 'BLOQ' AND txt04 <> 'ELIM' ).

    ENDIF.

  ENDIF.

* Busca Perfil x Status equipamento específico
  DATA lt_tb052 TYPE TABLE OF /ptloms/tb052.
  REFRESH lt_tb052.

  SELECT *
    FROM /ptloms/tb052
    INTO TABLE lt_tb052
    WHERE perfil = gv_perfil.

*LOOP AT it_tj02t ASSIGNING FIELD-SYMBOL(<fs_values>).
  FIELD-SYMBOLS: <fs_values> LIKE LINE OF it_tj02t.

  LOOP AT it_tj02t ASSIGNING <fs_values>.

    READ TABLE lt_tb052 TRANSPORTING NO FIELDS WITH KEY stat  = <fs_values>-istat.
    IF  sy-subrc      EQ 0.
      CONTINUE.
    ENDIF.

    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    ls_tab-stat  = <fs_values>-istat.
    ls_tab-txt04 = <fs_values>-txt04.
    ls_tab-txt30 = <fs_values>-txt30.

    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TXT04'
      value_org       = 'S'
      multiple_choice = p_mult
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    " --- Recupera o registro selecionado pelo usuário
*   READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_status_excl TABLES lt_return
                                                     lt_tab.

      ELSE.

*        READ TABLE lt_tab ASSIGNING FIELD-SYMBOL(<fs_tab>) WITH KEY txt04 = ls_return-fieldval.
        FIELD-SYMBOLS <fs_tab> LIKE LINE OF lt_tab.
        READ TABLE lt_tab ASSIGNING <fs_tab> WITH KEY txt04 = ls_return-fieldval.

        IF sy-subrc IS INITIAL.
          ls_dynpfields-fieldvalue = <fs_tab>-txt04.
        ENDIF.

        " --- Atribui valor ao campo da tela
        ls_dynpfields-fieldname  = 'WA_EQUIP_STATUS_EXCLUSIVO-TXT04'.

        APPEND ls_dynpfields TO lt_dynpfields.

        " --- Atribui valor ao campo da tela
        ls_dynpfields-fieldname  = 'WA_EQUIP_STATUS_EXCLUSIVO-STAT'.
        ls_dynpfields-fieldvalue = ls_return-fieldval.
        APPEND ls_dynpfields TO lt_dynpfields.

        " --- Atribui valor ao campo da tela
        ls_dynpfields-fieldname  = 'WA_EQUIP_STATUS_EXCLUSIVO-TXT30'.
        ls_dynpfields-fieldvalue = ls_return-fieldval.
        APPEND ls_dynpfields TO lt_dynpfields.


        CALL FUNCTION 'DYNP_VALUES_UPDATE'
          EXPORTING
            dyname               = sy-repid
            dynumb               = sy-dynnr
          TABLES
            dynpfields           = lt_dynpfields
          EXCEPTIONS
            invalid_abapworkarea = 1
            invalid_dynprofield  = 2
            invalid_dynproname   = 3
            invalid_dynpronummer = 4
            invalid_request      = 5
            no_fielddescription  = 6
            undefind_error       = 7
            OTHERS               = 8.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_EQTYP
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_eqtyp USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           eqtyp TYPE t370t-eqtyp,
           typtx TYPE t370u-typtx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb007
*    INTO TABLE @DATA(lt_tb007).
  DATA lt_tb007 TYPE TABLE OF /ptloms/tb007.
  SELECT *
    FROM /ptloms/tb007
    INTO TABLE lt_tb007.

  IF lt_tb007[] IS NOT INITIAL.
*    SELECT spras, eqtyp, typtx
*      FROM t370u
*      INTO TABLE @DATA(lt_t370u)
*      FOR ALL ENTRIES IN @lt_tb007
*      WHERE spras = @sy-langu
*        AND eqtyp = @lt_tb007-eqtyp.
    TYPES: BEGIN OF ty_t370u,
             spras TYPE t370u-spras,
             eqtyp TYPE t370u-eqtyp,
             typtx TYPE t370u-typtx,
           END OF ty_t370u.
    DATA lt_t370u TYPE TABLE OF ty_t370u.
    SELECT spras eqtyp typtx
      FROM t370u
      INTO TABLE lt_t370u
      FOR ALL ENTRIES IN lt_tb007
      WHERE spras = sy-langu
        AND eqtyp = lt_tb007-eqtyp.

*    LOOP AT lt_tb007 INTO DATA(ls_007).
    DATA ls_007 LIKE LINE OF lt_tb007.
    LOOP AT lt_tb007 INTO ls_007.

      READ TABLE gt_cat_equipamento TRANSPORTING NO FIELDS WITH KEY eqtyp  = ls_007-eqtyp.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_007 TO ls_tab.
*      READ TABLE lt_t370u INTO DATA(ls_t370u) WITH KEY eqtyp = ls_007-eqtyp.
      DATA ls_t370u LIKE LINE OF lt_t370u.
      READ TABLE lt_t370u INTO ls_t370u WITH KEY eqtyp = ls_007-eqtyp.
      ls_tab-typtx = ls_t370u-typtx.
      APPEND ls_tab TO lt_tab.

    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'EQTYP'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_eqtyp TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*       READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_cat_equipamento-eqtyp = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_CAT_EQUIPAMENTO-EQTYP'.
          ls_dynpfields-fieldvalue = wa_cat_equipamento-eqtyp.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_t370u INTO ls_t370u WITH KEY eqtyp = wa_cat_equipamento-eqtyp.
          IF sy-subrc EQ 0.
            wa_cat_equipamento-typtx = ls_t370u-typtx.

            ls_dynpfields-fieldname = 'WA_CAT_EQUIPAMENTO-TYPTX'.
            ls_dynpfields-fieldvalue = wa_cat_equipamento-typtx.
            APPEND ls_dynpfields TO lt_dynpfields.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_EQART
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_eqart USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           eqart TYPE t370k-eqart,
           eartx TYPE t370k_t-eartx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb008
*    INTO TABLE @DATA(lt_tb008).
  DATA lt_tb008 TYPE TABLE OF /ptloms/tb008.
  SELECT *
    FROM /ptloms/tb008
    INTO TABLE lt_tb008.

  IF lt_tb008[] IS NOT INITIAL.
*    SELECT spras, eqart, eartx
*      FROM t370k_t
*      INTO TABLE @DATA(lt_t370k_t)
*      FOR ALL ENTRIES IN @lt_tb008
*      WHERE spras = @sy-langu
*        AND eqart = @lt_tb008-eqart.
    TYPES: BEGIN OF ty_t370k_t,
             spras TYPE t370k_t-spras,
             eqart TYPE t370k_t-eqart,
             eartx TYPE t370k_t-eartx,
           END OF ty_t370k_t.
    DATA lt_t370k_t TYPE TABLE OF ty_t370k_t.
    SELECT spras eqart eartx
      FROM t370k_t
      INTO TABLE lt_t370k_t
      FOR ALL ENTRIES IN lt_tb008
      WHERE spras = sy-langu
        AND eqart = lt_tb008-eqart.

* LOOP AT lt_tb008 INTO DATA(ls_008).
    DATA ls_008 LIKE LINE OF lt_tb008.
    LOOP AT lt_tb008 INTO ls_008.

      READ TABLE gt_tipo_objeto TRANSPORTING NO FIELDS WITH KEY eqart  = ls_008-eqart.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_008 TO ls_tab.
*      READ TABLE lt_t370k_t INTO DATA(ls_t370k_t) WITH KEY eqart = ls_008-eqart.
      DATA ls_t370k_t LIKE LINE OF lt_t370k_t.
      READ TABLE lt_t370k_t INTO ls_t370k_t WITH KEY eqart = ls_008-eqart.
      ls_tab-eartx = ls_t370k_t-eartx.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'EQART'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_eqart TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_tipo_objeto-eqart = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_TIPO_OBJETO-EQART'.
          ls_dynpfields-fieldvalue = wa_tipo_objeto-eqart.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_t370k_t INTO ls_t370k_t WITH KEY eqart = wa_tipo_objeto-eqart.
          IF sy-subrc EQ 0.
            wa_tipo_objeto-eartx = ls_t370k_t-eartx.

            ls_dynpfields-fieldname = 'WA_TIPO_OBJETO-EARTX'.
            ls_dynpfields-fieldvalue = wa_tipo_objeto-eartx.
            APPEND ls_dynpfields TO lt_dynpfields.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_MATKL
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_matkl USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           matkl TYPE t023t-matkl,
           wgbez TYPE t023t-wgbez,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb027
*    INTO TABLE @DATA(lt_tb027).
  DATA lt_tb027 TYPE TABLE OF /ptloms/tb027.
  SELECT *
    FROM /ptloms/tb027
    INTO TABLE lt_tb027.

  IF lt_tb027[] IS NOT INITIAL.
*    SELECT spras, matkl, wgbez60
*      FROM t023t
*      INTO TABLE @DATA(lt_023t)
*      FOR ALL ENTRIES IN @lt_tb027
*      WHERE spras = @sy-langu
*        AND matkl = @lt_tb027-matkl.
    DATA lt_023t TYPE TABLE OF t023t.
    SELECT spras matkl wgbez
      FROM t023t
      INTO CORRESPONDING FIELDS OF TABLE lt_023t
      FOR ALL ENTRIES IN lt_tb027
      WHERE spras = sy-langu
        AND matkl = lt_tb027-matkl.

*    LOOP AT lt_tb027 INTO DATA(ls_027).
    DATA ls_027 LIKE LINE OF lt_tb027.
    LOOP AT lt_tb027 INTO ls_027.

      READ TABLE gt_grupo_mercadoria TRANSPORTING NO FIELDS WITH KEY matkl  = ls_027-matkl.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_027 TO ls_tab.
*      READ TABLE lt_023t INTO DATA(ls_023t) WITH KEY matkl = ls_027-matkl.
      DATA ls_023t LIKE LINE OF lt_023t.
      READ TABLE lt_023t INTO ls_023t WITH KEY matkl = ls_027-matkl.
      ls_tab-wgbez = ls_023t-wgbez.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'MATKL'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_matkl TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_grupo_mercadoria-matkl = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_GRUPO_MERCADORIA-MATKL'.
          ls_dynpfields-fieldvalue = wa_grupo_mercadoria-matkl.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_023t INTO ls_023t WITH KEY matkl = wa_grupo_mercadoria-matkl.
          IF sy-subrc EQ 0.
            wa_grupo_mercadoria-wgbez = ls_023t-wgbez.

            ls_dynpfields-fieldname = 'WA_GRUPO_MERCADORIA-WGBEZ'.
            ls_dynpfields-fieldvalue = wa_grupo_mercadoria-wgbez.
            APPEND ls_dynpfields TO lt_dynpfields.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_LGORT
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_lgort USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
           lgort TYPE t001l-lgort,
           lgobe TYPE t001l-lgobe,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb029
*    INTO TABLE @DATA(lt_tb029).
  DATA lt_tb029 TYPE TABLE OF /ptloms/tb029.
  SELECT *
    FROM /ptloms/tb029
    INTO TABLE lt_tb029.

  IF lt_tb029[] IS NOT INITIAL.
*    SELECT werks, lgort, lgobe
*      FROM t001l
*      INTO TABLE @DATA(lt_t001l)
*      FOR ALL ENTRIES IN @lt_tb029
*      WHERE werks = @lt_tb029-werks
*        AND lgort = @lt_tb029-lgort.
    TYPES: BEGIN OF ty_t001l,
             werks TYPE t001l-werks,
             lgort TYPE t001l-lgort,
             lgobe TYPE t001l-lgobe,
           END OF ty_t001l.
    DATA lt_t001l TYPE TABLE OF ty_t001l.
    SELECT werks lgort lgobe
      FROM t001l
      INTO TABLE lt_t001l
      FOR ALL ENTRIES IN lt_tb029
      WHERE werks = lt_tb029-werks
        AND lgort = lt_tb029-lgort.

*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb029
*      WHERE werks = @lt_tb029-werks.
    TYPES: BEGIN OF ty_t001w,
             werks TYPE t001w-werks,
             name1 TYPE t001w-name1,
           END OF ty_t001w.
    DATA lt_t001w TYPE TABLE OF ty_t001w.
    SELECT werks name1
      FROM t001w
      INTO TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb029
      WHERE werks = lt_tb029-werks.

*    LOOP AT lt_tb029 INTO DATA(ls_029).
    DATA ls_029 LIKE LINE OF lt_tb029.
    LOOP AT lt_tb029 INTO ls_029.

      READ TABLE gt_deposito TRANSPORTING NO FIELDS WITH KEY werks  = ls_029-werks
                                                             lgort  = ls_029-lgort.
      IF  sy-subrc EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_029 TO ls_tab.
*      READ TABLE lt_t001l INTO DATA(ls_t001l) WITH KEY werks = ls_029-werks
*                                                       lgort = ls_029-lgort.
      DATA ls_t001l LIKE LINE OF lt_t001l.
      READ TABLE lt_t001l INTO ls_t001l WITH KEY werks = ls_029-werks
                                                 lgort = ls_029-lgort.
      ls_tab-lgobe = ls_t001l-lgobe.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_029-werks.
      DATA ls_t001w LIKE LINE OF lt_t001w.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_029-werks.
      ls_tab-name1 = ls_t001w-name1.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TABIX'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_lgort TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.


        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
          MOVE ls_return-fieldval TO lv_tabix.

          READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

          wa_deposito-lgort = ls_tab-lgort.
          ls_dynpfields-fieldname = 'WA_DEPOSITO-LGORT'.
          ls_dynpfields-fieldvalue = wa_deposito-lgort.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_deposito-lgobe = ls_tab-lgobe.
          ls_dynpfields-fieldname = 'WA_DEPOSITO-LGOBE'.
          ls_dynpfields-fieldvalue = wa_deposito-lgobe.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_deposito-name1 = ls_tab-name1.
          ls_dynpfields-fieldname = 'WA_DEPOSITO-NAME1'.
          ls_dynpfields-fieldvalue = wa_deposito-name1.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_deposito-werks = ls_tab-werks.
          ls_dynpfields-fieldname = 'WA_DEPOSITO-WERKS'.
          ls_dynpfields-fieldvalue = wa_deposito-werks.
          APPEND ls_dynpfields TO lt_dynpfields.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_GRUND
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_grund USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
           grund TYPE trug-grund,
           grdtx TYPE trugt-grdtx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb038
*    INTO TABLE @DATA(lt_tb038).
  DATA lt_tb038 TYPE TABLE OF /ptloms/tb038.
  SELECT *
    FROM /ptloms/tb038
    INTO TABLE lt_tb038.

  IF lt_tb038[] IS NOT INITIAL.
*    SELECT werks, grund
*      FROM trug
*      INTO TABLE @DATA(lt_trug)
*      FOR ALL ENTRIES IN @lt_tb038
*      WHERE werks = @lt_tb038-werks
*        AND grund = @lt_tb038-grund.

*    SELECT werks, grund, grdtx
*      FROM trugt
*      INTO TABLE @DATA(lt_trugt)
*      FOR ALL ENTRIES IN @lt_tb038
*      WHERE spras = @sy-langu
*        AND werks = @lt_tb038-werks
*        AND grund = @lt_tb038-grund.
    TYPES: BEGIN OF ty_trugt,
             werks TYPE trugt-werks,
             grund TYPE trugt-grund,
             grdtx TYPE trugt-grdtx,
           END OF ty_trugt.

    DATA lt_trugt TYPE TABLE OF ty_trugt.
    SELECT werks grund grdtx
      FROM trugt
      INTO TABLE lt_trugt
      FOR ALL ENTRIES IN lt_tb038
      WHERE spras = sy-langu
        AND werks = lt_tb038-werks
        AND grund = lt_tb038-grund.

*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb038
*      WHERE werks = @lt_tb038-werks.
    DATA lt_t001w TYPE TABLE OF t001w.
    SELECT werks name1
      FROM t001w
      INTO CORRESPONDING FIELDS OF TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb038
      WHERE werks = lt_tb038-werks.

*    LOOP AT lt_tb038 INTO DATA(ls_038).
    DATA ls_038 LIKE LINE OF lt_tb038.

    LOOP AT lt_tb038 INTO ls_038.

      READ TABLE gt_causa_desvio TRANSPORTING NO FIELDS WITH KEY werks  = ls_038-werks
                                                                 grund  = ls_038-grund.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_038 TO ls_tab.
*      READ TABLE lt_trugt INTO DATA(ls_trugt) WITH KEY werks = ls_038-werks
*                                                       grund = ls_038-grund.
      DATA ls_trugt LIKE LINE OF lt_trugt.
      READ TABLE lt_trugt INTO ls_trugt WITH KEY werks = ls_038-werks
                                                 grund = ls_038-grund.
      ls_tab-grdtx = ls_trugt-grdtx.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_038-werks.
      DATA ls_t001w LIKE LINE OF lt_t001w.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_038-werks.
      ls_tab-name1 = ls_t001w-name1.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TABIX'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_causa_desvio TABLES lt_return
                                                     lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
          MOVE ls_return-fieldval TO lv_tabix.

          READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

          wa_causa_desvio-grund = ls_tab-grund.
          ls_dynpfields-fieldname = 'WA_CAUSA_DESVIO-GRUND'.
          ls_dynpfields-fieldvalue = wa_causa_desvio-grund.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_causa_desvio-grdtx = ls_tab-grdtx.
          ls_dynpfields-fieldname = 'WA_CAUSA_DESVIO-GRDTX'.
          ls_dynpfields-fieldvalue = wa_causa_desvio-grdtx.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_causa_desvio-name1 = ls_tab-name1.
          ls_dynpfields-fieldname = 'WA_CAUSA_DESVIO-NAME1'.
          ls_dynpfields-fieldvalue = wa_causa_desvio-name1.
          APPEND ls_dynpfields TO lt_dynpfields.

          wa_causa_desvio-werks = ls_tab-werks.
          ls_dynpfields-fieldname = 'WA_CAUSA_DESVIO-WERKS'.
          ls_dynpfields-fieldvalue = wa_causa_desvio-werks.
          APPEND ls_dynpfields TO lt_dynpfields.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_AUTORIZ
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_autoriz USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           autorizacao      TYPE /ptloms/tb043-autorizacao,
           desc_autorizacao TYPE val_text,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        lt_values_tab TYPE STANDARD TABLE OF dd07v.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

* Busca descrições do Status Mobile
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = '/PTLOMS/DM011'
      text            = 'X'
    TABLES
      values_tab      = lt_values_tab
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  IF lt_values_tab[] IS NOT INITIAL.

*    LOOP AT lt_values_tab INTO DATA(ls_values_tab).
    DATA ls_values_tab LIKE LINE OF lt_values_tab.
    LOOP AT lt_values_tab INTO ls_values_tab.

      READ TABLE gt_autorizacao TRANSPORTING NO FIELDS WITH KEY autorizacao  = ls_values_tab-domvalue_l.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      ls_tab-autorizacao      = ls_values_tab-domvalue_l.
      ls_tab-desc_autorizacao = ls_values_tab-ddtext.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'AUTORIZACAO'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_autorizacao TABLES lt_return
                                                    lt_tab.

      ELSE.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_CONFIG
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_config USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
*           tabix             TYPE sy-tabix,
           configuracao      TYPE /ptloms/tb044-configuracao,
           desc_configuracao TYPE val_text,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        lt_values_tab TYPE STANDARD TABLE OF dd07v.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

* Busca descrições do Status Mobile
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = '/PTLOMS/DM012'
      text            = 'X'
    TABLES
      values_tab      = lt_values_tab
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  IF lt_values_tab[] IS NOT INITIAL.

*    LOOP AT lt_values_tab INTO DATA(ls_values_tab).
    DATA ls_values_tab LIKE LINE OF lt_values_tab.
    LOOP AT lt_values_tab INTO ls_values_tab.

      READ TABLE gt_configuracao TRANSPORTING NO FIELDS WITH KEY configuracao  = ls_values_tab-domvalue_l.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
*      ls_tab-tabix             = lv_tabix.
      ls_tab-configuracao      = ls_values_tab-domvalue_l.
      ls_tab-desc_configuracao = ls_values_tab-ddtext.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'CONFIGURACAO'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_configuracao TABLES lt_return
                                                     lt_tab.

      ELSE.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_CONFIG
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_caract USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           atnam TYPE /ptloms/tb058-atnam,
           atbez TYPE cabnt-atbez,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        lt_values_tab TYPE STANDARD TABLE OF dd07v,
        ls_dynpfields LIKE LINE OF lt_dynpfields,
        ls_tab        LIKE LINE OF lt_tab,
        lv_tabix      TYPE sy-tabix.

*  SELECT atnam, atbez
*    FROM /ptloms/tb058 AS a INNER JOIN cabnt AS b
*    ON a~atinn = b~atinn AND
*       b~spras = @sy-langu
*    INTO TABLE @DATA(lt_cabnt).
  TYPES: BEGIN OF ty_cabnt,
           atnam TYPE /ptloms/tb058-atnam,
           atbez TYPE cabnt-atbez,
         END OF ty_cabnt.
  DATA lt_cabnt TYPE TABLE OF ty_cabnt.
  SELECT atnam atbez
    FROM /ptloms/tb058 AS a INNER JOIN cabnt AS b
    ON a~atinn = b~atinn AND
       b~spras = sy-langu
    INTO TABLE lt_cabnt.

  IF lt_cabnt[] IS NOT INITIAL.

*    LOOP AT lt_cabnt INTO DATA(ls_cabnt).
    DATA ls_cabnt LIKE LINE OF lt_cabnt.
    LOOP AT lt_cabnt INTO ls_cabnt.

      READ TABLE gt_caract_equipamento TRANSPORTING NO FIELDS WITH KEY atnam  = ls_cabnt-atnam.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix      = lv_tabix + 1.
      ls_tab-tabix  = lv_tabix.
      ls_tab-atnam  = ls_cabnt-atnam.
      ls_tab-atbez  = ls_cabnt-atbez.
      APPEND ls_tab TO lt_tab.

    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TABIX'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_caract TABLES lt_return lt_tab.

      ELSE.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_QMART
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_qmart USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix  TYPE sy-tabix,
           qmart  TYPE tq80-qmart,
           qmtyp  TYPE tq80-qmtyp,
           rbnr   TYPE tq80-rbnr,
           qmartx TYPE tq80_t-qmartx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix  TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb009
*    INTO TABLE @DATA(lt_tb009).
  DATA lt_tb009 TYPE TABLE OF /ptloms/tb009.
  SELECT *
    FROM /ptloms/tb009
    INTO TABLE lt_tb009.

  IF lt_tb009[] IS NOT INITIAL.
*    SELECT qmart, qmtyp, rbnr
*      FROM tq80
*      INTO TABLE @DATA(lt_tq80)
*      FOR ALL ENTRIES IN @lt_tb009
*      WHERE qmart = @lt_tb009-qmart.
    TYPES: BEGIN OF ty_tq80,
             qmart TYPE tq80-qmart,
             qmtyp TYPE tq80-qmtyp,
             rbnr  TYPE tq80-rbnr,
           END OF ty_tq80.
    DATA lt_tq80 TYPE TABLE OF ty_tq80.
    SELECT qmart qmtyp rbnr
      FROM tq80
      INTO TABLE lt_tq80
      FOR ALL ENTRIES IN lt_tb009
      WHERE qmart = lt_tb009-qmart.

*    SELECT spras, qmart, qmartx
*      FROM tq80_t
*      INTO TABLE @DATA(lt_tq80_t)
*      FOR ALL ENTRIES IN @lt_tb009
*      WHERE spras = @sy-langu
*        AND qmart = @lt_tb009-qmart.
    TYPES: BEGIN OF ty_tq80_t,
             spras  TYPE tq80_t-spras,
             qmart  TYPE tq80_t-qmart,
             qmartx TYPE tq80_t-qmartx,
           END OF ty_tq80_t.
    DATA lt_tq80_t TYPE TABLE OF ty_tq80_t.
    SELECT spras qmart qmartx
      FROM tq80_t
      INTO TABLE lt_tq80_t
      FOR ALL ENTRIES IN lt_tb009
      WHERE spras = sy-langu
        AND qmart = lt_tb009-qmart.

* Busca Perfil x Tipo Nota Cadastrada
    DATA: lt_021 TYPE TABLE OF /ptloms/tb021.
    SELECT *
      FROM /ptloms/tb021
      INTO CORRESPONDING FIELDS OF TABLE lt_021
      WHERE perfil = gv_perfil.

*    LOOP AT lt_tb009 INTO DATA(ls_009).
    DATA ls_009 LIKE LINE OF lt_tb009.
    LOOP AT lt_tb009 INTO ls_009.

      READ TABLE lt_021 TRANSPORTING NO FIELDS WITH KEY qmart  = ls_009-qmart.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_009 TO ls_tab.
*      READ TABLE lt_tq80 INTO DATA(ls_tq80) WITH KEY qmart = ls_009-qmart.
      DATA ls_tq80 LIKE LINE OF lt_tq80.
      READ TABLE lt_tq80 INTO ls_tq80 WITH KEY qmart = ls_009-qmart.
      ls_tab-qmtyp = ls_tq80-qmtyp.
      ls_tab-rbnr  = ls_tq80-rbnr.
*      READ TABLE lt_tq80_t INTO DATA(ls_tq80_t) WITH KEY qmart = ls_009-qmart.
      DATA ls_tq80_t LIKE LINE OF lt_tq80_t.
      READ TABLE lt_tq80_t INTO ls_tq80_t WITH KEY qmart = ls_009-qmart.
      ls_tab-qmartx = ls_tq80_t-qmartx.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'QMART'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_qmart TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_tipo_nota-qmart = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_TIPO_NOTA-QMART'.
          ls_dynpfields-fieldvalue = wa_tipo_nota-qmart.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_tq80 INTO ls_tq80 WITH KEY qmart = wa_tipo_nota-qmart.
          IF sy-subrc EQ 0.
            wa_tipo_nota-qmtyp = ls_tq80-qmtyp.
            wa_tipo_nota-rbnr  = ls_tq80-rbnr.

            ls_dynpfields-fieldname = 'WA_TIPO_NOTA-QMTYP'.
            ls_dynpfields-fieldvalue = wa_tipo_nota-qmtyp.
            APPEND ls_dynpfields TO lt_dynpfields.

            ls_dynpfields-fieldname = 'WA_TIPO_NOTA-RBNR'.
            ls_dynpfields-fieldvalue = wa_tipo_nota-rbnr.
            APPEND ls_dynpfields TO lt_dynpfields.

            READ TABLE lt_tq80_t INTO ls_tq80_t WITH KEY qmart = wa_tipo_nota-qmart.
            IF sy-subrc EQ 0.
              wa_tipo_nota-qmartx = ls_tq80_t-qmartx.

              ls_dynpfields-fieldname = 'WA_TIPO_NOTA-QMARTX'.
              ls_dynpfields-fieldvalue = wa_tipo_nota-qmartx.
              APPEND ls_dynpfields TO lt_dynpfields.
            ENDIF.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_QMART
*&---------------------------------------------------------------------*
FORM f_help_filtro_catalogo CHANGING p_value TYPE char2 p_text TYPE auarttext.

  TYPES: BEGIN OF ty_tab,
           catalogo TYPE /ptloms/ed044,
           texto    TYPE ddtext,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields LIKE LINE OF lt_dynpfields,
        ls_tab        LIKE LINE OF lt_tab,
        it_values     TYPE TABLE OF dd07v.

  CALL FUNCTION 'DDUT_DOMVALUES_GET'
    EXPORTING
      name          = '/PTLOMS/DM014'
      langu         = sy-langu
*     TEXTS_ONLY    = ' '
    TABLES
      dd07v_tab     = it_values
    EXCEPTIONS
      illegal_input = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  LOOP AT it_values ASSIGNING FIELD-SYMBOL(<fs_values>).
  FIELD-SYMBOLS: <fs_values> LIKE LINE OF it_values.
  LOOP AT it_values ASSIGNING <fs_values>.

    ls_tab-texto    = <fs_values>-ddtext.
    ls_tab-catalogo = <fs_values>-domvalue_l.

    APPEND ls_tab TO lt_tab.

  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'FILTRO_CATALOGO'
      value_org       = 'S'
      multiple_choice = ''
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.

    " --- Recupera o registro selecionado pelo usuário
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

*      READ TABLE lt_tab ASSIGNING FIELD-SYMBOL(<fs_tab>) WITH KEY texto = ls_return-fieldval.
      FIELD-SYMBOLS <fs_tab> LIKE LINE OF lt_tab.
      READ TABLE lt_tab ASSIGNING <fs_tab> WITH KEY texto = ls_return-fieldval.

      IF sy-subrc IS INITIAL.
        p_value = ls_dynpfields-fieldvalue = <fs_tab>-catalogo.
      ENDIF.

      " --- Atribui valor ao campo da tela
      ls_dynpfields-fieldname  = 'WA_TIPO_NOTA-FILTRO_CATALOGO'.

      APPEND ls_dynpfields TO lt_dynpfields.

      " --- Atribui valor ao campo da tela
      ls_dynpfields-fieldname  = 'WA_TIPO_NOTA-FILTRO_TXT'.
      p_text = ls_dynpfields-fieldvalue = ls_return-fieldval.

      APPEND ls_dynpfields TO lt_dynpfields.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_AUART
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_auart USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           auart TYPE t003o-auart,
           autyp TYPE t003o-autyp,
           txt   TYPE t003p-txt,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix TYPE sy-tabix.

*  SELECT *
*    FROM /ptloms/tb010
*    INTO TABLE @DATA(lt_tb010).
  DATA lt_tb010 TYPE TABLE OF /ptloms/tb010.
  SELECT *
    FROM /ptloms/tb010
    INTO TABLE lt_tb010.

  IF lt_tb010[] IS NOT INITIAL.
*    SELECT auart, autyp
*      FROM t003o
*      INTO TABLE @DATA(lt_t003o)
*      FOR ALL ENTRIES IN @lt_tb010
*      WHERE auart = @lt_tb010-auart.
    TYPES: BEGIN OF ty_t003o,
             auart TYPE t003o-auart,
             autyp TYPE t003o-autyp,
           END OF ty_t003o.
    DATA lt_t003o TYPE TABLE OF ty_t003o.
    SELECT auart autyp
      FROM t003o
      INTO TABLE lt_t003o
      FOR ALL ENTRIES IN lt_tb010
      WHERE auart = lt_tb010-auart.

*    SELECT spras, auart, txt
*      FROM t003p
*      INTO TABLE @DATA(lt_t003p)
*      FOR ALL ENTRIES IN @lt_tb010
*      WHERE spras = @sy-langu
*        AND auart = @lt_tb010-auart.
    TYPES: BEGIN OF ty_t003p,
             spras TYPE t003p-spras,
             auart TYPE t003p-auart,
             txt   TYPE t003p-txt,
           END OF ty_t003p.
    DATA lt_t003p TYPE TABLE OF ty_t003p.
    SELECT spras auart txt
      FROM t003p
      INTO TABLE lt_t003p
      FOR ALL ENTRIES IN lt_tb010
      WHERE spras = sy-langu
        AND auart = lt_tb010-auart.

* Busca Perfil x Tipo Ordem Cadastrada
    DATA: lt_022 TYPE TABLE OF /ptloms/tb022.
    SELECT *
      FROM /ptloms/tb022
      INTO CORRESPONDING FIELDS OF TABLE lt_022
      WHERE perfil = gv_perfil.

*    LOOP AT lt_tb010 INTO DATA(ls_010).
    DATA ls_010 LIKE LINE OF lt_tb010.
    LOOP AT lt_tb010 INTO ls_010.

      READ TABLE lt_022 TRANSPORTING NO FIELDS WITH KEY auart  = ls_010-auart.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_010 TO ls_tab.
*      READ TABLE lt_t003o INTO DATA(ls_t003o) WITH KEY auart = ls_010-auart.
      DATA ls_t003o LIKE LINE OF lt_t003o.
      READ TABLE lt_t003o INTO ls_t003o WITH KEY auart = ls_010-auart.
      ls_tab-autyp = ls_t003o-autyp.
*      READ TABLE lt_t003p INTO DATA(ls_t003p) WITH KEY auart = ls_010-auart.
      DATA ls_t003p LIKE LINE OF lt_t003p.
      READ TABLE lt_t003p INTO ls_t003p WITH KEY auart = ls_010-auart.
      ls_tab-txt = ls_t003p-txt.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'AUART'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_auart TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_tipo_ordem-auart = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_TIPO_ORDEM-AUART'.
          ls_dynpfields-fieldvalue = wa_tipo_ordem-auart.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_t003o INTO ls_t003o WITH KEY auart = wa_tipo_ordem-auart.
          IF sy-subrc EQ 0.
            wa_tipo_ordem-autyp = ls_t003o-autyp.

            ls_dynpfields-fieldname = 'WA_TIPO_ORDEM-AUTYP'.
            ls_dynpfields-fieldvalue = wa_tipo_ordem-autyp.
            APPEND ls_dynpfields TO lt_dynpfields.

            READ TABLE lt_t003p INTO ls_t003p WITH KEY auart = wa_tipo_ordem-auart.
            IF sy-subrc EQ 0.
              wa_tipo_ordem-txt = ls_t003p-txt.

              ls_dynpfields-fieldname = 'WA_TIPO_ORDEM-TXT'.
              ls_dynpfields-fieldvalue = wa_tipo_ordem-txt.
              APPEND ls_dynpfields TO lt_dynpfields.
            ENDIF.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
******************************* By Nádia - End
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_AUART
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_ilart USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           ilart TYPE t353i-ilart,
           ilatx TYPE t353i_t-ilatx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix TYPE sy-tabix.

  DATA: lt_tb024   TYPE TABLE OF /ptloms/tb024,
        lt_t353i_t TYPE TABLE OF t353i_t,
        ls_t353i_t LIKE LINE OF lt_t353i_t.

  SELECT *
    FROM /ptloms/tb024
    INTO TABLE lt_tb024.
*    INTO TABLE @DATA(lt_tb024).

  IF lt_tb024[] IS NOT INITIAL.

    SELECT spras ilart ilatx
      FROM t353i_t
      INTO CORRESPONDING FIELDS OF TABLE lt_t353i_t
*      INTO TABLE @DATA(lt_t353i_t)
      FOR ALL ENTRIES IN lt_tb024
      WHERE spras = sy-langu
        AND ilart = lt_tb024-ilart.

    DATA ls_024 LIKE LINE OF lt_tb024.
    LOOP AT lt_tb024 INTO ls_024.
*    LOOP AT lt_tb024 INTO DATA(ls_024).

      READ TABLE gt_tipo_atv_ordem TRANSPORTING NO FIELDS WITH KEY ilart  = ls_024-ilart.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_024 TO ls_tab.
      READ TABLE lt_t353i_t INTO ls_t353i_t WITH KEY ilart = ls_024-ilart.
*      READ TABLE lt_t353i_t INTO DATA(ls_t353i_t) WITH KEY ilart = ls_024-ilart.
      ls_tab-ilatx = ls_t353i_t-ilatx.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'ILART'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_ilart TABLES lt_return
                                              lt_tab.

      ELSE.

        " --- Recupera o registro selecionado pelo usuário
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
        DATA ls_return LIKE LINE OF lt_return.
        READ TABLE lt_return INTO ls_return INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_tipo_atv_ordem-ilart = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_TIPO_ATV_ORDEM-ILART'.
          ls_dynpfields-fieldvalue = wa_tipo_atv_ordem-ilart.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_t353i_t INTO ls_t353i_t WITH KEY ilart = wa_tipo_atv_ordem-ilart.
          IF sy-subrc EQ 0.
            wa_tipo_atv_ordem-ilatx = ls_t353i_t-ilatx.

            ls_dynpfields-fieldname = 'WA_TIPO_ATV_ORDEM-ILATX'.
            ls_dynpfields-fieldvalue = wa_tipo_atv_ordem-ilatx.
            APPEND ls_dynpfields TO lt_dynpfields.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_COD_ADM_MTART
*&---------------------------------------------------------------------*
FORM f_help_cod_adm_mtart USING p_mult TYPE ddbool_d.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           mtart TYPE t134-mtart,
           mtbez TYPE t134t-mtbez,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: lv_tabix TYPE sy-tabix.

  DATA lt_tb011 TYPE TABLE OF /ptloms/tb011.
  DATA lt_t134t TYPE STANDARD TABLE OF t134t.

  SELECT *
    FROM /ptloms/tb011
    INTO TABLE lt_tb011.
*    INTO TABLE @DATA(lt_tb011).

  IF lt_tb011[] IS NOT INITIAL.
    SELECT spras mtart mtbez
      FROM t134t
      INTO CORRESPONDING FIELDS OF TABLE lt_t134t
*      INTO TABLE @DATA(lt_t134t)
      FOR ALL ENTRIES IN lt_tb011
      WHERE spras = sy-langu
        AND mtart = lt_tb011-mtart.

    DATA ls_011 LIKE LINE OF lt_tb011.
    LOOP AT lt_tb011 INTO ls_011.
*    LOOP AT lt_tb011 INTO DATA(ls_011).

      READ TABLE gt_tipo_material TRANSPORTING NO FIELDS WITH KEY mtart  = ls_011-mtart.
      IF  sy-subrc      EQ 0.
        CONTINUE.
      ENDIF.

      CLEAR ls_tab.
      lv_tabix = lv_tabix + 1.
      ls_tab-tabix = lv_tabix.
      MOVE-CORRESPONDING ls_011 TO ls_tab.

      DATA ls_t134t LIKE LINE OF lt_t134t.
      READ TABLE lt_t134t INTO ls_t134t WITH KEY mtart = ls_011-mtart.
*      READ TABLE lt_t134t INTO DATA(ls_t134t) WITH KEY mtart = ls_011-mtart.
      ls_tab-mtbez = ls_t134t-mtbez.
      APPEND ls_tab TO lt_tab.
    ENDLOOP.

    IF lt_tab[] IS INITIAL.
      MOVE  'Não existen dados para ser inseridos' TO lv_msg .
      MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
      RETURN.
    ENDIF.

    " --- Apresenta na tela os valores
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'MTART'
        value_org       = 'S'
        multiple_choice = p_mult
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      IF p_mult = 'X'.

        PERFORM f_seleciona_mult_mtart TABLES lt_return
                                              lt_tab.

      ELSE.

        DATA ls_return LIKE LINE OF lt_return.
        " --- Recupera o registro selecionado pelo usuário
        READ TABLE lt_return INTO ls_return INDEX 1.
*        READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

        IF sy-subrc = 0.
          " --- Atribui valor ao campo da tela
          wa_tipo_material-mtart = ls_return-fieldval.

          ls_dynpfields-fieldname = 'WA_TIPO_MATERIAL-MTART'.
          ls_dynpfields-fieldvalue = wa_tipo_material-mtart.
          APPEND ls_dynpfields TO lt_dynpfields.

          READ TABLE lt_t134t INTO ls_t134t WITH KEY mtart = wa_tipo_material-mtart.
          IF sy-subrc EQ 0.
            wa_tipo_material-mtbez = ls_t134t-mtbez.

            ls_dynpfields-fieldname = 'WA_TIPO_MATERIAL-MTBEZ'.
            ls_dynpfields-fieldvalue = wa_tipo_material-mtbez.
            APPEND ls_dynpfields TO lt_dynpfields.
          ENDIF.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-repid
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynpfields
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_V002
*&---------------------------------------------------------------------*
FORM f_help_v002 .

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           iwerk TYPE t024i-iwerk,
           name1 TYPE t001w-name1,
           ingrp TYPE t024i-ingrp,
           innam TYPE t024i-innam,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab                TYPE STANDARD TABLE OF ty_tab,
        lt_return             TYPE STANDARD TABLE OF ddshretval,
        lt_grupo_planejamento TYPE /ptloms/ct007,
        lt_dynpfields         TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_tabix          TYPE sy-tabix,
        lv_tc_actual_line TYPE i.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA lt_tb002 TYPE TABLE OF /ptloms/tb002.
  SELECT *
      FROM /ptloms/tb002
      INTO TABLE lt_tb002
      WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
*  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
*  ENDIF.

  DATA lt_t001w TYPE TABLE OF t001w.

  IF lt_tb002[] IS NOT INITIAL.
    SELECT werks name1
      FROM t001w
      INTO TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = 'X'
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_grupo_planejamento      = lt_grupo_planejamento ).

*  SELECT iwerk, ingrp, innam
*    FROM t024i
*    INTO CORRESPONDING FIELDS OF TABLE @lt_grupo_planejamento.

*  LOOP AT lt_grupo_planejamento INTO DATA(ls_grupo_planejamento).
*    READ TABLE lt_tb002 INTO DATA(ls_002)
*    WITH KEY werks = ls_grupo_planejamento-iwerk.

  DATA: ls_grupo_planejamento LIKE LINE OF lt_grupo_planejamento,
        ls_002                LIKE LINE OF lt_tb002.

  LOOP AT lt_grupo_planejamento INTO ls_grupo_planejamento.
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_grupo_planejamento-iwerk.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    DATA ls_t001w LIKE LINE OF lt_t001w.

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_grupo_planejamento TO ls_tab.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    DATA ls_return LIKE LINE OF lt_return.
    " --- Recupera o registro selecionado pelo usuário
    READ TABLE lt_return INTO ls_return INDEX 1.
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

    IF sy-subrc = 0.
      CLEAR lv_tabix.

      " --- Atribui valor ao campo da tela
      REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
      MOVE ls_return-fieldval TO lv_tabix.

      lv_tabix = ls_return-fieldval.

      READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

      DATA lv_nome_campo TYPE dynfnam.
      /ptloms/v002-iwerk = ls_tab-iwerk.
      lv_nome_campo = '/PTLOMS/V002-IWERK(' && lv_tc_actual_line && ')'.
*      DATA(lv_nome_campo) = '/PTLOMS/V002-IWERK(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v002-iwerk.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v002-name1 = ls_tab-name1.
      lv_nome_campo = '/PTLOMS/V002-NAME1(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v002-name1.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v002-ingrp = ls_tab-ingrp.
      lv_nome_campo = '/PTLOMS/V002-INGRP(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v002-ingrp.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v002-innam = ls_tab-innam.
      lv_nome_campo = '/PTLOMS/V002-INNAM(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v002-innam.
      APPEND ls_dynpfields TO lt_dynpfields.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_V003
*&---------------------------------------------------------------------*
FORM f_help_v003 .

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           werks TYPE t357-werks,
           name1 TYPE t001w-name1,
           beber TYPE t357-beber,
           fing  TYPE t357-fing,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab              TYPE STANDARD TABLE OF ty_tab,
        lt_return           TYPE STANDARD TABLE OF ddshretval,
        lt_area_operacional TYPE /ptloms/ct008,
        lt_dynpfields       TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_tabix          TYPE sy-tabix,
        lv_tc_actual_line TYPE i.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.

  DATA lt_tb002 TYPE TABLE OF /ptloms/tb002.
  SELECT *
      FROM /ptloms/tb002
      INTO TABLE lt_tb002
      WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
*  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
*  ENDIF.

  DATA lt_t001w TYPE TABLE OF t001w.
  IF lt_tb002[] IS NOT INITIAL.
    SELECT werks name1
      FROM t001w
      INTO TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  SELECT werks beber fing
    FROM t357
    INTO CORRESPONDING FIELDS OF TABLE lt_area_operacional.

*  CREATE OBJECT o_oms.
*
*  o_oms->out_demais_dados_mestres(
*    EXPORTING
*      im_empresa_centro          = ''
*      im_grupo_planejamento      = ''
*      im_area_operacional        = 'X'
*      im_centro_trabalho         = ''
*      im_tipo_nota               = ''
*      im_tipo_ordem              = ''
*      im_tipo_prioridade_ordem   = ''
*      im_tipo_prioridade_nota    = ''
*      im_tipo_atv_manutencao     = ''
*      im_centro_custo            = ''
*      im_condicao_inst_ordem     = ''
*      im_tipo_atv_operacao       = ''
*      im_tipo_material           = ''
*      im_categoria_item_material = ''
*      im_deposito                = ''
*      im_categoria_equipamento   = ''
*      im_tipo_objeto             = ''
*      im_categoria_loc_inst      = ''
*    IMPORTING
*      et_area_operacional        = lt_area_operacional ).

*  SELECT werks, beber, fing
*    FROM t357
*    INTO CORRESPONDING FIELDS OF TABLE @lt_area_operacional.

*  LOOP AT lt_area_operacional INTO DATA(ls_area_operacional).
*    READ TABLE lt_tb002 INTO DATA(ls_002)
*    WITH KEY werks = ls_area_operacional-werks.
  DATA: ls_area_operacional LIKE LINE OF lt_area_operacional,
        ls_002              LIKE LINE OF lt_tb002.
  LOOP AT lt_area_operacional INTO ls_area_operacional.
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_area_operacional-werks.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_area_operacional TO ls_tab.

    DATA ls_t001w LIKE LINE OF lt_t001w.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    DATA ls_return LIKE LINE OF lt_return.
    " --- Recupera o registro selecionado pelo usuário
    READ TABLE lt_return INTO ls_return INDEX 1.
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

    IF sy-subrc = 0.
      CLEAR lv_tabix.

      " --- Atribui valor ao campo da tela
      REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
      MOVE ls_return-fieldval TO lv_tabix.

      READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

      DATA lv_nome_campo TYPE dynfnam.
      /ptloms/v003-werks = ls_tab-werks.
      lv_nome_campo = '/PTLOMS/V003-WERKS(' && lv_tc_actual_line && ')'.
*      DATA(lv_nome_campo) = '/PTLOMS/V003-WERKS(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v003-werks.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v003-name1 = ls_tab-name1.
      lv_nome_campo = '/PTLOMS/V003-NAME1(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v003-name1.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v003-beber = ls_tab-beber.
      lv_nome_campo = '/PTLOMS/V003-BEBER(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v003-beber.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v003-fing = ls_tab-fing.
      lv_nome_campo = '/PTLOMS/V003-FING(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v003-fing.
      APPEND ls_dynpfields TO lt_dynpfields.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_V004
*&---------------------------------------------------------------------*
FORM f_help_v004 .

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           objid TYPE crhd-objid,
           arbpl TYPE crhd-arbpl,
           werks TYPE crhd-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab             TYPE STANDARD TABLE OF ty_tab,
        lt_return          TYPE STANDARD TABLE OF ddshretval,
        lt_centro_trabalho TYPE /ptloms/ct009,
        lt_dynpfields      TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_tabix          TYPE sy-tabix,
        lv_tc_actual_line TYPE i.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

* Busca todos os Empresas/Centro cadastrados
*  SELECT *
*    FROM /ptloms/tb002
*    INTO TABLE @DATA(lt_tb002)
*    WHERE bukrs IN @r_bukrs.
  DATA lt_tb002 TYPE TABLE OF /ptloms/tb002.
  SELECT *
 FROM /ptloms/tb002
 INTO TABLE lt_tb002
 WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
*  IF lt_tb002[] IS NOT INITIAL.
*    SELECT werks, name1
*      FROM t001w
*      INTO TABLE @DATA(lt_t001w)
*      FOR ALL ENTRIES IN @lt_tb002
*      WHERE werks = @lt_tb002-werks.
*  ENDIF.
  DATA lt_t001w TYPE TABLE OF t001w.
  IF lt_tb002[] IS NOT INITIAL.
    SELECT werks name1
      FROM t001w
      INTO TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = 'X'
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_centro_trabalho         = lt_centro_trabalho ).

*  SELECT objid, werks, arbpl
*    FROM crhd
*    INTO CORRESPONDING FIELDS OF TABLE @lt_centro_trabalho.

*  LOOP AT lt_centro_trabalho INTO DATA(ls_centro_trabalho).
*    READ TABLE lt_tb002 INTO DATA(ls_002)
  DATA: ls_centro_trabalho LIKE LINE OF lt_centro_trabalho,
        ls_002             LIKE LINE OF lt_tb002.
  LOOP AT lt_centro_trabalho INTO ls_centro_trabalho.
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_centro_trabalho-werks.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_centro_trabalho TO ls_tab.

    DATA ls_t001w LIKE LINE OF lt_t001w.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
*    READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  DATA ls_return LIKE LINE OF lt_return.
  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
    READ TABLE lt_return INTO ls_return INDEX 1.
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

    IF sy-subrc = 0.
      CLEAR lv_tabix.

      " --- Atribui valor ao campo da tela
      REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
      MOVE ls_return-fieldval TO lv_tabix.

      READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

      DATA lv_nome_campo TYPE dynfnam.
      /ptloms/v004-objid = ls_tab-objid.
      lv_nome_campo = '/PTLOMS/V004-OBJID(' && lv_tc_actual_line && ')'.
*      DATA(lv_nome_campo) = '/PTLOMS/V004-OBJID(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v004-objid.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v004-arbpl = ls_tab-arbpl.
      lv_nome_campo = '/PTLOMS/V004-ARBPL(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v004-arbpl.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v004-werks = ls_tab-werks.
      lv_nome_campo = '/PTLOMS/V004-WERKS(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v004-werks.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v004-name1 = ls_tab-name1.
      lv_nome_campo = '/PTLOMS/V004-NAME1(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v004-name1.
      APPEND ls_dynpfields TO lt_dynpfields.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_HELP_V004_2
*&---------------------------------------------------------------------*
FORM f_help_v004_2 .

  DATA: ls_rcr01 TYPE rcr01.

  DATA: lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: lv_tc_actual_line TYPE i,
        lv_tc_actual_c    TYPE c LENGTH 10,
        lv_arbpl          TYPE /ptloms/v004-arbpl,
        lv_werks          TYPE /ptloms/v004-werks.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  DATA lv_nome_campo TYPE dynfnam.
  CLEAR ls_dynpfields.

  MOVE lv_tc_actual_line TO lv_tc_actual_c.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = lv_tc_actual_c
    IMPORTING
      output = lv_tc_actual_c.

  lv_nome_campo = '/PTLOMS/V004-ARBPL(' && lv_tc_actual_c && ')'.
*  DATA(lv_nome_campo) = '/PTLOMS/V004-ARBPL(' && lv_tc_actual_line && ')'.
  ls_dynpfields-fieldname = lv_nome_campo.
  APPEND ls_dynpfields TO lt_dynpfields.

  CLEAR ls_dynpfields.
  lv_nome_campo = '/PTLOMS/V004-WERKS(' && lv_tc_actual_c && ')'.
  ls_dynpfields-fieldname = lv_nome_campo.
  APPEND ls_dynpfields TO lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 01
      invalid_dynprofield  = 02
      invalid_dynproname   = 03
      invalid_dynpronummer = 04
      invalid_request      = 05
      no_fielddescription  = 06
      undefind_error       = 07.

  CLEAR ls_dynpfields.
  DATA lv_fieldname TYPE dynfnam.
  CLEAR lv_fieldname.
  CONCATENATE '/PTLOMS/V004-ARBPL('   lv_tc_actual_c   ')' INTO lv_fieldname.
*  READ TABLE lt_dynpfields INTO ls_dynpfields WITH KEY fieldname = '/PTLOMS/V004-ARBPL(' && lv_tc_actual_line && ')'.
  READ TABLE lt_dynpfields INTO ls_dynpfields WITH KEY fieldname = lv_fieldname.
  IF sy-subrc EQ 0.
    lv_arbpl = ls_dynpfields-fieldvalue.
  ENDIF.

  CLEAR ls_dynpfields.
  CLEAR lv_fieldname.
  CONCATENATE '/PTLOMS/V004-WERKS('   lv_tc_actual_c   ')' INTO lv_fieldname.
  READ TABLE lt_dynpfields INTO ls_dynpfields WITH KEY fieldname = lv_fieldname.
*  READ TABLE lt_dynpfields INTO ls_dynpfields WITH KEY fieldname = '/PTLOMS/V004-WERKS(' && lv_tc_actual_line && ')'.
  IF sy-subrc EQ 0.
    lv_werks = ls_dynpfields-fieldvalue.
  ENDIF.

  IF lv_arbpl IS INITIAL OR lv_werks IS INITIAL.
    MESSAGE s000 WITH 'Preencher Centro/Centro de Trabalho'(067) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'CR_WORKSTATION_READ_ROUTING'
    EXPORTING
      arbpl            = lv_arbpl
      werks            = lv_werks
      plnty            = 'E'
*     date             = *afrud-budat
      vgwkz            = 'X'
    IMPORTING
      works            = ls_rcr01
    EXCEPTIONS
      not_found        = 1
      type_not_allowed = 2.

  CALL FUNCTION 'C_VALID_COSTCENTER_ACTIVITIES'
    EXPORTING
      kokrs = ls_rcr01-kokrs
      kostl = ls_rcr01-kostl
    IMPORTING
      lstar = /ptloms/v004-learr.


  REFRESH lt_dynpfields[].

  CLEAR ls_dynpfields.
  lv_nome_campo = '/PTLOMS/V004-LEARR(' && lv_tc_actual_c && ')'.
  ls_dynpfields-fieldname  = lv_nome_campo.
  ls_dynpfields-fieldvalue = /ptloms/v004-learr.
  APPEND ls_dynpfields TO lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      undefind_error       = 7
      OTHERS               = 8.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_GRUPO_MERCADORIA
*&---------------------------------------------------------------------*
FORM f_busca_grupo_mercadoria .

  REFRESH gt_grupo_mercadoria[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb028
      INTO CORRESPONDING FIELDS OF TABLE gt_grupo_mercadoria
      WHERE perfil = gv_perfil.

*    IF gt_grupo_mercadoria[] IS NOT INITIAL.
*      SELECT spras, matkl, wgbez60
*        FROM t023t
*        INTO TABLE @DATA(lt_023t)
*        FOR ALL ENTRIES IN @gt_grupo_mercadoria
*        WHERE spras = @sy-langu
*          AND matkl = @gt_grupo_mercadoria-matkl.
*    ENDIF.

    DATA lt_023t TYPE STANDARD TABLE OF t023t.
    IF gt_grupo_mercadoria[] IS NOT INITIAL.
      SELECT spras matkl wgbez
        FROM t023t
        INTO CORRESPONDING FIELDS OF TABLE lt_023t
        FOR ALL ENTRIES IN gt_grupo_mercadoria
        WHERE spras = sy-langu
          AND matkl = gt_grupo_mercadoria-matkl.
    ENDIF.

    DATA ls_023t LIKE LINE OF lt_023t.
    FIELD-SYMBOLS: <fs_grupo_mercadoria> LIKE LINE OF gt_grupo_mercadoria.
    LOOP AT gt_grupo_mercadoria ASSIGNING <fs_grupo_mercadoria>.
*    LOOP AT gt_grupo_mercadoria ASSIGNING FIELD-SYMBOL(<fs_grupo_mercadoria>).
      READ TABLE lt_023t INTO ls_023t WITH KEY matkl = <fs_grupo_mercadoria>-matkl.
*      READ TABLE lt_023t INTO DATA(ls_023t) WITH KEY matkl = <fs_grupo_mercadoria>-matkl.

      IF sy-subrc EQ 0.
        <fs_grupo_mercadoria>-wgbez = ls_023t-wgbez.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DEPOSITO
*&---------------------------------------------------------------------*
FORM f_busca_deposito .

  REFRESH gt_deposito[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb030
      INTO CORRESPONDING FIELDS OF TABLE gt_deposito
      WHERE perfil = gv_perfil.

*    IF gt_deposito[] IS NOT INITIAL.
*      SELECT werks, lgort, lgobe
*        FROM t001l
*        INTO TABLE @DATA(lt_t001l)
*        FOR ALL ENTRIES IN @gt_deposito
*        WHERE werks = @gt_deposito-werks
*          AND lgort = @gt_deposito-lgort.
*
*      SELECT werks, name1
*        FROM t001w
*        INTO TABLE @DATA(lt_t001w)
*        FOR ALL ENTRIES IN @gt_deposito
*        WHERE werks = @gt_deposito-werks.
*    ENDIF.
    DATA: lt_t001l TYPE STANDARD TABLE OF t001l,
          lt_t001w TYPE STANDARD TABLE OF t001w,
          ls_t001w LIKE LINE OF lt_t001w.
    IF gt_deposito[] IS NOT INITIAL.
      SELECT werks lgort lgobe
        FROM t001l
        INTO CORRESPONDING FIELDS OF TABLE lt_t001l
        FOR ALL ENTRIES IN gt_deposito
        WHERE werks = gt_deposito-werks
          AND lgort = gt_deposito-lgort.

      SELECT werks name1
        FROM t001w
        INTO CORRESPONDING FIELDS OF TABLE lt_t001w
        FOR ALL ENTRIES IN gt_deposito
        WHERE werks = gt_deposito-werks.
    ENDIF.
    DATA ls_t001l LIKE LINE OF lt_t001l.
    FIELD-SYMBOLS: <fs_deposito> LIKE LINE OF gt_deposito.
    LOOP AT gt_deposito ASSIGNING <fs_deposito>.
*    LOOP AT gt_deposito ASSIGNING FIELD-SYMBOL(<fs_deposito>).
*      READ TABLE lt_t001l INTO DATA(ls_t001l) WITH KEY werks = <fs_deposito>-werks
      READ TABLE lt_t001l INTO ls_t001l WITH KEY werks = <fs_deposito>-werks
                                                       lgort = <fs_deposito>-lgort.
*                                                       lgort = <fs_deposito>-lgort.

      IF sy-subrc EQ 0.
        <fs_deposito>-lgobe = ls_t001l-lgobe.
      ENDIF.

      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = <fs_deposito>-werks.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = <fs_deposito>-werks.
      IF sy-subrc EQ 0.
        <fs_deposito>-name1 = ls_t001w-name1.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_CAUSA_DESVIO
*&---------------------------------------------------------------------*
FORM f_busca_causa_desvio .

  REFRESH gt_causa_desvio[].

  IF gv_perfil IS NOT INITIAL.
    SELECT *
      FROM /ptloms/tb039
      INTO CORRESPONDING FIELDS OF TABLE gt_causa_desvio
      WHERE perfil = gv_perfil.

    IF gt_causa_desvio[] IS NOT INITIAL.
*      SELECT werks, GRUND
*        FROM trug
*        INTO TABLE @DATA(lt_trug)
*        FOR ALL ENTRIES IN @gt_causa_desvio
*        WHERE werks = @gt_causa_desvio-werks
*          AND GRUND = @gt_causa_desvio-GRUND.
      DATA lt_trugt TYPE STANDARD TABLE OF trugt.
      SELECT werks grund grdtx
        FROM trugt
        INTO CORRESPONDING FIELDS OF TABLE lt_trugt
        FOR ALL ENTRIES IN gt_causa_desvio
        WHERE spras = sy-langu
          AND werks = gt_causa_desvio-werks
          AND grund = gt_causa_desvio-grund.

*      SELECT werks, name1
*        FROM t001w
*        INTO TABLE @DATA(lt_t001w)
*        FOR ALL ENTRIES IN @gt_causa_desvio
*        WHERE werks = @gt_causa_desvio-werks.
      DATA lt_t001w TYPE STANDARD TABLE OF t001w.
      SELECT werks name1
              FROM t001w
              INTO CORRESPONDING FIELDS OF TABLE lt_t001w
              FOR ALL ENTRIES IN gt_causa_desvio
              WHERE werks = gt_causa_desvio-werks.

    ENDIF.
    DATA ls_trugt LIKE LINE OF lt_trugt.
    FIELD-SYMBOLS: <fs_causa_desvio> LIKE LINE OF gt_causa_desvio.
    LOOP AT gt_causa_desvio ASSIGNING <fs_causa_desvio>.
*    LOOP AT gt_causa_desvio ASSIGNING FIELD-SYMBOL(<fs_causa_desvio>).
*      READ TABLE lt_trugt INTO DATA(ls_trugt) WITH KEY werks = <fs_causa_desvio>-werks
      READ TABLE lt_trugt INTO ls_trugt WITH KEY werks = <fs_causa_desvio>-werks
                                                       grund = <fs_causa_desvio>-grund.
*                                                       grund = <fs_causa_desvio>-grund.

      IF sy-subrc EQ 0.
        <fs_causa_desvio>-grdtx = ls_trugt-grdtx.
      ENDIF.

      DATA ls_t001w LIKE LINE OF lt_t001w.
      READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = <fs_causa_desvio>-werks.
*      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = <fs_causa_desvio>-werks.
      IF sy-subrc EQ 0.
        <fs_causa_desvio>-name1 = ls_t001w-name1.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_AUTORIZACAO
*&---------------------------------------------------------------------*
FORM f_busca_autorizacao .

  DATA: lt_values_tab TYPE STANDARD TABLE OF dd07v.

  DATA: lv_val_dominio TYPE val_single.

  REFRESH gt_autorizacao[].

  IF gv_perfil IS NOT INITIAL.

* Busca descrições do Status Mobile
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM011'
        text            = 'X'
      TABLES
        values_tab      = lt_values_tab
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

    SELECT *
      FROM /ptloms/tb043
      INTO CORRESPONDING FIELDS OF TABLE gt_autorizacao
      WHERE perfil = gv_perfil.

    DATA ls_values_tab LIKE LINE OF lt_values_tab.
    FIELD-SYMBOLS: <fs_autorizacao> LIKE LINE OF gt_autorizacao.
    LOOP AT gt_autorizacao ASSIGNING <fs_autorizacao>.
*    LOOP AT gt_autorizacao ASSIGNING FIELD-SYMBOL(<fs_autorizacao>).
      CLEAR lv_val_dominio.
      lv_val_dominio = <fs_autorizacao>-autorizacao.
      CONDENSE lv_val_dominio NO-GAPS.
      READ TABLE lt_values_tab INTO ls_values_tab WITH KEY domvalue_l = lv_val_dominio.
*      READ TABLE lt_values_tab INTO DATA(ls_values_tab) WITH KEY domvalue_l = lv_val_dominio.
      IF sy-subrc EQ 0.
        <fs_autorizacao>-desc_autorizacao = ls_values_tab-ddtext.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_LISTA_TAREFA
*&---------------------------------------------------------------------*
FORM f_busca_lista_tarefa .

  REFRESH:
    gt_lista,
    gt_tb063.

  IF gv_perfil IS NOT INITIAL.

    SELECT *
      FROM /ptloms/tb063
      INTO CORRESPONDING FIELDS OF TABLE gt_tb063
      WHERE perfil = gv_perfil.

    LOOP AT gt_tb063 INTO wa_tb063.

      APPEND INITIAL LINE TO gt_lista ASSIGNING <fs_lista_tarefa>.
      <fs_lista_tarefa>-plnty             = wa_tb063-plnty.
      <fs_lista_tarefa>-txt               = wa_tb063-txt.
      <fs_lista_tarefa>-plnnr             = wa_tb063-plnnr.
      <fs_lista_tarefa>-plnal             = wa_tb063-plnal.
      <fs_lista_tarefa>-ktext             = wa_tb063-ktext.
      <fs_lista_tarefa>-zaehl             = wa_tb063-zaehl.
      <fs_lista_tarefa>-werks             = wa_tb063-werks.
      <fs_lista_tarefa>-equnr             = wa_tb063-equnr.
      <fs_lista_tarefa>-eqktx             = wa_tb063-eqktx.
      <fs_lista_tarefa>-tplnr             = wa_tb063-tplnr.
      <fs_lista_tarefa>-pltxt             = wa_tb063-pltxt.

    ENDLOOP.

  ENDIF.

  SORT gt_lista     BY  plnty plnnr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_CONFIGURACAO
*&---------------------------------------------------------------------*
FORM f_busca_configuracao .

  DATA: lt_values_tab TYPE STANDARD TABLE OF dd07v.

  DATA: lv_val_dominio TYPE val_single.

  REFRESH gt_autorizacao[].

  IF gv_perfil IS NOT INITIAL.

* Busca descrições do Status Mobile
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM012'
        text            = 'X'
      TABLES
        values_tab      = lt_values_tab
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

    SELECT *
      FROM /ptloms/tb044
      INTO CORRESPONDING FIELDS OF TABLE gt_configuracao
      WHERE perfil = gv_perfil.

    DATA ls_values_tab LIKE LINE OF lt_values_tab.
    FIELD-SYMBOLS: <fs_configuracao> LIKE LINE OF gt_configuracao.
    LOOP AT gt_configuracao ASSIGNING <fs_configuracao>.
*    LOOP AT gt_configuracao ASSIGNING FIELD-SYMBOL(<fs_configuracao>).
      CLEAR lv_val_dominio.
      lv_val_dominio = <fs_configuracao>-configuracao.
      CONDENSE lv_val_dominio NO-GAPS.
      READ TABLE lt_values_tab INTO ls_values_tab WITH KEY domvalue_l = lv_val_dominio.
*      READ TABLE lt_values_tab INTO DATA(ls_values_tab) WITH KEY domvalue_l = lv_val_dominio.
      IF sy-subrc EQ 0.
        <fs_configuracao>-desc_configuracao = ls_values_tab-ddtext.
      ENDIF.
    ENDLOOP.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_V015
*&---------------------------------------------------------------------*
FORM f_help_v015 .

  TYPES: BEGIN OF ty_tab,
           tabix  TYPE sy-tabix,
           auart  TYPE aufart,
           artpr  TYPE artpr,
           priok  TYPE priok,
           priokx TYPE priokx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_prio_ordem TYPE /ptloms/ct012,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_tabix          TYPE sy-tabix,
        lv_tc_actual_line TYPE i.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = ''
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = 'X'
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_tipo_prioridade_ordem   = lt_prio_ordem ).

  DATA ls_prio_ordem LIKE LINE OF lt_prio_ordem.
  LOOP AT lt_prio_ordem INTO ls_prio_ordem.
*  LOOP AT lt_prio_ordem INTO DATA(ls_prio_ordem).

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_prio_ordem TO ls_tab.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

    IF sy-subrc = 0.
      CLEAR lv_tabix.

      " --- Atribui valor ao campo da tela
      REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
      MOVE ls_return-fieldval TO lv_tabix.

      READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

      DATA lv_nome_campo TYPE dynfnam.
      /ptloms/v015-auart = ls_tab-auart.
      lv_nome_campo = '/PTLOMS/V015-AUART(' && lv_tc_actual_line && ')'.
*      DATA(lv_nome_campo) = '/PTLOMS/V015-AUART(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v015-auart.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v015-artpr = ls_tab-artpr.
      lv_nome_campo = '/PTLOMS/V015-ARTPR(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v015-artpr.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v015-priok = ls_tab-priok.
      lv_nome_campo = '/PTLOMS/V015-PRIOK(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v015-priok.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v015-priokx = ls_tab-priokx.
      lv_nome_campo = '/PTLOMS/V015-PRIOKX(' && lv_tc_actual_line && ')'.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v015-priokx.
      APPEND ls_dynpfields TO lt_dynpfields.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_015
*&---------------------------------------------------------------------*
FORM validar_dados_v015.

  DATA: lwa_row TYPE /ptloms/v015.
  DATA: lv_msg(100) TYPE c.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.
*      ENDIF.

      IF lwa_row-amarelo <= lwa_row-verde.
        vim_abort_saving = 'X'.
***     DATA(lv_msg) = |Verde deve ser menor que Amarelo |.
        lv_msg = 'Verde deve ser menor que Amarelo'(107).
        MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      IF lwa_row-vermelho <= lwa_row-amarelo.
        vim_abort_saving = 'X'.
***     lv_msg = |Amarelo deve ser menor que Vermelho |.
        lv_msg = 'Amarelo deve ser menor que Vermelho'(108).
        MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_CAUSA_DESVIO
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_causa_desvio TABLES pt_return STRUCTURE ddshretval
                                          pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
           grund TYPE trug-grund,
           grdtx TYPE trugt-grdtx,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb039 TYPE STANDARD TABLE OF /ptloms/tb039.

  DATA: ls_tb039        TYPE /ptloms/tb039,
        ls_causa_desvio LIKE LINE OF gt_causa_desvio.

  DATA: lv_answer TYPE c,
        lv_tabix  TYPE sy-tabix.

  DATA: lv_msg(100)  TYPE c,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros ?'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Causa Desvio Cadastrada
*  SELECT *
*    FROM /ptloms/tb039
*    INTO TABLE @DATA(lt_039)
*    WHERE perfil = @gv_perfil.
  DATA lt_039 TYPE TABLE OF /ptloms/tb039.
  SELECT *
      FROM /ptloms/tb039
      INTO TABLE lt_039
      WHERE perfil = gv_perfil.

  DATA ls_return LIKE LINE OF pt_return.
  " --- Loop nos registro selecionado pelo usuário
  LOOP AT pt_return INTO ls_return.
*  LOOP AT pt_return INTO DATA(ls_return).

    DATA ls_tab LIKE LINE OF lt_tab.
    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    IF sy-subrc EQ 0.
*      READ TABLE lt_039 INTO DATA(ls_039) WITH KEY werks = ls_tab-werks
*                                                   grund = ls_tab-grund.
      DATA ls_039 LIKE LINE OF lt_039.
      READ TABLE lt_039 INTO ls_039 WITH KEY werks = ls_tab-werks
                                                   grund = ls_tab-grund.
      IF sy-subrc EQ 0.
***     DATA(lv_msg)  = |Registro já existente.|.
        lv_msg = 'Registro já existente.'(110).

***        DATA(lv_msg2) = |Centro: |        &&
***                        ls_tab-werks      &&
***                        | Causa Desvio: | &&
***                        ls_tab-grund.
        CONCATENATE 'Centro'(003) ls_tab-werks 'Causa Desvio:'(109) ls_tab-grund INTO lv_msg2 SEPARATED BY space.

        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      IF /ptloms/cl006=>verifica_centro_perfil( EXPORTING im_perfil = gv_perfil
*                                                          im_werks  = ls_tab-werks ) NE 0.
      DATA sy_subrc TYPE sy-subrc.

      /ptloms/cl006=>verifica_centro_perfil( EXPORTING im_perfil = gv_perfil
                                                       im_werks  = ls_tab-werks
                                             IMPORTING ex_subrc = sy_subrc ).

      IF sy_subrc NE 0.
        MESSAGE s003(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                       im_werks = ls_tab-werks ) IS INITIAL.
      DATA  possui_permissao TYPE char1.

      /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
                                                             im_werks = ls_tab-werks
                                                IMPORTING ex_possui_permissao = possui_permissao ).

      IF possui_permissao IS INITIAL.
        MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb039.
*      ls_tb039-perfil = gv_perfil.
*      ls_tb039-werks  = ls_tab-werks.
*      ls_tb039-grund  = ls_tab-grund.
*      APPEND ls_tb039 TO lt_tb039.
*
*      CLEAR ls_causa_desvio.
*      MOVE-CORRESPONDING ls_tab TO ls_causa_desvio.
*      APPEND ls_causa_desvio TO gt_causa_desvio.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      CLEAR ls_tb039.
      ls_tb039-perfil = gv_perfil.
      ls_tb039-werks  = ls_tab-werks.
      ls_tb039-grund  = ls_tab-grund.
      APPEND ls_tb039 TO lt_tb039.

      CLEAR ls_causa_desvio.
      MOVE-CORRESPONDING ls_tab TO ls_causa_desvio.
      APPEND ls_causa_desvio TO gt_causa_desvio.
    ENDIF.
  ENDLOOP.

  SORT gt_causa_desvio BY werks ASCENDING grund ASCENDING.

* Grava Causa Desvio
  IF lt_tb039[] IS NOT INITIAL.
    MODIFY /ptloms/tb039 FROM TABLE lt_tb039.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_AUTORIZACAO
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_autorizacao TABLES pt_return STRUCTURE ddshretval
                                         pt_tab.

  TYPES: BEGIN OF ty_tab,
           autorizacao      TYPE /ptloms/tb043-autorizacao,
           desc_autorizacao TYPE val_text,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb043 TYPE STANDARD TABLE OF /ptloms/tb043.

  DATA: ls_tb043       TYPE /ptloms/tb043,
        ls_autorizacao LIKE LINE OF gt_autorizacao.

  DATA: lv_answer  TYPE c,
        lv_autoriz TYPE /ptloms/tb043-autorizacao.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Autorizações Cadastrada
*  SELECT *
*    FROM /ptloms/tb043
*    INTO TABLE @DATA(lt_043)
*    WHERE perfil = @gv_perfil.

  DATA lt_043 TYPE TABLE OF /ptloms/tb043.
  SELECT *
      FROM /ptloms/tb043
      INTO TABLE lt_043
      WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário

  DATA ls_return LIKE LINE OF pt_return.
  DATA es_return LIKE LINE OF pt_return.
  DATA ls_tab LIKE LINE OF lt_tab.
  DATA ls_043 LIKE LINE OF lt_043.

  LOOP AT pt_return INTO ls_return.
*  LOOP AT pt_return INTO DATA(ls_return).

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_autoriz.

    READ TABLE lt_tab INTO ls_tab WITH KEY autorizacao = lv_autoriz.
*    READ TABLE lt_tab INTO DATA(ls_tab) WITH KEY autorizacao = lv_autoriz.
    IF sy-subrc EQ 0.
      READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = ls_tab-autorizacao.
*      READ TABLE lt_043 INTO DATA(ls_043) WITH KEY autorizacao = ls_tab-autorizacao.
      IF sy-subrc EQ 0.
*        DATA(lv_msg)  = |Registro existente.|.
*        DATA(lv_msg2) = |Autoriz.: | &&
*                        ls_tab-desc_autorizacao.
        DATA lv_msg TYPE char20.
        DATA lv_msg2 TYPE char80.
        lv_msg  = 'Registro existente.'.
        lv_msg2 = 'Autoriz.: ' &&
                        ls_tab-desc_autorizacao.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.

      ELSE. "Caso não encontre - Verificar se existe autorização para os casos abaixo:
        " 11 só se existir 10
        " 13 só se existir 07
        " 15 só se existir 09

        CASE lv_autoriz.
          WHEN '11'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '10'.

            IF sy-subrc NE 0.

              READ TABLE pt_return INTO es_return WITH KEY fieldval = '10'.

              IF sy-subrc NE 0.

                CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                  EXPORTING
                    titel     = 'Mensagem: '
                    textline1 = text-142.
                RETURN.

              ENDIF.

            ENDIF.

          WHEN '13'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '07'.

            IF sy-subrc NE 0.

              READ TABLE pt_return INTO es_return WITH KEY fieldval = '07'.

              IF sy-subrc NE 0.

                CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                  EXPORTING
                    titel     = 'Mensagem: '
                    textline1 = text-143.
                RETURN.

              ENDIF.

            ENDIF.

          WHEN '15'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '09'.

            IF sy-subrc NE 0.

              READ TABLE pt_return INTO es_return  WITH KEY fieldval = '09'.

              IF sy-subrc NE 0.

                CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                  EXPORTING
                    titel     = 'Mensagem: '
                    textline1 = text-144.

                RETURN.

              ENDIF.

            ENDIF.

        ENDCASE.

      ENDIF.

    ENDIF.

  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_autoriz.
    READ TABLE lt_tab INTO ls_tab WITH KEY autorizacao = lv_autoriz.
    IF sy-subrc EQ 0.
      CLEAR ls_tb043.
      ls_tb043-perfil      = gv_perfil.
      ls_tb043-autorizacao = ls_tab-autorizacao.
      APPEND ls_tb043 TO lt_tb043.

      CLEAR ls_autorizacao.
      MOVE-CORRESPONDING ls_tab TO ls_autorizacao.
      APPEND ls_autorizacao TO gt_autorizacao.
    ENDIF.
  ENDLOOP.

  SORT gt_autorizacao BY autorizacao ASCENDING.

* Grava Autorização
  IF lt_tb043[] IS NOT INITIAL.
    MODIFY /ptloms/tb043 FROM TABLE lt_tb043.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_CONFIGURACAO
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_configuracao TABLES pt_return STRUCTURE ddshretval
                                          pt_tab.

  TYPES: BEGIN OF ty_tab,
           configuracao      TYPE /ptloms/tb044-configuracao,
           desc_configuracao TYPE val_text,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb044 TYPE STANDARD TABLE OF /ptloms/tb044.

  DATA: ls_tb044        TYPE /ptloms/tb044,
        ls_configuracao LIKE LINE OF gt_configuracao.

  DATA: lv_answer TYPE c,
        lv_config TYPE /ptloms/tb044-configuracao.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Configurações Cadastrada
*  SELECT *
*    FROM /ptloms/tb044
*    INTO TABLE @DATA(lt_044)
*    WHERE perfil = @gv_perfil

  DATA lt_044 TYPE TABLE OF /ptloms/tb044.

  SELECT *
                   FROM /ptloms/tb044
             INTO TABLE lt_044
    WHERE perfil     EQ gv_perfil.

  DATA: lt_043 TYPE TABLE OF /ptloms/tb043,
        ls_043 TYPE /ptloms/tb043.

  SELECT *
      FROM /ptloms/tb043
      INTO TABLE lt_043
      WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA ls_return LIKE LINE OF pt_return.
  DATA es_return LIKE LINE OF pt_return.

  LOOP AT pt_return INTO ls_return.
*  LOOP AT pt_return INTO DATA(ls_return).

    DATA ls_tab LIKE LINE OF lt_tab.
    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_config.

    READ TABLE lt_tab INTO ls_tab WITH KEY configuracao = lv_config.
*    READ TABLE lt_tab INTO DATA(ls_tab) WITH KEY configuracao = lv_config.
    IF sy-subrc EQ 0.
      DATA ls_044 LIKE LINE OF lt_044.
      READ TABLE lt_044 INTO ls_044 WITH KEY configuracao = ls_tab-configuracao.
*      READ TABLE lt_044 INTO DATA(ls_044) WITH KEY configuracao = ls_tab-configuracao.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE char20.
        DATA lv_msg2 TYPE char80.

*        DATA(lv_msg)  = |Registro existente.|.
*        DATA(lv_msg2) = |Config.: | &&
*                        ls_tab-desc_configuracao.

        lv_msg  = 'Registro existente.'.
        lv_msg2 = 'Config.: ' &&
                        ls_tab-desc_configuracao.

        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.

      ELSE. "Caso não encontre - Verificar se existe configuração para os casos abaixo:
        " 06 só se existir 03 / 04 / 08 / 14
        " 08 só se existir 03 / 04
        " 11 só se existir 03 / 04
        " 18 só se existir 03 / 04 / 08 / 14
        " 19 só se existir 04 / 05

        CASE lv_config.

          WHEN '05'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '03'.

            IF sy-subrc NE 0.

              READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '04'.

              IF sy-subrc NE 0.

                READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '08'.

                IF sy-subrc NE 0.

                  READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '14'.

                ENDIF.

              ENDIF.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-152.

              RETURN.

            ENDIF.

          WHEN '06'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '03'.

            IF sy-subrc NE 0.

              READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '04'.

              IF sy-subrc NE 0.

                READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '08'.

                IF sy-subrc NE 0.

                  READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '14'.

                ENDIF.

              ENDIF.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-145.

              RETURN.

            ENDIF.

          WHEN '18'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '03'.

            IF sy-subrc NE 0.

              READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '04'.

              IF sy-subrc NE 0.

                READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '08'.

                IF sy-subrc NE 0.

                  READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '14'.

                ENDIF.

              ENDIF.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-148.

              RETURN.

            ENDIF.

          WHEN '04'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '03'.

            IF sy-subrc NE 0.

              READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '04'.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-151.

              RETURN.

            ENDIF.

          WHEN '08'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '03'.

            IF sy-subrc NE 0.

              READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '04'.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-146.

              RETURN.

            ENDIF.

          WHEN  '11'.

            READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '03'.

            IF sy-subrc NE 0.

              READ TABLE lt_043 INTO ls_043 WITH KEY autorizacao = '04'.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-147.

              RETURN.

            ENDIF.

          WHEN  '12'.

            READ TABLE lt_044 INTO ls_044 WITH KEY configuracao = '13'.

            IF sy-subrc NE 0.

              READ TABLE pt_return INTO es_return  WITH KEY fieldval = '13'.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-153.

              RETURN.

            ENDIF.

          WHEN '19'.

            READ TABLE lt_044 INTO ls_044 WITH KEY configuracao = '04'.

            IF sy-subrc NE 0.

              READ TABLE lt_044 INTO ls_044 WITH KEY configuracao = '05'.

              IF sy-subrc NE 0.
                READ TABLE pt_return INTO es_return  WITH KEY fieldval = '04'.

                IF sy-subrc NE 0.

                  READ TABLE pt_return INTO es_return  WITH KEY fieldval = '05'.

                ENDIF.

              ENDIF.

            ENDIF.

            IF sy-subrc NE 0.

              CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
                EXPORTING
                  titel     = 'Mensagem: '
                  textline1 = text-149.

              RETURN.

            ENDIF.

        ENDCASE.
      ENDIF.

    ENDIF.

  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_config.
    READ TABLE lt_tab INTO ls_tab WITH KEY configuracao = lv_config.
    IF sy-subrc EQ 0.
      CLEAR ls_tb044.
      ls_tb044-perfil       = gv_perfil.
      ls_tb044-configuracao = ls_tab-configuracao.
      APPEND ls_tb044 TO lt_tb044.

      CLEAR ls_configuracao.
      MOVE-CORRESPONDING ls_tab TO ls_configuracao.
      APPEND ls_configuracao TO gt_configuracao.
    ENDIF.
  ENDLOOP.

  SORT gt_configuracao BY configuracao ASCENDING.

* Grava Configuração
  IF lt_tb044[] IS NOT INITIAL.
    MODIFY /ptloms/tb044 FROM TABLE lt_tb044.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_CONFIGURACAO
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_caract TABLES pt_return STRUCTURE ddshretval
                                    pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           atnam TYPE /ptloms/tb058-atnam,
           atbez TYPE cabnt-atbez,
         END OF ty_tab.

  DATA: lt_tab                TYPE STANDARD TABLE OF ty_tab,
        lt_tb059              TYPE STANDARD TABLE OF /ptloms/tb059,
        ls_tb059              TYPE /ptloms/tb059,
        ls_caract_equipamento LIKE LINE OF gt_caract_equipamento.

  DATA: lv_answer TYPE c,
        lv_tabix  TYPE sy-tabix.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Configurações Cadastrada
*  SELECT atnam
*    FROM /ptloms/tb059
*    INTO TABLE @DATA(lt_059)
*    WHERE perfil = @gv_perfil.
  DATA lt_059 TYPE TABLE OF /ptloms/tb059.
  SELECT atnam
      FROM /ptloms/tb059
      INTO TABLE lt_059
      WHERE perfil = gv_perfil.
  DATA ls_return LIKE LINE OF pt_return.
  " --- Loop nos registro selecionado pelo usuário
  LOOP AT pt_return INTO ls_return.
*  LOOP AT pt_return INTO DATA(ls_return).
    DATA ls_tab LIKE LINE OF lt_tab.
    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    IF sy-subrc EQ 0.
      DATA ls_059 LIKE LINE OF lt_059.
      READ TABLE lt_059 INTO ls_059 WITH KEY atnam = ls_tab-atnam.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE char20.
        DATA lv_msg2 TYPE char80.
*

        lv_msg  = 'Registro existente.'.
        lv_msg2 = 'Config.: ' &&
                        ls_tab-atbez.
*        DATA(lv_msg)  = |Registro existente.|.
*        DATA(lv_msg2) = |Config.: | &&
*                        ls_tab-atbez.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      CLEAR ls_tb059.
      ls_tb059-perfil = gv_perfil.
      ls_tb059-atnam  = ls_tab-atnam.
      APPEND ls_tb059 TO lt_tb059.

      CLEAR ls_caract_equipamento.
      MOVE-CORRESPONDING ls_tab TO ls_caract_equipamento.
      APPEND ls_caract_equipamento TO gt_caract_equipamento.
    ENDIF.
  ENDLOOP.

  SORT gt_caract_equipamento BY atnam ASCENDING.

* Grava Configuração
  IF lt_tb059[] IS NOT INITIAL.
    MODIFY /ptloms/tb059 FROM TABLE lt_tb059.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_LGORT
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_lgort TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
           lgort TYPE t001l-lgort,
           lgobe TYPE t001l-lgobe,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb030 TYPE STANDARD TABLE OF /ptloms/tb030.

  DATA: ls_tb030    TYPE /ptloms/tb030,
        ls_deposito LIKE LINE OF gt_deposito.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Deposito Cadastrada
*  SELECT *
*    FROM /ptloms/tb030
*    INTO TABLE @DATA(lt_030)
*    WHERE perfil = @gv_perfil.

  DATA lt_030 TYPE TABLE OF /ptloms/tb030.
  SELECT *
      FROM /ptloms/tb030
      INTO TABLE lt_030
      WHERE perfil = gv_perfil.

  DATA ls_return LIKE LINE OF pt_return.
  " --- Loop nos registro selecionado pelo usuário
  LOOP AT pt_return INTO ls_return.
*  LOOP AT pt_return INTO DATA(ls_return).
    DATA ls_tab LIKE LINE OF lt_tab.
    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    IF sy-subrc EQ 0.
*      READ TABLE lt_030 INTO DATA(ls_030) WITH KEY werks = ls_tab-werks
*                                                   lgort = ls_tab-lgort.
      DATA ls_030 LIKE LINE OF lt_030.
      READ TABLE lt_030 INTO ls_030 WITH KEY werks = ls_tab-werks
                                                   lgort = ls_tab-lgort.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE char30.
        lv_msg  = 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
***        DATA(lv_msg2) = |Centro: |        &&
***                        ls_tab-werks      &&
***                        | Depósito: | &&
***                        ls_tab-lgort.
        CONCATENATE 'Centro:'(111) ls_tab-werks 'Depósito:'(112) ls_tab-lgort INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      DATA sy_subrc TYPE sy-subrc.

      /ptloms/cl006=>verifica_centro_perfil( EXPORTING im_perfil = gv_perfil
                                                       im_werks  = ls_tab-werks
                                             IMPORTING ex_subrc = sy_subrc ).

*      IF /ptloms/cl006=>verifica_centro_perfil( EXPORTING im_perfil = gv_perfil
*                                                          im_werks  = ls_tab-werks ) NE 0.

      IF sy_subrc NE 0.
        MESSAGE s003(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
*      IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                             im_werks = ls_tab-werks ) IS INITIAL.

      DATA  possui_permissao TYPE char1.

      /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
                                                             im_werks = ls_tab-werks
                                                IMPORTING ex_possui_permissao = possui_permissao ).
      IF possui_permissao IS INITIAL.
        MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb030.
*      ls_tb030-perfil = gv_perfil.
*      ls_tb030-werks  = ls_tab-werks.
*      ls_tb030-lgort  = ls_tab-lgort.
*      APPEND ls_tb030 TO lt_tb030.
*
*      CLEAR ls_deposito.
*      MOVE-CORRESPONDING ls_tab TO ls_deposito.
*      APPEND ls_deposito TO gt_deposito.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      CLEAR ls_tb030.
      ls_tb030-perfil = gv_perfil.
      ls_tb030-werks  = ls_tab-werks.
      ls_tb030-lgort  = ls_tab-lgort.
      APPEND ls_tb030 TO lt_tb030.

      CLEAR ls_deposito.
      MOVE-CORRESPONDING ls_tab TO ls_deposito.
      APPEND ls_deposito TO gt_deposito.
    ENDIF.
  ENDLOOP.

  SORT gt_deposito BY werks ASCENDING lgort ASCENDING.

* Grava Deposito
  IF lt_tb030[] IS NOT INITIAL.
    MODIFY /ptloms/tb030 FROM TABLE lt_tb030.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_MATKL
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_matkl TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           matkl TYPE t023t-matkl,
           wgbez TYPE t023t-wgbez,
         END OF ty_tab.


  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb028 TYPE STANDARD TABLE OF /ptloms/tb028.

  DATA: ls_tb028            TYPE /ptloms/tb028,
        ls_grupo_mercadoria LIKE LINE OF gt_grupo_mercadoria.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Grupo de Mercadoria Cadastrada
*  SELECT *
*    FROM /ptloms/tb028
*    INTO TABLE @DATA(lt_028)
*    WHERE perfil = @gv_perfil.
  DATA lt_028 TYPE TABLE OF /ptloms/tb028.

  SELECT *
FROM /ptloms/tb028
INTO TABLE lt_028
WHERE perfil = gv_perfil.


  DATA ls_return LIKE LINE OF pt_return.
  " --- Loop nos registro selecionado pelo usuário
  LOOP AT pt_return INTO ls_return.
*    LOOP AT pt_return INTO DATA(ls_return).

*    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY matkl = ls_return-fieldval.
*    READ TABLE lt_tab INTO DATA(ls_tab) WITH KEY matkl = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA ls_028 LIKE LINE OF lt_028.
      READ TABLE lt_028 INTO ls_028 WITH KEY matkl = ls_tab-matkl.
*      READ TABLE lt_028 INTO DATA(ls_028) WITH KEY matkl = ls_tab-matkl.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE char30.
        lv_msg  = 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
***        DATA(lv_msg2) = |Grp.Merc.: | &&
***                        ls_tab-matkl.
        CONCATENATE 'Grp.Merc.:'(113) ls_tab-matkl INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb028.
*      ls_tb028-perfil = gv_perfil.
*      ls_tb028-matkl  = ls_tab-matkl.
*      APPEND ls_tb028 TO lt_tb028.
*
*      CLEAR ls_grupo_mercadoria.
*      MOVE-CORRESPONDING ls_tab TO ls_grupo_mercadoria.
*      APPEND ls_grupo_mercadoria TO gt_grupo_mercadoria.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY matkl = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb028.
      ls_tb028-perfil = gv_perfil.
      ls_tb028-matkl  = ls_tab-matkl.
      APPEND ls_tb028 TO lt_tb028.

      CLEAR ls_grupo_mercadoria.
      MOVE-CORRESPONDING ls_tab TO ls_grupo_mercadoria.
      APPEND ls_grupo_mercadoria TO gt_grupo_mercadoria.
    ENDIF.
  ENDLOOP.

  SORT gt_grupo_mercadoria BY matkl ASCENDING.

* Grava Grupo de Mercadoria
  IF lt_tb028[] IS NOT INITIAL.
    MODIFY /ptloms/tb028 FROM TABLE lt_tb028.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_ILART
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_ilart TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           ilart TYPE t353i-ilart,
           ilatx TYPE t353i_t-ilatx,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb025 TYPE STANDARD TABLE OF /ptloms/tb025.

  DATA: ls_tb025          TYPE /ptloms/tb025,
        ls_tipo_atv_ordem LIKE LINE OF gt_tipo_atv_ordem.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Tipo Atv. Ordem Cadastrada
  DATA: lt_025 TYPE TABLE OF /ptloms/tb025.
  SELECT *
    FROM /ptloms/tb025
    INTO CORRESPONDING FIELDS OF TABLE lt_025
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA: ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA: ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY ilart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA: ls_025 LIKE LINE OF lt_025.
      READ TABLE lt_025 INTO ls_025 WITH KEY ilart = ls_tab-ilart.
      IF sy-subrc EQ 0.
*        DATA(lv_msg)  = |Registro existente.|.
***      DATA(lv_msg2) = |Tipo Atv.Ordem: | &&
***                        ls_tab-ilart.
        DATA: lv_msg TYPE char20.

        lv_msg  = 'Registro existente.'.
        lv_msg2 = 'Tipo Atv.Ordem:' && ls_tab-ilart.

        CONCATENATE 'Tipo Atv.Ordem:'(114) ls_tab-ilart INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb025.
*      ls_tb025-perfil = gv_perfil.
*      ls_tb025-ilart  = ls_tab-ilart.
*      APPEND ls_tb025 TO lt_tb025.
*
*      CLEAR ls_tipo_atv_ordem.
*      MOVE-CORRESPONDING ls_tab TO ls_tipo_atv_ordem.
*      APPEND ls_tipo_atv_ordem TO gt_tipo_atv_ordem.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY ilart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb025.
      ls_tb025-perfil = gv_perfil.
      ls_tb025-ilart  = ls_tab-ilart.
      APPEND ls_tb025 TO lt_tb025.

      CLEAR ls_tipo_atv_ordem.
      MOVE-CORRESPONDING ls_tab TO ls_tipo_atv_ordem.
      APPEND ls_tipo_atv_ordem TO gt_tipo_atv_ordem.
    ENDIF.
  ENDLOOP.

  SORT gt_tipo_atv_ordem BY ilart ASCENDING.

* Grava Tipo Atv. Ordem
  IF lt_tb025[] IS NOT INITIAL.
    MODIFY /ptloms/tb025 FROM TABLE lt_tb025.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_MTART
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_mtart TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           mtart TYPE t134-mtart,
           mtbez TYPE t134t-mtbez,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb023 TYPE STANDARD TABLE OF /ptloms/tb023.

  DATA: ls_tb023         TYPE /ptloms/tb023,
        ls_tipo_material LIKE LINE OF gt_tipo_material.

  DATA: lv_answer TYPE c,
        lv_tabix  TYPE sy-tabix.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Tipo Material Cadastrada
  DATA: lt_023 TYPE TABLE OF /ptloms/tb023.
  SELECT *
    FROM /ptloms/tb023
    INTO CORRESPONDING FIELDS OF TABLE lt_023
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA: ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY mtart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA: ls_023 LIKE LINE OF lt_023.
      READ TABLE lt_023 INTO ls_023 WITH KEY mtart = ls_tab-mtart.
      IF sy-subrc EQ 0.
*        DATA(lv_msg)  = |Registro existente.|.
        DATA lv_msg  TYPE c LENGTH 20 VALUE 'Registro existente.'.
        DATA lv_msg2 TYPE c LENGTH 20.
**        DATA(lv_msg2) = |Tipo Mat.: | &&
**                        ls_tab-mtart.
        CONCATENATE 'Tipo Mat.:' ls_tab-mtart INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb023.
*      ls_tb023-perfil = gv_perfil.
*      ls_tb023-mtart  = ls_tab-mtart.
*      APPEND ls_tb023 TO lt_tb023.
*
*      CLEAR ls_tipo_material.
*      MOVE-CORRESPONDING ls_tab TO ls_tipo_material.
*      APPEND ls_tipo_material TO gt_tipo_material.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY mtart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb023.
      ls_tb023-perfil = gv_perfil.
      ls_tb023-mtart  = ls_tab-mtart.
      APPEND ls_tb023 TO lt_tb023.

      CLEAR ls_tipo_material.
      MOVE-CORRESPONDING ls_tab TO ls_tipo_material.
      APPEND ls_tipo_material TO gt_tipo_material.
    ENDIF.
  ENDLOOP.

  SORT gt_tipo_material BY mtart ASCENDING.

* Grava Tipo Material
  IF lt_tb023[] IS NOT INITIAL.
    MODIFY /ptloms/tb023 FROM TABLE lt_tb023.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_AUART
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_auart TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           auart TYPE t003o-auart,
           autyp TYPE t003o-autyp,
           txt   TYPE t003p-txt,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb022 TYPE STANDARD TABLE OF /ptloms/tb022.

  DATA: ls_tb022      TYPE /ptloms/tb022,
        ls_tipo_ordem LIKE LINE OF gt_tipo_ordem.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Tipo Ordem Cadastrada
  DATA: lt_022 TYPE TABLE OF /ptloms/tb022.
  SELECT *
    FROM /ptloms/tb022
    INTO CORRESPONDING FIELDS OF TABLE lt_022
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA: ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA: ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY auart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA: ls_022 LIKE LINE OF lt_022.
      READ TABLE lt_022 INTO ls_022 WITH KEY auart = ls_tab-auart.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
**        DATA(lv_msg2) = |Tipo Ordem: | &&
**                        ls_tab-auart.
        CONCATENATE 'Tipo Ordem:'(088) ls_tab-auart INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb022.
*      ls_tb022-perfil = gv_perfil.
*      ls_tb022-auart  = ls_tab-auart.
*      APPEND ls_tb022 TO lt_tb022.
*
*      CLEAR ls_tipo_ordem.
*      MOVE-CORRESPONDING ls_tab TO ls_tipo_ordem.
*      APPEND ls_tipo_ordem TO gt_tipo_ordem.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY auart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb022.
      ls_tb022-perfil = gv_perfil.
      ls_tb022-auart  = ls_tab-auart.
      APPEND ls_tb022 TO lt_tb022.

      CLEAR ls_tipo_ordem.
      MOVE-CORRESPONDING ls_tab TO ls_tipo_ordem.
      APPEND ls_tipo_ordem TO gt_tipo_ordem.
    ENDIF.
  ENDLOOP.

  SORT gt_tipo_ordem BY auart ASCENDING.

* Grava Tipo Ordem
  IF lt_tb022[] IS NOT INITIAL.
    MODIFY /ptloms/tb022 FROM TABLE lt_tb022.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_QMART
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_qmart TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix  TYPE sy-tabix,
           qmart  TYPE tq80-qmart,
           qmtyp  TYPE tq80-qmtyp,
           rbnr   TYPE tq80-rbnr,
           qmartx TYPE tq80_t-qmartx,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb021 TYPE STANDARD TABLE OF /ptloms/tb021.

  DATA: ls_tb021     TYPE /ptloms/tb021,
        ls_tipo_nota LIKE LINE OF gt_tipo_nota.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Tipo Nota Cadastrada
  DATA: lt_021 TYPE TABLE OF /ptloms/tb021.
  SELECT *
    FROM /ptloms/tb021
    INTO CORRESPONDING FIELDS OF TABLE lt_021
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY qmart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA: ls_021 LIKE LINE OF lt_021.
      READ TABLE lt_021 INTO ls_021 WITH KEY qmart = ls_tab-qmart.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
***        DATA(lv_msg2) = |Tipo Nota: | &&
***                        ls_tab-qmart.
        CONCATENATE 'Tipo Nota:'(087) ls_tab-qmart INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb021.
*      ls_tb021-perfil = gv_perfil.
*      ls_tb021-qmart  = ls_tab-qmart.
*      APPEND ls_tb021 TO lt_tb021.
*
*      CLEAR ls_tipo_nota.
*      MOVE-CORRESPONDING ls_tab TO ls_tipo_nota.
*      APPEND ls_tipo_nota TO gt_tipo_nota.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY qmart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb021.
      ls_tb021-perfil = gv_perfil.
      ls_tb021-qmart  = ls_tab-qmart.
      APPEND ls_tb021 TO lt_tb021.

      CLEAR ls_tipo_nota.
      MOVE-CORRESPONDING ls_tab TO ls_tipo_nota.
      APPEND ls_tipo_nota TO gt_tipo_nota.
    ENDIF.
  ENDLOOP.

  SORT gt_tipo_nota BY qmart ASCENDING.

* Grava Tipo Nota
  IF lt_tb021[] IS NOT INITIAL.
    MODIFY /ptloms/tb021 FROM TABLE lt_tb021.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_EQART
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_eqart TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           eqart TYPE t370k-eqart,
           eartx TYPE t370k_t-eartx,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb020 TYPE STANDARD TABLE OF /ptloms/tb020.

  DATA: ls_tb020       TYPE /ptloms/tb020,
        ls_tipo_objeto LIKE LINE OF gt_tipo_objeto.

  DATA: lv_answer TYPE c,
        lv_tabix  TYPE sy-tabix.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Tipo de Obj. Cadastrada
  DATA: lt_020 TYPE TABLE OF /ptloms/tb020.
  SELECT *
    FROM /ptloms/tb020
    INTO CORRESPONDING FIELDS OF TABLE lt_020
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA: ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA: ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY eqart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA ls_020 LIKE LINE OF lt_020.
      READ TABLE lt_020 INTO ls_020 WITH KEY eqart = ls_tab-eqart.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
        DATA lv_msg2 TYPE c LENGTH 20.
        CONCATENATE 'Tipo Obj.Tec.:' ls_tab-eqart INTO lv_msg2 SEPARATED BY space.
*        DATA(lv_msg2) = |Tipo Obj.Tec.: |  &&
*                        ls_tab-eqart.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb020.
*      ls_tb020-perfil = gv_perfil.
*      ls_tb020-eqart  = ls_tab-eqart.
*      APPEND ls_tb020 TO lt_tb020.
*
*      CLEAR ls_tipo_objeto.
*      MOVE-CORRESPONDING ls_tab TO ls_tipo_objeto.
*      APPEND ls_tipo_objeto TO gt_tipo_objeto.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY eqart = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb020.
      ls_tb020-perfil = gv_perfil.
      ls_tb020-eqart  = ls_tab-eqart.
      APPEND ls_tb020 TO lt_tb020.

      CLEAR ls_tipo_objeto.
      MOVE-CORRESPONDING ls_tab TO ls_tipo_objeto.
      APPEND ls_tipo_objeto TO gt_tipo_objeto.
    ENDIF.
  ENDLOOP.

  SORT gt_tipo_objeto BY eqart ASCENDING.

* Grava Tipo Obj.
  IF lt_tb020[] IS NOT INITIAL.
    MODIFY /ptloms/tb020 FROM TABLE lt_tb020.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_EQTYP
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_eqtyp TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           eqtyp TYPE t370t-eqtyp,
           typtx TYPE t370u-typtx,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb019 TYPE STANDARD TABLE OF /ptloms/tb019.

  DATA: ls_tb019           TYPE /ptloms/tb019,
        ls_cat_equipamento LIKE LINE OF gt_cat_equipamento.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Cat.Equi. Cadastrada
  DATA lt_019 TYPE TABLE OF /ptloms/tb019.
  SELECT *
    FROM /ptloms/tb019
    INTO TABLE lt_019
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA: ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY eqtyp = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA ls_019 LIKE LINE OF lt_019.
      READ TABLE lt_019 INTO ls_019 WITH KEY eqtyp = ls_tab-eqtyp.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
***        DATA(lv_msg2) = |Cat.Equip. | &&
***                        ls_tab-eqtyp.
        CONCATENATE 'Cat.Equip'(115) ls_tab-eqtyp INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb019.
*      ls_tb019-perfil = gv_perfil.
*      ls_tb019-eqtyp  = ls_tab-eqtyp.
*      APPEND ls_tb019 TO lt_tb019.
*
*      CLEAR ls_cat_equipamento.
*      MOVE-CORRESPONDING ls_tab TO ls_cat_equipamento.
*      APPEND ls_cat_equipamento TO gt_cat_equipamento.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY eqtyp = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb019.
      ls_tb019-perfil = gv_perfil.
      ls_tb019-eqtyp  = ls_tab-eqtyp.
      APPEND ls_tb019 TO lt_tb019.

      CLEAR ls_cat_equipamento.
      MOVE-CORRESPONDING ls_tab TO ls_cat_equipamento.
      APPEND ls_cat_equipamento TO gt_cat_equipamento.
    ENDIF.
  ENDLOOP.

  SORT gt_cat_equipamento BY eqtyp ASCENDING.

* Grava Cat.Equip.
  IF lt_tb019[] IS NOT INITIAL.
    MODIFY /ptloms/tb019 FROM TABLE lt_tb019.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_FLTYP
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_fltyp TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           fltyp TYPE t370f-fltyp,
           typtx TYPE t370f_t-typtx,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb018 TYPE STANDARD TABLE OF /ptloms/tb018.

  DATA: ls_tb018        TYPE /ptloms/tb018,
        ls_cat_loc_inst LIKE LINE OF gt_cat_loc_inst.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Cat.Loc.Inst. Cadastrada
  DATA lt_018 TYPE TABLE OF /ptloms/tb018.
  SELECT *
    FROM /ptloms/tb018
    INTO TABLE lt_018
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    MOVE ls_return-fieldval TO lv_tabix.
*    READ TABLE lt_tab INTO DATA(ls_tab) INDEX lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY fltyp = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA ls_018 LIKE LINE OF lt_018.
      READ TABLE lt_018 INTO ls_018 WITH KEY fltyp = ls_tab-fltyp.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
***        DATA(lv_msg2) = |Cat.Loc.Inst.: | &&
***                        ls_tab-fltyp.
        CONCATENATE 'Cat.Loc.Inst.:'(116) ls_tab-fltyp INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb018.
*      ls_tb018-perfil = gv_perfil.
*      ls_tb018-fltyp  = ls_tab-fltyp.
*      APPEND ls_tb018 TO lt_tb018.
*
*      CLEAR ls_cat_loc_inst.
*      MOVE-CORRESPONDING ls_tab TO ls_cat_loc_inst.
*      APPEND ls_cat_loc_inst TO gt_cat_loc_inst.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY fltyp = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb018.
      ls_tb018-perfil = gv_perfil.
      ls_tb018-fltyp  = ls_tab-fltyp.
      APPEND ls_tb018 TO lt_tb018.

      CLEAR ls_cat_loc_inst.
      MOVE-CORRESPONDING ls_tab TO ls_cat_loc_inst.
      APPEND ls_cat_loc_inst TO gt_cat_loc_inst.
    ENDIF.
  ENDLOOP.

  SORT gt_cat_loc_inst BY fltyp ASCENDING.

* Grava Cat.Loc.Inst.
  IF lt_tb018[] IS NOT INITIAL.
    MODIFY /ptloms/tb018 FROM TABLE lt_tb018.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_OBJID
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_objid TABLES pt_return STRUCTURE ddshretval
                                   pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           objid TYPE crhd-objid,
           arbpl TYPE crhd-arbpl,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb017 TYPE STANDARD TABLE OF /ptloms/tb017.

  DATA: ls_tb017           TYPE /ptloms/tb017,
        ls_centro_trabalho LIKE LINE OF gt_centro_trabalho.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Centro Trabalho Cadastrada
  DATA: lt_017 TYPE TABLE OF /ptloms/tb017.
  SELECT *
    FROM /ptloms/tb017
    INTO TABLE lt_017
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      DATA ls_017 LIKE LINE OF lt_017.
      READ TABLE lt_017 INTO ls_017 WITH KEY objid = ls_tab-objid
                                                   werks = ls_tab-werks.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
***        DATA(lv_msg2) = |Centro Trab.: | &&
***                        ls_tab-objid     &&
***                        | Centro: |      &&
***                        ls_tab-werks.
        CONCATENATE 'Centro Trab.:'(117) ls_tab-objid 'Centro:'(111) ls_tab-werks INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      DATA: lv_centro_perfil    TYPE i VALUE 0.
      DATA: lv_centro_permissao TYPE c LENGTH 1.

      CALL METHOD /ptloms/cl006=>verifica_centro_perfil
        EXPORTING
          im_perfil = gv_perfil
          im_werks  = ls_tab-werks
        IMPORTING
          ex_subrc  = lv_centro_perfil.

      IF lv_centro_perfil NE 0.
        MESSAGE s003(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      CALL METHOD /ptloms/cl006=>verifica_permissao_centro
        EXPORTING
          im_tcode            = sy-tcode
          im_werks            = ls_tab-werks
        IMPORTING
          ex_possui_permissao = lv_centro_permissao.


      IF lv_centro_permissao IS INITIAL.
        MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb017.
*      ls_tb017-perfil = gv_perfil.
*      ls_tb017-werks  = ls_tab-werks.
*      ls_tb017-objid  = ls_tab-objid.
*      APPEND ls_tb017 TO lt_tb017.
*
*      CLEAR ls_centro_trabalho.
*      MOVE-CORRESPONDING ls_tab TO ls_centro_trabalho.
*      APPEND ls_centro_trabalho TO gt_centro_trabalho.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      CLEAR ls_tb017.
      ls_tb017-perfil = gv_perfil.
      ls_tb017-werks  = ls_tab-werks.
      ls_tb017-objid  = ls_tab-objid.
      APPEND ls_tb017 TO lt_tb017.

      CLEAR ls_centro_trabalho.
      MOVE-CORRESPONDING ls_tab TO ls_centro_trabalho.
      APPEND ls_centro_trabalho TO gt_centro_trabalho.
    ENDIF.
  ENDLOOP.

  SORT gt_centro_trabalho BY objid ASCENDING werks ASCENDING.

* Grava Centro de Trabalho
  IF lt_tb017[] IS NOT INITIAL.
    MODIFY /ptloms/tb017 FROM TABLE lt_tb017.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_CENTRO_AO
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_centro_ao TABLES pt_return STRUCTURE ddshretval
                                       pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
           beber TYPE t357-beber,
           fing  TYPE t357-fing,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb016 TYPE STANDARD TABLE OF /ptloms/tb016.

  DATA: ls_tb016            TYPE /ptloms/tb016,
        ls_area_operacional LIKE LINE OF gt_area_operacional.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Área Operacional Cadastrada
  DATA: lt_016 TYPE TABLE OF /ptloms/tb016.
  SELECT *
    FROM /ptloms/tb016
    INTO CORRESPONDING FIELDS OF TABLE lt_016
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      DATA ls_016 LIKE LINE OF lt_016.
      READ TABLE lt_016 INTO ls_016 WITH KEY werks = ls_tab-werks
                                                   beber = ls_tab-beber.
      IF sy-subrc EQ 0.
*        DATA(lv_msg)  = |Registro já existente.|.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro já existente.'.
***        DATA(lv_msg2) = |Centro: |        &&
***                        ls_tab-werks      &&
***                        | Área Op.: | &&
***                        ls_tab-beber.
        CONCATENATE 'Centro:'(111) ls_tab-werks 'Área Op.:'(118) ls_tab-beber INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      DATA: lv_centro_perfil TYPE i VALUE 0.

      CALL METHOD /ptloms/cl006=>verifica_centro_perfil
        EXPORTING
          im_perfil = gv_perfil
          im_werks  = ls_tab-werks
        IMPORTING
          ex_subrc  = lv_centro_perfil.


      IF lv_centro_perfil NE 0.
        MESSAGE s003(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      DATA: lv_centro_permissao TYPE c LENGTH 1.

      CALL METHOD /ptloms/cl006=>verifica_permissao_centro
        EXPORTING
          im_tcode            = sy-tcode
          im_werks            = ls_tab-werks
        IMPORTING
          ex_possui_permissao = lv_centro_permissao.


      IF lv_centro_permissao IS INITIAL.
        MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb016.
*      ls_tb016-perfil = gv_perfil.
*      ls_tb016-werks  = ls_tab-werks.
*      ls_tb016-beber  = ls_tab-beber.
*      APPEND ls_tb016 TO lt_tb016.
*
*      CLEAR ls_area_operacional.
*      MOVE-CORRESPONDING ls_tab TO ls_area_operacional.
*      APPEND ls_area_operacional TO gt_area_operacional.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      CLEAR ls_tb016.
      ls_tb016-perfil = gv_perfil.
      ls_tb016-werks  = ls_tab-werks.
      ls_tb016-beber  = ls_tab-beber.
      APPEND ls_tb016 TO lt_tb016.

      CLEAR ls_area_operacional.
      MOVE-CORRESPONDING ls_tab TO ls_area_operacional.
      APPEND ls_area_operacional TO gt_area_operacional.
    ENDIF.
  ENDLOOP.

  SORT gt_area_operacional BY werks ASCENDING beber ASCENDING.

* Grava Área Operacional
  IF lt_tb016[] IS NOT INITIAL.
    MODIFY /ptloms/tb016 FROM TABLE lt_tb016.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_CENTRO_GRP_P
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_centro_grp_p TABLES pt_return STRUCTURE ddshretval
                                          pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           iwerk TYPE t024i-iwerk,
           name1 TYPE t001w-name1,
           ingrp TYPE t024i-ingrp,
           innam TYPE t024i-innam,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb015 TYPE STANDARD TABLE OF /ptloms/tb015.

  DATA: ls_tb015              TYPE /ptloms/tb015,
        ls_grupo_planejamento LIKE LINE OF gt_grupo_planejamento.

  DATA: lv_answer TYPE c,
        lv_tabix  TYPE sy-tabix.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Grupo de Planejamento
  DATA lt_015 TYPE TABLE OF /ptloms/tb015.
  SELECT *
    FROM /ptloms/tb015
    INTO CORRESPONDING FIELDS OF TABLE lt_015
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      DATA ls_015 LIKE LINE OF lt_015.
      READ TABLE lt_015 INTO ls_015 WITH KEY iwerk = ls_tab-iwerk
                                                   ingrp = ls_tab-ingrp.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
        DATA lv_msg2 TYPE c LENGTH 40.
        CONCATENATE 'Centro' ls_tab-iwerk 'Grp.Plan.:' ls_tab-ingrp INTO lv_msg2 SEPARATED BY space.
*        DATA(lv_msg2) = |Centro: |     &&
*                        ls_tab-iwerk   &&
*                        | Grp.Plan.: | &&
*                        ls_tab-ingrp.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      DATA lv_centro_perfil TYPE i VALUE 0.

      CALL METHOD /ptloms/cl006=>verifica_centro_perfil
        EXPORTING
          im_perfil = gv_perfil
          im_werks  = ls_tab-iwerk
        IMPORTING
          ex_subrc  = lv_centro_perfil.

      IF lv_centro_perfil NE 0.
        MESSAGE s003(/ptloms/cm001) WITH ls_tab-iwerk DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      DATA: lv_permissao_centro TYPE c LENGTH 1.

      CALL METHOD /ptloms/cl006=>verifica_permissao_centro
        EXPORTING
          im_tcode            = sy-tcode
          im_werks            = ls_tab-iwerk
        IMPORTING
          ex_possui_permissao = lv_permissao_centro.

      IF lv_permissao_centro IS INITIAL.
        MESSAGE s002(/ptloms/cm001) WITH ls_tab-iwerk DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

*      CLEAR ls_tb015.
*      ls_tb015-perfil = gv_perfil.
*      ls_tb015-iwerk  = ls_tab-iwerk.
*      ls_tb015-ingrp  = ls_tab-ingrp.
*      APPEND ls_tb015 TO lt_tb015.
*
*      CLEAR ls_grupo_planejamento.
*      MOVE-CORRESPONDING ls_tab TO ls_grupo_planejamento.
*      APPEND ls_grupo_planejamento TO gt_grupo_planejamento.
    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      CLEAR ls_tb015.
      ls_tb015-perfil = gv_perfil.
      ls_tb015-iwerk  = ls_tab-iwerk.
      ls_tb015-ingrp  = ls_tab-ingrp.
      APPEND ls_tb015 TO lt_tb015.

      CLEAR ls_grupo_planejamento.
      MOVE-CORRESPONDING ls_tab TO ls_grupo_planejamento.
      APPEND ls_grupo_planejamento TO gt_grupo_planejamento.
    ENDIF.
  ENDLOOP.

  SORT gt_grupo_planejamento BY iwerk ASCENDING ingrp ASCENDING.

* Grava Grupo de Planejamento
  IF lt_tb015[] IS NOT INITIAL.
    MODIFY /ptloms/tb015 FROM TABLE lt_tb015.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_CENTRO_ADM
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_centro_adm TABLES pt_return STRUCTURE ddshretval
                                          pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           bukrs TYPE t001-bukrs,
           butxt TYPE t001-butxt,
           werks TYPE t001w-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: lt_tb014 TYPE STANDARD TABLE OF /ptloms/tb014.

  DATA: ls_tb014          TYPE /ptloms/tb014,
        ls_empresa_centro LIKE LINE OF gt_empresa_centro.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Empresa Centro Cadastrada
  DATA: lt_014 TYPE TABLE OF /ptloms/tb014.
  SELECT *
    FROM /ptloms/tb014
    INTO CORRESPONDING FIELDS OF TABLE lt_014
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      DATA ls_014 LIKE LINE OF lt_014.
      READ TABLE lt_014 INTO ls_014 WITH KEY bukrs = ls_tab-bukrs
                                                   werks = ls_tab-werks.
      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
*        DATA(lv_msg)  = |Registro existente.|.
***        DATA(lv_msg2) = |Empresa: |  &&
***                        ls_tab-bukrs &&
***                        | Cenrro: |  &&
***                        ls_tab-werks.
        CONCATENATE 'Empresa:'(119) ls_tab-bukrs 'Centro:'(111) ls_tab-werks INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      DATA lv_permissao_centro TYPE c LENGTH 1.

      CALL METHOD /ptloms/cl006=>verifica_permissao_centro
        EXPORTING
          im_tcode            = sy-tcode
          im_werks            = ls_tab-werks
        IMPORTING
          ex_possui_permissao = lv_permissao_centro.

      IF lv_permissao_centro IS INITIAL.
        MESSAGE s002(/ptloms/cm001) WITH ls_tab-werks DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
    ENDIF.

  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
    MOVE ls_return-fieldval TO lv_tabix.
    READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.
    IF sy-subrc EQ 0.
      CLEAR ls_tb014.
      ls_tb014-perfil = gv_perfil.
      ls_tb014-bukrs  = ls_tab-bukrs.
      ls_tb014-werks  = ls_tab-werks.
      APPEND ls_tb014 TO lt_tb014.

      CLEAR ls_empresa_centro.
      MOVE-CORRESPONDING ls_tab TO ls_empresa_centro.
      APPEND ls_empresa_centro TO gt_empresa_centro.
    ENDIF.
  ENDLOOP.

  SORT gt_empresa_centro BY bukrs ASCENDING werks ASCENDING.

* Grava Causa Desvio
  IF lt_tb014[] IS NOT INITIAL.
    MODIFY /ptloms/tb014 FROM TABLE lt_tb014.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
**&---------------------------------------------------------------------*
**&      Module  DISABLE_ICONS  OUTPUT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*MODULE disable_icons OUTPUT.
*
*  excl_cua_funct-function = 'MKBL'.
*  APPEND excl_cua_funct.
*  excl_cua_funct-function = 'MKAL'.
*  APPEND excl_cua_funct.
*  excl_cua_funct-function = 'MKLO'.
*  APPEND excl_cua_funct.
*
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_CENTRO_GRP_P
*&---------------------------------------------------------------------*
FORM f_seleciona_mult_lista_tarefa TABLES pt_return STRUCTURE ddshretval.

  DATA:
    ls_return LIKE LINE OF pt_return.

  DATA: lv_answer TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Lista de Tarefa

  " --- Loop nos registro selecionado pelo usuário

  LOOP AT pt_return INTO ls_return.

    READ TABLE gt_tb064 INTO wa_tb064 WITH KEY nrseq = ls_return-fieldval.
    IF sy-subrc EQ 0.

      READ TABLE gt_tb063 INTO wa_tb063 WITH KEY nrseq = wa_tb064-nrseq.

      IF sy-subrc EQ 0.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
        DATA lv_msg2 TYPE c LENGTH 40.
        CONCATENATE 'Lista de Tarefa' wa_tb064-plnty '-' wa_tb064-plnnr
                          INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

    ENDIF.

  ENDLOOP.

  DATA lv_nrseq   TYPE /ptloms/tb063-nrseq.
  CLEAR lv_nrseq.
  SELECT nrseq  UP TO 1 ROWS
     INTO lv_nrseq FROM /ptloms/tb063
    WHERE perfil EQ gv_perfil
    ORDER BY nrseq DESCENDING.
  ENDSELECT.

  LOOP AT pt_return INTO ls_return.

    REPLACE ALL OCCURRENCES OF '.'  IN ls_return-fieldval WITH ' '.
    CONDENSE ls_return-fieldval NO-GAPS.

    READ TABLE gt_tb064 INTO wa_tb064 WITH KEY nrseq = ls_return-fieldval.

    IF sy-subrc EQ 0.
      CLEAR wa_tb063.
      MOVE-CORRESPONDING wa_tb064   TO wa_tb063.
      wa_tb063-perfil = gv_perfil.
      lv_nrseq        = lv_nrseq  + 1.
      wa_tb063-nrseq  = lv_nrseq.
      APPEND wa_tb063 TO gt_tb063.

    ENDIF.

  ENDLOOP.

  SORT gt_tb063 BY nrseq ASCENDING.

* Grava Lista Tarefa
  IF gt_tb063[] IS NOT INITIAL.

    MODIFY /ptloms/tb063 FROM TABLE gt_tb063.

    PERFORM f_busca_lista_tarefa .

    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VERIFICA_BLOQUEIO
*&---------------------------------------------------------------------*
FORM f_verifica_bloqueio USING p_display_msg TYPE char1
                      CHANGING p_erro        TYPE char1.
*
*  DATA: rangetab TYPE TABLE OF vimsellist INITIAL SIZE 50
*                         WITH HEADER LINE.
*
*  IF gv_edit = 'X'.
*
*    CALL FUNCTION 'VIEW_ENQUEUE'
*      EXPORTING
*        action           = 'E'
*        enqueue_mode     = 'E'
*        view_name        = '/PTLOMS/TB012'
*        enqueue_range    = space
*      TABLES
*        sellist          = rangetab
*      EXCEPTIONS
*        foreign_lock     = 1
*        system_failure   = 2
*        table_not_found  = 5
*        client_reference = 7.
*
*    IF sy-subrc NE 0.
*      p_erro = 'X'.
*      IF p_display_msg = 'X'.
*        MESSAGE s049(sv) WITH sy-msgv1.
*      ENDIF.
*    ENDIF.
*
*  ELSE.
*
*    CALL FUNCTION 'VIEW_ENQUEUE'
*      EXPORTING
*        action           = 'D'
*        enqueue_mode     = 'E'
*        view_name        = '/PTLOMS/TB012'
*        enqueue_range    = space
*      TABLES
*        sellist          = rangetab
*      EXCEPTIONS
*        foreign_lock     = 1
*        system_failure   = 2
*        table_not_found  = 5
*        client_reference = 7.
*
*    IF sy-subrc NE 0.
*      p_erro = 'X'.
*      IF p_display_msg = 'X'.
*        MESSAGE s049(sv) WITH sy-msgv1.
*      ENDIF.
*    ENDIF.
*
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_V018
*&---------------------------------------------------------------------*
FORM f_help_v018 .

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           objid TYPE crhd-objid,
           arbpl TYPE crhd-arbpl,
           werks TYPE crhd-werks,
           name1 TYPE t001w-name1,
         END OF ty_tab.

  DATA: r_bukrs TYPE RANGE OF /ptloms/tb002-bukrs.

  DATA: lt_tab             TYPE STANDARD TABLE OF ty_tab,
        lt_return          TYPE STANDARD TABLE OF ddshretval,
        lt_centro_trabalho TYPE /ptloms/ct009,
        lt_dynpfields      TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: ls_tab LIKE LINE OF lt_tab.

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  DATA: lv_tabix              TYPE sy-tabix,
        lv_tc_actual_line     TYPE i,
        lv_tc_actual_line_str TYPE string.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  lv_tc_actual_line_str = lv_tc_actual_line.

* Busca todos os Empresas/Centro cadastrados
  DATA lt_tb002 TYPE TABLE OF /ptloms/tb002.
  SELECT *
    FROM /ptloms/tb002
    INTO CORRESPONDING FIELDS OF TABLE lt_tb002
    WHERE bukrs IN r_bukrs.

* Busca descrição dos centros
  IF lt_tb002[] IS NOT INITIAL.
    DATA lt_t001w TYPE TABLE OF t001w.
    SELECT werks name1
      FROM t001w
      INTO TABLE lt_t001w
      FOR ALL ENTRIES IN lt_tb002
      WHERE werks = lt_tb002-werks.
  ENDIF.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = ''
      im_grupo_planejamento      = ''
      im_area_operacional        = ''
      im_centro_trabalho         = 'X'
      im_tipo_nota               = ''
      im_tipo_ordem              = ''
      im_tipo_prioridade_ordem   = ''
      im_tipo_prioridade_nota    = ''
      im_tipo_atv_manutencao     = ''
      im_centro_custo            = ''
      im_condicao_inst_ordem     = ''
      im_tipo_atv_operacao       = ''
      im_tipo_material           = ''
      im_categoria_item_material = ''
      im_deposito                = ''
      im_categoria_equipamento   = ''
      im_tipo_objeto             = ''
      im_categoria_loc_inst      = ''
    IMPORTING
      et_centro_trabalho         = lt_centro_trabalho ).

*  SELECT objid, werks, arbpl
*    FROM crhd
*    INTO CORRESPONDING FIELDS OF TABLE @lt_centro_trabalho.

  DATA ls_centro_trabalho LIKE LINE OF lt_centro_trabalho.
  LOOP AT lt_centro_trabalho INTO ls_centro_trabalho.
    DATA ls_002 LIKE LINE OF lt_tb002.
    READ TABLE lt_tb002 INTO ls_002
    WITH KEY werks = ls_centro_trabalho-werks.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    CLEAR ls_tab.
    lv_tabix = lv_tabix + 1.
    ls_tab-tabix = lv_tabix.
    MOVE-CORRESPONDING ls_centro_trabalho TO ls_tab.

    DATA ls_t001w LIKE LINE OF lt_t001w.
    READ TABLE lt_t001w INTO ls_t001w WITH KEY werks = ls_002-werks.
    ls_tab-name1 = ls_t001w-name1.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  IF lt_tab[] IS INITIAL.
    MOVE  'Não existen dados para ser inseridos' TO lv_msg .
    MESSAGE s000(su) WITH lv_msg DISPLAY LIKE 'S'.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'TABIX'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.
      CLEAR lv_tabix.

      " --- Atribui valor ao campo da tela
      REPLACE ALL OCCURRENCES OF '.' IN ls_return-fieldval WITH space.
      MOVE ls_return-fieldval TO lv_tabix.

      READ TABLE lt_tab INTO ls_tab INDEX lv_tabix.

      /ptloms/v018-objid = ls_tab-objid.
*      DATA(lv_nome_campo) = '/PTLOMS/V018-OBJID(' && lv_tc_actual_line && ')'.
      DATA lv_nome_campo TYPE c LENGTH 40.
      CONCATENATE '/PTLOMS/V018-OBJID(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v018-objid.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v018-arbpl = ls_tab-arbpl.
*      lv_nome_campo = '/PTLOMS/V018-ARBPL(' && lv_tc_actual_line && ')'.
      CONCATENATE '/PTLOMS/V018-ARBPL(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v018-arbpl.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v018-werks = ls_tab-werks.
*      lv_nome_campo = '/PTLOMS/V018-WERKS(' && lv_tc_actual_line && ')'.
      CONCATENATE '/PTLOMS/V018-WERKS(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v018-werks.
      APPEND ls_dynpfields TO lt_dynpfields.

      /ptloms/v018-name1 = ls_tab-name1.
*      lv_nome_campo = '/PTLOMS/V018-NAME1(' && lv_tc_actual_line && ')'.
      CONCATENATE '/PTLOMS/V018-NAME1(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
      ls_dynpfields-fieldname = lv_nome_campo.
      ls_dynpfields-fieldvalue = /ptloms/v018-name1.
      APPEND ls_dynpfields TO lt_dynpfields.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_HELP_V018_2
*&---------------------------------------------------------------------*
FORM f_help_v018_2 .

  DATA: ls_rcr01 TYPE rcr01.

  DATA: lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: lv_tc_actual_line     TYPE i,
        lv_tc_actual_line_str TYPE string,
        lv_arbpl              TYPE /ptloms/v018-arbpl,
        lv_werks              TYPE /ptloms/v018-werks.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  lv_tc_actual_line_str = lv_tc_actual_line.

  CLEAR ls_dynpfields.
  DATA lv_nome_campo TYPE c LENGTH 40.
*  DATA(lv_nome_campo) = '/PTLOMS/V018-ARBPL(' && lv_tc_actual_line && ')'.
  CONCATENATE '/PTLOMS/V018-ARBPL(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
  ls_dynpfields-fieldname = lv_nome_campo.
  APPEND ls_dynpfields TO lt_dynpfields.

  CLEAR ls_dynpfields.
*  lv_nome_campo = '/PTLOMS/V018-WERKS(' && lv_tc_actual_line && ')'.
  CONCATENATE '/PTLOMS/V018-WERKS(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
  ls_dynpfields-fieldname = lv_nome_campo.
  APPEND ls_dynpfields TO lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 01
      invalid_dynprofield  = 02
      invalid_dynproname   = 03
      invalid_dynpronummer = 04
      invalid_request      = 05
      no_fielddescription  = 06
      undefind_error       = 07.

  CLEAR ls_dynpfields.
  CONCATENATE '/PTLOMS/V018-ARBPL(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
  READ TABLE lt_dynpfields INTO ls_dynpfields WITH KEY fieldname = lv_nome_campo.
  IF sy-subrc EQ 0.
    lv_arbpl = ls_dynpfields-fieldvalue.
  ENDIF.

  CLEAR ls_dynpfields.
  CONCATENATE '/PTLOMS/V018-WERKS(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
  READ TABLE lt_dynpfields INTO ls_dynpfields WITH KEY fieldname = lv_nome_campo.
  IF sy-subrc EQ 0.
    lv_werks = ls_dynpfields-fieldvalue.
  ENDIF.

  IF lv_arbpl IS INITIAL OR lv_werks IS INITIAL.
    MESSAGE s000 WITH 'Preencher Centro/Centro de Trabalho'(067) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'CR_WORKSTATION_READ_ROUTING'
    EXPORTING
      arbpl            = lv_arbpl
      werks            = lv_werks
      plnty            = 'E'
*     date             = *afrud-budat
      vgwkz            = 'X'
    IMPORTING
      works            = ls_rcr01
    EXCEPTIONS
      not_found        = 1
      type_not_allowed = 2.

  CALL FUNCTION 'C_VALID_COSTCENTER_ACTIVITIES'
    EXPORTING
      kokrs = ls_rcr01-kokrs
      kostl = ls_rcr01-kostl
    IMPORTING
      lstar = /ptloms/v018-learr.


  REFRESH lt_dynpfields[].

  CLEAR ls_dynpfields.
*  lv_nome_campo = '/PTLOMS/V018-LEARR(' && lv_tc_actual_line && ')'.
  CONCATENATE '/PTLOMS/V018-LEARR(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
  ls_dynpfields-fieldname  = lv_nome_campo.
  ls_dynpfields-fieldvalue = /ptloms/v018-learr.
  APPEND ls_dynpfields TO lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      undefind_error       = 7
      OTHERS               = 8.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_STATUS_ESPECIFIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_busca_status_inclusivo.

  REFRESH gt_status_inclusivo[].

  IF gv_perfil IS NOT INITIAL.

    SELECT *
      FROM /ptloms/tb051
      INTO TABLE gt_status_inclusivo
      WHERE perfil = gv_perfil.

    IF gt_status_inclusivo[] IS NOT INITIAL.

      DATA lt_tj02t TYPE TABLE OF tj02t.
      SELECT *
        FROM tj02t
        INTO TABLE lt_tj02t
        FOR ALL ENTRIES IN gt_status_inclusivo
        WHERE istat = gt_status_inclusivo-stat
          AND spras = sy-langu.

    ENDIF.

    FIELD-SYMBOLS <fs_status_inclusivo> LIKE LINE OF gt_status_inclusivo.
    LOOP AT gt_status_inclusivo ASSIGNING <fs_status_inclusivo>.

      DATA ls_tj02t LIKE LINE OF lt_tj02t.
      READ TABLE lt_tj02t INTO ls_tj02t WITH KEY txt04 = <fs_status_inclusivo>-txt04.

      IF sy-subrc EQ 0.
        <fs_status_inclusivo>-txt04 = ls_tj02t-txt04.
        <fs_status_inclusivo>-txt30 = ls_tj02t-txt30.
      ENDIF.

    ENDLOOP.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_STATUS_EXCLUSIVO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_busca_status_exclusivo.

  REFRESH gt_status_exclusivo[].

  IF gv_perfil IS NOT INITIAL.

    SELECT *
      FROM /ptloms/tb052
      INTO CORRESPONDING FIELDS OF TABLE gt_status_exclusivo
      WHERE perfil = gv_perfil.

    IF gt_status_exclusivo[] IS NOT INITIAL.

      DATA lt_tj02t TYPE TABLE OF tj02t.
      SELECT *
        FROM tj02t
        INTO CORRESPONDING FIELDS OF TABLE lt_tj02t
        FOR ALL ENTRIES IN gt_status_exclusivo
        WHERE istat = gt_status_exclusivo-stat
          AND spras = sy-langu.

    ENDIF.

    FIELD-SYMBOLS <fs_status_exclusivo> LIKE LINE OF gt_status_exclusivo.
    LOOP AT gt_status_exclusivo ASSIGNING <fs_status_exclusivo>.
      DATA ls_tj02t LIKE LINE OF lt_tj02t.
      READ TABLE lt_tj02t INTO ls_tj02t WITH KEY txt04 = <fs_status_exclusivo>-txt04.

      IF sy-subrc EQ 0.
        <fs_status_exclusivo>-txt04 = ls_tj02t-txt04.
        <fs_status_exclusivo>-txt30 = ls_tj02t-txt30.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_EQUIP_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_RETURN  text
*      -->P_LT_TAB  text
*----------------------------------------------------------------------*
FORM f_seleciona_mult_status_incl TABLES pt_return STRUCTURE ddshretval
                                          pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           txt04 TYPE /ptloms/tb051-txt04,
           stat  TYPE char5,
           txt30 TYPE tj02t-txt30,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: ls_tb051            TYPE /ptloms/tb051,
        ls_status_inclusivo LIKE LINE OF gt_status_inclusivo.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Status equipamento específico
  DATA lt_tb051 TYPE TABLE OF /ptloms/tb051.
  SELECT *
    FROM /ptloms/tb051
    INTO TABLE lt_tb051
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
*  LOOP AT pt_return INTO DATA(ls_return).
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY txt04 = ls_return-fieldval.
    IF sy-subrc EQ 0.
      DATA ls_051 LIKE LINE OF lt_tb051.
      READ TABLE lt_tb051 INTO ls_051 WITH KEY txt04 = ls_tab-txt04.
      IF sy-subrc EQ 0.
*        DATA(lv_msg)  = |Registro existente.|.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
        CONCATENATE 'Status'(134) ls_tab-stat INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY txt04 = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb051.
      ls_tb051-perfil = gv_perfil.
      ls_tb051-stat   = ls_tab-stat.
      ls_tb051-txt04  = ls_tab-txt04.
      ls_tb051-stat   = ls_tab-stat.
      APPEND ls_tb051 TO lt_tb051.

      CLEAR ls_status_inclusivo.
      MOVE-CORRESPONDING ls_tab TO ls_status_inclusivo.
      ls_status_inclusivo-perfil = gv_perfil.
      APPEND ls_status_inclusivo TO gt_status_inclusivo.
    ENDIF.
  ENDLOOP.

  SORT gt_status_inclusivo BY stat ASCENDING.

* Grava equipamento status específico
  IF lt_tb051[] IS NOT INITIAL.
    MODIFY /ptloms/tb051 FROM TABLE lt_tb051.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_MULT_EQUIP_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_RETURN  text
*      -->P_LT_TAB  text
*----------------------------------------------------------------------*
FORM f_seleciona_mult_status_excl TABLES pt_return STRUCTURE ddshretval
                                               pt_tab.

  TYPES: BEGIN OF ty_tab,
           tabix TYPE sy-tabix,
           txt04 TYPE /ptloms/tb051-txt04,
           stat  TYPE char5,
           txt30 TYPE tj02t-txt30,
         END OF ty_tab.

  DATA: lt_tab TYPE STANDARD TABLE OF ty_tab.

  DATA: ls_tb052            TYPE /ptloms/tb052,
        ls_status_exclusivo LIKE LINE OF gt_status_exclusivo.

  DATA: lv_answer    TYPE c,
        lv_tabix     TYPE sy-tabix,
        lv_msg2(100) TYPE c.

  IF pt_return[] IS INITIAL.
    RETURN.
  ENDIF.

  lt_tab[] = pt_tab[].

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma a inclusão dos novos registros'(056)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer = 'N'.
    MESSAGE s000(su) WITH 'Operação cancelada'(069).
    RETURN.
  ENDIF.

* Busca Perfil x Status equipamento específico
  DATA lt_tb052 TYPE TABLE OF /ptloms/tb052.
  SELECT *
    FROM /ptloms/tb052
    INTO CORRESPONDING FIELDS OF TABLE lt_tb052
    WHERE perfil = gv_perfil.

  " --- Loop nos registro selecionado pelo usuário
*  LOOP AT pt_return INTO DATA(ls_return).
  DATA ls_return LIKE LINE OF pt_return.
  LOOP AT pt_return INTO ls_return.

*    READ TABLE lt_tab INTO DATA(ls_tab) WITH KEY txt04 = ls_return-fieldval.
    DATA ls_tab LIKE LINE OF lt_tab.
    READ TABLE lt_tab INTO ls_tab WITH KEY txt04 = ls_return-fieldval.
    IF sy-subrc EQ 0.
*      READ TABLE lt_tb052 INTO DATA(ls_052) WITH KEY txt04 = ls_tab-txt04.
      DATA ls_052 LIKE LINE OF lt_tb052.
      READ TABLE lt_tb052 INTO ls_052 WITH KEY txt04 = ls_tab-txt04.
      IF sy-subrc EQ 0.
*        DATA(lv_msg)  = |Registro existente.|.
        DATA lv_msg TYPE c LENGTH 20 VALUE 'Registro existente.'.
        CONCATENATE 'Status'(134) ls_tab-stat INTO lv_msg2 SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg lv_msg2 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

    ENDIF.
  ENDLOOP.

  LOOP AT pt_return INTO ls_return.

    READ TABLE lt_tab INTO ls_tab WITH KEY txt04 = ls_return-fieldval.
    IF sy-subrc EQ 0.
      CLEAR ls_tb052.
      ls_tb052-perfil = gv_perfil.
      ls_tb052-stat   = ls_tab-stat.
      ls_tb052-txt04  = ls_tab-txt04.
      ls_tb052-stat   = ls_tab-stat.
      APPEND ls_tb052 TO lt_tb052.

      CLEAR ls_status_exclusivo.
      MOVE-CORRESPONDING ls_tab TO ls_status_exclusivo.
      ls_status_exclusivo-perfil = gv_perfil.
      APPEND ls_status_exclusivo TO gt_status_exclusivo.
    ENDIF.
  ENDLOOP.

  SORT gt_status_exclusivo BY stat ASCENDING.

* Grava equipamento status específico
  IF lt_tb052[] IS NOT INITIAL.
    MODIFY /ptloms/tb052 FROM TABLE lt_tb052.
    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Registros inseridos com sucesso'(054).
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao inserir registros'(055) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_EQUI_STATUS_ESPECIFICO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_grava_equi_status_exclusivo .

  DATA: ls_052              TYPE /ptloms/tb052,
        ls_status_exclusivo LIKE LINE OF gt_status_exclusivo.

  ls_052-perfil = gv_perfil.
  ls_052-txt04  = wa_status_exclusivo-txt04.
  ls_052-stat   = wa_status_exclusivo-stat.

  MODIFY /ptloms/tb052 FROM ls_052.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_status_exclusivo TO ls_status_exclusivo.

    APPEND ls_status_exclusivo TO gt_status_exclusivo.
    SORT gt_status_exclusivo BY txt04 ASCENDING.

    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_EQUI_STATUS_INCLUSIVO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM f_grava_equi_status_exclusivo .
*
*  DATA: ls_052              TYPE /ptloms/tb052,
*        ls_status_exclusivo LIKE LINE OF gt_status_exclusivo.
*
*  ls_052-perfil = gv_perfil.
*  ls_052-txt04  = wa_status_exclusivo-txt04.
*  ls_052-stat   = wa_status_exclusivo-stat.
*
*  MODIFY /ptloms/tb052 FROM ls_052.
*
*  IF sy-subrc EQ 0.
*    MOVE-CORRESPONDING wa_status_exclusivo TO ls_status_exclusivo.
*
*    APPEND ls_status_exclusivo TO gt_status_exclusivo.
*    SORT gt_status_exclusivo BY txt04 ASCENDING.
*
*    MESSAGE s000(su) WITH 'Registro inserido com sucesso'(046).
*  ELSE.
*    MESSAGE s000(su) WITH 'Erro ao inserir registro'(047) DISPLAY LIKE 'E'.
*  ENDIF.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_STAT_EQUIP_ESPECIFICO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_valida_status_inclusivo .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Área Operacional é válido
    IF wa_status_inclusivo-txt04 IS NOT INITIAL.

      DATA wa_status_especifico-txt30 TYPE c LENGTH 30.

      SELECT SINGLE b~txt30
        FROM tj06 AS a INNER JOIN tj02t AS b
        ON a~istat = b~istat
        INTO wa_status_especifico-txt30
        WHERE a~inact <> 'X' AND
              b~spras = sy-langu AND
             ( b~txt04 <> 'INAT' AND b~txt04 <> 'MREL' AND b~txt04 <> 'BLOQ' AND b~txt04 <> 'ELIM' ) AND
              b~txt04 = wa_status_inclusivo-txt04.

      IF sy-subrc NE 0.
        CLEAR: wa_status_inclusivo-txt04.
        MESSAGE e000(su) WITH 'Status inválido'(136).
      ENDIF.

      " Verifica se o status do equipamento específico existe
      DATA ls_051 TYPE /ptloms/tb051.
      SELECT SINGLE *
        FROM /ptloms/tb051
        INTO ls_051
        WHERE perfil = gv_perfil
          AND txt04 = wa_status_inclusivo-txt04.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_STAT_EQUIP_ESPECIFICO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_valida_status_exclusivo .

  IF sy-ucomm NE 'BTN_CANCEL' AND
     sy-ucomm NE 'ABR'.

    " Verifica se Área Operacional é válido
    IF wa_status_exclusivo-txt04 IS NOT INITIAL.

      SELECT SINGLE b~txt30
        FROM tj06 AS a INNER JOIN tj02t AS b
        ON a~istat = b~istat
        INTO wa_status_exclusivo-txt30
        WHERE a~inact <> 'X' AND
              b~spras = sy-langu AND
             ( b~txt04 <> 'INAT' AND b~txt04 <> 'MREL' AND b~txt04 <> 'BLOQ' AND b~txt04 <> 'ELIM' ) AND
              b~txt04 = wa_status_exclusivo-txt04.

      IF sy-subrc NE 0.
        CLEAR: wa_status_exclusivo-txt04.
        MESSAGE e000(su) WITH 'Status inválido'(136).
      ENDIF.

      " Verifica se o status do equipamento específico existe
      DATA ls_051 TYPE /ptloms/tb051.
      SELECT SINGLE *
        FROM /ptloms/tb051
        INTO ls_051
        WHERE perfil = gv_perfil
          AND txt04 = wa_status_exclusivo-txt04.

      IF sy-subrc EQ 0.
        MESSAGE e000(su) WITH 'Registro já existente'(049).
      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_V016
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_help_v016 .

  TYPES: BEGIN OF ty_tab,
           werks TYPE trugt-werks,
           grund TYPE trugt-grund,
           grdtx TYPE trugt-grdtx,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields LIKE LINE OF lt_dynpfields,
        lt_return     TYPE STANDARD TABLE OF ddshretval.

  DATA: ls_tab                LIKE LINE OF lt_tab,
        lv_tabix              TYPE sy-tabix,
        lv_tc_actual_line     TYPE i,
        lv_tc_actual_line_str TYPE string,
        it_mapping            TYPE STANDARD TABLE OF dselc,
        s_values              TYPE ty_tab,
        ls_return             TYPE ddshretval,
        s_mapping             TYPE dselc.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  SELECT werks grund grdtx
    FROM trugt
    INTO TABLE lt_tab
    WHERE spras = sy-langu.

  IF sy-subrc IS INITIAL.

    s_mapping-fldname     = 'F0001'.
    s_mapping-dyfldname   = 'WERKS'.
    APPEND s_mapping TO it_mapping.
    CLEAR s_mapping.

    s_mapping-fldname     = 'F0002'.
    s_mapping-dyfldname   = 'GRUND'.
    APPEND s_mapping TO it_mapping.
    CLEAR s_mapping.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'WERKS'
        value_org       = 'S'
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
        dynpfld_mapping = it_mapping
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.
      lv_tc_actual_line_str = lv_tc_actual_line.

      " --- Atribui valor ao campo da tela
      READ TABLE lt_return INTO ls_return WITH KEY fieldname = 'F0001'.

      IF sy-subrc IS INITIAL.

        /ptloms/v016-werks = ls_return-fieldval.
        DATA lv_nome_campo TYPE c LENGTH 40.
*        DATA(lv_nome_campo) = '/PTLOMS/V016-WERKS(' && lv_tc_actual_line && ')'.
        CONCATENATE '/PTLOMS/V016-WERKS(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
        ls_dynpfields-fieldname = lv_nome_campo.
        ls_dynpfields-fieldvalue = /ptloms/v016-werks.
        APPEND ls_dynpfields TO lt_dynpfields.

      ENDIF.

      READ TABLE lt_return INTO ls_return WITH KEY fieldname = 'F0002'.

      IF sy-subrc IS INITIAL.

        /ptloms/v016-grund = ls_return-fieldval.
*        lv_nome_campo = '/PTLOMS/V016-GRUND(' && lv_tc_actual_line && ')'.
        CONCATENATE '/PTLOMS/V016-GRUND(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
        ls_dynpfields-fieldname = lv_nome_campo.
        ls_dynpfields-fieldvalue = /ptloms/v016-grund.
        APPEND ls_dynpfields TO lt_dynpfields.

      ENDIF.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_V017
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_help_v017 .

  TYPES: BEGIN OF ty_tab,
           werks TYPE t001w-werks,
           tplnr TYPE iflotx-tplnr,
           pltxt TYPE iflotx-pltxt,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields LIKE LINE OF lt_dynpfields,
        lt_return     TYPE STANDARD TABLE OF ddshretval.

  DATA: ls_tab                LIKE LINE OF lt_tab,
        lv_tabix              TYPE sy-tabix,
        lv_tc_actual_line     TYPE i,
        lv_tc_actual_line_str TYPE string,
        it_mapping            TYPE STANDARD TABLE OF dselc,
        s_values              TYPE ty_tab,
        ls_return             TYPE ddshretval,
        s_mapping             TYPE dselc.

* Função que retorna o índide da linha clicada na ajuda de pesquisa do table control
  CALL FUNCTION 'DYNP_GET_STEPL'
    IMPORTING
      povstepl        = lv_tc_actual_line
    EXCEPTIONS
      stepl_not_found = 1
      OTHERS          = 2.

  SELECT swerk tplnr pltxt
    FROM iflo
    INTO TABLE lt_tab
    WHERE spras = sy-langu.

  IF sy-subrc IS INITIAL.

    s_mapping-fldname     = 'F0001'.
    s_mapping-dyfldname   = 'WERKS'.
    APPEND s_mapping TO it_mapping.
    CLEAR s_mapping.

    s_mapping-fldname     = 'F0002'.
    s_mapping-dyfldname   = 'TPLNR'.
    APPEND s_mapping TO it_mapping.
    CLEAR s_mapping.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'WERKS'
        value_org       = 'S'
      TABLES
        value_tab       = lt_tab
        return_tab      = lt_return
        dynpfld_mapping = it_mapping
      EXCEPTIONS
        parameter_error = 0
        no_values_found = 0
        OTHERS          = 0.

    IF sy-subrc = 0.

      lv_tc_actual_line_str = lv_tc_actual_line.

      " --- Atribui valor ao campo da tela
      READ TABLE lt_return INTO ls_return WITH KEY fieldname = 'F0001'.

      IF sy-subrc IS INITIAL.

        /ptloms/v017-werks = ls_return-fieldval.
*        DATA(lv_nome_campo) = '/PTLOMS/V017-WERKS(' && lv_tc_actual_line && ')'.
        DATA lv_nome_campo TYPE c LENGTH 40.
*        DATA(lv_nome_campo) = '/PTLOMS/V016-WERKS(' && lv_tc_actual_line && ')'.
        CONCATENATE '/PTLOMS/V017-WERKS(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.

        ls_dynpfields-fieldname = lv_nome_campo.
        ls_dynpfields-fieldvalue = /ptloms/v017-werks.
        APPEND ls_dynpfields TO lt_dynpfields.

      ENDIF.

      READ TABLE lt_return INTO ls_return WITH KEY fieldname = 'F0002'.

      IF sy-subrc IS INITIAL.

        /ptloms/v017-tplnr = ls_return-fieldval.
*        lv_nome_campo = '/PTLOMS/V017-TPLNR(' && lv_tc_actual_line && ')'.
        CONCATENATE '/PTLOMS/V017-TPLNR(' lv_tc_actual_line_str ')' INTO lv_nome_campo SEPARATED BY space.
        ls_dynpfields-fieldname = lv_nome_campo.
        ls_dynpfields-fieldvalue = /ptloms/v017-tplnr.
        APPEND ls_dynpfields TO lt_dynpfields.

      ENDIF.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  VALIDAR_DADOS_TB002
*&---------------------------------------------------------------------*
FORM f_validar_dados_v017.

  DATA: lwa_row TYPE /ptloms/v017.

  DATA: lv_msg(200) TYPE c.

  DATA lt_iflo TYPE TABLE OF iflo.
  SELECT swerk tplnr pltxt
    FROM iflo
    INTO CORRESPONDING FIELDS OF TABLE lt_iflo
    WHERE spras = sy-langu.

  SORT lt_iflo BY tplnr swerk.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF NOT <action> IS INITIAL AND <action> NE 'D' AND <action> NE 'X'.

        " Verifica se Empresa/Centro é válida
        READ TABLE lt_iflo TRANSPORTING NO FIELDS WITH KEY tplnr = lwa_row-tplnr swerk = lwa_row-werks BINARY SEARCH.

        IF sy-subrc NE 0.

          vim_abort_saving = 'X'.

          CONCATENATE lwa_row-werks '/' lwa_row-tplnr INTO lv_msg.

          MESSAGE s000(su) WITH 'Centro/Local de Instalação:'(138) lv_msg 'inválido'(074) DISPLAY LIKE 'E'.

          EXIT.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETA_CARACTERISTICA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_deleta_caracteristica .

  DATA lv_resposta(1) TYPE c.
  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

  DATA lv_qtde TYPE i.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
    lv_msg_tela = 'Remover o registro selecionado'(072).
  ELSE.
    MOVE lv_qtde TO lv_qtde_aux.
    CONCATENATE 'Remover os'(102) lv_qtde_aux 'registros selecionados'(103) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
    EXPORTING
      titlebar              = '### Confirmação ###'(039)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'Sim'(042)
      icon_button_1         = ' '
      text_button_2         = 'Não'(043)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
    DATA lt_caracteristica LIKE gt_caract_equipamento.
    lt_caracteristica = gt_caract_equipamento.
    DATA lv_row LIKE LINE OF o_rows.
    LOOP AT o_rows INTO lv_row.
      DATA ls_caracteristica LIKE LINE OF lt_caracteristica.
      READ TABLE lt_caracteristica INTO ls_caracteristica INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_caract_equipamento WHERE atnam = ls_caracteristica-atnam.

        " Remove da tabela /ptloms/tb059
        DELETE FROM /ptloms/tb059 WHERE perfil = gv_perfil
                                    AND atnam  = ls_caracteristica-atnam.
        IF sy-subrc NE 0.
          DATA lv_erro TYPE c LENGTH 1.
          lv_erro = 'X'.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'Registro removidos com sucesso'(040).
  ELSE.
    MESSAGE s000(su) WITH 'Erro ao remover registros'(041) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREENCHER_DADOS_TB058
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_preencher_dados_tb058.

  " Preencher campo ATINN da tabela TB058
*
  DATA: lwa_row TYPE /ptloms/tb058.

  SELECT atinn UP TO 1 ROWS
    FROM cabn
    INTO /ptloms/tb058-atinn
    WHERE atnam = /ptloms/tb058-atnam.
  ENDSELECT.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_PREENCHER_DADOS_TB058
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_preencher_dados_v020.
*
  DATA: lwa_row TYPE /ptloms/tb058.

  DATA lt_020 TYPE TABLE OF /ptloms/v020.
  DATA ls_020 LIKE LINE OF lt_020.

  SELECT a~atinn b~atbez UP TO 1 ROWS
    FROM cabn AS a INNER JOIN cabnt AS b
    ON a~atinn = b~atinn
    INTO CORRESPONDING FIELDS OF /ptloms/v020
    WHERE a~atnam = /ptloms/v020-atnam AND
          b~spras = sy-langu.
  ENDSELECT.

***  SELECT a~atinn, b~atbez UP TO 1 ROWS
***    FROM cabn AS a INNER JOIN cabnt AS b
***    ON a~atinn = b~atinn
***    INTO ( @/ptloms/v020-atinn, @/ptloms/v020-atbez )
***    WHERE a~atnam = @/ptloms/v020-atnam AND
***          b~spras = @sy-langu.
***  ENDSELECT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_PLKO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_TAB  text
*----------------------------------------------------------------------*
FORM f_busca_plko .

  TYPES:
    BEGIN OF ty_eqkt,
      equnr TYPE eqkt-equnr,
      eqktx TYPE eqkt-eqktx,
    END OF ty_eqkt.

  DATA:
    lt_v001   TYPE TABLE OF t001w,
    ls_v001   TYPE t001w,
    lt_tca02  TYPE TABLE OF tca02,
    ls_tca02  TYPE tca02,
    lt_eapl   TYPE TABLE OF eapl,
    ls_eapl   TYPE eapl,
    lt_eqkt   TYPE TABLE OF ty_eqkt,
    ls_eqkt   TYPE ty_eqkt,
    lt_tapl   TYPE TABLE OF tapl,
    ls_tapl   TYPE tapl,
    lt_iflotx TYPE TABLE OF iflotx,
    ls_iflotx TYPE iflotx,
    lr_v001   TYPE RANGE OF t001w-werks,
    er_v001   LIKE LINE OF lr_v001,
    lv_nrseq  TYPE /ptloms/tb063-nrseq.

  FIELD-SYMBOLS:
    <es_tb064> TYPE /ptloms/tb064.

  REFRESH:
    lr_v001,
    lt_v001,
    gt_tb064.

*Monta Range WERKS
  SELECT *
                 INTO TABLE lt_v001
                 FROM t001w.

  IF  lt_v001[] IS NOT INITIAL.

    er_v001-sign    = 'I'.
    er_v001-option  = 'EQ'.

    LOOP AT lt_v001 INTO ls_v001.

      er_v001-low = ls_v001-werks.
      APPEND er_v001  TO lr_v001.

    ENDLOOP.

* Busca dados na tabela de variantes
    SELECT *
                                          FROM plko
            INTO CORRESPONDING FIELDS OF TABLE gt_tb064
      WHERE plnty                           IN ('A', 'E', 'T')
        AND ( statu                         EQ '2  '
         OR   statu                         EQ '4  ')
        AND loekz                           EQ abap_false
        AND werks                           IN lr_v001.

    LOOP AT gt_tb064 INTO wa_tb064.

      READ TABLE gt_tb063 INTO wa_tb063 WITH KEY plnty =   wa_tb064-plnty
                                                 plnnr =   wa_tb064-plnnr
                                                 plnal =   wa_tb064-plnal
                                                 zaehl =   wa_tb064-zaehl.
      IF  sy-subrc           EQ 0.
        DELETE gt_tb064.
      ENDIF.

    ENDLOOP.

    IF  gt_tb064[]   IS NOT INITIAL.
      CLEAR lv_nrseq.
      SELECT nrseq  UP TO 1 ROWS
         INTO lv_nrseq FROM /ptloms/tb063
        WHERE perfil EQ gv_perfil
        ORDER BY nrseq DESCENDING.
      ENDSELECT.

      SELECT *   INTO TABLE lt_eapl
                       FROM eapl
         FOR ALL ENTRIES IN gt_tb064
        WHERE plnty      EQ gt_tb064-plnty
          AND plnnr      EQ gt_tb064-plnnr
          AND plnal      EQ gt_tb064-plnal.

      SELECT *   INTO TABLE lt_tca02
                       FROM tca02
         FOR ALL ENTRIES IN gt_tb064
        WHERE plnty      EQ gt_tb064-plnty
          AND spras      EQ sy-langu.

      SELECT equnr eqktx
                 INTO TABLE lt_eqkt
                       FROM eqkt
         FOR ALL ENTRIES IN lt_eapl
        WHERE equnr      EQ lt_eapl-equnr.

      SELECT *   INTO TABLE lt_tapl
                       FROM tapl
         FOR ALL ENTRIES IN gt_tb064
        WHERE plnty      EQ gt_tb064-plnty
          AND plnnr      EQ gt_tb064-plnnr
          AND plnal      EQ gt_tb064-plnal.

      IF  lt_tapl[]   IS NOT INITIAL.
        SELECT *   INTO TABLE lt_iflotx
                        FROM iflotx
           FOR ALL ENTRIES IN lt_tapl
          WHERE spras     EQ sy-langu
            AND tplnr     EQ lt_tapl-tplnr.
      ENDIF.

      LOOP AT gt_tb064   ASSIGNING <es_tb064>.

        lv_nrseq              = lv_nrseq + 1.
        <es_tb064>-nrseq      = lv_nrseq.

        READ TABLE lt_tca02 INTO ls_tca02 WITH KEY  plnty =  <es_tb064>-plnty.

        IF  sy-subrc        EQ  0.
          <es_tb064>-txt     = ls_tca02-txt.
        ENDIF.

* Busca Equipamento quando PLNTY = E
        READ TABLE lt_eapl INTO ls_eapl WITH KEY  plnty = <es_tb064>-plnty
                                                  plnnr = <es_tb064>-plnnr
                                                  plnal = <es_tb064>-plnal.

        IF  sy-subrc        EQ  0.
          <es_tb064>-equnr     = ls_eapl-equnr.
          READ TABLE lt_eqkt INTO ls_eqkt WITH KEY equnr   = ls_eapl-equnr.
          IF  sy-subrc      EQ 0.
            <es_tb064>-eqktx   = ls_eqkt-eqktx.
          ENDIF.
        ENDIF.

* Busca Local de Instalação quando PLNTY = T
        READ TABLE lt_tapl INTO ls_tapl WITH KEY  plnty = <es_tb064>-plnty
                                                  plnnr = <es_tb064>-plnnr
                                                  plnal = <es_tb064>-plnal.

        IF  sy-subrc        EQ  0.
          <es_tb064>-tplnr     = ls_tapl-tplnr.
          READ TABLE lt_iflotx INTO ls_iflotx WITH KEY tplnr   = ls_tapl-tplnr.
          IF  sy-subrc      EQ 0.
            <es_tb064>-pltxt   = ls_iflotx-pltxt.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDIF.

ENDFORM.
