*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Pool móds.                                        *
*& Nome            : /PTLOMS/MP002                                     *
*& Transação       : /PTLOMS/PTLOMS                                    *
*& Objetivo        : Programa para administrar Perfil                  *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
*PROGRAM /PTLOMS/MP002.

* Declarações globais
INCLUDE /ptloms/mp002_top.

* Rotinas PBO
INCLUDE /ptloms/mp002_o01.

* Forms
INCLUDE /ptloms/mp002_f01.

* Rotinas PAI
INCLUDE /ptloms/mp002_i01.

* Implementação de Classes
INCLUDE /ptloms/mp002_cl01.
