class /PTLOMS/CL009 definition
  public
  inheriting from /PTLOMS/CL008
  final
  create public .

public section.

  methods MONTA_ALV_TREE .
  methods GET_GT_ALV_TREE
    exporting
      value(IT_DESPACHO_TREE) type /PTLOMS/CT080 .
protected section.
PRIVATE SECTION.

  DATA:
    s_werks  TYPE RANGE OF crhd-werks .
  DATA:
    s_aufnr  TYPE RANGE OF viaufks-aufnr .
  DATA:
    s_auart  TYPE RANGE OF viaufks-auart .
  DATA:
    s_qmnum  TYPE RANGE OF viaufks-qmnum .
  DATA:
    s_priok  TYPE RANGE OF viaufks-priok .
  DATA:
    s_tplnr  TYPE RANGE OF viaufks-tplnr .
  DATA:
    s_equnr  TYPE RANGE OF viaufks-equnr .
  DATA:
    s_iwerk  TYPE RANGE OF viaufks-iwerk .
  DATA:
    s_ingpr  TYPE RANGE OF viaufks-ingpr .
  DATA:
    s_ilart  TYPE RANGE OF viaufks-ilart .
  DATA:
    s_gewrk  TYPE RANGE OF crhd-arbpl .
  DATA:
    s_gstrp  TYPE RANGE OF viaufks-gstrp .
  DATA:
    s_datope TYPE RANGE OF afvv-fsavd .
  DATA:
    s_gstrp_ini  TYPE RANGE OF viaufks-gstrp .
  DATA:
    s_datope_ini TYPE RANGE OF afvv-fsavd .
  DATA:
    s_gstrp_fim  TYPE RANGE OF viaufks-gstrp .
  DATA:
    s_datope_fim TYPE RANGE OF afvv-fsavd .
  DATA:
    s_usuapp TYPE RANGE OF /ptloms/tb013-usuario .
  DATA:
    r_objid  TYPE RANGE OF crhd-objid .
  DATA:
    gt_despacho TYPE /ptloms/ct079 .
  DATA:
    gt_despacho_tree TYPE /ptloms/ct080 .
  DATA:
    gt_tb026 TYPE STANDARD TABLE OF /ptloms/tb026 .
  DATA:
    gt_nodes TYPE STANDARD TABLE OF ty_nodes .
  DATA p_f_tree TYPE flag .
  DATA p_mat_at TYPE flag .
  DATA p_oper TYPE flag .
  DATA p_ordens TYPE flag .
  DATA g_alv_tree TYPE REF TO cl_gui_alv_tree .
  DATA g_custom_container TYPE REF TO cl_gui_custom_container .
  DATA g_toolbar TYPE REF TO cl_gui_toolbar .
  DATA gt_fieldcatalog TYPE lvc_t_fcat .

  METHODS init_tree .
  METHODS build_hierarchy_header
    CHANGING
      !p_hierarchy_header TYPE treev_hhdr .
  METHODS build_fieldcatalog .
  METHODS change_toolbar .
  METHODS register_events .
ENDCLASS.



CLASS /PTLOMS/CL009 IMPLEMENTATION.


  METHOD build_fieldcatalog.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: ls_fieldcatalog TYPE lvc_s_fcat.

    REFRESH gt_fieldcatalog[].

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'USUARIO'.
*    ls_fieldcatalog-coltext   = 'Usuário'(045).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'NOME'.
*    ls_fieldcatalog-coltext   = 'Nome'(046).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'PERNR'.
*    ls_fieldcatalog-coltext   = 'Matrícula'(047).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '14'.
    ls_fieldcatalog-no_out    = ''.
    ls_fieldcatalog-no_zero   = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'AUFNR'.
*    ls_fieldcatalog-coltext   = 'Ordem'(010).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '12'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'AUART'.
*    ls_fieldcatalog-coltext   = 'Tipo Ordem'(011).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    IF p_ordens = 'X'.
      CLEAR ls_fieldcatalog.
      ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
      ls_fieldcatalog-fieldname = 'VORNR'.
*      ls_fieldcatalog-coltext   = 'Nº Operação'(048).
      ls_fieldcatalog-just      = 'C'.
      ls_fieldcatalog-outputlen = '10'.
      ls_fieldcatalog-no_out    = 'X'.
      APPEND ls_fieldcatalog TO gt_fieldcatalog.

      CLEAR ls_fieldcatalog.
      ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
      ls_fieldcatalog-fieldname = 'SUBOPER'.
*      ls_fieldcatalog-coltext   = 'SubOperação'(049).
      ls_fieldcatalog-just      = 'C'.
      ls_fieldcatalog-outputlen = '10'.
      ls_fieldcatalog-no_out    = 'X'.
      APPEND ls_fieldcatalog TO gt_fieldcatalog.

    ELSEIF p_oper = 'X'.
      CLEAR ls_fieldcatalog.
      ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
      ls_fieldcatalog-fieldname = 'VORNR'.
*      ls_fieldcatalog-coltext   = 'Nº Operação'(048).
      ls_fieldcatalog-just      = 'C'.
      ls_fieldcatalog-outputlen = '10'.
      ls_fieldcatalog-no_out    = ''.
      APPEND ls_fieldcatalog TO gt_fieldcatalog.

      CLEAR ls_fieldcatalog.
      ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
      ls_fieldcatalog-fieldname = 'SUBOPER'.
*      ls_fieldcatalog-coltext   = 'SubOperação'(049).
      ls_fieldcatalog-just      = 'C'.
      ls_fieldcatalog-outputlen = '10'.
      ls_fieldcatalog-no_out    = ''.
      APPEND ls_fieldcatalog TO gt_fieldcatalog.

***   SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO @DATA(lv_confirmacao).
      DATA: lv_confirmacao TYPE /ptloms/tb033-confirmacao.
      SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO lv_confirmacao.

      CLEAR ls_fieldcatalog.
      ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
      ls_fieldcatalog-fieldname = 'ARBEI'.
      IF lv_confirmacao = 'H'.
*        ls_fieldcatalog-coltext = 'Trab.Prev.(H)'(050).
      ELSEIF lv_confirmacao = 'MIN'.
*        ls_fieldcatalog-coltext = 'Trab.Prev.(Min)'(051).
      ELSE.
*        ls_fieldcatalog-coltext   = 'Trab.Prev.'(052).
      ENDIF.
      ls_fieldcatalog-just      = 'C'.
      ls_fieldcatalog-outputlen = '10'.
      ls_fieldcatalog-no_out    = ''.
      ls_fieldcatalog-no_zero   = 'X'.
      APPEND ls_fieldcatalog TO gt_fieldcatalog.
    ENDIF.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'QMNUM'.
*    ls_fieldcatalog-coltext   = 'Nota'(012).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
*  ls_fieldcatalog-datatype  = 'CHAR'.
    ls_fieldcatalog-no_out    = ''.
    ls_fieldcatalog-convexit  = 'ALPHA'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'PRIOK'.
*    ls_fieldcatalog-coltext   = 'Prioridade'(013).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'GEWRK'.
*    ls_fieldcatalog-coltext   = 'ID Centro Trabalho'(014).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'ARBPL'.
*    ls_fieldcatalog-coltext   = 'Centro Trabalho'(015).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'GSTRP'.
    ls_fieldcatalog-coltext   = 'Data-base do início'(016).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-datatype  = 'DATS'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'GLTRP'.
*    ls_fieldcatalog-coltext   = 'Data-base do fim'(017).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-datatype  = 'DATS'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'IDAT1'.
*    ls_fieldcatalog-coltext   = 'Data da liberação'(018).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-datatype  = 'DATS'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'KTEXT'.
*    ls_fieldcatalog-coltext   = 'Texto breve'(019).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'IWERK'.
*    ls_fieldcatalog-coltext   = 'Centro Plan.Man.'(020).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'INGPR'.
*    ls_fieldcatalog-coltext   = 'Grupo de planejamento'(021).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'TPLNR'.
*    ls_fieldcatalog-coltext   = 'Local de instalação'(022).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'PLTXT'.
*    ls_fieldcatalog-coltext   = 'Des.Local de inst.'(053).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'EQUNR'.
*    ls_fieldcatalog-coltext   = 'Nº equipamento'(024).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'EQKTX'.
*    ls_fieldcatalog-coltext   = 'Desc.Nº equipamento'(025).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'DATA_ASSOCIACAO'.
*    ls_fieldcatalog-coltext   = 'Data da Associção'(054).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '20'.
    ls_fieldcatalog-datatype  = 'DATS'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'HORA_ASSOCIACAO'.
*    ls_fieldcatalog-coltext   = 'Desc.Nº equipamento'(025).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'STATUS_SIS'.
*    ls_fieldcatalog-coltext   = 'Status Sistema'(028).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'STATUS_USU'.
*    ls_fieldcatalog-coltext   = 'Status Usuário'(029).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'OBJNR'.
*    ls_fieldcatalog-coltext   = 'Nº objeto'(055).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'ARBID'.
*    ls_fieldcatalog-coltext   = 'ID-objeto do centro trabalho'(056).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'LTXA1'.
*    ls_fieldcatalog-coltext   = 'Txt.breve operação'(057).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'ARTPR'.
*    ls_fieldcatalog-coltext   = 'Tipo de prioridade'(058).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'PRIOKX'.
*    ls_fieldcatalog-coltext   = 'Prioridade'(013).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'INNAM'.
*    ls_fieldcatalog-coltext   = 'Desc.Grp.Planj.'(059).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

  ENDMETHOD.


  METHOD build_hierarchy_header.

    p_hierarchy_header-heading = 'Usuários/Ordens'.
    p_hierarchy_header-tooltip = 'Usuários/Ordens'.
    p_hierarchy_header-width = 40.
    p_hierarchy_header-width_pix = ''.

  ENDMETHOD.


  METHOD change_toolbar.

    CALL METHOD g_alv_tree->get_toolbar_object
      IMPORTING
        er_toolbar = g_toolbar.

    CHECK NOT g_toolbar IS INITIAL. "could happen if you do not use the
    "standard toolbar

* §2.Modify toolbar with methods of CL_GUI_TOOLBAR:
* add seperator to toolbar
    CALL METHOD g_toolbar->add_button
      EXPORTING
        fcode     = ''
        icon      = ''
        butn_type = cntb_btype_sep.

** add Standard Button to toolbar (for Delete Subtree)
*  CALL METHOD g_toolbar->add_button
*    EXPORTING
*      fcode     = 'DELETE'
*      icon      = '@11@'
*      butn_type = cntb_btype_button
*      text      = ''
*      quickinfo = 'Eliminar subárvore'.   "Delete subtree

    AUTHORITY-CHECK OBJECT '/PTLOMS/02'
             ID 'TCD' FIELD sy-tcode
             ID 'ACTVT' FIELD '02'.

    IF sy-subrc = 0.

      IF p_ordens = 'X'.
* add Standard Button to toolbar
        CALL METHOD g_toolbar->add_button
          EXPORTING
            fcode     = 'DESASSOCIA'
            icon      = icon_disconnect
            butn_type = cntb_btype_button
            text      = 'Desassociar Ordem'.
*         quickinfo = 'Desassociar Ordem'(040).   "Desassociar Ordem

* add Standard Button to toolbar
        CALL METHOD g_toolbar->add_button
          EXPORTING
            fcode     = 'TRANSFERE'
            icon      = icon_transfer
            butn_type = cntb_btype_button
            text      = 'Transferir Ordens'.
*         quickinfo = 'Transferir Ordens'(041).   "Transferir Ordens

      ELSEIF p_oper = 'X'.
* add Standard Button to toolbar
        CALL METHOD g_toolbar->add_button
          EXPORTING
            fcode     = 'DESASSOCIA'
            icon      = icon_disconnect
            butn_type = cntb_btype_button
            text      = 'Desassociar Operação'.
*         quickinfo = 'Desassociar Operação'(042).   "Desassociar Operação

* add Standard Button to toolbar
        CALL METHOD g_toolbar->add_button
          EXPORTING
            fcode     = 'TRANSFERE'
            icon      = icon_transfer
            butn_type = cntb_btype_button
            text      = 'Transferir Operação'.
*         quickinfo = 'Transferir Operação'(043).   "Transferir Operação
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_gt_alv_tree.

    it_despacho_tree = gt_despacho_tree.

  ENDMETHOD.


  METHOD init_tree.
* cria container para alv-tree
    DATA: l_tree_container_name(30) TYPE c.

    DATA: ls_vari TYPE disvariant.

*    l_tree_container_name = 'O_CONTAINER2'.
*
*    CREATE OBJECT g_custom_container
*      EXPORTING
*        container_name              = l_tree_container_name
*      EXCEPTIONS
*        cntl_error                  = 1
*        cntl_system_error           = 2
*        create_error                = 3
*        lifetime_error              = 4
*        lifetime_dynpro_dynpro_link = 5.
*    IF sy-subrc <> 0.
*      MESSAGE x208(00) WITH 'ERROR'(100).
*    ENDIF.

* cria tree control
    CREATE OBJECT g_alv_tree
      EXPORTING
        parent                      = g_custom_container
*       node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
        node_selection_mode         = cl_gui_list_tree=>node_sel_mode_multiple
        item_selection              = ' '
        no_html_header              = 'X'
        no_toolbar                  = ''
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        illegal_node_selection_mode = 5
        failed                      = 6
        illegal_column_name         = 7.
    IF sy-subrc <> 0.
      MESSAGE x208(00) WITH 'ERROR'.                        "#EC NOTEXT
    ENDIF.

    DATA l_hierarchy_header TYPE treev_hhdr.
    build_hierarchy_header( CHANGING p_hierarchy_header = l_hierarchy_header ).

* Define as características das colunas
    build_fieldcatalog( ).

    ls_vari-report     = sy-repid.
*    ls_vari-variant    = p_vari2.
*    ls_vari-handle     = c_hande.
*  ls_vari-log_group  = 'PROG'.
*  ls_vari-username   = space.
*  ls_vari-text       = space.
*  ls_vari-dependvars = space.

* Tabela 'gt_despacho_tree' deve estar vazia e global
    CALL METHOD g_alv_tree->set_table_for_first_display
      EXPORTING
        is_variant          = ls_vari
*       i_save              = c_save
        is_hierarchy_header = l_hierarchy_header
      CHANGING
        it_fieldcatalog     = gt_fieldcatalog
        it_outtab           = gt_despacho_tree. "tabela deve estar vazia!

* Monta Hierarquia do ALV Tree
    busca_dados_tree( CHANGING it_despacho_tree = gt_despacho_tree
                               it_tb026         = gt_tb026
                               it_nodes         = gt_nodes
                               g_alv_tree       = g_alv_tree ).

* Extende funções do MENU
    change_toolbar( ).

    register_events( ).

*    CALL METHOD g_alv_tree->update_calculations.

** Envia os dados para o frontend.
*    CALL METHOD g_alv_tree->frontend_update.

  ENDMETHOD.


  METHOD monta_alv_tree.

    IF g_alv_tree IS INITIAL.

      IF g_alv_tree IS NOT INITIAL.
        CALL METHOD g_alv_tree->free.
        CALL METHOD g_alv_tree->finalize.
      ENDIF.

      IF g_custom_container IS NOT INITIAL.
        CALL METHOD g_custom_container->free.
        CALL METHOD g_custom_container->finalize.
      ENDIF.

      init_tree( ).

      CALL METHOD cl_gui_cfw=>flush
        EXCEPTIONS
          cntl_system_error = 1
          cntl_error        = 2.
      IF sy-subrc NE 0.
        CALL FUNCTION 'POPUP_TO_INFORM'
          EXPORTING
            titel = 'Erro na fila de automação'
            txt1  = 'Erro interno:'
            txt2  = 'Um método na fila de automação'
            txt3  = 'provocou um erro'.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD register_events.

*    DATA: lt_events        TYPE cntl_simple_events,
*          l_event          TYPE cntl_simple_event,
*          l_event_receiver TYPE REF TO lcl_toolbar_event_receiver.
*
*    CALL METHOD g_alv_tree->get_registered_events
*      IMPORTING
*        events = lt_events.
*
** register events on frontend
*    CALL METHOD g_alv_tree->set_registered_events
*      EXPORTING
*        events                    = lt_events
*      EXCEPTIONS
*        cntl_error                = 1
*        cntl_system_error         = 2
*        illegal_event_combination = 3.
*    IF sy-subrc <> 0.
*      MESSAGE x208(00) WITH 'ERROR'.                        "#EC NOTEXT
*    ENDIF.
**-------------------------------------------------------------------
*
*    CREATE OBJECT l_event_receiver.
*    SET HANDLER l_event_receiver->on_function_selected FOR g_toolbar.

  ENDMETHOD.
ENDCLASS.
