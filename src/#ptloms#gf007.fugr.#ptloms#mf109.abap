FUNCTION /ptloms/mf109.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_DESPACHOS) TYPE  /PTLOMS/CT120
*"----------------------------------------------------------------------

  CALL METHOD /ptloms/cl014=>obter_lista_despachos
    EXPORTING
      i_inativo  = ''
    IMPORTING
      e_despacho = et_despachos.


ENDFUNCTION.
