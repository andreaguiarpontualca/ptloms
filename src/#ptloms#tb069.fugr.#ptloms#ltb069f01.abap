*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************

*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LTB069F01.
*----------------------------------------------------------------------*

FORM f_get_next_number.

  DATA:
    lv_new_number TYPE /ptloms/tb069-id,
    lv_subrc      TYPE sy-subrc.

*---------------------------------------------------------------------*
* Dados de criação: preencher somente uma vez
*---------------------------------------------------------------------*
  IF /ptloms/tb069-ernam IS INITIAL.
    /ptloms/tb069-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb069-erdat IS INITIAL.
    /ptloms/tb069-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb069-erzeit IS INITIAL.
    /ptloms/tb069-erzeit = sy-uzeit.
  ENDIF.

*---------------------------------------------------------------------*
* Dados da última alteração
*---------------------------------------------------------------------*
  /ptloms/tb069-aenam  = sy-uname.
  /ptloms/tb069-aedat  = sy-datum.
  /ptloms/tb069-aezeit = sy-uzeit.

*---------------------------------------------------------------------*
* Gerar o número somente quando o ID ainda estiver vazio
*---------------------------------------------------------------------*
  IF /ptloms/tb069-id IS INITIAL.

    CLEAR lv_new_number.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = '/PTLOMS/ID'
      IMPORTING
        number                  = lv_new_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    lv_subrc = sy-subrc.

    IF lv_subrc = 0.

      /ptloms/tb069-id = lv_new_number.

    ELSE.

      vim_abort_saving = 'X'.

      CASE lv_subrc.

        WHEN 1.
          MESSAGE s000(su)
            WITH 'Intervalo 01 não encontrado'
                 'para o objeto /PTLOMS/ID.'
            DISPLAY LIKE 'E'.

        WHEN 2.
          MESSAGE s000(su)
            WITH 'Intervalo 01 do objeto'
                 '/PTLOMS/ID não é interno.'
            DISPLAY LIKE 'E'.

        WHEN 3.
          MESSAGE s000(su)
            WITH 'Objeto de numeração'
                 '/PTLOMS/ID não encontrado.'
            DISPLAY LIKE 'E'.

        WHEN 6.
          MESSAGE s000(su)
            WITH 'Intervalo 01 do objeto'
                 '/PTLOMS/ID está esgotado.'
            DISPLAY LIKE 'E'.

        WHEN 7.
          MESSAGE s000(su)
            WITH 'Erro no buffer do objeto'
                 '/PTLOMS/ID.'
            DISPLAY LIKE 'E'.

        WHEN OTHERS.
          MESSAGE s000(su)
            WITH 'Erro ao gerar número'
                 'para o objeto /PTLOMS/ID.'
            DISPLAY LIKE 'E'.

      ENDCASE.

    ENDIF.

  ENDIF.

ENDFORM.


FORM f_check_chave_estrangeira.

  FIELD-SYMBOLS:
    <lfs_field> TYPE any.

  DATA:
    lwa_row  TYPE /ptloms/tb069,
    ls_tb070 TYPE /ptloms/tb070,
    ls_tb071 TYPE /ptloms/tb071,
    ls_tb072 TYPE /ptloms/tb072,
    ls_tb073 TYPE /ptloms/tb073,
    ls_tb074 TYPE /ptloms/tb074,
    ls_tb075 TYPE /ptloms/tb075,
    lv_msg   TYPE c LENGTH 255.

  LOOP AT total.

    CLEAR lwa_row.

    IF <vim_total_struc> IS NOT ASSIGNED.
      CONTINUE.
    ENDIF.

    MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*---------------------------------------------------------------------*
* Preencher dados de criação
*---------------------------------------------------------------------*
    IF <action> = 'N' OR <action> = 'I'.

      UNASSIGN <lfs_field>.

      ASSIGN COMPONENT 'ERNAM'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        IF <lfs_field> IS INITIAL.
          <lfs_field> = sy-uname.
        ENDIF.
      ENDIF.

      UNASSIGN <lfs_field>.

      ASSIGN COMPONENT 'ERDAT'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        IF <lfs_field> IS INITIAL.
          <lfs_field> = sy-datum.
        ENDIF.
      ENDIF.

      UNASSIGN <lfs_field>.

      ASSIGN COMPONENT 'ERZEIT'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        IF <lfs_field> IS INITIAL.
          <lfs_field> = sy-uzeit.
        ENDIF.
      ENDIF.

    ENDIF.

*---------------------------------------------------------------------*
* Atualizar dados da última alteração
*---------------------------------------------------------------------*
    IF <action> = 'U'
       OR <action> = 'N'
       OR <action> = 'I'.

      UNASSIGN <lfs_field>.

      ASSIGN COMPONENT 'AENAM'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        <lfs_field> = sy-uname.
      ENDIF.

      UNASSIGN <lfs_field>.

      ASSIGN COMPONENT 'AEDAT'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        <lfs_field> = sy-datum.
      ENDIF.

      UNASSIGN <lfs_field>.

      ASSIGN COMPONENT 'AEZEIT'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        <lfs_field> = sy-uzeit.
      ENDIF.

*     Atualizar a linha correspondente de EXTRACT
      READ TABLE extract WITH KEY <vim_xtotal_key>.

      IF sy-subrc = 0.
        extract = total.
        MODIFY extract INDEX sy-tabix.
      ENDIF.

*     Atualizar a linha atual de TOTAL
      MODIFY total.

*     Recarregar a estrutura após atualizar a auditoria
      CLEAR lwa_row.
      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

    ENDIF.

*---------------------------------------------------------------------*
* Validar exclusão
*---------------------------------------------------------------------*
    IF <action> = 'D'.

      CLEAR ls_tb070.

      SELECT SINGLE *
        INTO ls_tb070
        FROM /ptloms/tb070
        WHERE aplicacao = lwa_row-id.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        PERFORM f_message_delete_error
          USING lwa_row-id
                lwa_row-descricao
                '/PTLOMS/TB070'.

        EXIT.

      ENDIF.

      CLEAR ls_tb071.

      SELECT SINGLE *
        INTO ls_tb071
        FROM /ptloms/tb071
        WHERE aplicacao = lwa_row-id.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        PERFORM f_message_delete_error
          USING lwa_row-id
                lwa_row-descricao
                '/PTLOMS/TB071'.

        EXIT.

      ENDIF.

      CLEAR ls_tb072.

      SELECT SINGLE *
        INTO ls_tb072
        FROM /ptloms/tb072
        WHERE aplicacao = lwa_row-id.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        PERFORM f_message_delete_error
          USING lwa_row-id
                lwa_row-descricao
                '/PTLOMS/TB072'.

        EXIT.

      ENDIF.

      CLEAR ls_tb073.

      SELECT SINGLE *
        INTO ls_tb073
        FROM /ptloms/tb073
        WHERE aplicacao = lwa_row-id.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        PERFORM f_message_delete_error
          USING lwa_row-id
                lwa_row-descricao
                '/PTLOMS/TB073'.

        EXIT.

      ENDIF.

      CLEAR ls_tb074.

      SELECT SINGLE *
        INTO ls_tb074
        FROM /ptloms/tb074
        WHERE aplicacao = lwa_row-id.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        PERFORM f_message_delete_error
          USING lwa_row-id
                lwa_row-descricao
                '/PTLOMS/TB074'.

        EXIT.

      ENDIF.

      CLEAR ls_tb075.

      SELECT SINGLE *
        INTO ls_tb075
        FROM /ptloms/tb075
        WHERE aplicacao = lwa_row-id.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        PERFORM f_message_delete_error
          USING lwa_row-id
                lwa_row-descricao
                '/PTLOMS/TB075'.

        EXIT.

      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.


FORM f_message_delete_error
  USING
    pv_id        TYPE /ptloms/tb069-id
    pv_descricao TYPE /ptloms/tb069-descricao
    pv_tabela    TYPE c.

  DATA:
    lv_registro TYPE c LENGTH 255.

  CLEAR lv_registro.

  CONCATENATE
    pv_id
    pv_descricao
    INTO lv_registro
    SEPARATED BY '/'.

  MESSAGE s000(su)
    WITH 'Registro'
         lv_registro
         'já utilizado em'
         pv_tabela
    DISPLAY LIKE 'E'.

ENDFORM.
****----------------------------------------------------------------------*
******INCLUDE /PTLOMS/LTB069F01.
****----------------------------------------------------------------------*
***
***FORM f_get_next_number.
***
***  FIELD-SYMBOLS: <lfs_field>,
***                 <lfsw_total>.
***
***  DATA: lwa_row        TYPE /ptloms/tb069.
***  DATA: lv_msg         TYPE c LENGTH 50.
***
***  DATA: lv_new_number TYPE numc10. " Use the data type that matches your table field and SNRO definition
***
***  " Call the function module to get the next number from the number range object
***
***  /ptloms/tb069-ernam = sy-uname.
***  /ptloms/tb069-erdat = sy-datum.
***  /ptloms/tb069-erzeit = sy-uzeit.
***
***  /ptloms/tb069-aenam = sy-uname.
***  /ptloms/tb069-aedat = sy-datum.
***  /ptloms/tb069-aezeit = sy-uzeit.
***
***  CALL FUNCTION 'NUMBER_GET_NEXT'
***    EXPORTING
***      nr_range_nr             = '01'            " The interval number you created
***      object                  = '/PTLOMS/ID'    " The SNRO object name you created
***    IMPORTING
***      number                  = lv_new_number
***    EXCEPTIONS
***      interval_not_found      = 1
***      number_range_not_intern = 2
***      object_not_found        = 3
***      quantity_is_0           = 4
***      quantity_is_not_1       = 5
***      interval_overflow       = 6
***      buffer_overflow         = 7
***      OTHERS                  = 8.
***
***  IF sy-subrc IS INITIAL.
***    /ptloms/tb069-id = lv_new_number.
***    " Assign the obtained number to the relevant field of your table
***    " The structure name will typically be <view/table name>-<field name> <view/table name>-<field name> = lv_new_number.
***  ENDIF.
***
***ENDFORM.
***
***FORM f_check_chave_estrangeira.
***
***  FIELD-SYMBOLS: <lfs_field>,
***                 <lfsw_total>.
***
***  DATA: lwa_row        TYPE /ptloms/tb069.
****  DATA: lt_tb103_novos TYPE STANDARD TABLE OF /ptlgmr/tb103.
***  DATA: lv_msg         TYPE c LENGTH 50.
***
***  SELECT *
***    FROM /ptloms/tb069
***    INTO TABLE @DATA(lt_tb069).
***
***  LOOP AT total.
***
***    CLEAR:
***      lwa_row.
***
***    IF <vim_total_struc> IS ASSIGNED.
***
***      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.
***
***    ENDIF.
***
***    IF lwa_row-ernam IS INITIAL.
***      lwa_row-ernam = sy-uname.
***    ENDIF.
***
***    IF <action> = 'U' OR <action> = 'I'.
***      ASSIGN COMPONENT 'AENAM' OF STRUCTURE <vim_total_struc> TO <lfs_field>.
***      IF sy-subrc = 0.
***        <lfs_field> = sy-uname.
***      ENDIF.
***      ASSIGN COMPONENT 'AEDAT' OF STRUCTURE <vim_total_struc> TO <lfs_field>.
***      IF sy-subrc = 0.
***        <lfs_field> = sy-datum.
***      ENDIF.
***      ASSIGN COMPONENT 'AEZEIT' OF STRUCTURE <vim_total_struc> TO <lfs_field>.
***      IF sy-subrc = 0.
***        <lfs_field> = sy-uzeit.
***      ENDIF.
***
***      "Atualiza os dados na tela
***      READ TABLE extract WITH KEY <vim_xtotal_key>.
***      IF sy-subrc EQ 0.
***        extract = total.
***        MODIFY extract INDEX sy-tabix.
***      ENDIF.
***      MODIFY total.
***    ENDIF.
***
****    --- registro removido
***    IF <action> = 'D'.
***
***      SELECT SINGLE *
***        FROM /ptloms/tb070
***        INTO @DATA(ls_tb070)
***        WHERE aplicacao = @lwa_row-id.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR: lv_msg.
***        lv_msg = lwa_row-id && '/' && lwa_row-descricao.
***        MESSAGE s000(su) WITH 'Registro' lv_msg 'já utilizado na tab /ptloms/tb070'
***                              'Não é possível removê-lo.'
***                               DISPLAY LIKE 'E'.
***        EXIT.
***      ENDIF.
***
***      SELECT SINGLE *
***        FROM /ptloms/tb071
***        INTO @DATA(ls_tb071)
***        WHERE aplicacao = @lwa_row-id.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
***        lv_msg = lwa_row-id && '/' && lwa_row-descricao.
***        MESSAGE s000(su) WITH 'Registro' lv_msg 'já utilizado na tab /ptloms/tb071'
***                              'Não é possível removê-lo.'
***                               DISPLAY LIKE 'E'.
***        EXIT.
***      ENDIF.
***
***      SELECT SINGLE *
***        FROM /ptloms/tb072
***        INTO @DATA(ls_tb072)
***        WHERE aplicacao = @lwa_row-id.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
***        lv_msg = lwa_row-id && '/' && lwa_row-descricao.
***        MESSAGE s000(su) WITH 'Registro' lv_msg 'já utilizado na tab /ptloms/tb072'
***                              'Não é possível removê-lo.'
***                               DISPLAY LIKE 'E'.
***        EXIT.
***      ENDIF.
***
***      SELECT SINGLE *
***        FROM /ptloms/tb073
***        INTO @DATA(ls_tb073)
***        WHERE aplicacao = @lwa_row-id.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
***        lv_msg = lwa_row-id && '/' && lwa_row-descricao.
***        MESSAGE s000(su) WITH 'Registro' lv_msg 'já utilizado na tab /ptloms/tb073'
***                              'Não é possível removê-lo.'
***                               DISPLAY LIKE 'E'.
***        EXIT.
***      ENDIF.
***
***      SELECT SINGLE *
***        FROM /ptloms/tb074
***        INTO @DATA(ls_tb074)
***        WHERE aplicacao = @lwa_row-id.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
***        lv_msg = lwa_row-id && '/' && lwa_row-descricao.
***        MESSAGE s000(su) WITH 'Registro' lv_msg 'já utilizado na tab /ptloms/tb074'
***                              'Não é possível removê-lo.'
***                               DISPLAY LIKE 'E'.
***        EXIT.
***      ENDIF.
***
***      SELECT SINGLE *
***        FROM /ptloms/tb075
***        INTO @DATA(ls_tb075)
***        WHERE aplicacao = @lwa_row-id.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
***        lv_msg = lwa_row-id && '/' && lwa_row-descricao.
***        MESSAGE s000(su) WITH 'Registro' lv_msg 'já utilizado na tab /ptloms/tb075'
***                              'Não é possível removê-lo.'
***                               DISPLAY LIKE 'E'.
***        EXIT.
***      ENDIF.
***
***    ENDIF.
***
***  ENDLOOP.
***
***ENDFORM.


*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
