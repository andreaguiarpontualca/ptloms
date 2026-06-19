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
REPORT /PTLOMS/MP904  MESSAGE-ID /ptloms/cm001.

* Declarações globais
INCLUDE /PTLOMS/MP904_top.

* Rotinas PBO
INCLUDE /PTLOMS/MP904_o01.

* Forms
INCLUDE /PTLOMS/MP904_f01.

* Rotinas PAI
INCLUDE /PTLOMS/MP904_i01.

* Implementação de Classes
*INCLUDE /PTLOMS/MP904_cl01.

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
