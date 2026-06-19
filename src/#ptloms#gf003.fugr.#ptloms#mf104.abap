FUNCTION /ptloms/mf104.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_ORDEM) TYPE  /PTLOMS/CT104
*"  EXPORTING
*"     VALUE(ET_ORDEM) TYPE  /PTLOMS/CT104
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

  DATA: lt_033        TYPE TABLE OF /ptloms/tb033.
  DATA: ls_033        LIKE LINE OF lt_033.

  DATA: lv_dt_inicio  TYPE char19.
  DATA: lv_dt_fim     TYPE char19.
  DATA: lv_data       TYPE char10.
  DATA: lv_hora       TYPE char8.

  DATA lv_index       TYPE i.

  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ls_033
    FROM  /ptloms/tb033.

  IF ls_033-cesto EQ 'X'.

    LOOP AT it_ordem INTO ls_ordem.
      lv_index = sy-tabix.

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
             WHERE  aufnr  = lv_aufnr
             AND    vornr  = lv_vornr
             AND    conf_final NE 'X'.

      IF sy-subrc IS INITIAL.

        CALL FUNCTION '/PTLOMS/MF103'
          EXPORTING
            i_aufnr      = lv_aufnr
            i_vornr      = lv_vornr
          IMPORTING
            e_confirmada = lv_confirmada.

        IF lv_confirmada IS INITIAL.

          CLEAR lt_031.

          SELECT * UP TO 1 ROWS
            INTO CORRESPONDING FIELDS OF TABLE lt_031
            FROM  /ptloms/tb031
                 WHERE  aufnr  = lv_aufnr
                 AND    vornr  = lv_vornr
                 AND    conf_final EQ 'X'
            ORDER BY data_fim hora_fim.

          READ TABLE lt_031 INTO ls_031 INDEX 1.

          IF sy-subrc IS INITIAL.

            ls_051-chave = 'X'.
            ls_051-orderid = ls_ordem-aufnr.
            ls_051-activity =  lv_vornr.
            ls_051-fin_conf = 'X'.
            ls_051-complete = 'X'.
            ls_051-act_work = 0.
            ls_051-un_work = 'H'.
            ls_051-usuario_mobile = ls_031-usuario.
            CONCATENATE ls_031-data_ini+6(2) '/' ls_031-data_ini+4(2) '/' ls_031-data_ini(4) INTO lv_data.
            CONCATENATE ls_031-hora_ini(2) ':' ls_031-hora_ini+2(2) ':' ls_031-hora_ini+4(2) INTO lv_hora.
            CONCATENATE lv_data lv_hora INTO lv_dt_inicio SEPARATED BY space.
            CLEAR: lv_data, lv_hora.
            CONCATENATE ls_031-data_fim+6(2) '/' ls_031-data_fim+4(2) '/' ls_031-data_fim(4) INTO lv_data.
            CONCATENATE ls_031-hora_fim(2) ':' ls_031-hora_fim+2(2) ':' ls_031-hora_fim+4(2) INTO lv_hora.
            CONCATENATE lv_data lv_hora INTO lv_dt_fim SEPARATED BY space.
            ls_051-data_hora_inicio = lv_dt_inicio.
            ls_051-data_hora_fim    = lv_dt_fim.

            CALL FUNCTION '/PTLOMS/MF011'
              EXPORTING
                wa_confirmacao        = ls_051
                it_texto_confirmacao  = lt_txt_conf
              IMPORTING
                it_return_confirmacao = lt_062.

            CALL FUNCTION '/PTLOMS/MF103'
              EXPORTING
                i_aufnr      = lv_aufnr
                i_vornr      = lv_vornr
              IMPORTING
                e_confirmada = lv_confirmada.

            IF lv_confirmada IS NOT INITIAL.

              ls_ordem-status_sis = 'I0009'.

              MODIFY it_ordem FROM ls_ordem INDEX lv_index.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

    et_ordem = it_ordem.

  ENDIF.

  et_ordem = it_ordem.

ENDFUNCTION.
