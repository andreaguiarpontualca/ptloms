CLASS /ptloms/cl008 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
*    TYPES ty_despacho TYPE /ptloms/et078 .
*    TYPES:
*      BEGIN OF ty_despacho.
*        aufnr           TYPE viaufks-aufnr,
*        vornr           TYPE plpo-vornr,
*        suboper         TYPE uvorn,
*        data_associacao TYPE /ptloms/tb026-data_desassociacao,
*        hora_associacao TYPE /ptloms/tb026-hora_desassociacao,
*        auart           TYPE viaufks-auart,
*        qmnum           TYPE viaufks-qmnum,
*        priok           TYPE viaufks-priok,
*        gewrk           TYPE viaufks-gewrk,
*        arbpl           TYPE crhd-arbpl,
*        gstrp           TYPE viaufks-gstrp,
*        gltrp           TYPE viaufks-gltrp,
*        idat1           TYPE viaufks-idat1,
*        ktext           TYPE viaufks-ktext,
*        iwerk           TYPE viaufks-iwerk,
*        ingpr           TYPE viaufks-ingpr,
*        tplnr           TYPE viaufks-tplnr,
*        pltxt           TYPE iflotx-pltxt,
*        equnr           TYPE viaufks-equnr,
*        eqktx           TYPE v_equi-eqktx,
*        objnr           TYPE viaufks-objnr,
*        status_usu      TYPE j_stext,
*        status_sis      TYPE j_stext,
*        arbid           TYPE afvc-arbid,
*        ltxa1           TYPE afvc-ltxa1,
*        artpr           TYPE viaufks-artpr,
*        priokx          TYPE t356_t-priokx,
*        innam           TYPE t024i-innam,
*        aufpl           TYPE afvc-aufpl,
*        aplzl           TYPE afvc-aplzl,
*        sumnr           TYPE afvc-sumnr,
*        pernr           TYPE afvc-pernr,
*        objnr_oper_sub  TYPE afvc-objnr,
*        arbei           TYPE afvv-arbei,
*    end of ty_despacho .
      BEGIN OF ty_usuario.
    TYPES: usuario   TYPE /ptloms/tb013-usuario.
    TYPES: nome      TYPE /ptloms/tb013-nome.
    TYPES: matricula TYPE /ptloms/tb013-matricula.
    TYPES: END OF ty_usuario .
    TYPES:
      BEGIN OF ty_nodes,
        node    TYPE lvc_nkey,
        usuario TYPE /ptloms/tb013-usuario,
        data    TYPE d,
      END OF ty_nodes .
    TYPES:
*  types:
*    ct_despacho TYPE TABLE OF ty_despacho .
*  types:
*    ct_despacho_tree TYPE TABLE OF /ptloms/ct080 .
      ct_tb026 TYPE TABLE OF /ptloms/tb026 .
    TYPES:
      ct_nodes TYPE TABLE OF ty_nodes .

    METHODS constructor
      IMPORTING
        !rt_werks      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_aufnr      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_vornr      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_auart      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_qmnum      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_priok      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_tplnr      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_equnr      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_iwerk      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_ingpr      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_ilart      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_gewrk      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_gstrp      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_datope     TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_usuperfil  TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_usuapp     TYPE /iwbep/t_cod_select_options OPTIONAL
        !im_f_tree     TYPE flag OPTIONAL
        !im_mat_at     TYPE flag OPTIONAL
        !im_oper       TYPE flag OPTIONAL
        !im_ordens     TYPE flag OPTIONAL
        !rt_gstrp_ini  TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_datope_ini TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_gstrp_fim  TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_datope_fim TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_vlsch      TYPE /iwbep/t_cod_select_options OPTIONAL
        !rt_ernam      TYPE /iwbep/t_cod_select_options OPTIONAL .

    METHODS busca_dados
      IMPORTING
        VALUE(origem)      TYPE char3 OPTIONAL
      EXPORTING
        VALUE(it_despacho) TYPE /ptloms/ct079 .

    METHODS busca_dados_tree
      CHANGING
        !it_despacho_tree TYPE /ptloms/ct080
        !it_tb026         TYPE ct_tb026
        !it_nodes         TYPE ct_nodes
        !g_alv_tree       TYPE REF TO cl_gui_alv_tree .

    CLASS-METHODS associar
      IMPORTING
        !im_ordem         TYPE /ptloms/ct104 OPTIONAL
      EXPORTING
        VALUE(em_ordem)   TYPE /ptloms/ct104
        VALUE(re_retorno) TYPE bapiret2_t .

    CLASS-METHODS desassociar
      IMPORTING
        !im_ordem         TYPE /ptloms/ct104
      EXPORTING
        VALUE(re_retorno) TYPE bapiret2_t .

    METHODS transferir
      IMPORTING
        VALUE(im_ordem)   TYPE /ptloms/ct104
      EXPORTING
        VALUE(em_ordem)   TYPE /ptloms/ct104
        VALUE(re_retorno) TYPE bapiret2_t .

    CLASS-METHODS liberar_ordem
      IMPORTING
        !im_ordem         TYPE /ptloms/ct108
      EXPORTING
        VALUE(re_retorno) TYPE bapiret2_t .

    CLASS-METHODS validar_associar
      IMPORTING
        !im_ordem         TYPE /ptloms/ct104 OPTIONAL
      EXPORTING
        !em_ordem         TYPE /ptloms/ct104
        VALUE(re_retorno) TYPE bapiret2_t .

    METHODS busca_endereco_cliente
      IMPORTING
        VALUE(it_despacho)     TYPE /ptloms/ct079
      EXPORTING
        VALUE(it_despacho_out) TYPE /ptloms/ct079 .

    METHODS busca_endereco_cliente_tree
      CHANGING
        VALUE(it_despacho) TYPE /ptloms/ct080 .

    CLASS-METHODS validar_permissao_usuario
      IMPORTING
        !im_usuario TYPE char12
      EXCEPTIONS
        erro_usuario_permissao .

    CLASS-METHODS ler_bloqueio_ordem
      IMPORTING
        VALUE(im_ordem) TYPE aufnr
      EXPORTING
        VALUE(iv_uname) TYPE uname
        VALUE(subrc)    TYPE sy-subrc .

    CLASS-METHODS validar_transferencia
      IMPORTING
        !im_ordem         TYPE /ptloms/et129
      EXPORTING
        VALUE(re_retorno) TYPE bapiret2_t .

    CLASS-METHODS validar_dessasociacao
      IMPORTING
        !im_ordem         TYPE /ptloms/et129
      EXPORTING
        VALUE(re_retorno) TYPE bapiret2_t .
protected section.
private section.

  data:
    s_werks  TYPE RANGE OF crhd-werks .
  data:
    s_eqtyp  TYPE RANGE OF equi-eqtyp .
  data:
    s_aufnr  TYPE RANGE OF viaufks-aufnr .
  data:
    s_vornr  TYPE RANGE OF afvgd-vornr .
  data:
    s_auart  TYPE RANGE OF viaufks-auart .
  data:
    s_qmnum  TYPE RANGE OF viaufks-qmnum .
  data:
    s_priok  TYPE RANGE OF viaufks-priok .
  data:
    s_tplnr  TYPE RANGE OF viaufks-tplnr .
  data:
    s_equnr  TYPE RANGE OF viaufks-equnr .
  data:
    s_iwerk  TYPE RANGE OF viaufks-iwerk .
  data:
    s_ingpr  TYPE RANGE OF viaufks-ingpr .
  data:
    s_ilart  TYPE RANGE OF viaufks-ilart .
  data:
    s_gewrk  TYPE RANGE OF crhd-arbpl .
  data:
    s_gstrp  TYPE RANGE OF viaufks-gstrp .
  data:
    s_datope TYPE RANGE OF afvv-fsavd .
  data:
    s_gstrp_ini  TYPE RANGE OF viaufks-gstrp .
  data:
    s_datope_ini TYPE RANGE OF afvv-fsavd .
  data:
    s_gstrp_fim  TYPE RANGE OF viaufks-gstrp .
  data:
    s_datope_fim TYPE RANGE OF afvv-fsavd .
  data:
    s_usuapp TYPE RANGE OF /ptloms/tb013-usuario .
  data:
    s_usuperfil TYPE RANGE OF /ptloms/tb013-usuario .
  data:
    r_objid  TYPE RANGE OF crhd-objid .
  data GT_DESPACHO type /PTLOMS/CT079 .
  data GT_DESPACHO_TREE type /PTLOMS/CT080 .
  data:
    gt_tb026 TYPE STANDARD TABLE OF /ptloms/tb026 .
  data:
    gt_nodes TYPE STANDARD TABLE OF ty_nodes .
  data P_F_TREE type FLAG .
  data P_MAT_AT type FLAG .
  data P_OPER type FLAG .
  data P_ORDENS type FLAG .
  data GV_DATUM type DATUM .
  data GV_UZEIT type UZEIT .
  data:
    s_vlsch TYPE RANGE OF vlsch .
  data:
    s_ernam TYPE RANGE OF ernam .

  methods ADD_USER
    importing
      !P_USER type /PTLOMS/TB013-USUARIO
      !P_RELAT_KEY type LVC_NKEY
    changing
      !P_NODE_KEY type LVC_NKEY
      !G_ALV_TREE type ref to CL_GUI_ALV_TREE .
  methods GET_USER
    importing
      !P_USER type /PTLOMS/TB013-USUARIO
    changing
      !P_USER_NAME type /PTLOMS/TB013-NOME .
  methods ADD_COMPLETE_LINE
    importing
      !P_RELAT_KEY type LVC_NKEY
    changing
      !PS_DESPACHO_TREE type /PTLOMS/ET079
      !P_NODE_KEY type LVC_NKEY
      !G_ALV_TREE type ref to CL_GUI_ALV_TREE .
  methods ATUALIZA_DESASSOCIACAO
    importing
      !IM_ORDEM type /PTLOMS/ET119
    changing
      !CH_ERRO type FLAG .
  methods ASSOCIA_MAT_OPERACAO
    importing
      !IM_ORDEM type /PTLOMS/ET119
      !IM_REMOVE type FLAG
    changing
      !CH_ERRO type FLAG
      value(CH_RETORNO) type BAPIRET2_T optional .
  class-methods ASSOCIA_MAT_OPERACAO_BAPI
    importing
      !IM_ORDEM type /PTLOMS/ET119
      !IM_REMOVE type FLAG
      !IM_MATRICULA type PERSNO
    changing
      !CH_ERRO type FLAG
      value(RE_RETORNO) type BAPIRET2_T optional .
  methods ADD_DATA
    importing
      !P_USER type /PTLOMS/TB013-USUARIO
      !P_DATA type /PTLOMS/ET079-GSTRP
      !P_RELAT_KEY type LVC_NKEY
    changing
      !P_NODE_KEY type LVC_NKEY
      !G_ALV_TREE type ref to CL_GUI_ALV_TREE .
ENDCLASS.



CLASS /PTLOMS/CL008 IMPLEMENTATION.


  METHOD add_complete_line.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

    DATA: ls_layout_node TYPE lvc_s_layn.

    DATA: l_node_text TYPE lvc_value.

    DATA: lv_data TYPE char10.

    MOVE ps_despacho_tree-aufnr TO l_node_text.

*    l_node_text = |{ l_node_text ALPHA = OUT }|.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = l_node_text
      IMPORTING
        output = l_node_text.

    IF ps_despacho_tree-pernr IS INITIAL.
* Cor
      ls_layout_node-style   = 5.
    ENDIF.

*   Imagem ao abrir
    ls_layout_node-n_image   = icon_order.

*   Imagem ao expandir
    ls_layout_node-exp_image = icon_order.

    " 15/03/2023 - Converter data externa para interna devido campo não DATUM
*    CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
*      EXPORTING
*        date_internal            = CONV datum( ps_despacho_tree-data_associacao )
*      IMPORTING
*        date_external            = lv_data
*      EXCEPTIONS
*        date_internal_is_invalid = 1
*        OTHERS                   = 2.

    DATA: lv_dats TYPE d.
    CLEAR lv_dats.

    WRITE ps_despacho_tree-data_associacao(08) TO  lv_dats.

    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lv_dats
      IMPORTING
        output = lv_data.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    ps_despacho_tree-data_associacao = lv_data.
    " 15/03/2023 - Converter data INTERNA para EXTERNA devido campo não DATUM

*    WRITE ps_despacho_tree-hora_associacao TO ps_despacho_tree-hora_associacao USING EDIT MASK '__:__'.

    CALL METHOD g_alv_tree->add_node
      EXPORTING
        i_relat_node_key = p_relat_key
        i_relationship   = cl_gui_column_tree=>relat_last_child
        is_outtab_line   = ps_despacho_tree
        is_node_layout   = ls_layout_node
        i_node_text      = l_node_text
      IMPORTING
        e_new_node_key   = p_node_key.

  ENDMETHOD.


  METHOD add_data.

* Declaração de estrutura
    DATA: ls_despacho_tree TYPE /ptloms/et079, "ty_despacho_tree
          ls_nodes         LIKE LINE OF gt_nodes,
          ls_layout_node   TYPE lvc_s_layn..

* Declaração de variáveis
    DATA: lv_node_text TYPE lvc_value,
          lv_user_name TYPE /ptloms/tb013-nome,
          lv_hr_plan   TYPE char20.

* Recupera nome do usuário
    get_user( EXPORTING p_user      = p_user
               CHANGING p_user_name = lv_user_name ).

    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = p_data
      IMPORTING
        output = lv_node_text.

*   Imagem ao abrir
    ls_layout_node-n_image   = icon_date.

*   Imagem ao expandir
    ls_layout_node-exp_image = icon_date.

* add node
    CALL METHOD g_alv_tree->add_node
      EXPORTING
        i_relat_node_key = p_relat_key
        i_relationship   = cl_gui_column_tree=>relat_last_child
        i_node_text      = lv_node_text
        is_node_layout   = ls_layout_node
        is_outtab_line   = ls_despacho_tree
      IMPORTING
        e_new_node_key   = p_node_key.

* add user
    FIELD-SYMBOLS:
      <fs_nodes>  LIKE LINE OF gt_nodes.

    READ TABLE gt_nodes ASSIGNING <fs_nodes> WITH KEY usuario = p_user
                                                      data    = p_data.
    IF sy-subrc EQ 0.
      <fs_nodes>-node  = p_node_key.
    ELSE.
      ls_nodes-node    = p_node_key.
      ls_nodes-usuario = p_user.
      ls_nodes-data    = p_data.
      APPEND ls_nodes TO gt_nodes.
    ENDIF.

  ENDMETHOD.


  METHOD add_user.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de estrutura
    DATA: ls_despacho_tree TYPE /ptloms/et079, "ty_despacho_tree
          ls_nodes         LIKE LINE OF gt_nodes,
          ls_layout_node   TYPE lvc_s_layn.

* Declaração de variáveis
    DATA: lv_node_text TYPE lvc_value,
          lv_user_name TYPE /ptloms/tb013-nome, "output string for user
          lv_hr_plan   TYPE char20.

* Recupera nome do usuário
    get_user( EXPORTING p_user      = p_user
               CHANGING p_user_name = lv_user_name ).

*  lv_node_text = lv_user_name && | - (Trab.Prev. | && lv_hr_plan && |)|.
    lv_node_text = lv_user_name.

*   Imagem ao abrir
    ls_layout_node-n_image   = icon_customer.

*   Imagem ao expandir
    ls_layout_node-exp_image = icon_customer.

* add node
    CALL METHOD g_alv_tree->add_node
      EXPORTING
        i_relat_node_key = p_relat_key
        i_relationship   = cl_gui_column_tree=>relat_last_child
        i_node_text      = lv_node_text
        is_node_layout   = ls_layout_node
        is_outtab_line   = ls_despacho_tree
      IMPORTING
        e_new_node_key   = p_node_key.

* add user
*    READ TABLE gt_nodes ASSIGNING FIELD-SYMBOL(<fs_nodes>) WITH KEY usuario = p_user.
    FIELD-SYMBOLS:
      <fs_nodes>  LIKE LINE OF gt_nodes.

    READ TABLE gt_nodes ASSIGNING <fs_nodes> WITH KEY usuario = p_user.

    IF sy-subrc EQ 0.
      <fs_nodes>-node = p_node_key.
    ELSE.
      ls_nodes-node = p_node_key.
      ls_nodes-usuario = p_user.
      APPEND ls_nodes TO gt_nodes.
    ENDIF.

  ENDMETHOD.


  METHOD associar.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

*   Declaração de Tabelas Interna
    DATA: lt_operacao	       TYPE /ptloms/ct104,
          ls_operacao        TYPE /ptloms/et119,
          lt_return_despacho TYPE STANDARD TABLE OF bapiret2,
          lt_message         TYPE STANDARD TABLE OF bapiret2,
          lv_aufnr           TYPE aufnr,
          im_ordem_aux       TYPE /ptloms/ct104.

    im_ordem_aux = im_ordem.

    SORT im_ordem_aux BY aufnr vornr.
    DELETE ADJACENT DUPLICATES FROM im_ordem_aux COMPARING aufnr vornr.

    DATA: lt_026 TYPE TABLE OF /ptloms/tb026.

    SELECT aufnr vornr suboper
      FROM /ptloms/tb026
      INTO CORRESPONDING FIELDS OF TABLE lt_026
      FOR ALL ENTRIES IN im_ordem
      WHERE aufnr = im_ordem-aufnr
        AND desassociado = space.

***    SELECT aufnr, vornr, suboper
***      FROM /ptloms/tb026
***      INTO TABLE @DATA(lt_026)
***      FOR ALL ENTRIES IN @im_ordem
***      WHERE aufnr = @im_ordem-aufnr
***        AND desassociado = @space.

    SORT lt_026 BY aufnr vornr.

*** LOOP AT im_ordem_aux INTO DATA(ls_ordem).
    DATA: ls_ordem LIKE LINE OF im_ordem_aux.
    LOOP AT im_ordem_aux INTO ls_ordem.

      IF ls_ordem-vornr IS NOT INITIAL.

        ls_operacao-aufnr           = ls_ordem-aufnr.
        ls_operacao-vornr           = ls_ordem-vornr.
        ls_operacao-usuario_destino = ls_ordem-usuario_destino.
        APPEND ls_operacao TO lt_operacao.

      ELSE.

*       Busca roteiro da ordem
***     SELECT SINGLE aufpl FROM afko INTO @DATA(lv_aufpl) WHERE aufnr = @ls_ordem-aufnr.
        DATA: lv_aufpl TYPE afko-aufpl.
        SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = ls_ordem-aufnr.

        IF sy-subrc EQ 0.

*         Busca todas as operações da Ordem
          DATA: lt_afvc TYPE TABLE OF afvc.

          SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
            FROM afvc AS a
            INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
            INTO CORRESPONDING FIELDS OF TABLE lt_afvc
            WHERE a~aufpl = lv_aufpl
              AND a~phflg = space.

***          SELECT a~aufpl, a~aplzl, a~vornr, a~sumnr, a~objnr
***            FROM afvc AS a
***            INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***            INTO TABLE @DATA(lt_afvc)
***            WHERE a~aufpl = @lv_aufpl
***              AND a~phflg = @space.

***       LOOP AT lt_afvc ASSIGNING FIELD-SYMBOL(<fs_afvc>).
          FIELD-SYMBOLS: <fs_afvc> LIKE LINE OF lt_afvc.
          LOOP AT lt_afvc ASSIGNING <fs_afvc>.
            DATA tabix type sy-tabix.
            tabix = sy-tabix.
*            DATA(tabix) = sy-tabix.

            READ TABLE lt_026 TRANSPORTING NO FIELDS WITH KEY aufnr = ls_ordem-aufnr
                                                              vornr = <fs_afvc>-vornr
                                                     BINARY SEARCH.

            IF sy-subrc IS NOT INITIAL.

              DELETE lt_afvc INDEX tabix.

            ENDIF.

          ENDLOOP.

***       DATA(lt_afvc_aux) = lt_afvc.
          DATA: lt_afvc_aux TYPE TABLE OF afvc.
          lt_afvc_aux = lt_afvc.

***       lt_operacao = CORRESPONDING #( lt_afvc MAPPING vornr = vornr ).
          DATA: wa_afvc     LIKE LINE OF lt_afvc,
                wa_operacao LIKE LINE OF lt_operacao.

          LOOP AT lt_afvc INTO wa_afvc.
            MOVE-CORRESPONDING wa_afvc TO wa_operacao.
            APPEND wa_operacao TO lt_operacao.
          ENDLOOP.

***       LOOP AT lt_operacao ASSIGNING FIELD-SYMBOL(<fs_operacao>).
          FIELD-SYMBOLS: <fs_operacao> LIKE LINE OF lt_operacao.
          LOOP AT lt_operacao ASSIGNING <fs_operacao>.
            <fs_operacao>-usuario_destino = ls_ordem-usuario_destino.
          ENDLOOP.

        ENDIF.

      ENDIF.

      IF lt_operacao IS NOT INITIAL.
*       Despacho automático
        CALL FUNCTION '/PTLOMS/MF094'
          EXPORTING
            im_aufnr    = ls_ordem-aufnr
            im_associar = abap_true
          TABLES
            it_return   = lt_return_despacho
          CHANGING
            it_operacao = lt_operacao.

        LOOP AT lt_return_despacho TRANSPORTING NO FIELDS WHERE type = 'E'.
          EXIT.
        ENDLOOP.

        APPEND LINES OF lt_return_despacho TO re_retorno.

        SORT lt_operacao BY aufnr vornr.

        "Atualizar data e hora da associação

***     LOOP AT lt_operacao INTO DATA(wa_operacao).
        LOOP AT lt_operacao INTO wa_operacao.

***          READ TABLE im_ordem_aux ASSIGNING FIELD-SYMBOL(<fs_ordem_aux>) WITH KEY aufnr = wa_operacao-aufnr
***                                                                                  vornr = wa_operacao-vornr.
          FIELD-SYMBOLS: <fs_ordem_aux> LIKE LINE OF im_ordem_aux.
          READ TABLE im_ordem_aux ASSIGNING <fs_ordem_aux> WITH KEY aufnr = wa_operacao-aufnr
                                                                    vornr = wa_operacao-vornr.


          IF sy-subrc IS NOT INITIAL.

***         wa_operacao-aufnr = |{ wa_operacao-aufnr ALPHA = IN }|.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = wa_operacao-aufnr
              IMPORTING
                output = wa_operacao-aufnr.

            READ TABLE im_ordem_aux ASSIGNING <fs_ordem_aux> WITH KEY aufnr = wa_operacao-aufnr
                                                                      vornr = wa_operacao-vornr.

          ENDIF.

***       <fs_ordem_aux>-aufnr                = |{ <fs_ordem_aux>-aufnr ALPHA = OUT }|.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_ordem_aux>-aufnr
            IMPORTING
              output = <fs_ordem_aux>-aufnr.

          <fs_ordem_aux>-data_associacao      = wa_operacao-data_associacao.
          <fs_ordem_aux>-hora_associacao      = wa_operacao-hora_associacao.

          DATA: wl_tb013 TYPE /ptloms/tb013.

          SELECT SINGLE nome matricula
            FROM /ptloms/tb013
            INTO CORRESPONDING FIELDS OF wl_tb013
            WHERE usuario = wa_operacao-usuario_destino.

***          SELECT SINGLE nome, matricula
***            FROM /ptloms/tb013
***            INTO @DATA(wl_tb013)
***            WHERE usuario = @wa_operacao-usuario_destino.

          <fs_ordem_aux>-nome                 = wl_tb013-nome.
          <fs_ordem_aux>-matricula            = wl_tb013-matricula.
          <fs_ordem_aux>-motivo_associacao    = '03'.
          <fs_ordem_aux>-descricao_associacao = 'Associada'(003).

          CLEAR: wl_tb013.

        ENDLOOP.

      ENDIF.

      CLEAR: lt_operacao, lt_return_despacho.

    ENDLOOP.

*   CLEAR: im_ordem.

*   im_ordem = im_ordem_aux.
    em_ordem = im_ordem_aux.

  ENDMETHOD.


  METHOD associa_mat_operacao.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

    DATA: lv_erro      TYPE char1,
          lv_suboper   TYPE uvorn,
          lv_objnr     TYPE jsto-objnr,
          lv_desprezar TYPE char1.

* As informações do usuário são relevantes apenas na Associação
    IF im_remove IS INITIAL.

* Busca dados do usuário
*      SELECT SINGLE usuario, associa, matricula
*        FROM /ptloms/tb013
*        INTO @DATA(ls_013)
*        WHERE usuario = @im_ordem-usuario_origem.
*
      DATA ls_013   TYPE /ptloms/tb013.
      CLEAR ls_013.
      SELECT SINGLE usuario associa matricula
        FROM /ptloms/tb013
        INTO CORRESPONDING FIELDS OF ls_013
        WHERE usuario = im_ordem-usuario_origem.
*
* Verifica se no cadastro do usuário está configura para associar a Matrícula à Operação
      IF ls_013-associa IS INITIAL OR ls_013-matricula IS INITIAL.
        RETURN.
      ENDIF.

    ENDIF.

* Se Operação não estiver preechido, então aplica-se a rotina para todas operações
    IF im_ordem-vornr IS NOT INITIAL.

      associa_mat_operacao_bapi( EXPORTING im_ordem = im_ordem im_matricula = ls_013-matricula im_remove = im_remove CHANGING ch_erro = ch_erro re_retorno = ch_retorno ).

    ELSE.
* Busca roteiro da ordem
*      SELECT SINGLE aufpl FROM afko INTO @DATA(lv_aufpl) WHERE aufnr = @im_ordem-aufnr.
      DATA: lv_aufpl   TYPE afko-aufpl.
      CLEAR lv_aufpl.
      SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = im_ordem-aufnr.

      IF sy-subrc EQ 0.

* Busca todas as operações da Ordem
*        SELECT a~aufpl, a~aplzl, a~vornr, a~sumnr, a~objnr
*          FROM afvc AS a
*          INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
*          INTO TABLE @DATA(lt_afvc)
*          WHERE a~aufpl = @lv_aufpl
*            AND a~phflg   = @space
*            AND b~fsavd IN @s_datope.
*
*        DATA(lt_afvc_aux) = lt_afvc.
*
*        LOOP AT lt_afvc INTO DATA(ls_afvc).


        DATA:
          lt_afvc       TYPE TABLE OF afvc,
          lt_afvc_aux   TYPE TABLE OF afvc,
          ls_afvc       TYPE afvc,
          ls_afvc_aux   TYPE afvc.

        SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
          FROM afvc AS a
          INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
          APPENDING CORRESPONDING FIELDS OF TABLE lt_afvc
          WHERE a~aufpl  = lv_aufpl
            AND a~phflg  = space
            AND b~fsavd IN s_datope.

        refresh lt_afvc_aux.
        lt_afvc_aux[] = lt_afvc[].

        LOOP AT lt_afvc INTO ls_afvc.

          lv_objnr = ls_afvc-objnr.

          CLEAR lv_desprezar.
          CALL FUNCTION '/PTLOMS/MF008'
            EXPORTING
              im_objnr     = lv_objnr
            IMPORTING
              ex_desprezar = lv_desprezar.

          IF lv_desprezar = 'X'.
            CONTINUE.
          ENDIF.

          CLEAR lv_suboper.

          IF ls_afvc-sumnr IS NOT INITIAL.
*            READ TABLE lt_afvc_aux INTO DATA(ls_afvc_aux) WITH KEY aufpl = ls_afvc-aufpl
            READ TABLE lt_afvc_aux INTO ls_afvc_aux WITH KEY aufpl = ls_afvc-aufpl
                                                                   aplzl = ls_afvc-sumnr.
            IF sy-subrc EQ 0.
              lv_suboper    = ls_afvc-vornr.
              ls_afvc-vornr = ls_afvc_aux-vornr.
            ENDIF.

          ENDIF.

          associa_mat_operacao_bapi( EXPORTING im_ordem = im_ordem im_remove = im_remove im_matricula = ls_013-matricula CHANGING ch_erro = ch_erro re_retorno = ch_retorno ).

          IF lv_erro IS NOT INITIAL.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lv_erro IS INITIAL.
*    MESSAGE s000(su) WITH 'Matrícula associada com sucesso'.
    ELSE.
      MESSAGE s000(su) WITH 'Erro ao desassociar matrícula.'(086) DISPLAY LIKE 'E'.
    ENDIF.

  ENDMETHOD.


  METHOD associa_mat_operacao_bapi.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de tabelas interna
    DATA: lt_methods      TYPE STANDARD TABLE OF bapi_alm_order_method,
          lt_operation    TYPE STANDARD TABLE OF bapi_alm_order_operation,
          lt_operation_up TYPE STANDARD TABLE OF bapi_alm_order_operation_up,
          ls_retorno      TYPE bapiret2,
          lt_return       TYPE TABLE OF bapiret2.

* Declaração de estruturas
    DATA: ls_methods      LIKE LINE OF lt_methods,
          ls_operation    LIKE LINE OF lt_operation,
          ls_operation_up LIKE LINE OF lt_operation_up.

* Declaração de variáveis
    DATA: lv_objecttype TYPE objidext,
          lv_aufnr      TYPE aufnr,
          lv_vornr      TYPE vornr,
          lv_suboper    TYPE vornr.

* Rotina de Conversão para Ordem
*    lv_aufnr = |{ im_ordem-aufnr ALPHA = IN }|.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_ordem-aufnr
      IMPORTING
        output = lv_aufnr.

* Rotina de conversão para Operação
    IF im_ordem-vornr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
        EXPORTING
          input  = im_ordem-vornr
        IMPORTING
          output = lv_vornr.
    ENDIF.

* Rotina de conversão para SubOperação
    IF im_ordem-suboper IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
        EXPORTING
          input  = im_ordem-suboper
        IMPORTING
          output = lv_suboper.
    ENDIF.

* Monta OBJECTTYPE
    lv_objecttype = lv_aufnr && lv_vornr && lv_suboper.

* Verifica se Ordem/Usuário estão preenchidos
    IF im_ordem-aufnr IS INITIAL OR im_ordem-usuario_destino IS INITIAL.
      RETURN.
    ENDIF.

*    ls_return-message_v1 = |{ text-021 }| & | | & |{ lv_aufnr ALPHA = OUT }|.
*    ls_return-message_v2 = |{ text-022 }| & | | & |{ lv_vornr ALPHA = OUT }|.
*
*    APPEND ls_return TO it_return.
*
* Carrega parâmetros da BAPI
    ls_methods-refnumber = 1.
    ls_methods-objecttype = space.
    ls_methods-method     = 'SAVE'.
    ls_methods-objectkey  = lv_objecttype.
    APPEND ls_methods TO lt_methods.

    CLEAR ls_methods.
    ls_methods-refnumber = 1.
    ls_methods-objecttype = 'OPERATION'.
    ls_methods-method     = 'CHANGE'.
    ls_methods-objectkey  = lv_objecttype.
    APPEND ls_methods TO lt_methods.

    CLEAR ls_operation.
    ls_operation-activity     = lv_vornr.
    ls_operation-sub_activity = lv_suboper.

    IF im_remove IS INITIAL.
      ls_operation-pers_no = im_matricula.
    ENDIF.

    APPEND ls_operation TO lt_operation.

    CLEAR ls_operation_up.
    ls_operation_up-pers_no = 'X'.
    APPEND ls_operation_up TO lt_operation_up.

* Chama BAPI Associar Matrícula à Operação da Ordem
    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods      = lt_methods
        it_operation    = lt_operation
        it_operation_up = lt_operation_up
        return          = lt_return.

* Verifica retorno
*    READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
    IF sy-subrc NE 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
      ch_erro = 'X'.
    ENDIF.

    APPEND LINES OF lt_return TO re_retorno.

    IF ch_erro IS NOT INITIAL.

      ls_retorno-type = 'E'.

    ELSE.

      ls_retorno-type = 'S'.

    ENDIF.

    ls_retorno-id   = 'OMS'.
*    ls_retorno-message_v3 = |{ text-021 }| & | | & |{ lv_aufnr ALPHA = OUT }|.
*    ls_retorno-message_v4 = |{ text-022 }| & | | & |{ lv_vornr }|.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input         = lv_aufnr
     IMPORTING
       OUTPUT        = lv_aufnr .

    CONCATENATE text-021 lv_aufnr INTO ls_retorno-message_v3 SEPARATED BY space.
    CONCATENATE text-022 lv_vornr INTO ls_retorno-message_v4 SEPARATED BY space.

    APPEND ls_retorno TO re_retorno.

  ENDMETHOD.


  METHOD atualiza_desassociacao.

    DATA: ls_026 TYPE /ptloms/tb026.

    MOVE-CORRESPONDING im_ordem TO ls_026.

    ls_026-data_desassociacao   = sy-datum.
    ls_026-hora_desassociacao   = sy-uzeit.
    ls_026-motivo_desassociacao = '01'.
    ls_026-desassociado         = 'X'.
    ls_026-usuario              = im_ordem-usuario_origem.
    ls_026-data_associacao      = im_ordem-data_associacao.
    ls_026-hora_associacao      = im_ordem-hora_associacao.

    MODIFY /ptloms/tb026 FROM ls_026.

    IF sy-subrc EQ 0.
      MESSAGE s000(su) WITH 'Ordem desassociada com sucesso'(076).
      COMMIT WORK AND WAIT.
    ELSE.
      ch_erro = 'X'.
      MESSAGE s000(su) WITH 'Erro ao desassociar ordem'(077).
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.


  METHOD busca_dados.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Renato Costa
*********************************************************************************************************

    TYPES: BEGIN OF ty_afko,
             aufnr TYPE afko-aufnr,
           END OF ty_afko.

    DATA: it_afko TYPE STANDARD TABLE OF ty_afko.
* Declaração de range
    DATA: r_ordens_associadas_tot  TYPE RANGE OF aufnr,
          ls_ordens_associadas_tot LIKE LINE OF r_ordens_associadas_tot,
          r_auart                  TYPE RANGE OF auart,
          r_werks                  TYPE RANGE OF werks_d,
          r_eqtyp                  TYPE RANGE OF eqtyp,
          r_fltyp                  TYPE RANGE OF fltyp.

* Declaração de tabela interna
    DATA: lt_status TYPE STANDARD TABLE OF jstat.
    DATA: lt_ld_crhd        TYPE STANDARD TABLE OF ld_crhd.

    "downgrade
    DATA gt_despacho_temp TYPE /ptloms/ct079.

* Declaração de variáveis
    DATA: lv_stsma     TYPE jsto-stsma,
          lv_stonr     TYPE tj30-stonr,
          lv_objnr     TYPE jsto-objnr,
          lv_desprezar TYPE char1.

    DATA: lv_number                TYPE bapi_alm_order_header_e-orderid,
          ls_header                TYPE bapi_alm_order_header_e,
          lt_partner               TYPE STANDARD TABLE OF bapi_alm_order_partner,
          lt_operations            TYPE STANDARD TABLE OF bapi_alm_order_operation_e,
          lt_components            TYPE STANDARD TABLE OF bapi_alm_order_component_e,
          lt_text_lines            TYPE STANDARD TABLE OF bapi_alm_text_lines,
          lt_texts                 TYPE STANDARD TABLE OF bapi_alm_text,
          lt_return                TYPE STANDARD TABLE OF bapiret2,
          lt_tb026_parcial         TYPE TABLE OF /ptloms/tb026,
          ls_033                   TYPE /ptloms/tb033,
          ls_textos_ordem          TYPE /ptloms/et037,
          lv_data_referencia_verde TYPE sy-datum,
          lv_data_referencia_verme TYPE sy-datum,
          lv_data_associacao       TYPE sy-datum,
          lv_subrc                 TYPE sy-subrc.
    DATA: ls_ld_crhd           LIKE LINE OF lt_ld_crhd.

* Seleciona as ordens associadas parcialmente
    "  SELECT aufnr, vornr, suboper, usuario, data_associacao, hora_associacao
    "    FROM /ptloms/tb026
    "    INTO TABLE @DATA(lt_tb026_parcial)
    "    WHERE vornr <> @space
    "      AND desassociado = @space.

    SELECT aufnr vornr suboper usuario data_associacao hora_associacao
    FROM /ptloms/tb026
    INTO CORRESPONDING FIELDS OF TABLE lt_tb026_parcial
        WHERE vornr <> space
          AND desassociado = space.

    SORT lt_tb026_parcial BY aufnr vornr suboper.

    SELECT SINGLE * FROM  /ptloms/tb033 INTO ls_033.

    " Filtro de tipo de ordem não preenchida na variante da programação
***    IF s_auart[] IS INITIAL.

***      CALL METHOD /ptloms/cl013=>tipo_ordem_perfil
***        EXPORTING
***          im_usuperfil = s_usuperfil
***        CHANGING
***          ch_subrc     = lv_subrc
***        RECEIVING
***          re_auart     = r_auart.
***
***    ENDIF.
***
***    " Filtro para categoria de equipamento na variante da programação
***    CALL METHOD /ptloms/cl013=>categoria_equip_perfil
***      EXPORTING
***        im_usuperfil = s_usuperfil
***      CHANGING
***        ch_subrc     = lv_subrc
***      RECEIVING
***        re_eqtyp     = r_eqtyp.
***
***    " Filtro para categoria de local de instalação na variante da programação
***    CALL METHOD /ptloms/cl013=>categoria_local_instal_perfil
***      EXPORTING
***        im_usuperfil = s_usuperfil
***      CHANGING
***        ch_subrc     = lv_subrc
***      RECEIVING
***        re_fltyp     = r_fltyp.

* Seleção considerando a visão de Ordem
    IF p_ordens = 'X'.

* Seleciona Ordens
      IF r_ordens_associadas_tot[] IS INITIAL.

        "     SELECT aufnr, auart, qmnum, priok, gewrk,
        "            gstrp, gltrp, idat1, ktext, iwerk,
        "            ingpr, tplnr, equnr, objnr, artpr
        "     FROM viaufks
        "     INTO CORRESPONDING FIELDS OF TABLE @gt_despacho
        "     WHERE aufnr IN @s_aufnr
        "       AND auart IN @s_auart
        "       AND auart IN @r_auart " Tipos de ordem do perfil
        "       AND priok IN @s_priok
        "       AND qmnum IN @s_qmnum
        "       AND tplnr IN @s_tplnr
        "       AND equnr IN @s_equnr
        "       AND iwerk IN @s_iwerk
        "       AND ingpr IN @s_ingpr
        "       AND ilart IN @s_ilart
        "       AND gstrp IN @s_gstrp
        "       AND werks IN @s_werks
        "       AND gewrk IN @r_objid."@s_gewrk.

        SELECT aufnr auart qmnum priok gewrk
       gstrp gltrp idat1 ktext iwerk
       ingpr tplnr equnr objnr artpr ilart
                FROM viaufks
                INTO CORRESPONDING FIELDS OF TABLE gt_despacho
                WHERE aufnr IN s_aufnr
                  AND auart IN s_auart
                  AND auart IN r_auart " Tipos de ordem do perfil
                  AND priok IN s_priok
                  AND qmnum IN s_qmnum
                  AND tplnr IN s_tplnr
                  AND equnr IN s_equnr
                  AND iwerk IN s_iwerk
                  AND ingpr IN s_ingpr
                  AND ilart IN s_ilart
                  AND gstrp IN s_gstrp
                  AND werks IN s_werks
                  AND gewrk IN r_objid. "@s_gewrk

      ELSE.

        IF origem IS INITIAL.

* Seleciona Ordens (Não inclui as ordens já associadas)
          "     SELECT aufnr, auart, qmnum, priok, gewrk,
          "            gstrp, gltrp, idat1, ktext, iwerk,
          "            ingpr, tplnr, equnr, objnr, artpr
          "     FROM viaufks
          "     INTO CORRESPONDING FIELDS OF TABLE @gt_despacho
          "     WHERE aufnr IN @s_aufnr
          "       AND aufnr NOT IN @r_ordens_associadas_tot
          "       AND auart IN @s_auart
          "       AND auart IN @r_auart " Tipos de ordem do perfil
          "       AND priok IN @s_priok
          "       AND qmnum IN @s_qmnum
          "       AND tplnr IN @s_tplnr
          "       AND equnr IN @s_equnr
          "       AND iwerk IN @s_iwerk
          "       AND ingpr IN @s_ingpr
          "       AND ilart IN @s_ilart
          "       AND gstrp IN @s_gstrp
          "       AND werks IN @s_werks
          "       AND gewrk IN @r_objid.

          SELECT aufnr auart qmnum priok gewrk
             gstrp gltrp idat1 ktext iwerk
             ingpr tplnr equnr objnr artpr ilart
        FROM viaufks
        INTO CORRESPONDING FIELDS OF TABLE gt_despacho
        WHERE aufnr IN s_aufnr
          AND NOT aufnr IN r_ordens_associadas_tot
          AND auart IN s_auart
          AND auart IN r_auart " Tipos de ordem do perfil
          AND priok IN s_priok
          AND qmnum IN s_qmnum
          AND tplnr IN s_tplnr
          AND equnr IN s_equnr
          AND iwerk IN s_iwerk
          AND ingpr IN s_ingpr
          AND ilart IN s_ilart
          AND gstrp IN s_gstrp
          AND werks IN s_werks
          AND gewrk IN r_objid.

        ELSE.

* Seleciona Ordens (Não inclui as ordens já associadas)
          "     SELECT aufnr, auart, qmnum, priok, gewrk,
          "            gstrp, gltrp, idat1, ktext, iwerk,
          "            ingpr, tplnr, equnr, objnr, artpr
          "     FROM viaufks
          "     INTO CORRESPONDING FIELDS OF TABLE @gt_despacho
          "     WHERE aufnr IN @s_aufnr
          "       "!AND aufnr IN @r_ordens_associadas_tot
          "       AND auart IN @s_auart
          "       AND auart IN @r_auart " Tipos de ordem do perfiL
          "       AND priok IN @s_priok
          "       AND qmnum IN @s_qmnum
          "       AND tplnr IN @s_tplnr
          "       AND equnr IN @s_equnr
          "       AND iwerk IN @s_iwerk
          "       AND ingpr IN @s_ingpr
          "       AND ilart IN @s_ilart
          "       AND gstrp IN @s_gstrp
          "       AND werks IN @s_werks
          "       AND gewrk IN @r_objid.

          SELECT aufnr auart qmnum priok gewrk
            gstrp gltrp idat1 ktext iwerk
            ingpr tplnr equnr objnr artpr ilart
                     FROM viaufks
                     INTO CORRESPONDING FIELDS OF TABLE gt_despacho
                     WHERE aufnr IN s_aufnr
                       "AND aufnr IN r_ordens_associadas_tot
                       AND auart IN s_auart
                       AND auart IN r_auart " Tipos de ordem do perfiL
                       AND priok IN s_priok
                       AND qmnum IN s_qmnum
                       AND tplnr IN s_tplnr
                       AND equnr IN s_equnr
                       AND iwerk IN s_iwerk
                       AND ingpr IN s_ingpr
                       AND ilart IN s_ilart
                       AND gstrp IN s_gstrp
                       AND werks IN s_werks
                       AND gewrk IN r_objid.

        ENDIF.

      ENDIF.

* Seleção considerando a visão de operação
    ELSEIF p_oper = 'X'.

* Seleciona Ordens
      IF r_ordens_associadas_tot[] IS INITIAL.

        "    SELECT a~aufnr, a~auart, a~qmnum, a~priok, a~gewrk,
        "           a~gstrp, a~gltrp, a~idat1, a~ktext, a~iwerk,
        "           a~ingpr, a~tplnr, a~equnr, c~vornr, a~objnr,
        "           a~abckz, a~warpl, a~ilart,
        "           c~arbid, c~ltxa1, a~artpr, c~aufpl, c~aplzl,
        "           c~sumnr, c~pernr,
        "           d~arbei, d~arbeh, d~ismnw, d~fsavd, d~fsedd
        "    FROM viaufks AS a
        "    INNER JOIN afvc AS c ON a~aufpl = c~aufpl
        "    INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
        "    INTO CORRESPONDING FIELDS OF TABLE @gt_despacho
        "    WHERE a~aufnr IN @s_aufnr
        "      AND c~vornr IN @s_vornr
        "      AND a~auart IN @s_auart
        "      AND a~auart IN @r_auart " Tipos de ordem do perfil
        "      AND a~priok IN @s_priok
        "      AND a~qmnum IN @s_qmnum
        "      AND a~tplnr IN @s_tplnr
        "      AND a~equnr IN @s_equnr
        "      AND a~iwerk IN @s_iwerk
        "      AND a~ingpr IN @s_ingpr
        "      AND a~ilart IN @s_ilart
        "      AND a~gstrp IN @s_gstrp
        "      AND a~werks IN @s_werks " Centro obrigatório
        "      AND a~ernam IN @s_ernam
        "      AND c~arbid IN @r_objid
        "      AND c~phflg EQ @space
        "      AND c~ktsch IN @s_vlsch
        "      AND d~fsavd IN @s_datope
        "      AND a~idat3 = '00000000'        " Data de encerramento
        "      AND a~idat2 = '00000000'        " Data de encerramento técnico
        "      AND a~loekz = ''                " Marcado para eliminação
        "      AND a~getri = '00000000'        " Fim confirmado da ordem
        "      AND a~objnr NOT IN (
        "            " Excluir objetos com status BLOQ
        "            SELECT objnr
        "              FROM jest
        "              WHERE objnr LIKE 'OR%'
        "              AND   stat  = 'I0190'
        "              AND   inact = @space
        "            ).

        SELECT a~aufnr a~auart a~qmnum a~priok a~gewrk
             a~gstrp a~gltrp a~idat1 a~ktext a~iwerk
             a~ingpr a~tplnr a~equnr c~vornr a~objnr
             a~abckz a~warpl a~ilart
             c~arbid c~ltxa1 a~artpr c~aufpl c~aplzl
             c~sumnr c~pernr
             d~arbei d~arbeh d~ismnw d~fsavd d~fsedd
        FROM viaufks AS a
        INNER JOIN afvc AS c ON a~aufpl = c~aufpl
        INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
        INTO CORRESPONDING FIELDS OF TABLE gt_despacho
        WHERE a~aufnr IN s_aufnr
          AND c~vornr IN s_vornr
          AND a~auart IN s_auart
          AND a~auart IN r_auart " Tipos de ordem do perfil
          AND a~priok IN s_priok
          AND a~qmnum IN s_qmnum
          AND a~tplnr IN s_tplnr
          AND a~equnr IN s_equnr
          AND a~iwerk IN s_iwerk
          AND a~ingpr IN s_ingpr
          AND a~ilart IN s_ilart
          AND a~gstrp IN s_gstrp
          AND a~werks IN s_werks " Centro obrigatório
          AND a~ernam IN s_ernam
          AND c~arbid IN r_objid
          AND c~phflg EQ space
          AND c~ktsch IN s_vlsch
          AND d~fsavd IN s_datope
          AND a~idat3 = '00000000'        " Data de encerramento
          AND a~idat2 = '00000000'        " Data de encerramento técnico
          AND a~loekz = ''                " Marcado para eliminação
          AND a~getri = '00000000'        " Fim confirmado da ordem
          AND a~objnr NOT IN (
                " Excluir objetos com status BLOQ
                SELECT objnr
                  FROM jest
                  WHERE objnr LIKE 'OR%'
                  AND stat  = 'I0190'
                  AND inact = space
                ).

      ELSE.

* Seleciona Ordens (Não inclui as ordens já associadas)
        "   SELECT a~aufnr, a~auart, a~qmnum, a~priok, a~gewrk,
        "          a~gstrp, a~gltrp, a~idat1, a~ktext, a~iwerk,
        "          a~ingpr, a~tplnr, a~equnr, c~vornr, a~objnr,
        "          c~arbid, c~ltxa1, a~artpr, a~abckz, a~warpl,
        "          a~ilart,c~aufpl, c~aplzl,  c~sumnr, c~pernr,
        "          d~arbei, d~arbeh, d~ismnw, d~fsavd, d~fsedd
        "   FROM viaufks AS a
        "   INNER JOIN afvc AS c ON a~aufpl = c~aufpl
        "   INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
        "   INTO CORRESPONDING FIELDS OF TABLE @gt_despacho
        "   WHERE a~aufnr IN @s_aufnr
        "     AND c~vornr IN @s_vornr
        "     AND a~aufnr NOT IN @r_ordens_associadas_tot
        "     AND a~auart IN @r_auart " Tipos de ordem do perfil
        "     AND a~auart IN @s_auart
        "     AND a~priok IN @s_priok
        "     AND a~qmnum IN @s_qmnum
        "     AND a~tplnr IN @s_tplnr
        "     AND a~equnr IN @s_equnr
        "     AND a~iwerk IN @s_iwerk
        "     AND a~ingpr IN @s_ingpr
        "     AND a~ilart IN @s_ilart
        "     AND a~gstrp IN @s_gstrp
        "     AND a~werks IN @s_werks " Centro obrigatório
        "     AND a~ernam IN @s_ernam
        "     AND c~arbid IN @r_objid"@s_gewrk
        "     AND c~phflg EQ @space
        "     AND c~ktsch IN @s_vlsch
        "     AND d~fsavd IN @s_datope
        "     AND a~idat3 = '00000000'        " Data de encerramento
        "     AND a~idat2 = '00000000'        " Data de encerramento técnico
        "     AND a~loekz = ''                " Marcado para eliminação
        "     AND a~getri = '00000000'        " Fim confirmado da ordem
        "     AND a~objnr NOT IN (
        "           " Excluir objetos com status BLOQ
        "           SELECT objnr
        "             FROM jest
        "             WHERE objnr LIKE 'OR%'
        "             AND   stat  = 'I0190'
        "             AND   inact = @space
        "           ).

        SELECT a~aufnr a~auart a~qmnum a~priok a~gewrk
            a~gstrp a~gltrp a~idat1 a~ktext a~iwerk
            a~ingpr a~tplnr a~equnr c~vornr a~objnr
            c~arbid c~ltxa1 a~artpr a~abckz a~warpl
            a~ilart c~aufpl c~aplzl c~sumnr c~pernr
            d~arbei d~arbeh d~ismnw d~fsavd d~fsedd
       FROM viaufks AS a
       INNER JOIN afvc AS c ON a~aufpl = c~aufpl
       INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
       INTO CORRESPONDING FIELDS OF TABLE gt_despacho
       WHERE a~aufnr IN s_aufnr
         AND c~vornr IN s_vornr
         AND a~aufnr NOT IN r_ordens_associadas_tot
         AND a~auart IN r_auart " Tipos de ordem do perfil
         AND a~auart IN s_auart
         AND a~priok IN s_priok
         AND a~qmnum IN s_qmnum
         AND a~tplnr IN s_tplnr
         AND a~equnr IN s_equnr
         AND a~iwerk IN s_iwerk
         AND a~ingpr IN s_ingpr
         AND a~ilart IN s_ilart
         AND a~gstrp IN s_gstrp
         AND a~werks IN s_werks " Centro obrigatório
         AND a~ernam IN s_ernam
         AND c~arbid IN r_objid
         AND c~phflg EQ space
         AND c~ktsch IN s_vlsch
         AND d~fsavd IN s_datope
         AND a~idat3 = '00000000'        " Data de encerramento
         AND a~idat2 = '00000000'        " Data de encerramento técnico
         AND a~loekz = ''                " Marcado para eliminação
         AND a~getri = '00000000'        " Fim confirmado da ordem
         AND a~objnr NOT IN (
               " Excluir objetos com status BLOQ
               SELECT objnr
                 FROM jest
                 WHERE objnr LIKE 'OR%'
                 AND stat  = 'I0190'
                 AND inact = space
               ).

      ENDIF.

    ENDIF.

    IF gt_despacho[] IS NOT INITIAL.

      CHECK gt_despacho[] IS NOT INITIAL.

* Backlog - Filtrar categoria de equipamentos e categoria de local de instalação do perfil

***      DATA(gt_ordem_com_equipamento) = gt_despacho.
***      DATA(gt_ordem_sem_equipamento) = gt_despacho.
***
***      SORT gt_ordem_com_equipamento BY equnr.
***      " Ordens com equipamento
***      DELETE gt_ordem_com_equipamento WHERE equnr = ''.
***      IF gt_ordem_com_equipamento IS NOT INITIAL.
***        " Buscar a categoria do equipamento
***        SELECT equnr, eqtyp
***          FROM equi
***          INTO TABLE @DATA(it_equi)
***          FOR ALL ENTRIES IN @gt_ordem_com_equipamento
***          WHERE equnr = @gt_ordem_com_equipamento-equnr.
***        SORT it_equi BY equnr.
***        SORT gt_ordem_com_equipamento BY equnr.
***      ENDIF.
***
***      " Ordens sem equipamento
***      DELETE gt_ordem_sem_equipamento WHERE equnr <> ''.
***      IF gt_ordem_sem_equipamento IS NOT INITIAL.
***        SELECT tplnr, fltyp
***          FROM iflo
***          INTO TABLE @DATA(it_iflo)
***          FOR ALL ENTRIES IN @gt_ordem_sem_equipamento
***          WHERE tplnr = @gt_ordem_sem_equipamento-tplnr.
***        SORT it_iflo BY tplnr.
***        SORT gt_ordem_sem_equipamento BY tplnr.
***      ENDIF.
***
***      LOOP AT gt_despacho ASSIGNING FIELD-SYMBOL(<fs_despacho>).
***
***        DATA(tabix) = sy-tabix.
***
***        " Se a ordem possui equipamento
***        READ TABLE it_equi ASSIGNING FIELD-SYMBOL(<fs_equi>) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
***
***        IF sy-subrc IS INITIAL.
***          " Filtrar se a categoria de equipamento está no perfil do usuário.
***          IF <fs_equi>-eqtyp NOT IN r_eqtyp[].
***
***            DELETE gt_despacho INDEX tabix.
***
***          ENDIF.
***
***        ELSE.
***          " Se a ordem não possui equipamento
***          READ TABLE it_iflo ASSIGNING FIELD-SYMBOL(<fs_iflo>) WITH KEY tplnr = <fs_despacho>-tplnr BINARY SEARCH.
***
***          IF sy-subrc IS INITIAL.
***            " Filtrar se a categoria de local de instalação está no perfil do usuário
***            IF <fs_iflo>-fltyp NOT IN r_fltyp[].
***
***              DELETE gt_despacho INDEX tabix.
***
***            ENDIF.
***
***          ENDIF.
***
***        ENDIF.
***
***      ENDLOOP.
* Backlog - Filtrar categoria de equipamentos e categoria de local de instalação do perfil

      "DATA(gt_despacho_temp) = gt_despacho.
      gt_despacho_temp = gt_despacho.

      SORT gt_despacho_temp BY aufnr.
      DELETE ADJACENT DUPLICATES FROM gt_despacho_temp COMPARING aufnr.

* Seleciona Ordens associadas
      "  SELECT aufnr, vornr, usuario, data_associacao, hora_associacao, desassociado
      "    FROM /ptloms/tb026
      "    INTO TABLE @DATA(lt_tb026_associada)
      "    FOR ALL ENTRIES IN @gt_despacho_temp
      "    WHERE aufnr = @gt_despacho_temp-aufnr.

      DATA lt_tb026_associada TYPE TABLE OF /ptloms/tb026.

      SELECT aufnr vornr usuario data_associacao hora_associacao desassociado
         FROM /ptloms/tb026
         INTO CORRESPONDING FIELDS OF TABLE lt_tb026_associada
         FOR ALL ENTRIES IN gt_despacho_temp
         WHERE aufnr = gt_despacho_temp-aufnr.


      SORT lt_tb026_associada BY aufnr vornr data_associacao DESCENDING hora_associacao DESCENDING.

* Seleciona descrição dos Locais de Instalação
      "   SELECT tplnr, pltxt
      "     FROM iflotx
      "     INTO TABLE @DATA(lt_iflotx)
      "     FOR ALL ENTRIES IN @gt_despacho
      "     WHERE spras = @sy-langu
      "       AND tplnr = @gt_despacho-tplnr.
      DATA lt_iflotx TYPE TABLE OF iflotx.

      SELECT tplnr pltxt
           FROM iflotx
           INTO CORRESPONDING FIELDS OF TABLE lt_iflotx
           FOR ALL ENTRIES IN gt_despacho
           WHERE spras = sy-langu
             AND tplnr = gt_despacho-tplnr.

      SORT lt_iflotx BY tplnr.

* Seleciona descrição dos equipamentos
      " SELECT DISTINCT ( equnr ), eqktx, stort, eqfnr, anlnr, anlun
      "   FROM v_equi
      "   INTO TABLE @DATA(lt_v_equi)
      "   FOR ALL ENTRIES IN @gt_despacho
      "   WHERE txasp = 'X'
      "     AND owner = @space
      "     AND spras = @sy-langu
      "     AND equnr = @gt_despacho-equnr
      "     AND datab <= @sy-datum
      "     AND datbi >= @sy-datum.

      DATA lt_v_equi TYPE TABLE OF v_equi.

      SELECT DISTINCT equnr eqktx stort eqfnr anlnr anlun
         FROM v_equi
         INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
         FOR ALL ENTRIES IN gt_despacho
         WHERE txasp = 'X'
           AND owner = space
           AND spras = sy-langu
           AND equnr = gt_despacho-equnr
           AND datab <= sy-datum
           AND datbi >= sy-datum.

      SORT lt_v_equi BY equnr.

* Busca descrição do centro de trabalho
      IF p_ordens = 'X'.
        "    SELECT objty, objid, arbpl
        "      FROM crhd
        "      INTO TABLE @DATA(lt_crhd)
        "      FOR ALL ENTRIES IN @gt_despacho
        "      WHERE objid = @gt_despacho-gewrk.
        "  ELSEIF p_oper = 'X'.
        "    SELECT objty, objid, arbpl
        "      FROM crhd
        "      INTO TABLE @lt_crhd
        "      FOR ALL ENTRIES IN @gt_despacho
        "      WHERE objid = @gt_despacho-arbid.

        DATA lt_crhd TYPE TABLE OF crhd.

        SELECT objty objid arbpl
            FROM crhd
            INTO CORRESPONDING FIELDS OF TABLE lt_crhd
            FOR ALL ENTRIES IN gt_despacho
            WHERE objid = gt_despacho-gewrk.

      ELSEIF p_oper = 'X'.

        SELECT objty objid arbpl
          FROM crhd
          INTO CORRESPONDING FIELDS OF TABLE lt_crhd
          FOR ALL ENTRIES IN gt_despacho
          WHERE objid = gt_despacho-arbid.

      ENDIF.

      SORT lt_crhd BY objid.

* Busca descrição da prioridade
      "  SELECT spras, artpr, priok, priokx
      "    FROM t356_t
      "    INTO TABLE @DATA(lt_t356_t)
      "    FOR ALL ENTRIES IN @gt_despacho
      "    WHERE spras  = @sy-langu
      "      AND artpr  = @gt_despacho-artpr
      "      AND priok = @gt_despacho-priok.

      DATA lt_t356_t TYPE TABLE OF t356_t.

      SELECT spras artpr priok priokx
          FROM t356_t
          INTO CORRESPONDING FIELDS OF TABLE lt_t356_t
          FOR ALL ENTRIES IN gt_despacho
          WHERE spras  = sy-langu
            AND artpr  = gt_despacho-artpr
            AND priok = gt_despacho-priok.

      SORT lt_t356_t BY artpr priok.

* Busca descrição grupo de planejamento
      " SELECT iwerk, ingrp, innam
      "    FROM t024i
      "    INTO TABLE @DATA(lt_t024i)
      "    FOR ALL ENTRIES IN @gt_despacho
      "    WHERE iwerk = @gt_despacho-iwerk
      "      AND ingrp = @gt_despacho-ingpr.

      DATA lt_t024i TYPE TABLE OF t024i.

      SELECT iwerk ingrp innam
         FROM t024i
         INTO CORRESPONDING FIELDS OF TABLE lt_t024i
         FOR ALL ENTRIES IN gt_despacho
         WHERE iwerk = gt_despacho-iwerk
           AND ingrp = gt_despacho-ingpr.

      SORT lt_t024i BY iwerk ingrp.

* Busca SubOperações
      IF p_oper = 'X'.
        "    SELECT a~aufpl, a~aplzl, a~vornr, a~sumnr, a~objnr
        "      FROM afvc AS a
        "      INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
        "      INTO TABLE @DATA(lt_sub_operacoes)
        "      FOR ALL ENTRIES IN @gt_despacho
        "      WHERE a~aufpl = @gt_despacho-aufpl
        "        AND a~aplzl = @gt_despacho-aplzl
        "        AND a~phflg = @space
        "        AND b~fsavd IN @s_datope.

        DATA lt_sub_operacoes TYPE /ptloms/ct079.

        SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
            FROM afvc AS a
            INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
            INTO CORRESPONDING FIELDS OF TABLE lt_sub_operacoes
            FOR ALL ENTRIES IN gt_despacho
            WHERE a~aufpl = gt_despacho-aufpl
              AND a~aplzl = gt_despacho-aplzl
              AND a~phflg = space
                AND b~fsavd IN s_datope.

        SORT lt_sub_operacoes BY aufpl aplzl.

      ENDIF.

* Descrição código abc
      "   SELECT abckz, abctx
      "     FROM t370c_t
      "     INTO TABLE @DATA(lt_t370c_t)
      "     WHERE spras = @sy-langu.

      DATA lt_t370c_t TYPE TABLE OF t370c_t.

      SELECT abckz abctx
         FROM t370c_t
         INTO CORRESPONDING FIELDS OF TABLE lt_t370c_t
       	  WHERE spras = sy-langu.

      SORT lt_t370c_t BY abckz.

* Descrição plano de manutenção
      "   SELECT warpl, wptxt
      "     FROM mpla
      "     INTO TABLE @DATA(lt_mpla)
      "     FOR ALL ENTRIES IN @gt_despacho
      "     WHERE warpl = @gt_despacho-warpl.

      DATA lt_mpla TYPE TABLE OF mpla.

      SELECT warpl wptxt
          FROM mpla
          INTO CORRESPONDING FIELDS OF TABLE lt_mpla
          FOR ALL ENTRIES IN gt_despacho
          WHERE warpl = gt_despacho-warpl.

      SORT lt_mpla BY warpl.

* Descrição do tipo de atividade de manutenção
      "  SELECT ilart, ilatx
      "    FROM t353i_t
      "    INTO TABLE @DATA(lt_t353i_t)
      "    WHERE spras = @sy-langu.

      DATA lt_t353i_t TYPE TABLE OF t353i_t.

      SELECT ilart ilatx
         FROM t353i_t
         INTO CORRESPONDING FIELDS OF TABLE lt_t353i_t
        WHERE spras = sy-langu.

      SORT lt_t353i_t BY ilart.

* Busca configurações dos semáforos
      "   SELECT *
      "     FROM /ptloms/tb034
      "     INTO TABLE @DATA(lt_034).

      DATA lt_034 TYPE TABLE OF /ptloms/tb034.

      SELECT *
       FROM /ptloms/tb034
       INTO CORRESPONDING FIELDS OF TABLE lt_034.

      SORT lt_034 BY auart priok.

      "   SELECT equnr, tidnr
      "     FROM equz
      "     INTO TABLE @DATA(lt_equz)
      "     FOR ALL ENTRIES IN @gt_despacho
      "     WHERE equnr = @gt_despacho-equnr AND
      "           datbi = '99991231'.

      DATA lt_equz TYPE TABLE OF equz.

      SELECT equnr tidnr
         FROM equz
          INTO CORRESPONDING FIELDS OF TABLE lt_equz
          FOR ALL ENTRIES IN gt_despacho
          WHERE equnr = gt_despacho-equnr AND
          datbi = '99991231'.

      SORT lt_equz BY equnr.

*      SELECT usuario, matricula
*        FROM /ptloms/tb013
*        INTO TABLE @DATA(lt_tb013).

      DATA lt_tb013 TYPE TABLE OF /ptloms/tb013.

      SELECT usuario matricula
         FROM /ptloms/tb013
         INTO CORRESPONDING FIELDS OF TABLE lt_tb013.

      SORT lt_tb013 BY usuario.

      " Nome da matrícula
      "DATA(gt_despacho_aux) = gt_despacho.
      DATA gt_despacho_aux TYPE /ptloms/ct079.
      gt_despacho_aux = gt_despacho.
      SORT gt_despacho_aux BY pernr.
      DELETE gt_despacho_aux WHERE pernr IS INITIAL.
      DELETE ADJACENT DUPLICATES FROM gt_despacho_aux COMPARING pernr.

      "   SELECT pernr, sname
      "     FROM pa0001
      "     INTO TABLE @DATA(it_pa0001)
      "     FOR ALL ENTRIES IN @gt_despacho
      "     WHERE pernr = @gt_despacho-pernr.

      DATA it_pa0001 TYPE TABLE OF pa0001.

      SELECT pernr sname
        FROM pa0001
        INTO CORRESPONDING FIELDS OF TABLE it_pa0001
        FOR ALL ENTRIES IN gt_despacho
        WHERE pernr = gt_despacho-pernr.

      SORT it_pa0001 BY pernr.

      " Descrição do centro de planejamento
      "  SELECT a~iwerk, b~name1
      "    FROM t399i AS a INNER JOIN t001w AS b
      "    ON a~iwerk = b~werks
      "    INTO TABLE @DATA(it_centro_planejamento)
      "    WHERE a~iwerk IN @s_iwerk.

      DATA it_centro_planejamento TYPE TABLE OF t001w.

      SELECT a~iwerk b~name1
        FROM t399i AS a
        INNER JOIN t001w AS b
        ON a~iwerk = b~werks
        INTO CORRESPONDING FIELDS OF TABLE it_centro_planejamento
        WHERE a~iwerk IN s_iwerk.

      SORT it_centro_planejamento BY iwerk.

      "it_afko = CORRESPONDING #( gt_despacho MAPPING aufnr = aufnr ).

      DATA:
            ls_afko LIKE LINE OF it_afko.

      DATA: ls_despacho TYPE /ptloms/et078.

      LOOP AT gt_despacho INTO ls_despacho.
        ls_afko-aufnr = ls_despacho-aufnr.
        APPEND ls_afko TO it_afko.
      ENDLOOP.

      SORT it_afko BY aufnr.
      DELETE ADJACENT DUPLICATES FROM it_afko COMPARING aufnr.

      " Nota da ordem
      "   SELECT aufnr, qmnum
      "     FROM afih
      "     INTO TABLE @DATA(it_afih)
      "     FOR ALL ENTRIES IN @it_afko
      "     WHERE aufnr = @it_afko-aufnr.

      DATA it_afih TYPE TABLE OF afih.

      SELECT aufnr qmnum
       FROM afih
       INTO CORRESPONDING FIELDS OF TABLE it_afih
       FOR ALL ENTRIES IN it_afko
       WHERE aufnr = it_afko-aufnr.

      IF sy-subrc IS INITIAL.

        SORT it_afih BY aufnr.

        " Texto da nota
        " SELECT qmnum, qmtxt
        "   FROM qmel
        "   APPENDING TABLE @DATA(it_qmel)
        "   FOR ALL ENTRIES IN @it_afih
        "   WHERE aufnr = @it_afih-aufnr.

        DATA it_qmel TYPE TABLE OF qmel.

        SELECT qmnum qmtxt
          FROM qmel
          APPENDING CORRESPONDING FIELDS OF TABLE it_qmel
          FOR ALL ENTRIES IN it_afih
          WHERE aufnr = it_afih-aufnr.

        SORT it_qmel BY qmnum.
        DELETE ADJACENT DUPLICATES FROM it_qmel COMPARING qmnum.

      ENDIF.

      me->busca_endereco_cliente( EXPORTING it_despacho = gt_despacho IMPORTING it_despacho_out = gt_despacho ).

      FIELD-SYMBOLS: <fs_despacho> TYPE /ptloms/et078.
      "LOOP AT gt_despacho ASSIGNING FIELD-SYMBOL(<fs_despacho>).
      LOOP AT gt_despacho ASSIGNING <fs_despacho>.

        "DATA(lv_tabix) = sy-tabix.
        DATA lv_tabix TYPE sy-tabix.
        lv_tabix = sy-tabix.

        "DATA(ls_despacho) = <fs_despacho>.

        " Status da ordem
        CALL FUNCTION 'STATUS_TEXT_EDIT'
          EXPORTING
            objnr            = <fs_despacho>-objnr
            spras            = sy-langu
          IMPORTING
            e_stsma          = lv_stsma
            line             = <fs_despacho>-status_sis
            user_line        = <fs_despacho>-status_usu
            stonr            = lv_stonr
          EXCEPTIONS
            object_not_found = 1
            OTHERS           = 2.

        "IF <fs_despacho>-status_sis CS 'ABER'.
        IF <fs_despacho>-status_sis CS 'ABER' OR <fs_despacho>-status_sis CS 'ABIE'.

          <fs_despacho>-codigo_associacao_ordem    = '00'.
          <fs_despacho>-descricao_associacao_ordem = 'Aguardando liberação'(001).

        ELSE.

          " Buscar a associação mais recente - 28/02/2023 - Início
*          READ TABLE lt_tb026_associada INTO DATA(ls_tb026_associada) WITH KEY aufnr = <fs_despacho>-aufnr
*                                                                               vornr = <fs_despacho>-vornr
*                                                                        desassociado = ''.

          DATA ls_tb026_associada LIKE LINE OF lt_tb026_associada.

          READ TABLE lt_tb026_associada INTO ls_tb026_associada WITH KEY aufnr = <fs_despacho>-aufnr
                                                                         vornr = <fs_despacho>-vornr
                                                                         desassociado = ''.

          " Buscar a associação mais recente - 28/02/2023 - Fim
          IF sy-subrc EQ 0.
            <fs_despacho>-data_associacao = ls_tb026_associada-data_associacao.
            <fs_despacho>-hora_associacao = ls_tb026_associada-hora_associacao.
            IF ls_tb026_associada-desassociado IS INITIAL.
              <fs_despacho>-usuarioapp = ls_tb026_associada-usuario.                           " Usuário associado
              "READ TABLE lt_tb013 INTO DATA(ls_tb013) WITH KEY usuario = ls_tb026_associada-usuario BINARY SEARCH.
              DATA ls_tb013 LIKE LINE OF lt_tb013.
              READ TABLE lt_tb013 INTO ls_tb013 WITH KEY usuario = ls_tb026_associada-usuario BINARY SEARCH.

              IF sy-subrc IS INITIAL.
                <fs_despacho>-matricula = ls_tb013-matricula.                                  " Matrícula do usuário
              ENDIF.
            ENDIF.

            CONVERT DATE <fs_despacho>-data_associacao TIME <fs_despacho>-hora_associacao INTO TIME STAMP <fs_despacho>-data_hora_associacao TIME ZONE sy-zonlo.

            lv_data_associacao = <fs_despacho>-data_associacao.

            WRITE: lv_data_associacao USING EDIT MASK '__/__/____' TO <fs_despacho>-data_associacao.

            WRITE: lv_data_associacao USING EDIT MASK '__/__/____' TO <fs_despacho>-data_associacao_str.

            IF ls_033-cesto IS INITIAL.

              IF ( <fs_despacho>-pernr <> ls_tb013-matricula ) OR ( ls_tb026_associada-usuario IS NOT INITIAL AND <fs_despacho>-pernr IS INITIAL ).

                <fs_despacho>-codigo_associacao_ordem    = '01'.
                <fs_despacho>-descricao_associacao_ordem = 'Erro associação'(002).

              ELSE.

                " Status de Completamente associada
                IF ( <fs_despacho>-pernr = ls_tb013-matricula ).

                  <fs_despacho>-codigo_associacao_ordem    = '03'.
                  <fs_despacho>-descricao_associacao_ordem = 'Associada'(003).

                ENDIF.

              ENDIF.

            ELSE.

              <fs_despacho>-codigo_associacao_ordem    = '03'.
              <fs_despacho>-descricao_associacao_ordem = 'Associada'(003).

            ENDIF.

          ELSE.

            IF s_usuapp[] IS NOT INITIAL.
              DELETE gt_despacho INDEX lv_tabix.
              CONTINUE.
            ENDIF.

            <fs_despacho>-codigo_associacao_ordem    = '02'.
            <fs_despacho>-descricao_associacao_ordem = 'Disponível para associação'(004).

          ENDIF.

        ENDIF.

        IF  sy-tcode                    EQ '/PTLOMS/PTLOMSN004'.
          IF  <fs_despacho>-arbeh       EQ 'MIN'.
            <fs_despacho>-arbei          = <fs_despacho>-arbei / 60 .
            <fs_despacho>-ismnw          = <fs_despacho>-ismnw / 60 .
          ENDIF.
        ENDIF.

        " Filtro para usuário APP
        IF s_usuapp[] IS NOT INITIAL.
          IF ls_tb026_associada-usuario NOT IN s_usuapp[].
            DELETE gt_despacho INDEX lv_tabix.
            CONTINUE.
          ENDIF.
        ENDIF.

        "READ TABLE it_pa0001 INTO DATA(ls_pa0001) WITH KEY pernr = <fs_despacho>-pernr BINARY SEARCH.
        DATA ls_pa0001 LIKE LINE OF it_pa0001.
        READ TABLE it_pa0001 INTO ls_pa0001 WITH KEY pernr = <fs_despacho>-pernr BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          <fs_despacho>-sname = ls_pa0001-sname.

        ENDIF.

        "READ TABLE lt_iflotx INTO DATA(ls_iflotx) WITH KEY tplnr = <fs_despacho>-tplnr BINARY SEARCH.
        DATA ls_iflotx LIKE LINE OF lt_iflotx.

        READ TABLE lt_iflotx INTO ls_iflotx WITH KEY tplnr = <fs_despacho>-tplnr BINARY SEARCH.

        IF sy-subrc EQ 0.
          <fs_despacho>-pltxt = ls_iflotx-pltxt.
        ENDIF.

        "READ TABLE lt_v_equi INTO DATA(ls_v_equi) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
        DATA ls_v_equi LIKE LINE OF lt_v_equi.

        READ TABLE lt_v_equi INTO ls_v_equi WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.

        IF sy-subrc EQ 0.
          <fs_despacho>-eqktx = ls_v_equi-eqktx.
          <fs_despacho>-stort = ls_v_equi-stort.
          <fs_despacho>-eqfnr = ls_v_equi-eqfnr.
*          <fs_despacho>-anlnr = |{ ls_v_equi-anlnr ALPHA = OUT }|.
*          <fs_despacho>-anlun = |{ ls_v_equi-anlun ALPHA = OUT }|.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_v_equi-anlnr
            IMPORTING
              output = <fs_despacho>-anlnr.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_v_equi-anlun
            IMPORTING
              output = <fs_despacho>-anlun.

        ENDIF.

**Seleciona descrição do campo localização
*        SELECT stand, ktext
*            FROM t499s
*            INTO TABLE @DATA(lt_t499s)
*            FOR ALL ENTRIES IN @gt_despacho
*            WHERE stand = @gt_despacho-stort.
*
**Seleciona a descrição do campo localização
*        READ TABLE lt_t499s INTO DATA(ls_t499s) WITH KEY stand = <fs_despacho>-stort BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          <fs_despacho>-stortdesc = ls_t499s-ktext.
*        ENDIF.

        <fs_despacho>-ktext = <fs_despacho>-ktext.

        IF p_oper = 'X'.
          <fs_despacho>-ltxa1 = <fs_despacho>-ltxa1.
          <fs_despacho>-gewrk = <fs_despacho>-arbid.
        ENDIF.

        "READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = <fs_despacho>-gewrk BINARY SEARCH.}
        DATA ls_crhd LIKE LINE OF lt_crhd.

        READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = <fs_despacho>-gewrk BINARY SEARCH.
        IF sy-subrc = 0.
          <fs_despacho>-arbpl = ls_crhd-arbpl.
        ENDIF.

*        READ TABLE lt_t356_t INTO DATA(ls_t356_t) WITH KEY artpr = <fs_despacho>-artpr
*                                                           priok = <fs_despacho>-priok BINARY SEARCH.
        DATA ls_t356_t LIKE LINE OF lt_t356_t.

        READ TABLE lt_t356_t INTO ls_t356_t WITH KEY artpr = <fs_despacho>-artpr
                                                     priok = <fs_despacho>-priok BINARY SEARCH.
        IF sy-subrc EQ 0.
          <fs_despacho>-priokx = ls_t356_t-priokx.
        ENDIF.

*        READ TABLE lt_t024i INTO DATA(ls_t024i) WITH KEY iwerk = <fs_despacho>-iwerk
*                                                         ingrp = <fs_despacho>-ingpr BINARY SEARCH.
        DATA ls_t024i LIKE LINE OF lt_t024i.

        READ TABLE lt_t024i INTO ls_t024i WITH KEY iwerk = <fs_despacho>-iwerk
                                                         ingrp = <fs_despacho>-ingpr BINARY SEARCH.
        IF sy-subrc EQ 0.
          <fs_despacho>-innam = ls_t024i-innam.
        ENDIF.

        IF p_oper = 'X'.
          IF <fs_despacho>-sumnr IS NOT INITIAL.
*            READ TABLE lt_sub_operacoes INTO DATA(ls_sub_operacoes) WITH KEY aufpl = <fs_despacho>-aufpl
*                                                                             aplzl = <fs_despacho>-sumnr BINARY SEARCH.
            DATA ls_sub_operacoes LIKE LINE OF lt_sub_operacoes.

            READ TABLE lt_sub_operacoes INTO ls_sub_operacoes WITH KEY aufpl = <fs_despacho>-aufpl
                                                                             aplzl = <fs_despacho>-sumnr BINARY SEARCH.

            IF sy-subrc EQ 0.
              <fs_despacho>-suboper = <fs_despacho>-vornr.
              <fs_despacho>-vornr   = ls_sub_operacoes-vornr.
            ENDIF.
          ENDIF.

          READ TABLE lt_sub_operacoes INTO ls_sub_operacoes WITH KEY aufpl = <fs_despacho>-aufpl
                                                                     aplzl = <fs_despacho>-aplzl BINARY SEARCH.
          IF sy-subrc EQ 0.
            <fs_despacho>-objnr_oper_sub = ls_sub_operacoes-objnr.
          ENDIF.
        ENDIF.

        CLEAR lv_objnr.

        IF p_ordens = 'X'.
          lv_objnr = <fs_despacho>-objnr.
        ELSEIF p_oper = 'X'.
          lv_objnr = <fs_despacho>-objnr_oper_sub.
        ENDIF.

        " Substituído pelos filtros de seleção da visão VI_AUFKS
*        CLEAR lv_desprezar.
*        CALL FUNCTION '/PTLOMS/MF008'
*          EXPORTING
*            im_objnr     = lv_objnr
*          IMPORTING
*            ex_desprezar = lv_desprezar.
*
*        IF lv_desprezar = 'X'.
*          DELETE gt_despacho INDEX lv_tabix.
*          CONTINUE.
*        ENDIF.

        " Descrição código ABC
*        READ TABLE lt_t370c_t INTO DATA(ls_t370c_t) WITH KEY abckz = <fs_despacho>-abckz BINARY SEARCH.
        DATA ls_t370c_t LIKE LINE OF lt_t370c_t.
        READ TABLE lt_t370c_t INTO ls_t370c_t WITH KEY abckz = <fs_despacho>-abckz BINARY SEARCH.

        IF sy-subrc IS INITIAL.
          <fs_despacho>-abctx = ls_t370c_t-abctx.
        ENDIF.

        " Descrição plano de manutenção
*        READ TABLE lt_mpla INTO DATA(ls_mpla) WITH KEY warpl = <fs_despacho>-warpl BINARY SEARCH.
        DATA ls_mpla LIKE LINE OF lt_mpla.
        READ TABLE lt_mpla INTO ls_mpla WITH KEY warpl = <fs_despacho>-warpl BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <fs_despacho>-wptxt = ls_mpla-wptxt.
        ENDIF.

        " Descrição do tipo de atividade de manutenção
*        READ TABLE lt_t353i_t INTO DATA(ls_t353i_t) WITH KEY ilart = <fs_despacho>-ilart BINARY SEARCH.
        DATA ls_t353i_t LIKE LINE OF lt_t353i_t.
        READ TABLE lt_t353i_t INTO ls_t353i_t WITH KEY ilart = <fs_despacho>-ilart BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <fs_despacho>-ilatx = ls_t353i_t-ilatx.
        ENDIF.

        " Identidade técnica
*        READ TABLE lt_equz INTO DATA(ls_equz) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
        DATA ls_equz LIKE LINE OF lt_equz.
        READ TABLE lt_equz INTO ls_equz WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          <fs_despacho>-tidnr = ls_equz-tidnr.
        ENDIF.

        "<fs_despacho>-equnr = |{ <fs_despacho>-equnr ALPHA = OUT }|.

*        IF  <fs_despacho>-equnr   CO '0123456789'.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_despacho>-equnr
            IMPORTING
              output = <fs_despacho>-equnr.
*        ENDIF.

*
        IF s_aufnr[] IS NOT INITIAL OR origem = 'APP'.

* Textos das operações

          CLEAR: lv_number, ls_header.
          REFRESH: lt_partner[], lt_operations[], lt_components[],
                   lt_text_lines[], lt_return[], lt_texts[], lt_operations[].

          CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
            EXPORTING
              number        = <fs_despacho>-aufnr
            IMPORTING
              es_header     = ls_header
            TABLES
              et_partner    = lt_partner
              et_operations = lt_operations
              et_components = lt_components
              et_texts      = lt_texts
              et_text_lines = lt_text_lines
              return        = lt_return.

          <fs_despacho>-qtd_operacoes = lines( lt_operations ).

*          READ TABLE lt_texts INTO DATA(ls_texts) WITH KEY activity = space.
          DATA ls_texts      LIKE LINE OF lt_texts.
          DATA ls_text_lines LIKE LINE OF lt_text_lines.

          READ TABLE lt_texts INTO ls_texts WITH KEY activity = space.
          LOOP AT lt_text_lines INTO ls_text_lines.

            lv_tabix = sy-tabix.

            " Texto breve e longo da ordem
            IF ls_text_lines-tdline IS NOT INITIAL.
              IF sy-tabix = 1.
                <fs_despacho>-texto_breve_ordem = ls_text_lines-tdline.
              ELSE.
                IF lv_tabix <= ls_texts-textend.
                  IF ls_textos_ordem-tdformat = '*' OR ls_textos_ordem-tdformat IS INITIAL.
***                 DATA(lv_tdformat) = cl_abap_char_utilities=>newline.
                    DATA: lv_tdformat TYPE abap_char1.
                    lv_tdformat = cl_abap_char_utilities=>newline.

                  ENDIF.
                  IF <fs_despacho>-texto_longo_ordem IS NOT INITIAL.
                    <fs_despacho>-texto_longo_ordem = <fs_despacho>-texto_longo_ordem && | | && lv_tdformat && ls_text_lines-tdline.
                  ELSE.
                    <fs_despacho>-texto_longo_ordem = ls_text_lines-tdline.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
            " Texto breve e longo da ordem

            IF lv_tabix > ls_texts-textend.
              EXIT.
            ENDIF.
            CLEAR ls_textos_ordem.
            MOVE-CORRESPONDING ls_text_lines TO ls_textos_ordem.
            ls_textos_ordem-orderid  = <fs_despacho>-aufnr.
            ls_textos_ordem-activity = <fs_despacho>-vornr.

            IF ls_textos_ordem-tdformat = '*' OR ls_textos_ordem-tdformat IS INITIAL.
              lv_tdformat = cl_abap_char_utilities=>newline.
            ELSE.
            ENDIF.

            IF <fs_despacho>-texto_longo_operacao IS NOT INITIAL.
              <fs_despacho>-texto_longo_operacao = <fs_despacho>-texto_longo_operacao && | | && lv_tdformat && ls_textos_ordem-tdline.
            ELSE.
              <fs_despacho>-texto_longo_operacao = ls_textos_ordem-tdline.
            ENDIF.
          ENDLOOP.

          IF sy-subrc IS NOT INITIAL.
            <fs_despacho>-texto_breve_ordem = ls_header-short_text.
          ENDIF.

          " Item do plano de manutenção
*          <fs_despacho>-maintitem = |{ ls_header-maintitem ALPHA = OUT }|.
*          <fs_despacho>-warpl     = |{ <fs_despacho>-warpl ALPHA = OUT }|.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_header-maintitem
            IMPORTING
              output = <fs_despacho>-maintitem.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_despacho>-warpl
            IMPORTING
              output = <fs_despacho>-warpl.

        ENDIF.

        " Texto da nota
*        READ TABLE it_afih ASSIGNING FIELD-SYMBOL(<fs_afih>) WITH KEY aufnr = <fs_despacho>-aufnr BINARY SEARCH.
        FIELD-SYMBOLS: <fs_afih> TYPE afih.
        READ TABLE it_afih ASSIGNING <fs_afih> WITH KEY aufnr = <fs_despacho>-aufnr BINARY SEARCH.

        IF sy-subrc IS INITIAL.
          " Nota
*          READ TABLE it_qmel ASSIGNING FIELD-SYMBOL(<fs_qmel>) WITH KEY qmnum = <fs_afih>-qmnum BINARY SEARCH.
          FIELD-SYMBOLS: <fs_qmel> TYPE qmel.
          READ TABLE it_qmel ASSIGNING <fs_qmel> WITH KEY qmnum = <fs_afih>-qmnum BINARY SEARCH.

          IF sy-subrc IS INITIAL.

            <fs_despacho>-qmtxt = <fs_qmel>-qmtxt.

          ENDIF.

        ENDIF.

        "Centro de trabalho
        SELECT *
          FROM  ld_crhd
          INTO CORRESPONDING FIELDS OF TABLE lt_ld_crhd
          WHERE  spras  = sy-langu
          AND    arbpl  = ls_header-mn_wk_ctr
          AND    werks  = ls_header-plant.

        READ TABLE lt_ld_crhd INTO ls_ld_crhd INDEX 1.

        IF sy-subrc IS INITIAL.
          <fs_despacho>-mn_wkctr_descricao = ls_ld_crhd-ktext.
          <fs_despacho>-mn_wkctr_plant = ls_ld_crhd-werks.
        ENDIF.

        " Carrega Semáforo
*        READ TABLE lt_034 INTO DATA(ls_034) WITH KEY auart = <fs_despacho>-auart priok = <fs_despacho>-priok BINARY SEARCH.
        DATA ls_034 LIKE LINE OF lt_034.
        READ TABLE lt_034 INTO ls_034 WITH KEY auart = <fs_despacho>-auart priok = <fs_despacho>-priok BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF ls_034-urgente = 'X'.
            " Vermelho
            <fs_despacho>-semaforo_cor       = 'Error'.
            <fs_despacho>-semaforo_descricao = 'Alerta Vermelho'(025).
          ELSE.

            IF ls_034-verde IS INITIAL AND ls_034-vermelho IS INITIAL AND ls_034-amarelo IS INITIAL.
              <fs_despacho>-semaforo_cor = 'None'.
              <fs_despacho>-semaforo_descricao = 'Sem Alerta'(026).
            ELSE.
              lv_data_referencia_verde = <fs_despacho>-gstrp.
              lv_data_referencia_verde = lv_data_referencia_verde + ls_034-verde.
*
              lv_data_referencia_verme = <fs_despacho>-gstrp.
              lv_data_referencia_verme = lv_data_referencia_verme + ls_034-vermelho.
              " Verde
              IF sy-datum <= lv_data_referencia_verde.
                <fs_despacho>-semaforo_cor   = 'Success'.
                <fs_despacho>-semaforo_descricao = 'Alerta Verde'(028).
                " Vermelho
              ELSEIF sy-datum >= lv_data_referencia_verme.
                <fs_despacho>-semaforo_cor   = 'Error'.
                <fs_despacho>-semaforo_descricao = 'Alerta Vermelho'(025).
                " Amarelo
              ELSE.
                <fs_despacho>-semaforo_cor   = 'Warning'.
                <fs_despacho>-semaforo_descricao = 'Alerta Amarelo'(027).
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.
          <fs_despacho>-semaforo_cor = 'None'.
          <fs_despacho>-semaforo_descricao = 'Sem Alerta'(026).
        ENDIF.

        " Descrição do centro de planejamento
*        READ TABLE it_centro_planejamento INTO DATA(ls_centro_planejamento) WITH KEY iwerk = <fs_despacho>-iwerk BINARY SEARCH.
        DATA ls_centro_planejamento LIKE LINE OF it_centro_planejamento.
        READ TABLE it_centro_planejamento INTO ls_centro_planejamento WITH KEY iwerk = <fs_despacho>-iwerk BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          <fs_despacho>-name_cp = ls_centro_planejamento-name1.

        ENDIF.

        " Para as data que são exibidas no APP devem ser acrescidas de 1 dia
        " Datas formatadas para filtro no APP
        IF origem = 'APP'.

          IF <fs_despacho>-gltrp IS NOT INITIAL.

            WRITE: <fs_despacho>-gltrp USING EDIT MASK '__/__/____' TO <fs_despacho>-gltrp_str.
            ADD 1 TO <fs_despacho>-gltrp.

          ENDIF.

          IF <fs_despacho>-gstrp IS NOT INITIAL.

            WRITE: <fs_despacho>-gstrp USING EDIT MASK '__/__/____' TO <fs_despacho>-gstrp_str.
            ADD 1 TO <fs_despacho>-gstrp.

          ENDIF.

          IF <fs_despacho>-idat1 IS NOT INITIAL.

            WRITE: <fs_despacho>-idat1 USING EDIT MASK '__/__/____' TO <fs_despacho>-idat1_str.
            ADD 1 TO <fs_despacho>-idat1.

          ENDIF.

          IF <fs_despacho>-fsavd IS NOT INITIAL.

            WRITE: <fs_despacho>-fsavd USING EDIT MASK '__/__/____' TO <fs_despacho>-data_oper_ini_str.
            ADD 1 TO <fs_despacho>-fsavd.

          ENDIF.

          IF <fs_despacho>-fsedd IS NOT INITIAL.

            WRITE: <fs_despacho>-fsedd USING EDIT MASK '__/__/____' TO <fs_despacho>-data_oper_fim_str.
            ADD 1 TO <fs_despacho>-fsedd.

          ENDIF.

        ENDIF.

        CLEAR: ls_tb026_associada.

*       Converte código local instalação
        CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
          EXPORTING
            input  = <fs_despacho>-tplnr
          IMPORTING
            output = <fs_despacho>-tplnr.

      ENDLOOP.

      " Filtro para usuário APP
      IF s_usuapp[] IS NOT INITIAL.
        DELETE gt_despacho WHERE usuarioapp NOT IN s_usuapp[].
      ENDIF.

      " Filtro para Centro de trabalho
      IF s_gewrk[] IS NOT INITIAL.
        DELETE gt_despacho WHERE arbpl NOT IN s_gewrk[].
      ENDIF.

      IF p_oper = 'X'.
        " Chamada através do APP não deve eliminar registros
*        IF p_f_tree IS NOT INITIAL.
        IF origem    NE 'APP'.
*         Elimina do ALV as operações atribuídas
          LOOP AT gt_despacho INTO ls_despacho.
            lv_tabix = sy-tabix.
            READ TABLE lt_tb026_parcial TRANSPORTING NO FIELDS WITH KEY aufnr   = ls_despacho-aufnr
                                                                        vornr   = ls_despacho-vornr
                                                                        suboper = ls_despacho-suboper
                                                                        BINARY SEARCH.
            IF sy-subrc EQ 0.
              DELETE gt_despacho INDEX lv_tabix.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

    ENDIF.

    it_despacho[] = gt_despacho[].

  ENDMETHOD.


  METHOD busca_dados_tree.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************

    DATA: lt_despacho_tree TYPE /ptloms/ct080.

    DATA: ls_despacho_tree TYPE /ptloms/et079,
          ls_layout_node   TYPE lvc_s_layn.

    DATA: l_user      TYPE /ptloms/tb013-usuario,
          l_user_last TYPE /ptloms/tb013-usuario.

    DATA: l_data      TYPE d,
          l_data_last TYPE d.

    DATA: l_user_key TYPE lvc_nkey,
          l_data_key TYPE lvc_nkey,
          l_last_key TYPE lvc_nkey,
          l_top_key  TYPE lvc_nkey.

    TYPES: BEGIN OF ty_matricula,
             aufnr TYPE aufk-aufnr,
             pernr TYPE afvc-pernr,
           END OF ty_matricula.

    DATA: it_matricula TYPE TABLE OF ty_matricula,
          wa_matricula TYPE ty_matricula.

    DATA: lv_objnr     TYPE jsto-objnr,
          lv_desprezar TYPE char1,
          lv_pernr     TYPE afvc-pernr.

    DATA: o_oms TYPE REF TO /ptloms/cl001.

    IF p_f_tree = 'X'.
*      DATA(s_werks_aux) = s_werks[].
*      DATA(s_aufnr_aux) = s_aufnr[].
*      DATA(s_auart_aux) = s_auart[].
*      DATA(s_qmnum_aux) = s_qmnum[].
*      DATA(s_priok_aux) = s_priok[].
*      DATA(s_tplnr_aux) = s_tplnr[].
*      DATA(s_equnr_aux) = s_equnr[].
*      DATA(s_iwerk_aux) = s_iwerk[].
*      DATA(s_ingpr_aux) = s_ingpr[].
*      DATA(s_ilart_aux) = s_ilart[].
*      DATA(r_objid_aux) = r_objid[]. "s_gewrk.
*      DATA(s_gstrp_aux) = s_gstrp[].

      DATA s_werks_aux TYPE RANGE OF crhd-werks .
      DATA s_aufnr_aux TYPE RANGE OF viaufks-aufnr .
      DATA s_auart_aux TYPE RANGE OF viaufks-auart .
      DATA s_qmnum_aux TYPE RANGE OF viaufks-qmnum .
      DATA s_priok_aux TYPE RANGE OF viaufks-priok .
      DATA s_tplnr_aux TYPE RANGE OF viaufks-tplnr .
      DATA s_equnr_aux TYPE RANGE OF viaufks-equnr .
      DATA s_iwerk_aux TYPE RANGE OF viaufks-iwerk .
      DATA s_ingpr_aux TYPE RANGE OF viaufks-ingpr .
      DATA s_ilart_aux TYPE RANGE OF viaufks-ilart .
      DATA r_objid_aux TYPE RANGE OF crhd-objid .
      DATA s_gstrp_aux TYPE RANGE OF viaufks-gstrp .

      s_werks_aux = s_werks[].
      s_aufnr_aux = s_aufnr[].
      s_auart_aux = s_auart[].
      s_qmnum_aux = s_qmnum[].
      s_priok_aux = s_priok[].
      s_tplnr_aux = s_tplnr[].
      s_equnr_aux = s_equnr[].
      s_iwerk_aux = s_iwerk[].
      s_ingpr_aux = s_ingpr[].
      s_ilart_aux = s_ilart[].
      r_objid_aux = r_objid[]. "s_gewrk.
      s_gstrp_aux = s_gstrp[].
    ENDIF.

* Seleciona ordens associadas
    IF p_ordens = 'X'.
* Na visão ordem, seleciona as ordens associadas em que VORNR = vazio
      SELECT *
        FROM /ptloms/tb026
        INTO TABLE gt_tb026
        WHERE vornr        = space
          AND usuario      IN s_usuapp
          AND desassociado = space.

    ELSEIF p_oper = 'X'.
* Na visão operação, seleciona as ordens associadas em que VORNR <> vazio
      SELECT *
        FROM /ptloms/tb026
        INTO TABLE gt_tb026
        WHERE vornr        <> space
          AND usuario      IN s_usuapp
          AND desassociado = space.
    ENDIF.

* Ordena tabela
    SORT gt_tb026 BY usuario         ASCENDING
                     aufnr           ASCENDING
                     vornr           ASCENDING
                     suboper         ASCENDING
                     data_associacao ASCENDING
                     hora_associacao ASCENDING.

    IF gt_tb026[] IS NOT INITIAL.

* Busca dados de usuário
*      SELECT *
*        FROM /ptloms/tb013
*        INTO TABLE @DATA(lt_tb013)
*        FOR ALL ENTRIES IN @gt_tb026
*        WHERE usuario = @gt_tb026-usuario.
      DATA lt_tb013 TYPE TABLE OF /ptloms/tb013.
      SELECT *
        FROM /ptloms/tb013
        INTO TABLE lt_tb013
        FOR ALL ENTRIES IN gt_tb026
        WHERE usuario = gt_tb026-usuario.

* Busca dados de ordem
      IF p_ordens = 'X'.
*        SELECT aufnr, auart, qmnum, priok, gewrk,
*               gstrp, gltrp, idat1, ktext, iwerk,
*               ingpr, tplnr, equnr, artpr, objnr
*        FROM viaufks
*        INTO CORRESPONDING FIELDS OF TABLE @lt_despacho_tree
*        FOR ALL ENTRIES IN @gt_tb026
*        WHERE aufnr = @gt_tb026-aufnr
*            AND werks IN @s_werks_aux
****        AND gewrk IN @r_objid
****        AND gstrp IN @s_gstrp.
*            AND aufnr IN @s_aufnr_aux
*            AND auart IN @s_auart_aux
*            AND qmnum IN @s_qmnum_aux
*            AND priok IN @s_priok_aux
*            AND tplnr IN @s_tplnr_aux
*            AND equnr IN @s_equnr_aux
*            AND iwerk IN @s_iwerk_aux
*            AND ingpr IN @s_ingpr_aux
*            AND ilart IN @s_ilart_aux
*            AND gewrk IN @r_objid_aux "s_gewrk.
*            AND gstrp IN @s_gstrp_aux.
        SELECT aufnr auart qmnum priok gewrk
               gstrp gltrp idat1 ktext iwerk
               ingpr tplnr equnr artpr objnr
        FROM viaufks
        INTO CORRESPONDING FIELDS OF TABLE lt_despacho_tree
        FOR ALL ENTRIES IN gt_tb026
        WHERE aufnr = gt_tb026-aufnr
            AND werks IN s_werks_aux
***        AND gewrk IN @r_objid
***        AND gstrp IN @s_gstrp.
            AND aufnr IN s_aufnr_aux
            AND auart IN s_auart_aux
            AND qmnum IN s_qmnum_aux
            AND priok IN s_priok_aux
            AND tplnr IN s_tplnr_aux
            AND equnr IN s_equnr_aux
            AND iwerk IN s_iwerk_aux
            AND ingpr IN s_ingpr_aux
            AND ilart IN s_ilart_aux
            AND gewrk IN r_objid_aux "s_gewrk.
            AND gstrp IN s_gstrp_aux.

      ELSEIF p_oper = 'X'.
*        SELECT a~aufnr, a~auart, a~qmnum, a~priok, a~gewrk,
*               a~gstrp, a~gltrp, a~idat1, a~ktext, a~iwerk,
*               a~ingpr, a~tplnr, a~equnr, c~vornr, c~arbid,
*               c~ltxa1, a~artpr, a~objnr, c~aufpl, c~aplzl,
*               c~sumnr, c~pernr, d~arbei, d~fsavd, d~fsedd, d~ismnw
*        FROM viaufks AS a INNER JOIN afko AS b ON a~aufnr = b~aufnr
*        INNER JOIN afvc AS c ON b~aufpl = c~aufpl
*        INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
**      INTO CORRESPONDING FIELDS OF TABLE @lt_despacho_tree
*        INTO TABLE @DATA(lt_despacho_tree_aux)
*        FOR ALL ENTRIES IN @gt_tb026
*        WHERE a~aufnr EQ @gt_tb026-aufnr
*          AND a~werks IN @s_werks_aux
****        AND a~gewrk IN @r_objid
****        AND a~gstrp IN @s_gstrp
*          AND c~phflg EQ @space
*          AND d~fsavd IN @s_datope
*          AND a~aufnr IN @s_aufnr_aux
*          AND a~auart IN @s_auart_aux
*          AND a~qmnum IN @s_qmnum_aux
*          AND a~priok IN @s_priok_aux
*          AND a~tplnr IN @s_tplnr_aux
*          AND a~equnr IN @s_equnr_aux
*          AND a~iwerk IN @s_iwerk_aux
*          AND a~ingpr IN @s_ingpr_aux
*          AND a~ilart IN @s_ilart_aux
*          AND a~gewrk IN @r_objid_aux "s_gewrk.
*          AND a~gstrp IN @s_gstrp_aux.
        TYPES: BEGIN OF ty_despacho_tree_aux,
                 aufnr  TYPE viaufks-aufnr,
                 auart  TYPE viaufks-auart,
                 qmnum  TYPE viaufks-qmnum,
                 priok  TYPE viaufks-priok,
                 gewrk  TYPE viaufks-gewrk,
                 gstrp  TYPE viaufks-gstrp,
                 gltrp  TYPE viaufks-gltrp,
                 idat1  TYPE viaufks-idat1,
                 ktext  TYPE viaufks-ktext,
                 iwerk  TYPE viaufks-iwerk,
                 ingpr  TYPE viaufks-ingpr,
                 tplnr  TYPE viaufks-tplnr,
                 equnr  TYPE viaufks-equnr,
                 vornr  TYPE afvc-vornr,
                 arbid  TYPE afvc-arbid,
                 ltxa1  TYPE afvc-ltxa1,
                 artpr  TYPE viaufks-equnr,
                 aobjnr TYPE viaufks-equnr,
                 caufpl TYPE afvc-aufpl,
                 caplzl TYPE afvc-aplzl,
                 sumnr  TYPE afvc-sumnr,
                 pernr  TYPE afvc-pernr,
                 arbei  TYPE afvv-arbei,
                 arbeh  TYPE afvv-arbeh,
                 fsavd  TYPE afvv-fsavd,
                 fsedd  TYPE afvv-fsedd,
                 ismnw  TYPE afvv-ismnw,
               END OF ty_despacho_tree_aux.
        DATA lt_despacho_tree_aux TYPE TABLE OF ty_despacho_tree_aux.
        SELECT a~aufnr a~auart a~qmnum a~priok a~gewrk
               a~gstrp a~gltrp a~idat1 a~ktext a~iwerk
               a~ingpr a~tplnr a~equnr c~vornr c~arbid
               c~ltxa1 a~artpr a~objnr c~aufpl c~aplzl
               c~sumnr c~pernr d~arbei d~arbeh d~fsavd d~fsedd d~ismnw
        FROM viaufks AS a INNER JOIN afko AS b ON a~aufnr = b~aufnr
        INNER JOIN afvc AS c ON b~aufpl = c~aufpl
        INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
*      INTO CORRESPONDING FIELDS OF TABLE @lt_despacho_tree
        INTO TABLE lt_despacho_tree_aux
        FOR ALL ENTRIES IN gt_tb026
        WHERE a~aufnr EQ gt_tb026-aufnr
          AND c~vornr EQ gt_tb026-vornr   "Alterado por Vidal
          AND a~werks IN s_werks_aux
***        AND a~gewrk IN @r_objid
***        AND a~gstrp IN @s_gstrp
          AND c~phflg EQ space
          AND d~fsavd IN s_datope
          AND a~aufnr IN s_aufnr_aux
          AND a~auart IN s_auart_aux
          AND a~qmnum IN s_qmnum_aux
          AND a~priok IN s_priok_aux
          AND a~tplnr IN s_tplnr_aux
          AND a~equnr IN s_equnr_aux
          AND a~iwerk IN s_iwerk_aux
          AND a~ingpr IN s_ingpr_aux
          AND a~ilart IN s_ilart_aux
          AND a~gewrk IN r_objid_aux "s_gewrk.
          AND a~gstrp IN s_gstrp_aux.

* Na visão Operação, exibe apenas Operações sem matrícula atribuída
        IF p_oper = 'X' AND p_mat_at = 'X'.
          DELETE lt_despacho_tree_aux WHERE pernr IS NOT INITIAL.
        ENDIF.

*        LOOP AT lt_despacho_tree_aux INTO DATA(ls_despacho_tree_aux).
        DATA ls_despacho_tree_aux LIKE LINE OF lt_despacho_tree_aux.
        LOOP AT lt_despacho_tree_aux INTO ls_despacho_tree_aux.
          CLEAR ls_despacho_tree.
          TRY.
              MOVE-CORRESPONDING ls_despacho_tree_aux TO ls_despacho_tree.
            CATCH cx_root.
              CLEAR ls_despacho_tree_aux-arbei.
              CLEAR ls_despacho_tree_aux-ismnw.
              MOVE-CORRESPONDING ls_despacho_tree_aux TO ls_despacho_tree.
          ENDTRY.
          MOVE ls_despacho_tree_aux-aobjnr        TO ls_despacho_tree-objnr.
          CLEAR ls_despacho_tree-arbei.
          APPEND ls_despacho_tree TO lt_despacho_tree.
        ENDLOOP.
      ENDIF.

      IF lt_despacho_tree[] IS NOT INITIAL.

* Seleciona Ordens associadas
*        SELECT aufnr, vornr, suboper, usuario, data_associacao, hora_associacao
*          FROM /ptloms/tb026
*          INTO TABLE @DATA(lt_tb026_associada)
*          FOR ALL ENTRIES IN @gt_despacho
*          WHERE aufnr = @gt_despacho-aufnr.
        DATA lt_tb026_associada TYPE TABLE OF /ptloms/tb026.
        SELECT aufnr vornr suboper usuario data_associacao hora_associacao
          FROM /ptloms/tb026
          INTO CORRESPONDING FIELDS OF TABLE lt_tb026_associada
          FOR ALL ENTRIES IN gt_despacho
          WHERE aufnr = gt_despacho-aufnr.

* Seleciona descrição dos Locais de Instalação
*        SELECT tplnr, pltxt
*          FROM iflotx
*          INTO TABLE @DATA(lt_iflotx)
*          FOR ALL ENTRIES IN @lt_despacho_tree
*          WHERE spras = @sy-langu
*            AND tplnr = @lt_despacho_tree-tplnr.
        TYPES: BEGIN OF ty_iflotx,
                 tplnr TYPE iflotx-tplnr,
                 pltxt TYPE iflotx-tplnr,
               END OF ty_iflotx.
        DATA lt_iflotx TYPE TABLE OF ty_iflotx.
        SELECT tplnr pltxt
          FROM iflotx
          INTO TABLE lt_iflotx
          FOR ALL ENTRIES IN lt_despacho_tree
          WHERE spras = sy-langu
            AND tplnr = lt_despacho_tree-tplnr.

* Seleciona descrição dos equipamentos
*        SELECT equnr, eqktx
*          FROM v_equi
*          INTO TABLE @DATA(lt_v_equi)
*          FOR ALL ENTRIES IN @lt_despacho_tree
*          WHERE txasp EQ 'X'
*            AND owner EQ @space
*            AND spras EQ @sy-langu
*            AND equnr = @lt_despacho_tree-equnr.
        TYPES: BEGIN OF ty_v_equi,
                 equnr TYPE v_equi-equnr,
                 eqktx TYPE v_equi-eqktx,
                 eqfnr TYPE v_equi-eqfnr,
                 anlnr TYPE v_equi-anlnr,
                 anlun TYPE v_equi-anlun,
               END OF ty_v_equi.
        DATA lt_v_equi TYPE TABLE OF ty_v_equi.
        SELECT equnr eqktx eqfnr anlnr anlun
          FROM v_equi
          INTO TABLE lt_v_equi
          FOR ALL ENTRIES IN lt_despacho_tree
          WHERE txasp EQ 'X'
            AND owner EQ space
            AND spras EQ sy-langu
            AND equnr = lt_despacho_tree-equnr.

* Busca descrição do centro de trabalho
        IF p_ordens = 'X'.
*          SELECT objty, objid, arbpl
*            FROM crhd
*            INTO TABLE @DATA(lt_crhd)
*            FOR ALL ENTRIES IN @lt_despacho_tree
*            WHERE objid = @lt_despacho_tree-gewrk.
          TYPES: BEGIN OF ty_crhd,
                   objty TYPE crhd-objty,
                   objid TYPE crhd-objid,
                   arbpl TYPE crhd-arbpl,
                 END OF ty_crhd.
          DATA lt_crhd TYPE TABLE OF ty_crhd.
          SELECT objty objid arbpl
            FROM crhd
            INTO TABLE lt_crhd
            FOR ALL ENTRIES IN lt_despacho_tree
            WHERE objid = lt_despacho_tree-gewrk.

*          SELECT b~aufnr, c~vornr, c~pernr
*            FROM /ptloms/tb026 AS a INNER JOIN afko AS b
*            ON a~aufnr = b~aufnr
*            INNER JOIN afvc AS c
*            ON b~aufpl = c~aufpl
*            INTO TABLE @DATA(it_afvc)
*            FOR ALL ENTRIES IN @lt_despacho_tree
*            WHERE a~aufnr      = @lt_despacho_tree-aufnr
*            AND a~desassociado = @space
*            AND c~phflg        = @space.
          TYPES: BEGIN OF ty_afvc,
                   aufnr TYPE afko-aufnr,
                   vornr TYPE afvc-vornr,
                   pernr TYPE afvc-pernr,
                 END OF ty_afvc.
          DATA it_afvc TYPE TABLE OF ty_afvc.
          SELECT b~aufnr c~vornr c~pernr
            FROM /ptloms/tb026 AS a INNER JOIN afko AS b
            ON a~aufnr = b~aufnr
            INNER JOIN afvc AS c
            ON b~aufpl = c~aufpl
            INTO TABLE it_afvc
            FOR ALL ENTRIES IN lt_despacho_tree
            WHERE a~aufnr      = lt_despacho_tree-aufnr
            AND a~desassociado = space
            AND c~phflg        = space.

        ELSEIF p_oper = 'X'.
*          SELECT objty, objid, arbpl
*            FROM crhd
*            INTO TABLE @lt_crhd
*            FOR ALL ENTRIES IN @lt_despacho_tree
*            WHERE objid = @lt_despacho_tree-arbid.
          SELECT objty objid arbpl
            FROM crhd
            INTO TABLE lt_crhd
            FOR ALL ENTRIES IN lt_despacho_tree
            WHERE objid = lt_despacho_tree-arbid.
        ENDIF.

* Busca descrição da prioridade
*        SELECT spras, artpr, priok, priokx
*          FROM t356_t
*          INTO TABLE @DATA(lt_t356_t)
*          FOR ALL ENTRIES IN @lt_despacho_tree
*          WHERE spras  = @sy-langu
*            AND artpr  = @lt_despacho_tree-artpr
*            AND priok = @lt_despacho_tree-priok.
        TYPES: BEGIN OF ty_t356_t,
                 spras  TYPE t356_t-spras,
                 artpr  TYPE t356_t-artpr,
                 priok  TYPE t356_t-priok,
                 priokx TYPE t356_t-priokx,
               END OF ty_t356_t.
        DATA lt_t356_t TYPE TABLE OF ty_t356_t.
        SELECT spras artpr priok priokx
          FROM t356_t
          INTO TABLE lt_t356_t
          FOR ALL ENTRIES IN lt_despacho_tree
          WHERE spras  = sy-langu
            AND artpr  = lt_despacho_tree-artpr
            AND priok  = lt_despacho_tree-priok.

* Busca SubOperações
        IF p_oper = 'X'.
*          SELECT a~aufpl, a~aplzl, a~vornr, a~sumnr, a~objnr
*            FROM afvc AS a
*            INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
*            INTO TABLE @DATA(lt_sub_operacoes)
*            FOR ALL ENTRIES IN @lt_despacho_tree
*            WHERE a~aufpl = @lt_despacho_tree-aufpl
*              AND a~aplzl = @lt_despacho_tree-aplzl
*              AND a~phflg = @space
*              AND b~fsavd IN @s_datope.
          TYPES: BEGIN OF ty_sub_operacoes,
                   aufpl TYPE afvc-aufpl,
                   aplzl TYPE afvc-aplzl,
                   vornr TYPE afvc-vornr,
                   sumnr TYPE afvc-sumnr,
                   objnr TYPE afvc-objnr,
                 END OF ty_sub_operacoes.
          DATA lt_sub_operacoes TYPE TABLE OF ty_sub_operacoes.
          SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
            FROM afvc AS a
            INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
            INTO TABLE lt_sub_operacoes
            FOR ALL ENTRIES IN lt_despacho_tree
            WHERE a~aufpl = lt_despacho_tree-aufpl
              AND a~aplzl = lt_despacho_tree-aplzl
              AND a~phflg = space
              AND b~fsavd IN s_datope.
        ENDIF.

        me->busca_endereco_cliente_tree( CHANGING it_despacho = lt_despacho_tree ).

*       DATA(it_despacho_tree_aux) = lt_despacho_tree.
        DATA: it_despacho_tree_aux TYPE /ptloms/ct080.
        it_despacho_tree_aux = lt_despacho_tree.

*        LOOP AT lt_despacho_tree ASSIGNING FIELD-SYMBOL(<fs_despacho_tree>).
        DATA: lv_tabix TYPE sy-tabix.
        FIELD-SYMBOLS: <fs_despacho_tree> LIKE LINE OF lt_despacho_tree.
        LOOP AT lt_despacho_tree ASSIGNING <fs_despacho_tree>.

          lv_tabix = sy-tabix.

*          READ TABLE lt_tb026_associada INTO DATA(ls_tb026_associada) WITH KEY aufnr = <fs_despacho_tree>-aufnr.
          DATA ls_tb026_associada LIKE LINE OF lt_tb026_associada.
          READ TABLE lt_tb026_associada INTO ls_tb026_associada WITH KEY aufnr = <fs_despacho_tree>-aufnr.
          IF sy-subrc EQ 0.
            <fs_despacho_tree>-data_associacao = ls_tb026_associada-data_associacao.
            <fs_despacho_tree>-hora_associacao = ls_tb026_associada-hora_associacao.
            <fs_despacho_tree>-usuario         = ls_tb026_associada-usuario.
          ENDIF.

*          READ TABLE lt_iflotx INTO DATA(ls_iflotx) WITH KEY tplnr = <fs_despacho_tree>-tplnr.
          DATA ls_iflotx LIKE LINE OF lt_iflotx.
          READ TABLE lt_iflotx INTO ls_iflotx WITH KEY tplnr = <fs_despacho_tree>-tplnr.
          IF sy-subrc EQ 0.
            <fs_despacho_tree>-pltxt = ls_iflotx-pltxt.
*       Converte código local instalação
            CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
              EXPORTING
                input  = <fs_despacho_tree>-tplnr
              IMPORTING
                output = <fs_despacho_tree>-tplnr.
          ENDIF.

*          READ TABLE lt_v_equi INTO DATA(ls_v_equi) WITH KEY equnr = <fs_despacho_tree>-equnr.
          DATA ls_v_equi LIKE LINE OF lt_v_equi.
          READ TABLE lt_v_equi INTO ls_v_equi WITH KEY equnr = <fs_despacho_tree>-equnr.
          IF sy-subrc EQ 0.
            <fs_despacho_tree>-eqktx = ls_v_equi-eqktx.
*            <fs_despacho_tree>-eqfnr = ls_v_equi-eqfnr.
*            <fs_despacho_tree>-anlnr = ls_v_equi-anlnr.
*            <fs_despacho_tree>-anlun = ls_v_equi-anlun.
          ENDIF.

          IF p_oper = 'X'.
            <fs_despacho_tree>-gewrk = <fs_despacho_tree>-arbid.
          ENDIF.

*          READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = <fs_despacho_tree>-gewrk.
          DATA ls_crhd LIKE LINE OF lt_crhd.
          READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = <fs_despacho_tree>-gewrk.
          IF sy-subrc = 0.
            <fs_despacho_tree>-arbpl = ls_crhd-arbpl.
          ENDIF.

*          READ TABLE lt_t356_t INTO DATA(ls_t356_t) WITH KEY artpr = <fs_despacho_tree>-artpr
*                                                             priok = <fs_despacho_tree>-priok.
          DATA ls_t356_t LIKE LINE OF lt_t356_t.
          READ TABLE lt_t356_t INTO ls_t356_t WITH KEY artpr = <fs_despacho_tree>-artpr
                                                             priok = <fs_despacho_tree>-priok.
          IF sy-subrc EQ 0.
            <fs_despacho_tree>-priokx = ls_t356_t-priokx.
          ENDIF.

          IF p_oper = 'X'.
            IF <fs_despacho_tree>-sumnr IS NOT INITIAL.
*              READ TABLE lt_sub_operacoes INTO DATA(ls_sub_operacoes) WITH KEY aufpl = <fs_despacho_tree>-aufpl
*                                                                               aplzl = <fs_despacho_tree>-sumnr.
              DATA ls_sub_operacoes LIKE LINE OF lt_sub_operacoes.
              READ TABLE lt_sub_operacoes INTO ls_sub_operacoes WITH KEY aufpl = <fs_despacho_tree>-aufpl
                                                                               aplzl = <fs_despacho_tree>-sumnr.
              IF sy-subrc EQ 0.
                <fs_despacho_tree>-suboper = <fs_despacho_tree>-vornr.
                <fs_despacho_tree>-vornr   = ls_sub_operacoes-vornr.
              ENDIF.
            ENDIF.

            READ TABLE lt_sub_operacoes INTO ls_sub_operacoes WITH KEY aufpl = <fs_despacho_tree>-aufpl
                                                                       aplzl = <fs_despacho_tree>-aplzl.
            IF sy-subrc EQ 0.
              <fs_despacho_tree>-objnr_oper_sub = ls_sub_operacoes-objnr.
            ENDIF.
            " Seleção por ordem
          ELSE.

            " Busca por ordem informar a matrícula da ordem já associada para todas as operações
*            LOOP AT it_afvc ASSIGNING FIELD-SYMBOL(<fs_afvc>) WHERE aufnr = <fs_despacho_tree>-aufnr AND
*                                                                    pernr IS NOT INITIAL.
            FIELD-SYMBOLS: <fs_afvc> LIKE LINE OF it_afvc.
            LOOP AT it_afvc ASSIGNING <fs_afvc> WHERE aufnr = <fs_despacho_tree>-aufnr AND
                                                                    pernr IS NOT INITIAL.

              wa_matricula-aufnr = <fs_despacho_tree>-aufnr.
              wa_matricula-pernr = <fs_afvc>-pernr.

              COLLECT wa_matricula INTO it_matricula.

            ENDLOOP.

            IF lines( it_matricula ) = 1.

*              <fs_despacho_tree>-pernr = VALUE #( it_matricula[ 1 ]-pernr OPTIONAL ).
              READ TABLE it_matricula INTO wa_matricula INDEX 1.
              IF sy-subrc IS INITIAL.
                <fs_despacho_tree>-pernr = wa_matricula-pernr.
              ENDIF.

            ELSE.

              CLEAR: <fs_despacho_tree>-pernr.

            ENDIF.

            CLEAR: it_matricula.

          ENDIF.

          CLEAR lv_objnr.

          IF p_ordens = 'X'.
            lv_objnr = <fs_despacho_tree>-objnr.
          ELSEIF p_oper = 'X'.
            lv_objnr = <fs_despacho_tree>-objnr_oper_sub.
          ENDIF.

* Exclui as Ordens ENCE, ENTE e CONF
          CLEAR lv_desprezar.
          CALL FUNCTION '/PTLOMS/MF008'
            EXPORTING
              im_objnr     = lv_objnr
            IMPORTING
              ex_desprezar = lv_desprezar.

          IF lv_desprezar = 'X'.
            DELETE lt_despacho_tree INDEX lv_tabix.
            CONTINUE.
          ENDIF.

        ENDLOOP.

        " Filtro para Centro de trabalho
        IF s_gewrk[] IS NOT INITIAL.
          DELETE lt_despacho_tree WHERE arbpl NOT IN s_gewrk[].
        ENDIF.

*        IF p_ordens IS NOT INITIAL.
*
*          TYPES: BEGIN OF ty_ordem,
*                   aufnr   TYPE aufnr,
*                   usuario TYPE /ptloms/tb026-usuario,
*                 END OF ty_ordem.
*
*          DATA: it_ordem TYPE STANDARD TABLE OF ty_ordem.
*
*          DATA: wa_ordem TYPE ty_ordem.
**                members  TYPE lt_despacho_tree.
*
*          DATA(it_despacho) = lt_despacho_tree.
*
*          IF it_despacho IS NOT INITIAL.
*
*            SELECT b~aufnr, c~vornr
*              FROM /ptloms/tb026 AS a INNER JOIN afko AS b
*              ON a~aufnr = b~aufnr
*              INNER JOIN afvc AS c
*              ON b~aufpl = c~aufpl
*              INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
*              AND a~vornr = c~vornr
*              INTO TABLE @DATA(it_afvc)
*              FOR ALL ENTRIES IN @it_despacho
*              WHERE a~aufnr      = @it_despacho-aufnr
*              AND a~desassociado = @space
*              AND c~phflg        = @space.
*
*            IF sy-subrc IS INITIAL.
*
*              SELECT *
*                FROM /ptloms/tb026
*                INTO TABLE @DATA(it_tb026_local)
*                FOR ALL ENTRIES IN @it_despacho
*                WHERE aufnr       = @it_despacho-aufnr
*                  AND vornr       <> @space
*                  AND desassociado = @space.
*
*            ENDIF.
*
*          ENDIF.

*          LOOP AT lt_despacho_tree ASSIGNING <fs_despacho_tree>.

        " Recuperar todas operações
*            LOOP AT it_afvc ASSIGNING FIELD-SYMBOL(<fs_afvc>) WHERE aufnr = <fs_despacho_tree>-aufnr.
*
*            LOOP AT it_despacho INTO DATA(ls_despacho) WHERE aufnr = <fs_despacho_tree>-aufnr AND
*                                                             vornr = ''.
*
*              wa_ordem-aufnr   = ls_despacho-aufnr.
*              wa_ordem-usuario = ls_despacho-usuario.
*
*              COLLECT wa_ordem INTO it_ordem.
*
*            ENDLOOP.
*
**            ENDLOOP.
*
*            IF lines( it_ordem ) = 1.
*
*              <fs_despacho_tree>-usuario = ls_despacho-usuario.
*
*            ELSE.
*
*              CLEAR: <fs_despacho_tree>-usuario.
*
*            ENDIF.

*          ENDLOOP.

*          LOOP AT it_tb026_local INTO DATA(ls_local) GROUP BY ( aufnr = ls_local-aufnr pernr = ls_local-usuario )
*                                                          ASCENDING
*                                                          ASSIGNING FIELD-SYMBOL(<group>).
*
*            LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<fs_despacho>).
*
*              members = VALUE #( BASE members ( ls_local ) ).
*
*            ENDLOOP.
*
*          ENDLOOP.
*
*          SORT members BY aufnr pernr.
*          DELETE ADJACENT DUPLICATES FROM members COMPARING aufnr pernr.
*          DATA(members_original) = members.
*
*          LOOP AT lt_despacho_tree ASSIGNING <fs_despacho_tree>.
*
*            AT NEW aufnr.
*
*              DELETE members WHERE aufnr <> <fs_despacho_tree>-aufnr.
*
*              IF lines( members ) = 1.
*
*                READ TABLE members ASSIGNING FIELD-SYMBOL(<fs_members>) INDEX 1.
*
*                lv_pernr = <fs_members>-pernr.
*
*              ELSE.
*
*                lv_pernr = ''.
*
*              ENDIF.
*
*              members = members_original.
*
*            ENDAT.
*
*            <fs_despacho_tree>-pernr = lv_pernr.
*
*          ENDLOOP.

*        SORT members BY pernr.
*        DELETE ADJACENT DUPLICATES FROM members COMPARING pernr.
*
*        IF lines( members ) = 1.
*
*          TRY.
*
*              READ TABLE members ASSIGNING FIELD-SYMBOL(<fs_members>) INDEX 1.
*
*              "lt_despacho_tree[ aufnr = <fs_members>-pernr ] = <fs_members>-aufnr.
*
*            CATCH cx_sy_itab_line_not_found.
*
*          ENDTRY.
*
*        ELSE.
*
*          TRY.
*
*              READ TABLE members ASSIGNING <fs_members> INDEX 1.
*
*              IF sy-subrc IS INITIAL.
*
*                lt_despacho_tree[ aufnr = '' ] = <fs_members>-aufnr.
*
*              ENDIF.
*
*            CATCH cx_sy_itab_line_not_found.
*
*          ENDTRY.
*
*        ENDIF.
*
*      ENDLOOP.

*      ENDIF.

      ENDIF.

    ENDIF.

    " Necessário eliminar todos os nodes para então adicioná-los novamente
    CALL METHOD g_alv_tree->delete_all_nodes.

*   Imagem ao abrir
    ls_layout_node-n_image   = icon_usergroup.

*   Imagem ao expandir
    ls_layout_node-exp_image = icon_usergroup.

* Define nó superior
    CALL METHOD g_alv_tree->add_node
      EXPORTING
        i_relat_node_key = ''
        i_relationship   = cl_gui_column_tree=>relat_last_child
        is_node_layout   = ls_layout_node
        i_node_text      = 'Usuários'(069)
      IMPORTING
        e_new_node_key   = l_top_key.

*  PERFORM f_busca_horas_planejadas.

    CREATE OBJECT o_oms.

*    LOOP AT gt_tb026 INTO DATA(ls_026).
* Declaração de variáveis
    DATA: lv_stsma TYPE jsto-stsma,
          lv_stonr TYPE tj30-stonr.

    DATA ls_026 LIKE LINE OF gt_tb026.

    LOOP AT gt_tb026 INTO ls_026.

      CLEAR ls_despacho_tree.

      IF p_ordens = 'X'.
        READ TABLE lt_despacho_tree INTO ls_despacho_tree WITH KEY aufnr = ls_026-aufnr.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.
      ELSEIF p_oper = 'X'.
        READ TABLE lt_despacho_tree INTO ls_despacho_tree WITH KEY aufnr   = ls_026-aufnr
                                                                   vornr   = ls_026-vornr
                                                                   suboper = ls_026-suboper.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.

*        DATA(lv_tabix_aux) = sy-tabix.
        DATA lv_tabix_aux TYPE sy-tabix.
        lv_tabix_aux = sy-tabix.
        "ls_despacho_tree-ktext = ls_despacho_tree-ltxa1.

        READ TABLE lt_despacho_tree_aux INTO ls_despacho_tree_aux INDEX lv_tabix_aux.
        IF sy-subrc EQ 0.
*          DATA(rt_data_conf_usuario) = o_oms->out_monta_range_data_usuario( ls_026-usuario ).
          DATA rt_data_conf_usuario TYPE /iwbep/t_cod_select_options.
          rt_data_conf_usuario = o_oms->out_monta_range_data_usuario( ls_026-usuario ).
*          IF ls_despacho_tree_aux-fsavd IN rt_data_conf_usuario
*          OR ls_despacho_tree_aux-fsedd IN rt_data_conf_usuario.
          "--> Caso a unidade de medida esteja em MINUTOS, é necessário converter para HORAS.
          IF  sy-tcode                    EQ '/PTLOMS/PTLOMSN004'.
            IF  ls_despacho_tree_aux-arbeh  EQ 'MIN'.
              ls_despacho_tree_aux-arbei  = ls_despacho_tree_aux-arbei / 60 .
              ls_despacho_tree_aux-ismnw  = ls_despacho_tree_aux-ismnw / 60 .
            ENDIF.
          ENDIF.


          TRY.
              ls_despacho_tree-arbei = ls_despacho_tree_aux-arbei.
              ls_despacho_tree-ismnw = ls_despacho_tree_aux-ismnw.
            CATCH cx_root.
              CLEAR ls_despacho_tree-arbei.
              CLEAR ls_despacho_tree-ismnw.
          ENDTRY.


*          ENDIF.
        ENDIF.

        REFRESH rt_data_conf_usuario[].

      ENDIF.

      MOVE-CORRESPONDING ls_026 TO ls_despacho_tree.

      " Status da ordem
      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
          objnr            = ls_despacho_tree-objnr
          spras            = sy-langu
        IMPORTING
          e_stsma          = lv_stsma
          line             = ls_despacho_tree-status_sis
          user_line        = ls_despacho_tree-status_usu
          stonr            = lv_stonr
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.

*      READ TABLE lt_tb013 INTO DATA(ls_013) WITH KEY usuario = ls_despacho_tree-usuario.
      DATA ls_013 LIKE LINE OF lt_tb013.
      READ TABLE lt_tb013 INTO ls_013 WITH KEY usuario = ls_despacho_tree-usuario.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_013 TO ls_despacho_tree.
      ENDIF.

      MODIFY lt_despacho_tree  FROM ls_despacho_tree INDEX lv_tabix_aux.

    ENDLOOP.

*********************************************************************************************************
***  FIM - Nádia Rodrigues
*********************************************************************************************************
    SORT lt_despacho_tree BY usuario gstrp aufnr.

    LOOP AT lt_despacho_tree  INTO ls_despacho_tree.

      l_user = ls_despacho_tree-usuario.

      IF l_user NE l_user_last.

        l_user_last = l_user.
        CLEAR l_data_last.

* Usuário nodes
        add_user( EXPORTING p_user       = l_user
                            p_relat_key  = l_top_key
                  CHANGING  p_node_key   = l_user_key
                            g_alv_tree   = g_alv_tree ).
      ENDIF.

**** /- Inserção de nível por data

      l_data  = ls_despacho_tree-gstrp.

      IF  l_data  NE l_data_last.
        l_data_last = l_data.

        "Data inicio base
        add_data( EXPORTING p_user       = l_user
                            p_data       = l_data
                            p_relat_key  = l_user_key
                  CHANGING  p_node_key   = l_data_key
                            g_alv_tree   = g_alv_tree ).

      ENDIF.

      add_complete_line( EXPORTING p_relat_key      = l_data_key
                         CHANGING  p_node_key       = l_last_key
                                   g_alv_tree       = g_alv_tree
                                   ps_despacho_tree = ls_despacho_tree ).

    ENDLOOP.

    IF  lt_despacho_tree[]  IS INITIAL.
      REFRESH gt_nodes.
    ENDIF.

    gt_despacho_tree[] = it_despacho_tree[].

    it_tb026[]         = gt_tb026[].
    it_nodes[]         = gt_nodes[].

  ENDMETHOD.


  METHOD busca_endereco_cliente.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz..
*********************************************************************************************************
    DATA: lv_parvw   TYPE ihpa-parvw.

    CONSTANTS: c_ag  TYPE ihpa-parvw VALUE 'SP',
               c_ieq TYPE ihpa-obtyp VALUE 'IEQ'.

    TYPES: BEGIN OF ty_ihpa_parceiro,
             objnr   TYPE ihpa-objnr,
             parvw   TYPE ihpa-parvw,
             counter TYPE ihpa-counter,
             parnr   TYPE ihpa-parnr,   "kna1-kunnr,    "gbe 01/09/2025 - Dump URLA
             kunnr   TYPE kna1-kunnr,                   "gbe 01/09/2025 - Dump URLA
           END OF ty_ihpa_parceiro.

    DATA: it_ihpa_parceiro TYPE TABLE OF ty_ihpa_parceiro.
    DATA: vl_kunnr TYPE kna1-kunnr,
          vl_parnr TYPE ihpa-parnr.

    FIELD-SYMBOLS: <fs_ihpa_kunnr> LIKE LINE OF it_ihpa_parceiro.

    IF gt_despacho[] IS NOT INITIAL.

***   DATA(it_despacho_local) = gt_despacho[].
      DATA: it_despacho_local TYPE /ptloms/ct079.
      it_despacho_local =  gt_despacho[].

      SORT it_despacho_local BY equnr.

***   DATA(it_equnr) = it_despacho_local.
      DATA: it_equnr TYPE /ptloms/ct079.
      it_equnr = it_despacho_local.

      SORT it_equnr BY equnr.
      DELETE ADJACENT DUPLICATES FROM it_equnr COMPARING equnr.

      DATA: it_eqbs TYPE TABLE OF eqbs.

      SELECT kunnr equnr
        FROM eqbs
        INTO CORRESPONDING FIELDS OF TABLE it_eqbs
        FOR ALL ENTRIES IN it_equnr
        WHERE equnr = it_equnr-equnr.

***      SELECT kunnr, equnr
***        FROM eqbs
***        INTO TABLE @DATA(it_eqbs)
***        FOR ALL ENTRIES IN @it_equnr
***        WHERE equnr = @it_equnr-equnr.

      IF sy-subrc IS INITIAL.

        SORT it_eqbs BY kunnr.

        DATA: it_kna1 TYPE TABLE OF kna1.

        SELECT kunnr name1 name2 telf1 stras ort01 pstlz regio adrnr ort02
          FROM kna1
          INTO CORRESPONDING FIELDS OF TABLE it_kna1
          FOR ALL ENTRIES IN it_eqbs
          WHERE kunnr = it_eqbs-kunnr.

***        SELECT kunnr, name1, name2, telf1, stras, ort01, pstlz, regio, adrnr, ort02
***          FROM kna1
***          INTO TABLE @DATA(it_kna1)
***          FOR ALL ENTRIES IN @it_eqbs
***          WHERE kunnr = @it_eqbs-kunnr.

        IF sy-subrc IS INITIAL.

          SORT it_kna1 BY adrnr.

          DATA: it_adrc TYPE TABLE OF adrc.

          SELECT name1 street house_num1 addrnumber
            FROM adrc
            INTO CORRESPONDING FIELDS OF TABLE it_adrc
            FOR ALL ENTRIES IN it_kna1
            WHERE addrnumber = it_kna1-adrnr.

***          SELECT name1, street, house_num1, addrnumber
***            FROM adrc
***            INTO TABLE @DATA(it_adrc)
***            FOR ALL ENTRIES IN @it_kna1
***            WHERE addrnumber = @it_kna1-adrnr.

        ENDIF.

      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
        EXPORTING
          input  = c_ag
        IMPORTING
          output = lv_parvw.

      " Dados do cliente da aba parceiro
      DATA: it_equi TYPE TABLE OF equi.

      SELECT objnr equnr
        FROM equi
        INTO CORRESPONDING FIELDS OF TABLE it_equi
        FOR ALL ENTRIES IN it_equnr
        WHERE equnr = it_equnr-equnr.

***      SELECT objnr, equnr
***        FROM equi
***        INTO TABLE @DATA(it_equi)
***        FOR ALL ENTRIES IN @it_equnr
***        WHERE equnr = @it_equnr-equnr.

      IF sy-subrc IS INITIAL.

        SORT it_equi BY equnr.

        DATA: it_ihpa TYPE TABLE OF ihpa.

        SELECT objnr parvw counter parnr
          FROM ihpa
          INTO CORRESPONDING FIELDS OF TABLE it_ihpa
          FOR ALL ENTRIES IN it_equi
          WHERE objnr    = it_equi-objnr
            AND parvw    = lv_parvw
            AND kzloesch = space.

***        SELECT objnr, parvw, counter, parnr
***          FROM ihpa
***          INTO TABLE @DATA(it_ihpa)
***          FOR ALL ENTRIES IN @it_equi
***         WHERE objnr    = @it_equi-objnr
***           AND parvw    = @lv_parvw
***           AND kzloesch = @space.

        IF sy-subrc IS INITIAL.

          SORT it_ihpa_parceiro BY parnr.

*         Busca Equipamentos do Cliente

          SELECT objnr parvw counter parnr
            FROM ihpa
            INTO CORRESPONDING FIELDS OF TABLE it_ihpa_parceiro
            FOR ALL ENTRIES IN it_ihpa
            WHERE parvw    = lv_parvw
              AND obtyp    = c_ieq
              AND parnr    = it_ihpa-parnr
              AND kzloesch = space.

***          SELECT objnr parvw counter parnr
***            FROM ihpa
***            INTO TABLE it_ihpa_parceiro
***            FOR ALL ENTRIES IN it_ihpa
***            WHERE parvw    = lv_parvw
***              AND obtyp    = c_ieq
***              AND parnr    = it_ihpa-parnr
***              AND kzloesch = space.

          IF sy-subrc IS INITIAL.


            LOOP AT it_ihpa_parceiro ASSIGNING <fs_ihpa_kunnr>.     "GBE 01/09/2025 - Dump URLA.

              CLEAR: vl_kunnr, vl_parnr .

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = <fs_ihpa_kunnr>-parnr
                IMPORTING
                  output = vl_parnr.

              vl_kunnr = vl_parnr+2.

              <fs_ihpa_kunnr>-kunnr = vl_kunnr.

            ENDLOOP.


            DATA: it_kna1_parceiro TYPE TABLE OF kna1.

            SELECT kunnr name1 name2 telf1 ort01 pstlz regio adrnr ort02
              FROM kna1
              INTO CORRESPONDING FIELDS OF TABLE it_kna1_parceiro
              FOR ALL ENTRIES IN it_ihpa_parceiro
              WHERE kunnr = it_ihpa_parceiro-kunnr.            "it_ihpa_parceiro-parnr.     "GBE 01/09/2025 - Dump URLA

***            SELECT kunnr, name1, name2, telf1, ort01, pstlz, regio, adrnr, ort02
***              FROM kna1
***              INTO TABLE @DATA(it_kna1_parceiro)
***              FOR ALL ENTRIES IN @it_ihpa_parceiro
***              WHERE kunnr = @it_ihpa_parceiro-parnr.

            " Buscar o endereço completo comn 60 caracteres da ADRC
            IF sy-subrc IS INITIAL.

              SORT it_kna1_parceiro BY adrnr.

              DATA: it_adrc_parceiro TYPE TABLE OF adrc.

              SELECT name1 street house_num1 addrnumber
                FROM adrc
                INTO CORRESPONDING FIELDS OF TABLE it_adrc_parceiro
                FOR ALL ENTRIES IN it_kna1_parceiro
                WHERE addrnumber = it_kna1_parceiro-adrnr.

***              SELECT name1, street, house_num1, addrnumber
***                FROM adrc
***                INTO TABLE @DATA(it_adrc_parceiro)
***                FOR ALL ENTRIES IN @it_kna1_parceiro
***                WHERE addrnumber = @it_kna1_parceiro-adrnr.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

      SORT it_eqbs BY equnr.
      SORT it_kna1 BY kunnr.
      SORT it_adrc BY addrnumber.
      SORT it_equi BY equnr.
      SORT it_ihpa BY objnr.
      SORT it_ihpa_parceiro BY parnr.
      SORT it_kna1_parceiro BY kunnr.
      SORT it_adrc_parceiro BY addrnumber.

      FIELD-SYMBOLS: <fs_despacho> LIKE LINE OF gt_despacho,
                     <fs_eqbs>     LIKE LINE OF it_eqbs,
                     <fs_kna1>     LIKE LINE OF it_kna1,
                     <fs_adrc>     LIKE LINE OF it_adrc.

***   LOOP AT gt_despacho ASSIGNING FIELD-SYMBOL(<fs_despacho>).
      LOOP AT gt_despacho ASSIGNING <fs_despacho>.

***     READ TABLE it_eqbs ASSIGNING FIELD-SYMBOL(<fs_eqbs>) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
        READ TABLE it_eqbs ASSIGNING <fs_eqbs> WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.

        IF sy-subrc IS INITIAL.

***       READ TABLE it_kna1 ASSIGNING FIELD-SYMBOL(<fs_kna1>) WITH KEY kunnr = <fs_eqbs>-kunnr BINARY SEARCH.
          READ TABLE it_kna1 ASSIGNING <fs_kna1> WITH KEY kunnr = <fs_eqbs>-kunnr BINARY SEARCH.

          IF sy-subrc IS INITIAL.

***         <fs_despacho>-kunnr = |{ <fs_kna1>-kunnr ALPHA = OUT }|.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
              EXPORTING
                input  = <fs_kna1>-kunnr
              IMPORTING
                output = <fs_despacho>-kunnr.

            <fs_despacho>-name1 = <fs_kna1>-name1.
            <fs_despacho>-name2 = <fs_kna1>-name2.
            <fs_despacho>-telf1 = <fs_kna1>-telf1.
            <fs_despacho>-pstlz = <fs_kna1>-pstlz.

***         READ TABLE it_adrc ASSIGNING FIELD-SYMBOL(<fs_adrc>) WITH KEY addrnumber = <fs_kna1>-adrnr BINARY SEARCH.
            READ TABLE it_adrc ASSIGNING <fs_adrc> WITH KEY addrnumber = <fs_kna1>-adrnr BINARY SEARCH.

            IF sy-subrc IS INITIAL.

              <fs_despacho>-stras      = <fs_adrc>-street.
              <fs_despacho>-house_num1 = <fs_adrc>-house_num1.
              <fs_despacho>-ort01      = <fs_kna1>-ort01.
              <fs_despacho>-ort02      = <fs_kna1>-ort02.
              <fs_despacho>-regio      = <fs_kna1>-regio.

            ENDIF.

          ENDIF.

        ELSE.

***       READ TABLE it_equi ASSIGNING FIELD-SYMBOL(<fs_equi>) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
          FIELD-SYMBOLS: <fs_equi>          LIKE LINE OF it_equi,
                         <fs_ihpa>          LIKE LINE OF it_ihpa,
                         <fs_ihpa_parceiro> LIKE LINE OF it_ihpa_parceiro,
                         <fs_kna1_parceiro> LIKE LINE OF it_kna1_parceiro.

          DATA: wa_adrc_parceiro LIKE LINE OF it_adrc_parceiro.

***       READ TABLE it_equi ASSIGNING FIELD-SYMBOL(<fs_equi>) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
          READ TABLE it_equi ASSIGNING <fs_equi> WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.

          IF sy-subrc IS INITIAL.

***         READ TABLE it_ihpa ASSIGNING FIELD-SYMBOL(<fs_ihpa>) WITH KEY objnr = <fs_equi>-objnr BINARY SEARCH.
            READ TABLE it_ihpa ASSIGNING <fs_ihpa> WITH KEY objnr = <fs_equi>-objnr BINARY SEARCH.

            IF sy-subrc IS INITIAL.

***           READ TABLE it_ihpa_parceiro ASSIGNING FIELD-SYMBOL(<fs_ihpa_parceiro>) WITH KEY parnr = <fs_ihpa>-parnr BINARY SEARCH.
              READ TABLE it_ihpa_parceiro ASSIGNING <fs_ihpa_parceiro> WITH KEY parnr = <fs_ihpa>-parnr BINARY SEARCH.

              IF sy-subrc IS INITIAL.

***             READ TABLE it_kna1_parceiro ASSIGNING FIELD-SYMBOL(<fs_kna1_parceiro>) WITH KEY kunnr = <fs_ihpa_parceiro>-parnr BINARY SEARCH.
***             READ TABLE it_kna1_parceiro ASSIGNING <fs_kna1_parceiro> WITH KEY kunnr = <fs_ihpa_parceiro>-parnr BINARY SEARCH.
                READ TABLE it_kna1_parceiro ASSIGNING <fs_kna1_parceiro> WITH KEY kunnr = <fs_ihpa_parceiro>-kunnr BINARY SEARCH.    "GBE 01/09/2025 - Dump URLA.

                IF sy-subrc IS INITIAL.

***              <fs_despacho>-kunnr = |{ <fs_kna1_parceiro>-kunnr ALPHA = OUT }|.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = <fs_kna1_parceiro>-kunnr
                    IMPORTING
                      output = <fs_despacho>-kunnr.

                  <fs_despacho>-name1 = <fs_kna1_parceiro>-name1.
                  <fs_despacho>-name2 = <fs_kna1_parceiro>-name2.
                  <fs_despacho>-telf1 = <fs_kna1_parceiro>-telf1.
                  <fs_despacho>-pstlz = <fs_kna1_parceiro>-pstlz.

                  <fs_despacho>-ort01 = <fs_kna1_parceiro>-ort01.   "GBE 01/09/2025 - Dump URLA
                  <fs_despacho>-ort02 = <fs_kna1_parceiro>-ort02.   "GBE 01/09/2025 - Dump URLA
                  <fs_despacho>-regio = <fs_kna1_parceiro>-regio.   "GBE 01/09/2025 - Dump URLA

***               READ TABLE it_adrc_parceiro INTO DATA(wa_adrc_parceiro) WITH KEY addrnumber = <fs_kna1_parceiro>-adrnr BINARY SEARCH.
                  READ TABLE it_adrc_parceiro INTO wa_adrc_parceiro WITH KEY addrnumber = <fs_kna1_parceiro>-adrnr BINARY SEARCH.
                  IF sy-subrc EQ 0.

***               ENDIF.  "GBE 01/09/2025 - Dump URLA

                    <fs_despacho>-stras      = wa_adrc_parceiro-street.
                    <fs_despacho>-house_num1 = wa_adrc_parceiro-house_num1.
***                 <fs_despacho>-ort01      = <fs_kna1_parceiro>-ort01.   "GBE 01/09/2025 - Dump URLA
***                 <fs_despacho>-ort02      = <fs_kna1_parceiro>-ort02.   "GBE 01/09/2025 - Dump URLA
***                 <fs_despacho>-regio      = <fs_kna1_parceiro>-regio.   "GBE 01/09/2025 - Dump URLA

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

    it_despacho_out = gt_despacho.
    CLEAR wa_adrc_parceiro.

  ENDMETHOD.


  METHOD busca_endereco_cliente_tree.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: lv_parvw   TYPE ihpa-parvw.

    CONSTANTS: c_ag  TYPE ihpa-parvw VALUE 'SP',
               c_ieq TYPE ihpa-obtyp VALUE 'IEQ'.

    TYPES: BEGIN OF ty_ihpa_parceiro,
             objnr   TYPE ihpa-objnr,
             parvw   TYPE ihpa-parvw,
             counter TYPE ihpa-counter,
             parnr   TYPE ihpa-parnr,   "kna1-kunnr,    "gbe 01/09/2025 - Dump URLA
             kunnr   TYPE kna1-kunnr,                   "gbe 01/09/2025 - Dump URLA
           END OF ty_ihpa_parceiro.

    DATA: it_ihpa_parceiro TYPE TABLE OF ty_ihpa_parceiro.
    DATA: vl_kunnr TYPE kna1-kunnr,
          vl_parnr TYPE ihpa-parnr.

    FIELD-SYMBOLS: <fs_ihpa_kunnr> LIKE LINE OF it_ihpa_parceiro.

    IF it_despacho[] IS NOT INITIAL.

***   DATA(it_despacho_local) = it_despacho[].
      DATA: it_despacho_local TYPE /ptloms/ct080.   "Vidal 26/11/2024 - /ptloms/ct079
      it_despacho_local =  it_despacho[].           "Vidal 26/11/2024 - gt_despacho[].

      SORT it_despacho_local BY equnr.

***   DATA(it_equnr) = it_despacho_local.
      DATA: it_equnr TYPE /ptloms/ct080.   "Vidal 26/11/2024 - /ptloms/ct079.
      it_equnr = it_despacho_local.

      SORT it_equnr BY equnr.
      DELETE ADJACENT DUPLICATES FROM it_equnr COMPARING equnr.

      DATA: it_eqbs TYPE TABLE OF eqbs.

      SELECT kunnr equnr
        FROM eqbs
        INTO CORRESPONDING FIELDS OF TABLE it_eqbs
        FOR ALL ENTRIES IN it_equnr
        WHERE equnr = it_equnr-equnr.

***      SELECT kunnr, equnr
***        FROM eqbs
***        INTO TABLE @DATA(it_eqbs)
***        FOR ALL ENTRIES IN @it_equnr
***        WHERE equnr = @it_equnr-equnr.

      IF sy-subrc IS INITIAL.

        SORT it_eqbs BY kunnr.

        DATA: it_kna1 TYPE TABLE OF kna1.

        SELECT kunnr name1 name2 telf1 stras ort01 pstlz regio adrnr ort02
          FROM kna1
          INTO CORRESPONDING FIELDS OF TABLE it_kna1
          FOR ALL ENTRIES IN it_eqbs
          WHERE kunnr = it_eqbs-kunnr.

***        SELECT kunnr, name1, telf1, stras, ort01, pstlz, regio, adrnr, ort02
***          FROM kna1
***          INTO TABLE @DATA(it_kna1)
***          FOR ALL ENTRIES IN @it_eqbs
***          WHERE kunnr = @it_eqbs-kunnr.

        IF sy-subrc IS INITIAL.

          SORT it_kna1 BY adrnr.

          DATA: it_adrc TYPE TABLE OF adrc.

          SELECT name1 street house_num1 addrnumber
            FROM adrc
            INTO CORRESPONDING FIELDS OF TABLE it_adrc
            FOR ALL ENTRIES IN it_kna1
            WHERE addrnumber = it_kna1-adrnr.

***          SELECT name1, street, house_num1, addrnumber
***            FROM adrc
***            INTO TABLE @DATA(it_adrc)
***            FOR ALL ENTRIES IN @it_kna1
***            WHERE addrnumber = @it_kna1-adrnr.

        ENDIF.

      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
        EXPORTING
          input  = c_ag
        IMPORTING
          output = lv_parvw.

      " Dados do cliente da aba parceiro
      DATA: it_equi TYPE TABLE OF equi.

      SELECT objnr equnr
        FROM equi
        INTO CORRESPONDING FIELDS OF TABLE it_equi
        FOR ALL ENTRIES IN it_equnr
        WHERE equnr = it_equnr-equnr.

***      SELECT objnr, equnr
***        FROM equi
***        INTO TABLE @DATA(it_equi)
***        FOR ALL ENTRIES IN @it_equnr
***        WHERE equnr = @it_equnr-equnr.

      IF sy-subrc IS INITIAL.

        SORT it_equi BY equnr.

        DATA: it_ihpa TYPE TABLE OF ihpa.

        SELECT objnr parvw counter parnr
          FROM ihpa
          INTO CORRESPONDING FIELDS OF TABLE it_ihpa
          FOR ALL ENTRIES IN it_equi
          WHERE objnr    = it_equi-objnr
            AND parvw    = lv_parvw
            AND kzloesch = space.

***        SELECT objnr, parvw, counter, parnr
***          FROM ihpa
***          INTO TABLE @DATA(it_ihpa)
***          FOR ALL ENTRIES IN @it_equi
***         WHERE objnr    = @it_equi-objnr
***           AND parvw    = @lv_parvw
***           AND kzloesch = @space.

        IF sy-subrc IS INITIAL.

          SORT it_ihpa_parceiro BY parnr.

*        Busca Equipamentos do Cliente
          SELECT objnr parvw counter parnr
            FROM ihpa
            INTO CORRESPONDING FIELDS OF TABLE it_ihpa_parceiro
            FOR ALL ENTRIES IN it_ihpa
            WHERE parvw    = lv_parvw
              AND obtyp    = c_ieq
              AND parnr    = it_ihpa-parnr
              AND kzloesch = space.

***          SELECT objnr parvw counter parnr
***            FROM ihpa
***            INTO TABLE it_ihpa_parceiro
***            FOR ALL ENTRIES IN it_ihpa
***            WHERE parvw    = lv_parvw
***              AND obtyp    = c_ieq
***              AND parnr    = it_ihpa-parnr
***              AND kzloesch = space.

          IF sy-subrc IS INITIAL.


            LOOP AT it_ihpa_parceiro ASSIGNING <fs_ihpa_kunnr>.       "GBE 01/09/2025 - Dump URLA.

              CLEAR: vl_kunnr, vl_parnr .

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = <fs_ihpa_kunnr>-parnr
                IMPORTING
                  output = vl_parnr.

              vl_kunnr = vl_parnr+2.

              <fs_ihpa_kunnr>-kunnr = vl_kunnr.

            ENDLOOP.


            DATA: it_kna1_parceiro TYPE TABLE OF kna1.

            SELECT kunnr name1 name2 telf1 ort01 pstlz regio adrnr ort02
              FROM kna1
              INTO CORRESPONDING FIELDS OF TABLE it_kna1_parceiro
              FOR ALL ENTRIES IN it_ihpa_parceiro
              WHERE kunnr = it_ihpa_parceiro-kunnr.            "it_ihpa_parceiro-parnr.     "GBE 01/09/2025 - Dump URLA

***            SELECT kunnr, name1, telf1, ort01, pstlz, regio, adrnr, ort02
***              FROM kna1
***              INTO TABLE @DATA(it_kna1_parceiro)
***              FOR ALL ENTRIES IN @it_ihpa_parceiro
***              WHERE kunnr = @it_ihpa_parceiro-parnr.

            " Buscar o endereço completo comn 60 caracteres da ADRC
            IF sy-subrc IS INITIAL.

              SORT it_kna1_parceiro BY adrnr.

              DATA: it_adrc_parceiro TYPE TABLE OF adrc.

              SELECT name1 street house_num1 addrnumber
                FROM adrc
                INTO CORRESPONDING FIELDS OF TABLE it_adrc_parceiro
                FOR ALL ENTRIES IN it_kna1_parceiro
                WHERE addrnumber = it_kna1_parceiro-adrnr.

***              SELECT name1, street, house_num1, addrnumber
***                FROM adrc
***                INTO TABLE @DATA(it_adrc_parceiro)
***                FOR ALL ENTRIES IN @it_kna1_parceiro
***                WHERE addrnumber = @it_kna1_parceiro-adrnr.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

      SORT it_eqbs BY equnr.
      SORT it_kna1 BY kunnr.
      SORT it_adrc BY addrnumber.
      SORT it_equi BY equnr.
      SORT it_ihpa BY objnr.
      SORT it_ihpa_parceiro BY parnr.
      SORT it_kna1_parceiro BY kunnr.
      SORT it_adrc_parceiro BY addrnumber.


      FIELD-SYMBOLS: <fs_despacho> LIKE LINE OF it_despacho,
                     <fs_eqbs>     LIKE LINE OF it_eqbs,
                     <fs_kna1>     LIKE LINE OF it_kna1,
                     <fs_adrc>     LIKE LINE OF it_adrc.

***   LOOP AT it_despacho ASSIGNING FIELD-SYMBOL(<fs_despacho>).
      LOOP AT it_despacho ASSIGNING <fs_despacho>.

***     READ TABLE it_eqbs ASSIGNING FIELD-SYMBOL(<fs_eqbs>) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
        READ TABLE it_eqbs ASSIGNING <fs_eqbs> WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.

        IF sy-subrc IS INITIAL.

***       READ TABLE it_kna1 ASSIGNING FIELD-SYMBOL(<fs_kna1>) WITH KEY kunnr = <fs_eqbs>-kunnr BINARY SEARCH.
          READ TABLE it_kna1 ASSIGNING <fs_kna1> WITH KEY kunnr = <fs_eqbs>-kunnr BINARY SEARCH.

          IF sy-subrc IS INITIAL.

***         <fs_despacho>-kunnr = |{ <fs_kna1>-kunnr ALPHA = OUT }|.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
              EXPORTING
                input  = <fs_kna1>-kunnr
              IMPORTING
                output = <fs_despacho>-kunnr.

            <fs_despacho>-name1 = <fs_kna1>-name1.
            <fs_despacho>-telf1 = <fs_kna1>-telf1.

***         READ TABLE it_adrc ASSIGNING FIELD-SYMBOL(<fs_adrc>) WITH KEY addrnumber = <fs_kna1>-adrnr BINARY SEARCH.
            READ TABLE it_adrc ASSIGNING <fs_adrc> WITH KEY addrnumber = <fs_kna1>-adrnr BINARY SEARCH.

            IF sy-subrc IS INITIAL.

              <fs_despacho>-stras      = <fs_adrc>-street.
              <fs_despacho>-house_num1 = <fs_adrc>-house_num1.
              <fs_despacho>-ort01      = <fs_kna1>-ort01.
              <fs_despacho>-ort02      = <fs_kna1>-ort02.
              <fs_despacho>-regio      = <fs_kna1>-regio.

            ENDIF.

          ENDIF.

        ELSE.

          FIELD-SYMBOLS: <fs_equi>          LIKE LINE OF it_equi,
                         <fs_ihpa>          LIKE LINE OF it_ihpa,
                         <fs_ihpa_parceiro> LIKE LINE OF it_ihpa_parceiro,
                         <fs_kna1_parceiro> LIKE LINE OF it_kna1_parceiro.

          DATA: wa_adrc_parceiro LIKE LINE OF it_adrc_parceiro.

***       READ TABLE it_equi ASSIGNING FIELD-SYMBOL(<fs_equi>) WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.
          READ TABLE it_equi ASSIGNING <fs_equi> WITH KEY equnr = <fs_despacho>-equnr BINARY SEARCH.

          IF sy-subrc IS INITIAL.

***         READ TABLE it_ihpa ASSIGNING FIELD-SYMBOL(<fs_ihpa>) WITH KEY objnr = <fs_equi>-objnr BINARY SEARCH.
            READ TABLE it_ihpa ASSIGNING <fs_ihpa> WITH KEY objnr = <fs_equi>-objnr BINARY SEARCH.

            IF sy-subrc IS INITIAL.

***           READ TABLE it_ihpa_parceiro ASSIGNING FIELD-SYMBOL(<fs_ihpa_parceiro>) WITH KEY parnr = <fs_ihpa>-parnr BINARY SEARCH.
              READ TABLE it_ihpa_parceiro ASSIGNING <fs_ihpa_parceiro> WITH KEY parnr = <fs_ihpa>-parnr BINARY SEARCH.

              IF sy-subrc IS INITIAL.

***             READ TABLE it_kna1_parceiro ASSIGNING FIELD-SYMBOL(<fs_kna1_parceiro>) WITH KEY kunnr = <fs_ihpa_parceiro>-parnr BINARY SEARCH.
***             READ TABLE it_kna1_parceiro ASSIGNING <fs_kna1_parceiro> WITH KEY kunnr = <fs_ihpa_parceiro>-parnr BINARY SEARCH.
                READ TABLE it_kna1_parceiro ASSIGNING <fs_kna1_parceiro> WITH KEY kunnr = <fs_ihpa_parceiro>-kunnr BINARY SEARCH.    "GBE 01/09/2025 - Dump URLA.

                IF sy-subrc IS INITIAL.

***               <fs_despacho>-kunnr = |{ <fs_kna1_parceiro>-kunnr ALPHA = OUT }|.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = <fs_kna1_parceiro>-kunnr
                    IMPORTING
                      output = <fs_despacho>-kunnr.

                  <fs_despacho>-name1 = <fs_kna1_parceiro>-name1.
                  <fs_despacho>-telf1 = <fs_kna1_parceiro>-telf1.

                  <fs_despacho>-ort01 = <fs_kna1_parceiro>-ort01.   "GBE 01/09/2025 - Dump URLA
                  <fs_despacho>-ort02 = <fs_kna1_parceiro>-ort02.   "GBE 01/09/2025 - Dump URLA
                  <fs_despacho>-regio = <fs_kna1_parceiro>-regio.   "GBE 01/09/2025 - Dump URLA

***               READ TABLE it_adrc_parceiro INTO DATA(wa_adrc_parceiro) WITH KEY addrnumber = <fs_kna1_parceiro>-adrnr BINARY SEARCH.
                  READ TABLE it_adrc_parceiro INTO wa_adrc_parceiro WITH KEY addrnumber = <fs_kna1_parceiro>-adrnr BINARY SEARCH.
                  IF sy-subrc EQ 0.

***               ENDIF.  "GBE 01/09/2025 - Dump URLA

                    <fs_despacho>-stras      = wa_adrc_parceiro-street.
                    <fs_despacho>-house_num1 = wa_adrc_parceiro-house_num1.
***                 <fs_despacho>-ort01      = <fs_kna1_parceiro>-ort01.   "GBE 01/09/2025 - Dump URLA
***                 <fs_despacho>-ort02      = <fs_kna1_parceiro>-ort02.   "GBE 01/09/2025 - Dump URLA
***                 <fs_despacho>-regio      = <fs_kna1_parceiro>-regio.   "GBE 01/09/2025 - Dump URLA

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD constructor.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Renato Costa
*********************************************************************************************************

    DATA: ls_werks      LIKE LINE OF s_werks,
          ls_aufnr      LIKE LINE OF s_aufnr,
          ls_vornr      LIKE LINE OF s_vornr,
          ls_auart      LIKE LINE OF s_auart,
          ls_qmnum      LIKE LINE OF s_qmnum,
          ls_priok      LIKE LINE OF s_priok,
          ls_tplnr      LIKE LINE OF s_tplnr,
          ls_equnr      LIKE LINE OF s_equnr,
          ls_iwerk      LIKE LINE OF s_iwerk,
          ls_ingpr      LIKE LINE OF s_ingpr,
          ls_ilart      LIKE LINE OF s_ilart,
          ls_gewrk      LIKE LINE OF s_gewrk,
          "ls_gstrp      LIKE LINE OF s_gstrp,
          ls_gstrp      LIKE LINE OF s_gstrp,
          ls_datope     LIKE LINE OF s_datope,
          ls_usuapp     LIKE LINE OF s_usuapp,
          ls_usuperfil  LIKE LINE OF s_usuperfil,
          ls_objid      LIKE LINE OF r_objid,
          ls_gstrp_ini  LIKE LINE OF s_gstrp,
          ls_datope_ini LIKE LINE OF s_datope,
          ls_gstrp_fim  LIKE LINE OF s_gstrp,
          ls_datope_fim LIKE LINE OF s_datope,
          ls_vlsch      LIKE LINE OF s_vlsch,
          ls_ernam      LIKE LINE OF s_ernam.

    DATA ls_werks_aux LIKE LINE OF rt_werks.
*Monta Range S_WERKS
    LOOP AT rt_werks INTO ls_werks_aux.
      CLEAR ls_werks.
      MOVE-CORRESPONDING ls_werks_aux TO ls_werks.
      APPEND ls_werks TO s_werks.
    ENDLOOP.

    DATA ls_aufnr_aux LIKE LINE OF rt_werks.
*Monta Range S_AUFNR
    LOOP AT rt_aufnr INTO ls_aufnr_aux.
      CLEAR ls_aufnr.
      MOVE-CORRESPONDING ls_aufnr_aux TO ls_aufnr.
      "    ls_aufnr-low = |{ ls_aufnr-low ALPHA = IN }|.
      "    ls_aufnr-high = |{ ls_aufnr-high ALPHA = IN }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_aufnr-low
        IMPORTING
          output = ls_aufnr-low.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_aufnr-high
        IMPORTING
          output = ls_aufnr-high.

      APPEND ls_aufnr TO s_aufnr.
    ENDLOOP.

    DATA ls_vornr_aux LIKE LINE OF rt_vornr.
*Monta Range S_VORNR
    LOOP AT rt_vornr INTO ls_vornr_aux.
      CLEAR ls_vornr.
      MOVE-CORRESPONDING ls_vornr_aux TO ls_vornr.
      APPEND ls_vornr TO s_vornr.
    ENDLOOP.

    DATA ls_auart_aux LIKE LINE OF rt_auart.
*Monta Range S_AUART
    LOOP AT rt_auart INTO ls_auart_aux.
      CLEAR ls_auart.
      MOVE-CORRESPONDING ls_auart_aux TO ls_auart.
      APPEND ls_auart TO s_auart.
    ENDLOOP.

    DATA ls_qmnum_aux LIKE LINE OF rt_qmnum.
*Monta Range S_QMNUM
    LOOP AT rt_qmnum INTO ls_qmnum_aux.
      CLEAR ls_qmnum.
      MOVE-CORRESPONDING ls_qmnum_aux TO ls_qmnum.
      "   ls_qmnum-low = |{ ls_qmnum-low ALPHA = IN }|.
      "   ls_qmnum-high = |{ ls_qmnum-high ALPHA = IN }|.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_qmnum-low
        IMPORTING
          output = ls_qmnum-low.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_qmnum-high
        IMPORTING
          output = ls_qmnum-high.

      APPEND ls_qmnum TO s_qmnum.
    ENDLOOP.

    DATA ls_priok_aux LIKE LINE OF rt_priok.
*Monta Range S_PRIOK
    LOOP AT rt_priok INTO ls_priok_aux.
      CLEAR ls_priok.
      MOVE-CORRESPONDING ls_priok_aux TO ls_priok.
      APPEND ls_priok TO s_priok.
    ENDLOOP.

    DATA ls_tplnr_aux LIKE LINE OF rt_tplnr.
*Monta Range S_TPLNR
    LOOP AT rt_tplnr INTO ls_tplnr_aux.
      CLEAR ls_tplnr.
      MOVE-CORRESPONDING ls_tplnr_aux TO ls_tplnr.
      APPEND ls_tplnr TO s_tplnr.
    ENDLOOP.

    DATA ls_equnr_aux LIKE LINE OF rt_equnr.
*Monta Range S_EQUNR
    LOOP AT rt_equnr INTO ls_equnr_aux.
      CLEAR ls_equnr.
      MOVE-CORRESPONDING ls_equnr_aux TO ls_equnr.
      "   ls_equnr-low = |{ ls_equnr-low ALPHA = IN }|.
      "   ls_equnr-high = |{ ls_equnr-high ALPHA = IN }|.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_equnr-low
        IMPORTING
          output = ls_equnr-low.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_equnr-high
        IMPORTING
          output = ls_equnr-high.
      APPEND ls_equnr TO s_equnr.
    ENDLOOP.

    DATA ls_iwerk_aux LIKE LINE OF rt_iwerk.
*Monta Range S_IWERK
    LOOP AT rt_iwerk INTO ls_iwerk_aux.
      CLEAR ls_iwerk.
      MOVE-CORRESPONDING ls_iwerk_aux TO ls_iwerk.
      APPEND ls_iwerk TO s_iwerk.
    ENDLOOP.

    DATA ls_ingpr_aux LIKE LINE OF rt_ingpr.
*Monta Range S_INGPR
    LOOP AT rt_ingpr INTO ls_ingpr_aux.
      CLEAR ls_ingpr.
      MOVE-CORRESPONDING ls_ingpr_aux TO ls_ingpr.
      APPEND ls_ingpr TO s_ingpr.
    ENDLOOP.

    DATA ls_ilart_aux LIKE LINE OF rt_ilart.
*Monta Range S_ILART
    LOOP AT rt_ilart INTO ls_ilart_aux.
      CLEAR ls_ilart.
      MOVE-CORRESPONDING ls_ilart_aux TO ls_ilart.
      APPEND ls_ilart TO s_ilart.
    ENDLOOP.

    DATA ls_gewrk_aux LIKE LINE OF rt_gewrk.
*Monta Range S_GEWRK
    LOOP AT rt_gewrk INTO ls_gewrk_aux.
      CLEAR ls_gewrk.
      MOVE-CORRESPONDING ls_gewrk_aux TO ls_gewrk.
      APPEND ls_gewrk TO s_gewrk.
    ENDLOOP.

    DATA ls_gstrp_aux LIKE LINE OF rt_gstrp.
*Monta Range S_GSTRP
    LOOP AT rt_gstrp INTO ls_gstrp_aux.
      CLEAR ls_gstrp.
      MOVE-CORRESPONDING ls_gstrp_aux TO ls_gstrp.
      APPEND ls_gstrp TO s_gstrp.
    ENDLOOP.

    DATA ls_datope_aux LIKE LINE OF rt_datope.
*Monta Range S_DATOPE
    LOOP AT rt_datope INTO ls_datope_aux.
      CLEAR ls_datope.
      MOVE-CORRESPONDING ls_datope_aux TO ls_datope.
      APPEND ls_datope TO s_datope.
    ENDLOOP.

    DATA ls_usuapp_aux LIKE LINE OF rt_usuapp.
*Monta Range S_USUAPP
    LOOP AT rt_usuapp INTO ls_usuapp_aux.
      CLEAR ls_usuapp.
      MOVE-CORRESPONDING ls_usuapp_aux TO ls_usuapp.
      APPEND ls_usuapp TO s_usuapp.
    ENDLOOP.

*Monta Range S_USUPERFIL
***    LOOP AT rt_usuperfil INTO DATA(ls_usuperfil_aux).
***      CLEAR ls_usuperfil.
***      MOVE-CORRESPONDING ls_usuperfil_aux TO ls_usuperfil.
***      APPEND ls_usuperfil TO s_usuperfil.
***    ENDLOOP.

    DATA ls_vlsch_aux LIKE LINE OF rt_vlsch.

    LOOP AT rt_vlsch INTO ls_vlsch_aux.
      CLEAR ls_vlsch.
      MOVE-CORRESPONDING ls_vlsch_aux TO ls_vlsch.
      APPEND ls_vlsch TO s_vlsch.
    ENDLOOP.

    DATA ls_ernam_aux LIKE LINE OF rt_ernam.

    LOOP AT rt_ernam INTO ls_ernam_aux.
      CLEAR ls_ernam.
      MOVE-CORRESPONDING ls_ernam_aux TO ls_ernam.
      APPEND ls_ernam TO s_ernam.
    ENDLOOP.

    DATA ls_ini LIKE LINE OF rt_gstrp_ini.
    DATA ls_fim LIKE LINE OF rt_gstrp_fim.
    IF rt_gstrp_ini[] IS NOT INITIAL AND
       rt_gstrp_fim[] IS NOT INITIAL.

      READ TABLE rt_gstrp_ini INTO ls_ini INDEX 1.
      READ TABLE rt_gstrp_fim INTO ls_fim INDEX 1.
      ls_gstrp-sign   = 'I'.
      ls_gstrp-option = 'BT'.
      " ls_gstrp-low    = rt_gstrp_ini[ 1 ]-low.
      " ls_gstrp-high   = rt_gstrp_fim[ 1 ]-low.
      ls_gstrp-low    = ls_ini-low.
      ls_gstrp-high   = ls_fim-low.

      APPEND ls_gstrp TO s_gstrp.

    ENDIF.

    DATA ls_gstrp_aux_ini LIKE LINE OF rt_gstrp_ini.
*Monta Range S_GSTRP
    LOOP AT rt_gstrp_ini INTO ls_gstrp_aux_ini.
      CLEAR ls_gstrp_ini.
      MOVE-CORRESPONDING ls_gstrp_aux_ini TO ls_gstrp_ini.
      APPEND ls_gstrp_ini TO s_gstrp.
    ENDLOOP.

    DATA ls_gstrp_aux_fim LIKE LINE OF rt_gstrp_fim.
*Monta Range S_GSTRP
    LOOP AT rt_gstrp_fim INTO ls_gstrp_aux_fim.
      CLEAR ls_gstrp_fim.
      MOVE-CORRESPONDING ls_gstrp_aux_fim TO ls_gstrp_fim.
      APPEND ls_gstrp_fim TO s_gstrp_fim.
    ENDLOOP.

    DATA ls_dta_ini LIKE LINE OF rt_datope_ini.
    DATA ls_dta_fim LIKE LINE OF rt_datope_fim.
*Monta Range S_DATOPE
    IF rt_datope_ini[] IS NOT INITIAL AND
       rt_datope_fim[] IS NOT INITIAL.

      READ TABLE rt_datope_ini INTO ls_dta_ini INDEX 1.
      READ TABLE rt_datope_fim INTO ls_dta_fim INDEX 1.
      ls_datope-sign   = 'I'.
      ls_datope-option = 'BT'.
*      ls_datope-low    = rt_datope_ini[ 1 ]-low.
*      ls_datope-high   = rt_datope_fim[ 1 ]-low.
      ls_datope-low    = ls_dta_ini-low.
      ls_datope-high   = ls_dta_fim-low.

      APPEND ls_datope TO s_datope.

    ENDIF.

    DATA ls_datope_aux_ini LIKE LINE OF rt_datope_ini.

    LOOP AT rt_datope_ini INTO ls_datope_aux_ini.
      CLEAR ls_datope_ini.
      MOVE-CORRESPONDING ls_datope_aux_ini TO ls_datope_ini.
      APPEND ls_datope_ini TO s_datope_ini.
    ENDLOOP.

    DATA ls_datope_aux_fim LIKE LINE OF rt_datope_fim.

*Monta Range S_DATOPE_FIM
    LOOP AT rt_datope_fim INTO ls_datope_aux_fim.
      CLEAR ls_datope_fim.
      MOVE-CORRESPONDING ls_datope_aux_fim TO ls_datope_fim.
      APPEND ls_datope_fim TO s_datope_fim.
    ENDLOOP.

    p_f_tree = im_f_tree.
    p_mat_at = im_mat_at.
    p_oper   = im_oper.
    p_ordens = im_ordens.

    DATA lt_crhd TYPE TABLE OF crhd.
    DATA ls_crhd LIKE LINE OF lt_crhd.
* Monta Range R_OBJID
    IF s_gewrk[] IS NOT INITIAL.
*      SELECT objty, objid, arbpl, werks
*        FROM crhd
*        INTO TABLE lt_crhd
*        WHERE arbpl IN s_gewrk
*          AND werks IN @s_werks.

      LOOP AT lt_crhd INTO ls_crhd.
        CLEAR ls_objid.
        ls_objid-sign = 'I'.
        ls_objid-option = 'EQ'.
        ls_objid-low = ls_crhd-objid.
        APPEND ls_objid TO r_objid.
      ENDLOOP.
    ENDIF.

    gv_datum = sy-datum.
    gv_uzeit = gv_uzeit.

  ENDMETHOD.


  METHOD desassociar.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

* Declaração de tabela interna
    DATA: lt_return_assoc_mat   TYPE STANDARD TABLE OF bapiret2,
          lt_return_status_oper TYPE STANDARD TABLE OF bapiret2.
    DATA: lt_tb026              TYPE TABLE OF /ptloms/tb026.
    DATA: ls_tb026              LIKE LINE OF lt_tb026.
    DATA: lt_tb033              TYPE TABLE OF /ptloms/tb033.
    DATA: ls_tb033              LIKE LINE OF lt_tb033.
    DATA: it_ordem              TYPE /ptloms/ct104.
    DATA: lt_afvc               TYPE TABLE OF afvc.
    DATA: lt_afvc_aux           TYPE TABLE OF afvc.

* Declaração de Variáveis
    DATA: lv_aufnr    TYPE aufnr,
          lv_vornr    TYPE vornr,
          lv_usuario  TYPE xubname,
          lv_suboper  TYPE uvorn,
          lt_operacao	TYPE /ptloms/ct058,
          ls_operacao TYPE /ptloms/et058,
          ls_afvc     LIKE LINE OF lt_afvc.

    DATA: ls_ordem LIKE LINE OF it_ordem.

    DATA: lv_aufpl TYPE afko-aufpl.

* Declaração de Estrutura
    DATA: ls_026 TYPE /ptloms/tb026.

    IF im_ordem IS INITIAL.
      RETURN.
    ENDIF.

    it_ordem = im_ordem.

    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF ls_tb033
      FROM  /ptloms/tb033.

    SORT it_ordem BY aufnr vornr.
    DELETE ADJACENT DUPLICATES FROM it_ordem COMPARING aufnr vornr.

    FIELD-SYMBOLS: <fs_ordem> LIKE LINE OF it_ordem.
    LOOP AT it_ordem ASSIGNING <fs_ordem>.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_ordem>-aufnr
        IMPORTING
          output = <fs_ordem>-aufnr.
    ENDLOOP.

    IF ls_tb033-cesto IS INITIAL.

* Seleciona Ordens associadas
      SELECT aufnr vornr suboper usuario data_associacao hora_associacao
        FROM /ptloms/tb026
        INTO CORRESPONDING FIELDS OF TABLE lt_tb026
        FOR ALL ENTRIES IN it_ordem
        WHERE aufnr = it_ordem-aufnr.

    ELSE.

      READ TABLE it_ordem INTO ls_ordem INDEX 1.

      SELECT aufnr vornr suboper usuario data_associacao hora_associacao
        FROM /ptloms/tb026
        INTO CORRESPONDING FIELDS OF TABLE lt_tb026
        FOR ALL ENTRIES IN it_ordem
        WHERE aufnr = it_ordem-aufnr
          AND usuario = ls_ordem-usuario_origem.

    ENDIF.

    SORT lt_tb026 BY aufnr ASCENDING vornr ASCENDING data_associacao DESCENDING hora_associacao DESCENDING.

    LOOP AT it_ordem INTO ls_ordem.

* Busca roteiro da ordem
      IF ls_ordem-vornr IS NOT INITIAL.

        ls_operacao-activity = ls_ordem-vornr.
        ls_operacao-usuario  = ls_ordem-usuario_origem.
        APPEND ls_operacao TO lt_operacao.

      ELSE.

* Busca roteiro da ordem
        SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = ls_ordem-aufnr.

        IF sy-subrc EQ 0.
* Busca todas as operações da Ordem

          SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
            FROM afvc AS a
            INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
            INTO CORRESPONDING FIELDS OF TABLE lt_afvc
            WHERE a~aufpl = lv_aufpl
              AND a~phflg = space.


          lt_afvc_aux = lt_afvc.

*          lt_operacao = CORRESPONDING #( lt_afvc MAPPING activity = vornr ).
          CLEAR ls_afvc.
          LOOP AT lt_afvc INTO ls_afvc.
            MOVE-CORRESPONDING ls_afvc TO ls_operacao.
            ls_operacao-activity = ls_afvc-vornr.
            APPEND ls_operacao TO lt_operacao.
            CLEAR: ls_afvc, ls_operacao.
          ENDLOOP.

          FIELD-SYMBOLS: <fs_operacao> LIKE LINE OF lt_operacao.
          LOOP AT lt_operacao ASSIGNING <fs_operacao>.
            <fs_operacao>-usuario = ls_ordem-usuario_origem.
          ENDLOOP.

        ENDIF.

      ENDIF.

      LOOP AT lt_operacao ASSIGNING <fs_operacao>.

        MOVE-CORRESPONDING ls_ordem TO ls_026.

        ls_026-usuario              = ls_ordem-usuario_origem.
        ls_026-data_desassociacao   = sy-datum.
        ls_026-hora_desassociacao   = sy-uzeit.
        ls_026-motivo_desassociacao = ls_ordem-motivo_desassociacao.
        ls_026-desassociado         = 'X'.
        ls_026-vornr                = <fs_operacao>-activity.

        " Verificar o registro associado mais recente - 28/02/2023

        READ TABLE lt_tb026 INTO ls_tb026 WITH KEY aufnr = ls_ordem-aufnr vornr = <fs_operacao>-activity.
        IF sy-subrc EQ 0.
          ls_026-data_associacao = ls_tb026-data_associacao.
          ls_026-hora_associacao = ls_tb026-hora_associacao.
        ENDIF.

        MODIFY /ptloms/tb026 FROM ls_026.

        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
*          DATA(lv_erro) = 'X'.
          DATA: lv_erro TYPE char1.
          lv_erro = 'X'.
          ROLLBACK WORK.
        ENDIF.

        IF lv_erro IS INITIAL.

* Ordem
*          lv_aufnr = |{ ls_ordem-aufnr ALPHA = IN }|.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_ordem-aufnr
            IMPORTING
              output = lv_aufnr.


* Operação
          CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
            EXPORTING
              input  = <fs_operacao>-activity
            IMPORTING
              output = lv_vornr.

* Sub-Operação
*        lv_suboper = ls_ordem-suboper.

          CLEAR lv_usuario.

* Associa Matrícula à Operação

          IF ls_tb033-cesto IS INITIAL.

            CALL FUNCTION '/PTLOMS/MF036'
              EXPORTING
                im_aufnr       = ls_ordem-aufnr
                im_vornr       = <fs_operacao>-activity
                im_usuario     = ls_ordem-usuario_origem
                im_desassociar = 'X'
              TABLES
                it_return      = lt_return_assoc_mat.

            APPEND LINES OF lt_return_assoc_mat TO re_retorno.

          ENDIF.

          lv_usuario = ls_ordem-usuario_origem.

* Atualiza status da operação
          CALL FUNCTION '/PTLOMS/MF007'
            EXPORTING
              im_aufnr            = ls_ordem-aufnr
              im_vornr            = <fs_operacao>-activity
              im_suboper          = lv_suboper
*             im_usuario_mobile   = ls_ordem-usuario_destino
              im_usuario_mobile   = lv_usuario
              im_date_ini         = sy-datum
              im_time_ini         = sy-uzeit
              im_date_fim         = sy-datum
              im_time_fim         = sy-uzeit
              im_dev_reason       = space
              im_fin_conf         = space
              im_despacho_anulado = 'X'
            TABLES
              it_return           = lt_return_status_oper.

          APPEND LINES OF lt_return_status_oper TO re_retorno.

        ENDIF.

        CLEAR: lt_return_assoc_mat, lt_return_status_oper.

      ENDLOOP.

      CLEAR: lt_operacao.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_user.

    IF p_user IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE nome
      FROM /ptloms/tb013
      INTO p_user_name
      WHERE usuario = p_user.


  ENDMETHOD.


  METHOD ler_bloqueio_ordem.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: lv_garg     TYPE seqg3-garg,
          it_itab_enq TYPE TABLE OF seqg3,
          lv_number   TYPE sy-tabix.

    CONCATENATE sy-mandt im_ordem INTO lv_garg.

    CALL FUNCTION 'ENQUEUE_READ'
      EXPORTING
        gclient               = sy-mandt
        gname                 = 'AUFK'
        garg                  = lv_garg
        guname                = '*'
*       LOCAL                 = ' '
*       FAST                  = ' '
*       GARGNOWC              = ' '
      IMPORTING
        number                = lv_number
*       SUBRC                 =
      TABLES
        enq                   = it_itab_enq
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
*    Implement suitable error handling here
    ENDIF.

    IF lv_number > 0.

***   READ TABLE it_itab_enq ASSIGNING FIELD-SYMBOL(<fs_enq>) INDEX 1.
      FIELD-SYMBOLS: <fs_enq> LIKE LINE OF it_itab_enq.
      READ TABLE it_itab_enq ASSIGNING <fs_enq> INDEX 1.

      IF sy-subrc IS INITIAL.

        iv_uname = <fs_enq>-guname.

      ENDIF.

      subrc = 4.

    ENDIF.

  ENDMETHOD.


  METHOD liberar_ordem.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

* Declaração de Tabela Interna
    DATA: lt_return_lib_ordem TYPE STANDARD TABLE OF bapiret2,
          wl_return           TYPE bapiret2,
          lv_aufnr            TYPE aufnr,
          lv_line             TYPE bsvx-sttxt.

    DATA: ls_ordem LIKE LINE OF im_ordem.

    LOOP AT im_ordem INTO ls_ordem.

* Libera Ordem
      CALL FUNCTION '/PTLOMS/MF051'
        EXPORTING
          im_aufnr  = ls_ordem-aufnr
        TABLES
          it_return = lt_return_lib_ordem.

      APPEND LINES OF lt_return_lib_ordem TO re_retorno.

      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
          client           = sy-mandt
          flg_user_stat    = ' '
          objnr            = ls_ordem-objnr
          spras            = sy-langu
        IMPORTING
          line             = lv_line
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CLEAR wl_return.
*      lv_aufnr = |{ ls_ordem-aufnr ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = ls_ordem-aufnr
        IMPORTING
          output = lv_aufnr.

      wl_return-message_v1 = lv_aufnr.

      READ TABLE lt_return_lib_ordem TRANSPORTING NO FIELDS WITH KEY type = 'E'.

      IF sy-subrc IS INITIAL.

        wl_return-type = 'E'.
        wl_return-message = |{ 'Ordem:'(021) }| & | | & |{ lv_aufnr }|.

      ELSE.

        wl_return-type = 'S'.
        wl_return-message = |{ 'Ordem:'(021) }| & | | & |{ lv_aufnr }| & | | & |{ 'liberada com sucesso'(024) }|.

      ENDIF.

      wl_return-id         = 'OMS'.
      wl_return-message_v3 = lv_line.
      APPEND wl_return TO re_retorno.

      CLEAR: lt_return_lib_ordem, lv_line.

    ENDLOOP.

  ENDMETHOD.


  METHOD transferir.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

    DATA: lv_erro    TYPE flag,
          lt_ordem   TYPE /ptloms/ct104,
          lt_retorno TYPE bapiret2_t,
          lv_aufnr   TYPE caufv-aufnr.

    DATA im_ordem_aux TYPE /ptloms/ct104.
    im_ordem_aux = im_ordem.
*    DATA(im_ordem_aux) = im_ordem.

    DATA: o_oms TYPE REF TO /ptloms/cl008.

    CREATE OBJECT o_oms.

    CLEAR: im_ordem.

    FIELD-SYMBOLS: <fs_ordem> LIKE LINE OF im_ordem_aux.
    LOOP AT im_ordem_aux ASSIGNING <fs_ordem>.

* Atualiza campos relativo à associação
*      atualiza_desassociacao( EXPORTING im_ordem = <fs_ordem> CHANGING ch_erro = lv_erro ).

      CALL METHOD o_oms->atualiza_desassociacao
        EXPORTING
          im_ordem = <fs_ordem>
        CHANGING
          ch_erro  = lv_erro.

      IF lv_erro IS INITIAL.

* Desassociar Matrícula do Usuário na Ordem/Operação
*        associa_mat_operacao( EXPORTING im_ordem = <fs_ordem> im_remove = abap_true CHANGING ch_erro = lv_erro ch_retorno = re_retorno ).
        CALL METHOD o_oms->associa_mat_operacao
          EXPORTING
            im_ordem   = <fs_ordem>
            im_remove  = abap_true
          CHANGING
            ch_erro    = lv_erro
            ch_retorno = re_retorno.

        APPEND <fs_ordem> TO lt_ordem.

*        associar( CHANGING im_ordem = lt_ordem RECEIVING re_retorno = lt_retorno ).
        CALL METHOD /ptloms/cl008=>associar
          EXPORTING
            im_ordem   = lt_ordem
          IMPORTING
            re_retorno = lt_retorno
            em_ordem   = lt_ordem.


        APPEND LINES OF lt_ordem TO em_ordem.

        APPEND LINES OF lt_retorno TO re_retorno.

        CLEAR: lt_ordem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validar_associar.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

* Declaração de Tabelas Interna
    DATA: lt_operacao	       TYPE /ptloms/ct058,
          ls_operacao        TYPE /ptloms/et058,
          lt_return_despacho TYPE STANDARD TABLE OF bapiret2,
          lt_message         TYPE STANDARD TABLE OF bapiret2,
          ls_retorno         TYPE bapiret2,
          lv_aufnr           TYPE aufnr,
          usuario            TYPE /ptloms/et119-usuario_destino,
          lt_ordem           TYPE /ptloms/ct104,
          ls_ordem           TYPE /ptloms/et119,
          tt_ordem           TYPE /ptloms/ct104,
          ls_ordem_aux       TYPE /ptloms/et119.

    DATA: it_afko TYPE TABLE OF afko.
    DATA: lt_afvc TYPE TABLE OF afvc.
    DATA: lt_026  TYPE TABLE OF /ptloms/tb026.
    DATA: ls_033  TYPE /ptloms/tb033.

    FIELD-SYMBOLS: <fs_afko> LIKE LINE OF it_afko.
    FIELD-SYMBOLS: <fs_afvc> LIKE LINE OF lt_afvc.
    FIELD-SYMBOLS: <fs_026> LIKE LINE OF lt_026.

    lt_ordem = im_ordem.

    REFRESH tt_ordem.

    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_033 FROM  /ptloms/tb033.

*    DATA(usuario) = VALUE #( im_ordem[ 1 ]-usuario_destino OPTIONAL ).

    READ TABLE lt_ordem INTO ls_ordem INDEX 1.
    IF sy-subrc IS INITIAL.
      usuario = ls_ordem-usuario_destino.
    ENDIF.

    IF usuario IS NOT INITIAL.

      validar_permissao_usuario(
        EXPORTING
          im_usuario             = usuario
        EXCEPTIONS
          erro_usuario_permissao = 1
          OTHERS                 = 2 ).

      IF sy-subrc IS NOT INITIAL.

        ls_retorno = 'E'.
        ls_retorno-message = 'Usuário não possui configuração para associar matrícula.'(023).
        APPEND ls_retorno TO re_retorno.
        RETURN.

      ENDIF.

    ENDIF.

    DATA: lt_ordem_aux TYPE /ptloms/ct104.

*    lt_ordem_aux = CORRESPONDING #( lt_ordem ).
*    MOVE-CORRESPONDING lt_ordem TO lt_ordem_aux.
    LOOP AT lt_ordem INTO ls_ordem.
      MOVE-CORRESPONDING ls_ordem TO ls_ordem_aux.
      APPEND ls_ordem_aux TO lt_ordem_aux.
    ENDLOOP.

    SORT lt_ordem_aux BY aufnr.
    DELETE ADJACENT DUPLICATES FROM lt_ordem_aux COMPARING aufnr.

* Busca roteiro da ordem
    SELECT aufnr aufpl
      FROM afko
      INTO CORRESPONDING FIELDS OF TABLE it_afko
      FOR ALL ENTRIES IN lt_ordem_aux
      WHERE aufnr = lt_ordem_aux-aufnr.

    IF sy-subrc EQ 0.
* Busca todas as operações da Ordem
      SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
        FROM afvc AS a
        INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
        INTO CORRESPONDING FIELDS OF TABLE lt_afvc
        FOR ALL ENTRIES IN it_afko
        WHERE a~aufpl = it_afko-aufpl
          AND a~phflg = space.

    ENDIF.

    SELECT *
      FROM /ptloms/tb026
      INTO CORRESPONDING FIELDS OF TABLE lt_026
      FOR ALL ENTRIES IN lt_ordem
      WHERE aufnr = lt_ordem-aufnr
        AND desassociado = space.

    SORT lt_026 BY aufnr vornr.

    FIELD-SYMBOLS: <fs_ordem> LIKE LINE OF lt_ordem.
    LOOP AT lt_ordem ASSIGNING <fs_ordem>.

      IF NOT <fs_ordem>-status_sis CS 'LIB'.

        ls_retorno-type       = 'E'.
*        lv_aufnr = |{ <fs_ordem>-aufnr ALPHA = OUT }|.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = <fs_ordem>-aufnr
          IMPORTING
            output = lv_aufnr.

*        ls_retorno-message    = |{ 'Ordem'(010) }| & | | & |{ <fs_ordem>-aufnr ALPHA = OUT }| & | | & |{ 'não está liberada'(083) }|.
        CONCATENATE 'Ordem' lv_aufnr 'não está liberada' INTO ls_retorno-message SEPARATED BY space.
*        ls_retorno-message_v3 = |{ text-021 }| & | | & |{ <fs_ordem>-aufnr }|.
        CONCATENATE text-021 lv_aufnr INTO ls_retorno-message_v3 SEPARATED BY space.
        ls_retorno-parameter  = 'ABER'.
        APPEND ls_retorno TO re_retorno.
        EXIT.

      ENDIF.

    ENDLOOP.

    IF ls_033-cesto IS INITIAL.

      IF re_retorno IS INITIAL.

        LOOP AT it_afko ASSIGNING <fs_afko>.

          LOOP AT lt_afvc ASSIGNING <fs_afvc> WHERE aufpl = <fs_afko>-aufpl.

            READ TABLE lt_026 ASSIGNING <fs_026> WITH KEY aufnr = <fs_afko>-aufnr
                                                                        vornr = <fs_afvc>-vornr
                                                                BINARY SEARCH.

            IF sy-subrc IS INITIAL.

              READ TABLE lt_ordem ASSIGNING <fs_ordem> WITH KEY aufnr = <fs_026>-aufnr
                                                                vornr = <fs_026>-vornr.

              IF sy-subrc IS INITIAL.

*Begin of change - Sidney Vidal - 10.09.2024 19:12:29
                <fs_ordem>-data_associacao = <fs_026>-data_associacao.
                <fs_ordem>-hora_associacao = <fs_026>-hora_associacao.
*Ended of change - Sidney Vidal - 10.09.2024 19:12:29

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = <fs_ordem>-aufnr
                  IMPORTING
                    output = lv_aufnr.

                ls_retorno-type       = 'E'.
*              lv_aufnr              = |{ <fs_afko>-aufnr ALPHA = OUT }|.
                ls_retorno-id         = '/PTLOMS/CM001'.
                ls_retorno-message_v1 = lv_aufnr.
                ls_retorno-message_v2 = <fs_afvc>-vornr.
                ls_retorno-number     = '008'.
                ls_retorno-parameter  = <fs_026>-usuario.
*                ls_retorno-message_v3  = <fs_026>-matricula.
                DATA: ls_013 TYPE /ptloms/tb013.
                SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_013 FROM /ptloms/tb013 WHERE usuario EQ <fs_026>-usuario.
                ls_retorno-field = ls_013-matricula.
*              ls_retorno-message    = |{ 'Ordem'(010) }| & | | & |{ lv_aufnr }| & | | & |{ 'já associada para operação'(082) }| & | | & |{ <fs_afvc>-vornr }|.
                CONCATENATE 'Ordem' lv_aufnr 'já associada para operação' <fs_afvc>-vornr '. Favor atualizar o relatório' INTO ls_retorno-message SEPARATED BY space.
*              ls_retorno-message_v3 = |{ text-021 }| & | | & |{ <fs_afko>-aufnr ALPHA = OUT }|.
                CONCATENATE text-021 <fs_afko>-aufnr INTO ls_retorno-message_v3 SEPARATED BY space.
*              ls_retorno-message_v4 = |{ text-022 }| & | | & |{ <fs_afvc>-vornr }|.
                CONCATENATE text-022 <fs_afvc>-vornr INTO ls_retorno-message_v4 SEPARATED BY space.
                APPEND ls_retorno TO re_retorno.

*Begin of change - Sidney Vidal - 11.09.2024 14:30:49
                APPEND  <fs_ordem>  TO tt_ordem.
*Ended of change - Sidney Vidal - 11.09.2024 14:30:49

                " Eliminar a ordem já associada
                IF <fs_afvc>-vornr IS INITIAL.

                  DELETE lt_ordem WHERE aufnr = <fs_ordem>-aufnr.
                  EXIT.

                ELSE.

                  DELETE lt_ordem WHERE aufnr = <fs_ordem>-aufnr AND
                                        vornr = <fs_afvc>-vornr.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDLOOP.

        ENDLOOP.

        IF  tt_ordem[]   IS NOT INITIAL.
          REFRESH em_ordem.
          em_ordem       =  tt_ordem.
        ENDIF.

      ENDIF.

    ELSE.

      IF re_retorno IS INITIAL.

        LOOP AT it_afko ASSIGNING <fs_afko>.

          LOOP AT lt_afvc ASSIGNING <fs_afvc> WHERE aufpl = <fs_afko>-aufpl.

            READ TABLE lt_026 ASSIGNING <fs_026> WITH KEY aufnr = <fs_afko>-aufnr
                                                          vornr = <fs_afvc>-vornr
                                                          usuario = usuario
                                                                BINARY SEARCH.

            IF sy-subrc IS INITIAL.

              READ TABLE lt_ordem ASSIGNING <fs_ordem> WITH KEY aufnr = <fs_026>-aufnr
                                                                vornr = <fs_026>-vornr.

              IF sy-subrc IS INITIAL.

*Begin of change - Sidney Vidal - 10.09.2024 19:12:29
                <fs_ordem>-data_associacao = <fs_026>-data_associacao.
                <fs_ordem>-hora_associacao = <fs_026>-hora_associacao.
*Ended of change - Sidney Vidal - 10.09.2024 19:12:29

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = <fs_ordem>-aufnr
                  IMPORTING
                    output = lv_aufnr.

                ls_retorno-type       = 'E'.
*              lv_aufnr              = |{ <fs_afko>-aufnr ALPHA = OUT }|.
                ls_retorno-id         = '/PTLOMS/CM001'.
                ls_retorno-message_v1 = lv_aufnr.
                ls_retorno-message_v2 = <fs_afvc>-vornr.
                ls_retorno-number     = '008'.
*              ls_retorno-message    = |{ 'Ordem'(010) }| & | | & |{ lv_aufnr }| & | | & |{ 'já associada para operação'(082) }| & | | & |{ <fs_afvc>-vornr }|.
                CONCATENATE 'Ordem' lv_aufnr '/ operação' <fs_afvc>-vornr ' já associada para usuario ' usuario INTO ls_retorno-message SEPARATED BY space.
*              ls_retorno-message_v3 = |{ text-021 }| & | | & |{ <fs_afko>-aufnr ALPHA = OUT }|.
                CONCATENATE text-021 <fs_afko>-aufnr INTO ls_retorno-message_v3 SEPARATED BY space.
*              ls_retorno-message_v4 = |{ text-022 }| & | | & |{ <fs_afvc>-vornr }|.
                CONCATENATE text-022 <fs_afvc>-vornr INTO ls_retorno-message_v4 SEPARATED BY space.
                APPEND ls_retorno TO re_retorno.

*Begin of change - Sidney Vidal - 11.09.2024 14:30:49
                APPEND  <fs_ordem>  TO tt_ordem.
*Ended of change - Sidney Vidal - 11.09.2024 14:30:49

                " Eliminar a ordem já associada
                IF <fs_afvc>-vornr IS INITIAL.

                  DELETE lt_ordem WHERE aufnr = <fs_afko>-aufnr.
                  EXIT.

                ELSE.

                  DELETE lt_ordem WHERE aufnr = <fs_afko>-aufnr AND
                                        vornr = <fs_afvc>-vornr.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDLOOP.

        ENDLOOP.

        IF  tt_ordem[]   IS NOT INITIAL.
          REFRESH em_ordem.
          em_ordem       =  tt_ordem.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD validar_dessasociacao.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de Tabelas Interna
    DATA: lt_operacao	       TYPE /ptloms/ct058,
          ls_operacao        TYPE /ptloms/et058,
          lt_return_despacho TYPE STANDARD TABLE OF bapiret2,
          lt_message         TYPE STANDARD TABLE OF bapiret2,
          ls_retorno         TYPE bapiret2,
          lv_aufnr           TYPE aufnr,
          lt_tb033           TYPE TABLE OF /ptloms/tb033,
          ls_tb033           LIKE LINE OF lt_tb033.

    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_tb033 FROM  /ptloms/tb033.

*    SELECT usuario UP TO 1 ROWS
*    FROM /ptloms/tb026
*    INTO @DATA(usuario)
*    WHERE aufnr        = @im_ordem-aufnr
*      AND vornr        = @im_ordem-vornr
*      AND desassociado = @abap_false
*      ORDER BY usuario ASCENDING,
*               aufnr           ASCENDING,
*               vornr           ASCENDING,
*               suboper         ASCENDING,
*               data_associacao ASCENDING,
*               hora_associacao ASCENDING.
*    ENDSELECT.

    DATA usuario      TYPE /ptloms/tb026-usuario.
    CLEAR usuario.

    IF ls_tb033-cesto IS INITIAL.

      SELECT usuario    UP TO 1 ROWS
                         INTO usuario
                         FROM /ptloms/tb026
        WHERE aufnr        EQ im_ordem-aufnr
          AND vornr        EQ im_ordem-vornr
          AND desassociado EQ abap_false
                     ORDER BY usuario         ASCENDING
                              aufnr           ASCENDING
                              vornr           ASCENDING
                              suboper         ASCENDING
                              data_associacao ASCENDING
                              hora_associacao ASCENDING.
      ENDSELECT.

    ELSE.

      SELECT usuario    UP TO 1 ROWS
                         INTO usuario
                         FROM /ptloms/tb026
        WHERE aufnr        EQ im_ordem-aufnr
          AND vornr        EQ im_ordem-vornr
          AND usuario      EQ  im_ordem-usuario
          AND desassociado EQ abap_false
                     ORDER BY usuario         ASCENDING
                              aufnr           ASCENDING
                              vornr           ASCENDING
                              suboper         ASCENDING
                              data_associacao ASCENDING
                              hora_associacao ASCENDING.
      ENDSELECT.

    ENDIF.


    IF sy-subrc IS INITIAL.

      IF usuario <> im_ordem-usuario.


        ls_retorno-type       = 'E'.

*        lv_aufnr              = |{ im_ordem-aufnr ALPHA = OUT }|.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = im_ordem-aufnr
          IMPORTING
            output = lv_aufnr.

        ls_retorno-id         = '/PTLOMS/CM001'.
        ls_retorno-message_v1 = lv_aufnr.
        ls_retorno-message_v2 = im_ordem-vornr.
        ls_retorno-number     = '010'.

*        ls_retorno-message    = |{ 'Ordem'(010) }| & | | & |{ lv_aufnr }| & | | & |{ 'oper.'(087) }| & | | & |{ im_ordem-vornr }| & | | & |{ 'não associada p/ usuário selecionado. Atualizar relatório.'(086) }|.
        CONCATENATE 'Ordem' lv_aufnr 'oper.' im_ordem-vornr 'não associada p/ usuário selecionado. Atualizar relatório.'
               INTO ls_retorno-message SEPARATED BY space.

*        ls_retorno-message_v3 = |{ text-021 }| & | | & |{ im_ordem-aufnr ALPHA = OUT }|.
        CONCATENATE text-021 lv_aufnr INTO ls_retorno-message_v3 SEPARATED BY space.

*        ls_retorno-message_v4 = |{ text-022 }| & | | & |{ im_ordem-vornr }|.
        CONCATENATE text-022 im_ordem-vornr INTO ls_retorno-message_v4 SEPARATED BY space.

        APPEND ls_retorno TO re_retorno.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD validar_permissao_usuario.

    " Busca dados do usuário
    DATA: ls_013 TYPE /ptloms/tb013.

    SELECT SINGLE usuario associa matricula
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF ls_013
      WHERE usuario = im_usuario.

***    SELECT SINGLE usuario, associa, matricula
***      FROM /ptloms/tb013
***      INTO @DATA(ls_013)
***      WHERE usuario = @im_usuario.

    IF sy-subrc IS INITIAL.

*     Verifica se no cadastro do usuário está configura para associar a Matrícula à Operação
      IF ls_013-associa IS INITIAL.

        MESSAGE e005(/ptloms/cm001) WITH im_usuario RAISING erro_usuario_permissao.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD validar_transferencia.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declaração de Tabelas Interna
    DATA: lt_operacao	       TYPE /ptloms/ct058,
          ls_operacao        TYPE /ptloms/et058,
          lt_return_despacho TYPE STANDARD TABLE OF bapiret2,
          lt_message         TYPE STANDARD TABLE OF bapiret2,
          ls_retorno         TYPE bapiret2,
          lv_aufnr           TYPE aufnr.

*    SELECT usuario UP TO 1 ROWS
*    FROM /ptloms/tb026
*    INTO @DATA(usuario)
*    WHERE aufnr        = @im_ordem-aufnr
*      AND vornr        = @im_ordem-vornr
*      AND desassociado = @space
*      ORDER BY usuario ASCENDING,
*               aufnr           ASCENDING,
*               vornr           ASCENDING,
*               suboper         ASCENDING,
*               data_associacao ASCENDING,
*               hora_associacao ASCENDING.
*    ENDSELECT.

    DATA usuario      TYPE /ptloms/tb026-usuario.
    CLEAR usuario.
    SELECT usuario    UP TO 1 ROWS
                       INTO usuario
                       FROM /ptloms/tb026
      WHERE aufnr        EQ im_ordem-aufnr
        AND vornr        EQ im_ordem-vornr
        AND desassociado EQ abap_false
                   ORDER BY usuario         ASCENDING
                            aufnr           ASCENDING
                            vornr           ASCENDING
                            suboper         ASCENDING
                            data_associacao ASCENDING
                            hora_associacao ASCENDING.
    ENDSELECT.

    IF sy-subrc IS INITIAL.

      IF usuario <> im_ordem-usuario.

        ls_retorno-type       = 'E'.

*        lv_aufnr              = |{ im_ordem-aufnr ALPHA = OUT }|.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = im_ordem-aufnr
          IMPORTING
            output = lv_aufnr.

        ls_retorno-id         = '/PTLOMS/CM001'.
        ls_retorno-message_v1 = lv_aufnr.
        ls_retorno-message_v2 = im_ordem-vornr.
        ls_retorno-number     = '009'.

*        ls_retorno-message    = |{ 'Ordem'(010) }| & | | & |{ lv_aufnr }| & | | & |{ 'oper.'(087) }| & | | & |{ im_ordem-vornr }| & | | & |{ 'possui outro usuário associado. Atualizar relatório.'(085) }|.
        CONCATENATE 'Ordem' lv_aufnr 'oper.' im_ordem-vornr 'possui outro usuário associado. Atualizar relatório.'
               INTO ls_retorno-message SEPARATED BY space.

*        ls_retorno-message_v3 = |{ text-021 }| & | | & |{ im_ordem-aufnr ALPHA = OUT }|.
        CONCATENATE text-021 lv_aufnr INTO ls_retorno-message_v3 SEPARATED BY space.

*        ls_retorno-message_v4 = |{ text-022 }| & | | & |{ im_ordem-vornr }|.
        CONCATENATE text-022 im_ordem-vornr INTO ls_retorno-message_v4 SEPARATED BY space.

        APPEND ls_retorno TO re_retorno.

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
