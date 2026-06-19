*&---------------------------------------------------------------------*
*&  Include           /ptloms/mp003_f01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      form  f_montar_alv
*&---------------------------------------------------------------------*
FORM f_montar_alv .

  IF o_container IS NOT INITIAL.
    o_container->free( ).
    FREE o_container.
  ENDIF.

  IF o_container IS INITIAL.
    PERFORM criar_instancia_alv. "Cria container e o alv
    PERFORM definir_status_alv.  "Define os botões do alv
    PERFORM modificar_colunas.   "Modifica ou define atributos das colunas
    PERFORM modificar_layout.    "Modificar opções de layout
    PERFORM registrar_eventos.   "Registra os eventos do alv
    PERFORM metodo_selecao.      "Permite selecionar somente 1 linha no alv

* exibe o alv
    o_alv->display( ).
  ELSE.
    o_alv->refresh( ) .
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  busca_usuarios
*&---------------------------------------------------------------------*
FORM busca_usuarios .

  DATA: lt_values_tab TYPE STANDARD TABLE OF dd07v.

  SELECT *
    FROM /ptloms/tb013
    INTO CORRESPONDING FIELDS OF TABLE gt_usuario.

  IF gt_usuario[] IS NOT INITIAL.
*    Select *
*      from /ptloms/tb012
*      into table @data(lt_tb012)
*      for all entries in @gt_usuario
*      where perfil = @gt_usuario-perfil.
    DATA lt_tb012 TYPE TABLE OF /ptloms/tb012.
    SELECT *
     FROM /ptloms/tb012
     INTO CORRESPONDING FIELDS OF TABLE lt_tb012
     FOR ALL ENTRIES IN gt_usuario
     WHERE perfil = gt_usuario-perfil.

*    Select objty, objid, arbpl
*      from crhd
*      into table @data(lt_crhd)
*      for all entries in @gt_usuario
*      where objid = @gt_usuario-objid.

    DATA lt_crhd TYPE STANDARD TABLE OF crhd.
    SELECT objty objid arbpl
          FROM crhd
          INTO CORRESPONDING FIELDS OF TABLE lt_crhd
          FOR ALL ENTRIES IN gt_usuario
          WHERE objid = gt_usuario-objid.

    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM009'
        text            = abap_true
      TABLES
        values_tab      = lt_values_tab
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

    FIELD-SYMBOLS: <fs_usuario> LIKE LINE OF gt_usuario.
    LOOP AT gt_usuario ASSIGNING <fs_usuario>.
*    Loop at gt_usuario assigning field-symbol(<fs_usuario>).
* Monta descrição do perfil
      DATA ls_012 LIKE LINE OF lt_tb012.
      READ TABLE lt_tb012 INTO ls_012 WITH KEY perfil = <fs_usuario>-perfil.
*      Read table lt_tb012 into data(ls_012) with key perfil = <fs_usuario>-perfil.
      IF sy-subrc EQ 0.
        <fs_usuario>-descricao_perfil = ls_012-descricao.
      ENDIF.

* Monta descrição do centro de trabalho
      DATA ls_crhd LIKE LINE OF lt_crhd.
      READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = <fs_usuario>-objid.
*      Read table lt_crhd into data(ls_crhd) with key objid = <fs_usuario>-objid.
      IF sy-subrc EQ 0.
        <fs_usuario>-arbpl = ls_crhd-arbpl.
      ENDIF.

* Monta descrição do dia início

      DATA ls_values_tab LIKE LINE OF lt_values_tab.
      READ TABLE lt_values_tab INTO ls_values_tab WITH KEY domvalue_l = <fs_usuario>-dia_inicio.
*      Read table lt_values_tab into data(ls_values_tab) with key domvalue_l = <fs_usuario>-dia_inicio.
      IF sy-subrc EQ 0.
        <fs_usuario>-desc_dia_inicio = ls_values_tab-ddtext.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  criar_instancia_alv
*&---------------------------------------------------------------------*
FORM criar_instancia_alv .

  DATA:
    o_cx_salv_msg TYPE REF TO cx_salv_msg,
    ls_message    TYPE bal_s_msg.                           "#Ec needed


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
          t_table        = gt_usuario.
    CATCH cx_salv_msg INTO o_cx_salv_msg.
      CALL METHOD o_cx_salv_msg->if_alv_message~get_message
        RECEIVING
          r_s_msg = ls_message.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  definir_status_alv
*&---------------------------------------------------------------------*
FORM definir_status_alv .

* Habilita todos os botões genéricos do alv
  o_status = o_alv->get_functions( ).
  o_status->set_all( 'X' ).

  PERFORM excluir_botao
    USING '&GRAPH'.

  AUTHORITY-CHECK OBJECT '/PTLOMS/06'
           ID 'TCD' FIELD sy-tcode
           ID 'ACTVT' FIELD '02'.

  IF sy-subrc = 0.

    PERFORM adicionar_botao
    USING:
   "okcode          Ícone                 texto botão      texto ao passar o mouse
   "======          =================     ===============  =======================
   'ADM_USUARIO'    icon_create           'ADMINISTRAR/CRIAR'(020)  'ADMINISTRAR/CRIAR'(020),
   'ELI_USUARIO'    icon_delete           'ELIMINAR USUÁRIO'(055)   'ELIMINAR USUÁRIO'(055).
* 'Del_usuario'    icon_delete           'remover'        'remover'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  excluir_botao
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->p_0392   text
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  modificar_colunas
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modificar_colunas .

  "Buscar todas as colunas do alv
  o_columns = o_alv->get_columns( ).

  "Otimizar a largura das colunas
  o_columns->set_optimize( 'X' ).

  "Alterar título e outros atributos das colunas
  PERFORM alterar_atributos_coluna
    USING:
*          'NOME_COLUNA'       'Descrição'                   'X'    space.
           'MANDT'             'MANDT'                       space  space,
           'USUARIO'           'Usuário'(001)                'X'    space,
           'NOME'              'Nome'(002)                   'X'    space,
           'PERFIL'            'Perfil'(003)                 'X'    space,
           'DESCRICAO_PERFIL'  'Descrição Perfil'(004)       'X'    space,
*           'USUARIO_SAP'       'Usuário SAP'                'X'    space,
           'MATRICULA'         'Matrícula'(005)              'X'    space,
           'OBJID'             'Centro de Trabalho'(006)     'X'    space,
           'ARBPL'             'Desc.Cent.Trabalho'(007)     'X'    space,
           'SINCRONIZA'        'Sincronização'(008)          space  space,
           'SENHA'             'Senha'(009)                  space  space,
           'CONF_SENHA'        'Conf.Senha'(010)             space  space,
           'ASSOCIA'           'Associar Op.Ordem'(011)      'X'    space,
           'BLOQUEADO'         'Bloqueado'(012)              'X'    space,
*          'SENHA_USUARIO_SAP' 'Senha Usuário SAP'           space  space,
*          'STATUS_SENHA'      'Status Senha'                space  space,
           'MATERIAL_SALDO'    'Sin.Mat.c/Saldo'(013)        'X'    space,
           'DIA_INICIO'        'Dia de Início'(014)          space  space,
           'DESC_DIA_INICIO'   'Dia de Início'(014)          'X'    space,
           'DIAS_RETROATIVOS'  'Dias Retroativos'(015)       'X'    space,
           'DIAS_PROGRESSIVOS' 'Dias Progressivos'(016)      'X'    space,
           'ENCERRA'           'Encerramento Técnico'(017)   'X'    space,
           'LIMITE_CONF'       'Limite Confirmação(h)'(018)  'X'    space,
           'ATUALIZAR_SENHA'   'Atualizar Senha'(019)        'X'    space,
           'ELIMINADO'         'Eliminado'(056)              'X'    space.

  "Ordenar colunas no relatório alv
  PERFORM ordenar_coluna
    USING:
           'USUARIO'            '1',
           'NOME'               '2',
           'PERFIL'             '3',
           'DESCRICAO_PERFIL'   '4',
*          'USUARIO_SAP'        '5',
           'MATRICULA'          '5',
           'OBJID'              '6',
           'ARBPL'              '7',
           'SINCRONIZA'         '8',
           'LIMITE_CONF'        '9',
           'ENCERRA'            '10',
           'MATERIAL_SALDO'     '11',
           'DESC_DIA_INICIO'    '12',
           'DIAS_RETROATIVOS'   '13',
           'DIAS_PROGRESSIVOS'  '14',
           'SENHA'              '15',
           'CONF_SENHA'         '16',
           'ASSOCIA'            '17',
           'BLOQUEADO'          '18',
           'ATUALIZAR_SENHA'    '19'.

***  " Colorir colunas
***  perform colorir_coluna
***    using:
***           "campo     chave  "cor
***           'bukrs' space  '7' '0' '0',
***           'butxt' space  '7' '0' '0',
***           'werks' space  '7' '0' '0',"'6' '1' '0',
***           'name1' space  '7' '0' '0'."'6' '1' '0'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  alterar_atributos_coluna
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->p_0435   text
*      -->p_0436   text
*      -->p_0437   text
*      -->p_space  text
*----------------------------------------------------------------------*
FORM alterar_atributos_coluna USING p_coluna  TYPE c
                                    p_texto   TYPE c
                                    p_visible TYPE c
                                    p_hotspot TYPE c.

  DATA: l_texto_l TYPE scrtext_l,
        l_texto_m TYPE scrtext_m,
        l_texto_s TYPE scrtext_s,
        l_visible TYPE sap_bool.

  PERFORM buscar_coluna USING p_coluna.

  l_texto_l = p_texto.
  l_texto_m = p_texto.
  l_texto_s = p_texto.
  l_visible = p_visible.

  " Alterar o texto do cabeçalho da coluna
  o_column->set_long_text( l_texto_l ).
  o_column->set_medium_text( l_texto_m ).
  o_column->set_short_text( l_texto_s ).

  " Oculta coluna
  o_column->set_visible( l_visible ).

  " Ativar hotspot coluna
  IF p_hotspot = 'X'.
    o_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ordenar_coluna
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->p_0491   text
*      -->p_0492   text
*----------------------------------------------------------------------*
FORM ordenar_coluna USING p_column TYPE c
                          p_pos    TYPE c.


  DATA: l_column TYPE lvc_fname,
        l_pos    TYPE i.

  l_column = p_column.
  l_pos    = p_pos.

* Ordena as colunas no alv
  o_columns->set_column_position( columnname = l_column  position = l_pos ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  buscar_coluna
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->p_p_coluna  text
*----------------------------------------------------------------------*
FORM buscar_coluna USING VALUE(p_coluna) TYPE c.

  TRY.
      o_column ?= o_columns->get_column( p_coluna ).

    CATCH cx_salv_not_found.
*      "Coluna & não existe
*      message ...
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  modificar_layout
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  registrar_eventos
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  metodo_selecao
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM metodo_selecao .

  o_selections = o_alv->get_selections( ).
  "  O_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
  o_selections->set_selection_mode( if_salv_c_selection_mode=>none ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  colorir_coluna
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->p_0667   text
*      -->p_0668   text
*      -->p_0669   text
*      -->p_0670   text
*----------------------------------------------------------------------*
FORM colorir_coluna USING VALUE(p_coluna) TYPE salv_s_column_ref-columnname
                          VALUE(p_key)    TYPE sap_bool
                          VALUE(pi_col)   TYPE lvc_s_colo-col
                          VALUE(pi_int)   TYPE lvc_s_colo-int
                          VALUE(pi_inv)   TYPE lvc_s_colo-inv.

* Colorir coluna
* 7 laranja
* 6 rosa
* 5 verde
* 4 azul
* 3 amarelo
* 2 azul claro

  " fonte
* 0-1-0 azul
* 6-0-1 vermelho
* 5-0-1 verde
* 2-0-1 cinza

  DATA: ls_color  TYPE lvc_s_colo.

  TRY.

      o_column ?= o_columns->get_column( p_coluna ).

    CATCH cx_salv_not_found. " Campo & não existe

  ENDTRY.

*  Ls_color-col = pi_col.
*  Ls_color-int = pi_int.
*  Ls_color-inv = pi_inv.
*  O_column->set_color( ls_color ).

  o_column->set_key( p_key ).
*  o_column->set_color( VALUE lvc_s_colo( col = pi_col int = pi_int inv = pi_inv ) ).
  DATA: ti_lvc_s_colo TYPE lvc_s_colo.
  ti_lvc_s_colo-col = pi_col.
  ti_lvc_s_colo-int = pi_int.
  ti_lvc_s_colo-inv = pi_inv.
  o_column->set_color( ti_lvc_s_colo ).


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  adicionar_botao
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->p_0407   text
*      -->p_icon_release  text
*      -->p_0409   text
*      -->p_0410   text
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_deleta_usuario
*&---------------------------------------------------------------------*
FORM f_deleta_usuario .

  DATA lv_resposta(1) TYPE c.

  DATA: lv_msg_tela(100) TYPE c.
  DATA: lv_qtde_aux(2) TYPE c.

*  DESCRIBE TABLE o_rows LINES DATA(lv_qtde).
  DATA lv_qtde TYPE i.
  DESCRIBE TABLE o_rows LINES lv_qtde.

  IF lv_qtde = 1.
***    Data(lv_msg_tela) = |remover o registro selecionado|.
    lv_msg_tela = 'remover o registro selecionado'(049).
  ELSE.
***    Lv_msg_tela = |remover os | && lv_qtde && | registros selecionados|.
    lv_qtde_aux = lv_qtde.
    CONCATENATE 'remover os'(050) lv_qtde_aux 'registros selecionados'(051) INTO lv_msg_tela SEPARATED BY space.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#ec *
    EXPORTING
      titlebar              = '### CONFIRMAÇÃO ###'(048)
      diagnose_object       = ' '
      text_question         = lv_msg_tela
      text_button_1         = 'SIM'(053)
      icon_button_1         = ' '
      text_button_2         = 'NÃO'(054)
      icon_button_2         = ' '
      default_button        = '1'
      display_cancel_button = ''
      userdefined_f1_help   = ' '
      start_column          = 25
      start_row             = 6
      popup_type            = 'ICON_MESSAGE_CRITICAL'
    IMPORTING
      answer                = lv_resposta
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF lv_resposta = 1.
    DATA: lt_usuario TYPE STANDARD TABLE OF ty_usuario,
          lv_row     TYPE int4,
          lv_erro    TYPE char1,
          ls_usuario LIKE LINE OF lt_usuario.

    lt_usuario = gt_usuario.
*    DATA(lt_usuario) = gt_usuario.
    LOOP AT o_rows INTO lv_row.
*    LOOP AT o_rows INTO DATA(lv_row).
      READ TABLE lt_usuario INTO ls_usuario INDEX lv_row.
*      READ TABLE lt_usuario INTO DATA(ls_usuario) INDEX lv_row.
      IF sy-subrc EQ 0.

        " Remove da tabela interna
        DELETE gt_usuario WHERE usuario = ls_usuario-usuario
                            AND perfil  = ls_usuario-perfil.

        " Remove da tabela /ptloms/tb013
        DELETE FROM /ptloms/tb013 WHERE usuario = ls_usuario-usuario
                                    AND perfil  = ls_usuario-perfil.
        IF sy-subrc NE 0.
          lv_erro = 'X'.
*          DATA(lv_erro) = 'x'.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_erro IS INITIAL.
    MESSAGE s000(su) WITH 'registro removidos com sucesso'(047).
  ELSE.
    MESSAGE s000(su) WITH 'erro ao remover registros'(046) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_grava_usuario
*&---------------------------------------------------------------------*
FORM f_grava_usuario .

  DATA: lt_values_tab TYPE STANDARD TABLE OF dd07v.

  DATA: ls_013     TYPE /ptloms/tb013,
        ls_usuario LIKE LINE OF gt_usuario,
        lv_senha   TYPE /ptloms/tb013-senha.

** Limpa campos de senha
*  clear: wa_usuario-senha_usuario_sap,
*         wa_usuario-status_senha.

  MOVE-CORRESPONDING wa_usuario TO ls_013.

  IF gv_acao = 'I'.
    ls_013-atualizar_senha = 'X'.
  ELSE.
    SELECT SINGLE senha FROM /ptloms/tb013 INTO lv_senha WHERE usuario = wa_usuario-usuario.
*    SELECT SINGLE senha FROM /ptloms/tb013 INTO @DATA(lv_senha) WHERE usuario = @wa_usuario-usuario.
    IF sy-subrc EQ 0 AND
       wa_usuario-senha NE lv_senha.
      ls_013-atualizar_senha = 'X'.
    ELSE.
      CLEAR ls_013-atualizar_senha.
    ENDIF.
  ENDIF.

  MODIFY /ptloms/tb013 FROM ls_013.

  IF sy-subrc EQ 0.

    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM009'
        text            = 'X'
      TABLES
        values_tab      = lt_values_tab
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

* Monta descrição do dia início
    DATA ls_values_tab LIKE LINE OF lt_values_tab.
    READ TABLE lt_values_tab INTO ls_values_tab WITH KEY domvalue_l = wa_usuario-dia_inicio.
*    READ TABLE lt_values_tab INTO DATA(ls_values_tab) WITH KEY domvalue_l = wa_usuario-dia_inicio.
    IF sy-subrc EQ 0.
      wa_usuario-desc_dia_inicio = ls_values_tab-ddtext.
    ELSE.
      CLEAR wa_usuario-desc_dia_inicio.
    ENDIF.

    IF gv_acao = 'I'.

      MOVE-CORRESPONDING wa_usuario TO ls_usuario.
      ls_usuario-atualizar_senha = 'X'.
      APPEND ls_usuario TO gt_usuario.
      SORT gt_usuario BY usuario ASCENDING perfil ASCENDING.

      MESSAGE s000(su) WITH 'registro inserido com sucesso'(045).

    ELSEIF gv_acao = 'E'.
      FIELD-SYMBOLS: <fs_usuario> LIKE LINE OF gt_usuario.
      READ TABLE gt_usuario ASSIGNING <fs_usuario>
*      READ TABLE gt_usuario ASSIGNING FIELD-SYMBOL(<fs_usuario>)
      WITH KEY usuario = wa_usuario-usuario.
*                Perfil = wa_usuario-perfil.

      IF sy-subrc EQ 0.
        CLEAR wa_usuario-atualizar_senha.
        MOVE-CORRESPONDING wa_usuario TO <fs_usuario>.
        MESSAGE s000(su) WITH 'registro alterado com sucesso'(044).
      ELSE.
        MESSAGE s000(su) WITH 'erro ao atualizar registro'(043).
      ENDIF.

    ENDIF.
  ELSE.
    MESSAGE s000(su) WITH 'erro ao atualizar registro'(043) DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_trata_campos
*&---------------------------------------------------------------------*
FORM f_trata_campos .

  IF gv_acao = 'E'.
    gv_text = 'alterar registro'(052).
    LOOP AT SCREEN.
      IF "screen-name = 'wa_usuario-perfil' or
         screen-name = 'WA_USUARIO-USUARIO'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF gv_acao = 'I'.
    gv_text = 'inserir novo registro'(042).
  ENDIF.

* Verifica se é o primeiro carregamento de dados do usuário
  IF gv_primeiro_carreg_dados = 'X'.
    CLEAR gv_primeiro_carreg_dados.

*IuryFSilva - Comentado devido a reestruturação no processo para a versão 2
*    IF wa_usuario-dia_inicio IS NOT INITIAL.
*      gv_radio1 = 'X'.
*      CLEAR gv_radio2.
*    ELSEIF wa_usuario-dias_retroativos  IS NOT INITIAL OR
*       wa_usuario-dias_progressivos IS NOT INITIAL.
*      gv_radio2 = 'X'.
*      CLEAR gv_radio1.
*    ENDIF.
  ENDIF.

*IuryFSilva - Comentado devido a reestruturação no processo para a versão 2
*  IF gv_radio1 IS NOT INITIAL.
*    LOOP AT SCREEN.
*      IF screen-group1 = 'RD2'.
*        screen-input = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    CLEAR: wa_usuario-dias_retroativos, wa_usuario-dias_progressivos.
*
*  ELSEIF gv_radio2 IS NOT INITIAL.
*    LOOP AT SCREEN.
*      IF screen-group1 = 'RD1'.
*        screen-input = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*    CLEAR: wa_usuario-dia_inicio.
*
*  ENDIF.

  CLEAR gv_texto_unidade.
  LOOP AT SCREEN.
    IF screen-name = 'GV_TEXTO_UNIDADE'.
*      SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO @DATA(lv_confirmacao).
      DATA lv_confirmacao TYPE /ptloms/tb033-confirmacao.
      SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO lv_confirmacao.
      IF sy-subrc EQ 0.
        IF lv_confirmacao = 'H'.
          gv_texto_unidade = 'horas'.
        ELSEIF lv_confirmacao = 'MIN'.
          gv_texto_unidade = 'minutos'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

**-> Inicializa campo unidade de tempo
  IF  wa_usuario-unidade_tempo  IS INITIAL.
    wa_usuario-unidade_tempo = 'H'.
  ENDIF.


** Busca configuração do sistema
*  select single usuario_sap from /ptloms/tb033 into @data(lv_usuario_sap).
*
** Campos senha e confsenha
*  loop at screen.
*    If screen-group1 = 'rf1'.
*      If lv_usuario_sap = 'x'.
*        Screen-required = '0'.
*      Else.
*        Screen-required = '1'.
*      Endif.
*      Modify screen.
*    Endif.
*  Endloop.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_usuario_sap
*&---------------------------------------------------------------------*
FORM f_valida_usuario_sap .

*  If sy-ucomm ne 'exit' and
*     sy-ucomm ne 'back' and
*     sy-ucomm ne 'canc' and
*     sy-ucomm ne 'btn_cancel'.
*
*    If wa_usuario-usuario_sap is initial.
*      Message e000 with 'usuário sap é obrigatório'.
*    Endif.
*
*    Select single bname
*      from usr01
*      into @data(lv_bname)
*      where bname = @wa_usuario-usuario_sap.
*
*    If sy-subrc ne 0.
*      Message e000 with 'usuário sap inválido'.
*    Endif.
*
*  Endif.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_perfil
*&---------------------------------------------------------------------*
FORM f_valida_perfil .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-perfil IS INITIAL.
      MESSAGE e000 WITH 'perfil é obrigatório'(041).
    ENDIF.

*    SELECT SINGLE *
*      FROM /ptloms/tb012
*      INTO @DATA(ls_012)
*      WHERE perfil = @wa_usuario-perfil.

    DATA: ls_012 TYPE /ptloms/tb012.
    SELECT SINGLE *
          FROM /ptloms/tb012
          INTO ls_012
          WHERE perfil = wa_usuario-perfil.

    IF sy-subrc NE 0.
      CLEAR wa_usuario-descricao_perfil.
      MESSAGE e000 WITH 'Perfil inválido'(040).
    ENDIF.

    IF ls_012-inativo = 'X'.
      CLEAR wa_usuario-descricao_perfil.
      MESSAGE e000 WITH 'Perfil eliminado'(039).
    ENDIF.

    wa_usuario-descricao_perfil = ls_012-descricao.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_matricula
*&---------------------------------------------------------------------*
FORM f_valida_matricula .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-matricula IS INITIAL.
      RETURN.
    ENDIF.

* Verifica se existe algum outro usuário com a mesma matrícula (que seja válido)
*    SELECT SINGLE usuario
*      FROM /ptloms/tb013
*      INTO @DATA(lv_usuario)
*      WHERE usuario   NE @wa_usuario-usuario
*        AND matricula EQ @wa_usuario-matricula
*        AND bloqueado EQ @space.
    DATA lv_usuario TYPE string.
    SELECT SINGLE usuario
          FROM /ptloms/tb013
          INTO lv_usuario
          WHERE usuario   NE wa_usuario-usuario
            AND matricula EQ wa_usuario-matricula
            AND bloqueado EQ space.

    IF sy-subrc EQ 0.
      MESSAGE e000 WITH 'Matrícula já utilizada pelo usuário'(023) lv_usuario.
    ENDIF.

*    SELECT SINGLE pernr
*      FROM pa0001
*      INTO @DATA(lv_pernr)
*      WHERE pernr = @wa_usuario-matricula.

    DATA lv_pernr TYPE pa0001-pernr.
    SELECT SINGLE pernr
          FROM pa0001
          INTO lv_pernr
          WHERE pernr = wa_usuario-matricula.

    IF sy-subrc NE 0.
      MESSAGE e000 WITH 'Matrícula inválida'(024).
    ENDIF.

    " Wa_usuario-associa = abap_true.

  ENDIF.

*  If wa_usuario-matricula is initial.
*
*    Wa_usuario-associa = abap_false.
*
  "Endif.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_objid
*&---------------------------------------------------------------------*
FORM f_valida_objid .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-objid IS INITIAL.
      CLEAR wa_usuario-arbpl.
      RETURN.
    ENDIF.

*    SELECT SINGLE arbpl
*      FROM crhd
*      INTO @DATA(lv_arbpl)
*      WHERE objid = @wa_usuario-objid.
    DATA lv_arbpl TYPE crhd-arbpl.
    SELECT SINGLE arbpl
     FROM crhd
     INTO lv_arbpl
     WHERE objid = wa_usuario-objid.

    IF sy-subrc NE 0.
      CLEAR wa_usuario-arbpl.
      MESSAGE e000 WITH 'Centro trabalho inválido'(025).
    ENDIF.

    wa_usuario-arbpl = lv_arbpl.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_usuario
*&---------------------------------------------------------------------*
FORM f_valida_usuario .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-usuario IS INITIAL.
      MESSAGE e000 WITH 'Usuário é obrigatório'(026).
    ENDIF.

    IF gv_acao = 'I'.
*      SELECT SINGLE *
*        FROM /ptloms/tb013
*        INTO @DATA(ls_013)
*        WHERE usuario = @wa_usuario-usuario.

      DATA ls_013 TYPE /ptloms/tb013.
      SELECT SINGLE *
        FROM /ptloms/tb013
        INTO ls_013
        WHERE usuario = wa_usuario-usuario.

      IF sy-subrc EQ 0.
        MESSAGE e000 WITH 'Usuário já cadastrado'(027).
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_unid_tempo
*&---------------------------------------------------------------------*
FORM f_valida_unid_tempo .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-unidade_tempo IS INITIAL.
      wa_usuario-unidade_tempo = 'H'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_nome
*&---------------------------------------------------------------------*
FORM f_valida_nome.

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-nome IS INITIAL.
      MESSAGE e000 WITH 'Nome é obrigatório'(028).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_senha
*&---------------------------------------------------------------------*
FORM f_valida_senha .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

* Busca configuração do sistema
    DATA lv_usuario_sap TYPE /ptloms/tb033-usuario_sap.
    SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO lv_usuario_sap.
*    SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO @DATA(lv_usuario_sap).

    IF lv_usuario_sap IS INITIAL.
      IF wa_usuario-senha IS INITIAL.
        MESSAGE e000 WITH 'Senha é obrigatória'(029).
      ENDIF.
    ENDIF.

* Criptografar senha.
    IF wa_usuario-senha IS NOT INITIAL.
      PERFORM f_criptografa_senha CHANGING wa_usuario-senha.
    ENDIF.

*    If wa_usuario-conf_senha is initial.
*      Message e000 with 'confirmação da senha é obrigatório'.
*    Endif.

*    If wa_usuario-senha ne wa_usuario-conf_senha.
*      Message e000 with 'confirmação da senha não coincide com a senha'.
*    Endif.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_help_matricula
*&---------------------------------------------------------------------*
FORM f_help_matricula .

  TYPES: BEGIN OF ty_tab,
           pernr TYPE persno,
           sname TYPE pa0001-sname,
         END OF ty_tab.

  DATA: lt_return TYPE STANDARD TABLE OF ddshretval.

*  SELECT pernr, sname
*    FROM pa0001
*    INTO TABLE @DATA(lt_pa0001)
*    WHERE begda LE @sy-datum
*      AND endda GE @sy-datum.

  DATA lt_pa0001 TYPE TABLE OF ty_tab.

  SELECT pernr sname
    FROM pa0001
    INTO CORRESPONDING FIELDS OF TABLE lt_pa0001
    WHERE begda LE sy-datum
      AND endda GE sy-datum.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'PERNR'
      value_org       = 'S'
    TABLES
      value_tab       = lt_pa0001
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.


  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

    wa_usuario-matricula = ls_return-fieldval.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_help_unid_tempo
*&---------------------------------------------------------------------*
FORM f_help_unid_tempo .

  TYPES:
    BEGIN OF ty_dd07v,
      value TYPE dd07v-domvalue_l,
    END OF ty_dd07v.

  DATA:
    lt_return     TYPE STANDARD TABLE OF ddshretval,
    lt_values_tab TYPE TABLE OF ty_dd07v.

  REFRESH:
    lt_values_tab.

  SELECT domvalue_l
    FROM dd07v
    INTO TABLE lt_values_tab
    WHERE domname EQ  '/PTLOMS/DM010'.

  SORT lt_values_tab.
  DELETE ADJACENT DUPLICATES FROM lt_values_tab COMPARING ALL FIELDS.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'UNIDADE_TEMPO'
      value_org       = 'S'
    TABLES
      value_tab       = lt_values_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
    DATA ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.
*    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

    wa_usuario-unidade_tempo = ls_return-fieldval.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_criptografa_senha
*&---------------------------------------------------------------------*
FORM f_criptografa_senha CHANGING p_senha TYPE char32.

  " Criptografar senha
  CALL FUNCTION 'MD5_CALCULATE_HASH_FOR_CHAR'
    EXPORTING
      data   = p_senha
*     length = 0
*     version        = 1
    IMPORTING
      hash   = p_senha
    EXCEPTIONS
      OTHERS = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_confsenha
*&---------------------------------------------------------------------*
FORM f_valida_confsenha .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

* Busca configuração do sistema
    DATA lv_usuario_sap TYPE /ptloms/tb033-usuario_sap.
    SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO lv_usuario_sap.
*    SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO @DATA(lv_usuario_sap).

    IF lv_usuario_sap IS INITIAL OR wa_usuario-senha IS NOT INITIAL.
      IF wa_usuario-conf_senha IS INITIAL.
        MESSAGE e000 WITH 'Confirmação da senha é obrigatório'(030).
      ENDIF.
    ENDIF.

    IF wa_usuario-senha IS INITIAL AND wa_usuario-conf_senha IS NOT INITIAL.
      MESSAGE e000 WITH 'Se confirmação preenchida, então '(035) 'senha deve ser preenchida.'(036).
    ENDIF.

* Criptografar conf_senha.
    IF wa_usuario-conf_senha IS NOT INITIAL.
      PERFORM f_criptografa_senha CHANGING wa_usuario-conf_senha.
    ENDIF.

*    If wa_usuario-senha ne wa_usuario-conf_senha.
*      Message e000 with 'confirmação da senha não coincide com a senha'.
*    Endif.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_senha_confsenha
*&---------------------------------------------------------------------*
FORM f_valida_senha_confsenha .

*  If sy-ucomm ne 'exit' and
*     sy-ucomm ne 'back' and
*     sy-ucomm ne 'canc' and
*     sy-ucomm ne 'btn_cancel'.
*
*    If wa_usuario-senha is initial.
*      Message e000 with 'senha é obrigatório'.
*    Endif.
*
*    If wa_usuario-conf_senha is initial.
*      Message e000 with 'confirmação da senha é obrigatório'.
*    Endif.
*
*    If wa_usuario-senha ne wa_usuario-conf_senha.
*      Message e000 with 'confirmação da senha não coincide com a senha'.
*    Endif.
*
*  Endif.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_senha_usuario_sap
*&---------------------------------------------------------------------*
FORM f_valida_senha_usuario_sap .

*  Data: lv_bname    type xuser,
*        lv_password type xubcode.
*
*  Data: lv_icone_nome(20) type c.
**        Icone_texto(100) type c.
*
*  If sy-ucomm ne 'exit' and
*    sy-ucomm ne 'back' and
*    sy-ucomm ne 'canc' and
*    sy-ucomm ne 'btn_cancel'.
*
*    If wa_usuario-senha_usuario_sap is not initial.
*
*      Move: wa_usuario-usuario_sap       to lv_bname,
*            wa_usuario-senha_usuario_sap to lv_password.
*
*      Call function 'susr_login_check_rfc'
*        exporting
*          bname                     = lv_bname
*          password                  = lv_password
**         xbcode                    =
**         xcodvn                    =
**         use_new_exception         = 0
*        exceptions
*          wait                      = 1
*          user_locked               = 2
*          user_not_active           = 3
*          password_expired          = 4
*          wrong_password            = 5
*          no_check_for_this_user    = 6
*          password_attempts_limited = 7
*          internal_error            = 8
*          others                    = 9.
*
*      If sy-subrc ne 0.
*        Lv_icone_nome = 'icon_incomplete'.
*      Else.
*        Lv_icone_nome = 'icon_checked'.
*      Endif.
*
*    Else.
*      Lv_icone_nome = 'icon_incomplete'.
*    Endif.
*
** Executa ação do componente
*    call function 'icon_create'
*      exporting
*        name                  = lv_icone_nome
**       text                  = icone_texto
*        info                  = 'status'
*        add_stdinf            = 'x'
*      importing
*        result                = wa_usuario-status_senha
*      exceptions
*        icon_not_found        = 1
*        outputfield_too_short = 2
*        others                = 3.
*
*    If lv_icone_nome ne 'icon_checked'.
*      Message e000 with 'senha usuário sap inválida'.
*    Endif.
*  Endif.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_horizonte
*&---------------------------------------------------------------------*
FORM f_valida_horizonte .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-dia_inicio        IS INITIAL AND
       wa_usuario-dias_retroativos  IS INITIAL AND
       wa_usuario-dias_progressivos IS INITIAL.
      MESSAGE e000 WITH 'Definir horizonte de visualização'(031).
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_user_command_0200
*&---------------------------------------------------------------------*
FORM f_user_command_0200 .

  DATA: lv_erro TYPE char1.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_consiste_senha CHANGING lv_erro.

    IF lv_erro = 'X'.
      RETURN.
    ENDIF.

    PERFORM f_grava_usuario.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_consiste_senha
*&---------------------------------------------------------------------*
FORM f_consiste_senha CHANGING p_erro TYPE char1.

  IF p_erro = 'X'.
    RETURN.
  ENDIF.

  IF wa_usuario-senha IS NOT INITIAL AND wa_usuario-conf_senha IS INITIAL.
    MESSAGE s000 WITH 'Se senha preenchida, então '(037) 'confirmação deve ser preenchida.'(038) DISPLAY LIKE 'E'.
    p_erro = 'X'.
    RETURN.
  ENDIF.

  IF wa_usuario-senha IS INITIAL AND wa_usuario-conf_senha IS NOT INITIAL.
    MESSAGE s000 WITH 'Se confirmação preenchida, então '(035) 'senha deve ser preenchida.'(036) DISPLAY LIKE 'E'.
    p_erro = 'X'.
    RETURN.
  ENDIF.

  IF wa_usuario-senha NE wa_usuario-conf_senha.
    MESSAGE s000 WITH 'Confirmação diferente da senha.'(034) DISPLAY LIKE 'E'.
    p_erro = 'X'.
    RETURN.
  ENDIF.

* Busca configuração do sistema
  DATA lv_usuario_sap TYPE /ptloms/tb033-usuario_sap.
  SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO lv_usuario_sap.
*  SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO @DATA(lv_usuario_sap).

  IF lv_usuario_sap IS INITIAL.
    IF wa_usuario-senha IS INITIAL.
      MESSAGE s000 WITH 'Senha é obrigatória.'(032) DISPLAY LIKE 'E'.
      p_erro = 'X'.
      RETURN.
    ENDIF.

    IF wa_usuario-conf_senha IS INITIAL.
      MESSAGE s000 WITH 'Confirmação de senha é obrigatório.'(033) DISPLAY LIKE 'E'.
      p_erro = 'X'.
      RETURN.
    ENDIF.
  ENDIF.

  IF wa_usuario-matricula IS INITIAL.
    wa_usuario-associa = abap_false.
  ELSE.
    wa_usuario-associa = abap_true.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_associacao
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_valida_associacao .



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_valida_deleta_usuario
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_valida_elimina_usuario CHANGING p_erro..

  DATA: lt_usuario TYPE TABLE OF ty_usuario,
        ls_usuario LIKE LINE OF lt_usuario,
        lt_tb026   TYPE TABLE OF /ptloms/tb026.
  lt_usuario = gt_usuario.
*  DATA(lt_usuario) = gt_usuario.

  DATA lv_row TYPE int4.
  LOOP AT o_rows INTO lv_row.
*  LOOP AT o_rows INTO DATA(lv_row).

    READ TABLE lt_usuario INTO ls_usuario INDEX lv_row.
*    READ TABLE lt_usuario INTO DATA(ls_usuario) INDEX lv_row.

    IF sy-subrc EQ 0.

*      SELECT b~aufnr, c~vornr
*        FROM /ptloms/tb026 AS a INNER JOIN afko AS b
*        ON a~aufnr = b~aufnr
*        INNER JOIN afvc AS c
*        ON b~aufpl = c~aufpl
*        INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
*        AND a~vornr = c~vornr
*        INTO TABLE @DATA(lt_tb026)
*        WHERE a~usuario    = @ls_usuario-usuario
*        AND a~desassociado = @space
*        AND c~phflg        = @space.

      SELECT b~aufnr c~vornr
        FROM /ptloms/tb026 AS a
          INNER JOIN afko AS b ON a~aufnr = b~aufnr
          INNER JOIN afvc AS c ON b~aufpl = c~aufpl
          INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
        INTO CORRESPONDING FIELDS OF TABLE lt_tb026
        WHERE a~usuario    = ls_usuario-usuario
          AND a~desassociado = space
          AND c~phflg        = space.

      IF sy-subrc IS INITIAL.

        MESSAGE s006(/ptloms/cm001) WITH ls_usuario-usuario ls_usuario-usuario DISPLAY LIKE 'E'.
        p_erro = abap_true.
        RETURN.

      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.
