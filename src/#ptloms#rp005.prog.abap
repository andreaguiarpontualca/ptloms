*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          Pontual    consultores    associados     ltda.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : pm                                                *
*& tipo            : report                                            *
*& nome            : /ptloms/rp005                                     *
*& transação       :                                                   *
*& objetivo        : ajuste de confirmação                             *
*&---------------------------------------------------------------------*
*&                     controle de alterações                          *
*&---------------------------------------------------------------------*
*& data      |responsável|request   |descrição                         *
*&---------------------------------------------------------------------*

*********************************************************************************************************
***  trecho do código abaixo revisado em 30/04/2024 em função da incompatibilidade de versão com a solar.
*********************************************************************************************************
***  Inicio - renato costa
*********************************************************************************************************

REPORT /ptloms/rp005 MESSAGE-ID /ptloms/cm001.

*&---------------------------------------------------------------------*
*& Tables
*&---------------------------------------------------------------------*
TABLES: afru.

*&---------------------------------------------------------------------*
*& Tela de seleção
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_aufnr FOR afru-aufnr,
                s_ernam FOR afru-ernam DEFAULT 'ptloms',
                s_budat FOR afru-budat.
PARAMETERS p_tp_con TYPE learr OBLIGATORY.
PARAMETERS p_rep AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b1.

*&---------------------------------------------------------------------*
*& Processamento principal
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_start.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  f_start
*&---------------------------------------------------------------------*
FORM f_start .

  DATA: lt_afru TYPE STANDARD TABLE OF afru.

  PERFORM f_busca_dados TABLES lt_afru.
  PERFORM f_processa_dados TABLES lt_afru.

  MESSAGE s000 WITH 'dados processados com sucesso'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_busca_dados
*&---------------------------------------------------------------------*
FORM f_busca_dados TABLES pt_afru STRUCTURE afru.

* Busca ordens
  SELECT *
    FROM afru
    INTO TABLE pt_afru
    WHERE aufnr IN s_aufnr
      AND budat IN s_budat
      AND ernam IN s_ernam
      AND stokz EQ space "desconsidera estornados
      AND stzhl EQ 0. "Desconsidera lançamentos de estorno

  IF p_rep IS INITIAL.
*    Select *
*      from /ptloms/tb042
*      into table @data(lt_lt042)
*      where aufnr in @s_aufnr.
    DATA: lt_lt042 TYPE TABLE OF /ptloms/tb042,
          ls_042   LIKE LINE OF lt_lt042.

    SELECT *
    FROM /ptloms/tb042
    INTO CORRESPONDING FIELDS OF TABLE lt_lt042
    WHERE aufnr IN s_aufnr.

    LOOP AT lt_lt042 INTO ls_042.
*    Loop at lt_lt042 into data(ls_042).
      DELETE pt_afru WHERE aufnr = ls_042-aufnr.
    ENDLOOP.

  ENDIF.

  IF pt_afru[] IS INITIAL.
    MESSAGE s000 WITH 'não foram selecionados dados para execução' DISPLAY LIKE 'e'.
    STOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_processa_dados
*&---------------------------------------------------------------------*
FORM f_processa_dados TABLES pt_afru STRUCTURE afru.


  DATA: ls_afru            LIKE LINE OF pt_afru,
        lt_afru_ordem_oper TYPE TABLE OF afru.

  LOOP AT pt_afru INTO ls_afru.
*  Loop at pt_afru into data(ls_afru).

    lt_afru_ordem_oper = pt_afru[].
*    DATA(lt_afru_ordem_oper) = pt_afru[].

* Mantém apenas registros da mesma ordem/operação
    DELETE lt_afru_ordem_oper WHERE aufnr NE ls_afru-aufnr OR vornr NE ls_afru-vornr.

* Ordena de forma decrescente
    SORT lt_afru_ordem_oper BY rueck DESCENDING rmzhl DESCENDING.

* Processar estorno por ordem/operação
    DATA s_afru_ordem_oper LIKE LINE OF lt_afru_ordem_oper.
    DATA ls_afru_ordem_oper LIKE LINE OF lt_afru_ordem_oper.

    LOOP AT lt_afru_ordem_oper INTO s_afru_ordem_oper.
*    LOOP AT lt_afru_ordem_oper INTO DATA(s_afru_ordem_oper).
* Estorna lançamento
    PERFORM f_estorna USING ls_afru_ordem_oper.
  ENDLOOP.

* Ordena de forma crescente
  SORT lt_afru_ordem_oper BY rueck ASCENDING rmzhl ASCENDING.

* Processar lançamento por ordem/operação
  LOOP AT lt_afru_ordem_oper INTO ls_afru_ordem_oper.
* Estorna lançamento
    PERFORM f_lanca_confirmacao USING ls_afru_ordem_oper.
  ENDLOOP.

* Remove da tabela principal o registros já processados
  DELETE pt_afru WHERE aufnr EQ ls_afru-aufnr AND vornr EQ ls_afru-vornr.

ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_estorna
*&---------------------------------------------------------------------*
FORM f_estorna USING p_afru TYPE afru.

  DATA :
    lv_confirmation        TYPE bapi_conf_key-conf_no,
    lv_confirmationcounter TYPE bapi_conf_key-conf_cnt,
    lv_postgdate           TYPE bapi_alm_confirmation-postg_date,
    lv_conftext            TYPE bapi_alm_confirmation-conf_text,
    ls_return              TYPE bapiret2.

  DATA: "lt_tb042 type standard table of /ptloms/tb042,
        ls_tb042 TYPE /ptloms/tb042.

  lv_confirmation        = p_afru-rueck.
  lv_confirmationcounter = p_afru-rmzhl.
  lv_conftext            = 'reprocessamento apontamentos oms.'.

  CALL FUNCTION 'BAPI_ALM_CONF_CANCEL'
    EXPORTING
      confirmation        = lv_confirmation
      confirmationcounter = lv_confirmationcounter
*     postgdate           = lv_postgdate
      conftext            = lv_conftext
    IMPORTING
      return              = ls_return
*     locked              =
*     created_conf_no     =
*     created_conf_count  =
    .
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'x'.

  ls_tb042-chave         = 'e'.
  ls_tb042-conf_no_refe  = p_afru-rueck.
  ls_tb042-conf_cnt_refe = p_afru-rmzhl.
  ls_tb042-aufnr         = p_afru-aufnr.
  ls_tb042-vornr         = p_afru-vornr.

  IF ls_return-type = 'e'.
    ls_tb042-status = 'e'.
  ELSE.
    ls_tb042-status = 's'.
  ENDIF.

  MODIFY /ptloms/tb042 FROM ls_tb042.
  IF sy-subrc EQ 0.
    COMMIT WORK AND WAIT.
  ELSE.
    ROLLBACK WORK.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_lanca_confirmacao
*&---------------------------------------------------------------------*
FORM f_lanca_confirmacao USING p_afru TYPE afru.

* Declarações para bapi
  DATA: lt_timetickets   TYPE STANDARD TABLE OF bapi_alm_timeconfirmation,
        lt_detail_return TYPE STANDARD TABLE OF bapi_alm_return.

  DATA: ls_timetickets TYPE bapi_alm_timeconfirmation.

  DATA: ls_return_conf TYPE bapiret2,
        ls_conf_detail TYPE bapi_alm_confirmation.

  DATA: "lt_tb042 type standard table of /ptloms/tb042,
        ls_tb042 TYPE /ptloms/tb042.

  CALL FUNCTION 'BAPI_ALM_CONF_GETDETAIL'
    EXPORTING
      confirmation        = p_afru-rueck
      confirmationcounter = p_afru-rmzhl
    IMPORTING
      return              = ls_return_conf
      conf_detail         = ls_conf_detail.

  MOVE-CORRESPONDING ls_conf_detail TO ls_timetickets.

*  Ls_timetickets-act_type = 'hman'.
  ls_timetickets-act_type = p_tp_con.

  APPEND ls_timetickets TO lt_timetickets.

* Confirma mão de obra
  CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
    TABLES
      timetickets   = lt_timetickets
      detail_return = lt_detail_return.

  ls_tb042-chave         = 'c'.
  ls_tb042-conf_no_refe  = p_afru-rueck.
  ls_tb042-conf_cnt_refe = p_afru-rmzhl.
  ls_tb042-aufnr         = p_afru-aufnr.
  ls_tb042-vornr         = p_afru-vornr.

  data ls_detail_return like LINE OF lt_detail_return.

  READ TABLE lt_detail_return INTO ls_detail_return WITH KEY type = 'e'.
*  READ TABLE lt_detail_return INTO DATA(ls_detail_return) WITH KEY type = 'e'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'x'.

* Busca conf_cnt
    LOOP AT lt_detail_return INTO ls_detail_return WHERE conf_cnt IS NOT INITIAL.
      EXIT.
    ENDLOOP.

    ls_tb042-conf_no  = ls_detail_return-conf_no.
    ls_tb042-conf_cnt = ls_detail_return-conf_cnt.
    ls_tb042-status   = 's'.
  ELSE.
    ls_tb042-status   = 'e'.
  ENDIF.

  MODIFY /ptloms/tb042 FROM ls_tb042.
  IF sy-subrc EQ 0.
    COMMIT WORK AND WAIT.
  ELSE.
    ROLLBACK WORK.
  ENDIF.
ENDFORM.
