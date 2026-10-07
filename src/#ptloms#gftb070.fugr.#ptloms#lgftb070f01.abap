*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************
*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB070F01.
*----------------------------------------------------------------------*

FORM f_check_chave_estrangeira.

  FIELD-SYMBOLS:
    <lfs_field> TYPE any.

  DATA:
    lwa_row  TYPE /ptloms/tb070,
    ls_tb071 TYPE /ptloms/tb071,
    ls_tb075 TYPE /ptloms/tb075.

  LOOP AT total.

    CLEAR lwa_row.

    IF <vim_total_struc> IS NOT ASSIGNED.
      CONTINUE.
    ENDIF.

    MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*---------------------------------------------------------------------*
* Preencher campos de auditoria
*---------------------------------------------------------------------*
    IF <action> = 'I'.

*     Usuário de criação
      ASSIGN COMPONENT 'ERNAM'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        IF <lfs_field> IS INITIAL.
          <lfs_field> = sy-uname.
        ENDIF.
      ENDIF.

*     Data de criação
      UNASSIGN <lfs_field>.

      ASSIGN COMPONENT 'ERDAT'
        OF STRUCTURE <vim_total_struc>
        TO <lfs_field>.

      IF sy-subrc = 0.
        IF <lfs_field> IS INITIAL.
          <lfs_field> = sy-datum.
        ENDIF.
      ENDIF.

*     Hora de criação
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
* Campos de última alteração
*---------------------------------------------------------------------*
    IF <action> = 'U' OR <action> = 'I'.

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

*     Recarregar estrutura auxiliar após atualizar a estrutura VIM
      CLEAR lwa_row.
      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*     Atualizar tabela de exibição
      READ TABLE extract WITH KEY <vim_xtotal_key>.

      IF sy-subrc = 0.
        extract = total.
        MODIFY extract INDEX sy-tabix.
      ENDIF.

*     Atualizar linha atual da tabela TOTAL
      MODIFY total.

    ENDIF.

*---------------------------------------------------------------------*
* Validar remoção do registro
*---------------------------------------------------------------------*
    IF <action> = 'D'.

      CLEAR ls_tb071.

      SELECT SINGLE aplicacao
                    formulario
        INTO CORRESPONDING FIELDS OF ls_tb071
        FROM /ptloms/tb071
        WHERE aplicacao  = lwa_row-aplicacao
          AND formulario = lwa_row-formulario.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        MESSAGE s000(su)
          WITH 'Formulário'
               lwa_row-formulario
               'já utilizado na tab /PTLOMS/TB071'
               'Não é possível removê-lo.'
          DISPLAY LIKE 'E'.

        EXIT.

      ENDIF.

      CLEAR ls_tb075.

      SELECT SINGLE aplicacao
                    formulario
        INTO CORRESPONDING FIELDS OF ls_tb075
        FROM /ptloms/tb075
        WHERE aplicacao  = lwa_row-aplicacao
          AND formulario = lwa_row-formulario.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        MESSAGE s000(su)
          WITH 'Formulário'
               lwa_row-formulario
               'já utilizado na tab /PTLOMS/TB075'
               'Não é possível removê-lo.'
          DISPLAY LIKE 'E'.

        EXIT.

      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.

FORM f_upd_user_date_time.

*---------------------------------------------------------------------*
* Dados de criação: preencher somente quando estiverem vazios
*---------------------------------------------------------------------*
  IF /ptloms/tb070-ernam IS INITIAL.
    /ptloms/tb070-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb070-erdat IS INITIAL.
    /ptloms/tb070-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb070-erzeit IS INITIAL.
    /ptloms/tb070-erzeit = sy-uzeit.
  ENDIF.

*---------------------------------------------------------------------*
* Dados de alteração: atualizar sempre
*---------------------------------------------------------------------*
  /ptloms/tb070-aenam  = sy-uname.
  /ptloms/tb070-aedat  = sy-datum.
  /ptloms/tb070-aezeit = sy-uzeit.

ENDFORM.

****----------------------------------------------------------------------*
******INCLUDE /PTLOMS/LGFTB070F01.
****----------------------------------------------------------------------*
***FORM f_check_chave_estrangeira.
***
***  FIELD-SYMBOLS: <lfs_field>,
***                 <lfsw_total>.
***
***  DATA: lwa_row        TYPE /ptloms/tb070.
***  DATA: lv_msg         TYPE c LENGTH 255.
***
***  SELECT *
***    FROM /ptloms/tb070
***    INTO TABLE @DATA(lt_tb070).
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
***        FROM /ptloms/tb071
***        INTO @DATA(ls_tb071)
***        WHERE aplicacao  = @lwa_row-aplicacao
***          and formulario = @lwa_row-formulario.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
****        lv_msg = lwa_row-id_form && '/' && lwa_row-desc_form  .
***        MESSAGE s000(su) WITH 'Formulário' lwa_row-formulario 'já utilizado na tab /ptloms/tb071'
***                              'Não é possível removê-lo.'
***                               DISPLAY LIKE 'E'.
***        EXIT.
***      ENDIF.
***
***      SELECT SINGLE *
***        FROM /ptloms/tb075
***        INTO @DATA(ls_tb075)
***        WHERE aplicacao  = @lwa_row-aplicacao
***          and formulario = @lwa_row-formulario.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
****        lv_msg = lwa_row-id_form && '/' && lwa_row-desc_form  .
***        MESSAGE s000(su) WITH 'Formulário' lwa_row-formulario 'já utilizado na tab /ptloms/tb075'
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
***
***FORM f_upd_user_date_time.
***
***  FIELD-SYMBOLS: <lfs_field>,
***                 <lfsw_total>.
***
***  DATA: lwa_row        TYPE /ptloms/tb070.
***  DATA: lv_msg         TYPE c LENGTH 50.
***
***  DATA: lv_new_number TYPE numc10. " Use the data type that matches your table field and SNRO definition
***
***  " Call the function module to get the next number from the number range object
***
***  /ptloms/tb070-ernam = sy-uname.
***  /ptloms/tb070-erdat = sy-datum.
***  /ptloms/tb070-erzeit = sy-uzeit.
***
***  /ptloms/tb070-aenam = sy-uname.
***  /ptloms/tb070-aedat = sy-datum.
***  /ptloms/tb070-aezeit = sy-uzeit.
***
***ENDFORM.

*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
