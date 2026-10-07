*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB087F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.
  DATA: ls_/ptloms/tb087 TYPE /ptloms/tb087. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb087.

      IF ls_/ptloms/tb087-ernam IS INITIAL.
        ls_/ptloms/tb087-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb087-erdat IS INITIAL.
        ls_/ptloms/tb087-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb087-erzeit = ''.
        ls_/ptloms/tb087-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb087-aenam = sy-uname.
      ls_/ptloms/tb087-aedat = sy-datum.
      ls_/ptloms/tb087-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb087 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
