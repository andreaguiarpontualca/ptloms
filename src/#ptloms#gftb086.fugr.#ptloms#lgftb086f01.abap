*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB086F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb086 TYPE /ptloms/tb086. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb086.

      IF ls_/ptloms/tb086-ernam IS INITIAL.
        ls_/ptloms/tb086-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb086-erdat IS INITIAL.
        ls_/ptloms/tb086-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb086-erzeit = ''.
        ls_/ptloms/tb086-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb086-aenam = sy-uname.
      ls_/ptloms/tb086-aedat = sy-datum.
      ls_/ptloms/tb086-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb086 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
