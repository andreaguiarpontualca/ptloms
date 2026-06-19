*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP904_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF ok_100 = 'EXIT' OR
     ok_100 = 'BACK' OR
     ok_100 = 'CANC'.

    LEAVE TO  SCREEN '0' .

  ELSE.

    CALL METHOD cl_gui_cfw=>dispatch.

  ENDIF.

  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.

  IF ok_101 = 'EXIT' OR
     ok_101 = 'BACK' OR
     ok_101 = 'CANC'.

    LEAVE TO SCREEN '0100'.

  ELSE.

    CALL METHOD cl_gui_cfw=>dispatch.

  ENDIF.

  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0102 INPUT.

  IF ok_102 = 'EXIT' OR
     ok_102 = 'BACK' OR
     ok_102 = 'CANC'.

    CLEAR gv_pula.
    LEAVE TO SCREEN '0100'.

  ELSE.

    CALL METHOD cl_gui_cfw=>dispatch.

  ENDIF.

  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  DATA: p_erro TYPE flag.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_valida_associacao CHANGING lt_associar.

    IF it_message IS NOT INITIAL.

      CALL FUNCTION 'RMSL325_DISPLAY_MSG_POPUP'
        EXPORTING
          it_message = it_message.

    ELSEIF lt_associar IS NOT INITIAL.

      PERFORM f_grava_despacho CHANGING lt_associar.

    ENDIF.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  DATA: p_canc TYPE flag.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_valida_desassociacao CHANGING p_canc.

    IF it_message IS NOT INITIAL.

      CALL FUNCTION 'RMSL325_DISPLAY_MSG_POPUP'
        EXPORTING
          it_message = it_message.

    ENDIF.

    IF p_canc IS INITIAL.

      PERFORM f_desassociar.

    ENDIF.

    CLEAR: p_canc.

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

    PERFORM f_valida_transferencia CHANGING p_canc.

    IF it_message IS NOT INITIAL.

      CALL FUNCTION 'RMSL325_DISPLAY_MSG_POPUP'
        EXPORTING
          it_message = it_message.

    ENDIF.

    IF p_canc IS INITIAL.

      PERFORM f_transferir.

    ENDIF.

    CLEAR: p_canc.

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
