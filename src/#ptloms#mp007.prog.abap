*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/MP004                                     *
*& Transação       : /PTLOMS/PTLOMSN004                                *
*& Objetivo        : Despacho                                          *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
*REPORT /PTLOMS/MP004.

* Declarações globais
INCLUDE /PTLOMS/MP007_TOP.
*INCLUDE /ptloms/mp004_top.

* Rotinas PBO
INCLUDE /PTLOMS/MP007_O01.
*INCLUDE /ptloms/mp004_o01.

* Forms
INCLUDE /PTLOMS/MP007_F01.
*INCLUDE /ptloms/mp004_f01.

* Rotinas PAI
INCLUDE /PTLOMS/MP007_I01.
*INCLUDE /ptloms/mp004_i01.

* Implementação de Classes
INCLUDE /PTLOMS/MP007_CL01.
*INCLUDE /ptloms/mp004_cl01.

*&---------------------------------------------------------------------*
*& Processamento Principal
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  DATA: lv_erro TYPE char1.

  PERFORM f_auth CHANGING lv_erro.
  IF lv_erro IS INITIAL.
    PERFORM f_validacao_inicial CHANGING lv_erro.
    IF lv_erro IS INITIAL.
      PERFORM f_monta_monitor_plan.
      PERFORM f_monta_range_objid.
      PERFORM f_despacho.
    ENDIF.
  ENDIF.
