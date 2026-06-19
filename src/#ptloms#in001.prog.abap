*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/IN001                                  *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  f_get_paramenter
*&---------------------------------------------------------------------*
FORM f_get_paramenter CHANGING p_table TYPE tabname.

  CHECK p_table IS INITIAL.
  GET PARAMETER ID 'DTB' FIELD p_table.

ENDFORM.                    " f_get_paramenter

*&---------------------------------------------------------------------*
*&      Form  f_check_table
*&---------------------------------------------------------------------*
*  Verifica se a tabela  existe, se é transparente e se é Z e
*  informacoes da tabela e dos campos
*----------------------------------------------------------------------*
FORM f_check_table USING p_table TYPE tabname.

  REFRESH: tg_sellist, tg_header, tg_namtab.

  CLEAR: v_tab_esp.

* Verifica se tabaela existe e se ela tem SM30
* Monta listagem dos campos com opçao para selecao (restringir dados)
* e busca descricao dos campos
  CALL FUNCTION 'VIEW_GET_DDIC_INFO'
    EXPORTING
      viewname        = p_table
    TABLES
      sellist         = tg_sellist
      x_header        = tg_header
      x_namtab        = tg_namtab
    EXCEPTIONS
      no_tvdir_entry  = 1
      table_not_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    MESSAGE e037(sv) WITH p_table.
  ENDIF.

  IF tg_sellist[] IS INITIAL.
    v_tab_esp = 'X'. "Controle de tabela especial que possui uma tela de seleção própria
  ELSE.
    DELETE tg_sellist WHERE value = ''.
  ENDIF.

ENDFORM.                    " f_check_table

*&---------------------------------------------------------------------*
*&      Form  f_show_view
*&---------------------------------------------------------------------*
FORM f_show_view_table .

  CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
    EXPORTING
      action                       = 'S'
      show_selection_popup         = '' "Sempre vazio, tratamento feito fora desta funcao
      view_name                    = p_table
      check_ddic_mainflag          = 'X'
    TABLES
      dba_sellist                  = tg_sellist
      excl_cua_funct               = tg_excl_funct
    EXCEPTIONS
      client_reference             = 1
      foreign_lock                 = 2
      invalid_action               = 3
      no_clientindependent_auth    = 4
      no_database_function         = 5
      no_editor_function           = 6
      no_show_auth                 = 7
      no_tvdir_entry               = 8
      no_upd_auth                  = 9
      only_show_allowed            = 10
      system_failure               = 11
      unknown_field_in_dba_sellist = 12
      view_not_found               = 13
      maintenance_prohibited       = 14
      OTHERS                       = 15.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " f_show_view

*&---------------------------------------------------------------------*
*&      Form  f_exibe_de_restricao
*&---------------------------------------------------------------------*
FORM f_exibe_de_restricao .

  DATA: lt_dd17s TYPE dd17s OCCURS 0 WITH HEADER LINE,
        lt_fcat  TYPE lvc_t_fcat.

  CHECK p_com_r = 'X' AND v_tab_esp = 'X'.

* Seleciona campos indices
  SELECT *
    FROM dd17s
    INTO TABLE lt_dd17s
    WHERE sqltab    = p_table    AND
          as4local  = c_as4local AND
          as4vers   = c_as4vers.

  IF sy-subrc = 0.
    SORT lt_dd17s BY fieldname.
    DELETE ADJACENT DUPLICATES FROM lt_dd17s COMPARING fieldname.
  ENDIF.

* Filtra chave e indice.
  LOOP AT tg_namtab INTO wa_namtab.
    " Descarta campo MANDANTE na seleção
    IF sy-tabix EQ 1.
      IF wa_namtab-datatype EQ 'CLNT'.
        DELETE tg_namtab INDEX sy-tabix.
        CONTINUE.
      ENDIF.
    ENDIF.

    READ TABLE lt_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = wa_namtab-viewfield
                                             tech = 'X'.    "Exclui campos tecnico, por exemplo MANDT

    IF sy-subrc = 0.
      DELETE tg_namtab WHERE viewfield = wa_namtab-viewfield .
      CONTINUE.
    ENDIF.

  ENDLOOP.

* Exibe tela de selecao das condicoes.
  CALL FUNCTION 'TABLE_RANGE_INPUT'                         "#EC *
    EXPORTING
      table                = p_table
      show_selection_popup = ''
    TABLES
      sellist              = tg_sellist
      x_header             = tg_header
      x_namtab             = tg_namtab
    EXCEPTIONS
      cancelled_by_user    = 1
      no_input             = 2
      OTHERS               = 3.

  IF sy-subrc NE 0.
    "Ação cancelada pelo usuário
    MESSAGE s017 DISPLAY LIKE 'E'.

    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.                    " f_exibe_de_restricao
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
