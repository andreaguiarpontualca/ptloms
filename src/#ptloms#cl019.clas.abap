CLASS /ptloms/cl019 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_werks TYPE RANGE OF /ptloms/et006-werks .
    TYPES:
      tt_auart      TYPE RANGE OF /ptloms/et011-auart .
    TYPES:
      tt_usuperfil TYPE RANGE OF /ptloms/tb013-usuario .
    TYPES:
      tt_eqtyp TYPE RANGE OF equi-eqtyp .
    TYPES:
      tt_fltyp TYPE RANGE OF fltyp .

    METHODS consulta_respostas
      IMPORTING
        VALUE(i_usuario)   TYPE /ptloms/et092-usuario
        VALUE(i_operacao)  TYPE /ptloms/et092-operacao
        VALUE(i_ordem)     TYPE /ptloms/et092-ordem
        VALUE(i_data_ini)  TYPE /ptloms/et092-data_ini
        VALUE(i_data_fim)  TYPE /ptloms/et092-data_fim
      EXPORTING
        VALUE(e_respostas) TYPE /ptloms/ct089
        VALUE(e_retorno)   TYPE /ptloms/ct156 .
protected section.
PRIVATE SECTION.

  DATA:
    it_lista   TYPE /ptloms/ct123,
    it_retorno TYPE /ptloms/ct060.
ENDCLASS.



CLASS /PTLOMS/CL019 IMPLEMENTATION.


  METHOD consulta_respostas.

    DATA: lt_tb076     TYPE TABLE OF /ptloms/tb076,
          ls_tb076     TYPE /ptloms/tb076,
*          lt_respostas TYPE TABLE OF /ptloms/et092,
          ls_respostas TYPE /ptloms/et092,
          ls_retorno   TYPE /ptloms/et060.

    DATA: r_usuario  TYPE RANGE OF /ptloms/tb076-usuario,
          r_operacao TYPE RANGE OF /ptloms/tb076-operacao,
          r_ordem    TYPE RANGE OF /ptloms/tb076-ordem,
          r_erdat    TYPE RANGE OF /ptloms/tb076-erdat.

    DATA: ls_usuario  LIKE LINE OF r_usuario,
          ls_operacao LIKE LINE OF r_operacao,
          ls_ordem    LIKE LINE OF r_ordem,
          ls_erdat    LIKE LINE OF r_erdat.

    DATA: lv_aufnr TYPE aufnr,
          lv_vornr TYPE vornr.

    IF i_usuario IS NOT INITIAL.
      ls_usuario-sign = 'I'.
      ls_usuario-option = 'EQ'.
      ls_usuario-low = i_usuario.
      APPEND ls_usuario TO r_usuario.
    ENDIF.

    IF i_ordem IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_ordem
        IMPORTING
          output = lv_aufnr.

      CONDENSE lv_aufnr NO-GAPS.

      ls_ordem-sign = 'I'.
      ls_ordem-option = 'EQ'.
*      ls_ordem-low = i_ordem.
      ls_ordem-low = lv_aufnr.
      APPEND ls_ordem TO r_ordem.
    ENDIF.

    IF i_operacao IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_operacao
        IMPORTING
          output = lv_vornr.

      CONDENSE lv_vornr NO-GAPS.

      ls_operacao-sign = 'I'.
      ls_operacao-option = 'EQ'.
*      ls_operacao-low = i_operacao.
      ls_operacao-low = lv_vornr.
      APPEND ls_operacao TO r_operacao.
    ENDIF.

    ls_erdat-sign = 'I'.
    ls_erdat-option = 'BT'.
    IF i_data_ini IS NOT INITIAL.
      ls_erdat-low = i_data_ini.
    ELSE.
      ls_erdat-low = '00000000'.
    ENDIF.

    IF i_data_fim IS NOT INITIAL.
      ls_erdat-high = i_data_fim.
    ELSE.
      ls_erdat-high = sy-datum.
    ENDIF.
    APPEND ls_erdat TO r_erdat.

    SELECT * INTO TABLE lt_tb076
      FROM /ptloms/tb076
      WHERE usuario IN r_usuario
        AND operacao IN r_operacao
        AND ordem IN r_ordem.
*        and erdat in r_erdat.
    IF sy-subrc <> 0.
      ls_retorno-chave   = 'X'.
      ls_retorno-type    = 'W'.
      ls_retorno-message = 'Nenhum dado encontrado na Tab. /PTLOMS/TB076'.
      APPEND ls_retorno TO e_retorno.
      EXIT.
    ENDIF.

    ls_retorno-chave   = 'X'.
    ls_retorno-type    = 'S'.
    ls_retorno-message = 'Sucesso'.
    APPEND ls_retorno TO e_retorno.

    LOOP AT lt_tb076 INTO ls_tb076.
      MOVE-CORRESPONDING ls_tb076 TO ls_respostas.
      ls_respostas-chave   = 'X'.
      APPEND ls_respostas TO e_respostas.
      CLEAR ls_respostas.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
