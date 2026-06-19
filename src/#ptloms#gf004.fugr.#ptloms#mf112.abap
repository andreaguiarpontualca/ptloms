FUNCTION /PTLOMS/MF112.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WA_ORDEM) TYPE  /PTLOMS/ET087
*"     VALUE(IM_NOTA) TYPE  CHAR12 OPTIONAL
*"     VALUE(IM_NOCOMMIT) TYPE  CHAR1 OPTIONAL
*"     VALUE(IT_TEXTO_ORDEM) TYPE  /PTLOMS/CT059
*"     VALUE(IT_ANEXO) TYPE  /PTLOMS/CT072
*"  EXPORTING
*"     VALUE(EX_AUFNR) TYPE  AUFNR
*"     VALUE(IT_RETURN_ORDEM) TYPE  /PTLOMS/CT063
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->in_ordem_lista_tarefa
    EXPORTING
      im_ordem       = wa_ordem
      im_nota        = im_nota
      im_nocommit    = im_nocommit
      it_texto_ordem = it_texto_ordem
      it_anexo       = it_anexo
    IMPORTING
      ex_aufnr       = ex_aufnr
      et_return      = it_return_ordem.

ENDFUNCTION.
