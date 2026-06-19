FUNCTION /ptloms/mf011.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WA_CONFIRMACAO) TYPE  /PTLOMS/ET051
*"     VALUE(IT_TEXTO_CONFIRMACAO) TYPE  /PTLOMS/CT061
*"  EXPORTING
*"     VALUE(IT_RETURN_CONFIRMACAO) TYPE  /PTLOMS/CT062
*"----------------------------------------------------------------------

  DATA: ls_033 TYPE /ptloms/tb033.

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  SELECT SINGLE * FROM  /ptloms/tb033
    INTO CORRESPONDING FIELDS OF ls_033.

  IF ls_033-cesto IS INITIAL.

    o_oms->in_confirmacao(
      EXPORTING
        im_confirmacao = wa_confirmacao
        it_texto       = it_texto_confirmacao
      IMPORTING
        rt_return      = it_return_confirmacao ).

  ELSE.

    o_oms->in_confirmacao_cesto(
    EXPORTING
      im_confirmacao = wa_confirmacao
      it_texto       = it_texto_confirmacao
    IMPORTING
      rt_return      = it_return_confirmacao ).

  ENDIF.


ENDFUNCTION.
