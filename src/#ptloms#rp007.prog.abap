*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/RP006                                     *
*& Transação       : /PTLOMS/PTLOMSN007                                *
*& Objetivo        : Ajustes Cadastro Centro Trabalho                  *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************
REPORT /ptloms/rp007 MESSAGE-ID /ptlgpn/cm001.

*-----------------------------------------------------------------------
* Tela de Seleção
*-----------------------------------------------------------------------
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE text-001.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_exp RADIOBUTTON GROUP r1 USER-COMMAND radio MODIF ID r1 DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(79) text-002 FOR FIELD p_exp.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_imp RADIOBUTTON GROUP r1 MODIF ID r1.
SELECTION-SCREEN COMMENT 3(79) text-003 FOR FIELD p_imp.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN: END OF BLOCK b01.

*&---------------------------------------------------------------------*
*& Processamento Principal
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_start.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  F_START
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_start .

  IF p_exp = 'X'.

    DATA: lt_tb017 TYPE TABLE OF /ptloms/tb017.

    SELECT * FROM /ptloms/tb017 INTO CORRESPONDING FIELDS OF TABLE lt_tb017
      WHERE perfil NE ' '.

    DATA: ls_tb017 LIKE LINE OF lt_tb017.

    IF  lt_tb017[] IS NOT INITIAL.
      LOOP AT lt_tb017 INTO ls_tb017.
        MODIFY /ptloms/tb017_bk FROM ls_tb017.
      ENDLOOP.
      DELETE FROM /ptloms/tb017.
    ENDIF.

  ELSE.

    DATA: lt_tb017_bk TYPE TABLE OF /ptloms/tb017_bk.
    SELECT * FROM /ptloms/tb017_bk INTO TABLE lt_tb017_bk
      WHERE perfil NE ' '.

    IF  lt_tb017_bk[] IS NOT INITIAL.
      DATA: ls_tb017_bk LIKE LINE OF lt_tb017_bk.
      LOOP AT lt_tb017_bk INTO ls_tb017_bk.
        MODIFY /ptloms/tb017 FROM ls_tb017_bk.
      ENDLOOP.
      DELETE FROM /ptloms/tb017_bk.
    ENDIF.

  ENDIF.

ENDFORM.
