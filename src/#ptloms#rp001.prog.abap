*----------------------------------------------------------------------*
*              PONTUAL CONSULTORES ASSOCIADOS LTDA ®                   *
*----------------------------------------------------------------------*
* Programa   : /PTLOMS/RP001                                           *
* Descrição  : Atualização Visão Tabela                                *
*----------------------------------------------------------------------*
* Autor      : PONTUAL CONSULTORES ASSOCIADOS                          *
*----------------------------------------------------------------------*
*              HISTÓRICO DAS MODIFICAÇÕES                              *
*----------------------------------------------------------------------*
* Autor      :                                        Data:   /  /     *
* Observações:                                                         *
*----------------------------------------------------------------------*
REPORT  /ptloms/rp001 MESSAGE-ID /PTLOMS/CM001.

*&---------------------------------------------------------------------*
* Constantes
*&---------------------------------------------------------------------*
CONSTANTS: c_as4local TYPE as4local VALUE 'A',
           c_as4vers  TYPE as4vers  VALUE '0000'.

*&---------------------------------------------------------------------*
* Declarações Globais
*&---------------------------------------------------------------------*
* Work areas
DATA: wa_namtab    LIKE  vimnamtab.

* Tabelas Internas
DATA: tg_sellist    LIKE  vimsellist OCCURS 0,
      tg_excl_funct TYPE STANDARD TABLE OF vimexclfun,
      tg_header     LIKE  vimdesc    OCCURS 0,
      tg_namtab     LIKE  vimnamtab  OCCURS 0.

DATA: v_tab_esp TYPE c.

*&---------------------------------------------------------------------*
* Tela de Seleção
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_table   TYPE dd02l-tabname OBLIGATORY MODIF ID dtb.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-024.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 1.
PARAMETERS: p_sem_r RADIOBUTTON GROUP gr1.
SELECTION-SCREEN COMMENT 3(40) text-025.
SELECTION-SCREEN END OF LINE.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 1.
PARAMETERS: p_com_r RADIOBUTTON GROUP gr1.
SELECTION-SCREEN COMMENT 3(40) text-026.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b2.

*&---------------------------------------------------------------------*
* Includes auxiliares
*&---------------------------------------------------------------------*
INCLUDE /PTLOMS/IN001.

*&---------------------------------------------------------------------*
* INITIALIZATION.
*&---------------------------------------------------------------------*
INITIALIZATION.

  PERFORM f_get_paramenter CHANGING p_table.

*&---------------------------------------------------------------------*
* Consistencias
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_table.

  PERFORM f_check_table USING p_table.

*&---------------------------------------------------------------------*
* Logica Principal
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  SET PARAMETER ID 'DTB' FIELD p_table.

  PERFORM: f_verifica_permissao,
           f_exibe_de_restricao ,
           f_show_view_table.
