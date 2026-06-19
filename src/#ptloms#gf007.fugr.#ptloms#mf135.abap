FUNCTION /PTLOMS/MF135.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_PERGUNTAS) TYPE  /PTLOMS/CT155
*"  EXPORTING
*"     VALUE(E_PERGUNTAS) TYPE  /PTLOMS/CT155
*"     VALUE(E_OPCOES) TYPE  /PTLOMS/CT087
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl017.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->busca_perguntas
    EXPORTING
      i_perguntas  = i_perguntas
    IMPORTING
      e_perguntas = e_perguntas
      e_opcoes    = e_opcoes
      e_retorno   = e_retorno.

ENDFUNCTION.
