*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB091F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb091 TYPE /ptloms/tb091. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb091.

      IF ls_/ptloms/tb091-ernam IS INITIAL.
        ls_/ptloms/tb091-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb091-erdat IS INITIAL.
        ls_/ptloms/tb091-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb091-erzeit = ''.
        ls_/ptloms/tb091-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb091-aenam = sy-uname.
      ls_/ptloms/tb091-aedat = sy-datum.
      ls_/ptloms/tb091-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb091 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
