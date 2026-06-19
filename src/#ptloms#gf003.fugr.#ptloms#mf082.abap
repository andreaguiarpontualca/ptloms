FUNCTION /ptloms/mf082.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_AUFNR) TYPE  CHAR12
*"  EXPORTING
*"     VALUE(IT_RETORNO) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lv_subrc TYPE sy-subrc.
  DATA: lv_usuario TYPE sy-uname.
  DATA: ls_retorno LIKE LINE OF it_retorno.

  /ptloms/cl008=>ler_bloqueio_ordem( EXPORTING im_ordem = im_aufnr IMPORTING subrc = lv_subrc iv_uname = lv_usuario ).



  IF lv_subrc IS NOT INITIAL.

    ls_retorno-type = 'E'.
    ls_retorno-id = 'CO'.
    ls_retorno-number = '469'.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = im_aufnr
      IMPORTING
        output = ls_retorno-message_v1.
    ls_retorno-message_v2 = lv_usuario.

    CONCATENATE 'Ordem' ls_retorno-message_v1 'já está sendo tratada por' lv_usuario INTO ls_retorno-message SEPARATED BY space.

    APPEND ls_retorno TO it_retorno.

*    APPEND VALUE #( type = 'E' id = 'CO' number = '469' message_v1 = |{ im_aufnr ALPHA = OUT }|  message_v2 = lv_usuario
*                 message = |{ 'Ordem'(024) }| & | | & |{ im_aufnr ALPHA = OUT }| & | | & |{ 'já está sendo tratada por'(025) }| & | | & |{ lv_usuario }| ) TO it_retorno.

  ENDIF.

ENDFUNCTION.
