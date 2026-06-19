*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/RP002                                     *
*& Transação       : /PTLOMS/PTLOMSN005                                *
*& Objetivo        : Exibição de Log                                   *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*

REPORT /ptloms/rp002.

*&---------------------------------------------------------------------*
*& Processamento Principal
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_verifica_permissao.
  SET PARAMETER ID 'BALOBJ' FIELD '/PTLOMS/OMS'.
  SET PARAMETER ID 'BALSUBOBJ' FIELD '*'.
  SET PARAMETER ID 'BALEXT' FIELD '*'.
  CALL TRANSACTION 'SLG1'.

END-OF-SELECTION.
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
