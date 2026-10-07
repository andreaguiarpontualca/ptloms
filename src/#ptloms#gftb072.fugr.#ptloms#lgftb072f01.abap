*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************

*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB072F01.
*----------------------------------------------------------------------*

FORM f_check_chave_estrangeira.

  FIELD-SYMBOLS:
    <lfs_field> TYPE any.

  DATA:
    lwa_row  TYPE /ptloms/tb072,
    ls_tb074 TYPE /ptloms/tb074,
    lv_msg   TYPE c LENGTH 255.

  LOOP AT total.

    CLEAR lwa_row.

    IF <vim_total_struc> IS NOT ASSIGNED.
      CONTINUE.
    ENDIF.

    MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*---------------------------------------------------------------------*
*   Preencher campos de criação
*---------------------------------------------------------------------*
    IF <action> = 'I'.

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
*   Preencher dados da última alteração
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

*     Atualizar estrutura auxiliar após preencher a auditoria
      CLEAR lwa_row.
      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*     Atualizar os dados na tabela de exibição
      READ TABLE extract WITH KEY <vim_xtotal_key>.

      IF sy-subrc = 0.
        extract = total.
        MODIFY extract INDEX sy-tabix.
      ENDIF.

*     Atualizar a linha atual de TOTAL
      MODIFY total.

    ENDIF.

*---------------------------------------------------------------------*
*   Validar exclusão
*---------------------------------------------------------------------*
    IF <action> = 'D'.

      CLEAR ls_tb074.

      SELECT SINGLE aplicacao
                    opcao
        INTO CORRESPONDING FIELDS OF ls_tb074
        FROM /ptloms/tb074
        WHERE aplicacao = lwa_row-aplicacao
          AND opcao     = lwa_row-opcao.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        CLEAR lv_msg.

        CONCATENATE
          'Aplicação/Opção'
          lwa_row-aplicacao
          lwa_row-opcao
          INTO lv_msg
          SEPARATED BY space.

        MESSAGE s000(su)
          WITH lv_msg
               'já utilizados na tabela'
               '/PTLOMS/TB074'
               'Não é possível removê-los.'
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
  IF /ptloms/tb072-ernam IS INITIAL.
    /ptloms/tb072-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb072-erdat IS INITIAL.
    /ptloms/tb072-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb072-erzeit IS INITIAL.
    /ptloms/tb072-erzeit = sy-uzeit.
  ENDIF.

*---------------------------------------------------------------------*
* Dados de alteração: atualizar sempre
*---------------------------------------------------------------------*
  /ptloms/tb072-aenam  = sy-uname.
  /ptloms/tb072-aedat  = sy-datum.
  /ptloms/tb072-aezeit = sy-uzeit.

ENDFORM.
****----------------------------------------------------------------------*
******INCLUDE /PTLOMS/LGFTB072F01.
****----------------------------------------------------------------------*
***FORM f_check_chave_estrangeira.
***
***  FIELD-SYMBOLS: <lfs_field>,
***                 <lfsw_total>.
***
***  DATA: lwa_row        TYPE /ptloms/tb072.
***  DATA: lv_msg         TYPE c LENGTH 255.
***
***  SELECT *
***    FROM /ptloms/tb072
***    INTO TABLE @DATA(lt_tb072).
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
***        FROM /ptloms/tb074
***        INTO @DATA(ls_tb074)
***        WHERE aplicacao  = @lwa_row-aplicacao
***          and opcao = @lwa_row-opcao.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
***        CONCATENATE 'Aplicação/Opção' lwa_row-aplicacao lwa_row-opcao into lv_msg SEPARATED BY space.
***        MESSAGE s000(su) WITH lv_msg
***                              'já utilizados na tab /ptloms/tb074'
***                              'Não é possível removê-los.'
***                              DISPLAY LIKE 'E'.
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
***  DATA: lwa_row        TYPE /ptloms/tb072.
***
***  /ptloms/tb072-ernam = sy-uname.
***  /ptloms/tb072-erdat = sy-datum.
***  /ptloms/tb072-erzeit = sy-uzeit.
***
***  /ptloms/tb072-aenam = sy-uname.
***  /ptloms/tb072-aedat = sy-datum.
***  /ptloms/tb072-aezeit = sy-uzeit.
***
***ENDFORM.


*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
