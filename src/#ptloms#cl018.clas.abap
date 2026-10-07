class /PTLOMS/CL018 definition
  public
  final
  create public .

public section.

  types:
    tt_werks TYPE RANGE OF viaufks-werks .
  types:
    tt_auart      TYPE RANGE OF viaufks-auart .
  types:
    tt_usuperfil TYPE RANGE OF /ptloms/tb013-usuario .
  types:
    tt_eqtyp TYPE RANGE OF equi-eqtyp .
  types:
    tt_fltyp TYPE RANGE OF fltyp .

  class-methods PESQUISAR_RESPOSTAS
    importing
      !IV_ORDEM type AUFNR
      !IV_USUARIO type ERNAM
      !IV_FORMULARIO type /PTLOMS/ED059
      !IV_ERDAT_INI type ERDAT
      !IV_ERDAT_FIM type ERDAT
    exporting
      !ET_DADOS type /PTLOMS/CT170 .
  methods BUSCA_RESPOSTAS
    importing
      value(I_RESPOSTAS) type /PTLOMS/CT088
    exporting
      value(E_RESPOSTAS) type /PTLOMS/CT088
      value(E_RETORNO) type /PTLOMS/CT156 .
protected section.
private section.

  data IT_LISTA type /PTLOMS/CT123 .
  data IT_RETORNO type /PTLOMS/CT060 .
ENDCLASS.



CLASS /PTLOMS/CL018 IMPLEMENTATION.


  METHOD busca_respostas.

    DATA: lt_tb076     TYPE TABLE OF /ptloms/tb076,
          ls_tb076     TYPE /ptloms/tb076,
          lt_respostas TYPE TABLE OF /ptloms/et090,
          ls_respostas TYPE /ptloms/et090,
          ls_retorno   TYPE /ptloms/et060.

    LOOP AT i_respostas INTO ls_respostas.

      CLEAR ls_tb076.

      MOVE-CORRESPONDING ls_respostas TO ls_tb076.

*     Conversão da ordem
      CLEAR ls_tb076-ordem.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_respostas-ordem
        IMPORTING
          output = ls_tb076-ordem.

      CONDENSE ls_tb076-ordem NO-GAPS.

*     Conversão da operação
      CLEAR ls_tb076-operacao.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_respostas-operacao
        IMPORTING
          output = ls_tb076-operacao.

      CONDENSE ls_tb076-operacao NO-GAPS.

*     Dados de controle
      ls_tb076-mandt  = sy-mandt.

      ls_tb076-erdat  = sy-datum.
      ls_tb076-ernam  = sy-uname.
      ls_tb076-erzeit = sy-uzeit.

      ls_tb076-aedat  = sy-datum.
      ls_tb076-aenam  = sy-uname.
      ls_tb076-aezeit = sy-uzeit.

      ls_tb076-status = 'SUCESSO'.

      APPEND ls_tb076 TO lt_tb076.

    ENDLOOP.

    IF lt_tb076 IS NOT INITIAL.

      MODIFY /ptloms/tb076
        FROM TABLE lt_tb076.

      IF sy-subrc = 0.

        COMMIT WORK AND WAIT.

        CLEAR ls_retorno.

        ls_retorno-chave   = 'X'.
        ls_retorno-type    = 'S'.
        ls_retorno-message =
          'Tab. /PTLOMS/TB076 atualizada com sucesso'.

        APPEND ls_retorno TO e_retorno.

        LOOP AT i_respostas INTO ls_respostas.

          ls_respostas-chave  = 'X'.
          ls_respostas-status = 'SUCESSO'.

          APPEND ls_respostas TO e_respostas.

        ENDLOOP.

      ELSE.

        ROLLBACK WORK.

        LOOP AT i_respostas INTO ls_respostas.

          ls_respostas-chave  = 'X'.
          ls_respostas-status = 'ERRO'.

          APPEND ls_respostas TO e_respostas.

        ENDLOOP.

        CLEAR ls_retorno.

        ls_retorno-chave   = 'X'.
        ls_retorno-type    = 'W'.
        ls_retorno-message =
          'Erro ao atualizar Tab. /PTLOMS/TB076'.

        APPEND ls_retorno TO e_retorno.

      ENDIF.

    ENDIF.

  ENDMETHOD.


METHOD pesquisar_respostas.

  DATA: lv_ordem      TYPE aufnr,
        lv_usuario    TYPE ernam,
        lv_formulario TYPE /ptloms/ed059,
        lv_erdat_ini  TYPE erdat,
        lv_erdat_fim  TYPE erdat,
        lv_erdat_aux  TYPE erdat.

  DATA: lt_ordem_rng      TYPE RANGE OF /ptloms/tb076-ordem,
        wa_ordem_rng      LIKE LINE OF lt_ordem_rng,
        lt_usuario_rng    TYPE RANGE OF /ptloms/tb076-usuario,
        wa_usuario_rng    LIKE LINE OF lt_usuario_rng,
        lt_formulario_rng TYPE RANGE OF /ptloms/tb076-formulario,
        wa_formulario_rng LIKE LINE OF lt_formulario_rng,
        lt_erdat_rng      TYPE RANGE OF /ptloms/tb076-erdat,
        wa_erdat_rng      LIKE LINE OF lt_erdat_rng.

* Tabelas para recuperacao das descricoes dos dominios
  DATA: lt_dm038 TYPE TABLE OF dd07v,
        ls_dm038 TYPE dd07v,
        lt_dm022 TYPE TABLE OF dd07v,
        ls_dm022 TYPE dd07v,
        lt_dm023 TYPE TABLE OF dd07v,
        ls_dm023 TYPE dd07v.

  FIELD-SYMBOLS: <fs_dados> LIKE LINE OF et_dados.

  CLEAR et_dados.

  lv_ordem      = iv_ordem.
  lv_usuario    = iv_usuario.
  lv_formulario = iv_formulario.
  lv_erdat_ini  = iv_erdat_ini.
  lv_erdat_fim  = iv_erdat_fim.


*---------------------------------------------------------------------*
* Evita pesquisa totalmente aberta
*---------------------------------------------------------------------*
  IF lv_ordem IS INITIAL
     AND lv_usuario IS INITIAL
     AND lv_formulario IS INITIAL
     AND lv_erdat_ini IS INITIAL
     AND lv_erdat_fim IS INITIAL.
    RETURN.
  ENDIF.


*---------------------------------------------------------------------*
* Ordem
*---------------------------------------------------------------------*
  IF lv_ordem IS NOT INITIAL.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_ordem
      IMPORTING
        output = lv_ordem.

    CLEAR wa_ordem_rng.
    wa_ordem_rng-sign   = 'I'.
    wa_ordem_rng-option = 'EQ'.
    wa_ordem_rng-low    = lv_ordem.
    APPEND wa_ordem_rng TO lt_ordem_rng.

  ELSE.

    CLEAR wa_ordem_rng.
    wa_ordem_rng-sign   = 'I'.
    wa_ordem_rng-option = 'CP'.
    wa_ordem_rng-low    = '*'.
    APPEND wa_ordem_rng TO lt_ordem_rng.

  ENDIF.


*---------------------------------------------------------------------*
* Usuario
*---------------------------------------------------------------------*
  IF lv_usuario IS NOT INITIAL.

    TRANSLATE lv_usuario TO UPPER CASE.

    CLEAR wa_usuario_rng.
    wa_usuario_rng-sign   = 'I'.
    wa_usuario_rng-option = 'EQ'.
    wa_usuario_rng-low    = lv_usuario.
    APPEND wa_usuario_rng TO lt_usuario_rng.

  ELSE.

    CLEAR wa_usuario_rng.
    wa_usuario_rng-sign   = 'I'.
    wa_usuario_rng-option = 'CP'.
    wa_usuario_rng-low    = '*'.
    APPEND wa_usuario_rng TO lt_usuario_rng.

  ENDIF.


*---------------------------------------------------------------------*
* Formulario
*---------------------------------------------------------------------*
  IF lv_formulario IS NOT INITIAL.

    TRANSLATE lv_formulario TO UPPER CASE.

    CLEAR wa_formulario_rng.
    wa_formulario_rng-sign   = 'I'.
    wa_formulario_rng-option = 'EQ'.
    wa_formulario_rng-low    = lv_formulario.
    APPEND wa_formulario_rng TO lt_formulario_rng.

  ELSE.

    CLEAR wa_formulario_rng.
    wa_formulario_rng-sign   = 'I'.
    wa_formulario_rng-option = 'CP'.
    wa_formulario_rng-low    = '*'.
    APPEND wa_formulario_rng TO lt_formulario_rng.

  ENDIF.


*---------------------------------------------------------------------*
* Validacao das datas de entrada
*---------------------------------------------------------------------*
  IF lv_erdat_ini IS NOT INITIAL
     AND lv_erdat_ini NE '00000000'.

    CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
      EXPORTING
        date                      = lv_erdat_ini
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.

    IF sy-subrc NE 0.
      CLEAR lv_erdat_ini.
    ENDIF.

  ENDIF.


  IF lv_erdat_fim IS NOT INITIAL
     AND lv_erdat_fim NE '00000000'.

    CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
      EXPORTING
        date                      = lv_erdat_fim
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.

    IF sy-subrc NE 0.
      CLEAR lv_erdat_fim.
    ENDIF.

  ENDIF.


*---------------------------------------------------------------------*
* Se inicio maior que fim, inverte
*---------------------------------------------------------------------*
  IF lv_erdat_ini IS NOT INITIAL
     AND lv_erdat_fim IS NOT INITIAL
     AND lv_erdat_ini GT lv_erdat_fim.

    lv_erdat_aux = lv_erdat_ini.
    lv_erdat_ini = lv_erdat_fim.
    lv_erdat_fim = lv_erdat_aux.

  ENDIF.


*---------------------------------------------------------------------*
* Range de ERDAT
*---------------------------------------------------------------------*
  CLEAR wa_erdat_rng.
  wa_erdat_rng-sign = 'I'.

  IF lv_erdat_ini IS NOT INITIAL
     AND lv_erdat_fim IS NOT INITIAL.

    wa_erdat_rng-option = 'BT'.
    wa_erdat_rng-low    = lv_erdat_ini.
    wa_erdat_rng-high   = lv_erdat_fim.

  ELSEIF lv_erdat_ini IS NOT INITIAL.

    wa_erdat_rng-option = 'GE'.
    wa_erdat_rng-low    = lv_erdat_ini.

  ELSEIF lv_erdat_fim IS NOT INITIAL.

    wa_erdat_rng-option = 'LE'.
    wa_erdat_rng-low    = lv_erdat_fim.

  ELSE.

    wa_erdat_rng-option = 'BT'.
    wa_erdat_rng-low    = '00010101'.
    wa_erdat_rng-high   = '99991231'.

  ENDIF.

  APPEND wa_erdat_rng TO lt_erdat_rng.


*---------------------------------------------------------------------*
* Pesquisa das respostas
*---------------------------------------------------------------------*
  SELECT *
    FROM /ptloms/tb076
    INTO CORRESPONDING FIELDS OF TABLE et_dados
    WHERE ordem      IN lt_ordem_rng
      AND usuario    IN lt_usuario_rng
      AND formulario IN lt_formulario_rng
      AND erdat      IN lt_erdat_rng.


*---------------------------------------------------------------------*
* Recupera descricoes dos dominios
*---------------------------------------------------------------------*

* Tipo de Uso
* Dominio: /PTLOMS/DM038
  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname        = '/PTLOMS/DM038'
      text           = 'X'
      langu          = sy-langu
    TABLES
      dd07v_tab      = lt_dm038
    EXCEPTIONS
      wrong_textflag = 1
      OTHERS         = 2.

  IF sy-subrc EQ 0.
    SORT lt_dm038 BY domvalue_l.
  ELSE.
    CLEAR lt_dm038.
  ENDIF.


* Tipo de Vinculo
* Dominio: /PTLOMS/DM022
  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname        = '/PTLOMS/DM022'
      text           = 'X'
      langu          = sy-langu
    TABLES
      dd07v_tab      = lt_dm022
    EXCEPTIONS
      wrong_textflag = 1
      OTHERS         = 2.

  IF sy-subrc EQ 0.
    SORT lt_dm022 BY domvalue_l.
  ELSE.
    CLEAR lt_dm022.
  ENDIF.


* Tipo de Resposta
* Dominio: /PTLOMS/DM023
  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname        = '/PTLOMS/DM023'
      text           = 'X'
      langu          = sy-langu
    TABLES
      dd07v_tab      = lt_dm023
    EXCEPTIONS
      wrong_textflag = 1
      OTHERS         = 2.

  IF sy-subrc EQ 0.
    SORT lt_dm023 BY domvalue_l.
  ELSE.
    CLEAR lt_dm023.
  ENDIF.


*---------------------------------------------------------------------*
* Tratamento dos dados retornados
*---------------------------------------------------------------------*
  LOOP AT et_dados ASSIGNING <fs_dados>.


*---------------------------------------------------------------------*
* Descricao do Tipo de Uso
*---------------------------------------------------------------------*
    CLEAR <fs_dados>-descr_tipo_uso.

    IF <fs_dados>-tipo_uso IS NOT INITIAL.

      READ TABLE lt_dm038 INTO ls_dm038
        WITH KEY domvalue_l = <fs_dados>-tipo_uso
        BINARY SEARCH.

      IF sy-subrc EQ 0.
        <fs_dados>-descr_tipo_uso = ls_dm038-ddtext.
      ENDIF.

    ENDIF.


*---------------------------------------------------------------------*
* Descricao do Tipo de Vinculo
*---------------------------------------------------------------------*
    CLEAR <fs_dados>-descr_tp_vinculo.

    IF <fs_dados>-tp_vinculo IS NOT INITIAL.

      READ TABLE lt_dm022 INTO ls_dm022
        WITH KEY domvalue_l = <fs_dados>-tp_vinculo
        BINARY SEARCH.

      IF sy-subrc EQ 0.
        <fs_dados>-descr_tp_vinculo = ls_dm022-ddtext.
      ENDIF.

    ENDIF.


*---------------------------------------------------------------------*
* Descricao do Tipo de Resposta
*---------------------------------------------------------------------*
    CLEAR <fs_dados>-descr_resposta.

    IF <fs_dados>-resposta IS NOT INITIAL.

      READ TABLE lt_dm023 INTO ls_dm023
        WITH KEY domvalue_l = <fs_dados>-resposta
        BINARY SEARCH.

      IF sy-subrc EQ 0.
        <fs_dados>-descr_resposta = ls_dm023-ddtext.
      ENDIF.

    ENDIF.


*---------------------------------------------------------------------*
* Conversao da ordem para formato externo
*---------------------------------------------------------------------*
    IF <fs_dados>-ordem IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <fs_dados>-ordem
        IMPORTING
          output = <fs_dados>-ordem.

    ENDIF.


*---------------------------------------------------------------------*
* Saneamento ERDAT
*---------------------------------------------------------------------*
    IF <fs_dados>-erdat IS NOT INITIAL
       AND <fs_dados>-erdat NE '00000000'.

      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = <fs_dados>-erdat
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.

      IF sy-subrc NE 0.
        CLEAR <fs_dados>-erdat.
      ENDIF.

    ELSE.

      CLEAR <fs_dados>-erdat.

    ENDIF.


*---------------------------------------------------------------------*
* Saneamento AEDAT
*---------------------------------------------------------------------*
    IF <fs_dados>-aedat IS NOT INITIAL
       AND <fs_dados>-aedat NE '00000000'.

      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = <fs_dados>-aedat
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.

      IF sy-subrc NE 0.
        CLEAR <fs_dados>-aedat.
      ENDIF.

    ELSE.

      CLEAR <fs_dados>-aedat.

    ENDIF.

  ENDLOOP.


*---------------------------------------------------------------------*
* Ordenacao final
*---------------------------------------------------------------------*
  SORT et_dados BY ordem
                   operacao
                   formulario
                   grupo
                   ordenacao1
                   ordenacao2
                   sequencial.

ENDMETHOD.
ENDCLASS.
