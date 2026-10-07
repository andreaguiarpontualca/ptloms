*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB090F01.
*----------------------------------------------------------------------*
FORM f_upd_user_date_time.

  DATA: ls_/ptloms/tb090 TYPE /ptloms/tb090. " Replace with your table/structure

  " Loop through the table control memory for records to be saved
  LOOP AT total.
    IF <vim_total_struc> IS ASSIGNED.
      MOVE-CORRESPONDING <vim_total_struc> TO ls_/ptloms/tb090.

      IF ls_/ptloms/tb090-ernam IS INITIAL.
        ls_/ptloms/tb090-ernam = sy-uname.
      ENDIF.

      IF ls_/ptloms/tb090-erdat IS INITIAL.
        ls_/ptloms/tb090-erdat = sy-datum.
      ENDIF.

      IF ls_/ptloms/tb090-erzeit IS INITIAL.
        ls_/ptloms/tb090-erzeit = sy-uzeit.
      ENDIF.

      ls_/ptloms/tb090-aenam = sy-uname.
      ls_/ptloms/tb090-aedat = sy-datum.
      ls_/ptloms/tb090-aezeit = sy-uzeit.

      MOVE-CORRESPONDING ls_/ptloms/tb090 TO <vim_total_struc>.
      MODIFY total.
    ENDIF.

  ENDLOOP.

ENDFORM.
