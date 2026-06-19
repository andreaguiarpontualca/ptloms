*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP004_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC'.

    LEAVE TO SCREEN 0.
*    LEAVE PROGRAM.

  ELSE.

    CALL METHOD cl_gui_cfw=>dispatch.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_despacho.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_desassociar.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_associar_outro_usuario.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0500 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

*    PERFORM f_valida_operacao.

    PERFORM f_transferir.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_USUARIO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_usuario INPUT.

  PERFORM f_valida_usuario.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_USUARIO_ASSOCIAR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_usuario_associar INPUT.

  PERFORM f_valida_usuario_associar.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  HELP_USUARIO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE help_usuario INPUT.

  PERFORM f_help_usuario.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_MOTIVO_DES  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_motivo_des INPUT.

  PERFORM f_valida_motivo_des.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  HELP_RETIRADA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE help_retirada INPUT.

  PERFORM f_help_retirada.

ENDMODULE.
