*&---------------------------------------------------------------------*
*& Report  /PTLOMS/RP033
*&---------------------------------------------------------------------*
*& Processamento dos canais. Agendamento inicial recomendado: a cada
*  5 minutos.
*  O job deve permanecer agendado; não criar ou excluir dinamicamente
*  conforme a configuração.
*&---------------------------------------------------------------------*
REPORT /ptloms/rp033 MESSAGE-ID /ptloms/cm001.

DATA: it_tb105     TYPE TABLE OF /ptloms/tb105,
      it_tb105_aux TYPE TABLE OF /ptloms/tb105,
      wa_tb105     TYPE /ptloms/tb105.

DATA: lv_sucesso  TYPE xfeld,
      lv_mensagem TYPE /ptloms/ed162,
      lv_tabix    TYPE i,
      lv_lote     TYPE i,
      lv_alertas  TYPE /ptloms/tb033-alertas.

SELECTION-SCREEN BEGIN OF BLOCK b1.
PARAMETERS: p_limite TYPE i DEFAULT 3,
            p_lote   TYPE i DEFAULT 500.
SELECTION-SCREEN END OF BLOCK b1.


*-----------------*
START-OF-SELECTION.
*-----------------*
  PERFORM f_seleciona_dados.
  PERFORM f_processa_dados.

*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
FORM f_seleciona_dados .

* Verificar Config. Gerais
  SELECT SINGLE alertas INTO lv_alertas
    FROM /ptloms/tb033
    WHERE alertas = abap_true.
  IF sy-subrc <> 0.
    LEAVE LIST-PROCESSING.
  ENDIF.

* Selecionar emails a serem enviados
  SELECT * INTO TABLE it_tb105
    FROM /ptloms/tb105
    WHERE status_email = 'P'
      AND tent_email <= p_limite.
  IF sy-subrc <> 0.
    MESSAGE i000 WITH 'Nenhum dado válido foi selecionado' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_PROCESSA_DADOS
*&---------------------------------------------------------------------*
FORM f_processa_dados .

* Bloqueio da tabela
  CALL FUNCTION 'ENQUEUE_/PTLOMS/ENOTIF'
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
    MESSAGE i000 WITH 'Erro no bloqueio (ENQUEUE) tab. /PTLOMS/Tb105' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

* Processamento dos emails
  LOOP AT it_tb105 INTO wa_tb105.
    lv_tabix = sy-tabix.
    lv_lote = lv_lote + 1.

    CALL METHOD /ptloms/cl029=>enviar_email
      EXPORTING
        iv_id_notificacao = wa_tb105-id_notificacao
        iv_usuario        = wa_tb105-usuario
      IMPORTING
        ev_sucesso        = lv_sucesso
        ev_mensagem       = lv_mensagem.
    IF lv_sucesso = abap_true.  " Sucesso
      wa_tb105-status_email = 'S'.
      wa_tb105-data_email = sy-datum.
      wa_tb105-hora_email = sy-uzeit.
    ELSE.                       " Erro
      wa_tb105-tent_email = wa_tb105-tent_email + 1.
      wa_tb105-erro_email = lv_mensagem.
      IF wa_tb105-tent_email = p_limite.
        wa_tb105-status_email = 'E'.
      ENDIF.
    ENDIF.
    APPEND wa_tb105 TO it_tb105_aux.

    IF lv_lote >= p_lote.
      MODIFY /ptloms/tb105 FROM TABLE it_tb105_aux.
      COMMIT WORK AND WAIT.
      FREE it_tb105_aux.
      CLEAR lv_lote.
    ENDIF.

  ENDLOOP.

  IF it_tb105_aux IS NOT INITIAL.
    MODIFY /ptloms/tb105 FROM TABLE it_tb105.
    COMMIT WORK AND WAIT.
  ENDIF.

  CALL FUNCTION 'DEQUEUE_/PTLOMS/ENOTIF'.

ENDFORM.
