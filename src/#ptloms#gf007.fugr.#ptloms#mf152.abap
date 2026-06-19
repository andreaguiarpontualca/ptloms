FUNCTION /ptloms/mf152.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_EQKTX) TYPE  CHAR40 OPTIONAL
*"     VALUE(IV_INVNR) TYPE  CHAR25 OPTIONAL
*"     VALUE(IV_TPLNR) TYPE  CHAR30 OPTIONAL
*"     VALUE(IV_PLTXT) TYPE  CHAR40 OPTIONAL
*"     VALUE(IV_STATUS) TYPE  STRING OPTIONAL
*"     VALUE(IV_EQUNR) TYPE  CHAR18 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_DADOS) TYPE  /PTLOMS/CT167
*"----------------------------------------------------------------------

  " Limpa a tabela de exportação da RFC por segurança
  CLEAR et_dados.

  " Chama o método orquestrador estático da classe
  CALL METHOD /ptloms/cl013=>nota_ordem_equipamento_local
    EXPORTING
      iv_equnr  = iv_equnr
      iv_eqktx  = iv_eqktx
      iv_invnr  = iv_invnr
      iv_tplnr  = iv_tplnr
      iv_pltxt  = iv_pltxt
      iv_status = iv_status
    IMPORTING
      et_dados  = et_dados.





ENDFUNCTION.
