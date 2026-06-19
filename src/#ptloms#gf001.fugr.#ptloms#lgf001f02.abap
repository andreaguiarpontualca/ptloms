*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGF001F02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_EQUI_GRP_PLAN
*&---------------------------------------------------------------------*
FORM f_filtro_equi_grp_plan .

  DATA: lt_015 TYPE STANDARD TABLE OF /ptloms/tb015,
        ls_015 LIKE LINE OF lt_015.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_grupo_planejamento ASSIGNING FIELD-SYMBOL(<fs_grupo_planejamento>) INDEX lv_row.
    FIELD-SYMBOLS: <fs_grupo_planejamento> LIKE LINE OF gt_grupo_planejamento.
    READ TABLE gt_grupo_planejamento ASSIGNING <fs_grupo_planejamento> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_grupo_planejamento>-filtro_equi = 'X'.
        CLEAR <fs_grupo_planejamento>-filtro_equi.
      ELSE.
        <fs_grupo_planejamento>-filtro_equi = 'X'.
      ENDIF.

      CLEAR ls_015.
      MOVE-CORRESPONDING <fs_grupo_planejamento> TO ls_015.
      ls_015-perfil = gv_perfil.
      APPEND ls_015 TO lt_015.
    ENDIF.
  ENDLOOP.

  IF lt_015[] IS NOT INITIAL.
    MODIFY /ptloms/tb015 FROM TABLE lt_015.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_LOCL_GRP_PLAN
*&---------------------------------------------------------------------*
FORM f_filtro_locl_grp_plan .

  DATA: lt_015 TYPE STANDARD TABLE OF /ptloms/tb015,
        ls_015 LIKE LINE OF lt_015.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'.
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_grupo_planejamento ASSIGNING FIELD-SYMBOL(<fs_grupo_planejamento>) INDEX lv_row.
    FIELD-SYMBOLS: <fs_grupo_planejamento> LIKE LINE OF gt_grupo_planejamento.
    READ TABLE gt_grupo_planejamento ASSIGNING <fs_grupo_planejamento> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_grupo_planejamento>-filtro_locl = 'X'.
        CLEAR <fs_grupo_planejamento>-filtro_locl.
      ELSE.
        <fs_grupo_planejamento>-filtro_locl = 'X'.
      ENDIF.

      CLEAR ls_015.
      MOVE-CORRESPONDING <fs_grupo_planejamento> TO ls_015.
      ls_015-perfil = gv_perfil.
      APPEND ls_015 TO lt_015.
    ENDIF.
  ENDLOOP.

  IF lt_015[] IS NOT INITIAL.
    MODIFY /ptloms/tb015 FROM TABLE lt_015.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_filtro_catalogo_ordem
*&---------------------------------------------------------------------*
FORM f_filtro_catalogo_ordem .

  DATA: lt_022   TYPE STANDARD TABLE OF /ptloms/tb022,
        ls_022   LIKE LINE OF lt_022,
        lv_value TYPE char2,
        lv_text  TYPE auarttext.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  PERFORM f_help_filtro_catalogo CHANGING lv_value lv_text.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_tipo_ordem ASSIGNING FIELD-SYMBOL(<fs_tipo_ordem>) INDEX lv_row.
    FIELD-SYMBOLS <fs_tipo_ordem> LIKE LINE OF gt_tipo_ordem.
    READ TABLE gt_tipo_ordem ASSIGNING <fs_tipo_ordem> INDEX lv_row.
    IF sy-subrc EQ 0.

      <fs_tipo_ordem>-filtro_catalogo = lv_value.
      <fs_tipo_ordem>-filtro_txt      = lv_text.

      CLEAR ls_022.
      MOVE-CORRESPONDING <fs_tipo_ordem> TO ls_022.
      ls_022-perfil = gv_perfil.
      APPEND ls_022 TO lt_022.
    ENDIF.
  ENDLOOP.

  IF lt_022[] IS NOT INITIAL.
    MODIFY /ptloms/tb022 FROM TABLE lt_022.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_EQUI_AREA_OP
*&---------------------------------------------------------------------*
FORM f_filtro_equi_area_op .

  DATA: lt_016 TYPE STANDARD TABLE OF /ptloms/tb016,
        ls_016 LIKE LINE OF lt_016.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_area_operacional ASSIGNING FIELD-SYMBOL(<fs_area_operacional>) INDEX lv_row.
    FIELD-SYMBOLS <fs_area_operacional> LIKE LINE OF gt_area_operacional.
    READ TABLE gt_area_operacional ASSIGNING <fs_area_operacional> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_area_operacional>-filtro_equi = 'X'.
        CLEAR <fs_area_operacional>-filtro_equi.
      ELSE.
        <fs_area_operacional>-filtro_equi = 'X'.
      ENDIF.

      CLEAR ls_016.
      MOVE-CORRESPONDING <fs_area_operacional> TO ls_016.
      ls_016-perfil = gv_perfil.
      APPEND ls_016 TO lt_016.
    ENDIF.
  ENDLOOP.

  IF lt_016[] IS NOT INITIAL.
    MODIFY /ptloms/tb016 FROM TABLE lt_016.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_LOCL_AREA_OP
*&---------------------------------------------------------------------*
FORM f_filtro_locl_area_op .

  DATA: lt_016 TYPE STANDARD TABLE OF /ptloms/tb016,
        ls_016 LIKE LINE OF lt_016.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*   READ TABLE gt_area_operacional ASSIGNING FIELD-SYMBOL(<fs_area_operacional>) INDEX lv_row
    FIELD-SYMBOLS: <fs_area_operacional> LIKE LINE OF gt_area_operacional.
    READ TABLE gt_area_operacional ASSIGNING <fs_area_operacional> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_area_operacional>-filtro_locl = 'X'.
        CLEAR <fs_area_operacional>-filtro_locl.
      ELSE.
        <fs_area_operacional>-filtro_locl = 'X'.
      ENDIF.

      CLEAR ls_016.
      MOVE-CORRESPONDING <fs_area_operacional> TO ls_016.
      ls_016-perfil = gv_perfil.
      APPEND ls_016 TO lt_016.
    ENDIF.
  ENDLOOP.

  IF lt_016[] IS NOT INITIAL.
    MODIFY /ptloms/tb016 FROM TABLE lt_016.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_EQUI_CENTRO_TRAB
*&---------------------------------------------------------------------*
FORM f_filtro_equi_centro_trab .

  DATA: lt_017 TYPE STANDARD TABLE OF /ptloms/tb017,
        ls_017 LIKE LINE OF lt_017.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_centro_trabalho ASSIGNING FIELD-SYMBOL(<fs_centro_trabalho>) INDEX lv_row.
    FIELD-SYMBOLS: <fs_centro_trabalho> LIKE LINE OF gt_centro_trabalho.
    READ TABLE gt_centro_trabalho ASSIGNING <fs_centro_trabalho> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_centro_trabalho>-filtro_equi = 'X'.
        CLEAR <fs_centro_trabalho>-filtro_equi.
      ELSE.
        <fs_centro_trabalho>-filtro_equi = 'X'.
      ENDIF.

      CLEAR ls_017.
      MOVE-CORRESPONDING <fs_centro_trabalho> TO ls_017.
      ls_017-perfil = gv_perfil.
      APPEND ls_017 TO lt_017.

    ENDIF.
  ENDLOOP.

  IF lt_017[] IS NOT INITIAL.
    MODIFY /ptloms/tb017 FROM TABLE lt_017.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_LOCL_CENTRO_TRAB
*&---------------------------------------------------------------------*
FORM f_filtro_locl_centro_trab .

  DATA: lt_017 TYPE STANDARD TABLE OF /ptloms/tb017,
        ls_017 LIKE LINE OF lt_017.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_centro_trabalho ASSIGNING FIELD-SYMBOL(<fs_centro_trabalho>) INDEX lv_row.
    FIELD-SYMBOLS <fs_centro_trabalho> LIKE LINE OF gt_centro_trabalho.
    READ TABLE gt_centro_trabalho ASSIGNING <fs_centro_trabalho> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_centro_trabalho>-filtro_locl = 'X'.
        CLEAR <fs_centro_trabalho>-filtro_locl.
      ELSE.
        <fs_centro_trabalho>-filtro_locl = 'X'.
      ENDIF.

      CLEAR ls_017.
      MOVE-CORRESPONDING <fs_centro_trabalho> TO ls_017.
      ls_017-perfil = gv_perfil.
      APPEND ls_017 TO lt_017.

    ENDIF.
  ENDLOOP.

  IF lt_017[] IS NOT INITIAL.
    MODIFY /ptloms/tb017 FROM TABLE lt_017.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_EQUI_TP_OBJ
*&---------------------------------------------------------------------*
FORM f_filtro_equi_tp_obj .

  DATA: lt_020 TYPE STANDARD TABLE OF /ptloms/tb020,
        ls_020 LIKE LINE OF lt_020.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_tipo_objeto ASSIGNING FIELD-SYMBOL(<fs_tipo_objeto>) INDEX lv_row.
    FIELD-SYMBOLS:  <fs_tipo_objeto> LIKE LINE OF gt_tipo_objeto.
    READ TABLE gt_tipo_objeto ASSIGNING <fs_tipo_objeto> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_tipo_objeto>-filtro_equi = 'X'.
        CLEAR <fs_tipo_objeto>-filtro_equi.
      ELSE.
        <fs_tipo_objeto>-filtro_equi = 'X'.
      ENDIF.

      CLEAR ls_020.
      MOVE-CORRESPONDING <fs_tipo_objeto> TO ls_020.
      ls_020-perfil = gv_perfil.
      APPEND ls_020 TO lt_020.

    ENDIF.
  ENDLOOP.

  IF lt_020[] IS NOT INITIAL.
    MODIFY /ptloms/tb020 FROM TABLE lt_020.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTRO_LOCL_TP_OBJ
*&---------------------------------------------------------------------*
FORM f_filtro_locl_tp_obj .

  DATA: lt_020 TYPE STANDARD TABLE OF /ptloms/tb020,
        ls_020 LIKE LINE OF lt_020.

  DATA: lv_answer TYPE c.

  o_rows = o_selections->get_selected_rows( ).
  IF o_rows[] IS INITIAL.
    MESSAGE s000(su) WITH 'Selecionar ao menos um registro'(120) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Solicitar confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'
      textline1      = 'Confirma atualização de filtro'(121)
      titel          = 'Confirmação'(068)
      cancel_display = ' '
    IMPORTING
      answer         = lv_answer.

  IF lv_answer NE 'J'.
    MESSAGE s000(su) WITH 'Ação cancelada.'(122).
    RETURN.
  ENDIF.

*  LOOP AT o_rows INTO DATA(lv_row).
  DATA lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.
*    READ TABLE gt_tipo_objeto ASSIGNING FIELD-SYMBOL(<fs_tipo_objeto>) INDEX lv_row.
    FIELD-SYMBOLS <fs_tipo_objeto> LIKE LINE OF gt_tipo_objeto.
    READ TABLE gt_tipo_objeto ASSIGNING <fs_tipo_objeto> INDEX lv_row.
    IF sy-subrc EQ 0.
      IF <fs_tipo_objeto>-filtro_locl = 'X'.
        CLEAR <fs_tipo_objeto>-filtro_locl.
      ELSE.
        <fs_tipo_objeto>-filtro_locl = 'X'.
      ENDIF.

      CLEAR ls_020.
      MOVE-CORRESPONDING <fs_tipo_objeto> TO ls_020.
      ls_020-perfil = gv_perfil.
      APPEND ls_020 TO lt_020.

    ENDIF.
  ENDLOOP.

  IF lt_020[] IS NOT INITIAL.
    MODIFY /ptloms/tb020 FROM TABLE lt_020.
    MESSAGE s000(su) WITH 'Registro atualizado com sucesso.'(123).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VERIFICA_BLOQUEIO_TABELA
*&---------------------------------------------------------------------*
FORM f_verifica_bloqueio_tabela CHANGING p_edit TYPE char1.

  DATA: rangetab TYPE TABLE OF vimsellist INITIAL SIZE 50
                         WITH HEADER LINE.

  IF sy-ucomm = 'AEND'. "Editar

    CALL FUNCTION 'VIEW_ENQUEUE'
      EXPORTING
        action           = 'E'
        enqueue_mode     = 'E'
        view_name        = '/PTLOMS/TB012'
        enqueue_range    = space
      TABLES
        sellist          = rangetab
      EXCEPTIONS
        foreign_lock     = 1
        system_failure   = 2
        table_not_found  = 5
        client_reference = 7.

    IF sy-subrc NE 0.
      MESSAGE s049(sv) WITH sy-msgv1.
      EXIT.
    ELSE.
      p_edit = 'X'.
    ENDIF.
  ELSEIF sy-ucomm = 'ANZG'. "Exibir
    CLEAR  p_edit.
  ENDIF.

  CALL FUNCTION 'VIEW_ENQUEUE'
    EXPORTING
      action           = 'D'
      enqueue_mode     = 'E'
      view_name        = '/PTLOMS/TB012'
      enqueue_range    = space
    TABLES
      sellist          = rangetab
    EXCEPTIONS
      foreign_lock     = 1
      system_failure   = 2
      table_not_found  = 5
      client_reference = 7.

ENDFORM.
