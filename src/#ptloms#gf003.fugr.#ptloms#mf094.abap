FUNCTION /ptloms/mf094.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_AUFNR) TYPE  AUFNR
*"     REFERENCE(IM_ASSOCIAR) TYPE  CHAR1 OPTIONAL
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"  CHANGING
*"     REFERENCE(IT_OPERACAO) TYPE  /PTLOMS/CT104
*"----------------------------------------------------------------------

* Declaração de tabela interna
  DATA: lt_tb026              TYPE STANDARD TABLE OF /ptloms/tb026,
        lt_tb033              TYPE STANDARD TABLE OF /ptloms/tb033,
        lt_return_status_oper TYPE STANDARD TABLE OF bapiret2,
        lt_return_assoc_mat   TYPE STANDARD TABLE OF bapiret2.

* Declaração de estrutura
  DATA: ls_return LIKE LINE OF it_return,
        ls_026    TYPE /ptloms/tb026,
        ls_033    TYPE /ptloms/tb033.

* Declaração de variáveis
  DATA: lv_aufnr     TYPE aufnr,
        lv_vornr     TYPE vornr,
        lv_suboper   TYPE uvorn,
        lv_data      TYPE datum,
        lv_hora      TYPE uzeit,
        lv_usuario   TYPE xubname,
        lv_subobject TYPE balsubobj,
        lv_extnumber TYPE balnrext,
        lv_msg       TYPE bapi_msg,
        lv_type      TYPE symsgty.

  SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_033 FROM  /ptloms/tb033.

  IF sy-subrc EQ 0.

    IF ls_033-cesto IS INITIAL.

* Valida Ordem
      IF im_aufnr IS INITIAL.
        CLEAR ls_return.
        ls_return = 'E'.
        ls_return-message = 'Ordem não informada'(020).
        APPEND ls_return TO it_return.
        RETURN.
      ENDIF.

* Valida Operações
      IF it_operacao[] IS INITIAL.
        CLEAR ls_return.
        ls_return = 'E'.
        ls_return-message = 'Operação não informada'(019).
        APPEND ls_return TO it_return.
        RETURN.
      ENDIF.

      lv_data = sy-datum.
      lv_hora = sy-uzeit.
*  lv_aufnr = |{ im_aufnr ALPHA = IN }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = im_aufnr
        IMPORTING
          output = lv_aufnr.


*  LOOP AT it_operacao INTO DATA(<ls_operacao>) WHERE usuario IS NOT INITIAL AND deleted IS INITIAL.
      FIELD-SYMBOLS: <ls_operacao> LIKE LINE OF it_operacao.
      LOOP AT it_operacao ASSIGNING <ls_operacao>.

        CLEAR ls_026.

        lv_usuario = <ls_operacao>-usuario_destino.
        lv_vornr   = <ls_operacao>-vornr.

        " Atualizar data e hora para retorno da associação do gateway no procedimento de associar operação
        <ls_operacao>-data_associacao = lv_data.
        <ls_operacao>-hora_associacao = lv_hora.

* Atualiza tabela de Despacho
        ls_026-aufnr = lv_aufnr.

        CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
          EXPORTING
            input  = lv_vornr
          IMPORTING
            output = lv_vornr.

        ls_026-vornr           = lv_vornr.
        ls_026-usuario         = lv_usuario.
        ls_026-data_associacao = lv_data.
        ls_026-hora_associacao = lv_hora.
        ls_026-mobile          = 'X'.
        APPEND ls_026 TO lt_tb026.
        MODIFY /ptloms/tb026 FROM TABLE lt_tb026.

        IF sy-subrc EQ 0.

          COMMIT WORK AND WAIT.
*
* Associa Matrícula à Operação
          CALL FUNCTION '/PTLOMS/MF036'
            EXPORTING
              im_aufnr   = lv_aufnr
              im_vornr   = lv_vornr
              im_usuario = lv_usuario
            TABLES
              it_return  = lt_return_assoc_mat.

          APPEND LINES OF lt_return_assoc_mat TO it_return.

          READ TABLE lt_return_assoc_mat TRANSPORTING NO FIELDS WITH KEY type = 'E'.

          CLEAR: lt_return_assoc_mat.



          IF sy-subrc IS NOT INITIAL.

* Atualiza status da operação
            CALL FUNCTION '/PTLOMS/MF007'
              EXPORTING
                im_aufnr            = lv_aufnr
                im_vornr            = lv_vornr
                im_suboper          = lv_suboper
                im_usuario_mobile   = lv_usuario
                im_date_ini         = lv_data
                im_time_ini         = lv_hora
                im_date_fim         = lv_data
                im_time_fim         = lv_hora
                im_dev_reason       = space
                im_fin_conf         = space
                im_despacho_anulado = space
                im_associar         = im_associar
              TABLES
                it_return           = lt_return_status_oper.

            APPEND LINES OF lt_return_status_oper TO it_return.

            READ TABLE lt_return_assoc_mat TRANSPORTING NO FIELDS WITH KEY type = 'E'.

            IF sy-subrc IS NOT INITIAL.

              CLEAR ls_return.
              ls_return-id         = 'DATA'.
              CONCATENATE ls_026-data_associacao ls_026-hora_associacao INTO ls_return-message SEPARATED BY space.
*          ls_return-message    = |{ ls_026-data_associacao }| && | { ls_026-hora_associacao } | .
*          ls_return-message_v1 = |{ im_aufnr }|.
              ls_return-message_v1 = im_aufnr.
*          ls_return-message_v2 = |{ lv_vornr }|.
              ls_return-message_v2 = lv_vornr.

              APPEND ls_return TO it_return.

            ENDIF.

          ENDIF.

          CLEAR: lt_return_status_oper.

        ENDIF.
      ENDLOOP.

    ELSE.

* Valida Ordem
      IF im_aufnr IS INITIAL.
        CLEAR ls_return.
        ls_return = 'E'.
        ls_return-message = 'Ordem não informada'(020).
        APPEND ls_return TO it_return.
        RETURN.
      ENDIF.

* Valida Operações
      IF it_operacao[] IS INITIAL.
        CLEAR ls_return.
        ls_return = 'E'.
        ls_return-message = 'Operação não informada'(019).
        APPEND ls_return TO it_return.
        RETURN.
      ENDIF.

      lv_data = sy-datum.
      lv_hora = sy-uzeit.
*  lv_aufnr = |{ im_aufnr ALPHA = IN }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = im_aufnr
        IMPORTING
          output = lv_aufnr.


*  LOOP AT it_operacao INTO DATA(<ls_operacao>) WHERE usuario IS NOT INITIAL AND deleted IS INITIAL.
      LOOP AT it_operacao ASSIGNING <ls_operacao>.

        CLEAR ls_026.

        lv_usuario = <ls_operacao>-usuario_destino.
        lv_vornr   = <ls_operacao>-vornr.

        " Atualizar data e hora para retorno da associação do gateway no procedimento de associar operação
        <ls_operacao>-data_associacao = lv_data.
        <ls_operacao>-hora_associacao = lv_hora.

* Atualiza tabela de Despacho
        ls_026-aufnr = lv_aufnr.

        CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
          EXPORTING
            input  = lv_vornr
          IMPORTING
            output = lv_vornr.

        ls_026-vornr           = lv_vornr.
        ls_026-usuario         = lv_usuario.
        ls_026-data_associacao = lv_data.
        ls_026-hora_associacao = lv_hora.
        ls_026-mobile          = 'X'.
        APPEND ls_026 TO lt_tb026.
        MODIFY /ptloms/tb026 FROM TABLE lt_tb026.

        IF sy-subrc EQ 0.

* Atualiza status da operação
          CALL FUNCTION '/PTLOMS/MF007'
            EXPORTING
              im_aufnr            = lv_aufnr
              im_vornr            = lv_vornr
              im_suboper          = lv_suboper
              im_usuario_mobile   = lv_usuario
              im_date_ini         = lv_data
              im_time_ini         = lv_hora
              im_date_fim         = lv_data
              im_time_fim         = lv_hora
              im_dev_reason       = space
              im_fin_conf         = space
              im_despacho_anulado = space
              im_associar         = im_associar
            TABLES
              it_return           = lt_return_status_oper.

          APPEND LINES OF lt_return_status_oper TO it_return.

          READ TABLE lt_return_assoc_mat TRANSPORTING NO FIELDS WITH KEY type = 'E'.

          IF sy-subrc IS NOT INITIAL.

            CLEAR ls_return.
            ls_return-id         = 'DATA'.
            CONCATENATE ls_026-data_associacao ls_026-hora_associacao INTO ls_return-message SEPARATED BY space.
*          ls_return-message    = |{ ls_026-data_associacao }| && | { ls_026-hora_associacao } | .
*          ls_return-message_v1 = |{ im_aufnr }|.
            ls_return-message_v1 = im_aufnr.
*          ls_return-message_v2 = |{ lv_vornr }|.
            ls_return-message_v2 = lv_vornr.

            APPEND ls_return TO it_return.

          ENDIF.

        ENDIF.

        CLEAR: lt_return_status_oper.
      ENDLOOP.

    ENDIF.

  ENDIF.

ENDFUNCTION.
