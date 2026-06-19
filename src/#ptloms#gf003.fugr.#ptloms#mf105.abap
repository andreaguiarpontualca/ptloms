FUNCTION /PTLOMS/MF105.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_ORDEM) TYPE  /PTLOMS/CT104
*"----------------------------------------------------------------------

  DATA: ls_ordem      LIKE LINE OF it_ordem.
  DATA: lv_confirmada TYPE char1.
  DATA: lt_031        TYPE TABLE OF /ptloms/tb031.
  DATA: ls_031        LIKE LINE OF lt_031.

  DATA: lv_aufnr      TYPE char12.
  DATA: lv_vornr      TYPE char4.

  DATA: ls_051        TYPE /ptloms/et051.
  DATA: lt_txt_conf   TYPE /ptloms/ct061.
  DATA: lt_062        TYPE /ptloms/ct062.

  LOOP AT it_ordem INTO ls_ordem.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_ordem-aufnr
      IMPORTING
        output = lv_aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_ordem-vornr
      IMPORTING
        output = lv_vornr.

    SELECT        *
      INTO CORRESPONDING FIELDS OF TABLE lt_031
      FROM  /ptloms/tb031
           WHERE  aufnr  = ls_ordem-aufnr
           AND    vornr  = ls_ordem-vornr
           AND    conf_final NE 'X'.

    IF sy-subrc IS NOT INITIAL.

      CALL FUNCTION '/PTLOMS/MF103'
        EXPORTING
          i_aufnr      = ls_ordem-aufnr
          i_vornr      = ls_ordem-vornr
        IMPORTING
          e_confirmada = lv_confirmada.

      IF lv_confirmada EQ 'X'.

        CALL FUNCTION '/PTLOMS/MF011'
          EXPORTING
            wa_confirmacao        = ls_051
            it_texto_confirmacao  = lt_txt_conf
          IMPORTING
            it_return_confirmacao = lt_062.

      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFUNCTION.
