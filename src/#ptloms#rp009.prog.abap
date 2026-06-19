*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo         : PM                                                 *
*& Tipo           : Corretivo                                          *
*& Nome           : /PTLOMS/RP009                                      *
*& Transação      : /PTLOMS/PTLOMSN030                                 *
*& Autor          : Iury Silva                                         *
*& Funcional      : Andre Aguiar                                       *
*& Objetivo       : Elimina dados histórico de rastreamento usuário    *
*&---------------------------------------------------------------------*

REPORT /ptloms/rp009.

TABLES: /ptloms/tb078.

*----------------------------------------------------------------------*
* Tela de seleção
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:     p_meses TYPE t5a4a-dlymo OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
* Processamento Principal
*----------------------------------------------------------------------*
START-OF-SELECTION.
  DATA: lv_erro        TYPE sy-subrc,
        lv_tabela      TYPE string,
        lv_msg         TYPE string,
        lv_data_limite TYPE sy-datum,
        lr_intervalo   TYPE /iwbep/t_cod_select_options,
        ls_intervalo   LIKE LINE OF lr_intervalo.

  lv_erro = 0.

***************************************************************************************
* Histórico de Rastreamento de Usuário
***************************************************************************************
  "Data atual menos quantidade de meses
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      months    = p_meses "* -1
      signum    = '-'
      years     = 0
      days      = 0
    IMPORTING
      calc_date = lv_data_limite.

  IF lv_data_limite IS NOT INITIAL.
    ls_intervalo-sign = 'I'.
    ls_intervalo-option = 'BT'.
    ls_intervalo-low = lv_data_limite.
    ls_intervalo-high = sy-datum.

    APPEND ls_intervalo TO lr_intervalo.
  ENDIF.

  DELETE FROM /ptloms/tb079 WHERE data_criacao IN lr_intervalo.
  IF sy-subrc <> 0.
    lv_erro = sy-subrc.
    lv_tabela = '/PTLOMS/TB079'.
  ENDIF.

  IF lv_erro = 0.
    COMMIT WORK AND WAIT.
    MESSAGE s000(/ptloms/cm001) WITH 'Dados eliminados com sucesso!'.
    EXIT.
  ELSE.
    ROLLBACK WORK.
    lv_msg = 'Erro ao eliminar os dados da tabela'.
    MESSAGE e000(/ptloms/cm001) DISPLAY LIKE 'E' WITH lv_msg lv_tabela.
    EXIT.
  ENDIF.
