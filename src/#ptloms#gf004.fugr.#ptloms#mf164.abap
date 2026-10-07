FUNCTION /ptloms/mf164.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_OPCOES) TYPE /PTLOMS/CT087
*"----------------------------------------------------------------------

  DATA: lo_checklist TYPE REF TO /ptloms/cl017,
        lt_opcoes    TYPE /ptloms/cl017=>tt_checklist_lista_opcoes,
        ls_opcao     TYPE /ptloms/tb074,
        ls_saida     TYPE /ptloms/et089.

  CLEAR et_opcoes[].

* Instancia classe de checklist
  CREATE OBJECT lo_checklist.

* Busca listas de opções configuradas
  CALL METHOD lo_checklist->busca_checklist_lista_opcoes
    IMPORTING
      e_opcoes = lt_opcoes.

* Converte estrutura interna para estrutura da RFC
  LOOP AT lt_opcoes INTO ls_opcao.

    CLEAR ls_saida.

    ls_saida-chave          = 'X'.
    ls_saida-tipolistaopcao = ls_opcao-opcao.
    ls_saida-sequencial     = ls_opcao-sequencial.
    ls_saida-descricao      = ls_opcao-descricao.

    APPEND ls_saida TO et_opcoes.

  ENDLOOP.

ENDFUNCTION.
