class /PTLOMS/CL017 definition
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

  methods BUSCA_PERGUNTAS
    importing
      value(I_PERGUNTAS) type /PTLOMS/CT155
    exporting
      value(E_PERGUNTAS) type /PTLOMS/CT155
      value(E_OPCOES) type /PTLOMS/CT087
      value(E_RETORNO) type /PTLOMS/CT156 .
protected section.
PRIVATE SECTION.

  DATA:
    it_lista   TYPE /ptloms/ct123,
    it_retorno TYPE /ptloms/ct060.
ENDCLASS.



CLASS /PTLOMS/CL017 IMPLEMENTATION.


  METHOD busca_perguntas.

    DATA: lv_id        TYPE /ptloms/tb069-id,
          lt_tb071     TYPE TABLE OF /ptloms/tb071,
          ls_tb071     TYPE /ptloms/tb071,
          lt_tb073     TYPE TABLE OF /ptloms/tb073,
          ls_tb073     TYPE /ptloms/tb073,
          lt_tb074     TYPE TABLE OF /ptloms/tb074,
          ls_tb074     TYPE /ptloms/tb074,
          lt_tb075     TYPE TABLE OF /ptloms/tb075,
          ls_tb075     TYPE /ptloms/tb075,
          lt_perguntas TYPE TABLE OF /ptloms/et088,
          ls_perguntas TYPE /ptloms/et088,
          ls_retorno   TYPE /ptloms/et060,
          ls_opcoes    TYPE /ptloms/et089.

    SELECT SINGLE id INTO lv_id
      FROM /ptloms/tb069
      WHERE descricao LIKE 'OMS'.
    CHECK sy-subrc = 0.

    SELECT * INTO TABLE lt_tb071
      FROM /ptloms/tb071
      FOR ALL ENTRIES IN i_perguntas
      WHERE aplicacao = lv_id
        AND tp_vinculo = i_perguntas-tp_vinculo
        AND descr_vinculo = i_perguntas-descr_vinculo.
    IF sy-subrc <> 0.
      ls_retorno-chave   = 'X'.
      ls_retorno-type    = 'W'.
      ls_retorno-message = 'Dados tab. /ptloms/tb071 não encontrados'.
      APPEND ls_retorno TO e_retorno.
      CLEAR ls_retorno.
    ELSE.
      SELECT * INTO TABLE lt_tb075
        FROM /ptloms/tb075
        FOR ALL ENTRIES IN lt_tb071
        WHERE aplicacao = lt_tb071-aplicacao
          AND formulario = lt_tb071-formulario.
      IF sy-subrc <> 0.
        ls_retorno-chave   = 'X'.
        ls_retorno-type    = 'W'.
        ls_retorno-message = 'Dados tab. /ptloms/tb075 não encontrados'.
        APPEND ls_retorno TO e_retorno.
        CLEAR ls_retorno.
      ELSE.
        SELECT * INTO TABLE lt_tb073
        FROM /ptloms/tb073
        FOR ALL ENTRIES IN lt_tb075
        WHERE aplicacao = lt_tb075-aplicacao
          AND grupo = lt_tb075-grupo.
        IF sy-subrc <> 0.
          ls_retorno-chave   = 'X'.
          ls_retorno-type    = 'W'.
          ls_retorno-message = 'Dados tab. /ptloms/tb073 não encontrados'.
          APPEND ls_retorno TO e_retorno.
          CLEAR ls_retorno.
        ENDIF.
      ENDIF.
    ENDIF.

    LOOP AT lt_tb071 INTO ls_tb071.

      LOOP AT lt_tb075 INTO ls_tb075
        WHERE formulario = ls_tb071-formulario.

        CLEAR ls_tb073.
        READ TABLE lt_tb073 INTO ls_tb073 WITH KEY aplicacao = ls_tb075-aplicacao
                                                   grupo = ls_tb075-grupo.

        MOVE-CORRESPONDING ls_tb075 TO ls_perguntas.
        ls_perguntas-chave = 'X'.
        ls_perguntas-tp_vinculo = ls_tb071-tp_vinculo.
        ls_perguntas-descr_vinculo = ls_tb071-descr_vinculo.
        ls_perguntas-descr_grupo = ls_tb073-descricao.
        APPEND ls_perguntas TO e_perguntas.
        CLEAR ls_perguntas.

      ENDLOOP.

    ENDLOOP.

    IF e_perguntas IS NOT INITIAL.

      APPEND LINES OF e_perguntas TO lt_perguntas.
      SORT lt_perguntas BY opcao.
      DELETE ADJACENT DUPLICATES FROM lt_perguntas COMPARING opcao.
      SELECT * INTO TABLE lt_tb074
        FROM /ptloms/tb074
        FOR ALL ENTRIES IN lt_perguntas
        WHERE opcao = lt_perguntas-opcao.
      LOOP AT lt_tb074 INTO ls_tb074.
        ls_opcoes-chave = 'X'.
        ls_opcoes-tipolistaopcao = ls_tb074-opcao.
        ls_opcoes-sequencial = ls_tb074-sequencial.
        ls_opcoes-descricao = ls_tb074-descricao.
        APPEND ls_opcoes TO e_opcoes.
        CLEAR ls_opcoes.
      ENDLOOP.

      ls_retorno-chave   = 'X'.
      ls_retorno-type    = 'S'.
      ls_retorno-message = 'Pesquisa realizada com sucesso'.
      APPEND ls_retorno TO e_retorno.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
