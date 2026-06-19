FUNCTION /ptloms/mf068.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_ORDEM) TYPE  /PTLOMS/CT104
*"  EXPORTING
*"     VALUE(IT_RETORNO) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************
  CALL METHOD /ptloms/cl008=>desassociar(
    EXPORTING
      im_ordem   = it_ordem
    IMPORTING
      re_retorno = it_retorno ).

ENDFUNCTION.
