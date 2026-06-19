*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP007_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_DESPACHO
*&---------------------------------------------------------------------*
FORM f_despacho .

  PERFORM f_busca_dados.
  PERFORM f_chama_monitor.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DADOS
*&---------------------------------------------------------------------*
FORM f_busca_dados .

  o_cl008->busca_dados( IMPORTING it_despacho = gt_despacho ).

  o_cl008->busca_endereco_cliente( EXPORTING it_despacho = gt_despacho IMPORTING it_despacho_out = gt_despacho ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHAMA_MONITOR
*&---------------------------------------------------------------------*
FORM f_chama_monitor .

  CALL SCREEN '0100'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_ALV
*&---------------------------------------------------------------------*
FORM f_monta_alv .

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
          t_table        = gt_despacho.
    CATCH cx_salv_msg INTO o_cx_salv_msg.
      CALL METHOD o_cx_salv_msg->if_alv_message~get_message
        RECEIVING
          r_s_msg = ls_message.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DEFINIR_STATUS_ALV
*&---------------------------------------------------------------------*
FORM definir_status_alv .

* Habilita todos os botões genéricos do alv
  o_status = o_alv->get_functions( ).
  o_status->set_all( 'X' ).

  PERFORM excluir_botao
    USING '&GRAPH'.

  PERFORM adicionar_botao
  USING:
 "Okcode          Ícone                 Texto botão         Texto ao passar o mouse
 "======          =================     ===============     =======================
 'ATUALIZA'         icon_refresh         'Atualizar Ordens'(009)    ' '. "Atualizar Ordens'(009).

  AUTHORITY-CHECK OBJECT '/PTLOMS/02'
           ID 'TCD'   FIELD sy-tcode
           ID 'ACTVT' FIELD '02'.

  IF sy-subrc = 0.

    IF p_ordens = 'X'.
      PERFORM adicionar_botao
      USING:
     "Okcode          Ícone                 Texto botão         Texto ao passar o mouse
     "======          =================     ===============     =======================
     'ADM_DESPACHO'    icon_connect         'Associar Ordem'(006)    ''. "'Associar Ordem'.

    ELSEIF p_oper = 'X'.
      PERFORM adicionar_botao
      USING:
     "Okcode          Ícone                 Texto botão         Texto ao passar o mouse
     "======          =================     ===============     =======================
     'ADM_DESPACHO'    icon_connect         'Associar Operação'(007)    ''. "'Associar Operação'.

    ENDIF.

    IF p_ordens IS NOT INITIAL.

      PERFORM adicionar_botao
      USING:
     "Okcode          Ícone                 Texto botão         Texto ao passar o mouse
     "======          =================     ===============     =======================
     'ADM_LIB'         icon_release         'Liberar Ordem'(008)     ''. "'Liberar Ordem'.

    ELSE.

      PERFORM adicionar_botao
      USING:
     "Okcode          Ícone                 Texto botão         Texto ao passar o mouse
     "======          =================     ===============     =======================
     'ADM_LIB'         icon_release         'Liberar Operação'(112)     ''. "'Liberar Operação'.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXCLUIR_BOTAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0392   text
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
  o_columns->set_optimize( 'X' ).

  "Alterar título e outros atributos das colunas
  PERFORM alterar_atributos_coluna
    USING:
           'AUFNR'           'Ordem'(010)                       'X'    'X'     12 '' '' 'AUFNR' 'AFKO' '',
           'AUART'           'Tipo Ordem'(011)                  'X'    space   12 'X' '' '' '' '',
*          'VORNR'           'Nº Operação'                      space  space,
           'QMNUM'           'Nota'(012)                        'X'    'X'     10 '' '' 'QMNUM' 'QMEL' '',
           'PRIOK'           'Prioridade'(013)                  space  space   10 '' '' '' '' '',
           'GEWRK'           'ID Centro Trabalho'(014)          space  space   10 '' '' '' '' 'X',
           'ARBPL'           'Centro Trabalho'(015)             'X'    space   10 'X' '' '' '' '',
           'GSTRP'           'Data-base do início'(016)         'X'    space   10 '' '' '' '' '',
           'GLTRP'           'Data-base do fim'(017)            'X'    space   10 '' '' '' '' '',
           'IDAT1'           'Data da liberação'(018)           'X'    space   10 '' '' '' '' '',
           'KTEXT'           'Texto breve'(019)                 'X'    space   10 '' '' '' '' '',
           'IWERK'           'Centro Plan.Man.'(020)            'X'    space   10 'X' '' '' '' '',
           'INGPR'           'Grupo de planejamento'(021)       'X'    space   10 'X' '' '' '' '',
           'TPLNR'           'Local de instalação'(022)         'X'    space   10 'X' '' '' '' '',
           'PLTXT'           'Desc.Local de inst.'(023)         'X'    space   10 '' '' '' '' '',
           'EQUNR'           'Nº equipamento'(024)              'X'    space   10 '' '' 'EQUNR' 'EQUI' '',
           'EQKTX'           'Desc.Nº equipamento'(025)         'X'    space   10 '' '' '' '' '',
           'DATA_ASSOCIACAO' 'Data de Associação'(026)          'X'    space   10 '' '' '' '' '',
           'HORA_ASSOCIACAO' 'Hora de Associação'(027)          space  space   10 '' '' '' '' '',
           'STATUS_SIS'      'Status Sistema'(028)              'X'    space   10 '' '' '' '' '',
           'STATUS_USU'      'Status Usuário'(029)              'X'    space   10 '' '' '' '' '',
           'OBJNR'           'Nº Objeto'(030)                   space  space   10 '' '' '' '' 'X',
           'LTXA1'           'Descrição da Operação'(031)       space  space   10 '' '' '' '' '',
           'ARTPR'           'Tipo de Prioridade'(032)          space  space   10 '' '' '' '' '',
           'PRIOKX'          'Prioridade Ordem'(033)            'X'    space   10 '' '' '' '' '',
           'INNAM'           'Desc.Grp.Planejamento'(034)       'X'    space   10 '' '' '' '' '',
           'AUFPL'           'Roteiro'(035)                     space  space   10 '' '' '' '' 'X',
           'APLZL'           'Numerador'(036)                   space  space   10 '' '' '' '' 'X',
           'SUMNR'           'Nº ponto de conexão'(037)         space  space   10 '' '' '' '' 'X',
           'NAME1'           'Descrição cliente'(093)           'X'    space   10 '' '' '' ''  '',
           'KUNNR'           'Cliente'(094)                     'X'    'X'     10 '' '' 'KUNNR' 'KNA1' '',
           'STRAS'           'Endereço'(095)                    'X'    space   10 '' 'Endereço do cliente'(101) '' '' '',
           'HOUSE_NUM1'      'Número'(096)                      'X'    space   10 '' 'Número do cliente'(102) '' '' '',
           'ORT02'           'Bairro'(097)                      'X'    space   10 '' 'Bairro do cliente'(103) '' '' '',
           'ORT01'           'Cidade'(098)                      'X'    space   10 '' 'Cidade do cliente'(104) '' '' '',
           'REGIO'           'Estado'(099)                      'X'    space   10 '' 'Estado do cliente'(105) '' '' '',
           'TELF1'           'Telefone'(100)                    'X'    space   10 '' 'Telefone do cliente'(106) '' '' '',
           'TIDNR'           'Nº identificação técnica'(108)    ''     space   10 'X' '' '' '' '',
           'WARPL'           'Plano de manutenção'(109)         ''     space   10 '' '' '' '' '',
           'WPTXT'           'Texto do plano de manutenção'(110) ''    space   10 '' '' '' '' '',

           'SEMAFORO_COR'    ''                                 ''     space   10 '' '' '' '' 'X',
           'ARBEI'           ''                                 ''     space   10 '' '' '' '' 'X',
           'ABCKZ'           ''                                 ''     space   10 '' '' '' '' 'X',
           'ABCTX'           ''                                 ''     space   10 '' '' '' '' 'X',
           'ILART'           ''                                 ''     space   10 '' '' '' '' 'X',
           'ILATX'           ''                                 ''     space   10 '' '' '' '' 'X',
           'TEXTO_LONGO_OPERACAO'           ''                  ''     space   10 '' '' '' '' 'X',
           'QTD_OPERACOES'   ''                                 ''     space   10 '' '' '' '' 'X',
           'USUARIOAPP'      ''                                 ''     space   10 '' '' '' '' 'X',
           'MATRICULA'       ''                                 ''     space   10 '' '' '' '' 'X',
           'QTD_USUARIOS'    ''                                 ''     space   10 '' '' '' '' 'X',
           'CHAVE'           ''                                 ''     space   10 '' '' '' '' 'X',
           'SUBOPER'         ''                                 ''     space   10 '' '' '' '' 'X',
           'ARBID'           ''                                 ''     space   10 '' '' '' '' 'X',
           'PERNR'           ''                                 ''     space   10 '' '' '' '' 'X',
           'OBJNR_OPER_SUB'           ''                                 ''     space   10 '' '' '' '' 'X',
           'DATA_ASSOCIACAO_STR'      ''                        ''     space   10 '' '' '' '' 'X',
           'DATA_HORA_ASSOCIACAO'     ''                        ''     space   10 '' '' '' '' 'X',
           'GSTRP_STR'                ''                 ''     space   10 '' '' '' '' 'X',
           'GLTRP_STR'                ''                 ''     space   10 '' '' '' '' 'X',
           'IDAT1_STR'                ''                 ''     space   10 '' '' '' '' 'X',
           'DATA_ASSOCIACAO_STR'      ''                 ''     space   10 '' '' '' '' 'X',
           'PSTLZ'            'Cep'(112)                 ''     space   10 '' '' '' '' '',
           'TEXTO_LONGO_ORDEM' 'Texto longo da ordem'(113)                 ''     space   10 '' '' '' '' '',
           'TEXTO_BREVE_ORDEM' 'Texto breve da ordem'(114)                 ''     space   10 '' '' '' '' '',
           'DATA_OPER_INI_STR' ''                 ''     space   10 '' '' '' '' 'X',
           'DATA_OPER_FIM_STR' ''                 ''     space   10 '' '' '' '' 'X',
           'FSAVD'             'Data início da operação'(119) ''     space   10 '' '' '' '' '',
           'FSEDD'             'Data fim da operação'(120)    ''     space   10 '' '' '' '' '',
           'CODIGO_ASSOCIACAO_ORDEM'              ''                 ''     space   10 '' '' '' '' 'X',
           'DESCRICAO_ASSOCIACAO_ORDEM'           ''                 ''     space   10 '' '' '' '' 'X',
           'NAME_CP'           'Descrição do centro de planejamento'(115)              ''     space   10 '' '' '' '' '',
           'ARBEH'             'Unidade de trabalho'(116)              ''     space   10 '' '' '' '' '',
           'ISMNW'             'Trabalho real'(117)                    ''     space   10 '' '' '' '' '',
           'SNAME'             'Nome do empregado'(118)                    ''     space   10 '' '' '' '' ''.




*           'TELF1'           ''                                 ''     space   10 '' '' '' '' 'X',
*           'TELF1'           ''                                 ''     space   10 '' '' '' '' 'X'.

  IF p_ordens = 'X'.
    PERFORM alterar_atributos_coluna USING:   'VORNR'        'Operação'(038)      space space   10 abap_true '' '' '' '',
                                              'SUBOPER'      'Suboperação'(039)   space space   10 abap_true '' '' '' ''.
*                                              'GEWRK'      'ID Centro Trabalho'  'X'   space,
*                                              'ARBID'      'ID Centro Trabalho'  space space.
  ELSEIF p_oper = 'X'.
    PERFORM alterar_atributos_coluna USING:   'VORNR'        'Nº Operação'(038)   'X' space    10 abap_true '' '' '' '',
                                              'SUBOPER'      'Suboperação'(039)   'X' space    10 abap_true '' '' '' ''.
*                                              'GEWRK'      'ID Centro Trabalho'  space space,
*                                              'ARBID'      'ID Centro Trabalho'  'X' space.
  ENDIF.

  IF p_ordens = 'X'.

    "Ordenar colunas no relatório ALV
    PERFORM ordenar_coluna
      USING:
             'AUFNR'      '1',
             'AUART'      '2',
             'QMNUM'      '3',
             'PRIOK'      '4',
             'PRIOKX'     '5',
             'GEWRK'      '6',
             'ARBPL'      '7',
             'GSTRP'      '8',
             'GLTRP'      '9',
             'IDAT1'      '10',
             'KTEXT'      '11',
             'IWERK'      '12',
             'INGPR'      '13',
             'INNAM'      '14',
             'TPLNR'      '15',
             'PLTXT'      '16',
             'EQUNR'      '17',
             'EQKTX'      '18',
             'STATUS_SIS' '19',
             'STATUS_USU' '20' ,
             'KUNNR'      '21',
             'NAME1'      '22',
             'STRAS'      '23',
             'HOUSE_NUM1' '24',
             'ORT02'      '26',
             'ORT01'      '25',
             'REGIO'      '27',
             'TELF1'      '28'.

  ELSEIF p_oper = 'X'.

    "Ordenar colunas no relatório ALV
    PERFORM ordenar_coluna
      USING:
             'AUFNR'      '1',
             'AUART'      '2',
             'VORNR'      '3',
             'SUBOPER'    '4',
             'QMNUM'      '5',
             'PRIOK'      '6',
             'PRIOKX'     '7',
             'GEWRK'      '8',
             'ARBPL'      '9',
             'GSTRP'      '10',
             'GLTRP'      '11',
             'IDAT1'      '12',
             'KTEXT'      '13',
             'IWERK'      '14',
             'INGPR'      '15',
             'INNAM'      '16',
             'TPLNR'      '17',
             'PLTXT'      '18',
             'EQUNR'      '19',
             'EQKTX'      '20',
             'STATUS_SIS' '21',
             'STATUS_USU' '22',
             'KUNNR'      '23',
             'NAME1'      '24',
             'STRAS'      '25',
             'HOUSE_NUM1' '26',
             'ORT02'      '28',
             'ORT01'      '27',
             'REGIO'      '29',
             'TELF1'      '30'.

  ENDIF.

***  " Colorir colunas
***  PERFORM colorir_coluna
***    USING:
***           "Campo     Chave  "Cor
***           'BUKRS' space  '7' '0' '0',
***           'BUTXT' space  '7' '0' '0',
***           'WERKS' space  '7' '0' '0',"'6' '1' '0',
***           'NAME1' space  '7' '0' '0'."'6' '1' '0'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALTERAR_ATRIBUTOS_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0435   text
*      -->P_0436   text
*      -->P_0437   text
*      -->P_SPACE  text
*----------------------------------------------------------------------*
FORM alterar_atributos_coluna USING p_coluna  TYPE c
                                    p_texto   TYPE c
                                    p_visible TYPE c
                                    p_hotspot TYPE c
                                    p_tamanho TYPE lvc_outlen
                                    p_zero    TYPE c
                                    p_tooltip TYPE c
                                    p_field   TYPE salv_s_ddic_reference-field
                                    p_table   TYPE salv_s_ddic_reference-table
                                    p_tech    TYPE c.

  DATA: l_texto_l TYPE scrtext_l,
        l_texto_m TYPE scrtext_m,
        l_texto_s TYPE scrtext_s,
        l_visible TYPE sap_bool,
        l_ddic    TYPE salv_s_ddic_reference.

  PERFORM buscar_coluna USING p_coluna.

  l_texto_l    = p_texto.
  l_texto_m    = p_texto.
  l_texto_s    = p_texto.
  l_visible    = p_visible.
  l_ddic-table = p_table.
  l_ddic-field = p_field.

  " Alterar o texto do cabeçalho da coluna
  o_column->set_long_text( l_texto_l ).
  o_column->set_medium_text( l_texto_m ).
  o_column->set_short_text( l_texto_s ).
  o_column->set_output_length( p_tamanho ).
  o_column->set_zero( p_zero ).
  o_column->set_tooltip( p_tooltip ).
  o_column->set_technical( p_tech ).

  IF l_ddic IS NOT INITIAL.

    o_column->set_ddic_reference( l_ddic  ).

  ENDIF.

  " Oculta coluna
  o_column->set_visible( l_visible ).

  " Ativar Hotspot coluna
  IF p_hotspot = 'X'.
    o_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ORDENAR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0491   text
*      -->P_0492   text
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

ENDFORM.
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

ENDFORM.
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

ENDFORM.
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COLORIR_COLUNA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0667   text
*      -->P_0668   text
*      -->P_0669   text
*      -->P_0670   text
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
*  o_column->set_color( ls_color ).

  o_column->set_key( p_key ).
*  o_column->set_color( VALUE lvc_s_colo( col = pi_col int = pi_int inv = pi_inv ) ).
  DATA: ti_lvc_s_colo TYPE lvc_s_colo.
  ti_lvc_s_colo-col = pi_col.
  ti_lvc_s_colo-int = pi_int.
  ti_lvc_s_colo-inv = pi_inv.
  o_column->set_color( ti_lvc_s_colo ).


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADICIONAR_BOTAO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0407   text
*      -->P_ICON_RELEASE  text
*      -->P_0409   text
*      -->P_0410   text
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
*&      Form  F_VALIDA_USUARIO
*&---------------------------------------------------------------------*
FORM f_valida_usuario .

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-usuario IS INITIAL.
      MESSAGE e000 WITH 'Usuário é obrigatório'(060).
    ENDIF.

    DATA: ls_013 TYPE /ptloms/tb013.
    SELECT SINGLE usuario nome bloqueado matricula
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF ls_013
      WHERE usuario = wa_usuario-usuario.

***    SELECT SINGLE usuario, nome, bloqueado, matricula
***      FROM /ptloms/tb013
***      INTO @DATA(ls_013)
***      WHERE usuario = @wa_usuario-usuario.

    IF sy-subrc NE 0.
      CLEAR wa_usuario-nome.
      MESSAGE e000 WITH 'Usuário inválido'(061).
    ENDIF.

    IF ls_013-bloqueado = 'X'.
      CLEAR wa_usuario-nome.
      MESSAGE e000 WITH 'Usuário bloqueado'(062).
    ENDIF.

    IF ls_013-matricula = '00000000'.
      MESSAGE e000 WITH 'Usuário sem matrícula'(107).
    ENDIF.

    wa_usuario-nome      = ls_013-nome.
    wa_usuario-matricula = ls_013-matricula.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_USUARIO_ASSOCIAR
*&---------------------------------------------------------------------*
FORM f_valida_usuario_associar .

  DATA: lt_selected_nodes TYPE lvc_t_nkey.

  DATA: ls_despacho_tree TYPE /ptloms/et079. "ty_despacho_tree.

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF wa_usuario-usuario IS INITIAL.
      MESSAGE e000 WITH 'Usuário é obrigatório'(060).
    ENDIF.

    DATA: ls_013 TYPE /ptloms/tb013.
    SELECT SINGLE usuario nome bloqueado matricula
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF ls_013
      WHERE usuario = wa_usuario-usuario.

***    SELECT SINGLE usuario, nome, bloqueado, matricula
***      FROM /ptloms/tb013
***      INTO @DATA(ls_013)
***      WHERE usuario = @wa_usuario-usuario.

    IF sy-subrc NE 0.
      CLEAR wa_usuario-nome.
      MESSAGE e000 WITH 'Usuário inválido'(061).
    ENDIF.

    IF ls_013-bloqueado = 'X'.
      CLEAR wa_usuario-nome.
      MESSAGE e000 WITH 'Usuário bloqueado'(062).
    ENDIF.

    IF ls_013-matricula = '00000000'.
      CLEAR wa_usuario-nome.
      MESSAGE e000 WITH 'Usuário sem matrícula'(107).
    ENDIF.

* Determina node solecionado
*    PERFORM f_busca_registro_selecionado CHANGING ls_despacho_tree.
    PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

*** LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
    DATA: ls_selected_nodes TYPE LINE OF lvc_t_nkey.
    LOOP AT lt_selected_nodes INTO ls_selected_nodes.

      CLEAR ls_despacho_tree.
      PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                        CHANGING ls_despacho_tree.
      IF ls_despacho_tree IS INITIAL.
        CONTINUE.
      ENDIF.
      IF ls_despacho_tree-usuario = wa_usuario-usuario.
        CLEAR wa_usuario-nome.
        MESSAGE e000 WITH 'Usuário selecionado é o próprio usuário'(063).
      ENDIF.
    ENDLOOP.

*   Verifica se ordem já está associada ao usuário
    DATA: lv_aufnr TYPE /ptloms/tb026-aufnr.
    SELECT SINGLE aufnr
      FROM /ptloms/tb026
      INTO lv_aufnr
      WHERE aufnr        = ls_despacho_tree-aufnr
        AND vornr        = ls_despacho_tree-vornr
        AND suboper      = ls_despacho_tree-suboper
        AND usuario      = wa_usuario-usuario
        AND desassociado = space.

***    SELECT SINGLE aufnr
***      FROM /ptloms/tb026
***      INTO @DATA(lv_aufnr)
***      WHERE aufnr        = @ls_despacho_tree-aufnr
***        AND vornr        = @ls_despacho_tree-vornr
***        AND suboper      = @ls_despacho_tree-suboper
***        AND usuario      = @wa_usuario-usuario
***        AND desassociado = @space.

    IF sy-subrc EQ 0.
      MESSAGE e000 WITH 'Ordem já associada à esse usuário'(064).
    ENDIF.

    wa_usuario-nome = ls_013-nome.
    wa_usuario-matricula = ls_013-matricula.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_USUARIO
*&---------------------------------------------------------------------*
FORM f_help_usuario .

  TYPES: BEGIN OF ty_tab,
           usuario TYPE /ptloms/tb013-usuario,
           nome    TYPE /ptloms/tb013-nome,
         END OF ty_tab.

  DATA: "lt_tab        TYPE STANDARD TABLE OF ty_tab,
    lt_return     TYPE STANDARD TABLE OF ddshretval,
    lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: ls_dynpfields LIKE LINE OF lt_dynpfields.

  DATA: lt_tb013 TYPE TABLE OF /ptloms/tb013.
  SELECT usuario nome matricula
    FROM /ptloms/tb013
    INTO CORRESPONDING FIELDS OF TABLE lt_tb013
    WHERE bloqueado = space AND
          matricula <> '00000000'.

***  SELECT usuario, nome, matricula
***    FROM /ptloms/tb013
***    INTO TABLE @DATA(lt_tb013)
***    WHERE bloqueado = @space AND
***          matricula <> '00000000'.

  IF lt_tb013[] IS INITIAL.
    RETURN.
  ENDIF.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'USUARIO'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tb013
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*** READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA: ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

      " --- Atribui valor ao campo da tela
      wa_usuario-usuario = ls_return-fieldval.

***   READ TABLE lt_tb013 INTO DATA(ls_013) WITH KEY usuario = wa_usuario-usuario.
      DATA: ls_013 LIKE LINE OF lt_tb013 .
      READ TABLE lt_tb013 INTO ls_013 WITH KEY usuario = wa_usuario-usuario.

      IF sy-subrc = 0.
        wa_usuario-nome = ls_013-nome.
        wa_usuario-matricula = ls_013-matricula.
        ls_dynpfields-fieldname = 'WA_USUARIO-NOME'.
        ls_dynpfields-fieldvalue = wa_usuario-nome.
        APPEND ls_dynpfields TO lt_dynpfields.
      ENDIF.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_ALV_TREE
*&---------------------------------------------------------------------*
FORM f_monta_alv_tree .

  IF g_alv_tree IS INITIAL.

    IF g_alv_tree IS NOT INITIAL.
      CALL METHOD g_alv_tree->free.
      CALL METHOD g_alv_tree->finalize.
    ENDIF.

    IF g_custom_container IS NOT INITIAL.
      CALL METHOD g_custom_container->free.
      CALL METHOD g_custom_container->finalize.
    ENDIF.

    PERFORM init_tree.

    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2.
    IF sy-subrc NE 0.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel = 'Erro na fila de automação'(065)
          txt1  = 'Erro interno:'(066)
          txt2  = 'Um método na fila de automação'(067)
          txt3  = 'provocou um erro'(068).
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_TREE
*&---------------------------------------------------------------------*
FORM init_tree .

* cria container para alv-tree
  DATA: l_tree_container_name(30) TYPE c.

  DATA: ls_vari TYPE disvariant.

  l_tree_container_name = 'O_CONTAINER2'.

  CREATE OBJECT g_custom_container
    EXPORTING
      container_name              = l_tree_container_name
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'(100).
  ENDIF.

* cria tree control
  CREATE OBJECT g_alv_tree
    EXPORTING
      parent                      = g_custom_container
*     node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
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
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  DATA l_hierarchy_header TYPE treev_hhdr.
  PERFORM build_hierarchy_header CHANGING l_hierarchy_header.

* Define as características das colunas
  PERFORM build_fieldcatalog.

  ls_vari-report     = sy-repid.
  ls_vari-variant    = p_vari2.
  ls_vari-handle     = c_hande.
*  ls_vari-log_group  = 'PROG'.
*  ls_vari-username   = space.
*  ls_vari-text       = space.
*  ls_vari-dependvars = space.

* Tabela 'gt_despacho_tree' deve estar vazia e global
  CALL METHOD g_alv_tree->set_table_for_first_display
    EXPORTING
      is_variant          = ls_vari
      i_save              = c_save
      is_hierarchy_header = l_hierarchy_header
    CHANGING
      it_fieldcatalog     = gt_fieldcatalog
      it_outtab           = gt_despacho_tree. "tabela deve estar vazia!

* Monta Hierarquia do ALV Tree
  PERFORM create_hierarchy.

* Extende funções do MENU
  PERFORM change_toolbar.

  PERFORM register_events.

  CALL METHOD g_alv_tree->update_calculations.

* Envia os dados para o frontend.
  CALL METHOD g_alv_tree->frontend_update.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_HIERARCHY_HEADER
*&---------------------------------------------------------------------*
FORM build_hierarchy_header  CHANGING p_hierarchy_header TYPE treev_hhdr.

  p_hierarchy_header-heading = 'Usuários/Ordens'(044).
  p_hierarchy_header-tooltip = 'Usuários/Ordens'(044).
  p_hierarchy_header-width = 40.
  p_hierarchy_header-width_pix = ''.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
FORM build_fieldcatalog .

  DATA: ls_fieldcatalog TYPE lvc_s_fcat.

  REFRESH gt_fieldcatalog[].

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'USUARIO'.
  ls_fieldcatalog-coltext   = 'Usuário'(045).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'NOME'.
  ls_fieldcatalog-coltext   = 'Nome'(046).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'PERNR'.
  ls_fieldcatalog-coltext   = 'Matrícula'(047).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '14'.
  ls_fieldcatalog-no_out    = ''.
  ls_fieldcatalog-no_zero   = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'AUFNR'.
  ls_fieldcatalog-coltext   = 'Ordem'(010).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '12'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'AUART'.
  ls_fieldcatalog-coltext   = 'Tipo Ordem'(011).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  IF p_ordens = 'X'.
    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'VORNR'.
    ls_fieldcatalog-coltext   = 'Nº Operação'(048).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'SUBOPER'.
    ls_fieldcatalog-coltext   = 'SubOperação'(049).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = 'X'.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

  ELSEIF p_oper = 'X'.
    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'VORNR'.
    ls_fieldcatalog-coltext   = 'Nº Operação'(048).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'SUBOPER'.
    ls_fieldcatalog-coltext   = 'SubOperação'(049).
    ls_fieldcatalog-just      = 'C'.
    ls_fieldcatalog-outputlen = '10'.
    ls_fieldcatalog-no_out    = ''.
    APPEND ls_fieldcatalog TO gt_fieldcatalog.

*** SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO @DATA(lv_confirmacao).
    DATA: lv_confirmacao LIKE /ptloms/tb033-confirmacao.
    SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO lv_confirmacao.

    CLEAR ls_fieldcatalog.
    ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
    ls_fieldcatalog-fieldname = 'ARBEI'.
    IF lv_confirmacao = 'H'.
      ls_fieldcatalog-coltext = 'Trab.Prev.(H)'(050).
    ELSEIF lv_confirmacao = 'MIN'.
      ls_fieldcatalog-coltext = 'Trab.Prev.(Min)'(051).
    ELSE.
      ls_fieldcatalog-coltext   = 'Trab.Prev.'(052).
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
  ls_fieldcatalog-coltext   = 'Nota'(012).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-no_zero   = 'X'.
  ls_fieldcatalog-no_out    = ''.
  ls_fieldcatalog-convexit  = 'ALPHA'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'PRIOK'.
  ls_fieldcatalog-coltext   = 'Prioridade'(013).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

***  CLEAR ls_fieldcatalog.
***  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
***  ls_fieldcatalog-fieldname = 'GEWRK'.
***  ls_fieldcatalog-coltext   = 'ID Centro Trabalho'(014).
***  ls_fieldcatalog-just      = 'C'.
***  ls_fieldcatalog-outputlen = '10'.
***  ls_fieldcatalog-no_out    = 'X'.
***  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'ARBPL'.
  ls_fieldcatalog-coltext   = 'Centro Trabalho'(015).
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
  ls_fieldcatalog-coltext   = 'Data-base do fim'(017).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-datatype  = 'DATS'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'IDAT1'.
  ls_fieldcatalog-coltext   = 'Data da liberação'(018).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-datatype  = 'DATS'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'KTEXT'.
  ls_fieldcatalog-coltext   = 'Texto breve'(019).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'IWERK'.
  ls_fieldcatalog-coltext   = 'Centro Plan.Man.'(020).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'INGPR'.
  ls_fieldcatalog-coltext   = 'Grupo de planejamento'(021).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'TPLNR'.
  ls_fieldcatalog-coltext   = 'Local de instalação'(022).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'PLTXT'.
  ls_fieldcatalog-coltext   = 'Des.Local de inst.'(053).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'EQUNR'.
  ls_fieldcatalog-coltext   = 'Nº equipamento'(024).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-no_out    = ''.
  ls_fieldcatalog-no_zero   = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'EQKTX'.
  ls_fieldcatalog-coltext   = 'Desc.Nº equipamento'(025).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'DATA_ASSOCIACAO'.
  ls_fieldcatalog-coltext   = 'Data da Associação'(054).
  ls_fieldcatalog-just      = 'C'.
* 14/03/2023 - Formatar data - Início
*  ls_fieldcatalog-outputlen = '20'.
* 14/03/2023 - Formatar data - Fim
  ls_fieldcatalog-datatype  = 'DATS'.
  ls_fieldcatalog-inttype   = 'D'.
  ls_fieldcatalog-intlen    = '000008'.
  ls_fieldcatalog-dd_outlen = '000010'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'HORA_ASSOCIACAO'.
  ls_fieldcatalog-coltext   = 'Desc.Nº equipamento'(025).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'STATUS_SIS'.
  ls_fieldcatalog-coltext   = 'Status Sistema'(028).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'STATUS_USU'.
  ls_fieldcatalog-coltext   = 'Status Usuário'(029).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

***  CLEAR ls_fieldcatalog.
***  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
***  ls_fieldcatalog-fieldname = 'OBJNR'.
***  ls_fieldcatalog-coltext   = 'Nº objeto'(055).
***  ls_fieldcatalog-just      = 'C'.
***  ls_fieldcatalog-outputlen = '10'.
***  ls_fieldcatalog-no_out    = 'X'.
***  APPEND ls_fieldcatalog TO gt_fieldcatalog.

***  CLEAR ls_fieldcatalog.
***  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
***  ls_fieldcatalog-fieldname = 'ARBID'.
***  ls_fieldcatalog-coltext   = 'ID-objeto do centro trabalho'(056).
***  ls_fieldcatalog-just      = 'C'.
***  ls_fieldcatalog-outputlen = '10'.
***  ls_fieldcatalog-no_out    = 'X'.
***  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'LTXA1'.
  ls_fieldcatalog-coltext   = 'Txt.breve operação'(057).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'ARTPR'.
  ls_fieldcatalog-coltext   = 'Tipo de prioridade'(058).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'PRIOKX'.
  ls_fieldcatalog-coltext   = 'Prioridade'(013).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = ''.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'INNAM'.
  ls_fieldcatalog-coltext   = 'Desc.Grp.Planj.'(059).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '10'.
  ls_fieldcatalog-no_out    = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'NAME1'.
  ls_fieldcatalog-coltext   = 'Descrição cliente'(093).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '25'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'KUNNR'.
  ls_fieldcatalog-coltext   = 'Cliente'(094).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-no_zero   = 'X'.
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'STRAS'.
  ls_fieldcatalog-coltext   = 'Endereço'(095).
  ls_fieldcatalog-just      = 'L'.
  ls_fieldcatalog-outputlen = '25'.
  ls_fieldcatalog-tooltip   = 'Endereço do cliente'(101).
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'HOUSE_NUM1'.
  ls_fieldcatalog-coltext   = 'Número'(096).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-tooltip   = 'Número do cliente'(102).
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'ORT02'.
  ls_fieldcatalog-coltext   = 'Bairro'(097).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-tooltip   = 'Bairro do cliente'(103).
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'ORT01'.
  ls_fieldcatalog-coltext   = 'Cidade'(098).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-tooltip   = 'Cidade do cliente'(104).
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'REGIO'.
  ls_fieldcatalog-coltext   = 'Estado'(099).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-tooltip   = 'Estado do cliente'(105).
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-ref_table = 'GT_DESPACHO_TREE'.
  ls_fieldcatalog-fieldname = 'TELF1'.
  ls_fieldcatalog-coltext   = 'Telefone'(100).
  ls_fieldcatalog-just      = 'C'.
  ls_fieldcatalog-outputlen = '20'.
  ls_fieldcatalog-tooltip   = 'Telefone do cliente'(106).
  APPEND ls_fieldcatalog TO gt_fieldcatalog.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_HIERARCHY
*&---------------------------------------------------------------------*
FORM create_hierarchy .

  o_cl008->busca_dados_tree( CHANGING it_despacho_tree = gt_despacho_tree
                                      it_tb026         = gt_tb026
                                      it_nodes         = gt_nodes
                                      g_alv_tree       = g_alv_tree ).

* 14/03/2023 - Ajuste data da associação - Início
*  LOOP AT gt_despacho_tree ASSIGNING FIELD-SYMBOL(<fs_despacho>).
*    IF <fs_despacho>-data_associacao IS NOT INITIAL.
*      CONCATENATE <fs_despacho>-data_associacao+6(2) '.' <fs_despacho>-data_associacao+4(2) '.' <fs_despacho>-data_associacao(4) INTO <fs_despacho>-data_associacao .
*    ENDIF.
*  ENDLOOP.
* 14/03/2023 - Ajuste data da associação - Fim
*  DATA: lt_despacho_tree TYPE STANDARD TABLE OF /ptloms/cl008=>ty_despacho_tree. "ty_despacho_tree
**        lt_status        TYPE STANDARD TABLE OF jstat.
*
*  DATA: ls_despacho_tree TYPE /ptloms/cl008=>ty_despacho_tree, "ty_despacho_tree
*        ls_layout_node   TYPE lvc_s_layn.
*
*  DATA: l_user      TYPE /ptloms/tb013-usuario,
*        l_user_last TYPE /ptloms/tb013-usuario.
*
*  DATA: l_user_key TYPE lvc_nkey,
*        l_last_key TYPE lvc_nkey,
*        l_top_key  TYPE lvc_nkey.
*
*  DATA: lv_objnr     TYPE jsto-objnr,
*        lv_desprezar TYPE char1.
*
*  DATA: o_oms TYPE REF TO /ptloms/cl001.
*
*  IF p_f_tree = 'X'.
*    DATA(s_werks_aux) = s_werks[].
*    DATA(s_aufnr_aux) = s_aufnr[].
*    DATA(s_auart_aux) = s_auart[].
*    DATA(s_qmnum_aux) = s_qmnum[].
*    DATA(s_priok_aux) = s_priok[].
*    DATA(s_tplnr_aux) = s_tplnr[].
*    DATA(s_equnr_aux) = s_equnr[].
*    DATA(s_iwerk_aux) = s_iwerk[].
*    DATA(s_ingpr_aux) = s_ingpr[].
*    DATA(s_ilart_aux) = s_ilart[].
*    DATA(r_objid_aux) = r_objid[]. "s_gewrk.
*    DATA(s_gstrp_aux) = s_gstrp[].
*  ENDIF.
*
** Seleciona ordens associadas
*  IF p_ordens = 'X'.
** Na visão ordem, seleciona as ordens associadas em que VORNR = vazio
*    SELECT *
*      FROM /ptloms/tb026
*      INTO TABLE gt_tb026
*      WHERE vornr        = space
*        AND usuario      IN s_usuapp
*        AND desassociado = space.
*
*  ELSEIF p_oper = 'X'.
** Na visão operação, seleciona as ordens associadas em que VORNR <> vazio
*    SELECT *
*      FROM /ptloms/tb026
*      INTO TABLE gt_tb026
*      WHERE vornr        <> space
*        AND usuario      IN s_usuapp
*        AND desassociado = space.
*  ENDIF.
*
** Ordena tabela
*  SORT gt_tb026 BY usuario         ASCENDING
*                   aufnr           ASCENDING
*                   vornr           ASCENDING
*                   suboper         ASCENDING
*                   data_associacao ASCENDING
*                   hora_associacao ASCENDING.
*
*  IF gt_tb026[] IS NOT INITIAL.
*
** Busca dados de usuário
*    SELECT *
*      FROM /ptloms/tb013
*      INTO TABLE @DATA(lt_tb013)
*      FOR ALL ENTRIES IN @gt_tb026
*      WHERE usuario = @gt_tb026-usuario.
*
** Busca dados de ordem
*    IF p_ordens = 'X'.
*      SELECT aufnr, auart, qmnum, priok, gewrk,
*             gstrp, gltrp, idat1, ktext, iwerk,
*             ingpr, tplnr, equnr, artpr, objnr
*      FROM viaufks
*      INTO CORRESPONDING FIELDS OF TABLE @lt_despacho_tree
*      FOR ALL ENTRIES IN @gt_tb026
*      WHERE aufnr = @gt_tb026-aufnr
*          AND werks IN @s_werks_aux
****        AND gewrk IN @r_objid
****        AND gstrp IN @s_gstrp.
*          AND aufnr IN @s_aufnr_aux
*          AND auart IN @s_auart_aux
*          AND qmnum IN @s_qmnum_aux
*          AND priok IN @s_priok_aux
*          AND tplnr IN @s_tplnr_aux
*          AND equnr IN @s_equnr_aux
*          AND iwerk IN @s_iwerk_aux
*          AND ingpr IN @s_ingpr_aux
*          AND ilart IN @s_ilart_aux
*          AND gewrk IN @r_objid_aux "s_gewrk.
*          AND gstrp IN @s_gstrp_aux.
*
*    ELSEIF p_oper = 'X'.
*      SELECT a~aufnr, a~auart, a~qmnum, a~priok, a~gewrk,
*             a~gstrp, a~gltrp, a~idat1, a~ktext, a~iwerk,
*             a~ingpr, a~tplnr, a~equnr, c~vornr, c~arbid,
*             c~ltxa1, a~artpr, a~objnr, c~aufpl, c~aplzl,
*             c~sumnr, c~pernr, d~arbei, d~fsavd, d~fsedd
*      FROM viaufks AS a INNER JOIN afko AS b ON a~aufnr = b~aufnr
*      INNER JOIN afvc AS c ON b~aufpl = c~aufpl
*      INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
**      INTO CORRESPONDING FIELDS OF TABLE @lt_despacho_tree
*      INTO TABLE @DATA(lt_despacho_tree_aux)
*      FOR ALL ENTRIES IN @gt_tb026
*      WHERE a~aufnr EQ @gt_tb026-aufnr
*        AND a~werks IN @s_werks_aux
****        AND a~gewrk IN @r_objid
****        AND a~gstrp IN @s_gstrp
*        AND c~phflg EQ @space
*        AND d~fsavd IN @s_datope
*        AND a~aufnr IN @s_aufnr_aux
*        AND a~auart IN @s_auart_aux
*        AND a~qmnum IN @s_qmnum_aux
*        AND a~priok IN @s_priok_aux
*        AND a~tplnr IN @s_tplnr_aux
*        AND a~equnr IN @s_equnr_aux
*        AND a~iwerk IN @s_iwerk_aux
*        AND a~ingpr IN @s_ingpr_aux
*        AND a~ilart IN @s_ilart_aux
*        AND a~gewrk IN @r_objid_aux "s_gewrk.
*        AND a~gstrp IN @s_gstrp_aux.
*
** Na visão Operação, exibe apenas Operações sem matrícula atribuída
*      IF p_oper = 'X' AND p_mat_at = 'X'.
*        DELETE lt_despacho_tree_aux WHERE pernr IS NOT INITIAL.
*      ENDIF.
*
*      LOOP AT lt_despacho_tree_aux INTO DATA(ls_despacho_tree_aux).
*        CLEAR ls_despacho_tree.
*        MOVE-CORRESPONDING ls_despacho_tree_aux TO ls_despacho_tree.
*        CLEAR ls_despacho_tree-arbei.
*        APPEND ls_despacho_tree TO lt_despacho_tree.
*      ENDLOOP.
*    ENDIF.
*
****    IF p_f_tree = 'X'.
****      DELETE lt_despacho_tree WHERE aufnr NOT IN s_aufnr.
****      DELETE lt_despacho_tree WHERE auart NOT IN s_auart.
****      DELETE lt_despacho_tree WHERE qmnum NOT IN s_qmnum.
****      DELETE lt_despacho_tree WHERE priok NOT IN s_priok.
****      DELETE lt_despacho_tree WHERE tplnr NOT IN s_tplnr.
****      DELETE lt_despacho_tree WHERE equnr NOT IN s_equnr.
****      DELETE lt_despacho_tree WHERE iwerk NOT IN s_iwerk.
****      DELETE lt_despacho_tree WHERE ingpr NOT IN s_ingpr.
*****      DELETE lt_despacho_tree WHERE ILART NOT IN S_ILART.
****      DELETE lt_despacho_tree WHERE gewrk NOT IN r_objid."s_gewrk.
****      DELETE lt_despacho_tree WHERE gstrp NOT IN s_gstrp.
****    ENDIF.
*
*    IF lt_despacho_tree[] IS NOT INITIAL.
*
** Seleciona Ordens associadas
*      SELECT aufnr, vornr, suboper, usuario, data_associacao, hora_associacao
*        FROM /ptloms/tb026
*        INTO TABLE @DATA(lt_tb026_associada)
*        FOR ALL ENTRIES IN @gt_despacho
*        WHERE aufnr = @gt_despacho-aufnr.
*
** Seleciona descrição dos Locais de Instalação
*      SELECT tplnr, pltxt
*        FROM iflotx
*        INTO TABLE @DATA(lt_iflotx)
*        FOR ALL ENTRIES IN @lt_despacho_tree
*        WHERE spras = @sy-langu
*          AND tplnr = @lt_despacho_tree-tplnr.
*
** Seleciona descrição dos equipamentos
*      SELECT equnr, eqktx
*        FROM v_equi
*        INTO TABLE @DATA(lt_v_equi)
*        FOR ALL ENTRIES IN @lt_despacho_tree
*        WHERE txasp EQ 'X'
*          AND owner EQ @space
*          AND spras EQ @sy-langu
*          AND equnr = @lt_despacho_tree-equnr.
*
** Busca descrição do centro de trabalho
*      IF p_ordens = 'X'.
*        SELECT objty, objid, arbpl
*          FROM crhd
*          INTO TABLE @DATA(lt_crhd)
*          FOR ALL ENTRIES IN @lt_despacho_tree
*          WHERE objid = @lt_despacho_tree-gewrk.
*      ELSEIF p_oper = 'X'.
*        SELECT objty, objid, arbpl
*          FROM crhd
*          INTO TABLE @lt_crhd
*          FOR ALL ENTRIES IN @lt_despacho_tree
*          WHERE objid = @lt_despacho_tree-arbid.
*      ENDIF.
*
** Busca descrição da prioridade
*      SELECT spras, artpr, priok, priokx
*        FROM t356_t
*        INTO TABLE @DATA(lt_t356_t)
*        FOR ALL ENTRIES IN @lt_despacho_tree
*        WHERE spras  = @sy-langu
*          AND artpr  = @lt_despacho_tree-artpr
*          AND priok = @lt_despacho_tree-priok.
*
** Busca SubOperações
*      IF p_oper = 'X'.
*        SELECT a~aufpl, a~aplzl, a~vornr, a~sumnr, a~objnr
*          FROM afvc AS a
*          INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
*          INTO TABLE @DATA(lt_sub_operacoes)
*          FOR ALL ENTRIES IN @lt_despacho_tree
*          WHERE a~aufpl = @lt_despacho_tree-aufpl
*            AND a~aplzl = @lt_despacho_tree-aplzl
*            AND a~phflg = @space
*            AND b~fsavd IN @s_datope.
*      ENDIF.
*
*      LOOP AT lt_despacho_tree ASSIGNING FIELD-SYMBOL(<fs_despacho_tree>).
*
*        DATA(lv_tabix) = sy-tabix.
*
*        READ TABLE lt_tb026_associada INTO DATA(ls_tb026_associada) WITH KEY aufnr = <fs_despacho_tree>-aufnr.
*        IF sy-subrc EQ 0.
*          <fs_despacho_tree>-data_associacao = ls_tb026_associada-data_associacao.
*          <fs_despacho_tree>-hora_associacao = ls_tb026_associada-hora_associacao.
*        ENDIF.
*
*        READ TABLE lt_iflotx INTO DATA(ls_iflotx) WITH KEY tplnr = <fs_despacho_tree>-tplnr.
*        IF sy-subrc EQ 0.
*          <fs_despacho_tree>-pltxt = ls_iflotx-pltxt.
*        ENDIF.
*
*        READ TABLE lt_v_equi INTO DATA(ls_v_equi) WITH KEY equnr = <fs_despacho_tree>-equnr.
*        IF sy-subrc EQ 0.
*          <fs_despacho_tree>-eqktx = ls_v_equi-eqktx.
*        ENDIF.
*
*        IF p_oper = 'X'.
*          <fs_despacho_tree>-gewrk = <fs_despacho_tree>-arbid.
*        ENDIF.
*
*        READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = <fs_despacho_tree>-gewrk.
*        IF sy-subrc = 0.
*          <fs_despacho_tree>-arbpl = ls_crhd-arbpl.
*        ENDIF.
*
*        READ TABLE lt_t356_t INTO DATA(ls_t356_t) WITH KEY artpr = <fs_despacho_tree>-artpr
*                                                           priok = <fs_despacho_tree>-priok.
*        IF sy-subrc EQ 0.
*          <fs_despacho_tree>-priokx = ls_t356_t-priokx.
*        ENDIF.
*
*        IF p_oper = 'X'.
*          IF <fs_despacho_tree>-sumnr IS NOT INITIAL.
*            READ TABLE lt_sub_operacoes INTO DATA(ls_sub_operacoes) WITH KEY aufpl = <fs_despacho_tree>-aufpl
*                                                                             aplzl = <fs_despacho_tree>-sumnr.
*            IF sy-subrc EQ 0.
*              <fs_despacho_tree>-suboper = <fs_despacho_tree>-vornr.
*              <fs_despacho_tree>-vornr   = ls_sub_operacoes-vornr.
*            ENDIF.
*          ENDIF.
*
*          READ TABLE lt_sub_operacoes INTO ls_sub_operacoes WITH KEY aufpl = <fs_despacho_tree>-aufpl
*                                                                     aplzl = <fs_despacho_tree>-aplzl.
*          IF sy-subrc EQ 0.
*            <fs_despacho_tree>-objnr_oper_sub = ls_sub_operacoes-objnr.
*          ENDIF.
*        ENDIF.
*
*        CLEAR lv_objnr.
*
*        IF p_ordens = 'X'.
*          lv_objnr = <fs_despacho_tree>-objnr.
*        ELSEIF p_oper = 'X'.
*          lv_objnr = <fs_despacho_tree>-objnr_oper_sub.
*        ENDIF.
*
** Exclui as Ordens ENCE, ENTE e CONF
*        CLEAR lv_desprezar.
*        CALL FUNCTION '/PTLOMS/MF008'
*          EXPORTING
*            im_objnr     = lv_objnr
*          IMPORTING
*            ex_desprezar = lv_desprezar.
*
*        IF lv_desprezar = 'X'.
*          DELETE lt_despacho_tree INDEX lv_tabix.
*          CONTINUE.
*        ENDIF.
*
**        REFRESH lt_status[].
*** Busca status da Ordem
**        CALL FUNCTION 'STATUS_READ'
**          EXPORTING
**            client           = sy-mandt
**            objnr            = lv_objnr
**            only_active      = 'X'
**          TABLES
**            status           = lt_status
**          EXCEPTIONS
**            object_not_found = 1
**            OTHERS           = 2.
**
*** Verifica se a Ordem possui o status ENTE I0045 (Encerrado Tecnicamente)
**        READ TABLE lt_status WITH KEY stat = 'I0045' TRANSPORTING NO FIELDS.
**        IF sy-subrc EQ 0.
**          DELETE lt_despacho_tree INDEX lv_tabix.
**          CONTINUE.
**        ELSE.
*** Verifica se a Ordem possui o status ENCE I0046 (Encerrado)
**          READ TABLE lt_status WITH KEY stat = 'I0046' TRANSPORTING NO FIELDS.
**          IF sy-subrc EQ 0.
**            DELETE lt_despacho_tree INDEX lv_tabix.
**            CONTINUE.
**          ELSE.
*** Verifica se a Ordem possui o status CONF I0009 (Confirmado)
**            READ TABLE lt_status WITH KEY stat = 'I0009' TRANSPORTING NO FIELDS.
**            IF sy-subrc EQ 0.
**              DELETE lt_despacho_tree INDEX lv_tabix.
**              CONTINUE.
**            ENDIF.
**          ENDIF.
**        ENDIF.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.
*
*  " Necessário eliminar todos os nodes para então adicioná-los novamente
*  CALL METHOD g_alv_tree->delete_all_nodes.
*
**   Imagem ao abrir
*  ls_layout_node-n_image   = icon_usergroup.
*
**   Imagem ao expandir
*  ls_layout_node-exp_image = icon_usergroup.
*
** Define nó superior
*  CALL METHOD g_alv_tree->add_node
*    EXPORTING
*      i_relat_node_key = ''
*      i_relationship   = cl_gui_column_tree=>relat_last_child
*      is_node_layout   = ls_layout_node
*      i_node_text      = 'Usuários'(069)
*    IMPORTING
*      e_new_node_key   = l_top_key.
*
**  PERFORM f_busca_horas_planejadas.
*
*  CREATE OBJECT o_oms.
*
*  LOOP AT gt_tb026 INTO DATA(ls_026).
*
*    CLEAR ls_despacho_tree.
*
*    IF p_ordens = 'X'.
*      READ TABLE lt_despacho_tree INTO ls_despacho_tree WITH KEY aufnr = ls_026-aufnr.
*      IF sy-subrc NE 0.
*        CONTINUE.
*      ENDIF.
*    ELSEIF p_oper = 'X'.
*      READ TABLE lt_despacho_tree INTO ls_despacho_tree WITH KEY aufnr   = ls_026-aufnr
*                                                                 vornr   = ls_026-vornr
*                                                                 suboper = ls_026-suboper.
*      IF sy-subrc NE 0.
*        CONTINUE.
*      ENDIF.
*      DATA(lv_tabix_aux) = sy-tabix.
*      ls_despacho_tree-ktext = ls_despacho_tree-ltxa1.
*
*      READ TABLE lt_despacho_tree_aux INTO ls_despacho_tree_aux INDEX lv_tabix_aux.
*      IF sy-subrc EQ 0.
*        DATA(rt_data_conf_usuario) = o_oms->out_monta_range_data_usuario( ls_026-usuario ).
*        IF ls_despacho_tree_aux-fsavd IN rt_data_conf_usuario OR
*           ls_despacho_tree_aux-fsedd IN rt_data_conf_usuario.
*          ls_despacho_tree-arbei = ls_despacho_tree_aux-arbei.
*        ENDIF.
*      ENDIF.
*      REFRESH rt_data_conf_usuario[].
*    ENDIF.
*
*    MOVE-CORRESPONDING ls_026 TO ls_despacho_tree.
*
*    READ TABLE lt_tb013 INTO DATA(ls_013) WITH KEY usuario = ls_despacho_tree-usuario.
*    IF sy-subrc EQ 0.
*      MOVE-CORRESPONDING ls_013 TO ls_despacho_tree.
*    ENDIF.
*
*    l_user = ls_despacho_tree-usuario.
*
*    IF l_user NE l_user_last.
*
*      l_user_last = l_user.
*
** Usuário nodes
*      PERFORM add_user USING l_user
*                             l_top_key
*                    CHANGING l_user_key.
*    ENDIF.
*
**    PERFORM f_horas_planejadas_filter USING ls_despacho_tree-usuario
**                                            ls_despacho_tree-aufpl
**                                            ls_despacho_tree-aplzl
**                                   CHANGING ls_despacho_tree-arbei.
*
** Nó inferior
*    PERFORM add_complete_line USING  ls_despacho_tree
*                                     l_user_key
*                            CHANGING l_last_key.
*
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  add_user
*&---------------------------------------------------------------------*
FORM add_user USING    p_user      TYPE c
                       p_relat_key TYPE lvc_nkey
              CHANGING p_node_key  TYPE lvc_nkey.

* Declaração de estrutura
  DATA: ls_despacho_tree TYPE /ptloms/et079, "ty_despacho_tree
        ls_nodes         LIKE LINE OF gt_nodes,
        ls_layout_node   TYPE lvc_s_layn..

* Declaração de variáveis
  DATA: lv_node_text TYPE lvc_value,
        lv_user_name TYPE /ptloms/tb013-nome, "output string for user
        lv_hr_plan   TYPE char20.

* Recupera nome do usuário
  PERFORM get_user USING p_user
                   CHANGING lv_user_name.

** Recupera Horas Planejadas
*  PERFORM f_horas_planejadas USING p_user
*                            CHANGING lv_hr_plan.

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
***  READ TABLE gt_nodes ASSIGNING FIELD-SYMBOL(<fs_nodes>) WITH KEY usuario = p_user.
  FIELD-SYMBOLS: <fs_nodes> LIKE LINE OF gt_nodes.
  READ TABLE gt_nodes ASSIGNING <fs_nodes> WITH KEY usuario = p_user.
  IF sy-subrc EQ 0.
    <fs_nodes>-node = p_node_key.
  ELSE.
    ls_nodes-node = p_node_key.
    ls_nodes-usuario = p_user.
    APPEND ls_nodes TO gt_nodes.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_USER
*&---------------------------------------------------------------------*
FORM get_user  USING    p_user TYPE /ptloms/tb013-usuario
               CHANGING p_user_name TYPE /ptloms/tb013-nome.

  CHECK p_user IS NOT INITIAL.

  SELECT SINGLE nome
    FROM /ptloms/tb013
    INTO p_user_name
    WHERE usuario = p_user.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  add_complete_line
*&---------------------------------------------------------------------*
FORM add_complete_line USING   ps_despacho_tree TYPE /ptloms/et079 "ty_despacho_tree
                               p_relat_key TYPE lvc_nkey
                     CHANGING  p_node_key TYPE lvc_nkey.

  DATA: ls_layout_node TYPE lvc_s_layn.

  DATA: l_node_text TYPE lvc_value.

  DATA: lv_data TYPE char10.

  MOVE ps_despacho_tree-aufnr TO l_node_text.

***  l_node_text = |{ l_node_text ALPHA = OUT }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = l_node_text
    IMPORTING
      output = l_node_text.

  IF ps_despacho_tree-pernr IS INITIAL.
* Cor
    ls_layout_node-style   = 5.
  ENDIF.

  DATA: lv_dats TYPE d.
  CLEAR lv_dats.
  WRITE ps_despacho_tree-data_associacao(08) TO  lv_dats.
  CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
    EXPORTING
      input  = lv_dats
    IMPORTING
      output = lv_data.
* 15/03/2023 - Converter data tela para formato externo devido campo do tipo char20
*  CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
*    EXPORTING
*      date_internal            = CONV datum( ps_despacho_tree-data_associacao )
*    IMPORTING
*      date_external            = lv_data
*    EXCEPTIONS
*      date_internal_is_invalid = 1
*      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  ps_despacho_tree-data_associacao = lv_data.

* 15/03/2023 - Converter data tela para formato externo devido campo do tipo char20

*   Imagem ao abrir
  ls_layout_node-n_image   = icon_order.

*   Imagem ao expandir
  ls_layout_node-exp_image = icon_order.

  CALL METHOD g_alv_tree->add_node
    EXPORTING
      i_relat_node_key = p_relat_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      is_outtab_line   = ps_despacho_tree
      is_node_layout   = ls_layout_node
      i_node_text      = l_node_text
    IMPORTING
      e_new_node_key   = p_node_key.

ENDFORM.                               " add_complete_line
*&---------------------------------------------------------------------*
*&      Form  CHANGE_TOOLBAR
*&---------------------------------------------------------------------*
FORM change_toolbar .

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
          text      = 'Desassociar Ordem'(040).
*         quickinfo = 'Desassociar Ordem'(040).   "Desassociar Ordem

* add Standard Button to toolbar
      CALL METHOD g_toolbar->add_button
        EXPORTING
          fcode     = 'TRANSFERE'
          icon      = icon_transfer
          butn_type = cntb_btype_button
          text      = 'Transferir Ordens'(041).
*         quickinfo = 'Transferir Ordens'(041).   "Transferir Ordens

    ELSEIF p_oper = 'X'.
* add Standard Button to toolbar
      CALL METHOD g_toolbar->add_button
        EXPORTING
          fcode     = 'DESASSOCIA'
          icon      = icon_disconnect
          butn_type = cntb_btype_button
          text      = 'Desassociar Operação'(042).
*         quickinfo = 'Desassociar Operação'(042).   "Desassociar Operação

* add Standard Button to toolbar
      CALL METHOD g_toolbar->add_button
        EXPORTING
          fcode     = 'TRANSFERE'
          icon      = icon_transfer
          butn_type = cntb_btype_button
          text      = 'Transferir Operação'(043).
*         quickinfo = 'Transferir Operação'(043).   "Transferir Operação
    ENDIF.
  ENDIF.

**** add Standard Button to toolbar
***  CALL METHOD g_toolbar->add_button
***    EXPORTING
***      fcode     = 'ASSOCIA'
***      icon      = icon_reference_list
***      butn_type = cntb_btype_button
***      text      = 'Associar à outro Usuário'
***      quickinfo = 'Associar à outro Usuário'.   "Associa à outro Usuário
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REGISTER_EVENTS
*&---------------------------------------------------------------------*
FORM register_events .

  DATA: lt_events        TYPE cntl_simple_events,
        l_event          TYPE cntl_simple_event,
        l_event_receiver TYPE REF TO lcl_toolbar_event_receiver.

  CALL METHOD g_alv_tree->get_registered_events
    IMPORTING
      events = lt_events.

* register events on frontend
  CALL METHOD g_alv_tree->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.
*-------------------------------------------------------------------

  CREATE OBJECT l_event_receiver.
  SET HANDLER l_event_receiver->on_function_selected FOR g_toolbar.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DESASSOCIAR
*&---------------------------------------------------------------------*
FORM f_desassociar .

  DATA: lt_selected_nodes TYPE lvc_t_nkey.

  DATA: ls_despacho_tree TYPE /ptloms/et079. "ty_despacho_tree

  DATA: lv_erro     TYPE char1,
        lv_confirma TYPE char1.

** Busca registro selecionado
*  PERFORM f_busca_registro_selecionado CHANGING ls_despacho_tree.
  PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

* Confirmar ação
  PERFORM f_popup_confirmar USING 'Pretende desassociar as ordens do usuário?'(070)
                         CHANGING lv_confirma.

  IF lv_confirma = 'X'.

***   LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
    DATA: ls_selected_nodes LIKE LINE OF lt_selected_nodes.
    LOOP AT lt_selected_nodes INTO ls_selected_nodes.

      CLEAR ls_despacho_tree.
      PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                        CHANGING ls_despacho_tree.
      IF ls_despacho_tree IS INITIAL.
        CONTINUE.
      ENDIF.

* Atualiza campos relativo à associação
      PERFORM f_atualiza_desassociacao USING ls_despacho_tree
                                             sy-datum
                                             sy-uzeit
                                             /ptloms/tb026-motivo_desassociacao
                                       CHANGING lv_erro.

      IF lv_erro IS INITIAL.

* Desassociar Matrícula do Usuário na Ordem/Operação
        PERFORM f_associa_mat_operacao USING ls_despacho_tree-aufnr
                                             ls_despacho_tree-vornr
                                             ls_despacho_tree-suboper
                                             ls_despacho_tree-usuario
                                             'X'. "Desassociar

* Atualiza status da Operação
        PERFORM f_atualiza_status_operacao USING ls_despacho_tree-aufnr
                                                 ls_despacho_tree-vornr
                                                 ls_despacho_tree-suboper
                                                 ls_despacho_tree-usuario
                                                 'X'.

* Atualiza ALV
        PERFORM f_atualiza_alv USING ls_despacho_tree.
      ENDIF.

    ENDLOOP.

    PERFORM f_delete_reg_selecionados.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUP_CONFIRMAR
*&---------------------------------------------------------------------*
FORM f_popup_confirmar USING p_text      TYPE char100
                    CHANGING p_confirma  TYPE char1.

  DATA: lv_rc TYPE c.

* Pop-up para confirmação
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      textline1      = p_text
*     textline2      = P_text2
      titel          = 'Confirmação'(071)
      cancel_display = ' '
    IMPORTING
      answer         = lv_rc.

  IF lv_rc EQ 'J'.
    p_confirma = 'X'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_PRIMEIRO_NO_SELEC
*&---------------------------------------------------------------------*
FORM f_busca_primeiro_no_selec CHANGING p_no TYPE lvc_nkey.

  DATA: lt_selected_nodes TYPE lvc_t_nkey.

* Determina node solecionado
  CALL METHOD g_alv_tree->get_selected_nodes
    CHANGING
      ct_selected_nodes = lt_selected_nodes.
  CALL METHOD cl_gui_cfw=>flush.

  READ TABLE lt_selected_nodes INTO p_no INDEX 1.
  IF sy-subrc NE 0.
    MESSAGE i000 WITH 'Marcar um nó'(072).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_NO_SELECIONADO
*&---------------------------------------------------------------------*
FORM f_busca_no_selecionado CHANGING p_no TYPE lvc_nkey.

  DATA: lt_selected_nodes TYPE lvc_t_nkey.

* Determina node solecionado
  CALL METHOD g_alv_tree->get_selected_nodes
    CHANGING
      ct_selected_nodes = lt_selected_nodes.
  CALL METHOD cl_gui_cfw=>flush.

  READ TABLE lt_selected_nodes INTO p_no INDEX 1.
  IF sy-subrc NE 0.
    MESSAGE i000 WITH 'Marcar um nó'(072).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_NO_SELECIONADO
*&---------------------------------------------------------------------*
FORM f_busca_registro_selecionado CHANGING ps_despacho_tree TYPE /ptloms/et079.

  DATA: lt_selected_nodes TYPE lvc_t_nkey.

* Determina node solecionado
  CALL METHOD g_alv_tree->get_selected_nodes
    CHANGING
      ct_selected_nodes = lt_selected_nodes.
  CALL METHOD cl_gui_cfw=>flush.

***  READ TABLE lt_selected_nodes INTO DATA(lv_selected_node) INDEX 1.
  DATA lv_selected_node LIKE LINE OF lt_selected_nodes.
  READ TABLE lt_selected_nodes INTO lv_selected_node INDEX 1.

  IF sy-subrc EQ 0.

* Retorno linha do node selecionado
    CALL METHOD g_alv_tree->get_outtab_line
      EXPORTING
        i_node_key    = lv_selected_node
      IMPORTING
        e_outtab_line = ps_despacho_tree.

  ELSE. "sy-subrc EQ 0
    MESSAGE i000 WITH 'Marcar um nó'(072).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DADOS_NO_SELECIONADO
*&---------------------------------------------------------------------*
FORM f_busca_dados_no_selecionado USING p_no             TYPE lvc_nkey
                               CHANGING ps_despacho_tree TYPE /ptloms/et079.

  IF p_no IS INITIAL.
    RETURN.
  ENDIF.

* Retorno linha do node selecionado
  CALL METHOD g_alv_tree->get_outtab_line
    EXPORTING
      i_node_key    = p_no
    IMPORTING
      e_outtab_line = ps_despacho_tree.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_REGISTROS_SELECIONADOS
*&---------------------------------------------------------------------*
FORM f_busca_registros_selecionados CHANGING pt_selected_nodes TYPE lvc_t_nkey.

* Determina node solecionado
  CALL METHOD g_alv_tree->get_selected_nodes
    CHANGING
      ct_selected_nodes = pt_selected_nodes.

  CALL METHOD cl_gui_cfw=>flush.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ASSOCIAR_OUTRO_USUARIO
*&---------------------------------------------------------------------*
FORM f_associar_outro_usuario .

  DATA: ls_despacho_tree TYPE /ptloms/et079.

  DATA: lv_erro     TYPE char1,
        lv_confirma TYPE char1.

* Busca registro selecionado
  PERFORM f_busca_registro_selecionado CHANGING ls_despacho_tree.

* Confirmar ação
  PERFORM f_popup_confirmar USING 'Pretende associar ordem à outro usuário?'(073)
                          CHANGING lv_confirma.

  IF lv_confirma = 'X'.

* Data e Hora da Desassociação
***    DATA(lv_datum) = sy-datum.
    DATA: lv_datum TYPE sy-datum.
    lv_datum = sy-datum.

***    DATA(lv_uzeit) = sy-uzeit.
    DATA: lv_uzeit TYPE sy-uzeit.
    lv_uzeit = sy-uzeit.

** Atualiza campos relativo à associação
*    PERFORM f_atualiza_desassociacao USING ls_despacho_tree
*                                           sy-datum
*                                           sy-uzeit
*                                           1
*                                  CHANGING lv_erro.
*
*    IF lv_erro IS INITIAL.
* Associa Ordem para outro usuário
    PERFORM f_associar USING sy-datum
                             sy-uzeit
                             ls_despacho_tree.
*    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDAR_SELECAO_ALV_TREE
*&---------------------------------------------------------------------*
FORM f_validar_selecao_alv_tree .

  DATA: lt_selected_nodes TYPE lvc_t_nkey.
  DATA: ls_despacho_tree TYPE /ptloms/et079.

  PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

***  LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
  DATA: ls_selected_nodes LIKE LINE OF lt_selected_nodes.
  LOOP AT lt_selected_nodes INTO ls_selected_nodes.

    CLEAR ls_despacho_tree.
    PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                      CHANGING ls_despacho_tree.
    IF ls_despacho_tree IS NOT INITIAL.
      RETURN.
    ENDIF.
  ENDLOOP.

  IF ls_despacho_tree IS INITIAL.
    MESSAGE e000 WITH 'Selecionar uma ordem específica'(074).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TRANSFERIR
*&---------------------------------------------------------------------*
FORM f_transferir .

  DATA: lv_no TYPE lvc_nkey.

  DATA: lt_selected_nodes TYPE lvc_t_nkey.

  DATA: ls_despacho_tree TYPE /ptloms/et079.

  DATA: lv_erro     TYPE char1,
        lv_confirma TYPE char1.

** Busca registro selecionado
*  PERFORM f_busca_registro_selecionado CHANGING ls_despacho_tree.
  PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

* Confirmar ação
  PERFORM f_popup_confirmar USING 'Pretende transferir ordem à outro usuário?'(075)
                         CHANGING lv_confirma.

  IF lv_confirma = 'X'.

*   Data e Hora da Desassociação
*** DATA(lv_datum) = sy-datum.
    DATA: lv_datum TYPE sy-datum.
    lv_datum = sy-datum.

*** DATA(lv_uzeit) = sy-uzeit.
    DATA: lv_uzeit TYPE sy-uzeit.
    lv_uzeit = sy-uzeit.

***   LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
    DATA: ls_selected_nodes LIKE LINE OF lt_selected_nodes.
    LOOP AT lt_selected_nodes INTO ls_selected_nodes.

      CLEAR ls_despacho_tree.
      PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                        CHANGING ls_despacho_tree.
      IF ls_despacho_tree IS INITIAL.
        CONTINUE.
      ENDIF.

* Atualiza campos relativo à associação
      PERFORM f_atualiza_desassociacao USING ls_despacho_tree
                                             lv_datum
                                             lv_uzeit
                                             1
                                    CHANGING lv_erro.

      IF lv_erro IS INITIAL.

* Desassociar Matrícula do Usuário na Ordem/Operação
        PERFORM f_associa_mat_operacao USING ls_despacho_tree-aufnr
                                             ls_despacho_tree-vornr
                                             ls_despacho_tree-suboper
                                             ls_despacho_tree-usuario
                                             'X'. "Desassociar

* Associa Ordem para outro usuário
        PERFORM f_associar USING lv_datum
                                 lv_uzeit
                                 ls_despacho_tree.
      ENDIF.

    ENDLOOP.

    PERFORM f_delete_reg_selecionados.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ATUALIZA_DESASSOCIACAO
*&---------------------------------------------------------------------*
FORM f_atualiza_desassociacao USING ps_despacho_tree TYPE /ptloms/et079
                                    p_datum          TYPE sy-datum
                                    p_uzeit          TYPE sy-uzeit
                                    p_motivo         TYPE /ptloms/tb026-motivo_desassociacao
                           CHANGING p_erro           TYPE char1.

  DATA: ls_026 TYPE /ptloms/tb026.

  IF ps_despacho_tree IS INITIAL.
    RETURN.
  ENDIF.

  MOVE-CORRESPONDING ps_despacho_tree TO ls_026.

  " 15/03/2023 - Converter data externa para interna devido campo não DATUM
  CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
    EXPORTING
      date_external            = ps_despacho_tree-data_associacao
      accept_initial_date      = 'X'
    IMPORTING
      date_internal            = ls_026-data_associacao
    EXCEPTIONS
      date_external_is_invalid = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  " 15/03/2023 - Converter data externa para interna devido campo não DATUM

  ls_026-data_desassociacao   = p_datum.
  ls_026-hora_desassociacao   = p_uzeit.
  ls_026-motivo_desassociacao = p_motivo.
  ls_026-desassociado         = 'X'.

  MODIFY /ptloms/tb026 FROM ls_026.

  IF sy-subrc EQ 0.
    MESSAGE s000 WITH 'Ordem desassociada com sucesso'(076).
    COMMIT WORK.
  ELSE.
    p_erro = 'X'.
    MESSAGE s000 WITH 'Erro ao desassociar ordem'(077).
    ROLLBACK WORK.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_DESPACHO
*&---------------------------------------------------------------------*
FORM f_grava_despacho .

* Declaração de tabela interna
  DATA: lt_tb026 TYPE STANDARD TABLE OF /ptloms/tb026.

* Declaração de estrutura
  DATA: ls_026           TYPE /ptloms/tb026,
        ls_despacho_tree TYPE /ptloms/et079.

* Loop para os registros (ordens) selecionadas para associção (despacho)
***LOOP AT o_rows INTO DATA(lv_row).
  DATA: lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.

*   Data e Hora da Desassociação
*** DATA(lv_datum) = sy-datum.
    DATA: lv_datum TYPE sy-datum.
    lv_datum = sy-datum.

*** DATA(lv_uzeit) = sy-uzeit.
    DATA: lv_uzeit TYPE sy-uzeit.
    lv_uzeit = sy-uzeit.

* Busca os dados do registro selecionado
*** READ TABLE gt_despacho INTO DATA(ls_despacho) INDEX lv_row.
    DATA: ls_despacho LIKE LINE OF gt_despacho.
    READ TABLE gt_despacho INTO ls_despacho INDEX lv_row.

    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ls_despacho TO ls_026.
      ls_026-usuario = wa_usuario-usuario.
      ls_026-data_associacao = lv_datum.
      ls_026-hora_associacao = lv_uzeit.
      APPEND ls_026 TO lt_tb026.
      PERFORM f_associa_mat_operacao USING ls_despacho-aufnr
                                           ls_despacho-vornr
                                           ls_despacho-suboper
                                           wa_usuario-usuario
                                           space.
    ENDIF.
  ENDLOOP.

  IF lt_tb026[] IS NOT INITIAL.

* Atualiza tabela de Despacho
    MODIFY /ptloms/tb026 FROM TABLE lt_tb026.
    IF sy-subrc EQ 0.

* Inclui Ordem no ALV Tree
      PERFORM f_add_ordem_alv_tree USING lv_datum lv_uzeit.

* Remove as ordens associadas do ALV principal
      LOOP AT lt_tb026 INTO ls_026.
        DELETE gt_despacho WHERE aufnr   = ls_026-aufnr
                             AND vornr   = ls_026-vornr
                             AND suboper = ls_026-suboper.

* Atualiza status da Operação
        PERFORM f_atualiza_status_operacao USING ls_026-aufnr
                                                 ls_026-vornr
                                                 ls_026-suboper
                                                 ls_026-usuario
                                                 space.
      ENDLOOP.

      COMMIT WORK.
      MESSAGE s000 WITH 'Orden(s) associada(s) com sucesso'(078).
    ELSE.
      ROLLBACK WORK.
      MESSAGE s000 WITH 'Erro ao associar orden(s)'(079) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_ORDEM_ALV_TREE
*&---------------------------------------------------------------------*
FORM f_add_ordem_alv_tree USING p_datum TYPE sy-datum
                                p_uzeit TYPE sy-uzeit.

* Declaração de tabelas
  DATA: lt_subtree_nodes  TYPE lvc_t_nkey.

* Declaração de estrutura
  DATA: ls_despacho_tree TYPE /ptloms/et079.

* Declaração de variáveis
  DATA: lv_user_key TYPE lvc_nkey,
        lv_user     TYPE /ptloms/tb013-usuario,
        lv_last_key TYPE lvc_nkey,
        lv_top_key  TYPE lvc_nkey.

  lv_user = wa_usuario-usuario.
  lv_top_key = '          1'.

* Usuário nodes
*** READ TABLE gt_despacho_tree INTO DATA(ls_nodes) WITH KEY usuario = wa_usuario-usuario.
  DATA: ls_nodes LIKE LINE OF gt_despacho_tree.
  READ TABLE gt_despacho_tree INTO ls_nodes WITH KEY usuario = wa_usuario-usuario.

* Caso seja a primeira ordem para o usuário, então criar o Nó Usuário
  IF sy-subrc NE 0.
    PERFORM add_user USING lv_user
                           lv_top_key
                  CHANGING lv_user_key.
  ELSE.

* Busca nó do usuário
    PERFORM f_busca_no_pai USING wa_usuario-usuario CHANGING lv_user_key.
  ENDIF.

* Loop para os registros (ordens) selecionadas para associção (despacho)
***  LOOP AT o_rows INTO DATA(lv_row).
  DATA: lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.

* Busca os dados do registro selecionado
*** READ TABLE gt_despacho INTO DATA(ls_despacho) INDEX lv_row.
    DATA: ls_despacho LIKE LINE OF gt_despacho.
    READ TABLE gt_despacho INTO ls_despacho INDEX lv_row.

    IF sy-subrc EQ 0.
      CLEAR ls_despacho_tree.
      MOVE-CORRESPONDING ls_despacho TO ls_despacho_tree.
      MOVE: wa_usuario-usuario TO ls_despacho_tree-usuario,
            wa_usuario-nome    TO ls_despacho_tree-nome,
            p_uzeit            TO ls_despacho_tree-hora_associacao,
            p_datum            TO ls_despacho_tree-data_associacao.

      IF p_ordens IS NOT INITIAL.

        SELECT SINGLE matricula
          FROM /ptloms/tb013
          INTO ls_despacho_tree-pernr
          WHERE usuario = ls_despacho_tree-usuario.

      ENDIF.

* Busca Matrícula associada
      SELECT SINGLE c~pernr
        FROM viaufks AS a INNER JOIN afko AS b ON a~aufnr = b~aufnr
        INNER JOIN afvc AS c ON b~aufpl = c~aufpl
        INTO ls_despacho_tree-pernr
        WHERE a~aufnr EQ ls_despacho_tree-aufnr
          AND c~vornr EQ ls_despacho_tree-vornr
          AND c~phflg EQ space.

* Nó inferior
      PERFORM add_complete_line USING  ls_despacho_tree
                                       lv_user_key
                              CHANGING lv_last_key.

    ENDIF.

  ENDLOOP.

*   update frontend
  CALL METHOD g_alv_tree->frontend_update.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_ORDEM_ALV_TREE_V2
*&---------------------------------------------------------------------*
FORM f_add_ordem_alv_tree_v2 USING p_datum          TYPE sy-datum
                                   p_uzeit          TYPE sy-uzeit
                                   ps_despacho_tree TYPE /ptloms/et079.

* Declaração de tabelas
  DATA: lt_subtree_nodes  TYPE lvc_t_nkey.

* Declaração de estrutura
  DATA: ls_despacho_tree TYPE /ptloms/et079.

* Declaração de variáveis
  DATA: lv_user_key TYPE lvc_nkey,
        lv_user     TYPE /ptloms/tb013-usuario,
        lv_last_key TYPE lvc_nkey,
        lv_top_key  TYPE lvc_nkey.

  lv_user = wa_usuario-usuario.
  lv_top_key = '          1'.

* Usuário nodes
*** READ TABLE gt_despacho_tree INTO DATA(ls_nodes) WITH KEY usuario = wa_usuario-usuario.
  DATA: ls_nodes LIKE LINE OF gt_despacho_tree.
  READ TABLE gt_despacho_tree INTO ls_nodes WITH KEY usuario = wa_usuario-usuario.

* Caso seja a primeira ordem para o usuário, então criar o Nó Usuário
  IF sy-subrc NE 0.
    PERFORM add_user USING lv_user
                           lv_top_key
                  CHANGING lv_user_key.
  ELSE.

* Busca nó do usuário
    PERFORM f_busca_no_pai USING wa_usuario-usuario CHANGING lv_user_key.
  ENDIF.

  CLEAR ls_despacho_tree.
  MOVE-CORRESPONDING ps_despacho_tree TO ls_despacho_tree.
  MOVE: wa_usuario-usuario TO ls_despacho_tree-usuario,
        wa_usuario-nome    TO ls_despacho_tree-nome,
        wa_usuario-matricula  TO ls_despacho_tree-pernr,
        p_datum            TO ls_despacho_tree-data_associacao,
        p_uzeit            TO ls_despacho_tree-hora_associacao.

* Nó inferior
  PERFORM add_complete_line USING  ls_despacho_tree
                                   lv_user_key
                          CHANGING lv_last_key.

*   update frontend
  CALL METHOD g_alv_tree->frontend_update.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ATUALIZA_ALV
*&---------------------------------------------------------------------*
FORM f_atualiza_alv USING ps_despacho_tree TYPE /ptloms/et079.

  DATA: ls_despacho LIKE LINE OF gt_despacho.

  IF ps_despacho_tree IS INITIAL.
    RETURN.
  ENDIF.

  MOVE-CORRESPONDING ps_despacho_tree TO ls_despacho.

  PERFORM f_atualiza_status CHANGING ls_despacho.

  APPEND ls_despacho TO gt_despacho.

  SORT gt_despacho BY aufnr ASCENDING vornr ASCENDING suboper ASCENDING.

  o_alv->refresh( ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_MOTIVO_DES
*&---------------------------------------------------------------------*
FORM f_valida_motivo_des .

  DATA:lt_values_tab   TYPE STANDARD TABLE OF dd07v,
       lt_values_dd07l TYPE STANDARD TABLE OF dd07l.

  IF sy-ucomm NE 'EXIT' AND
     sy-ucomm NE 'BACK' AND
     sy-ucomm NE 'CANC' AND
     sy-ucomm NE 'BTN_CANCEL'.

    IF /ptloms/tb026-motivo_desassociacao IS INITIAL.
      MESSAGE e000 WITH 'Motivo é obrigatório'(080).
    ENDIF.

    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = '/PTLOMS/DM006'
*       TEXT            = 'X'
*       FILL_DD07L_TAB  = ' '
      TABLES
        values_tab      = lt_values_tab
        values_dd07l    = lt_values_dd07l
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.

    IF sy-subrc = 0.

***   READ TABLE lt_values_tab INTO DATA(ls_values_tab)
***   WITH KEY domvalue_l = /ptloms/tb026-motivo_desassociacao.

      DATA: ls_values_tab LIKE LINE OF lt_values_tab.
      READ TABLE lt_values_tab INTO ls_values_tab
      WITH KEY domvalue_l = /ptloms/tb026-motivo_desassociacao.

      IF sy-subrc NE 0.
        CLEAR gv_desc_motivo_desassociacao.
        MESSAGE e000 WITH 'Motivo inválido'(081).
      ENDIF.

      gv_desc_motivo_desassociacao = ls_values_tab-ddtext.

    ENDIF.


  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_NO_PAI
*&---------------------------------------------------------------------*
FORM f_busca_no_pai USING p_usuario CHANGING p_no TYPE lvc_nkey.

  DATA: lv_tabix TYPE sy-tabix.

  IF p_usuario IS INITIAL.
    RETURN.
  ENDIF.

***  READ TABLE gt_nodes INTO DATA(ls_nodes) WITH KEY usuario = p_usuario.
  DATA: ls_nodes LIKE LINE OF gt_nodes.
  READ TABLE gt_nodes INTO ls_nodes WITH KEY usuario = p_usuario.

  IF sy-subrc EQ 0.
    p_no = ls_nodes-node.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ASSOCIAR
*&---------------------------------------------------------------------*
FORM f_associar USING p_datum TYPE sy-datum
                      p_uzeit TYPE sy-uzeit
                      ps_despacho_tree TYPE /ptloms/et079.

* Declaração de tabela interna
  DATA: lt_tb026 TYPE STANDARD TABLE OF /ptloms/tb026.

* Declaração de estrutura
  DATA: ls_026           TYPE /ptloms/tb026,
        ls_despacho_tree TYPE /ptloms/et079.

  IF ps_despacho_tree IS INITIAL.
    RETURN.
  ENDIF.

  MOVE-CORRESPONDING ps_despacho_tree TO ls_026.
  ls_026-usuario = wa_usuario-usuario.
  ls_026-data_associacao = p_datum.
  ls_026-hora_associacao = p_uzeit.
  APPEND ls_026 TO lt_tb026.

  IF lt_tb026[] IS NOT INITIAL.

* Atualiza tabela de Despacho
    MODIFY /ptloms/tb026 FROM TABLE lt_tb026.
    IF sy-subrc EQ 0.

* Associar Matrícula do Usuário na Ordem/Operação
      PERFORM f_associa_mat_operacao USING ps_despacho_tree-aufnr
                                           ps_despacho_tree-vornr
                                           ps_despacho_tree-suboper
                                           wa_usuario-usuario
                                           space. "Associar

* Atualiza status da Operação
      PERFORM f_atualiza_status_operacao USING ps_despacho_tree-aufnr
                                               ps_despacho_tree-vornr
                                               ps_despacho_tree-suboper
                                               wa_usuario-usuario
                                               space.

* Inclui Ordem no ALV Tree
      PERFORM f_add_ordem_alv_tree_v2 USING p_datum
                                            p_uzeit
                                            ps_despacho_tree.

      COMMIT WORK.
      MESSAGE s000 WITH 'Orden(s) associada(s) com sucesso'(078).
    ELSE.
      ROLLBACK WORK.
      MESSAGE s000 WITH 'Erro ao associar orden(s)'(079) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VERIFICA_ATRIBUICAO_PARCIAL
*&---------------------------------------------------------------------*
FORM f_verificao_inicial CHANGING p_atribuida TYPE char1
                                  p_liberada  TYPE char1.

** Validação pertinente apenas para visão Ordem
*  CHECK p_ordens = 'X'.

  p_liberada = 'X'.

  IF p_ordens = 'X'.

    DATA: lt_026 TYPE STANDARD TABLE OF /ptloms/tb026.

    SELECT aufnr vornr suboper
      FROM /ptloms/tb026
      INTO TABLE lt_026
      FOR ALL ENTRIES IN gt_despacho
      WHERE aufnr = gt_despacho-aufnr
        AND vornr <> space
        AND desassociado = space.

***    SELECT aufnr, vornr, suboper
***      FROM /ptloms/tb026
***      INTO TABLE @DATA(lt_026)
***      FOR ALL ENTRIES IN @gt_despacho
***      WHERE aufnr = @gt_despacho-aufnr
***        AND vornr <> @space
***        AND desassociado = @space.


  ENDIF.

***  LOOP AT o_rows INTO DATA(lv_row).
  DATA: lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.

*** READ TABLE gt_despacho INTO DATA(ls_despacho) INDEX lv_row.
    DATA: ls_despacho LIKE LINE OF gt_despacho.
    READ TABLE gt_despacho INTO ls_despacho INDEX lv_row.

    IF sy-subrc EQ 0.

***   READ TABLE lt_026 INTO DATA(ls_026) WITH KEY aufnr = ls_despacho-aufnr.
      DATA  ls_026 LIKE LINE OF lt_026.
      READ TABLE lt_026 INTO ls_026 WITH KEY aufnr = ls_despacho-aufnr.

      IF sy-subrc EQ 0.
        " 30/05/2023
        MESSAGE s000 WITH 'Ordem'(010) ls_026-aufnr 'já associada Por Operação'(082)  DISPLAY LIKE 'E'.
        p_atribuida = 'X'.
        EXIT.
      ENDIF.

      IF NOT ls_despacho-status_sis CS 'LIB'.
        MESSAGE s000 WITH 'Ordem'(010) ls_despacho-aufnr 'não está liberada'(083)  DISPLAY LIKE 'E'.
        CLEAR p_liberada.
        EXIT.
      ENDIF.

    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LIBERA_ORDEM
*&---------------------------------------------------------------------*
FORM f_libera_ordem .

* Declaração de tabelas interna
  DATA: lt_return  TYPE STANDARD TABLE OF bapiret2.

* Declaração de variáveis
  DATA: lv_aufnr TYPE aufnr,
        lv_stsma TYPE jsto-stsma,
        lv_stonr TYPE tj30-stonr.

  TYPES: BEGIN OF ty_aufnr,
           aufnr TYPE aufnr,
         END OF ty_aufnr.

  DATA: it_aufnr TYPE TABLE OF ty_aufnr,
        wa_aufnr TYPE ty_aufnr.

***  LOOP AT o_rows INTO DATA(lv_rows).
  DATA: lv_rows LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_rows.

    FIELD-SYMBOLS: <fs_despacho> LIKE LINE OF gt_despacho.
*** READ TABLE gt_despacho ASSIGNING FIELD-SYMBOL(<fs_despacho>) INDEX lv_rows.
    READ TABLE gt_despacho ASSIGNING <fs_despacho> INDEX lv_rows.

*** READ TABLE gt_despacho ASSIGNING FIELD-SYMBOL(<fs_despacho>) INDEX lv_rows.
    READ TABLE gt_despacho ASSIGNING <fs_despacho> INDEX lv_rows.

    IF <fs_despacho>-aufnr IS INITIAL.
      CONTINUE.
    ENDIF.

    wa_aufnr-aufnr = <fs_despacho>-aufnr.
    COLLECT wa_aufnr INTO it_aufnr.

  ENDLOOP.

*** LOOP AT it_aufnr ASSIGNING FIELD-SYMBOL(<fs_aufnr>).
  FIELD-SYMBOLS: <fs_aufnr> LIKE LINE OF it_aufnr.
  LOOP AT it_aufnr ASSIGNING <fs_aufnr>.

    READ TABLE gt_despacho ASSIGNING <fs_despacho> WITH KEY aufnr = <fs_aufnr>.

    IF sy-subrc IS INITIAL.

* Rotina de Conversão para Ordem
***   lv_aufnr = |{ <fs_despacho>-aufnr ALPHA = IN }|.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_despacho>-aufnr
        IMPORTING
          output = lv_aufnr.

      CALL FUNCTION '/PTLOMS/MF051'
        EXPORTING
          im_aufnr  = lv_aufnr
        TABLES
          it_return = lt_return.

* Verifica retorno
***   READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
      DATA: ls_return LIKE LINE OF lt_return.
      READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.

      IF sy-subrc NE 0.

***     LOOP AT gt_despacho ASSIGNING <fs_despacho> WHERE aufnr = <fs_aufnr>.
        LOOP AT gt_despacho ASSIGNING <fs_despacho> WHERE aufnr = <fs_aufnr>.

*        Atualiza campo Status Sistema no ALV
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

        ENDLOOP.

        MESSAGE s000(su) WITH 'Ordem liberada com sucesso'(084).
      ELSE.
        MESSAGE s000(su) WITH 'Erro ao liberar ordem.'(085) ls_return-message DISPLAY LIKE 'E'.
      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ASSOCIA_MAT_OPERACAO
*&---------------------------------------------------------------------*
FORM f_associa_mat_operacao USING p_aufnr   TYPE aufnr
                                  p_vornr   TYPE vornr
                                  p_suboper TYPE uvorn
                                  p_usuario TYPE xubname
                                  p_remove  TYPE char1.

** Declaração de tabela interna
*  DATA: lt_status TYPE STANDARD TABLE OF jstat.

  DATA: lv_erro      TYPE char1,
        lv_suboper   TYPE uvorn,
        lv_objnr     TYPE jsto-objnr,
        lv_desprezar TYPE char1.

* As informações do usuário são relevantes apenas na Associação
  IF p_remove IS INITIAL.

* Busca dados do usuário

    DATA: ls_013 TYPE /ptloms/tb013.
    SELECT SINGLE usuario associa matricula
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF ls_013
      WHERE usuario = p_usuario.

***    SELECT SINGLE usuario, associa, matricula
***      FROM /ptloms/tb013
***      INTO @DATA(ls_013)
***      WHERE usuario = @p_usuario.

* Verifica se no cadastro do usuário está configura para associar a Matrícula à Operação
    IF ls_013-associa IS INITIAL OR ls_013-matricula IS INITIAL.
      RETURN.
    ENDIF.

  ENDIF.

* Se Operação não estiver preechido, então aplica-se a rotina para todas operações
  IF p_vornr IS NOT INITIAL.

    PERFORM f_associa_mat_operacao_bapi USING p_aufnr
                                              p_vornr
                                              p_suboper
                                              p_usuario
                                              ls_013-matricula
                                              p_remove
*                                              lv_commit
                                     CHANGING lv_erro.
  ELSE.

*   Busca roteiro da ordem
*** SELECT SINGLE aufpl FROM afko INTO @DATA(lv_aufpl) WHERE aufnr = @p_aufnr.
    DATA: lv_aufpl LIKE afko-aufpl.
    SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = p_aufnr.

    IF sy-subrc EQ 0.

*     Busca todas as operações da Ordem
      DATA: lt_afvc TYPE TABLE OF afvc.

      SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
        FROM afvc AS a
        INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
        INTO CORRESPONDING FIELDS OF TABLE lt_afvc
        WHERE a~aufpl = lv_aufpl
          AND a~phflg = space
          AND b~fsavd IN s_datope.

***      SELECT a~aufpl, a~aplzl, a~vornr, a~sumnr, a~objnr
***        FROM afvc AS a
***        INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INTO TABLE @DATA(lt_afvc)
***        WHERE a~aufpl = @lv_aufpl
***          AND a~phflg = @space
***          AND b~fsavd IN @s_datope.

***   DATA(lt_afvc_aux) = lt_afvc.
      DATA: lt_afvc_aux TYPE TABLE OF afvc.
      lt_afvc_aux = lt_afvc.

***   LOOP AT lt_afvc INTO DATA(ls_afvc).
      DATA: ls_afvc LIKE LINE OF lt_afvc.
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

** Busca status da Ordem
*        CALL FUNCTION 'STATUS_READ'
*          EXPORTING
*            client           = sy-mandt
*            objnr            = lv_objnr
*            only_active      = 'X'
*          TABLES
*            status           = lt_status
*          EXCEPTIONS
*            object_not_found = 1
*            OTHERS           = 2.
*
** Verifica se a Ordem possui o status ENTE I0045 (Encerrado Tecnicamente)
*        READ TABLE lt_status WITH KEY stat = 'I0045' TRANSPORTING NO FIELDS.
*        IF sy-subrc EQ 0.
*          CONTINUE.
*        ELSE.
** Verifica se a Ordem possui o status ENCE I0046 (Encerrado)
*          READ TABLE lt_status WITH KEY stat = 'I0046' TRANSPORTING NO FIELDS.
*          IF sy-subrc EQ 0.
*            CONTINUE.
*          ELSE.
** Verifica se a Ordem possui o status CONF I0009 (Confirmado)
*            READ TABLE lt_status WITH KEY stat = 'I0009' TRANSPORTING NO FIELDS.
*            IF sy-subrc EQ 0.
*              CONTINUE.
*            ENDIF.
*          ENDIF.
*        ENDIF.

        CLEAR lv_suboper.

        IF ls_afvc-sumnr IS NOT INITIAL.
***          READ TABLE lt_afvc_aux INTO DATA(ls_afvc_aux) WITH KEY aufpl = ls_afvc-aufpl
***                                                                 aplzl = ls_afvc-sumnr.
          DATA: ls_afvc_aux LIKE LINE OF lt_afvc_aux.
          READ TABLE lt_afvc_aux INTO ls_afvc_aux WITH KEY aufpl = ls_afvc-aufpl
                                                           aplzl = ls_afvc-sumnr.

          IF sy-subrc EQ 0.
            lv_suboper    = ls_afvc-vornr.
            ls_afvc-vornr = ls_afvc_aux-vornr.
          ENDIF.

        ENDIF.

        PERFORM f_associa_mat_operacao_bapi USING p_aufnr
                                                  ls_afvc-vornr
                                                  lv_suboper
                                                  p_usuario
                                                  ls_013-matricula
                                                  p_remove
*                                                  lv_commit
                                         CHANGING lv_erro.

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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ASSOCIA_MAT_OPERACAO_BAPI
*&---------------------------------------------------------------------*
FORM f_associa_mat_operacao_bapi USING p_aufnr     TYPE aufnr
                                       p_vornr     TYPE vornr
                                       p_suboper   TYPE uvorn
                                       p_usuario   TYPE xubname
                                       p_matricula TYPE persno
                                       p_remove    TYPE char1
*                                       p_commit    TYPE char1
                              CHANGING p_erro      TYPE char1.

* Declaração de tabelas interna
  DATA: lt_methods      TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_operation    TYPE STANDARD TABLE OF bapi_alm_order_operation,
        lt_operation_up TYPE STANDARD TABLE OF bapi_alm_order_operation_up,
        lt_return       TYPE STANDARD TABLE OF bapiret2.

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
***  lv_aufnr = |{ p_aufnr ALPHA = IN }|.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = p_aufnr
    IMPORTING
      output = lv_aufnr.

* Rotina de conversão para Operação
  IF p_vornr IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
      EXPORTING
        input  = p_vornr
      IMPORTING
        output = lv_vornr.
  ENDIF.

* Rotina de conversão para SubOperação
  IF p_vornr IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
      EXPORTING
        input  = p_suboper
      IMPORTING
        output = lv_suboper.
  ENDIF.

* Monta OBJECTTYPE
  lv_objecttype = lv_aufnr && lv_vornr && lv_suboper.

* Verifica se Ordem/Usuário estão preenchidos
  IF p_aufnr IS INITIAL OR p_usuario IS INITIAL.
    RETURN.
  ENDIF.

** As informações do usuário são relevantes apenas na Associação
*  IF p_remove IS INITIAL.
*
** Busca dados do usuário
*    SELECT SINGLE usuario, associa, matricula
*      FROM /ptloms/tb013
*      INTO @DATA(ls_013)
*      WHERE usuario = @p_usuario.
*
** Verifica se no cadastro do usuário está configura para associar a Matrícula à Operação
*    IF ls_013-associa IS INITIAL OR ls_013-matricula IS INITIAL.
*      RETURN.
*    ENDIF.
*
*  ENDIF.

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
  IF p_remove IS INITIAL.
    ls_operation-pers_no = p_matricula.
  ENDIF.
  APPEND ls_operation TO lt_operation.

  CLEAR ls_operation_up.
  ls_operation_up-pers_no = 'X'.
  APPEND ls_operation_up TO lt_operation_up.

* Chama BAPI Associar Matrícula à Opeação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods      = lt_methods
      it_operation    = lt_operation
      it_operation_up = lt_operation_up
      return          = lt_return.

* Verifica retorno
*** READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  DATA: ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.

  IF sy-subrc NE 0.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

  ELSE.
    p_erro = 'X'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ATUALIZA_STATUS_OPERACAO
*&---------------------------------------------------------------------*
FORM f_atualiza_status_operacao USING p_aufnr   TYPE aufnr
                                      p_vornr   TYPE vornr
                                      p_suboper TYPE uvorn
                                      p_usuario TYPE xubname
                                      p_anula   TYPE char1.

  DATA: lt_return_status_oper TYPE STANDARD TABLE OF bapiret2,
        lt_status             TYPE STANDARD TABLE OF jstat.

  DATA: lv_data      TYPE datum,
        lv_hora      TYPE uzeit,
        lv_suboper   TYPE uvorn,
        lv_objnr     TYPE jsto-objnr,
        lv_desprezar TYPE char1.

  lv_data = sy-datum.

  lv_hora = sy-uzeit.

* Se Operação não estiver preechido, então aplica-se a rotina para todas operações
  IF p_vornr IS NOT INITIAL.

* Atualiza status da operação
    CALL FUNCTION '/PTLOMS/MF007'
      EXPORTING
        im_aufnr            = p_aufnr
        im_vornr            = p_vornr
        im_suboper          = p_suboper
        im_usuario_mobile   = p_usuario
        im_date_ini         = lv_data
        im_time_ini         = lv_hora
        im_date_fim         = lv_data
        im_time_fim         = lv_hora
        im_dev_reason       = space
        im_fin_conf         = space
        im_despacho_anulado = p_anula
      TABLES
        it_return           = lt_return_status_oper.

  ELSE.
* Busca roteiro da ordem
*** SELECT SINGLE aufpl FROM afko INTO @DATA(lv_aufpl) WHERE aufnr = @p_aufnr.
    DATA: lv_aufpl TYPE afko-aufpl.
    SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = p_aufnr.

    IF sy-subrc EQ 0.

*     Busca todas as operações da Ordem
      DATA: lt_afvc TYPE TABLE OF afvc.
      SELECT a~aufpl a~aplzl a~vornr a~sumnr a~objnr
        FROM afvc AS a
        INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
        INTO CORRESPONDING FIELDS OF TABLE lt_afvc
        WHERE a~aufpl = lv_aufpl
          AND a~phflg = space
          AND b~fsavd IN s_datope.

***      SELECT a~aufpl, a~aplzl, a~vornr, a~sumnr, a~objnr
***        FROM afvc AS a
***        INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INTO TABLE @DATA(lt_afvc)
***        WHERE a~aufpl = @lv_aufpl
***          AND a~phflg = @space
***          AND b~fsavd IN @s_datope.

***   DATA(lt_afvc_aux) = lt_afvc.
      DATA: lt_afvc_aux TYPE TABLE OF afvc.
      lt_afvc_aux = lt_afvc.

***   LOOP AT lt_afvc INTO DATA(ls_afvc).
      DATA: ls_afvc LIKE LINE OF lt_afvc.
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

***          READ TABLE lt_afvc_aux INTO DATA(ls_afvc_aux) WITH KEY aufpl = ls_afvc-aufpl
***                                                       aplzl = ls_afvc-sumnr.

          DATA: ls_afvc_aux LIKE LINE OF lt_afvc_aux.
          READ TABLE lt_afvc_aux INTO ls_afvc_aux WITH KEY aufpl = ls_afvc-aufpl
                                                           aplzl = ls_afvc-sumnr.

          IF sy-subrc EQ 0.
            lv_suboper    = ls_afvc-vornr.
            ls_afvc-vornr = ls_afvc_aux-vornr.
          ENDIF.

        ENDIF.

* Atualiza status da operação
        CALL FUNCTION '/PTLOMS/MF007'
          EXPORTING
            im_aufnr            = p_aufnr
            im_vornr            = ls_afvc-vornr
            im_suboper          = lv_suboper
            im_usuario_mobile   = p_usuario
            im_date_ini         = lv_data
            im_time_ini         = lv_hora
            im_date_fim         = lv_data
            im_time_fim         = lv_hora
            im_dev_reason       = space
            im_fin_conf         = space
            im_despacho_anulado = p_anula
          TABLES
            it_return           = lt_return_status_oper.

      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_OPERACAO
*&---------------------------------------------------------------------*
FORM f_valida_operacao CHANGING p_status TYPE /ptloms/ed011.

  DATA: lt_selected_nodes TYPE lvc_t_nkey.
  DATA: ls_despacho_tree TYPE /ptloms/et079.

* Busca registro selecionado
*  PERFORM f_busca_registro_selecionado CHANGING ls_despacho_tree.
  PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

***  LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
  DATA: ls_selected_nodes LIKE LINE OF lt_selected_nodes.
  LOOP AT lt_selected_nodes INTO ls_selected_nodes.

    CLEAR ls_despacho_tree.
    PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                      CHANGING ls_despacho_tree.
    IF sy-subrc IS INITIAL.
      CONTINUE.
    ENDIF.

    DATA: lv_status LIKE /ptloms/tb031-status.

*   Busca status da operação
    IF ls_despacho_tree-aufnr IS NOT INITIAL.
      IF ls_despacho_tree-vornr IS INITIAL.

        SELECT SINGLE status
          FROM /ptloms/tb031
          INTO lv_status
          WHERE aufnr   = ls_despacho_tree-aufnr
            AND inativo = space.

***        SELECT SINGLE status
***          FROM /ptloms/tb031
***          INTO @DATA(lv_status)
***          WHERE aufnr   = @ls_despacho_tree-aufnr
***            AND inativo = @space.

      ELSE.

        SELECT SINGLE status
         FROM /ptloms/tb031
         INTO lv_status
         WHERE aufnr   = ls_despacho_tree-aufnr
           AND vornr   = ls_despacho_tree-vornr
           AND suboper = ls_despacho_tree-suboper
           AND inativo = space.


***        SELECT SINGLE status
***          FROM /ptloms/tb031
***          INTO lv_status
***          WHERE aufnr   = ls_despacho_tree-aufnr
***            AND vornr   = ls_despacho_tree-vornr
***            AND suboper = ls_despacho_tree-suboper
***            AND inativo = space.
      ENDIF.
    ENDIF.

    p_status = lv_status.

    IF p_status = 2.
      RETURN.
    ENDIF.

  ENDLOOP.

** Transferência de ordem ou operações já iniciadas no dispositivo não podem ser efetuadas
*  IF lv_status = 2.
*    p_erro = 'X'.
*    MESSAGE s000 WITH 'Regstro já iniciado no App' DISPLAY LIKE 'E'.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_VARIANT
*&---------------------------------------------------------------------*
FORM f_f4_variant USING p_hande
               CHANGING p_variante.

  DATA: lv_variant_exit TYPE  char1,
        ls_variante     TYPE  disvariant,
        ls_variant_aux  TYPE  disvariant.

  ls_variante-report = sy-repid.
  IF p_hande = 'X'.
    ls_variante-handle = c_hande.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = ls_variante
      i_save     = c_save
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
*&---------------------------------------------------------------------*
*&      Form  F_VALIDACAO_INICIAL
*&---------------------------------------------------------------------*
FORM f_validacao_inicial CHANGING p_erro TYPE char1.

  IF p_oper = 'X'.
    IF s_datope IS INITIAL.
      MESSAGE s000 WITH 'Data Início Operação obrigatório'(087) DISPLAY LIKE 'E'.
      p_erro = 'X'.
    ENDIF.
  ENDIF.

  IF p_ordens = 'X'.

    IF s_gstrp IS INITIAL.
      MESSAGE s000 WITH 'Data base inicío obrigatório'(088) DISPLAY LIKE 'E'.
      p_erro = 'X'.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_RANGE_OBJID
*&---------------------------------------------------------------------*
FORM f_monta_range_objid .

  DATA: ls_objid LIKE LINE OF r_objid.

  REFRESH r_objid[].

  IF s_gewrk[] IS INITIAL.
    RETURN.
  ENDIF.

  DATA: lt_crhd TYPE TABLE OF crhd.

  SELECT objty objid arbpl werks
    FROM crhd
    INTO CORRESPONDING FIELDS OF TABLE lt_crhd
    WHERE arbpl IN s_gewrk
      AND werks IN s_werks.

***  SELECT objty, objid, arbpl, werks
***    FROM crhd
***    INTO TABLE @DATA(lt_crhd)
***    WHERE arbpl IN @s_gewrk
***      AND werks IN @s_werks.

***  LOOP AT lt_crhd INTO DATA(ls_crhd).
  DATA: ls_crhd LIKE LINE OF lt_crhd.
  LOOP AT lt_crhd INTO ls_crhd.
    CLEAR ls_objid.
    ls_objid-sign = 'I'.
    ls_objid-option = 'EQ'.
    ls_objid-low = ls_crhd-objid.
    APPEND ls_objid TO r_objid.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HORAS_PLANEJADAS
*&---------------------------------------------------------------------*
FORM f_horas_planejadas USING p_user     TYPE /ptloms/tb013-usuario
                      CHANGING p_hr_plan TYPE char20.

*  DATA: o_oms TYPE REF TO /ptloms/cl001.
*
*  DATA: rt_usuario_app TYPE /iwbep/t_cod_select_options,
*        rt_data        TYPE /iwbep/t_cod_select_options.
*
*  DATA: ls_usuario_app LIKE LINE OF rt_usuario_app.
*
*  DATA: it_horas_plan_rel TYPE /ptloms/ct070.
*
*  DATA: lv_arbei TYPE /ptloms/et070-arbei.
*
*  IF p_user IS INITIAL.
*    RETURN.
*  ENDIF.
*
*  CREATE OBJECT o_oms.
*
*  ls_usuario_app-sign = 'I'.
*  ls_usuario_app-option = 'EQ'.
*  ls_usuario_app-low = p_user.
*  APPEND ls_usuario_app TO rt_usuario_app.
*
*  o_oms->out_horas_plan_real(
*    EXPORTING
*      rt_usuario_app    = rt_usuario_app
*      rt_data           = rt_data
*    IMPORTING
*      et_horas_plan_rel = it_horas_plan_rel ).
*
*  READ TABLE it_horas_plan_rel INTO DATA(ls_horas_plan_rel) INDEX 1.
*
*  lv_arbei = ls_horas_plan_rel-arbei.
*
**  IF lv_arbei IS NOT INITIAL.
*  SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO @DATA(lv_confirmacao).
*  p_hr_plan = lv_arbei && | | && lv_confirmacao.
**  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HORAS_PLANEJADAS_FILTER
*&---------------------------------------------------------------------*
FORM f_horas_planejadas_filter USING p_user    TYPE /ptloms/tb013-usuario
                                     p_aufpl   TYPE afvc-aufpl
                                     p_aplzl   TYPE afvc-aplzl
                            CHANGING p_hr_plan TYPE afvv-arbei.

*  DATA: o_oms TYPE REF TO /ptloms/cl001.
*
*  DATA: rt_usuario_app TYPE /iwbep/t_cod_select_options,
*        rt_data        TYPE /iwbep/t_cod_select_options.
*
*  DATA: ls_usuario_app LIKE LINE OF rt_usuario_app.
*
*  DATA: it_horas_plan_rel TYPE /ptloms/ct070.
*
*  DATA: lv_arbei TYPE /ptloms/et070-arbei.
*
*  IF p_user IS INITIAL.
*    RETURN.
*  ENDIF.
*
*  CREATE OBJECT o_oms.
*
*  ls_usuario_app-sign = 'I'.
*  ls_usuario_app-option = 'EQ'.
*  ls_usuario_app-low = p_user.
*  APPEND ls_usuario_app TO rt_usuario_app.
*
*  o_oms->out_horas_plan_real(
*    EXPORTING
*      rt_usuario_app    = rt_usuario_app
*      rt_data           = rt_data
*      im_filter_aufpl   = p_aufpl
*      im_filter_aplzl   = p_aplzl
*    IMPORTING
*      et_horas_plan_rel = it_horas_plan_rel ).
*
*  READ TABLE it_horas_plan_rel INTO DATA(ls_horas_plan_rel) INDEX 1.
*
*  p_hr_plan = ls_horas_plan_rel-arbei.
*
***  IF lv_arbei IS NOT INITIAL.
**  SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO @DATA(lv_confirmacao).
**  p_hr_plan = lv_arbei && | | && lv_confirmacao.
***  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_HORAS_PLANEJADAS
*&---------------------------------------------------------------------*
FORM f_busca_horas_planejadas .

** Tipo
*  TYPES: BEGIN OF ty_trab_prev,
*           aufnr       TYPE aufnr,
*           vornr       TYPE vornr,
*           pernr       TYPE co_pernr,
*           data_inicio TYPE datum,
*           data_fim    TYPE datum,
*         END OF ty_trab_prev.
*
*  DATA: lt_trab_prev TYPE STANDARD TABLE OF ty_trab_prev,
*        ls_trab_prev TYPE ty_trab_prev.
*
** Declaração de range
*  DATA: r_matricula  TYPE RANGE OF co_pernr,
*        ls_matricula LIKE LINE OF r_matricula.
*
*  DATA: o_oms TYPE REF TO /ptloms/cl001.
*
*  IF gt_tb026[] IS INITIAL.
*    RETURN.
*  ENDIF.
*
** Busca matrícula do Usuário APP
*  SELECT usuario, matricula, dia_inicio, dias_retroativos, dias_progressivos
*    FROM /ptloms/tb013
*    INTO TABLE @DATA(lt_tb013)
*    FOR ALL ENTRIES IN @gt_tb026
*    WHERE usuario EQ @gt_tb026-usuario.
*
*  CREATE OBJECT o_oms.
*  LOOP AT gt_tb026 INTO DATA(ls_tb026).
*    CLEAR ls_trab_prev.
*    ls_trab_prev-aufnr = ls_tb026-aufnr.
*    ls_trab_prev-vornr = ls_tb026-vornr.
*
*    READ TABLE lt_tb013 INTO DATA(ls_tb013) WITH KEY usuario = ls_tb026-usuario.
*    IF sy-subrc EQ 0.
*      ls_trab_prev-pernr = ls_tb013-matricula.
*    ENDIF.
*    DATA(rt_data_conf_usuario) = o_oms->out_monta_range_data_usuario( sy-uname ).
*    READ TABLE rt_data_conf_usuario INTO DATA(ls_data_conf_usuario) INDEX 1.
*    IF sy-subrc EQ 0.
*      ls_trab_prev-data_inicio = ls_data_conf_usuario-low.
*      ls_trab_prev-data_fim    = ls_data_conf_usuario-high.
*    ENDIF.
*    REFRESH rt_data_conf_usuario[].
*
*    APPEND ls_trab_prev TO lt_trab_prev.
*  ENDLOOP.
*
*  SELECT au~aufnr, a~vornr, a~aufpl, a~aplzl, a~objnr, a~pernr, b~arbei, b~ismnw, b~fsavd
*    FROM aufk AS au INNER JOIN afko AS af ON au~aufnr = af~aufnr
*    INNER JOIN afvc AS a ON af~aufpl = a~aufpl
*    INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
*    INTO TABLE @DATA(lt_plan_rel)
*    FOR ALL ENTRIES IN @lt_trab_prev
*    WHERE a~pernr  EQ @lt_trab_prev-pernr AND
*          au~aufnr EQ @lt_trab_prev-aufnr AND
*          a~vornr  EQ @lt_trab_prev-vornr AND
*        ( ( b~fsavd <= @lt_trab_prev-data_inicio AND b~fsavd >= @lt_trab_prev-data_inicio ) OR
*          ( b~fsedd <= @lt_trab_prev-data_inicio AND b~fsedd >= @lt_trab_prev-data_inicio ) ).
*
*  IF lt_trab_prev[] IS INITIAL.
*    RETURN.
*  ENDIF.
*
*  DELETE lt_trab_prev WHERE pernr IS INITIAL.
*
*** Confirmações estornadas
**  SELECT a~aufpl, a~vornr, a~aplzl, a~objnr, a~pernr, b~arbei, c~ismnw, b~fsavd, c~rueck, c~rmzhl, c~isdd, c~isdz, c~iedd, c~iedz, c~stzhl
**    FROM aufk AS au INNER JOIN afko AS af ON au~aufnr = af~aufnr
**    INNER JOIN afvc AS a ON af~aufpl = a~aufpl
**    INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
**    INNER JOIN afru AS c ON  a~aufpl = c~aufpl AND a~aplzl = c~aplzl
**    INTO TABLE @DATA(lt_plan_rel_afru_estornado)
**    FOR ALL ENTRIES IN @lt_trab_prev
**    WHERE a~pernr  EQ @lt_trab_prev-pernr AND
**          au~aufnr EQ @lt_trab_prev-aufnr AND
**          a~vornr  EQ @lt_trab_prev-vornr AND
**        ( ( b~fsavd <= @lt_trab_prev-data_inicio AND b~fsavd >= @lt_trab_prev-data_inicio ) OR
**          ( b~fsedd <= @lt_trab_prev-data_inicio AND b~fsedd >= @lt_trab_prev-data_inicio ) ) AND
**        ( ( c~isdd <= @lt_trab_prev-data_inicio AND c~isdd >= @lt_trab_prev-data_inicio ) OR
**          ( c~iedd <= @lt_trab_prev-data_inicio AND c~iedd >= @lt_trab_prev-data_inicio ) ) AND
**           c~stokz NE @space.
**
*** Confirmações válidas
**  SELECT a~aufpl, a~vornr, a~aplzl, a~objnr, a~pernr, b~arbei, c~ismnw, b~fsavd, c~rueck, c~rmzhl, c~isdd, c~isdz, c~iedd, c~iedz, c~stzhl
**    FROM aufk AS au INNER JOIN afko AS af ON au~aufnr = af~aufnr
**    INNER JOIN afvc AS a ON af~aufpl = a~aufpl
**    INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
**    INNER JOIN afru AS c ON  a~aufpl = c~aufpl AND a~aplzl = c~aplzl
**    INTO TABLE @DATA(lt_plan_rel_afru)
**    FOR ALL ENTRIES IN @lt_trab_prev
**    WHERE a~pernr  EQ @lt_trab_prev-pernr AND
**          au~aufnr EQ @lt_trab_prev-aufnr AND
**          a~vornr  EQ @lt_trab_prev-vornr AND
**        ( ( b~fsavd <= @lt_trab_prev-data_inicio AND b~fsavd >= @lt_trab_prev-data_inicio ) OR
**          ( b~fsedd <= @lt_trab_prev-data_inicio AND b~fsedd >= @lt_trab_prev-data_inicio ) ) AND
**        ( ( c~isdd <= @lt_trab_prev-data_inicio AND c~isdd >= @lt_trab_prev-data_inicio ) OR
**          ( c~iedd <= @lt_trab_prev-data_inicio AND c~iedd >= @lt_trab_prev-data_inicio ) ) AND
**            c~stokz EQ @space.
**
*** Elimina as confirmações estornadas
**  LOOP AT lt_plan_rel_afru_estornado INTO DATA(ls_plan_rel_afru_estornado).
**    DELETE lt_plan_rel_afru WHERE rueck = ls_plan_rel_afru_estornado-rueck
**                              AND stzhl = ls_plan_rel_afru_estornado-rmzhl.
**  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_HELP_RETIRADA
*&---------------------------------------------------------------------*
FORM f_help_retirada .

  TYPES: BEGIN OF ty_tab,
           codigo    TYPE /ptloms/tb026-motivo_desassociacao,
           descricao TYPE char100,
         END OF ty_tab.

  DATA: lt_tab        TYPE STANDARD TABLE OF ty_tab,
        lt_return     TYPE STANDARD TABLE OF ddshretval,
        lt_dynpfields TYPE STANDARD TABLE OF dynpread.

  DATA: lt_values_tab   TYPE STANDARD TABLE OF dd07v,
        lt_values_dd07l TYPE STANDARD TABLE OF dd07l.

  DATA: ls_tab        LIKE LINE OF lt_tab,
        ls_dynpfields LIKE LINE OF lt_dynpfields.

  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = '/PTLOMS/DM006'
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_values_tab
      values_dd07l    = lt_values_dd07l
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

***  LOOP AT lt_values_tab INTO DATA(ls_values_tab_aux).
  DATA: ls_values_tab_aux LIKE LINE OF lt_values_tab.
  LOOP AT lt_values_tab INTO ls_values_tab_aux.
    CLEAR ls_tab.
    ls_tab-codigo    = ls_values_tab_aux-domvalue_l.
    ls_tab-descricao = ls_values_tab_aux-ddtext.
    APPEND ls_tab TO lt_tab.
  ENDLOOP.

  " --- Apresenta na tela os valores
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CODIGO'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tab
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 0
      no_values_found = 0
      OTHERS          = 0.

  IF sy-subrc = 0.
    " --- Recupera o registro selecionado pelo usuário
*** READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    DATA: ls_return LIKE LINE OF lt_return.
    READ TABLE lt_return INTO ls_return INDEX 1.

    IF sy-subrc = 0.

      " --- Atribui valor ao campo da tela
      /ptloms/tb026-motivo_desassociacao = ls_return-fieldval.

      READ TABLE lt_tab INTO ls_tab WITH KEY codigo = /ptloms/tb026-motivo_desassociacao.

      IF sy-subrc = 0.
        ls_dynpfields-fieldname = 'GV_DESC_MOTIVO_DESASSOCIACAO'.
        ls_dynpfields-fieldvalue = ls_tab-descricao.
        APPEND ls_dynpfields TO lt_dynpfields.
      ENDIF.

      CALL FUNCTION 'DYNP_VALUES_UPDATE'
        EXPORTING
          dyname               = sy-repid
          dynumb               = sy-dynnr
        TABLES
          dynpfields           = lt_dynpfields
        EXCEPTIONS
          invalid_abapworkarea = 1
          invalid_dynprofield  = 2
          invalid_dynproname   = 3
          invalid_dynpronummer = 4
          invalid_request      = 5
          no_fielddescription  = 6
          undefind_error       = 7
          OTHERS               = 8.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_AUTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_auth CHANGING p_erro TYPE char1.

***  LOOP AT s_werks INTO DATA(wa_werks).
  DATA: wa_werks LIKE LINE OF s_werks.
  LOOP AT s_werks INTO wa_werks.

*    IF /ptloms/cl006=>verifica_permissao_centro( EXPORTING im_tcode = sy-tcode
*                                                           im_werks = wa_werks-low ) IS INITIAL.

    DATA lv_permissao_centro TYPE c LENGTH 1.
    CALL METHOD /ptloms/cl006=>verifica_permissao_centro
      EXPORTING
        im_tcode            = sy-tcode
        im_werks            = wa_werks-low
      IMPORTING
        ex_possui_permissao = lv_permissao_centro.


    IF lv_permissao_centro IS INITIAL.
      p_erro = 'X'.
      MESSAGE s002(/ptloms/cm001) WITH wa_werks-low DISPLAY LIKE 'E'.
    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETE_REG_SELECIONADOS
*&---------------------------------------------------------------------*
FORM f_delete_reg_selecionados .

  DATA: lt_selected_nodes TYPE lvc_t_nkey.

  DATA: ls_despacho_tree  TYPE /ptloms/et079.

  DATA: lv_no     TYPE lvc_nkey,
        lv_no_pai TYPE lvc_nkey.

*  PERFORM f_busca_primeiro_no_selec CHANGING lv_no.
  PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

***  LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
  DATA:  ls_selected_nodes LIKE LINE OF lt_selected_nodes.
  LOOP AT lt_selected_nodes INTO ls_selected_nodes.
    CLEAR ls_despacho_tree.
    PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                      CHANGING ls_despacho_tree.
    IF ls_despacho_tree IS INITIAL.
      CONTINUE.
    ENDIF.

** Busca registro selecionado
*      PERFORM f_busca_registro_selecionado CHANGING ls_despacho_tree.

* Busca nó do Pai
    PERFORM f_busca_no_pai USING  ls_despacho_tree-usuario CHANGING lv_no_pai.

    lv_no = ls_selected_nodes.

* Remove registro selecionado
    CALL METHOD g_alv_tree->delete_subtree
      EXPORTING
        i_node_key = lv_no.

* Verifica se há mais algum registro no mesmo nível do registro selecionado
*** READ TABLE gt_despacho_tree INTO DATA(ls_despacho) WITH KEY usuario = ls_despacho_tree-usuario.
    DATA: ls_despacho LIKE LINE OF gt_despacho_tree.
    READ TABLE gt_despacho_tree INTO ls_despacho WITH KEY usuario = ls_despacho_tree-usuario.

    IF sy-subrc NE 0.

      CALL METHOD g_alv_tree->delete_subtree
        EXPORTING
          i_node_key = lv_no_pai.

    ENDIF.

  ENDLOOP.

*   update frontend
  CALL METHOD g_alv_tree->frontend_update.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_MONITOR_PLAN
*&---------------------------------------------------------------------*
FORM f_monta_monitor_plan .

  DATA: rt_werks  TYPE /iwbep/t_cod_select_options,
        rt_aufnr  TYPE /iwbep/t_cod_select_options,
        rt_auart  TYPE /iwbep/t_cod_select_options,
        rt_qmnum  TYPE /iwbep/t_cod_select_options,
        rt_priok  TYPE /iwbep/t_cod_select_options,
        rt_tplnr  TYPE /iwbep/t_cod_select_options,
        rt_equnr  TYPE /iwbep/t_cod_select_options,
        rt_iwerk  TYPE /iwbep/t_cod_select_options,
        rt_ingpr  TYPE /iwbep/t_cod_select_options,
        rt_ilart  TYPE /iwbep/t_cod_select_options,
        rt_gewrk  TYPE /iwbep/t_cod_select_options,
        rt_gstrp  TYPE /iwbep/t_cod_select_options,
        rt_datope TYPE /iwbep/t_cod_select_options,
        rt_usuapp TYPE /iwbep/t_cod_select_options,
        lv_f_tree TYPE flag,
        lv_mat_at TYPE flag,
        lv_oper   TYPE flag,
        lv_ordens TYPE flag,
        ls_werks  LIKE LINE OF rt_werks,
        ls_aufnr  LIKE LINE OF rt_aufnr,
        ls_auart  LIKE LINE OF rt_auart,
        ls_qmnum  LIKE LINE OF rt_qmnum,
        ls_priok  LIKE LINE OF rt_priok,
        ls_tplnr  LIKE LINE OF rt_tplnr,
        ls_equnr  LIKE LINE OF rt_equnr,
        ls_iwerk  LIKE LINE OF rt_iwerk,
        ls_ingpr  LIKE LINE OF rt_ingpr,
        ls_ilart  LIKE LINE OF rt_ilart,
        ls_gewrk  LIKE LINE OF rt_gewrk,
        ls_gstrp  LIKE LINE OF rt_gstrp,
        ls_datope LIKE LINE OF rt_datope,
        ls_usuapp LIKE LINE OF rt_usuapp.

*Monta Range RT_WERKS
***  LOOP AT s_werks INTO DATA(ls_werks_aux).
  DATA: ls_werks_aux LIKE LINE OF s_werks.
  LOOP AT s_werks INTO ls_werks_aux.
    CLEAR ls_werks.
    MOVE-CORRESPONDING ls_werks_aux TO ls_werks.
    APPEND ls_werks TO rt_werks.
  ENDLOOP.

*Monta Range RT_AUFNR
*** LOOP AT s_aufnr INTO DATA(ls_aufnr_aux).
  DATA: ls_aufnr_aux LIKE LINE OF s_aufnr.
  LOOP AT s_aufnr INTO ls_aufnr_aux.
    CLEAR ls_aufnr.
    MOVE-CORRESPONDING ls_aufnr_aux TO ls_aufnr.
    APPEND ls_aufnr TO rt_aufnr.
  ENDLOOP.

* Monta Range RT_AUART
***  LOOP AT s_auart INTO DATA(ls_auart_aux).
  DATA: ls_auart_aux LIKE LINE OF s_auart.
  LOOP AT s_auart INTO ls_auart_aux.
    CLEAR ls_auart.
    MOVE-CORRESPONDING ls_auart_aux TO ls_auart.
    APPEND ls_auart TO rt_auart.
  ENDLOOP.

*Monta Range RT_QMNUM
*** LOOP AT s_qmnum INTO DATA(ls_qmnum_aux).
  DATA: ls_qmnum_aux LIKE LINE OF s_qmnum.
  LOOP AT s_qmnum INTO ls_qmnum_aux.
    CLEAR ls_qmnum.
    MOVE-CORRESPONDING ls_qmnum_aux TO ls_qmnum.
    APPEND ls_qmnum TO rt_qmnum.
  ENDLOOP.

*Monta Range RT_PRIOK
*** LOOP AT s_priok INTO DATA(ls_priok_aux).
  DATA: ls_priok_aux LIKE LINE OF s_priok.
  LOOP AT s_priok INTO ls_priok_aux.
    CLEAR ls_priok.
    MOVE-CORRESPONDING ls_priok_aux TO ls_priok.
    APPEND ls_priok TO rt_priok.
  ENDLOOP.

*Monta Range RT_TPLNR
***  LOOP AT s_tplnr INTO DATA(ls_tplnr_aux).
  DATA: ls_tplnr_aux LIKE LINE OF s_tplnr.
  LOOP AT s_tplnr INTO ls_tplnr_aux.
    CLEAR ls_tplnr.
    MOVE-CORRESPONDING ls_tplnr_aux TO ls_tplnr.
    APPEND ls_tplnr TO rt_tplnr.
  ENDLOOP.

*Monta Range RT_EQUNR
***  LOOP AT s_equnr INTO DATA(ls_equnr_aux).
  DATA: ls_equnr_aux LIKE LINE OF s_equnr.
  LOOP AT s_equnr INTO ls_equnr_aux.
    CLEAR ls_equnr.
    MOVE-CORRESPONDING ls_equnr_aux TO ls_equnr.
    APPEND ls_equnr TO rt_equnr.
  ENDLOOP.

*Monta Range RT_IWERK
***  LOOP AT s_iwerk INTO DATA(ls_iwerk_aux).
  DATA: ls_iwerk_aux LIKE LINE OF s_iwerk.
  LOOP AT s_iwerk INTO ls_iwerk_aux.
    CLEAR ls_iwerk.
    MOVE-CORRESPONDING ls_iwerk_aux TO ls_iwerk.
    APPEND ls_iwerk TO rt_iwerk.
  ENDLOOP.

*Monta Range RT_INGPR
***  LOOP AT s_ingpr INTO DATA(ls_ingpr_aux).
  DATA: ls_ingpr_aux LIKE LINE OF s_ingpr.
  LOOP AT s_ingpr INTO ls_ingpr_aux.
    CLEAR ls_ingpr.
    MOVE-CORRESPONDING ls_ingpr_aux TO ls_ingpr.
    APPEND ls_ingpr TO rt_ingpr.
  ENDLOOP.

*Monta Range RT_ILART
***  LOOP AT s_ilart INTO DATA(ls_ilart_aux).
  DATA: ls_ilart_aux LIKE LINE OF s_ilart.
  LOOP AT s_ilart INTO ls_ilart_aux.
    CLEAR ls_ilart.
    MOVE-CORRESPONDING ls_ilart_aux TO ls_ilart.
    APPEND ls_ilart TO rt_ilart.
  ENDLOOP.

*Monta Range RT_GEWRK
***  LOOP AT s_gewrk INTO DATA(ls_gewrk_aux).
  DATA: ls_gewrk_aux LIKE LINE OF s_gewrk.
  LOOP AT s_gewrk INTO ls_gewrk_aux.
    CLEAR ls_gewrk.
    MOVE-CORRESPONDING ls_gewrk_aux TO ls_gewrk.
    APPEND ls_gewrk TO rt_gewrk.
  ENDLOOP.

*Monta Range RT_GSTRP
***  LOOP AT s_gstrp INTO DATA(ls_gstrp_aux).
  DATA: ls_gstrp_aux LIKE LINE OF s_gstrp.
  LOOP AT s_gstrp INTO ls_gstrp_aux.
    CLEAR ls_gstrp.
    MOVE-CORRESPONDING ls_gstrp_aux TO ls_gstrp.
    APPEND ls_gstrp TO rt_gstrp.
  ENDLOOP.

*Monta Range RT_DATOPE
***  LOOP AT s_datope INTO DATA(ls_datope_aux).
  DATA: ls_datope_aux LIKE LINE OF s_datope.
  LOOP AT s_datope INTO ls_datope_aux.
    CLEAR ls_datope.
    MOVE-CORRESPONDING ls_datope_aux TO ls_datope.
    APPEND ls_datope TO rt_datope.
  ENDLOOP.

*Monta Range RT_USUAPP
***  LOOP AT s_usuapp INTO DATA(ls_usuapp_aux).
  DATA: ls_usuapp_aux LIKE LINE OF s_usuapp.
  LOOP AT s_usuapp INTO ls_usuapp_aux.
    CLEAR ls_usuapp.
    MOVE-CORRESPONDING ls_usuapp_aux TO ls_usuapp.
    APPEND ls_usuapp TO rt_usuapp.
  ENDLOOP.

  lv_f_tree = p_f_tree.
  lv_mat_at = p_mat_at.
  lv_oper   = p_oper.
  lv_ordens = p_ordens.

  CREATE OBJECT o_cl008
    EXPORTING
      rt_werks  = rt_werks
      rt_aufnr  = rt_aufnr
      rt_auart  = rt_auart
      rt_qmnum  = rt_qmnum
      rt_priok  = rt_priok
      rt_tplnr  = rt_tplnr
      rt_equnr  = rt_equnr
      rt_iwerk  = rt_iwerk
      rt_ingpr  = rt_ingpr
      rt_ilart  = rt_ilart
      rt_gewrk  = rt_gewrk
      rt_gstrp  = rt_gstrp
      rt_datope = rt_datope
      rt_usuapp = rt_usuapp
      im_f_tree = lv_f_tree
      im_mat_at = lv_mat_at
      im_oper   = lv_oper
      im_ordens = lv_ordens.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ATUALIZA_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_DESPACHO  text
*----------------------------------------------------------------------*
FORM f_atualiza_status CHANGING ls_despacho TYPE /ptloms/et078.

* Declaração de variáveis
  DATA: lv_stsma     TYPE jsto-stsma,
        lv_stonr     TYPE tj30-stonr,
        lv_objnr     TYPE jsto-objnr,
        lv_desprezar TYPE char1.

  CALL FUNCTION 'STATUS_TEXT_EDIT'
    EXPORTING
      objnr            = ls_despacho-objnr
      spras            = sy-langu
    IMPORTING
      e_stsma          = lv_stsma
      line             = ls_despacho-status_sis
      user_line        = ls_despacho-status_usu
      stonr            = lv_stonr
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LER_BLOQUEIO_ORDEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_ler_bloqueio_ordem .

  DATA: lv_subrc   TYPE sy-subrc,
        it_message TYPE bapirettab,
        lv_usuario TYPE sy-uname.

***  LOOP AT o_rows INTO DATA(lv_row).
  DATA: lv_row LIKE LINE OF o_rows.
  LOOP AT o_rows INTO lv_row.

*** READ TABLE gt_despacho INTO DATA(ls_despacho) INDEX lv_row.
    DATA: ls_despacho LIKE LINE OF gt_despacho.
    READ TABLE gt_despacho INTO ls_despacho INDEX lv_row.

    IF sy-subrc EQ 0.

      /ptloms/cl008=>ler_bloqueio_ordem( EXPORTING im_ordem = ls_despacho-aufnr IMPORTING subrc = lv_subrc iv_uname = lv_usuario ).

      IF lv_subrc IS NOT INITIAL.

***     APPEND VALUE #( type = 'E' id = 'CO' number = '469' message_v1 = |{ ls_despacho-aufnr ALPHA = OUT }|  message_v2 = lv_usuario ) TO it_message.

        DATA: wa_message LIKE LINE OF it_message.
        wa_message-type = 'E'.
        wa_message-id = 'CO'.
        wa_message-number = '469'.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_despacho-aufnr
          IMPORTING
            output = wa_message-message_v1.

        wa_message-message_v2 = lv_usuario.

        APPEND wa_message TO it_message.


        DELETE o_rows WHERE table_line = lv_row.

      ENDIF.

      CLEAR: lv_usuario.

    ENDIF.

  ENDLOOP.

  IF it_message IS NOT INITIAL.

    SORT it_message BY message_v1.
    DELETE ADJACENT DUPLICATES FROM it_message COMPARING message_v1.

    CALL FUNCTION 'RMSL325_DISPLAY_MSG_POPUP'
      EXPORTING
        it_message = it_message.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LER_BLOQUEIO_ORDEM_ALV_TREE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_ler_bloqueio_ordem_alv_tree .

  DATA: lt_selected_nodes TYPE lvc_t_nkey.
  DATA: ls_despacho_tree TYPE /ptloms/et079.
  DATA: lv_subrc         TYPE sy-subrc.
  DATA: it_message TYPE bapirettab.

  PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

***  LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
  DATA: ls_selected_nodes LIKE LINE OF lt_selected_nodes.
  LOOP AT lt_selected_nodes INTO ls_selected_nodes.

    CLEAR ls_despacho_tree.
    PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                      CHANGING ls_despacho_tree.
    IF ls_despacho_tree IS NOT INITIAL.

      /ptloms/cl008=>ler_bloqueio_ordem( EXPORTING im_ordem = ls_despacho_tree-aufnr IMPORTING subrc = lv_subrc ).

      IF lv_subrc IS NOT INITIAL.

***     APPEND VALUE #( type = 'E' id = 'CO' number = '469' message_v1 = ls_despacho_tree-aufnr message_v2 = sy-msgv1 ) TO it_message.

        DATA: wa_message LIKE LINE OF it_message.
        wa_message-type = 'E'.
        wa_message-id = 'CO'.
        wa_message-number = '469'.
        wa_message-message_v1 = ls_despacho_tree-aufnr.
        wa_message-message_v2 = sy-msgv1.

        APPEND wa_message TO it_message.

        DELETE lt_selected_nodes WHERE table_line = ls_selected_nodes.

      ENDIF.

    ENDIF.

  ENDLOOP.

  IF sy-subrc IS INITIAL.

    CALL FUNCTION 'RMSL325_DISPLAY_MSG_POPUP'
      EXPORTING
        it_message = it_message.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDAR_BLOQUEIO_ORDEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validar_bloqueio_ordem CHANGING lt_selected_nodes TYPE lvc_t_nkey.

  DATA: ls_despacho_tree TYPE /ptloms/et079.
  DATA: lv_subrc            TYPE sy-subrc,
        lv_usuario          TYPE sy-uname,
        lv_field            TYPE lvc_fname,
        lv_nkey             TYPE lvc_nkey,
        ls_laci             TYPE lvc_s_laci,
        lt_item_layout      TYPE lvc_t_layi,
        ls_item_layout      TYPE lvc_s_layi,
        l_fieldname         TYPE lvc_fname,
        ls_change_layout_wa TYPE lvc_s_laci,
        lv_type             TYPE i,
        lt_change_layout    TYPE lvc_t_laci,
        wa_node_layout      TYPE lvc_s_layn,
        lt_nodes            TYPE lvc_t_nkey.

  CLEAR: it_message.

* Busca registro selecionado
  PERFORM f_busca_registros_selecionados CHANGING lt_selected_nodes.

***  LOOP AT lt_selected_nodes INTO DATA(ls_selected_nodes).
  DATA: ls_selected_nodes LIKE LINE OF lt_selected_nodes .
  LOOP AT lt_selected_nodes INTO ls_selected_nodes.

    CLEAR ls_despacho_tree.
    PERFORM f_busca_dados_no_selecionado USING ls_selected_nodes
                                      CHANGING ls_despacho_tree.
    IF sy-subrc IS INITIAL.

      /ptloms/cl008=>ler_bloqueio_ordem( EXPORTING im_ordem = ls_despacho_tree-aufnr IMPORTING subrc = lv_subrc iv_uname = lv_usuario ).

      IF lv_subrc IS NOT INITIAL.

***     APPEND VALUE #( type = 'E' id = 'CO' number = '469' message_v1 = ls_despacho_tree-aufnr message_v2 = lv_usuario ) TO it_message.
        DATA: wa_message LIKE LINE OF it_message.
        wa_message-type = 'E'.
        wa_message-id = 'CO'.
        wa_message-number = '469'.
        wa_message-message_v1 = ls_despacho_tree-aufnr.
        wa_message-message_v2 = lv_usuario.

        APPEND wa_message TO it_message.

        DELETE lt_selected_nodes WHERE table_line = ls_selected_nodes.

        APPEND ls_selected_nodes TO lt_nodes.

      ENDIF.

    ENDIF.

  ENDLOOP.

  IF lt_nodes IS NOT INITIAL.

    g_alv_tree->unselect_nodes(
      EXPORTING
        it_node_key                  = lt_nodes
      EXCEPTIONS
        cntl_system_error            = 1
        dp_error                     = 2
        multiple_node_selection_only = 3
        error_in_node_key_table      = 4
        failed                       = 5
        OTHERS                       = 6
           ).
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    CALL METHOD cl_gui_cfw=>flush.

  ENDIF.

ENDFORM.
