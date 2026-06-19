FUNCTION /PTLOMS/MF153.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ORDEM) TYPE  CHAR12 OPTIONAL
*"     VALUE(IV_USUARIO) TYPE  CHAR12 OPTIONAL
*"     VALUE(IV_FORMULARIO) TYPE  /PTLOMS/ED059 OPTIONAL
*"     VALUE(IV_ERDAT_INI) TYPE  ERDAT OPTIONAL
*"     VALUE(IV_ERDAT_FIM) TYPE  ERDAT OPTIONAL
*"  EXPORTING
*"     VALUE(ET_DADOS) TYPE  /PTLOMS/CT170
*"----------------------------------------------------------------------

  " Limpa a tabela de exportação da RFC por segurança
  CLEAR et_dados.

  " Chama o método orquestrador estático da classe
CALL METHOD /ptloms/cl018=>pesquisar_respostas
  EXPORTING
    iv_ordem      = iv_ordem
    iv_usuario    = iv_usuario
    iv_formulario = iv_formulario
    iv_erdat_ini  = iv_erdat_ini
    iv_erdat_fim  = iv_erdat_fim
  IMPORTING
    et_dados      = et_dados.






ENDFUNCTION.
