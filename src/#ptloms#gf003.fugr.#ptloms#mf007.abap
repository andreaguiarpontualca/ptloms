FUNCTION /ptloms/mf007.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_AUFNR) TYPE  AUFNR
*"     REFERENCE(IM_VORNR) TYPE  VORNR
*"     REFERENCE(IM_SUBOPER) TYPE  UVORN
*"     REFERENCE(IM_USUARIO_MOBILE) TYPE  XUBNAME
*"     REFERENCE(IM_DATE_INI) TYPE  DATUM
*"     REFERENCE(IM_TIME_INI) TYPE  UZEIT
*"     REFERENCE(IM_DATE_FIM) TYPE  DATUM
*"     REFERENCE(IM_TIME_FIM) TYPE  UZEIT
*"     REFERENCE(IM_DEV_REASON) TYPE  CO_AGRND
*"     REFERENCE(IM_FIN_CONF) TYPE  CHAR1
*"     REFERENCE(IM_DESPACHO_ANULADO) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(IM_STATUS_MOBILE) TYPE  /PTLOMS/ED010 OPTIONAL
*"     REFERENCE(IM_ASSOCIAR) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(IM_ENC_TEC) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(IM_CONF_NO) TYPE  CO_RUECK OPTIONAL
*"     REFERENCE(IM_CONF_CNT) TYPE  CO_RMZHL OPTIONAL
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

* Declaração de tabela interna
  DATA: lt_status TYPE STANDARD TABLE OF jstat.

* Declaração de estrutu
  DATA: ls_031    TYPE /ptloms/tb031,
        ls_033    TYPE /ptloms/tb033,
        ls_return LIKE LINE OF it_return.

* Declaração de variável
  DATA: lv_aufnr TYPE aufnr.

*Recupera configuração do sistema
  SELECT SINGLE *
    FROM /ptloms/tb033
    INTO CORRESPONDING FIELDS OF ls_033.


* Verifica se parâmetros estão preenchidos
  IF im_aufnr          IS INITIAL OR
     im_vornr          IS INITIAL OR
     im_usuario_mobile IS INITIAL OR
     im_date_ini       IS INITIAL OR
     im_time_ini       IS INITIAL OR
     im_date_fim       IS INITIAL OR
     im_time_fim       IS INITIAL.

    CLEAR ls_return.
    ls_return-type = 'E'.
    ls_return-message = 'Parâmetros não preenchidos'(001).
    APPEND ls_return TO it_return.
    RETURN.
  ENDIF.

* Rotina de conversão para Ordem
***  lv_aufnr = |{ im_aufnr ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_aufnr
    IMPORTING
      output = lv_aufnr.

* Verifica se existe algum Ordem/Operação à Inativar
  DATA: lt_tb031 TYPE TABLE OF /ptloms/tb031.

  IF ls_033-cesto IS INITIAL.

    SELECT *
      FROM /ptloms/tb031
      INTO TABLE lt_tb031
      WHERE aufnr           = lv_aufnr
        AND vornr           = im_vornr
        AND suboper         = im_suboper
        AND data_inativacao = '00000000'.

  ELSE.

    SELECT *
      FROM /ptloms/tb031
      INTO TABLE lt_tb031
      WHERE aufnr           = lv_aufnr
        AND vornr           = im_vornr
        AND suboper         = im_suboper
        AND usuario         = im_usuario_mobile
        AND data_inativacao = '00000000'.

  ENDIF.

***  SELECT *
***    FROM /ptloms/tb031
***    INTO TABLE @DATA(lt_tb031)
***    WHERE aufnr           = @lv_aufnr
***      AND vornr           = @im_vornr
***      AND suboper         = @im_suboper
***      AND data_inativacao = '00000000'.

* Se o parâmetro IM_DESPACHO_ANULADO preenchido, despacho foi anulado
  IF im_despacho_anulado IS NOT INITIAL.
    ls_031-status = 5. "Despacho Anulado
    IF ls_033-cesto IS NOT INITIAL.
      ls_031-conf_final = 'X'    .
    ENDIF.

* Se a operação for cancelado, então status da operação é "Não Executado"
  ELSEIF im_status_mobile = 5.

    ls_031-status = 4. "Não Executado
    IF ls_033-cesto IS NOT INITIAL.
      ls_031-conf_final = 'X'    .
    ENDIF.

*** Condição desabilitada em função do conflito gerado com o status "não executado" ao cancelar a operação da ordem no App.  Bretz/Riveli - 09/08/2022
*** Se o parâmetro DEV_REASON estiver preenchido, significa status da operação = Não executado
***  ELSEIF im_dev_reason IS NOT INITIAL AND im_fin_conf IS NOT INITIAL.
***    ls_031-status = 4. "Não executado

  ELSE.

* Busca OBJNR da Operação

    DATA: lv_objnr LIKE afvc-objnr.

    IF im_suboper IS INITIAL.

      SELECT SINGLE b~objnr
        FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
        INTO lv_objnr
        WHERE a~aufnr = lv_aufnr
*         AND b~phflg = @space
          AND b~vornr = im_vornr
          AND b~sumnr = space.

***      SELECT SINGLE b~objnr
***        FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
***        INTO @DATA(lv_objnr)
***        WHERE a~aufnr = @lv_aufnr
****          AND b~phflg = @space
***          AND b~vornr = @im_vornr
***          AND b~sumnr = @space.
    ELSE.

      DATA: lv_aplzl LIKE afvc-aplzl.

      SELECT SINGLE b~aplzl
        FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
        INTO lv_aplzl
        WHERE a~aufnr = lv_aufnr
*         AND b~phflg = space
          AND b~vornr = im_vornr
          AND b~sumnr = space.

***      SELECT SINGLE b~aplzl
***        FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
***        INTO @DATA(lv_aplzl)
***        WHERE a~aufnr = @lv_aufnr
****          AND b~phflg = @space
***          AND b~vornr = @im_vornr
***          AND b~sumnr = @space.

      IF sy-subrc EQ 0.

        SELECT SINGLE b~objnr
          FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
          INTO lv_objnr
          WHERE a~aufnr = lv_aufnr
*           AND b~phflg = @space
            AND b~vornr = im_suboper
            AND b~sumnr = lv_aplzl.

***        SELECT SINGLE b~objnr
***          FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
***          INTO @lv_objnr
***          WHERE a~aufnr = @lv_aufnr
****            AND b~phflg = @space
***            AND b~vornr = @im_suboper
***            AND b~sumnr = @lv_aplzl.

      ENDIF.
    ENDIF.

* Se não encontrar OBJNR, então retorna
    IF lv_objnr IS INITIAL.
      CLEAR ls_return.
      ls_return-type = 'E'.
      ls_return-message = 'OBJNR da Operação não econtrado'(002).
      APPEND ls_return TO it_return.
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

* Para Status = 2 (Iniciado no Dispositivo), status de sistema da operação
* deve ser CNPA (Confirmado Parcialmente)

* Verifica se a Ordem possui o status CNPA I0010 (Confirmado parcialmente)
    READ TABLE lt_status WITH KEY stat = 'I0010' TRANSPORTING NO FIELDS.

* Se não encontrar status, então retorna
    IF sy-subrc EQ 0.
      ls_031-status = 2. "Iniciado no Dispositivo
    ELSE.

* Para Status = 3 (Concluído no Dispositivo), status de sistema da operação
* deve ser CONF (Confirmado)

* Verifica se a Ordem possui o status CONF I0009 (Confirmado)
      READ TABLE lt_status WITH KEY stat = 'I0009' TRANSPORTING NO FIELDS.

* Se não encontrar status, então retorna
      IF sy-subrc EQ  0.
        ls_031-status = 3. "Concluído no Dispositivo
        IF ls_033-cesto IS NOT INITIAL.
          ls_031-conf_final = 'X'    .
        ENDIF.

        IF im_enc_tec IS NOT INITIAL.
          ls_031-status = 6. "Encerrado Tecnicamente.
          IF ls_033-cesto IS NOT INITIAL.
            ls_031-conf_final = 'X'    .
          ENDIF.
        ENDIF.

      ELSE.
        ls_031-status = 1. "Despachado para usuário
*        CLEAR ls_return.
*        ls_return-type = 'E'.
*        ls_return-message = 'Operação não possui Status de Sistema CNPA nem CONF'(003).
*        APPEND ls_return TO it_return.
*        RETURN.
      ENDIF.
    ENDIF.
  ENDIF.

* Tratativa para execuções sequenciais simultâneas - Verifica se já existe registro exatamento igual
  DATA: lt_tb031_iguais TYPE TABLE OF /ptloms/tb031.

  SELECT *
    FROM /ptloms/tb031
    INTO CORRESPONDING FIELDS OF TABLE lt_tb031_iguais
    WHERE aufnr    = lv_aufnr
      AND vornr    = im_vornr
      AND suboper  = im_suboper
      AND usuario  = im_usuario_mobile
      AND data_ini = im_date_ini
      AND hora_ini = im_time_ini
      AND data_fim = im_date_fim
      AND hora_fim = im_time_fim.

***  SELECT *
***    FROM /ptloms/tb031
***    INTO TABLE @DATA(lt_tb031_iguais)
***    WHERE aufnr    = @lv_aufnr
***      AND vornr    = @im_vornr
***      AND suboper  = @im_suboper
***      AND usuario  = @im_usuario_mobile
***      AND data_ini = @im_date_ini
***      AND hora_ini = @im_time_ini
***      AND data_fim = @im_date_fim
***      AND hora_fim = @im_time_fim.

  IF sy-subrc EQ 0.
*** DATA(lv_time_fim) = im_time_fim + 1.
    DATA: lv_time_fim LIKE sy-uzeit.
    lv_time_fim = im_time_fim + 1.

  ELSE.
    lv_time_fim = im_time_fim.
  ENDIF.

* Carregamento dos campos
  ls_031-aufnr    = lv_aufnr.
  ls_031-vornr    = im_vornr.
  ls_031-suboper  = im_suboper.
  ls_031-usuario  = im_usuario_mobile.
  ls_031-data_ini = im_date_ini.
  ls_031-hora_ini = im_time_ini.
  ls_031-data_fim = im_date_fim.
  ls_031-hora_fim = lv_time_fim.
  ls_031-conf_no  = im_conf_no.
  ls_031-conf_cnt = im_conf_cnt.

* Atualiza tabela de status no novo registro
  MODIFY /ptloms/tb031 FROM ls_031.
  IF sy-subrc NE 0.
*** DATA(lv_erro) = 'X'. "Erro ao atualizar a tabela de status
    DATA: lv_erro TYPE c.
    lv_erro = 'X'.
  ENDIF.

  FIELD-SYMBOLS: <fs_031> LIKE LINE OF lt_tb031.
  DATA: ls_026 TYPE /ptloms/tb026.

  IF ls_033-cesto IS INITIAL.

* Atualiza tabela de status com capo INATIVO para os demais registros
    IF lv_erro IS INITIAL AND lt_tb031[] IS NOT INITIAL.

*** LOOP AT lt_tb031 ASSIGNING FIELD-SYMBOL(<fs_031>).
      LOOP AT lt_tb031 ASSIGNING <fs_031>.
        <fs_031>-inativo = 'X'.
        <fs_031>-data_inativacao = im_date_fim.
        <fs_031>-hora_inativacao = im_time_fim.
      ENDLOOP.

      MODIFY /ptloms/tb031 FROM TABLE lt_tb031.
      IF sy-subrc NE 0.
        lv_erro = 'X'. "Erro ao atualizar a tabela de status
      ENDIF.

*   Elimina Despacho
      IF im_fin_conf IS NOT INITIAL OR im_status_mobile = 5.

        SELECT SINGLE *
          FROM /ptloms/tb026
          INTO CORRESPONDING FIELDS OF ls_026
          WHERE aufnr        = lv_aufnr
            AND vornr        = im_vornr
            AND suboper      = im_suboper
            AND usuario      = im_usuario_mobile
            AND desassociado = space.

***      SELECT SINGLE *
***        FROM /ptloms/tb026
***        INTO @DATA(ls_026)
***        WHERE aufnr        = @lv_aufnr
***          AND vornr        = @im_vornr
***          AND suboper      = @im_suboper
***          AND usuario      = @im_usuario_mobile
***          AND desassociado = @space.

        IF sy-subrc EQ 0.
          ls_026-data_desassociacao   = im_date_fim.
          ls_026-hora_desassociacao   = im_time_fim.
          ls_026-motivo_desassociacao = 4.
          ls_026-desassociado         = 'X'.
          MODIFY /ptloms/tb026 FROM ls_026.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ELSE.

* Atualiza tabela de status com capo INATIVO para os demais registros
    IF lv_erro IS INITIAL AND lt_tb031[] IS NOT INITIAL.

*** LOOP AT lt_tb031 ASSIGNING FIELD-SYMBOL(<fs_031>).
      LOOP AT lt_tb031 ASSIGNING <fs_031> WHERE usuario EQ im_usuario_mobile.
        <fs_031>-inativo    = 'X'.
        <fs_031>-conf_final = 'X'.
        <fs_031>-data_inativacao = im_date_fim.
        <fs_031>-hora_inativacao = im_time_fim.
      ENDLOOP.

      MODIFY /ptloms/tb031 FROM TABLE lt_tb031.
      IF sy-subrc NE 0.
        lv_erro = 'X'. "Erro ao atualizar a tabela de status
      ENDIF.

*   Elimina Despacho
      IF im_fin_conf IS NOT INITIAL OR im_status_mobile = 5.

        SELECT SINGLE *
          FROM /ptloms/tb026
          INTO CORRESPONDING FIELDS OF ls_026
          WHERE aufnr        = lv_aufnr
            AND vornr        = im_vornr
            AND suboper      = im_suboper
            AND usuario      = im_usuario_mobile
            AND desassociado = space.

***      SELECT SINGLE *
***        FROM /ptloms/tb026
***        INTO @DATA(ls_026)
***        WHERE aufnr        = @lv_aufnr
***          AND vornr        = @im_vornr
***          AND suboper      = @im_suboper
***          AND usuario      = @im_usuario_mobile
***          AND desassociado = @space.

        IF sy-subrc EQ 0.
          ls_026-data_desassociacao   = im_date_fim.
          ls_026-hora_desassociacao   = im_time_fim.
          ls_026-motivo_desassociacao = 4.
          ls_026-desassociado         = 'X'.
          MODIFY /ptloms/tb026 FROM ls_026.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.

  IF lv_erro IS INITIAL.
    CLEAR ls_return.
    ls_return-type = 'S'.
    ls_return-message = |{ 'Sucesso ao atualizar status da Operação para'(004) }| & | | & |{ ls_031-status }|.
    APPEND ls_return TO it_return.

    IF im_associar IS NOT INITIAL.

      CLEAR ls_return.

***  lv_aufnr = |{ im_aufnr ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = im_aufnr
        IMPORTING
          output = lv_aufnr.

      CONDENSE lv_aufnr NO-GAPS.
      ls_return-type = 'S'.
      ls_return-id   = 'OMS'.
      ls_return-message = |{ 'Ordem'(024) }| & | | & |{ lv_aufnr }| & | | & |{ 'associada para operação'(026) }| & | | & |{ im_vornr }|.

      APPEND ls_return TO it_return.

    ELSE.

      CLEAR ls_return.

***   lv_aufnr = |{ im_aufnr ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = im_aufnr
        IMPORTING
          output = lv_aufnr.

      CONDENSE lv_aufnr NO-GAPS.
      ls_return-type = 'S'.
      ls_return-id   = 'OMS'.
      ls_return-message = |{ 'Ordem'(024) }| & | | & |{ lv_aufnr }| & | | & |{ 'desassociada p/ operação'(027) }| & | | & |{ im_vornr }|.
      APPEND ls_return TO it_return.

    ENDIF.

    COMMIT WORK.
  ELSE.
    CLEAR ls_return.
    ls_return-type = 'E'.
    ls_return-message = 'Erro ao atualizar a tabela de status'(005).
    APPEND ls_return TO it_return.

    IF im_associar IS NOT INITIAL.

      CLEAR ls_return.

***   lv_aufnr = |{ im_aufnr ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = im_aufnr
        IMPORTING
          output = lv_aufnr.

      CONDENSE lv_aufnr NO-GAPS.
      ls_return-type = 'E'.
      ls_return-id   = 'OMS'.
      ls_return-message = |{ 'Erro ao associar a Ordem'(028) }| & | | & |{ lv_aufnr }| & | | & |{ 'e operação'(029) }| & | | & |{ im_vornr }|.
      APPEND ls_return TO it_return.

    ELSE.

      CLEAR ls_return.

***   lv_aufnr = |{ im_aufnr ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = im_aufnr
        IMPORTING
          output = lv_aufnr.

      CONDENSE lv_aufnr NO-GAPS.
      ls_return-type = 'E'.
      ls_return-id   = 'OMS'.
      ls_return-message = |{ 'Erro ao desassociar a Ordem'(030) }| & | | & |{ lv_aufnr }| & | | & |{ 'e operação'(029) }| & | | & |{ im_vornr }|.
      APPEND ls_return TO it_return.

    ENDIF.

    ROLLBACK WORK.
  ENDIF.

***LOOP AT it_return ASSIGNING FIELD-SYMBOL(<fs_return>).
  FIELD-SYMBOLS: <fs_return> LIKE LINE OF it_return.
  LOOP AT it_return ASSIGNING <fs_return>.

*** lv_aufnr = |{ lv_aufnr ALPHA = OUT }|.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_aufnr
      IMPORTING
        output = lv_aufnr.

    CONDENSE lv_aufnr NO-GAPS.

    <fs_return>-message_v3 = |{ text-021 }| & | | & |{ lv_aufnr }|.
    <fs_return>-message_v4 = |{ text-022 }| & | | & |{ im_vornr }|.

  ENDLOOP.

*  it_return[] = lt_return[].
ENDFUNCTION.
