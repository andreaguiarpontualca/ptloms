FUNCTION /ptloms/mf054.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_TEXTO_LONGO) TYPE  STRING
*"  TABLES
*"      IT_TEXTO STRUCTURE  BAPI_ALM_TEXT_LINES
*"----------------------------------------------------------------------

* Declaração de tabela interna
  DATA: lt_status     TYPE TABLE OF string,
        lt_text_lines	TYPE STANDARD TABLE OF bapi_alm_text_lines.

* Declaração de estrutura
  DATA: ls_text_lines LIKE LINE OF lt_text_lines.

* Declaração de variáveis
  DATA: lv_quebra_linha TYPE string VALUE cl_abap_char_utilities=>newline,
        lv_tam          TYPE i,
        lv_tam2         TYPE i.

* Verifica se possui texto longo
  IF im_texto_longo IS INITIAL.
    RETURN.
  ENDIF.

  DATA ls_status LIKE LINE OF lt_status.
  DATA lv_field_count TYPE i.

  REFRESH lt_status[].
  SPLIT im_texto_longo  AT lv_quebra_linha INTO TABLE lt_status.
*  LOOP AT lt_status INTO DATA(ls_status).
  LOOP AT lt_status INTO ls_status.

*    DATA(lv_field_count) = strlen( ls_status ).
    lv_field_count = strlen( ls_status ).

    IF lv_field_count > 132.

*      DATA(lv_div) = lv_field_count DIV 132.
*      DATA(lv_mod) = lv_field_count MOD 132.
      DATA lv_div   TYPE i.
      DATA lv_mod   TYPE i.
      DATA lv_times TYPE i.
      DATA lv_index TYPE sy-index.

      lv_div = lv_field_count DIV 132.
      lv_mod = lv_field_count MOD 132.

      IF lv_mod = 0.
*        DATA(lv_times) = lv_div.
        lv_times = lv_div.
      ELSE.
        lv_times = lv_div + 1.
      ENDIF.

      lv_tam  = 0.
      lv_tam2 = 132.
      DO lv_times TIMES.
*        DATA(lv_index) = sy-index.
        lv_index = sy-index.
        IF lv_index = lv_times.
          IF lv_mod > 0.
            lv_tam2 = lv_tam2 - ( lv_tam2 - lv_mod ).
          ENDIF.
        ENDIF.

        CLEAR ls_text_lines.
*        ls_text_lines-tdformat = '*'.
        ls_text_lines-tdline   = ls_status+lv_tam(lv_tam2).
        APPEND ls_text_lines TO lt_text_lines.
        lv_tam = lv_tam + 132.
      ENDDO.

      CLEAR: lv_div, lv_mod, lv_times, lv_tam, lv_tam2.

    ELSE.

      CLEAR ls_text_lines.
      ls_text_lines-tdformat = '*'.
      ls_text_lines-tdline   = ls_status.
      APPEND ls_text_lines TO lt_text_lines.
    ENDIF.
  ENDLOOP.

  IF lt_text_lines[] IS NOT INITIAL.
    APPEND LINES OF lt_text_lines TO it_texto.
  ENDIF.

ENDFUNCTION.
