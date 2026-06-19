FUNCTION /ptloms/mf107.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_USUARIO) TYPE  CHAR12
*"     VALUE(I_AUFNR) TYPE  CHAR12
*"     VALUE(I_VORNR) TYPE  CHAR4
*"  EXPORTING
*"     VALUE(E_DESPACHO) TYPE  /PTLOMS/ET141
*"----------------------------------------------------------------------

  CALL METHOD /ptloms/cl014=>despachar_operacao
    EXPORTING
      i_usuario          = i_usuario
      i_aufnr            = i_aufnr
      i_vornr            = i_vornr
    IMPORTING
      e_despacho         = e_despacho
    EXCEPTIONS
      oper_ja_desp_us    = 1
      mat_obrigatoria    = 2
      ordem_nao_liberada = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFUNCTION.
