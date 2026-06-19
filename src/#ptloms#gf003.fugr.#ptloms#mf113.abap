FUNCTION /ptloms/mf113.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_ORDEM) TYPE  /PTLOMS/ET087
*"     VALUE(IM_AUFNR) TYPE  CHAR12 OPTIONAL
*"     VALUE(IM_NOCOMMIT) TYPE  CHAR1 OPTIONAL
*"     VALUE(IT_TEXTO_ORDEM) TYPE  /PTLOMS/CT059
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

* Declaração de tabelas interna
  DATA: lt_methods      TYPE bapi_alm_order_method       OCCURS 0 WITH HEADER LINE,
        lt_header       TYPE STANDARD TABLE OF bapi_alm_order_headers_i,
        lt_header_up    TYPE STANDARD TABLE OF bapi_alm_order_headers_up,
        lt_return       TYPE STANDARD TABLE OF bapiret2,
        lt_text	        TYPE STANDARD TABLE OF bapi_alm_text,
        lt_text_lines	  TYPE STANDARD TABLE OF bapi_alm_text_lines,
        it_task_list    TYPE bapi_alm_order_tasklists_i  OCCURS 0 WITH HEADER LINE,
        it_et_numbers   TYPE bapi_alm_numbers            OCCURS 0 WITH HEADER LINE,
        it_extension_in TYPE bapiparex                   OCCURS 0 WITH HEADER LINE,

        ls_texto_ordem  LIKE LINE OF it_texto_ordem,

* Declaração de tabela interna
        lt_status       TYPE TABLE OF string,

* Declaração de estruturas
        ls_methods      LIKE LINE OF lt_methods,
        ls_header       LIKE LINE OF lt_header,
        ls_text_lines   LIKE LINE OF lt_text_lines,
        ls_text         LIKE LINE OF lt_text,

* Declaraçãode variável
        lv_activity     TYPE vornr,
        lv_refnumber    TYPE ifrefnum,
        lv_datbi        TYPE datum VALUE '99991231',
        lv_aufnr        TYPE qmnum,
        lv_iwerk        TYPE iwerk,
        lv_texto_longo  TYPE string,
        lv_quebra_linha TYPE string VALUE cl_abap_char_utilities=>newline,
        lv_qtd_line     TYPE i,
        lv_qtd_line_ini TYPE i,
        lv_qtd_line_fim TYPE i,

        lv_objidext     TYPE objidext VALUE '%00000000001',
        lv_ifrefnum     TYPE ifrefnum VALUE 1.

* Verifica se cabeçalho da ORDEM foi preenchido
  IF im_ordem IS INITIAL.
    RETURN.
  ENDIF.

  REFRESH: lt_methods[], lt_header[], lt_return[],  lt_text[],   lt_text_lines[].

  CLEAR ls_methods.
  ls_methods-refnumber = lv_ifrefnum.
  ls_methods-objecttype = 'HEADER'.

  IF im_aufnr IS INITIAL.

    ls_methods-method     = 'CREATE'.
    ls_methods-objectkey  = lv_objidext.

  ELSE.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_aufnr
      IMPORTING
        output = lv_aufnr.

    ls_methods-method     = 'CREATETONOTIF'.
    ls_methods-objectkey  = lv_objidext && lv_aufnr.
  ENDIF.

  APPEND ls_methods TO lt_methods.

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

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = ls_header-equipment
    IMPORTING
      output = ls_header-equipment.

  ls_header-orderid = lv_objidext.

  IF lv_aufnr IS NOT INITIAL.
    ls_header-notif_no = lv_aufnr.
  ENDIF.

  ls_header-start_date = im_ordem-data_hora_inicio+6(4) &&
                         im_ordem-data_hora_inicio+3(2) &&
                         im_ordem-data_hora_inicio(2).

  ls_header-basicstart = im_ordem-data_hora_inicio+11(2) &&
                         im_ordem-data_hora_inicio+14(2) &&
                         im_ordem-data_hora_inicio+17(2).

  IF ls_header-start_date > sy-datum.
    ls_header-finish_date = im_ordem-data_hora_inicio+6(4) &&
                            im_ordem-data_hora_inicio+3(2) &&
                            im_ordem-data_hora_inicio(2).
  ELSE.
    ls_header-finish_date = im_ordem-data_hora_fim+6(4) &&
                            im_ordem-data_hora_fim+3(2) &&
                            im_ordem-data_hora_fim(2).
  ENDIF.

  IF ls_header-start_date > sy-datum.
    ls_header-basic_fin = im_ordem-data_hora_inicio+11(2) &&
                          im_ordem-data_hora_inicio+14(2) &&
                          im_ordem-data_hora_inicio+17(2).
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
      output = ls_header-funct_loc.

  APPEND ls_header TO lt_header.

* Preenche texto da ordem
  IF im_ordem-texto_longo IS NOT INITIAL.

    CLEAR ls_methods.
    ls_methods-refnumber = lv_ifrefnum.
    ls_methods-objecttype = 'TEXT'.
    ls_methods-method     = 'CREATE'.
    ls_methods-objectkey  = lv_objidext.
    APPEND ls_methods TO lt_methods.

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
*------------------------------------------------*
*   MONTA_LISTA_TAREFA
*------------------------------------------------*

  CLEAR it_task_list.
  REFRESH it_task_list.

  CLEAR lt_methods.
  lt_methods-refnumber  = '000001'.
  lt_methods-objecttype = 'TASKLIST'.
  lt_methods-method     = 'ADD'.
  lt_methods-objectkey  = '%00000000001'.
  APPEND lt_methods.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_ordem-plnnr
    IMPORTING
      output = im_ordem-plnnr.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_ordem-plnal
    IMPORTING
      output = im_ordem-plnal.

  MOVE: im_ordem-plnty         TO it_task_list-task_list_type,
        im_ordem-plnnr         TO it_task_list-task_list_group,
        im_ordem-plnal         TO it_task_list-group_counter,
        abap_true              TO it_task_list-delete_old_operations.
*       'X'                    TO it_task_list-use_workcenter_from_head.

  APPEND it_task_list.

* Chama BAPI para criação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods    = lt_methods
      it_header     = lt_header
      it_header_up  = lt_header_up
      it_text       = lt_text
      it_text_lines = lt_text_lines
      it_tasklists  = it_task_list
      extension_in  = it_extension_in
      et_numbers    = it_et_numbers
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

  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    FIELD-SYMBOLS: <fs_return> LIKE LINE OF lt_return.
    READ TABLE lt_return ASSIGNING <fs_return> WITH KEY type = 'E'.

    IF sy-subrc EQ 0.

      IF <fs_return>-id = 'CP' AND <fs_return>-number = 404.
        CONCATENATE <fs_return>-message 'Tipo de Ordem configurado para criar Op.Automaticamente'(006) INTO <fs_return>-message SEPARATED BY space.
      ENDIF.

      CONCATENATE <fs_return>-message
                  'Tipo da Ordem:'(007)  ls_header-order_type
                  'Texto Breve:'(008)    ls_header-short_text
                  'Loc.Inst:'(009)       ls_header-funct_loc
                  'Equip.'(010)          ls_header-equipment
                  INTO <fs_return>-message SEPARATED BY space.

    ENDIF.

*   Definir Nota para Eliminação
    IF im_aufnr IS NOT INITIAL.

      CALL FUNCTION '/PTLOMS/MF050'
        EXPORTING
          im_nota = im_aufnr.

      ls_return-type = 'E'.

      CONCATENATE 'Nota:'(011) im_aufnr 'Marcada para Eliminação'(012) INTO ls_return-message SEPARATED BY space.

      APPEND ls_return TO lt_return.

    ENDIF.

  ENDIF.

  it_return[] = lt_return[].

ENDFUNCTION.
