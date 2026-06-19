*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP002_TOP
*&---------------------------------------------------------------------*
PROGRAM /ptloms/mp002.

CONSTANTS: BEGIN OF c_tabstrip,
             tab1  TYPE sy-ucomm VALUE 'TABSTRIP_FC1',
             tab2  TYPE sy-ucomm VALUE 'TABSTRIP_FC2',
             tab3  TYPE sy-ucomm VALUE 'TABSTRIP_FC3',
             tab4  TYPE sy-ucomm VALUE 'TABSTRIP_FC4',
             tab5  TYPE sy-ucomm VALUE 'TABSTRIP_FC5',
             tab6  TYPE sy-ucomm VALUE 'TABSTRIP_FC6',
             tab7  TYPE sy-ucomm VALUE 'TABSTRIP_FC7',
             tab8  TYPE sy-ucomm VALUE 'TABSTRIP_FC8',
             tab9  TYPE sy-ucomm VALUE 'TABSTRIP_FC9',
             tab10 TYPE sy-ucomm VALUE 'TABSTRIP_FC10',
           END OF c_tabstrip.

CONTROLS: tabstrip TYPE TABSTRIP.

DATA: BEGIN OF g_tabstrip,
        subscreen   TYPE sy-dynnr,
        prog        TYPE sy-repid VALUE '/PTLOMS/MP002',
        pressed_tab TYPE sy-ucomm VALUE c_tabstrip-tab1,
      END OF g_tabstrip.
