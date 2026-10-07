FUNCTION /ptloms/mf163.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_VINCULOS) TYPE  /PTLOMS/CT175
*"----------------------------------------------------------------------

  DATA: lo_checklist TYPE REF TO /ptloms/cl017,
        lt_vinculos  TYPE /ptloms/cl017=>tt_checklist_vinculos,
        ls_vinculo   TYPE /ptloms/tb071,
        ls_saida     TYPE /ptloms/et208.

  CLEAR et_vinculos[].

* Instancia classe de checklist
  CREATE OBJECT lo_checklist.

* Busca vínculos configurados
  CALL METHOD lo_checklist->busca_checklist_vinculos
    IMPORTING
      e_vinculos = lt_vinculos.

* Converte estrutura interna para estrutura da RFC
  LOOP AT lt_vinculos INTO ls_vinculo.

    CLEAR ls_saida.

    ls_saida-chave         = 'X'.
    ls_saida-aplicacao     = ls_vinculo-aplicacao.
    ls_saida-formulario    = ls_vinculo-formulario.
    ls_saida-tp_vinculo    = ls_vinculo-tp_vinculo.
    ls_saida-descr_vinculo = ls_vinculo-descr_vinculo.
    ls_saida-tipo_uso      = ls_vinculo-tipo_uso.
    ls_saida-identificacao = ls_vinculo-identificacao.

    APPEND ls_saida TO et_vinculos.

  ENDLOOP.

ENDFUNCTION.
