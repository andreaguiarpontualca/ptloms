*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB096F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb096 TYPE /ptloms/tb096. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb096.

      IF ls_/ptloms/tb096-ernam IS INITIAL.
        ls_/ptloms/tb096-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb096-erdat IS INITIAL.
        ls_/ptloms/tb096-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb096-erzeit = ''.
        ls_/ptloms/tb096-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb096-aenam = sy-uname.
      ls_/ptloms/tb096-aedat = sy-datum.
      ls_/ptloms/tb096-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb096 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
