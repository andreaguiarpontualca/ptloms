FUNCTION /ptloms/mf069.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(IT_RETORNO) TYPE  BAPIRET2_T
*"  CHANGING
*"     VALUE(IT_ORDEM) TYPE  /PTLOMS/CT104
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************


*  CALL METHOD: /ptloms/cl008=>associar( CHANGING im_ordem = it_ordem RECEIVING re_retorno = it_retorno ).

  CALL METHOD /ptloms/cl008=>associar
    EXPORTING
      im_ordem   = it_ordem
    IMPORTING
      em_ordem   = it_ordem
      re_retorno = it_retorno.

ENDFUNCTION.
