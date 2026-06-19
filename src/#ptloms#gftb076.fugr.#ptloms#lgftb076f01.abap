*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB076F01.
*----------------------------------------------------------------------*
form F_SAVE_USER_DATE_TIME.

  /ptloms/tb076-ernam = sy-uname.
  /ptloms/tb076-erdat = sy-datum.
  /ptloms/tb076-erzeit = sy-uzeit.

  /ptloms/tb076-aenam = sy-uname.
  /ptloms/tb076-aedat = sy-datum.
  /ptloms/tb076-aezeit = sy-uzeit.

endform.

FORM F_UPD_USER_DATE_TIME.

  FIELD-SYMBOLS: <lfs_field>,
                 <lfsw_total>.

  DATA: lwa_row        TYPE /ptloms/tb076.

  LOOP AT total.

    CLEAR: lwa_row.

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

  ENDLOOP.
ENDFORM.
