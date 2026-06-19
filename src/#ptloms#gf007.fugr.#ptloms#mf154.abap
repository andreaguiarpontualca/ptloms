FUNCTION /ptloms/mf154.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_PSTNG_DATE) TYPE  DATUM
*"     VALUE(IV_TESTRUN) TYPE  FLAG
*"     VALUE(IT_BAIXA) TYPE  /PTLOMS/CT171
*"  EXPORTING
*"     VALUE(ET_DADOS) TYPE  /PTLOMS/CT171
*"     VALUE(ET_RETURN) TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: lt_baixa_reserva    TYPE STANDARD TABLE OF /ptloms/et201,
        lt_baixa_item       TYPE STANDARD TABLE OF /ptloms/et201,
        lt_return_bapi      TYPE bapiret2_t,
        ls_baixa            TYPE /ptloms/et201,
        ls_item_grupo       TYPE /ptloms/et201,
        ls_item_retorno     LIKE LINE OF et_dados,
        ls_return_bapi      TYPE bapiret2,
        ls_return_060       TYPE /ptloms/et060,
        lv_rsnum            TYPE resb-rsnum,
        lv_rsnum_ant        TYPE resb-rsnum,
        lv_materialdocument TYPE mblnr,
        lv_matdocumentyear  TYPE mjahr,
        lv_has_error        TYPE abap_bool,
        lv_message          TYPE bapi_msg.

  CLEAR: et_return,
         et_dados.

  IF it_baixa IS INITIAL.

    CLEAR ls_return_060.
    ls_return_060-chave     = 'R'.
    ls_return_060-type      = 'E'.
    ls_return_060-id        = 'ZPM'.
    ls_return_060-number    = '001'.
    ls_return_060-message   = 'Nenhum item informado para baixa de reserva.'.
    ls_return_060-type_desc = 'Erro'.
    APPEND ls_return_060 TO et_return.

    RETURN.

  ENDIF.

  lt_baixa_reserva[] = it_baixa[].

  SORT lt_baixa_reserva BY rsnum rspos.

  CLEAR et_dados.

  LOOP AT lt_baixa_reserva INTO ls_baixa.

    CLEAR ls_item_retorno.
    MOVE-CORRESPONDING ls_baixa TO ls_item_retorno.

    IF ls_item_retorno-status IS INITIAL.
      ls_item_retorno-status = 'P'.
    ENDIF.

    APPEND ls_item_retorno TO et_dados.

  ENDLOOP.

  DELETE lt_baixa_reserva WHERE rsnum IS INITIAL
                              OR rspos IS INITIAL
                              OR menge IS INITIAL
                              OR menge <= 0.

  IF lt_baixa_reserva IS INITIAL.

    CLEAR ls_return_060.
    ls_return_060-chave     = 'R'.
    ls_return_060-type      = 'E'.
    ls_return_060-id        = 'ZPM'.
    ls_return_060-number    = '002'.
    ls_return_060-message   = 'Nenhum item válido informado para baixa de reserva.'.
    ls_return_060-type_desc = 'Erro'.
    APPEND ls_return_060 TO et_return.

    LOOP AT et_dados INTO ls_item_retorno.

      ls_item_retorno-status = 'E'.

      MODIFY et_dados FROM ls_item_retorno TRANSPORTING status
        WHERE rsnum = ls_item_retorno-rsnum
          AND rspos = ls_item_retorno-rspos.

    ENDLOOP.

    RETURN.

  ENDIF.

  CLEAR lv_rsnum_ant.

  LOOP AT lt_baixa_reserva INTO ls_baixa.

    IF lv_rsnum_ant IS INITIAL
       OR lv_rsnum_ant <> ls_baixa-rsnum.

      lv_rsnum = ls_baixa-rsnum.

      CLEAR: lt_baixa_item,
             lt_return_bapi,
             lv_materialdocument,
             lv_matdocumentyear,
             lv_has_error.

      LOOP AT lt_baixa_reserva INTO ls_item_grupo
        WHERE rsnum = lv_rsnum.

        APPEND ls_item_grupo TO lt_baixa_item.

      ENDLOOP.

      CALL METHOD /ptloms/cl013=>baixa_reserva_pm
        EXPORTING
          iv_rsnum            = lv_rsnum
          it_baixa            = lt_baixa_item
          iv_pstng_date       = iv_pstng_date
          iv_testrun          = iv_testrun
        IMPORTING
          ev_materialdocument = lv_materialdocument
          ev_matdocumentyear  = lv_matdocumentyear
          et_return           = lt_return_bapi.

      LOOP AT lt_return_bapi INTO ls_return_bapi.

        CLEAR ls_return_060.
        CLEAR ls_item_grupo.

        MOVE-CORRESPONDING ls_return_bapi TO ls_return_060.

        ls_return_060-chave = 'R'.

        IF ls_return_bapi-row IS NOT INITIAL.

          READ TABLE lt_baixa_item INTO ls_item_grupo INDEX ls_return_bapi-row.

        ENDIF.

        IF ls_item_grupo-rsnum IS INITIAL.

          READ TABLE lt_baixa_item INTO ls_item_grupo INDEX 1.

        ENDIF.

        IF ls_item_grupo-rsnum IS NOT INITIAL.

          ls_return_060-parameter  = ls_return_bapi-parameter.
          ls_return_060-row        = ls_return_bapi-row.
          ls_return_060-field      = ls_return_bapi-field.

          ls_return_060-message_v1 = ls_item_grupo-rsnum.
          ls_return_060-message_v2 = ls_item_grupo-rspos.
          ls_return_060-message_v3 = ls_item_grupo-orderid.
          ls_return_060-message_v4 = ls_item_grupo-activity.

          CONCATENATE 'Reserva'
                      ls_item_grupo-rsnum
                      'Item'
                      ls_item_grupo-rspos
                      'Ordem'
                      ls_item_grupo-orderid
                      'Operação'
                      ls_item_grupo-activity
                      '-'
                      ls_return_bapi-message
                 INTO ls_return_060-message
                 SEPARATED BY space.

        ELSE.

          ls_return_060-message_v1 = lv_rsnum.

        ENDIF.

        CASE ls_return_060-type.
          WHEN 'S'.
            ls_return_060-type_desc = 'Sucesso'.

          WHEN 'E' OR 'A' OR 'X'.
            ls_return_060-type_desc = 'Erro'.
            lv_has_error = abap_true.

            IF ls_return_bapi-row IS NOT INITIAL
               AND ls_item_grupo-rsnum IS NOT INITIAL
               AND ls_item_grupo-rspos IS NOT INITIAL.

              LOOP AT et_dados INTO ls_item_retorno
                WHERE rsnum = ls_item_grupo-rsnum
                  AND rspos = ls_item_grupo-rspos.

                ls_item_retorno-status = 'E'.

                MODIFY et_dados FROM ls_item_retorno TRANSPORTING status
                  WHERE rsnum = ls_item_retorno-rsnum
                    AND rspos = ls_item_retorno-rspos.

              ENDLOOP.

            ELSE.

              LOOP AT et_dados INTO ls_item_retorno
                WHERE rsnum = lv_rsnum.

                ls_item_retorno-status = 'E'.

                MODIFY et_dados FROM ls_item_retorno TRANSPORTING status
                  WHERE rsnum = ls_item_retorno-rsnum
                    AND rspos = ls_item_retorno-rspos.

              ENDLOOP.

            ENDIF.

          WHEN 'W'.
            ls_return_060-type_desc = 'Aviso'.

          WHEN 'I'.
            ls_return_060-type_desc = 'Informação'.

          WHEN OTHERS.
            ls_return_060-type_desc = 'Informação'.

        ENDCASE.

        APPEND ls_return_060 TO et_return.

      ENDLOOP.

      IF lv_has_error = abap_false
         AND lv_materialdocument IS NOT INITIAL
         AND lv_matdocumentyear IS NOT INITIAL.

        LOOP AT et_dados INTO ls_item_retorno
          WHERE rsnum = lv_rsnum
            AND status = 'P'.

          ls_item_retorno-status = 'S'.

          MODIFY et_dados FROM ls_item_retorno TRANSPORTING status
            WHERE rsnum = ls_item_retorno-rsnum
              AND rspos = ls_item_retorno-rspos.

        ENDLOOP.

        CLEAR: ls_return_060,
               lv_message.

        READ TABLE lt_baixa_item INTO ls_item_grupo INDEX 1.

        CONCATENATE 'Reserva'
                    lv_rsnum
                    'Ordem'
                    ls_item_grupo-orderid
                    'Operação'
                    ls_item_grupo-activity
                    ': documento de material'
                    lv_materialdocument
                    '/'
                    lv_matdocumentyear
                    'criado com sucesso.'
               INTO lv_message
               SEPARATED BY space.

        ls_return_060-chave      = 'R'.
        ls_return_060-type       = 'S'.
        ls_return_060-id         = 'ZPM'.
        ls_return_060-number     = '010'.
        ls_return_060-message    = lv_message.
        ls_return_060-message_v1 = lv_rsnum.
        ls_return_060-message_v2 = space.
        ls_return_060-message_v3 = ls_item_grupo-orderid.
        ls_return_060-message_v4 = ls_item_grupo-activity.
        ls_return_060-type_desc  = 'Sucesso'.

        APPEND ls_return_060 TO et_return.

      ELSEIF lv_has_error = abap_false
         AND iv_testrun = abap_true.

        LOOP AT et_dados INTO ls_item_retorno
          WHERE rsnum = lv_rsnum
            AND status = 'P'.

          ls_item_retorno-status = 'S'.

          MODIFY et_dados FROM ls_item_retorno TRANSPORTING status
            WHERE rsnum = ls_item_retorno-rsnum
              AND rspos = ls_item_retorno-rspos.

        ENDLOOP.

        CLEAR: ls_return_060,
               lv_message.

        READ TABLE lt_baixa_item INTO ls_item_grupo INDEX 1.

        CONCATENATE 'Reserva'
                    lv_rsnum
                    'Ordem'
                    ls_item_grupo-orderid
                    'Operação'
                    ls_item_grupo-activity
                    ': simulação executada sem erros.'
               INTO lv_message
               SEPARATED BY space.

        ls_return_060-chave      = 'R'.
        ls_return_060-type       = 'S'.
        ls_return_060-id         = 'ZPM'.
        ls_return_060-number     = '011'.
        ls_return_060-message    = lv_message.
        ls_return_060-message_v1 = lv_rsnum.
        ls_return_060-message_v2 = space.
        ls_return_060-message_v3 = ls_item_grupo-orderid.
        ls_return_060-message_v4 = ls_item_grupo-activity.
        ls_return_060-type_desc  = 'Sucesso'.

        APPEND ls_return_060 TO et_return.

      ENDIF.

      lv_rsnum_ant = lv_rsnum.

    ENDIF.

  ENDLOOP.

ENDFUNCTION.
