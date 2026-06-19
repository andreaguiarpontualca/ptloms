*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/MP006_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE gv_ok_code.

    WHEN 'EXIT' OR 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.

    WHEN 'BT_GRAVAR'  OR 'SAVE'.
      PERFORM f_grava.

    WHEN 'BT_CANC'.
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.
