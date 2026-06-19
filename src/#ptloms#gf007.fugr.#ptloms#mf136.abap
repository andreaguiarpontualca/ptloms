FUNCTION /ptloms/mf136.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_RESPOSTAS) TYPE  /PTLOMS/CT088
*"  EXPORTING
*"     VALUE(E_RESPOSTAS) TYPE  /PTLOMS/CT088
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl018.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->busca_respostas
    EXPORTING
      i_respostas = i_respostas
    IMPORTING
      e_respostas = e_respostas
      e_retorno   = e_retorno.

ENDFUNCTION.
