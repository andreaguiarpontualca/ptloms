FUNCTION /ptloms/mf052.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_AUFNR) TYPE  AUFNR
*"     REFERENCE(IM_USUARIO_MOBILE) TYPE  XUBNAME
*"     REFERENCE(IM_DATE) TYPE  RU_IEDD
*"     REFERENCE(IM_TIME) TYPE  RU_IEDZ
*"  EXPORTING
*"     REFERENCE(EX_ENTE) TYPE  CHAR1
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 06/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

  DATA: lt_return_ente TYPE STANDARD TABLE OF bapireturn1.

  DATA: ls_return LIKE LINE OF it_return.

* Declaração de tabela interna
  DATA: lt_status TYPE STANDARD TABLE OF jstat.

* Declaração de variável
  DATA: lv_aufnr     TYPE aufnr,
        lv_objectkey TYPE objidext.

  DATA: lv_number TYPE bapi_sewocrt-orderid,
        lv_bezdt  TYPE bezdt,
        lv_bezur  TYPE bezur_d.

* Verifica se parâmetros estão preenchidos
  IF im_aufnr IS INITIAL OR im_usuario_mobile IS INITIAL.
    RETURN.
  ENDIF.

* Rotina de conversão para Ordem
***  lv_aufnr = |{ im_aufnr ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_aufnr
    IMPORTING
      output = lv_aufnr.

* Busca dados do Usuário Mobile
  DATA: lv_encerra TYPE /ptloms/tb013-encerra.
  SELECT SINGLE encerra
    FROM /ptloms/tb013
    INTO lv_encerra
    WHERE usuario = im_usuario_mobile.

***  SELECT SINGLE encerra
***    FROM /ptloms/tb013
***    INTO @DATA(lv_encerra)
***    WHERE usuario = @im_usuario_mobile.

* Verifica se no cadastro do usuário está marcado para encerrar tecnicamente a ordem
  IF lv_encerra NE 'X'.
    RETURN.
  ENDIF.

* Busca OBJNR da Ordemd
  DATA: lv_objnr LIKE aufk-objnr.
  SELECT SINGLE objnr
    FROM aufk
    INTO lv_objnr
    WHERE aufnr = lv_aufnr.

***  SELECT SINGLE objnr
***    FROM aufk
***    INTO @DATA(lv_objnr)
***    WHERE aufnr = @lv_aufnr.

* Se não encontrar OBJNR, então retorna
  IF lv_objnr IS INITIAL.
    RETURN.
  ENDIF.

* Busca status da Ordem
  CALL FUNCTION 'STATUS_READ'
    EXPORTING
      client           = sy-mandt
      objnr            = lv_objnr
      only_active      = 'X'
    TABLES
      status           = lt_status
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.

* Verifica se a Ordem possui o status I0009 (Confirmado)
  READ TABLE lt_status WITH KEY stat = 'I0009' TRANSPORTING NO FIELDS.

* Se não encontrar status, então retorna
  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

  MOVE: lv_aufnr TO lv_number,
        im_date  TO lv_bezdt,
        im_time  TO lv_bezur.

  CALL FUNCTION 'BAPI_ISUSMORDER_SETSTATUSTECHN'
    EXPORTING
      number        = lv_number
      referencedate = lv_bezdt
      referencetime = lv_bezur
    TABLES
      return        = lt_return_ente.
*** Teste ENTE - Fim

* Verifica retorno
*  READ TABLE lt_return_ente INTO DATA(ls_return_aux) WITH KEY type = 'E'.
  DATA ls_return_aux LIKE LINE OF lt_return_ente.
  READ TABLE lt_return_ente INTO ls_return_aux WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    ex_ente = 'X'.
  ENDIF.

*** LOOP AT lt_return_ente INTO DATA(ls_return_ente).
  DATA: ls_return_ente LIKE LINE OF lt_return_ente.
  LOOP AT lt_return_ente INTO ls_return_ente.
    CLEAR ls_return.
    MOVE-CORRESPONDING ls_return_ente TO ls_return.
    APPEND ls_return TO it_return.
  ENDLOOP.


ENDFUNCTION.
