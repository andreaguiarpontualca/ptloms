FUNCTION /ptloms/mf001.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_NOTA) TYPE  /PTLOMS/ET043
*"     REFERENCE(IT_TEXTO) TYPE  /PTLOMS/CT044
*"     REFERENCE(IT_ITEM) TYPE  /PTLOMS/CT045
*"     REFERENCE(IT_ITEM_CAUSA) TYPE  /PTLOMS/CT046
*"     REFERENCE(IT_ITEM_ATIVIDADE) TYPE  /PTLOMS/CT047
*"     REFERENCE(IT_ITEM_TAREFA) TYPE  /PTLOMS/CT048
*"     REFERENCE(IT_ITEM_MEDIDAS) TYPE  /PTLOMS/CT024
*"  EXPORTING
*"     REFERENCE(EX_NOTIF_NO) TYPE  QMNUM
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************
* Declaração de tabela interna
  DATA: lt_status TYPE TABLE OF string.

* Declarações para BAPI
  DATA: lv_notif_type           TYPE bapi2080-notif_type,
        lv_maintactytype_export TYPE ila,
        ls_notifheader          TYPE bapi2080_nothdri,
        ls_notifheader_export   TYPE bapi2080_nothdre,
        ls_notifheader_save     TYPE bapi2080_nothdre,
        lt_notitem              TYPE STANDARD TABLE OF bapi2080_notitemi,
        lt_notifcaus            TYPE STANDARD TABLE OF bapi2080_notcausi,
        lt_notifactv            TYPE STANDARD TABLE OF bapi2080_notactvi,
        lt_notiftask            TYPE STANDARD TABLE OF bapi2080_nottaski,
        lt_longtexts            TYPE STANDARD TABLE OF bapi2080_notfulltxti,
        lt_return               TYPE STANDARD TABLE OF bapiret2.

* Declaração de estrutura
  DATA: ls_longtexts  LIKE LINE OF lt_longtexts,
        ls_notitem    LIKE LINE OF lt_notitem,
        ls_notifcaus  LIKE LINE OF lt_notifcaus,
        ls_notifactv  LIKE LINE OF lt_notifactv,
        ls_notiftask  LIKE LINE OF lt_notiftask,
        ls_return_aux LIKE LINE OF lt_return.

* Declaração de variáveis
  DATA: lv_usuario      TYPE /ptloms/tb013-usuario,
        lv_texto_longo  TYPE string,
        lv_quebra_linha TYPE string VALUE cl_abap_char_utilities=>newline.

* Verifica se critério cabeçalho da NOTA foi preenchido
  IF im_nota IS INITIAL.
    RETURN.
  ENDIF.

* Carrega dados de cabeçalho
  MOVE im_nota-type TO lv_notif_type.
  MOVE-CORRESPONDING im_nota TO ls_notifheader.

* Converter Equipamento para Maiúsculo
  TRANSLATE ls_notifheader-equipment TO UPPER CASE.

  ls_notifheader-strmlfndate = im_nota-data_hora_inicio_parada+6(4) &&
                               im_nota-data_hora_inicio_parada+3(2) &&
                               im_nota-data_hora_inicio_parada(2).
  ls_notifheader-strmlfntime = im_nota-data_hora_inicio_parada+11(2) &&
                               im_nota-data_hora_inicio_parada+14(2) &&
                               im_nota-data_hora_inicio_parada+17(2).
  ls_notifheader-endmlfndate = im_nota-data_hora_fim_parada+6(4) &&
                               im_nota-data_hora_fim_parada+3(2) &&
                               im_nota-data_hora_fim_parada(2).
  ls_notifheader-endmlfntime = im_nota-data_hora_fim_parada+11(2) &&
                               im_nota-data_hora_fim_parada+14(2) &&
                               im_nota-data_hora_fim_parada+17(2).

  ls_notifheader-notif_date = im_nota-data_hora_inicio+6(4) &&
                              im_nota-data_hora_inicio+3(2) &&
                              im_nota-data_hora_inicio(2).

  ls_notifheader-notiftime = im_nota-data_hora_inicio+11(2) &&
                             im_nota-data_hora_inicio+14(2) &&
                             im_nota-data_hora_inicio+17(2).

  TYPES: BEGIN OF ty_viqmel,
           qmnum TYPE viqmel-qmnum,
           qmdat TYPE viqmel-qmdat,
           mzeit TYPE viqmel-mzeit,
           tplnr TYPE viqmel-tplnr,
           equnr TYPE viqmel-equnr,
         END OF ty_viqmel.
  DATA lt_viqmel TYPE TABLE OF ty_viqmel.

* Verifica se alguma nota já foi criada na mesma Data/Hora com o mesmo Equipamento e/ou Local de Instalação - Início
  IF ls_notifheader-equipment IS NOT INITIAL.
*    SELECT qmnum, qmdat, mzeit, tplnr, equnr
*      FROM viqmel
*      INTO TABLE @DATA(lt_viqmel)
*      WHERE qmdat = @ls_notifheader-notif_date
*        AND mzeit = @ls_notifheader-notiftime
*        AND equnr = @ls_notifheader-equipment.
    SELECT qmnum qmdat mzeit tplnr equnr
      FROM viqmel
      INTO TABLE lt_viqmel
      WHERE qmdat = ls_notifheader-notif_date
        AND mzeit = ls_notifheader-notiftime
        AND equnr = ls_notifheader-equipment.
*      AND tplnr = @ls_notifheader-funct_loc.
  ELSE.
*    SELECT qmnum, qmdat, mzeit, tplnr, equnr
*      FROM viqmel
*      INTO TABLE @lt_viqmel
*      WHERE qmdat = @ls_notifheader-notif_date
*        AND mzeit = @ls_notifheader-notiftime
**      AND equnr = @ls_notifheader-equipment
*        AND tplnr = @ls_notifheader-funct_loc.
    SELECT qmnum qmdat mzeit tplnr equnr
      FROM viqmel
      INTO TABLE lt_viqmel
      WHERE qmdat = ls_notifheader-notif_date
        AND mzeit = ls_notifheader-notiftime
*      AND equnr = @ls_notifheader-equipment
        AND tplnr = ls_notifheader-funct_loc.
  ENDIF.
  IF sy-subrc EQ 0.
    CLEAR ls_return_aux.
    ls_return_aux-type = 'E'.

    CONCATENATE 'Já existe nota na mesma data/hora:'(001) im_nota-data_hora_inicio INTO ls_return_aux-message SEPARATED BY space.
*** ls_return_aux-message = |Já existe nota na mesma data/hora: | && im_nota-data_hora_inicio.


    APPEND ls_return_aux TO lt_return.
*    DATA(lv_nota_ja_criada) = 'X'.
    DATA lv_nota_ja_criada TYPE char1.
    lv_nota_ja_criada = 'X'.
  ENDIF.
* Verifica se alguma nota já foi criada na mesma Data/Hora com o mesmo Equipamento e/ou Local de Instalação - Fim

  IF lv_nota_ja_criada IS INITIAL.

* Monta matrícula
    IF im_nota-usuario_app IS NOT INITIAL.
      lv_usuario = im_nota-usuario_app.
    ELSE.
      lv_usuario = sy-uname.
    ENDIF.

* Busca matrícula do usuário
*    SELECT SINGLE matricula FROM /ptloms/tb013 INTO @DATA(lv_matricula) WHERE usuario = @lv_usuario.
    DATA lv_matricula TYPE /ptloms/tb013-matricula.
    SELECT SINGLE matricula FROM /ptloms/tb013 INTO lv_matricula WHERE usuario = lv_usuario.

    IF lv_matricula IS NOT INITIAL.
      ls_notifheader-reportedby = lv_matricula.
    ELSEIF lv_usuario IS NOT INITIAL.
      ls_notifheader-reportedby = lv_usuario.
    ENDIF.

* Carrega Texto da Nota
    IF im_nota-texto_longo IS NOT INITIAL.
*    MOVE im_nota-texto_longo TO lv_texto_longo.
*    SPLIT lv_texto_longo AT lv_quebra_linha INTO TABLE lt_status.
*    LOOP AT lt_status INTO DATA(ls_status).
*      CLEAR ls_longtexts.
*      ls_longtexts-objtype    = 'QMEL'.
*      ls_longtexts-format_col = '*'.
*      ls_longtexts-text_line  = ls_status.
*      APPEND ls_longtexts TO lt_longtexts.
*    ENDLOOP.

* Monta Texto Longo
      CALL FUNCTION '/PTLOMS/MF055'
        EXPORTING
          im_texto_longo = im_nota-texto_longo
        TABLES
          it_texto       = lt_longtexts.

    ELSE.
*       LOOP AT it_texto INTO DATA(ls_texto).
      DATA ls_texto LIKE LINE OF it_texto.
      LOOP AT it_texto INTO ls_texto.
        CLEAR ls_longtexts.
        MOVE-CORRESPONDING ls_texto TO ls_longtexts.
        APPEND ls_longtexts TO lt_longtexts.
      ENDLOOP.
    ENDIF.

* Carrega itens da Nota
    IF ( im_nota-d_codegrp IS NOT INITIAL AND
         im_nota-d_code IS NOT INITIAL ) OR

       ( im_nota-dl_codegrp IS NOT INITIAL AND
         im_nota-dl_code IS NOT INITIAL ).

      CLEAR ls_notitem.
      ls_notitem-item_key     = 1.
      ls_notitem-item_sort_no = 1.
      ls_notitem-d_codegrp    = im_nota-d_codegrp.
      ls_notitem-d_code       = im_nota-d_code.
      ls_notitem-dl_codegrp   = im_nota-dl_codegrp.
      ls_notitem-dl_code      = im_nota-dl_code.
*    ls_notitem-descript     = 'Item 1'.
      APPEND ls_notitem TO lt_notitem.
    ELSE.
*      LOOP AT it_item INTO DATA(ls_item).
      DATA ls_item LIKE LINE OF it_item.
      LOOP AT it_item INTO ls_item.
        CLEAR ls_notitem.
        MOVE-CORRESPONDING ls_item TO ls_notitem.
        APPEND ls_notitem TO lt_notitem.
      ENDLOOP.
    ENDIF.

* Carrega Causas do Item
    IF im_nota-d_codegrp_causa IS NOT INITIAL AND
       im_nota-d_code_causa    IS NOT INITIAL.

      ls_notifcaus-cause_key     = 1.
      ls_notifcaus-item_key      = 1.
      ls_notifcaus-item_sort_no  = 1.
      ls_notifcaus-cause_sort_no = 1.
*    ls_notifcaus-causetext     = 'Causa criada no Mobile'.
      ls_notifcaus-cause_codegrp = im_nota-d_codegrp_causa.
      ls_notifcaus-cause_code    = im_nota-d_code_causa.
      APPEND ls_notifcaus TO lt_notifcaus.

    ELSE.
*      LOOP AT it_item_causa INTO DATA(ls_item_causa).
      DATA ls_item_causa LIKE LINE OF it_item_causa.
      LOOP AT it_item_causa INTO ls_item_causa.
        CLEAR ls_notifcaus.
        MOVE-CORRESPONDING ls_item_causa TO ls_notifcaus.
        APPEND ls_notifcaus TO lt_notifcaus.
      ENDLOOP.
    ENDIF.

*   Carrega Medidas do Item
    IF im_nota-task_codegrp IS NOT INITIAL AND
       im_nota-task_code    IS NOT INITIAL.

      ls_notiftask-task_key     = 1.
      "ls_notiftask-item_key      = 1.
      ls_notiftask-item_sort_no  = 1.
      ls_notiftask-task_sort_no = 1.

      ls_notiftask-TASK_CODEGRP = im_nota-task_codegrp.
      ls_notiftask-TASK_CODE    = im_nota-TASK_CODE.
      APPEND ls_notiftask TO lt_notiftask.

    ELSE.
*      LOOP AT it_item_causa INTO DATA(ls_item_causa).
      "DATA ls_item_causa LIKE LINE OF it_item_causa.
      LOOP AT it_item_causa INTO ls_item_causa.
        CLEAR ls_notifcaus.
        MOVE-CORRESPONDING ls_item_causa TO ls_notifcaus.
        APPEND ls_notifcaus TO lt_notifcaus.
      ENDLOOP.
    ENDIF.

* Carrega Atividades do Item
*   LOOP AT it_item_atividade INTO DATA(ls_item_atividade).
    DATA ls_item_atividade LIKE LINE OF it_item_atividade.
    LOOP AT it_item_atividade INTO ls_item_atividade.
      CLEAR ls_notifactv.
      MOVE-CORRESPONDING ls_item_atividade TO ls_notifactv.
      APPEND ls_notifactv TO lt_notifactv.
    ENDLOOP.

* Carrega Tarefas do Item
*    LOOP AT it_item_tarefa INTO DATA(ls_item_tarefa).
    DATA ls_item_tarefa LIKE LINE OF it_item_tarefa.
    LOOP AT it_item_tarefa INTO ls_item_tarefa.
      CLEAR ls_notiftask.
      MOVE-CORRESPONDING ls_item_tarefa TO ls_notiftask.
      APPEND ls_notiftask TO lt_notiftask.
    ENDLOOP.

*   Conversão local de instalação
    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = ls_notifheader-funct_loc
      IMPORTING
        output = ls_notifheader-funct_loc
      EXCEPTIONS
*       not_found = 1
*       OTHERS = 2.
        OTHERS = 0.

* Executa BAPI para criação da Nota
    CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'
      EXPORTING
        notif_type         = lv_notif_type
        notifheader        = ls_notifheader
      IMPORTING
        notifheader_export = ls_notifheader_export
*       maintactytype_export = lv_maintactytype_export
      TABLES
        notitem            = lt_notitem
        notifcaus          = lt_notifcaus
        notifactv          = lt_notifactv
        notiftask          = lt_notiftask
        longtexts          = lt_longtexts
        return             = lt_return.

  ENDIF.

  IF ls_notifheader_export-notif_no IS NOT INITIAL.

    CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
      EXPORTING
        number      = ls_notifheader_export-notif_no
      IMPORTING
        notifheader = ls_notifheader_save
      TABLES
        return      = lt_return.

*    READ TABLE  lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
    IF sy-subrc NE 0.
      ex_notif_no = ls_notifheader_save-notif_no.
    ELSE.
      it_return[] = lt_return[].
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ELSE.
*    READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WITH KEY type = 'E'.
    FIELD-SYMBOLS: <fs_return> LIKE LINE OF lt_return.
    READ TABLE lt_return ASSIGNING <fs_return> WITH KEY type = 'E'.
*********************************************************************************************************
***  FIM - Nádia Rodrigues
*********************************************************************************************************
    IF sy-subrc EQ 0.

*   Conversão local de instalação
      CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
        EXPORTING
          input  = ls_notifheader-funct_loc
        IMPORTING
          output = ls_notifheader-funct_loc
        EXCEPTIONS
*         not_found = 1
*         OTHERS = 2.
          OTHERS = 0.

      CONCATENATE <fs_return>-message
                  'Tipo da Nota:'(002) lv_notif_type
                  'Texto Breve:'(003)  ls_notifheader-short_text
                  'Loc.Inst:'(004)     ls_notifheader-funct_loc
                  'Equip.:'(005)       ls_notifheader-equipment
                  INTO <fs_return>-message SEPARATED BY space.

***      <fs_return>-message = <fs_return>-message &&
***                           | Tipo da Nota: | && lv_notif_type &&
***                           | Texto Breve: | && ls_notifheader-short_text &&
***                           | Loc.Inst: | && ls_notifheader-funct_loc &&
***                           | Equip.: | && ls_notifheader-equipment.

    ENDIF.
    it_return[] = lt_return[].
    RETURN.
  ENDIF.

ENDFUNCTION.
