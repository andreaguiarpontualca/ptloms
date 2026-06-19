class /PTLOMS/CL015 definition
  public
  final
  create public .

public section.

  types:
    tt_werks TYPE RANGE OF viaufks-werks .
  types:
    tt_auart      TYPE RANGE OF viaufks-auart .
  types:
    tt_usuperfil TYPE RANGE OF /ptloms/tb013-usuario .
  types:
    tt_eqtyp TYPE RANGE OF equi-eqtyp .
  types:
    tt_fltyp TYPE RANGE OF fltyp .

  methods BUSCA_DETALHES_ORDEM
    importing
      value(I_DETALHE) type /PTLOMS/CT127
    exporting
      value(E_DETALHE) type /PTLOMS/CT132 .
  methods BUSCA_HISTORICO_ASSOCIACOES
    importing
      !RT_GUID type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_AUFNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_UNAME type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_VORNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_CRIADOPOR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATACRIACAO type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_HORACRIACAO type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ALTERADOPOR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATADESSAC type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_HORADESSAC type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_MOTIVO type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !ASSOCIACOES type /PTLOMS/CT161 .
  methods BUSCA_HISTORICO_CONFIRMACAO
    importing
      value(HISTOR_CONFIRM_IN) type /PTLOMS/CT154
    exporting
      !HISTOR_CONFIRM_OUT type /PTLOMS/CT154 .
  methods BUSCA_LISTA_ASSOCIACOES
    importing
      !RT_AUFNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_UNAME type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !ASSOCIACOES type /PTLOMS/CT125 .
  methods BUSCA_LISTA_OPERACOES
    importing
      value(ORIGEM) type CHAR3 optional
      value(RT_WERKS) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_AUFNR) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_VORNR) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_AUART) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_QMNUM) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_PRIOK) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_TPLNR) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_EQUNR) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_KOSTLEQUNR) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_KOSTLFUNCL) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_IWERK) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_USUAPP) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_INGPR) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_ILART) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_GEWRK) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_GSTRP_INI) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_GSTRP_FIM) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_DATOPE_INI) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_DATOPE_FIM) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_VLSCH) type /IWBEP/T_COD_SELECT_OPTIONS optional
    exporting
      value(IT_DESPACHO) type /PTLOMS/CT119
      value(IT_FILTRO) type /PTLOMS/CT103 .
  methods CONFIRMAR_OPERACOES
    importing
      !I_DETALHE type /PTLOMS/CT133
    exporting
      !E_DETALHE type /PTLOMS/CT135 .
  methods DESASSOCIAR_OPERACAO
    importing
      value(I_DETALHE) type /PTLOMS/CT138
    exporting
      value(E_DETALHE) type /PTLOMS/CT139 .
  methods GRAVAR_TABELA_HISTORICO
    importing
      value(STATUS) type INT1 optional
      value(GUID) type /PTLOMS/ED118 optional
      !USUARIO type SY-UNAME
      value(MOTIVO) type CHAR4 optional
    exporting
      !RETORNO type BAPI_MTYPE .
  methods RECUSAR_OPERACAO
    importing
      value(I_DETALHE) type /PTLOMS/CT144
    exporting
      value(E_DETALHE) type /PTLOMS/CT142 .
protected section.
private section.

  data:
    s_werks      TYPE RANGE OF crhd-werks .
  data:
    s_eqtyp      TYPE RANGE OF equi-eqtyp .
  data:
    s_aufnr      TYPE RANGE OF viaufks-aufnr .
  data:
    s_vornr      TYPE RANGE OF afvgd-vornr .
  data:
    s_auart      TYPE RANGE OF viaufks-auart .
  data:
    s_qmnum      TYPE RANGE OF viaufks-qmnum .
  data:
    s_priok      TYPE RANGE OF viaufks-priok .
  data:
    s_tplnr      TYPE RANGE OF viaufks-tplnr .
  data:
    s_equnr      TYPE RANGE OF viaufks-equnr .
  data:
    s_iwerk      TYPE RANGE OF viaufks-iwerk .
  data:
    s_ingpr      TYPE RANGE OF viaufks-ingpr .
  data:
    s_ilart      TYPE RANGE OF viaufks-ilart .
  data:
    s_gewrk      TYPE RANGE OF crhd-arbpl .
  data:
    s_gstrp      TYPE RANGE OF viaufks-gstrp .
  data:
    s_gstrp_ini  TYPE RANGE OF viaufks-gstrp .
  data:
    s_datope_ini TYPE RANGE OF afvv-fsavd .
  data:
    s_gstrp_fim  TYPE RANGE OF viaufks-gstrp .
  data:
    s_datope_fim TYPE RANGE OF afvv-fsavd .
  data:
    s_usuapp     TYPE RANGE OF /ptloms/tb013-usuario .
  data:
    s_vlsch      TYPE RANGE OF vlsch .
  data GT_DESPACHO type /PTLOMS/CT079 .

  methods CONVERTE_TIMESTAMP .
  methods ESTORNAR_CONFIRMACAO .
  methods GET_USER
    importing
      !P_USER type /PTLOMS/TB013-USUARIO
    changing
      !P_USER_NAME type /PTLOMS/TB013-NOME .
  methods GRAVAR_TABELA_CONFIRMACAO
    importing
      value(AUFNR) type AUFNR
      value(VORNR) type VORNR
      !GUID_ASSOCIACAO type /PTLOMS/ED118
      !GUID_CONFIRMACAO type /PTLOMS/ED118
      !UNAME type UNAME
      !FIN_CONF type CHAR1
      !N_CONFIRMACAO type CO_RUECK optional
      !C_CONFIRMACAO type CO_RMZHL optional
      !D_CONFIRMACAO type RU_ERSDA optional
      !T_CONFIRMACAO type ISMNW optional
      !LATITUDE type /PTLOMS/ED106 optional
      !LONGITUDE type /PTLOMS/ED107 optional
    exporting
      !RETORNO type BAPI_MTYPE .
  methods PREPARA_CONFIRMACAO
    importing
      value(I_DETALHE) type /PTLOMS/ET160
    exporting
      value(E_CONFIRMACAO) type /PTLOMS/ET051 .
ENDCLASS.



CLASS /PTLOMS/CL015 IMPLEMENTATION.


  METHOD busca_detalhes_ordem.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 11/12/2025 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************
*    DATA: w_detalhe                LIKE LINE OF i_detalhe,
*          v_aufnr                  TYPE aufnr,
*          ls_header                TYPE bapi_alm_order_header_e,
*          lt_operations            TYPE TABLE OF bapi_alm_order_operation_e,
*          lt_components            TYPE TABLE OF bapi_alm_order_component_e,
*          lt_text_lines            TYPE TABLE OF bapi_alm_text_lines,
*          ls_text_lines            LIKE LINE OF  lt_text_lines,
*          lt_retorno               TYPE bapiret2_t,
*          ls_retorno               TYPE bapiret2,
*          lt_texts                 TYPE STANDARD TABLE OF bapi_alm_text,
*          ls_texts                 LIKE LINE OF lt_texts,
*          ls_equimaster            TYPE bapi_equi,
*          ls_equitext              TYPE bapi_eqkt,
*          ls_return                TYPE bapireturn,
*          ls_general_exp           TYPE bapi_itob,
*          detalhe_ordem            TYPE /ptloms/et158,
*          lt_viaufks               TYPE TABLE OF viaufks,
*          ls_viaufks               LIKE LINE OF lt_viaufks,
*          lt_034                   TYPE TABLE OF /ptloms/tb034,
*          ls_034                   LIKE LINE OF lt_034,
*          lv_data_referencia_verde TYPE sy-datum,
*          lv_data_referencia_verme TYPE sy-datum.

    DATA: w_detalhe                LIKE LINE OF i_detalhe,
          v_aufnr                  TYPE aufnr,
          ls_header                TYPE bapi_alm_order_header_e,
          lt_operations            TYPE STANDARD TABLE OF bapi_alm_order_operation_e,
          lt_components            TYPE STANDARD TABLE OF bapi_alm_order_component_e,
          lt_text_lines            TYPE STANDARD TABLE OF bapi_alm_text_lines,
          ls_text_lines            LIKE LINE OF  lt_text_lines,
          lt_retorno               TYPE bapiret2_t,
          ls_retorno               TYPE bapiret2,
          lt_texts                 TYPE STANDARD TABLE OF bapi_alm_text,
          ls_texts                 LIKE LINE OF lt_texts,
          ls_equimaster            TYPE bapi_equi,
          ls_equitext              TYPE bapi_eqkt,
          ls_return                TYPE bapireturn,
          ls_general_exp           TYPE bapi_itob,
          detalhe_ordem            TYPE /ptloms/et158,
          lt_viaufks               TYPE TABLE OF viaufks,
          ls_viaufks               LIKE LINE OF lt_viaufks,
          lt_034                   TYPE TABLE OF /ptloms/tb034,
          ls_034                   LIKE LINE OF lt_034,
          lv_data_referencia_verde TYPE sy-datum,
          lv_data_referencia_verme TYPE sy-datum.


    FIELD-SYMBOLS: <fs_operations> TYPE /ptloms/et147.

    "Declarações necessária para compatibilidade
    DATA: ls_operations  TYPE /ptloms/et147,
          ls_retorno_aux TYPE /ptloms/et060.
    FIELD-SYMBOLS: <fs_operation> TYPE bapi_alm_order_operation_e,
                   <fs_component> TYPE bapi_alm_order_component_e,
                   <fs_retorno>   TYPE bapiret2.

    LOOP AT i_detalhe INTO w_detalhe.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = w_detalhe-aufnr
        IMPORTING
          output = v_aufnr.


*----------------------------------*
*   Busca informações da ordem     *
*----------------------------------*
      CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
        EXPORTING
          number        = v_aufnr
        IMPORTING
          es_header     = ls_header
        TABLES
          et_operations = lt_operations
          et_components = lt_components
          et_text_lines = lt_text_lines
          et_texts      = lt_texts
          return        = lt_retorno.

      MOVE-CORRESPONDING ls_header TO detalhe_ordem.

      detalhe_ordem-aufnr = w_detalhe-aufnr.
*      detalhe_ordem-vornr = w_detalhe-vornr.
      detalhe_ordem-short_text_ordem = ls_header-short_text.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = ls_header-task_list_group
        IMPORTING
          output = detalhe_ordem-task_list_group.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = detalhe_ordem-group_counter
        IMPORTING
          output = ls_header-group_counter.

      detalhe_ordem-task_list_type   = ls_header-task_list_type.

*      MOVE-CORRESPONDING lt_operations TO detalhe_ordem-operacoesordemset[].

      LOOP AT lt_operations ASSIGNING <fs_operation>.
        CLEAR ls_operations.
        MOVE-CORRESPONDING <fs_operation> TO ls_operations.
        APPEND ls_operations TO detalhe_ordem-operacoesordemset.
      ENDLOOP.

      LOOP AT detalhe_ordem-operacoesordemset ASSIGNING <fs_operations>.
        <fs_operations>-aufnr = detalhe_ordem-aufnr.
        <fs_operations>-vornr = <fs_operations>-activity.
      ENDLOOP.

      DATA: lt_saldo_material TYPE /ptloms/ct064.
      DATA: ls_components     TYPE /ptloms/et155,
            ls_saldo_material LIKE LINE OF lt_saldo_material.
      DATA: rt_matnr TYPE /iwbep/t_cod_select_options,
            rt_werks TYPE /iwbep/t_cod_select_options,
            rt_lgort TYPE /iwbep/t_cod_select_options,
            ls_matnr LIKE LINE OF rt_matnr,
            ls_werks LIKE LINE OF rt_werks,
            ls_lgort LIKE LINE OF rt_lgort.

      DATA: o_oms TYPE REF TO /ptloms/cl001.

      CREATE OBJECT o_oms.

*      MOVE-CORRESPONDING lt_components TO detalhe_ordem-componentesordemset[].

      LOOP AT lt_components ASSIGNING <fs_component>.
        IF <fs_component>-delete_ind IS NOT INITIAL.
          CONTINUE.
        ENDIF.
        CLEAR ls_components.
        MOVE-CORRESPONDING <fs_component> TO ls_components.
        APPEND ls_components TO detalhe_ordem-componentesordemset.
      ENDLOOP.

      LOOP AT detalhe_ordem-componentesordemset INTO ls_components.
        SHIFT ls_components-reserv_no LEFT DELETING LEADING '0'.
        SHIFT ls_components-res_item  LEFT DELETING LEADING '0'.
        SHIFT ls_components-orderid  LEFT DELETING LEADING '0'.
        SHIFT ls_components-material  LEFT DELETING LEADING '0'.
*        SHIFT ls_components-activity  LEFT DELETING LEADING '0'.

* Busca estoque do Material do Componente
        IF ls_components-material IS NOT INITIAL.
          CLEAR:  ls_matnr, rt_matnr.
          ls_matnr-sign = 'I'.
          ls_matnr-option = 'EQ'.
          ls_matnr-low = ls_components-material.
          APPEND ls_matnr TO rt_matnr.

          IF ls_components-plant IS NOT INITIAL.
            CLEAR:  ls_werks, rt_werks.
            ls_werks-sign = 'I'.
            ls_werks-option = 'EQ'.
            ls_werks-low = ls_components-plant.
            APPEND ls_werks TO rt_werks.

            IF ls_components-stge_loc IS NOT INITIAL.
              CLEAR: ls_lgort, rt_lgort.
              ls_lgort-sign = 'I'.
              ls_lgort-option = 'EQ'.
              ls_lgort-low = ls_components-stge_loc.
              APPEND ls_lgort TO rt_lgort.
            ENDIF.

            REFRESH lt_saldo_material[].
            o_oms->out_estoque_material(
              EXPORTING
                rt_matnr = rt_matnr
                rt_werks = rt_werks
                rt_lgort = rt_lgort
              IMPORTING
                et_saldo = lt_saldo_material ).

            READ TABLE lt_saldo_material INTO ls_saldo_material INDEX 1.
            ls_components-labst = ls_saldo_material-labst.
          ENDIF.
        ENDIF.

* Converte Unidade de Medida
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
          EXPORTING
            input          = ls_components-requirement_quantity_unit
            language       = sy-langu
          IMPORTING
            output         = ls_components-requirement_quantity_unit
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.

        MODIFY detalhe_ordem-componentesordemset FROM ls_components.

      ENDLOOP.

*      MOVE-CORRESPONDING lt_retorno TO detalhe_ordem-retornoset[].

      LOOP AT lt_retorno ASSIGNING <fs_retorno>.
        CLEAR ls_retorno_aux.
        MOVE-CORRESPONDING <fs_retorno> TO ls_retorno_aux.
        APPEND ls_retorno_aux TO detalhe_ordem-retornoset.
      ENDLOOP.

      LOOP AT lt_text_lines INTO ls_text_lines.
        CONCATENATE detalhe_ordem-texto_longo_ordem ls_text_lines-tdline INTO detalhe_ordem-texto_longo_ordem.
      ENDLOOP.


*----------------------------------*
*   Busca descrição do equipamento *
*----------------------------------*
      IF ls_header-equipment IS NOT INITIAL.

        CALL FUNCTION 'BAPI_EQMT_DETAIL'
          EXPORTING
            equipment  = ls_header-equipment
          IMPORTING
            equimaster = ls_equimaster
            equitext   = ls_equitext
            return     = ls_return.

        detalhe_ordem-eqktx = ls_equitext-equidescr.
        detalhe_ordem-invnr = ls_equimaster-inventory.

        SELECT SINGLE ile~kostl
          FROM equz AS eqz
          LEFT OUTER JOIN iloa AS ile ON ile~iloan = eqz~iloan
         WHERE eqz~datbi = '99991231'
           AND eqz~equnr = @ls_header-equipment
          INTO @detalhe_ordem-kostl_equnr.

        detalhe_ordem-kostl_equnr = |{ detalhe_ordem-kostl_equnr ALPHA = OUT }|.

      ENDIF.

*------------------------------------------*
*  Busca descrição do local de instalação  *
*------------------------------------------*
      IF ls_header-funct_loc IS NOT INITIAL.

        CALL FUNCTION 'BAPI_FUNCLOC_GETDETAIL'
          EXPORTING
            functlocation    = ls_header-funct_loc
          IMPORTING
            data_general_exp = ls_general_exp.

        detalhe_ordem-pltxt = ls_general_exp-descript.

        SELECT SINGLE ifl~kostl
          FROM iflo AS ifl
         WHERE ifl~tplnr = @ls_header-funct_loc
          INTO @detalhe_ordem-kostl_funcl.

        detalhe_ordem-kostl_funcl = |{ detalhe_ordem-kostl_funcl ALPHA = OUT }|.

        CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
          EXPORTING
            input  = ls_header-funct_loc
          IMPORTING
            output = detalhe_ordem-funct_loc.

      ENDIF.

*------------------------------------------*
*  Busca detalhes da nota                  *
*------------------------------------------*
      IF detalhe_ordem-notif_no IS NOT INITIAL.

        DATA: ls_header_nota TYPE bapi2080_nothdre.

        CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
          EXPORTING
            number             = detalhe_ordem-notif_no
            clear_buffer       = 'X'
          IMPORTING
            notifheader_export = ls_header_nota.

        detalhe_ordem-qmart = ls_header_nota-notif_type.
        detalhe_ordem-qmtxt = ls_header_nota-short_text.

      ENDIF.

*----------------------------------*
*   Lógica para semáforo           *
*----------------------------------*
      SELECT SINGLE *
       INTO ls_034
       FROM /ptloms/tb034
       WHERE auart = detalhe_ordem-order_type AND
             priok = detalhe_ordem-priority.

      IF sy-subrc EQ 0.
        IF ls_034-urgente = 'X'.
          " Vermelho
          detalhe_ordem-semaforo_icone = 'sap-icon://status-error'.
          detalhe_ordem-semaforo_cor   = 'Error'.
          detalhe_ordem-semaforo_descricao = 'Alerta Vermelho'(001).
        ELSE.

          IF ls_034-verde IS INITIAL AND ls_034-vermelho IS INITIAL AND ls_034-amarelo IS INITIAL.
            detalhe_ordem-semaforo_cor = 'None'.
            detalhe_ordem-semaforo_descricao = 'Sem Alerta'(002).
          ELSE.
            lv_data_referencia_verde = detalhe_ordem-start_date(4) && detalhe_ordem-start_date+4(2) && detalhe_ordem-start_date+6(4).
            lv_data_referencia_verde = lv_data_referencia_verde + ls_034-verde.

            lv_data_referencia_verme = detalhe_ordem-start_date(4) && detalhe_ordem-start_date+4(2) && detalhe_ordem-start_date+6(4).
            lv_data_referencia_verme = lv_data_referencia_verme + ls_034-vermelho.
            " Verde
            IF sy-datum <= lv_data_referencia_verde.
              detalhe_ordem-semaforo_icone = 'sap-icon://status-completed'.
              detalhe_ordem-semaforo_cor   = 'Success'.
              detalhe_ordem-semaforo_descricao = 'Alerta Verde'(003).
              " Vermelho
            ELSEIF sy-datum >= lv_data_referencia_verme.
              detalhe_ordem-semaforo_icone = 'sap-icon://status-error'.
              detalhe_ordem-semaforo_cor   = 'Error'.
              detalhe_ordem-semaforo_descricao = 'Alerta Vermelho'(001).
              " Amarelo
            ELSE.
              detalhe_ordem-semaforo_icone = 'sap-icon://status-critical'.
              detalhe_ordem-semaforo_cor   = 'Warning'.
              detalhe_ordem-semaforo_descricao = 'Alerta Amarelo'(004).
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        detalhe_ordem-semaforo_cor = 'None'.
        detalhe_ordem-semaforo_descricao = 'Sem Alerta'(002).
      ENDIF.

*------------------------------------------*
*  Busca Texto referente à prioridade      *
*------------------------------------------*
      IF detalhe_ordem-priotype IS NOT INITIAL AND detalhe_ordem-priority IS NOT INITIAL.
        SELECT SINGLE priokx
          FROM t356_t INTO detalhe_ordem-priokx
          WHERE spras = sy-langu AND
                artpr = detalhe_ordem-priotype AND
                priok = detalhe_ordem-priority.
      ENDIF.

*---------------------------------------------------------*
*  Busca Nome do grupo de planejamento de manutenção      *
*---------------------------------------------------------*
      IF detalhe_ordem-plangroup IS NOT INITIAL.
        SELECT SINGLE innam
           FROM t024i INTO detalhe_ordem-innam
           WHERE ingrp = detalhe_ordem-plangroup.
      ENDIF.

*---------------------------------------------------------*
*  Busca Denominação breve do Centro de trabalho          *
*---------------------------------------------------------*
      IF ls_header-mn_wk_ctr IS NOT INITIAL AND ls_header-plant IS NOT INITIAL.
        SELECT SINGLE ktext
          INTO detalhe_ordem-mn_wkctr_descricao
          FROM  ld_crhd
               WHERE  spras  = sy-langu
               AND    arbpl  = ls_header-mn_wk_ctr
               AND    werks  = ls_header-plant.

      ENDIF.

*---------------------------------------------------------*
*  Busca Nome Centro                                      *
*---------------------------------------------------------*
      SELECT SINGLE name1
          INTO detalhe_ordem-desc_planplant
          FROM t001w
          WHERE werks = detalhe_ordem-planplant.

*---------------------------------------------------------*
*  Busca Centro de Trabalho                               *
*---------------------------------------------------------*
      IF detalhe_ordem-mn_wkctr_id IS NOT INITIAL.
        SELECT SINGLE arbpl FROM crhd INTO detalhe_ordem-arbpl WHERE objid = detalhe_ordem-mn_wkctr_id.
      ENDIF.

      APPEND detalhe_ordem TO e_detalhe.

      CLEAR: w_detalhe,ls_header,detalhe_ordem,ls_equimaster,ls_equitext,ls_return.

      REFRESH: lt_operations,lt_components,lt_text_lines,lt_texts,lt_retorno.

    ENDLOOP.


*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
  ENDMETHOD.


  METHOD busca_historico_associacoes.

    DATA: ti_tb066       TYPE TABLE OF /ptloms/tb066,
          wa_tb066       TYPE /ptloms/tb066,
          ti_associacoes TYPE /ptloms/ct061,
          associacao     LIKE LINE OF associacoes,
          ti_retorno     TYPE /ptloms/ct060,
          wa_retorno     LIKE LINE OF ti_retorno,
          wa_aufnr       TYPE /iwbep/s_cod_select_option.

    SELECT *
      FROM /ptloms/tb066
      INTO TABLE ti_tb066
      WHERE guid          IN rt_guid AND
            aufnr         IN rt_aufnr AND
            vornr         IN rt_vornr AND
            uname         IN rt_uname AND
            criadopor     IN rt_criadopor AND
            datacriacao   IN rt_datacriacao AND
            horacriacao   IN rt_horacriacao AND
            alteradopor   IN rt_alteradopor AND
            datadessac    IN rt_datadessac AND
            horadessac    IN rt_horadessac AND
            motivo        IN rt_motivo.

    IF sy-subrc IS INITIAL.

      DATA: ti_status_operacao      TYPE TABLE OF /ptloms/et187,
            wa_187                  TYPE /ptloms/et187,
            ti_motivos_deassociacao TYPE TABLE OF /ptloms/et186,
            wa_186                  TYPE /ptloms/et186.
      DATA(ti_dd07v_tab) = VALUE dd07v_tab( ).
      DATA(lv_rc)        = VALUE sy-subrc( ).

      "Busca Descrição dos Status Operação
      CALL FUNCTION 'DD_DOMVALUES_GET'
        EXPORTING
          domname        = '/PTLOMS/DM008'
          text           = abap_true
        IMPORTING
          rc             = lv_rc
        TABLES
          dd07v_tab      = ti_dd07v_tab
        EXCEPTIONS
          wrong_textflag = 1
          OTHERS         = 2.

      LOOP AT ti_dd07v_tab INTO DATA(linha).
        wa_187-status = linha-domvalue_l.
        wa_187-descr_status = linha-ddtext.
        APPEND wa_187 TO ti_status_operacao.
      ENDLOOP.

      CLEAR: ti_dd07v_tab[], lv_rc, linha.

      "Busca Descrição dos Motivos da deassociação
      CALL FUNCTION 'DD_DOMVALUES_GET'
        EXPORTING
          domname        = '/PTLOMS/DM006'
          text           = abap_true
        IMPORTING
          rc             = lv_rc
        TABLES
          dd07v_tab      = ti_dd07v_tab
        EXCEPTIONS
          wrong_textflag = 1
          OTHERS         = 2.

      LOOP AT ti_dd07v_tab INTO linha.
        wa_186-motivo = linha-domvalue_l.
        wa_186-descr_motivo = linha-ddtext.
        APPEND wa_186 TO ti_motivos_deassociacao.
      ENDLOOP.

      SORT: ti_status_operacao ASCENDING BY status,
            ti_motivos_deassociacao ASCENDING BY motivo.

      DELETE ADJACENT DUPLICATES FROM ti_status_operacao.
      DELETE ADJACENT DUPLICATES FROM ti_motivos_deassociacao.

      DATA: data TYPE char20.
      DATA: hora TYPE char20.

      LOOP AT ti_tb066 INTO wa_tb066.

        associacao-guid         = wa_tb066-guid.
        associacao-aufnr        = wa_tb066-aufnr.
        associacao-vornr        = wa_tb066-vornr.
        associacao-uname        = wa_tb066-uname.
        associacao-criadopor    = wa_tb066-criadopor.
        associacao-datacriacao  = wa_tb066-datacriacao.
        associacao-horacriacao  = wa_tb066-horacriacao.

        CONCATENATE wa_tb066-datacriacao+6(2) '/'
                    wa_tb066-datacriacao+4(2) '/'
                    wa_tb066-datacriacao(4)
                    INTO data.

        CONCATENATE wa_tb066-horacriacao(2) ':'
                    wa_tb066-horacriacao+2(2) ':'
                    wa_tb066-horacriacao+4(2)
                    INTO hora.

        CONCATENATE data hora INTO associacao-data_hora_cri SEPARATED BY space.

        associacao-alteradopor  = wa_tb066-alteradopor.
        associacao-datadessac   = wa_tb066-datadessac.
        associacao-horadessac   = wa_tb066-horadessac.

        CLEAR: data, hora.
        CONCATENATE wa_tb066-datadessac+6(2) '/'
                    wa_tb066-datadessac+4(2) '/'
                    wa_tb066-datadessac(4)
                    INTO data.

        CONCATENATE wa_tb066-horadessac(2) ':'
                    wa_tb066-horadessac+2(2) ':'
                    wa_tb066-horadessac+4(2)
                    INTO hora.

        CONCATENATE data hora INTO associacao-data_hora_desa SEPARATED BY space.

        associacao-motivo       = wa_tb066-motivo.
        associacao-status       = wa_tb066-status.

        CLEAR:wa_186, wa_187.
        READ TABLE ti_motivos_deassociacao INTO wa_186 WITH KEY motivo = wa_tb066-motivo BINARY SEARCH.
        IF sy-subrc = 0.
          associacao-descr_motivo = wa_186-descr_motivo.
        ENDIF.

        READ TABLE ti_status_operacao INTO wa_187 WITH KEY status = wa_tb066-status BINARY SEARCH.
        IF sy-subrc = 0.
          associacao-descr_status = wa_187-descr_status.
        ENDIF.

        wa_retorno-chave   = 'X'.
        wa_retorno-type    = 'S'.
        wa_retorno-message = 'Sucesso'.
        associacao-tiporetorno = 'S'.
        APPEND wa_retorno TO ti_retorno.
        APPEND LINES OF ti_retorno TO associacao-retorno.
        APPEND associacao TO associacoes.
        CLEAR: wa_retorno, associacao, ti_retorno[].

      ENDLOOP.

    ELSE.

      wa_retorno-chave   = 'X'.
      wa_retorno-type    = 'W'.
      wa_retorno-message = 'Nenhum dado encontrado na Tab. /PTLOMS/TB0066'.
      associacao-tiporetorno = 'W'.
      APPEND wa_retorno TO ti_retorno.
      APPEND LINES OF ti_retorno TO associacao-retorno.
      APPEND associacao TO associacoes.
      EXIT.

    ENDIF.

  ENDMETHOD.


  METHOD busca_historico_confirmacao.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 11/12/2025 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************

    DATA: ti_return        TYPE bapiret2,
          ti_orderrange    TYPE TABLE OF bapi_pp_orderrange,
          wa_orderrange    LIKE LINE OF ti_orderrange,
          ti_confirmations TYPE TABLE OF bapi_conf_key,
          wa_return_conf   TYPE bapiret2,
          wa_conf_detail   TYPE bapi_alm_confirmation.


*    LOOP AT histor_confirm_in INTO DATA(wa_hist_confir).

    DATA: wa_hist_confir  TYPE /ptloms/et181.
    LOOP AT histor_confirm_in INTO wa_hist_confir.

      wa_orderrange-sign = 'I'.
      wa_orderrange-option = 'EQ'.
      wa_orderrange-low = wa_hist_confir-orderid.
      APPEND wa_orderrange TO ti_orderrange.

    ENDLOOP.

    IF ti_orderrange IS NOT INITIAL.

      CALL FUNCTION 'BAPI_ALM_CONF_GETLIST'
        IMPORTING
          return        = ti_return
        TABLES
          order_range   = ti_orderrange
          confirmations = ti_confirmations
        EXCEPTIONS
          OTHERS        = 01.
      CASE sy-subrc.
        WHEN 0.            " OK
        WHEN OTHERS.       " to be implemented
      ENDCASE.


      DELETE ti_confirmations WHERE reversed IS NOT INITIAL.

      DELETE ti_confirmations WHERE rev_conf_cnt IS NOT INITIAL.

    ENDIF.

*    LOOP AT ti_confirmations INTO DATA(wa_confirmation).

    DATA: wa_confirmation TYPE bapi_conf_key,
          lv_usuario      TYPE uname.

    LOOP AT ti_confirmations INTO wa_confirmation.

      CALL FUNCTION 'BAPI_ALM_CONF_GETDETAIL'
        EXPORTING
          confirmation        = wa_confirmation-conf_no
          confirmationcounter = wa_confirmation-conf_cnt
        IMPORTING
          return              = wa_return_conf
          conf_detail         = wa_conf_detail.

      CLEAR wa_hist_confir.

      READ TABLE histor_confirm_in INTO wa_hist_confir WITH KEY orderid = wa_conf_detail-orderid.
      IF sy-subrc IS INITIAL.

        IF wa_hist_confir-usuario IS NOT INITIAL.

          DATA: wa_tb068 TYPE /ptloms/tb068,
                lv_aufnr TYPE /ptloms/tb068-aufnr,
                lv_vornr TYPE /ptloms/tb068-vornr,
                lv_rmzhl TYPE /ptloms/tb068-rmzhl,
                lv_rueck TYPE /ptloms/tb068-rueck.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = wa_confirmation-orderid
            IMPORTING
              output = lv_aufnr.

          CONDENSE lv_aufnr NO-GAPS.
*
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*            EXPORTING
*              input  = wa_confirmation-orderid
*            IMPORTING
*              output = lv_aufnr.

*          lv_vornr = wa_confirmation-operation.

*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*            EXPORTING
*              input  = wa_confirmation-conf_cnt
*            IMPORTING
*              output = lv_rmzhl.

*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*            EXPORTING
*              input  = wa_confirmation-conf_no
*            IMPORTING
*              output = lv_rueck.

          SELECT SINGLE *
            FROM /ptloms/tb068
            INTO wa_tb068
            WHERE aufnr   = lv_aufnr  AND
                  vornr   = wa_confirmation-operation AND
                  usuario = wa_hist_confir-usuario    AND
                  rmzhl   = wa_confirmation-conf_cnt  AND
                  rueck   = wa_confirmation-conf_no.

*          SELECT *
*            FROM /ptloms/tb013
*            INTO TABLE @DATA(ti_tb013)
*            WHERE usuario = @wa_hist_confir-usuario.

          DATA ti_tb013 TYPE TABLE OF /ptloms/tb013.
          SELECT *
            FROM /ptloms/tb013
            INTO TABLE ti_tb013
            WHERE usuario = wa_hist_confir-usuario.

          IF sy-subrc IS INITIAL.

*            SELECT *
*              FROM /ptloms/tb044
*              INTO TABLE @DATA(ti_tb044)
*              FOR ALL ENTRIES IN @ti_tb013
*              WHERE perfil = @ti_tb013-perfil AND
*                    configuracao = '16'.

            DATA ti_tb044 TYPE TABLE OF /ptloms/tb044.
            SELECT *
              FROM /ptloms/tb044
              INTO TABLE ti_tb044
              FOR ALL ENTRIES IN ti_tb013
              WHERE perfil = ti_tb013-perfil AND
                    configuracao = '16'.

            IF sy-subrc IS INITIAL.

              lv_usuario = wa_hist_confir-usuario.
              CLEAR: wa_hist_confir.
              MOVE-CORRESPONDING wa_conf_detail TO wa_hist_confir.
              wa_hist_confir-usuario = lv_usuario.

              IF wa_tb068 IS NOT INITIAL.
                wa_hist_confir-latitude = wa_tb068-latitude.
                wa_hist_confir-longitude = wa_tb068-longitude.
              ENDIF.

              APPEND wa_hist_confir TO histor_confirm_out.
              CLEAR: lv_usuario, wa_tb068.

            ELSE.

*              READ TABLE ti_tb013 INTO DATA(wa_tb013) INDEX 1.

              DATA: wa_tb013 TYPE /ptloms/tb013.
              READ TABLE ti_tb013 INTO wa_tb013 INDEX 1.

              IF wa_conf_detail-pers_no = wa_tb013-matricula.
                lv_usuario = wa_hist_confir-usuario.
                CLEAR: wa_hist_confir.
                MOVE-CORRESPONDING wa_conf_detail TO wa_hist_confir.
                wa_hist_confir-usuario = lv_usuario.

                IF wa_tb068 IS NOT INITIAL.
                  wa_hist_confir-latitude = wa_tb068-latitude.
                  wa_hist_confir-longitude = wa_tb068-longitude.
                ENDIF.

                APPEND wa_hist_confir TO histor_confirm_out.
                CLEAR: lv_usuario, wa_tb068.
              ENDIF.

            ENDIF.

          ENDIF.

        ELSE.
          CLEAR wa_hist_confir.
          MOVE-CORRESPONDING wa_conf_detail TO wa_hist_confir.
          APPEND wa_hist_confir TO histor_confirm_out.
        ENDIF.

      ENDIF.



    ENDLOOP.

*  LOOP AT histor_confirm_out ASSIGNING FIELD-SYMBOL(<fs_histor_confirm>).
*
*      CONCATENATE <fs_histor_confirm>-exec_fin_date+6(2) '/'
*                  <fs_histor_confirm>-exec_fin_date+4(2) '/'
*                  <fs_histor_confirm>-exec_fin_date(4)
*                  INTO DATA(data).
*
*      CONCATENATE <fs_histor_confirm>-exec_fin_time(2) ':'
*                  <fs_histor_confirm>-exec_fin_time+2(2) ':'
*                  <fs_histor_confirm>-exec_fin_time+4(2)
*                  INTO DATA(hora).
*
*      CONCATENATE data hora INTO <fs_histor_confirm>-data_hora_fim SEPARATED BY space.
*
*      CLEAR: data, hora.
*      CONCATENATE <fs_histor_confirm>-exec_start_date+6(2) '/'
*                  <fs_histor_confirm>-exec_start_date+4(2) '/'
*                  <fs_histor_confirm>-exec_start_date(4)
*                  INTO data.
*
*      CONCATENATE <fs_histor_confirm>-exec_start_time(2) ':'
*                  <fs_histor_confirm>-exec_start_time+2(2) ':'
*                  <fs_histor_confirm>-exec_start_time+4(2)
*                  INTO hora.
*
*      CONCATENATE data hora INTO <fs_histor_confirm>-data_hora_ini SEPARATED BY space.
*
*    ENDLOOP.

    DATA: lv_data TYPE char20,
          lv_hora TYPE char20.

    FIELD-SYMBOLS: <fs_histor_confirm> TYPE /ptloms/et181.

    LOOP AT histor_confirm_out ASSIGNING <fs_histor_confirm>.

      CLEAR: lv_data, lv_hora.
      CONCATENATE <fs_histor_confirm>-exec_fin_date+6(2) '/'
                  <fs_histor_confirm>-exec_fin_date+4(2) '/'
                  <fs_histor_confirm>-exec_fin_date(4)
                  INTO lv_data.

      CONCATENATE <fs_histor_confirm>-exec_fin_time(2) ':'
                  <fs_histor_confirm>-exec_fin_time+2(2) ':'
                  <fs_histor_confirm>-exec_fin_time+4(2)
                  INTO lv_hora.

      CONCATENATE lv_data lv_hora INTO <fs_histor_confirm>-data_hora_fim SEPARATED BY space.

      CLEAR: lv_data, lv_hora.
      CONCATENATE <fs_histor_confirm>-exec_start_date+6(2) '/'
                  <fs_histor_confirm>-exec_start_date+4(2) '/'
                  <fs_histor_confirm>-exec_start_date(4)
                  INTO lv_data.

      CONCATENATE <fs_histor_confirm>-exec_start_time(2) ':'
                  <fs_histor_confirm>-exec_start_time+2(2) ':'
                  <fs_histor_confirm>-exec_start_time+4(2)
                  INTO lv_hora.

      CONCATENATE lv_data lv_hora INTO <fs_histor_confirm>-data_hora_ini SEPARATED BY space.

    ENDLOOP.
*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
  ENDMETHOD.


  METHOD busca_lista_associacoes.

    DATA: ti_tb065   TYPE TABLE OF /ptloms/tb065,
          wa_tb065   TYPE /ptloms/tb065,
          associacao LIKE LINE OF associacoes,
          ti_retorno TYPE /ptloms/ct060,
          wa_retorno LIKE LINE OF ti_retorno,
          wa_aufnr   TYPE /iwbep/s_cod_select_option,
          wa_header  TYPE bapi_alm_order_header_e,
          ti_return  TYPE TABLE OF bapiret2,
          ti_oper    TYPE TABLE OF bapi_alm_order_operation_e,
          wa_oper    LIKE LINE OF ti_oper.

    DATA: lv_aufnr     TYPE aufnr,
          rt_aufnr_aux TYPE /iwbep/t_cod_select_options.



    FIELD-SYMBOLS: <fs_aufnr> LIKE LINE OF rt_aufnr.

    rt_aufnr_aux[] = rt_aufnr[].

    LOOP AT rt_aufnr_aux ASSIGNING <fs_aufnr>.

      CALL FUNCTION 'CONVERSION_EXIT_AUFNR_INPUT'
        EXPORTING
          input  = <fs_aufnr>-low
        IMPORTING
          output = lv_aufnr.

      <fs_aufnr>-low = lv_aufnr.

    ENDLOOP.

    SELECT *
    FROM /ptloms/tb065
    INTO TABLE ti_tb065
    WHERE aufnr IN rt_aufnr_aux AND
          uname IN rt_uname.

    IF sy-subrc IS INITIAL.

*      Retornando as que não foram encontradas:
      LOOP AT ti_tb065 INTO wa_tb065.

        CALL FUNCTION 'CONVERSION_EXIT_AUFNR_INPUT'
          EXPORTING
            input  = wa_tb065-aufnr
          IMPORTING
            output = wa_tb065-aufnr.

*       Verifica Ordens Encerradas
        CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
          EXPORTING
            number        = wa_tb065-aufnr
          IMPORTING
            es_header     = wa_header
          TABLES
            et_operations = ti_oper
            return        = ti_return.

        IF wa_header-sys_status CS 'ENTE' OR wa_header-sys_status CS 'CONF'.   " Ordem Encerrada

          " Eliminar TODAS as ocorrências da ordem da  /ptloms/tb065
          DELETE FROM /ptloms/tb065
            WHERE aufnr = wa_tb065-aufnr.

          " Atualizar a TB066 com o histórico
          UPDATE /ptloms/tb066
            SET alteradopor = sy-uname
                datadessac  = sy-datum
                horadessac  = sy-uzeit
                motivo      = '05'
                status      = 5
            WHERE aufnr = wa_tb065-aufnr.

          COMMIT WORK.

        ELSE.

          LOOP AT ti_oper INTO wa_oper.

            IF wa_oper-system_status_text CS 'CONF'.

              " Eliminar TODAS as ocorrências da ordem da  /ptloms/tb065
              DELETE FROM /ptloms/tb065
                WHERE aufnr = wa_tb065-aufnr
                  AND vornr = wa_oper-activity.

              " Atualizar a TB066 com o histórico
              UPDATE /ptloms/tb066
                SET alteradopor = sy-uname
                    datadessac  = sy-datum
                    horadessac  = sy-uzeit
                    motivo      = '05'
                    status      = 5
                WHERE aufnr = wa_tb065-aufnr
                  AND vornr = wa_oper-activity .

              COMMIT WORK.

            ENDIF.

          ENDLOOP.

        ENDIF.

        CLEAR: wa_header,
               ti_return.

      ENDLOOP.

    ENDIF.

    UNASSIGN <fs_aufnr>.

    SELECT *
      FROM /ptloms/tb065
      INTO TABLE ti_tb065
      WHERE aufnr IN rt_aufnr_aux AND
            uname IN rt_uname.

    IF sy-subrc IS INITIAL.

      LOOP AT ti_tb065 INTO wa_tb065.

        CALL FUNCTION 'CONVERSION_EXIT_AUFNR_OUTPUT'
          EXPORTING
            input  = wa_tb065-aufnr
          IMPORTING
            output = associacao-aufnr.

        associacao-vornr = wa_tb065-vornr.
        associacao-uname = wa_tb065-uname.
        associacao-guid  = wa_tb065-guid.
        APPEND associacao TO associacoes.

      ENDLOOP.

    ENDIF.


  ENDMETHOD.


  METHOD busca_lista_operacoes.

    TYPES:
      BEGIN OF ty_et140,
        werks       TYPE /ptloms/et140-werks,
        aufnr       TYPE /ptloms/et140-aufnr,
        vornr       TYPE /ptloms/et140-vornr,
        auart       TYPE /ptloms/et140-auart,
        qmnum       TYPE /ptloms/et140-qmnum,
        priok       TYPE /ptloms/et140-priok,
        tplnr       TYPE /ptloms/et140-tplnr,
        equnr       TYPE /ptloms/et140-equnr,
        iwerk       TYPE /ptloms/et140-iwerk,
        ernam       TYPE /ptloms/et140-usuario,
        ingpr       TYPE /ptloms/et140-ingpr,
        ilart       TYPE /ptloms/et140-ilart,
        gewrk       TYPE /ptloms/et140-gewrk,
        gstrp       TYPE d,
        gstri       TYPE d,
        gltrp       TYPE d,
        gltri       TYPE d,
        ktsch       TYPE /ptloms/et140-vlsch,
        kostl_equnr TYPE /ptloms/et140-kostl_equnr,
        kostl_funcl TYPE /ptloms/et140-kostl_funcl,
      END OF ty_et140.

* Declaração de range
    DATA:
      lt_et140                 TYPE TABLE OF ty_et140,
      ls_et140                 TYPE ty_et140,
      lt_centro_trabalho       TYPE TABLE OF /ptloms/tb005,
      ls_centro_trabalho       LIKE LINE OF lt_centro_trabalho,
      ls_despacho              LIKE LINE OF it_despacho,
      r_ordens_associadas_tot  TYPE RANGE OF aufnr,
      ls_ordens_associadas_tot LIKE LINE OF r_ordens_associadas_tot,
      lr_gewrk                 TYPE RANGE OF gewrk,
      lv_aufnr                 TYPE aufnr,
      lv_qmnum                 TYPE qmnum,
      lv_equnr                 TYPE equnr,
      lv_kostl                 TYPE kostl.

    DATA: ls_gewrk LIKE LINE OF lr_gewrk.

    IF rt_gewrk[] IS NOT INITIAL AND rt_werks[] IS NOT INITIAL.
      SELECT * FROM /ptloms/tb005
        INTO TABLE lt_centro_trabalho
        WHERE arbpl IN rt_gewrk[]
          AND werks IN rt_werks[].

      IF lt_centro_trabalho[] IS NOT INITIAL.

        LOOP AT lt_centro_trabalho INTO ls_centro_trabalho.

          ls_gewrk-sign = 'I'.
          ls_gewrk-option = 'EQ'.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_centro_trabalho-objid
            IMPORTING
              output = ls_gewrk-low.
*          ls_gewrk-low = ls_centro_trabalho-objid.
          APPEND ls_gewrk TO lr_gewrk.
          CLEAR ls_centro_trabalho.

        ENDLOOP.

      ENDIF.
    ENDIF.

    FIELD-SYMBOLS <fs_range> TYPE /iwbep/s_cod_select_option.

    LOOP AT rt_aufnr ASSIGNING <fs_range>.

      IF <fs_range>-low IS NOT INITIAL.

        CLEAR lv_aufnr.
        lv_aufnr = <fs_range>-low.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_aufnr
          IMPORTING
            output = lv_aufnr.
        <fs_range>-low = lv_aufnr.

      ENDIF.

      IF <fs_range>-high IS NOT INITIAL.

        CLEAR lv_aufnr.
        lv_aufnr = <fs_range>-high.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_aufnr
          IMPORTING
            output = lv_aufnr.
        <fs_range>-high = lv_aufnr.

      ENDIF.

    ENDLOOP.

    LOOP AT rt_qmnum ASSIGNING <fs_range>.

      IF <fs_range>-low IS NOT INITIAL.

        CLEAR lv_qmnum.
        lv_qmnum = <fs_range>-low.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_qmnum
          IMPORTING
            output = lv_qmnum.
        <fs_range>-low = lv_qmnum.

      ENDIF.

      IF <fs_range>-high IS NOT INITIAL.

        CLEAR lv_qmnum.
        lv_qmnum = <fs_range>-high.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_qmnum
          IMPORTING
            output = lv_qmnum.
        <fs_range>-high = lv_qmnum.

      ENDIF.

    ENDLOOP.

    LOOP AT rt_equnr ASSIGNING <fs_range>.

      IF <fs_range>-low IS NOT INITIAL.

        CLEAR lv_equnr.
        lv_equnr = <fs_range>-low.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_equnr
          IMPORTING
            output = lv_equnr.
        <fs_range>-low = lv_equnr.

      ENDIF.

      IF <fs_range>-high IS NOT INITIAL.

        CLEAR lv_equnr.
        lv_equnr = <fs_range>-high.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_equnr
          IMPORTING
            output = lv_equnr.
        <fs_range>-high = lv_equnr.

      ENDIF.

    ENDLOOP.

    LOOP AT rt_kostlequnr ASSIGNING <fs_range>.
      IF <fs_range>-low IS NOT INITIAL.
        CLEAR lv_kostl.
        lv_kostl       = <fs_range>-low.
        <fs_range>-low = |{ lv_kostl ALPHA = IN }|.
      ENDIF.

      IF <fs_range>-high IS NOT INITIAL.
        CLEAR lv_kostl.
        lv_kostl        = <fs_range>-high.
        <fs_range>-high = |{ lv_kostl ALPHA = IN }|.
      ENDIF.
    ENDLOOP.

    LOOP AT rt_kostlfuncl ASSIGNING <fs_range>.
      IF <fs_range>-low IS NOT INITIAL.
        CLEAR lv_kostl.
        lv_kostl       = <fs_range>-low.
        <fs_range>-low = |{ lv_kostl ALPHA = IN }|.
      ENDIF.

      IF <fs_range>-high IS NOT INITIAL.
        CLEAR lv_kostl.
        lv_kostl        = <fs_range>-high.
        <fs_range>-high = |{ lv_kostl ALPHA = IN }|.
      ENDIF.
    ENDLOOP.


    SELECT a~werks,
           a~aufnr,
           c~vornr,
           a~auart,
           a~qmnum,
           a~priok,
           a~tplnr,
           a~equnr,
           a~iwerk,
           a~ernam,
           a~ingpr,
           a~ilart,
           a~gewrk,
           a~gstrp,
           a~gstri,
           a~gltrp,
           a~gltri,
           c~ktsch,
           i~kostl AS kostl_equnr,
           l~kostl AS kostl_funcl
      FROM viaufks         AS a
     INNER JOIN afvc       AS c ON a~aufpl = c~aufpl
     INNER JOIN afvv       AS d ON c~aufpl = d~aufpl AND c~aplzl   = d~aplzl
      LEFT OUTER JOIN equz AS e ON e~equnr = a~equnr AND e~datbi = '99991231'
      LEFT OUTER JOIN iloa AS i ON i~iloan = e~iloan
      LEFT OUTER JOIN iflo AS l ON l~tplnr = a~tplnr
      INTO CORRESPONDING FIELDS OF TABLE @lt_et140
     WHERE a~aufnr IN @rt_aufnr
       AND c~vornr IN @rt_vornr
       AND a~auart IN @rt_auart
       AND a~auart IN @rt_auart
       AND a~priok IN @rt_priok
       AND a~qmnum IN @rt_qmnum
       AND a~tplnr IN @rt_tplnr
       AND a~equnr IN @rt_equnr
       AND a~iwerk IN @rt_iwerk
       AND a~ingpr IN @rt_ingpr
       AND a~ilart IN @rt_ilart
       AND a~gstrp IN @rt_datope_ini
       AND a~swerk IN @rt_werks  " Centro de manutenção obrigatório
       AND a~gewrk IN @lr_gewrk
       AND a~ernam IN @rt_usuapp
       AND c~ktsch IN @rt_vlsch
       AND c~phflg EQ @space

       AND i~kostl IN @rt_kostlequnr
       AND l~kostl IN @rt_kostlfuncl

       AND a~idat3 = '00000000' " Data de encerramento
       AND a~idat2 = '00000000' " Data de encerramento técnico
       AND a~loekz = ''         " Marcado para eliminação
       AND a~getri = '00000000' " Fim confirmado da ordem
       AND a~objnr NOT IN (
           " Excluir objetos com status BLOQ
           SELECT objnr FROM jest WHERE objnr LIKE 'OR%' AND stat EQ 'I0190' AND inact EQ @space
       ).

    IF lt_et140[] IS NOT INITIAL.

      LOOP AT lt_et140 INTO ls_et140.

        MOVE-CORRESPONDING ls_et140 TO ls_despacho.

        MOVE:
          ls_et140-ernam TO ls_despacho-usuario,
          ls_et140-gstrp TO ls_despacho-datopeini,
          ls_et140-gltrp TO ls_despacho-datopefim,
          ls_et140-ktsch TO ls_despacho-vlsch.

        APPEND ls_despacho TO it_despacho.

      ENDLOOP.

    ENDIF.

    UNASSIGN <fs_range>.

  ENDMETHOD.


  METHOD confirmar_operacoes.

    DATA: o_cl003 TYPE REF TO /ptloms/cl003,
          o_cl015 TYPE REF TO /ptloms/cl015.

    CREATE OBJECT o_cl003.
    CREATE OBJECT o_cl015.

    DATA: w_detalhe             LIKE LINE OF i_detalhe,
          w_detalhe_aux         LIKE LINE OF e_detalhe, "Inserido oir Iury Silva Confirmação final
          wa_detalhe            LIKE LINE OF e_detalhe,
          v_aufnr               TYPE aufnr,
          v_vornr               TYPE vornr,
          ls_header             TYPE bapi_alm_order_header_e,
          e_operations          TYPE bapi_alm_order_operation_e,
          lt_components         TYPE TABLE OF bapi_alm_order_component_e,
          lt_text_lines         TYPE TABLE OF bapi_alm_text_lines,
          ls_text_lines         LIKE LINE OF  lt_text_lines,
          lt_retorno            TYPE bapiret2_t,
          ls_retorno            TYPE bapiret2,
          lt_texts              TYPE STANDARD TABLE OF bapi_alm_text,
          ls_texts              LIKE LINE OF lt_texts,
          ti_detalhe            TYPE /ptloms/ct133,
          ti_detalhe_finconf    TYPE /ptloms/ct133,
          wa_confirmacao        TYPE /ptloms/et051,
          ls_texto_confirmacao  TYPE /ptloms/ct061,
          lt_return_confirmacao TYPE /ptloms/ct062,
          ls_return_confirmacao LIKE LINE OF lt_return_confirmacao,
          ls_tb066              TYPE /ptloms/tb066,
          lt_retorno_serv       TYPE TABLE OF /ptloms/et060,
          ls_retorno_serv       TYPE /ptloms/et060,
          lt_tb068              TYPE TABLE OF /ptloms/tb068,
          ls_tb068              TYPE /ptloms/tb068,
          lt_tb065              TYPE TABLE OF /ptloms/tb065,
          ls_tb065              TYPE /ptloms/tb065,
          linhas                TYPE i,
          v_retorno             TYPE bapi_mtype,
          v_data                TYPE char19,
          v_hora                TYPE char19,
          v_datlo               TYPE sy-datlo,
          v_timlo               TYPE sy-timlo,
          v_timestamp           TYPE tzonref-tstamps,
          v_guid                TYPE char75,
          diferenca             TYPE i,
          conf_cnt              TYPE co_rmzhl,
          conf_no               TYPE co_rueck,
          act_work              TYPE ismnw.

    DATA: v_desassociar TYPE c.

* Separando as que são de confirmação final e não
    LOOP AT i_detalhe INTO w_detalhe.
      IF w_detalhe-fin_conf EQ abap_true.
        APPEND w_detalhe TO ti_detalhe_finconf.
      ELSE.
        APPEND w_detalhe TO ti_detalhe.
      ENDIF.
    ENDLOOP.

* Para cada confirmação que não seja final
*   Ordenar a lista de confirmações por DataHoraInicio, DataHoraFim
    SORT ti_detalhe BY data_hora_inicio data_hora_fim.

    LOOP AT ti_detalhe INTO  w_detalhe.

*------------------------------------------------------------------*
*   1º Parte: Busca informações da ordem e prepara a Confirmação   *
*------------------------------------------------------------------*
      CALL METHOD o_cl015->prepara_confirmacao
        EXPORTING
          i_detalhe     = w_detalhe
        IMPORTING
          e_confirmacao = wa_confirmacao.

* Realiza a confirmação
      CLEAR lt_return_confirmacao[].
      o_cl003->in_confirmacao(
        EXPORTING
          im_confirmacao = wa_confirmacao
          it_texto       = ls_texto_confirmacao
        IMPORTING
          rt_return      = lt_return_confirmacao ).

      CLEAR: conf_no, conf_cnt.
      LOOP AT lt_return_confirmacao INTO ls_return_confirmacao.

        IF ls_return_confirmacao-conf_cnt IS NOT INITIAL.
          conf_no  = ls_return_confirmacao-conf_no.
          conf_cnt = ls_return_confirmacao-conf_cnt.
        ENDIF.

        MOVE-CORRESPONDING ls_return_confirmacao TO ls_retorno_serv.
        IF NOT ls_retorno_serv-message CS 'desassociada'.
          APPEND ls_retorno_serv TO lt_retorno_serv.
        ENDIF.
      ENDLOOP.

      CLEAR wa_detalhe.
      MOVE-CORRESPONDING w_detalhe TO wa_detalhe.
      wa_detalhe-retornoset[] = lt_retorno_serv[].

      READ TABLE lt_retorno_serv INTO ls_retorno_serv WITH KEY type = 'S'.
      IF sy-subrc IS INITIAL.
        wa_detalhe-tipo_retorno = 'S'.
      ELSE.
        wa_detalhe-tipo_retorno = 'E'.
      ENDIF.
      CLEAR lt_retorno_serv[].

      APPEND wa_detalhe TO e_detalhe.

*-----------------------------------------------------------------*
*   2º Parte: Atualiza tabelas de log                             *
*-----------------------------------------------------------------*
      IF wa_detalhe-tipo_retorno = 'S'.
*      Se a confirmação for bem-sucedida gravar em tabela o numero da
*      confirmação, ordem, operação, usuário, data e hora + GUID
*      Confirmação e Associação
        CLEAR: v_retorno, act_work.
        act_work = wa_confirmacao-act_work.

        CALL METHOD o_cl015->gravar_tabela_confirmacao
          EXPORTING
            aufnr            = w_detalhe-aufnr
            vornr            = w_detalhe-vornr
            guid_associacao  = w_detalhe-guid_associacao
            guid_confirmacao = w_detalhe-guid_confirmacao
            fin_conf         = w_detalhe-fin_conf
            uname            = w_detalhe-usuario
            latitude         = w_detalhe-latitude
            longitude        = w_detalhe-longitude
            n_confirmacao    = conf_no
            c_confirmacao    = conf_cnt
            d_confirmacao    = sy-datum
            t_confirmacao    = act_work
          IMPORTING
            retorno          = v_retorno.


*      Atualizar o registro correspondente na tabela de histórico (GUID)
*      /PTLOMS/TB066 STATUS = 7
        CLEAR v_retorno.
        CALL METHOD o_cl015->gravar_tabela_historico
          EXPORTING
            status  = 7
            usuario = w_detalhe-usuario
            guid    = w_detalhe-guid_associacao
*           motivo  = w_detalhe-dev_reason
          IMPORTING
            retorno = v_retorno.
      ENDIF.

    ENDLOOP.
*-----------------------------------------------------------------*
*   3º Parte: Processo para confirmação final                     *
*-----------------------------------------------------------------*
    CLEAR w_detalhe.
    LOOP AT ti_detalhe_finconf INTO w_detalhe.

* Busca informações da ordem e prepara a Confirmação
      CALL METHOD o_cl015->prepara_confirmacao
        EXPORTING
          i_detalhe     = w_detalhe
        IMPORTING
          e_confirmacao = wa_confirmacao.

      CLEAR: v_aufnr, v_vornr, v_guid, ls_tb065.

      v_guid = w_detalhe-guid_associacao.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = w_detalhe-aufnr
        IMPORTING
          output = v_aufnr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = w_detalhe-vornr
        IMPORTING
          output = v_vornr.

      SELECT SINGLE *
        FROM /ptloms/tb065
        INTO ls_tb065
        WHERE guid = v_guid.

      IF sy-subrc IS INITIAL.

*        IF w_detalhe-dev_reason IS INITIAL.
*          w_detalhe-dev_reason = '04'.
*        ENDIF.

*        CALL METHOD o_cl015->gravar_tabela_historico
*          EXPORTING
*            status  = 3
*            usuario = w_detalhe-usuario
*            guid    = w_detalhe-guid_associacao
*            motivo  = w_detalhe-dev_reason
*          IMPORTING
*            retorno = v_retorno.
*
*************************************************************************************************
*        DELETE /ptloms/tb065 FROM ls_tb065.
*************************************************************************************************

* Busca informações na tabela de histórico para ver se há mais operações
        SELECT *
          FROM /ptloms/tb065
          INTO TABLE lt_tb065
          WHERE aufnr = v_aufnr
            AND vornr = v_vornr
            AND guid <> v_guid.

*     Se for encontrado mais de um registro na tabela(CESTO).
        DESCRIBE TABLE lt_tb065 LINES linhas.
        IF linhas > 0.
*          Chamar o método /PTLOMS/CL003->in_confirmacao SEM PASSAR
*          A MARCAÇÃO DE CONFIRMAÇÃO FINAL.
          CLEAR: wa_confirmacao-fin_conf, wa_confirmacao-complete.
        ELSE.
          wa_confirmacao-complete = abap_true.
        ENDIF.

        CLEAR lt_return_confirmacao[].

        o_cl003->in_confirmacao(
          EXPORTING
            im_confirmacao = wa_confirmacao
            it_texto       = ls_texto_confirmacao
          IMPORTING
            rt_return      = lt_return_confirmacao ).

*       Verifica se não houve erro na confirmação e caso não, remove o registro da tb065(Desassocia a Ordem)
        READ TABLE lt_return_confirmacao TRANSPORTING NO FIELDS WITH KEY type = 'E'.

        IF sy-subrc <> 0.

*          IF w_detalhe-dev_reason IS INITIAL.
*            w_detalhe-dev_reason = '04'.
*          ENDIF.

          CALL METHOD o_cl015->gravar_tabela_historico
            EXPORTING
              status  = 3
              usuario = w_detalhe-usuario
              guid    = w_detalhe-guid_associacao
              motivo  = '04' "w_detalhe-dev_reason
            IMPORTING
              retorno = v_retorno.

          DELETE /ptloms/tb065 FROM ls_tb065.

        ENDIF.

************************************************************************************************

        CLEAR: conf_no, conf_cnt.
        LOOP AT lt_return_confirmacao INTO ls_return_confirmacao.

          IF ls_return_confirmacao-conf_cnt IS NOT INITIAL.
            conf_no  = ls_return_confirmacao-conf_no.
            conf_cnt = ls_return_confirmacao-conf_cnt.
          ENDIF.

          MOVE-CORRESPONDING ls_return_confirmacao TO ls_retorno_serv.
          IF NOT ls_retorno_serv-message CS 'desassociada'.
            APPEND ls_retorno_serv TO lt_retorno_serv.
          ENDIF.
        ENDLOOP.

*       Se a confirmação for bem-sucedida gravar em tabela o número
*        da confirmação, ordem, operação, usuário e o marcador
*        de confirmação final.
        CLEAR: wa_detalhe, ls_retorno_serv.
        MOVE-CORRESPONDING w_detalhe TO wa_detalhe.
        wa_detalhe-retornoset[] = lt_retorno_serv[].

        READ TABLE lt_retorno_serv INTO ls_retorno_serv WITH KEY type = 'S'.
        IF sy-subrc IS INITIAL.
          wa_detalhe-tipo_retorno = 'S'.
        ELSE.
          wa_detalhe-tipo_retorno = 'E'.
        ENDIF.

        CLEAR lt_retorno_serv[].

        APPEND wa_detalhe TO e_detalhe.

        IF wa_detalhe-tipo_retorno = 'S'.
          CLEAR: v_retorno, act_work.
          act_work = wa_confirmacao-act_work.
          CALL METHOD o_cl015->gravar_tabela_confirmacao
            EXPORTING
              aufnr            = w_detalhe-aufnr
              vornr            = w_detalhe-vornr
              guid_associacao  = w_detalhe-guid_associacao
              guid_confirmacao = w_detalhe-guid_confirmacao
              fin_conf         = w_detalhe-fin_conf
              uname            = w_detalhe-usuario
              latitude         = w_detalhe-latitude
              longitude        = w_detalhe-longitude
              n_confirmacao    = conf_no
              c_confirmacao    = conf_cnt
              d_confirmacao    = sy-datum
              t_confirmacao    = act_work
            IMPORTING
              retorno          = v_retorno.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  method CONVERTE_TIMESTAMP.
  endmethod.


  METHOD desassociar_operacao.

    DATA: w_detalhe             LIKE LINE OF i_detalhe,
          lt_detalhe            TYPE /ptloms/ct139,
          wa_detalhe            LIKE LINE OF e_detalhe,
          wa_confirmacao        TYPE /ptloms/et051,
          ls_texto_confirmacao  TYPE /ptloms/ct061,
          lt_tb065              TYPE TABLE OF /ptloms/tb065,
          ls_tb065              LIKE LINE OF lt_tb065,
          lt_tb068              TYPE TABLE OF /ptloms/tb068,
          ls_tb068              LIKE LINE OF lt_tb068,
          v_retorno             TYPE bapi_mtype,
          o_cl015               TYPE REF TO /ptloms/cl015,
          v_aufnr               TYPE aufnr,
          v_vornr               TYPE vornr,
          lt_return             TYPE STANDARD TABLE OF bapiret2,
          ls_return             TYPE bapiret2,
          lt_return_confirmacao TYPE /ptloms/ct062,
          ls_return_confirmacao LIKE LINE OF lt_return_confirmacao,
          lt_retorno_serv       TYPE TABLE OF /ptloms/et060,
          ls_retorno_serv       TYPE /ptloms/et060,
          o_cl003               TYPE REF TO /ptloms/cl003,
          ls_et160              TYPE /ptloms/et160,
          v_subrc               TYPE sy-subrc,
          lt_dd07v              TYPE TABLE OF dd07v,
          ls_dd07v              TYPE dd07v,
          ls_afru               TYPE afru,
          v_confirmation        TYPE  bapi_conf_key-conf_no,
          v_confirmationcounter TYPE  bapi_conf_key-conf_cnt,
          v_postgdate           TYPE  bapi_alm_confirmation-postg_date,
          ls_retorno            TYPE /ptloms/et060.


    CREATE OBJECT o_cl015.
    CREATE OBJECT o_cl003.

    LOOP AT i_detalhe INTO w_detalhe.

      SELECT *
       FROM /ptloms/tb065
       INTO TABLE lt_tb065
       WHERE guid = w_detalhe-guid.

      IF sy-subrc IS INITIAL.

        LOOP AT lt_tb065 INTO ls_tb065.

          DELETE /ptloms/tb065 FROM ls_tb065.

          CALL METHOD o_cl015->gravar_tabela_historico
            EXPORTING
              status  = 5
              usuario = w_detalhe-responsavel_desassociacao
              guid    = w_detalhe-guid
              motivo  = w_detalhe-codigo_motivo_desassociacao
            IMPORTING
              retorno = v_retorno.

          CLEAR wa_detalhe.
          MOVE-CORRESPONDING w_detalhe TO wa_detalhe.
          wa_detalhe-tipo_retorno = 'S'.
          CONCATENATE 'Ordem' w_detalhe-aufnr 'operação' w_detalhe-vornr
                      'desassociada com sucesso para usuário' w_detalhe-uname
                      INTO wa_detalhe-retorno SEPARATED BY space.

          CLEAR: ls_retorno_serv, lt_retorno_serv[].
          ls_retorno_serv-type = 'S'.
          ls_retorno_serv-message = wa_detalhe-retorno.
          APPEND ls_retorno_serv TO lt_retorno_serv.
          wa_detalhe-retornoset[] = lt_retorno_serv[].

          CALL FUNCTION '/PTLOMS/MF036'
            EXPORTING
              im_aufnr       = ls_tb065-aufnr
              im_vornr       = ls_tb065-vornr
              im_usuario     = w_detalhe-responsavel_desassociacao
              im_desassociar = 'X'
            TABLES
              it_return      = lt_return.

          CLEAR: ls_retorno_serv.
          LOOP AT lt_return INTO ls_return.
            MOVE-CORRESPONDING ls_return TO ls_retorno_serv.
            APPEND ls_retorno_serv TO wa_detalhe-retornoset.
          ENDLOOP.

*          APPEND wa_detalhe TO e_detalhe.

        ENDLOOP.

        CLEAR lt_tb065.
        SELECT *
          FROM /ptloms/tb065
          INTO TABLE lt_tb065
          WHERE aufnr = w_detalhe-aufnr AND
                vornr = w_detalhe-vornr.

        IF sy-subrc IS NOT INITIAL.

          CLEAR: v_aufnr, v_vornr.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = w_detalhe-aufnr
            IMPORTING
              output = v_aufnr.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = w_detalhe-vornr
            IMPORTING
              output = v_vornr.

          CLEAR lt_tb068.
          SELECT *
            FROM /ptloms/tb068
            INTO TABLE lt_tb068
            WHERE aufnr = v_aufnr AND
                  vornr = v_vornr AND
*                  vornr = w_detalhe-vornr AND
                  fin_conf = abap_true.

          IF sy-subrc IS INITIAL.

            LOOP AT lt_tb068 INTO ls_tb068.

              SELECT SINGLE *
              FROM afru
              INTO ls_afru
              WHERE aufnr = v_aufnr AND
                    vornr = w_detalhe-vornr AND
                    rueck = ls_tb068-rueck AND
                    rmzhl = ls_tb068-rmzhl AND
                    ersda = ls_tb068-ersda.

              IF sy-subrc IS INITIAL.

                v_postgdate           = ls_afru-ersda.
                v_confirmationcounter = ls_afru-rmzhl.
                v_confirmation        = ls_afru-rueck.

                CALL FUNCTION 'BAPI_ALM_CONF_CANCEL'
                  EXPORTING
                    confirmation        = v_confirmation
                    confirmationcounter = v_confirmationcounter
                    postgdate           = v_postgdate
                    conftext            = 'Estorno converter conf parcial em final'
                  IMPORTING
                    return              = ls_return.

                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

                MOVE-CORRESPONDING ls_return TO ls_retorno.
                APPEND ls_retorno TO wa_detalhe-retornoset.
                CLEAR ls_return.

              ENDIF.

              ls_et160-chave            = w_detalhe-chave.
              ls_et160-guid_confirmacao = ls_tb068-guid_confirmacao.
              ls_et160-guid_associacao  = ls_tb068-guid_associacao.
              ls_et160-aufnr            = ls_tb068-aufnr.
              ls_et160-vornr            = ls_tb068-vornr.
              ls_et160-usuario          = ls_tb068-usuario.
              ls_et160-fin_conf         = abap_true.
              CONCATENATE 'Confirmação final gerada automaticamente após desassociação da operação pelo usuário'
                          w_detalhe-responsavel_desassociacao INTO ls_et160-texto_longo SEPARATED BY space.
*              ls_et160-conf_text        = 'Confirmação final via desassociação'.
              ls_et160-conf_text        = ls_afru-ltxa1.

              CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP ls_et160-data_hora_inicio TIME ZONE sy-zonlo.
              CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP ls_et160-data_hora_fim TIME ZONE sy-zonlo.
*            ls_et160-data_hora_inicio = sy-datum.
*            ls_et160-data_hora_fim    = sy-uzeit.

              CALL METHOD o_cl015->prepara_confirmacao
                EXPORTING
                  i_detalhe     = ls_et160
                IMPORTING
                  e_confirmacao = wa_confirmacao.

              CLEAR lt_return_confirmacao[].
              o_cl003->in_confirmacao(
                EXPORTING
                  im_confirmacao = wa_confirmacao
                  it_texto       = ls_texto_confirmacao
                IMPORTING
                  rt_return      = lt_return_confirmacao ).

              LOOP AT lt_return_confirmacao INTO ls_return_confirmacao.
                MOVE-CORRESPONDING ls_return_confirmacao TO ls_retorno_serv.
                IF NOT ls_retorno_serv-message CS 'desassociada'.
                  APPEND ls_retorno_serv TO wa_detalhe-retornoset[].
                ENDIF.
              ENDLOOP.

              READ TABLE lt_retorno_serv INTO ls_retorno_serv WITH KEY type = 'S'.
              IF sy-subrc IS INITIAL.
                wa_detalhe-tipo_retorno = 'S'.
              ELSE.
                wa_detalhe-tipo_retorno = 'E'.
              ENDIF.
              CLEAR lt_retorno_serv[].

*              APPEND wa_detalhe TO e_detalhe.

            ENDLOOP.

          ENDIF.

        ENDIF.

      ELSE.
        CLEAR wa_detalhe.
        MOVE-CORRESPONDING w_detalhe TO wa_detalhe.
        wa_detalhe-tipo_retorno = 'E'.
        CONCATENATE 'Ordem' w_detalhe-aufnr 'operação' w_detalhe-vornr
                    'não está associada a usuário' w_detalhe-uname
                    INTO wa_detalhe-retorno SEPARATED BY space.

        CLEAR: ls_retorno_serv, lt_retorno_serv[].
        ls_retorno_serv-type = 'E'.
        ls_retorno_serv-message = wa_detalhe-retorno.
        APPEND ls_retorno_serv TO lt_retorno_serv.
        wa_detalhe-retornoset[] = lt_retorno_serv[].

*        APPEND wa_detalhe TO e_detalhe.
      ENDIF.

      APPEND wa_detalhe TO e_detalhe.

    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM i_detalhe COMPARING chave guid aufnr vornr.
    LOOP AT i_detalhe INTO w_detalhe.
*------------------------------------------------------------*
*               Atualizar capacidade técnica
*------------------------------------------------------------*
      CLEAR: lt_return, ls_return.
      CALL FUNCTION '/PTLOMS/MF132'
        EXPORTING
          im_aufnr  = ls_tb065-aufnr
          im_vornr  = ls_tb065-vornr
        TABLES
          it_return = lt_return.

      CLEAR ls_retorno.
      LOOP AT lt_return INTO ls_return.
        MOVE-CORRESPONDING ls_return TO ls_retorno_serv.
        APPEND ls_retorno_serv TO wa_detalhe-retornoset.
      ENDLOOP.
*------------------------------------------------------------*
    ENDLOOP.

  ENDMETHOD.


  method ESTORNAR_CONFIRMACAO.
  endmethod.


  method GET_USER.
  endmethod.


  METHOD gravar_tabela_confirmacao.

    DATA: ls_tb068 TYPE /ptloms/tb068.

    CLEAR ls_tb068.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = aufnr
      IMPORTING
        output = ls_tb068-aufnr.

    CONDENSE ls_tb068-aufnr NO-GAPS.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = vornr
      IMPORTING
        output = ls_tb068-vornr.

    CONDENSE ls_tb068-vornr NO-GAPS.

*    ls_tb068-aufnr            = aufnr.
*    ls_tb068-vornr            = vornr.

    ls_tb068-usuario          = uname.
    ls_tb068-guid_associacao  = guid_associacao.
    ls_tb068-guid_confirmacao = guid_confirmacao.
    ls_tb068-data             = sy-datum.
    ls_tb068-hora             = sy-uzeit.
    ls_tb068-fin_conf         = fin_conf.
    ls_tb068-rueck            = n_confirmacao.
    ls_tb068-rmzhl            = c_confirmacao.
    ls_tb068-ersda            = d_confirmacao.
    ls_tb068-latitude         = latitude.
    ls_tb068-longitude        = longitude.

*    IF t_confirmacao IS INITIAL.
*      SELECT SINGLE ismnw
*        INTO ls_tb068-act_work
*        FROM afru
*        WHERE rueck  = n_confirmacao AND
*              rmzhl  = c_confirmacao AND
*              ersda  = d_confirmacao.
*    ELSE.
*      ls_tb068-act_work       = t_confirmacao.
*    ENDIF.

    MODIFY /ptloms/tb068 FROM ls_tb068.
    COMMIT WORK.


  ENDMETHOD.


  METHOD gravar_tabela_historico.

*      Atualizar o registro correspondente na tabela de histórico (GUID)
*      /PTLOMS/TB066 STATUS = 7 ou STATUS = 3
    DATA: ls_tb066 TYPE /ptloms/tb066,
          v_motivo TYPE numc2.

    SELECT SINGLE *
    FROM /ptloms/tb066
    INTO ls_tb066
    WHERE guid = guid.

    v_motivo = motivo.

    IF v_motivo <> '00'.
      ls_tb066-datadessac          = sy-datum.
      ls_tb066-horadessac          = sy-uzeit.
    ENDIF.
*      ls_tb066-datadessac          = sy-datum.
*      ls_tb066-horadessac          = sy-uzeit.

    ls_tb066-alteradopor         = usuario.
    ls_tb066-status              = status.
    ls_tb066-motivo              = v_motivo.
    MODIFY /ptloms/tb066 FROM ls_tb066.
    COMMIT WORK.

  ENDMETHOD.


  METHOD prepara_confirmacao.

    DATA: v_data        TYPE char19,
          v_hora        TYPE char19,
          v_datlo       TYPE sy-datlo,
          v_timlo       TYPE sy-timlo,
          v_timestamp   TYPE tzonref-tstamps,
          v_guid        TYPE char75,
          v_aufnr       TYPE aufnr,
          v_vornr       TYPE vornr,
          diferenca     TYPE i,
          v_duration    TYPE f,
          v_un_work(7)  TYPE p DECIMALS 1,
          v_act_work    TYPE /ptloms/et051-act_work,
          e_operations  TYPE bapi_alm_order_operation_e,
          lt_text_lines TYPE TABLE OF bapi_alm_text_lines,
          ls_text_lines LIKE LINE OF  lt_text_lines,
          lt_retorno    TYPE bapiret2_t,
          ls_retorno    TYPE bapiret2,
          lt_texts      TYPE STANDARD TABLE OF bapi_alm_text,
          ls_texts      LIKE LINE OF lt_texts.

    DATA: lv_iso_string  TYPE string, "VALUE '2026-04-29T18:11:51.875Z',
          lv_date_tmp    TYPE char10,
          lv_time_tmp    TYPE char8,
          lv_date        TYPE sy-datum,
          lv_time        TYPE sy-uzeit,
          lv_data_inicio TYPE sy-datum,
          lv_hora_inicio TYPE sy-uzeit,
          lv_data_fim    TYPE sy-datum,
          lv_hora_fim    TYPE sy-uzeit.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_detalhe-aufnr
      IMPORTING
        output = v_aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_detalhe-vornr
      IMPORTING
        output = v_vornr.

*------------------------------------------------------------------*
*   1º Parte: Busca informações da ordem e realiza a Confirmação   *
*------------------------------------------------------------------*
*     Para cada confirmação recebida chamar BAPI_ALM_OPERATION_GET_DETAIL
*     para recuperar informações necessárias para criar a confirmação.
    CALL FUNCTION 'BAPI_ALM_OPERATION_GET_DETAIL'
      EXPORTING
        iv_orderid    = v_aufnr
        iv_activity   = v_vornr
      IMPORTING
        es_operation  = e_operations
      TABLES
        return        = lt_retorno
        et_text       = lt_texts
        et_text_lines = lt_text_lines.

    e_confirmacao-chave            = i_detalhe-chave.
    e_confirmacao-guid             = i_detalhe-guid_confirmacao.
    e_confirmacao-orderid          = v_aufnr.
    e_confirmacao-activity         = v_vornr.
    e_confirmacao-usuario_app      = i_detalhe-usuario.
    e_confirmacao-fin_conf         = i_detalhe-fin_conf.
    e_confirmacao-dev_reason       = i_detalhe-dev_reason.
    e_confirmacao-conf_text        = i_detalhe-conf_text.
    e_confirmacao-texto_longo      = i_detalhe-texto_longo.
    e_confirmacao-data_hora_inicio = i_detalhe-data_hora_inicio.
    e_confirmacao-data_hora_fim    = i_detalhe-data_hora_fim.


    MOVE-CORRESPONDING e_operations TO e_confirmacao.

    CLEAR diferenca.

*    diferenca = cl_abap_tstmp=>compare( tstmp1 = i_detalhe-data_hora_fim
*                                        tstmp2 = i_detalhe-data_hora_inicio ).
*    IF e_operations-un_work = 'H'.
*      e_confirmacao-act_work  = diferenca / 3600.
*    ELSE.
*      e_confirmacao-act_work  = diferenca / 60.
*    ENDIF.


    e_confirmacao-datahorainiciodt = i_detalhe-data_hora_inicio.
    e_confirmacao-datahorafimdt    = i_detalhe-data_hora_fim.
    e_confirmacao-pers_no          = e_operations-pers_no.


    v_timestamp = i_detalhe-data_hora_inicio.
    CLEAR: v_datlo, v_timlo, v_data, v_hora, lv_data_inicio, lv_hora_inicio, lv_hora_fim.
    CALL FUNCTION 'IB_CONVERT_FROM_TIMESTAMP'
      EXPORTING
        i_timestamp = i_detalhe-data_hora_inicio
        i_tzone     = 'BRAZIL'
      IMPORTING
        e_datlo     = v_datlo
        e_timlo     = v_timlo.

    CONCATENATE v_datlo+6(2) '/'
                v_datlo+4(2) '/'
                v_datlo(4) INTO v_data.

    CONCATENATE v_timlo(2) ':'
                v_timlo+2(2) ':'
                v_timlo+4(2) INTO v_hora.

    CONCATENATE v_data v_hora INTO
                e_confirmacao-data_hora_inicio SEPARATED BY space.

    lv_data_inicio = v_datlo.
    lv_hora_inicio = v_timlo.


    CLEAR: v_datlo, v_timlo, v_data, v_hora, lv_data_fim, lv_hora_fim.
    v_timestamp = i_detalhe-data_hora_fim.
    CALL FUNCTION 'IB_CONVERT_FROM_TIMESTAMP'
      EXPORTING
        i_timestamp = i_detalhe-data_hora_fim
        i_tzone     = 'BRAZIL'
      IMPORTING
        e_datlo     = v_datlo
        e_timlo     = v_timlo.

    CONCATENATE v_datlo+6(2) '/'
                v_datlo+4(2) '/'
                v_datlo(4) INTO v_data.

    CONCATENATE v_timlo(2) ':'
                v_timlo+2(2) ':'
                v_timlo+4(2) INTO v_hora.

    CONCATENATE v_data v_hora INTO
                e_confirmacao-data_hora_fim SEPARATED BY space.

    lv_data_fim = v_datlo.
    lv_hora_fim = v_timlo.

    "Preenche Trabalho Real
    IF i_detalhe-data_hora_inicio IS NOT INITIAL AND i_detalhe-data_hora_fim IS NOT INITIAL.

      CLEAR: v_duration, v_un_work.
      CALL FUNCTION 'COPF_DETERMINE_DURATION'
        EXPORTING
          i_start_date       = lv_data_inicio
          i_start_time       = lv_hora_inicio
          i_end_date         = lv_data_fim
          i_end_time         = lv_hora_fim
          i_unit_of_duration = e_operations-un_work
        IMPORTING
          e_duration         = v_duration
        EXCEPTIONS
          exception_raised   = 1
          OTHERS             = 2.

      IF sy-subrc EQ 0.

        v_un_work = v_duration.
*        IF e_operations-un_work = 'H'.
*          e_confirmacao-act_work  = v_un_work / 3600.
*        ELSE.
*          e_confirmacao-act_work  = v_un_work * 60.
*        ENDIF.
        CASE e_operations-un_work.

          WHEN 'H'.
            e_confirmacao-act_work = v_un_work.
          WHEN 'MIN'.
            e_confirmacao-act_work = v_un_work / 60.

        ENDCASE.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD recusar_operacao.

    DATA: w_detalhe             LIKE LINE OF i_detalhe,
          ti_detalhe            TYPE /ptloms/ct144,
          lt_tb065              TYPE TABLE OF /ptloms/tb065,
          ls_tb065              TYPE /ptloms/tb065,
          wa_detalhe            LIKE LINE OF e_detalhe,
          lt_retorno            TYPE TABLE OF /ptloms/et060,
          ls_retorno            TYPE /ptloms/et060,
          o_cl015               TYPE REF TO /ptloms/cl015,
          o_cl003               TYPE REF TO /ptloms/cl003,
          v_retorno             TYPE bapi_mtype,
          lt_return             TYPE STANDARD TABLE OF bapiret2,
          ls_return             TYPE bapiret2,
          v_aufnr               TYPE aufnr,
          v_vornr               TYPE vornr,
          lt_tb068              TYPE TABLE OF /ptloms/tb068,
          ls_tb068              LIKE LINE OF lt_tb068,
          ls_et160              TYPE /ptloms/et160,
          wa_confirmacao        TYPE /ptloms/et051,
          lt_return_confirmacao TYPE /ptloms/ct062,
          ls_return_confirmacao LIKE LINE OF lt_return_confirmacao,
          ls_texto_confirmacao  TYPE /ptloms/ct061,
          lt_afru               TYPE TABLE OF afru,
          ls_afru               TYPE afru,
          v_confirmation        TYPE  bapi_conf_key-conf_no,
          v_confirmationcounter TYPE  bapi_conf_key-conf_cnt,
          v_postgdate           TYPE  bapi_alm_confirmation-postg_date.

    CREATE OBJECT o_cl015.
    CREATE OBJECT o_cl003.

    ti_detalhe[] = i_detalhe[].

    DATA: lt_confirmacao TYPE TABLE OF /ptloms/et160.
    DATA: ls_confirmacao LIKE LINE OF lt_confirmacao.
    DATA: lt_confoper    TYPE /ptloms/ct135.
    DATA: ls_confoper    LIKE LINE OF lt_confoper.

    LOOP AT i_detalhe INTO w_detalhe.

      MOVE-CORRESPONDING w_detalhe TO ls_confirmacao.
      ls_confirmacao-guid_associacao = w_detalhe-guid.
      APPEND ls_confirmacao TO lt_confirmacao.

    ENDLOOP.


    CALL METHOD o_cl015->confirmar_operacoes
      EXPORTING
        i_detalhe = lt_confirmacao
      IMPORTING
        e_detalhe = lt_confoper.


    LOOP AT ti_detalhe INTO w_detalhe.

      READ TABLE lt_confoper INTO ls_confoper
        WITH KEY guid_associacao = w_detalhe-guid
                 tipo_retorno      = 'S'.

      IF sy-subrc IS INITIAL.
        SELECT SINGLE *
         FROM /ptloms/tb065
         INTO ls_tb065
         WHERE guid = w_detalhe-guid.

        IF sy-subrc IS INITIAL.

*       Para cada associação encontrada
*       Remover da tabela /PTLOMS/TB065
          DELETE /ptloms/tb065 FROM ls_tb065.

*       Atualizar tabela /PTLOMS/TB066 pesquisando pelo campo guid.
*       MOTIVO = 03 e Status = 05
          CALL METHOD o_cl015->gravar_tabela_historico
            EXPORTING
              status  = 4
              usuario = sy-uname
              guid    = w_detalhe-guid
              motivo  = '03'
            IMPORTING
              retorno = v_retorno.

          CLEAR wa_detalhe.
          MOVE-CORRESPONDING w_detalhe TO wa_detalhe.
          wa_detalhe-tipo_retorno = 'S'.
          CONCATENATE 'Ordem' ls_tb065-aufnr 'operação' ls_tb065-vornr
                      'recusada com sucesso para usuário' ls_tb065-uname
                      INTO wa_detalhe-retorno SEPARATED BY space.

*       Remover matrícula da operação da ordem
*       Chamar função /PTLOMS/MF036
          CALL FUNCTION '/PTLOMS/MF036'
            EXPORTING
              im_aufnr       = ls_tb065-aufnr
              im_vornr       = ls_tb065-vornr
              im_usuario     = ls_tb065-uname
              im_desassociar = 'X'
            TABLES
              it_return      = lt_return.

          CLEAR: ls_retorno.
          LOOP AT lt_return INTO ls_return.
            MOVE-CORRESPONDING ls_return TO ls_retorno.
            APPEND ls_retorno TO wa_detalhe-retornoset.
          ENDLOOP.

          CLEAR: v_aufnr, v_vornr.
          v_aufnr  = ls_tb065-aufnr.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_tb065-vornr
            IMPORTING
              output = v_vornr.

*       Pesquisar na tabela de associações /PTLOMS/TB065 se ainda
*       tem alguma associação para Ordem/Operação.
          CLEAR: lt_tb065.
          SELECT *
            FROM /ptloms/tb065
            INTO TABLE lt_tb065
            WHERE aufnr = v_aufnr AND
                  vornr = v_vornr.

          IF sy-subrc IS INITIAL.

**         Se encontrar chamar a função para Confirmação Final
*          ls_et160-chave            = w_detalhe-chave.
*          ls_et160-guid_confirmacao = ls_tb065-guid.
**            ls_et160-guid_associacao  = ls_tb065-guid_associacao.
*          ls_et160-aufnr            = ls_tb065-aufnr.
*          ls_et160-vornr            = ls_tb065-vornr.
*          ls_et160-usuario          = ls_tb065-uname.
*          ls_et160-fin_conf         = abap_false.
*          CONCATENATE 'Confirmação final gerada automaticamente após recusa da operação pelo usuário'
*                       ls_tb065-uname INTO ls_et160-texto_longo SEPARATED BY space.
*          ls_et160-conf_text        = 'Confirmação final via recusa'.
*
*          CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP ls_et160-data_hora_inicio TIME ZONE sy-zonlo.
*          CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP ls_et160-data_hora_fim TIME ZONE sy-zonlo.
**            ls_et160-data_hora_inicio = sy-datum.
**            ls_et160-data_hora_fim    = sy-uzeit.
*
*          CALL METHOD o_cl015->prepara_confirmacao
*            EXPORTING
*              i_detalhe     = ls_et160
*            IMPORTING
*              e_confirmacao = wa_confirmacao.
*
*          CLEAR lt_return_confirmacao[].
*          o_cl003->in_confirmacao(
*            EXPORTING
*              im_confirmacao = wa_confirmacao
*              it_texto       = ls_texto_confirmacao
*            IMPORTING
*              rt_return      = lt_return_confirmacao ).
*
*
*          LOOP AT lt_return_confirmacao INTO ls_return_confirmacao.
*            MOVE-CORRESPONDING ls_return_confirmacao TO ls_retorno.
*            IF NOT ls_retorno-message CS 'desassociada'.
*              APPEND ls_retorno TO wa_detalhe-retornoset[].
*            ENDIF.
*          ENDLOOP.
*
*          READ TABLE lt_retorno INTO ls_retorno WITH KEY type = 'S'.
*          IF sy-subrc IS INITIAL.
*            wa_detalhe-tipo_retorno = 'S'.
*          ELSE.
*            wa_detalhe-tipo_retorno = 'E'.
*          ENDIF.
*          CLEAR lt_retorno[].
*

*          ENDLOOP.

          ELSE.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = v_aufnr
              IMPORTING
                output = v_aufnr.

*         Se não encontrar verifica na tabela de confirmações se
*         há alguma confirmação final para a ordem/operação.
            CLEAR ls_tb068.
            SELECT SINGLE *
              FROM /ptloms/tb068
              INTO ls_tb068
              WHERE aufnr = v_aufnr AND
                    vornr = v_vornr AND
                    fin_conf = abap_true.

            IF sy-subrc IS INITIAL.

*            Antes de criar um novo apontamento com a confirmação final,
*            deve estornar a confirmação parcial para não gerar lançamento em duplicidade.
              SELECT SINGLE *
                FROM afru
                INTO ls_afru
                WHERE aufnr = v_aufnr AND
                      vornr = v_vornr AND
                      rueck = ls_tb068-rueck AND
                      rmzhl = ls_tb068-rmzhl AND
                      ersda = ls_tb068-ersda.

              IF sy-subrc IS INITIAL.

                v_postgdate           = ls_afru-ersda.
                v_confirmationcounter = ls_afru-rmzhl.
                v_confirmation        = ls_afru-rueck.

                CALL FUNCTION 'BAPI_ALM_CONF_CANCEL'
                  EXPORTING
                    confirmation        = v_confirmation
                    confirmationcounter = v_confirmationcounter
                    postgdate           = v_postgdate
                    conftext            = 'Estorno converter conf parcial em final'
                  IMPORTING
                    return              = ls_return.

                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

                MOVE-CORRESPONDING ls_return TO ls_retorno.
                APPEND ls_retorno TO wa_detalhe-retornoset.
                CLEAR ls_return.

              ENDIF.

              ls_et160-chave            = w_detalhe-chave.
              ls_et160-guid_confirmacao = ls_tb068-guid_confirmacao.
              ls_et160-guid_associacao  = ls_tb068-guid_associacao.
              ls_et160-aufnr            = ls_tb068-aufnr.
              ls_et160-vornr            = ls_tb068-vornr.
              ls_et160-usuario          = ls_tb068-usuario.
              ls_et160-fin_conf         = abap_true.

              CONCATENATE 'Confirmação final gerada automaticamente após recusa da operação pelo usuário'
                          ls_tb068-usuario INTO ls_et160-texto_longo SEPARATED BY space.
              ls_et160-conf_text        = ls_afru-ltxa1.

              CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP ls_et160-data_hora_inicio TIME ZONE sy-zonlo.
              CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP ls_et160-data_hora_fim TIME ZONE sy-zonlo.
*            ls_et160-data_hora_inicio = sy-datum.
*            ls_et160-data_hora_fim    = sy-uzeit.

              CALL METHOD o_cl015->prepara_confirmacao
                EXPORTING
                  i_detalhe     = ls_et160
                IMPORTING
                  e_confirmacao = wa_confirmacao.

*            wa_confirmacao-act_work = ls_tb068-act_work.
              CLEAR lt_return_confirmacao[].
              o_cl003->in_confirmacao(
                EXPORTING
                  im_confirmacao = wa_confirmacao
                  it_texto       = ls_texto_confirmacao
                IMPORTING
                  rt_return      = lt_return_confirmacao ).


              LOOP AT lt_return_confirmacao INTO ls_return_confirmacao.
                MOVE-CORRESPONDING ls_return_confirmacao TO ls_retorno.
                IF NOT ls_retorno-message CS 'desassociada'.
                  APPEND ls_retorno TO wa_detalhe-retornoset[].
                ENDIF.
              ENDLOOP.

              READ TABLE lt_retorno INTO ls_retorno WITH KEY type = 'S'.
              IF sy-subrc IS INITIAL.
                wa_detalhe-tipo_retorno = 'S'.
              ELSE.
                wa_detalhe-tipo_retorno = 'E'.
              ENDIF.
              CLEAR lt_retorno[].


            ENDIF.

          ENDIF.

        ELSE.
          MOVE-CORRESPONDING w_detalhe TO wa_detalhe.
          wa_detalhe-tipo_retorno = 'E'.
          wa_detalhe-retorno = 'Ordem não está associada a usuário'.

          CLEAR: ls_retorno, lt_retorno[].
          ls_retorno-type = 'E'.
          ls_retorno-type_desc = 'Error' .
          ls_retorno-message = wa_detalhe-retorno.
          APPEND ls_retorno TO lt_retorno.
          wa_detalhe-retornoset[] = lt_retorno[].
        ENDIF.
      ELSE.
        MOVE-CORRESPONDING w_detalhe TO wa_detalhe.
        wa_detalhe-tipo_retorno = 'E'.
        wa_detalhe-retorno = 'Confirmação não criada para a recusa'.

        CLEAR: ls_retorno, lt_retorno[].
        ls_retorno-type = 'E'.
        ls_retorno-type_desc = 'Error' .
        ls_retorno-message = wa_detalhe-retorno.
        APPEND ls_retorno TO lt_retorno.

        READ TABLE lt_confoper INTO ls_confoper
          WITH KEY guid_associacao = w_detalhe-guid
                   tipo_retorno      = 'E'.

        IF sy-subrc IS INITIAL.

          LOOP AT ls_confoper-retornoset INTO ls_retorno.
            APPEND ls_retorno TO lt_retorno.
          ENDLOOP.

        ENDIF.


        wa_detalhe-retornoset[] = lt_retorno[].
        CLEAR ls_confoper.
      ENDIF.


      APPEND wa_detalhe TO e_detalhe.
      CLEAR wa_detalhe.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
