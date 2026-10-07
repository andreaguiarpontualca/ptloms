FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb084 TYPE /ptloms/tb084. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb084.

      IF ls_/ptloms/tb084-ernam IS INITIAL.
        ls_/ptloms/tb084-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb084-erdat IS INITIAL.
        ls_/ptloms/tb084-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb084-erzeit = ''.
        ls_/ptloms/tb084-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb084-aenam = sy-uname.
      ls_/ptloms/tb084-aedat = sy-datum.
      ls_/ptloms/tb084-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb084 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
