*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB093F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb093 TYPE /ptloms/tb093. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb093.

      IF ls_/ptloms/tb093-ernam IS INITIAL.
        ls_/ptloms/tb093-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb093-erdat IS INITIAL.
        ls_/ptloms/tb093-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb093-erzeit IS INITIAL.
        ls_/ptloms/tb093-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb093-aenam = sy-uname.
      ls_/ptloms/tb093-aedat = sy-datum.
      ls_/ptloms/tb093-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb093 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
