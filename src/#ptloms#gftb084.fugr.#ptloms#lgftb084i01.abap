*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB084I01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  Z_CONTROL_FIELDS_0100  INPUT
*&---------------------------------------------------------------------*
MODULE z_control_fields_0100 INPUT.

  IF /ptloms/tb084-ernam IS INITIAL.
    /ptloms/tb084-ernam = sy-uname.
  ENDIF.

  IF /ptloms/tb084-erdat IS INITIAL.
    /ptloms/tb084-erdat = sy-datum.
  ENDIF.

  IF /ptloms/tb084-erzeit = ''.
    /ptloms/tb084-erzeit = sy-uzeit.
  ENDIF.

  /ptloms/tb084-aenam = sy-uname.
  /ptloms/tb084-aedat = sy-datum.
  /ptloms/tb084-aezeit = sy-uzeit.

ENDMODULE.
