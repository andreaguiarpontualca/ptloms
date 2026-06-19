*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/RP003                                     *
*& Transação       : /PTLOMS/PTLOMSN006                                *
*& Objetivo        : Relatório para Status das Operações               *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
REPORT /ptloms/rp003.
************************************************************************
***  Prograna REVISADO em 06/05/2024 em função da
***  incompatibilidade de versão com a SOLAR.
************************************************************************
***  Consultora ABAP - Nádia Rodrigues
************************************************************************

*&---------------------------------------------------------------------*
*& Tables
*&---------------------------------------------------------------------*
TABLES: viaufks,
        /ptloms/tb031.

*&---------------------------------------------------------------------*
*& Tipos
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_alv,
         aufnr           TYPE /ptloms/tb031-aufnr,
         vornr           TYPE /ptloms/tb031-vornr,
         suboper         TYPE /ptloms/tb031-suboper,
         usuario         TYPE /ptloms/tb031-usuario,
         nome            TYPE /ptloms/tb013-nome,
         data_ini        TYPE /ptloms/tb031-data_ini,
         hora_ini        TYPE /ptloms/tb031-hora_ini,
*         data_fim        TYPE /ptloms/tb031-data_fim,
*         hora_fim        TYPE /ptloms/tb031-hora_fim,
         status          TYPE val_text, "/ptloms/tb031-status,
         data_inativacao TYPE /ptloms/tb031-data_inativacao,
         hora_inativacao TYPE /ptloms/tb031-hora_inativacao,
         inativo         TYPE /ptloms/tb031-inativo,
         auart           TYPE viaufks-auart,
         arbpl           TYPE crhd-arbpl,    " Descrição Centro de Trabalho
         gstrp           TYPE viaufks-gstrp, " Data base Início
         gltrp           TYPE viaufks-gltrp, " Data base Fim
         ktext           TYPE viaufks-ktext, " Texto Breve
         iwerk           TYPE viaufks-iwerk, " Centro Planejamento
         ingpr           TYPE viaufks-ingpr, " Grupo Planejamento
         tplnr           TYPE viaufks-tplnr, " Local de Instalãção
         pltxt           TYPE iflotx-pltxt,  " Desc.Local de inst.
         equnr           TYPE viaufks-equnr, " Equipamento
         eqktx           TYPE v_equi-eqktx,  " Descrição do Equipamento
         status_usu      TYPE j_stext,       " Status de Usuário
         status_sis      TYPE j_stext,       " Status de Sistema
         grund           TYPE trug-grund,    " Causa do desvio
         grdtx           TYPE trugt-grdtx,   " Descrição Causa do desvio
         stort           TYPE itob-stort,    " Localização
         eqfnr           TYPE itob-eqfnr,    " Ordenação
         anlnr           TYPE itob-anlnr,    " Imobilizado
         anlun           TYPE itob-anlun,    " Sub número imobilizado
       END OF ty_alv.

*&---------------------------------------------------------------------*
*& Taabelas Interna
*&---------------------------------------------------------------------*
DATA: gt_dados TYPE STANDARD TABLE OF ty_alv,
      gt_alv   TYPE STANDARD TABLE OF ty_alv.

*----------------------------------------------------------------------*
* Definições de variavéis
*----------------------------------------------------------------------*
DATA: gv_okcode TYPE sy-tcode.

*----------------------------------------------------------------------*
* Definições para o alv
*----------------------------------------------------------------------*
CLASS lcl_handle_events      DEFINITION DEFERRED.

DATA:
  o_alv           TYPE REF TO cl_salv_table,
  o_status        TYPE REF TO cl_salv_functions,
  o_columns       TYPE REF TO cl_salv_columns_table,
  o_column        TYPE REF TO cl_salv_column_table,
  o_events        TYPE REF TO cl_salv_events_table,
  o_handle_events TYPE REF TO lcl_handle_events,
  o_container     TYPE REF TO cl_gui_custom_container,
  o_selections    TYPE REF TO cl_salv_selections,
  o_layout        TYPE REF TO cl_salv_layout,
  st_key          TYPE salv_s_layout_key,
  g_default       TYPE sap_bool,
  o_rows          TYPE salv_t_row.

*----------------------------------------------------------------------*
* Definição da classe local lcl_handle_events
*----------------------------------------------------------------------*
CLASS lcl_handle_events DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS clique_duplo FOR EVENT double_click  "Clique duplo no alv
                OF cl_salv_events_table
      IMPORTING row column.                                 "#EC NEEDED

    METHODS clique_alv   FOR EVENT link_click    "Link, hotspot ou botão no alv
                OF cl_salv_events_table
      IMPORTING row column.                                 "#EC NEEDED

    METHODS user_command FOR EVENT added_function
                OF cl_salv_events_table
      IMPORTING e_salv_function.
ENDCLASS.                    "lcl_handle_events DEFINITION

*----------------------------------------------------------------------*
* Implementação da classe local lcl_handle_events
*----------------------------------------------------------------------*
CLASS lcl_handle_events IMPLEMENTATION.

  METHOD clique_duplo.
  ENDMETHOD.                    "clique_duplo

  METHOD clique_alv.

*    READ TABLE gt_alv INTO DATA(ls_alv) INDEX row.
    DATA ls_alv LIKE LINE OF gt_alv.
    READ TABLE gt_alv INTO ls_alv INDEX row.
    IF sy-subrc EQ 0.
      SET PARAMETER ID 'ANR' FIELD ls_alv-aufnr.
      CALL TRANSACTION 'IW32' AND SKIP FIRST SCREEN.
    ENDIF.

  ENDMETHOD.                    "clique_link

  METHOD user_command.

    CASE e_salv_function.
      WHEN 'ATUALIZA'.
        PERFORM f_start USING ''.
      WHEN OTHERS.
    ENDCASE.

    o_alv->refresh( ) .
  ENDMETHOD.                    "user_command

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION

*&---------------------------------------------------------------------*
*& Tela de Seleção
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_aufnr FOR viaufks-aufnr,
                s_auart FOR viaufks-auart,
                s_qmnum FOR viaufks-qmnum,
                s_priok FOR viaufks-priok,
                s_tplnr FOR viaufks-tplnr,
                s_equnr FOR viaufks-equnr,
                s_iwerk FOR viaufks-iwerk, "Centro de Planejamento
                s_ingpr FOR viaufks-ingpr, "Grupo de Planejamento
                s_ilart FOR viaufks-ilart, "Tipo de atividade de manutenção
                s_gewrk FOR viaufks-gewrk MATCHCODE OBJECT /ptloms/sh002, " Centro de Trabalho
                s_gstrp FOR viaufks-gstrp OBLIGATORY. "Data Base Início

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
SELECT-OPTIONS: s_usuapp FOR /ptloms/tb031-usuario MATCHCODE OBJECT /ptloms/sh001,
                s_status FOR /ptloms/tb031-status.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_inat AS CHECKBOX DEFAULT ''.
SELECTION-SCREEN END OF BLOCK b2.

*&---------------------------------------------------------------------*
*& Processamento Principal
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_start USING 'X'.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  F_START
*&---------------------------------------------------------------------*
FORM f_start USING p_carrega_tela_inicial TYPE char1.

  PERFORM f_limpa_dados.
  PERFORM f_verifica_permissao.
  PERFORM f_busca_dados.
  PERFORM f_monta_dados.

  IF p_carrega_tela_inicial = 'X'.
    PERFORM f_mostra_alv.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DADOS
*&---------------------------------------------------------------------*
FORM f_busca_dados .

  DATA: lt_values_tab TYPE STANDARD TABLE OF dd07v.

  DATA: ls_dados LIKE LINE OF gt_dados.

  DATA: lv_objnr TYPE viaufks-objnr,
        lv_stsma TYPE jsto-stsma,
        lv_stonr TYPE tj30-stonr.

* Busca Status das Operações
*  SELECT a~aufnr, a~vornr, a~suboper, a~usuario, a~data_ini, a~hora_ini, a~data_fim,
*         a~hora_fim, a~status, a~data_inativacao, a~hora_inativacao, a~inativo,
*         b~auart, " Tipo de Ordem
*         b~gewrk, " ID Centro de Trabalho
*         b~gstrp, " Data base Início
*         b~gltrp, " Data base Fim
*         b~ktext, " Texto Breve
*         b~iwerk, " Centro Planejamento
*         b~ingpr, " Grupo Planejamento
*         b~tplnr, " Local de Instalãção
*         b~equnr, " Equipamento
*         b~objnr  " Objnr
*    FROM /ptloms/tb031 AS a INNER JOIN viaufks AS b ON b~aufnr = a~aufnr
*    INTO TABLE @DATA(lt_tb031)
*    WHERE a~aufnr   IN @s_aufnr
*      AND a~status  IN @s_status
*      AND a~usuario IN @s_usuapp
*      AND b~auart   IN @s_auart
*      AND b~priok   IN @s_priok
*      AND b~qmnum   IN @s_qmnum
*      AND b~tplnr   IN @s_tplnr
*      AND b~equnr   IN @s_equnr
*      AND b~iwerk   IN @s_iwerk
*      AND b~ingpr   IN @s_ingpr
*      AND b~ilart   IN @s_ilart
*      AND b~gstrp   IN @s_gstrp
*      AND b~gewrk   IN @s_gewrk.
  TYPES: BEGIN OF ty_tb031,
           aufnr           TYPE /ptloms/tb031-aufnr,
           vornr           TYPE /ptloms/tb031-vornr,
           suboper         TYPE /ptloms/tb031-suboper,
           usuario         TYPE /ptloms/tb031-usuario,
           data_ini        TYPE /ptloms/tb031-data_ini,
           hora_ini        TYPE /ptloms/tb031-hora_ini,
           data_fim        TYPE /ptloms/tb031-data_fim,
           hora_fim        TYPE /ptloms/tb031-hora_fim,
           status          TYPE /ptloms/tb031-status,
           data_inativacao TYPE /ptloms/tb031-data_inativacao,
           hora_inativacao TYPE /ptloms/tb031-hora_inativacao,
           inativo         TYPE /ptloms/tb031-inativo,
           conf_cnt        TYPE /ptloms/tb031-conf_cnt,
           auart           TYPE viaufks-auart,
           gewrk           TYPE viaufks-gewrk,
           gstrp           TYPE viaufks-gstrp,
           gltrp           TYPE viaufks-gltrp,
           ktext           TYPE viaufks-ktext,
           iwerk           TYPE viaufks-iwerk,
           ingpr           TYPE viaufks-ingpr,
           tplnr           TYPE viaufks-tplnr,
           equnr           TYPE viaufks-equnr,
           objnr           TYPE viaufks-objnr,
         END OF ty_tb031.
  DATA lt_tb031 TYPE TABLE OF ty_tb031.
  SELECT a~aufnr a~vornr a~suboper a~usuario a~data_ini a~hora_ini a~data_fim
         a~hora_fim a~status a~data_inativacao a~hora_inativacao a~inativo
         a~conf_cnt "Contador
         b~auart " Tipo de Ordem
         b~gewrk " ID Centro de Trabalho
         b~gstrp " Data base Início
         b~gltrp " Data base Fim
         b~ktext " Texto Breve
         b~iwerk " Centro Planejamento
         b~ingpr " Grupo Planejamento
         b~tplnr " Local de Instalãção
         b~equnr " Equipamento
         b~objnr  " Objnr
    FROM /ptloms/tb031 AS a INNER JOIN viaufks AS b ON b~aufnr = a~aufnr
    INTO TABLE lt_tb031
    WHERE a~aufnr   IN s_aufnr
      AND a~status  IN s_status
      AND a~usuario IN s_usuapp
      AND b~auart   IN s_auart
      AND b~priok   IN s_priok
      AND b~qmnum   IN s_qmnum
      AND b~tplnr   IN s_tplnr
      AND b~equnr   IN s_equnr
      AND b~iwerk   IN s_iwerk
      AND b~ingpr   IN s_ingpr
      AND b~ilart   IN s_ilart
      AND b~gstrp   IN s_gstrp
      AND b~gewrk   IN s_gewrk.

* Verifica se vamos considerar os registos inativos
  IF p_inat IS INITIAL.
    DELETE lt_tb031 WHERE inativo = 'X'.
  ENDIF.

  IF lt_tb031[] IS NOT INITIAL.
* Seleciona descrição dos Locais de Instalação
*    SELECT tplnr, pltxt
*      FROM iflotx
*      INTO TABLE @DATA(lt_iflotx)
*      FOR ALL ENTRIES IN @lt_tb031
*      WHERE spras = @sy-langu
*        AND tplnr = @lt_tb031-tplnr.
    TYPES: BEGIN OF ty_iflotx,
             tplnr TYPE iflotx-tplnr,
             pltxt TYPE iflotx-pltxt,
           END OF ty_iflotx.
    DATA lt_iflotx TYPE TABLE OF ty_iflotx.
    SELECT tplnr pltxt
      FROM iflotx
      INTO TABLE lt_iflotx
      FOR ALL ENTRIES IN lt_tb031
      WHERE spras = sy-langu
        AND tplnr = lt_tb031-tplnr.

* Seleciona descrição dos equipamentos e local de instalação do equipamento
*    SELECT equnr, eqktx, stort, eqfnr, anlnr, anlun
*      FROM v_equi
*      INTO TABLE @DATA(lt_v_equi)
*      FOR ALL ENTRIES IN @lt_tb031
*      WHERE txasp EQ 'X'
*        AND owner EQ @space
*        AND spras EQ @sy-langu
*        AND equnr EQ @lt_tb031-equnr
*        AND datab <= @sy-datum
*        AND datbi >= @sy-datum.
    TYPES: BEGIN OF ty_v_equi,
             equnr TYPE v_equi-equnr,
             eqktx TYPE v_equi-eqktx,
             stort TYPE v_equi-stort,
             eqfnr TYPE v_equi-eqfnr,
             anlnr TYPE v_equi-anlnr,
             anlun TYPE v_equi-anlun,
           END OF ty_v_equi.
    DATA lt_v_equi TYPE TABLE OF ty_v_equi.
    SELECT equnr eqktx stort eqfnr anlnr anlun
      FROM v_equi
      INTO TABLE lt_v_equi
      FOR ALL ENTRIES IN lt_tb031
      WHERE txasp EQ 'X'
        AND owner EQ space
        AND spras EQ sy-langu
        AND equnr EQ lt_tb031-equnr
        AND datab <= sy-datum
        AND datbi >= sy-datum.

    SORT lt_v_equi BY equnr.

* Busca descrição do centro de trabalho
*    SELECT objty, objid, arbpl
*      FROM crhd
*      INTO TABLE @DATA(lt_crhd)
*      FOR ALL ENTRIES IN @lt_tb031
*      WHERE objid = @lt_tb031-gewrk.
    TYPES: BEGIN OF ty_crhd,
             objty TYPE crhd-objty,
             objid TYPE crhd-objid,
             arbpl TYPE crhd-arbpl,
           END OF ty_crhd.
    DATA lt_crhd TYPE TABLE OF ty_crhd.
    SELECT objty objid arbpl
      FROM crhd
      INTO TABLE lt_crhd
      FOR ALL ENTRIES IN lt_tb031
      WHERE objid = lt_tb031-gewrk.

*    SELECT usuario, nome
*      FROM /ptloms/tb013
*      INTO TABLE @DATA(lt_tb013)
*      FOR ALL ENTRIES IN @lt_tb031
*      WHERE usuario = @lt_tb031-usuario.
    TYPES: BEGIN OF ty_tb013,
             usuario TYPE /ptloms/tb013-usuario,
             nome    TYPE /ptloms/tb013-nome,
           END OF ty_tb013.
    DATA lt_tb013 TYPE TABLE OF ty_tb013.
    SELECT usuario nome
      FROM /ptloms/tb013
      INTO TABLE lt_tb013
      FOR ALL ENTRIES IN lt_tb031
      WHERE usuario = lt_tb031-usuario.

*    SELECT aufnr, vornr, isdz, iedz, werks, grund, iedd
*      INTO TABLE @DATA(lt_afru)
*      FROM afru
*      FOR ALL ENTRIES IN @lt_tb031
*      WHERE aufnr = @lt_tb031-aufnr AND
*            vornr = @lt_tb031-vornr AND
*            stokz <> 'X'.
    TYPES: BEGIN OF ty_afru,
             aufnr TYPE afru-aufnr,
             vornr TYPE afru-vornr,
             rmzhl TYPE afru-rmzhl,
             isdz  TYPE afru-isdz,
             iedz  TYPE afru-iedz,
             werks TYPE afru-werks,
             grund TYPE afru-grund,
             iedd  TYPE afru-iedd,
           END OF ty_afru.
    DATA lt_afru TYPE TABLE OF ty_afru.
    SELECT aufnr vornr rmzhl
           isdz iedz werks grund iedd
      INTO TABLE lt_afru
      FROM afru
      FOR ALL ENTRIES IN lt_tb031
      WHERE aufnr = lt_tb031-aufnr AND
            vornr = lt_tb031-vornr AND
            stokz <> 'X'.

    SORT lt_afru BY aufnr ASCENDING vornr ASCENDING
                                    rmzhl ASCENDING
                                    iedd  DESCENDING.

*    SELECT * FROM
*      trugt
*      INTO TABLE @DATA(lt_causa)
*      WHERE spras = @sy-langu.
    DATA lt_causa TYPE TABLE OF trugt.
    SELECT * FROM
      trugt
      INTO TABLE lt_causa
      WHERE spras = sy-langu.

    SORT lt_causa BY werks grund.

*    SELECT a~aufnr, b~vornr, c~grund, d~grdtx
*      INTO TABLE @DATA(lt_oper)
*      FROM afko AS a
*      INNER JOIN afvc  AS b ON a~aufpl = b~aufpl
*      INNER JOIN afru  AS c ON b~rueck = c~rueck AND b~rmzhl = c~rmzhl
*      INNER JOIN trugt AS d ON c~werks = d~werks AND c~grund = d~grund
*      FOR ALL ENTRIES IN @lt_tb031
*      WHERE a~aufnr EQ @lt_tb031-aufnr
*        AND d~spras EQ @sy-langu.

  ENDIF.

  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = '/PTLOMS/DM008'
      text            = 'X'
    TABLES
      values_tab      = lt_values_tab
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

* LOOP AT lt_tb031 INTO DATA(ls_031).
  DATA ls_031 LIKE LINE OF lt_tb031.
  LOOP AT lt_tb031 INTO ls_031.
    CLEAR ls_dados.
    MOVE-CORRESPONDING ls_031 TO ls_dados.

* Descrição do local de Instalação
*    READ TABLE lt_iflotx INTO DATA(ls_iflotx) WITH KEY tplnr = ls_031-tplnr.
    DATA ls_iflotx LIKE LINE OF lt_iflotx.
    READ TABLE lt_iflotx INTO ls_iflotx WITH KEY tplnr = ls_031-tplnr.
    IF sy-subrc EQ 0.
      ls_dados-pltxt = ls_iflotx-pltxt.
    ENDIF.

* Descrição do Equipamento
*    READ TABLE lt_v_equi INTO DATA(ls_v_equi) WITH KEY equnr = ls_031-equnr BINARY SEARCH.
    DATA ls_v_equi LIKE LINE OF lt_v_equi.
    READ TABLE lt_v_equi INTO ls_v_equi WITH KEY equnr = ls_031-equnr BINARY SEARCH.
    IF sy-subrc EQ 0.
      ls_dados-eqktx = ls_v_equi-eqktx.
      ls_dados-stort = ls_v_equi-stort.
      ls_dados-eqfnr = ls_v_equi-eqfnr.
*      ls_dados-anlnr = |{ ls_v_equi-anlnr ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = ls_v_equi-anlnr
        IMPORTING
          output = ls_dados-anlnr.

*      ls_dados-anlun = |{ ls_v_equi-anlun ALPHA = OUT }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = ls_v_equi-anlun
        IMPORTING
          output = ls_dados-anlun.

    ENDIF.

* Descrição do Centro de Trabalho
*    READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = ls_031-gewrk.
    DATA ls_crhd LIKE LINE OF lt_crhd.
    READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = ls_031-gewrk.
    IF sy-subrc = 0.
      ls_dados-arbpl = ls_crhd-arbpl.
    ENDIF.

* Descrição do status
*    READ TABLE lt_values_tab INTO DATA(ls_values_tab) WITH KEY valpos = ls_031-status.
    DATA ls_values_tab LIKE LINE OF lt_values_tab.
    READ TABLE lt_values_tab INTO ls_values_tab WITH KEY valpos = ls_031-status.
    IF sy-subrc EQ 0.
      ls_dados-status = ls_values_tab-ddtext.
    ENDIF.

*    READ TABLE lt_tb013 INTO DATA(ls_tb013) WITH KEY usuario = ls_031-usuario.
    DATA ls_tb013 LIKE LINE OF lt_tb013.
    READ TABLE lt_tb013 INTO ls_tb013 WITH KEY usuario = ls_031-usuario.
    IF sy-subrc EQ 0.
      ls_dados-nome = ls_tb013-nome.
    ENDIF.

    " Despacho anulado
    IF ls_031-status <> '5'.
*      READ TABLE lt_afru INTO DATA(ls_afru) WITH KEY aufnr = ls_031-aufnr
*                                                     vornr = ls_031-vornr.
      DATA ls_afru LIKE LINE OF lt_afru.
      READ TABLE lt_afru INTO ls_afru WITH KEY aufnr = ls_031-aufnr
                                               vornr = ls_031-vornr
                                               rmzhl = ls_031-conf_cnt.

      IF sy-subrc IS INITIAL.

*        READ TABLE lt_causa INTO DATA(ls_causa) WITH KEY werks = ls_afru-werks
*                                                         grund = ls_afru-grund
*                                                BINARY SEARCH.
        DATA ls_causa LIKE LINE OF lt_causa.
        READ TABLE lt_causa INTO ls_causa WITH KEY werks = ls_afru-werks
                                                   grund = ls_afru-grund
                                                BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          ls_dados-grund = ls_afru-grund.
          ls_dados-grdtx = ls_causa-grdtx.

        ENDIF.

      ENDIF.

    ENDIF.

    lv_objnr = ls_031-objnr.
    CALL FUNCTION 'STATUS_TEXT_EDIT'
      EXPORTING
        objnr            = lv_objnr
        spras            = sy-langu
        bypass_buffer    = 'X'
      IMPORTING
        e_stsma          = lv_stsma
        line             = ls_dados-status_sis
        user_line        = ls_dados-status_usu
        stonr            = lv_stonr
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.

    APPEND ls_dados TO gt_dados.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_DADOS
*&---------------------------------------------------------------------*
FORM f_monta_dados .

  gt_alv = gt_dados.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MOSTRA_ALV
*&---------------------------------------------------------------------*
FORM f_mostra_alv .

  CALL SCREEN '0100'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIBIR_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exibir_alv OUTPUT.
  PERFORM exibir_alv.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  EXIBIR_ALV
*&---------------------------------------------------------------------*
FORM exibir_alv .
  IF o_container IS INITIAL.
    PERFORM criar_instancia_alv. "Cria container e o alv
    PERFORM definir_status_alv.  "Define os botões do alv
    PERFORM modificar_colunas.   "Modifica ou define atributos das colunas
    PERFORM modificar_layout.    "Modificar opções de layout
    PERFORM registrar_eventos.   "Registra os eventos do alv
    PERFORM metodo_selecao.      "Permite selecionar somente 1 linha no ALV

* Exibe o ALV
    o_alv->display( ).
  ELSE.
    o_alv->refresh( ) .
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CRIAR_INSTANCIA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM criar_instancia_alv .

  DATA:
    o_cx_salv_msg TYPE REF TO cx_salv_msg,
    ls_message    TYPE bal_s_msg.                           "#EC NEEDED

  IF cl_salv_table=>is_offline( ) EQ if_salv_c_bool_sap=>false.

    " Cria o container somente se não estiver executando em background
    CREATE OBJECT o_container
      EXPORTING
        container_name = 'O_CONTAINER'.

  ENDIF.

* Criar a instância do alv
* =========================
  TRY.

      CALL METHOD cl_salv_table=>factory
        EXPORTING
          r_container    = o_container
          container_name = 'O_CONTAINER'
        IMPORTING
          r_salv_table   = o_alv
        CHANGING
          t_table        = gt_alv.

    CATCH cx_salv_msg INTO o_cx_salv_msg.
      CALL METHOD o_cx_salv_msg->if_alv_message~get_message
        RECEIVING
          r_s_msg = ls_message.
  ENDTRY.

ENDFORM.                    " CRIAR_INSTANCIA_ALV
*&---------------------------------------------------------------------*
*&      Form  DEFINIR_STATUS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM definir_status_alv .

  DATA icon_release TYPE icon_release.

* Habilita todos os botões genéricos do alv
  o_status = o_alv->get_functions( ).
  o_status->set_all( 'X' ).

  PERFORM excluir_botao
    USING '&GRAPH'.

  PERFORM adicionar_botao
  USING:
 "Okcode          Ícone                 Texto botão         Texto ao passar o mouse
 "======          =================     ===============     =======================
 'ATUALIZA'         icon_refresh         'Atualizar'(025)     'Atualizar'(025).

*  PERFORM adicionar_botao
*    USING:
*   "Okcode   Ícone          Texto botão                 Texto ao passar o mouse
*   "======   ============   ===============             =======================
*   'VORDER' icon_release    'Visualizar por Ordem'   'Visualizar por Ordem'.

ENDFORM.                    " DEFINIR_STATUS_ALV
*&---------------------------------------------------------------------*
*&      Form  ADICIONAR_BOTAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0689   text
*      -->P_ICON_RELEASE  text
*      -->P_0691   text
*      -->P_0692   text
*----------------------------------------------------------------------*
FORM adicionar_botao USING VALUE(p_name)    TYPE c
                            p_icon          TYPE any
                            p_text          TYPE c
                            VALUE(p_tooltip) TYPE c.

  DATA: l_name    TYPE salv_de_function,
        l_icon    TYPE string,
        l_text    TYPE string,
        l_tooltip TYPE string.

  l_name    = p_name.
  l_icon    = p_icon.
  l_text    = p_text.
  l_tooltip = p_tooltip.

  TRY.
      o_status->add_function(
        name     = l_name
        icon     = l_icon
        text     = l_text
        tooltip  = l_tooltip
        position = if_salv_c_function_position=>right_of_salv_functions ).
    CATCH cx_salv_existing .
    CATCH cx_salv_wrong_call .
  ENDTRY.

ENDFORM.                    " ADICIONAR_BOTAO
*&---------------------------------------------------------------------*
*&      Form  EXCLUIR_BOTAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0685   text
*----------------------------------------------------------------------*
FORM excluir_botao USING VALUE(p_name) TYPE c.

  DATA: l_name TYPE salv_de_function.

  l_name = p_name.

  TRY.

      CALL METHOD o_status->remove_function
        EXPORTING
          name = l_name.

    CATCH cx_salv_not_found .
    CATCH cx_salv_wrong_call .
  ENDTRY.

ENDFORM.                    " EXCLUIR_BOTAO
*&---------------------------------------------------------------------*
*&      Form  MODIFICAR_COLUNAS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modificar_colunas .

  "Buscar todas as colunas do ALV
  o_columns = o_alv->get_columns( ).

  "Otimizar a largura das colunas
* o_columns->set_optimize( 'X' ).

  "Alterar título e outros atributos das colunas
  PERFORM alterar_atributos_coluna
    USING:
*          'NOME_COLUNA'     'Descrição'             'X'    space     5
*           'MANDT'          'MANDT'                 space  space,
           'AUFNR'           'Ordem'(004)                  'X'    'X'      10,
           'VORNR'           'Operação'(005)               'X'    space    8,
           'SUBOPER'         'SubOperação'(006)            'X'    space    10,
           'USUARIO'         'Usuário Mobile'(003)         'X'    space    14,
           'NOME'            'Nome Usuário'(007)           'X'    space    15,
           'DATA_INI'        'Data Início'(008)            'X'    space    10,
           'HORA_INI'        'Hora Início'(009)            'X'    space    10,
*          'DATA_FIM'        'Data Fim'                    space  space    8,
*          'HORA_FIM'        'Hora Fim'                    space  space    8,
           'STATUS'          'Status Operação'(010)        space   space   60,  "'X'    space    70,
           'DATA_INATIVACAO' 'Data Inativação'(011)        'X'    space    12,
           'HORA_INATIVACAO' 'Hora Inativação'(012)        'X'    space    12,
           'INATIVO'         'Inativo'(013)                space  space    10,
           'AUART'           'Tipo Ordem'(014)             'X'    space    10,
           'ARBPL'           'Centro Trabalho'(015)        space   space   10,
*          'GEWRK'           'ID Centro Trabalho'          space  space    10,
           'GSTRP'           'Data-base do início'(016)    space   space   10,
           'GLTRP'           'Data-base do fim'(017)       space   space   10,
           'KTEXT'           'Texto breve'(018)            space   space   40,
           'IWERK'           'Centro Plan.Man.'(019)       space   space   10,
           'INGPR'           'Grupo de planejamento'(020)  space   space   10,
           'TPLNR'           'Local de instalação'(021)    space   space   15,
           'PLTXT'           'Desc.Local de inst.'(022)    space   space   40,
           'EQUNR'           'Nº equipamento'(023)         space   space   15,
           'EQKTX'           'Desc.Nº equipamento'(024)    space   space   40,
           'STATUS_SIS'      'Status de Sistema'(026)      'X'     space   20,
           'STATUS_USU'      'Status de Usuário'(027)      space  space    20,
           'GRUND'           'Causa Desvio'(028)           'X'    space    08,
           'GRDTX'           'Desc.Causa Desvio'(029)      'X'    space    30,
           'STORT'           'Localização'(130)            'X'    space    10,
           'EQFNR'           'Campo ordenação'(131)        'X'    space    10,
           'ANLNR'           'Imobilizado'(132)            'X'    space    10,
           'ANLUN'           'Subnº do imobilizado'(133)   'X'    space    20.

  "Ordenar colunas no relatório ALV
  PERFORM ordenar_coluna
    USING:
         'AUFNR'           '1',
         'VORNR'           '2',
         'SUBOPER'         '3',
         'DATA_INI'        '4',
         'HORA_INI'        '5',
         'STATUS'          '6',
         'STATUS_SIS'      '7',
         'USUARIO'         '8',
         'NOME'            '9',
         'AUART'           '10',
         'DATA_INATIVACAO' '11',
         'HORA_INATIVACAO' '12',
         'ARBPL'           '13',
         'GSTRP'           '14',
         'GLTRP'           '15',
         'KTEXT'           '16',
         'IWERK'           '17',
         'INGPR'           '18',
         'TPLNR'           '19',
         'PLTXT'           '20',
         'EQUNR'           '21',
         'EQKTX'           '22'.

*  " Colorir colunas
*  PERFORM colorir_coluna
*    USING:
*           "Campo     Chave  "Cor
*           'LINHA'    space  '7' '0' '0'.
**           'MSG'      space  '7' '0' '0'.

ENDFORM.                    " MODIFICAR_COLUNAS
*&---------------------------------------------------------------------*
*&      Form  ALTERAR_ATRIBUTOS_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0801   text
*      -->P_0802   text
*      -->P_SPACE  text
*      -->P_SPACE  text
*----------------------------------------------------------------------*
FORM alterar_atributos_coluna USING p_coluna  TYPE c
                                    p_texto   TYPE c
                                    p_visible TYPE c
*                                   p_length  TYPE n
                                    p_hotspot TYPE c
                                    p_tam     TYPE lvc_outlen.

  DATA: l_texto_l TYPE scrtext_l,
        l_texto_m TYPE scrtext_m,
        l_texto_s TYPE scrtext_s,
        l_visible TYPE sap_bool,
        l_length  TYPE lvc_outlen.

  PERFORM buscar_coluna USING p_coluna.

  l_texto_l = p_texto.
  l_texto_m = p_texto.
  l_texto_s = p_texto.
  l_visible = p_visible.
* l_length  = p_length.

  " Alterar o texto do cabeçalho da coluna
* o_column->set_optimized( 'X' ).
  o_column->set_alignment( if_salv_c_alignment=>centered ).
  o_column->set_long_text( l_texto_l ).
  o_column->set_medium_text( l_texto_m ).
  o_column->set_short_text( l_texto_s ).
  o_column->set_output_length( p_tam ).
*  o_column->set_output_length( l_length ) .

  " Oculta coluna
  o_column->set_visible( l_visible ).

  " Ativar Hotspot coluna
  IF p_hotspot = 'X'.
    o_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
  ENDIF.

ENDFORM.                    " ALTERAR_ATRIBUTOS_COLUNA
*&---------------------------------------------------------------------*
*&      Form  ORDENAR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0934   text
*      -->P_0935   text
*----------------------------------------------------------------------*
FORM ordenar_coluna USING p_column TYPE c
                          p_pos    TYPE c.


  DATA: l_column TYPE lvc_fname,
        l_pos    TYPE i.

  l_column = p_column.
  l_pos    = p_pos.

* Ordena as colunas no alv
  o_columns->set_column_position( columnname = l_column  position = l_pos ).
ENDFORM.                    " ORDENAR_COLUNA
*&---------------------------------------------------------------------*
*&      Form  COLORIR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1024   text
*      -->P_SPACE  text
*      -->P_1026   text
*      -->P_1027   text
*      -->P_1028   text
*----------------------------------------------------------------------*
FORM colorir_coluna USING VALUE(p_coluna) TYPE salv_s_column_ref-columnname
                          VALUE(p_key)    TYPE sap_bool
                          VALUE(pi_col)   TYPE lvc_s_colo-col
                          VALUE(pi_int)   TYPE lvc_s_colo-int
                          VALUE(pi_inv)   TYPE lvc_s_colo-inv.

* Colorir coluna
* 7 Laranja
* 6 Rosa
* 5 Verde
* 4 Azul
* 3 Amarelo
* 2 Azul claro

  " Fonte
* 0-1-0 Azul
* 6-0-1 Vermelho
* 5-0-1 Verde
* 2-0-1 Cinza

  DATA: ls_color  TYPE lvc_s_colo.

  TRY.

      o_column ?= o_columns->get_column( p_coluna ).

    CATCH cx_salv_not_found. " Campo & não existe

  ENDTRY.

*  ls_color-col = pi_col.
*  ls_color-int = pi_int.
*  ls_color-inv = pi_inv.
  o_column->set_color( ls_color ).

  o_column->set_key( p_key ).
*  o_column->set_color( value lvc_s_colo( col = pi_col int = pi_int inv = pi_inv ) ).

ENDFORM.                    " COLORIR_COLUNA
*&---------------------------------------------------------------------*
*&      Form  MODIFICAR_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modificar_layout .

  CLEAR: st_key, g_default.

  st_key-report = sy-repid.
  g_default     = 'X'.

  o_layout = o_alv->get_layout( ).

  o_layout->set_key( st_key ).
  o_layout->set_default( g_default ).
  o_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

ENDFORM.                    " MODIFICAR_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  REGISTRAR_EVENTOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM registrar_eventos .

* Registra os eventos
  o_events = o_alv->get_event( ).

  CREATE OBJECT o_handle_events.

  SET HANDLER o_handle_events->clique_duplo FOR o_events.
  SET HANDLER o_handle_events->clique_alv   FOR o_events.
  SET HANDLER o_handle_events->user_command FOR o_events.

ENDFORM.                    " REGISTRAR_EVENTOS
*&---------------------------------------------------------------------*
*&      Form  METODO_SELECAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM metodo_selecao .

  o_selections = o_alv->get_selections( ).
  o_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

ENDFORM.                    " METODO_SELECAO
*&---------------------------------------------------------------------*
*&      Form  BUSCAR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_COLUNA  text
*----------------------------------------------------------------------*
FORM buscar_coluna USING VALUE(p_coluna) TYPE c.

  TRY.
      o_column ?= o_columns->get_column( p_coluna ).

    CATCH cx_salv_not_found.
*      "Coluna & não existe
*      MESSAGE ...
  ENDTRY.

ENDFORM.                    " BUSCAR_COLUNA
*&---------------------------------------------------------------------*
*&      Module  SAIR_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE sair_0100 INPUT.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_VERIFICA_PERMISSAO
*&---------------------------------------------------------------------*
FORM f_verifica_permissao .

  AUTHORITY-CHECK OBJECT '/PTLOMS/01'
           ID 'TCD' FIELD sy-tcode
           ID 'ACTVT' FIELD '02'.

  IF sy-subrc <> 0.
    MESSAGE e001(/ptloms/cm001) WITH '/PTLOMS/01'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LIMPA_DADOS
*&---------------------------------------------------------------------*
FORM f_limpa_dados .

  REFRESH: gt_dados,
           gt_alv[].

ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC'.

    LEAVE TO  SCREEN '0' .

  ENDIF.

ENDMODULE.
