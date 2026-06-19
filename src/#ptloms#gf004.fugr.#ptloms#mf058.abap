FUNCTION /ptloms/mf058.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  XUBNAME
*"  EXPORTING
*"     VALUE(IT_AUTORIZACAO) TYPE  /PTLOMS/CT076
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

  DATA: lt_values_tab TYPE STANDARD TABLE OF dd07v,
        ls_values_tab LIKE LINE OF lt_values_tab.

  DATA: ls_autorizacao LIKE LINE OF it_autorizacao.

  DATA: lv_val_dominio TYPE val_single,
        lv_usuario     TYPE xubname.

  DATA: lv_perfil TYPE /ptloms/tb013-perfil.

  DATA: lt_043 TYPE TABLE OF /ptloms/tb043,
        ls_043 LIKE LINE OF lt_043.

* Verifica se usuário está preenchido
  IF im_usuario IS INITIAL.
    RETURN.
  ENDIF.

  lv_usuario = im_usuario.
  TRANSLATE lv_usuario TO UPPER CASE.

* Busca Perfil do usuário
  SELECT SINGLE perfil FROM /ptloms/tb013 INTO lv_perfil WHERE usuario = lv_usuario .

* Verifica se encontrou Perfil
  IF lv_perfil IS INITIAL.
    RETURN.
  ENDIF.

* Busca autorizações
  SELECT *
    FROM /ptloms/tb043
    INTO CORRESPONDING FIELDS OF TABLE lt_043
    WHERE perfil = lv_perfil.

* Busca idioma do usuário
  sy-langu = /ptloms/cl001=>out_idioma_usuario( sy-uname ).

* Busca descrições do Status Mobile
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = '/PTLOMS/DM011'
      text            = 'X'
    TABLES
      values_tab      = lt_values_tab
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  LOOP AT lt_043 INTO ls_043.
*  LOOP AT lt_043 INTO DATA(ls_043).
    CLEAR ls_autorizacao.
    ls_autorizacao-usuario     = im_usuario.
    ls_autorizacao-autorizacao = ls_043-autorizacao.

    CLEAR lv_val_dominio.
    lv_val_dominio = ls_043-autorizacao.
    CONDENSE lv_val_dominio NO-GAPS.
    READ TABLE lt_values_tab INTO ls_values_tab WITH KEY domvalue_l = lv_val_dominio.
*    READ TABLE lt_values_tab INTO DATA(ls_values_tab) WITH KEY domvalue_l = lv_val_dominio.
    IF sy-subrc EQ 0.
      ls_autorizacao-desc_autorizacao = ls_values_tab-ddtext.
    ENDIF.

    APPEND ls_autorizacao TO it_autorizacao.
  ENDLOOP.

ENDFUNCTION.
