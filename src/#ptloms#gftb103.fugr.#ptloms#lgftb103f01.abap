*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB103F01.
*----------------------------------------------------------------------*
FORM f_check_chave_estrangeira.
  FIELD-SYMBOLS:
    <lfs_field> TYPE any.

  DATA:
    lwa_row  TYPE /ptloms/tb103,
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
      " TBD
    ENDIF.

  ENDLOOP.

ENDFORM.

FORM f_upd_user_date_time.
*---------------------------------------------------------------------*
* Dados de criação: preencher somente quando estiverem vazios
*---------------------------------------------------------------------*
  IF /ptloms/tb103-ernam IS INITIAL.
    /ptloms/tb103-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb103-erdat is INITIAL.
    /ptloms/tb103-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb103-erzeit = ''.
    /ptloms/tb103-erzeit = sy-uzeit.
  ENDIF.

*---------------------------------------------------------------------*
* Dados de alteração: atualizar sempre
*---------------------------------------------------------------------*
  /ptloms/tb103-aenam  = sy-uname.
  /ptloms/tb103-aedat  = sy-datum.
  /ptloms/tb103-aezeit = sy-uzeit.

ENDFORM.
