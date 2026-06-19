FUNCTION /ptloms/mf074.
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

  DATA: rt_datope TYPE /iwbep/t_cod_select_options.

*  DATA(o_cl008) = NEW /ptloms/cl008( rt_datope = rt_datope ).
  DATA: o_cl008 TYPE REF TO /ptloms/cl008.

  CREATE OBJECT o_cl008
    EXPORTING
      rt_datope = rt_datope.

*  o_cl008->transferir( CHANGING im_ordem = it_ordem RECEIVING re_retorno = it_retorno ).
  CALL METHOD o_cl008->transferir
    EXPORTING
      im_ordem   = it_ordem
    IMPORTING
      em_ordem   = it_ordem
      re_retorno = it_retorno.


ENDFUNCTION.
