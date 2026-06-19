FUNCTION /ptloms/mf106.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_OPERACOES) TYPE  /PTLOMS/CT119
*"----------------------------------------------------------------------

  CALL METHOD /ptloms/cl014=>get_operacoes_simplificada
    IMPORTING
      et_operacoes = et_operacoes.




ENDFUNCTION.
