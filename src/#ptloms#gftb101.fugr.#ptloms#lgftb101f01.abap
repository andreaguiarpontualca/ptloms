*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB101F01.
*----------------------------------------------------------------------*

FORM f_check_chave_estrangeira.
  FIELD-SYMBOLS:
    <lfs_field> TYPE any.

  DATA:
    lwa_row  TYPE /ptloms/tb101,
    ls_tb102 TYPE /ptloms/tb102,
    ls_tb103 TYPE /ptloms/tb103,
    ls_tb104 TYPE /ptloms/tb104,
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
      CLEAR ls_tb102.

      SELECT SINGLE id_lista
        INTO CORRESPONDING FIELDS OF ls_tb102
        FROM /ptloms/tb102
        WHERE id_lista = lwa_row-id_lista.
      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        CLEAR lv_msg.

        CONCATENATE
          'ID_LISTA'
          lwa_row-id_lista
          INTO lv_msg
          SEPARATED BY space.

        MESSAGE s000(su)
          WITH lv_msg
               'já utilizado na tabela'
               '/PTLOMS/TB102'
               'Não é possível removê-lo.'
          DISPLAY LIKE 'E'.

        EXIT.

      ENDIF.

      CLEAR ls_tb103.

      SELECT SINGLE id_lista
        INTO CORRESPONDING FIELDS OF ls_tb103
        FROM /ptloms/tb103
        WHERE id_lista = lwa_row-id_lista.
      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        CLEAR lv_msg.

        CONCATENATE
          'ID_LISTA'
          lwa_row-id_lista
          INTO lv_msg
          SEPARATED BY space.

        MESSAGE s000(su)
          WITH lv_msg
               'já utilizado na tabela'
               '/PTLOMS/TB103'
               'Não é possível removê-lo.'
          DISPLAY LIKE 'E'.

        EXIT.

      ENDIF.

      CLEAR ls_tb104.

      SELECT SINGLE id_lista
        INTO CORRESPONDING FIELDS OF ls_tb104
        FROM /ptloms/tb104
        WHERE id_lista = lwa_row-id_lista.
      IF sy-subrc = 0.

        vim_abort_saving = 'X'.

        CLEAR lv_msg.

        CONCATENATE
          'ID_LISTA'
          lwa_row-id_lista
          INTO lv_msg
          SEPARATED BY space.

        MESSAGE s000(su)
          WITH lv_msg
               'já utilizado na tabela'
               '/PTLOMS/tb104'
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
  IF /ptloms/tb101-ernam IS INITIAL.
    /ptloms/tb101-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb101-erdat IS INITIAL..
    /ptloms/tb101-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb101-erzeit = ''.
    /ptloms/tb101-erzeit = sy-uzeit.
  ENDIF.

*---------------------------------------------------------------------*
* Dados de alteração: atualizar sempre
*---------------------------------------------------------------------*
  /ptloms/tb101-aenam  = sy-uname.
  /ptloms/tb101-aedat  = sy-datum.
  /ptloms/tb101-aezeit = sy-uzeit.

ENDFORM.
