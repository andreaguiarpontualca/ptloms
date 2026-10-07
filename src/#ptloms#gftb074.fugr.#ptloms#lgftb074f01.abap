*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************

*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB074F01.
*----------------------------------------------------------------------*

FORM f_get_next_number.

  DATA:
    lv_new_number TYPE /ptloms/tb074-sequencial,
    lv_subrc      TYPE sy-subrc.

*---------------------------------------------------------------------*
* Preencher dados de criação somente quando estiverem vazios
*---------------------------------------------------------------------*
  IF /ptloms/tb074-ernam IS INITIAL.
    /ptloms/tb074-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb074-erdat IS INITIAL.
    /ptloms/tb074-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb074-erzeit IS INITIAL.
    /ptloms/tb074-erzeit = sy-uzeit.
  ENDIF.

*---------------------------------------------------------------------*
* Atualizar dados da última alteração
*---------------------------------------------------------------------*
  /ptloms/tb074-aenam  = sy-uname.
  /ptloms/tb074-aedat  = sy-datum.
  /ptloms/tb074-aezeit = sy-uzeit.

*---------------------------------------------------------------------*
* Buscar próximo número somente quando ainda não estiver preenchido
*---------------------------------------------------------------------*
  IF /ptloms/tb074-sequencial IS INITIAL.

    CLEAR lv_new_number.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = '/PTLOMS/SQ'
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

      /ptloms/tb074-sequencial = lv_new_number.

    ELSE.

      vim_abort_saving = 'X'.

      CASE lv_subrc.

        WHEN 1.
          MESSAGE s000(su)
            WITH 'Intervalo 01 não encontrado'
                 'para o objeto /PTLOMS/SQ.'
            DISPLAY LIKE 'E'.

        WHEN 2.
          MESSAGE s000(su)
            WITH 'O intervalo 01 de /PTLOMS/SQ'
                 'não é interno.'
            DISPLAY LIKE 'E'.

        WHEN 3.
          MESSAGE s000(su)
            WITH 'Objeto de numeração'
                 '/PTLOMS/SQ não encontrado.'
            DISPLAY LIKE 'E'.

        WHEN 6.
          MESSAGE s000(su)
            WITH 'Intervalo 01 de /PTLOMS/SQ'
                 'está esgotado.'
            DISPLAY LIKE 'E'.

        WHEN OTHERS.
          MESSAGE s000(su)
            WITH 'Erro ao gerar número'
                 'para o objeto /PTLOMS/SQ.'
            DISPLAY LIKE 'E'.

      ENDCASE.

    ENDIF.

  ENDIF.

ENDFORM.


FORM f_check_chave_estrangeira.

  FIELD-SYMBOLS:
    <lfs_field> TYPE any.

  DATA:
    lwa_row TYPE /ptloms/tb074.

  LOOP AT total.

    CLEAR lwa_row.

    IF <vim_total_struc> IS NOT ASSIGNED.
      CONTINUE.
    ENDIF.

    MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*---------------------------------------------------------------------*
* Preencher os dados de criação
*
* No TMG, uma nova linha normalmente possui ACTION = 'N'.
* A condição com 'I' foi mantida por segurança até confirmar no debug.
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
* Preencher os dados da última alteração
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

*---------------------------------------------------------------------*
* Atualizar os dados nas tabelas internas do TMG
*---------------------------------------------------------------------*
      READ TABLE extract WITH KEY <vim_xtotal_key>.

      IF sy-subrc = 0.
        extract = total.
        MODIFY extract INDEX sy-tabix.
      ENDIF.

      MODIFY total.

    ENDIF.

*---------------------------------------------------------------------*
* Nenhuma validação de exclusão está ativa
*---------------------------------------------------------------------*
    IF <action> = 'D'.

*     A validação com /PTLOMS/TB075 permanece desativada porque
*     essa tabela está sendo considerada como histórico.

    ENDIF.

  ENDLOOP.

ENDFORM.
****----------------------------------------------------------------------*
******INCLUDE /PTLOMS/LGFTB074F01.
****----------------------------------------------------------------------*
***FORM f_get_next_number.
***
****  FIELD-SYMBOLS: <lfs_field>,
****                 <lfsw_total>.
***
***  DATA: lwa_row        TYPE /ptloms/tb074.
***  DATA: lv_msg         TYPE c LENGTH 50.
***
***  DATA: lv_new_number TYPE numc10. " Use the data type that matches your table field and SNRO definition
***
***  " Call the function module to get the next number from the number range object
***
***  /ptloms/tb074-ernam = sy-uname.
***  /ptloms/tb074-erdat = sy-datum.
***  /ptloms/tb074-erzeit = sy-uzeit.
***
***  /ptloms/tb074-aenam = sy-uname.
***  /ptloms/tb074-aedat = sy-datum.
***  /ptloms/tb074-aezeit = sy-uzeit.
***
***  CALL FUNCTION 'NUMBER_GET_NEXT'
***    EXPORTING
***      nr_range_nr             = '01'            " The interval number you created
***      object                  = '/PTLOMS/SQ'    " The SNRO object name you created
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
***    /ptloms/tb074-sequencial = lv_new_number.
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
***  DATA: lwa_row        TYPE /ptloms/tb074.
****  DATA: lt_tb103_novos TYPE STANDARD TABLE OF /ptlgmr/tb103.
***  DATA: lv_msg         TYPE c LENGTH 50.
***
***  SELECT *
***    FROM /ptloms/tb074
***    INTO TABLE @DATA(lt_tb074).
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
**** Comentado para considerar a TB075 como histórico
****      SELECT SINGLE *
****        FROM /ptloms/tb075
****        INTO @DATA(ls_tb075)
****        WHERE aplicacao = @lwa_row-aplicacao
****          AND opcao = @lwa_row-opcao.
****
****      IF sy-subrc EQ 0.
****        vim_abort_saving = 'X'.
****        CLEAR:
****          lv_msg.
****        lv_msg = lwa_row-aplicacao && '/' && lwa_row-opcao.
****        MESSAGE s000(su) WITH 'Aplicação/Opção' lv_msg 'já utilizados na tab /ptloms/tb075.'
****                              'Não é possível removê-lo.'
****                               DISPLAY LIKE 'E'.
****        EXIT.
****
****      ENDIF.
***
***    ENDIF.
***
***  ENDLOOP.
***
***ENDFORM.


*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
