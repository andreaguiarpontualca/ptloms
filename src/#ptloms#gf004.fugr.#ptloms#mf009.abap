FUNCTION /ptloms/mf009.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WA_NOTA) TYPE  /PTLOMS/ET043
*"     VALUE(IT_TEXTO) TYPE  /PTLOMS/CT044
*"     VALUE(IT_ITEM) TYPE  /PTLOMS/CT045
*"     VALUE(IT_ITEM_CAUSA) TYPE  /PTLOMS/CT046
*"     VALUE(IT_ITEM_ATIVIDADE) TYPE  /PTLOMS/CT047
*"     VALUE(IT_ITEM_MEDIDAS) TYPE  /PTLOMS/CT024
*"     VALUE(IT_ITEM_TAREFA) TYPE  /PTLOMS/CT048
*"     VALUE(IT_ANEXO) TYPE  /PTLOMS/CT072
*"  EXPORTING
*"     VALUE(EX_NOTF_NO) TYPE  QMNUM
*"     VALUE(IT_RETURN) TYPE  /PTLOMS/CT060
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_nota(
    EXPORTING
      im_nota           = wa_nota
      it_texto          = it_texto
      it_item           = it_item
      it_item_causa     = it_item_causa
      it_item_atividade = it_item_atividade
      it_item_medidas   = it_item_medidas
      it_item_tarefa    = it_item_tarefa
      it_anexo          = it_anexo
    IMPORTING
      ex_notf_no        = ex_notf_no
      et_return         = it_return ).

ENDFUNCTION.
