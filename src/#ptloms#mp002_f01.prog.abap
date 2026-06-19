*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_TABSTRIP_ACTIVE_TAB_SET
*&---------------------------------------------------------------------*
FORM f_tabstrip_active_tab_set .

* Determinando qual subtela será apresentada nas trocas de abas
  tabstrip-activetab = g_tabstrip-pressed_tab.

  CASE g_tabstrip-pressed_tab.

*   ABA REFORMA
    WHEN c_tabstrip-tab1.
      g_tabstrip-subscreen = '0110'.

*   ABA TRANSFERÊNCIA
    WHEN c_tabstrip-tab2.
      g_tabstrip-subscreen = '0120'.

*   ABA TROCA
    WHEN c_tabstrip-tab3.
      g_tabstrip-subscreen = '0130'.

*   ABA BAIXA
    WHEN c_tabstrip-tab4.
      g_tabstrip-subscreen = '0140'.

*   ABA HISTÓRICO
    WHEN c_tabstrip-tab5.
      g_tabstrip-subscreen = '0150'.

*   ABA MEDIÇÃO DE SULCOS
    WHEN c_tabstrip-tab6.
      g_tabstrip-subscreen = '0160'.

*   ABA CUSTOS
    WHEN c_tabstrip-tab7.
      g_tabstrip-subscreen = '0170'.

*   ABA CUSTOS
    WHEN c_tabstrip-tab8.
      g_tabstrip-subscreen = '0180'.

*   ABA CUSTOS
    WHEN c_tabstrip-tab9.
      g_tabstrip-subscreen = '0190'.

*   ABA CUSTOS
    WHEN c_tabstrip-tab10.
      g_tabstrip-subscreen = '0200'.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PBO_0100
*&---------------------------------------------------------------------*
FORM f_pbo_0100 .

  AUTHORITY-CHECK OBJECT '/PTLOMS/04'
           ID 'TCD' FIELD sy-tcode
           ID 'ACTVT' FIELD '02'.

  IF sy-subrc <> 0.
    MESSAGE e001(/ptloms/cm001) WITH '/PTLOMS/04'.
  ENDIF.

ENDFORM.
