*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/MP003                                     *
*& Transação       : /PTLOMS/PTLOMSN003                                *
*& Objetivo        : Programa para administrar cadastro de usuários    *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
*REPORT /PTLOMS/MP003.

* Declarações globais
INCLUDE /ptloms/mp003_top.

* Rotinas PBO
INCLUDE /ptloms/mp003_o01.

* Forms
INCLUDE /ptloms/mp003_f01.

* Rotinas PAI
INCLUDE /ptloms/mp003_i01.

* Implementação de Classes
INCLUDE /ptloms/mp003_cl01.
