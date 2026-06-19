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

    CLEAR et_retorno[].

    SELECT t65~uname         AS usuario,
           t65~aufnr         AS ordem,
           t65~vornr         AS operacao,
           via~gstrs         AS data_inicio,
           sum( afvv~arbei ) AS total_plan,
           sum( fru~ismnw  ) AS total_real_usu,
           sum( fru~ismnw  ) AS total_real
      INTO TABLE @et_retorno
      FROM /ptloms/tb065 AS t65
     INNER JOIN viaufks  AS via
        ON via~aufnr = t65~aufnr
     INNER JOIN afvc
        ON afvc~aufpl = via~aufpl
       AND afvc~vornr = t65~vornr
       AND afvc~loekz = ''
     INNER JOIN afvv
        ON afvv~aufpl = afvc~aufpl
       AND afvv~aplzl = afvc~aplzl
      LEFT OUTER JOIN afru     AS fru
        ON via~aufpl = fru~aufpl
       AND fru~vornr = t65~vornr
       AND fru~aufnr = t65~aufnr
       AND fru~stokz = ''
     WHERE via~gstrs IN @rt_data
     GROUP BY t65~uname, t65~aufnr, t65~vornr, via~gstrs
     ORDER BY t65~uname, t65~aufnr, t65~vornr, via~gstrs.

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

    SELECT DISTINCT
           via~autyp,
           via~aufpl,
           via~objnr,
           t66~guid         AS guid,
           via~qmnum        AS notif_no,
           via~auart        AS order_type,
           via~aufnr        AS aufnr,
           via~ktext        AS short_text_ordem,
           t66~vornr        AS vornr,
           tvc~ltxa1        AS description,
           via~priok        AS priority,
           pri~priokx       AS priokx,
           t66~uname        AS uname,
           t66~datacriacao  AS datacriacao,
           t66~horacriacao  AS horacriacao,
           t66~status       AS status,
           t66~datadessac   AS datadessac,
           t66~horadessac   AS horadessac,
           t66~motivo       AS motivo,
           sh_motivo~ddtext AS descr_motivo,
           CASE WHEN t77~aufnr IS NOT NULL THEN 'X' ELSE ' ' END AS possui_assinatura,
           CASE WHEN t76~ordem IS NOT NULL THEN 'X' ELSE ' ' END AS possui_checklist,
           CASE WHEN t68~aufnr IS NOT NULL THEN 'X' ELSE ' ' END AS possui_confirmacao,
           via~equnr AS eqpto_num,
           via~equnr AS equipment,
           equ~eqktx AS eqktx,
           via~tplnr AS funct_loc,
           loc~pltxt AS pltxt,
           via~iwerk AS planplant,
           cpl~name1 AS desc_planplant,
           via~ingpr AS plangroup,
           grp~innam AS innam,
           via~ilart AS pmacttype,
           atv~ilatx AS ilatx,
           via~artpr AS priotype,
           via~gewrk AS mn_wkctr_id,
           ctt~arbpl AS arbpl,
           ctt~ktext AS t_ctt,
           ile~kostl AS kostl_equnr,
           csk~ltext AS kostl_equnr_t,
           ifl~kostl AS kostl_funcl,
           cso~ltext AS kostl_funcl_t
      FROM viaufks AS via
     INNER JOIN /ptloms/tb066 AS t66
        ON via~aufnr = t66~aufnr
      LEFT OUTER JOIN afko AS tko
        ON via~aufnr = tko~aufnr
      LEFT JOIN afvc AS tvc
        ON tko~aufpl = tvc~aufpl
       AND t66~vornr = tvc~vornr
      LEFT JOIN afvv AS tvv
        ON tvc~aufpl = tvv~aufpl
       AND tvc~aplzl = tvv~aplzl
      LEFT OUTER JOIN dd07t AS sh_motivo
        ON sh_motivo~domname    = '/PTLOMS/DM006'
       AND sh_motivo~ddlanguage = @sy-langu
       AND sh_motivo~domvalue_l = t66~motivo
      LEFT OUTER JOIN t356_t AS pri
        ON pri~artpr = via~artpr
       AND pri~spras = @sy-langu
       AND pri~priok = via~priok
      LEFT OUTER JOIN eqkt AS equ
        ON equ~equnr = via~equnr
       AND equ~spras = @sy-langu
      LEFT OUTER JOIN iflotx AS loc
        ON loc~tplnr = via~tplnr
       AND loc~spras = @sy-langu
      LEFT OUTER JOIN t001w  AS cpl
        ON cpl~werks = via~iwerk
       AND cpl~spras = @sy-langu
      LEFT OUTER JOIN t024i AS grp
        ON grp~iwerk = via~iwerk
       AND grp~ingrp = via~ingpr
      LEFT OUTER JOIN t353i_t AS atv
        ON atv~spras = @sy-langu
       AND atv~ilart = via~ilart
      LEFT OUTER JOIN crhd_v1 AS ctt
        ON ctt~objty = 'A'
       AND ctt~spras = @sy-langu
       AND ctt~objid = via~gewrk
      LEFT OUTER JOIN /ptloms/tb076 AS t76
        ON t76~ordem    = via~aufnr
       AND t76~operacao = t66~vornr
       AND t76~usuario  = t66~uname
      LEFT OUTER JOIN /ptloms/tb077 AS t77
        ON t77~aufnr       = via~aufnr
       AND t77~vornr       = t66~vornr
       AND t77~usuario_app = t66~uname
      LEFT OUTER JOIN /ptloms/tb068 AS t68
        ON t68~aufnr   = via~aufnr
       AND t68~vornr   = t66~vornr
       AND t68~usuario = t66~uname
      LEFT OUTER JOIN equz AS eqz
        ON eqz~equnr = via~equnr
       AND eqz~datbi = '99991231'
      LEFT OUTER JOIN iloa AS ile
        ON ile~iloan = eqz~iloan
      LEFT OUTER JOIN cskt AS csk
        ON csk~kostl = ile~kostl
       AND csk~spras = @sy-langu
       AND csk~datbi = '99991231'
      LEFT OUTER JOIN iflo AS ifl
        ON ifl~tplnr = via~tplnr
      LEFT OUTER JOIN cskt AS cso
        ON cso~kostl = ifl~kostl
       AND cso~spras = @sy-langu
       AND cso~datbi = '99991231'
     WHERE t66~datacriacao IN @rt_datacriacao
       AND via~aufnr       IN @rt_aufnr
     ORDER BY t66~datacriacao, via~aufnr, t66~vornr
      INTO CORRESPONDING FIELDS OF TABLE @et_historico.

    "-- Compatibilidade de tipo de status --"
    SELECT domvalue_l, ddtext
      FROM dd07t
      INTO TABLE @DATA(lt_dominio)
     WHERE domname    = '/PTLOMS/DM008'
       AND ddlanguage = @sy-langu
       AND as4local   = 'A'.

    DATA: lv_equnr  TYPE equi-equnr,
          lv_status TYPE de_cm_status.

    LOOP AT et_historico ASSIGNING FIELD-SYMBOL(<entidade>).
      <entidade>-descr_status   = VALUE #( lt_dominio[ <entidade>-status ]-ddtext OPTIONAL ).
      <entidade>-data_hora_cri  = |{ <entidade>-datacriacao   DATE = USER } { <entidade>-horacriacao TIME = ISO }|.
      <entidade>-data_hora_desa = |{ <entidade>-datadessac    DATE = USER } { <entidade>-horadessac  TIME = ISO }|.
      <entidade>-eqpto_num      = |{ <entidade>-eqpto_num    ALPHA = OUT  }|.
      <entidade>-equipment      = |{ <entidade>-equipment    ALPHA = OUT  }|.
      <entidade>-kostl_equnr    = |{ <entidade>-kostl_equnr  ALPHA = OUT  }|.
      <entidade>-kostl_funcl    = |{ <entidade>-kostl_funcl  ALPHA = OUT  }|.

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
      IF sy-subrc is initial.
        <entidade>-sys_status = lv_status.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD obter_lista_associ_prg_desasss.

* Declaração de tabela
    DATA: lt_associacoes     TYPE /ptloms/ct166,
          lt_detalhes_ordens TYPE /ptloms/ct132,
          lt_ordens          TYPE /ptloms/ct127,
          lt_detalhes        TYPE /ptloms/ct132.

* Declaração de Estrutura
    DATA: ls_datacriacao     LIKE LINE OF rt_datacriacao,
          ls_detalhes_ordens LIKE LINE OF lt_detalhes_ordens,
          ls_detalhe_ordem   TYPE /ptloms/et147,
          ls_ordens          TYPE /ptloms/et151.

* Declaraçãode variável
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

      SELECT DISTINCT
             auf~auart,
             t65~aufnr,
             t65~uname,
             t13~matricula AS pers_no,
             t65~guid,
             t66~datacriacao,
             t66~horacriacao,
             t66~datadessac,
             t66~vornr,
             t13~objid,
             tcr~arbpl,
             'E' AS equnr_loc_type,
             'L' AS funct_loc_type,
             tvv~fsavd AS first_sched_start_date
        FROM /ptloms/tb065 AS t65
       INNER JOIN /ptloms/tb066 AS t66
          ON t65~guid  = t66~guid
       INNER JOIN aufk AS auf
          ON t65~aufnr = auf~aufnr
       INNER JOIN afko AS tko
          ON t65~aufnr = tko~aufnr
       INNER JOIN afvc AS tvc
          ON tko~aufpl = tvc~aufpl
         AND t66~vornr = tvc~vornr
       INNER JOIN afvv AS tvv
          ON tvc~aufpl = tvv~aufpl
         AND tvc~aplzl = tvv~aplzl
        LEFT OUTER JOIN /ptloms/tb013 AS t13
          ON t65~uname = t13~usuario
        LEFT OUTER JOIN crhd AS tcr
          ON t13~objid = tcr~objid
         AND tcr~objty = 'A'
        INTO CORRESPONDING FIELDS OF TABLE @et_associacoes
       WHERE tvv~fsavd IN @rt_datacriacao.

      IF sy-subrc IS INITIAL.

        LOOP AT et_associacoes ASSIGNING <fs_associacao>.

          CLEAR: ls_detalhe_ordem, ls_ordens, lt_ordens, lt_detalhes.

          "-- Detalhes da operação --"
          CALL FUNCTION '/PTLOMS/MF116'
            EXPORTING
              i_aufnr   = <fs_associacao>-aufnr
              i_vornr   = <fs_associacao>-vornr
            IMPORTING
              e_detalhe = ls_detalhe_ordem.

          <fs_associacao>-description            = ls_detalhe_ordem-description.
          "<fs_associacao>-pers_no                = ls_detalhe_ordem-pers_no.
          <fs_associacao>-system_status_text     = ls_detalhe_ordem-system_status_text.
          <fs_associacao>-first_sched_start_date = ls_detalhe_ordem-earl_sched_start_date.
          <fs_associacao>-first_sched_fin_date   = ls_detalhe_ordem-earl_sched_fin_date.
          <fs_associacao>-late_sched_start_date  = ls_detalhe_ordem-late_sched_start_date.
          <fs_associacao>-late_sched_fin_date    = ls_detalhe_ordem-late_sched_fin_date.
          <fs_associacao>-un_work                = ls_detalhe_ordem-un_work.
          <fs_associacao>-work_activity          = ls_detalhe_ordem-work_activity.
          <fs_associacao>-work_actual            = ls_detalhe_ordem-work_actual.

          MOVE-CORRESPONDING <fs_associacao> TO ls_ordens.
          APPEND ls_ordens TO lt_ordens.

          "-- Detalhes da Ordem --"
          CALL FUNCTION '/PTLOMS/MF124'
            EXPORTING
              i_detalhe = lt_ordens
            IMPORTING
              e_detalhe = lt_detalhes.

          DATA(ls_detalhe) = VALUE #( lt_detalhes[ 1 ] OPTIONAL ).

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
          lt_ordens                    TYPE STANDARD TABLE OF /ptloms/et151,
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

          lv_data_ini = |{ ls_datacriacao-low+6(2) }/{ ls_datacriacao-low+4(2) }/{ ls_datacriacao-low(4) }|.
          lv_data_fim = |{ ls_datacriacao-high+6(2) }/{ ls_datacriacao-high+4(2) }/{ ls_datacriacao-high(4) }|.

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
          ls_historico_confirmacao-orderid   = |{ ls_associacao-aufnr ALPHA = IN }|.
          ls_historico_confirmacao-operation = |{ ls_associacao-vornr ALPHA = IN }|.

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

      MOVE-CORRESPONDING lt_hist_associacoes TO lt_ordens.

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
