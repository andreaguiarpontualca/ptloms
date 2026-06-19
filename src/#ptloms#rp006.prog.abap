*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/RP006                                     *
*& Transação       : /PTLOMS/PTLOMSN006                                *
*& Objetivo        : Relatório de log                                  *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
REPORT /ptloms/rp006.
************************************************************************
***  Prograna REVISADO em 06/05/2024 em função da
***  incompatibilidade de versão com a SOLAR.
************************************************************************
***  Consultora ABAP - Nádia Rodrigues
************************************************************************

*&---------------------------------------------------------------------*
*& Tables
*&---------------------------------------------------------------------*
TABLES: balhdr,
        /ptloms/tb013.

*&---------------------------------------------------------------------*
*& Tipos
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_alv,
         perfil    TYPE /ptloms/tb013-perfil,
         descricao TYPE /ptloms/tb012-descricao,
         nome      TYPE /ptloms/tb013-nome,
         usuario   TYPE /ptloms/tb013-usuario,
         matricula TYPE /ptloms/tb013-matricula,
         lognumber TYPE balhdr-lognumber,
         object    TYPE balhdr-object,
         subobject TYPE balhdr-subobject,
         subobjtxt TYPE balsubt-subobjtxt,
         extnumber TYPE balhdr-extnumber,
         aldate    TYPE balhdr-aldate,
         altime    TYPE balhdr-altime,
         aluser    TYPE balhdr-aluser,
         contador  TYPE i,
       END OF ty_alv.

TYPES: BEGIN OF ty_balsubt,
         subobject TYPE balsubt-subobject,
         subobjtxt TYPE balsubt-subobjtxt,
       END OF ty_balsubt.

DATA:  it_balsubt  TYPE TABLE OF ty_balsubt.
DATA:  wa_balsubt  TYPE ty_balsubt.

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

  ENDMETHOD.                    "clique_link


  METHOD user_command.

  ENDMETHOD.                    "user_command

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION

*&---------------------------------------------------------------------*
*& Tela de Seleção
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_perfil FOR /ptloms/tb013-perfil,
                s_user   FOR /ptloms/tb013-usuario MATCHCODE OBJECT /ptloms/sh001,
                s_matri  FOR /ptloms/tb013-matricula,
                s_date   FOR balhdr-aldate OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-100.
PARAMETERS  p_vari  TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK b4.

*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
*&---------------------------------------------------------------------*

* Ajuda de pesquisa: Variante de exibição.
  PERFORM f_f4_variant USING '' CHANGING p_vari.

*&---------------------------------------------------------------------*
*& Processamento Principal
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN.

  PERFORM f_start.

*&---------------------------------------------------------------------*
START-OF-SELECTION.
*&---------------------------------------------------------------------*

  PERFORM f_monta_dados.
  PERFORM f_mostra_alv.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  F_START
*&---------------------------------------------------------------------*
FORM f_start.

  PERFORM f_limpa_dados.
  PERFORM f_verifica_permissao.
  PERFORM f_busca_dados.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DADOS
*&---------------------------------------------------------------------*
FORM f_busca_dados .

  DATA: ls_dados LIKE LINE OF gt_dados.

* Busca Status das Operações
*  SELECT a~lognumber, a~object, a~subobject, a~extnumber, a~aldate, a~altime, a~aluser, b~usuario, b~perfil, b~nome, b~matricula
*    FROM balhdr AS a INNER JOIN /ptloms/tb013 AS b
*    ON a~aluser = b~usuario
*    INTO TABLE @DATA(it_balhdr)
*    WHERE aluser    IN @s_user AND
*          aldate    IN @s_date AND
*          perfil    IN @s_perfil AND
*          matricula IN @s_matri.
  TYPES: BEGIN OF ty_balhdr,
           lognumber TYPE balhdr-lognumber,
           object    TYPE balhdr-object,
           subobject TYPE balhdr-subobject,
           extnumber TYPE balhdr-extnumber,
           aldate    TYPE balhdr-aldate,
           altime    TYPE balhdr-altime,
           aluser    TYPE balhdr-aluser,
           usuario   TYPE /ptloms/tb013-usuario,
           perfil    TYPE /ptloms/tb013-perfil,
           nome      TYPE /ptloms/tb013-nome,
           matricula TYPE /ptloms/tb013-matricula,
         END OF ty_balhdr.
  DATA it_balhdr TYPE TABLE OF ty_balhdr.
  SELECT a~lognumber a~object a~subobject a~extnumber a~aldate a~altime a~aluser b~usuario b~perfil b~nome b~matricula
    FROM balhdr AS a INNER JOIN /ptloms/tb013 AS b
    ON a~aluser = b~usuario
    INTO TABLE it_balhdr
    WHERE aluser    IN s_user AND
          aldate    IN s_date AND
          perfil    IN s_perfil AND
          matricula IN s_matri.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE e000(su) WITH text-030.
  ELSE.

*   Busca descrição objetos
*    SELECT subobject, subobjtxt FROM balsubt
*      INTO TABLE @DATA(it_balsubt)
*      WHERE spras     = @sy-langu
*        AND object = '/PTLOMS/OMS'.

    SELECT subobject subobjtxt FROM balsubt
      INTO  TABLE it_balsubt
      WHERE spras  = sy-langu
        AND object = '/PTLOMS/OMS'.

*   Busca dados do perfil
*    SELECT perfil, descricao
*      FROM /ptloms/tb012
*      INTO TABLE @DATA(it_perfil).

    DATA:
      it_perfil TYPE TABLE OF /ptloms/tb012,
      ls_perfil TYPE /ptloms/tb012.

    SELECT perfil descricao
      FROM /ptloms/tb012
      INTO CORRESPONDING FIELDS OF TABLE it_perfil.

    SORT it_perfil BY perfil.

*    LOOP AT it_balhdr ASSIGNING FIELD-SYMBOL(<fs_balhdr>).
    FIELD-SYMBOLS: <fs_balhdr> LIKE LINE OF it_balhdr.
    LOOP AT it_balhdr ASSIGNING <fs_balhdr>.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <fs_balhdr>-extnumber
        IMPORTING
          output = <fs_balhdr>-extnumber.

      MOVE-CORRESPONDING <fs_balhdr> TO ls_dados.

*      ls_dados-descricao = it_perfil[ perfil = ls_dados-perfil ]-descricao.
      DATA wa_perfil LIKE LINE OF it_perfil.
      READ TABLE it_perfil INTO wa_perfil WITH KEY perfil = ls_dados-perfil.
      IF sy-subrc IS INITIAL.
        ls_dados-descricao = wa_perfil-descricao.
      ENDIF.

      READ TABLE it_balsubt INTO wa_balsubt WITH KEY subobject = <fs_balhdr>-subobject.

      IF sy-subrc EQ 0.
        MOVE wa_balsubt-subobjtxt TO ls_dados-subobjtxt.
      ENDIF.

      APPEND ls_dados TO gt_dados.

    ENDLOOP.

    SORT gt_dados BY perfil descricao usuario nome matricula.

  ENDIF.

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
        container_name = 'O_CONTAINER'
        parent         = cl_gui_custom_container=>screen0.

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

  DATA: lr_functions TYPE REF TO cl_salv_functions_list.

  lr_functions = o_alv->get_functions( ).
  lr_functions->set_aggregation_count( 'X' ).

*  PERFORM excluir_botao
*    USING '&GRAPH'.

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
FORM adicionar_botao USING  p_name          TYPE c
                            p_icon          TYPE any
                            p_text          TYPE c
                            p_tooltip       TYPE c.

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
FORM excluir_botao USING p_name TYPE c.

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

  "Alterar título e outros atributos das colunas
  PERFORM alterar_atributos_coluna
    USING:
           'PERFIL'          'Perfil'(005)                  'X'    space    8,
           'DESCRICAO'       'Descricao perfil'(014)        'X'    space    20,
           'NOME'            'Nome'(006)                    'X'    space    15,
           'USUARIO'         'Usuário'(004)                 'X'    ''       10,
           'MATRICULA'       'Matrícula'(003)               'X'    space    10,
           'LOGNUMBER'       'Log'(007)                     'X'    space    20,
           'OBJECT'          'Objeto'(008)                  'X'    space    15,
           'SUBOBJECT'       'Subobjeto'(009)               'X'    space    20,
           'SUBOBJTXT'       'Desc.SubObjeto'(031)          'X'    space    20,
           'EXTNUMBER'       'Id. SubObjeto'(010)           'X'    space    11,
           'ALDATE'          'Data Log'(011)                'X'    space    11,
           'ALTIME'          'Hora Log'(012)                'X'    space    10,
           'ALUSER'          'Usuário log'(013)             'X'    space    10,
           'CONTADOR'        'Contador'(015)                'X'    space    10.

  TRY.
      o_columns->set_count_column( 'CONTADOR' ).
    CATCH cx_salv_data_error.                           "#EC NO_HANDLER
  ENDTRY.

  "Ordenar colunas no relatório ALV
  PERFORM ordenar_coluna
    USING:
         'PERFIL'           '1',
         'DESCRICAO'        '2',
         'USUARIO'          '3',
         'NOME'             '4',
         'MATRICULA'        '5'.
*         'HORA_INI'        '5',
*         'STATUS'          '6',
*         'STATUS_SIS'      '7',
*         'USUARIO'         '8',
*         'NOME'            '9',
*         'AUART'           '10',
*         'DATA_INATIVACAO' '11',
*         'HORA_INATIVACAO' '12',
*         'ARBPL'           '13',
*         'GSTRP'           '14',
*         'GLTRP'           '15',
*         'KTEXT'           '16',
*         'IWERK'           '17',
*         'INGPR'           '18',
*         'TPLNR'           '19',
*         'PLTXT'           '20',
*         'EQUNR'           '21',
*         'EQKTX'           '22'.

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
FORM colorir_coluna USING p_coluna  TYPE salv_s_column_ref-columnname
                          p_key     TYPE sap_bool
                          pi_col    TYPE lvc_s_colo-col
                          pi_int    TYPE lvc_s_colo-int
                          pi_inv    TYPE lvc_s_colo-inv.

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

  DATA: lv_set_lay TYPE slis_vari.

  CLEAR: st_key, g_default.

  st_key-report = sy-repid.
  g_default     = 'X'.

  o_layout = o_alv->get_layout( ).

  o_layout->set_key( st_key ).
  o_layout->set_default( g_default ).
  o_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

  lv_set_lay = p_vari.
  o_layout->set_initial_layout( lv_set_lay ).

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

*  o_selections = o_alv->get_selections( ).
*  o_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

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
*&      Form  F_F4_VARIANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0265   text
*      <--P_P_VARI  text
*----------------------------------------------------------------------*
FORM f_f4_variant USING p_hande
               CHANGING p_variante.

  DATA: lv_variant_exit TYPE  char1,
        ls_variante     TYPE  disvariant,
        ls_variant_aux  TYPE  disvariant.

  ls_variante-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = ls_variante
      i_save     = 'A'
    IMPORTING
      e_exit     = lv_variant_exit
      es_variant = ls_variant_aux
    EXCEPTIONS
      not_found  = 2.

  IF sy-subrc = 2.
*-- Não foi possível recuperar variante.
    MESSAGE i000(su) WITH text-e01.
    LEAVE LIST-PROCESSING AND RETURN TO SCREEN 0.
  ELSE.
    IF lv_variant_exit EQ space.
      p_variante = ls_variant_aux-variant.
    ENDIF.
  ENDIF.

ENDFORM.
