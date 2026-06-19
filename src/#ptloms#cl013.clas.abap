class /PTLOMS/CL013 definition
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

  class-methods DATA_RETROATIVA
    exporting
      value(CH_DATA) type DATUM .
  class-methods TIPO_ORDEM_PERFIL
    importing
      value(IM_USUPERFIL) type TT_USUPERFIL optional
      !IM_SUBRC type SY-SUBRC
    exporting
      !EM_SUBRC type SY-SUBRC
      value(RE_AUART) type TT_AUART .
  class-methods CATEGORIA_EQUIP_PERFIL
    importing
      value(IM_USUPERFIL) type TT_USUPERFIL optional
      !IM_SUBRC type SY-SUBRC
    exporting
      !EM_SUBRC type SY-SUBRC
      value(RE_EQTYP) type TT_EQTYP .
  class-methods CATEGORIA_LOCAL_INSTAL_PERFIL
    importing
      value(IM_USUPERFIL) type TT_USUPERFIL optional
      !IM_SUBRC type SY-SUBRC
    exporting
      !EM_SUBRC type SY-SUBRC
      value(RE_FLTYP) type TT_FLTYP .
  class-methods ORDEM_POR_CLIENTE
    importing
      !IV_NAME type STRING optional
      !IV_KUNNR type STRING optional
      !IV_CPF type STRING optional
      !IV_STATUS type STRING optional
      !IV_CNPJ type STRING optional
      !IV_DADOS_ENDERECO type CHAR1 optional
    exporting
      !ET_ORDERS type /PTLOMS/CT167 .
  class-methods NOTAS_POR_CLIENTE
    importing
      !IV_STATUS type STRING optional
      !IV_NAME type STRING optional
      !IV_KUNNR type STRING optional
      !IV_CPF type STRING optional
      !IV_CNPJ type STRING optional
      !IV_DADOS_ENDERECO type CHAR1 optional
    exporting
      !ET_NOTAS type /PTLOMS/CT167 .
  class-methods BUSCAR_CLIENTES
    importing
      !IV_NAME type STRING optional
      !IV_CNPJ type STRING optional
      !IV_CPF type STRING optional
      !IV_KUNNR type STRING optional
      !IV_DADOS_ENDERECO type CHAR1 optional
    exporting
      !ET_CLIENTES type /PTLOMS/CT168 .
  class-methods NOTA_ORDEM_CLIENTE
    importing
      !IV_NAME type STRING optional
      !IV_KUNNR type STRING optional
      !IV_CPF type STRING optional
      !IV_STATUS type STRING optional
      !IV_CNPJ type STRING optional
      !IV_DADOS_ENDERECO type CHAR1 optional
    exporting
      !ET_DADOS type /PTLOMS/CT167 .
  class-methods OBTER_DETALHE_NOTA
    importing
      !IV_QMNUM type VIQMEL-QMNUM
    exporting
      !ES_NOTA type /PTLOMS/ET199 .
  class-methods OBTER_DETALHE_ORDEM
    importing
      !IV_AUFNR type AUFK-AUFNR
    exporting
      !ES_ORDEM type /PTLOMS/ET199 .
  class-methods OBTER_OPERACOES_ORDEM
    importing
      !IV_AUFNR type AUFK-AUFNR
    exporting
      !ET_OPERACOES type /PTLOMS/CT169 .
  class-methods OBTER_TIMELINE_COMPLETA
    importing
      !IV_AUFNR type CHAR12
      !IV_QMNUM type CHAR12 optional
    exporting
      !ET_TIMELINE type /PTLOMS/CT169 .
  class-methods OBTER_TIMELINE_FIORI
    importing
      !IV_AUFNR type CHAR12
      !IV_QMNUM type CHAR12 optional
    exporting
      !ET_TIMELINE type /PTLOMS/CT169 .
  class-methods ORDENS_POR_EQUIPAMENTO_LOCAL
    importing
      !IV_EQUNR type EQUI-EQUNR optional
      !IV_EQKTX type EQKT-EQKTX optional
      !IV_INVNR type EQUI-INVNR optional
      !IV_TPLNR type IFLOT-TPLNR optional
      !IV_PLTXT type IFLOTX-PLTXT optional
      !IV_STATUS type STRING optional
    exporting
      !ET_ORDERS type /PTLOMS/CT167 .
  class-methods NOTAS_POR_EQUIPAMENTO_LOCAL
    importing
      !IV_EQUNR type EQUI-EQUNR optional
      !IV_EQKTX type EQKT-EQKTX optional
      !IV_INVNR type EQUI-INVNR optional
      !IV_TPLNR type IFLOT-TPLNR optional
      !IV_PLTXT type IFLOTX-PLTXT optional
      !IV_STATUS type STRING optional
    exporting
      !ET_NOTAS type /PTLOMS/CT167 .
  class-methods NOTA_ORDEM_EQUIPAMENTO_LOCAL
    importing
      !IV_EQUNR type EQUI-EQUNR optional
      !IV_EQKTX type EQKT-EQKTX optional
      !IV_INVNR type EQUI-INVNR optional
      !IV_TPLNR type IFLOT-TPLNR optional
      !IV_PLTXT type IFLOTX-PLTXT optional
      !IV_STATUS type STRING optional
    exporting
      !ET_DADOS type /PTLOMS/CT167 .
  class-methods BAIXA_RESERVA_PM
    importing
      !IV_RSNUM type RESB-RSNUM
      !IV_PSTNG_DATE type BUDAT optional
      !IV_TESTRUN type FLAG optional
      !IT_BAIXA type /PTLOMS/CT171
    exporting
      !EV_MATERIALDOCUMENT type MBLNR
      !EV_MATDOCUMENTYEAR type MJAHR
      !ET_RETURN type BAPIRET2_T .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL013 IMPLEMENTATION.


METHOD baixa_reserva_pm.

  DATA: lt_resb     TYPE TABLE OF resb,
        ls_header   TYPE bapi2017_gm_head_01,
        ls_code     TYPE bapi2017_gm_code,
        lt_item     TYPE TABLE OF bapi2017_gm_item_create,
        ls_item     TYPE bapi2017_gm_item_create,
        ls_headret  TYPE bapi2017_gm_head_ret,
        lt_return   TYPE TABLE OF bapiret2,
        ls_return   TYPE bapiret2,
        lv_pendente TYPE menge_d,
        lv_erro     TYPE abap_bool,
        lv_bwart    TYPE bwart,
        lv_auart    TYPE aufart.

  CLEAR: ev_materialdocument,
         ev_matdocumentyear,
         et_return.

  IF iv_rsnum IS INITIAL.
    APPEND VALUE bapiret2(
      type    = 'E'
      id      = 'ZPM'
      number  = '001'
      message = 'Número da reserva não informado.'
    ) TO et_return.
    RETURN.
  ENDIF.

  IF it_baixa IS INITIAL.
    APPEND VALUE bapiret2(
      type    = 'E'
      id      = 'ZPM'
      number  = '002'
      message = 'Nenhum item informado para baixa.'
    ) TO et_return.
    RETURN.
  ENDIF.

  SELECT *
    FROM resb
    INTO TABLE @lt_resb
   WHERE rsnum = @iv_rsnum
     AND xloek = @space.

  IF lt_resb IS INITIAL.
    APPEND VALUE bapiret2(
      type    = 'E'
      id      = 'ZPM'
      number  = '003'
      message = |Reserva { iv_rsnum } não encontrada ou sem itens válidos.|
    ) TO et_return.
    RETURN.
  ENDIF.

  DATA(ls_resb_ref) = lt_resb[ 1 ].

  IF ls_resb_ref-aufnr IS NOT INITIAL.

    SELECT SINGLE auart
      FROM aufk
      INTO @lv_auart
     WHERE aufnr = @ls_resb_ref-aufnr.

  ENDIF.

  ls_header-pstng_date = COND #( WHEN iv_pstng_date IS INITIAL
                                 THEN sy-datum
                                 ELSE iv_pstng_date ).

  ls_header-doc_date   = sy-datum.
  ls_header-pr_uname   = sy-uname.
  ls_header-header_txt = |Baixa reserva PM { iv_rsnum }|.

  ls_code-gm_code = '03'. "Goods Issue

  LOOP AT lt_resb ASSIGNING FIELD-SYMBOL(<fs_resb>).

    READ TABLE it_baixa ASSIGNING FIELD-SYMBOL(<fs_baixa>)
      WITH KEY rsnum = <fs_resb>-rsnum
               rspos = <fs_resb>-rspos.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    IF <fs_baixa>-menge IS INITIAL OR <fs_baixa>-menge <= 0.
      APPEND VALUE bapiret2(
        type    = 'E'
        id      = 'ZPM'
        number  = '004'
        message = |Item { <fs_resb>-rspos }: quantidade para baixa inválida.|
      ) TO et_return.
      CONTINUE.
    ENDIF.

    IF <fs_resb>-kzear = abap_true.
      APPEND VALUE bapiret2(
        type    = 'E'
        id      = 'ZPM'
        number  = '005'
        message = |Item { <fs_resb>-rspos }: item da reserva já finalizado.|
      ) TO et_return.
      CONTINUE.
    ENDIF.

    lv_pendente = <fs_resb>-bdmng - <fs_resb>-enmng.

    IF lv_pendente <= 0.
      APPEND VALUE bapiret2(
        type    = 'W'
        id      = 'ZPM'
        number  = '006'
        message = |Item { <fs_resb>-rspos }: não possui saldo pendente para baixa.|
      ) TO et_return.
      CONTINUE.
    ENDIF.

    IF <fs_baixa>-menge > lv_pendente.
      APPEND VALUE bapiret2(
        type    = 'E'
        id      = 'ZPM'
        number  = '007'
        message = |Item { <fs_resb>-rspos }: quantidade informada { <fs_baixa>-menge } superior ao saldo pendente { lv_pendente }.|
      ) TO et_return.
      CONTINUE.
    ENDIF.

    CLEAR lv_bwart.

    SELECT SINGLE bwart
      FROM /ptloms/tb080
      INTO @lv_bwart
     WHERE werks = @<fs_resb>-werks
       AND auart = @lv_auart
       AND ativo = @abap_true.

    IF lv_bwart IS INITIAL.
      SELECT SINGLE bwart
        FROM /ptloms/tb080
        INTO @lv_bwart
       WHERE werks = @<fs_resb>-werks
         AND auart = @space
         AND ativo = @abap_true.
    ENDIF.

    IF lv_bwart IS INITIAL.
      lv_bwart = '261'.

      APPEND VALUE bapiret2(
        type    = 'W'
        id      = 'ZPM'
        number  = '009'
        message = |Item { <fs_resb>-rspos }: movimento não configurado para centro { <fs_resb>-werks } e tipo de ordem { lv_auart }. Utilizado movimento default 261.|
      ) TO et_return.
    ENDIF.

    CLEAR ls_item.

    ls_item-material  = <fs_resb>-matnr.
    ls_item-plant     = <fs_resb>-werks.
    ls_item-stge_loc  = <fs_resb>-lgort.
    ls_item-batch     = <fs_resb>-charg.
    ls_item-move_type = lv_bwart.

    ls_item-entry_qnt = <fs_baixa>-menge.
    ls_item-entry_uom = <fs_resb>-meins.

    ls_item-reserv_no = <fs_resb>-rsnum.
    ls_item-res_item  = <fs_resb>-rspos.
    ls_item-orderid   = <fs_resb>-aufnr.

    APPEND ls_item TO lt_item.

  ENDLOOP.

  LOOP AT et_return TRANSPORTING NO FIELDS
    WHERE type = 'E'
       OR type = 'A'
       OR type = 'X'.
    lv_erro = abap_true.
    EXIT.
  ENDLOOP.

  IF lv_erro = abap_true.
    RETURN.
  ENDIF.

  IF lt_item IS INITIAL.
    APPEND VALUE bapiret2(
      type    = 'W'
      id      = 'ZPM'
      number  = '008'
      message = |Nenhum item válido encontrado para baixa da reserva { iv_rsnum }.|
    ) TO et_return.
    RETURN.
  ENDIF.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_header
      goodsmvt_code    = ls_code
      testrun          = iv_testrun
    IMPORTING
      goodsmvt_headret = ls_headret
      materialdocument = ev_materialdocument
      matdocumentyear  = ev_matdocumentyear
    TABLES
      goodsmvt_item    = lt_item
      return           = lt_return.

  APPEND LINES OF lt_return TO et_return.

  CLEAR lv_erro.

  LOOP AT lt_return INTO ls_return
    WHERE type = 'E'
       OR type = 'A'
       OR type = 'X'.
    lv_erro = abap_true.
    EXIT.
  ENDLOOP.

  IF lv_erro = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RETURN.
  ENDIF.

  IF iv_testrun IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDMETHOD.


METHOD buscar_clientes.

*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  STRING OPTIONAL
*"     VALUE(IV_CNPJ) TYPE  STRING OPTIONAL
*"     VALUE(IV_CPF) TYPE  STRING OPTIONAL
*"     VALUE(IV_KUNNR) TYPE  STRING OPTIONAL
*"     VALUE(IV_DADOS_ENDERECO) TYPE CHAR1 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_CLIENTES) TYPE  /PTLOMS/TT_CLIENTES " Sua tabela de clientes
*"----------------------------------------------------------------------

  " --- CONFIGURAÇÃO DE TIPOS LOCAIS (DIALETO STANDARD SAP) ---
  TYPES: BEGIN OF ty_kna1_aux,
           kunnr TYPE kna1-kunnr,
           name1 TYPE kna1-name1,
           name2 TYPE kna1-name2,
           stcd1 TYPE kna1-stcd1,
           stcd2 TYPE kna1-stcd2,
           adrnr TYPE kna1-adrnr,
         END OF ty_kna1_aux.

  TYPES: BEGIN OF ty_adrc,
           addrnumber TYPE adrc-addrnumber,
           street     TYPE adrc-street,
           house_num1 TYPE adrc-house_num1,
           city1      TYPE adrc-city1,
           post_code1 TYPE adrc-post_code1,
           region     TYPE adrc-region,
         END OF ty_adrc.

  TYPES: BEGIN OF ty_adr2,
           addrnumber TYPE adr2-addrnumber,
           tel_number TYPE adr2-tel_number, " Corrigido de telephone para tel_number
           tel_extens TYPE adr2-tel_extens,
         END OF ty_adr2.

  TYPES: BEGIN OF ty_adr6,
           addrnumber TYPE adr6-addrnumber,
           smtp_addr  TYPE adr6-smtp_addr,
         END OF ty_adr6.

  " --- TABELAS INTERNAS E WORK AREAS ---
  DATA: lv_search        TYPE string,
        lv_clean_val     TYPE string,
        lv_kunnr         TYPE kna1-kunnr,
        lt_kna1_aux      TYPE STANDARD TABLE OF ty_kna1_aux,
        wa_kna1_aux      TYPE ty_kna1_aux,
        wa_cliente       LIKE LINE OF et_clientes,

        " Tabelas de Endereço/Contato obtidas via Business Address Services (BAS)
        lt_adrc          TYPE STANDARD TABLE OF ty_adrc,
        wa_adrc          TYPE ty_adrc,
        lt_adr2          TYPE STANDARD TABLE OF ty_adr2,
        wa_adr2          TYPE ty_adr2,
        lt_adr6          TYPE STANDARD TABLE OF ty_adr6,
        wa_adr6          TYPE ty_adr6,

        " Variáveis locais auxiliares para strings dinâmicas
        lv_endereco_comp TYPE string,
        lv_telefones     TYPE string.

  CLEAR et_clientes.

  " Validação de segurança: se tudo estiver em branco, encerra
  IF iv_name IS INITIAL AND iv_cnpj IS INITIAL AND iv_cpf IS INITIAL AND iv_kunnr IS INITIAL.
    RETURN.
  ENDIF.

  " =====================================================================
  " 1. BLOCOS DE PESQUISA (REGRA ORIGINAL POR PRIORIDADE)
  " =====================================================================
  IF iv_kunnr IS NOT INITIAL.
    lv_kunnr = iv_kunnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_kunnr
      IMPORTING
        output = lv_kunnr.

    SELECT kunnr name1 name2 stcd1 stcd2 adrnr
      FROM kna1
      INTO CORRESPONDING FIELDS OF TABLE lt_kna1_aux
      WHERE kunnr = lv_kunnr.

  ELSEIF iv_cpf IS NOT INITIAL.
    lv_clean_val = iv_cpf.
    TRANSLATE lv_clean_val USING '. - / '.
    CONDENSE lv_clean_val NO-GAPS.

    SELECT kunnr name1 name2 stcd1 stcd2 adrnr
      FROM kna1
      INTO CORRESPONDING FIELDS OF TABLE lt_kna1_aux
      WHERE stcd2 = lv_clean_val
         OR stcd1 = lv_clean_val.

  ELSEIF iv_cnpj IS NOT INITIAL.
    lv_clean_val = iv_cnpj.
    TRANSLATE lv_clean_val USING '. - / '.
    CONDENSE lv_clean_val NO-GAPS.

    SELECT kunnr name1 name2 stcd1 stcd2 adrnr
      FROM kna1
      INTO CORRESPONDING FIELDS OF TABLE lt_kna1_aux
      WHERE stcd1 = lv_clean_val
         OR stcd2 = lv_clean_val.

  ELSEIF iv_name IS NOT INITIAL.
    lv_clean_val = iv_name.
    CONDENSE lv_clean_val.
    TRANSLATE lv_clean_val TO UPPER CASE.

    CONCATENATE '%' lv_clean_val '%' INTO lv_search.

    SELECT kunnr name1 name2 stcd1 stcd2 adrnr
      FROM kna1
      INTO CORRESPONDING FIELDS OF TABLE lt_kna1_aux
      WHERE name1 LIKE lv_search
         OR name2 LIKE lv_search
         OR mcod1 LIKE lv_search.
  ENDIF.

  " =====================================================================
  " 2. BUSCA EM LOTE DE ENDEREÇOS E CONTATOS (APENAS SE SOLICITADO)
  " =====================================================================
  IF iv_dados_endereco IS NOT INITIAL AND lt_kna1_aux IS NOT INITIAL.

    " Busca moradas físicas principais
    SELECT addrnumber street house_num1 city1 post_code1 region
      FROM adrc
      INTO TABLE lt_adrc
      FOR ALL ENTRIES IN lt_kna1_aux
      WHERE addrnumber = lt_kna1_aux-adrnr
        AND nation     = ''. " Endereço standard por omissão

    " Busca números de telefone ativos
    SELECT addrnumber tel_number tel_extens
      FROM adr2
      INTO TABLE lt_adr2
      FOR ALL ENTRIES IN lt_kna1_aux
      WHERE addrnumber = lt_kna1_aux-adrnr
        AND r3_user    NE 'V'. " Exclui registros inválidos/de fax

    " Busca contas de e-mail ativas
    SELECT addrnumber smtp_addr
      FROM adr6
      INTO TABLE lt_adr6
      FOR ALL ENTRIES IN lt_kna1_aux
      WHERE addrnumber = lt_kna1_aux-adrnr.

  ENDIF.

  " =====================================================================
  " 3. MAPEAMENTO SEGURO E FORMATAÇÃO DE STRINGS PARA O FRONTEND
  " =====================================================================
  IF lt_kna1_aux IS NOT INITIAL.
    LOOP AT lt_kna1_aux INTO wa_kna1_aux.
      CLEAR: wa_cliente, lv_endereco_comp, lv_telefones.

      " Passa os dados comuns do cliente
      wa_cliente-kunnr = wa_kna1_aux-kunnr.
      wa_cliente-name1 = wa_kna1_aux-name1.
      wa_cliente-name2 = wa_kna1_aux-name2.
      wa_cliente-cnpj  = wa_kna1_aux-stcd1.
      wa_cliente-cpf   = wa_kna1_aux-stcd2.

      " Processamento condicional do endereço (se flag estiver ativa)
      IF iv_dados_endereco IS NOT INITIAL AND wa_kna1_aux-adrnr IS NOT INITIAL.

        " 3.1 Formatação do Endereço Completo Comercial solicitado
        READ TABLE lt_adrc INTO wa_adrc WITH KEY addrnumber = wa_kna1_aux-adrnr.
        IF sy-subrc = 0.
          CONDENSE: wa_adrc-street, wa_adrc-house_num1, wa_adrc-city1, wa_adrc-region, wa_adrc-post_code1.

          IF wa_adrc-street IS NOT INITIAL.
            CONCATENATE wa_adrc-street ',' wa_adrc-house_num1 INTO lv_endereco_comp SEPARATED BY space.
            CONCATENATE lv_endereco_comp ' -' wa_adrc-city1 INTO lv_endereco_comp SEPARATED BY space.
            CONCATENATE lv_endereco_comp ' -' wa_adrc-region ',' INTO lv_endereco_comp SEPARATED BY space.
            CONCATENATE lv_endereco_comp wa_adrc-post_code1 INTO wa_cliente-endereco_completo SEPARATED BY space.
          ENDIF.
        ENDIF.

        " 3.2 Consolidação de múltiplos telefones unificados por ' / '
        CLEAR lv_telefones.
        LOOP AT lt_adr2 INTO wa_adr2 WHERE addrnumber = wa_kna1_aux-adrnr.
          CONDENSE wa_adr2-tel_number.
          IF wa_adr2-tel_number IS NOT INITIAL.
            IF lv_telefones IS INITIAL.
              lv_telefones = wa_adr2-tel_number.
            ELSE.
              CONCATENATE lv_telefones ' / ' wa_adr2-tel_number INTO lv_telefones.
            ENDIF.
          ENDIF.
        ENDLOOP.
        wa_cliente-telefones = lv_telefones.

        " 3.3 Primeiro E-mail Ativo encontrado (Regra do registro primário)
        READ TABLE lt_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_kna1_aux-adrnr.
        IF sy-subrc = 0.
          wa_cliente-email = wa_adr6-smtp_addr.
        ENDIF.

      ENDIF.

      APPEND wa_cliente TO et_clientes.
    ENDLOOP.
  ENDIF.

ENDMETHOD.


  METHOD categoria_equip_perfil.

    " Perfil associado ao usuário
*    SELECT SINGLE * FROM
*       /ptloms/tb013
*      INTO @DATA(wl_tb013)
*      WHERE usuario IN @im_usuperfil.

    DATA: wl_tb013 TYPE /ptloms/tb013.

    SELECT SINGLE * FROM /ptloms/tb013 INTO wl_tb013
          WHERE usuario IN im_usuperfil.

    IF sy-subrc IS INITIAL.

      " Centros associado ao perfil
*      SELECT 'I'   AS sign,
*             'EQ'  AS option,
*             eqtyp AS low,
*             eqtyp AS high
*        FROM /ptloms/tb019
*        INTO TABLE @re_eqtyp
*        WHERE perfil = @wl_tb013-perfil.

      SELECT *
          FROM /ptloms/tb019
          INTO CORRESPONDING FIELDS OF TABLE re_eqtyp
          WHERE perfil = wl_tb013-perfil.


      IF sy-subrc IS NOT INITIAL.

        " Se não houver categoria de equipamento no perfil, não retornar nenhum
        em_subrc = 4.

      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD categoria_local_instal_perfil.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Renato Costa
*********************************************************************************************************

    " Perfil associado ao usuário
*    SELECT SINGLE * FROM
*       /ptloms/tb013
*      INTO @DATA(wl_tb013)
*      WHERE usuario IN @im_usuperfil.

    DATA: wl_tb013 TYPE /ptloms/tb013.

    SELECT SINGLE * FROM /ptloms/tb013 INTO wl_tb013
          WHERE usuario IN im_usuperfil.

    IF sy-subrc IS INITIAL.

      " Centros associado ao perfil
*      SELECT 'I'   AS sign,
*             'EQ'  AS option,
*             fltyp AS low,
*             fltyp AS high
*        FROM /ptloms/tb018
*        INTO TABLE @re_fltyp
*        WHERE perfil = @wl_tb013-perfil.

      SELECT *
       FROM /ptloms/tb018
       INTO CORRESPONDING FIELDS OF TABLE re_fltyp
       WHERE perfil = wl_tb013-perfil.

      IF sy-subrc IS NOT INITIAL.

        " Se não houver categoria de local de instalação no perfil, não retornar nenhum
        em_subrc = 4.

      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD data_retroativa.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

    DATA: days   TYPE t5a4a-dlydy,
          months TYPE t5a4a-dlymo.

    DATA: periodo TYPE /ptloms/tb033-anos_retroativos.

    " Configuração de período para pesquisa de ordem
    SELECT SINGLE anos_retroativos
      INTO periodo
      FROM /ptloms/tb033.

    CASE periodo.

      WHEN '1' OR ''.

        days = 7.

      WHEN '2'.

        months = 1.

      WHEN '3'.

        months = 3.

      WHEN '4'.

        months = 6.

      WHEN '5'.

        months = 9.

      WHEN '6'.

        months = 12.

    ENDCASE.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = days
        months    = months
        signum    = '-'
        years     = 0
      IMPORTING
        calc_date = ch_data.

  ENDMETHOD.


METHOD notas_por_cliente.

*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  STRING OPTIONAL
*"     VALUE(IV_CNPJ) TYPE  STRING OPTIONAL
*"     VALUE(IV_CPF) TYPE  STRING OPTIONAL
*"     VALUE(IV_KUNNR) TYPE  STRING OPTIONAL
*"     VALUE(IV_STATUS) TYPE  STRING OPTIONAL
*"     VALUE(IV_DADOS_ENDERECO) TYPE CHAR1 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_NOTAS) TYPE  /PTLOMS/CT167
*"----------------------------------------------------------------------

  TYPES: BEGIN OF ty_kunnr,
           kunnr TYPE kna1-kunnr,
         END OF ty_kunnr.

  TYPES: BEGIN OF ty_ihpa_parnr,
           parnr TYPE ihpa-parnr,
         END OF ty_ihpa_parnr.

  TYPES: BEGIN OF ty_equnr,
           equnr TYPE eqbs-equnr,
         END OF ty_equnr.

  TYPES: BEGIN OF ty_qmnum,
           qmnum TYPE viqmel-qmnum,
         END OF ty_qmnum.

  TYPES: BEGIN OF ty_viqmel_data,
           qmnum TYPE viqmel-qmnum,
           qmart TYPE viqmel-qmart,
           qmtxt TYPE viqmel-qmtxt,
           erdat TYPE viqmel-erdat,
           aufnr TYPE viqmel-aufnr,
           equnr TYPE viqmel-equnr,
           tplnr TYPE viqmel-tplnr,
           objnr TYPE viqmel-objnr,
         END OF ty_viqmel_data.

  TYPES: BEGIN OF ty_jest,
           objnr TYPE jest-objnr,
           stat  TYPE jest-stat,
         END OF ty_jest.

  TYPES: BEGIN OF ty_eqkt,
           equnr TYPE eqkt-equnr,
           eqktx TYPE eqkt-eqktx,
         END OF ty_eqkt.

  TYPES: BEGIN OF ty_equi,
           equnr TYPE equi-equnr,
           invnr TYPE equi-invnr,
         END OF ty_equi.

  TYPES: BEGIN OF ty_iflotx,
           tplnr TYPE iflotx-tplnr,
           pltxt TYPE iflotx-pltxt,
         END OF ty_iflotx.

  TYPES: BEGIN OF ty_tj02t,
           istat TYPE tj02t-istat,
           txt04 TYPE tj02t-txt04,
           txt30 TYPE tj02t-txt30,
         END OF ty_tj02t.

  DATA: lt_clientes     TYPE /ptloms/ct168,
        wa_cliente      LIKE LINE OF lt_clientes,

        lt_kunnr        TYPE STANDARD TABLE OF ty_kunnr,
        wa_kunnr        TYPE ty_kunnr,

        lt_parnr_ihpa   TYPE STANDARD TABLE OF ty_ihpa_parnr,
        wa_parnr_ihpa   TYPE ty_ihpa_parnr,

        lt_eqbs         TYPE STANDARD TABLE OF ty_equnr,

        lt_ihpa         TYPE STANDARD TABLE OF ihpa,
        wa_ihpa         TYPE ihpa,

        lt_qmnum_all    TYPE STANDARD TABLE OF ty_qmnum,
        wa_qmnum_all    TYPE ty_qmnum,

        lt_qmnum_rng    TYPE RANGE OF viqmel-qmnum,
        wa_qmnum_rng    LIKE LINE OF lt_qmnum_rng,

        lt_viqmel_fin   TYPE STANDARD TABLE OF ty_viqmel_data,
        wa_viqmel_fin   TYPE ty_viqmel_data,

        lt_jest         TYPE STANDARD TABLE OF ty_jest,
        wa_jest         TYPE ty_jest,

        lt_eqkt         TYPE STANDARD TABLE OF ty_eqkt,
        wa_eqkt         TYPE ty_eqkt,

        lt_equi         TYPE STANDARD TABLE OF ty_equi,
        wa_equi         TYPE ty_equi,

        lt_iflotx       TYPE STANDARD TABLE OF ty_iflotx,
        wa_iflotx       TYPE ty_iflotx,

        lt_tj02t        TYPE STANDARD TABLE OF ty_tj02t,
        wa_tj02t        TYPE ty_tj02t,

        lt_orders_out   TYPE /ptloms/ct167,
        wa_orders       LIKE LINE OF lt_orders_out,

        lv_kunnr_atual  TYPE kna1-kunnr,
        lv_objnr_tmp    TYPE ihpa-objnr,
        lv_status_final TYPE jest-stat.

  CLEAR et_notas.

  " =====================================================================
  " STEP 1: CHAMADA DO MÉTODO DE CLIENTES
  " =====================================================================
  CALL METHOD /ptloms/cl013=>buscar_clientes
    EXPORTING
      iv_name           = iv_name
      iv_cnpj           = iv_cnpj
      iv_cpf            = iv_cpf
      iv_kunnr          = iv_kunnr
      iv_dados_endereco = iv_dados_endereco
    IMPORTING
      et_clientes       = lt_clientes.

  IF lt_clientes IS INITIAL.
    RETURN.
  ENDIF.

  SORT lt_clientes BY kunnr.

  LOOP AT lt_clientes INTO wa_cliente.

    CLEAR wa_kunnr.
    wa_kunnr-kunnr = wa_cliente-kunnr.
    APPEND wa_kunnr TO lt_kunnr.

    CLEAR wa_parnr_ihpa.
    wa_parnr_ihpa-parnr = wa_cliente-kunnr.
    APPEND wa_parnr_ihpa TO lt_parnr_ihpa.

  ENDLOOP.

  SORT lt_kunnr BY kunnr.
  DELETE ADJACENT DUPLICATES FROM lt_kunnr COMPARING kunnr.
  DELETE lt_kunnr WHERE kunnr IS INITIAL.

  SORT lt_parnr_ihpa BY parnr.
  DELETE ADJACENT DUPLICATES FROM lt_parnr_ihpa COMPARING parnr.
  DELETE lt_parnr_ihpa WHERE parnr IS INITIAL.

  " =====================================================================
  " STEP 2: REGRAS DA IHPA - CAPTURA VIA PARCEIROS DA NOTA
  " =====================================================================
  IF lt_parnr_ihpa IS NOT INITIAL.

    SELECT objnr parnr parvw
      FROM ihpa
      INTO CORRESPONDING FIELDS OF TABLE lt_ihpa
      FOR ALL ENTRIES IN lt_parnr_ihpa
      WHERE parnr = lt_parnr_ihpa-parnr.

  ENDIF.

  SORT lt_ihpa BY objnr parnr.

  LOOP AT lt_ihpa INTO wa_ihpa.
    IF wa_ihpa-objnr(2) = 'QM'.
      CLEAR wa_qmnum_all.
      wa_qmnum_all-qmnum = wa_ihpa-objnr+2(10).
      APPEND wa_qmnum_all TO lt_qmnum_all.
    ENDIF.
  ENDLOOP.

  " =====================================================================
  " STEP 3: REGRAS DA EQBS - NOTAS SEM ORDEM VIA ATIVOS DO CLIENTE
  " =====================================================================
  IF lt_kunnr IS NOT INITIAL.

    SELECT equnr
      FROM eqbs
      INTO CORRESPONDING FIELDS OF TABLE lt_eqbs
      FOR ALL ENTRIES IN lt_kunnr
      WHERE kunnr = lt_kunnr-kunnr.

  ENDIF.

  IF lt_eqbs IS NOT INITIAL.

    SORT lt_eqbs BY equnr.
    DELETE ADJACENT DUPLICATES FROM lt_eqbs COMPARING equnr.
    DELETE lt_eqbs WHERE equnr IS INITIAL.

    IF lt_eqbs IS NOT INITIAL.

      SELECT qmnum
        FROM viqmel
        APPENDING CORRESPONDING FIELDS OF TABLE lt_qmnum_all
        FOR ALL ENTRIES IN lt_eqbs
        WHERE equnr = lt_eqbs-equnr.

    ENDIF.

  ENDIF.

  " =====================================================================
  " STEP 4: CONSOLIDAR MAPA DE NOTAS E GERAR RANGE
  " =====================================================================
  IF lt_qmnum_all IS NOT INITIAL.

    SORT lt_qmnum_all BY qmnum.
    DELETE ADJACENT DUPLICATES FROM lt_qmnum_all COMPARING qmnum.
    DELETE lt_qmnum_all WHERE qmnum IS INITIAL.

    CLEAR lt_qmnum_rng.

    LOOP AT lt_qmnum_all INTO wa_qmnum_all.

      CLEAR wa_qmnum_rng.
      wa_qmnum_rng-sign   = 'I'.
      wa_qmnum_rng-option = 'EQ'.
      wa_qmnum_rng-low    = wa_qmnum_all-qmnum.

      APPEND wa_qmnum_rng TO lt_qmnum_rng.

    ENDLOOP.

  ENDIF.

  " =====================================================================
  " STEP 5: EXTRAÇÃO FINAL VIA VIEW VIQMEL E TRATAMENTO DE SAÍDA
  " =====================================================================
  IF lt_qmnum_rng IS NOT INITIAL.

    SELECT qmnum qmart qmtxt erdat aufnr equnr tplnr objnr
      FROM viqmel
      INTO CORRESPONDING FIELDS OF TABLE lt_viqmel_fin
      WHERE qmnum IN lt_qmnum_rng.

    IF lt_viqmel_fin IS NOT INITIAL.

      SELECT objnr stat
        FROM jest
        INTO CORRESPONDING FIELDS OF TABLE lt_jest
        FOR ALL ENTRIES IN lt_viqmel_fin
        WHERE objnr = lt_viqmel_fin-objnr
          AND inact = space.

      SORT lt_jest BY objnr stat.

      IF lt_jest IS NOT INITIAL.

        SELECT istat txt04 txt30
          FROM tj02t
          INTO CORRESPONDING FIELDS OF TABLE lt_tj02t
          FOR ALL ENTRIES IN lt_jest
          WHERE istat = lt_jest-stat
            AND spras = sy-langu.

        SORT lt_tj02t BY istat.

      ENDIF.

      SELECT equnr eqktx
        FROM eqkt
        INTO CORRESPONDING FIELDS OF TABLE lt_eqkt
        FOR ALL ENTRIES IN lt_viqmel_fin
        WHERE equnr = lt_viqmel_fin-equnr
          AND spras = sy-langu.

      SORT lt_eqkt BY equnr.

      SELECT equnr invnr
        FROM equi
        INTO TABLE lt_equi
        FOR ALL ENTRIES IN lt_viqmel_fin
        WHERE equnr = lt_viqmel_fin-equnr.

      SORT lt_equi BY equnr.

      SELECT tplnr pltxt
        FROM iflotx
        INTO CORRESPONDING FIELDS OF TABLE lt_iflotx
        FOR ALL ENTRIES IN lt_viqmel_fin
        WHERE tplnr = lt_viqmel_fin-tplnr
          AND spras = sy-langu.

      SORT lt_iflotx BY tplnr.

    ENDIF.

    LOOP AT lt_viqmel_fin INTO wa_viqmel_fin.

      CLEAR: wa_orders,
             wa_jest,
             wa_tj02t,
             wa_eqkt,
             wa_equi,
             wa_iflotx,
             wa_cliente,
             lv_kunnr_atual,
             lv_objnr_tmp,
             lv_status_final.

      " ===============================================================
      " Determinação correta do status ativo da JEST
      "
      " A JEST pode possuir vários status ativos para o mesmo OBJNR.
      " Não usar READ TABLE simples por OBJNR, pois ele pega apenas
      " o primeiro registro encontrado e pode retornar OUTROS
      " antes de encontrar um status de encerramento.
      "
      " Prioridade:
      " 1) ENCERRADA
      " 2) ABERTA
      " 3) OUTROS
      " ===============================================================

      LOOP AT lt_jest INTO wa_jest
        WHERE objnr = wa_viqmel_fin-objnr
          AND ( stat = 'I0070'
             OR stat = 'I0072'
             OR stat = 'I0076' ).

        lv_status_final      = wa_jest-stat.
        wa_orders-status_rel = 'ENCERRADA'.
        EXIT.

      ENDLOOP.

      IF lv_status_final IS INITIAL.

        LOOP AT lt_jest INTO wa_jest
          WHERE objnr = wa_viqmel_fin-objnr
            AND ( stat = 'I0068'
               OR stat = 'I0069'
               OR stat = 'I0001'
               OR stat = 'I0002' ).

          lv_status_final      = wa_jest-stat.
          wa_orders-status_rel = 'ABERTA'.
          EXIT.

        ENDLOOP.

      ENDIF.

      IF lv_status_final IS INITIAL.

        READ TABLE lt_jest INTO wa_jest
          WITH KEY objnr = wa_viqmel_fin-objnr
          BINARY SEARCH.

        IF sy-subrc = 0.
          lv_status_final = wa_jest-stat.
        ENDIF.

        wa_orders-status_rel = 'OUTROS'.

      ENDIF.

      " Aplica o filtro de entrada do Gateway OData
      IF iv_status IS NOT INITIAL.

        IF iv_status = 'ABERTA'
           AND wa_orders-status_rel NE 'ABERTA'.
          CONTINUE.
        ELSEIF iv_status = 'ENCERRADA'
           AND wa_orders-status_rel NE 'ENCERRADA'.
          CONTINUE.
        ENDIF.

      ENDIF.

      " Busca o texto explicativo do status selecionado pela regra acima
      IF lv_status_final IS NOT INITIAL.

        READ TABLE lt_tj02t INTO wa_tj02t
          WITH KEY istat = lv_status_final
          BINARY SEARCH.

        IF sy-subrc = 0.
          CONCATENATE wa_tj02t-txt04 ' - ' wa_tj02t-txt30
            INTO wa_orders-status_sistema.
        ENDIF.

      ENDIF.

      " Mapeamento padrão dos campos da Nota
      wa_orders-tipo        = 'N'.
      wa_orders-documento   = wa_viqmel_fin-qmnum.
      wa_orders-auart_qmart = wa_viqmel_fin-qmart.
      wa_orders-ktext       = wa_viqmel_fin-qmtxt.
      wa_orders-erdat       = wa_viqmel_fin-erdat.
      wa_orders-aufnr_rel   = wa_viqmel_fin-aufnr.
      wa_orders-equnr       = wa_viqmel_fin-equnr.
      wa_orders-tplnr       = wa_viqmel_fin-tplnr.

      " Determinação do Cliente correspondente
      CONCATENATE 'QM' wa_viqmel_fin-qmnum INTO lv_objnr_tmp.

      READ TABLE lt_ihpa INTO wa_ihpa
        WITH KEY objnr = lv_objnr_tmp
        BINARY SEARCH.

      IF sy-subrc = 0.
        lv_kunnr_atual = wa_ihpa-parnr.
      ELSEIF lt_clientes IS NOT INITIAL.
        READ TABLE lt_clientes INTO wa_cliente INDEX 1.
        lv_kunnr_atual = wa_cliente-kunnr.
      ENDIF.

      IF lv_kunnr_atual IS NOT INITIAL.

        READ TABLE lt_clientes INTO wa_cliente
          WITH KEY kunnr = lv_kunnr_atual
          BINARY SEARCH.

        IF sy-subrc = 0.
          wa_orders-kunnr             = wa_cliente-kunnr.
          wa_orders-name1             = wa_cliente-name1.
          wa_orders-name2             = wa_cliente-name2.
          wa_orders-cnpj              = wa_cliente-cnpj.
          wa_orders-cpf               = wa_cliente-cpf.
          wa_orders-endereco_completo = wa_cliente-endereco_completo.
          wa_orders-telefones         = wa_cliente-telefones.
          wa_orders-email             = wa_cliente-email.
        ENDIF.

      ENDIF.

      " Atribuição da descrição do Equipamento
      IF wa_orders-equnr IS NOT INITIAL.

        READ TABLE lt_eqkt INTO wa_eqkt
          WITH KEY equnr = wa_viqmel_fin-equnr
          BINARY SEARCH.

        IF sy-subrc = 0.
          wa_orders-eqktx = wa_eqkt-eqktx.
        ENDIF.

        READ TABLE lt_equi INTO wa_equi
          WITH KEY equnr = wa_viqmel_fin-equnr
          BINARY SEARCH.

        IF sy-subrc = 0.
          wa_orders-invnr = wa_equi-invnr.
        ENDIF.

      ENDIF.

      " Atribuição da descrição do Local de Instalação
      IF wa_orders-tplnr IS NOT INITIAL.

        READ TABLE lt_iflotx INTO wa_iflotx
          WITH KEY tplnr = wa_viqmel_fin-tplnr
          BINARY SEARCH.

        IF sy-subrc = 0.
          wa_orders-pltxt = wa_iflotx-pltxt.
        ENDIF.

      ENDIF.

      " Remoção de Zeros à Esquerda
      IF wa_orders-documento IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = wa_orders-documento
          IMPORTING
            output = wa_orders-documento.
      ENDIF.

      IF wa_orders-equnr IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = wa_orders-equnr
          IMPORTING
            output = wa_orders-equnr.
      ENDIF.

      IF wa_orders-aufnr_rel IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = wa_orders-aufnr_rel
          IMPORTING
            output = wa_orders-aufnr_rel.
      ENDIF.

      APPEND wa_orders TO lt_orders_out.

    ENDLOOP.

  ENDIF.

  SORT lt_orders_out BY erdat DESCENDING.
  et_notas = lt_orders_out.

ENDMETHOD.


METHOD notas_por_equipamento_local.

*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_EQUNR) TYPE EQUI-EQUNR OPTIONAL
*"     VALUE(IV_EQKTX) TYPE EQKT-EQKTX OPTIONAL
*"     VALUE(IV_INVNR) TYPE EQUI-INVNR OPTIONAL
*"     VALUE(IV_TPLNR) TYPE IFLOT-TPLNR OPTIONAL
*"     VALUE(IV_PLTXT) TYPE IFLOTX-PLTXT OPTIONAL
*"     VALUE(IV_STATUS) TYPE STRING OPTIONAL
*"  EXPORTING
*"     VALUE(ET_NOTAS) TYPE /PTLOMS/CT167
*"----------------------------------------------------------------------

  TYPES: BEGIN OF ty_equnr,
           equnr TYPE equi-equnr,
         END OF ty_equnr.

  TYPES: BEGIN OF ty_tplnr,
           tplnr TYPE iflotx-tplnr,
         END OF ty_tplnr.

  TYPES: BEGIN OF ty_viqmel_data,
           qmnum TYPE viqmel-qmnum,
           qmart TYPE viqmel-qmart,
           qmtxt TYPE viqmel-qmtxt,
           erdat TYPE viqmel-erdat,
           aufnr TYPE viqmel-aufnr,
           equnr TYPE viqmel-equnr,
           tplnr TYPE viqmel-tplnr,
           objnr TYPE viqmel-objnr,
         END OF ty_viqmel_data.

  TYPES: BEGIN OF ty_jest,
           objnr TYPE jest-objnr,
           stat  TYPE jest-stat,
         END OF ty_jest.

  TYPES: BEGIN OF ty_tj02t,
           istat TYPE tj02t-istat,
           txt04 TYPE tj02t-txt04,
           txt30 TYPE tj02t-txt30,
         END OF ty_tj02t.

  TYPES: BEGIN OF ty_eqkt,
           equnr TYPE eqkt-equnr,
           eqktx TYPE eqkt-eqktx,
         END OF ty_eqkt.

  TYPES: BEGIN OF ty_equi,
           equnr TYPE equi-equnr,
           invnr TYPE equi-invnr,
         END OF ty_equi.

  TYPES: BEGIN OF ty_iflotx,
           tplnr TYPE iflotx-tplnr,
           pltxt TYPE iflotx-pltxt,
         END OF ty_iflotx.

  TYPES: BEGIN OF ty_ihpa_kunnr,
           objnr TYPE ihpa-objnr,
           parnr TYPE kna1-kunnr,
         END OF ty_ihpa_kunnr.

  TYPES: BEGIN OF ty_kna1,
           kunnr TYPE kna1-kunnr,
           name1 TYPE kna1-name1,
           name2 TYPE kna1-name2,
           stcd1 TYPE kna1-stcd1,
           stcd2 TYPE kna1-stcd2,
         END OF ty_kna1.

  DATA: lt_equnr_sel    TYPE STANDARD TABLE OF ty_equnr,
        wa_equnr_sel    TYPE ty_equnr,
        lt_tplnr_sel    TYPE STANDARD TABLE OF ty_tplnr,
        wa_tplnr_sel    TYPE ty_tplnr,

        lt_equnr_rng    TYPE RANGE OF equi-equnr,
        wa_equnr_rng    LIKE LINE OF lt_equnr_rng,
        lt_tplnr_rng    TYPE RANGE OF iflotx-tplnr,
        wa_tplnr_rng    LIKE LINE OF lt_tplnr_rng,

        lt_viqmel_fin   TYPE STANDARD TABLE OF ty_viqmel_data,
        wa_viqmel_fin   TYPE ty_viqmel_data,

        lt_jest         TYPE STANDARD TABLE OF ty_jest,
        wa_jest         TYPE ty_jest,

        lt_tj02t        TYPE STANDARD TABLE OF ty_tj02t,
        wa_tj02t        TYPE ty_tj02t,

        lt_eqkt         TYPE STANDARD TABLE OF ty_eqkt,
        wa_eqkt         TYPE ty_eqkt,

        lt_equi         TYPE STANDARD TABLE OF ty_equi,
        wa_equi         TYPE ty_equi,

        lt_iflotx       TYPE STANDARD TABLE OF ty_iflotx,
        wa_iflotx       TYPE ty_iflotx,

        lt_ihpa_kunnr   TYPE STANDARD TABLE OF ty_ihpa_kunnr,
        wa_ihpa_kunnr   TYPE ty_ihpa_kunnr,

        lt_kna1         TYPE STANDARD TABLE OF ty_kna1,
        wa_kna1         TYPE ty_kna1,

        lt_orders_out   TYPE /ptloms/ct167,
        wa_orders       LIKE LINE OF lt_orders_out,

        lv_equnr        TYPE equi-equnr,
        lv_tplnr        TYPE iflotx-tplnr,
        lv_search       TYPE string,
        lv_status_final TYPE jest-stat.

  CLEAR et_notas.

  IF iv_equnr IS INITIAL
     AND iv_eqktx IS INITIAL
     AND iv_invnr IS INITIAL
     AND iv_tplnr IS INITIAL
     AND iv_pltxt IS INITIAL.
    RETURN.
  ENDIF.

  "====================================================================
  " 1. Determina equipamentos
  "====================================================================
  IF iv_equnr IS NOT INITIAL.

    lv_equnr = iv_equnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_equnr
      IMPORTING
        output = lv_equnr.

    CLEAR wa_equnr_sel.
    wa_equnr_sel-equnr = lv_equnr.
    APPEND wa_equnr_sel TO lt_equnr_sel.

  ELSEIF iv_invnr IS NOT INITIAL.

    SELECT equnr
      FROM equi
      INTO CORRESPONDING FIELDS OF TABLE lt_equnr_sel
      WHERE invnr = iv_invnr.

  ELSEIF iv_eqktx IS NOT INITIAL.

    lv_search = iv_eqktx.
    CONDENSE lv_search.
    CONCATENATE '%' lv_search '%' INTO lv_search.

    SELECT equnr
      FROM eqkt
      INTO CORRESPONDING FIELDS OF TABLE lt_equnr_sel
      WHERE eqktx LIKE lv_search
        AND spras = sy-langu.

  ENDIF.

  IF lt_equnr_sel IS NOT INITIAL.

    SORT lt_equnr_sel BY equnr.
    DELETE ADJACENT DUPLICATES FROM lt_equnr_sel COMPARING equnr.
    DELETE lt_equnr_sel WHERE equnr IS INITIAL.

    LOOP AT lt_equnr_sel INTO wa_equnr_sel.
      CLEAR wa_equnr_rng.
      wa_equnr_rng-sign   = 'I'.
      wa_equnr_rng-option = 'EQ'.
      wa_equnr_rng-low    = wa_equnr_sel-equnr.
      APPEND wa_equnr_rng TO lt_equnr_rng.
    ENDLOOP.

  ENDIF.

  "====================================================================
  " 2. Determina locais de instalação
  "====================================================================
  IF iv_tplnr IS NOT INITIAL.

    lv_tplnr = iv_tplnr.

    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = lv_tplnr
      IMPORTING
        output = lv_tplnr.

    CLEAR wa_tplnr_sel.
    wa_tplnr_sel-tplnr = lv_tplnr.
    APPEND wa_tplnr_sel TO lt_tplnr_sel.

  ELSEIF iv_pltxt IS NOT INITIAL.

    lv_search = iv_pltxt.
    CONDENSE lv_search.
    CONCATENATE '%' lv_search '%' INTO lv_search.

    SELECT tplnr
      FROM iflotx
      INTO CORRESPONDING FIELDS OF TABLE lt_tplnr_sel
      WHERE pltxt LIKE lv_search
        AND spras = sy-langu.

  ENDIF.

  IF lt_tplnr_sel IS NOT INITIAL.

    SORT lt_tplnr_sel BY tplnr.
    DELETE ADJACENT DUPLICATES FROM lt_tplnr_sel COMPARING tplnr.
    DELETE lt_tplnr_sel WHERE tplnr IS INITIAL.

    LOOP AT lt_tplnr_sel INTO wa_tplnr_sel.
      CLEAR wa_tplnr_rng.
      wa_tplnr_rng-sign   = 'I'.
      wa_tplnr_rng-option = 'EQ'.
      wa_tplnr_rng-low    = wa_tplnr_sel-tplnr.
      APPEND wa_tplnr_rng TO lt_tplnr_rng.
    ENDLOOP.

  ENDIF.

  IF lt_equnr_rng IS INITIAL
     AND lt_tplnr_rng IS INITIAL.
    RETURN.
  ENDIF.

  "====================================================================
  " 3. Busca notas PM/QM por equipamento/local
  "====================================================================
  IF lt_equnr_rng IS NOT INITIAL
     AND lt_tplnr_rng IS NOT INITIAL.

    SELECT qmnum qmart qmtxt erdat aufnr equnr tplnr objnr
      FROM viqmel
      INTO CORRESPONDING FIELDS OF TABLE lt_viqmel_fin
      WHERE equnr IN lt_equnr_rng
        AND tplnr IN lt_tplnr_rng.

  ELSEIF lt_equnr_rng IS NOT INITIAL.

    SELECT qmnum qmart qmtxt erdat aufnr equnr tplnr objnr
      FROM viqmel
      INTO CORRESPONDING FIELDS OF TABLE lt_viqmel_fin
      WHERE equnr IN lt_equnr_rng.

  ELSEIF lt_tplnr_rng IS NOT INITIAL.

    SELECT qmnum qmart qmtxt erdat aufnr equnr tplnr objnr
      FROM viqmel
      INTO CORRESPONDING FIELDS OF TABLE lt_viqmel_fin
      WHERE tplnr IN lt_tplnr_rng.

  ENDIF.

  IF lt_viqmel_fin IS INITIAL.
    RETURN.
  ENDIF.

  SORT lt_viqmel_fin BY qmnum.
  DELETE ADJACENT DUPLICATES FROM lt_viqmel_fin COMPARING qmnum.

  "====================================================================
  " 4. Busca status, textos e dados técnicos em lote
  "====================================================================
  SELECT objnr stat
    FROM jest
    INTO CORRESPONDING FIELDS OF TABLE lt_jest
    FOR ALL ENTRIES IN lt_viqmel_fin
    WHERE objnr = lt_viqmel_fin-objnr
      AND inact = space.

  SORT lt_jest BY objnr stat.

  IF lt_jest IS NOT INITIAL.

    SELECT istat txt04 txt30
      FROM tj02t
      INTO CORRESPONDING FIELDS OF TABLE lt_tj02t
      FOR ALL ENTRIES IN lt_jest
      WHERE istat = lt_jest-stat
        AND spras = sy-langu.

    SORT lt_tj02t BY istat.

  ENDIF.

  SELECT equnr eqktx
    FROM eqkt
    INTO CORRESPONDING FIELDS OF TABLE lt_eqkt
    FOR ALL ENTRIES IN lt_viqmel_fin
    WHERE equnr = lt_viqmel_fin-equnr
      AND spras = sy-langu.

  SORT lt_eqkt BY equnr.

  SELECT equnr invnr
    FROM equi
    INTO TABLE lt_equi
    FOR ALL ENTRIES IN lt_viqmel_fin
    WHERE equnr = lt_viqmel_fin-equnr.

  SORT lt_equi BY equnr.

  SELECT tplnr pltxt
    FROM iflotx
    INTO CORRESPONDING FIELDS OF TABLE lt_iflotx
    FOR ALL ENTRIES IN lt_viqmel_fin
    WHERE tplnr = lt_viqmel_fin-tplnr
      AND spras = sy-langu.

  SORT lt_iflotx BY tplnr.

SELECT objnr parnr
  FROM ihpa
  INTO CORRESPONDING FIELDS OF TABLE lt_ihpa_kunnr
  FOR ALL ENTRIES IN lt_viqmel_fin
  WHERE objnr = lt_viqmel_fin-objnr.

  IF lt_ihpa_kunnr IS NOT INITIAL.

    SORT lt_ihpa_kunnr BY objnr parnr.
    DELETE ADJACENT DUPLICATES FROM lt_ihpa_kunnr COMPARING objnr parnr.
    DELETE lt_ihpa_kunnr WHERE parnr IS INITIAL.

    IF lt_ihpa_kunnr IS NOT INITIAL.

      SELECT kunnr name1 name2 stcd1 stcd2
        FROM kna1
        INTO CORRESPONDING FIELDS OF TABLE lt_kna1
        FOR ALL ENTRIES IN lt_ihpa_kunnr
        WHERE kunnr = lt_ihpa_kunnr-parnr.

      SORT lt_kna1 BY kunnr.

    ENDIF.

  ENDIF.

  "====================================================================
  " 5. Montagem da saída
  "====================================================================
  LOOP AT lt_viqmel_fin INTO wa_viqmel_fin.

    CLEAR: wa_orders,
           wa_jest,
           wa_tj02t,
           wa_eqkt,
           wa_equi,
           wa_iflotx,
           wa_ihpa_kunnr,
           wa_kna1,
           lv_status_final.

    "Prioridade 1: nota encerrada
    LOOP AT lt_jest INTO wa_jest
      WHERE objnr = wa_viqmel_fin-objnr
        AND ( stat = 'I0070'
           OR stat = 'I0072'
           OR stat = 'I0076' ).

      lv_status_final      = wa_jest-stat.
      wa_orders-status_rel = 'ENCERRADA'.
      EXIT.

    ENDLOOP.

    "Prioridade 2: nota aberta
    IF lv_status_final IS INITIAL.

      LOOP AT lt_jest INTO wa_jest
        WHERE objnr = wa_viqmel_fin-objnr
          AND ( stat = 'I0068'
             OR stat = 'I0069'
             OR stat = 'I0001'
             OR stat = 'I0002' ).

        lv_status_final      = wa_jest-stat.
        wa_orders-status_rel = 'ABERTA'.
        EXIT.

      ENDLOOP.

    ENDIF.

    "Fallback
    IF lv_status_final IS INITIAL.

      READ TABLE lt_jest INTO wa_jest
        WITH KEY objnr = wa_viqmel_fin-objnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        lv_status_final = wa_jest-stat.
      ENDIF.

      wa_orders-status_rel = 'OUTROS'.

    ENDIF.

    IF iv_status IS NOT INITIAL.

      IF iv_status = 'ABERTA'
         AND wa_orders-status_rel NE 'ABERTA'.
        CONTINUE.
      ELSEIF iv_status = 'ENCERRADA'
         AND wa_orders-status_rel NE 'ENCERRADA'.
        CONTINUE.
      ENDIF.

    ENDIF.

    IF lv_status_final IS NOT INITIAL.

      READ TABLE lt_tj02t INTO wa_tj02t
        WITH KEY istat = lv_status_final
        BINARY SEARCH.

      IF sy-subrc = 0.
        CONCATENATE wa_tj02t-txt04 ' - ' wa_tj02t-txt30
          INTO wa_orders-status_sistema.
      ENDIF.

    ENDIF.

    wa_orders-tipo        = 'N'.
    wa_orders-documento   = wa_viqmel_fin-qmnum.
    wa_orders-auart_qmart = wa_viqmel_fin-qmart.
    wa_orders-ktext       = wa_viqmel_fin-qmtxt.
    wa_orders-erdat       = wa_viqmel_fin-erdat.
    wa_orders-aufnr_rel   = wa_viqmel_fin-aufnr.
    wa_orders-equnr       = wa_viqmel_fin-equnr.
    wa_orders-tplnr       = wa_viqmel_fin-tplnr.

    READ TABLE lt_eqkt INTO wa_eqkt
      WITH KEY equnr = wa_viqmel_fin-equnr
      BINARY SEARCH.

    IF sy-subrc = 0.
      wa_orders-eqktx = wa_eqkt-eqktx.
    ENDIF.

    READ TABLE lt_equi INTO wa_equi
      WITH KEY equnr = wa_viqmel_fin-equnr
      BINARY SEARCH.

    IF sy-subrc = 0.
      wa_orders-invnr = wa_equi-invnr.
    ENDIF.

    READ TABLE lt_iflotx INTO wa_iflotx
      WITH KEY tplnr = wa_viqmel_fin-tplnr
      BINARY SEARCH.

    IF sy-subrc = 0.
      wa_orders-pltxt = wa_iflotx-pltxt.
    ENDIF.

    READ TABLE lt_ihpa_kunnr INTO wa_ihpa_kunnr
      WITH KEY objnr = wa_viqmel_fin-objnr
      BINARY SEARCH.

    IF sy-subrc = 0.

      READ TABLE lt_kna1 INTO wa_kna1
        WITH KEY kunnr = wa_ihpa_kunnr-parnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        wa_orders-kunnr = wa_kna1-kunnr.
        wa_orders-name1 = wa_kna1-name1.
        wa_orders-name2 = wa_kna1-name2.
        wa_orders-cnpj  = wa_kna1-stcd1.
        wa_orders-cpf   = wa_kna1-stcd2.
      ENDIF.

    ENDIF.

    IF wa_orders-documento IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-documento
        IMPORTING
          output = wa_orders-documento.
    ENDIF.

    IF wa_orders-equnr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-equnr
        IMPORTING
          output = wa_orders-equnr.
    ENDIF.

    IF wa_orders-aufnr_rel IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-aufnr_rel
        IMPORTING
          output = wa_orders-aufnr_rel.
    ENDIF.

    IF wa_orders-tplnr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
        EXPORTING
          input  = wa_orders-tplnr
        IMPORTING
          output = wa_orders-tplnr.
    ENDIF.

    APPEND wa_orders TO lt_orders_out.

  ENDLOOP.

  SORT lt_orders_out BY erdat DESCENDING.
  et_notas = lt_orders_out.

ENDMETHOD.


METHOD nota_ordem_cliente.

*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  STRING OPTIONAL
*"     VALUE(IV_CNPJ) TYPE  STRING OPTIONAL
*"     VALUE(IV_CPF) TYPE  STRING OPTIONAL
*"     VALUE(IV_KUNNR) TYPE  STRING OPTIONAL
*"     VALUE(IV_STATUS) TYPE  STRING OPTIONAL
*"     VALUE(IV_DADOS_ENDERECO) TYPE CHAR1 OPTIONAL " <-- ADICIONADO NA INTERFACE
*"  EXPORTING
*"     VALUE(ET_DADOS) TYPE  /PTLOMS/CT167
*"----------------------------------------------------------------------

  " --- TABELAS INTERNAS E WORK AREAS ---
  DATA: lt_notas  TYPE /ptloms/ct167,
        wa_nota   LIKE LINE OF lt_notas,
        lt_ordens TYPE /ptloms/ct167,
        wa_ordem  LIKE LINE OF lt_ordens.

  CLEAR et_dados.

  " =====================================================================
  " STEP 1: BUSCA TODAS AS NOTAS DO CLIENTE (Chamada Estática)
  " =====================================================================
  CALL METHOD /ptloms/cl013=>notas_por_cliente
    EXPORTING
      iv_name           = iv_name
      iv_cnpj           = iv_cnpj
      iv_cpf            = iv_cpf
      iv_kunnr          = iv_kunnr
      iv_status         = iv_status
      iv_dados_endereco = iv_dados_endereco " <-- REPASSANDO O PARÂMETRO AJUSTADO
    IMPORTING
      et_notas          = lt_notas.

  " =====================================================================
  " STEP 2: BUSCA TODAS AS ORDENS DO CLIENTE (Chamada Estática)
  " =====================================================================
  CALL METHOD /ptloms/cl013=>ordem_por_cliente
    EXPORTING
      iv_name           = iv_name
      iv_cnpj           = iv_cnpj
      iv_cpf            = iv_cpf
      iv_kunnr          = iv_kunnr
      iv_status         = iv_status
      iv_dados_endereco = iv_dados_endereco " <-- REPASSANDO O PARÂMETRO AJUSTADO
    IMPORTING
      et_orders         = lt_ordens.

  " =====================================================================
  " STEP 3: FILTRAGEM / DE-DUPLICAÇÃO DE ORDENS RELACIONADAS
  " =====================================================================
  IF lt_notas IS NOT INITIAL AND lt_ordens IS NOT INITIAL.

    " Ordenamos por aufnr_rel para otimizar a leitura interna
    SORT lt_notas BY aufnr_rel.

    LOOP AT lt_ordens INTO wa_ordem.

      " Verifica se a ordem corrente já está vinculada a alguma nota
      " Usando BINARY SEARCH para performance máxima na linha do tempo
      READ TABLE lt_notas WITH KEY aufnr_rel = wa_ordem-documento
                 TRANSPORTING NO FIELDS BINARY SEARCH.

      " Se encontrou, elimina a ordem solta do lote para evitar duplicidade na tela
      IF sy-subrc = 0.
        " CORRIGIDO: Exclusão cirúrgica baseada no índice do loop atual (Evita quebra de paginação do LOOP)
        DELETE lt_ordens INDEX sy-tabix.
      ENDIF.

    ENDLOOP.

  ENDIF.

  " =====================================================================
  " STEP 4: CONSOLIDAR E GERAR LINHA DO TEMPO CRONOLÓGICA
  " =====================================================================
  IF lt_notas IS NOT INITIAL.
    APPEND LINES OF lt_notas TO et_dados.
  ENDIF.

  IF lt_ordens IS NOT INITIAL.
    APPEND LINES OF lt_ordens TO et_dados.
  ENDIF.

  " Ordenação cronológica unificada
  SORT et_dados BY erdat DESCENDING.

ENDMETHOD.


METHOD nota_ordem_equipamento_local.

*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_EQUNR)  TYPE EQUI-EQUNR OPTIONAL
*"     VALUE(IV_EQKTX)  TYPE EQKT-EQKTX OPTIONAL
*"     VALUE(IV_INVNR)  TYPE EQUI-INVNR OPTIONAL
*"     VALUE(IV_TPLNR)  TYPE IFLOT-TPLNR OPTIONAL
*"     VALUE(IV_PLTXT)  TYPE IFLOTX-PLTXT OPTIONAL
*"     VALUE(IV_STATUS) TYPE STRING OPTIONAL
*"  EXPORTING
*"     VALUE(ET_DADOS) TYPE /PTLOMS/CT167
*"----------------------------------------------------------------------

  DATA: lt_notas        TYPE /ptloms/ct167,
        lt_ordens       TYPE /ptloms/ct167,
        lt_ordens_final TYPE /ptloms/ct167,
        wa_ordem        LIKE LINE OF lt_ordens.

  CLEAR et_dados.

  IF iv_equnr IS INITIAL
     AND iv_eqktx IS INITIAL
     AND iv_invnr IS INITIAL
     AND iv_tplnr IS INITIAL
     AND iv_pltxt IS INITIAL.
    RETURN.
  ENDIF.

  "====================================================================
  " STEP 1: Busca notas por equipamento/local
  "====================================================================
  CALL METHOD /ptloms/cl013=>notas_por_equipamento_local
    EXPORTING
      iv_equnr  = iv_equnr
      iv_eqktx  = iv_eqktx
      iv_invnr  = iv_invnr
      iv_tplnr  = iv_tplnr
      iv_pltxt  = iv_pltxt
      iv_status = iv_status
    IMPORTING
      et_notas  = lt_notas.

  "====================================================================
  " STEP 2: Busca ordens por equipamento/local
  "====================================================================
  CALL METHOD /ptloms/cl013=>ordens_por_equipamento_local
    EXPORTING
      iv_equnr  = iv_equnr
      iv_eqktx  = iv_eqktx
      iv_invnr  = iv_invnr
      iv_tplnr  = iv_tplnr
      iv_pltxt  = iv_pltxt
      iv_status = iv_status
    IMPORTING
      et_orders = lt_ordens.

  "====================================================================
  " STEP 3: Remove ordens já vinculadas a notas
  "====================================================================
  IF lt_notas IS NOT INITIAL
     AND lt_ordens IS NOT INITIAL.

    SORT lt_notas BY aufnr_rel.

    LOOP AT lt_ordens INTO wa_ordem.

      READ TABLE lt_notas
        WITH KEY aufnr_rel = wa_ordem-documento
        TRANSPORTING NO FIELDS
        BINARY SEARCH.

      IF sy-subrc <> 0.
        APPEND wa_ordem TO lt_ordens_final.
      ENDIF.

    ENDLOOP.

    lt_ordens = lt_ordens_final.

  ENDIF.

  "====================================================================
  " STEP 4: Consolida notas + ordens
  "====================================================================
  IF lt_notas IS NOT INITIAL.
    APPEND LINES OF lt_notas TO et_dados.
  ENDIF.

  IF lt_ordens IS NOT INITIAL.
    APPEND LINES OF lt_ordens TO et_dados.
  ENDIF.

  SORT et_dados BY erdat DESCENDING.

ENDMETHOD.


METHOD obter_detalhe_nota.

*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_QMNUM) TYPE  VIQMEL-QMNUM
*"  EXPORTING
*"     VALUE(ES_NOTA) TYPE  /PTLOMS/ET199
*"----------------------------------------------------------------------

  TYPES: BEGIN OF ty_viqmel,
           qmnum  TYPE viqmel-qmnum,
           qmart  TYPE viqmel-qmart,
           qmtxt  TYPE viqmel-qmtxt,
           erdat  TYPE viqmel-erdat,
           erzeit TYPE viqmel-erzeit,
           ernam  TYPE viqmel-ernam,
           objnr  TYPE viqmel-objnr,
         END OF ty_viqmel.

  TYPES: BEGIN OF ty_jest,
           stat TYPE jest-stat,
         END OF ty_jest.

  TYPES: BEGIN OF ty_tj02t,
           istat TYPE tj02t-istat,
           txt04 TYPE tj02t-txt04,
           txt30 TYPE tj02t-txt30,
         END OF ty_tj02t.

  TYPES: BEGIN OF ty_jcds,
           udate TYPE jcds-udate,
           utime TYPE jcds-utime,
         END OF ty_jcds.

  DATA:
    lv_qmnum        TYPE viqmel-qmnum,
    wa_viqmel       TYPE ty_viqmel,
    lt_jest         TYPE STANDARD TABLE OF ty_jest,
    wa_jest         TYPE ty_jest,
    lt_tj02t        TYPE STANDARD TABLE OF ty_tj02t,
    wa_tj02t        TYPE ty_tj02t,
    lv_status_sist  TYPE string,
    lv_status_final TYPE jest-stat,
    lt_jcds         TYPE STANDARD TABLE OF ty_jcds,
    wa_jcds         TYPE ty_jcds.

  CLEAR es_nota.

  IF iv_qmnum IS INITIAL.
    RETURN.
  ENDIF.

  lv_qmnum = iv_qmnum.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_qmnum
    IMPORTING
      output = lv_qmnum.

  SELECT SINGLE
         qmnum
         qmart
         qmtxt
         erdat
         erzeit
         ernam
         objnr
    FROM viqmel
    INTO CORRESPONDING FIELDS OF wa_viqmel
    WHERE qmnum = lv_qmnum.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  es_nota-tipo       = 'NOTA'.
  es_nota-docnum     = wa_viqmel-qmnum.
  es_nota-doctipo    = wa_viqmel-qmart.
  es_nota-docdesc    = wa_viqmel-qmtxt.
  es_nota-data_cria  = wa_viqmel-erdat.
  es_nota-hora_cria  = wa_viqmel-erzeit.
  es_nota-criado_por = wa_viqmel-ernam.

  TRY.

      SELECT SINGLE txt
        FROM ('TQ80T')
        INTO es_nota-doctipodesc
        WHERE qmart = wa_viqmel-qmart
          AND spras = sy-langu.

    CATCH cx_sy_dynamic_osql_error.

      TRY.

          SELECT SINGLE qartx
            FROM ('TQART')
            INTO es_nota-doctipodesc
            WHERE qmart = wa_viqmel-qmart
              AND spras = sy-langu.

        CATCH cx_sy_dynamic_osql_error.
          es_nota-doctipodesc = wa_viqmel-qmart.
      ENDTRY.

  ENDTRY.

  IF es_nota-doctipodesc IS INITIAL.
    es_nota-doctipodesc = wa_viqmel-qmart.
  ENDIF.

  IF wa_viqmel-objnr IS NOT INITIAL.

    SELECT stat
      FROM jest
      INTO TABLE lt_jest
      WHERE objnr = wa_viqmel-objnr
        AND inact = space.

    SORT lt_jest BY stat.

  ENDIF.

  IF lt_jest IS NOT INITIAL.

    SELECT istat txt04 txt30
      FROM tj02t
      INTO TABLE lt_tj02t
      FOR ALL ENTRIES IN lt_jest
      WHERE istat = lt_jest-stat
        AND spras = sy-langu.

    SORT lt_tj02t BY istat.

  ENDIF.

  CLEAR:
    lv_status_sist,
    lv_status_final.

  LOOP AT lt_jest INTO wa_jest.

    READ TABLE lt_tj02t INTO wa_tj02t
      WITH KEY istat = wa_jest-stat
      BINARY SEARCH.

    IF sy-subrc = 0.

      IF lv_status_sist IS INITIAL.
        lv_status_sist = wa_tj02t-txt04.
      ELSE.
        CONCATENATE lv_status_sist
                    wa_tj02t-txt04
               INTO lv_status_sist
          SEPARATED BY space.
      ENDIF.

    ENDIF.

  ENDLOOP.

  es_nota-status_sistema = lv_status_sist.

  "Prioridade 1: nota encerrada
  LOOP AT lt_jest INTO wa_jest
    WHERE stat = 'I0070'
       OR stat = 'I0072'
       OR stat = 'I0076'.

    lv_status_final        = wa_jest-stat.
    es_nota-status_usuario = 'ENCERRADA'.
    EXIT.

  ENDLOOP.

  "Prioridade 2: nota aberta
  IF lv_status_final IS INITIAL.

    LOOP AT lt_jest INTO wa_jest
      WHERE stat = 'I0068'
         OR stat = 'I0069'
         OR stat = 'I0001'
         OR stat = 'I0002'.

      lv_status_final        = wa_jest-stat.
      es_nota-status_usuario = 'ABERTA'.
      EXIT.

    ENDLOOP.

  ENDIF.

  "Fallback
  IF lv_status_final IS INITIAL.
    es_nota-status_usuario = 'OUTROS'.
  ENDIF.

  CLEAR:
    es_nota-data_fim,
    es_nota-hora_fim.

  IF es_nota-status_usuario = 'ENCERRADA'
     AND wa_viqmel-objnr IS NOT INITIAL
     AND lv_status_final IS NOT INITIAL.

    SELECT udate
           utime
      FROM jcds
      INTO TABLE lt_jcds
      WHERE objnr = wa_viqmel-objnr
        AND stat  = lv_status_final
        AND inact = space.

    IF lt_jcds IS INITIAL.

      SELECT udate
             utime
        FROM jcds
        INTO TABLE lt_jcds
        WHERE objnr = wa_viqmel-objnr
          AND stat  = lv_status_final.

    ENDIF.

    IF lt_jcds IS NOT INITIAL.

      SORT lt_jcds BY
        udate DESCENDING
        utime DESCENDING.

      READ TABLE lt_jcds INTO wa_jcds INDEX 1.

      IF sy-subrc = 0.
        es_nota-data_fim = wa_jcds-udate.
        es_nota-hora_fim = wa_jcds-utime.
      ENDIF.

    ENDIF.

  ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = es_nota-docnum
    IMPORTING
      output = es_nota-docnum.

  CONCATENATE 'N-'
              es_nota-docnum
         INTO es_nota-chave.

ENDMETHOD.


METHOD obter_detalhe_ordem.

  TYPES: BEGIN OF ty_aufk,
           aufnr   TYPE aufk-aufnr,
           auart   TYPE aufk-auart,
           ktext   TYPE aufk-ktext,
           erdat   TYPE aufk-erdat,
           erfzeit TYPE aufk-erfzeit,
           ernam   TYPE aufk-ernam,
           idat2   TYPE aufk-idat2,
           objnr   TYPE aufk-objnr,
         END OF ty_aufk.

  TYPES: BEGIN OF ty_jest,
           stat TYPE jest-stat,
         END OF ty_jest.

  TYPES: BEGIN OF ty_tj02t,
           istat TYPE tj02t-istat,
           txt04 TYPE tj02t-txt04,
           txt30 TYPE tj02t-txt30,
         END OF ty_tj02t.

  TYPES: BEGIN OF ty_jcds,
           udate TYPE jcds-udate,
           utime TYPE jcds-utime,
         END OF ty_jcds.

  DATA: lv_aufnr        TYPE aufk-aufnr,
        wa_aufk         TYPE ty_aufk,
        lt_jest         TYPE STANDARD TABLE OF ty_jest,
        wa_jest         TYPE ty_jest,
        lt_tj02t        TYPE STANDARD TABLE OF ty_tj02t,
        wa_tj02t        TYPE ty_tj02t,
        lt_jcds         TYPE STANDARD TABLE OF ty_jcds,
        wa_jcds         TYPE ty_jcds,
        lv_status_sist  TYPE string,
        lv_status_final TYPE jest-stat.

  CLEAR es_ordem.

  IF iv_aufnr IS INITIAL.
    RETURN.
  ENDIF.

  lv_aufnr = iv_aufnr.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_aufnr
    IMPORTING
      output = lv_aufnr.

  SELECT SINGLE aufnr
                auart
                ktext
                erdat
                erfzeit
                ernam
                idat2
                objnr
    FROM aufk
    INTO CORRESPONDING FIELDS OF wa_aufk
    WHERE aufnr = lv_aufnr.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  es_ordem-tipo       = 'ORDEM'.
  es_ordem-docnum     = wa_aufk-aufnr.
  es_ordem-doctipo    = wa_aufk-auart.
  es_ordem-docdesc    = wa_aufk-ktext.
  es_ordem-data_cria  = wa_aufk-erdat.
  es_ordem-hora_cria  = wa_aufk-erfzeit.
  es_ordem-criado_por = wa_aufk-ernam.

  TRY.

      SELECT SINGLE txt
        FROM ('T003P')
        INTO es_ordem-doctipodesc
        WHERE auart = wa_aufk-auart
          AND spras = sy-langu.

    CATCH cx_sy_dynamic_osql_error.
      es_ordem-doctipodesc = wa_aufk-auart.

  ENDTRY.

  IF es_ordem-doctipodesc IS INITIAL.
    es_ordem-doctipodesc = wa_aufk-auart.
  ENDIF.

  IF wa_aufk-objnr IS NOT INITIAL.

    SELECT stat
      FROM jest
      INTO TABLE lt_jest
      WHERE objnr = wa_aufk-objnr
        AND inact = space.

    SORT lt_jest BY stat.

  ENDIF.

  IF lt_jest IS NOT INITIAL.

    SELECT istat
           txt04
           txt30
      FROM tj02t
      INTO TABLE lt_tj02t
      FOR ALL ENTRIES IN lt_jest
      WHERE istat = lt_jest-stat
        AND spras = sy-langu.

    SORT lt_tj02t BY istat.

  ENDIF.

  CLEAR: lv_status_sist,
         lv_status_final.

  LOOP AT lt_jest INTO wa_jest.

    READ TABLE lt_tj02t INTO wa_tj02t
      WITH KEY istat = wa_jest-stat
      BINARY SEARCH.

    IF sy-subrc = 0.

      IF lv_status_sist IS INITIAL.
        lv_status_sist = wa_tj02t-txt04.
      ELSE.
        CONCATENATE lv_status_sist
                    wa_tj02t-txt04
               INTO lv_status_sist
          SEPARATED BY space.
      ENDIF.

    ENDIF.

  ENDLOOP.

  es_ordem-status_sistema = lv_status_sist.

  "Prioridade 1: ordem encerrada - TECO / CLSD
  LOOP AT lt_jest INTO wa_jest
    WHERE stat = 'I0045'
       OR stat = 'I0046'.

    lv_status_final          = wa_jest-stat.
    es_ordem-status_usuario  = 'ENCERRADA'.
    EXIT.

  ENDLOOP.

  "Prioridade 2: ordem aberta
  IF lv_status_final IS INITIAL.

    LOOP AT lt_jest INTO wa_jest
      WHERE stat = 'I0001'
         OR stat = 'I0002'.

      lv_status_final         = wa_jest-stat.
      es_ordem-status_usuario = 'ABERTA'.
      EXIT.

    ENDLOOP.

  ENDIF.

  "Fallback
  IF lv_status_final IS INITIAL.
    es_ordem-status_usuario = 'OUTROS'.
  ENDIF.

  CLEAR: es_ordem-data_fim,
         es_ordem-hora_fim.

  IF es_ordem-status_usuario = 'ENCERRADA'
     AND wa_aufk-objnr IS NOT INITIAL
     AND lv_status_final IS NOT INITIAL.

    SELECT udate
           utime
      FROM jcds
      INTO TABLE lt_jcds
      WHERE objnr = wa_aufk-objnr
        AND stat  = lv_status_final
        AND inact = space.

    IF lt_jcds IS INITIAL.

      SELECT udate
             utime
        FROM jcds
        INTO TABLE lt_jcds
        WHERE objnr = wa_aufk-objnr
          AND stat  = lv_status_final.

    ENDIF.

    IF lt_jcds IS NOT INITIAL.

      SORT lt_jcds BY udate DESCENDING
                      utime DESCENDING.

      READ TABLE lt_jcds INTO wa_jcds INDEX 1.

      IF sy-subrc = 0.
        es_ordem-data_fim = wa_jcds-udate.
        es_ordem-hora_fim = wa_jcds-utime.
      ENDIF.

    ENDIF.

    IF es_ordem-data_fim IS INITIAL
       AND wa_aufk-idat2 IS NOT INITIAL.
      es_ordem-data_fim = wa_aufk-idat2.
    ENDIF.

  ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = es_ordem-docnum
    IMPORTING
      output = es_ordem-docnum.

  CONCATENATE 'O-'
              es_ordem-docnum
         INTO es_ordem-chave.

ENDMETHOD.


METHOD obter_operacoes_ordem.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_AUFNR) TYPE  AUFK-AUFNR
*"  EXPORTING
*"     VALUE(ET_OPERACOES) TYPE  /PTLOMS/CT169
*"----------------------------------------------------------------------

  " --- TIPOS LOCAIS ---
  TYPES: BEGIN OF ty_afvc,
           aufpl TYPE afvc-aufpl,
           aplzl TYPE afvc-aplzl,
           vornr TYPE afvc-vornr,
           ltxa1 TYPE afvc-ltxa1,
           objnr TYPE afvc-objnr,
         END OF ty_afvc.

  TYPES: BEGIN OF ty_jest,
           objnr TYPE jest-objnr,
           stat  TYPE jest-stat,
         END OF ty_jest.

  TYPES: BEGIN OF ty_tj02t,
           istat TYPE tj02t-istat,
           txt04 TYPE tj02t-txt04,
         END OF ty_tj02t.

  TYPES: BEGIN OF ty_objnr,
           objnr TYPE jest-objnr,
         END OF ty_objnr.

  " --- VARIÁVEIS ---
  DATA: lv_aufnr       TYPE aufk-aufnr,
        lv_aufpl       TYPE afko-aufpl,
        lt_afvc        TYPE STANDARD TABLE OF ty_afvc,
        wa_afvc        TYPE ty_afvc,
        lt_objnr_wrk   TYPE STANDARD TABLE OF ty_objnr,
        wa_objnr_wrk   TYPE ty_objnr,
        lt_jest        TYPE STANDARD TABLE OF ty_jest,
        wa_jest        TYPE ty_jest,
        lt_istat       TYPE STANDARD TABLE OF tj02t-istat,
        lv_istat       TYPE tj02t-istat,
        lt_tj02t       TYPE STANDARD TABLE OF ty_tj02t,
        wa_tj02t       TYPE ty_tj02t,
        wa_operacao    TYPE /ptloms/et199,
        lv_status_sist TYPE string,
        lv_encerrada   TYPE abap_bool,
        lv_docnum_fmt  TYPE afvc-vornr,
        lv_aufnr_fmt   TYPE aufk-aufnr,
        lv_data_min    TYPE dats,
        lv_data_max    TYPE dats,
        lv_total_reg   TYPE i,
        lv_final_reg   TYPE i,
        lt_tb066       TYPE TABLE OF /ptloms/tb066,
        ls_tb066       TYPE /ptloms/tb066,
        " Variáveis auxiliares para normalização
        lv_aufnr_tb    TYPE aufk-aufnr,
        lv_vornr_tb    TYPE afvc-vornr.

  DATA:
    lv_hora_min TYPE tims,
    lv_hora_max TYPE tims.

  CLEAR et_operacoes.

  IF iv_aufnr IS INITIAL. RETURN. ENDIF.

  lv_aufnr = iv_aufnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_aufnr
    IMPORTING
      output = lv_aufnr.

  SELECT SINGLE aufpl FROM afko INTO lv_aufpl WHERE aufnr = lv_aufnr.
  IF sy-subrc NE 0. RETURN. ENDIF.

  SELECT aufpl aplzl vornr ltxa1 objnr FROM afvc INTO TABLE lt_afvc WHERE aufpl = lv_aufpl.
  IF sy-subrc NE 0. RETURN. ENDIF.

  LOOP AT lt_afvc INTO wa_afvc.
    IF wa_afvc-objnr IS NOT INITIAL.
      wa_objnr_wrk-objnr = wa_afvc-objnr.
      APPEND wa_objnr_wrk TO lt_objnr_wrk.
    ENDIF.
  ENDLOOP.

  IF lt_objnr_wrk IS NOT INITIAL.
    SELECT objnr stat FROM jest INTO TABLE lt_jest FOR ALL ENTRIES IN lt_objnr_wrk
      WHERE objnr = lt_objnr_wrk-objnr AND inact = ' '.

    LOOP AT lt_jest INTO wa_jest. APPEND wa_jest-stat TO lt_istat. ENDLOOP.
    SORT lt_istat. DELETE ADJACENT DUPLICATES FROM lt_istat.

    IF lt_istat IS NOT INITIAL.
      SELECT istat txt04 FROM tj02t INTO TABLE lt_tj02t FOR ALL ENTRIES IN lt_istat
        WHERE istat = lt_istat-table_line AND spras = sy-langu.
    ENDIF.
  ENDIF.

  lv_aufnr_fmt = iv_aufnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = lv_aufnr_fmt
    IMPORTING
      output = lv_aufnr_fmt.

  LOOP AT lt_afvc INTO wa_afvc.
    CLEAR wa_operacao.
    wa_operacao-tipo    = 'OPERACAO'.
    wa_operacao-doctipo = wa_afvc-aplzl.
    wa_operacao-docnum  = wa_afvc-vornr.
    wa_operacao-docdesc = wa_afvc-ltxa1.

    " --- Normalização para busca na TB066 ---
    lv_aufnr_tb = lv_aufnr. " Já está com Alpha input
    lv_vornr_tb = wa_afvc-vornr.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_vornr_tb
      IMPORTING
        output = lv_vornr_tb.

    " A. Lógica TB066
    SELECT * FROM /ptloms/tb066 INTO TABLE lt_tb066
      WHERE aufnr = lv_aufnr_tb AND vornr = lv_vornr_tb.

    lv_total_reg = 0.
    lv_final_reg = 0.

    CLEAR:
      lv_data_min,
      lv_hora_min,
      lv_data_max,
      lv_hora_max.

    LOOP AT lt_tb066 INTO ls_tb066.

      lv_total_reg = lv_total_reg + 1.

      IF ls_tb066-datadessac IS NOT INITIAL.
        lv_final_reg = lv_final_reg + 1.
      ENDIF.

      " Menor data/hora de criação
      IF ls_tb066-datacriacao IS NOT INITIAL.

        IF lv_data_min IS INITIAL
        OR ls_tb066-datacriacao < lv_data_min
        OR ( ls_tb066-datacriacao = lv_data_min
             AND ls_tb066-horacriacao < lv_hora_min ).

          lv_data_min = ls_tb066-datacriacao.
          lv_hora_min = ls_tb066-horacriacao.

        ENDIF.

      ENDIF.

      " Maior data/hora de encerramento
      IF ls_tb066-datadessac IS NOT INITIAL.

        IF lv_data_max IS INITIAL
        OR ls_tb066-datadessac > lv_data_max
        OR ( ls_tb066-datadessac = lv_data_max
             AND ls_tb066-horadessac > lv_hora_max ).

          lv_data_max = ls_tb066-datadessac.
          lv_hora_max = ls_tb066-horadessac.

        ENDIF.

      ENDIF.

    ENDLOOP.

    wa_operacao-data_cria = lv_data_min.
    wa_operacao-hora_cria = lv_hora_min.

    wa_operacao-data_fim  = lv_data_max.
    wa_operacao-hora_fim  = lv_hora_max.

    " B. Processa Status de Sistema
    lv_encerrada = abap_false.
    CLEAR lv_status_sist.
    LOOP AT lt_jest INTO wa_jest WHERE objnr = wa_afvc-objnr.
      IF wa_jest-stat = 'I0045' OR wa_jest-stat = 'I0046'. lv_encerrada = abap_true. ENDIF.
      READ TABLE lt_tj02t INTO wa_tj02t WITH KEY istat = wa_jest-stat.
      IF sy-subrc = 0.
        IF lv_status_sist IS INITIAL.
          lv_status_sist = wa_tj02t-txt04.
        ELSE.
          CONCATENATE lv_status_sist wa_tj02t-txt04 INTO lv_status_sist SEPARATED BY space.
        ENDIF.
      ENDIF.
    ENDLOOP.
    wa_operacao-status_sistema = lv_status_sist.

    " C. Define Status Usuário
    IF lv_total_reg > 0 AND lv_total_reg = lv_final_reg.
      wa_operacao-status_usuario = 'ENCERRADA'.
    ELSEIF lv_encerrada = abap_true.
      wa_operacao-status_usuario = 'ENCERRADA'.
    ELSE.
      wa_operacao-status_usuario = 'ABERTA'.
    ENDIF.

    lv_docnum_fmt = wa_afvc-vornr.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_docnum_fmt
      IMPORTING
        output = lv_docnum_fmt.

    wa_operacao-docnum = lv_docnum_fmt.
    CONCATENATE 'OP-' lv_aufnr_fmt '-' lv_docnum_fmt INTO wa_operacao-chave.
    APPEND wa_operacao TO et_operacoes.
  ENDLOOP.

ENDMETHOD.


METHOD obter_timeline_completa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_QMNUM) TYPE  VIQMEL-QMNUM OPTIONAL
*"     VALUE(IV_AUFNR) TYPE  AUFK-AUFNR OPTIONAL
*"  EXPORTING
*"     VALUE(ET_TIMELINE) TYPE  /PTLOMS/CT169
*"----------------------------------------------------------------------

  DATA: ls_nota      TYPE /ptloms/et199,
        ls_ordem     TYPE /ptloms/et199,
        lt_operacoes TYPE /ptloms/ct169,
        ls_operacao  TYPE /ptloms/et199.

  CLEAR et_timeline.

  " 1. Buscar Nota (se informado)
  IF iv_qmnum IS NOT INITIAL.
    " Chamada estática usando o nome da classe
    /ptloms/cl013=>obter_detalhe_nota(
      EXPORTING iv_qmnum = iv_qmnum
      IMPORTING es_nota  = ls_nota ).

    IF ls_nota-docnum IS NOT INITIAL.
      APPEND ls_nota TO et_timeline.
    ENDIF.
  ENDIF.

  " 2. Buscar Ordem (se informado)
  IF iv_aufnr IS NOT INITIAL.
    " Chamada estática usando o nome da classe
    /ptloms/cl013=>obter_detalhe_ordem(
      EXPORTING iv_aufnr = iv_aufnr
      IMPORTING es_ordem = ls_ordem ).

    IF ls_ordem-docnum IS NOT INITIAL.
      APPEND ls_ordem TO et_timeline.
    ENDIF.

    " 3. Buscar Operações da Ordem
    /ptloms/cl013=>obter_operacoes_ordem(
      EXPORTING iv_aufnr     = iv_aufnr
      IMPORTING et_operacoes = lt_operacoes ).

    APPEND LINES OF lt_operacoes TO et_timeline.
  ENDIF.

  " Ordenar a Timeline por data de criação para o Fiori exibir corretamente
  SORT et_timeline BY data_cria ASCENDING.

ENDMETHOD.


METHOD obter_timeline_fiori.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_QMNUM) TYPE  VIQMEL-QMNUM OPTIONAL
*"     VALUE(IV_AUFNR) TYPE  AUFK-AUFNR OPTIONAL
*"  EXPORTING
*"     VALUE(ET_TIMELINE) TYPE  /PTLOMS/CT169
*"----------------------------------------------------------------------

  DATA:
    lt_operacoes TYPE /ptloms/ct169,
    ls_nota      TYPE /ptloms/et199,
    ls_ordem     TYPE /ptloms/et199,
    ls_item      TYPE /ptloms/et199,
    ls_operacao  TYPE /ptloms/et199.

  CLEAR et_timeline.

  "====================================================================
  " 1. NOTA
  "====================================================================
  IF iv_qmnum IS NOT INITIAL.

    /ptloms/cl013=>obter_detalhe_nota(
      EXPORTING
        iv_qmnum = iv_qmnum
      IMPORTING
        es_nota  = ls_nota ).

    IF ls_nota-docnum IS NOT INITIAL.

      " Evento de abertura
      CLEAR ls_item.
      ls_item = ls_nota.

      ls_item-status_usuario = 'ABERTA'.
      ls_item-chave          = '1-N-0'.

      APPEND ls_item TO et_timeline.

      " Evento de encerramento
      IF ls_nota-status_usuario = 'ENCERRADA'
      AND ls_nota-data_fim IS NOT INITIAL.

        CLEAR ls_item.
        ls_item = ls_nota.

        ls_item-status_usuario = 'ENCERRADA'.
        ls_item-data_cria      = ls_nota-data_fim.
        ls_item-hora_cria      = ls_nota-hora_fim.
        ls_item-docdesc        = 'Nota encerrada'.
        ls_item-chave          = '6-N-1'.

        APPEND ls_item TO et_timeline.

      ENDIF.

    ENDIF.

  ENDIF.

  "====================================================================
  " 2. ORDEM
  "====================================================================
  IF iv_aufnr IS NOT INITIAL.

    /ptloms/cl013=>obter_detalhe_ordem(
      EXPORTING
        iv_aufnr = iv_aufnr
      IMPORTING
        es_ordem = ls_ordem ).

    IF ls_ordem-docnum IS NOT INITIAL.

      " Evento de abertura
      CLEAR ls_item.
      ls_item = ls_ordem.

      ls_item-status_usuario = 'ABERTA'.
      ls_item-chave          = '2-O-0'.

      APPEND ls_item TO et_timeline.

      " Evento de encerramento
      IF ls_ordem-status_usuario = 'ENCERRADA'
      AND ls_ordem-data_fim IS NOT INITIAL.

        CLEAR ls_item.
        ls_item = ls_ordem.

        ls_item-status_usuario = 'ENCERRADA'.
        ls_item-data_cria      = ls_ordem-data_fim.
        ls_item-hora_cria      = ls_ordem-hora_fim.
        ls_item-docdesc        = 'Ordem encerrada'.
        ls_item-chave          = '5-O-1'.

        APPEND ls_item TO et_timeline.

      ENDIF.

    ENDIF.

    "==================================================================
    " 3. OPERAÇÕES
    "==================================================================
    /ptloms/cl013=>obter_operacoes_ordem(
      EXPORTING
        iv_aufnr     = iv_aufnr
      IMPORTING
        et_operacoes = lt_operacoes ).

    LOOP AT lt_operacoes INTO ls_operacao.

      " Evento de abertura
      CLEAR ls_item.
      ls_item = ls_operacao.

      ls_item-status_usuario = 'ABERTA'.
      ls_item-chave          = '3-P-0'.

      APPEND ls_item TO et_timeline.

      " Evento de encerramento
      IF ls_operacao-data_fim IS NOT INITIAL.

        CLEAR ls_item.
        ls_item = ls_operacao.

        ls_item-status_usuario = 'ENCERRADA'.
        ls_item-data_cria      = ls_operacao-data_fim.
        ls_item-hora_cria      = ls_operacao-hora_fim.
        ls_item-docdesc        = 'Operação encerrada'.
        ls_item-chave          = '4-P-1'.

        APPEND ls_item TO et_timeline.

      ENDIF.

    ENDLOOP.

  ENDIF.

  "====================================================================
  " 4. ORDENAÇÃO CRONOLÓGICA
  "====================================================================
  SORT et_timeline BY
    data_cria ASCENDING
    hora_cria ASCENDING
    chave     ASCENDING.

ENDMETHOD.


METHOD ordem_por_cliente.

*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  STRING OPTIONAL
*"     VALUE(IV_CNPJ) TYPE  STRING OPTIONAL
*"     VALUE(IV_CPF) TYPE  STRING OPTIONAL
*"     VALUE(IV_KUNNR) TYPE  STRING OPTIONAL
*"     VALUE(IV_STATUS) TYPE  STRING OPTIONAL
*"     VALUE(IV_DADOS_ENDERECO) TYPE CHAR1 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_ORDERS) TYPE  /PTLOMS/CT167
*"----------------------------------------------------------------------

  TYPES: BEGIN OF ty_kunnr,
           kunnr TYPE kna1-kunnr,
         END OF ty_kunnr.

  TYPES: BEGIN OF ty_equnr,
           equnr TYPE eqbs-equnr,
         END OF ty_equnr.

  TYPES: BEGIN OF ty_aufk_data,
           aufnr TYPE aufk-aufnr,
           auart TYPE aufk-auart,
           ktext TYPE aufk-ktext,
           erdat TYPE aufk-erdat,
           equnr TYPE afih-equnr,
           tplnr TYPE iloa-tplnr,
           objnr TYPE aufk-objnr,
         END OF ty_aufk_data.

  TYPES: BEGIN OF ty_jest,
           objnr TYPE jest-objnr,
           stat  TYPE jest-stat,
         END OF ty_jest.

  TYPES: BEGIN OF ty_eqkt,
           equnr TYPE eqkt-equnr,
           eqktx TYPE eqkt-eqktx,
         END OF ty_eqkt.

  TYPES: BEGIN OF ty_equi,
           equnr TYPE equi-equnr,
           invnr TYPE equi-invnr,
         END OF ty_equi.

  TYPES: BEGIN OF ty_iflotx,
           tplnr TYPE iflotx-tplnr,
           pltxt TYPE iflotx-pltxt,
         END OF ty_iflotx.

  TYPES: BEGIN OF ty_tj02t,
           istat TYPE tj02t-istat,
           txt04 TYPE tj02t-txt04,
           txt30 TYPE tj02t-txt30,
         END OF ty_tj02t.

  DATA: lt_clientes     TYPE /ptloms/ct168,
        wa_cliente      LIKE LINE OF lt_clientes,
        lt_kunnr        TYPE STANDARD TABLE OF ty_kunnr,
        wa_kunnr        TYPE ty_kunnr,
        lt_eqbs         TYPE STANDARD TABLE OF ty_equnr,

        lt_aufk_fin     TYPE STANDARD TABLE OF ty_aufk_data,
        wa_aufk_fin     TYPE ty_aufk_data,

        lt_jest         TYPE STANDARD TABLE OF ty_jest,
        wa_jest         TYPE ty_jest,

        lt_eqkt         TYPE STANDARD TABLE OF ty_eqkt,
        wa_eqkt         TYPE ty_eqkt,

        lt_equi         TYPE STANDARD TABLE OF ty_equi,
        wa_equi         TYPE ty_equi,

        lt_iflotx       TYPE STANDARD TABLE OF ty_iflotx,
        wa_iflotx       TYPE ty_iflotx,

        lt_tj02t        TYPE STANDARD TABLE OF ty_tj02t,
        wa_tj02t        TYPE ty_tj02t,

        lt_orders_out   TYPE /ptloms/ct167,
        wa_orders       LIKE LINE OF lt_orders_out,

        lv_status_final TYPE jest-stat.

  CLEAR et_orders.

  CALL METHOD /ptloms/cl013=>buscar_clientes
    EXPORTING
      iv_name           = iv_name
      iv_cnpj           = iv_cnpj
      iv_cpf            = iv_cpf
      iv_kunnr          = iv_kunnr
      iv_dados_endereco = iv_dados_endereco
    IMPORTING
      et_clientes       = lt_clientes.

  IF lt_clientes IS INITIAL.
    RETURN.
  ENDIF.

  LOOP AT lt_clientes INTO wa_cliente.
    CLEAR wa_kunnr.
    wa_kunnr-kunnr = wa_cliente-kunnr.
    APPEND wa_kunnr TO lt_kunnr.
  ENDLOOP.

  SORT lt_kunnr BY kunnr.
  DELETE ADJACENT DUPLICATES FROM lt_kunnr COMPARING kunnr.
  DELETE lt_kunnr WHERE kunnr IS INITIAL.

  IF lt_kunnr IS INITIAL.
    RETURN.
  ENDIF.

  SELECT equnr
    FROM eqbs
    INTO CORRESPONDING FIELDS OF TABLE lt_eqbs
    FOR ALL ENTRIES IN lt_kunnr
    WHERE kunnr = lt_kunnr-kunnr.

  IF lt_eqbs IS NOT INITIAL.
    SORT lt_eqbs BY equnr.
    DELETE ADJACENT DUPLICATES FROM lt_eqbs COMPARING equnr.
    DELETE lt_eqbs WHERE equnr IS INITIAL.
  ENDIF.

  IF lt_eqbs IS INITIAL.
    RETURN.
  ENDIF.

  SELECT a~aufnr a~auart a~ktext a~erdat b~equnr c~tplnr a~objnr
    FROM aufk AS a
    INNER JOIN afih AS b ON a~aufnr = b~aufnr
    LEFT OUTER JOIN iloa AS c ON b~iloan = c~iloan
    INTO CORRESPONDING FIELDS OF TABLE lt_aufk_fin
    FOR ALL ENTRIES IN lt_eqbs
    WHERE b~equnr = lt_eqbs-equnr
      AND a~autyp = '30'.

  IF lt_aufk_fin IS INITIAL.
    RETURN.
  ENDIF.

  SELECT objnr stat
    FROM jest
    INTO CORRESPONDING FIELDS OF TABLE lt_jest
    FOR ALL ENTRIES IN lt_aufk_fin
    WHERE objnr = lt_aufk_fin-objnr
      AND inact = space.

  SORT lt_jest BY objnr stat.

  IF lt_jest IS NOT INITIAL.

    SELECT istat txt04 txt30
      FROM tj02t
      INTO CORRESPONDING FIELDS OF TABLE lt_tj02t
      FOR ALL ENTRIES IN lt_jest
      WHERE istat = lt_jest-stat
        AND spras = sy-langu.

    SORT lt_tj02t BY istat.

  ENDIF.

  SELECT equnr eqktx
    FROM eqkt
    INTO CORRESPONDING FIELDS OF TABLE lt_eqkt
    FOR ALL ENTRIES IN lt_aufk_fin
    WHERE equnr = lt_aufk_fin-equnr
      AND spras = sy-langu.

  SORT lt_eqkt BY equnr.

  SELECT equnr invnr
    FROM equi
    INTO TABLE lt_equi
    FOR ALL ENTRIES IN lt_aufk_fin
    WHERE equnr = lt_aufk_fin-equnr.

  SORT lt_equi BY equnr.

  SELECT tplnr pltxt
    FROM iflotx
    INTO CORRESPONDING FIELDS OF TABLE lt_iflotx
    FOR ALL ENTRIES IN lt_aufk_fin
    WHERE tplnr = lt_aufk_fin-tplnr
      AND spras = sy-langu.

  SORT lt_iflotx BY tplnr.

  LOOP AT lt_aufk_fin INTO wa_aufk_fin.

    CLEAR: wa_orders,
           wa_jest,
           wa_tj02t,
           wa_eqkt,
           wa_equi,
           wa_iflotx,
           lv_status_final.

    "Prioridade 1: ordem encerrada
    LOOP AT lt_jest INTO wa_jest
      WHERE objnr = wa_aufk_fin-objnr
        AND ( stat = 'I0045'
           OR stat = 'I0046' ).

      lv_status_final      = wa_jest-stat.
      wa_orders-status_rel = 'ENCERRADA'.
      EXIT.

    ENDLOOP.

    "Prioridade 2: ordem aberta
    IF lv_status_final IS INITIAL.

      LOOP AT lt_jest INTO wa_jest
        WHERE objnr = wa_aufk_fin-objnr
          AND ( stat = 'I0001'
             OR stat = 'I0002' ).

        lv_status_final      = wa_jest-stat.
        wa_orders-status_rel = 'ABERTA'.
        EXIT.

      ENDLOOP.

    ENDIF.

    "Fallback
    IF lv_status_final IS INITIAL.

      READ TABLE lt_jest INTO wa_jest
        WITH KEY objnr = wa_aufk_fin-objnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        lv_status_final = wa_jest-stat.
      ENDIF.

      wa_orders-status_rel = 'OUTROS'.

    ENDIF.

    IF iv_status IS NOT INITIAL.

      IF iv_status = 'ABERTA'
         AND wa_orders-status_rel NE 'ABERTA'.
        CONTINUE.
      ELSEIF iv_status = 'ENCERRADA'
         AND wa_orders-status_rel NE 'ENCERRADA'.
        CONTINUE.
      ENDIF.

    ENDIF.

    IF lv_status_final IS NOT INITIAL.

      READ TABLE lt_tj02t INTO wa_tj02t
        WITH KEY istat = lv_status_final
        BINARY SEARCH.

      IF sy-subrc = 0.
        CONCATENATE wa_tj02t-txt04 ' - ' wa_tj02t-txt30
          INTO wa_orders-status_sistema.
      ENDIF.

    ENDIF.

    wa_orders-tipo        = 'O'.
    wa_orders-documento   = wa_aufk_fin-aufnr.
    wa_orders-auart_qmart = wa_aufk_fin-auart.
    wa_orders-ktext       = wa_aufk_fin-ktext.
    wa_orders-erdat       = wa_aufk_fin-erdat.
    wa_orders-equnr       = wa_aufk_fin-equnr.
    wa_orders-tplnr       = wa_aufk_fin-tplnr.

    CLEAR wa_cliente.
    IF lt_clientes IS NOT INITIAL.
      READ TABLE lt_clientes INTO wa_cliente INDEX 1.
      IF sy-subrc = 0.
        wa_orders-name1             = wa_cliente-name1.
        wa_orders-name2             = wa_cliente-name2.
        wa_orders-cnpj              = wa_cliente-cnpj.
        wa_orders-cpf               = wa_cliente-cpf.
        wa_orders-kunnr             = wa_cliente-kunnr.
        wa_orders-endereco_completo = wa_cliente-endereco_completo.
        wa_orders-telefones         = wa_cliente-telefones.
        wa_orders-email             = wa_cliente-email.
      ENDIF.
    ENDIF.

    IF wa_orders-equnr IS NOT INITIAL.

      READ TABLE lt_eqkt INTO wa_eqkt
        WITH KEY equnr = wa_aufk_fin-equnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        wa_orders-eqktx = wa_eqkt-eqktx.
      ENDIF.

      READ TABLE lt_equi INTO wa_equi
        WITH KEY equnr = wa_aufk_fin-equnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        wa_orders-invnr = wa_equi-invnr.
      ENDIF.

    ENDIF.

    IF wa_orders-tplnr IS NOT INITIAL.

      READ TABLE lt_iflotx INTO wa_iflotx
        WITH KEY tplnr = wa_aufk_fin-tplnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        wa_orders-pltxt = wa_iflotx-pltxt.
      ENDIF.

    ENDIF.

    IF wa_orders-documento IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-documento
        IMPORTING
          output = wa_orders-documento.
    ENDIF.

    IF wa_orders-equnr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-equnr
        IMPORTING
          output = wa_orders-equnr.
    ENDIF.

    APPEND wa_orders TO lt_orders_out.

  ENDLOOP.

  SORT lt_orders_out BY erdat DESCENDING.
  et_orders = lt_orders_out.

ENDMETHOD.


METHOD ORDENS_POR_EQUIPAMENTO_LOCAL.

  TYPES: BEGIN OF ty_equnr,
           equnr TYPE equi-equnr,
         END OF ty_equnr.

  TYPES: BEGIN OF ty_tplnr,
           tplnr TYPE iflotx-tplnr,
         END OF ty_tplnr.

  TYPES: BEGIN OF ty_aufk_data,
           aufnr TYPE aufk-aufnr,
           auart TYPE aufk-auart,
           ktext TYPE aufk-ktext,
           erdat TYPE aufk-erdat,
           equnr TYPE afih-equnr,
           tplnr TYPE iloa-tplnr,
           objnr TYPE aufk-objnr,
         END OF ty_aufk_data.

  TYPES: BEGIN OF ty_jest,
           objnr TYPE jest-objnr,
           stat  TYPE jest-stat,
         END OF ty_jest.

  TYPES: BEGIN OF ty_tj02t,
           istat TYPE tj02t-istat,
           txt04 TYPE tj02t-txt04,
           txt30 TYPE tj02t-txt30,
         END OF ty_tj02t.

  TYPES: BEGIN OF ty_eqkt,
           equnr TYPE eqkt-equnr,
           eqktx TYPE eqkt-eqktx,
         END OF ty_eqkt.

  TYPES: BEGIN OF ty_equi,
           equnr TYPE equi-equnr,
           invnr TYPE equi-invnr,
         END OF ty_equi.

  TYPES: BEGIN OF ty_iflotx,
           tplnr TYPE iflotx-tplnr,
           pltxt TYPE iflotx-pltxt,
         END OF ty_iflotx.

  TYPES: BEGIN OF ty_eqbs_kunnr,
           equnr TYPE eqbs-equnr,
           kunnr TYPE eqbs-kunnr,
         END OF ty_eqbs_kunnr.

  TYPES: BEGIN OF ty_kna1,
           kunnr TYPE kna1-kunnr,
           name1 TYPE kna1-name1,
           name2 TYPE kna1-name2,
           stcd1 TYPE kna1-stcd1,
           stcd2 TYPE kna1-stcd2,
         END OF ty_kna1.

  DATA: lt_equnr_sel    TYPE STANDARD TABLE OF ty_equnr,
        wa_equnr_sel    TYPE ty_equnr,
        lt_tplnr_sel    TYPE STANDARD TABLE OF ty_tplnr,
        wa_tplnr_sel    TYPE ty_tplnr,

        lt_equnr_rng    TYPE RANGE OF equi-equnr,
        wa_equnr_rng    LIKE LINE OF lt_equnr_rng,
        lt_tplnr_rng    TYPE RANGE OF iflotx-tplnr,
        wa_tplnr_rng    LIKE LINE OF lt_tplnr_rng,

        lt_aufk_fin     TYPE STANDARD TABLE OF ty_aufk_data,
        wa_aufk_fin     TYPE ty_aufk_data,

        lt_jest         TYPE STANDARD TABLE OF ty_jest,
        wa_jest         TYPE ty_jest,

        lt_tj02t        TYPE STANDARD TABLE OF ty_tj02t,
        wa_tj02t        TYPE ty_tj02t,

        lt_eqkt         TYPE STANDARD TABLE OF ty_eqkt,
        wa_eqkt         TYPE ty_eqkt,

        lt_equi         TYPE STANDARD TABLE OF ty_equi,
        wa_equi         TYPE ty_equi,

        lt_iflotx       TYPE STANDARD TABLE OF ty_iflotx,
        wa_iflotx       TYPE ty_iflotx,

        lt_eqbs_kunnr   TYPE STANDARD TABLE OF ty_eqbs_kunnr,
        wa_eqbs_kunnr   TYPE ty_eqbs_kunnr,

        lt_kna1         TYPE STANDARD TABLE OF ty_kna1,
        wa_kna1         TYPE ty_kna1,

        lt_orders_out   TYPE /ptloms/ct167,
        wa_orders       LIKE LINE OF lt_orders_out,

        lv_equnr        TYPE equi-equnr,
        lv_tplnr        TYPE iflotx-tplnr,
        lv_search       TYPE string,
        lv_status_final TYPE jest-stat.

  CLEAR et_orders.

  IF iv_equnr IS INITIAL
     AND iv_eqktx IS INITIAL
     AND iv_invnr IS INITIAL
     AND iv_tplnr IS INITIAL
     AND iv_pltxt IS INITIAL.
    RETURN.
  ENDIF.

  "====================================================================
  " 1. Determinação dos equipamentos
  "====================================================================
  IF iv_equnr IS NOT INITIAL.

    lv_equnr = iv_equnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_equnr
      IMPORTING
        output = lv_equnr.

    CLEAR wa_equnr_sel.
    wa_equnr_sel-equnr = lv_equnr.
    APPEND wa_equnr_sel TO lt_equnr_sel.

  ELSEIF iv_invnr IS NOT INITIAL.

    SELECT equnr
      FROM equi
      INTO CORRESPONDING FIELDS OF TABLE @lt_equnr_sel
      WHERE invnr = @iv_invnr.

  ELSEIF iv_eqktx IS NOT INITIAL.

    lv_search = iv_eqktx.
    CONDENSE lv_search.
    TRANSLATE lv_search TO UPPER CASE.
    CONCATENATE '%' lv_search '%' INTO lv_search.

    SELECT equnr
      FROM eqkt
      INTO CORRESPONDING FIELDS OF TABLE @lt_equnr_sel
      WHERE eqktx LIKE @lv_search
        AND spras = @sy-langu.

  ENDIF.

  IF lt_equnr_sel IS NOT INITIAL.

    SORT lt_equnr_sel BY equnr.
    DELETE ADJACENT DUPLICATES FROM lt_equnr_sel COMPARING equnr.
    DELETE lt_equnr_sel WHERE equnr IS INITIAL.

    LOOP AT lt_equnr_sel INTO wa_equnr_sel.
      CLEAR wa_equnr_rng.
      wa_equnr_rng-sign   = 'I'.
      wa_equnr_rng-option = 'EQ'.
      wa_equnr_rng-low    = wa_equnr_sel-equnr.
      APPEND wa_equnr_rng TO lt_equnr_rng.
    ENDLOOP.

  ENDIF.

  "====================================================================
  " 2. Determinação dos locais de instalação
  "====================================================================
  IF iv_tplnr IS NOT INITIAL.

    lv_tplnr = iv_tplnr.

    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = lv_tplnr
      IMPORTING
        output = lv_tplnr.

    CLEAR wa_tplnr_sel.
    wa_tplnr_sel-tplnr = lv_tplnr.
    APPEND wa_tplnr_sel TO lt_tplnr_sel.

  ELSEIF iv_pltxt IS NOT INITIAL.

    lv_search = iv_pltxt.
    CONDENSE lv_search.
    TRANSLATE lv_search TO UPPER CASE.
    CONCATENATE '%' lv_search '%' INTO lv_search.

    SELECT tplnr
      FROM iflotx
      INTO CORRESPONDING FIELDS OF TABLE @lt_tplnr_sel
      WHERE pltxt LIKE @lv_search
        AND spras = @sy-langu.

  ENDIF.

  IF lt_tplnr_sel IS NOT INITIAL.

    SORT lt_tplnr_sel BY tplnr.
    DELETE ADJACENT DUPLICATES FROM lt_tplnr_sel COMPARING tplnr.
    DELETE lt_tplnr_sel WHERE tplnr IS INITIAL.

    LOOP AT lt_tplnr_sel INTO wa_tplnr_sel.
      CLEAR wa_tplnr_rng.
      wa_tplnr_rng-sign   = 'I'.
      wa_tplnr_rng-option = 'EQ'.
      wa_tplnr_rng-low    = wa_tplnr_sel-tplnr.
      APPEND wa_tplnr_rng TO lt_tplnr_rng.
    ENDLOOP.

  ENDIF.

  IF lt_equnr_rng IS INITIAL
     AND lt_tplnr_rng IS INITIAL.
    RETURN.
  ENDIF.

  "====================================================================
  " 3. Busca das ordens PM
  "====================================================================
  IF lt_equnr_rng IS NOT INITIAL
     AND lt_tplnr_rng IS NOT INITIAL.

    SELECT a~aufnr,
           a~auart,
           a~ktext,
           a~erdat,
           b~equnr,
           c~tplnr,
           a~objnr
      FROM aufk AS a
      INNER JOIN afih AS b
        ON a~aufnr = b~aufnr
      LEFT OUTER JOIN iloa AS c
        ON b~iloan = c~iloan
      INTO CORRESPONDING FIELDS OF TABLE @lt_aufk_fin
      WHERE b~equnr IN @lt_equnr_rng
        AND c~tplnr IN @lt_tplnr_rng
        AND a~autyp = '30'.

  ELSEIF lt_equnr_rng IS NOT INITIAL.

    SELECT a~aufnr,
           a~auart,
           a~ktext,
           a~erdat,
           b~equnr,
           c~tplnr,
           a~objnr
      FROM aufk AS a
      INNER JOIN afih AS b
        ON a~aufnr = b~aufnr
      LEFT OUTER JOIN iloa AS c
        ON b~iloan = c~iloan
      INTO CORRESPONDING FIELDS OF TABLE @lt_aufk_fin
      WHERE b~equnr IN @lt_equnr_rng
        AND a~autyp = '30'.

  ELSEIF lt_tplnr_rng IS NOT INITIAL.

    SELECT a~aufnr,
           a~auart,
           a~ktext,
           a~erdat,
           b~equnr,
           c~tplnr,
           a~objnr
      FROM aufk AS a
      INNER JOIN afih AS b
        ON a~aufnr = b~aufnr
      LEFT OUTER JOIN iloa AS c
        ON b~iloan = c~iloan
      INTO CORRESPONDING FIELDS OF TABLE @lt_aufk_fin
      WHERE c~tplnr IN @lt_tplnr_rng
        AND a~autyp = '30'.

  ENDIF.

  IF lt_aufk_fin IS INITIAL.
    RETURN.
  ENDIF.

  SORT lt_aufk_fin BY aufnr.
  DELETE ADJACENT DUPLICATES FROM lt_aufk_fin COMPARING aufnr.

  "====================================================================
  " 4. Busca em lote dos dados auxiliares
  "====================================================================
  SELECT objnr,
         stat
    FROM jest
    INTO CORRESPONDING FIELDS OF TABLE @lt_jest
    FOR ALL ENTRIES IN @lt_aufk_fin
    WHERE objnr = @lt_aufk_fin-objnr
      AND inact = @space.

  SORT lt_jest BY objnr stat.

  IF lt_jest IS NOT INITIAL.

    SELECT istat,
           txt04,
           txt30
      FROM tj02t
      INTO CORRESPONDING FIELDS OF TABLE @lt_tj02t
      FOR ALL ENTRIES IN @lt_jest
      WHERE istat = @lt_jest-stat
        AND spras = @sy-langu.

    SORT lt_tj02t BY istat.

  ENDIF.

  SELECT equnr,
         eqktx
    FROM eqkt
    INTO CORRESPONDING FIELDS OF TABLE @lt_eqkt
    FOR ALL ENTRIES IN @lt_aufk_fin
    WHERE equnr = @lt_aufk_fin-equnr
      AND spras = @sy-langu.

  SORT lt_eqkt BY equnr.

  SELECT equnr,
         invnr
    FROM equi
    INTO TABLE @lt_equi
    FOR ALL ENTRIES IN @lt_aufk_fin
    WHERE equnr = @lt_aufk_fin-equnr.

  SORT lt_equi BY equnr.

  SELECT tplnr,
         pltxt
    FROM iflotx
    INTO CORRESPONDING FIELDS OF TABLE @lt_iflotx
    FOR ALL ENTRIES IN @lt_aufk_fin
    WHERE tplnr = @lt_aufk_fin-tplnr
      AND spras = @sy-langu.

  SORT lt_iflotx BY tplnr.

  SELECT equnr,
         kunnr
    FROM eqbs
    INTO CORRESPONDING FIELDS OF TABLE @lt_eqbs_kunnr
    FOR ALL ENTRIES IN @lt_aufk_fin
    WHERE equnr = @lt_aufk_fin-equnr.

  IF lt_eqbs_kunnr IS NOT INITIAL.

    SORT lt_eqbs_kunnr BY equnr kunnr.
    DELETE ADJACENT DUPLICATES FROM lt_eqbs_kunnr COMPARING equnr kunnr.
    DELETE lt_eqbs_kunnr WHERE kunnr IS INITIAL.

    IF lt_eqbs_kunnr IS NOT INITIAL.

      SELECT kunnr,
             name1,
             name2,
             stcd1,
             stcd2
        FROM kna1
        INTO CORRESPONDING FIELDS OF TABLE @lt_kna1
        FOR ALL ENTRIES IN @lt_eqbs_kunnr
        WHERE kunnr = @lt_eqbs_kunnr-kunnr.

      SORT lt_kna1 BY kunnr.

    ENDIF.

  ENDIF.

  "====================================================================
  " 5. Montagem da saída
  "====================================================================
  LOOP AT lt_aufk_fin INTO wa_aufk_fin.

    CLEAR: wa_orders,
           wa_jest,
           wa_tj02t,
           wa_eqkt,
           wa_equi,
           wa_iflotx,
           wa_eqbs_kunnr,
           wa_kna1,
           lv_status_final.

    LOOP AT lt_jest INTO wa_jest
      WHERE objnr = wa_aufk_fin-objnr.

      IF wa_jest-stat = 'I0045'
         OR wa_jest-stat = 'I0046'.

        lv_status_final      = wa_jest-stat.
        wa_orders-status_rel = 'ENCERRADA'.
        EXIT.

      ENDIF.

    ENDLOOP.

    IF lv_status_final IS INITIAL.

      LOOP AT lt_jest INTO wa_jest
        WHERE objnr = wa_aufk_fin-objnr.

        IF wa_jest-stat = 'I0001'
           OR wa_jest-stat = 'I0002'.

          lv_status_final      = wa_jest-stat.
          wa_orders-status_rel = 'ABERTA'.
          EXIT.

        ENDIF.

      ENDLOOP.

    ENDIF.

    IF lv_status_final IS INITIAL.

      READ TABLE lt_jest INTO wa_jest
        WITH KEY objnr = wa_aufk_fin-objnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        lv_status_final = wa_jest-stat.
      ENDIF.

      wa_orders-status_rel = 'OUTROS'.

    ENDIF.

    IF iv_status IS NOT INITIAL.

      IF iv_status = 'ABERTA'
         AND wa_orders-status_rel NE 'ABERTA'.
        CONTINUE.
      ELSEIF iv_status = 'ENCERRADA'
         AND wa_orders-status_rel NE 'ENCERRADA'.
        CONTINUE.
      ENDIF.

    ENDIF.

    IF lv_status_final IS NOT INITIAL.

      READ TABLE lt_tj02t INTO wa_tj02t
        WITH KEY istat = lv_status_final
        BINARY SEARCH.

      IF sy-subrc = 0.
        CONCATENATE wa_tj02t-txt04 ' - ' wa_tj02t-txt30
          INTO wa_orders-status_sistema.
      ENDIF.

    ENDIF.

    wa_orders-tipo        = 'O'.
    wa_orders-documento   = wa_aufk_fin-aufnr.
    wa_orders-auart_qmart = wa_aufk_fin-auart.
    wa_orders-ktext       = wa_aufk_fin-ktext.
    wa_orders-erdat       = wa_aufk_fin-erdat.
    wa_orders-equnr       = wa_aufk_fin-equnr.
    wa_orders-tplnr       = wa_aufk_fin-tplnr.

    READ TABLE lt_eqkt INTO wa_eqkt
      WITH KEY equnr = wa_aufk_fin-equnr
      BINARY SEARCH.

    IF sy-subrc = 0.
      wa_orders-eqktx = wa_eqkt-eqktx.
    ENDIF.

    READ TABLE lt_equi INTO wa_equi
      WITH KEY equnr = wa_aufk_fin-equnr
      BINARY SEARCH.

    IF sy-subrc = 0.
      wa_orders-invnr = wa_equi-invnr.
    ENDIF.

    READ TABLE lt_iflotx INTO wa_iflotx
      WITH KEY tplnr = wa_aufk_fin-tplnr
      BINARY SEARCH.

    IF sy-subrc = 0.
      wa_orders-pltxt = wa_iflotx-pltxt.
    ENDIF.

    READ TABLE lt_eqbs_kunnr INTO wa_eqbs_kunnr
      WITH KEY equnr = wa_aufk_fin-equnr
      BINARY SEARCH.

    IF sy-subrc = 0.

      READ TABLE lt_kna1 INTO wa_kna1
        WITH KEY kunnr = wa_eqbs_kunnr-kunnr
        BINARY SEARCH.

      IF sy-subrc = 0.
        wa_orders-kunnr = wa_kna1-kunnr.
        wa_orders-name1 = wa_kna1-name1.
        wa_orders-name2 = wa_kna1-name2.
        wa_orders-cnpj  = wa_kna1-stcd1.
        wa_orders-cpf   = wa_kna1-stcd2.
      ENDIF.

    ENDIF.

    IF wa_orders-documento IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-documento
        IMPORTING
          output = wa_orders-documento.
    ENDIF.

    IF wa_orders-equnr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = wa_orders-equnr
        IMPORTING
          output = wa_orders-equnr.
    ENDIF.

    IF wa_orders-tplnr IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
        EXPORTING
          input  = wa_orders-tplnr
        IMPORTING
          output = wa_orders-tplnr.
    ENDIF.

    APPEND wa_orders TO lt_orders_out.

  ENDLOOP.

  SORT lt_orders_out BY erdat DESCENDING.
  et_orders = lt_orders_out.

ENDMETHOD.


  METHOD tipo_ordem_perfil.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

    TYPES: BEGIN OF st_auart_type,
             auart_low  TYPE c LENGTH 40,
             auart_high TYPE c LENGTH 4,
           END OF st_auart_type.

    DATA: w_range LIKE LINE OF re_auart.
    DATA: wl_tb013 TYPE /ptloms/tb013.

    DATA: lt_range TYPE TABLE OF  st_auart_type.
    DATA: ls_range LIKE LINE OF lt_range.

    " Perfil associado ao usuário
    SELECT SINGLE * FROM
       /ptloms/tb013
      INTO CORRESPONDING FIELDS OF wl_tb013
      WHERE usuario IN im_usuperfil.

    IF sy-subrc IS INITIAL.

      " Tipos de ordens associado ao perfil
*      SELECT 'I'   AS sign,
*             'EQ'  AS option,
*             auart AS low,
*             auart AS high
*        FROM /ptloms/tb022
*        INTO TABLE @re_auart
*        WHERE perfil = @wl_tb013-perfil.

      SELECT auart
             auart
        FROM /ptloms/tb022
        INTO TABLE lt_range
        WHERE perfil = wl_tb013-perfil.

      LOOP AT lt_range INTO ls_range.

        w_range-sign = 'I'.
        w_range-option = 'EQ'.
        w_range-low  = ls_range-auart_low.
        w_range-high = ls_range-auart_high.

        APPEND ls_range TO re_auart.

      ENDLOOP.

      IF sy-subrc IS NOT  INITIAL.

        " Se não houver tipos de ordem no perfil, não retornar nenhuma ordem
        em_subrc = 4.

      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
