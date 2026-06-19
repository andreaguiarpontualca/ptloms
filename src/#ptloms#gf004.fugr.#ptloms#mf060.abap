FUNCTION /ptloms/mf060.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_PERFIL) TYPE  CHAR10
*"  EXPORTING
*"     VALUE(IT_CONFIGURACAO) TYPE  /PTLOMS/CT078
*"----------------------------------------------------------------------

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

  DATA: lt_values_tab TYPE STANDARD TABLE OF dd07v.
  DATA: ls_values_tab LIKE LINE OF lt_values_tab.

  DATA: ls_configuracao LIKE LINE OF it_configuracao.

  DATA: lv_val_dominio TYPE val_single,
        lv_perfil      TYPE char10.

  DATA: lt_044 TYPE TABLE OF /ptloms/tb044.
  DATA: ls_044 LIKE LINE OF lt_044.

* Verifica se perfil está preenchido
  IF im_perfil IS INITIAL.
    RETURN.
  ENDIF.

  lv_perfil = im_perfil.
  TRANSLATE lv_perfil TO UPPER CASE.

* Busca idioma do usuário
  sy-langu = /ptloms/cl001=>out_idioma_usuario( sy-uname ).

* Busca configurações
  SELECT *
    FROM /ptloms/tb044
    INTO CORRESPONDING FIELDS OF TABLE lt_044
    WHERE perfil = lv_perfil.

* Busca descrições do Status Mobile
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = '/PTLOMS/DM012'
      text            = 'X'
    TABLES
      values_tab      = lt_values_tab
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  LOOP AT lt_044 INTO ls_044.
    CLEAR ls_configuracao.
    ls_configuracao-perfil       = im_perfil.
    ls_configuracao-configuracao = ls_044-configuracao.

    CLEAR lv_val_dominio.
    lv_val_dominio = ls_044-configuracao.
    CONDENSE lv_val_dominio NO-GAPS.
    READ TABLE lt_values_tab INTO ls_values_tab WITH KEY domvalue_l = lv_val_dominio.
    IF sy-subrc EQ 0.
      ls_configuracao-desc_configuracao = ls_values_tab-ddtext.
    ENDIF.

    APPEND ls_configuracao TO it_configuracao.
  ENDLOOP.

ENDFUNCTION.
