class /PTLOMS/CL014 definition
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

  methods OBTER_CONSULTA_ANALITICA
    importing
      value(RT_DATA) type /IWBEP/T_COD_SELECT_OPTIONS
      value(RT_ORDEM) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_USUARIO) type /IWBEP/T_COD_SELECT_OPTIONS optional
    returning
      value(ET_RETORNO) type /PTLOMS/CT173 .
  class-methods OBTER_HISTORICO_ATENDIMENTO
    importing
      value(RT_DATACRIACAO) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_AUFNR) type /IWBEP/T_COD_SELECT_OPTIONS optional
    exporting
      !ET_HISTORICO type /PTLOMS/CT162 .
  class-methods ANULAR_DESPACHO
    importing
      !I_DESPACHO type /PTLOMS/ET141
    exporting
      !E_DESPACHO type /PTLOMS/ET141
    exceptions
      DES_NAO_ENCONTRADO .
  class-methods ATUALIZAR_DESPACHO
    importing
      !I_DESPACHO type /PTLOMS/ET141
    exporting
      !E_DESPACHO type /PTLOMS/ET141
    exceptions
      DES_NAO_ENCONTRADO .
  class-methods DESPACHAR_OPERACAO
    importing
      !I_USUARIO type UNAME
      !I_AUFNR type AUFNR
      !I_VORNR type VORNR
    exporting
      !E_DESPACHO type /PTLOMS/ET141
    exceptions
      OPER_JA_DESP_US
      MAT_OBRIGATORIA
      ORDEM_NAO_LIBERADA .
  class-methods GET_OPERACOES_SIMPLIFICADA
    exporting
      value(ET_OPERACOES) type /PTLOMS/CT119 .
  class-methods GRAVAR_DESPACHO
    importing
      !I_DESPACHO type /PTLOMS/ET141
    exporting
      !E_DESPACHO type /PTLOMS/ET141 .
  class-methods INATIVAR_DESPACHO
    importing
      !I_GUID type GUID
    exporting
      !E_DESPACHO type /PTLOMS/ET141 .
  class-methods OBTER_DESPACHO
    importing
      !I_GUID type GUID
    exporting
      !E_DESPACHO type /PTLOMS/ET141
    exceptions
      DES_NAO_ENCONTRADO .
  class-methods OBTER_LISTA_DESPACHOS
    importing
      !I_INATIVO type FLAG
    exporting
      !E_DESPACHO type /PTLOMS/CT120 .
  class-methods OBTER_LISTA_STATUS_EXEC_OPERAC
    importing
      value(RT_GUID) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_DATADESSAC) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_DATACRIACAO) type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_AUFNR type /IWBEP/T_COD_SELECT_OPTIONS
      value(I_DATA_INI) type /PTLOMS/ET188-DATACRIACAO optional
      value(I_DATA_FIM) type /PTLOMS/ET188-DATADESSAC optional
    exporting
      !ET_ASSOCIACOES type /PTLOMS/CT162 .
  class-methods OBTER_LISTA_ASSOCI_PRG_DESASSS
    importing
      value(RT_DATADESSAC) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(RT_DATACRIACAO) type /IWBEP/T_COD_SELECT_OPTIONS optional
      value(I_DATA_INI) type /PTLOMS/ET195-DATA_INI optional
      value(I_DATA_FIM) type /PTLOMS/ET195-DATA_FIM optional
    exporting
      !ET_ASSOCIACOES type /PTLOMS/CT166 .
  class-methods VERIFICAR_DESPACHO_ATIVO
    importing
      !I_USUARIO type UNAME optional
      !I_AUFNR type AUFNR
      !I_VORNR type VORNR
    exporting
      !ET_DESPACHOS type /PTLOMS/CT120 .
  class-methods VERIFICAR_STATUS_LIBERADO
    importing
      !I_AUFNR type AUFNR
    exporting
      !E_FLAG type FLAG .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL014 IMPLEMENTATION.


  METHOD anular_despacho.

    DATA: ls_et141 TYPE /ptloms/et141.

    CALL METHOD /ptloms/cl014=>obter_despacho
      EXPORTING
        i_guid     = i_despacho-guid
      IMPORTING
        e_despacho = ls_et141.

    CALL METHOD /ptloms/cl014=>obter_despacho
      EXPORTING
        i_guid             = i_despacho-guid
      IMPORTING
        e_despacho         = ls_et141
      EXCEPTIONS
        des_nao_encontrado = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
      MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '003' RAISING des_nao_encontrado.
    ELSE.

      ls_et141-motivo_desassociacao = i_despacho-motivo_desassociacao.
      ls_et141-data_desassociacao = sy-datum.
      ls_et141-hora_desassociacao = sy-uzeit.
      ls_et141-inativo = 'X'.

      CALL METHOD /ptloms/cl014=>atualizar_despacho
        EXPORTING
          i_despacho         = ls_et141
        IMPORTING
          e_despacho         = e_despacho
        EXCEPTIONS
          des_nao_encontrado = 1
          OTHERS             = 2.
      IF sy-subrc <> 0.
        MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '003' RAISING des_nao_encontrado.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD atualizar_despacho.

    DATA: ls_141 TYPE /ptloms/et141.
    DATA: ls_062 TYPE /ptloms/tb062.
    DATA system_uuid TYPE REF TO if_system_uuid.

    MOVE-CORRESPONDING i_despacho TO ls_062.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_062-aufnr
      IMPORTING
        output = ls_062-aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_062-vornr
      IMPORTING
        output = ls_062-vornr.

    GET TIME STAMP FIELD ls_062-alterado_em.
    ls_062-alterado_por = sy-uname.

    UPDATE /ptloms/tb062 FROM ls_062.

    IF sy-subrc IS INITIAL.

      MOVE-CORRESPONDING ls_062 TO e_despacho.

    ELSE.

      MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '003' RAISING des_nao_encontrado.

    ENDIF.

  ENDMETHOD.


  METHOD despachar_operacao.

    DATA: lt_despachos_realizados TYPE /ptloms/ct120.
    DATA: ls_despacho             TYPE /ptloms/et141.
    DATA: ls_tb013                TYPE /ptloms/tb013.
    DATA: lt_tb044                TYPE TABLE OF /ptloms/tb044.
    DATA: ls_tb044                LIKE LINE OF lt_tb044.
    DATA: ls_liberado             TYPE flag.

    CALL METHOD /ptloms/cl014=>verificar_status_liberado
      EXPORTING
        i_aufnr = i_aufnr
      IMPORTING
        e_flag  = ls_liberado.

    IF ls_liberado IS INITIAL.

      MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '005' RAISING ordem_nao_liberada.

    ENDIF.

    CALL METHOD /ptloms/cl014=>verificar_despacho_ativo
      EXPORTING
        i_usuario    = i_usuario
        i_aufnr      = i_aufnr
        i_vornr      = i_vornr
      IMPORTING
        et_despachos = lt_despachos_realizados.

    IF lt_despachos_realizados IS INITIAL.

      ls_despacho-aufnr = i_aufnr.
      ls_despacho-vornr = i_vornr.
      ls_despacho-usuario = i_usuario.
      ls_despacho-data_associacao = sy-datum.
      ls_despacho-hora_associacao = sy-uzeit.
      ls_despacho-status = 1.


      SELECT  SINGLE      *
        FROM  /ptloms/tb013
        INTO ls_tb013
             WHERE  usuario    = i_usuario.

      IF sy-subrc IS INITIAL.

        SELECT SINGLE       *
          FROM  /ptloms/tb044
          INTO ls_tb044
               WHERE  perfil = ls_tb013-perfil
                  AND configuracao = '20'.

        IF sy-subrc IS INITIAL.

          IF ls_tb013-matricula IS INITIAL.

            MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '004' RAISING mat_obrigatoria.

          ENDIF.

        ENDIF.

        CALL METHOD /ptloms/cl014=>gravar_despacho
          EXPORTING
            i_despacho = ls_despacho
          IMPORTING
            e_despacho = ls_despacho.

        e_despacho = ls_despacho.

      ELSE.

        MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '002' RAISING oper_ja_desp_us.

      ENDIF.

    ELSE.

      MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '001' RAISING oper_ja_desp_us.

    ENDIF.

  ENDMETHOD.


  METHOD get_operacoes_simplificada.

    DATA: lt_operacoes TYPE TABLE OF viauf_afvc.
    DATA: ls_operacoes LIKE LINE OF lt_operacoes.
    DATA: ls_operacoes2 LIKE LINE OF et_operacoes.

    SELECT *
      FROM viauf_afvc AS va
      JOIN jest AS j ON va~objnr EQ j~objnr
    INTO CORRESPONDING FIELDS OF TABLE  lt_operacoes
      WHERE j~inact EQ ''
        AND j~stat EQ 'I0002'
         OR j~stat EQ 'I0001'
      ORDER BY aufnr DESCENDING.

    LOOP AT lt_operacoes INTO ls_operacoes.

      MOVE-CORRESPONDING ls_operacoes TO ls_operacoes2.

      APPEND ls_operacoes2 TO et_operacoes.

    ENDLOOP.

  ENDMETHOD.


  METHOD gravar_despacho.

    DATA: ls_141 TYPE /ptloms/et141.
    DATA: ls_062 TYPE /ptloms/tb062.
    DATA system_uuid TYPE REF TO if_system_uuid.

    ls_141 = i_despacho.

    system_uuid = cl_uuid_factory=>create_system_uuid( ).
    TRY.
        DATA uuid_x16 TYPE sysuuid_x16.
        uuid_x16 = system_uuid->create_uuid_x16( ).
        ls_141-guid = uuid_x16.
      CATCH cx_uuid_error.

    ENDTRY.

    GET TIME STAMP FIELD ls_141-criado_em.
    ls_141-criado_por = sy-uname.
    GET TIME STAMP FIELD ls_141-alterado_em.
    ls_141-alterado_por = sy-uname.

    MOVE-CORRESPONDING ls_141 TO ls_062.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_062-aufnr
      IMPORTING
        output = ls_062-aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_062-vornr
      IMPORTING
        output = ls_062-vornr.

    INSERT /ptloms/tb062 FROM ls_062.

    IF sy-subrc IS INITIAL.

      MOVE-CORRESPONDING ls_062 TO e_despacho.

    ENDIF.

  ENDMETHOD.


  METHOD inativar_despacho.

    DATA: ls_062 TYPE /ptloms/tb062.

    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF ls_062
           FROM /ptloms/tb062
           WHERE guid = i_guid.

    ls_062-inativo = 'X'.

    GET TIME STAMP FIELD ls_062-alterado_em.
    ls_062-alterado_por = sy-uname.

    UPDATE /ptloms/tb062 FROM ls_062.

    IF sy-subrc IS INITIAL.

      MOVE-CORRESPONDING ls_062 TO e_despacho.

    ENDIF.


  ENDMETHOD.


METHOD obter_consulta_analitica.

  TYPES:
    BEGIN OF ty_retorno,
      ordem             TYPE afru-aufnr,
      operacao          TYPE afru-vornr,
      usuario           TYPE afru-ernam,
      matricula         TYPE /ptloms/tb013-matricula,
      nome_usuario      TYPE /ptloms/tb013-nome,
      data_inicio       TYPE viaufks-gstrs,
      total_plan_ut     TYPE afvv-arbeh,
      total_plan        TYPE afvv-arbei,
      total_real_ut     TYPE afru-ismne,
      total_real        TYPE afru-ismnw,
      total_real_usu_ut TYPE afru-ismne,
      total_real_usu    TYPE afru-ismnw,
    END OF ty_retorno,

    BEGIN OF ty_total_usu,
      usuario           TYPE afru-ernam,
      ordem             TYPE afru-aufnr,
      operacao          TYPE afru-vornr,
      data_inicio       TYPE viaufks-gstrs,
      total_real_usu_ut TYPE afru-ismne,
      total_real_usu    TYPE afru-ismnw,
    END OF ty_total_usu,

    BEGIN OF ty_total_ord,
      ordem         TYPE afru-aufnr,
      operacao      TYPE afru-vornr,
      data_inicio   TYPE viaufks-gstrs,
      total_real_ut TYPE afru-ismne,
      total_real    TYPE afru-ismnw,
    END OF ty_total_ord.


  DATA:
    lt_retorno      TYPE STANDARD TABLE OF ty_retorno,

*   Tabelas intermediarias para receber resultado do SELECT
    lt_total_usu_db TYPE STANDARD TABLE OF ty_total_usu,
    lt_total_ord_db TYPE STANDARD TABLE OF ty_total_ord,

*   Tabelas finais utilizadas pela logica original
    lt_total_usu    TYPE HASHED TABLE OF ty_total_usu
                     WITH UNIQUE KEY
                       usuario
                       ordem
                       operacao
                       data_inicio,

    lt_total_ord    TYPE HASHED TABLE OF ty_total_ord
                     WITH UNIQUE KEY
                       ordem
                       operacao
                       data_inicio,

    ls_total_usu    TYPE ty_total_usu,
    ls_total_ord    TYPE ty_total_ord.


  FIELD-SYMBOLS:
    <et_retorno> TYPE /ptloms/et204,
    <retorno>    TYPE ty_retorno,
    <total_usu>  TYPE ty_total_usu,
    <total_ord>  TYPE ty_total_ord.


  CLEAR et_retorno[].


*---------------------------------------------------------------------*
* Obtem o somatorio por ordens e usuario
*---------------------------------------------------------------------*
  SELECT t66~aufnr         AS ordem
         t66~vornr         AS operacao
         t66~uname         AS usuario
         t13~matricula     AS matricula
         t13~nome          AS nome_usuario
         via~gstrs         AS data_inicio
         afvv~arbei        AS total_plan
         afvv~arbeh        AS total_plan_ut
    INTO CORRESPONDING FIELDS OF TABLE lt_retorno
    FROM /ptloms/tb066 AS t66
    INNER JOIN viaufks AS via
      ON via~aufnr = t66~aufnr
    INNER JOIN afvc
      ON afvc~aufpl = via~aufpl
     AND afvc~loekz = ' '
    INNER JOIN afvv
      ON afvv~aufpl = afvc~aufpl
     AND afvv~aplzl = afvc~aplzl
    INNER JOIN /ptloms/tb013 AS t13
      ON t13~usuario = t66~uname
    WHERE via~gstrs  IN rt_data
      AND t66~aufnr  IN rt_ordem
      AND t66~uname  IN rt_usuario
      AND afvc~vornr = t66~vornr
      AND via~objnr NOT IN
          ( SELECT objnr
              FROM jest
             WHERE inact = ' '
               AND ( stat = 'I0045'
                  OR stat = 'I0046' ) ).


*---------------------------------------------------------------------*
* Obtem total realizado por usuario
*
* IMPORTANTE:
* O SELECT nao grava diretamente na HASHED TABLE.
* Isto evita ITAB_DUPLICATE_KEY quando existir mais de uma ISMNE
* para usuario/ordem/operacao/data.
*---------------------------------------------------------------------*
  CLEAR lt_total_usu_db[].
  CLEAR lt_total_usu[].

  SELECT t13~usuario      AS usuario
         via~aufnr        AS ordem
         tot~vornr        AS operacao
         via~gstrs        AS data_inicio
         tot~ismne        AS total_real_usu_ut
         SUM( tot~ismnw ) AS total_real_usu
    INTO CORRESPONDING FIELDS OF TABLE lt_total_usu_db
    FROM viaufks AS via
    LEFT OUTER JOIN afru AS tot
      ON tot~aufnr = via~aufnr
    INNER JOIN /ptloms/tb013 AS t13
      ON t13~matricula = tot~pernr
    WHERE via~gstrs   IN rt_data
      AND via~aufnr   IN rt_ordem
      AND t13~usuario IN rt_usuario
      AND via~objnr NOT IN
          ( SELECT objnr
              FROM jest
             WHERE inact = ' '
               AND ( stat = 'I0045'
                  OR stat = 'I0046' ) )
    GROUP BY t13~usuario
             via~aufnr
             tot~vornr
             via~gstrs
             tot~ismne.


*---------------------------------------------------------------------*
* Consolida total por usuario
*---------------------------------------------------------------------*
  LOOP AT lt_total_usu_db INTO ls_total_usu.

    READ TABLE lt_total_usu
      ASSIGNING <total_usu>
      WITH TABLE KEY
        usuario     = ls_total_usu-usuario
        ordem       = ls_total_usu-ordem
        operacao    = ls_total_usu-operacao
        data_inicio = ls_total_usu-data_inicio.

    IF sy-subrc = 0.

      <total_usu>-total_real_usu =
        <total_usu>-total_real_usu +
        ls_total_usu-total_real_usu.

*     Mantem a unidade encontrada para a chave.
*     Caso existam unidades diferentes, revisar regra funcional.
      IF <total_usu>-total_real_usu_ut IS INITIAL.
        <total_usu>-total_real_usu_ut =
          ls_total_usu-total_real_usu_ut.
      ENDIF.

    ELSE.

      INSERT ls_total_usu
        INTO TABLE lt_total_usu.

    ENDIF.

  ENDLOOP.


*---------------------------------------------------------------------*
* Obtem total realizado por ordem
*
* Mesma protecao aplicada ao total por usuario.
*---------------------------------------------------------------------*
  CLEAR lt_total_ord_db[].
  CLEAR lt_total_ord[].

  SELECT via~aufnr        AS ordem
         tot~vornr        AS operacao
         via~gstrs        AS data_inicio
         tot~ismne        AS total_real_ut
         SUM( tot~ismnw ) AS total_real
    INTO CORRESPONDING FIELDS OF TABLE lt_total_ord_db
    FROM viaufks AS via
    LEFT OUTER JOIN afru AS tot
      ON tot~aufnr = via~aufnr
    WHERE via~gstrs IN rt_data
      AND via~aufnr IN rt_ordem
      AND via~objnr NOT IN
          ( SELECT objnr
              FROM jest
             WHERE inact = ' '
               AND ( stat = 'I0045'
                  OR stat = 'I0046' ) )
    GROUP BY via~aufnr
             tot~vornr
             via~gstrs
             tot~ismne.


*---------------------------------------------------------------------*
* Consolida total por ordem
*---------------------------------------------------------------------*
  LOOP AT lt_total_ord_db INTO ls_total_ord.

    READ TABLE lt_total_ord
      ASSIGNING <total_ord>
      WITH TABLE KEY
        ordem       = ls_total_ord-ordem
        operacao    = ls_total_ord-operacao
        data_inicio = ls_total_ord-data_inicio.

    IF sy-subrc = 0.

      <total_ord>-total_real =
        <total_ord>-total_real +
        ls_total_ord-total_real.

*     Mantem a unidade encontrada para a chave.
      IF <total_ord>-total_real_ut IS INITIAL.
        <total_ord>-total_real_ut =
          ls_total_ord-total_real_ut.
      ENDIF.

    ELSE.

      INSERT ls_total_ord
        INTO TABLE lt_total_ord.

    ENDIF.

  ENDLOOP.


*---------------------------------------------------------------------*
* Agregacao dos totais no retorno
*---------------------------------------------------------------------*
  LOOP AT lt_retorno ASSIGNING <retorno>.


*---------------------------------------------------------------------*
* Total realizado pelo usuario
*---------------------------------------------------------------------*
    READ TABLE lt_total_usu
      ASSIGNING <total_usu>
      WITH TABLE KEY
        usuario     = <retorno>-usuario
        ordem       = <retorno>-ordem
        operacao    = <retorno>-operacao
        data_inicio = <retorno>-data_inicio.

    IF sy-subrc = 0.

      <retorno>-total_real_usu =
        <total_usu>-total_real_usu.

      <retorno>-total_real_usu_ut =
        <total_usu>-total_real_usu_ut.

    ENDIF.


*---------------------------------------------------------------------*
* Total realizado da ordem
*---------------------------------------------------------------------*
    READ TABLE lt_total_ord
      ASSIGNING <total_ord>
      WITH TABLE KEY
        ordem       = <retorno>-ordem
        operacao    = <retorno>-operacao
        data_inicio = <retorno>-data_inicio.

    IF sy-subrc = 0.

      <retorno>-total_real =
        <total_ord>-total_real.

      <retorno>-total_real_ut =
        <total_ord>-total_real_ut.

    ENDIF.


*---------------------------------------------------------------------*
* Converte numero da ordem para formato externo
*---------------------------------------------------------------------*
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = <retorno>-ordem
      IMPORTING
        output = <retorno>-ordem.


*---------------------------------------------------------------------*
* Monta tabela de retorno
*---------------------------------------------------------------------*
    APPEND INITIAL LINE TO et_retorno
      ASSIGNING <et_retorno>.

    MOVE-CORRESPONDING <retorno>
      TO <et_retorno>.

  ENDLOOP.

ENDMETHOD.


  METHOD obter_despacho.

    DATA: ls_062 TYPE /ptloms/tb062.

    SELECT SINGLE *
           INTO CORRESPONDING FIELDS OF ls_062
           FROM /ptloms/tb062
           WHERE guid = i_guid.


    IF sy-subrc IS INITIAL.

      MOVE-CORRESPONDING ls_062 TO e_despacho.

    ELSE.

      MESSAGE ID '/PTLOMS/CM002' TYPE 'E' NUMBER '003' RAISING des_nao_encontrado.

    ENDIF.


  ENDMETHOD.


  METHOD obter_historico_atendimento.

******************************************************************************
** V E R S Ã O   E H P   6 . 0
******************************************************************************
    TYPES: BEGIN OF ty_historico,
             autyp            TYPE viaufks-autyp,
             aufpl            TYPE viaufks-aufpl,
             objnr            TYPE viaufks-objnr,
             notif_no         TYPE viaufks-qmnum,
             order_type       TYPE viaufks-auart,
             aufnr            TYPE viaufks-aufnr,
             short_text_ordem TYPE viaufks-ktext,
             eqpto_num        TYPE viaufks-equnr,
             equipment        TYPE viaufks-equnr,
             funct_loc        TYPE viaufks-tplnr,
             planplant        TYPE viaufks-iwerk,
             plangroup        TYPE viaufks-ingpr,
             pmacttype        TYPE viaufks-ilart,
             priotype         TYPE viaufks-artpr,
             mn_wkctr_id      TYPE viaufks-gewrk,
             priority         TYPE viaufks-priok,
             guid             TYPE /ptloms/tb066-guid,
             vornr            TYPE /ptloms/tb066-vornr,
             uname            TYPE /ptloms/tb066-uname,
             datacriacao      TYPE /ptloms/tb066-datacriacao,
             horacriacao      TYPE /ptloms/tb066-horacriacao,
             status           TYPE /ptloms/tb066-status,
             datadessac       TYPE /ptloms/tb066-datadessac,
             horadessac       TYPE /ptloms/tb066-horadessac,
             motivo           TYPE /ptloms/tb066-motivo,
             description      TYPE afvc-ltxa1,
             descr_motivo     TYPE dd07t-ddtext,
             priokx           TYPE t356_t-priokx,
             eqktx            TYPE eqkt-eqktx,
             pltxt            TYPE iflotx-pltxt,
             desc_planplant   TYPE t001w-name1,
             innam            TYPE t024i-innam,
             ilatx            TYPE t353i_t-ilatx,
             arbpl            TYPE crhd_v1-arbpl,
             t_ctt            TYPE crhd_v1-ktext,
             iloan            TYPE equz-iloan,
             kostl_equnr      TYPE iloa-kostl,
             kostl_equnr_t    TYPE cskt-ltext,
             kostl_funcl      TYPE iflo-kostl,
             kostl_funcl_t    TYPE cskt-ltext,

           END OF ty_historico,

           BEGIN OF ty_dominio,
             domvalue_l TYPE dd07t-domvalue_l,
             ddtext     TYPE dd07t-ddtext,
           END OF ty_dominio,

           BEGIN OF ty_flag,
             aufnr TYPE aufnr,
             vornr TYPE vornr,
             uname TYPE /ptloms/tb066-uname,
           END OF ty_flag,

           BEGIN OF ty_cc_eq,
             iloan         TYPE iloa-iloan,
             kostl_equnr   TYPE cskt-kostl,
             kostl_equnr_t TYPE cskt-ltext,
           END OF ty_cc_eq,

           BEGIN OF ty_cc_lc,
             funct_loc     type viaufks-tplnr,
             kostl_funcl   TYPE iflo-kostl,
             kostl_funcl_t TYPE cskt-ltext,
           END OF ty_cc_lc,

           ty_t_historico TYPE STANDARD TABLE OF ty_historico WITH DEFAULT KEY.

    DATA: lt_historico   TYPE ty_t_historico,
          ls_historico   TYPE ty_historico,
          lt_assinatura  TYPE STANDARD TABLE OF ty_flag,
          lt_checklist   TYPE STANDARD TABLE OF ty_flag,
          lt_confirmacao TYPE STANDARD TABLE OF ty_flag,
          lt_dominio     TYPE STANDARD TABLE OF ty_dominio,
          lt_cc_eq       TYPE STANDARD TABLE OF ty_cc_eq,
          ls_cc_eq       TYPE ty_cc_eq,
          lt_cc_lc       TYPE STANDARD TABLE OF ty_cc_lc,
          ls_cc_lc       TYPE ty_cc_lc,
          ls_dominio     TYPE ty_dominio,
          lv_d_status    TYPE dd07t-domvalue_l,
          lv_status      TYPE de_cm_status,
          lv_equnr       TYPE equi-equnr,
          lv_tplnr       TYPE iflot-tplnr.

    FIELD-SYMBOLS: <entidade> TYPE /ptloms/et188,
                   <linha>    TYPE ty_historico.


    SELECT viaufks~autyp    AS autyp
           viaufks~aufpl    AS aufpl
           viaufks~objnr    AS objnr
           viaufks~qmnum    AS notif_no
           viaufks~auart    AS order_type
           viaufks~aufnr    AS aufnr
           viaufks~ktext    AS short_text_ordem
           viaufks~equnr    AS eqpto_num
           viaufks~equnr    AS equipment
           viaufks~tplnr    AS funct_loc
           viaufks~iwerk    AS planplant
           viaufks~ingpr    AS plangroup
           viaufks~ilart    AS pmacttype
           viaufks~artpr    AS priotype
           viaufks~gewrk    AS mn_wkctr_id
           viaufks~priok    AS priority
           t66~guid         AS guid
           t66~vornr        AS vornr
           t66~uname        AS uname
           t66~datacriacao  AS datacriacao
           t66~horacriacao  AS horacriacao
           t66~status       AS status
           t66~datadessac   AS datadessac
           t66~horadessac   AS horadessac
           t66~motivo       AS motivo
           tvc~ltxa1        AS description
           sh_motivo~ddtext AS descr_motivo
           pri~priokx       AS priokx
           equ~eqktx        AS eqktx
           loc~pltxt        AS pltxt
           cpl~name1        AS desc_planplant
           grp~innam        AS innam
           atv~ilatx        AS ilatx
           ctt~arbpl        AS arbpl
           ctt~ktext        AS t_ctt
           eqz~iloan        AS iloan
      INTO CORRESPONDING FIELDS OF TABLE lt_historico
      FROM viaufks
     INNER JOIN /ptloms/tb066 AS t66 ON t66~aufnr = viaufks~aufnr
     INNER JOIN afvc          AS tvc ON tvc~aufpl = viaufks~aufpl AND tvc~vornr = t66~vornr AND tvc~loekz = space
      LEFT OUTER JOIN dd07t   AS sh_motivo ON sh_motivo~domvalue_l = t66~motivo AND sh_motivo~ddlanguage = sy-langu AND sh_motivo~domname = '/PTLOMS/DM006' AND sh_motivo~as4local = 'A'
      LEFT OUTER JOIN t356_t  AS pri ON pri~artpr = viaufks~artpr AND pri~priok = viaufks~priok AND pri~spras = sy-langu
      LEFT OUTER JOIN eqkt    AS equ ON equ~equnr = viaufks~equnr AND equ~spras = sy-langu
      LEFT OUTER JOIN iflotx  AS loc ON loc~tplnr = viaufks~tplnr AND loc~spras = sy-langu
      LEFT OUTER JOIN t001w   AS cpl ON cpl~werks = viaufks~iwerk AND cpl~spras = sy-langu
      LEFT OUTER JOIN t024i   AS grp ON grp~iwerk = viaufks~iwerk AND grp~ingrp = viaufks~ingpr
      LEFT OUTER JOIN t353i_t AS atv ON atv~spras = sy-langu      AND atv~ilart = viaufks~ilart
      LEFT OUTER JOIN crhd_v1 AS ctt ON ctt~objty = 'A'           AND ctt~spras = sy-langu AND ctt~objid = viaufks~gewrk
      LEFT OUTER JOIN equz    AS eqz ON eqz~equnr = viaufks~equnr AND eqz~datbi = '99991231'
     WHERE t66~datacriacao IN rt_datacriacao
       AND viaufks~aufnr   IN rt_aufnr
     ORDER BY t66~datacriacao viaufks~aufnr t66~vornr.

    "-- Compatibilidade de tipo de status --"

    SELECT domvalue_l ddtext
      FROM dd07t
      INTO TABLE lt_dominio
     WHERE domname    = '/PTLOMS/DM008'
       AND ddlanguage = sy-langu
       AND as4local   = 'A'.

    IF lt_historico[] IS NOT INITIAL.

      SELECT aufnr vornr usuario_app AS uname
        INTO CORRESPONDING FIELDS OF TABLE lt_assinatura
        FROM /ptloms/tb077
         FOR ALL ENTRIES IN lt_historico
       WHERE aufnr       = lt_historico-aufnr
         AND vornr       = lt_historico-vornr
         AND usuario_app = lt_historico-uname.

      SORT lt_assinatura BY aufnr vornr uname.
      DELETE ADJACENT DUPLICATES FROM lt_assinatura COMPARING aufnr vornr uname.

      SELECT ordem    AS aufnr operacao AS vornr usuario  AS uname
        INTO CORRESPONDING FIELDS OF TABLE lt_checklist
        FROM /ptloms/tb076
         FOR ALL ENTRIES IN lt_historico
       WHERE ordem    = lt_historico-aufnr
         AND operacao = lt_historico-vornr
         AND usuario  = lt_historico-uname.

      SORT lt_checklist BY aufnr vornr uname.
      DELETE ADJACENT DUPLICATES FROM lt_checklist COMPARING aufnr vornr uname.

      SELECT aufnr vornr usuario AS uname
        INTO CORRESPONDING FIELDS OF TABLE lt_confirmacao
        FROM /ptloms/tb068
         FOR ALL ENTRIES IN lt_historico
       WHERE aufnr   = lt_historico-aufnr
         AND vornr   = lt_historico-vornr
         AND usuario = lt_historico-uname.

      SORT lt_confirmacao BY aufnr vornr uname.
      DELETE ADJACENT DUPLICATES FROM lt_confirmacao COMPARING aufnr vornr uname.

      "-- Centro de custo de equipamento --"
      SELECT iloa~iloan cskt~kostl AS kostl_equnr cskt~ltext AS kostl_equnr_t
        INTO CORRESPONDING FIELDS OF TABLE lt_cc_eq
        FROM iloa
        LEFT OUTER JOIN cskt ON cskt~kostl = iloa~kostl AND cskt~spras = sy-langu AND cskt~datbi = '99991231'
         FOR ALL ENTRIES IN lt_historico
       WHERE iloa~iloan = lt_historico-iloan.

      SORT lt_cc_eq BY kostl_equnr.
      DELETE ADJACENT DUPLICATES FROM lt_cc_eq COMPARING kostl_equnr.

      "-- Centro de custo de local --"
      SELECT iflo~tplnr AS funct_loc cskt~kostl AS kostl_funcl cskt~ltext AS kostl_funcl_t
        INTO CORRESPONDING FIELDS OF TABLE lt_cc_lc
        FROM iflo
        LEFT OUTER JOIN cskt ON cskt~kostl = iflo~kostl AND cskt~spras = sy-langu AND cskt~datbi = '99991231'
         FOR ALL ENTRIES IN lt_historico
       WHERE iflo~tplnr = lt_historico-funct_loc.

      SORT lt_cc_lc BY kostl_funcl.
      DELETE ADJACENT DUPLICATES FROM lt_cc_lc COMPARING kostl_funcl.

    ENDIF.

    LOOP AT lt_historico ASSIGNING <linha>.

      APPEND INITIAL LINE TO et_historico ASSIGNING <entidade>.

      MOVE-CORRESPONDING <linha> TO <entidade>.

      CLEAR: <entidade>-possui_assinatura, <entidade>-possui_checklist, <entidade>-possui_confirmacao, lv_d_status.

      READ TABLE lt_assinatura
        TRANSPORTING NO FIELDS
        WITH KEY aufnr = <entidade>-aufnr
                 vornr = <entidade>-vornr
                 uname = <entidade>-uname
        BINARY SEARCH.

      IF sy-subrc = 0.
        <entidade>-possui_assinatura = 'X'.
      ENDIF.

      READ TABLE lt_checklist
        TRANSPORTING NO FIELDS
        WITH KEY aufnr = <entidade>-aufnr
                 vornr = <entidade>-vornr
                 uname = <entidade>-uname
        BINARY SEARCH.

      IF sy-subrc = 0.
        <entidade>-possui_checklist = 'X'.
      ENDIF.

      READ TABLE lt_confirmacao
        TRANSPORTING NO FIELDS
        WITH KEY aufnr = <entidade>-aufnr
                 vornr = <entidade>-vornr
                 uname = <entidade>-uname
        BINARY SEARCH.

      IF sy-subrc = 0.
        <entidade>-possui_confirmacao = 'X'.
      ENDIF.

      "-- C.Custo Equipamento --"
      READ TABLE lt_cc_eq INTO ls_cc_eq WITH KEY iloan = <linha>-iloan BINARY SEARCH.
      IF sy-subrc = 0.
        <entidade>-kostl_equnr = ls_cc_eq-kostl_equnr.
      ENDIF.

      "-- C.Custo Local --"
      READ TABLE lt_cc_lc INTO ls_cc_lc WITH KEY funct_loc = <linha>-funct_loc BINARY SEARCH.
      IF sy-subrc = 0.
        <entidade>-kostl_funcl = ls_cc_lc-kostl_funcl.
      ENDIF.

      "-- Status --"
      WRITE <entidade>-status TO lv_d_status LEFT-JUSTIFIED.
      READ TABLE lt_dominio INTO ls_dominio WITH KEY domvalue_l = lv_d_status.
      IF sy-subrc = 0.
        <entidade>-descr_status = ls_dominio-ddtext.
      ELSE.
        <entidade>-descr_status = space.
      ENDIF.




      <entidade>-data_hora_cri  = |{ <entidade>-datacriacao   DATE = USER } { <entidade>-horacriacao TIME = ISO }|.
      <entidade>-data_hora_desa = |{ <entidade>-datadessac    DATE = USER } { <entidade>-horadessac  TIME = ISO }|.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <entidade>-eqpto_num
        IMPORTING
          output = <entidade>-eqpto_num.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <entidade>-equipment
        IMPORTING
          output = <entidade>-equipment.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <entidade>-kostl_equnr
        IMPORTING
          output = <entidade>-kostl_equnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <entidade>-kostl_funcl
        IMPORTING
          output = <entidade>-kostl_funcl.
      CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
        EXPORTING
          input  = <entidade>-funct_loc
        IMPORTING
          output = <entidade>-funct_loc.

      "--
      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
          objnr            = <entidade>-objnr
          only_active      = 'X'
          spras            = sy-langu
        IMPORTING
          line             = lv_status
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.

      IF sy-subrc IS INITIAL.
        <entidade>-sys_status = lv_status.
      ENDIF.

    ENDLOOP.

******************************************************************************
** V E R S Ã O   M O D E R N A   7 4 0
******************************************************************************
**
**    SELECT DISTINCT
**           via~autyp,
**           via~aufpl,
**           via~objnr,
**           t66~guid         AS guid,
**           via~qmnum        AS notif_no,
**           via~auart        AS order_type,
**           via~aufnr        AS aufnr,
**           via~ktext        AS short_text_ordem,
**           t66~vornr        AS vornr,
**           tvc~ltxa1        AS description,
**           via~priok        AS priority,
**           pri~priokx       AS priokx,
**           t66~uname        AS uname,
**           t66~datacriacao  AS datacriacao,
**           t66~horacriacao  AS horacriacao,
**           t66~status       AS status,
**           t66~datadessac   AS datadessac,
**           t66~horadessac   AS horadessac,
**           t66~motivo       AS motivo,
**           sh_motivo~ddtext AS descr_motivo,
**           CASE WHEN t77~aufnr IS NOT NULL THEN 'X' ELSE ' ' END AS possui_assinatura,
**           CASE WHEN t76~ordem IS NOT NULL THEN 'X' ELSE ' ' END AS possui_checklist,
**           CASE WHEN t68~aufnr IS NOT NULL THEN 'X' ELSE ' ' END AS possui_confirmacao,
**           via~equnr AS eqpto_num,
**           via~equnr AS equipment,
**           equ~eqktx AS eqktx,
**           via~tplnr AS funct_loc,
**           loc~pltxt AS pltxt,
**           via~iwerk AS planplant,
**           cpl~name1 AS desc_planplant,
**           via~ingpr AS plangroup,
**           grp~innam AS innam,
**           via~ilart AS pmacttype,
**           atv~ilatx AS ilatx,
**           via~artpr AS priotype,
**           via~gewrk AS mn_wkctr_id,
**           ctt~arbpl AS arbpl,
**           ctt~ktext AS t_ctt,
**           ile~kostl AS kostl_equnr,
**           csk~ltext AS kostl_equnr_t,
**           ifl~kostl AS kostl_funcl,
**           cso~ltext AS kostl_funcl_t
**      FROM viaufks AS via
**     INNER JOIN /ptloms/tb066 AS t66
**        ON via~aufnr = t66~aufnr
**      LEFT OUTER JOIN afko AS tko
**        ON via~aufnr = tko~aufnr
**      LEFT JOIN afvc AS tvc
**        ON tko~aufpl = tvc~aufpl
**       AND t66~vornr = tvc~vornr
**      LEFT JOIN afvv AS tvv
**        ON tvc~aufpl = tvv~aufpl
**       AND tvc~aplzl = tvv~aplzl
**      LEFT OUTER JOIN dd07t AS sh_motivo
**        ON sh_motivo~domname    = '/PTLOMS/DM006'
**       AND sh_motivo~ddlanguage = @sy-langu
**       AND sh_motivo~domvalue_l = t66~motivo
**      LEFT OUTER JOIN t356_t AS pri
**        ON pri~artpr = via~artpr
**       AND pri~spras = @sy-langu
**       AND pri~priok = via~priok
**      LEFT OUTER JOIN eqkt AS equ
**        ON equ~equnr = via~equnr
**       AND equ~spras = @sy-langu
**      LEFT OUTER JOIN iflotx AS loc
**        ON loc~tplnr = via~tplnr
**       AND loc~spras = @sy-langu
**      LEFT OUTER JOIN t001w  AS cpl
**        ON cpl~werks = via~iwerk
**       AND cpl~spras = @sy-langu
**      LEFT OUTER JOIN t024i AS grp
**        ON grp~iwerk = via~iwerk
**       AND grp~ingrp = via~ingpr
**      LEFT OUTER JOIN t353i_t AS atv
**        ON atv~spras = @sy-langu
**       AND atv~ilart = via~ilart
**      LEFT OUTER JOIN crhd_v1 AS ctt
**        ON ctt~objty = 'A'
**       AND ctt~spras = @sy-langu
**       AND ctt~objid = via~gewrk
**      LEFT OUTER JOIN /ptloms/tb076 AS t76
**        ON t76~ordem    = via~aufnr
**       AND t76~operacao = t66~vornr
**       AND t76~usuario  = t66~uname
**      LEFT OUTER JOIN /ptloms/tb077 AS t77
**        ON t77~aufnr       = via~aufnr
**       AND t77~vornr       = t66~vornr
**       AND t77~usuario_app = t66~uname
**      LEFT OUTER JOIN /ptloms/tb068 AS t68
**        ON t68~aufnr   = via~aufnr
**       AND t68~vornr   = t66~vornr
**       AND t68~usuario = t66~uname
**      LEFT OUTER JOIN equz AS eqz
**        ON eqz~equnr = via~equnr
**       AND eqz~datbi = '99991231'
**      LEFT OUTER JOIN iloa AS ile
**        ON ile~iloan = eqz~iloan
**      LEFT OUTER JOIN cskt AS csk
**        ON csk~kostl = ile~kostl
**       AND csk~spras = @sy-langu
**       AND csk~datbi = '99991231'
**      LEFT OUTER JOIN iflo AS ifl
**        ON ifl~tplnr = via~tplnr
**      LEFT OUTER JOIN cskt AS cso
**        ON cso~kostl = ifl~kostl
**       AND cso~spras = @sy-langu
**       AND cso~datbi = '99991231'
**     WHERE t66~datacriacao IN @rt_datacriacao
**       AND via~aufnr       IN @rt_aufnr
**     ORDER BY t66~datacriacao, via~aufnr, t66~vornr
**      INTO CORRESPONDING FIELDS OF TABLE @et_historico.
**
**    "-- Compatibilidade de tipo de status --"
**    SELECT domvalue_l, ddtext
**      FROM dd07t
**      INTO TABLE @DATA(lt_dominio)
**     WHERE domname    = '/PTLOMS/DM008'
**       AND ddlanguage = @sy-langu
**       AND as4local   = 'A'.
**
**    DATA: lv_equnr  TYPE equi-equnr,
**          lv_status TYPE de_cm_status,
**          lv_tplnr  type iflot-tplnr.
**
**    LOOP AT et_historico ASSIGNING FIELD-SYMBOL(<entidade>).
**      <entidade>-descr_status   = VALUE #( lt_dominio[ <entidade>-status ]-ddtext OPTIONAL ).
**      <entidade>-data_hora_cri  = |{ <entidade>-datacriacao   DATE = USER } { <entidade>-horacriacao TIME = ISO }|.
**      <entidade>-data_hora_desa = |{ <entidade>-datadessac    DATE = USER } { <entidade>-horadessac  TIME = ISO }|.
**      <entidade>-eqpto_num      = |{ <entidade>-eqpto_num    ALPHA = OUT  }|.
**      <entidade>-equipment      = |{ <entidade>-equipment    ALPHA = OUT  }|.
**      <entidade>-kostl_equnr    = |{ <entidade>-kostl_equnr  ALPHA = OUT  }|.
**      <entidade>-kostl_funcl    = |{ <entidade>-kostl_funcl  ALPHA = OUT  }|.
**
**      call FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
**        EXPORTING
**          input  = <entidade>-funct_loc
**        IMPORTING
**          output = <entidade>-funct_loc
**        .
**
**      "--
**      CALL FUNCTION 'STATUS_TEXT_EDIT'
**        EXPORTING
**          objnr            = <entidade>-objnr
**          only_active      = 'X'
**          spras            = sy-langu
**        IMPORTING
**          line             = lv_status
**        EXCEPTIONS
**          object_not_found = 1
**          OTHERS           = 2.
**      IF sy-subrc is initial.
**        <entidade>-sys_status = lv_status.
**      ENDIF.
**
**    ENDLOOP.
**
  ENDMETHOD.


  METHOD obter_lista_associ_prg_desasss.

    TYPES: BEGIN OF ty_centros,
             objid TYPE crhd-objid,
             arbpl TYPE crhd-arbpl,
           END OF ty_centros.

* Declaração de tabela
    DATA: lt_associacoes     TYPE /ptloms/ct166,
          lt_detalhes_ordens TYPE /ptloms/ct132,
          lt_ordens          TYPE /ptloms/ct127,
          lt_detalhes        TYPE /ptloms/ct132,
          ls_detalhe         TYPE /ptloms/et158.

* Declaração de Estrutura
    DATA: ls_datacriacao     LIKE LINE OF rt_datacriacao,
          ls_detalhes_ordens LIKE LINE OF lt_detalhes_ordens,
          ls_detalhe_ordem   TYPE /ptloms/et147,
          ls_ordens          TYPE /ptloms/et151,
          lt_centros         TYPE TABLE OF ty_centros,
          ls_centro          TYPE ty_centros.

* Declaração de variável
    DATA: lv_aufnr TYPE aufnr,
          o_cl015  TYPE REF TO /ptloms/cl015.

    FIELD-SYMBOLS: <fs_associacao> TYPE LINE OF /ptloms/ct166.

    ls_datacriacao-sign = 'I'.
    ls_datacriacao-option = 'BT'.
    IF i_data_ini IS NOT INITIAL.
      ls_datacriacao-low = i_data_ini.
    ELSE.
      ls_datacriacao-low = '00000000'.
    ENDIF.

    IF i_data_fim IS NOT INITIAL.
      ls_datacriacao-high = i_data_fim.
    ELSE.
      ls_datacriacao-high = sy-datum.
    ENDIF.
    APPEND ls_datacriacao TO rt_datacriacao.

    IF rt_datacriacao IS NOT INITIAL.

      SELECT auf~auart
             t65~aufnr
             t65~uname
             t13~matricula AS pers_no
             t65~guid
             t66~datacriacao
             t66~horacriacao
             t66~vornr
             t13~objid
             tvv~fsavd AS first_sched_start_date
             tvv~fsedd AS first_sched_fin_date
             tvv~ssavd AS late_sched_start_date
             tvv~ssedd AS late_sched_fin_date
        INTO CORRESPONDING FIELDS OF TABLE et_associacoes
        FROM /ptloms/tb065 AS t65
       INNER JOIN /ptloms/tb066       AS t66 ON t65~guid  = t66~guid
       INNER JOIN aufk                AS auf ON t65~aufnr = auf~aufnr
       INNER JOIN afko                AS tko ON t65~aufnr = tko~aufnr
       INNER JOIN afvc                AS tvc ON tko~aufpl = tvc~aufpl AND t66~vornr = tvc~vornr
       INNER JOIN afvv                AS tvv ON tvc~aufpl = tvv~aufpl AND tvc~aplzl = tvv~aplzl
        LEFT OUTER JOIN /ptloms/tb013 AS t13 ON t65~uname = t13~usuario
       WHERE tvv~fsavd IN rt_datacriacao.

      IF sy-subrc IS INITIAL.

        SELECT DISTINCT objid arbpl
          INTO TABLE lt_centros
          FROM crhd
         WHERE objty = 'A'.

        LOOP AT et_associacoes ASSIGNING <fs_associacao>.

          CLEAR: ls_detalhe_ordem, ls_ordens, lt_ordens, lt_detalhes, ls_centro, ls_detalhe.

          "-- Detalhes da operação --"
          CALL FUNCTION '/PTLOMS/MF116'
            EXPORTING
              i_aufnr   = <fs_associacao>-aufnr
              i_vornr   = <fs_associacao>-vornr
            IMPORTING
              e_detalhe = ls_detalhe_ordem.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT' EXPORTING input  = <fs_associacao>-aufnr IMPORTING output = <fs_associacao>-aufnr.
          <fs_associacao>-description            = ls_detalhe_ordem-description.
          <fs_associacao>-system_status_text     = ls_detalhe_ordem-system_status_text.
          <fs_associacao>-un_work                = ls_detalhe_ordem-un_work.
          <fs_associacao>-work_activity          = ls_detalhe_ordem-work_activity.
          <fs_associacao>-work_actual            = ls_detalhe_ordem-work_actual.
          <fs_associacao>-equnr_loc_type         = 'E'.
          <fs_associacao>-funct_loc_type         = 'L'.

          READ TABLE lt_centros INTO ls_centro WITH KEY objid = <fs_associacao>-objid.

          IF ls_centro-arbpl IS NOT INITIAL.
            <fs_associacao>-arbpl = ls_centro-arbpl.
          ENDIF.

          MOVE-CORRESPONDING <fs_associacao> TO ls_ordens.
          APPEND ls_ordens TO lt_ordens.

          "-- Detalhes da Ordem --"
          CALL FUNCTION '/PTLOMS/MF124'
            EXPORTING
              i_detalhe = lt_ordens
            IMPORTING
              e_detalhe = lt_detalhes.

          READ TABLE lt_detalhes INTO ls_detalhe INDEX 1.

          <fs_associacao>-short_text_ordem   = ls_detalhe-short_text_ordem.
          <fs_associacao>-equipment          = ls_detalhe-equipment.
          <fs_associacao>-eqktx              = ls_detalhe-eqktx.
          <fs_associacao>-funct_loc          = ls_detalhe-funct_loc.
          <fs_associacao>-pltxt              = ls_detalhe-pltxt.
          <fs_associacao>-invnr              = ls_detalhe-invnr.
          <fs_associacao>-semaforo_icone     = ls_detalhe-semaforo_icone.
          <fs_associacao>-semaforo_cor       = ls_detalhe-semaforo_cor.
          <fs_associacao>-semaforo_descricao = ls_detalhe-semaforo_descricao.

        ENDLOOP.

        IF lt_ordens[] IS NOT INITIAL.

          CREATE OBJECT o_cl015.

          CALL METHOD o_cl015->busca_detalhes_ordem
            EXPORTING
              i_detalhe = lt_ordens
            IMPORTING
              e_detalhe = lt_detalhes_ordens.

        ENDIF.

      ENDIF.

    ENDIF.

    UNASSIGN <fs_associacao>.

  ENDMETHOD.


  METHOD obter_lista_despachos.

    DATA: lt_062 TYPE TABLE OF /ptloms/tb062.
    DATA: ls_062 TYPE          /ptloms/tb062.
    DATA: ls_141 TYPE          /ptloms/et141.

    SELECT *
           INTO CORRESPONDING FIELDS OF TABLE lt_062
    FROM /ptloms/tb062
    WHERE inativo = i_inativo.


    IF sy-subrc IS INITIAL.

      LOOP AT lt_062 INTO ls_062.

        MOVE-CORRESPONDING ls_062 TO ls_141.

        APPEND ls_141 TO e_despacho.

      ENDLOOP.

    ENDIF.


  ENDMETHOD.


  METHOD obter_lista_status_exec_operac.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************
    TYPES: BEGIN OF ty_det_equnr,
             equnr       TYPE v_equi-equnr,
             fleet_num   TYPE fleet-fleet_num,
             license_num TYPE fleet-license_num,
             invnr       TYPE v_equi-invnr,
             anlnr       TYPE v_equi-anlnr,
           END OF ty_det_equnr.

    DATA: lt_det_equnr TYPE TABLE OF ty_det_equnr,
          ls_det_equnr TYPE ty_det_equnr.

* Declaração de tabela
    DATA: lt_partner                   TYPE STANDARD TABLE OF bapi_alm_order_partner,
          lt_operations                TYPE STANDARD TABLE OF bapi_alm_order_operation_e,
          lt_components                TYPE STANDARD TABLE OF bapi_alm_order_component_e,
          lt_objlist                   TYPE STANDARD TABLE OF bapi_alm_order_objectlist,
          lt_text_lines                TYPE STANDARD TABLE OF bapi_alm_text_lines,
          lt_texts                     TYPE STANDARD TABLE OF bapi_alm_text,
          lt_return                    TYPE STANDARD TABLE OF bapiret2,
          lt_equipamentos              TYPE /ptloms/ct130,
          lt_clientes                  TYPE /ptloms/ct129,
          lt_historico_assinatura      TYPE /ptloms/ct159,
          lt_checklst_resp_usuario     TYPE /ptloms/ct089,
          lt_historico_confirmacao_in  TYPE /ptloms/ct154,
          lt_historico_confirmacao_out TYPE /ptloms/ct154,
          lt_detalhes_operacoes        TYPE /ptloms/ct126,
          lt_detalhes_ordens           TYPE /ptloms/ct132,
          lt_ordens                    TYPE TABLE OF /ptloms/et151,
          lt_retorno_hist_assint       TYPE /ptloms/ct156,
          lt_retorno_chcklst_rsp_usr   TYPE /ptloms/ct156.

* Declaração de Estrutura
    DATA: ls_partner               LIKE LINE OF lt_partner,
          ls_operations            LIKE LINE OF lt_operations,
          ls_components            LIKE LINE OF lt_components,
          ls_objlist               LIKE LINE OF lt_objlist,
          ls_text_lines            LIKE LINE OF lt_text_lines,
          ls_texts                 LIKE LINE OF lt_texts,
          ls_return                LIKE LINE OF lt_return,
          ls_equipamento           LIKE LINE OF lt_equipamentos,
          ls_cliente               LIKE LINE OF lt_clientes,
          ls_detalhes_ordens       LIKE LINE OF lt_detalhes_ordens,
          ls_detalhes_operacoes    LIKE LINE OF lt_detalhes_operacoes,
          ls_historico_confirmacao LIKE LINE OF lt_historico_confirmacao_in,
          ls_ordens                TYPE /ptloms/et151,
          rt_uname                 TYPE /iwbep/t_cod_select_options,
          rt_vornr                 TYPE /iwbep/t_cod_select_options,
          rt_criadopor             TYPE /iwbep/t_cod_select_options,
          rt_horacriacao           TYPE /iwbep/t_cod_select_options,
          rt_alteradopor           TYPE /iwbep/t_cod_select_options,
          rt_horadessac            TYPE /iwbep/t_cod_select_options,
          rt_motivo                TYPE /iwbep/t_cod_select_options,
          ls_datacriacao           LIKE LINE OF  rt_datacriacao,
          ls_aufnr                 LIKE LINE OF  rt_datacriacao.

* Declarações para BAPI
    DATA: lv_number   TYPE bapi_alm_order_header_e-orderid,
          ls_header   TYPE bapi_alm_order_header_e,
          lv_data_ini TYPE /ptloms/et184-data_criacao_app,
          lv_data_fim TYPE /ptloms/et184-data_criacao_app.

* Declaraçãode variável
    DATA: lv_aufnr  TYPE aufnr.

    DATA: lt_hist_associacoes TYPE /ptloms/ct161,
          lt_associacoes      TYPE /ptloms/ct162,
          ls_hist_associacao  LIKE LINE OF lt_hist_associacoes,
          ls_associacao       LIKE LINE OF et_associacoes.

    DATA: o_cl015 TYPE REF TO /ptloms/cl015,
          o_cl016 TYPE REF TO /ptloms/cl016,
          o_cl019 TYPE REF TO /ptloms/cl019.

    FIELD-SYMBOLS: <fs_associacao> TYPE LINE OF /ptloms/ct162.

    CREATE OBJECT o_cl015.

    ls_datacriacao-sign = 'I'.
    ls_datacriacao-option = 'BT'.
    IF i_data_ini IS NOT INITIAL.
      ls_datacriacao-low = i_data_ini.
    ELSE.
      ls_datacriacao-low = '00000000'.
    ENDIF.

    IF i_data_fim IS NOT INITIAL.
      ls_datacriacao-high = i_data_fim.
    ELSE.
      ls_datacriacao-high = sy-datum.
    ENDIF.
    APPEND ls_datacriacao TO rt_datacriacao.

* Busca informações da ordem
    CALL METHOD o_cl015->busca_historico_associacoes
      EXPORTING
        rt_guid        = rt_guid
        rt_aufnr       = rt_aufnr
        rt_uname       = rt_uname
        rt_vornr       = rt_vornr
        rt_criadopor   = rt_criadopor
        rt_datacriacao = rt_datacriacao
        rt_horacriacao = rt_horacriacao
        rt_alteradopor = rt_alteradopor
        rt_datadessac  = rt_datadessac
        rt_horadessac  = rt_horadessac
        rt_motivo      = rt_motivo
      IMPORTING
        associacoes    = lt_hist_associacoes.

* Busca informações complementares da ordem
    IF lt_hist_associacoes[] IS NOT INITIAL.

      CREATE OBJECT: o_cl019, o_cl016.

      LOOP AT lt_hist_associacoes INTO ls_hist_associacao.

        REFRESH: lt_historico_assinatura[], lt_checklst_resp_usuario[].

        MOVE-CORRESPONDING ls_hist_associacao TO ls_associacao.

        DELETE ls_associacao-retorno WHERE type = 'S'.
        ls_associacao-chave = 'X'.

        IF sy-subrc = 0.

          CONCATENATE ls_datacriacao-low+6(2)
                      ls_datacriacao-low+4(2)
                      ls_datacriacao-low(4)
                 INTO lv_data_ini
                 SEPARATED BY '/'.

          CONCATENATE ls_datacriacao-high+6(2)
                      ls_datacriacao-high+4(2)
                      ls_datacriacao-high(4)
                 INTO lv_data_fim
                 SEPARATED BY '/'.
***          lv_data_ini = |{ ls_datacriacao-low+6(2) }/{ ls_datacriacao-low+4(2) }/{ ls_datacriacao-low(4) }|.
***          lv_data_fim = |{ ls_datacriacao-high+6(2) }/{ ls_datacriacao-high+4(2) }/{ ls_datacriacao-high(4) }|.

          o_cl016->busca_historico_assinaturas(
            EXPORTING
             i_usuario               = ls_associacao-uname
             i_operacao              = ls_associacao-vornr
             i_ordem                 = ls_associacao-aufnr
            IMPORTING
              e_historico_assinatura = lt_historico_assinatura
              e_retorno = lt_retorno_hist_assint
          ).

          IF lt_historico_assinatura[] IS NOT INITIAL.
            ls_associacao-possui_assinatura = abap_true.
            DELETE lt_retorno_hist_assint WHERE type = 'S'.
            APPEND LINES OF lt_historico_assinatura TO ls_associacao-historicoassinaturas.
          ELSE.
            ls_associacao-possui_assinatura = abap_false.
          ENDIF.

          o_cl019->consulta_respostas(
            EXPORTING
              i_usuario   = ls_associacao-uname
              i_operacao  = ls_associacao-vornr
              i_ordem     = ls_associacao-aufnr
              i_data_ini  = lv_data_ini
              i_data_fim  = lv_data_fim
            IMPORTING
              e_respostas = lt_checklst_resp_usuario
              e_retorno   = lt_retorno_chcklst_rsp_usr
          ).

          IF lt_checklst_resp_usuario[] IS NOT INITIAL.
            ls_associacao-possui_checklist = abap_true.
            DELETE lt_retorno_chcklst_rsp_usr WHERE type = 'S'.
            APPEND LINES OF lt_checklst_resp_usuario TO ls_associacao-listachecklistrespostasusuario.
          ELSE.
            ls_associacao-possui_checklist = abap_false.
          ENDIF.

          ls_historico_confirmacao-usuario   = ls_associacao-uname.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_associacao-aufnr
            IMPORTING
              output = ls_historico_confirmacao-orderid.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_associacao-vornr
            IMPORTING
              output = ls_historico_confirmacao-operation.
***          ls_historico_confirmacao-orderid   = |{ ls_associacao-aufnr ALPHA = IN }|.
***          ls_historico_confirmacao-operation = |{ ls_associacao-vornr ALPHA = IN }|.

          APPEND ls_historico_confirmacao TO lt_historico_confirmacao_in.

          CALL METHOD o_cl015->busca_historico_confirmacao
            EXPORTING
              histor_confirm_in  = lt_historico_confirmacao_in
            IMPORTING
              histor_confirm_out = lt_historico_confirmacao_out.

          IF lt_historico_confirmacao_out[] IS NOT INITIAL.
            ls_associacao-possui_confirmacao = abap_true.
            DELETE lt_retorno_hist_assint WHERE type = 'S'.
            APPEND LINES OF lt_historico_confirmacao_out TO ls_associacao-historicoconfirmacao.
          ELSE.
            ls_associacao-possui_confirmacao = abap_false.
          ENDIF.

          APPEND ls_associacao TO lt_associacoes.
          CLEAR: ls_associacao, ls_historico_confirmacao, lt_historico_confirmacao_in[], lt_historico_confirmacao_out[].
        ENDIF.

      ENDLOOP.

***      MOVE-CORRESPONDING lt_hist_associacoes TO lt_ordens.

      CLEAR: ls_hist_associacao, ls_ordens.
      LOOP AT lt_hist_associacoes INTO ls_hist_associacao.
        CLEAR ls_ordens.
        ls_ordens-aufnr = ls_hist_associacao-aufnr.
        ls_ordens-vornr = ls_hist_associacao-vornr.
        APPEND ls_ordens TO lt_ordens.
      ENDLOOP.

      CALL METHOD o_cl015->busca_detalhes_ordem
        EXPORTING
          i_detalhe = lt_ordens
        IMPORTING
          e_detalhe = lt_detalhes_ordens.

      IF lt_detalhes_ordens[] IS NOT INITIAL.

        SORT lt_detalhes_ordens ASCENDING BY aufnr equipment.
        CLEAR: ls_equipamento, ls_detalhes_ordens.
        LOOP AT lt_detalhes_ordens INTO ls_detalhes_ordens.

          ls_equipamento-chave  = 'X'.
          ls_equipamento-equinr = ls_detalhes_ordens-equipment.

          APPEND ls_equipamento TO lt_equipamentos.
        ENDLOOP.

        IF lt_equipamentos[] IS NOT INITIAL.

          o_cl016->busca_detalhe_cliente(
            EXPORTING
              i_cliente   = lt_equipamentos
            IMPORTING
              e_detalhe   = lt_clientes
               ).

          SORT lt_clientes BY equinr ASCENDING.
          DELETE ADJACENT DUPLICATES FROM lt_clientes.
          SORT lt_associacoes BY eqpto_num ASCENDING.

          LOOP AT lt_associacoes ASSIGNING <fs_associacao>.



            IF lt_detalhes_ordens[] IS NOT INITIAL.

              READ TABLE lt_detalhes_ordens INTO ls_detalhes_ordens WITH KEY aufnr = <fs_associacao>-aufnr.
              IF sy-subrc = 0.
                CLEAR: lt_detalhes_operacoes[], ls_detalhes_operacoes.

                lt_detalhes_operacoes[] = ls_detalhes_ordens-operacoesordemset[].

                READ TABLE lt_detalhes_operacoes INTO ls_detalhes_operacoes WITH KEY aufnr = <fs_associacao>-aufnr
                                                                                     vornr = <fs_associacao>-vornr BINARY SEARCH.
                IF sy-subrc = 0.
                  DELETE ls_detalhes_ordens-retornoset WHERE type = 'S'.
                  "Adicionar as mensagems que não foram excluidas a tabela de retorno de execução
                  MOVE-CORRESPONDING ls_detalhes_ordens TO <fs_associacao>.
                  MOVE-CORRESPONDING ls_detalhes_operacoes TO <fs_associacao>.
                  <fs_associacao>-eqpto_num = ls_detalhes_ordens-equipment.
                ENDIF.

              ENDIF.

            ENDIF.

            CLEAR: ls_cliente.
            READ TABLE lt_clientes INTO ls_cliente WITH KEY equinr = <fs_associacao>-eqpto_num BINARY SEARCH.
            IF sy-subrc = 0.
              <fs_associacao>-name1    = ls_cliente-name1.
              <fs_associacao>-name2    = ls_cliente-name2.
              <fs_associacao>-telfl    = ls_cliente-telfl.
              <fs_associacao>-stras    = ls_cliente-stras.
              <fs_associacao>-ort01    = ls_cliente-ort01.
              <fs_associacao>-pstlz    = ls_cliente-pstlz.
              <fs_associacao>-regio    = ls_cliente-regio.
              <fs_associacao>-adrnr    = ls_cliente-adrnr.
              <fs_associacao>-ort02    = ls_cliente-ort02.
              <fs_associacao>-street    = ls_cliente-street.
              <fs_associacao>-house_num1    = ls_cliente-house_num1.
            ENDIF.

          ENDLOOP.
          UNASSIGN <fs_associacao>.

        ENDIF.

        APPEND LINES OF lt_associacoes TO et_associacoes.

      ENDIF.

    ELSE.

    ENDIF.

*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************

  ENDMETHOD.


  METHOD VERIFICAR_DESPACHO_ATIVO.

    DATA: lt_062 TYPE TABLE OF /ptloms/tb062.
    DATA: ls_062 LIKE LINE OF lt_062.
    DATA: ls_141 TYPE /ptloms/et141.

    IF i_usuario IS INITIAL.
      SELECT *
        FROM  /ptloms/tb062
        INTO TABLE lt_062
             WHERE  aufnr    = i_aufnr
             AND    vornr    = i_vornr
             AND    inativo  = ''.


    ELSE.
      SELECT        *
        FROM  /ptloms/tb062
        INTO TABLE lt_062
             WHERE  aufnr    = i_aufnr
             AND    vornr    = i_vornr
             AND    usuario  = i_usuario
             AND    inativo  = ''.

    ENDIF.

    LOOP AT lt_062 INTO ls_062.

      MOVE-CORRESPONDING ls_062 TO ls_141.
      APPEND ls_141 TO et_despachos.

    ENDLOOP.

  ENDMETHOD.


  METHOD verificar_status_liberado.

    DATA: lt_aufk TYPE TABLE OF aufk.
    DATA: ls_aufk LIKE LINE OF lt_aufk.
    DATA: lt_jest TYPE TABLE OF jest.

    SELECT *
      INTO TABLE lt_aufk
      FROM  aufk
           WHERE  aufnr  = i_aufnr.

    IF sy-subrc IS INITIAL.

      READ TABLE lt_aufk INTO ls_aufk INDEX 1.

      SELECT        *
        FROM  jest
        INTO  TABLE lt_jest
       WHERE  objnr  = ls_aufk-objnr
         AND  inact = ''
         AND  stat EQ 'I0002' .

      IF sy-subrc IS INITIAL.

        e_flag = 'X'.

      ENDIF.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
