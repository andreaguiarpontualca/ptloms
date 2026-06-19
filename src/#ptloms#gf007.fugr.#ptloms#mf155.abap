FUNCTION /ptloms/mf155.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_PROMPT_USUARIO) TYPE  STRING
*"     VALUE(IV_JSON_DADOS) TYPE  STRING
*"  EXPORTING
*"     VALUE(RS_RESULT) TYPE  /PTLOMS/ET203
*"----------------------------------------------------------------------

  " Limpa a tabela de exportação da RFC por segurança
  CLEAR rs_result.

  DATA: es_result TYPE /ptloms/et202.

  " Chama o método orquestrador estático da classe
  CALL METHOD /ptloms/cl020=>analisar_checklist
    EXPORTING
      iv_prompt_usuario = iv_prompt_usuario
      iv_json_dados     = iv_json_dados
    RECEIVING
      rs_result         = es_result.

  MOVE-CORRESPONDING es_result TO rs_result.

ENDFUNCTION.
