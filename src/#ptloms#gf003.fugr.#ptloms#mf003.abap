FUNCTION /ptloms/mf003.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_OPERACAO) TYPE  /PTLOMS/ET067
*"  EXPORTING
*"     VALUE(EX_VORNR) TYPE  VORNR
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
************************************************************************
***  Programa REVISADO em 06/05/2024 em função da
***  incompatibilidade de versão com a SOLAR.
************************************************************************
***  Consultora ABAP - Nádia Rodrigues
************************************************************************
* Declaração de tabelas interna
  DATA: lt_methods    TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_operation  TYPE STANDARD TABLE OF bapi_alm_order_operation,
        lt_return     TYPE STANDARD TABLE OF bapiret2,
        lt_status     TYPE TABLE OF string,
        lt_text	      TYPE STANDARD TABLE OF bapi_alm_text,
        lt_text_lines	TYPE STANDARD TABLE OF bapi_alm_text_lines.

* Declaração de estruturas
  DATA: ls_methods      LIKE LINE OF lt_methods,
        ls_operation    LIKE LINE OF lt_operation,
        ls_text_lines   LIKE LINE OF lt_text_lines,
        ls_text         LIKE LINE OF lt_text,
        ls_operation_dt TYPE bapi_alm_order_operation_e.

* Declaração de variáveis
  DATA: lv_aufnr        TYPE aufnr,
        lv_usuario      TYPE /ptloms/tb013-usuario,
        lv_quebra_linha TYPE string VALUE cl_abap_char_utilities=>newline,
        lv_objectkey    TYPE objidext,
        lv_contador     TYPE i,
        lv_texto_longo  TYPE string,
        lv_continua     TYPE c LENGTH 1 VALUE 'X',
        lv_profwoc      TYPE tpmp-profwoc,
        lv_indet        TYPE v_tcn41_pm-indet.

* Verifica se OPERAÇÂO foi preenchido
  IF im_operacao IS INITIAL.
    RETURN.
  ENDIF.

* Monta matrícula
  IF im_operacao-usuario_app IS NOT INITIAL.
    lv_usuario = im_operacao-usuario.
  ELSE.
    lv_usuario = sy-uname.
  ENDIF.

* Busca matrícula do usuário
*  SELECT SINGLE matricula FROM /ptloms/tb013 INTO @DATA(lv_matricula) WHERE usuario = @lv_usuario.
  DATA lv_matricula TYPE /ptloms/tb013-matricula.
  SELECT SINGLE matricula FROM /ptloms/tb013 INTO lv_matricula WHERE usuario = lv_usuario.

*  lv_aufnr = |{ im_operacao-objectkey ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_operacao-objectkey
    IMPORTING
      output = lv_aufnr.


  lv_objectkey = lv_aufnr.


* Seleciona Centro da Ordem
  "  SELECT SINGLE werks FROM aufk INTO @DATA(lv_werks) WHERE aufnr = @lv_aufnr.
  DATA lv_werks TYPE aufk-werks.
  SELECT SINGLE werks FROM aufk INTO lv_werks WHERE aufnr = lv_aufnr.


* Busca roteiro da ordem
*  SELECT SINGLE aufpl FROM afko INTO @DATA(lv_aufpl) WHERE aufnr = @lv_aufnr.
  DATA lv_aufpl TYPE afko-aufpl.
  SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = lv_aufnr.

  IF sy-subrc EQ 0.
* Busca todas as operações da Ordem
*    SELECT aufpl, aplzl, vornr
*      FROM afvc
*      INTO TABLE @DATA(lt_afvc)
*      WHERE aufpl = @lv_aufpl
*        AND sumnr = @space.
*        AND phflg = @space.
    TYPES: BEGIN OF ty_afvc,
             aufpl TYPE afvc-aufpl,
             aplzl TYPE afvc-aplzl,
             vornr TYPE afvc-vornr,
           END OF ty_afvc.
    DATA lt_afvc TYPE TABLE OF ty_afvc.
    SELECT aufpl aplzl vornr
      FROM afvc
      INTO TABLE lt_afvc
      WHERE aufpl = lv_aufpl
        AND sumnr = space.

  ENDIF.

* Ordena Operações
  SORT lt_afvc BY vornr DESCENDING.

* Atualiza a 1º operação da ordem que foi criada automaticamente.
  CALL FUNCTION 'BAPI_ALM_OPERATION_GET_DETAIL'
    EXPORTING
      iv_orderid    = lv_aufnr
      iv_activity   = '0010'
    IMPORTING
      es_operation  = ls_operation_dt
    TABLES
      return        = lt_return
      et_text       = lt_text
      et_text_lines = lt_text_lines.

  CLEAR: lt_text, lt_text_lines.


  IF ls_operation_dt-description EQ 'UPDATE'.
    CONCATENATE lv_objectkey '0010' INTO lv_objectkey.
  ENDIF.


* Busca a última operação
*  READ TABLE lt_afvc INTO DATA(ls_afvc) INDEX 1.
  DATA ls_afvc LIKE LINE OF lt_afvc.
  READ TABLE lt_afvc INTO ls_afvc INDEX 1.

* Carrega parâmetros da BAPI
  IF ls_operation_dt-description EQ 'UPDATE'.
    CLEAR ls_methods.
    ls_methods-refnumber = 1.
    ls_methods-objecttype = 'OPERATION'.
    ls_methods-method     = 'CHANGE'.
    ls_methods-objectkey  = lv_objectkey."im_operacao-objectkey.
    APPEND ls_methods TO lt_methods.
  ELSE.
    CLEAR ls_methods.
    ls_methods-refnumber = 1.
    ls_methods-objecttype = 'OPERATION'.
    ls_methods-method     = 'CREATE'.
    ls_methods-objectkey  = lv_objectkey."im_operacao-objectkey.
    APPEND ls_methods TO lt_methods.
  ENDIF.

*  CLEAR ls_methods.
*  ls_methods-refnumber = 1.
*  ls_methods-objecttype = 'TEXT'.
*  ls_methods-method     = 'CREATE'.
*  ls_methods-objectkey  = lv_objectkey."im_operacao-objectkey.
*  APPEND ls_methods TO lt_methods.

  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  ls_methods-objectkey  = lv_objectkey."im_operacao-objectkey.
  APPEND ls_methods TO lt_methods.

  MOVE-CORRESPONDING im_operacao TO ls_operation.

  CLEAR: ls_operation-equipment, ls_operation-funct_loc.

  IF ls_operation_dt-description EQ 'UPDATE'.
    ls_operation-activity = '0010'.
    ls_operation-duration_normal_unit = im_operacao-un_work.
  ELSE.
    ls_operation-activity    = ls_afvc-vornr + 10.
    ls_operation-duration_normal_unit = im_operacao-un_work.
  ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
    EXPORTING
      input  = ls_operation-activity
    IMPORTING
      output = ls_operation-activity.

  ls_operation-control_key = 'PM01'.
  IF im_operacao-work_cntr_plant IS NOT INITIAL.
    ls_operation-plant     = im_operacao-work_cntr_plant.
  ELSE.
    ls_operation-plant     = lv_werks.
  ENDIF.

  IF lv_matricula IS NOT INITIAL.
    ls_operation-pers_no = lv_matricula.
  ELSEIF lv_usuario IS NOT INITIAL.
    ls_operation-pers_no = lv_usuario.
  ENDIF.

* Verifica a configuração da chave de cálculo customizada para a ordem e ajusta o tipo de parâmetro a ser considerado na operação.
  CLEAR lv_profwoc.
  SELECT SINGLE profwoc INTO lv_profwoc
   FROM tpmp
   WHERE werks = lv_werks
     AND auart = im_operacao-order_type.

  IF sy-subrc EQ 0.

    CLEAR lv_indet.
    SELECT SINGLE indet INTO lv_indet
     FROM tcn41
     WHERE profidnetz = lv_profwoc.

    IF lv_indet = '2'.  "Calcular Trabalho
      ls_operation-duration_normal = ls_operation-work_activity.
      CLEAR ls_operation-work_activity.
    ENDIF.

  ENDIF.

  APPEND ls_operation TO lt_operation.

* Preenche texto da operação
  IF im_operacao-texto_longo IS NOT INITIAL.

    CLEAR lv_texto_longo.
    IF im_operacao-standard_text_key IS NOT INITIAL.
      lv_texto_longo = im_operacao-description && lv_quebra_linha && im_operacao-texto_longo.
    ELSE.
      lv_texto_longo = im_operacao-texto_longo.
    ENDIF.

    IF ls_operation_dt-description EQ 'UPDATE'.
      CLEAR ls_methods.
      ls_methods-refnumber = 1.
      ls_methods-objecttype = 'TEXT'.
      ls_methods-method     = 'CHANGE'.
      ls_methods-objectkey  = lv_objectkey."im_operacao-objectkey.
      APPEND ls_methods TO lt_methods.
    ELSE.
      CLEAR ls_methods.
      ls_methods-refnumber = 1.
      ls_methods-objecttype = 'TEXT'.
      ls_methods-method     = 'CREATE'.
      ls_methods-objectkey  = lv_objectkey."im_operacao-objectkey.
      APPEND ls_methods TO lt_methods.
    ENDIF.
*    SPLIT im_operacao-texto_longo  AT lv_quebra_linha INTO TABLE lt_status.
*    LOOP AT lt_status INTO DATA(ls_status).
*      CLEAR ls_text_lines.
*      ls_text_lines-tdformat = '*'.
*      ls_text_lines-tdline   = ls_status.
*      APPEND ls_text_lines TO lt_text_lines.
*    ENDLOOP.

* Monta Texto Longo
    CALL FUNCTION '/PTLOMS/MF054'
      EXPORTING
*       im_texto_longo = im_operacao-texto_longo
        im_texto_longo = lv_texto_longo
      TABLES
        it_texto       = lt_text_lines.

    IF lt_text_lines[] IS NOT INITIAL.
*      DESCRIBE TABLE lt_text_lines LINES DATA(lv_qtd_line).
      DATA lv_qtd_line TYPE i.
      DESCRIBE TABLE lt_text_lines LINES lv_qtd_line.
      ls_text-orderid   = lv_objectkey."im_operacao-objectkey.
      ls_text-activity  = ls_operation-activity.
      ls_text-langu     = sy-langu.
      ls_text-langu_iso = sy-langu.
      ls_text-textstart = 1.
      ls_text-textend   = lv_qtd_line.
      APPEND ls_text TO lt_text.
    ENDIF.
  ENDIF.

*  WHILE lv_continua = 'X'.

* Chama BAPI para criação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods    = lt_methods
      it_operation  = lt_operation
      it_text       = lt_text
      it_text_lines = lt_text_lines
      return        = lt_return.

*    READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type   = 'E'
*                                                         id     = 'IWO_BAPI'
*                                                         number = 124.
*    IF sy-subrc NE 0.
*      CLEAR lv_continua.
*    ENDIF.
*    IF lv_contador = 1000.
*      CLEAR lv_continua.
*    ENDIF.
*    lv_contador = lv_contador + 1.
*  ENDWHILE.


* Verifica retorno
*  READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  DATA ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    ex_vornr = ls_operation-activity.
    ls_return-type    = 'S'.
    ls_return-id      = 'SU'.
    ls_return-number  = '000'.

*    ls_return-message = |{ 'Operação'(032) }| && | { ls_operation-activity ALPHA = OUT }| && |{ 'criada com sucesso'(031) }|.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = ls_operation-activity
      IMPORTING
        output = ls_operation-activity.

*    ls_return-message = |{ 'Operação'(032) }| && | { ls_operation-activity }| && |{ 'criada com sucesso'(031) }|.
    CONCATENATE 'Operação'(032)
                ls_operation-activity
                'criada com sucesso'(031)
                INTO ls_return-message SEPARATED BY space.
    APPEND ls_return TO lt_return.
  ENDIF.

  it_return[] = lt_return[].

ENDFUNCTION.
