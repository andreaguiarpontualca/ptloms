*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB092F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb092 TYPE /ptloms/tb092. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb092.

      IF ls_/ptloms/tb092-ernam IS INITIAL.
        ls_/ptloms/tb092-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb092-erdat IS INITIAL.
        ls_/ptloms/tb092-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb092-erzeit IS INITIAL.
        ls_/ptloms/tb092-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb092-aenam = sy-uname.
      ls_/ptloms/tb092-aedat = sy-datum.
      ls_/ptloms/tb092-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb092 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
