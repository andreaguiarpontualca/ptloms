FUNCTION /ptloms/mf051.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_AUFNR) TYPE  AUFNR
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

* Declaração de tabelas interna
  DATA: lt_methods TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_return  TYPE STANDARD TABLE OF bapiret2.

* Declaração de estruturas
  DATA: ls_methods LIKE LINE OF lt_methods.

* Declaração de variável
  DATA: lv_aufnr TYPE aufnr.

* Verifica se ordem foi preenchida
  IF im_aufnr IS INITIAL.
    RETURN.
  ENDIF.

* Rotina de Conversão para Ordem
***  lv_aufnr = |{ im_aufnr ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_aufnr
    IMPORTING
      output = lv_aufnr.

* Carrega parâmetros da BAPI
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = 'HEADER'.
  ls_methods-method     = 'RELEASE'.
  ls_methods-objectkey  = lv_aufnr.
  APPEND ls_methods TO lt_methods.

* Correção de erro em função da atualização do S4H - Ini
  DATA(lv_batch) = sy-batch.

* Chama BAPI para liberação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods
      return     = lt_return.

* Correção de erro em função da atualização do S4H - Ini
  sy-batch = lv_batch.
* Correção de erro em função da atualização do S4H - Fim

* Verifica retorno
***  READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  DATA: ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.

  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.

  it_return[] = lt_return[].

ENDFUNCTION.
