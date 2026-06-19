*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CRIA_OBJETO_OMS
*&---------------------------------------------------------------------*
FORM cria_objeto_oms .

  IF o_oms IS NOT BOUND.
    CREATE OBJECT o_oms.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PBO_005
*&---------------------------------------------------------------------*
FORM f_pbo_005 .

  SET PF-STATUS  'STATUS_005'.
  SET TITLEBAR   'T005'.

  PERFORM f_insere_arvore.
  PERFORM f_figura.

  AUTHORITY-CHECK OBJECT '/PTLOMS/01'
           ID 'TCD' FIELD sy-tcode
           ID 'ACTVT' FIELD '02'.

  IF sy-subrc <> 0.
    MESSAGE e001(/ptloms/cm001) WITH '/PTLOMS/01'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INSERE_ARVORE
*&---------------------------------------------------------------------*
FORM f_insere_arvore .

  TYPES: item_table_type LIKE STANDARD TABLE OF mtreeitm WITH DEFAULT KEY.

  DATA: o_mycontainer    TYPE REF TO cl_gui_custom_container,
        o_tree           TYPE REF TO cl_gui_list_tree,
        o_event_receiver TYPE REF TO lcl_event_receiver_005.

  DATA: lt_node_table TYPE treev_ntab,
        lt_item_table TYPE item_table_type,
        lt_events     TYPE cntl_simple_events.

  DATA: ls_item  TYPE mtreeitm,
        ls_event TYPE cntl_simple_event.

* Compõe tabela de nodos NODE_TABLE
  PERFORM f_compoe_tab_nodos TABLES lt_node_table.

* Recupera dados de MENU da tab. /PTLOMS/TB001
  DATA lt_tb001 TYPE /ptloms/ct100.
  lt_tb001 = o_oms->get_tb001( ).
*  DATA(lt_tb001) = o_oms->get_tb001( ).

* Só continua se a tabela de nodos não estiver vazia
  IF lt_node_table[] IS INITIAL.
    RETURN.
  ENDIF.

  DATA: ls_node LIKE LINE OF lt_node_table,
        ls_001  LIKE LINE OF lt_tb001.
  LOOP AT lt_node_table INTO ls_node.
*  LOOP AT lt_node_table INTO DATA(ls_node).

    READ TABLE lt_tb001 INTO ls_001 WITH KEY nivel_pai = ls_node-node_key.
*    READ TABLE lt_tb001 INTO DATA(ls_001) WITH KEY nivel_pai = ls_node-node_key.

    IF ls_node-isfolder = 'X'.

      ls_item-node_key = ls_node-node_key.
      ls_item-item_name = 1.
      ls_item-class = cl_gui_list_tree=>item_class_text. "'2'.
      ls_item-font = cl_gui_list_tree=>item_font_prop. "'2'.
      ls_item-alignment = cl_gui_list_tree=>align_auto. "'3'.
      ls_item-text = ls_001-texto. "'Manutenção  Tabelas'.

      APPEND ls_item TO lt_item_table.
      CLEAR ls_item.

    ELSE.

      ls_item-node_key = ls_node-node_key.
      ls_item-item_name = 1.
      ls_item-class = cl_column_tree_model=>item_class_link. "'5'.
      ls_item-length = '4'.
      ls_item-t_image = '@0P@'.
      ls_item-ignoreimag = 'X'.
      ls_item-txtisqinfo = 'X'.

      APPEND ls_item TO lt_item_table.
      CLEAR ls_item.

      ls_item-node_key = ls_node-node_key.
      ls_item-item_name = 2.
      ls_item-class = cl_gui_list_tree=>item_class_text. "'2'.
      ls_item-font = cl_gui_list_tree=>item_font_prop. "'2'.
      ls_item-alignment = cl_gui_list_tree=>align_auto. "'3'.
      ls_item-text = ls_001-texto.

      APPEND ls_item TO lt_item_table.
      CLEAR ls_item.

    ENDIF.
  ENDLOOP.

  SORT lt_node_table BY node_key. "05.09.2012

  IF o_mycontainer IS INITIAL.

    CREATE OBJECT o_mycontainer
      EXPORTING
        container_name = 'CUSTOM_TREE'.

    CREATE OBJECT o_tree
      EXPORTING
        parent              = o_mycontainer
        node_selection_mode = o_tree->node_sel_mode_multiple
        item_selection      = 'X'
        with_headers        = ' '.

    CREATE OBJECT o_event_receiver.

    SET HANDLER o_event_receiver->handle_item_double_click FOR o_tree.
    ls_event-eventid = cl_gui_list_tree=>eventid_item_double_click.
    ls_event-appl_event = 'X'.   "system event, does not trigger PAI
    APPEND ls_event TO lt_events.

    SET HANDLER o_event_receiver->handle_link_click FOR o_tree.
    ls_event-eventid = cl_gui_list_tree=>eventid_link_click.
    ls_event-appl_event = 'X'.
    APPEND ls_event TO lt_events.

    CALL METHOD o_tree->set_registered_events
      EXPORTING
        events = lt_events.

    CALL METHOD o_tree->add_nodes_and_items
      EXPORTING
        node_table                     = lt_node_table
        item_table                     = lt_item_table
        item_table_structure_name      = 'MTREEITM'
      EXCEPTIONS
        failed                         = 1
        cntl_system_error              = 3
        error_in_tables                = 4
        dp_error                       = 5
        table_structure_name_not_found = 6.

    IF sy-subrc <> 0.
    ENDIF.

***    CALL METHOD o_tree->expand_root_nodes
***      EXPORTING
***        expand_subtree = 'X'.

    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_COMPOE_TAB_NODOS
*&---------------------------------------------------------------------*
FORM f_compoe_tab_nodos TABLES pt_node_table STRUCTURE treev_node.

  DATA: lt_tb001 TYPE /ptloms/ct100,
        ls_001   LIKE LINE OF lt_tb001.
  lt_tb001 = o_oms->get_tb001( ).
*  DATA(lt_tb001) = o_oms->get_tb001( ).

  LOOP AT lt_tb001 INTO ls_001.
*  LOOP AT lt_tb001 INTO DATA(ls_001).

    PERFORM insere_nodos TABLES lt_tb001
                                pt_node_table
                          USING ls_001.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DCLIK
*&---------------------------------------------------------------------*
FORM dclik USING p_node_key.

  DATA: lv_tam    TYPE i,
        lv_tabela TYPE char50,
        lv_trans  LIKE sy-tcode.

* Seleciona a linha na tab. /PTLOMS/TB001 para tratar tipo
*  SELECT SINGLE *
*    INTO @DATA(ls_tb001)
*    FROM /ptloms/tb001
*    WHERE spras     EQ @sy-langu
*      AND nivel_pai EQ @p_node_key.

  DATA: ls_tb001 TYPE /ptloms/tb001.

  SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF ls_tb001
      FROM /ptloms/tb001
      WHERE spras     EQ sy-langu
        AND nivel_pai EQ p_node_key.


* Se o tipo não estiver preenchido na tabela, não faz nada.
  IF ls_tb001-tipo EQ ''.
    RETURN.
  ENDIF.

* Verfica Objeto de Autorização para "Manutenção de Layout"
  IF ls_tb001-codigo = 'MAN01'.
    AUTHORITY-CHECK OBJECT '/PTLOMS/03'
             ID 'TCD' FIELD sy-tcode
             ID 'ACTVT' FIELD '02'.

    IF sy-subrc <> 0.
      MESSAGE e001(/ptloms/cm001) WITH '/PTLOMS/03'.
    ENDIF.
  ENDIF.

  CASE ls_tb001-tipo.

*   Submit - programa de manutenção de tabelas - evita acesso a SM30
    WHEN 'S'.

      lv_tam = strlen( ls_tb001-codigo ).
      lv_tam = lv_tam - 2.

      CONCATENATE '/PTLOMS/TB0' ls_tb001-codigo+lv_tam INTO lv_tabela.

      SUBMIT /ptloms/rp001
      USING SELECTION-SCREEN 1000
      WITH  p_table = lv_tabela
      AND RETURN.                                        "#EC CI_SUBMIT

*   Submit - programa de manutenção de tabelas - evita acesso a SM30
    WHEN 'V'.

      lv_tam = strlen( ls_tb001-codigo ).
      lv_tam = lv_tam - 2.

      CONCATENATE '/PTLOMS/V0' ls_tb001-codigo+lv_tam INTO lv_tabela.

      SUBMIT /ptloms/rp001
      USING SELECTION-SCREEN 1000
      WITH  p_table = lv_tabela
      AND RETURN.                                        "#EC CI_SUBMIT

*   Transação
    WHEN 'T'.

      lv_tam = strlen( ls_tb001-codigo ).
      lv_tam = lv_tam - 2.

      CONCATENATE '/PTLOMS/PTLOMSN0' ls_tb001-codigo+lv_tam  INTO lv_trans.

***   CALL TRANSACTION lv_trans WITH AUTHORITY-CHECK.
      CALL TRANSACTION lv_trans.

*   Set Dados
    WHEN 'P'.
      lv_tam = strlen( ls_tb001-codigo ).
      lv_tam = lv_tam - 3.

      CONCATENATE 'ZOMS_' ls_tb001-codigo+lv_tam  INTO lv_trans.
      SET PARAMETER ID 'GSE' FIELD lv_trans.

***   CALL TRANSACTION 'GS03' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
      CALL TRANSACTION 'GS03' AND SKIP FIRST SCREEN.

*   Transação Nativa SAP
    WHEN 'N'.
      CALL TRANSACTION ls_tb001-codigo.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERE_NODOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM insere_nodos TABLES pt_tb001 STRUCTURE /ptloms/tb001
                         pt_node_table STRUCTURE treev_node
                   USING ps_001 TYPE /ptloms/tb001.

  DATA: ls_node LIKE mtreesnode.

  DATA: lv_relatkey   LIKE /ptloms/tb001-nivel_pai,
        lv_nivel_pai  LIKE /ptloms/tb001-nivel_pai,
        lv_tam_filho  TYPE i,
        lv_icon       LIKE v_icon-name,
        lv_filhos(20).

  CLEAR ls_node.
  ls_node-node_key = ps_001-nivel_pai.

  CLEAR lv_relatkey.
  PERFORM f_calcula_relatkey USING ps_001-nivel_pai
                             CHANGING lv_relatkey.

  ls_node-relatkey = lv_relatkey.

* Guardando para referenciar nos filhos
  CLEAR lv_nivel_pai.
  lv_nivel_pai = ps_001-nivel_pai.

  CLEAR lv_icon.
  lv_icon = ps_001-icon.

* Se for transação, é o último nível e não coloca simbolo de PASTA
  IF ps_001-codigo = ''.

    ls_node-isfolder = 'X'.
    ls_node-n_image   = lv_icon.
    ls_node-exp_image = lv_icon.

  ELSE.

    ls_node-isfolder = ''.
    ls_node-n_image  = '@BT@'.

  ENDIF.

  ls_node-relatship = ''.
  ls_node-text      = ps_001-texto.

  APPEND ls_node TO pt_node_table.

* Compõe nível dos filhos
  CLEAR lv_filhos.
  CONCATENATE ps_001-nivel_pai '#' INTO lv_filhos.
  CONDENSE lv_filhos NO-GAPS.

  lv_tam_filho = strlen( lv_filhos ).

  DELETE pt_tb001 WHERE nivel_pai = ps_001-nivel_pai.

* Inserção dos filhos do nodo corrente
  DATA ls_001   LIKE LINE OF pt_tb001.
  LOOP AT pt_tb001 INTO ls_001.
*  LOOP AT pt_tb001 INTO DATA(ls_001).

    IF ls_001-nivel_pai(lv_tam_filho) = lv_filhos.

*     Filho - primeiro nível
      PERFORM f_insere_filhos TABLES pt_tb001
                                     pt_node_table
                              USING lv_nivel_pai ls_001.

    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALCULA_RELATKEY
*&---------------------------------------------------------------------*
FORM f_calcula_relatkey  USING    p_nivel_pai TYPE /ptloms/tb001-nivel_pai
                         CHANGING p_relatkey  TYPE /ptloms/tb001-nivel_pai.

  DATA: lt_partes TYPE TABLE OF string.

  SPLIT p_nivel_pai AT '#' INTO TABLE lt_partes.

  DATA ls_partes   LIKE LINE OF lt_partes.
  LOOP AT lt_partes INTO ls_partes.
*  LOOP AT lt_partes INTO DATA(ls_partes).

    AT LAST.
      EXIT.
    ENDAT.

    IF sy-tabix = 1.
      p_relatkey = ls_partes.
    ELSE.
      CONCATENATE p_relatkey '#' ls_partes INTO p_relatkey.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INSERE_FILHOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_insere_filhos TABLES pt_tb001 STRUCTURE /ptloms/tb001
                            pt_node_table STRUCTURE treev_node
                     USING  pp_nivel_sup TYPE /ptloms/tb001-nivel_pai
                            ps_001        TYPE /ptloms/tb001.

  DATA: ls_node       LIKE mtreesnode,
        lv_filhos(20),
        lv_tam_filho  TYPE i,
        lv_node_key   TYPE /ptloms/tb001-nivel_pai,
        lv_icon       LIKE v_icon-name,
        lv_relatkey   LIKE /ptloms/tb001-nivel_pai.

  CLEAR ls_node.
  ls_node-node_key = ps_001-nivel_pai.

  CLEAR lv_relatkey.
  PERFORM f_calcula_relatkey USING ps_001-nivel_pai
                             CHANGING lv_relatkey.

  ls_node-relatkey = lv_relatkey.

  CLEAR lv_icon.
  lv_icon = ps_001-icon.

* Se for transação, é o último nível e não coloca simbolo de PASTA
  IF ps_001-codigo = ''.

    ls_node-isfolder = 'X'.
    ls_node-n_image   = lv_icon.
    ls_node-exp_image = lv_icon.

  ELSE.

    ls_node-isfolder = ''.
    ls_node-n_image  = lv_icon.
    ls_node-exp_image = lv_icon.

  ENDIF.

  ls_node-relatship = ''.
  ls_node-text      = ps_001-texto.

  APPEND ls_node TO pt_node_table.

* Compõe nível dos filhos
  CLEAR lv_filhos.
  CONCATENATE ps_001-nivel_pai '#' INTO lv_filhos.
  CONDENSE lv_filhos NO-GAPS.

  lv_tam_filho = strlen( lv_filhos ).

  DELETE pt_tb001 WHERE nivel_pai = ps_001-nivel_pai.

* Inserção do filhos do nodo atual
  DATA ls_001   LIKE LINE OF pt_tb001.
  LOOP AT pt_tb001 INTO ls_001.
*  LOOP AT pt_tb001 INTO DATA(ls_001).

    IF ls_001-nivel_pai(lv_tam_filho) = lv_filhos.

      MOVE: ls_node-node_key TO lv_node_key.

*     Filho - nível final
      PERFORM f_insere_filhos TABLES pt_tb001
                                     pt_node_table
                              USING lv_node_key ls_001.

    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FIGURA
*&---------------------------------------------------------------------*
FORM f_figura .

  DATA: o_container_init TYPE REF TO cl_gui_custom_container,
        o_picture_init   TYPE REF TO cl_gui_picture.

  DATA: lv_url TYPE /ptloms/ed014.
  DATA lv_init TYPE char1.
  lv_init = o_oms->get_init( ).

*-----tratamento da imagem------------
  IF lv_init IS INITIAL.

*   create the custom container
    CREATE OBJECT o_container_init
      EXPORTING
        container_name = 'CUSTOM_FIG'.

*   create the picture control
    CREATE OBJECT o_picture_init
      EXPORTING
        parent = o_container_init.

*   Request an URL from the data provider by exporting the pic_data.
    CLEAR lv_url.

*   Mostra figura
    PERFORM load_pic_from_db USING '/PTLOMS/IMAGEM_COCKPIT_01'
                             CHANGING lv_url.

*   load picture
    CALL METHOD o_picture_init->load_picture_from_url
      EXPORTING
        url = lv_url.

    o_oms->set_init( 'X' ).

    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2.

    IF sy-subrc <> 0.
*   error handling
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  load_pic_from_db
*&---------------------------------------------------------------------*
FORM load_pic_from_db USING p_figura TYPE any
                      CHANGING p_url TYPE /ptloms/ed014.

  DATA: lt_query_table    LIKE w3query OCCURS 1 WITH HEADER LINE,
        ls_query_table    LIKE LINE OF lt_query_table,
        lt_html_table     LIKE w3html OCCURS 1,
        lv_return_code    LIKE w3param-ret_code,
        lv_content_type   LIKE w3param-cont_type,
        lv_content_length LIKE w3param-cont_len,
        lt_pic_data       LIKE w3mime OCCURS 0,
        lv_pic_size       TYPE i,
        lv_url            TYPE /ptloms/ed014.

  REFRESH lt_query_table.
  ls_query_table-name = '_OBJECT_ID'.

* Figura que será apresentada - pode ser consultada via SMW0
  ls_query_table-value = p_figura.
  APPEND ls_query_table TO lt_query_table.

  CALL FUNCTION 'WWW_GET_MIME_OBJECT' ##FM_OLDED
    TABLES
      query_string        = lt_query_table
      html                = lt_html_table
      mime                = lt_pic_data
    CHANGING
      return_code         = lv_return_code
      content_type        = lv_content_type
      content_length      = lv_content_length
    EXCEPTIONS
      object_not_found    = 1
      parameter_not_found = 2
      OTHERS              = 3.

  IF sy-subrc = 0.
    lv_pic_size = lv_content_length.
  ENDIF.

  CALL FUNCTION 'DP_CREATE_URL'                             "#EC *
    EXPORTING
      type     = 'image'
      subtype  = cndp_sap_tab_unknown
      size     = lv_pic_size
      lifetime = cndp_lifetime_transaction
    TABLES
      data     = lt_pic_data
    CHANGING
      url      = p_url
    EXCEPTIONS
      OTHERS   = 1.

ENDFORM.                    " load_pic_from_db
*&---------------------------------------------------------------------*
*&      Form  F_SAIDA
*&---------------------------------------------------------------------*
FORM f_saida USING p_ucomm TYPE sy-ucomm.

  CONSTANTS: c_25 TYPE i VALUE 25.

  DATA: lv_msg_tela(60) TYPE c,
        lv_resposta(1)  TYPE c,
        lv_num_comp_aux TYPE equnr,
        lv_erro_blk(1)  TYPE c.

  IF p_ucomm = 'EXIT' OR
     p_ucomm = 'BACK' OR
     p_ucomm = 'CANC'.

    lv_msg_tela = 'Deseja realmente sair do programa ?'(001).

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '### Confirmação ###'(002)
        diagnose_object       = ' '
        text_question         = lv_msg_tela
        text_button_1         = 'Sim'(003)
        icon_button_1         = ' '
        text_button_2         = 'Não'(004)
        icon_button_2         = ' '
        default_button        = '1'
        display_cancel_button = ''
        userdefined_f1_help   = ' '
        start_column          = c_25
        start_row             = 6
        popup_type            = 'ICON_MESSAGE_CRITICAL'
      IMPORTING
        answer                = lv_resposta
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.

    IF lv_resposta = '1'.

*       Se for a primeira tela, sai do programa
      IF sy-dynnr = '0005'.
        LEAVE PROGRAM.
      ELSE.

        LEAVE TO SCREEN '0005'.

      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_USER_COMMAND_0005
*&---------------------------------------------------------------------*
FORM f_user_command_0005 .

  gv_okcode = sy-ucomm.

  CLEAR sy-ucomm.

  CASE gv_okcode.

*>>>> ABANDONAR PROGRAMA <<<<<*
*     ==================
    WHEN 'EXIT' OR 'CANC' OR 'BACK'.

      PERFORM f_saida USING gv_okcode.

  ENDCASE.


ENDFORM.
