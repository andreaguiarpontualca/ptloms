*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGF001I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_BUKRS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_bukrs INPUT.

  PERFORM f_help_cod_bukrs.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_WERKS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_werks INPUT.

  PERFORM f_help_cod_werks.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_IWERK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_iwerk INPUT.

  PERFORM f_help_cod_iwerk.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_INGRP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_ingrp INPUT.

  PERFORM f_help_cod_ingrp.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_IWERK_2  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_werks_2 INPUT.

  PERFORM f_help_cod_werks_2.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_BEBER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_beber INPUT.

  PERFORM f_help_cod_beber.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_OBJID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_objid INPUT.

  PERFORM f_help_cod_objid.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_WERKS_3  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_werks_3 INPUT.

  PERFORM f_help_cod_werks_3.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_FLTYP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_fltyp INPUT.

  PERFORM f_help_cod_fltyp.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_QMART  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_qmart INPUT.

  PERFORM f_help_cod_qmart.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TABSTRIP_ACTIVE_TAB_GET  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE tabstrip_active_tab_get INPUT.

  PERFORM f_tabstrip_active_tab_get.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_PERFIL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_perfil INPUT.

  PERFORM f_help_perfil.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_PERFIL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_perfil INPUT.

  PERFORM f_valida_perfil.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SAIR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE sair INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC'.

    LEAVE PROGRAM.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0012  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0012 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC'.

    LEAVE PROGRAM.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_empresa_centro.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0111  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0111 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_grupo_planejamento.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0131  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0121 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_area_operacional.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0131  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0131 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_centro_trabalho.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0141  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0141 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_cat_loc_inst.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0151  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0151 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_cat_equipamento.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0161  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0161 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_grupo_tipo_objeto.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0171  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0171 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_tipo_nota.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0181  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0181 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_tipo_ordem.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0201  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0201 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_tipo_atv_ordem.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0211  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0211 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_grupo_mercadoria.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0221  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0221 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_deposito.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0231  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0231 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_causa_desvio.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0252  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0252 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_caracteristica.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0111  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0191 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_tipo_material.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_EMPRESA_CENTRO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_empresa_centro INPUT.

  PERFORM f_valida_empresa_centro.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_EMPRESA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_empresa INPUT.

  PERFORM f_help_cod_adm_empresa.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_CENTRO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_centro INPUT.

  PERFORM f_help_cod_adm_centro USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_CENTRO_GRP_P  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_centro_grp_p INPUT.

  PERFORM f_help_cod_adm_centro_grp_p USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_GRUPO_PLANEJAMENTO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_grupo_planejamento INPUT.

*  PERFORM f_valida_grupo_planejamento.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_GRP_P  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_grp_p INPUT.

  PERFORM f_help_cod_adm_grp_p.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_AREA_OPERACIONAL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_area_operacional INPUT.

*  PERFORM f_valida_area_operacional.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_CENTRO_TRABALHO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_centro_trabalho INPUT.

*  PERFORM f_valida_centro_trabalho.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_CAT_LOC_INST  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_cat_loc_inst INPUT.

  PERFORM f_valida_cat_loc_inst.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_CAT_EQUIPAMENTO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_cat_equipamento INPUT.

  PERFORM f_valida_cat_equipamento.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_CARACT_EQUIPAMENTO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

MODULE valida_caract_equipamento INPUT.

  PERFORM f_valida_caract_equipamento.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_STATUS_EQUIPAMENTO_INCLUSIVO INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_status_inclusivo INPUT.

  PERFORM f_valida_status_inclusivo.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  VALIDA_STATUS_EQUIPAMENTO_ESPECIFICO INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_status_exclusivo INPUT.

  PERFORM f_valida_status_exclusivo.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_TIPO_OBJETO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_tipo_objeto INPUT.

*  PERFORM f_valida_tipo_objeto.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_TIPO_NOTA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_tipo_nota INPUT.

  PERFORM f_valida_tipo_nota.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_TIPO_ORDEM  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_tipo_ordem INPUT.

  PERFORM f_valida_tipo_ordem.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_TIPO_ATV_ORDEM  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_tipo_atv_ordem INPUT.

  PERFORM f_valida_tipo_atv_ordem.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_GRUPO_MERCADORIA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_grupo_mercadoria INPUT.

  PERFORM f_valida_grupo_mercadoria.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_DEPOSITO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_deposito INPUT.

  PERFORM f_valida_deposito.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_CAUSA_DESVIO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_causa_desvio INPUT.

  PERFORM f_valida_causa_desvio.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDA_TIPO_MATERIAL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valida_tipo_material INPUT.

  PERFORM f_valida_tipo_material.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_Centro_AO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_centro_ao INPUT.

  PERFORM f_help_cod_adm_centro_ao USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_BEBER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_beber INPUT.

  PERFORM f_help_cod_adm_beber.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_OBJID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_objid INPUT.

  PERFORM f_help_cod_adm_objid USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_CENTRO_CT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_centro_ct INPUT.

  PERFORM f_help_cod_adm_centro_ct.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_FLTYP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_fltyp INPUT.

  PERFORM f_help_cod_adm_fltyp USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_EQTYP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_status_inclusivo INPUT.

  PERFORM f_help_status_inclusivo USING space.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_EQTYP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_prioridade INPUT.

  PERFORM f_help_prioridade USING space.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_EQTYP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_tipo_ordem_prioridade INPUT.

  PERFORM f_help_tipo_ordem_prioridade USING space.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_EQTYP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_status_exclusivo INPUT.

  PERFORM f_help_status_exclusivo USING space.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_EQTYP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_eqtyp INPUT.

  PERFORM f_help_cod_adm_eqtyp USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_EQART  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_eqart INPUT.

  PERFORM f_help_cod_adm_eqart USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_MATKL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_matkl INPUT.

  PERFORM f_help_cod_adm_matkl USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_LGORT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_lgort INPUT.

  PERFORM f_help_cod_adm_lgort USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_GRUND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_grund INPUT.

  PERFORM f_help_cod_adm_grund USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_QMART  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_qmart INPUT.

  PERFORM f_help_cod_adm_qmart USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_AUART  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_filtro_catalogo INPUT.

  DATA: lv_1 TYPE char2,
        lv_2 TYPE auarttext.

  PERFORM f_help_filtro_catalogo CHANGING lv_1 lv_2.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_AUART  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_auart INPUT.

  PERFORM f_help_cod_adm_auart USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_ILART  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_ilart INPUT.

  PERFORM f_help_cod_adm_ilart USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_MTART  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_mtart INPUT.

  PERFORM f_help_cod_adm_mtart USING space.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v001 INPUT.

  PERFORM f_help_v001.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v002 INPUT.

  PERFORM f_help_v002.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V003  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v003 INPUT.

  PERFORM f_help_v003.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V004  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v004 INPUT.

  PERFORM f_help_v004.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V004_2  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v004_2 INPUT.

  PERFORM f_help_v004_2.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V015  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v015 INPUT.

  PERFORM f_help_v015.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0012'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  F_HELP_V004  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v018 INPUT.

  PERFORM f_help_v018.

ENDMODULE.

*&      Module  F_HELP_V004_2  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v018_2 INPUT.

  PERFORM f_help_v018_2.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0153  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0153 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_equi_status_exclusivo.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0153  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0154 INPUT.

  IF sy-ucomm = 'EXIT' OR
     sy-ucomm = 'BACK' OR
     sy-ucomm = 'CANC' OR
     sy-ucomm = 'ABR'  OR
     sy-ucomm = 'BTN_CANCEL'.

    LEAVE TO SCREEN 0.

  ELSEIF sy-ucomm = 'BTN_SAVE'.

    PERFORM f_grava_equi_status_exclusivo.

    LEAVE TO SCREEN 0.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V016  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v016 INPUT.

  PERFORM f_help_v016.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_V017  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_v017 INPUT.

  PERFORM f_help_v017.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F_HELP_COD_ADM_CARACT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f_help_cod_adm_caract INPUT.

  PERFORM f_help_cod_adm_caract USING space.

ENDMODULE.
