FUNCTION /ptloms/mf149.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  STRING OPTIONAL
*"     VALUE(IV_CNPJ) TYPE  STRING OPTIONAL
*"     VALUE(IV_CPF) TYPE  STRING OPTIONAL
*"     VALUE(IV_KUNNR) TYPE  STRING OPTIONAL
*"     VALUE(IV_STATUS) TYPE  STRING OPTIONAL
*"     VALUE(IV_DADOS_ENDERECO) TYPE  CHAR1 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_DADOS) TYPE  /PTLOMS/CT167
*"----------------------------------------------------------------------

  " Limpa a tabela de exportação da RFC por segurança
  CLEAR et_dados.

  " Chama o método orquestrador estático da classe
  CALL METHOD /ptloms/cl013=>nota_ordem_cliente
    EXPORTING
      iv_name           = iv_name
      iv_cnpj           = iv_cnpj
      iv_cpf            = iv_cpf
      iv_kunnr          = iv_kunnr
      iv_status         = iv_status
      iv_dados_endereco = iv_dados_endereco
    IMPORTING
      et_dados          = et_dados.

ENDFUNCTION.
