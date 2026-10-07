*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB094F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb094 TYPE /ptloms/tb094. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb094.

      IF ls_/ptloms/tb094-ernam IS INITIAL.
        ls_/ptloms/tb094-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb094-erdat IS INITIAL.
        ls_/ptloms/tb094-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb094-erzeit = ''.
        ls_/ptloms/tb094-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb094-aenam = sy-uname.
      ls_/ptloms/tb094-aedat = sy-datum.
      ls_/ptloms/tb094-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb094 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
