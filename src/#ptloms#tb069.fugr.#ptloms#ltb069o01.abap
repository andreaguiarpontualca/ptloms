*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LTB069O01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  Z_OCULTAR_ID  OUTPUT
*&---------------------------------------------------------------------*
MODULE z_ocultar_id OUTPUT.

  LOOP AT SCREEN.
    IF screen-name = '/PTLOMS/TB069-ID'. " Use the field name as it appears in the screen layout/structure
      screen-invisible = '1'.
      screen-active = '0'. " Set active to 0 to completely hide the element and label
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  Z_SELECIONA_ID  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE z_seleciona_id OUTPUT.

***  select single id into /PTLOMS/TB069-id
***    from /PTLOMS/TB069
***    where id = */PTLOMS/TB069-id.


ENDMODULE.
