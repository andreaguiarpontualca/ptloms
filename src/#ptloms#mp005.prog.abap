*&---------------------------------------------------------------------*
*& Report  /PTLOMS/MP005
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /ptloms/mp005.

* Declaração de tabelas interna
DATA: lt_methods      TYPE STANDARD TABLE OF bapi_alm_order_method,
      lt_operation    TYPE STANDARD TABLE OF bapi_alm_order_operation,
      lt_operation_up TYPE STANDARD TABLE OF bapi_alm_order_operation_up,
      lt_return       TYPE STANDARD TABLE OF bapiret2.

* Declaração de estruturas
DATA: ls_methods      LIKE LINE OF lt_methods,
      ls_operation    LIKE LINE OF lt_operation,
      ls_operation_up LIKE LINE OF lt_operation_up.

* Declaração de variáveis
DATA: lv_objecttype TYPE objidext,
      lv_aufnr      TYPE aufnr,
      lv_vornr      TYPE vornr,
      lv_suboper    TYPE vornr,
      lv_remove     TYPE flag VALUE 'X',
      lv_achou      TYPE flag.

DATA: lt_041 TYPE TABLE OF /ptloms/tb041.
DATA: ls_041 LIKE LINE OF lt_041.
DATA: lt_operacoes TYPE TABLE OF bapi_alm_order_operation_e.
DATA: ls_operacoes LIKE LINE OF lt_operacoes.
DATA: lt_retorno   TYPE TABLE OF bapiret2.
DATA: ls_retorno   LIKE LINE OF lt_retorno.


DATA: aufnr   TYPE  aufnr.
DATA: vornr   TYPE  vornr.
DATA: suboper TYPE  uvorn.
DATA: usuario TYPE  xubname.

AUTHORITY-CHECK OBJECT '/PTLOMS/01'
         ID 'TCD' FIELD sy-tcode
         ID 'ACTVT' FIELD '02'.

IF sy-subrc <> 0.
  MESSAGE e001(/ptloms/cm001) WITH '/PTLOMS/01'.
ENDIF.

* Busca dados do usuário
SELECT *
  FROM /ptloms/tb041
  INTO TABLE lt_041
  WHERE processado NE 'X'.

LOOP AT lt_041 INTO ls_041.

  REFRESH: lt_methods[],
           lt_operation[],
           lt_operation_up[],
           lt_return[].


  aufnr = ls_041-aufnr.
  vornr = ls_041-vornr.
  suboper = ls_041-suboper.
  usuario = ls_041-usuario.

* Busca dados do usuário
  DATA: ls_013 TYPE /ptloms/tb013.
  SELECT SINGLE usuario associa matricula
    FROM /ptloms/tb013
    INTO CORRESPONDING FIELDS OF ls_013
    WHERE usuario = usuario.

* Rotina de Conversão para Ordem
*  lv_aufnr = |{ aufnr ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = aufnr
    IMPORTING
      output = lv_aufnr.


* Rotina de conversão para Operação
  IF vornr IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
      EXPORTING
        input  = vornr
      IMPORTING
        output = lv_vornr.
  ENDIF.

* Rotina de conversão para SubOperação
  IF suboper IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
      EXPORTING
        input  = suboper
      IMPORTING
        output = lv_suboper.
  ENDIF.

* Monta OBJECTTYPE
  lv_objecttype = lv_aufnr && lv_vornr && lv_suboper.

* Verifica se Ordem/Usuário estão preenchidos
  IF aufnr IS INITIAL OR usuario IS INITIAL.
*    RETURN.
    CONTINUE.
  ENDIF.

* Carrega parâmetros da BAPI
  ls_methods-refnumber = 1.
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  ls_methods-objectkey  = lv_objecttype.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = 'OPERATION'.
  ls_methods-method     = 'CHANGE'.
  ls_methods-objectkey  = lv_objecttype.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_operation.
  ls_operation-activity     = lv_vornr.
  ls_operation-sub_activity = lv_suboper.
  IF lv_remove IS INITIAL.
    ls_operation-pers_no = ls_013-matricula.
  ENDIF.
  APPEND ls_operation TO lt_operation.

  CLEAR ls_operation_up.
  ls_operation_up-pers_no = 'X'.
  APPEND ls_operation_up TO lt_operation_up.

* Chama BAPI Associar Matrícula à Opeação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods      = lt_methods
      it_operation    = lt_operation
      it_operation_up = lt_operation_up
      return          = lt_return.

* Verifica retorno
  DATA: ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    ls_041-data = sy-datum.
    ls_041-hora = sy-uzeit.
    ls_041-processado = 'X'.
    ls_041-matricula = ls_013-matricula.

    MODIFY /ptloms/tb041 FROM ls_041.

    COMMIT WORK AND WAIT.

    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number        = aufnr
      TABLES
        et_operations = lt_operacoes
        return        = lt_retorno.

    LOOP AT lt_operacoes INTO ls_operacoes.
      IF ls_operacoes-pers_no IS NOT INITIAL.
        IF ls_operacoes-complete IS INITIAL.
          lv_achou = 'X'.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_achou IS INITIAL.
      DATA: ls_026 TYPE /ptloms/tb026.
      SELECT SINGLE *
        FROM /ptloms/tb026
        INTO CORRESPONDING FIELDS OF ls_026
        WHERE aufnr        = aufnr
          AND vornr        = space
          AND suboper      = space
          AND usuario      = usuario
          AND desassociado = space.
      IF sy-subrc EQ 0.
        ls_026-data_desassociacao   = sy-datum.
        ls_026-hora_desassociacao   = sy-uzeit.
        ls_026-motivo_desassociacao = 4.
        ls_026-desassociado         = 'X'.
        MODIFY /ptloms/tb026 FROM ls_026.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.

  ENDIF.
  CLEAR lv_achou.
ENDLOOP.
