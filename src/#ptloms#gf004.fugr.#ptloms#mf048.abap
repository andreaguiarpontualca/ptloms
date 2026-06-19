FUNCTION /PTLOMS/MF048.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"  EXPORTING
*"     VALUE(EX_NOME) TYPE  AD_NAMTEXT
*"----------------------------------------------------------------------

  /ptloms/cl006=>busca_dados_usuario( EXPORTING im_usuario = im_usuario
                                      IMPORTING ex_nome    = ex_nome ).

ENDFUNCTION.
