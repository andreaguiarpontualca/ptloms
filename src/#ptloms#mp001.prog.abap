*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/MP001                                     *
*& Transação       : /PTLOMS/PTLOMS                                    *
*& Objetivo        : Programa para administrar funcionalidades do OMS  *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
*PROGRAM /PTLOMS/MP001.

* Declarações globais
INCLUDE /ptloms/mp001_top.

* Rotinas PBO
INCLUDE /ptloms/mp001_o01.

* Forms
INCLUDE /ptloms/mp001_f01.

* Rotinas PAI
INCLUDE /ptloms/mp001_i01.

* Implementação de Classes
INCLUDE /ptloms/mp001_cl01.
