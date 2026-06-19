*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB075F01.
*----------------------------------------------------------------------*
FORM f_get_next_number.

  DATA: lwa_row        TYPE /ptloms/tb075.
  DATA: lv_msg         TYPE c LENGTH 50.
  DATA: lv_new_number TYPE numc10. " Use the data type that matches your table field and SNRO definition

  " Call the function module to get the next number from the number range object
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'            " The interval number you created
      object                  = '/PTLOMS/SQ'    " The SNRO object name you created
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

  IF sy-subrc IS INITIAL.
    /ptloms/tb075-sequencial = lv_new_number.
    " Assign the obtained number to the relevant field of your table
    " The structure name will typically be <view/table name>-<field name> <view/table name>-<field name> = lv_new_number.
  ENDIF.

  /ptloms/tb075-ernam = sy-uname.
  /ptloms/tb075-erdat = sy-datum.
  /ptloms/tb075-erzeit = sy-uzeit.

  /ptloms/tb075-aenam = sy-uname.
  /ptloms/tb075-aedat = sy-datum.
  /ptloms/tb075-aezeit = sy-uzeit.

ENDFORM.

FORM F_UPD_USER_DATE_TIME.

  FIELD-SYMBOLS: <lfs_field>,
                 <lfsw_total>.

  DATA: lwa_row        TYPE /ptloms/tb075.

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
