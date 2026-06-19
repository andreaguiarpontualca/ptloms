FUNCTION /ptloms/mf044.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"  EXPORTING
*"     VALUE(EX_USUARIO) TYPE  XUBNAME
*"----------------------------------------------------------------------
************************************************************************
***  Módulo de função REVISADO em 06/05/2024 em função da
***  incompatibilidade de versão com a SOLAR.
************************************************************************
***  Consultora ABAP - Nádia Rodrigues
************************************************************************

* Erro: Unexpected word "EXPORTING" in functional method call
*  ex_usuario = /ptloms/cl006=>busca_usuario( EXPORTING im_usuario = im_usuario ).
  ex_usuario = /ptloms/cl006=>busca_usuario( im_usuario = im_usuario ).

ENDFUNCTION.
