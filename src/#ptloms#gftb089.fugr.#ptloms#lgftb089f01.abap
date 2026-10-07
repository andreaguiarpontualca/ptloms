*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB089F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb089 TYPE /ptloms/tb089. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb089.

      IF ls_/ptloms/tb089-ernam IS INITIAL.
        ls_/ptloms/tb089-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb089-erdat IS INITIAL.
        ls_/ptloms/tb089-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb089-erzeit = ''.
        ls_/ptloms/tb089-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb089-aenam = sy-uname.
      ls_/ptloms/tb089-aedat = sy-datum.
      ls_/ptloms/tb089-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb089 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
