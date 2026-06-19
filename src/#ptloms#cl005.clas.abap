class /PTLOMS/CL005 definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods AUTENTICA
    importing
      !IM_USUARIO type XUBNAME
      !IM_SENHA type CHAR32
    exporting
      !EX_AUTENTICADO type CHAR1 .
  methods CRIA_SESSAO
    importing
      !IM_USUARIO type XUBNAME
    exporting
      !EX_SESSAO_CRIADA type CHAR1 .
  methods FINALIZA_SESSAO
    importing
      !IM_USUARIO type XUBNAME
    exporting
      !EX_SESSAO_FINALIZADA type CHAR1 .
  methods BUSCA_SESSAO
    importing
      !IM_USUARIO type XUBNAME
    exporting
      !EX_GUID type CHAR32 .
  methods ATUALIZA_SENHA
    importing
      !IM_USUARIO type XUBNAME
      !IM_SENHA type CHAR32
      !IM_CONFSENHA type CHAR32
    exporting
      !EX_SENHA_ALTERADA type CHAR1 .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL005 IMPLEMENTATION.


  METHOD atualiza_senha.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - ANDRÉ AGUIAR
*********************************************************************************************************

* Declaração de Variável
    DATA: lv_senha_criptografada     TYPE /ptloms/tb013-senha,
          lv_confsenha_criptografada TYPE /ptloms/tb013-senha,
          ls_013                     TYPE /ptloms/tb013.

* Verifica se Parâmetros de entrada foram preenchidos
    IF im_usuario IS INITIAL OR im_senha IS INITIAL OR im_confsenha IS INITIAL.
      RETURN.
    ENDIF.

* Busca informações do usuário
*    SELECT SINGLE *
*      FROM /ptloms/tb013
*      INTO @DATA(ls_013)
*      WHERE usuario = @im_usuario.

    SELECT SINGLE *
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF ls_013
      WHERE usuario = im_usuario.

* Verifica se encontrou informãções do usuário
    IF ls_013 IS INITIAL.
      RETURN.
    ENDIF.

* Criptografar senha
    CALL FUNCTION 'MD5_CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        data   = im_senha
      IMPORTING
        hash   = lv_senha_criptografada
      EXCEPTIONS
        OTHERS = 1.

* Criptografar senha
    CALL FUNCTION 'MD5_CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        data   = im_senha
      IMPORTING
        hash   = lv_confsenha_criptografada
      EXCEPTIONS
        OTHERS = 1.

    IF lv_senha_criptografada EQ lv_confsenha_criptografada.

      ls_013-senha      = lv_senha_criptografada.
      ls_013-conf_senha = lv_confsenha_criptografada.
      CLEAR ls_013-atualizar_senha.

      MODIFY /ptloms/tb013 FROM ls_013.
      IF sy-subrc EQ 0.
        COMMIT WORK.
        ex_senha_alterada = 'X'.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD autentica.

*   Declaração de Variável
    DATA: lv_senha_criptografada TYPE /ptloms/tb013-senha.

*   Verifica se Parâmetros de entrada foram preenchidos
    IF im_usuario IS INITIAL OR im_senha IS INITIAL.
      RETURN.
    ENDIF.

*   Criptografar senha
    CALL FUNCTION 'MD5_CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        data   = im_senha
      IMPORTING
        hash   = lv_senha_criptografada
      EXCEPTIONS
        OTHERS = 1.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 29/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO
*********************************************************************************************************
*   Buscar senha do usuário
    DATA: lv_senha TYPE /ptloms/tb013-senha.

    SELECT SINGLE senha FROM /ptloms/tb013 INTO lv_senha WHERE usuario = im_usuario.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

***  Buscar senha do usuário
***    SELECT SINGLE senha FROM /ptloms/tb013 INTO @DATA(lv_senha) WHERE usuario = @im_usuario.
***    IF sy-subrc NE 0.
***      RETURN.
***    ENDIF.
*********************************************************************************************************
***  FIM
*********************************************************************************************************

    IF lv_senha_criptografada EQ lv_senha.
      ex_autenticado = 'X'.
    ENDIF.

  ENDMETHOD.


  METHOD busca_sessao.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

* Verifica se parâmetro de entrada foi preenchido
    IF im_usuario IS INITIAL.
      RETURN.
    ENDIF.

* Busca sessão do Usuário
    SELECT SINGLE guid FROM /ptloms/tb032 INTO ex_guid WHERE usuario = im_usuario.
    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

  ENDMETHOD.


  method CONSTRUCTOR.
  endmethod.


  METHOD cria_sessao.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************


* Declarãção de Estrutura
    DATA: lt_032     TYPE TABLE OF /ptloms/tb032.
    DATA: ls_032     TYPE /ptloms/tb032.
    DATA: ls_032_aux TYPE /ptloms/tb032.

* Declaração de variáveis
    DATA: lv_guid_16 TYPE guid_16,
          lv_guid_22 TYPE guid_22,
          lv_guid_32 TYPE guid_32.

* Verifica se parâmetro de entrada foi preenchido
    IF im_usuario IS INITIAL.
      RETURN.
    ENDIF.

* Verifica se já existe alguma sessão aberta para o usuário
    SELECT SINGLE * FROM /ptloms/tb032 INTO CORRESPONDING FIELDS OF ls_032_aux WHERE usuario = im_usuario.
    IF sy-subrc EQ 0.
* Se já existir sessão, a mesma deve ser eliminada
*      DELETE FROM /ptloms/tb032 WHERE usuario = lv_usuario.
      ex_sessao_criada = 'X'.
      ls_032 = ls_032_aux.
      RETURN.
    ENDIF.

* Cria ID Único (Representará o número da Sessão)
    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_16 = lv_guid_16
        ev_guid_22 = lv_guid_22
        ev_guid_32 = lv_guid_32.

* Carrega parâmetros da sessão
    CLEAR ls_032.
    ls_032-usuario = im_usuario.
    ls_032-guid    = lv_guid_32.
    ls_032-data    = sy-datum.
    ls_032-hora    = sy-uzeit.

* Cria Sessão
    MODIFY /ptloms/tb032 FROM ls_032.
    IF sy-subrc EQ 0.
      ex_sessao_criada = 'X'.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.


  METHOD finaliza_sessao.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************


* Verifica se parâmetro de entrada foi preenchido
    IF im_usuario IS INITIAL.
      RETURN.
    ENDIF.

* Finaliza Sessão
    DELETE FROM /ptloms/tb032 WHERE usuario = im_usuario.
    IF sy-subrc EQ 0.
      ex_sessao_finalizada = 'X'.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
