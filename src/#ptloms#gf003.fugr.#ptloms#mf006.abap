FUNCTION /ptloms/mf006.
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

* Declaração de tabelas interna
  DATA: lt_methods   TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_header    TYPE STANDARD TABLE OF bapi_alm_order_headers_i,
        lt_operation TYPE STANDARD TABLE OF bapi_alm_order_operation,
        lt_return    TYPE STANDARD TABLE OF bapiret2.

* Declaração de estruturas
  DATA: ls_methods LIKE LINE OF lt_methods,
        ls_header  LIKE LINE OF lt_header.

* Declaração de tabela interna
  DATA: lt_status TYPE STANDARD TABLE OF jstat.

* Declaração de variável
  DATA: lv_aufnr     TYPE aufnr,
        lv_objectkey TYPE objidext.

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
  DATA: lv_encerra LIKE /ptloms/tb013-encerra.
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

* Busca OBJNR da Ordem
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

  lv_objectkey = lv_aufnr.

* Carrega parâmetros da BAPI
  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = 'HEADER'.
  ls_methods-method     = 'TECHNICALCOMPLETE'.
  ls_methods-objectkey  = lv_objectkey.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  ls_methods-objectkey  = lv_objectkey.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_header.
  ls_header-orderid = lv_aufnr.
  ls_header-teco_ref_date = im_date.
  ls_header-teco_ref_time = im_time.
  APPEND ls_header TO lt_header.

*  CALL FUNCTION 'BUFFER_REFRESH_ALL'.

* Chama BAPI para criação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods   = lt_methods
      it_header    = lt_header
      it_operation = lt_operation
      return       = lt_return.

* Verifica retorno
*** READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  DATA: ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    ex_ente = 'X'.
  ENDIF.

  it_return[] = lt_return[].
ENDFUNCTION.
