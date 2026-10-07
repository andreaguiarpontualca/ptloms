*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************

FUNCTION /ptloms/mf051.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_AUFNR) TYPE AUFNR
*"  TABLES
*"      IT_RETURN STRUCTURE BAPIRET2
*"----------------------------------------------------------------------

* Declaração de tabelas internas
  DATA:
    lt_methods TYPE STANDARD TABLE OF bapi_alm_order_method,
    lt_return  TYPE STANDARD TABLE OF bapiret2.

* Declaração de estruturas
  DATA:
    ls_method TYPE bapi_alm_order_method,
    ls_return TYPE bapiret2.

* Declaração de variáveis
  DATA:
    lv_aufnr TYPE aufnr,
    lv_batch TYPE sybatch,
    lv_error TYPE abap_bool.

* Inicialização
  REFRESH:
    lt_methods,
    lt_return,
    it_return.

  CLEAR:
    ls_method,
    ls_return,
    lv_aufnr,
    lv_batch,
    lv_error.

  lv_error = abap_false.

*---------------------------------------------------------------------*
* Validar número da ordem
*---------------------------------------------------------------------*
  IF im_aufnr IS INITIAL.

    CLEAR ls_return.
    ls_return-type    = 'E'.
    ls_return-id      = '00'.
    ls_return-number  = '398'.
    ls_return-message = 'Número da ordem não informado.'.

    APPEND ls_return TO it_return.
    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* Converter número da ordem para formato interno
*---------------------------------------------------------------------*
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_aufnr
    IMPORTING
      output = lv_aufnr.

*---------------------------------------------------------------------*
* Configurar liberação do cabeçalho
*---------------------------------------------------------------------*
  CLEAR ls_method.

  ls_method-refnumber  = 1.
  ls_method-objecttype = 'HEADER'.
  ls_method-method     = 'RELEASE'.
  ls_method-objectkey  = lv_aufnr.

  APPEND ls_method TO lt_methods.

*---------------------------------------------------------------------*
* Configurar gravação
*
* O método SAVE deve ser informado depois das operações que serão
* executadas pela BAPI.
*---------------------------------------------------------------------*
  CLEAR ls_method.

  ls_method-refnumber  = 1.
  ls_method-objecttype = space.
  ls_method-method     = 'SAVE'.
  ls_method-objectkey  = space.

  APPEND ls_method TO lt_methods.

*---------------------------------------------------------------------*
* Preservar indicador de execução em background
*---------------------------------------------------------------------*
  lv_batch = sy-batch.

*---------------------------------------------------------------------*
* Liberar ordem
*---------------------------------------------------------------------*
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods = lt_methods
      return     = lt_return.

* Manter somente se for necessário no ambiente S/4HANA
  sy-batch = lv_batch.

*---------------------------------------------------------------------*
* Verificar mensagens de erro
*---------------------------------------------------------------------*
  LOOP AT lt_return INTO ls_return.

    IF ls_return-type = 'E'
       OR ls_return-type = 'A'
       OR ls_return-type = 'X'.

      lv_error = abap_true.
      EXIT.

    ENDIF.

  ENDLOOP.

*---------------------------------------------------------------------*
* Confirmar ou desfazer a transação
*---------------------------------------------------------------------*
  IF lv_error = abap_false.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDIF.

*---------------------------------------------------------------------*
* Retornar mensagens da BAPI
*---------------------------------------------------------------------*
  it_return[] = lt_return[].

ENDFUNCTION.
***FUNCTION /ptloms/mf051.
****"----------------------------------------------------------------------
****"*"Interface local:
****"  IMPORTING
****"     REFERENCE(IM_AUFNR) TYPE  AUFNR
****"  TABLES
****"      IT_RETURN STRUCTURE  BAPIRET2
****"----------------------------------------------------------------------
***
**** Declaração de tabelas interna
***  DATA: lt_methods TYPE STANDARD TABLE OF bapi_alm_order_method,
***        lt_return  TYPE STANDARD TABLE OF bapiret2.
***
**** Declaração de estruturas
***  DATA: ls_methods LIKE LINE OF lt_methods.
***
**** Declaração de variável
***  DATA: lv_aufnr TYPE aufnr.
***
**** Verifica se ordem foi preenchida
***  IF im_aufnr IS INITIAL.
***    RETURN.
***  ENDIF.
***
**** Rotina de Conversão para Ordem
******  lv_aufnr = |{ im_aufnr ALPHA = IN }|.
***  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
***    EXPORTING
***      input  = im_aufnr
***    IMPORTING
***      output = lv_aufnr.
***
**** Carrega parâmetros da BAPI
***  ls_methods-objecttype = space.
***  ls_methods-method     = 'SAVE'.
***  APPEND ls_methods TO lt_methods.
***
***  CLEAR ls_methods.
***  ls_methods-refnumber = 1.
***  ls_methods-objecttype = 'HEADER'.
***  ls_methods-method     = 'RELEASE'.
***  ls_methods-objectkey  = lv_aufnr.
***  APPEND ls_methods TO lt_methods.
***
**** Correção de erro em função da atualização do S4H - Ini
***  DATA(lv_batch) = sy-batch.
***
**** Chama BAPI para liberação da Ordem
***  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
***    TABLES
***      it_methods = lt_methods
***      return     = lt_return.
***
**** Correção de erro em função da atualização do S4H - Ini
***  sy-batch = lv_batch.
**** Correção de erro em função da atualização do S4H - Fim
***
**** Verifica retorno
******  READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
***  DATA: ls_return LIKE LINE OF lt_return.
***  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
***
***  IF sy-subrc NE 0.
***    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
***      EXPORTING
***        wait = 'X'.
***  ELSE.
***    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
***  ENDIF.
***
***  it_return[] = lt_return[].
***
***ENDFUNCTION.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
