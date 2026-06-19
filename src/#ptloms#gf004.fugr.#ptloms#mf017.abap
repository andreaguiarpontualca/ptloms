FUNCTION /ptloms/mf017.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_OBJKEY) TYPE  SWO_TYPEID
*"     VALUE(IM_USER) TYPE  SY-UNAME OPTIONAL
*"     VALUE(IT_ANEXO_ORDEM) TYPE  /PTLOMS/CT072
*"  EXPORTING
*"     VALUE(IT_RETORNO_ANEXO) TYPE  /PTLOMS/CT063
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_anexar_imagem( EXPORTING im_objkey  = im_objkey
                                     im_objtyp  = 'BUS2007'
                                     im_user    = im_user
                                     it_anexo   = it_anexo_ordem
                           IMPORTING et_return  = it_retorno_anexo ).

ENDFUNCTION.
