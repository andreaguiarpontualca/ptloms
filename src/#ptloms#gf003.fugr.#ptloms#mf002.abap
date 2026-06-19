FUNCTION /ptloms/mf002.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_ORDEM) TYPE  /PTLOMS/ET057
*"     VALUE(IM_NOTA) TYPE  CHAR12 OPTIONAL
*"     VALUE(IM_NOCOMMIT) TYPE  CHAR1 OPTIONAL
*"     VALUE(IT_TEXTO_ORDEM) TYPE  /PTLOMS/CT059
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"  CHANGING
*"     REFERENCE(IT_OPERACAO) TYPE  /PTLOMS/CT058 OPTIONAL
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************
* Declaração de tabelas interna
  DATA: lt_methods    TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_header     TYPE STANDARD TABLE OF bapi_alm_order_headers_i,
        lt_operation  TYPE STANDARD TABLE OF bapi_alm_order_operation,
        lt_return     TYPE STANDARD TABLE OF bapiret2,
        lt_text	      TYPE STANDARD TABLE OF bapi_alm_text,
        lt_text_lines	TYPE STANDARD TABLE OF bapi_alm_text_lines.
*        lt_text_lines TYPE STANDARD TABLE OF bapi_alm_text_lines.
  DATA: ls_texto_ordem LIKE LINE OF it_texto_ordem.


* Declaração de tabela interna
  DATA: lt_status TYPE TABLE OF string.

* Declaração de estruturas
  DATA: ls_methods    LIKE LINE OF lt_methods,
        ls_header     LIKE LINE OF lt_header,
        ls_operation  LIKE LINE OF lt_operation,
        ls_text_lines LIKE LINE OF lt_text_lines,
        ls_text       LIKE LINE OF lt_text.
  DATA: ls_350           TYPE t350.
  DATA: ls_operation_aux LIKE LINE OF it_operacao.
  DATA: ls_350_aux TYPE t350.
  DATA: ls_350_aux2 TYPE t350.

* Declaraçãode variável
  DATA: lv_activity     TYPE vornr,
        lv_refnumber    TYPE ifrefnum,
        lv_datbi        TYPE datum VALUE '99991231',
        lv_nota         TYPE qmnum,
        lv_iwerk        TYPE iwerk,
        lv_texto_longo  TYPE string,
        lv_quebra_linha TYPE string VALUE cl_abap_char_utilities=>newline.
  DATA: lv_qtd_line TYPE i.
  DATA: lv_qtd_line_ini TYPE i.
  DATA lv_qtd_line_fim TYPE i.


  DATA: lv_objidext TYPE objidext VALUE '%00000000001',
        lv_ifrefnum TYPE ifrefnum VALUE 1.

* Verifica se cabeçalho da ORDEM foi preenchido
  IF im_ordem IS INITIAL.
    RETURN.
  ENDIF.

  REFRESH: lt_methods[], lt_header[], lt_operation[],
           lt_return[],  lt_text[],   lt_text_lines[].

  CLEAR ls_methods.
  ls_methods-refnumber = lv_ifrefnum.
  ls_methods-objecttype = 'HEADER'.
  IF im_nota IS INITIAL.
    ls_methods-method     = 'CREATE'.
    ls_methods-objectkey  = lv_objidext.
  ELSE.
*    lv_nota = |{ im_nota ALPHA = IN }|.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_nota
      IMPORTING
        output = lv_nota.
    ls_methods-method     = 'CREATETONOTIF'.
    ls_methods-objectkey  = lv_objidext && lv_nota.
  ENDIF.
  APPEND ls_methods TO lt_methods.

*  CLEAR ls_methods.
*  ls_methods-refnumber = lv_ifrefnum.
*  ls_methods-objecttype = 'TEXT'.
*  ls_methods-method     = 'CREATE'.
*  ls_methods-objectkey  = '%00000000001'.
*  APPEND ls_methods TO lt_methods.

* Carrega parâmetros da BAPI
  CLEAR ls_methods.
  ls_methods-refnumber = lv_ifrefnum.
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  ls_methods-objectkey  = lv_objidext.
  APPEND ls_methods TO lt_methods.

* Cabeçalho do Ordem
  CLEAR ls_header.
  MOVE-CORRESPONDING im_ordem TO ls_header.

* Converter Equipamento para Maiúsculo
  TRANSLATE ls_header-equipment TO UPPER CASE.

*  ls_header-equipment = |{ ls_header-equipment ALPHA = IN }|.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = ls_header-equipment
    IMPORTING
      output = ls_header-equipment.

  ls_header-orderid = lv_objidext.
  IF lv_nota IS NOT INITIAL.
    ls_header-notif_no = lv_nota.
  ENDIF.

  ls_header-start_date = im_ordem-data_hora_inicio+6(4) &&
                         im_ordem-data_hora_inicio+3(2) &&
                         im_ordem-data_hora_inicio(2).
  ls_header-basicstart = im_ordem-data_hora_inicio+11(2) &&
                         im_ordem-data_hora_inicio+14(2) &&
                         im_ordem-data_hora_inicio+17(2).

  IF ls_header-start_date > sy-datum.  "Consistência efetuada para contemplar data de criação da ordem no futuro - 02/06/2023
    ls_header-finish_date = im_ordem-data_hora_inicio+6(4) &&
                            im_ordem-data_hora_inicio+3(2) &&
                            im_ordem-data_hora_inicio(2).
  ELSE.
    ls_header-finish_date = im_ordem-data_hora_fim+6(4) &&
                            im_ordem-data_hora_fim+3(2) &&
                            im_ordem-data_hora_fim(2).
  ENDIF.

* 09/06/2023 - Data futura informar a hora fim igual a início
  IF ls_header-start_date > sy-datum.
    ls_header-basic_fin = im_ordem-data_hora_inicio+11(2) &&
                          im_ordem-data_hora_inicio+14(2) &&
                          im_ordem-data_hora_inicio+17(2).
* 09/06/2023 - Data futura informar a hora fim igual a início
  ELSE.
    ls_header-basic_fin = im_ordem-data_hora_fim+11(2) &&
                          im_ordem-data_hora_fim+14(2) &&
                          im_ordem-data_hora_fim+17(2).
  ENDIF.


  IF im_ordem-mn_wk_plant IS NOT INITIAL.
    lv_iwerk = im_ordem-mn_wk_plant.
  ELSEIF ls_header-equipment IS NOT INITIAL.
    SELECT SINGLE iwerk FROM v_equi INTO lv_iwerk WHERE txasp EQ 'X'
                                                    AND owner EQ space
                                                    AND spras EQ sy-langu
                                                    AND equnr EQ ls_header-equipment
                                                    AND datbi EQ lv_datbi.
  ELSEIF ls_header-funct_loc IS NOT INITIAL.
    SELECT SINGLE iwerk FROM iflot INTO lv_iwerk WHERE tplnr = ls_header-funct_loc.
  ELSEIF ls_header-planplant IS NOT INITIAL.
    lv_iwerk = ls_header-planplant.
  ENDIF.

* Conversão local de instalação
  CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
    EXPORTING
      input  = ls_header-funct_loc
    IMPORTING
      output = ls_header-funct_loc
    EXCEPTIONS
*     not_found = 1
*     OTHERS = 2.
      OTHERS = 0.

  APPEND ls_header TO lt_header.

* Preenche texto da ordem
  IF im_ordem-texto_longo IS NOT INITIAL.

    CLEAR ls_methods.
    ls_methods-refnumber = lv_ifrefnum.
    ls_methods-objecttype = 'TEXT'.
    ls_methods-method     = 'CREATE'.
    ls_methods-objectkey  = lv_objidext.
    APPEND ls_methods TO lt_methods.

*    SPLIT im_ordem-texto_longo  AT lv_quebra_linha INTO TABLE lt_status.
*    LOOP AT lt_status INTO DATA(ls_status).
*      CLEAR ls_text_lines.
*      ls_text_lines-tdformat = '*'.
*      ls_text_lines-tdline   = ls_status.
*      APPEND ls_text_lines TO lt_text_lines.
*    ENDLOOP.

    IF im_ordem-short_text IS NOT INITIAL.
      CLEAR ls_text_lines.
      ls_text_lines-tdformat = '*'.
      ls_text_lines-tdline = im_ordem-short_text.
      APPEND ls_text_lines TO lt_text_lines.
    ENDIF.

* Monta Texto Longo
    CALL FUNCTION '/PTLOMS/MF054'
      EXPORTING
        im_texto_longo = im_ordem-texto_longo
      TABLES
        it_texto       = lt_text_lines.

  ELSE.
    IF it_texto_ordem[] IS NOT  INITIAL.
      CLEAR ls_text_lines.
      ls_text_lines-tdformat = '*'.
      ls_text_lines-tdline = im_ordem-short_text.
      APPEND ls_text_lines TO lt_text_lines.

      LOOP AT it_texto_ordem INTO ls_texto_ordem.
        CLEAR ls_text_lines.
        MOVE-CORRESPONDING ls_texto_ordem TO ls_text_lines.
        APPEND ls_text_lines TO lt_text_lines.
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF lt_text_lines[] IS NOT INITIAL.
    DESCRIBE TABLE lt_text_lines LINES lv_qtd_line.
    ls_text-orderid   = lv_objidext.
    ls_text-langu     = sy-langu.
    ls_text-langu_iso = sy-langu.
    ls_text-textstart = 1.
    ls_text-textend   = lv_qtd_line.
    APPEND ls_text TO lt_text.
  ENDIF.

* Preenche operações
*  CLEAR lv_refnumber.
  CLEAR lv_activity.
* Busca configuração do tipo de ordem

  SELECT SINGLE *
    FROM t350
    INTO ls_350
    WHERE auart      EQ ls_header-order_type
     AND notdat      EQ 'X'
*     AND qmart       NE @space
     AND ( extended_ol EQ '2' OR extended_ol EQ '3' ).
* Se encontrar´, a ordem já cria a primeira operação automaticamente, então a primeira operação na BAPI deve ser a segunda da ordem
  IF sy-subrc EQ 0.
    lv_activity = lv_activity + 10.
  ENDIF.

  lv_refnumber = lv_ifrefnum.

  LOOP AT it_operacao INTO ls_operation_aux WHERE deleted = ''.
    CLEAR ls_operation.
    MOVE-CORRESPONDING ls_operation_aux TO ls_operation.
    ls_operation-plant = ls_operation_aux-work_cntr_plant.
    ls_operation-duration_normal_unit = ls_operation-un_work.
    APPEND ls_operation TO lt_operation.

    CLEAR ls_methods.
    ls_methods-refnumber = lv_refnumber.
    ls_methods-objecttype = 'OPERATION'.
    ls_methods-method     = 'CREATE'.
    ls_methods-objectkey  = lv_objidext.
    APPEND ls_methods TO lt_methods.

    IF ls_operation_aux-texto_longo IS NOT INITIAL.
      CLEAR ls_methods.
      lv_refnumber = lv_refnumber + lv_ifrefnum.
      ls_methods-refnumber = lv_refnumber.
      ls_methods-objecttype = 'TEXT'.
      ls_methods-method     = 'CREATE'.
      ls_methods-objectkey  = lv_objidext.
      APPEND ls_methods TO lt_methods.

* Monta texto da operação

      DESCRIBE TABLE lt_text_lines LINES lv_qtd_line_ini.
      lv_qtd_line_ini = lv_qtd_line_ini + 1.

*    REFRESH lt_status[].
*    SPLIT ls_operation_aux-texto_longo  AT lv_quebra_linha INTO TABLE lt_status.
*    LOOP AT lt_status INTO ls_status.
*      CLEAR ls_text_lines.
*      ls_text_lines-tdformat = '*'.
*      ls_text_lines-tdline   = ls_status.
*      APPEND ls_text_lines TO lt_text_lines.
*    ENDLOOP.

      CLEAR lv_texto_longo.
      IF ls_operation_aux-standard_text_key IS NOT INITIAL.
        lv_texto_longo = ls_operation_aux-description && lv_quebra_linha && ls_operation_aux-texto_longo.
      ELSE.
        lv_texto_longo = ls_operation_aux-texto_longo.
      ENDIF.

* Monta Texto Longo
      CALL FUNCTION '/PTLOMS/MF054'
        EXPORTING
*         im_texto_longo = ls_operation_aux-texto_longo
          im_texto_longo = lv_texto_longo
        TABLES
          it_texto       = lt_text_lines.

      lv_activity = lv_activity + 10.
      CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
        EXPORTING
          input  = lv_activity
        IMPORTING
          output = lv_activity.

      IF lt_text_lines[] IS NOT INITIAL.
        DESCRIBE TABLE lt_text_lines LINES lv_qtd_line_fim.
        ls_text-orderid   = lv_objidext.
        ls_text-activity  = lv_activity.
        ls_text-langu     = sy-langu.
        ls_text-langu_iso = sy-langu.
        ls_text-textstart = lv_qtd_line_ini.
        ls_text-textend   = lv_qtd_line_fim.
        APPEND ls_text TO lt_text.
      ENDIF.

    ENDIF.
  ENDLOOP.

  CLEAR lv_activity.
* Busca configuração do tipo de ordem

  SELECT SINGLE *
    FROM t350
    INTO ls_350_aux
    WHERE auart      EQ ls_header-order_type
     AND notdat      EQ 'X'
*     AND qmart       NE @space
     AND ( extended_ol EQ '2' OR extended_ol EQ '3' ).
* Se encontrar´, a ordem já cria a primeira operação automaticamente, então a primeira operação na BAPI deve ser a segunda da ordem
  IF sy-subrc EQ 0.
    lv_activity = lv_activity + 10.
  ENDIF.

*  LOOP AT lt_operation ASSIGNING FIELD-SYMBOL(<fs_operation>).
  FIELD-SYMBOLS: <fs_operation> LIKE LINE OF lt_operation.
  LOOP AT lt_operation ASSIGNING <fs_operation>.
    lv_activity = lv_activity + 10.
    CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
      EXPORTING
        input  = lv_activity
      IMPORTING
        output = lv_activity.
    <fs_operation>-activity = lv_activity.
    <fs_operation>-control_key = 'PM01'.
    IF <fs_operation>-work_cntr IS NOT INITIAL.
*      <fs_operation>-plant = lv_iwerk.
      IF <fs_operation>-plant IS INITIAL.
        <fs_operation>-plant = lv_iwerk.
      ENDIF.
    ENDIF.
  ENDLOOP.

  CLEAR lv_activity.
* Busca configuração do tipo de ordem

  SELECT SINGLE *
    FROM t350
    INTO ls_350_aux2
    WHERE auart      EQ ls_header-order_type
     AND notdat      EQ 'X'
*     AND qmart       NE @space
     AND ( extended_ol EQ '2' OR extended_ol EQ '3' ).
* Se encontrar´, a ordem já cria a primeira operação automaticamente, então a primeira operação na BAPI deve ser a segunda da ordem
  IF sy-subrc EQ 0.
    lv_activity = lv_activity + 10.
  ENDIF.
  FIELD-SYMBOLS: <fs_operacao> LIKE LINE OF it_operacao.
  LOOP AT it_operacao ASSIGNING <fs_operacao> WHERE deleted = ''.
    lv_activity = lv_activity + 10.
    CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
      EXPORTING
        input  = lv_activity
      IMPORTING
        output = lv_activity.
    <fs_operacao>-activity = lv_activity.
    <fs_operacao>-control_key = 'PM01'.
    IF <fs_operacao>-work_cntr IS NOT INITIAL.
      IF <fs_operacao>-work_cntr_plant IS INITIAL.
        <fs_operacao>-plant = lv_iwerk.
      ENDIF.
    ENDIF.
  ENDLOOP.

*  CALL FUNCTION 'BUFFER_REFRESH_ALL'.

* Chama BAPI para criação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods    = lt_methods
      it_header     = lt_header
      it_operation  = lt_operation
      it_text       = lt_text
      it_text_lines = lt_text_lines
      return        = lt_return.

  IF im_nocommit IS NOT INITIAL.
    it_return[] = lt_return[].
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RETURN.
  ENDIF.

* Verifica retorno
  DATA: ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    " 11/10/2023 - Novos campos para nova tela - Ordem e operação
    LOOP AT it_operacao ASSIGNING <fs_operacao> WHERE activity IS NOT INITIAL.
      READ TABLE lt_operation ASSIGNING <fs_operation> WITH KEY activity = <fs_operacao>-activity.
      IF sy-subrc IS INITIAL.
        <fs_operacao>-vornr = <fs_operation>-activity.
      ENDIF.
      <fs_operacao>-aufnr = ls_header-orderid.
    ENDLOOP.
    " 11/10/2023 - Novos campos para nova tela - Ordem e operação
  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    FIELD-SYMBOLS: <fs_return> LIKE LINE OF lt_return.
    READ TABLE lt_return ASSIGNING <fs_return> WITH KEY type = 'E'.
    IF sy-subrc EQ 0.
      IF <fs_return>-id = 'CP' AND <fs_return>-number = 404.
        CONCATENATE <fs_return>-message 'Tipo de Ordem configurado para criar Op.Automaticamente'(006) INTO <fs_return>-message SEPARATED BY space.
***     <fs_return>-message = <fs_return>-message && | Tipo de Ordem configurado para criar Op.Automaticamente|.
      ENDIF.

      CONCATENATE <fs_return>-message
                  'Tipo da Ordem:'(007)  ls_header-order_type
                  'Texto Breve:'(008)    ls_header-short_text
                  'Loc.Inst:'(009)       ls_header-funct_loc
                  'Equip.'(010)          ls_header-equipment
                  INTO <fs_return>-message SEPARATED BY space.

***      <fs_return>-message = <fs_return>-message &&
***                           | Tipo da Ordem: | && ls_header-order_type &&
***                           | Texto Breve: | && ls_header-short_text &&
***                           | Loc.Inst: | && ls_header-funct_loc &&
***                           | Equip.: | && ls_header-equipment.

    ENDIF.
*   Definir Nota para Eliminação
    IF im_nota IS NOT INITIAL.
      CALL FUNCTION '/PTLOMS/MF050'
        EXPORTING
          im_nota = im_nota.
      ls_return-type = 'E'.

      CONCATENATE 'Nota:'(011) im_nota 'Marcada para Eliminação'(012) INTO ls_return-message SEPARATED BY space.
***   ls_return-message = |Nota: | && im_nota && | Marcada para Eliminação|.

      APPEND ls_return TO lt_return.
    ENDIF.
  ENDIF.

  it_return[] = lt_return[].

ENDFUNCTION.
