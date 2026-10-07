*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************
*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB073F01.
*----------------------------------------------------------------------*

FORM f_check_chave_estrangeira.

  FIELD-SYMBOLS:
    <lfs_field> TYPE any.

  DATA:
    lwa_row  TYPE /ptloms/tb073,
    ls_tb075 TYPE /ptloms/tb075,
    lv_msg   TYPE c LENGTH 255.

  LOOP AT total.

    CLEAR lwa_row.

    IF <vim_total_struc> IS NOT ASSIGNED.
      CONTINUE.
    ENDIF.

    MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*---------------------------------------------------------------------*
*   Preencher dados de criação
*
*   No TMG, a ação de inclusão normalmente é "N".
*   Caso seu ambiente utilize "I", ajuste a condição.
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
*   Preencher dados da última alteração
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

*     Recarregar estrutura após atualizar os campos de auditoria
      CLEAR lwa_row.
      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

*     Atualizar a linha correspondente em EXTRACT
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

      CLEAR ls_tb075.

      SELECT SINGLE aplicacao
                    grupo
        INTO CORRESPONDING FIELDS OF ls_tb075
        FROM /ptloms/tb075
        WHERE aplicacao = lwa_row-aplicacao
          AND grupo     = lwa_row-grupo.

      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        CLEAR lv_msg.

        CONCATENATE
          'Aplicação/Grupo'
          lwa_row-aplicacao
          lwa_row-grupo
          INTO lv_msg
          SEPARATED BY space.

        MESSAGE s000(su)
          WITH lv_msg
               'já utilizados na tabela'
               '/PTLOMS/TB075'
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
  IF /ptloms/tb073-ernam IS INITIAL.
    /ptloms/tb073-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb073-erdat IS INITIAL.
    /ptloms/tb073-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb073-erzeit IS INITIAL.
    /ptloms/tb073-erzeit = sy-uzeit.
  ENDIF.

*---------------------------------------------------------------------*
* Dados da última alteração: atualizar sempre
*---------------------------------------------------------------------*
  /ptloms/tb073-aenam  = sy-uname.
  /ptloms/tb073-aedat  = sy-datum.
  /ptloms/tb073-aezeit = sy-uzeit.

ENDFORM.
****----------------------------------------------------------------------*
******INCLUDE /PTLOMS/LGFTB073F01.
****----------------------------------------------------------------------*
***FORM f_check_chave_estrangeira.
***
***  FIELD-SYMBOLS: <lfs_field>,
***                 <lfsw_total>.
***
***  DATA: lwa_row        TYPE /ptloms/tb073.
***  DATA: lv_msg         TYPE c LENGTH 255.
***
***  SELECT *
***    FROM /ptloms/tb073
***    INTO TABLE @DATA(lt_tb073).
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
***        FROM /ptloms/tb075
***        INTO @DATA(ls_tb074)
***        WHERE aplicacao = @lwa_row-aplicacao
***          and Grupo = @lwa_row-grupo.
***
***      IF sy-subrc EQ 0.
***        vim_abort_saving = 'X'.
***        CLEAR:
***          lv_msg.
***        CONCATENATE 'Aplicação/Grupo' lwa_row-aplicacao lwa_row-grupo into lv_msg SEPARATED BY space.
***        MESSAGE s000(su) WITH lv_msg
***                              'já utilizados na tab /ptloms/tb075'
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
***  /ptloms/tb073-ernam = sy-uname.
***  /ptloms/tb073-erdat = sy-datum.
***  /ptloms/tb073-erzeit = sy-uzeit.
***
***  /ptloms/tb073-aenam = sy-uname.
***  /ptloms/tb073-aedat = sy-datum.
***  /ptloms/tb073-aezeit = sy-uzeit.
***
***ENDFORM.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
