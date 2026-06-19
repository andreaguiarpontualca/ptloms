*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/MP006_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA
*&---------------------------------------------------------------------*
FORM f_grava .

  PERFORM f_grava_config.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_CONFIG
*&---------------------------------------------------------------------*
FORM f_grava_config.

  IF wa_tb033 IS NOT INITIAL.
    MODIFY /ptloms/tb033 FROM wa_tb033.
    MESSAGE s000 WITH 'Dados gravados com sucesso'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CARREGA_DADOS
*&---------------------------------------------------------------------*
FORM f_carrega_dados .

  DATA: it_idd07v TYPE TABLE OF dd07v,
        name      TYPE vrm_id,
        list      TYPE vrm_values,
        value     LIKE LINE OF list,
        l_icon    LIKE mtreeitm-t_image.

  IF wa_tb033 IS INITIAL.

    SELECT SINGLE * INTO wa_tb033 FROM /ptloms/tb033.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname   = '/PTLOMS/DM019'
        text      = 'X'
*       LANGU     = sy-langu
*       BYPASS_BUFFER        = ' '
*       IMPORTING
*       RC        =
      TABLES
        dd07v_tab = it_idd07v
*       EXCEPTIONS
*       WRONG_TEXTFLAG       = 1
*       OTHERS    = 2
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    name = 'WA_TB033-ANOS_RETROATIVOS'.

    DATA: wa_dd07v LIKE LINE OF it_idd07v.

    LOOP AT it_idd07v INTO wa_dd07v.

      value-key = wa_dd07v-domvalue_l.

      CASE value-key.

        WHEN 1.
          value-text = wa_dd07v-ddtext.
        WHEN OTHERS.
          value-text = wa_dd07v-ddtext.

      ENDCASE.
      APPEND value TO list.

    ENDLOOP.

    " Lista com os anos retroativos
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = name
        values = list.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTORIZACAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM autorizacao .

  AUTHORITY-CHECK OBJECT '/PTLOMS/10'
         ID 'TCD' FIELD sy-tcode
         ID 'ACTVT' FIELD '02'.

  IF sy-subrc <> 0.
    MESSAGE s001(/ptloms/cm001) WITH '/PTLOMS/10' DISPLAY LIKE 'E'.
    LEAVE PROGRAM.
  ENDIF.

ENDFORM.
