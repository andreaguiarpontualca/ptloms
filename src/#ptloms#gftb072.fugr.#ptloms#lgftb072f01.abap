*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB072F01.
*----------------------------------------------------------------------*
FORM f_check_chave_estrangeira.

  FIELD-SYMBOLS: <lfs_field>,
                 <lfsw_total>.

  DATA: lwa_row        TYPE /ptloms/tb072.
  DATA: lv_msg         TYPE c LENGTH 255.

  SELECT *
    FROM /ptloms/tb072
    INTO TABLE @DATA(lt_tb072).

  LOOP AT total.

    CLEAR:
      lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

    ENDIF.

    IF lwa_row-ernam IS INITIAL.
      lwa_row-ernam = sy-uname.
    ENDIF.

    IF <action> = 'U' OR <action> = 'I'.
      ASSIGN COMPONENT 'AENAM' OF STRUCTURE <vim_total_struc> TO <lfs_field>.
      IF sy-subrc = 0.
        <lfs_field> = sy-uname.
      ENDIF.
      ASSIGN COMPONENT 'AEDAT' OF STRUCTURE <vim_total_struc> TO <lfs_field>.
      IF sy-subrc = 0.
        <lfs_field> = sy-datum.
      ENDIF.
      ASSIGN COMPONENT 'AEZEIT' OF STRUCTURE <vim_total_struc> TO <lfs_field>.
      IF sy-subrc = 0.
        <lfs_field> = sy-uzeit.
      ENDIF.

      "Atualiza os dados na tela
      READ TABLE extract WITH KEY <vim_xtotal_key>.
      IF sy-subrc EQ 0.
        extract = total.
        MODIFY extract INDEX sy-tabix.
      ENDIF.
      MODIFY total.
    ENDIF.

*    --- registro removido
    IF <action> = 'D'.

      SELECT SINGLE *
        FROM /ptloms/tb074
        INTO @DATA(ls_tb074)
        WHERE aplicacao  = @lwa_row-aplicacao
          and opcao = @lwa_row-opcao.

      IF sy-subrc EQ 0.
        vim_abort_saving = 'X'.
        CLEAR:
          lv_msg.
        CONCATENATE 'Aplicação/Opção' lwa_row-aplicacao lwa_row-opcao into lv_msg SEPARATED BY space.
        MESSAGE s000(su) WITH lv_msg
                              'já utilizados na tab /ptloms/tb074'
                              'Não é possível removê-los.'
                              DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.

FORM f_upd_user_date_time.

  FIELD-SYMBOLS: <lfs_field>,
                 <lfsw_total>.

  DATA: lwa_row        TYPE /ptloms/tb072.

  /ptloms/tb072-ernam = sy-uname.
  /ptloms/tb072-erdat = sy-datum.
  /ptloms/tb072-erzeit = sy-uzeit.

  /ptloms/tb072-aenam = sy-uname.
  /ptloms/tb072-aedat = sy-datum.
  /ptloms/tb072-aezeit = sy-uzeit.

ENDFORM.
