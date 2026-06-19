class /PTLOMS/CL012 definition
  public
  final
  create public .

public section.

  methods OUT_CLASSE_CARACTERISCA
    importing
      !RT_OBJEK type /IWBEP/T_COD_SELECT_OPTIONS
    returning
      value(RT_CARACTERISTICAS) type /PTLOMS/CT001 .
  methods OUT_CATALOGO
    importing
      !RT_RBNR type /IWBEP/T_COD_SELECT_OPTIONS
    returning
      value(RT_CATALOGOS) type /PTLOMS/CT002 .
  methods OUT_PONTO_MEDICAO
    importing
      !RT_OBJNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
    returning
      value(RT_PONTO_MEDICAO) type /PTLOMS/CT003 .
  methods OUT_DOCUMENTO_MEDICAO
    importing
      !RT_POINT type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS
      !IM_QTDE type NUMC3
    returning
      value(RT_DOCUMENTO_MEDICAO) type /PTLOMS/CT004 .
  methods OUT_PARCEIRO_NEGOCIO
    importing
      !RT_OBJNR type /IWBEP/T_COD_SELECT_OPTIONS
    returning
      value(RT_PARCEIRO_NEGOCIO) type /PTLOMS/CT005 .
  methods OUT_DEMAIS_DADOS_MESTRES
    importing
      !IM_EMPRESA_CENTRO type CHAR1 optional
      !IM_GRUPO_PLANEJAMENTO type CHAR1 optional
      !IM_AREA_OPERACIONAL type CHAR1 optional
      !IM_CENTRO_TRABALHO type CHAR1 optional
      !IM_TIPO_NOTA type CHAR1 optional
      !IM_TIPO_ORDEM type CHAR1 optional
      !IM_TIPO_PRIORIDADE_ORDEM type CHAR1 optional
      !IM_TIPO_PRIORIDADE_NOTA type CHAR1 optional
      !IM_TIPO_ATV_MANUTENCAO type CHAR1 optional
      !IM_CENTRO_CUSTO type CHAR1 optional
      !IM_CONDICAO_INST_ORDEM type CHAR1 optional
      !IM_TIPO_ATV_OPERACAO type CHAR1 optional
      !IM_TIPO_MATERIAL type CHAR1 optional
      !IM_CATEGORIA_ITEM_MATERIAL type CHAR1 optional
      !IM_DEPOSITO type CHAR1 optional
      !IM_CATEGORIA_EQUIPAMENTO type CHAR1 optional
      !IM_TIPO_OBJETO type CHAR1 optional
      !IM_CATEGORIA_LOC_INST type CHAR1 optional
      !IM_TIPO_ATV_ORDEM type CHAR1 optional
      !IM_CAUSA_DESVIO type CHAR1 optional
      !IM_MATRICULA type CHAR1 optional
      !IM_CHAVE_MODELO type CHAR1 optional
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
      !IM_CENTRO_PLANEJAMENTO type CHAR1 optional
    exporting
      !ET_EMPRESA_CENTRO type /PTLOMS/CT006
      !ET_GRUPO_PLANEJAMENTO type /PTLOMS/CT007
      !ET_AREA_OPERACIONAL type /PTLOMS/CT008
      !ET_CENTRO_TRABALHO type /PTLOMS/CT009
      !ET_TIPO_NOTA type /PTLOMS/CT010
      !ET_TIPO_ORDEM type /PTLOMS/CT011
      !ET_TIPO_PRIORIDADE_ORDEM type /PTLOMS/CT012
      !ET_TIPO_PRIORIDADE_NOTA type /PTLOMS/CT013
      !ET_TIPO_ATV_MANUTENCAO type /PTLOMS/CT014
      !ET_CENTRO_CUSTO type /PTLOMS/CT015
      !ET_CONDICAO_INST_ORDEM type /PTLOMS/CT016
      !ET_TIPO_ATV_OPERACAO type /PTLOMS/CT017
      !ET_TIPO_MATERIAL type /PTLOMS/CT027
      !ET_CATEGORIA_ITEM_MATERIAL type /PTLOMS/CT028
      !ET_DEPOSITO type /PTLOMS/CT029
      !ET_CATEGORIA_EQUIPAMENTO type /PTLOMS/CT034
      !ET_TIPO_OBJETO type /PTLOMS/CT035
      !ET_CATEGORIA_LOC_INST type /PTLOMS/CT040
      !ET_TIPO_ATV_ORDEM type /PTLOMS/CT049
      !ET_CAUSA_DESVIO type /PTLOMS/CT066
      !ET_MATRICULAS type /PTLOMS/CT073
      !ET_CHAVE_MODELO type /PTLOMS/CT085
      !ET_CENTRO_PLANEJAMENTO type /PTLOMS/CT111 .
  methods OUT_LOCAL_INSTALACAO
    importing
      !RT_BUKRS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_IWERK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_INGRP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_BEBER type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_LGWID type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_EQART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_FLTYP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
      !IM_TOP type INT4 optional
      !IM_SKIP type INT4 optional
    exporting
      value(ET_LOCAL_INSTALACAO) type /PTLOMS/CT018
      !ET_IMAGENS_LOCAL_INSTALACAO type /PTLOMS/CT072
      !EX_QUANTIDADE_LOCAL_INST type INT4 .
  methods OUT_EQUIPAMENTO_UNICO
    importing
      !IT_EQUIPAMENTO type /PTLOMS/CT019 optional
      !RT_BUKRS type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_EQUNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_IWERK type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_INGRP type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_BEBER type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_GEWRK type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_EQART type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_EQTYP type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
      !IM_TOP type INT4 optional
      !IM_SKIP type INT4 optional
    exporting
      !ET_IMAGEMS_EQUIPAMENTO type /PTLOMS/CT072
      !ET_EQUIPAMENTO type /PTLOMS/CT019
      !ET_FILTRO_EQUNR type /PTLOMS/CT056
      !ET_FILTRO_EQKTX type /PTLOMS/CT056
      !ET_FILTRO_INVNR type /PTLOMS/CT056
      !ET_FILTRO_TIDNR type /PTLOMS/CT056
      !EX_QUANTIDADE_EQUIPAMENTO type INT4
      !ET_RETORNO type /PTLOMS/CT156 .
  methods OUT_EQUIPAMENTO
    importing
      !RT_BUKRS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_IWERK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_INGRP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_BEBER type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GEWRK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_EQART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_EQTYP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
      !IM_TOP type INT4 optional
      !IM_SKIP type INT4 optional
    exporting
      !ET_IMAGEMS_EQUIPAMENTO type /PTLOMS/CT072
      !ET_EQUIPAMENTO type /PTLOMS/CT019
      !ET_FILTRO_EQUNR type /PTLOMS/CT056
      !ET_FILTRO_EQKTX type /PTLOMS/CT056
      !ET_FILTRO_INVNR type /PTLOMS/CT056
      !ET_FILTRO_TIDNR type /PTLOMS/CT056
      !EX_QUANTIDADE_EQUIPAMENTO type INT4 .
  methods OUT_GRUPO_CODE
    importing
      !RT_CODEGRUPPE type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_KATALOGART type /IWBEP/T_COD_SELECT_OPTIONS
    returning
      value(RT_GRUPO_CODE) type /PTLOMS/CT020 .
  methods OUT_NOTA
    importing
      !RT_QMNUM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_QMART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_IWERK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_INGRP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_BEBER type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ARBPL type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_PARNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_EQFNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_STRMN type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_STTXT type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ASTEX type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !ET_NOTAS type /PTLOMS/CT021
      !ET_ITENS_NOTA type /PTLOMS/CT022
      !ET_TEXTOS_NOTA type /PTLOMS/CT023
      !ET_MEDIDAS_NOTA type /PTLOMS/CT024
      !ET_CAUSAS_NOTA type /PTLOMS/CT025
      !ET_ATIVIDADES_NOTA type /PTLOMS/CT026
      !ET_IMAGENS_NOTA type /PTLOMS/CT072 .
  methods OUT_MATERIAL
    importing
      !RT_MTART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_WERKS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_LGORT type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
      !IM_TOP type INT4 optional
      !IM_SKIP type INT4 optional
    exporting
      value(RT_MATERIAIS) type /PTLOMS/CT030
      !EX_QUANTIDADE_MATERIAL type INT4 .
  methods OUT_LISTA_TECNICA
    importing
      !RT_EQUNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TPLNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_MATNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_WERKS type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(ET_LISTA_TECNICA_EQUI) type /PTLOMS/CT031
      value(ET_LISTA_TECNICA_LOC_INST) type /PTLOMS/CT032
      value(ET_LISTA_TECNICA_MAT) type /PTLOMS/CT033 .
  methods OUT_ORDEM
    importing
      !RT_AUFNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_AUART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_IWERK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_INGPR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_BEBER type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ARBPL type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_PARNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_EQFNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GSTRP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_STTXT type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ASTTX type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS
      !IM_TOP type INT4 optional
      !IM_SKIP type INT4 optional
    exporting
      !ET_ORDENS type /PTLOMS/CT036
      !ET_TEXTOS_ORDEM type /PTLOMS/CT037
      !ET_TEXTOS_OPERACOES type /PTLOMS/CT037
      !ET_OPERACOES_ORDEM type /PTLOMS/CT038
      !ET_COMPONENTES_ORDEM type /PTLOMS/CT039
      !ET_CONFIRMACOES type /PTLOMS/CT075
      !ET_IMAGENS_ORDEM type /PTLOMS/CT072
      !ET_FILTRO_ORDEM type /PTLOMS/CT056
      !ET_FILTRO_NOTA type /PTLOMS/CT056
      !ET_FILTRO_TIPO_ORDEM type /PTLOMS/CT056
      !ET_FILTRO_INICIO_BASE type /PTLOMS/CT056
      !ET_FILTRO_FIM_BASE type /PTLOMS/CT056
      !ET_FILTRO_LOCAL_INSTALACAO type /PTLOMS/CT056
      !ET_FILTRO_EQUIPAMENTO type /PTLOMS/CT056
      !ET_FILTRO_GRUPO_PLANEJAMENTO type /PTLOMS/CT056
      !ET_FILTRO_CENTRO_TRABALHO type /PTLOMS/CT056
      !ET_FILTRO_CODIGO_ABC type /PTLOMS/CT056
      !ET_FILTRO_PLANO_MANUTENCAO type /PTLOMS/CT056
      !ET_FILTRO_CICLO type /PTLOMS/CT056
      !ET_FILTRO_TIPO_ATVD_MANUTENCAO type /PTLOMS/CT056
      !EX_QUANTIDADE_ORDEM type INT4 .
  methods OUT_IMAGEM
    importing
      !RT_INSTID_A type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TYPEID_A type /IWBEP/T_COD_SELECT_OPTIONS
    returning
      value(RT_ANEXOS) type /PTLOMS/CT072 .
  methods OUT_ESTOQUE_MATERIAL
    importing
      !RT_MATNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_WERKS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_LGORT type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
    exporting
      !ET_SALDO type /PTLOMS/CT064 .
  methods OUT_HORAS_PLAN_REAL
    importing
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATA type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !ET_HORAS_PLAN_REL type /PTLOMS/CT070 .
  methods OUT_USUARIO
    importing
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !ET_DADOS_USUARIO_APP type /PTLOMS/CT101 .
  methods OUT_MONTA_RANGE_DATA_USUARIO
    importing
      !IM_USUARIO type XUBNAME
    returning
      value(RT_DATA) type /IWBEP/T_COD_SELECT_OPTIONS .
  methods OUT_MATRICULA
    exporting
      !ET_MATRICULAS type /PTLOMS/CT073 .
  methods OUT_CONFIGURACAO_SISTEMA
    exporting
      !ET_CONFIGURACAO_SISTEMA type /PTLOMS/CT074 .
  methods OUT_LOG
    importing
      !RT_DATE_FROM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATE_TO type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TIME_FROM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TIME_TO type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USER_ID type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !ET_LOG type /PTLOMS/CT077 .
  class-methods OUT_IDIOMA_USUARIO
    importing
      !IM_USUARIO type UNAME
    returning
      value(RM_IDIOMA) type LANGU .
  methods OUT_INFOLOG
    importing
      !RT_DATE_FROM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATE_TO type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TIME_FROM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TIME_TO type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USER_ID type /IWBEP/T_COD_SELECT_OPTIONS .
  methods OUT_PROGRAMACAO_USUARIOS
    importing
      !RT_WERKS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_AUFNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_AUART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_QMNUM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_PRIOK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TPLNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_EQUNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_IWERK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_INGPR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ILART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GEWRK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GSTRP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATOPE type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUAPP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_F_TREE type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_MAT_AT type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_OPER type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ORDENS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GSTRP_INI type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATOPE_INI type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GSTRP_FIM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATOPE_FIM type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !IT_DESPACHO_TREE type /PTLOMS/CT080 .
  methods OUT_PROGRAMACAO_ORDENS
    importing
      !RT_WERKS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_AUFNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_VORNR type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_AUART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_QMNUM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_PRIOK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_TPLNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_EQUNR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_IWERK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_INGPR type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ILART type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GEWRK type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GSTRP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATOPE type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USUAPP type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_F_TREE type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_MAT_AT type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_OPER type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ORDENS type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GSTRP_INI type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATOPE_INI type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_GSTRP_FIM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_DATOPE_FIM type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ERNAM type /IWBEP/T_COD_SELECT_OPTIONS optional
      !RT_VLSCH type /IWBEP/T_COD_SELECT_OPTIONS optional
    exporting
      !IT_DESPACHO type /PTLOMS/CT079
      !IT_FILTRO type /PTLOMS/CT103 .
  methods OUT_VARIANT_VALUES
    importing
      !RT_VARIANT type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !IT_VARIANT_VALUES type /PTLOMS/CT082 .
  methods OUT_VARIANT
    importing
      !RT_VAR_USUARIO type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !IT_VARIANT type /PTLOMS/CT081 .
  methods OUT_LAYOUT_VALUES
    importing
      !RT_ID_LAYOUT type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !IT_LAYOUT_VALUES type /PTLOMS/CT084 .
  methods OUT_LAYOUT
    importing
      !RT_TABELA type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_USARIO type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_PADRAO type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !IT_LAYOUT type /PTLOMS/CT083 .
  methods OUT_VARIANT_UPDATE
    importing
      !IV_VARIANT type /PTLOMS/ET122 .
  methods OUT_VARIANT_DELETE
    importing
      !IV_VAR_KEY type STRING .
  methods OUT_VARIANT_CREATE
    importing
      !IV_VARIANT type /PTLOMS/ET122 .
  methods OUT_ORDEM_PERFIL_USUARIO
    importing
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
    exporting
      !ET_ORDENS type /PTLOMS/CT109 .
  methods OUT_NOTA_PERFIL_USUARIO
    importing
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS optional
    exporting
      !ET_NOTAS type /PTLOMS/CT110 .
protected section.
private section.

  methods OUT_LOCAL_INSTALACAO_V2
    importing
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !RT_LOCL type /IWBEP/T_COD_SELECT_OPTIONS .
  methods OUT_EQUIPAMENTO_V2
    importing
      !RT_USUARIO_APP type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      !RT_EQUNR type /IWBEP/T_COD_SELECT_OPTIONS .
  methods OUT_FILTRO
    importing
      !IM_VALUE type ANY
      !IM_FIELD type ANY
      !IM_DATA_ELEMENT type ROLLNAME
    changing
      !IT_FILTRO type /PTLOMS/CT103 .
  methods OUT_CHAVE_MODELO
    exporting
      !ET_CHAVE_MODELO type /PTLOMS/CT085 .
  methods OUT_PRIORIDADE
    exporting
      !ET_PRIORIDADE type /PTLOMS/CT112 .
ENDCLASS.



CLASS /PTLOMS/CL012 IMPLEMENTATION.


  METHOD out_catalogo.
*
**   Declaração de range
*    DATA: r_codegruppe  TYPE RANGE OF qpgt-codegruppe,
*          ls_codegruppe LIKE LINE OF r_codegruppe.
*
**   Declaração de tabela interna
*    DATA: lt_t352c      TYPE STANDARD TABLE OF /ptloms/cl007=>ty_t352c. "ty_t352c,
****       lt_t352c_nota TYPE STANDARD TABLE OF /ptloms/cl007=>ty_t352c. "ty_t352c.
*
**   Declaração de estrutura
*    DATA: ls_catalogos LIKE LINE OF rt_catalogos,
*          ls_t352c     TYPE /ptloms/cl007=>ty_t352c. "ty_t352c.
*
**   Verifica se parâmetro de entrada está preenchido
*    IF rt_rbnr[] IS INITIAL.
*      RETURN.
*    ENDIF.
*
*** Monta range com tipo específico
**    LOOP AT rt_rbnr INTO DATA(ls_rbnr_aux).
**      CLEAR ls_rbnr.
**      MOVE: ls_rbnr_aux-sign   TO ls_rbnr-sign,
**            ls_rbnr_aux-option TO ls_rbnr-option,
**            ls_rbnr_aux-low    TO ls_rbnr-low,
**            ls_rbnr_aux-high   TO ls_rbnr-high.
**      APPEND ls_rbnr TO r_rbnr.
**    ENDLOOP.
*
** Busca Tipos de catálogo por esquema de relatório
** OBS: Os tipos B,C e 5 são os tipo utilizados atualmente e foram solicitads
**      pelo consultor funcional Cristian Reis, que fossem fixos no código
**    SELECT rbnr, qkatart, qcodegrp
**      FROM t352c
**      INTO CORRESPONDING FIELDS OF TABLE @lt_t352c
**      WHERE rbnr IN @rt_rbnr
**        AND ( qkatart EQ 'B' OR
**              qkatart EQ 'C' OR
**              qkatart EQ '5' ).
*
*    /ptloms/cl007=>select_t352c( EXPORTING rt_table_in = rt_rbnr
*                                IMPORTING rt_table_out = lt_t352c ).
*
**********************************************************************************************************
****  Trecho do código abaixo REVISADO em 29/04/2024 em função da incompatibilidade de versão com a SOLAR.
**********************************************************************************************************
****  INICIO
**********************************************************************************************************
*    TYPES: BEGIN OF ty_tipo_nota,
*             qmart TYPE /ptloms/tb009-qmart,
*             rbnr  TYPE tq80-rbnr,
*           END OF ty_tipo_nota.
*
*    DATA: lt_tipo_nota TYPE TABLE OF ty_tipo_nota.
*
**   Busca todos os tipos de Nota
*    SELECT a~qmart b~rbnr
*      FROM /ptloms/tb009 AS a INNER JOIN tq80 AS b
*      ON a~qmart = b~qmart
*      INTO TABLE lt_tipo_nota.
*
****    SELECT a~qmart, b~rbnr FROM /ptloms/tb009 AS a
****      INNER JOIN tq80 AS b ON a~qmart = b~qmart
****      INTO TABLE @DATA(lt_tipo_nota).
*
*    IF sy-subrc EQ 0.
*
*      IF lt_tipo_nota[] IS NOT INITIAL.
*
**       Busca Tipos de catálogo por esquema de relatório dos Tipos de Notas
*        TYPES: BEGIN OF ty_t352c_nota,
*                 rbnr     TYPE t352c-rbnr,
*                 qkatart  TYPE t352c-qkatart,
*                 qcodegrp TYPE t352c-qcodegrp,
*               END OF ty_t352c_nota.
*
*        DATA: lt_t352c_nota TYPE TABLE OF ty_t352c_nota.
*
*        SELECT rbnr qkatart qcodegrp
*        FROM t352c
*        INTO CORRESPONDING FIELDS OF TABLE lt_t352c_nota
*        FOR ALL ENTRIES IN lt_tipo_nota
*        WHERE rbnr EQ lt_tipo_nota-rbnr
*          AND ( qkatart EQ 'B' OR
*                qkatart EQ 'C' OR
*                qkatart EQ '5' ).
*
****        SELECT rbnr, qkatart, qcodegrp
****          FROM t352c
****          INTO CORRESPONDING FIELDS OF TABLE @lt_t352c_nota
****          FOR ALL ENTRIES IN @lt_tipo_nota
****          WHERE rbnr EQ @lt_tipo_nota-rbnr
****                  AND ( qkatart EQ 'B' OR
****                        qkatart EQ 'C' OR
****                        qkatart EQ '5' ).
*
*        LOOP AT lt_tipo_nota INTO DATA(ls_tipo_nota).
*          CLEAR ls_t352c.
*
*          LOOP AT lt_t352c_nota INTO DATA(ls_t352c_nota) WHERE rbnr = ls_tipo_nota-rbnr.
*            MOVE-CORRESPONDING ls_t352c_nota TO ls_t352c.
*            ls_t352c-qmart = ls_tipo_nota-qmart.
*            APPEND ls_t352c TO lt_t352c.
*          ENDLOOP.
*
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
*
*    IF lt_t352c[] IS NOT INITIAL.
*
*      DATA(lt_t352c_with_qcodegrp)    = lt_t352c[].
*      DATA(lt_t352c_without_qcodegrp) = lt_t352c[].
*
*      IF lt_t352c_without_qcodegrp[] IS NOT INITIAL.
*
*        TYPES: BEGIN OF ty_qpgt_aux,
*                 katalogart TYPE qpgt-katalogart,
*                 codegruppe TYPE qpgt-codegruppe,
*                 kurztext   TYPE qpgt-kurztext,
*               END OF ty_qpgt_aux.
*
*        DATA: lt_qpgt_aux TYPE TABLE OF ty_qpgt_aux.
*
*        SELECT katalogart codegruppe kurztext
*            INTO TABLE lt_qpgt_aux
*            FROM qpgt
*            FOR ALL ENTRIES IN lt_t352c_without_qcodegrp
*            WHERE katalogart = lt_t352c_without_qcodegrp-qkatart
*              AND sprache    = sy-langu.
*
****        SELECT katalogart, codegruppe, kurztext
****            INTO TABLE @DATA(lt_qpgt_aux)
****            FROM qpgt
****            FOR ALL ENTRIES IN @lt_t352c_without_qcodegrp
****            WHERE katalogart = @lt_t352c_without_qcodegrp-qkatart
****              AND sprache    = @sy-langu.
*
** I
**       DELETE lt_t352c WHERE qcodegrp = '*'.
** F
*        DATA ls_t352c_aux LIKE LINE OF lt_t352c.
*
*        LOOP AT lt_t352c_without_qcodegrp INTO DATA(ls_t352c_without_qcodegrp).
*
*          CLEAR ls_t352c_aux.
*
*          ls_t352c_aux-rbnr    = ls_t352c_without_qcodegrp-rbnr.
*          ls_t352c_aux-qkatart = ls_t352c_without_qcodegrp-qkatart.
*          ls_t352c_aux-qmart   = ls_t352c_without_qcodegrp-qmart.
*
** I
*          DELETE lt_t352c WHERE rbnr     = ls_t352c_without_qcodegrp-rbnr
*                            AND qkatart  = ls_t352c_without_qcodegrp-qkatart
*                            AND qcodegrp = ls_t352c_without_qcodegrp-qcodegrp
*                            AND qmart    = ls_t352c_without_qcodegrp-qmart.
*
*          REFRESH r_codegruppe[].
*          CLEAR ls_codegruppe.
*          ls_codegruppe-sign = 'I'.
*          ls_codegruppe-option = 'CP'.
*          ls_codegruppe-low = ls_t352c_without_qcodegrp-qcodegrp.
*          APPEND ls_codegruppe TO r_codegruppe.
** F
*
****       LOOP AT lt_qpgt_aux INTO DATA(ls_qpgt_aux) WHERE katalogart = ls_t352c_without_qcodegrp-qkatart.
*          DATA: ls_qpgt_aux TYPE ty_qpgt_aux.
*          LOOP AT lt_qpgt_aux INTO ls_qpgt_aux WHERE katalogart = ls_t352c_without_qcodegrp-qkatart.
*
*            IF ls_qpgt_aux-codegruppe NOT IN r_codegruppe.
*              CONTINUE.
*            ENDIF.
*
*            ls_t352c_aux-qcodegrp = ls_qpgt_aux-codegruppe.
*            APPEND ls_t352c_aux TO lt_t352c.
*          ENDLOOP.
*
*        ENDLOOP.
*      ENDIF.
*
**     Buscar Textos grupos de codes
*      IF lt_t352c[] IS NOT INITIAL.
*
**       Seleciona Textos codes
*        TYPES: BEGIN OF ty_qpgt,
*                 katalogart TYPE qpgt-katalogart,
*                 codegruppe TYPE qpgt-codegruppe,
*                 kurztext   TYPE qpct-kurztext,
*               END OF ty_qpgt.
*
*        DATA: lt_qpgt TYPE TABLE OF ty_qpgt.
*
*        SELECT katalogart codegruppe kurztext
*          INTO TABLE lt_qpgt
*          FROM qpgt
*          FOR ALL ENTRIES IN lt_t352c
*          WHERE katalogart = lt_t352c-qkatart
*            AND codegruppe = lt_t352c-qcodegrp
*            AND sprache    = sy-langu.
*
****        SELECT katalogart, codegruppe, kurztext
****          INTO TABLE @DATA(lt_qpgt)
****          FROM qpgt
****          FOR ALL ENTRIES IN @lt_t352c
****          WHERE katalogart = @lt_t352c-qkatart
****            AND codegruppe = @lt_t352c-qcodegrp
****            AND sprache    = @sy-langu.
*
*      ENDIF.
*
*      IF lt_qpgt[] IS NOT INITIAL.
*
**       Seleciona Textos codes
*        TYPES: BEGIN OF ty_qpct_aux,
*                 katalogart TYPE qpct-katalogart,
*                 codegruppe TYPE qpct-codegruppe,
*                 code       TYPE qpct-code,
*                 sprache    TYPE qpct-sprache,
*                 version    TYPE qpct-version,
*                 kurztext   TYPE qpct-kurztext,
*               END OF ty_qpct_aux.
*
*        DATA: lt_qpct TYPE TABLE OF ty_qpct_aux.
*
*        SELECT katalogart codegruppe code sprache version kurztext
*          FROM qpct
*          INTO TABLE lt_qpct
*          FOR ALL ENTRIES IN lt_qpgt
*          WHERE katalogart = lt_qpgt-katalogart
*            AND codegruppe = lt_qpgt-codegruppe
*            AND sprache    = sy-langu.
*
****        SELECT katalogart, codegruppe, code, sprache, version, kurztext
****          FROM qpct
****          INTO TABLE @DATA(lt_qpct)
****          FOR ALL ENTRIES IN @lt_qpgt
****          WHERE katalogart = @lt_qpgt-katalogart
****            AND codegruppe = @lt_qpgt-codegruppe
****            AND sprache    = @sy-langu.
*
*      ENDIF.
*    ENDIF.
*
**********************************************************************************************************
****  FIM
**********************************************************************************************************
*
**   Montagem de dados de saída
*    LOOP AT lt_t352c INTO ls_t352c.
*
*      CLEAR ls_catalogos.
*
*      ls_catalogos-rbnr    = ls_t352c-rbnr.
*      ls_catalogos-qkatart = ls_t352c-qkatart.
*      ls_catalogos-qmart   = ls_t352c-qmart.
*      READ TABLE lt_qpgt INTO DATA(ls_qpgt) WITH KEY katalogart = ls_t352c-qkatart
*                                                     codegruppe = ls_t352c-qcodegrp.
*      IF sy-subrc EQ 0.
*
*        ls_catalogos-parnr = ls_qpgt-codegruppe.
*        ls_catalogos-name1 = ls_qpgt-kurztext.
*
*        LOOP AT lt_qpct INTO DATA(ls_qpct) WHERE katalogart = ls_qpgt-katalogart
*                                             AND codegruppe = ls_qpgt-codegruppe.
*          ls_catalogos-stras = ls_qpct-code.
*          ls_catalogos-telf1 = ls_qpct-kurztext.
*          APPEND ls_catalogos TO rt_catalogos.
*        ENDLOOP.
*
*        IF sy-subrc NE 0.
*          APPEND ls_catalogos TO rt_catalogos.
*        ENDIF.
*      ENDIF.
*
*    ENDLOOP.


  ENDMETHOD.


  METHOD OUT_CHAVE_MODELO.

*** Declaração de tabela interna
**    DATA: lt_tline TYPE TABLE OF tline.
**
*** Declaração de estrutura
**    DATA: ls_chave_modelo LIKE LINE OF et_chave_modelo.
**
*** Declaração de variáveis
**    DATA: lv_id           TYPE thead-tdid,
**          lv_language     TYPE thead-tdspras,
**          lv_name         TYPE thead-tdname,
**          lv_object       TYPE thead-tdobject,
**          lv_quebra_linha TYPE string VALUE cl_abap_char_utilities=>newline..
**
**    MOVE: 'SUBM'   TO lv_id,
**          sy-langu TO lv_language,
**          'WORKST' TO lv_object.
**
*** Busca Chave Modelo
**    SELECT *
**      FROM t435t
**      INTO TABLE @DATA(lt_t435)
**      WHERE spras EQ @sy-langu.
**
**    LOOP AT lt_t435 INTO DATA(ls_t435).
**
**      CLEAR: ls_chave_modelo,
**             lv_name.
**
**      MOVE ls_t435-vlsch TO lv_name.
**
**      CALL FUNCTION 'READ_TEXT'
**        EXPORTING
**          id                      = lv_id
**          language                = lv_language
**          name                    = lv_name
**          object                  = lv_object
**        TABLES
**          lines                   = lt_tline
**        EXCEPTIONS
**          id                      = 1
**          language                = 2
**          name                    = 3
**          not_found               = 4
**          object                  = 5
**          reference_check         = 6
**          wrong_access_to_archive = 7
**          OTHERS                  = 8.
**
**      ls_chave_modelo-vlsch       = ls_t435-vlsch.
**      ls_chave_modelo-texto_breve = ls_t435-txt.
**
**      LOOP AT lt_tline INTO DATA(ls_tline).
**        DATA(lv_tabix) = sy-tabix.
**        IF lv_tabix = 2.
**          ls_chave_modelo-texto_longo = ls_tline-tdline.
**        ELSEIF lv_tabix >= 2.
**          ls_chave_modelo-texto_longo = ls_chave_modelo-texto_longo && lv_quebra_linha && ls_tline-tdline.
**        ENDIF.
**      ENDLOOP.
**
**      APPEND ls_chave_modelo TO et_chave_modelo.
**    ENDLOOP.
**
  ENDMETHOD.


  METHOD out_classe_caracterisca.
*
*    TYPES: BEGIN OF ty_char.
*             INCLUDE TYPE bapi1003_alloc_values_char.
*             TYPES: objectkey TYPE bapi1003_key-object.
*    TYPES:END OF ty_char.
*
**   Declaração de Tipos
*    TYPES: BEGIN OF ty_inob,
*             cuobj      TYPE inob-cuobj,
*             objek      TYPE inob-objek,
*             objek_conv TYPE inob-objek,
*           END OF ty_inob.
*
**   Declaração de Range
*    DATA: r_new_range  TYPE /iwbep/t_cod_select_options,
*          ls_new_range LIKE LINE OF r_new_range.
*
**   Declaração de Tabela Interna
*    DATA: "lt_inob     TYPE STANDARD TABLE OF ty_inob,
*          lt_char_aux TYPE STANDARD TABLE OF ty_char.
*
**   Declaração de estrutura
*    DATA: ls_caracteristicas LIKE LINE OF rt_caracteristicas,
*          ls_char_aux        TYPE ty_char.
*
**   Declaração de variável
*    DATA: lv_char_field TYPE cha_class_view-sollwert.
*
**   Declaração de Parâmetros da BAPI
*    DATA: lv_objectkey   TYPE  bapi1003_key-object,
*          lv_objecttable TYPE  bapi1003_key-objecttable,
*          lv_classnum    TYPE  bapi1003_key-classnum,
*          lv_classtype   TYPE  bapi1003_key-classtype,
*          lt_char        TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
*          lt_num         TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
*          lt_curr        TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
*          lt_return      TYPE STANDARD TABLE OF bapiret2.
*
**   Verifica se parâmetro de entrada está preenchido
*    IF rt_objek IS INITIAL.
*      RETURN.
*    ENDIF.
*
*    DATA lt_ausp TYPE /ptloms/cl007=>ct_ausp.
*    /ptloms/cl007=>select_ausp( EXPORTING rt_table_in  = rt_objek
*                                IMPORTING rt_table_out = lt_ausp ).
*
*    DATA: lt_inob TYPE /ptloms/cl007=>ct_inob.
*    /ptloms/cl007=>select_inob( EXPORTING rt_table_in  = rt_objek
*                                IMPORTING rt_table_out = lt_inob ).
*
*    IF lt_inob[] IS NOT INITIAL.
*
**********************************************************************************************************
****  Trecho do código abaixo REVISADO em 29/04/2024 em função da incompatibilidade de versão com a SOLAR.
**********************************************************************************************************
****  INICIO
**********************************************************************************************************
*      FIELD-SYMBOLS: <fs_inob> LIKE LINE OF lt_inob.
*
*      LOOP AT lt_inob INTO <fs_inob>.
*        <fs_inob>-objek_conv = <fs_inob>-cuobj.
*      ENDLOOP.
*
**     Seleciona Textos codes
*      SELECT objek atinn atzhl mafid klart adzhl atwrt atflv
*        FROM ausp
*        APPENDING TABLE lt_ausp
*        FOR ALL ENTRIES IN lt_inob
*        WHERE objek = lt_inob-objek_conv.
*
****      LOOP AT lt_inob ASSIGNING FIELD-SYMBOL(<fs_inob>).
****        <fs_inob>-objek_conv = <fs_inob>-cuobj.
****      ENDLOOP.
****
****      SELECT objek, atinn, atzhl, mafid, klart, adzhl, atwrt, atflv
****        FROM ausp
****        APPENDING TABLE @lt_ausp
****        FOR ALL ENTRIES IN @lt_inob
****        WHERE objek = @lt_inob-objek_conv.
*
*    ENDIF.
*
** Se não encontrar registros, então sair do método
*    IF lt_ausp[] IS INITIAL.
*      RETURN.
*    ENDIF.
*
** Seleciona Equipamentos
**    SELECT equnr
**      FROM equi
**      INTO TABLE @DATA(lt_equi)
**      WHERE equnr IN @rt_objek.
*
*    DATA: lt_equi TYPE /ptloms/cl007=>ct_equi.
*    /ptloms/cl007=>select_equi( EXPORTING rt_table_in  = rt_objek
*                                IMPORTING rt_table_out = lt_equi ).
*
** Seleciona Locais de Instalação
**    SELECT tplnr
**      FROM iflot
**      INTO TABLE @DATA(lt_iflot)
**      WHERE tplnr IN @rt_objek.
*
*    DATA: lt_iflot TYPE /ptloms/cl007=>ct_iflot.
*    /ptloms/cl007=>select_iflot( EXPORTING rt_table_in  = rt_objek
*                                 IMPORTING rt_table_out = lt_iflot ).
*
**   Seleciona texto para características
*    TYPES: BEGIN OF ty_cabnt,
*             atinn TYPE cabnt-atinn,
*             spras TYPE cabnt-spras,
*             adzhl TYPE cabnt-adzhl,
*             atbez TYPE cabnt-atbez,
*           END OF ty_cabnt.
*
*    DATA: lt_cabnt TYPE TABLE OF ty_cabnt.
*
*    SELECT atinn spras adzhl atbez
*      FROM cabnt
*      INTO TABLE lt_cabnt
*      FOR ALL ENTRIES IN lt_ausp
*      WHERE atinn = lt_ausp-atinn
*        AND spras = sy-langu.
*
****    SELECT atinn, spras, adzhl, atbez
****      FROM cabnt
****      INTO TABLE @DATA(lt_cabnt)
****      FOR ALL ENTRIES IN @lt_ausp
****      WHERE atinn = @lt_ausp-atinn
****        AND spras = @sy-langu.
*
**   Seleciona CLINT
*    TYPES: BEGIN OF ty_ksml,
*             clint TYPE ksml-clint,
*             posnr TYPE ksml-posnr,
*             adzhl TYPE ksml-adzhl,
*             imerk TYPE ksml-imerk,
*           END OF ty_ksml.
*
*    DATA: lt_ksml TYPE TABLE OF ty_ksml.
*
*    SELECT clint posnr adzhl imerk
*      FROM ksml
*      INTO TABLE lt_ksml
*      FOR ALL ENTRIES IN lt_ausp
*      WHERE imerk = lt_ausp-atinn.
*
****    SELECT clint, posnr, adzhl, imerk
****      FROM ksml
****      INTO TABLE @DATA(lt_ksml)
****      FOR ALL ENTRIES IN @lt_ausp
****      WHERE imerk = @lt_ausp-atinn.
*
**   Seleciona atribuições
*    TYPES: BEGIN OF ty_kssk,
*             objek TYPE kssk-objek,
*             mafid TYPE kssk-mafid,
*             klart TYPE kssk-klart,
*             clint TYPE kssk-clint,
*             adzhl TYPE kssk-adzhl,
*           END OF ty_kssk.
*
*    DATA: lt_kssk TYPE TABLE OF ty_kssk.
*
*    SELECT objek mafid klart clint adzhl
*      FROM kssk
*      INTO TABLE lt_kssk
*      FOR ALL ENTRIES IN lt_ausp
*      WHERE objek = lt_ausp-objek.
*
****    SELECT objek, mafid, klart,clint, adzhl
****      FROM kssk
****      INTO TABLE @DATA(lt_kssk)
****      FOR ALL ENTRIES IN @lt_ausp
****      WHERE objek = @lt_ausp-objek.
*
*    IF lt_kssk[] IS NOT INITIAL.
*
**     Seleciona dados do cabeçalho da Classe
*      TYPES: BEGIN OF ty_klah,
*               clint TYPE klah-clint,
*               class TYPE klah-class,
*             END OF ty_klah.
*
*      DATA: lt_klah TYPE TABLE OF ty_klah.
*
*      SELECT clint class
*        FROM klah
*        INTO TABLE lt_klah
*        FOR ALL ENTRIES IN lt_kssk
*        WHERE clint = lt_kssk-clint.
*
****      SELECT clint, class
****        FROM klah
****        INTO TABLE @DATA(lt_klah)
****        FOR ALL ENTRIES IN @lt_kssk
****        WHERE clint = @lt_kssk-clint.
*
**     Seleciona Sistema de Classificação
*      TYPES: BEGIN OF ty_swor,
*               clint TYPE swor-clint,
*               spras TYPE swor-spras,
*               klpos TYPE swor-klpos,
*               kschl TYPE swor-kschl,
*             END OF ty_swor.
*
*      DATA: lt_swor TYPE TABLE OF ty_swor.
*
*      SELECT clint spras klpos kschl
*        FROM swor
*        INTO TABLE lt_swor
*        FOR ALL ENTRIES IN lt_kssk
*        WHERE clint = lt_kssk-clint
*          AND spras = sy-langu.
*
****      SELECT clint, spras,klpos, kschl
****        FROM swor
****        INTO TABLE @DATA(lt_swor)
****        FOR ALL ENTRIES IN @lt_kssk
****        WHERE clint = @lt_kssk-clint
****          AND spras = @sy-langu.
*
*    ENDIF.
*
** Monta tabela de saída
**** LOOP AT lt_ausp INTO DATA(ls_ausp).
*    DATA: ls_ausp LIKE LINE OF lt_ausp.
*    LOOP AT lt_ausp INTO ls_ausp.
*
*      " Limpa estrutura
*      CLEAR ls_caracteristicas.
*
*      " Objeto
*      MOVE ls_ausp-objek TO ls_caracteristicas-objek.
*
*      " Característica
****   READ TABLE lt_cabnt INTO DATA(ls_cabnt) WITH KEY atinn = ls_ausp-atinn.
*      DATA: ls_cabnt LIKE LINE OF lt_cabnt.
*      READ TABLE lt_cabnt INTO ls_cabnt WITH KEY atinn = ls_ausp-atinn.
*      IF sy-subrc EQ 0.
*        MOVE ls_cabnt-atbez TO ls_caracteristicas-atbez.
*      ENDIF.
*
*      " Valor
*      IF ls_ausp-atwrt IS NOT INITIAL.
*        MOVE ls_ausp-atwrt TO ls_caracteristicas-valor.
*      ELSE.
*        CALL FUNCTION 'QSS0_FLTP_TO_CHAR_CONVERSION'
*          EXPORTING
*            i_number_of_digits = 2
*            i_fltp_value       = ls_ausp-atflv
*          IMPORTING
*            e_char_field       = lv_char_field.
*
*        MOVE lv_char_field TO ls_caracteristicas-valor.
*
*        CLEAR lv_char_field.
*      ENDIF.
*
*      " Clint
*
****   LOOP AT lt_ksml INTO DATA(ls_ksml) WHERE imerk = ls_ausp-atinn.
*      DATA: ls_ksml LIKE LINE OF lt_ksml.
*      LOOP AT lt_ksml INTO ls_ksml WHERE imerk = ls_ausp-atinn.
*
****     READ TABLE lt_kssk INTO DATA(ls_kssk) WITH KEY objek = ls_ausp-objek
****                                                    clint = ls_ksml-clint.
*        DATA: ls_kssk LIKE LINE OF lt_kssk.
*        READ TABLE lt_kssk INTO ls_kssk WITH KEY objek = ls_ausp-objek
*                                                 clint = ls_ksml-clint.
*        IF sy-subrc EQ 0.
*          ls_caracteristicas-clint = ls_ksml-clint.
*        ELSE.
*          CONTINUE.
*        ENDIF.
*
*        " Classe
****     READ TABLE lt_klah INTO DATA(ls_klah) WITH KEY clint = ls_ksml-clint.
*        DATA: ls_klah LIKE LINE OF lt_klah.
*        READ TABLE lt_klah INTO ls_klah WITH KEY clint = ls_ksml-clint.
*        IF sy-subrc EQ 0.
*          ls_caracteristicas-class = ls_klah-class.
*        ENDIF.
*
*        " Denominação
****     READ TABLE lt_swor INTO DATA(ls_swor) WITH KEY clint = ls_ksml-clint.
*        DATA: ls_swor LIKE LINE OF lt_swor.
*        READ TABLE lt_swor INTO ls_swor WITH KEY clint = ls_ksml-clint.
*        IF sy-subrc EQ 0.
*          ls_caracteristicas-klschl = ls_swor-kschl.
*        ENDIF.
*
*        " Limpa variáveis da BAPI
*        CLEAR: lv_objectkey, lv_objecttable, lv_classnum, lv_classtype.
*        REFRESH: lt_num[], lt_char[], lt_curr[], lt_return[].
*
*        " Verifica se Objeto é Equipamento ou Local de Instalação
*        DATA: ls_equi LIKE LINE OF lt_equi.
*        READ TABLE lt_equi INTO ls_equi WITH KEY equnr = ls_ausp-objek.
*
*        IF sy-subrc NE 0.
*
*          DATA: ls_iflot LIKE LINE OF lt_iflot.
*          READ TABLE lt_iflot INTO ls_iflot WITH KEY tplnr = ls_ausp-objek.
*
*          IF sy-subrc NE 0.
*
*            DATA: ls_inob LIKE LINE OF lt_inob.
*            READ TABLE lt_inob INTO ls_inob WITH KEY cuobj = ls_ausp-objek.
*
*            IF sy-subrc EQ 0.
*
*              READ TABLE lt_equi INTO ls_equi WITH KEY equnr = ls_inob-objek.
*
*              IF sy-subrc NE 0.
*
*                READ TABLE lt_iflot INTO ls_iflot WITH KEY tplnr = ls_inob-objek.
*
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
*
****        IF sy-subrc NE 0.
****          READ TABLE lt_iflot INTO DATA(ls_iflot) WITH KEY tplnr = ls_ausp-objek.
****          IF sy-subrc NE 0.
****            READ TABLE lt_inob INTO DATA(ls_inob) WITH KEY cuobj = ls_ausp-objek.
****            IF sy-subrc EQ 0.
****              READ TABLE lt_equi INTO ls_equi WITH KEY equnr = ls_inob-objek.
****              IF sy-subrc NE 0.
****                READ TABLE lt_iflot INTO ls_iflot WITH KEY tplnr = ls_inob-objek.
****              ENDIF.
****            ENDIF.
****          ENDIF.
****        ENDIF.
*
*        " Carrega OBJECTKEY e OBJECTTABLE
*        IF ls_equi IS NOT INITIAL.
*          MOVE: ls_equi-equnr TO lv_objectkey,
*                'EQUI'        TO lv_objecttable,
*                '002'         TO lv_classtype.
*        ELSEIF ls_iflot IS NOT INITIAL.
*          MOVE: ls_iflot-tplnr TO lv_objectkey,
*                'IFLOT'        TO lv_objecttable,
*                '003'          TO lv_classtype.
*        ENDIF.
*
*        " Carrega CLASSNUM
*        MOVE: ls_klah-class TO lv_classnum.
*
*        IF lv_objectkey IS NOT INITIAL.
*
*          READ TABLE lt_char_aux INTO ls_char_aux WITH KEY objectkey     = lv_objectkey
*                                                           charact_descr = ls_cabnt-atbez.
*          IF sy-subrc EQ 0.
*            MOVE: ls_char_aux-value_char TO ls_caracteristicas-valor.
*          ELSE.
*
*            " Executa BAPI
*            CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
*              EXPORTING
*                objectkey       = lv_objectkey
*                objecttable     = lv_objecttable
*                classnum        = lv_classnum
*                classtype       = lv_classtype
*              TABLES
*                allocvaluesnum  = lt_num
*                allocvalueschar = lt_char
*                allocvaluescurr = lt_curr
*                return          = lt_return.
*
*            IF lt_char[] IS NOT INITIAL.
*
****           READ TABLE lt_char INTO DATA(ls_char) WITH KEY charact_descr = ls_cabnt-atbez.
*              DATA: ls_char LIKE LINE OF lt_char .
*              READ TABLE lt_char INTO ls_char WITH KEY charact_descr = ls_cabnt-atbez.
*
*              IF sy-subrc EQ 0.
*                MOVE: ls_char-value_char TO ls_caracteristicas-valor.
*                CLEAR ls_char_aux.
*                ls_char_aux-objectkey = lv_objectkey.
*                MOVE-CORRESPONDING ls_char TO ls_char_aux.
*                APPEND ls_char_aux TO lt_char_aux.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
*        APPEND ls_caracteristicas TO rt_caracteristicas.
*
*      ENDLOOP.
*
*      IF sy-subrc NE 0.
*        " Inclui registro na tabela de característica
*        APPEND ls_caracteristicas TO rt_caracteristicas.
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD OUT_CONFIGURACAO_SISTEMA.

**    SELECT * FROM /ptloms/tb033 INTO CORRESPONDING FIELDS OF TABLE @et_configuracao_sistema.

  ENDMETHOD.


 METHOD OUT_DEMAIS_DADOS_MESTRES.
***
***    IF rt_usuario_app IS NOT INITIAL.
***      SELECT SINGLE perfil FROM /ptloms/tb013 INTO @DATA(lv_perfil) WHERE usuario IN @rt_usuario_app.
***    ENDIF.
***
****   Busca Empresa/Centro
***    IF im_empresa_centro IS NOT INITIAL.
***      IF lv_perfil IS NOT INITIAL.
***        SELECT a~bukrs, b~butxt, c~werks, c~name1
***          FROM /ptloms/tb014 AS a INNER JOIN t001 AS b ON a~bukrs = b~bukrs
***          INNER JOIN t001w AS c ON a~werks = c~bwkey
***          INTO CORRESPONDING FIELDS OF TABLE @et_empresa_centro
***          WHERE a~perfil = @lv_perfil.
***      ELSE.
***
***        SELECT a~bukrs, a~butxt, c~werks, c~name1
***          FROM t001 AS a INNER JOIN t001k AS b ON a~bukrs = b~bukrs
***          INNER JOIN t001w AS c ON b~bwkey = c~bwkey
***          INTO CORRESPONDING FIELDS OF TABLE @et_empresa_centro.
***      ENDIF.
***    ENDIF.
***
****   Busca Grupo de Planejamento
***    IF im_grupo_planejamento IS NOT INITIAL.
***      IF lv_perfil IS NOT INITIAL.
***        SELECT a~iwerk, a~ingrp, b~innam
***          FROM /ptloms/tb015 AS a INNER JOIN t024i AS b ON a~iwerk = b~iwerk AND a~ingrp = b~ingrp
***          INTO CORRESPONDING FIELDS OF TABLE @et_grupo_planejamento
***          WHERE a~perfil = @lv_perfil.
***      ELSE.
***
***        SELECT iwerk, ingrp, innam
***          FROM t024i
***          INTO CORRESPONDING FIELDS OF TABLE @et_grupo_planejamento.
***      ENDIF.
***    ENDIF.
***
*******   Busca Área Operacional
******    IF im_area_operacional IS NOT INITIAL.
******      SELECT werks, beber, fing
******        FROM t357
******        INTO CORRESPONDING FIELDS OF TABLE @et_area_operacional.
******    ENDIF.
***
****   Busca Área Operacional
***    IF im_area_operacional IS NOT INITIAL.
***      SELECT werks, beber FROM /ptloms/tb016
***      INTO TABLE @DATA(lt_area_operacional)
***      WHERE perfil = @lv_perfil.
***
***      IF lt_area_operacional IS NOT INITIAL.
***        SELECT werks, beber, fing
***          FROM t357
***          INTO CORRESPONDING FIELDS OF TABLE @et_area_operacional
***          FOR ALL ENTRIES IN @lt_area_operacional
***          WHERE werks = @lt_area_operacional-werks
***            AND beber = @lt_area_operacional-beber.
***      ENDIF.
***    ENDIF.
***
****   Busca Centro de Trabalho
***    IF im_centro_trabalho IS NOT INITIAL.
***      IF lv_perfil IS NOT INITIAL.
***        SELECT a~objid, a~werks, b~arbpl, c~ktext
***          FROM /ptloms/tb017 AS a INNER JOIN crhd AS b ON a~objid = b~objid AND a~werks = b~werks
***          INNER JOIN crtx AS c ON c~objty = b~objty AND c~objid = b~objid
***          INTO CORRESPONDING FIELDS OF TABLE @et_centro_trabalho
***          WHERE a~perfil = @lv_perfil
***            AND c~spras  = @sy-langu.
***      ELSE.
***
***        SELECT a~objid, a~werks, a~arbpl, b~ktext
***          FROM crhd AS a INNER JOIN crtx AS b ON b~objty = a~objty AND b~objid = a~objid
***          INTO CORRESPONDING FIELDS OF TABLE @et_centro_trabalho
***          WHERE b~spras = @sy-langu.
***      ENDIF.
***      SORT et_centro_trabalho BY objid ASCENDING.
***    ENDIF.
***
****   Busca Tipo de Nota
***    IF im_tipo_nota IS NOT INITIAL.
***      IF lv_perfil IS NOT INITIAL.
***        SELECT d~qmart, a~qmtyp, a~rbnr, b~qmartx
***          FROM /ptloms/tb021 AS d INNER JOIN tq80 AS a ON d~qmart = a~qmart
***          INNER JOIN tq80_t AS b ON a~qmart = b~qmart
***          INNER JOIN /ptloms/tb009 AS c ON a~qmart = c~qmart
***          INTO CORRESPONDING FIELDS OF TABLE @et_tipo_nota
***          WHERE d~perfil = @lv_perfil
***            AND b~spras  = @sy-langu.
***      ELSE.
***
***        SELECT a~qmart, a~qmtyp, a~rbnr, b~qmartx
***          FROM tq80 AS a INNER JOIN tq80_t AS b ON a~qmart = b~qmart
***          INNER JOIN /ptloms/tb009 AS c ON a~qmart = c~qmart
***          INTO CORRESPONDING FIELDS OF TABLE @et_tipo_nota
***          WHERE b~spras = @sy-langu.
***      ENDIF.
***    ENDIF.
***
****   Busca Tipo de Ordem
***    IF im_tipo_ordem IS NOT INITIAL.
***      IF lv_perfil IS NOT INITIAL.
***        SELECT d~auart, a~autyp, b~txt
***          FROM /ptloms/tb022 AS d INNER JOIN t003o AS a ON d~auart = a~auart
***          INNER JOIN t003p AS b ON a~auart = b~auart
***          INNER JOIN /ptloms/tb010 AS c ON a~auart = c~auart
***          INTO CORRESPONDING FIELDS OF TABLE @et_tipo_ordem
***          WHERE d~perfil = @lv_perfil
***            AND b~spras  = @sy-langu.
***      ELSE.
***
***        SELECT a~auart, a~autyp, b~txt
***          FROM t003o AS a INNER JOIN t003p AS b ON a~auart = b~auart
***          INNER JOIN /ptloms/tb010 AS c ON a~auart = c~auart
***          INTO CORRESPONDING FIELDS OF TABLE @et_tipo_ordem
***          WHERE b~spras = @sy-langu.
***      ENDIF.
***    ENDIF.
***
****   Busca Tipo de Prioridade de Ordens
***    IF im_tipo_prioridade_ordem IS NOT INITIAL.
***      SELECT a~auart, a~artpr, b~priok, b~priokx
***        FROM t350 AS a INNER JOIN t356_t AS b ON a~artpr = b~artpr
***        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_prioridade_ordem
***        WHERE b~spras = @sy-langu.
***
***      IF et_tipo_prioridade_ordem IS NOT INITIAL.
***        LOOP AT et_tipo_prioridade_ordem INTO DATA(ls_tipo_prioridade_ordem).
***          READ TABLE et_tipo_ordem INTO DATA(ls_tipo_ordem) WITH KEY auart = ls_tipo_prioridade_ordem-auart.
***          IF sy-subrc NE 0.
***            DELETE et_tipo_prioridade_ordem.
***          ENDIF.
***        ENDLOOP.
***      ENDIF.
***    ENDIF.
***
****   Busca Tipo de Prioridade de Nota
******    IF im_tipo_prioridade_nota IS NOT INITIAL.
******      SELECT a~qmart, a~artpr, b~priok, b~priokx
******        FROM tq80 AS a INNER JOIN t356_t AS b ON a~artpr = b~artpr
******        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_prioridade_nota
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
****   Busca Tipo de Prioridade de Nota
***    IF im_tipo_prioridade_nota IS NOT INITIAL.
***      SELECT a~qmart, a~artpr, b~priok, b~priokx
***        FROM tq80 AS a INNER JOIN t356_t AS b ON a~artpr = b~artpr
***        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_prioridade_nota
***        WHERE b~spras = @sy-langu.
***
***      IF et_tipo_prioridade_nota IS NOT INITIAL.
***        LOOP AT et_tipo_prioridade_nota INTO DATA(ls_tipo_prioridade_nota).
***          READ TABLE et_tipo_nota INTO DATA(ls_tipo_nota) WITH KEY qmart = ls_tipo_prioridade_nota-qmart.
***          IF sy-subrc NE 0.
***            DELETE et_tipo_prioridade_nota.
***          ENDIF.
***        ENDLOOP.
***      ENDIF.
***    ENDIF.
***
******   Busca Tipo de Atividade de Manutenção (Ordens)
******    IF im_tipo_atv_manutencao IS NOT INITIAL.
******      SELECT a~auart, a~ilart, b~ilatx
******        FROM t350i AS a INNER JOIN t353i_t AS b ON a~ilart = b~ilart
******        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_atv_manutencao
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
****   Busca Tipo de Atividade de Manutenção (Ordens)
***    IF im_tipo_atv_manutencao IS NOT INITIAL.
***      SELECT ilart FROM /ptloms/tb025
***        INTO TABLE @DATA(lt_tam)
***        WHERE perfil = @lv_perfil.
***
***      IF lt_tam IS NOT INITIAL.
***        SELECT a~auart, a~ilart, b~ilatx
***        FROM t350i AS a INNER JOIN t353i_t AS b ON a~ilart = b~ilart
***        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_atv_manutencao
***        FOR ALL ENTRIES IN @lt_tam
***        WHERE a~ilart = @lt_tam-ilart
***          AND b~spras = @sy-langu.
***
***        IF et_tipo_atv_manutencao IS NOT INITIAL.
***          LOOP AT et_tipo_atv_manutencao INTO DATA(ls_tam).
***            READ TABLE et_tipo_ordem INTO ls_tipo_ordem WITH KEY auart = ls_tam-auart.
***            IF sy-subrc NE 0.
***              DELETE et_tipo_atv_manutencao.
***            ENDIF.
***          ENDLOOP.
***        ENDIF.
***
***      ENDIF.
***    ENDIF.
***
****   Busca Centro de Custo
******    IF im_centro_custo IS NOT INITIAL.
******      SELECT a~bukrs, a~kostl, b~ktext
******        FROM csks AS a INNER JOIN cskt AS b ON a~kokrs = b~kokrs
******                                           AND a~kostl = b~kostl
******                                           AND a~datbi = b~datbi
******        INTO CORRESPONDING FIELDS OF TABLE @et_centro_custo
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
****   Seleciona Condição de Instalação (Ordem)
***    IF im_condicao_inst_ordem IS NOT INITIAL.
***      SELECT a~anlzu, b~anlzux
***        FROM t357m AS a INNER JOIN t357m_t AS b ON a~anlzu = b~anlzu
***        INTO CORRESPONDING FIELDS OF TABLE @et_condicao_inst_ordem
***        WHERE b~spras = @sy-langu.
***    ENDIF.
***
****   Seleciona Tipo de Atividade (Operação)
******    IF im_tipo_atv_operacao IS NOT INITIAL.
******      SELECT a~objid, b~lstar, c~ktext
******        FROM crhd AS a INNER JOIN crco AS b ON a~objty = b~objty AND a~objid = b~objid
******        INNER JOIN cslt AS c ON b~kokrs = c~kokrs AND b~lstar = c~lstar
******        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_atv_operacao
******        WHERE c~spras = @sy-langu
******          AND c~datbi = '99991231'.
******    ENDIF.
***
****   Busca Tipo de Material
******    IF im_tipo_material IS NOT INITIAL.
******      SELECT a~mtart, b~mtbez
******        FROM t134 AS a INNER JOIN t134t AS b ON a~mtart = b~mtart
******        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_material
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
***    IF im_tipo_material IS NOT INITIAL.
***      SELECT mtart FROM /ptloms/tb023
***        INTO TABLE @DATA(lt_tipo_material)
***        WHERE perfil = @lv_perfil.
***
***      IF lt_tipo_material IS NOT INITIAL.
***        SELECT a~mtart, b~mtbez
***           FROM t134 AS a INNER JOIN t134t AS b ON a~mtart = b~mtart
***           INTO CORRESPONDING FIELDS OF TABLE @et_tipo_material
***           FOR ALL ENTRIES IN @lt_tipo_material
***           WHERE a~mtart = @lt_tipo_material-mtart
***             AND b~spras = @sy-langu.
***      ENDIF.
***    ENDIF.
***
***
****   Busca Categoria Item do Material
******    IF im_categoria_item_material IS NOT INITIAL.
******      SELECT a~postp, b~ptext
******        FROM t418 AS a INNER JOIN t418t AS b ON a~postp = b~postp
******        INTO CORRESPONDING FIELDS OF TABLE @et_categoria_item_material
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
**** Busca Depósitos
******    IF im_deposito IS NOT INITIAL.
******      SELECT werks, lgort, lgobe
******        FROM t001l
******        INTO CORRESPONDING FIELDS OF TABLE @et_deposito.
******    ENDIF.
***
****   Busca Depósitos
***    IF im_deposito IS NOT INITIAL.
***
****     Busca perfil depósito.
***      SELECT werks, lgort FROM /ptloms/tb030
***        INTO TABLE @DATA(lt_deposito)
***        WHERE perfil = @lv_perfil.
***
***      IF lt_deposito IS NOT INITIAL.
***        SELECT werks, lgort, lgobe
***          FROM t001l
***          FOR ALL ENTRIES IN @lt_deposito
***          WHERE werks = @lt_deposito-werks
***           AND  lgort = @lt_deposito-lgort
***          INTO CORRESPONDING FIELDS OF TABLE @et_deposito.
***      ENDIF.
***    ENDIF.
***
****Buca Categoria de Equipamento
******    IF im_categoria_equipamento IS NOT INITIAL.
******      SELECT a~eqtyp, b~typtx
******        FROM t370t AS a INNER JOIN t370u AS b ON a~eqtyp = b~eqtyp
******        INTO CORRESPONDING FIELDS OF TABLE @et_categoria_equipamento
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
***    IF im_categoria_equipamento IS NOT INITIAL.
***      SELECT eqtyp FROM /ptloms/tb019
***        INTO TABLE @DATA(lt_cat_equip)
***        WHERE perfil = @lv_perfil.
***
***      IF lt_cat_equip IS NOT INITIAL.
***        SELECT a~eqtyp, b~typtx
***          FROM t370t AS a INNER JOIN t370u AS b ON a~eqtyp = b~eqtyp
***          INTO CORRESPONDING FIELDS OF TABLE @et_categoria_equipamento
***          FOR ALL ENTRIES IN @lt_cat_equip
***          WHERE a~eqtyp = @lt_cat_equip-eqtyp
***           AND  b~spras = @sy-langu.
***      ENDIF.
***    ENDIF.
***
******* Busca Tipo de Objeto
******    IF im_tipo_objeto IS NOT INITIAL.
******      SELECT a~eqart, b~eartx
******        FROM t370k AS a INNER JOIN t370k_t AS b ON a~eqart = b~eqart
******        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_objeto
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
****   Busca Tipo de Objeto
***    IF im_tipo_objeto IS NOT INITIAL.
***      SELECT eqart FROM /ptloms/tb020
***        INTO TABLE @DATA(lt_tipo_objeto)
***        WHERE perfil = @lv_perfil.
***
***      IF lt_tipo_objeto IS NOT INITIAL.
***        SELECT a~eqart, b~eartx
***        FROM t370k AS a INNER JOIN t370k_t AS b ON a~eqart = b~eqart
***        INTO CORRESPONDING FIELDS OF TABLE @et_tipo_objeto
***          FOR ALL ENTRIES IN @lt_tipo_objeto
***        WHERE a~eqart = @lt_tipo_objeto-eqart
***          AND b~spras = @sy-langu.
***      ENDIF.
***    ENDIF.
***
**** Busca Categorias de Local de Instalação
******    IF im_categoria_loc_inst IS NOT INITIAL.
******      SELECT a~fltyp, b~typtx
******        FROM t370f AS a INNER JOIN t370f_t AS b ON a~fltyp = b~fltyp
******        INTO CORRESPONDING FIELDS OF TABLE @et_categoria_loc_inst
******        WHERE b~spras = @sy-langu.
******    ENDIF.
***
****   Busca Categorias de Local de Instalação
***    IF im_categoria_loc_inst IS NOT INITIAL.
***      SELECT fltyp FROM /ptloms/tb018
***        INTO TABLE @DATA(lt_cat_local)
***        WHERE perfil = @lv_perfil.
***
***      IF lt_cat_local IS NOT INITIAL.
***        SELECT a~fltyp, b~typtx
***          FROM t370f AS a INNER JOIN t370f_t AS b ON a~fltyp = b~fltyp
***          INTO CORRESPONDING FIELDS OF TABLE @et_categoria_loc_inst
***          FOR ALL ENTRIES IN @lt_cat_local
***          WHERE a~fltyp = @lt_cat_local-fltyp
***            AND b~spras = @sy-langu.
***      ENDIF.
***    ENDIF.
***
***
**** Busca Tipo de Atividade Ordem
******    IF im_tipo_atv_ordem IS NOT INITIAL.
******      IF lv_perfil IS NOT INITIAL.
******        SELECT c~ilart, b~ilatx
******          FROM /ptloms/tb025 AS c INNER JOIN t353i AS a ON c~ilart = a~ilart
******          INNER JOIN t353i_t AS b ON a~ilart = b~ilart
******          INTO CORRESPONDING FIELDS OF TABLE @et_tipo_atv_ordem
******          WHERE c~perfil = @lv_perfil
******            AND b~spras  = @sy-langu.
******      ELSE.
******
******        SELECT a~ilart, b~ilatx
******          FROM t353i AS a INNER JOIN t353i_t AS b ON a~ilart = b~ilart
******          INTO CORRESPONDING FIELDS OF TABLE @et_tipo_atv_ordem
******          WHERE b~spras = @sy-langu.
******      ENDIF.
******    ENDIF.
***
**** Busca Causa Desvio
***    IF im_causa_desvio IS NOT INITIAL.
***      IF lv_perfil IS NOT INITIAL.
***        SELECT a~werks, a~grund, b~grdtx
***          FROM /ptloms/tb039 AS c INNER JOIN trug AS a ON c~werks = a~werks AND c~grund = a~grund
***          INNER JOIN trugt AS b ON a~werks = b~werks AND a~grund = b~grund
***          INTO CORRESPONDING FIELDS OF TABLE @et_causa_desvio
***          WHERE c~perfil = @lv_perfil
***            AND b~spras = @sy-langu.
***
***      ELSE.
***
***        SELECT a~werks, a~grund, b~grdtx
***          FROM trug AS a INNER JOIN trugt AS b ON a~werks = b~werks AND a~grund = b~grund
***          INTO CORRESPONDING FIELDS OF TABLE @et_causa_desvio
***          WHERE b~spras = @sy-langu.
***      ENDIF.
***    ENDIF.
***
****   Busca Matrículas
***    IF im_matricula IS NOT INITIAL.
***      SELECT usuario, nome, matricula
***        FROM /ptloms/tb013
***        INTO CORRESPONDING FIELDS OF TABLE @et_matriculas
***        WHERE bloqueado NE 'X' AND
***              matricula NE '00000000'.
***    ENDIF.
***
***    IF im_centro_planejamento IS NOT INITIAL.
***      SELECT a~iwerk, b~name1
***        FROM t399i AS a INNER JOIN t001w AS b
***        ON a~iwerk = b~werks
***        INTO CORRESPONDING FIELDS OF TABLE @et_centro_planejamento.
***
***    ENDIF.
***
**** Busca Chave Modelo
***    IF im_chave_modelo IS NOT INITIAL.
***      me->out_chave_modelo( IMPORTING et_chave_modelo = et_chave_modelo ).
***    ENDIF.
  ENDMETHOD.


  METHOD OUT_DOCUMENTO_MEDICAO.
***
****Declaração de range
***    DATA: r_point TYPE /iwbep/t_cod_select_options.
***
**** Declaração de estrutura
***    DATA: ls_documento_medicao LIKE LINE OF rt_documento_medicao.
***
**** Declaração de variávis
***    DATA: lv_point     TYPE imrg-point,
***          lv_flstr(22),
***          lv_data      TYPE sy-datum,
***          lv_hora      TYPE sy-uzeit,
***          wa_impt      TYPE impt,
***          wa_rihimrg   TYPE rihimrg.
***
***    DATA: v_anzst      TYPE  cabn-anzst,
***          v_anzdz      TYPE cabn-anzdz,
***          v_msehi      TYPE cabn-msehi,
***          v_cntrr      TYPE imrg-cntrr,
***          vl_flstr(22).
***
**** Verifica se parâmetro de entrada está preenchido
***    IF rt_point[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
***    r_point[] = rt_point[].
***
**** Converte o campo POINT
***    LOOP AT r_point ASSIGNING FIELD-SYMBOL(<fs_point>).
***      IF <fs_point>-low IS NOT INITIAL.
***        MOVE <fs_point>-low TO lv_point.
***        <fs_point>-low = |{ lv_point ALPHA = IN }|.
***      ENDIF.
***      IF <fs_point>-high IS NOT INITIAL.
***        MOVE <fs_point>-high TO lv_point.
***        <fs_point>-high = |{ lv_point ALPHA = IN }|.
***      ENDIF.
***    ENDLOOP.
***
***    DATA lt_imrg TYPE /ptloms/cl007=>ct_imrg.
***    /ptloms/cl007=>select_imrg( EXPORTING rt_table_in  = r_point
***                                IMPORTING rt_table_out = lt_imrg ).
***
**** Verifica se encontrou Documento de Medição
***    IF lt_imrg[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Ordena Documentos de Medição
***    SORT lt_imrg BY point ASCENDING idate DESCENDING itime DESCENDING.
***
**** Monta tabela de saída
***    LOOP AT lt_imrg INTO DATA(ls_imrg).
***
***      DATA(lt_doc_med) = rt_documento_medicao[].
***      DELETE lt_doc_med WHERE point NE ls_imrg-point.
***
***      DESCRIBE TABLE lt_doc_med LINES DATA(lv_qtde_point).
***
***      IF lv_qtde_point >= im_qtde.
***        CONTINUE.
***      ENDIF.
***
***      CLEAR ls_documento_medicao.
***
***      MOVE-CORRESPONDING ls_imrg TO ls_documento_medicao.
***
***      ls_documento_medicao-mdocm = |{ ls_documento_medicao-mdocm ALPHA = OUT }|.
***      SHIFT ls_documento_medicao-recdv LEFT DELETING LEADING '0'.
***
***      lv_data = ls_documento_medicao-idate.
***      lv_hora = ls_documento_medicao-itime.
***      ls_documento_medicao-data_hora = lv_data+6(2) && |/| &&
***                                       lv_data+4(2) && |/| &&
***                                       lv_data(4)   && | | &&
***                                       lv_hora(2)   && |:| &&
***                                       lv_hora+2(2) && |:| &&
***                                       lv_hora+4(2).
***
***      CALL FUNCTION 'MEASUREM_POINT_READ'
***        EXPORTING
***          auth_check      = 'X'
***          auth_tcode      = 'IK03'
***          buffer_bypass   = ' '
***          dyfield         = ' '
***          point           = ls_imrg-point
***        IMPORTING
***          impt_wa         = wa_impt
***          pttxt           = wa_rihimrg-pttxt
***        EXCEPTIONS
***          imptt_not_found = 01
***          no_authority    = 02.
***
***      SELECT SINGLE anzst anzdz msehi INTO ( v_anzst, v_anzdz, v_msehi )
***       FROM cabn
***       WHERE atnam = wa_impt-atnam.
***
***      IF wa_impt-indct = 'X'.
***
***        DATA(value_si) = ls_imrg-cntrr.
***
***      ELSE.
***
***        value_si = ls_imrg-readg.
***
***      ENDIF.
***
***      CALL FUNCTION 'FLTP_CHAR_CONVERSION_FROM_SI'
***        EXPORTING
***          char_unit       = v_msehi
***          decimals        = v_anzdz
***          exponent        = '0'
***          fltp_value_si   = value_si
***          indicator_value = 'X'
***        IMPORTING
***          char_value      = vl_flstr
***        EXCEPTIONS
***          no_unit_given   = 01.
***
***      CONDENSE vl_flstr.
***      MOVE vl_flstr TO ls_documento_medicao-recdv.
***
***      APPEND ls_documento_medicao TO rt_documento_medicao.
***
***    ENDLOOP.
  ENDMETHOD.


  METHOD out_equipamento.

    FIELD-SYMBOLS <fs_filtro> LIKE LINE OF et_filtro_equnr..

*   Declaração de range
    DATA: r_instid_a     TYPE /iwbep/t_cod_select_options,
          r_typeid_a     TYPE /iwbep/t_cod_select_options,
          r_iwerk        TYPE RANGE OF v_equi-iwerk, " Centro de Planejamento
          r_ingrp        TYPE RANGE OF v_equi-ingrp, " Grupo de Planejamento
          r_beber        TYPE RANGE OF v_equi-beber, " Área Operacional
          r_lgwid        TYPE RANGE OF v_equi-gewrk, " ID Centro de Trabalho
          r_eqtyp        TYPE RANGE OF v_equi-eqtyp, " Categoria Equipamento
          r_eqart        TYPE RANGE OF v_equi-eqart, " Tipo de Objeto Técnico
          r_equnr        TYPE RANGE OF v_equi-equnr, " Equipamento
          r_equnr_copy   TYPE RANGE OF v_equi-equnr, " Equipamento
          r_equnr_status TYPE RANGE OF v_equi-objnr,
          rt_equnr       TYPE /iwbep/t_cod_select_options,
          r_objnr        TYPE RANGE OF jest-objnr,
          r_exc          TYPE RANGE OF /ptloms/tb052-stat,
          r_inc          TYPE RANGE OF /ptloms/tb051-stat.

*         Declaração de tabela
    DATA: lt_anexo   TYPE /ptloms/ct072,
          lt_tb013   TYPE TABLE OF /ptloms/tb013,
          lt_tb014   TYPE TABLE OF /ptloms/tb014,
          lt_tb015   TYPE TABLE OF /ptloms/tb015,
          lt_tb016   TYPE TABLE OF /ptloms/tb016,
          lt_tb017   TYPE TABLE OF /ptloms/tb017,
          lt_tb019   TYPE TABLE OF /ptloms/tb019,
          lt_tb020   TYPE TABLE OF /ptloms/tb020,
          lt_tb051   TYPE TABLE OF /ptloms/tb051,
          lt_jest    TYPE TABLE OF jest,
*         lt_v_equi     TYPE TABLE OF v_equi,
          lt_bgmkobj TYPE TABLE OF bgmkobj.

    TYPES: BEGIN OF ty_equi_objnr,
             objnr TYPE equi-objnr,
             stat  TYPE jest-stat,
             inact TYPE jest-inact,
           END OF ty_equi_objnr.

    DATA: it_equi_objnr TYPE TABLE OF ty_equi_objnr.

    TYPES: BEGIN OF ty_jest,
             objnr TYPE jest-objnr,
             stat  TYPE jest-stat,
             equnr TYPE jest-objnr.
    TYPES: END OF ty_jest.

    DATA: it_jest_aux TYPE TABLE OF ty_jest.
    DATA: ls_jest_aux LIKE LINE OF it_jest_aux.

    TYPES: BEGIN OF ty_v_equi,
             equnr TYPE v_equi-objnr,
             eqtyp TYPE v_equi-eqtyp,
             eqktx TYPE v_equi-eqktx,
             eqart TYPE v_equi-eqart,
             brgew TYPE v_equi-brgew,
             invnr TYPE v_equi-invnr,
             herst TYPE v_equi-herst,
             typbz TYPE v_equi-typbz,
             serge TYPE v_equi-serge,
             swerk TYPE v_equi-swerk,
             beber TYPE v_equi-beber,
             ppsid TYPE v_equi-ppsid,
             eqfnr TYPE v_equi-eqfnr,
             bukrs TYPE v_equi-bukrs,
             anlnr TYPE v_equi-anlnr,
             kostl TYPE v_equi-kostl,
             iwerk TYPE v_equi-iwerk,
             ingrp TYPE v_equi-ingrp,
             gewrk TYPE v_equi-gewrk,
             rbnr  TYPE v_equi-rbnr,
             tplnr TYPE v_equi-tplnr,
             tidnr TYPE v_equi-tidnr,
             submt TYPE v_equi-submt,
             objnr TYPE v_equi-objnr,
             baujj TYPE v_equi-baujj,
             stat  TYPE jest-stat,
             inact TYPE jest-inact,
           END OF ty_v_equi,

           BEGIN OF ty_fleet,
             objnr       TYPE fleet-objnr,
             fleet_num   TYPE fleet-fleet_num,
             license_num TYPE fleet-license_num,
           END OF ty_fleet.

    DATA: lt_v_equi TYPE TABLE OF ty_v_equi,
          lt_fleet  TYPE TABLE OF ty_fleet.

    DATA: lt_equi_final LIKE lt_v_equi.

    DATA: lt_jstat TYPE TABLE OF jstat,
          ls_jstat TYPE jstat.

*   Declaração de estrutura
    DATA: ls_equipamento LIKE LINE OF et_equipamento,
          ls_instid_a    LIKE LINE OF r_instid_a,
          ls_typeid_a    LIKE LINE OF r_typeid_a,
          ls_iwerk       LIKE LINE OF r_iwerk,
          ls_ingrp       LIKE LINE OF r_ingrp,
          ls_beber       LIKE LINE OF r_beber,
          ls_lgwid       LIKE LINE OF r_lgwid,
          ls_eqtyp       LIKE LINE OF r_eqtyp,
          ls_eqart       LIKE LINE OF r_eqart,
          ls_equnr       LIKE LINE OF r_equnr,
          ls_objnr       LIKE LINE OF r_objnr,
          ls_filtro      TYPE /ptloms/et056,
          ls_tb013       LIKE LINE OF lt_tb013,
          ls_equnr_aux   LIKE LINE OF rt_equnr,
          ls_tb014       LIKE LINE OF lt_tb014,
          lr_iwerk       LIKE LINE OF r_iwerk,
          ls_tb015       LIKE LINE OF lt_tb015,
          ls_tb016       LIKE LINE OF lt_tb016,
          ls_tb017       LIKE LINE OF lt_tb017,
          ls_tb019       LIKE LINE OF lt_tb019,
          ls_tb020       LIKE LINE OF lt_tb020,
          ls_tb051       LIKE LINE OF lt_tb051,
          lr_inc         LIKE LINE OF r_inc,
          lt_tb052       TYPE TABLE OF /ptloms/tb052,
          ls_tb052       LIKE LINE OF lt_tb052,
          lr_exc         LIKE LINE OF r_inc,
          ls_jest        LIKE LINE OF lt_jest,
          ls_bgmkobj     LIKE LINE OF lt_bgmkobj,
          ls_033         TYPE /ptloms/tb033,
          ls_v_equi      LIKE LINE OF lt_equi_final,
          ls_fleet       LIKE LINE OF lt_fleet.

*   Declaração de variáveis
    DATA: lv_line                   TYPE bsvx-sttxt,
          lv_user_line              TYPE bsvx-sttxt,
          lv_anw_stat_existing      TYPE xfeld,
          lv_e_stsma                TYPE jsto-stsma,
          lv_stonr                  TYPE tj30-stonr,
          lv_quantidade_equipamento TYPE int4,
          lv_quantidade_pacote      TYPE int4 VALUE 2000,
          lv_equnr                  TYPE equnr,
          lv_configuracao           TYPE /ptloms/tb044-configuracao,
          lv_tabix                  TYPE sy-tabix.

*   Verifica se parâmetros de entrada estão preenchidos
    IF rt_bukrs[]       IS INITIAL AND
       rt_iwerk[]       IS INITIAL AND
       rt_ingrp[]       IS INITIAL AND
       rt_beber[]       IS INITIAL AND
       rt_gewrk[]       IS INITIAL AND
       rt_eqart[]       IS INITIAL AND
       rt_usuario_app[] IS INITIAL.
      RETURN.
    ENDIF.

*   Busca perfil do usuário (OMS - Usuário)
    IF rt_usuario_app[] IS NOT INITIAL.

      SELECT usuario perfil
        FROM /ptloms/tb013
        INTO CORRESPONDING FIELDS OF TABLE lt_tb013
        WHERE usuario IN rt_usuario_app.

      IF lt_tb013[] IS NOT INITIAL.

        CLEAR ls_tb013.
        READ TABLE lt_tb013 INTO ls_tb013 INDEX 1.

*       Verfica Configuração da Forma de recuperação dos Equipamentos
        CLEAR lv_configuracao.
        SELECT SINGLE configuracao FROM /ptloms/tb044 INTO lv_configuracao WHERE perfil = ls_tb013-perfil
                                                                             AND configuracao = '02'.

*       Configuração 02 - Sincronizar apenas Cliente(s) com ordem(s) atribuída(s) não respeita os filtros do APP
        IF lv_configuracao = '02'.

          me->out_equipamento_v2( EXPORTING rt_usuario_app = rt_usuario_app
                                  IMPORTING rt_equnr       = rt_equnr ).

          IF rt_equnr[] IS INITIAL.
            RETURN.
          ENDIF.

          LOOP AT rt_equnr INTO ls_equnr_aux.

            CLEAR ls_equnr.
            MOVE-CORRESPONDING ls_equnr_aux TO ls_equnr.
            APPEND ls_equnr TO r_equnr.

*           Objetos para seleção na JEST (inclusivo/exclusivo
            CLEAR ls_objnr.
            ls_objnr-sign   = 'I'.
            ls_objnr-option = 'EQ'.
            CONCATENATE 'IE' ls_equnr-low INTO ls_objnr-low.
            APPEND ls_objnr TO r_objnr.

          ENDLOOP.

        ELSE.

*         Busca Centro do Perfil (OMS - Perfil x Empresa/Centro)
          SELECT *
            FROM /ptloms/tb014
            INTO CORRESPONDING FIELDS OF TABLE lt_tb014
            FOR ALL ENTRIES IN lt_tb013
            WHERE perfil = lt_tb013-perfil.

*         Monta o range com os centros do perfil
          LOOP AT lt_tb014 INTO ls_tb014.
            CLEAR ls_iwerk.
            lr_iwerk-sign = 'I'.
            lr_iwerk-option = 'EQ'.
            lr_iwerk-low = ls_tb014-werks.
            APPEND lr_iwerk TO r_iwerk.
          ENDLOOP.

*         Busca o Grupo de Planejamento do Perfil (OMS - Perfil x Grupo Planejamento)
          SELECT *
            FROM /ptloms/tb015
            INTO CORRESPONDING FIELDS OF TABLE lt_tb015
            FOR ALL ENTRIES IN lt_tb013
            WHERE perfil = lt_tb013-perfil
              AND iwerk IN r_iwerk.

*         Monta o range com o grupo de planejamento
          LOOP AT lt_tb015 INTO ls_tb015 WHERE filtro_equi = 'X'.
            CLEAR ls_ingrp.
            ls_ingrp-sign   = 'I'.
            ls_ingrp-option = 'EQ'.
            ls_ingrp-low    = ls_tb015-ingrp.
            APPEND ls_ingrp TO r_ingrp.
          ENDLOOP.

*         Busca Área Operacional do Perfil (OMS - Perfil x Área Operacional)
          SELECT *
            FROM /ptloms/tb016
            INTO CORRESPONDING FIELDS OF TABLE lt_tb016
            FOR ALL ENTRIES IN lt_tb013
            WHERE perfil = lt_tb013-perfil
              AND werks IN r_iwerk.

*         Monta o range com a área operacional.
          LOOP AT lt_tb016 INTO ls_tb016 WHERE filtro_equi = 'X'.
            CLEAR ls_beber.
            ls_beber-sign   = 'I'.
            ls_beber-option = 'EQ'.
            ls_beber-low    = ls_tb016-beber.
            APPEND ls_beber TO r_beber.
          ENDLOOP.

*         Busca Centro de Trabalho do Perfil (OMS - Perfil x Centro de Trabalho)
          SELECT *
            FROM /ptloms/tb017
            INTO CORRESPONDING FIELDS OF TABLE lt_tb017
            FOR ALL ENTRIES IN lt_tb013
            WHERE perfil = lt_tb013-perfil
              AND werks IN r_iwerk.

*         Monta o range com o centro de trbalho
          LOOP AT lt_tb017 INTO ls_tb017 WHERE filtro_equi = 'X'.
            CLEAR ls_lgwid.
            ls_lgwid-sign   = 'I'.
            ls_lgwid-option = 'EQ'.
            ls_lgwid-low    = ls_tb017-objid.
            APPEND ls_lgwid TO r_lgwid.
          ENDLOOP.

*         Busca Categoria de Equipamento do Perfil (OMS - Perfil x Categoria Equipamento)
          SELECT *
            FROM /ptloms/tb019
            INTO CORRESPONDING FIELDS OF TABLE lt_tb019
            FOR ALL ENTRIES IN lt_tb013
            WHERE perfil = lt_tb013-perfil.

*         Monta o range com a categoria de equipamento
          LOOP AT lt_tb019 INTO ls_tb019.
            CLEAR ls_eqtyp.
            ls_eqtyp-sign   = 'I'.
            ls_eqtyp-option = 'EQ'.
            ls_eqtyp-low    = ls_tb019-eqtyp.
            APPEND ls_eqtyp TO r_eqtyp.
          ENDLOOP.

*         Busca Tipo de Ojeto Técnico do Perfil (OMS - Perfil x Tipo de Objeto Técnico)
          SELECT *
            FROM /ptloms/tb020
            INTO CORRESPONDING FIELDS OF TABLE lt_tb020
            FOR ALL ENTRIES IN lt_tb013
            WHERE perfil = lt_tb013-perfil.

*         Monta o range com o tipo de objeto técnico.
          LOOP AT lt_tb020 INTO ls_tb020 WHERE filtro_equi = 'X'.
            CLEAR ls_eqart.
            ls_eqart-sign   = 'I'.
            ls_eqart-option = 'EQ'.
            ls_eqart-low    = ls_tb020-eqart.
            APPEND ls_eqart TO r_eqart.
          ENDLOOP.

        ENDIF.
      ENDIF.
    ENDIF.

*--------------------------------------------------------------------------*
* Status de inclusão e exclusão de equipamentos - Início                   *
* Não deve ser válido a inclusão e exlusão para configuração 02 do cliente*
*--------------------------------------------------------------------------*
    IF lv_configuracao <> '02'.

*     Verificar cadastro do status do equipamento inclusivo (OMS - Perfil x Equipamento - Status inclusivo)
      SELECT *
        FROM /ptloms/tb051
        INTO CORRESPONDING FIELDS OF TABLE lt_tb051
        WHERE perfil = ls_tb013-perfil.

*     Monta o range com os status inclusivos.
      LOOP AT lt_tb051 INTO ls_tb051.
        CLEAR lr_inc.
        lr_inc-sign   = 'I'.
        lr_inc-option = 'EQ'.
        lr_inc-low    = ls_tb051-stat.
        lr_inc-high   = ls_tb051-stat.

        APPEND lr_inc TO r_inc.
      ENDLOOP.

*     Verificar cadastro do status do equipamento exclusivo (OMS - Perfil x Equipamento - Status exclusivo)
      SELECT *
       FROM /ptloms/tb052
       INTO CORRESPONDING FIELDS OF TABLE lt_tb052
       WHERE perfil = ls_tb013-perfil.

*     Monta o range com os status exclusivos
      LOOP AT lt_tb052 INTO ls_tb052.
        CLEAR lr_inc.
        lr_exc-sign   = 'I'.
        lr_exc-option = 'EQ'.
        lr_exc-low    = ls_tb052-stat.
        lr_exc-high   = ls_tb052-stat.

        APPEND lr_exc TO r_exc.
      ENDLOOP.

    ENDIF.

*   Status de inativo deve ser sempre exclusivo (Inativo)
    lr_exc-sign   = 'I'.
    lr_exc-option = 'EQ'.
    lr_exc-low    = 'I0320'.
    lr_exc-high   = 'I0320'.
    APPEND lr_exc TO r_exc.

*   Status de inativo deve ser sempre exclusivo (Marcação para eliminação)
    lr_exc-sign   = 'I'.
    lr_exc-option = 'EQ'.
    lr_exc-low    = 'I0076'.
    lr_exc-high   = 'I0076'.
    APPEND lr_exc TO r_exc.

*   Status de inativo deve ser sempre exclusivo (Cód.elimin., possível arquivar.)
    lr_exc-sign   = 'I'.
    lr_exc-option = 'EQ'.
    lr_exc-low    = 'I0013'.
    lr_exc-high   = 'I0013'.
    APPEND lr_exc TO r_exc.

*   Caso a seleção seja por equipamentos em clientes das ordens atribuídas
    IF r_objnr[] IS NOT INITIAL.

*     Verificar as ordens para os status inclusivo e exclusivos
      SELECT objnr stat
        FROM jest
        INTO CORRESPONDING FIELDS OF TABLE lt_jest
        WHERE objnr IN r_objnr
        AND   inact = space.

*     Montar a chave do EQUNR para filtro
      LOOP AT lt_jest INTO ls_jest.
        ls_jest_aux-objnr = ls_jest-objnr.
        ls_jest_aux-stat = ls_jest-stat.
        ls_jest_aux-equnr = ls_jest-objnr+2(18).
        APPEND ls_jest_aux TO it_jest_aux.
      ENDLOOP.

    ELSE.

***      SELECT v~objnr j~stat j~inact
***         FROM v_equi AS v
***         INNER JOIN jest AS j ON j~objnr = v~objnr
***         INTO TABLE it_equi_objnr
***         WHERE v~swerk IN r_iwerk
***           AND v~ingrp IN r_ingrp
***           AND v~beber IN r_beber
***           AND v~gewrk IN r_lgwid
***           AND v~eqtyp IN r_eqtyp
***           AND v~eqart IN r_eqart
***           AND v~datbi = '99991231'
***           AND j~inact NE 'X'
***
***           AND v~objnr NOT IN ( SELECT objnr
***                                FROM jest
***                                WHERE objnr LIKE 'IE%'
***                                  AND stat  IN r_exc
***                                  AND inact = space ).

      IF r_eqtyp[] IS INITIAL. " Se range estiver vazio, então não busca equipamentos (É necessário cadastrar categoria de equipamento para o perfil)
        RETURN.
      ENDIF.

      SELECT v~equnr v~eqtyp v~eqktx v~eqart v~brgew v~invnr
             v~herst v~typbz v~serge v~swerk v~beber v~ppsid
             v~eqfnr v~bukrs v~anlnr v~kostl v~iwerk v~ingrp
             v~gewrk v~rbnr  v~tplnr v~tidnr v~submt v~objnr v~baujj
             j~stat j~inact

         FROM v_equi AS v
         INNER JOIN jest AS j ON j~objnr = v~objnr
         INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
         WHERE v~spras EQ sy-langu
*          AND v~txasp EQ 'X'
           AND v~datbi = '99991231'

           AND v~bukrs IN rt_bukrs
           AND v~iwerk IN rt_iwerk
           AND v~eqtyp IN rt_eqtyp
           AND v~ingrp IN rt_ingrp
           AND v~beber IN rt_beber
           AND v~gewrk IN rt_gewrk
           AND v~eqart IN rt_eqart
           AND j~inact NE 'X'

           "Filtros relativos ao Usuário
           AND v~swerk IN r_iwerk
           AND v~ingrp IN r_ingrp
           AND v~beber IN r_beber
           AND v~gewrk IN r_lgwid
           AND v~eqtyp IN r_eqtyp
           AND v~eqart IN r_eqart

           AND v~objnr NOT IN ( SELECT objnr
                                FROM jest
                                WHERE objnr LIKE 'IE%'
                                  AND stat  IN r_exc
                                  AND inact = space ).

      IF r_inc[] IS NOT INITIAL.
        DELETE lt_v_equi WHERE stat NOT IN r_inc.
      ENDIF.

    ENDIF.

* SE O EQUIPAMENTO ESTÁ ATRIBUIO A UMA ORDEM FAZ SENTIDO FAZER VALIDAÇÃO NA JEST ?
***    IF it_jest_aux IS NOT INITIAL.
***
***      SORT it_jest_aux BY objnr stat.
***
***      " Para configuração 02 - Equipamentos em clientes das ordens atribuídas
***      IF lv_configuracao = '02'.
***
***        IF it_jest_aux[] IS NOT INITIAL.
***          " Criar range para incluir o EQUNR que deve ser validado na JEST
****          r_equnr_status = VALUE #( FOR wl IN it_jest_aux ( sign = 'I' option = 'EQ' low = wl-equnr ) ).
***          DATA ls_equnr_status LIKE LINE OF r_equnr_status.
***          LOOP AT it_jest_aux INTO ls_jest_aux.
***            ls_equnr_status-sign = 'I'.
***            ls_equnr_status-option = 'EQ'.
***            ls_equnr_status-low = ls_jest_aux-equnr.
***
***            APPEND ls_equnr_status TO r_equnr_status.
***          ENDLOOP.
***
***          IF r_equnr_status[] IS NOT INITIAL.
***            DELETE r_equnr WHERE low NOT IN r_equnr_status[].
***          ENDIF.
***
***        ENDIF.
***
***      ENDIF.
***
***    ENDIF.
*-------------------------------------------------------------------*
* Status de inclusão e exclusão de equipamentos - Fim               *
*-------------------------------------------------------------------*
    IF lv_configuracao = '02'.

      IF r_equnr[] IS NOT INITIAL.

        WHILE r_equnr[] IS NOT INITIAL.

          APPEND LINES OF r_equnr[] FROM 1 TO lv_quantidade_pacote TO r_equnr_copy[].

          DELETE r_equnr FROM 1 TO lv_quantidade_pacote.

          SELECT equnr eqtyp eqktx eqart brgew invnr
                 herst typbz serge swerk beber ppsid
                 eqfnr bukrs anlnr kostl iwerk ingrp
                 gewrk rbnr  tplnr tidnr submt objnr baujj
            FROM v_equi
            APPENDING CORRESPONDING FIELDS OF TABLE lt_v_equi
            WHERE equnr IN r_equnr_copy
              AND txasp EQ 'X'
              AND owner EQ space
              AND spras EQ sy-langu
              AND bukrs IN rt_bukrs
              AND iwerk IN rt_iwerk
              AND eqtyp IN rt_eqtyp
              AND ingrp IN rt_ingrp
              AND beber IN rt_beber
              AND gewrk IN rt_gewrk
              AND eqart IN rt_eqart
              AND datbi EQ '99991231'.

          CLEAR: r_equnr_copy[].

        ENDWHILE.

      ELSE.

        SELECT equnr eqtyp eqktx eqart brgew invnr
               herst typbz serge swerk beber ppsid
               eqfnr bukrs anlnr kostl iwerk ingrp
               gewrk rbnr  tplnr tidnr submt objnr baujj
          FROM v_equi
          INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
          WHERE txasp EQ 'X'
            AND equnr IN r_equnr   "Filtro dos equipamentos com status inclusivos e exclusivos
            AND owner EQ space
            AND spras EQ sy-langu
            AND bukrs IN rt_bukrs
            AND iwerk IN rt_iwerk
            AND eqtyp IN rt_eqtyp
            AND ingrp IN rt_ingrp
            AND beber IN rt_beber
            AND gewrk IN rt_gewrk
            AND eqart IN rt_eqart
            AND datbi EQ '99991231'.

      ENDIF.

    ELSE.

*     É obrigatório cadastrar a categoria de equipamento para o Perfil
***      IF r_eqtyp[] IS INITIAL. " Se range estiver vazio, então não busca equipamentos (É necessário cadastrar categoria de equipamento para o perfil)
***        RETURN.
***      ENDIF.
***
***      IF it_jest_aux IS NOT INITIAL.
***
****       Seleciona Equipamentos
***        SELECT equnr eqtyp eqktx eqart brgew invnr
***               herst typbz serge swerk beber ppsid
***               eqfnr bukrs anlnr kostl iwerk ingrp
***               gewrk rbnr  tplnr tidnr submt objnr baujj
***          FROM v_equi
***          INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
***          FOR ALL ENTRIES IN it_jest_aux
***          WHERE objnr EQ it_jest_aux-objnr
***            AND txasp EQ 'X'
***            AND owner EQ space
***            AND spras EQ sy-langu
***            AND bukrs IN rt_bukrs
***            AND iwerk IN rt_iwerk
***            AND eqtyp IN rt_eqtyp
***            AND ingrp IN rt_ingrp
***            AND beber IN rt_beber
***            AND gewrk IN rt_gewrk
***            AND eqart IN rt_eqart
***            AND datbi EQ '99991231'
***
***            " Filtros relativos ao Usuário
***            AND swerk IN r_iwerk
***            AND ingrp IN r_ingrp
***            AND beber IN r_beber
***            AND gewrk IN r_lgwid
***            AND eqtyp IN r_eqtyp
***            AND eqart IN r_eqart.
***
***      ELSE.
***
****       Seleciona Equipamentos
***        SELECT equnr eqtyp eqktx eqart brgew invnr
***               herst typbz serge swerk beber ppsid
***               eqfnr bukrs anlnr kostl iwerk ingrp
***               gewrk rbnr  tplnr tidnr submt objnr baujj
***          FROM v_equi
***          INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
***          WHERE txasp EQ 'X'
***            AND owner EQ space
***            AND spras EQ sy-langu
***            AND bukrs IN rt_bukrs
***            AND iwerk IN rt_iwerk
***            AND eqtyp IN rt_eqtyp
***            AND ingrp IN rt_ingrp
***            AND beber IN rt_beber
***            AND gewrk IN rt_gewrk
***            AND eqart IN rt_eqart
***            AND datbi EQ '99991231'
***
***           "Filtros relativos ao Usuário
***            AND swerk IN r_iwerk
***            AND ingrp IN r_ingrp
***            AND beber IN r_beber
***            AND gewrk IN r_lgwid
***            AND eqtyp IN r_eqtyp
***            AND eqart IN r_eqart.
***
***      ENDIF.
    ENDIF.

*   Verifica se encontrou equipamento
    IF lt_v_equi[] IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_v_equi BY equnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_v_equi COMPARING equnr.
    lt_equi_final = lt_v_equi.

* Busca status do Equipamento
***    DATA it_jest TYPE TABLE OF jest.
***    SELECT objnr stat inact
***      FROM jest
***      INTO CORRESPONDING FIELDS OF TABLE it_jest
***      FOR ALL ENTRIES IN lt_v_equi
***      WHERE objnr = lt_v_equi-objnr.
***
***    SORT it_jest BY objnr stat inact.

*   Busca garantia Equipamento
***    SELECT j_objnr gaart gwldt gwlen
***      FROM bgmkobj
***      INTO CORRESPONDING FIELDS OF TABLE lt_bgmkobj
***      FOR ALL ENTRIES IN lt_v_equi
***      WHERE j_objnr = lt_v_equi-objnr.

*   Busca Placa do veiculo e Num de indentificação
    SELECT objnr fleet_num license_num
      FROM fleet
      INTO CORRESPONDING FIELDS OF TABLE lt_fleet
      FOR ALL ENTRIES IN lt_v_equi
      WHERE objnr = lt_v_equi-objnr.

*   Busca configuração do sistema
    SELECT SINGLE anexo_ordem anexo_locl anexo_equi
      FROM /ptloms/tb033
      INTO CORRESPONDING FIELDS OF ls_033.

    DESCRIBE TABLE lt_equi_final LINES ex_quantidade_equipamento.

*   Monta tabela de saída
    LOOP AT lt_equi_final INTO ls_v_equi.

*     Melhoria Performance - Início
      lv_tabix = sy-tabix.
      IF im_top > 0.
        IF lv_tabix <= im_skip.
          CONTINUE.
        ENDIF.

        lv_quantidade_equipamento = lv_quantidade_equipamento + 1.
        IF lv_quantidade_equipamento > im_top.
          EXIT.
        ENDIF.
      ENDIF.
*     Melhoria Performance - Fim

*     Atribui campos correspondentes
      MOVE-CORRESPONDING ls_v_equi TO ls_equipamento.

*     Limpa variáveis
      CLEAR: lv_anw_stat_existing, lv_e_stsma,
             lv_line, lv_user_line, lv_stonr.

*     Chama função que retorna status de usuário e sistema
      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
          objnr             = ls_v_equi-objnr
*         only_active       = 'X'
          spras             = sy-langu
        IMPORTING
          anw_stat_existing = lv_anw_stat_existing
          e_stsma           = lv_e_stsma
          line              = lv_line
          user_line         = lv_user_line
          stonr             = lv_stonr
        EXCEPTIONS
          object_not_found  = 1
          OTHERS            = 2.

      IF sy-subrc = 0.  "Carrega status de usuário e sistema
        MOVE: lv_user_line TO ls_equipamento-status_usuario,
              lv_line      TO ls_equipamento-status_sistema.
      ENDIF.

****     Busca garantia inicial/final cliente
***      CLEAR ls_bgmkobj.
***      READ TABLE lt_bgmkobj INTO ls_bgmkobj WITH KEY j_objnr = ls_v_equi-objnr
***                                                     gaart   = '1'.
***      IF sy-subrc EQ 0.
***        MOVE: ls_bgmkobj-gwldt TO ls_equipamento-gwldt_ini,
***              ls_bgmkobj-gwlen TO ls_equipamento-gwlen_ini.
***      ENDIF.
***
****     Busca garantia inicial/final fornecedor
***      CLEAR ls_bgmkobj.
***      READ TABLE lt_bgmkobj INTO ls_bgmkobj WITH KEY j_objnr = ls_v_equi-objnr
***                                                     gaart   = '2'.
***      IF sy-subrc EQ 0.
***        MOVE: ls_bgmkobj-gwldt TO ls_equipamento-gwldt_fim,
***              ls_bgmkobj-gwlen TO ls_equipamento-gwlen_fim.
***      ENDIF.

      IF ls_equipamento-objnr IS NOT INITIAL.

*     Busca Placa do veiculo e Num de indentificação
        CLEAR ls_fleet.
        READ TABLE lt_fleet INTO ls_fleet WITH KEY objnr = ls_equipamento-objnr.
        IF sy-subrc EQ 0.
          ls_equipamento-fleet_num   = ls_fleet-fleet_num.
          ls_equipamento-license_num = ls_fleet-license_num.
        ENDIF.

      ENDIF.

*     Carrega imagens do Equipamento
      IF ls_033-anexo_equi = 'X'.
        CLEAR: ls_instid_a, ls_typeid_a.
        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.

        ls_instid_a-sign = 'I'.
        ls_instid_a-option = 'EQ'.
        ls_instid_a-low = ls_v_equi-equnr.
        APPEND ls_instid_a TO r_instid_a.

        ls_typeid_a-sign = 'I'.
        ls_typeid_a-option = 'EQ'.
        ls_typeid_a-low = 'EQUI'.
        APPEND ls_typeid_a TO r_typeid_a.

      ENDIF.

*     Carrega Filtro EQUNR
      IF ls_equipamento-equnr IS NOT INITIAL.
        READ TABLE et_filtro_equnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-equnr.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
*         ls_filtro-key   = |{ ls_equipamento-equnr ALPHA = OUT }|.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_equipamento-equnr
            IMPORTING
              output = ls_filtro-key.
*         ls_filtro-text  = |{ ls_equipamento-equnr ALPHA = OUT }|.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_equipamento-equnr
            IMPORTING
              output = ls_filtro-text.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_equnr.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

*     Carrega Filtro EQKTX
      IF ls_equipamento-eqktx IS NOT INITIAL.
        READ TABLE et_filtro_eqktx ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-eqktx.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
          ls_filtro-key   = ls_equipamento-eqktx.
          ls_filtro-text  = ls_equipamento-eqktx.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_eqktx.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

*     Carrega Filtro INVNR
      IF ls_equipamento-invnr IS NOT INITIAL.
        READ TABLE et_filtro_invnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-invnr.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
          ls_filtro-key   = ls_equipamento-invnr.
          ls_filtro-text  = ls_equipamento-invnr.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_invnr.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

*     Carrega Filtro TIDNR
      IF ls_equipamento-tidnr IS NOT INITIAL.
        READ TABLE et_filtro_tidnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-tidnr.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
          ls_filtro-key   = ls_equipamento-tidnr.
          ls_filtro-text  = ls_equipamento-tidnr.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_tidnr.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

      ls_equipamento-quantidade_equipamento = ex_quantidade_equipamento.

*     Busca descrição do status do equipamento
      CALL FUNCTION 'STATUS_READ'
        EXPORTING
*         CLIENT           = SY-MANDT
          objnr            = ls_equipamento-objnr
          only_active      = 'X'
*       IMPORTING
*         OBTYP            =
*         STSMA            =
*         STONR            =
        TABLES
          status           = lt_jstat
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.
      IF sy-subrc = 0.
        READ TABLE lt_jstat INTO ls_jstat INDEX 1.
        IF sy-subrc = 0.
          ls_equipamento-status = ls_jstat-stat.
          SELECT SINGLE txt30 INTO ls_equipamento-desc_status
            FROM tj02t
            WHERE istat = ls_jstat-stat
              AND spras = sy-langu.
        ENDIF.
      ENDIF.
      CLEAR: lt_jstat.

*     Inclui na tabela de saída
      APPEND ls_equipamento TO et_equipamento.
      CLEAR ls_equipamento.

    ENDLOOP.

    SORT et_equipamento BY equnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_equipamento COMPARING equnr.

  ENDMETHOD.

***  METHOD out_equipamento.
***
****Declaração de range
***    DATA: r_instid_a                TYPE /iwbep/t_cod_select_options,
***          r_typeid_a                TYPE /iwbep/t_cod_select_options,
***          r_iwerk                   TYPE RANGE OF v_equi-iwerk, " Centro de Planejamento
***          r_ingrp                   TYPE RANGE OF v_equi-ingrp, " Grupo de Planejamento
***          r_beber                   TYPE RANGE OF v_equi-beber, " Área Operacional
***          r_lgwid                   TYPE RANGE OF v_equi-gewrk, " ID Centro de Trabalho
***          r_eqtyp                   TYPE RANGE OF v_equi-eqtyp, " Categoria Equipamento
***          r_eqart                   TYPE RANGE OF v_equi-eqart, " Tipo de Objeto Técnico
***          r_equnr                   TYPE RANGE OF v_equi-equnr, " Equipamento
***          r_equnr_copy              TYPE RANGE OF v_equi-equnr, " Equipamento
***          r_equnr_status            TYPE RANGE OF v_equi-objnr,
***          rt_equnr                  TYPE /iwbep/t_cod_select_options,
***          r_objnr                   TYPE RANGE OF jest-objnr,
**** Declaração de estrutura
***          ls_equipamento            LIKE LINE OF et_equipamento,
***          ls_instid_a               LIKE LINE OF r_instid_a,
***          ls_typeid_a               LIKE LINE OF r_typeid_a,
***          ls_iwerk                  LIKE LINE OF r_iwerk,
***          ls_ingrp                  LIKE LINE OF r_ingrp,
***          ls_beber                  LIKE LINE OF r_beber,
***          ls_lgwid                  LIKE LINE OF r_lgwid,
***          ls_eqtyp                  LIKE LINE OF r_eqtyp,
***          ls_eqart                  LIKE LINE OF r_eqart,
***          ls_equnr                  LIKE LINE OF r_equnr,
***          ls_objnr                  LIKE LINE OF r_objnr,
***          ls_filtro                 TYPE /ptloms/et056,
**** Declaração de tabela
***          lt_anexo                  TYPE /ptloms/ct072,
**** Declaração de variáveis
***          lv_line                   TYPE bsvx-sttxt,
***          lv_user_line              TYPE bsvx-sttxt,
***          lv_anw_stat_existing      TYPE xfeld,
***          lv_e_stsma                TYPE jsto-stsma,
***          lv_stonr                  TYPE tj30-stonr,
***          lv_quantidade_equipamento TYPE int4,
***          lv_quantidade_pacote      TYPE int4 VALUE 2000,
***          lv_equnr                  TYPE equnr.
***
***    TYPES: BEGIN OF ty_equi_objnr,
***             objnr TYPE equi-objnr,
***           END OF ty_equi_objnr.
***
***    DATA: it_equi_objnr TYPE TABLE OF ty_equi_objnr.
***
**** Verifica se parâmetros de entrada estão preenchidos
***    IF rt_bukrs[]       IS INITIAL AND
***       rt_iwerk[]       IS INITIAL AND
***       rt_ingrp[]       IS INITIAL AND
***       rt_beber[]       IS INITIAL AND
***       rt_gewrk[]       IS INITIAL AND
***       rt_eqart[]       IS INITIAL AND
***       rt_usuario_app[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca perfil do usuário
***    DATA lt_tb013 TYPE TABLE OF /ptloms/tb013.
***    IF rt_usuario_app[] IS NOT INITIAL.
***      SELECT usuario perfil
***        FROM /ptloms/tb013
***        INTO CORRESPONDING FIELDS OF TABLE lt_tb013
***        WHERE usuario IN rt_usuario_app.
***
***      IF lt_tb013[] IS NOT INITIAL.
***
***        DATA ls_tb013 LIKE LINE OF lt_tb013.
***        READ TABLE lt_tb013 INTO ls_tb013 INDEX 1.
***
**** Verfica Configuração da Forma de recuperação dos Equipamentos
***        DATA lv_configuracao TYPE /ptloms/tb044-configuracao.
***        SELECT SINGLE configuracao FROM /ptloms/tb044 INTO lv_configuracao WHERE perfil       = ls_tb013-perfil
***                                                                                    AND configuracao = '02'.
***        " Configuração 02 - Sincronizar apenas Cliente(s) com ordem(s) atribuída(s) não respeita os filtros do APP
***        IF lv_configuracao = '02'.
***
***          me->out_equipamento_v2( EXPORTING rt_usuario_app = rt_usuario_app
***                                  IMPORTING rt_equnr       = rt_equnr ).
***
***          IF rt_equnr[] IS INITIAL.
***            RETURN.
***          ENDIF.
***
***          DATA ls_equnr_aux LIKE LINE OF rt_equnr.
***          LOOP AT rt_equnr INTO ls_equnr_aux.
***            CLEAR ls_equnr.
***            MOVE-CORRESPONDING ls_equnr_aux TO ls_equnr.
***            APPEND ls_equnr TO r_equnr.
***
***            " Objetos para seleção na JEST (inclusivo/exclusivo
***            CLEAR ls_objnr.
***            ls_objnr-sign   = 'I'.
***            ls_objnr-option = 'EQ'.
***            CONCATENATE 'IE' ls_equnr-low INTO ls_objnr-low.
***            APPEND ls_objnr TO r_objnr.
***
***          ENDLOOP.
***
***        ELSE.
**** Busca Centro do Perfil
***          DATA lt_tb014 TYPE TABLE OF /ptloms/tb014.
***          SELECT *
***            FROM /ptloms/tb014
***            INTO CORRESPONDING FIELDS OF TABLE lt_tb014
***            FOR ALL ENTRIES IN lt_tb013
***            WHERE perfil = lt_tb013-perfil.
***
**** Transforma em Range
****          r_iwerk = VALUE #( FOR wa IN lt_tb014 ( sign = 'I' option = 'EQ' low = wa-werks ) ).
***
***          DATA ls_tb014 LIKE LINE OF lt_tb014.
***          DATA lr_iwerk LIKE LINE OF r_iwerk.
***          LOOP AT lt_tb014 INTO ls_tb014.
***            CLEAR ls_iwerk.
***            lr_iwerk-sign = 'I'.
***            lr_iwerk-option = 'EQ'.
***            lr_iwerk-low = ls_tb014-werks.
***            APPEND lr_iwerk TO r_iwerk.
***          ENDLOOP.
***
**** Busca Grupo de Planejamento do Perfil
***          DATA lt_tb015 TYPE TABLE OF /ptloms/tb015.
***          SELECT *
***            FROM /ptloms/tb015
***            INTO CORRESPONDING FIELDS OF TABLE lt_tb015
***            FOR ALL ENTRIES IN lt_tb013
***            WHERE perfil = lt_tb013-perfil
***              AND iwerk IN r_iwerk.
***
**** Transforma em Range
***          DATA ls_tb015 LIKE LINE OF lt_tb015.
***          LOOP AT lt_tb015 INTO ls_tb015 WHERE filtro_equi = 'X'.
***            CLEAR ls_ingrp.
***            ls_ingrp-sign   = 'I'.
***            ls_ingrp-option = 'EQ'.
***            ls_ingrp-low    = ls_tb015-ingrp.
***            APPEND ls_ingrp TO r_ingrp.
***          ENDLOOP.
***
**** Busca Área Operacional do Perfil
***          DATA lt_tb016 TYPE TABLE OF /ptloms/tb016.
***          SELECT *
***            FROM /ptloms/tb016
***            INTO CORRESPONDING FIELDS OF TABLE lt_tb016
***            FOR ALL ENTRIES IN lt_tb013
***            WHERE perfil = lt_tb013-perfil
***              AND werks IN r_iwerk.
***
**** Transforma em Range
***          DATA ls_tb016 LIKE LINE OF lt_tb016.
***          LOOP AT lt_tb016 INTO ls_tb016 WHERE filtro_equi = 'X'.
***            CLEAR ls_beber.
***            ls_beber-sign   = 'I'.
***            ls_beber-option = 'EQ'.
***            ls_beber-low    = ls_tb016-beber.
***            APPEND ls_beber TO r_beber.
***          ENDLOOP.
***
**** Busca Centro de Trabalho do Perfil
***          DATA lt_tb017 TYPE TABLE OF /ptloms/tb017.
***          SELECT *
***            FROM /ptloms/tb017
***            INTO CORRESPONDING FIELDS OF TABLE lt_tb017
***            FOR ALL ENTRIES IN lt_tb013
***            WHERE perfil = lt_tb013-perfil
***              AND werks IN r_iwerk.
***
**** Transforma em Range
***          DATA ls_tb017 LIKE LINE OF lt_tb017.
***          LOOP AT lt_tb017 INTO ls_tb017 WHERE filtro_equi = 'X'.
***            CLEAR ls_lgwid.
***            ls_lgwid-sign   = 'I'.
***            ls_lgwid-option = 'EQ'.
***            ls_lgwid-low    = ls_tb017-objid.
***            APPEND ls_lgwid TO r_lgwid.
***          ENDLOOP.
***
**** Busca Categoria de Equipamento do Perfil
***          DATA lt_tb019 TYPE TABLE OF /ptloms/tb019.
***          SELECT *
***            FROM /ptloms/tb019
***            INTO CORRESPONDING FIELDS OF TABLE lt_tb019
***            FOR ALL ENTRIES IN lt_tb013
***            WHERE perfil = lt_tb013-perfil.
***
**** Transforma em Range
***          DATA ls_tb019 LIKE LINE OF lt_tb019.
***          LOOP AT lt_tb019 INTO ls_tb019.
***            CLEAR ls_eqtyp.
***            ls_eqtyp-sign   = 'I'.
***            ls_eqtyp-option = 'EQ'.
***            ls_eqtyp-low    = ls_tb019-eqtyp.
***            APPEND ls_eqtyp TO r_eqtyp.
***          ENDLOOP.
***
**** Busca Tipo de Ojeto Técnico do Perfil
***          DATA lt_tb020 TYPE TABLE OF /ptloms/tb020.
***          SELECT *
***            FROM /ptloms/tb020
***            INTO CORRESPONDING FIELDS OF TABLE lt_tb020
***            FOR ALL ENTRIES IN lt_tb013
***            WHERE perfil = lt_tb013-perfil.
***
**** Transforma em Range
***          DATA ls_tb020 LIKE LINE OF lt_tb020.
***          LOOP AT lt_tb020 INTO ls_tb020 WHERE filtro_equi = 'X'.
***            CLEAR ls_eqart.
***            ls_eqart-sign   = 'I'.
***            ls_eqart-option = 'EQ'.
***            ls_eqart-low    = ls_tb020-eqart.
***            APPEND ls_eqart TO r_eqart.
***          ENDLOOP.
***
***        ENDIF.
***      ENDIF.
***    ENDIF.
***
****--------------------------------------------------------------------------*
**** Status de inclusão e exclusão de equipamentos - Início                   *
**** Não deve ser válido a inclusão e inclusão para configuração 02 do cliente*
****--------------------------------------------------------------------------*
***    IF lv_configuracao <> '02'.
***
***      " Verificar cadastro do status do equipamento inclusivo
***      DATA lt_tb051 TYPE TABLE OF /ptloms/tb051.
***      DATA ls_tb051 LIKE LINE OF lt_tb051.
****      SELECT 'I' AS sign, 'EQ' AS option, stat AS low, stat AS high
****        FROM /ptloms/tb051
****        INTO TABLE @DATA(r_inc)
****        WHERE perfil = @ls_tb013-perfil.
***      SELECT *
***        FROM /ptloms/tb051
***        INTO CORRESPONDING FIELDS OF TABLE lt_tb051
***        WHERE perfil = ls_tb013-perfil.
***
***
***      DATA r_inc TYPE RANGE OF /ptloms/tb051-stat.
***      DATA: lr_inc LIKE LINE OF r_inc.
***
***      LOOP AT lt_tb051 INTO ls_tb051.
***        CLEAR lr_inc.
***        lr_inc-sign   = 'I'.
***        lr_inc-option = 'EQ'.
***        lr_inc-low    = ls_tb051-stat.
***        lr_inc-high   = ls_tb051-stat.
***
***        APPEND lr_inc TO r_inc.
***
***      ENDLOOP.
***
***      " Verificar cadastro do status do equipamento exclusivo
****      SELECT 'I' AS sign, 'EQ' AS option, stat AS low, stat AS high
****        FROM /ptloms/tb052
****        INTO TABLE @DATA(r_exc)
****        WHERE perfil = @ls_tb013-perfil.
***
***      DATA lt_tb052 TYPE TABLE OF /ptloms/tb052.
***      DATA ls_tb052 LIKE LINE OF lt_tb052.
***      SELECT *
***       FROM /ptloms/tb052
***       INTO CORRESPONDING FIELDS OF TABLE lt_tb052
***       WHERE perfil = ls_tb013-perfil.
***
***      DATA r_exc TYPE RANGE OF /ptloms/tb052-stat.
***      DATA: lr_exc LIKE LINE OF r_inc.
***
***      LOOP AT lt_tb052 INTO ls_tb052.
***        CLEAR lr_inc.
***        lr_exc-sign   = 'I'.
***        lr_exc-option = 'EQ'.
***        lr_exc-low    = ls_tb052-stat.
***        lr_exc-high   = ls_tb052-stat.
***
***        APPEND lr_exc TO r_exc.
***
***      ENDLOOP.
***
***    ENDIF.
***
***    " Status de inativo deve ser sempre exclusivo
****    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'I0320' high = 'I0320' ) TO r_exc.
***    lr_exc-sign   = 'I'.
***    lr_exc-option = 'EQ'.
***    lr_exc-low    = 'I0320'.
***    lr_exc-high   = 'I0320'.
***    APPEND lr_exc TO r_exc.
***    " Status de marcado para eliminação deve ser sempre exclusivo
****    APPEND VALUE #( sign = 'I' option = 'EQ' low = 'I0076' high = 'I0076' ) TO r_exc.
***    lr_exc-sign   = 'I'.
***    lr_exc-option = 'EQ'.
***    lr_exc-low    = 'I0076'.
***    lr_exc-high   = 'I0076'.
***    APPEND lr_exc TO r_exc.
***
***
***    " Caso a seleção seja por equipamentos em clientes das ordens atribuídas
***    IF r_objnr[] IS NOT INITIAL.
***
***      " Verificar as ordens para os status inclusivo e exclusivos
***      DATA lt_jest TYPE TABLE OF jest.
***      DATA ls_jest LIKE LINE OF lt_jest.
****      SELECT objnr stat objnr AS equnr
****        FROM jest
****        INTO TABLE it_jest_aux
****        WHERE objnr IN r_objnr
****        AND   inact = space.
***      SELECT objnr stat
***        FROM jest
***        INTO CORRESPONDING FIELDS OF TABLE lt_jest
***        WHERE objnr IN r_objnr
***        AND   inact = space.
***
***      TYPES: BEGIN OF ty_jest,
***               objnr TYPE jest-objnr,
***               stat  TYPE jest-stat,
***               equnr TYPE jest-objnr.
***      TYPES: END OF ty_jest.
***
***      DATA: it_jest_aux TYPE TABLE OF ty_jest.
***      DATA: ls_jest_aux LIKE LINE OF it_jest_aux.
***
***      " Montar a chave do EQUNR para filtro
****      LOOP AT it_jest_aux ASSIGNING FIELD-SYMBOL(<fs>).
****        <fs>-equnr = <fs>-objnr+2(18).
****      ENDLOOP.
***
***      LOOP AT lt_jest INTO ls_jest.
***        ls_jest_aux-objnr = ls_jest-objnr.
***        ls_jest_aux-stat = ls_jest-stat.
***        ls_jest_aux-equnr = ls_jest-objnr+2(18).
***        APPEND ls_jest_aux TO it_jest_aux.
***      ENDLOOP.
***
***    ELSE.
***
***      SELECT objnr
***       FROM v_equi
***       INTO TABLE it_equi_objnr
***       WHERE swerk IN r_iwerk
***         AND ingrp IN r_ingrp
***         AND beber IN r_beber
***         AND gewrk IN r_lgwid
***         AND eqtyp IN r_eqtyp
***         AND eqart IN r_eqart.
***
***      " Buscar os objetos com status inclusivos que não tenha exclusivos conforme sub select abaixo
***      " Não usar CORRESPONDING FIELDS
******      SELECT objnr stat objnr
******        FROM jest
******        INTO TABLE it_jest_aux
******        WHERE objnr LIKE 'IE%'
******        AND   stat  IN r_inc
******        AND   inact = space
***
******      AND objnr NOT IN (
******      " Buscar os objetos com status exclusivos
******      SELECT objnr
******      FROM jest
******      WHERE objnr LIKE 'IE%'
******      AND   stat  IN r_exc
******      AND   inact = space
******      ).
***
***      SELECT objnr stat objnr
***        FROM jest
***        INTO TABLE it_jest_aux
***        FOR ALL ENTRIES IN it_equi_objnr
***        WHERE objnr = it_equi_objnr-objnr
***        AND   stat IN r_inc
***        AND   inact = space
***
***         AND objnr NOT IN (
***         " Buscar os objetos com status exclusivos
***         SELECT objnr
***         FROM jest
***         WHERE objnr = it_equi_objnr-objnr  "objnr LIKE 'IE%'
***         AND   stat  IN r_exc
***         AND   inact = space
***         ).
***
***    ENDIF.
***
***    IF it_jest_aux IS NOT INITIAL.
***
***      SORT it_jest_aux BY objnr stat.
***
***      " Para configuração 02 - Equipamentos em clientes das ordens atribuídas
***      IF lv_configuracao = '02'.
***
***        IF it_jest_aux[] IS NOT INITIAL.
***          " Criar range para incluir o EQUNR que deve ser validado na JEST
****          r_equnr_status = VALUE #( FOR wl IN it_jest_aux ( sign = 'I' option = 'EQ' low = wl-equnr ) ).
***          DATA ls_equnr_status LIKE LINE OF r_equnr_status.
***          LOOP AT it_jest_aux INTO ls_jest_aux.
***            ls_equnr_status-sign = 'I'.
***            ls_equnr_status-option = 'EQ'.
***            ls_equnr_status-low = ls_jest_aux-equnr.
***
***            APPEND ls_equnr_status TO r_equnr_status.
***          ENDLOOP.
***
***          IF r_equnr_status[] IS NOT INITIAL.
***
***            DELETE r_equnr WHERE low NOT IN r_equnr_status[].
***
***          ENDIF.
***
***        ENDIF.
***
***      ENDIF.
***
***    ENDIF.
****-------------------------------------------------------------------*
**** Status de inclusão e exclusão de equipamentos - Fim               *
****-------------------------------------------------------------------*
***
***    IF lv_configuracao = '02'.
***
***      IF r_equnr[] IS NOT INITIAL.
***
***        WHILE r_equnr[] IS NOT INITIAL.
***
***          APPEND LINES OF r_equnr[] FROM 1 TO lv_quantidade_pacote TO r_equnr_copy[].
***
***          DELETE r_equnr FROM 1 TO lv_quantidade_pacote.
***
***          DATA lt_v_equi TYPE TABLE OF v_equi.
***          SELECT equnr eqtyp eqktx eqart brgew invnr
***                 herst typbz serge swerk beber ppsid
***                 eqfnr bukrs anlnr kostl iwerk ingrp
***                 gewrk rbnr  tplnr tidnr submt objnr baujj
***            FROM v_equi
***            APPENDING CORRESPONDING FIELDS OF TABLE lt_v_equi
***            WHERE equnr IN r_equnr_copy
***            AND txasp EQ 'X'
***              AND owner EQ space
***              AND spras EQ sy-langu
***              AND bukrs IN rt_bukrs
***              AND iwerk IN rt_iwerk
***              AND eqtyp IN rt_eqtyp
***              AND ingrp IN rt_ingrp
***              AND beber IN rt_beber
***              AND gewrk IN rt_gewrk
***              AND eqart IN rt_eqart
***              AND datbi EQ '99991231'.
***
***          CLEAR: r_equnr_copy[].
***
***        ENDWHILE.
***
***      ELSE.
***
***        SELECT equnr eqtyp eqktx eqart brgew invnr
***               herst typbz serge swerk beber ppsid
***               eqfnr bukrs anlnr kostl iwerk ingrp
***               gewrk rbnr  tplnr tidnr submt objnr baujj
***          FROM v_equi
***          INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
***          WHERE txasp EQ 'X'
***            AND equnr IN r_equnr   " Filtro dos equipamentos com status inclusivos e exclusivos
***            AND owner EQ space
***            AND spras EQ sy-langu
***            AND bukrs IN rt_bukrs
***            AND iwerk IN rt_iwerk
***            AND eqtyp IN rt_eqtyp
***            AND ingrp IN rt_ingrp
***            AND beber IN rt_beber
***            AND gewrk IN rt_gewrk
***            AND eqart IN rt_eqart
***            AND datbi EQ '99991231'.
***
***      ENDIF.
***
***    ELSE.
***
**** É obrigatório cadastrar a categoria de equipamento para o Perfil
***      IF r_eqtyp[] IS INITIAL. " Se range estiver vazio, então não busca equipamentos (É necessário cadastrar categoria de equipamento para o perfil)
***        RETURN.
***      ENDIF.
***
***      IF it_jest_aux IS NOT INITIAL.
***
**** Seleciona Equipamentos
***        SELECT equnr eqtyp eqktx eqart brgew invnr
***               herst typbz serge swerk beber ppsid
***               eqfnr bukrs anlnr kostl iwerk ingrp
***               gewrk rbnr  tplnr tidnr submt objnr baujj
***          FROM v_equi
***          INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
***          FOR ALL ENTRIES IN it_jest_aux
***          WHERE objnr EQ it_jest_aux-objnr
***            AND txasp EQ 'X'
***            AND owner EQ space
***            AND spras EQ sy-langu
***            AND bukrs IN rt_bukrs
***            AND iwerk IN rt_iwerk
***            AND eqtyp IN rt_eqtyp
***            AND ingrp IN rt_ingrp
***            AND beber IN rt_beber
***            AND gewrk IN rt_gewrk
***            AND eqart IN rt_eqart
***            AND datbi EQ '99991231'
***
***            " Filtros relativos ao Usuário
***            AND swerk IN r_iwerk
***            AND ingrp IN r_ingrp
***            AND beber IN r_beber
***            AND gewrk IN r_lgwid
***            AND eqtyp IN r_eqtyp
***            AND eqart IN r_eqart.
***
***      ELSE.
***
**** Seleciona Equipamentos
***        SELECT equnr eqtyp eqktx eqart brgew invnr
***               herst typbz serge swerk beber ppsid
***               eqfnr bukrs anlnr kostl iwerk ingrp
***               gewrk rbnr  tplnr tidnr submt objnr baujj
***          FROM v_equi
***          INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
***          WHERE txasp EQ 'X'
***            AND owner EQ space
***            AND spras EQ sy-langu
***            AND bukrs IN rt_bukrs
***            AND iwerk IN rt_iwerk
***            AND eqtyp IN rt_eqtyp
***            AND ingrp IN rt_ingrp
***            AND beber IN rt_beber
***            AND gewrk IN rt_gewrk
***            AND eqart IN rt_eqart
***            AND datbi EQ '99991231'
***
***           " Filtros relativos ao Usuário
***            AND swerk IN r_iwerk
***            AND ingrp IN r_ingrp
***            AND beber IN r_beber
***            AND gewrk IN r_lgwid
***            AND eqtyp IN r_eqtyp
***            AND eqart IN r_eqart.
***
***      ENDIF.
***
***    ENDIF.
***
**** Verifica se encontrou equipamento
***    IF lt_v_equi[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
***    DATA lt_equi_final LIKE lt_v_equi.
***    lt_equi_final = lt_v_equi.
****    DATA(lt_equi_final) = lt_v_equi[].
***
***    SORT lt_v_equi BY equnr ASCENDING.
***    DELETE ADJACENT DUPLICATES FROM lt_v_equi COMPARING equnr.
***
**** Busca status do Equipamento
***    DATA it_jest TYPE TABLE OF jest.
***    SELECT objnr stat inact
***      FROM jest
***      INTO CORRESPONDING FIELDS OF TABLE it_jest
***      FOR ALL ENTRIES IN lt_v_equi
***      WHERE objnr = lt_v_equi-objnr.
***
***    SORT it_jest BY objnr stat inact.
***
**** Busca garantia Equipamento
***    DATA lt_bgmkobj TYPE TABLE OF bgmkobj.
***    SELECT j_objnr gaart gwldt gwlen
***      FROM bgmkobj
***      INTO CORRESPONDING FIELDS OF TABLE lt_bgmkobj
***      FOR ALL ENTRIES IN lt_v_equi
***      WHERE j_objnr = lt_v_equi-objnr.
***
**** Busca configuração do sistema
***    DATA ls_033 TYPE /ptloms/tb033.
***    SELECT SINGLE anexo_ordem anexo_locl anexo_equi
***      FROM /ptloms/tb033
***      INTO CORRESPONDING FIELDS OF ls_033.
***
***    DESCRIBE TABLE lt_equi_final LINES ex_quantidade_equipamento.
***
**** Monta tabela de saída
***    DATA ls_v_equi LIKE LINE OF lt_equi_final.
***    LOOP AT lt_equi_final INTO ls_v_equi.
***
**** Melhoria Performance - Início
***      DATA lv_tabix TYPE sy-tabix.
***      lv_tabix = sy-tabix.
***      IF im_top > 0.
***        IF lv_tabix <= im_skip.
***          CONTINUE.
***        ENDIF.
***
***        lv_quantidade_equipamento = lv_quantidade_equipamento + 1.
***        IF lv_quantidade_equipamento > im_top.
***          EXIT.
***        ENDIF.
***      ENDIF.
**** Melhoria Performance - Fim
***
**** Atribui campos correspondentes
***      MOVE-CORRESPONDING ls_v_equi TO ls_equipamento.
***
**** Limpa variáveis
***      CLEAR: lv_anw_stat_existing, lv_e_stsma,
***             lv_line, lv_user_line, lv_stonr.
***
**** Chama função que retorna status de usuário e sistema
***      CALL FUNCTION 'STATUS_TEXT_EDIT'
***        EXPORTING
***          objnr             = ls_v_equi-objnr
****         only_active       = 'X'
***          spras             = sy-langu
***        IMPORTING
***          anw_stat_existing = lv_anw_stat_existing
***          e_stsma           = lv_e_stsma
***          line              = lv_line
***          user_line         = lv_user_line
***          stonr             = lv_stonr
***        EXCEPTIONS
***          object_not_found  = 1
***          OTHERS            = 2.
***
***      IF sy-subrc = 0.
**** Carrega status de usuário e sistema
***        MOVE: lv_user_line TO ls_equipamento-status_usuario,
***              lv_line      TO ls_equipamento-status_sistema.
***      ENDIF.
***
**** Busca garantia inicial/final cliente
***      DATA ls_bgmkobj LIKE LINE OF lt_bgmkobj.
***      READ TABLE lt_bgmkobj INTO ls_bgmkobj WITH KEY j_objnr = ls_v_equi-objnr
***                                                           gaart   = '1'.
***      IF sy-subrc EQ 0.
***        MOVE: ls_bgmkobj-gwldt TO ls_equipamento-gwldt_ini,
***              ls_bgmkobj-gwlen TO ls_equipamento-gwlen_ini.
***      ENDIF.
***
**** Busca garantia inicial/final fornecedor
***      READ TABLE lt_bgmkobj INTO ls_bgmkobj WITH KEY j_objnr = ls_v_equi-objnr
***                                                     gaart   = '2'.
***      IF sy-subrc EQ 0.
***        MOVE: ls_bgmkobj-gwldt TO ls_equipamento-gwldt_fim,
***              ls_bgmkobj-gwlen TO ls_equipamento-gwlen_fim.
***      ENDIF.
***
**** Carrega imagens do Equipamento
***      IF ls_033-anexo_equi = 'X'.
***        CLEAR: ls_instid_a, ls_typeid_a.
***        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.
***
***        ls_instid_a-sign = 'I'.
***        ls_instid_a-option = 'EQ'.
***        ls_instid_a-low = ls_v_equi-equnr.
***        APPEND ls_instid_a TO r_instid_a.
***
***        ls_typeid_a-sign = 'I'.
***        ls_typeid_a-option = 'EQ'.
***        ls_typeid_a-low = 'EQUI'.
***        APPEND ls_typeid_a TO r_typeid_a.
***
***        " 11/08/2023 - Verificar serviço individual
********        lt_anexo = me->out_imagem( rt_instid_a = r_instid_a
********                                   rt_typeid_a = r_typeid_a ).
********
********        IF lt_anexo[] IS NOT INITIAL.
********          APPEND LINES OF lt_anexo TO et_imagems_equipamento.
********        ENDIF.
***        " 11/08/2023 - Verificar serviço individual
***      ENDIF.
***
**** Carrega Filtro EQUNR
***      IF ls_equipamento-equnr IS NOT INITIAL.
***        FIELD-SYMBOLS <fs_filtro> LIKE LINE OF et_filtro_equnr.
***        READ TABLE et_filtro_equnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-equnr.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
****          ls_filtro-key   = |{ ls_equipamento-equnr ALPHA = OUT }|.
***          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
***            EXPORTING
***              input  = ls_equipamento-equnr
***            IMPORTING
***              output = ls_filtro-key.
****          ls_filtro-text  = |{ ls_equipamento-equnr ALPHA = OUT }|.
***          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
***            EXPORTING
***              input  = ls_equipamento-equnr
***            IMPORTING
***              output = ls_filtro-text.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_equnr.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro EQKTX
***      IF ls_equipamento-eqktx IS NOT INITIAL.
***        READ TABLE et_filtro_eqktx ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-eqktx.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key   = ls_equipamento-eqktx.
***          ls_filtro-text  = ls_equipamento-eqktx.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_eqktx.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro INVNR
***      IF ls_equipamento-invnr IS NOT INITIAL.
***        READ TABLE et_filtro_invnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-invnr.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key   = ls_equipamento-invnr.
***          ls_filtro-text  = ls_equipamento-invnr.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_invnr.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro INVNR
***      IF ls_equipamento-tidnr IS NOT INITIAL.
***        READ TABLE et_filtro_tidnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-tidnr.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key   = ls_equipamento-tidnr.
***          ls_filtro-text  = ls_equipamento-tidnr.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_tidnr.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
***      ls_equipamento-quantidade_equipamento = ex_quantidade_equipamento.
***
**** Inclui na tabela de saída
***      APPEND ls_equipamento TO et_equipamento.
***    ENDLOOP.
***
***    SORT et_equipamento BY equnr ASCENDING.
***    DELETE ADJACENT DUPLICATES FROM et_equipamento COMPARING equnr.
***
***  ENDMETHOD.


  METHOD out_equipamento_unico.

    FIELD-SYMBOLS <fs_filtro> LIKE LINE OF et_filtro_equnr..

*   Declaração de range
    DATA: r_instid_a     TYPE /iwbep/t_cod_select_options,
          r_typeid_a     TYPE /iwbep/t_cod_select_options,
          r_iwerk        TYPE RANGE OF v_equi-iwerk, " Centro de Planejamento
          r_ingrp        TYPE RANGE OF v_equi-ingrp, " Grupo de Planejamento
          r_beber        TYPE RANGE OF v_equi-beber, " Área Operacional
          r_lgwid        TYPE RANGE OF v_equi-gewrk, " ID Centro de Trabalho
          r_eqtyp        TYPE RANGE OF v_equi-eqtyp, " Categoria Equipamento
          r_eqart        TYPE RANGE OF v_equi-eqart, " Tipo de Objeto Técnico
          r_equnr        TYPE RANGE OF v_equi-equnr, " Equipamento
          r_equnr_copy   TYPE RANGE OF v_equi-equnr, " Equipamento
          r_equnr_status TYPE RANGE OF v_equi-objnr,
          rt_equnr_num   TYPE /iwbep/t_cod_select_options,
          r_objnr        TYPE RANGE OF jest-objnr,
          r_exc          TYPE RANGE OF /ptloms/tb052-stat,
          r_inc          TYPE RANGE OF /ptloms/tb051-stat.

*         Declaração de tabela
    DATA: lt_anexo   TYPE /ptloms/ct072,
          lt_tb013   TYPE TABLE OF /ptloms/tb013,
          lt_tb014   TYPE TABLE OF /ptloms/tb014,
          lt_tb015   TYPE TABLE OF /ptloms/tb015,
          lt_tb016   TYPE TABLE OF /ptloms/tb016,
          lt_tb017   TYPE TABLE OF /ptloms/tb017,
          lt_tb019   TYPE TABLE OF /ptloms/tb019,
          lt_tb020   TYPE TABLE OF /ptloms/tb020,
          lt_tb051   TYPE TABLE OF /ptloms/tb051,
          lt_jest    TYPE TABLE OF jest,
*         lt_v_equi     TYPE TABLE OF v_equi,
          lt_bgmkobj TYPE TABLE OF bgmkobj.

    TYPES: BEGIN OF ty_equi_objnr,
             objnr TYPE equi-objnr,
             stat  TYPE jest-stat,
             inact TYPE jest-inact,
           END OF ty_equi_objnr.

    DATA: it_equi_objnr TYPE TABLE OF ty_equi_objnr.

    TYPES: BEGIN OF ty_jest,
             objnr TYPE jest-objnr,
             stat  TYPE jest-stat,
             equnr TYPE jest-objnr.
    TYPES: END OF ty_jest.

    DATA: it_jest_aux TYPE TABLE OF ty_jest.
    DATA: ls_jest_aux LIKE LINE OF it_jest_aux.

    TYPES: BEGIN OF ty_v_equi,
             equnr TYPE v_equi-objnr,
             eqtyp TYPE v_equi-eqtyp,
             eqktx TYPE v_equi-eqktx,
             eqart TYPE v_equi-eqart,
             brgew TYPE v_equi-brgew,
             invnr TYPE v_equi-invnr,
             herst TYPE v_equi-herst,
             typbz TYPE v_equi-typbz,
             serge TYPE v_equi-serge,
             swerk TYPE v_equi-swerk,
             beber TYPE v_equi-beber,
             ppsid TYPE v_equi-ppsid,
             eqfnr TYPE v_equi-eqfnr,
             bukrs TYPE v_equi-bukrs,
             anlnr TYPE v_equi-anlnr,
             kostl TYPE v_equi-kostl,
             iwerk TYPE v_equi-iwerk,
             ingrp TYPE v_equi-ingrp,
             gewrk TYPE v_equi-gewrk,
             rbnr  TYPE v_equi-rbnr,
             tplnr TYPE v_equi-tplnr,
             tidnr TYPE v_equi-tidnr,
             submt TYPE v_equi-submt,
             objnr TYPE v_equi-objnr,
             baujj TYPE v_equi-baujj,
             stat  TYPE jest-stat,
             inact TYPE jest-inact,
           END OF ty_v_equi,

           BEGIN OF ty_fleet,
             objnr       TYPE fleet-objnr,
             fleet_num   TYPE fleet-fleet_num,
             license_num TYPE fleet-license_num,
           END OF ty_fleet.

    DATA: lt_v_equi TYPE TABLE OF ty_v_equi,
          lt_fleet  TYPE TABLE OF ty_fleet.

    DATA: lt_equi_final LIKE lt_v_equi.

    DATA: lt_jstat TYPE TABLE OF jstat,
          ls_jstat TYPE jstat.

*   Declaração de estrutura
    DATA: ls_equipamento LIKE LINE OF et_equipamento,
          ls_instid_a    LIKE LINE OF r_instid_a,
          ls_typeid_a    LIKE LINE OF r_typeid_a,
          ls_iwerk       LIKE LINE OF r_iwerk,
          ls_ingrp       LIKE LINE OF r_ingrp,
          ls_beber       LIKE LINE OF r_beber,
          ls_lgwid       LIKE LINE OF r_lgwid,
          ls_eqtyp       LIKE LINE OF r_eqtyp,
          ls_eqart       LIKE LINE OF r_eqart,
          ls_equnr       LIKE LINE OF r_equnr,
          ls_objnr       LIKE LINE OF r_objnr,
          ls_filtro      TYPE /ptloms/et056,
          ls_tb013       LIKE LINE OF lt_tb013,
          ls_equnr_aux   LIKE LINE OF rt_equnr_num,
          ls_tb014       LIKE LINE OF lt_tb014,
          lr_iwerk       LIKE LINE OF r_iwerk,
          ls_tb015       LIKE LINE OF lt_tb015,
          ls_tb016       LIKE LINE OF lt_tb016,
          ls_tb017       LIKE LINE OF lt_tb017,
          ls_tb019       LIKE LINE OF lt_tb019,
          ls_tb020       LIKE LINE OF lt_tb020,
          ls_tb051       LIKE LINE OF lt_tb051,
          lr_inc         LIKE LINE OF r_inc,
          lt_tb052       TYPE TABLE OF /ptloms/tb052,
          ls_tb052       LIKE LINE OF lt_tb052,
          lr_exc         LIKE LINE OF r_inc,
          ls_jest        LIKE LINE OF lt_jest,
          ls_bgmkobj     LIKE LINE OF lt_bgmkobj,
          ls_033         TYPE /ptloms/tb033,
          ls_v_equi      LIKE LINE OF lt_equi_final,
          ls_fleet       LIKE LINE OF lt_fleet.

*   Declaração de variáveis
    DATA: lv_line                   TYPE bsvx-sttxt,
          lv_user_line              TYPE bsvx-sttxt,
          lv_anw_stat_existing      TYPE xfeld,
          lv_e_stsma                TYPE jsto-stsma,
          lv_stonr                  TYPE tj30-stonr,
          lv_quantidade_equipamento TYPE int4,
          lv_quantidade_pacote      TYPE int4 VALUE 2000,
          lv_equnr                  TYPE equnr,
          lv_configuracao           TYPE /ptloms/tb044-configuracao,
          lv_tabix                  TYPE sy-tabix.

**   Verifica se parâmetros de entrada estão preenchidos
    IF rt_equnr[] IS INITIAL AND it_equipamento[] IS INITIAL.
      RETURN.
    ENDIF.

*   Status de inativo deve ser sempre exclusivo (Inativo)
    lr_exc-sign   = 'I'.
    lr_exc-option = 'EQ'.
    lr_exc-low    = 'I0320'.
    lr_exc-high   = 'I0320'.
    APPEND lr_exc TO r_exc.

*   Status de inativo deve ser sempre exclusivo (Marcação para eliminação)
    lr_exc-sign   = 'I'.
    lr_exc-option = 'EQ'.
    lr_exc-low    = 'I0076'.
    lr_exc-high   = 'I0076'.
    APPEND lr_exc TO r_exc.

*   Status de inativo deve ser sempre exclusivo (Cód.elimin., possível arquivar.)
    lr_exc-sign   = 'I'.
    lr_exc-option = 'EQ'.
    lr_exc-low    = 'I0013'.
    lr_exc-high   = 'I0013'.
    APPEND lr_exc TO r_exc.

*-------------------------------------------------------------------*
* Status de inclusão e exclusão de equipamentos - Fim               *
*-------------------------------------------------------------------*

    IF it_equipamento[] IS NOT INITIAL.

      SELECT equnr eqtyp eqktx eqart brgew invnr
             herst typbz serge swerk beber ppsid
             eqfnr bukrs anlnr kostl iwerk ingrp
             gewrk rbnr  tplnr tidnr submt objnr baujj
        FROM v_equi
        INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
        FOR ALL ENTRIES IN it_equipamento
        WHERE equnr = it_equipamento-equnr.

    ELSE.

      SELECT equnr eqtyp eqktx eqart brgew invnr
             herst typbz serge swerk beber ppsid
             eqfnr bukrs anlnr kostl iwerk ingrp
             gewrk rbnr  tplnr tidnr submt objnr baujj
        FROM v_equi
        INTO CORRESPONDING FIELDS OF TABLE lt_v_equi
        WHERE  equnr IN rt_equnr.   "Filtro dos equipamentos com status inclusivos e exclusivos

    ENDIF.

*   Verifica se encontrou equipamento
    IF lt_v_equi[] IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_v_equi BY equnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_v_equi COMPARING equnr.
    lt_equi_final = lt_v_equi.

*   Busca Placa do veiculo e Num de indentificação
    SELECT objnr fleet_num license_num
      FROM fleet
      INTO CORRESPONDING FIELDS OF TABLE lt_fleet
      FOR ALL ENTRIES IN lt_v_equi
      WHERE objnr = lt_v_equi-objnr.

*   Busca configuração do sistema
    SELECT SINGLE anexo_ordem anexo_locl anexo_equi
      FROM /ptloms/tb033
      INTO CORRESPONDING FIELDS OF ls_033.

    DESCRIBE TABLE lt_equi_final LINES ex_quantidade_equipamento.

*   Monta tabela de saída
    LOOP AT lt_equi_final INTO ls_v_equi.

*     Melhoria Performance - Início
      lv_tabix = sy-tabix.
      IF im_top > 0.
        IF lv_tabix <= im_skip.
          CONTINUE.
        ENDIF.

        lv_quantidade_equipamento = lv_quantidade_equipamento + 1.
        IF lv_quantidade_equipamento > im_top.
          EXIT.
        ENDIF.
      ENDIF.
*     Melhoria Performance - Fim

*     Atribui campos correspondentes
      MOVE-CORRESPONDING ls_v_equi TO ls_equipamento.

*     Limpa variáveis
      CLEAR: lv_anw_stat_existing, lv_e_stsma,
             lv_line, lv_user_line, lv_stonr.

*     Chama função que retorna status de usuário e sistema
      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
          objnr             = ls_v_equi-objnr
          spras             = sy-langu
        IMPORTING
          anw_stat_existing = lv_anw_stat_existing
          e_stsma           = lv_e_stsma
          line              = lv_line
          user_line         = lv_user_line
          stonr             = lv_stonr
        EXCEPTIONS
          object_not_found  = 1
          OTHERS            = 2.

      IF sy-subrc = 0.  "Carrega status de usuário e sistema
        MOVE: lv_user_line TO ls_equipamento-status_usuario,
              lv_line      TO ls_equipamento-status_sistema.
      ENDIF.

      IF ls_equipamento-objnr IS NOT INITIAL.

*     Busca Placa do veiculo e Num de indentificação
        CLEAR ls_fleet.
        READ TABLE lt_fleet INTO ls_fleet WITH KEY objnr = ls_equipamento-objnr.
        IF sy-subrc EQ 0.
          ls_equipamento-fleet_num   = ls_fleet-fleet_num.
          ls_equipamento-license_num = ls_fleet-license_num.
        ENDIF.

      ENDIF.

*     Carrega imagens do Equipamento
      IF ls_033-anexo_equi = 'X'.
        CLEAR: ls_instid_a, ls_typeid_a.
        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.

        ls_instid_a-sign = 'I'.
        ls_instid_a-option = 'EQ'.
        ls_instid_a-low = ls_v_equi-equnr.
        APPEND ls_instid_a TO r_instid_a.

        ls_typeid_a-sign = 'I'.
        ls_typeid_a-option = 'EQ'.
        ls_typeid_a-low = 'EQUI'.
        APPEND ls_typeid_a TO r_typeid_a.

      ENDIF.

*     Carrega Filtro EQUNR
      IF ls_equipamento-equnr IS NOT INITIAL.
        READ TABLE et_filtro_equnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-equnr.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_equipamento-equnr
            IMPORTING
              output = ls_filtro-key.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = ls_equipamento-equnr
            IMPORTING
              output = ls_filtro-text.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_equnr.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

*     Carrega Filtro EQKTX
      IF ls_equipamento-eqktx IS NOT INITIAL.
        READ TABLE et_filtro_eqktx ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-eqktx.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
          ls_filtro-key   = ls_equipamento-eqktx.
          ls_filtro-text  = ls_equipamento-eqktx.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_eqktx.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

*     Carrega Filtro INVNR
      IF ls_equipamento-invnr IS NOT INITIAL.
        READ TABLE et_filtro_invnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-invnr.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
          ls_filtro-key   = ls_equipamento-invnr.
          ls_filtro-text  = ls_equipamento-invnr.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_invnr.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

*     Carrega Filtro TIDNR
      IF ls_equipamento-tidnr IS NOT INITIAL.
        READ TABLE et_filtro_tidnr ASSIGNING <fs_filtro> WITH KEY key = ls_equipamento-tidnr.
        IF sy-subrc NE 0.
          CLEAR ls_filtro.
          ls_filtro-key   = ls_equipamento-tidnr.
          ls_filtro-text  = ls_equipamento-tidnr.
          ls_filtro-count = 1.
          APPEND ls_filtro TO et_filtro_tidnr.
        ELSE.
          <fs_filtro>-count = <fs_filtro>-count + 1.
        ENDIF.
      ENDIF.

      ls_equipamento-quantidade_equipamento = ex_quantidade_equipamento.

*     Busca descrição do status do equipamento
      CALL FUNCTION 'STATUS_READ'
        EXPORTING
          objnr            = ls_equipamento-objnr
          only_active      = 'X'
        TABLES
          status           = lt_jstat
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.
      IF sy-subrc = 0.
        READ TABLE lt_jstat INTO ls_jstat INDEX 1.
        IF sy-subrc = 0.
          ls_equipamento-status = ls_jstat-stat.
          SELECT SINGLE txt30 INTO ls_equipamento-desc_status
            FROM tj02t
            WHERE istat = ls_jstat-stat
              AND spras = sy-langu.
        ENDIF.
      ENDIF.
      CLEAR: lt_jstat.

*     Inclui na tabela de saída
      APPEND ls_equipamento TO et_equipamento.
      CLEAR ls_equipamento.

    ENDLOOP.

    SORT et_equipamento BY equnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_equipamento COMPARING equnr.

  ENDMETHOD.


  METHOD out_equipamento_v2.

    CONSTANTS: c_ag  TYPE ihpa-parvw VALUE 'SP',
               c_ieq TYPE ihpa-obtyp VALUE 'IEQ'.

    DATA: ls_equnr LIKE LINE OF rt_equnr.

    DATA: lv_parvw     TYPE ihpa-parvw,
          lv_usuario   TYPE /ptloms/tb013-usuario,
          lv_objnr     TYPE jsto-objnr,
          lv_desprezar TYPE char1.

* Verifica se Existe Usuário
    IF rt_usuario_app[] IS INITIAL.
      RETURN.
    ENDIF.

* Monta horizonte Usuário
    DATA ls_usuario_app LIKE LINE OF rt_usuario_app.
    READ TABLE rt_usuario_app INTO ls_usuario_app INDEX 1.
    IF ls_usuario_app-sign = 'I' AND ls_usuario_app-option = 'EQ'.
      lv_usuario = ls_usuario_app-low.
      DATA rt_data_conf_usuario TYPE /iwbep/t_cod_select_options.
      rt_data_conf_usuario = me->out_monta_range_data_usuario( lv_usuario ).
    ENDIF.

* Busca ordens despachadas (que estão dentro do horizonte do usuário)
    TYPES: BEGIN OF ty_ordens_despachadas,
             aufnr           TYPE /ptloms/tb026-aufnr,
             vornr           TYPE /ptloms/tb026-vornr,
             suboper         TYPE /ptloms/tb026-suboper,
             usuario         TYPE /ptloms/tb026-usuario,
             data_associacao TYPE /ptloms/tb026-data_associacao,
             hora_associacao TYPE /ptloms/tb026-hora_associacao,
             objnr           TYPE viaufks-objnr.
    TYPES: END OF ty_ordens_despachadas.
    DATA lt_tb026_aux TYPE TABLE OF ty_ordens_despachadas.

    SELECT a~aufnr a~vornr a~suboper a~usuario a~data_associacao a~hora_associacao b~objnr
      FROM /ptloms/tb026 AS a INNER JOIN viaufks AS b ON a~aufnr EQ b~aufnr
      INNER JOIN afvc AS c ON b~aufpl = c~aufpl
      INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
      INTO CORRESPONDING FIELDS OF TABLE lt_tb026_aux
        WHERE a~usuario      IN rt_usuario_app
          AND a~desassociado EQ space
          AND ( d~fsavd IN rt_data_conf_usuario OR d~fsedd IN rt_data_conf_usuario ).

* Verifica se encontrou alguma Ordem
    IF lt_tb026_aux[] IS INITIAL.
      RETURN.
    ENDIF.

*    DATA(lt_tb026) = lt_tb026_aux[].
    DATA lt_tb026 LIKE lt_tb026_aux.
    lt_tb026 = lt_tb026_aux[].
    REFRESH lt_tb026[].

* Desconsiderar os status ENTE, ENCE, CONF, MREL e BLOQ.
    DATA ls_tb026_aux LIKE LINE OF lt_tb026_aux.
    LOOP AT lt_tb026_aux INTO ls_tb026_aux.
      lv_objnr = ls_tb026_aux-objnr.
      CLEAR lv_desprezar.
      CALL FUNCTION '/PTLOMS/MF008'
        EXPORTING
          im_objnr     = lv_objnr
        IMPORTING
          ex_desprezar = lv_desprezar.
      IF lv_desprezar EQ 'X'.
        CONTINUE.
      ENDIF.
      APPEND ls_tb026_aux TO lt_tb026.
    ENDLOOP.

* Verifica se encontrou alguma Ordem
    IF lt_tb026[] IS INITIAL.
      RETURN.
    ENDIF.

* Busca Equipamento da Ordem
    TYPES: BEGIN OF ty_equipamentos_ordem,
             aufnr TYPE afih-aufnr,
             equnr TYPE afih-equnr,
             objnr TYPE equi-objnr.
    TYPES: END OF ty_equipamentos_ordem.

    DATA lt_afih TYPE TABLE OF ty_equipamentos_ordem.

    SELECT a~aufnr a~equnr b~objnr
      FROM afih AS a INNER JOIN equi AS b ON a~equnr = b~equnr
      INTO CORRESPONDING FIELDS OF TABLE lt_afih
      FOR ALL ENTRIES IN lt_tb026
      WHERE a~aufnr = lt_tb026-aufnr.

* Verifica se encontrou equipamentos
    IF lt_afih[] IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = c_ag
      IMPORTING
        output = lv_parvw.

* Busca Emissor da Ordem
    DATA lt_ihpa TYPE TABLE OF ihpa.
    SELECT objnr parvw counter parnr
      FROM ihpa
      INTO CORRESPONDING FIELDS OF TABLE lt_ihpa
      FOR ALL ENTRIES IN lt_afih
      WHERE objnr    = lt_afih-objnr
        AND parvw    = lv_parvw
        AND kzloesch = space.

    IF lt_ihpa[] IS NOT INITIAL.
* Busca Equipamentos do Cliente
      DATA lt_ihpa_parceiro TYPE TABLE OF ihpa.
      SELECT objnr parvw counter parnr
        FROM ihpa
        INTO CORRESPONDING FIELDS OF TABLE lt_ihpa_parceiro
        FOR ALL ENTRIES IN lt_ihpa
        WHERE parvw    = lv_parvw
          AND obtyp    = c_ieq
          AND parnr    = lt_ihpa-parnr
          AND kzloesch = space.

    ENDIF.

    IF lt_afih IS NOT INITIAL.
*Dados de cliente na aba Dds.série
      SORT lt_afih BY equnr.

      DATA lt_eqbs TYPE TABLE OF eqbs.
      SELECT equnr kunnr
        FROM eqbs
        INTO CORRESPONDING FIELDS OF TABLE lt_eqbs
        FOR ALL ENTRIES IN lt_afih
        WHERE equnr = lt_afih-equnr.

      IF sy-subrc IS INITIAL.

        DATA lt_eqbs_aux LIKE lt_eqbs.
        lt_eqbs_aux = lt_eqbs[].
        REFRESH: lt_eqbs.
        DELETE lt_eqbs_aux  WHERE kunnr  = space.

        IF  lt_eqbs_aux[]  IS NOT INITIAL.

          SELECT equnr kunnr
            FROM eqbs
            INTO CORRESPONDING FIELDS OF TABLE lt_eqbs
            FOR ALL ENTRIES IN lt_eqbs_aux
            WHERE kunnr = lt_eqbs_aux-kunnr.

          IF sy-subrc IS NOT INITIAL.
            CLEAR: lt_eqbs[].
          ENDIF.

        ENDIF.

      ELSE.

        CLEAR: lt_eqbs.

      ENDIF.

    ENDIF.

    IF  lt_ihpa_parceiro[] IS INITIAL
    AND lt_eqbs[]          IS INITIAL.

      RETURN.

    ENDIF.

    IF lt_ihpa_parceiro[] IS NOT INITIAL.
* Busca equipamentos
      DATA lt_equi TYPE TABLE OF equi.
      SELECT equnr objnr
        FROM equi
        INTO CORRESPONDING FIELDS OF TABLE lt_equi
        FOR ALL ENTRIES IN lt_ihpa_parceiro
        WHERE objnr = lt_ihpa_parceiro-objnr.
    ENDIF.

* Monta Saída
    DATA ls_ihpa_parceiro LIKE LINE OF lt_ihpa_parceiro.
    LOOP AT lt_ihpa_parceiro INTO ls_ihpa_parceiro.
      DATA ls_equi LIKE LINE OF lt_equi.
      READ TABLE lt_equi INTO ls_equi WITH KEY objnr = ls_ihpa_parceiro-objnr.
      IF sy-subrc EQ 0.
        CLEAR ls_equnr.
        ls_equnr-sign = 'I'.
        ls_equnr-option = 'EQ'.
        ls_equnr-low = ls_equi-equnr.
        APPEND ls_equnr TO rt_equnr.
      ENDIF.
    ENDLOOP.

*Montar saída com os dados de clientes da aba Dds. série
    DATA ls_eqbs LIKE LINE OF lt_eqbs.
    LOOP AT lt_eqbs INTO ls_eqbs.
      CLEAR ls_equnr.
      ls_equnr-sign = 'I'.
      ls_equnr-option = 'EQ'.
      ls_equnr-low = ls_eqbs-equnr.
      APPEND ls_equnr TO rt_equnr.
    ENDLOOP.

    SORT rt_equnr BY sign option low.
    DELETE ADJACENT DUPLICATES FROM rt_equnr COMPARING sign option low.

  ENDMETHOD.


 METHOD OUT_ESTOQUE_MATERIAL.
***
**** Declaração de range
***    DATA: r_matnr TYPE /iwbep/t_cod_select_options,
***          r_werks TYPE RANGE OF t001w-werks,
***          r_lgort TYPE RANGE OF t001l-lgort.
***
**** Declaração de estrutura
***    DATA: ls_saldo LIKE LINE OF et_saldo,
***          ls_werks LIKE LINE OF r_werks,
***          ls_lgort LIKE LINE OF r_lgort.
***
**** Declaraçãode variável
***    DATA: lv_matnr TYPE matnr.
***
**** Verifica se Material e Centro foram preenchidos
***    IF rt_matnr[] IS INITIAL OR rt_werks IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca perfil do usuário
***    IF rt_usuario_app[] IS NOT INITIAL.
***      SELECT usuario, perfil
***        FROM /ptloms/tb013
***        INTO TABLE @DATA(lt_tb013)
***        WHERE usuario IN @rt_usuario_app.
***
***      IF lt_tb013[] IS NOT INITIAL.
***
**** Busca Centro do Perfil
***        SELECT *
***          FROM /ptloms/tb014
***          INTO TABLE @DATA(lt_tb014)
***          FOR ALL ENTRIES IN @lt_tb013
***          WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***        LOOP AT lt_tb014 INTO DATA(ls_tb014).
***          CLEAR ls_werks.
***          ls_werks-sign   = 'I'.
***          ls_werks-option = 'EQ'.
***          ls_werks-low    = ls_tb014-werks.
***          APPEND ls_werks TO r_werks.
***        ENDLOOP.
***
**** Busca Depósito do Perfil
***        SELECT *
***          FROM /ptloms/tb030
***          INTO TABLE @DATA(lt_tb030)
***          FOR ALL ENTRIES IN @lt_tb013
***          WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***        LOOP AT lt_tb030 INTO DATA(ls_tb030).
***          CLEAR ls_lgort.
***          ls_lgort-sign   = 'I'.
***          ls_lgort-option = 'EQ'.
***          ls_lgort-low    = ls_tb030-lgort.
***          APPEND ls_lgort TO r_lgort.
***        ENDLOOP.
***
***      ENDIF.
***    ENDIF.
***
***    r_matnr[] = rt_matnr[].
***
**** Converte o campo MATNR
***    LOOP AT r_matnr ASSIGNING FIELD-SYMBOL(<fs_matnr>).
***      IF <fs_matnr>-low IS NOT INITIAL.
***        MOVE <fs_matnr>-low TO lv_matnr.
***        <fs_matnr>-low = |{ lv_matnr ALPHA = IN }|.
***      ENDIF.
***      IF <fs_matnr>-high IS NOT INITIAL.
***        MOVE <fs_matnr>-high TO lv_matnr.
***        <fs_matnr>-high = |{ lv_matnr ALPHA = IN }|.
***      ENDIF.
***    ENDLOOP.
***
**** Busca estoque do Material
***    SELECT matnr, werks, lgort, labst
***      FROM mard
***      INTO TABLE @DATA(lt_mard)
***      WHERE matnr  IN @r_matnr
***        AND werks  IN @rt_werks
***        AND lgort  IN @rt_lgort
***        AND lvorm  EQ @space
***
***        " Filtros do Perfil do usuário
***        AND werks  IN @r_werks
***        AND lgort  IN @r_lgort.
***
***    IF lt_mard[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
***    IF rt_lgort[] IS NOT INITIAL OR rt_usuario_app[] IS NOT INITIAL.
***
**** Busca descrição do Depósito
***      SELECT werks, lgort, lgobe
***        FROM t001l
***        INTO TABLE @DATA(lt_t001l)
***        FOR ALL ENTRIES IN @lt_mard
***        WHERE werks = @lt_mard-werks
***          AND lgort = @lt_mard-lgort.
***
**** Busca unidade do material
***      SELECT matnr, meins
***        FROM mara
***        INTO TABLE @DATA(lt_mara)
***        FOR ALL ENTRIES IN @lt_mard
***        WHERE matnr = @lt_mard-matnr.
***
***      LOOP AT lt_mard INTO DATA(ls_mard).
***        IF rt_usuario_app[] IS NOT INITIAL.
**** 14/03/2023 - Enviar materiais sem saldo para envio do depósito
****          IF ls_mard-labst = 0.
****            CONTINUE.
****          ENDIF.
**** 14/03/2023 - Enviar materiais sem saldo para envio do depósito
***        ENDIF.
***        CLEAR ls_saldo.
***        ls_saldo-matnr = ls_mard-matnr.
***        ls_saldo-werks = ls_mard-werks.
***        ls_saldo-lgort = ls_mard-lgort.
***        ls_saldo-labst = ls_mard-labst.
***        READ TABLE lt_t001l INTO DATA(ls_t001l) WITH KEY werks = ls_mard-werks lgort = ls_mard-lgort.
***        IF sy-subrc EQ 0.
***          ls_saldo-lgobe = ls_t001l-lgobe.
***        ENDIF.
***        READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_mard-matnr.
***        IF sy-subrc EQ 0.
***          ls_saldo-meins = ls_mara-meins.
***          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
***            EXPORTING
***              input    = ls_saldo-meins
***              language = sy-langu
***            IMPORTING
***              output   = ls_saldo-meins.
***        ENDIF.
***        COLLECT ls_saldo INTO et_saldo.
***      ENDLOOP.
***    ELSE.
***      LOOP AT lt_mard INTO ls_mard.
***        CLEAR ls_saldo.
***        ls_saldo-matnr = ls_mard-matnr.
***        ls_saldo-werks = ls_mard-werks.
***        ls_saldo-labst = ls_mard-labst.
***        READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_mard-matnr.
***        IF sy-subrc EQ 0.
***          ls_saldo-meins = ls_mara-meins.
***          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
***            EXPORTING
***              input    = ls_saldo-meins
***              language = sy-langu
***            IMPORTING
***              output   = ls_saldo-meins.
***        ENDIF.
***        COLLECT ls_saldo INTO et_saldo.
***      ENDLOOP.
***    ENDIF.
***
  ENDMETHOD.


  METHOD OUT_FILTRO.

*** Declaração de estrutura
**    DATA: ls_filtro        LIKE LINE OF it_filtro,
**          ls_filtro_values TYPE /ptloms/et116.
**
**    CLEAR ls_filtro_values.
**    READ TABLE it_filtro ASSIGNING FIELD-SYMBOL(<fs_filtro>) WITH KEY key = im_field.
**    IF sy-subrc EQ 0.
**      READ TABLE <fs_filtro>-values INTO DATA(ls_filtro_values_aux) WITH KEY key = im_value.
**      IF sy-subrc NE 0.
**        ls_filtro_values-key = im_value.
**        APPEND ls_filtro_values TO <fs_filtro>-values.
**      ENDIF.
**    ELSE.
**      CLEAR ls_filtro.
**      ls_filtro-key = im_field.
**      SELECT SINGLE scrtext_s FROM dd04t INTO ls_filtro-label WHERE rollname = im_data_element AND ddlanguage = sy-langu AND as4local = 'A'.
**      IF sy-subrc NE 0.
**        ls_filtro-label = im_data_element.
**      ENDIF.
**      ls_filtro_values-key = im_value.
**      APPEND ls_filtro_values TO ls_filtro-values.
**      APPEND ls_filtro TO it_filtro.
**    ENDIF.

  ENDMETHOD.


  METHOD OUT_GRUPO_CODE.
***
**** Verifica se parâmetro de entrada está preenchido
***    IF rt_codegruppe[] IS INITIAL AND
***       rt_katalogart[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Seleciona Grupo Code
***    SELECT a~katalogart, a~codegruppe, a~code, b~kurztext
***      FROM qpcd AS a INNER JOIN qpct AS b ON a~katalogart = b~katalogart
***                                         AND a~codegruppe = b~codegruppe
***                                         AND a~code       = b~code
***                                         AND a~version    = b~version
***      INTO CORRESPONDING FIELDS OF TABLE @rt_grupo_code
***      WHERE b~sprache = @sy-langu
***        AND a~codegruppe IN @rt_codegruppe
***        AND a~katalogart IN @rt_katalogart.
  ENDMETHOD.


 METHOD OUT_HORAS_PLAN_REAL.
***
**** Declaração de range
***    DATA: r_matricula  TYPE RANGE OF co_pernr,
***          ls_matricula LIKE LINE OF r_matricula.
***
**** Declaração de Tabela interma
***    DATA: lt_status TYPE STANDARD TABLE OF jstat.
***
**** Declaração de estrutura
***    DATA: ls_horas_plan_rel LIKE LINE OF et_horas_plan_rel.
***
**** Declaração de variáveis
***    DATA: lv_usuario          TYPE /ptloms/tb013-usuario,
***          lv_objnr            TYPE j_objnr,
***          lv_duration         TYPE f,
***          lv_un_work(16)      TYPE p DECIMALS 5,
***          lv_start_date        TYPE sy-datum,
***          lv_start_time        TYPE sy-uzeit,
***          lv_end_date         TYPE sy-datum,
***          lv_end_time          TYPE sy-uzeit,
***          lv_unit_of_duration  TYPE t006-msehi,
***          lv_start_date_h     TYPE sy-datum,
***          lv_start_time_h     TYPE sy-uzeit,
***          lv_end_date_h       TYPE sy-datum,
***          lv_end_time_h       TYPE sy-uzeit.
***
**** Verifica se foi preenchido usuário
***    IF rt_usuario_app[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca matrícula do Usuário APP
***    SELECT usuario, matricula, dia_inicio, dias_retroativos, dias_progressivos
***      FROM /ptloms/tb013
***      INTO TABLE @DATA(lt_tb013)
***      WHERE usuario IN @rt_usuario_app.
***
***    DELETE lt_tb013 WHERE matricula IS INITIAL.
***
**** Se não encontrar nenhuma matrícula, então retorna
***    IF lt_tb013[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Monta Range de Matrícula
***    LOOP AT lt_tb013 INTO DATA(ls_013).
***      CLEAR ls_matricula.
***      ls_matricula-sign = 'I'.
***      ls_matricula-option = 'EQ'.
***      ls_matricula-low = ls_013-matricula.
***      APPEND ls_matricula TO r_matricula.
***    ENDLOOP.
***
**** Caso não tenha prreenchido o filtro de data e só tenha um usuário no filtro, carrega o filtro configurado de data
***    IF rt_data[] IS INITIAL.
***      DESCRIBE TABLE rt_usuario_app LINES DATA(lv_qtd_usu).
***      IF lv_qtd_usu = 1.
***        READ TABLE rt_usuario_app INTO DATA(ls_usuario_app) INDEX 1.
***        IF ls_usuario_app-sign = 'I' AND ls_usuario_app-option = 'EQ'.
***          lv_usuario = ls_usuario_app-low.
***          DATA(rt_data_conf_usuario) = me->out_monta_range_data_usuario( lv_usuario ).
***        ENDIF.
***      ENDIF.
***    ENDIF.
***
**** Busca horas planejadas/realizadas
***    IF rt_data[] IS NOT INITIAL AND rt_data_conf_usuario[] IS INITIAL.
***      SELECT a~aufpl, a~aplzl, a~objnr, a~pernr, b~arbei, b~ismnw, b~fsavd
***        FROM afvc AS a INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INTO TABLE @DATA(lt_plan_rel)
***        WHERE a~pernr IN @r_matricula
****          AND a~phflg EQ @space
***          AND ( b~fsavd IN @rt_data OR b~fsedd IN @rt_data ).
***
**** Confirmações estornadas
***      SELECT a~aufpl, a~aplzl, a~objnr, a~pernr, b~arbei, c~ismnw, b~fsavd, c~rueck, c~rmzhl, c~isdd, c~isdz, c~iedd, c~iedz, c~stzhl
***        FROM afvc AS a INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INNER JOIN afru AS c ON  a~aufpl = c~aufpl AND a~aplzl = c~aplzl
***        INTO TABLE @DATA(lt_plan_rel_afru_estornado)
***        WHERE a~pernr IN @r_matricula
****          AND a~phflg EQ @space
***          AND ( b~fsavd IN @rt_data_conf_usuario OR b~fsedd IN @rt_data_conf_usuario )
***          AND ( c~isdd  IN @rt_data_conf_usuario OR c~iedd  IN @rt_data_conf_usuario )
***          AND c~stokz NE @space.
***
**** Confirmações válidas
***      SELECT a~aufpl, a~aplzl, a~objnr, a~pernr, b~arbei, c~ismnw, b~fsavd, c~rueck, c~rmzhl, c~isdd, c~isdz, c~iedd, c~iedz, c~stzhl
***        FROM afvc AS a INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INNER JOIN afru AS c ON  a~aufpl = c~aufpl AND a~aplzl = c~aplzl
***        INTO TABLE @DATA(lt_plan_rel_afru)
***        WHERE a~pernr IN @r_matricula
****          AND a~phflg EQ @space
***          AND ( b~fsavd IN @rt_data OR b~fsedd IN @rt_data )
***          AND ( c~isdd  IN @rt_data OR c~iedd  IN @rt_data_conf_usuario )
***          AND c~stokz EQ @space.
***    ELSE.
***      SELECT a~aufpl, a~aplzl, a~objnr, a~pernr, b~arbei, b~ismnw, b~fsavd
***        FROM afvc AS a INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INTO TABLE @lt_plan_rel
***        WHERE a~pernr IN @r_matricula
****          AND a~phflg EQ @space
***          AND ( b~fsavd IN @rt_data_conf_usuario OR b~fsedd IN @rt_data_conf_usuario ).
***
**** Confirmações estornadas
***      SELECT a~aufpl, a~aplzl, a~objnr, a~pernr, b~arbei, c~ismnw, b~fsavd, c~rueck, c~rmzhl, c~isdd, c~isdz, c~iedd, c~iedz, c~stzhl
***        FROM afvc AS a INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INNER JOIN afru AS c ON  a~aufpl = c~aufpl AND a~aplzl = c~aplzl
***        INTO TABLE @lt_plan_rel_afru_estornado
***        WHERE a~pernr IN @r_matricula
****          AND a~phflg EQ @space
***          AND ( b~fsavd IN @rt_data_conf_usuario OR b~fsedd IN @rt_data_conf_usuario )
***          AND ( c~isdd  IN @rt_data_conf_usuario OR c~iedd  IN @rt_data_conf_usuario )
***          AND c~stokz NE @space.
***
**** Confirmações válidas
***      SELECT a~aufpl, a~aplzl, a~objnr, a~pernr, b~arbei, c~ismnw, b~fsavd, c~rueck, c~rmzhl, c~isdd, c~isdz, c~iedd, c~iedz, c~stzhl
***        FROM afvc AS a INNER JOIN afvv AS b ON a~aufpl = b~aufpl AND a~aplzl = b~aplzl
***        INNER JOIN afru AS c ON  a~aufpl = c~aufpl AND a~aplzl = c~aplzl
***        INTO TABLE @lt_plan_rel_afru
***        WHERE a~pernr IN @r_matricula
****          AND a~phflg EQ @space
***          AND ( b~fsavd IN @rt_data_conf_usuario OR b~fsedd IN @rt_data_conf_usuario )
***          AND ( c~isdd  IN @rt_data_conf_usuario OR c~iedd  IN @rt_data_conf_usuario )
***          AND c~stokz EQ @space.
***    ENDIF.
***
***** Aplica filtro (Parâmetros de Seleção) - Início
****    IF im_filter_aufpl IS NOT INITIAL AND im_filter_aplzl IS NOT INITIAL.
****      DELETE lt_plan_rel WHERE aufpl NE im_filter_aufpl OR aplzl NE im_filter_aplzl.
****    ELSEIF im_filter_aufpl IS NOT INITIAL AND im_filter_aplzl IS INITIAL.
****      DELETE lt_plan_rel WHERE aufpl NE im_filter_aufpl.
****    ENDIF.
***** Aplica filtro (Parâmetros de Seleção) - Fim
***
***    READ TABLE rt_data_conf_usuario INTO DATA(ls_data_conf_usuario) INDEX 1.
***    IF sy-subrc EQ 0.
***      MOVE: ls_data_conf_usuario-low  TO lv_start_date_h,
***            000001                    TO lv_start_time_h,
***            ls_data_conf_usuario-high TO lv_end_date_h,
***            '235959'                  TO lv_end_time_h.
***    ENDIF.
***
***    SELECT SINGLE confirmacao FROM /ptloms/tb033 INTO @DATA(lv_confirmacao).
***    IF sy-subrc EQ 0.
***      IF lv_confirmacao = 'H'.
***        lv_unit_of_duration = 'H'.
***      ELSEIF lv_confirmacao = 'MIN'.
***        lv_unit_of_duration = 'MIN'.
***      ENDIF.
***    ENDIF.
***
**** Elimina as confirmações estornadas
***    LOOP AT lt_plan_rel_afru_estornado INTO DATA(ls_plan_rel_afru_estornado).
***      DELETE lt_plan_rel_afru WHERE rueck = ls_plan_rel_afru_estornado-rueck
***                                AND stzhl = ls_plan_rel_afru_estornado-rmzhl.
***    ENDLOOP.
***
**** Refinamento das horas realizadas - Considerar os apontamentos dentro do horizonte do usuário
***    LOOP AT lt_plan_rel ASSIGNING FIELD-SYMBOL(<fs_lt_plan_rel>).
***      CLEAR <fs_lt_plan_rel>-ismnw.
***      LOOP AT lt_plan_rel_afru INTO DATA(ls_plan_rel_afru) WHERE aufpl = <fs_lt_plan_rel>-aufpl
***                                                             AND aplzl = <fs_lt_plan_rel>-aplzl.
***
***        CLEAR: lv_start_date, lv_start_time, lv_end_date, lv_end_time,
***               lv_duration, lv_un_work.
***
***        IF ls_plan_rel_afru-isdd IN rt_data_conf_usuario AND ls_plan_rel_afru-iedd IN rt_data_conf_usuario.
***          lv_start_date = ls_plan_rel_afru-isdd.
***          lv_start_time = ls_plan_rel_afru-isdz.
***          lv_end_date = ls_plan_rel_afru-iedd.
***          lv_end_time = ls_plan_rel_afru-iedz.
***        ELSEIF ls_plan_rel_afru-isdd IN rt_data_conf_usuario AND ls_plan_rel_afru-iedd NOT IN rt_data_conf_usuario.
***          lv_start_date = ls_plan_rel_afru-isdd.
***          lv_start_time = ls_plan_rel_afru-isdz.
***          lv_end_date = lv_end_date_h.
***          lv_end_time = lv_end_time_h.
***        ELSEIF ls_plan_rel_afru-isdd NOT IN rt_data_conf_usuario AND ls_plan_rel_afru-iedd IN rt_data_conf_usuario.
***          lv_start_date = lv_start_date_h.
***          lv_start_time = lv_start_time_h.
***          lv_end_date = ls_plan_rel_afru-iedd.
***          lv_end_time = ls_plan_rel_afru-iedz.
***        ELSE.
***          CONTINUE.
***        ENDIF.
***
***        CALL FUNCTION 'COPF_DETERMINE_DURATION'
***          EXPORTING
***            i_start_date       = lv_start_date
***            i_start_time       = lv_start_time
***            i_end_date         = lv_end_date
***            i_end_time         = lv_end_time
***            i_unit_of_duration = lv_unit_of_duration
***          IMPORTING
***            e_duration         = lv_duration
***          EXCEPTIONS
***            exception_raised   = 1
***            OTHERS             = 2.
***
***        IF sy-subrc EQ 0.
***          lv_un_work = lv_duration.
***        ENDIF.
***
****        <fs_lt_plan_rel>-ismnw = <fs_lt_plan_rel>-ismnw + ls_plan_rel_afru-ismnw.
***        <fs_lt_plan_rel>-ismnw = <fs_lt_plan_rel>-ismnw + lv_un_work.
***      ENDLOOP.
***    ENDLOOP.
***
**** Se não encontrar Horas Planejada/Realizada, então retorna
***    IF lt_plan_rel[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
***** Busca Ordens
****    SELECT a~aufnr, a~aufpl, b~objnr
****      FROM afko AS a INNER JOIN aufk AS b ON a~aufnr = b~aufnr
****      INTO TABLE @DATA(lt_afko)
****      FOR ALL ENTRIES IN @lt_plan_rel
****      WHERE aufpl = @lt_plan_rel-aufpl.
***
**** Monta tabela de saída
***    LOOP AT lt_plan_rel INTO DATA(ls_plan_rel).
***      CLEAR ls_horas_plan_rel.
***      MOVE-CORRESPONDING ls_plan_rel TO ls_horas_plan_rel.
****      ls_horas_plan_rel-dif_plan_real = ls_horas_plan_rel-arbei - ls_horas_plan_rel-ismnw.
***      ls_horas_plan_rel-data_inicio = ls_data_conf_usuario-low.
***      ls_horas_plan_rel-data_fim    = ls_data_conf_usuario-high.
***      ls_horas_plan_rel-data_inicio_conv = ls_horas_plan_rel-data_inicio+6(2) && |/| &&
***                                           ls_horas_plan_rel-data_inicio+4(2) && |/| &&
***                                           ls_horas_plan_rel-data_inicio+2(2).
***      ls_horas_plan_rel-data_fim_conv    = ls_horas_plan_rel-data_fim+6(2) && |/| &&
***                                           ls_horas_plan_rel-data_fim+4(2) && |/| &&
***                                           ls_horas_plan_rel-data_fim+2(2).
***      READ TABLE lt_tb013 INTO ls_013 WITH KEY matricula = ls_plan_rel-pernr.
***      IF sy-subrc EQ 0.
***        ls_horas_plan_rel-usuario = ls_013-usuario.
***      ENDIF.
***
**** Atualiza horas pendentes
****      READ TABLE lt_afko INTO DATA(ls_afko) WITH KEY aufpl = ls_plan_rel-aufpl.
****      IF sy-subrc EQ 0.
**** Busca status
***      REFRESH lt_status[].
***      CLEAR lv_objnr.
****        lv_objnr = ls_afko-objnr.
***      lv_objnr = ls_plan_rel-objnr.
***      CALL FUNCTION 'STATUS_READ'
***        EXPORTING
***          client           = sy-mandt
***          objnr            = lv_objnr
***          only_active      = 'X'
***        TABLES
***          status           = lt_status
***        EXCEPTIONS
***          object_not_found = 1
***          OTHERS           = 2.
***
**** Verifica se a Ordem possui o status CONF I0009 (Confirmado)
***      READ TABLE lt_status WITH KEY stat = 'I0009' TRANSPORTING NO FIELDS.
***      IF sy-subrc EQ 0.
***        DATA(lv_conf) = 'X'.
***      ENDIF.
***
**** Verifica se a Ordem possui o status CNPA I0010 (Confirmado parcialmente)
***      READ TABLE lt_status WITH KEY stat = 'I0010' TRANSPORTING NO FIELDS.
***      IF sy-subrc EQ 0.
***        DATA(lv_cnpa) = 'X'.
***      ENDIF.
***
**** Verifica se a Ordem possui o status LIB I0002 (Liberado)
***      READ TABLE lt_status WITH KEY stat = 'I0002' TRANSPORTING NO FIELDS.
***      IF sy-subrc EQ 0.
***        DATA(lv_lib) = 'X'.
***      ENDIF.
***
****        IF lv_conf = 'X'.
****          " Não faz nada
****        ELSEIF lv_lib = 'X' AND lv_cnpa IS INITIAL.
****          ls_horas_plan_rel-dif_plan_real = ls_horas_plan_rel-arbei.
****        ELSEIF lv_cnpa = 'X'.
****          IF ls_horas_plan_rel-ismnw > ls_horas_plan_rel-arbei.
****            ls_horas_plan_rel-dif_plan_real = 0.
****          ELSE.
****            ls_horas_plan_rel-dif_plan_real = ls_horas_plan_rel-arbei - ls_horas_plan_rel-ismnw.
****          ENDIF.
****        ENDIF.
***
**** Realizado - Se operação não tem CONF ou CNPA, então Realizado não é contabilizado
***      IF lv_conf NE 'X' AND lv_cnpa NE 'X'.
***        CLEAR ls_horas_plan_rel-ismnw.
***      ENDIF.
***
**** Pendente
***      IF lv_conf NE 'X'.
***        ls_horas_plan_rel-dif_plan_real = ls_horas_plan_rel-arbei - ls_horas_plan_rel-ismnw.
***        IF ls_horas_plan_rel-dif_plan_real < 0.
***          CLEAR ls_horas_plan_rel-dif_plan_real.
***        ENDIF.
***      ENDIF.
***
***      CLEAR: lv_conf, lv_cnpa, lv_lib.
***
****      ENDIF.
***      COLLECT ls_horas_plan_rel INTO et_horas_plan_rel.
***    ENDLOOP.
***
***
  ENDMETHOD.


  METHOD OUT_IDIOMA_USUARIO.

*** Declarações para a BAPI
**    DATA: lv_username     TYPE bapibname-bapibname,
**          ls_logondata    TYPE bapilogond,
**          ls_defaults     TYPE bapidefaul,
**          ls_address      TYPE bapiaddr3,
**          ls_company      TYPE bapiuscomp,
**          ls_snc          TYPE bapisncu,
**          ls_ref_user     TYPE bapirefus,
**          ls_alias        TYPE bapialias,
**          ls_uclass       TYPE bapiuclass,
**          ls_lastmodified TYPE bapimoddat,
**          ls_islocked     TYPE bapislockd,
**          lt_return       TYPE STANDARD TABLE OF bapiret2,
**          lt_addtel       TYPE STANDARD TABLE OF bapiadtel.
**
*** Busca idioma do usuário
**    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
**      EXPORTING
**        username     = im_usuario
**      IMPORTING
**        ref_user     = ls_ref_user
**        alias        = ls_alias
**        snc          = ls_snc
**        company      = ls_company
**        address      = ls_address
**        defaults     = ls_defaults
**        logondata    = ls_logondata
**        uclass       = ls_uclass
**        lastmodified = ls_lastmodified
**        islocked     = ls_islocked
**      TABLES
**        return       = lt_return
**        addtel       = lt_addtel
**      EXCEPTIONS
**        OTHERS       = 01.
**
**    IF ls_address-langu_p IS NOT INITIAL.
**      rm_idioma = ls_address-langu_p.
**    ENDIF.

  ENDMETHOD.


  METHOD OUT_IMAGEM.
***
**** Declaração de estrutura
***    DATA: "ls_imagem        LIKE LINE OF et_imagem,
***      ls_anexo         LIKE LINE OF rt_anexos,
***      ls_contetudo_hex TYPE /ptloms/et042.
***
**** Declarações para BAPI
***    DATA: lv_document_id   TYPE sofolenti1-doc_id,
***          ls_document_data TYPE sofolenti1,
***          lt_contents_hex  TYPE STANDARD TABLE OF solix.
***
**** Declaração de variáveis
***    DATA: lv_string         TYPE string,
***          lv_filename       TYPE skwf_filnm,
***          lv_minetype       TYPE skwf_mime,
***          lv_file_extension TYPE char4,
***          lv_len            TYPE i.
***
**** Verifica se critério de seleção foi preenchido
***    IF rt_instid_a[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca imagens
***    SELECT brelguid, instid_a, typeid_a, instid_b
***      FROM srgbtbrel
***      INTO TABLE @DATA(lt_srgbtbrel)
***      WHERE reltype = 'ATTA'
***        AND instid_a IN @rt_instid_a
***        AND typeid_a IN @rt_typeid_a.
***
**** Verifica se imagem foi encontrada
***    IF lt_srgbtbrel[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Monta tabela de saída
***    LOOP AT lt_srgbtbrel INTO DATA(ls_srgbtbrel).
***
****      CLEAR ls_imagem.
***      CLEAR ls_anexo.
***
****      MOVE-CORRESPONDING ls_srgbtbrel TO ls_imagem.
***
***      CLEAR: lv_document_id, ls_document_data.
***      REFRESH: lt_contents_hex[].
***
***      MOVE ls_srgbtbrel-instid_b TO lv_document_id.
***
***      CALL FUNCTION 'SO_DOCUMENT_READ_API1'
***        EXPORTING
***          document_id                = lv_document_id
***        IMPORTING
***          document_data              = ls_document_data
***        TABLES
***          contents_hex               = lt_contents_hex
***        EXCEPTIONS
***          document_id_not_exist      = 1
***          operation_no_authorization = 2
***          x_error                    = 3
***          OTHERS                     = 4.
***
***      IF lt_contents_hex[] IS NOT INITIAL.
****        MOVE-CORRESPONDING ls_document_data TO ls_imagem.
****        LOOP AT lt_contents_hex INTO DATA(ls_contents_hex).
****          MOVE ls_contents_hex-line TO ls_contetudo_hex-line.
****          APPEND ls_contetudo_hex TO ls_imagem-contents_hex.
****        ENDLOOP.
***
***        IF ls_document_data-obj_type = 'JPE' AND ls_document_data-obj_type = 'JPG' AND ls_document_data-obj_type = 'PDF' AND ls_document_data-obj_type = 'PNG' AND
***           ls_document_data-obj_type = 'jpe' AND ls_document_data-obj_type = 'jpg' AND ls_document_data-obj_type = 'pdf' AND ls_document_data-obj_type = 'png'.
***          CONTINUE.
***        ENDIF.
***
***        ls_anexo-file_name  = ls_document_data-obj_descr.
***        ls_anexo-media_type = ls_document_data-obj_type.
***
***        CLEAR lv_string.
***
***        LOOP AT lt_contents_hex INTO DATA(ls_hex).
***          lv_string = lv_string && ls_hex-line.
***        ENDLOOP.
***
***        ls_anexo-arquivo      = lv_string.
***        ls_anexo-server       = 'X'.
***        ls_anexo-instid_a     = ls_srgbtbrel-instid_a.
***        ls_anexo-upload_state = 'Complete'.
***        ls_anexo-size         = ls_document_data-doc_size.
***
***        CLEAR: lv_filename, lv_minetype, lv_file_extension.
***
***        IF ls_document_data-obj_type EQ 'XLS' OR
***           ls_document_data-obj_type EQ 'DOC' OR
***           ls_document_data-obj_type EQ 'PPT'.
***
***          CALL FUNCTION '/PTLOMS/MF057'
***            EXPORTING
***              i_line     = lt_contents_hex[ 1 ]-line
***              i_filetype = ls_document_data-obj_type
***            IMPORTING
***              e_extensao = lv_file_extension.
***
***          IF lv_file_extension IS NOT INITIAL.
***            TRANSLATE lv_file_extension TO LOWER CASE.
***          ELSE.
***            lv_file_extension = ls_document_data-obj_type.
***            TRANSLATE lv_file_extension TO LOWER CASE.
***          ENDIF.
***        ELSE.
***          IF ls_document_data-obj_type = 'JPE'.
***            lv_file_extension = 'JPEG'.
***          ELSE.
***            lv_file_extension = ls_document_data-obj_type.
***          ENDIF.
***          TRANSLATE lv_file_extension TO LOWER CASE.
***        ENDIF.
***
***        CASE lv_file_extension.
***          WHEN 'jpg'.
***            DATA(lv_ext_false) = 'X'.
***          WHEN 'xls'.
***            lv_ext_false = 'X'.
***            lv_len = strlen( ls_document_data-obj_descr ).
***            lv_len = lv_len - 4.
***            IF lv_len > 0.
***              IF ls_document_data-obj_descr+lv_len EQ '.XLS' OR
***                 ls_document_data-obj_descr+lv_len EQ '.xls'.
***                ls_document_data-obj_descr = ls_document_data-obj_descr(lv_len).
***              ENDIF.
***            ENDIF.
***
***          WHEN 'xlsx'.
***            lv_ext_false = 'X'.
***            lv_len = strlen( ls_document_data-obj_descr ).
***            lv_len = lv_len - 5.
***            IF lv_len > 0.
***              IF ls_document_data-obj_descr+lv_len EQ '.XLSX' OR
***                 ls_document_data-obj_descr+lv_len EQ '.xlsx'.
***                ls_document_data-obj_descr = ls_document_data-obj_descr(lv_len).
***              ENDIF.
***            ENDIF.
***
***          WHEN 'doc'.
***            lv_ext_false = 'X'.
***            lv_len = strlen( ls_document_data-obj_descr ).
***            lv_len = lv_len - 4.
***            IF lv_len > 0.
***              IF ls_document_data-obj_descr+lv_len EQ '.DOC' OR
***                 ls_document_data-obj_descr+lv_len EQ '.doc'.
***                ls_document_data-obj_descr = ls_document_data-obj_descr(lv_len).
***              ENDIF.
***            ENDIF.
***
***          WHEN 'docx'.
***            lv_ext_false = 'X'.
***            lv_len = strlen( ls_document_data-obj_descr ).
***            lv_len = lv_len - 5.
***            IF lv_len > 0.
***              IF ls_document_data-obj_descr+lv_len EQ '.DOCX' OR
***                 ls_document_data-obj_descr+lv_len EQ '.docx'.
***                ls_document_data-obj_descr = ls_document_data-obj_descr(lv_len).
***              ENDIF.
***            ENDIF.
***
***          WHEN 'ppt'.
***            lv_ext_false = 'X'.
***            lv_len = strlen( ls_document_data-obj_descr ).
***            lv_len = lv_len - 4.
***            IF lv_len > 0.
***              IF ls_document_data-obj_descr+lv_len EQ '.PPT' OR
***                 ls_document_data-obj_descr+lv_len EQ '.ppt'.
***                ls_document_data-obj_descr = ls_document_data-obj_descr(lv_len).
***              ENDIF.
***            ENDIF.
***
***          WHEN 'pptx'.
***            lv_ext_false = 'X'.
***            lv_len = strlen( ls_document_data-obj_descr ).
***            lv_len = lv_len - 5.
***            IF lv_len > 0.
***              IF ls_document_data-obj_descr+lv_len EQ '.PPTX' OR
***                 ls_document_data-obj_descr+lv_len EQ '.pptx'.
***                ls_document_data-obj_descr = ls_document_data-obj_descr(lv_len).
***              ENDIF.
***            ENDIF.
***
***          WHEN 'pdf'.
***            lv_ext_false = 'X'.
***            lv_len = strlen( ls_document_data-obj_descr ).
***            lv_len = lv_len - 4.
***            IF lv_len > 0.
***
***              IF ls_document_data-obj_descr+lv_len EQ '.PDF' OR
***                 ls_document_data-obj_descr+lv_len EQ '.pdf'.
***                ls_document_data-obj_descr = ls_document_data-obj_descr(lv_len).
***              ENDIF.
***            ENDIF.
***        ENDCASE.
***
***        IF lv_ext_false = 'X'.
***          lv_filename = ls_document_data-obj_descr && |.| && lv_file_extension.
***        ELSE.
***          lv_filename = ls_document_data-obj_descr.
***        ENDIF.
***        CLEAR lv_ext_false.
***
**** Recupera o minetype do anexo
***        CALL FUNCTION 'SKWF_MIMETYPE_OF_FILE_GET'
***          EXPORTING
***            filename = lv_filename
****           X_USE_LOCAL_REGISTRY       =
***          IMPORTING
***            mimetype = lv_minetype.
***
***        ls_anexo-media_type_fiori = lv_minetype.
***
***        CASE lv_file_extension.
***          WHEN 'XLSX'.
***            lv_minetype = 'application/vnd.ms-excel'.
***          WHEN 'xlsx'.
***            lv_minetype = 'application/vnd.ms-excel'.
***          WHEN 'DOCX'.
***            lv_minetype = 'application/msword'.
***          WHEN 'docx'.
***            lv_minetype = 'application/msword'.
***          WHEN 'PPTX'.
***            lv_minetype = 'application/vnd.ms-powerpoint'.
***          WHEN 'pptx'.
***            lv_minetype = 'application/vnd.ms-powerpoint'.
***        ENDCASE.
***
***        ls_anexo-media_type = lv_minetype.
***        ls_anexo-file_name = lv_filename.
***
***      ELSE.
***        CONTINUE.
***      ENDIF.
***
***      APPEND ls_anexo TO rt_anexos.
****      APPEND ls_imagem TO et_imagem.
***
***    ENDLOOP.
***
  ENDMETHOD.


  METHOD OUT_INFOLOG.

*** Declaração de Tabelas Interna
**    DATA: lt_header_data        TYPE STANDARD TABLE OF balhdr,
**          lt_header_parameters  TYPE STANDARD TABLE OF balhdrp,
**          lt_messages           TYPE STANDARD TABLE OF balm,
**          lt_message_parameters TYPE STANDARD TABLE OF balmp,
**          lt_contexts           TYPE STANDARD TABLE OF balc,
**          lt_exceptions         TYPE STANDARD TABLE OF bal_s_exception.
**
*** Declaração de Estrutura
***    DATA: ls_log LIKE LINE OF et_log.
**
*** Declaração de Variáveis
**    DATA: lv_object           TYPE balhdr-object,
**          lv_subobject        TYPE balhdr-subobject,
**          lv_external_number  TYPE balhdr-extnumber,
**          lv_date_from        TYPE balhdr-aldate,
**          lv_date_to          TYPE balhdr-aldate,
**          lv_time_from        TYPE balhdr-altime,
**          lv_time_to          TYPE balhdr-altime,
**          lv_user_id          TYPE balhdr-aluser,
**          lv_timestmp         TYPE rke_hzstmp,
**          lv_data             TYPE sy-datum,
**          lv_hora             TYPE sy-uzeit,
**          lv_horario_verao(1) TYPE c.
**
*** Leitura dos Parâmetros de seleção
***    READ TABLE rt_object          INTO DATA(ls_object)          INDEX 1.
***    READ TABLE rt_subobject       INTO DATA(ls_subobject)       INDEX 1.
***    READ TABLE rt_external_number INTO DATA(ls_external_number) INDEX 1.
**    READ TABLE rt_date_from       INTO DATA(ls_date_from)       INDEX 1.
**    READ TABLE rt_date_to         INTO DATA(ls_date_to)         INDEX 1.
**    READ TABLE rt_time_from       INTO DATA(ls_time_from)       INDEX 1.
**    READ TABLE rt_time_to         INTO DATA(ls_time_to)         INDEX 1.
**    READ TABLE rt_user_id         INTO DATA(ls_user_id)         INDEX 1.
**
*** Verifica se Data e Usuário estão preenchidos
**    IF ls_date_from-low IS INITIAL AND ls_date_to-low IS INITIAL AND ls_user_id-low IS INITIAL.
**      RETURN.
**    ENDIF.
**
*** Atribuição de Parâmetros
**    lv_object          = '/PTLOMS/OMS'."
***    lv_subobject       = ls_subobject-low.
***    lv_external_number = ls_external_number-low.
**    lv_date_from       = ls_date_from-low.
**    lv_date_to         = ls_date_to-low.
**    lv_time_from       = ls_time_from-low.
**    lv_time_to         = ls_time_to-low.
**    lv_user_id         = ls_user_id-low.
**
**    CALL FUNCTION 'APPL_LOG_READ_DB'
**      EXPORTING
**        object      = lv_object
***       subobject   = lv_subobject
***       external_number    = lv_external_number
**        date_from   = lv_date_from
**        date_to     = lv_date_to
**        time_from   = lv_time_from
**        time_to     = lv_time_to
**        user_id     = lv_user_id
**      TABLES
**        header_data = lt_header_data
**        messages    = lt_messages.
**
**
  ENDMETHOD.


  METHOD OUT_LAYOUT.

** Declaração de estrutura
*    DATA: ls_layout LIKE LINE OF it_layout.
*
** Busca dados de Layout
*    SELECT *
*      FROM /ptloms/tb046
*      INTO TABLE @DATA(lt_tb046)
*      WHERE tabela  IN @rt_tabela
*        AND usuario IN @rt_usario
*        AND padrao  IN @rt_padrao.
*
** Monta dados de saída
*    LOOP AT lt_tb046 INTO DATA(ls_tb046).
*      CLEAR ls_layout.
*      MOVE-CORRESPONDING ls_tb046 TO ls_layout.
*      APPEND ls_layout TO it_layout.
*    ENDLOOP.

  ENDMETHOD.


  METHOD OUT_LAYOUT_VALUES.

*** Declaração de estrutura
**    DATA: ls_layout_values LIKE LINE OF it_layout_values.
**
*** Busca dados de Layout
**    SELECT *
**      FROM /ptloms/tb047
**      INTO TABLE @DATA(lt_tb047)
**      WHERE id_layout IN @rt_id_layout.
**
*** Monta dados de saída
**    LOOP AT lt_tb047 INTO DATA(ls_tb047).
**      CLEAR ls_layout_values.
**      MOVE-CORRESPONDING ls_tb047 TO ls_layout_values.
**      APPEND ls_layout_values TO it_layout_values.
**    ENDLOOP.

  ENDMETHOD.


  METHOD OUT_LISTA_TECNICA.
***
**** Declaração de range
***    DATA: r_equnr TYPE /iwbep/t_cod_select_options,
***          r_matnr TYPE /iwbep/t_cod_select_options.
***
**** Declaração de estruturas
***    DATA: ls_lista_tecnica_equi     LIKE LINE OF et_lista_tecnica_equi,
***          ls_lista_tecnica_loc_inst LIKE LINE OF et_lista_tecnica_loc_inst,
***          ls_lista_tecnica_mat      LIKE LINE OF et_lista_tecnica_mat.
***
**** Declaraçãode variável
***    DATA: lv_equnr TYPE equnr,
***          lv_matnr TYPE matnr.
***
**** Verifica se critério de seleção foi preenchido.
***    IF ( rt_equnr[] IS INITIAL AND
***         rt_tplnr[] IS INITIAL AND
***         rt_matnr[] IS INITIAL ) OR
***       ( rt_equnr[] IS INITIAL AND
***         rt_tplnr[] IS INITIAL AND
***         rt_werks[] IS INITIAL ).
***      RETURN.
***    ENDIF.
***
***    IF rt_equnr IS NOT INITIAL.
***
***      r_equnr[] = rt_equnr[].
***
**** Converte o campo EQUNR
***      LOOP AT r_equnr ASSIGNING FIELD-SYMBOL(<fs_equnr>).
***        IF <fs_equnr>-low IS NOT INITIAL.
***          MOVE <fs_equnr>-low TO lv_equnr.
***          <fs_equnr>-low = |{ lv_equnr ALPHA = IN }|.
***        ENDIF.
***        IF <fs_equnr>-high IS NOT INITIAL.
***          MOVE <fs_equnr>-high TO lv_equnr.
***          <fs_equnr>-high = |{ lv_equnr ALPHA = IN }|.
***        ENDIF.
***      ENDLOOP.
***
**** Busca Lista Técnica do Equipamento / Item da Lista Técnica
****      SELECT a~equnr, a~werks, a~stlan, a~stlnr, a~stlal,
****             b~stlty, b~stlkn, b~stpoz, b~idnrk, b~postp,
****             b~posnr, b~meins, b~menge
****        FROM eqst AS a INNER JOIN stpo AS b ON a~stlnr = b~stlnr
****        INTO TABLE @DATA(lt_stpo_equi)
****        WHERE a~equnr IN @r_equnr
****          AND b~stlty = 'E'.
***
***      DATA lt_stpo_equi TYPE /ptloms/cl007=>ct_eqst.
***      /ptloms/cl007=>select_eqst( EXPORTING rt_table_in   = r_equnr
***                                   IMPORTING rt_table_out = lt_stpo_equi ).
***
***    ENDIF.
***
**** Busca Lista Técnica de Local de Instalação / Item da Lista Técnica
***    IF rt_tplnr[] IS NOT INITIAL.
****      SELECT a~tplnr, a~werks, a~stlan, a~stlnr, a~stlal,
****             b~stlty, b~stlkn, b~stpoz, b~idnrk, b~postp,
****             b~posnr, b~meins, b~menge
****        FROM tpst AS a INNER JOIN stpo AS b ON a~stlnr = b~stlnr
****        INTO TABLE @DATA(lt_stpo_loc_inst)
****        WHERE a~tplnr IN @rt_tplnr
****          AND b~stlty = 'T'.
***
***      DATA lt_stpo_loc_inst TYPE /ptloms/cl007=>ct_tpst.
***      /ptloms/cl007=>select_tpst( EXPORTING rt_table_in   = rt_tplnr
***                                   IMPORTING rt_table_out = lt_stpo_loc_inst ).
***
***    ENDIF.
***
**** Busca Lista Técnica de Material / Item da Lista Técnica
***    IF rt_matnr[] IS NOT INITIAL AND rt_werks[] IS NOT INITIAL.
***
***      r_matnr[] = rt_matnr[].
***
**** Converte o campo MATNR
***      LOOP AT r_matnr ASSIGNING FIELD-SYMBOL(<fs_matnr>).
***        IF <fs_matnr>-low IS NOT INITIAL.
***          MOVE <fs_matnr>-low TO lv_matnr.
***          <fs_matnr>-low = |{ lv_matnr ALPHA = IN }|.
***        ENDIF.
***        IF <fs_matnr>-high IS NOT INITIAL.
***          MOVE <fs_matnr>-high TO lv_matnr.
***          <fs_matnr>-high = |{ lv_matnr ALPHA = IN }|.
***        ENDIF.
***      ENDLOOP.
***
****      SELECT a~matnr, a~werks, a~stlan, a~stlnr, a~stlal,
****             b~stlty, b~stlkn, b~stpoz, b~idnrk, b~postp,
****             b~posnr, b~meins, b~menge
****        FROM mast AS a INNER JOIN stpo AS b ON a~stlnr = b~stlnr
****        INTO TABLE @DATA(lt_stpo_mat)
****        WHERE a~matnr IN @r_matnr
****          AND a~werks IN @rt_werks
****          AND a~stlan = '4'
****          AND b~stlty = 'M'.
***
***      DATA lt_stpo_mat TYPE /ptloms/cl007=>ct_mast.
***      /ptloms/cl007=>select_mast( EXPORTING rt_table_in   = r_matnr
***                                   IMPORTING rt_table_out = lt_stpo_mat ).
***      DELETE lt_stpo_mat WHERE werks NOT IN rt_werks.
***
**** Foi solicitado pelo consultor funcional Cristian Reis, inverter os campos MATNR e IDNRK
***      LOOP AT lt_stpo_mat ASSIGNING FIELD-SYMBOL(<fs_stpo_mat>).
***        DATA(lv_matnr_aux) = <fs_stpo_mat>-matnr.
***        DATA(lv_idnrk_aux) = <fs_stpo_mat>-idnrk.
***        <fs_stpo_mat>-matnr = lv_idnrk_aux.
***        <fs_stpo_mat>-idnrk = lv_matnr_aux.
***      ENDLOOP.
***
***    ENDIF.
***
**** Monta dados de saída Lista Técnica Equipamento
***    LOOP AT lt_stpo_equi INTO DATA(ls_stpo_equi).
***      CLEAR ls_lista_tecnica_equi.
***      MOVE-CORRESPONDING ls_stpo_equi TO ls_lista_tecnica_equi.
***
**** Converte Unidade de Medida
***      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
***        EXPORTING
***          input          = ls_lista_tecnica_equi-meins
***          language       = sy-langu
***        IMPORTING
***          output         = ls_lista_tecnica_equi-meins
***        EXCEPTIONS
***          unit_not_found = 1
***          OTHERS         = 2.
***
***      APPEND ls_lista_tecnica_equi TO et_lista_tecnica_equi.
***    ENDLOOP.
***    IF lt_stpo_equi[] IS NOT INITIAL.
***      SORT lt_stpo_equi BY equnr ASCENDING
***                           stlnr ASCENDING
***                           idnrk ASCENDING
***                           postp ASCENDING
***                           posnr ASCENDING
***                           meins ASCENDING
***                           menge ASCENDING.
***      DELETE ADJACENT DUPLICATES FROM lt_stpo_equi COMPARING equnr stlnr idnrk postp posnr meins menge.
***    ENDIF.
***
**** Monta dados de saída Lista Técnica Local de Instalação
***    LOOP AT lt_stpo_loc_inst INTO DATA(ls_stpo_loc_inst).
***      CLEAR ls_lista_tecnica_loc_inst.
***      MOVE-CORRESPONDING ls_stpo_loc_inst TO ls_lista_tecnica_loc_inst.
***
**** Converte Unidade de Medida
***      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
***        EXPORTING
***          input          = ls_lista_tecnica_loc_inst-meins
***          language       = sy-langu
***        IMPORTING
***          output         = ls_lista_tecnica_loc_inst-meins
***        EXCEPTIONS
***          unit_not_found = 1
***          OTHERS         = 2.
***
***      APPEND ls_lista_tecnica_loc_inst TO et_lista_tecnica_loc_inst.
***    ENDLOOP.
***    IF lt_stpo_loc_inst[] IS NOT INITIAL.
***      SORT lt_stpo_loc_inst BY tplnr ASCENDING
***                               stlnr ASCENDING
***                               idnrk ASCENDING
***                               postp ASCENDING
***                               posnr ASCENDING
***                               meins ASCENDING
***                               menge ASCENDING.
***      DELETE ADJACENT DUPLICATES FROM lt_stpo_loc_inst COMPARING tplnr stlnr idnrk postp posnr meins menge.
***    ENDIF.
***
**** Busca descrição dos materiais
***    IF lt_stpo_mat[] IS NOT INITIAL.
***      SELECT matnr, spras, maktx
***        FROM makt
***        INTO TABLE @DATA(lt_makt)
***        FOR ALL ENTRIES IN @lt_stpo_mat
***        WHERE matnr = @lt_stpo_mat-matnr
***          AND spras = @sy-langu.
***    ENDIF.
***
**** Monta dados de saída Lista Técnica Material
***    LOOP AT lt_stpo_mat INTO DATA(ls_stpo_mat).
***      CLEAR ls_lista_tecnica_mat.
***      MOVE-CORRESPONDING ls_stpo_mat TO ls_lista_tecnica_mat.
***
**** Converte Unidade de Medida
***      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
***        EXPORTING
***          input          = ls_lista_tecnica_mat-meins
***          language       = sy-langu
***        IMPORTING
***          output         = ls_lista_tecnica_mat-meins
***        EXCEPTIONS
***          unit_not_found = 1
***          OTHERS         = 2.
***
***      READ TABLE lt_makt INTO DATA(ls_makt) WITH KEY matnr = ls_stpo_mat-matnr.
***      IF sy-subrc EQ 0.
***        ls_lista_tecnica_mat-maktx = ls_makt-maktx.
***      ENDIF.
***      ls_lista_tecnica_mat-matnr = |{ ls_lista_tecnica_mat-matnr ALPHA = OUT }|.
***      ls_lista_tecnica_mat-idnrk = |{ ls_lista_tecnica_mat-idnrk ALPHA = OUT }|.
***      APPEND ls_lista_tecnica_mat TO et_lista_tecnica_mat.
***    ENDLOOP.
***    IF et_lista_tecnica_mat[] IS NOT INITIAL.
***      SORT et_lista_tecnica_mat BY matnr ASCENDING
***                                   werks ASCENDING
***                                   stlnr ASCENDING
***                                   idnrk ASCENDING
***                                   postp ASCENDING
***                                   posnr ASCENDING
***                                   meins ASCENDING
***                                   menge ASCENDING.
***      DELETE ADJACENT DUPLICATES FROM et_lista_tecnica_mat COMPARING matnr werks stlnr idnrk postp posnr meins menge.
***    ENDIF.
  ENDMETHOD.


  METHOD OUT_LOCAL_INSTALACAO.
***
****Declaração de range
***    DATA: r_instid_a TYPE /iwbep/t_cod_select_options,
***          r_typeid_a TYPE /iwbep/t_cod_select_options,
***          r_iwerk    TYPE RANGE OF iflo-iwerk, " Centro de Planejamento
***          r_ingrp    TYPE RANGE OF iflo-ingrp, " Grupo de Planejamento
***          r_beber    TYPE RANGE OF iflo-beber, " Área Operacional
***          r_lgwid    TYPE RANGE OF iflo-lgwid, " ID Centro de Trabalho
***          r_fltyp    TYPE RANGE OF iflo-fltyp, " Categoria Local de Instalação
***          r_eqart    TYPE RANGE OF iflo-eqart, " Tipo de Objeto Técnico
***          r_locl     TYPE RANGE OF iflo-tplnr, " Local de Instalação
***          rt_locl    TYPE /iwbep/t_cod_select_options.
***
**** Declaração de estrutura
***    DATA: ls_local_instalacao LIKE LINE OF et_local_instalacao,
***          ls_instid_a         LIKE LINE OF r_instid_a,
***          ls_typeid_a         LIKE LINE OF r_typeid_a,
***          ls_iwerk            LIKE LINE OF r_iwerk,
***          ls_ingrp            LIKE LINE OF r_ingrp,
***          ls_beber            LIKE LINE OF r_beber,
***          ls_lgwid            LIKE LINE OF r_lgwid,
***          ls_fltyp            LIKE LINE OF r_fltyp,
***          ls_eqart            LIKE LINE OF r_eqart,
***          ls_locl             LIKE LINE OF r_locl.
***
**** Declaração de tabela
***    DATA: lt_imagem TYPE /ptloms/ct041,
***          lt_anexo  TYPE /ptloms/ct072.
***
**** Declaração de variáveis
***    DATA: lv_line                  TYPE bsvx-sttxt,
***          lv_user_line             TYPE bsvx-sttxt,
***          lv_anw_stat_existing     TYPE xfeld,
***          lv_e_stsma               TYPE jsto-stsma,
***          lv_stonr                 TYPE tj30-stonr,
***          lv_quantidade_local_inst TYPE int4.
***
**** Verifica se parâmetros de entrada estão preenchidos
***    IF rt_bukrs[] IS INITIAL AND
***       rt_iwerk[] IS INITIAL AND
***       rt_ingrp[] IS INITIAL AND
***       rt_beber[] IS INITIAL AND
***       rt_lgwid[] IS INITIAL AND
****       rt_wergw[] IS INITIAL AND
***       rt_eqart[] IS INITIAL AND
***       rt_fltyp[] IS INITIAL AND
***       rt_usuario_app[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca perfil do usuário
***    IF rt_usuario_app[] IS NOT INITIAL.
***      SELECT usuario, perfil
***        FROM /ptloms/tb013
***        INTO TABLE @DATA(lt_tb013)
***        WHERE usuario IN @rt_usuario_app.
***
***      IF lt_tb013[] IS NOT INITIAL.
***
***        READ TABLE lt_tb013 INTO DATA(ls_tb013) INDEX 1.
***
**** Verfica Configuração da Forma de recuperação dos Equipamentos
***        SELECT SINGLE configuracao FROM /ptloms/tb044 INTO @DATA(lv_configuracao) WHERE perfil       = @ls_tb013-perfil
***                                                                                    AND configuracao = '02'.
***        IF lv_configuracao = '02'.
***
***          me->out_local_instalacao_v2( EXPORTING rt_usuario_app = rt_usuario_app
***                                       IMPORTING rt_locl        = rt_locl ).
***
***          IF rt_locl[] IS INITIAL.
***            RETURN.
***          ENDIF.
***
***          LOOP AT rt_locl INTO DATA(ls_locl_aux).
***            CLEAR ls_locl.
***            MOVE-CORRESPONDING ls_locl_aux TO ls_locl.
***            APPEND ls_locl TO r_locl.
***          ENDLOOP.
***
***        ELSE.
***
**** Busca Centro do Perfil
***          SELECT *
***            FROM /ptloms/tb014
***            INTO TABLE @DATA(lt_tb014)
***            FOR ALL ENTRIES IN @lt_tb013
***            WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***          LOOP AT lt_tb014 INTO DATA(ls_tb014).
***            CLEAR ls_iwerk.
***            ls_iwerk-sign   = 'I'.
***            ls_iwerk-option = 'EQ'.
***            ls_iwerk-low    = ls_tb014-werks.
***            APPEND ls_iwerk TO r_iwerk.
***          ENDLOOP.
***
**** Busca Grupo de Planejamento do Perfil
***          SELECT *
***            FROM /ptloms/tb015
***            INTO TABLE @DATA(lt_tb015)
***            FOR ALL ENTRIES IN @lt_tb013
***            WHERE perfil = @lt_tb013-perfil
***              AND iwerk IN @r_iwerk.
***
**** Transforma em Range
***          LOOP AT lt_tb015 INTO DATA(ls_tb015) WHERE filtro_locl = 'X'.
***            CLEAR ls_ingrp.
***            ls_ingrp-sign   = 'I'.
***            ls_ingrp-option = 'EQ'.
***            ls_ingrp-low    = ls_tb015-ingrp.
***            APPEND ls_ingrp TO r_ingrp.
***          ENDLOOP.
***
**** Busca Área Operacional do Perfil
***          SELECT *
***            FROM /ptloms/tb016
***            INTO TABLE @DATA(lt_tb016)
***            FOR ALL ENTRIES IN @lt_tb013
***            WHERE perfil = @lt_tb013-perfil
***              AND werks IN @r_iwerk.
***
**** Transforma em Range
***          LOOP AT lt_tb016 INTO DATA(ls_tb016) WHERE filtro_locl = 'X'.
***            CLEAR ls_beber.
***            ls_beber-sign   = 'I'.
***            ls_beber-option = 'EQ'.
***            ls_beber-low    = ls_tb016-beber.
***            APPEND ls_beber TO r_beber.
***          ENDLOOP.
***
**** Busca Centro de Trabalho do Perfil
***          SELECT *
***            FROM /ptloms/tb017
***            INTO TABLE @DATA(lt_tb017)
***            FOR ALL ENTRIES IN @lt_tb013
***            WHERE perfil = @lt_tb013-perfil
***              AND werks IN @r_iwerk.
***
**** Transforma em Range
***          LOOP AT lt_tb017 INTO DATA(ls_tb017) WHERE filtro_locl = 'X'.
***            CLEAR ls_lgwid.
***            ls_lgwid-sign   = 'I'.
***            ls_lgwid-option = 'EQ'.
***            ls_lgwid-low    = ls_tb017-objid.
***            APPEND ls_lgwid TO r_lgwid.
***          ENDLOOP.
***
**** Busca Categoria de Local de Instalação do Perfil
***          SELECT *
***            FROM /ptloms/tb018
***            INTO TABLE @DATA(lt_tb018)
***            FOR ALL ENTRIES IN @lt_tb013
***            WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***          LOOP AT lt_tb018 INTO DATA(ls_tb018).
***            CLEAR ls_fltyp.
***            ls_fltyp-sign   = 'I'.
***            ls_fltyp-option = 'EQ'.
***            ls_fltyp-low    = ls_tb018-fltyp.
***            APPEND ls_fltyp TO r_fltyp.
***          ENDLOOP.
***
**** Busca Tipo de Ojeto Técnico do Perfil
***          SELECT *
***            FROM /ptloms/tb020
***            INTO TABLE @DATA(lt_tb020)
***            FOR ALL ENTRIES IN @lt_tb013
***            WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***          LOOP AT lt_tb020 INTO DATA(ls_tb020) WHERE filtro_locl = 'X'.
***            CLEAR ls_eqart.
***            ls_eqart-sign   = 'I'.
***            ls_eqart-option = 'EQ'.
***            ls_eqart-low    = ls_tb020-eqart.
***            APPEND ls_eqart TO r_eqart.
***          ENDLOOP.
***
***        ENDIF.
***      ENDIF.
***    ENDIF.
***
***    IF lv_configuracao = '02'.
***
**** Busca dados do Local de Instalação
***      SELECT tplnr, spras, pltxt, eqart, brgew, invnr,
***             herst, typbz, serge, swerk, beber, lgwid,
***             eqfnr, bukrs, anlnr, kostl, iwerk, ingrp,
***             ppsid, rbnr, tplma, objnr, submt, fltyp
***        FROM iflo
***        INTO TABLE @DATA(lt_iflo)
***        WHERE tplnr IN @r_locl
***          AND bukrs IN @rt_bukrs
***          AND iwerk IN @rt_iwerk
***          AND ingrp IN @rt_ingrp
***          AND beber IN @rt_beber
***          AND lgwid IN @rt_lgwid
***          AND eqart IN @rt_eqart
***          AND fltyp IN @rt_fltyp.
***
****          " Filtros relativos ao Usuário
****          AND iwerk IN @r_iwerk
****          AND ingrp IN @r_ingrp
****          AND beber IN @r_beber
****          AND lgwid IN @r_lgwid
****          AND fltyp IN @r_fltyp
****          AND eqart IN @r_eqart.
***
***    ELSE.
***
**** É obrigatório cadastrar a categoria de Local de Instalação para o Perfil
***      IF r_fltyp[] IS INITIAL. " Se range estiver vazio, então não busca Locls (É necessário cadastrar categoria de Locls para o perfil)
***        RETURN.
***      ENDIF.
***
**** Busca dados do Local de Instalação
***      SELECT tplnr, spras, pltxt, eqart, brgew, invnr,
***             herst, typbz, serge, swerk, beber, lgwid,
***             eqfnr, bukrs, anlnr, kostl, iwerk, ingrp,
***             ppsid, rbnr, tplma, objnr, submt, fltyp
***        FROM iflo
***        INTO TABLE @lt_iflo
***        WHERE bukrs IN @rt_bukrs
***          AND iwerk IN @rt_iwerk
***          AND ingrp IN @rt_ingrp
***          AND beber IN @rt_beber
***          AND lgwid IN @rt_lgwid
***          AND eqart IN @rt_eqart
***          AND fltyp IN @rt_fltyp
***
***          " Filtros relativos ao Usuário
***          AND iwerk IN @r_iwerk
***          AND ingrp IN @r_ingrp
***          AND beber IN @r_beber
***          AND lgwid IN @r_lgwid
***          AND fltyp IN @r_fltyp
***          AND eqart IN @r_eqart.
***    ENDIF.
***
**** Verifica se encontrou Local de Instalação
***    IF lt_iflo[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
***    SORT lt_iflo BY tplnr ASCENDING.
***    DELETE ADJACENT DUPLICATES FROM lt_iflo COMPARING tplnr.
***
**** Busca status do Local de Instalação
***    SELECT objnr, stat, inact
***      FROM jest
***      INTO TABLE @DATA(lt_jest)
***      FOR ALL ENTRIES IN @lt_iflo
***      WHERE objnr = @lt_iflo-objnr.
***
**** Busca configuração do sistema
***    SELECT SINGLE anexo_ordem, anexo_locl, anexo_equi
***      FROM /ptloms/tb033
***      INTO @DATA(ls_033).
***
***    DATA(lt_iflo_final) = lt_iflo[].
***    REFRESH lt_iflo_final.
***
**** Monta tabela final
***    LOOP AT lt_iflo INTO DATA(ls_iflo).
***
**** Limpa estrutura
***      CLEAR ls_local_instalacao.
***
**** Verifica se Locacl de Instalação está Inativo.
***      READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY objnr = ls_iflo-objnr
***                                                         stat  = 'I0320'
***                                                         inact = space.
***      IF sy-subrc EQ 0.
***        CONTINUE.
***      ENDIF.
***
**** Verifica se Local de Instalação está Marcado para Eliminação
***      READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY objnr = ls_iflo-objnr
***                                                         stat  = 'I0076'
***                                                         inact = space.
***      IF sy-subrc EQ 0.
***        CONTINUE.
***      ENDIF.
***
***      APPEND ls_iflo TO lt_iflo_final.
***    ENDLOOP.
***
**** Melhoria Performance - Início
***    DESCRIBE TABLE lt_iflo_final LINES ex_quantidade_local_inst.
**** Melhoria Performance - Fim
***
**** Monta dados de saída
***    LOOP AT lt_iflo_final INTO ls_iflo.
***
**** Melhoria Performance - Início
***      DATA(lv_tabix) = sy-tabix.
***      IF im_top > 0.
***        IF lv_tabix <= im_skip.
***          CONTINUE.
***        ENDIF.
***
***        lv_quantidade_local_inst = lv_quantidade_local_inst + 1.
***        IF lv_quantidade_local_inst > im_top.
***          EXIT.
***        ENDIF.
***      ENDIF.
**** Melhoria Performance - Fim
***
**** Carrega estrutura com campos correspondentes
***      MOVE-CORRESPONDING ls_iflo TO ls_local_instalacao.
***
**** Limpa variáveis
***      CLEAR: lv_anw_stat_existing, lv_e_stsma,
***             lv_line, lv_user_line, lv_stonr.
***
**** Chama função que retorna status de usuário e sistema
***      CALL FUNCTION 'STATUS_TEXT_EDIT'
***        EXPORTING
***          objnr             = ls_iflo-objnr
****         only_active       = 'X'
***          spras             = sy-langu
***        IMPORTING
***          anw_stat_existing = lv_anw_stat_existing
***          e_stsma           = lv_e_stsma
***          line              = lv_line
***          user_line         = lv_user_line
***          stonr             = lv_stonr
***        EXCEPTIONS
***          object_not_found  = 1
***          OTHERS            = 2.
***
***      IF sy-subrc = 0.
**** Carrega status de usuário e sistema
***        MOVE: lv_user_line TO ls_local_instalacao-status_usuario,
***              lv_line      TO ls_local_instalacao-status_sistema.
***      ENDIF.
***
**** Carrega imagens do Local de Instalação
***      IF ls_033-anexo_locl = 'X'.
***        CLEAR: ls_instid_a, ls_typeid_a.
***        REFRESH: r_instid_a[], r_typeid_a[], lt_imagem.
***
***        ls_instid_a-sign = 'I'.
***        ls_instid_a-option = 'EQ'.
***        ls_instid_a-low = ls_iflo-tplnr.
***        APPEND ls_instid_a TO r_instid_a.
***
***        ls_typeid_a-sign = 'I'.
***        ls_typeid_a-option = 'EQ'.
***        ls_typeid_a-low = 'BUS0010'.
***        APPEND ls_typeid_a TO r_typeid_a.
***
***        lt_anexo = me->out_imagem( rt_instid_a = r_instid_a
***                                   rt_typeid_a = r_typeid_a ).
***
***        IF lt_anexo[] IS NOT INITIAL.
***          APPEND LINES OF lt_anexo TO et_imagens_local_instalacao.
***        ENDIF.
***      ENDIF.
***
**** Inclui na tabela de saída
***      APPEND ls_local_instalacao TO et_local_instalacao.
***
***    ENDLOOP.
***
  ENDMETHOD.


  METHOD OUT_LOCAL_INSTALACAO_V2.

**    DATA: rt_equnr             TYPE /iwbep/t_cod_select_options,
**          r_equnr              TYPE RANGE OF v_equi-equnr,
**          r_equnr_copy         TYPE RANGE OF v_equi-equnr, " Equipamento
**          lv_quantidade_pacote TYPE int4 VALUE 2000.
**
**    DATA: ls_equnr LIKE LINE OF r_equnr,
**          ls_locl  LIKE LINE OF rt_locl.
**
**    DATA: lv_datbi TYPE equz-datbi VALUE '99991231'.
**
*** Busca equipamentos
**    me->out_equipamento_v2( EXPORTING rt_usuario_app = rt_usuario_app
**                            IMPORTING rt_equnr       = rt_equnr ).
**
*** Verifica se encontrou equipamentos
**    IF rt_equnr[] IS INITIAL.
**      RETURN.
**    ENDIF.
**
*** Carrega equipamentos
**    LOOP AT rt_equnr INTO DATA(ls_equnr_aux).
**      CLEAR ls_equnr.
**      MOVE-CORRESPONDING ls_equnr_aux TO ls_equnr.
**      APPEND ls_equnr TO r_equnr.
**    ENDLOOP.
**
*** 27/02/2023 - MR - Evitar dump devido quantidade de registros no range para o SELECT - Início
**    WHILE r_equnr[] IS NOT INITIAL.
**
**      APPEND LINES OF r_equnr[] FROM 1 TO lv_quantidade_pacote TO r_equnr_copy[].
**
**      DELETE r_equnr FROM 1 TO lv_quantidade_pacote.
**
*** Seleciona Intervalo de tempo equipamento
*** Busca dados da EQUZ
**      SELECT equnr, datbi, eqlfn, iloan, iwerk
**        FROM equz
**        APPENDING TABLE @DATA(lt_equz)
**        WHERE equnr IN @r_equnr_copy
**          AND datbi EQ @lv_datbi.
**
**      CLEAR: r_equnr_copy[].
**
**    ENDWHILE.
*** 27/02/2023 - MR - Evitar dump devido quantidade de registros no range para o SELECT - Fim
**
**    IF lt_equz[] IS NOT INITIAL.
**      SELECT iloan, tplnr
**        FROM iloa
**        INTO TABLE @DATA(lt_iloa)
**        FOR ALL ENTRIES IN @lt_equz
**        WHERE iloan = @lt_equz-iloan.
**
**      IF sy-subrc EQ 0.
**        LOOP AT lt_iloa INTO DATA(ls_iloa).
**          CLEAR ls_locl.
**          ls_locl-sign = 'I'.
**          ls_locl-option = 'EQ'.
**          ls_locl-low = ls_iloa-tplnr.
**          APPEND ls_locl TO rt_locl.
**        ENDLOOP.
**      ENDIF.
**    ENDIF.
**
*** Inclui Locais de Instalação de Exceção
**    SELECT *
**      FROM /ptloms/tb045
**      INTO TABLE @DATA(lt_tb45).
***        FOR ALL ENTRIES IN @lt_equz
***        WHERE werks = @lt_equz-iwerk.
**
**    IF sy-subrc EQ 0.
**      LOOP AT lt_tb45 INTO DATA(ls_tb45).
**        CLEAR ls_locl.
**        ls_locl-sign = 'I'.
**        ls_locl-option = 'EQ'.
**        ls_locl-low = ls_tb45-tplnr.
**        APPEND ls_locl TO rt_locl.
**      ENDLOOP.
**    ENDIF.
**
*** Ordena e elimina Locais repetidos
**    SORT rt_locl BY low ASCENDING.
**    DELETE ADJACENT DUPLICATES FROM rt_locl COMPARING low.

  ENDMETHOD.


  METHOD OUT_LOG.

*** Declaração de Tabelas Interna
**    DATA: lt_header_data        TYPE STANDARD TABLE OF balhdr,
**          lt_header_parameters  TYPE STANDARD TABLE OF balhdrp,
**          lt_messages           TYPE STANDARD TABLE OF balm,
**          lt_message_parameters TYPE STANDARD TABLE OF balmp,
**          lt_contexts           TYPE STANDARD TABLE OF balc,
**          lt_exceptions         TYPE STANDARD TABLE OF bal_s_exception.
**
*** Declaração de Estrutura
**    DATA: ls_log LIKE LINE OF et_log.
**
*** Declaração de Variáveis
**    DATA: lv_object           TYPE balhdr-object,
**          lv_subobject        TYPE balhdr-subobject,
**          lv_external_number  TYPE balhdr-extnumber,
**          lv_date_from        TYPE balhdr-aldate,
**          lv_date_to          TYPE balhdr-aldate,
**          lv_time_from        TYPE balhdr-altime,
**          lv_time_to          TYPE balhdr-altime,
**          lv_user_id          TYPE balhdr-aluser,
**          lv_timestmp         TYPE rke_hzstmp,
**          lv_data             TYPE sy-datum,
**          lv_hora             TYPE sy-uzeit,
**          lv_horario_verao(1) TYPE c.
**
*** Leitura dos Parâmetros de seleção
***    READ TABLE rt_object          INTO DATA(ls_object)          INDEX 1.
***    READ TABLE rt_subobject       INTO DATA(ls_subobject)       INDEX 1.
***    READ TABLE rt_external_number INTO DATA(ls_external_number) INDEX 1.
**    READ TABLE rt_date_from       INTO DATA(ls_date_from)       INDEX 1.
**    READ TABLE rt_date_to         INTO DATA(ls_date_to)         INDEX 1.
**    READ TABLE rt_time_from       INTO DATA(ls_time_from)       INDEX 1.
**    READ TABLE rt_time_to         INTO DATA(ls_time_to)         INDEX 1.
**    READ TABLE rt_user_id         INTO DATA(ls_user_id)         INDEX 1.
**
*** Verifica se Data e Usuário estão preenchidos
**    IF ls_date_from-low IS INITIAL AND ls_date_to-low IS INITIAL AND ls_user_id-low IS INITIAL.
**      RETURN.
**    ENDIF.
**
*** Atribuição de Parâmetros
**    lv_object          = '/PTLOMS/OMS'."
***    lv_subobject       = ls_subobject-low.
***    lv_external_number = ls_external_number-low.
**    lv_date_from       = ls_date_from-low.
**    lv_date_to         = ls_date_to-low.
**    lv_time_from       = ls_time_from-low.
**    lv_time_to         = ls_time_to-low.
**    lv_user_id         = ls_user_id-low.
**
**    CALL FUNCTION 'APPL_LOG_READ_DB'
**      EXPORTING
**        object             = lv_object
***       subobject          = lv_subobject
***       external_number    = lv_external_number
**        date_from          = lv_date_from
**        date_to            = lv_date_to
**        time_from          = lv_time_from
**        time_to            = lv_time_to
**        user_id            = lv_user_id
**      TABLES
**        header_data        = lt_header_data
**        header_parameters  = lt_header_parameters
**        messages           = lt_messages
**        message_parameters = lt_message_parameters
**        contexts           = lt_contexts
**        t_exceptions       = lt_exceptions.
**
**    IF lt_header_data[] IS NOT INITIAL.
**      SELECT *
**        FROM balsubt
**        INTO TABLE @DATA(lt_balsubt)
**        WHERE spras  EQ @sy-langu
**          AND object EQ '/PTLOMS/OMS'.
**    ENDIF.
**
**    LOOP AT lt_messages INTO DATA(ls_messages).
**      CLEAR ls_log.
**      MOVE-CORRESPONDING ls_messages TO ls_log.
**
**      READ TABLE lt_header_data INTO DATA(ls_header_data) WITH KEY lognumber = ls_messages-lognumber.
**      IF sy-subrc EQ 0.
**        ls_log-user_id   = ls_header_data-aluser.
**        ls_log-subobject = ls_header_data-subobject.
**        READ TABLE lt_balsubt INTO DATA(ls_balsubt) WITH KEY subobject = ls_header_data-subobject.
**        IF sy-subrc EQ 0.
**          ls_log-subobjtxt = ls_balsubt-subobjtxt.
**        ENDIF.
**      ENDIF.
**
**      SHIFT ls_log-lognumber LEFT DELETING LEADING '0'.
**
**      ls_log-date_from = ls_date_from-low.
**      ls_log-date_to   = ls_date_to-low.
**      ls_log-time_from = ls_time_from-low.
**      ls_log-time_to   = ls_time_to-low.
**
***      ls_log-user_id   = ls_user_id-low.
**
**      ls_log-date_time_from = ls_log-date_from+6(2) && |/| &&
**                              ls_log-date_from+4(2) && |/| &&
**                              ls_log-date_from(4)   && | | &&
**                              ls_log-time_from(2)   && |:| &&
**                              ls_log-time_from+2(2) && |:| &&
**                              ls_log-time_from+4(2).
**
**      ls_log-date_time_to = ls_log-date_to+6(2) && |/| &&
**                              ls_log-date_to+4(2) && |/| &&
**                              ls_log-date_to(4)   && | | &&
**                              ls_log-time_to(2)   && |:| &&
**                              ls_log-time_to+2(2) && |:| &&
**                              ls_log-time_to+4(2).
**
**      ls_log-message   = ls_messages-msgv1 && ls_messages-msgv2 && ls_messages-msgv3 && ls_messages-msgv4.
**
**      CLEAR: lv_data, lv_hora, lv_horario_verao.
**
**      CONVERT TIME STAMP ls_messages-time_stmp TIME ZONE sy-zonlo
**                INTO DATE lv_data TIME lv_hora
**                DAYLIGHT SAVING TIME lv_horario_verao.
**
***      IF lv_horario_verao = 'X'.
***
***        " Diminuir 1 hora
***        cl_abap_tstmp=>td_normalize(
***          EXPORTING
***            date_in                    = lv_data
***            time_in                    = lv_hora
***          IMPORTING
***            date_norm                  = lv_data
***            time_norm                  = lv_hora
***        ).
***      ENDIF.
**
**      ls_log-data_hora = lv_data+6(2) && |/| &&
**                         lv_data+4(2) && |/| &&
**                         lv_data(4)   && | | &&
**                         lv_hora(2)   && |:| &&
**                         lv_hora+2(2) && |:| &&
**                         lv_hora+4(2).
**
**      APPEND ls_log TO et_log.
**    ENDLOOP.
  ENDMETHOD.


  METHOD OUT_MATERIAL.
***
**** Declaração de Range
***    DATA: r_lgort TYPE RANGE OF mard-lgort,
***          r_mtart TYPE RANGE OF mara-mtart,
***          r_matkl TYPE RANGE OF mara-matkl,
***          r_werks TYPE RANGE OF mard-werks,
***          r_data  TYPE /iwbep/t_cod_select_options.
***
**** Declaração de estruturas
***    DATA: ls_lgort LIKE LINE OF r_lgort,
***          ls_mtart LIKE LINE OF r_mtart,
***          ls_matkl LIKE LINE OF r_matkl,
***          ls_werks LIKE LINE OF r_werks.
***
**** Declaração de variáveis
***    DATA: lv_quantidade_material TYPE int4.
***
**** Verifica se critério de seleção foi preechido
***    IF ( rt_mtart[]       IS INITIAL   OR
***         rt_werks[]       IS INITIAL ) AND
***       ( rt_usuario_app[] IS INITIAL ).
***      RETURN.
***    ENDIF.
***
**** Busca perfil do usuário
***    IF rt_usuario_app[] IS NOT INITIAL.
***      SELECT usuario, perfil, material_saldo
***        FROM /ptloms/tb013
***        INTO TABLE @DATA(lt_tb013)
***        WHERE usuario IN @rt_usuario_app.
***
***      IF lt_tb013[] IS NOT INITIAL.
***
**** Busca tipo de Material do Perfil
***        SELECT *
***          FROM /ptloms/tb023
***          INTO TABLE @DATA(lt_tb023)
***          FOR ALL ENTRIES IN @lt_tb013
***          WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***        LOOP AT lt_tb023 INTO DATA(ls_tb023).
***          CLEAR ls_mtart.
***          ls_mtart-sign   = 'I'.
***          ls_mtart-option = 'EQ'.
***          ls_mtart-low    = ls_tb023-mtart.
***          APPEND ls_mtart TO r_mtart.
***        ENDLOOP.
***
**** Busca Grupo de Mercadoria do Perfil
***        SELECT *
***          FROM /ptloms/tb028
***          INTO TABLE @DATA(lt_tb028)
***          FOR ALL ENTRIES IN @lt_tb013
***          WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***        LOOP AT lt_tb028 INTO DATA(ls_tb028).
***          CLEAR ls_matkl.
***          ls_matkl-sign   = 'I'.
***          ls_matkl-option = 'EQ'.
***          ls_matkl-low    = ls_tb028-matkl.
***          APPEND ls_matkl TO r_matkl.
***        ENDLOOP.
***
**** Busca Depósito do Perfil
***        SELECT *
***          FROM /ptloms/tb030
***          INTO TABLE @DATA(lt_tb030)
***          FOR ALL ENTRIES IN @lt_tb013
***          WHERE perfil = @lt_tb013-perfil.
***
**** Transforma em Range
***        LOOP AT lt_tb030 INTO DATA(ls_tb030).
***          CLEAR ls_lgort.
***          ls_lgort-sign   = 'I'.
***          ls_lgort-option = 'EQ'.
***          ls_lgort-low    = ls_tb030-lgort.
***          APPEND ls_lgort TO r_lgort.
***
***          CLEAR ls_werks.
***          ls_werks-sign   = 'I'.
***          ls_werks-option = 'EQ'.
***          ls_werks-low    = ls_tb030-werks.
***          APPEND ls_werks TO r_werks.
***        ENDLOOP.
***
***      ENDIF.
***
**** É obrigatório que seja cadastrado tipo de Materia no Perfil
***      IF r_mtart[] IS INITIAL. " Se range estiver vazio, então não busca materiais (É necessário cadastrar tipo de material para o perfil)
***        RETURN.
***      ENDIF.
***
**** 20/03/2023 - Início
***      IF r_lgort[] IS INITIAL. " Se range estiver vazio, então não busca materiais (É necessário cadastrar o depósito para o perfil)
***        RETURN.
***      ENDIF.
***
***      IF r_werks[] IS INITIAL. " Se range estiver vazio, então não busca materiais (É necessário cadastrar centro para o perfil)
***        RETURN.
***      ENDIF.
**** 20/03/2023 - Fim
***
**** Caso só tenha um usuário no filtro, lê configuração de Saldo em Estoque do Material, relativo ao usuário
***      DESCRIBE TABLE rt_usuario_app LINES DATA(lv_qtd_usu).
***      IF lv_qtd_usu = 1.
***        READ TABLE rt_usuario_app INTO DATA(ls_usuario_app) INDEX 1.
***        IF ls_usuario_app-sign = 'I' AND ls_usuario_app-option = 'EQ'.
***          READ TABLE lt_tb013 INTO DATA(ls_tb013) WITH KEY usuario = ls_usuario_app-low.
***          IF sy-subrc EQ 0 AND ls_tb013-material_saldo = 'X'.
***            DATA(lv_material_saldo) = 'X'.
***          ENDIF.
***        ENDIF.
***      ENDIF.
***
***      IF rt_lgort[] IS NOT INITIAL OR r_lgort[] IS NOT INITIAL.
**** Seleciona Materiais
***        IF lv_material_saldo = 'X'.
***          SELECT a~matnr, c~maktx, a~mtart, a~meins, b~werks, b~lgort
***            FROM mara AS a INNER JOIN mard AS b ON a~matnr = b~matnr
***            INNER JOIN makt AS c ON a~matnr = c~matnr
***            INTO CORRESPONDING FIELDS OF TABLE @rt_materiais
***            WHERE a~mtart IN @rt_mtart
***              AND b~werks IN @rt_werks
***              AND b~lgort IN @rt_lgort
***              AND c~spras = @sy-langu
***              AND b~labst > 0
***              AND a~lvorm EQ @space
***              AND b~lvorm EQ @space
***
***              " Filtros relativos ao Usuário
***              AND a~mtart IN @r_mtart
***              AND a~matkl IN @r_matkl
***              AND b~werks IN @r_werks
***              AND b~lgort IN @r_lgort.
***        ELSE.
***          SELECT a~matnr, c~maktx, a~mtart, a~meins, b~werks, b~lgort
***            FROM mara AS a INNER JOIN mard AS b ON a~matnr = b~matnr
***            INNER JOIN makt AS c ON a~matnr = c~matnr
***            INTO CORRESPONDING FIELDS OF TABLE @rt_materiais
***            WHERE a~mtart IN @rt_mtart
***              AND b~werks IN @rt_werks
***              AND b~lgort IN @rt_lgort
***              AND c~spras = @sy-langu
***              AND a~lvorm EQ @space
***              AND b~lvorm EQ @space
***
***              " Filtros relativos ao Usuário
***              AND a~mtart IN @r_mtart
***              AND a~matkl IN @r_matkl
***              AND b~werks IN @r_werks
***              AND b~lgort IN @r_lgort.
***        ENDIF.
***      ELSE.
***
**** Seleciona Materiais
***        IF lv_material_saldo = 'X'.
***          SELECT a~matnr, c~maktx, a~mtart, a~meins, b~werks
***            FROM mara AS a INNER JOIN marc AS b ON a~matnr = b~matnr
***            INNER JOIN makt AS c ON a~matnr = c~matnr
***            INNER JOIN mard AS d ON a~matnr = b~matnr
***            INTO CORRESPONDING FIELDS OF TABLE @rt_materiais
***            WHERE a~mtart IN @rt_mtart
***              AND b~werks IN @rt_werks
***              AND c~spras = @sy-langu
***              AND d~labst > 0
***              AND a~lvorm EQ @space
***              AND b~lvorm EQ @space
***              AND d~lvorm EQ @space
***
***              " Filtros relativos ao Usuário
***              AND a~mtart IN @r_mtart
***              AND a~matkl IN @r_matkl
***              AND b~werks IN @r_werks
***              AND d~lgort IN @r_lgort.
***        ELSE.
***          SELECT a~matnr, c~maktx, a~mtart, a~meins, b~werks
***            FROM mara AS a INNER JOIN marc AS b ON a~matnr = b~matnr
***            INNER JOIN makt AS c ON a~matnr = c~matnr
***            INNER JOIN mard AS d ON a~matnr = b~matnr
***            INTO CORRESPONDING FIELDS OF TABLE @rt_materiais
***            WHERE a~mtart IN @rt_mtart
***              AND b~werks IN @rt_werks
***              AND c~spras = @sy-langu
***              AND a~lvorm EQ @space
***              AND b~lvorm EQ @space
***              AND d~lvorm EQ @space
***
***              " Filtros relativos ao Usuário
***              AND a~mtart IN @r_mtart
***              AND a~matkl IN @r_matkl
***              AND b~werks IN @r_werks
***              AND d~lgort IN @r_lgort.
***        ENDIF.
***
***      ENDIF.
***
***    ENDIF.
***
***    IF rt_materiais[] IS NOT INITIAL.
***      SORT rt_materiais BY matnr ASCENDING
***                           mtart ASCENDING
***                           meins ASCENDING
***                           werks ASCENDING
***                           lgort ASCENDING.
***
***      DELETE ADJACENT DUPLICATES FROM rt_materiais COMPARING matnr mtart meins werks.
****      DELETE ADJACENT DUPLICATES FROM rt_materiais COMPARING matnr mtart meins werks lgort.
***
**** Melhoria Performance - Início
***      IF im_top > 0.
***        DESCRIBE TABLE rt_materiais LINES ex_quantidade_material.
***
***        DATA(lt_materiais_final) = rt_materiais[].
***        REFRESH rt_materiais[].
***
***        LOOP AT lt_materiais_final INTO DATA(ls_materiais).
***          DATA(lv_tabix) = sy-tabix.
***          IF im_top > 0.
***            IF lv_tabix <= im_skip.
***              CONTINUE.
***            ENDIF.
***
***            lv_quantidade_material = lv_quantidade_material + 1.
***            IF lv_quantidade_material > im_top.
***              EXIT.
***            ENDIF.
***          ENDIF.
***          APPEND ls_materiais TO rt_materiais.
***        ENDLOOP.
***      ENDIF.
**** Melhoria Performance - Fim
***    ENDIF.
***
  ENDMETHOD.


  METHOD OUT_MATRICULA.

***    SELECT usuario, nome, matricula
***      FROM /ptloms/tb013
***      INTO CORRESPONDING FIELDS OF TABLE @et_matriculas
***      WHERE bloqueado NE 'X'.

  ENDMETHOD.


  METHOD out_monta_range_data_usuario.
***
    DATA: ls_data LIKE LINE OF rt_data.

* Declaração de variáveis
    DATA: lv_dia_semana_partida TYPE C LENGTH 10,
          lv_data_de            TYPE sy-datum,
          lv_data_ate           TYPE sy-datum.

* Verifica se parâmetro de entrada foi preenchido
    IF im_usuario IS INITIAL.
      RETURN.
    ENDIF.

*Begin of change - Sidney Vidal - 31.07.2024 16:19:34
* Busca os dados do usuário
*    SELECT SINGLE usuario, dia_inicio, dias_retroativos, dias_progressivos
*      FROM /ptloms/tb013
*      INTO @DATA(ls_tb013)
*      WHERE usuario = @im_usuario.
    DATA ls_tb013    TYPE /ptloms/tb013.
    SELECT SINGLE usuario dia_inicio dias_retroativos dias_progressivos
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF ls_tb013
      WHERE usuario = im_usuario.
*Ended of change - Sidney Vidal - 31.07.2024 16:19:34

* Verifica se usuário foi encontrado
    IF ls_tb013 IS INITIAL.
      RETURN.
    ENDIF.

    IF ls_tb013-dia_inicio IS NOT INITIAL.

      "Busca dia da semana da Data de Partida
      CALL FUNCTION 'DATE_TO_DAY'
        EXPORTING
          date    = sy-datum
        IMPORTING
          weekday = lv_dia_semana_partida.

      CASE ls_tb013-dia_inicio.

        WHEN '1'. "Domingo

          CASE lv_dia_semana_partida.
            WHEN 'Sunday'. "Domingo
              lv_data_de = sy-datum.
              lv_data_ate = sy-datum + 6.
            WHEN 'Monday'. "Segunda-feira
              lv_data_de = sy-datum - 1.
              lv_data_ate = sy-datum + 5.
            WHEN 'Tuesday'. "Terça-feira
              lv_data_de   = sy-datum - 2.
              lv_data_ate = sy-datum + 4.
            WHEN 'Wed.'."Quarta-feira
              lv_data_de = sy-datum - 3.
              lv_data_ate = sy-datum + 3.
            WHEN 'Thursday'. "Quinta-feira
              lv_data_de = sy-datum - 4.
              lv_data_ate = sy-datum + 2.
            WHEN 'Friday'. "Sexta-feira
              lv_data_de = sy-datum - 5.
              lv_data_ate = sy-datum + 1.
            WHEN 'Sat.'. "Sábado
              lv_data_de = sy-datum - 6.
              lv_data_ate = sy-datum.
            WHEN OTHERS.
          ENDCASE.

        WHEN '2'. "Segunda-feira

          CASE lv_dia_semana_partida.
            WHEN 'Sunday'. "Domingo
              lv_data_de = sy-datum - 6.
              lv_data_ate = sy-datum.
            WHEN 'Monday'. "Segunda-feira
              lv_data_de = sy-datum.
              lv_data_ate = sy-datum + 6.
            WHEN 'Tuesday'. "Terça-feira
              lv_data_de = sy-datum - 1.
              lv_data_ate = sy-datum + 5.
            WHEN 'Wed.'."Quarta-feira
              lv_data_de = sy-datum - 2.
              lv_data_ate = sy-datum + 4.
            WHEN 'Thursday'. "Quinta-feira
              lv_data_de = sy-datum - 3.
              lv_data_ate = sy-datum + 3.
            WHEN 'Friday'. "Sexta-feira
              lv_data_de = sy-datum - 4.
              lv_data_ate = sy-datum + 2.
            WHEN 'Sat.'. "Sábado
              lv_data_de = sy-datum - 5.
              lv_data_ate = sy-datum + 1.
            WHEN OTHERS.
          ENDCASE.

        WHEN OTHERS.
      ENDCASE.



    ELSEIF ls_tb013-dias_retroativos IS NOT INITIAL OR ls_tb013-dias_progressivos IS NOT INITIAL.

      lv_data_de    = sy-datum - ls_tb013-dias_retroativos.
      lv_data_ate   = sy-datum + ls_tb013-dias_progressivos.

    ENDIF.

    ls_data-sign   = 'I'.
    ls_data-option = 'BT'.
    ls_data-low    = lv_data_de.
    ls_data-high   = lv_data_ate.

    APPEND ls_data TO rt_data.
  ENDMETHOD.


  METHOD out_nota.
***
****Declaração de range
***    DATA: r_qmnum    TYPE /iwbep/t_cod_select_options,
***          r_parnr    TYPE /iwbep/t_cod_select_options,
***          r_instid_a TYPE /iwbep/t_cod_select_options,
***          r_typeid_a TYPE /iwbep/t_cod_select_options.
***
***
**** Declaração de tabela interna
***    DATA: lt_status TYPE TABLE OF string.
***
**** Declaração de estrutaras
***    DATA: ls_nota            LIKE LINE OF et_notas,
***          ls_itens_nota      LIKE LINE OF et_itens_nota,
***          ls_textos_nota     LIKE LINE OF et_textos_nota,
***          ls_medidas_nota    LIKE LINE OF et_medidas_nota,
***          ls_causas_nota     LIKE LINE OF et_causas_nota,
***          ls_atividades_nota LIKE LINE OF et_atividades_nota,
***          ls_instid_a        LIKE LINE OF r_instid_a,
***          ls_typeid_a        LIKE LINE OF r_typeid_a.
***
**** Declaração de variável
***    DATA: lv_qmnum           TYPE viqmel-qmnum,
***          lv_parnr           TYPE i_parnr,
***          lv_partner_true(1) TYPE c,
***          lv_status_true(1)  TYPE c.
***
**** Declaração de tabela
***    DATA: "lt_imagem TYPE /ptloms/ct041
***          lt_anexo TYPE /ptloms/ct072.
***
**** Declaração para BAPI
***    DATA: ls_notifheader_export TYPE bapi2080_nothdre,
***          ls_header             TYPE bapi_alm_order_header_e,
***          lt_notlongtxt         TYPE STANDARD TABLE OF bapi2080_notfulltxte,
***          lt_notitem            TYPE STANDARD TABLE OF bapi2080_notiteme,
***          lt_notifcaus          TYPE STANDARD TABLE OF bapi2080_notcause,
***          lt_notiftask          TYPE STANDARD TABLE OF bapi2080_nottaske,
***          lt_notifactv          TYPE STANDARD TABLE OF bapi2080_notactve,
***          lt_notifpartnr        TYPE STANDARD TABLE OF bapi2080_notpartnre,
***          lt_return             TYPE STANDARD TABLE OF bapiret2.
***
**** Verifica se parâmetros de entrada estão preenchido
***    IF ( rt_qmnum[] IS INITIAL AND
***         rt_qmart[] IS INITIAL AND
***         rt_iwerk[] IS INITIAL AND
***         rt_ingrp[] IS INITIAL AND
***         rt_beber[] IS INITIAL AND
***         rt_arbpl[] IS INITIAL AND
***         rt_parnr[] IS INITIAL AND
***         rt_eqfnr[] IS INITIAL ) AND"OR
****        rt_strmn[] IS INITIAL.
****        rt_sttxt[] IS INITIAL AND
****        rt_astex[] IS NOT INITIAL.
***         rt_strmn[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
***    r_parnr[] = rt_parnr[].
***
**** Converte o campo PARNR
***    LOOP AT r_parnr ASSIGNING FIELD-SYMBOL(<fs_parnr>).
***      IF <fs_parnr>-low IS NOT INITIAL.
***        MOVE <fs_parnr>-low TO lv_parnr.
***        <fs_parnr>-low = |{ lv_parnr ALPHA = IN }|.
***      ENDIF.
***      IF <fs_parnr>-high IS NOT INITIAL.
***        MOVE <fs_parnr>-high TO lv_parnr.
***        <fs_parnr>-high = |{ lv_parnr ALPHA = IN }|.
***      ENDIF.
***    ENDLOOP.
***
***    r_qmnum[] = rt_qmnum[].
***
**** Converte o campo QMNUM
***    LOOP AT r_qmnum ASSIGNING FIELD-SYMBOL(<fs_qmnum>).
***      IF <fs_qmnum>-low IS NOT INITIAL.
***        MOVE <fs_qmnum>-low TO lv_qmnum.
***        <fs_qmnum>-low = |{ lv_qmnum ALPHA = IN }|.
***      ENDIF.
***      IF <fs_qmnum>-high IS NOT INITIAL.
***        MOVE <fs_qmnum>-high TO lv_qmnum.
***        <fs_qmnum>-high = |{ lv_qmnum ALPHA = IN }|.
***      ENDIF.
***    ENDLOOP.
***
**** Seleciona Notas
***    SELECT qmnum, objnr
***      FROM viqmel
***      INTO TABLE @DATA(lt_viqmel)
***      WHERE qmnum IN @r_qmnum
***        AND qmart IN @rt_qmart
***        AND iwerk IN @rt_iwerk
***        AND ingrp IN @rt_ingrp
***        AND beber IN @rt_beber
***        AND arbpl IN @rt_arbpl
***        AND eqfnr IN @rt_eqfnr
***        AND strmn IN @rt_strmn.
***
**** Verifica se encontrou Nota
***    IF lt_viqmel[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca configuração do sistema
***    SELECT SINGLE anexo_ordem, anexo_locl, anexo_equi
***      FROM /ptloms/tb033
***      INTO @DATA(ls_033).
***
**** Monta tabelas de saída
***    LOOP AT lt_viqmel INTO DATA(ls_viqmel).
***
***      CLEAR ls_nota.
***
***      ls_nota-objnr = ls_viqmel-objnr.
***
**** Limpa variávveis
***      CLEAR: ls_header, ls_notifheader_export.
***      REFRESH: lt_notlongtxt[], lt_notitem[], lt_notifcaus[], lt_notifpartnr[],
***               lt_notifactv[], lt_notiftask[], lt_return[].
***
***      MOVE: ls_viqmel-qmnum TO ls_header-notif_no.
***
***      CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
***        EXPORTING
***          number             = ls_header-notif_no
***        IMPORTING
***          notifheader_export = ls_notifheader_export
***        TABLES
***          notlongtxt         = lt_notlongtxt
***          notitem            = lt_notitem
***          notifcaus          = lt_notifcaus
***          notifactv          = lt_notifactv
***          notiftask          = lt_notiftask
***          notifpartnr        = lt_notifpartnr
***          return             = lt_return.
***
**** Verifica se status de sistema da nota está contido no critério de seleção
***      REFRESH lt_status[].
***      CLEAR lv_status_true.
***      IF rt_sttxt IS NOT INITIAL.
***        SPLIT ls_notifheader_export-sys_status AT ' ' INTO TABLE lt_status.
***        LOOP AT lt_status INTO DATA(ls_status).
***          IF ls_status IN rt_sttxt.
***            lv_status_true = 'X'.
***            EXIT.
***          ENDIF.
***        ENDLOOP.
***        IF lv_status_true IS INITIAL.
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
**** Verifica se status de usuário da nota está contido no critério de seleção
***      REFRESH lt_status[].
***      CLEAR lv_status_true.
***      IF rt_astex IS NOT INITIAL.
***        SPLIT ls_notifheader_export-userstatus AT ' ' INTO TABLE lt_status.
***        LOOP AT lt_status INTO ls_status.
***          IF ls_status IN rt_astex.
***            lv_status_true = 'X'.
***            EXIT.
***          ENDIF.
***        ENDLOOP.
***        IF lv_status_true IS INITIAL.
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
**** Verifica se parceiro está contido no critério de seleção
***      CLEAR lv_partner_true.
***      IF r_parnr[] IS NOT INITIAL.
***        LOOP AT lt_notifpartnr INTO DATA(ls_notifpartnr).
***          ls_notifpartnr-partner = |{ ls_notifpartnr-partner ALPHA = IN }|.
***          IF ls_notifpartnr-partner IN r_parnr.
***            lv_partner_true = 'X'.
***            EXIT.
***          ENDIF.
***        ENDLOOP.
***        IF lv_partner_true IS INITIAL.
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
**** Atribui campos correspondentes da Nota
***      MOVE-CORRESPONDING ls_notifheader_export TO ls_nota.
***
**** Carrega textos da Nota
***      LOOP AT lt_notlongtxt INTO DATA(ls_notlongtxt).
***        CLEAR ls_textos_nota.
***        MOVE-CORRESPONDING ls_notlongtxt TO ls_textos_nota.
***        ls_textos_nota-notif_no = ls_nota-notif_no.
***        APPEND ls_textos_nota TO et_textos_nota.
***      ENDLOOP.
***
**** Carrega itens da Nota
***      LOOP AT lt_notitem INTO DATA(ls_notitem).
***        CLEAR ls_itens_nota.
***        MOVE-CORRESPONDING ls_notitem TO ls_itens_nota.
***        APPEND ls_itens_nota TO et_itens_nota.
***      ENDLOOP.
***
**** Carrega Causas da Nota
***      LOOP AT lt_notifcaus INTO DATA(ls_notifcaus).
***        CLEAR ls_causas_nota.
***        MOVE-CORRESPONDING ls_notifcaus TO ls_causas_nota.
***        APPEND ls_causas_nota TO et_causas_nota.
***      ENDLOOP.
***
**** Carrega medidas da Nota
***      LOOP AT lt_notiftask INTO DATA(ls_notiftask).
***        CLEAR ls_medidas_nota.
***        MOVE-CORRESPONDING ls_notiftask TO ls_medidas_nota.
***        APPEND ls_medidas_nota TO et_medidas_nota.
***      ENDLOOP.
***
**** Carrega atividades da Nota
***      LOOP AT lt_notifactv INTO DATA(ls_notifactv).
***        CLEAR ls_atividades_nota.
***        MOVE-CORRESPONDING ls_notifactv TO ls_atividades_nota.
***        APPEND ls_atividades_nota TO et_atividades_nota.
***      ENDLOOP.
***
**** Carrega imagens da nota
***      IF ls_033-anexo_ordem = 'X'.
***        CLEAR: ls_instid_a, ls_typeid_a.
***        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.
***
***        ls_instid_a-sign = 'I'.
***        ls_instid_a-option = 'EQ'.
***        ls_instid_a-low = ls_viqmel-qmnum.
***        APPEND ls_instid_a TO r_instid_a.
***
***        ls_typeid_a-sign = 'I'.
***        ls_typeid_a-option = 'EQ'.
***        ls_typeid_a-low = 'BUS2038'.
***        APPEND ls_typeid_a TO r_typeid_a.
***
***        lt_anexo = me->out_imagem( rt_instid_a = r_instid_a
***                                   rt_typeid_a = r_typeid_a ).
***
***        IF lt_anexo[] IS NOT INITIAL.
***          APPEND LINES OF lt_anexo TO et_imagens_nota.
***        ENDIF.
***      ENDIF.
***
**** Carrega Nota
***      APPEND ls_nota TO et_notas.
***
***    ENDLOOP.
***
  ENDMETHOD.


  METHOD OUT_NOTA_PERFIL_USUARIO.
**
**    READ TABLE rt_usuario_app INTO DATA(ls_usuario_app) INDEX 1.
**
**    IF ls_usuario_app-sign = 'I' AND ls_usuario_app-option = 'EQ'.
**
**      DATA(lv_usuario) = ls_usuario_app-low.
**
**    ENDIF.
**
**    SELECT SINGLE *
**      FROM /ptloms/tb013
**      INTO @DATA(ls_usuario)
**      WHERE usuario EQ @lv_usuario.
**
**    IF sy-subrc IS INITIAL.
**
*** Busca Perfil x Tipo Nota
**      SELECT *
**        FROM /ptloms/tb021
**        INTO TABLE @DATA(lt_tb021)
**        WHERE perfil = @ls_usuario-perfil.
**
**      IF sy-subrc IS INITIAL.
**
**        SORT lt_tb021 BY qmart.
**
**        SELECT qmnum, objnr
**          FROM viqmel
**          INTO TABLE @DATA(lt_viqmel)
**          FOR ALL ENTRIES IN @lt_tb021
**          WHERE qmart = @lt_tb021-qmart.
**
**      ENDIF.
**
**    ENDIF.
**
**    " Monta Tabelas de Saída
**    LOOP AT lt_viqmel INTO DATA(ls_viqmel).
**
**      APPEND VALUE #( qmnum = |{ ls_viqmel-qmnum ALPHA = OUT }| usuario_app = lv_usuario ) TO et_notas.
**
**    ENDLOOP.
**
   ENDMETHOD.


  METHOD out_ordem.
***
***    CONSTANTS: c_ag  TYPE ihpa-parvw VALUE 'SP',
***               c_ieq TYPE ihpa-obtyp VALUE 'IEQ'.
***    DATA: lv_parvw   TYPE ihpa-parvw.
***
****Declaração de range
***    DATA:      r_aufnr    TYPE /iwbep/t_cod_select_options,
***               r_parnr    TYPE /iwbep/t_cod_select_options,
***               r_instid_a TYPE /iwbep/t_cod_select_options,
***               r_typeid_a TYPE /iwbep/t_cod_select_options.
***
***    DATA: rt_matnr TYPE /iwbep/t_cod_select_options,
***          rt_werks TYPE /iwbep/t_cod_select_options,
***          rt_lgort TYPE /iwbep/t_cod_select_options,
***          ls_matnr LIKE LINE OF rt_matnr,
***          ls_werks LIKE LINE OF rt_werks,
***          ls_lgort LIKE LINE OF rt_lgort.
***
**** Declaração de tabelaxs interna
***    DATA: lt_status     TYPE TABLE OF string,
***          lt_values_tab TYPE STANDARD TABLE OF dd07v.
***
**** Declaração de Estrutura
***    DATA: ls_ordem             LIKE LINE OF et_ordens,
***          ls_textos_ordem      LIKE LINE OF et_textos_ordem,
***          ls_textos_operacoes  LIKE LINE OF et_textos_operacoes,
***          ls_operacoes_ordem   LIKE LINE OF et_operacoes_ordem,
***          ls_componentes_ordem LIKE LINE OF et_componentes_ordem,
***          ls_confirmacoes      LIKE LINE OF et_confirmacoes,
***          ls_filtro            TYPE /ptloms/et056,
***          ls_instid_a          LIKE LINE OF r_instid_a,
***          ls_typeid_a          LIKE LINE OF r_typeid_a,
***          ls_return_conf       TYPE bapiret2,
***          ls_conf_detail       TYPE bapi_alm_confirmation.
***
**** Declaração de tabela
***    DATA: lt_partner        TYPE STANDARD TABLE OF bapi_alm_order_partner,
***          lt_operations     TYPE STANDARD TABLE OF bapi_alm_order_operation_e,
***          lt_components     TYPE STANDARD TABLE OF bapi_alm_order_component_e,
***          lt_text_lines     TYPE STANDARD TABLE OF bapi_alm_text_lines,
***          lt_texts          TYPE STANDARD TABLE OF bapi_alm_text,
***          lt_return         TYPE STANDARD TABLE OF bapiret2,
***          lt_anexo          TYPE /ptloms/ct072,
***          lt_saldo_material TYPE /ptloms/ct064,
***          lt_txt_read       TYPE STANDARD TABLE OF tline.
***
**** Declarações para BAPI
***    DATA: lv_number TYPE bapi_alm_order_header_e-orderid,
***          ls_header TYPE bapi_alm_order_header_e.
***
**** Declaraçãode variável
***    DATA: lv_aufnr                 TYPE aufnr,
***          lv_parnr                 TYPE i_parnr,
***          lv_partner_true(1)       TYPE c,
***          lv_status_true(1)        TYPE c,
***          lv_objnr                 TYPE jsto-objnr,
***          lv_desprezar             TYPE char1,
***          lv_usuario               TYPE /ptloms/tb013-usuario,
***          lv_outro_titular(1)      TYPE c,
***          lv_val_dominio           TYPE val_single,
***          lv_data_referencia_verde TYPE sy-datum,
***          lv_data_referencia_verme TYPE sy-datum,
***          lv_atribuir_oper         TYPE flag,
***          lv_calc_trab_real        TYPE flag,
***          lv_data                  TYPE sy-datum,
***          lv_hora                  TYPE sy-uzeit,
***          lv_nome                  TYPE tdobname,
***          lv_quantidade_ordem      TYPE int4,
***          lv_quebra_linha          TYPE string VALUE cl_abap_char_utilities=>newline.
***
***    DATA: BEGIN OF wa_address,
***            adrnr      TYPE kna1-adrnr,
***            ort02      TYPE kna1-ort02,
***            house_num1 TYPE adrc-house_num1,
***          END OF wa_address.
***
***    r_parnr[] = rt_parnr[].
***
**** Converte o campo PARNR
***    LOOP AT r_parnr ASSIGNING FIELD-SYMBOL(<fs_parnr>).
***      IF <fs_parnr>-low IS NOT INITIAL.
***        MOVE <fs_parnr>-low TO lv_parnr.
***        <fs_parnr>-low = |{ lv_parnr ALPHA = IN }|.
***      ENDIF.
***      IF <fs_parnr>-high IS NOT INITIAL.
***        MOVE <fs_parnr>-high TO lv_parnr.
***        <fs_parnr>-high = |{ lv_parnr ALPHA = IN }|.
***      ENDIF.
***    ENDLOOP.
***
***    r_aufnr[] = rt_aufnr[].
***
**** Converte o campo AUFNR
***    LOOP AT r_aufnr ASSIGNING FIELD-SYMBOL(<fs_aufnr>).
***      IF <fs_aufnr>-low IS NOT INITIAL.
***        MOVE <fs_aufnr>-low TO lv_aufnr.
***        <fs_aufnr>-low = |{ lv_aufnr ALPHA = IN }|.
***      ENDIF.
***      IF <fs_aufnr>-high IS NOT INITIAL.
***        MOVE <fs_aufnr>-high TO lv_aufnr.
***        <fs_aufnr>-high = |{ lv_aufnr ALPHA = IN }|.
***      ENDIF.
***    ENDLOOP.
***
******* Seleciona Ordens
******    SELECT aufnr, objnr
******      FROM viaufks
******      INTO TABLE @DATA(lt_viaufks)
******      WHERE aufnr IN @r_aufnr
******        AND auart IN @rt_auart
******        AND iwerk IN @rt_iwerk
******        AND ingpr IN @rt_ingpr
******        AND beber IN @rt_beber
******        AND gewrk IN @rt_arbpl
******        AND eqfnr IN @rt_eqfnr
******        AND gstrp IN @rt_gstrp.
******
*******        " Filtros relativos ao Usuário
*******        AND iwerk IN @r_iwerk
*******        AND ingpr IN @r_ingpr
*******        AND beber IN @r_beber
*******        AND gewrk IN @r_lgwid
*******        AND auart IN @r_auart
*******        AND ilart IN @r_ilart.
***
**** Busca ordens despachadas
***    SELECT aufnr, vornr, suboper, usuario, data_associacao, hora_associacao
***      FROM /ptloms/tb026
***      INTO TABLE @DATA(lt_tb026)
***      WHERE aufnr        IN @r_aufnr
***        AND usuario      IN @rt_usuario_app
***        AND desassociado EQ @space.
***
***    IF lt_tb026[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca status das ordens despachadas
***    SELECT aufnr, vornr, suboper, usuario, data_ini, hora_ini, data_fim, hora_fim, status, inativo
***      FROM /ptloms/tb031
***      INTO TABLE @DATA(lt_031)
***      WHERE aufnr   IN @r_aufnr
***        AND usuario IN @rt_usuario_app
***        AND ( status EQ 1 OR status = 2 ).
****        AND inativo EQ @space.
***
**** Busca status das ordens despachadas
***    SELECT aufnr, vornr, suboper, usuario, data_ini, hora_ini, data_fim, hora_fim, status, inativo
***      FROM /ptloms/tb031
***      INTO TABLE @DATA(lt_031_outro_titular)
***      WHERE aufnr   IN @r_aufnr
***        AND usuario NOT IN @rt_usuario_app
***        AND ( status EQ 1 OR status = 2 )
***        AND inativo EQ @space.
***
**** Recupera registro mais recente
***    SORT lt_031 BY aufnr    ASCENDING
***                   vornr    ASCENDING
***                   suboper  ASCENDING
***                   usuario  ASCENDING
***                   data_ini DESCENDING
***                   hora_ini DESCENDING
***                   data_fim DESCENDING
***                   hora_fim DESCENDING.
***    DELETE ADJACENT DUPLICATES FROM lt_031 COMPARING  aufnr vornr suboper usuario.
***
***    DATA(lt_ordens) = lt_tb026.
***    SORT lt_ordens BY aufnr ASCENDING.
***    DELETE ADJACENT DUPLICATES FROM lt_ordens COMPARING aufnr.
***
**** Seleciona Ordens
***    IF lt_ordens[] IS NOT INITIAL.
***
**** Caso não tenha prreenchido o filtro de data e só tenha um usuário no filtro, carrega o filtro configurado de data
***      IF rt_gstrp[] IS INITIAL.
***        DESCRIBE TABLE rt_usuario_app LINES DATA(lv_qtd_usu).
***        IF lv_qtd_usu = 1.
***          READ TABLE rt_usuario_app INTO DATA(ls_usuario_app) INDEX 1.
***          IF ls_usuario_app-sign = 'I' AND ls_usuario_app-option = 'EQ'.
***            lv_usuario = ls_usuario_app-low.
***            DATA(rt_data_conf_usuario) = me->out_monta_range_data_usuario( lv_usuario ).
***          ENDIF.
***        ENDIF.
***      ENDIF.
***
***      IF rt_gstrp[] IS NOT INITIAL AND rt_data_conf_usuario[] IS INITIAL.
****        SELECT aufnr, auart, objnr, iwerk
****          FROM viaufks
****          INTO TABLE @DATA(lt_viaufks)
****          FOR ALL ENTRIES IN @lt_ordens
****          WHERE aufnr EQ @lt_ordens-aufnr
****            AND auart IN @rt_auart
****            AND iwerk IN @rt_iwerk
****            AND ingpr IN @rt_ingpr
****            AND beber IN @rt_beber
****            AND gewrk IN @rt_arbpl
****            AND eqfnr IN @rt_eqfnr
****            AND gstrp IN @rt_gstrp.
***
***        SELECT a~aufnr, a~auart, a~objnr, a~iwerk
***          FROM viaufks AS a INNER JOIN afko AS b ON a~aufnr = b~aufnr
***          INNER JOIN afvc AS c ON b~aufpl = c~aufpl
***          INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
***          INTO TABLE @DATA(lt_viaufks)
***          FOR ALL ENTRIES IN @lt_ordens
***          WHERE a~aufnr EQ @lt_ordens-aufnr
***            AND a~auart IN @rt_auart
***            AND a~iwerk IN @rt_iwerk
***            AND a~ingpr IN @rt_ingpr
***            AND a~beber IN @rt_beber
***            AND a~gewrk IN @rt_arbpl
***            AND a~eqfnr IN @rt_eqfnr
***            AND ( d~fsavd IN @rt_gstrp OR d~fsedd IN @rt_gstrp ).
****            AND a~gstrp IN @rt_gstrp.
***
***      ELSE.
***        SELECT a~aufnr, a~auart, a~objnr, a~iwerk
***          FROM viaufks AS a INNER JOIN afko AS b ON a~aufnr = b~aufnr
***          INNER JOIN afvc AS c ON b~aufpl = c~aufpl
***          INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
***          INTO TABLE @lt_viaufks
***          FOR ALL ENTRIES IN @lt_ordens
***          WHERE a~aufnr EQ @lt_ordens-aufnr
***            AND a~auart IN @rt_auart
***            AND a~iwerk IN @rt_iwerk
***            AND a~ingpr IN @rt_ingpr
***            AND a~beber IN @rt_beber
***            AND a~gewrk IN @rt_arbpl
***            AND a~eqfnr IN @rt_eqfnr
***            AND ( d~fsavd IN @rt_data_conf_usuario OR d~fsedd IN @rt_data_conf_usuario ).
****            AND a~gstrp IN @rt_data_conf_usuario.
***      ENDIF.
***    ENDIF.
***
**** Verifica se Ordem foi encontrada
***    IF lt_viaufks[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca dados da Chave de controle - operação
***    SELECT plnaw, steus, ruek
***      FROM t430
***      INTO TABLE @DATA(lt_t430).
***
**** Busca OBJNR das Operações/SubOperações
***    SELECT a~aufnr, b~aufpl, b~aplzl, b~vornr, b~sumnr, b~objnr
***      FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
***      INTO TABLE @DATA(lt_afvc)
***      FOR ALL ENTRIES IN @lt_ordens
***      WHERE a~aufnr = @lt_ordens-aufnr
***        AND b~phflg = @space.
***
**** Busca descrição Centro de planejamento de manutenção
***    SELECT werks, name1
***      FROM t001w
***      INTO TABLE @DATA(lt_t001w)
***      FOR ALL ENTRIES IN @lt_viaufks
***      WHERE werks = @lt_viaufks-iwerk.
***
**** Busca configuração do sistema
***    SELECT SINGLE anexo_ordem, anexo_locl, anexo_equi
***      FROM /ptloms/tb033
***      INTO @DATA(ls_033).
***
***** Busca idioma do usuário
****  sy-langu = /ptloms/cl001=>out_idioma_usuario( sy-uname ).
***
**** Busca descrições do Status Mobile
***    CALL FUNCTION 'GET_DOMAIN_VALUES'
***      EXPORTING
***        domname         = '/PTLOMS/DM007'
***        text            = 'X'
***      TABLES
***        values_tab      = lt_values_tab
***      EXCEPTIONS
***        no_values_found = 1
***        OTHERS          = 2.
***
**** Busca perfil do usuário
***    SELECT SINGLE perfil FROM /ptloms/tb013 INTO @DATA(lv_perfil) WHERE usuario = @lv_usuario.
***    IF sy-subrc EQ 0.
**** Busca autorizações do Perfil
***      SELECT SINGLE autorizacao FROM /ptloms/tb043 INTO @DATA(lv_autorizacao) WHERE perfil = @lv_perfil AND autorizacao = '08'.
***      IF sy-subrc EQ 0 AND lv_autorizacao = '08'.
***        lv_atribuir_oper = 'X'.
***      ENDIF.
***    ENDIF.
***
***** Busca configuração do sistema
****    SELECT SINGLE atribuir_oper FROM /ptloms/tb033 INTO @DATA(lv_atribuir_oper).
***
***** Busca configuração do sistema
****    SELECT SINGLE atribuir_oper calc_trab_real FROM /ptloms/tb033 INTO ( lv_atribuir_oper , lv_calc_trab_real ).
***
**** Busca configuração do sistema
***    SELECT SINGLE calc_trab_real FROM /ptloms/tb033 INTO lv_calc_trab_real.
***
**** Busca configurações dos semáforos
***    SELECT *
***      FROM /ptloms/tb034
***      INTO TABLE @DATA(lt_034)
***      FOR ALL ENTRIES IN @lt_viaufks
***      WHERE auart = @lt_viaufks-auart.
***
**** Melhoria Performance - Início
***    DESCRIBE TABLE lt_viaufks LINES ex_quantidade_ordem.
**** Melhoria Performance - Fim
***
***    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
***      EXPORTING
***        input  = c_ag
***      IMPORTING
***        output = lv_parvw.
***
***    " 25/05/2023
***    " Informar se catálogo é obrigatório ou opcional
***    SELECT * FROM
***      /ptloms/tb022
***      INTO TABLE @DATA(lt_022).
***
****    SELECT objnr, parvw, counter, parnr
****      FROM ihpa
****      INTO TABLE @DATA(lt_ihpa)
****      FOR ALL ENTRIES IN @lt_viaufks
****      WHERE objnr    = @lt_viaufks-objnr
****        AND parvw    = @lv_parvw
****        AND kzloesch = @space.
****    IF lt_ihpa[] IS NOT INITIAL.
****      SORT lt_ihpa BY objnr parvw parnr.
***** Busca Equipamentos do Cliente
****      SELECT objnr, parvw, counter, parnr
****        FROM ihpa
****        INTO TABLE @DATA(lt_ihpa_parceiro)
****        FOR ALL ENTRIES IN @lt_ihpa
****        WHERE parvw    = @lv_parvw
****          AND obtyp    = @c_ieq
****          AND parnr    = @lt_ihpa-parnr
****          AND kzloesch = @space.
****      SORT lt_ihpa_parceiro BY parnr.
****    ENDIF.
***
**** Monta Tabelas de Saída
***    LOOP AT lt_viaufks INTO DATA(ls_viaufks).
***
**** Melhoria Performance - Início
***      DATA(lv_tabix_aux) = sy-tabix.
***      IF im_top > 0.
***        IF lv_tabix_aux <= im_skip.
***          CONTINUE.
***        ENDIF.
***
***        lv_quantidade_ordem = lv_quantidade_ordem + 1.
***        IF lv_quantidade_ordem > im_top.
***          EXIT.
***        ENDIF.
***      ENDIF.
**** Melhoria Performance - Fim
***
***      lv_objnr = ls_viaufks-objnr.
***
***      CLEAR lv_desprezar.
***      CALL FUNCTION '/PTLOMS/MF008'
***        EXPORTING
***          im_objnr     = lv_objnr
***        IMPORTING
***          ex_desprezar = lv_desprezar.
***
***      IF lv_desprezar = 'X'.
***        CONTINUE.
***      ENDIF.
***
**** Limpa estrutura
***      CLEAR ls_ordem.
***
**** Atribui OBJNR
***      ls_ordem-objnr = ls_viaufks-objnr.
***
**** Limpa variáveis referentes à BAPI
***      CLEAR: lv_number, ls_header.
***      REFRESH: lt_partner[], lt_operations[], lt_components[],
***               lt_text_lines[], lt_return[], lt_texts[].
***
***      lv_number = |{ ls_viaufks-aufnr ALPHA = IN }|.
***
***      CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
***        EXPORTING
***          number        = lv_number
***        IMPORTING
***          es_header     = ls_header
***        TABLES
***          et_partner    = lt_partner
***          et_operations = lt_operations
***          et_components = lt_components
***          et_texts      = lt_texts
***          et_text_lines = lt_text_lines
***          return        = lt_return.
***
**** Verifica se status de sistema da nota está contido no critério de seleção
***      REFRESH lt_status[].
***      CLEAR lv_status_true.
***      IF rt_sttxt IS NOT INITIAL.
***        SPLIT ls_header-sys_status AT ' ' INTO TABLE lt_status.
***        LOOP AT lt_status INTO DATA(ls_status).
***          IF ls_status IN rt_sttxt.
***            lv_status_true = 'X'.
***            EXIT.
***          ENDIF.
***        ENDLOOP.
***        IF lv_status_true IS INITIAL.
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
**** Verifica se status de usuário da nota está contido no critério de seleção
***      REFRESH lt_status[].
***      CLEAR lv_status_true.
***      IF rt_asttx IS NOT INITIAL.
***        SPLIT ls_header-userstatus AT ' ' INTO TABLE lt_status.
***        LOOP AT lt_status INTO ls_status.
***          IF ls_status IN rt_asttx.
***            lv_status_true = 'X'.
***            EXIT.
***          ENDIF.
***        ENDLOOP.
***        IF lv_status_true IS INITIAL.
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
**** Verifica se parceiro está contido no critério de seleção
***      CLEAR lv_partner_true.
***      IF rt_parnr[] IS NOT INITIAL.
***        LOOP AT lt_partner INTO DATA(ls_partner).
***          ls_partner-partner = |{ ls_partner-partner ALPHA = IN }|.
***          IF ls_partner-partner IN rt_parnr.
***            lv_partner_true = 'X'.
***            EXIT.
***          ENDIF.
***        ENDLOOP.
***        IF lv_partner_true IS INITIAL.
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
**** Atribui campos correspondentes da Ordem
***      MOVE-CORRESPONDING ls_header TO ls_ordem.
***
**** Descrição do Centro de planejamento
***      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = ls_header-planplant.
***      IF sy-subrc EQ 0.
***        ls_ordem-desc_planplant = ls_t001w-name1.
***      ENDIF.
***
**** Carrega textos da Ordem
***      READ TABLE lt_texts INTO DATA(ls_texts) WITH KEY activity = space.
***      LOOP AT lt_text_lines INTO DATA(ls_text_lines).
***        DATA(lv_tabix) = sy-tabix.
***        IF lv_tabix > ls_texts-textend.
***          EXIT.
***        ENDIF.
***        CLEAR ls_textos_ordem.
***        MOVE-CORRESPONDING ls_text_lines TO ls_textos_ordem.
***        ls_textos_ordem-orderid  = ls_ordem-orderid.
***        ls_textos_ordem-activity = ls_texts-activity.
***        APPEND ls_textos_ordem TO et_textos_ordem.
***
***        IF ls_textos_ordem-tdformat = '*' OR ls_textos_ordem-tdformat IS INITIAL.
***          DATA(lv_tdformat) = lv_quebra_linha.
***        ELSE.
****          lv_tdformat = |<>|.
***        ENDIF.
***
***        IF ls_ordem-texto_longo IS NOT INITIAL.
***          ls_ordem-texto_longo = ls_ordem-texto_longo && | | && lv_tdformat && ls_textos_ordem-tdline.
***        ELSE.
***          ls_ordem-texto_longo = ls_textos_ordem-tdline.
***        ENDIF.
***      ENDLOOP.
***
**** Carrega operações da Ordem
***      LOOP AT lt_operations INTO DATA(ls_operations).
***
***        IF rt_data_conf_usuario[] IS NOT INITIAL.
***          IF ls_operations-earl_sched_start_date NOT IN rt_data_conf_usuario.
***            CONTINUE.
***          ENDIF.
***        ENDIF.
***
***        CLEAR lv_outro_titular.
***
**** Verifica se Operação foi despachada para Usuário e/ou se foi Inciada no Dispositivo
***        READ TABLE lt_031 INTO DATA(ls_031) WITH KEY aufnr = ls_viaufks-aufnr
***                                                     vornr = ls_operations-activity.
***        IF sy-subrc NE 0.
****          CONTINUE.
***          lv_outro_titular = 'X'.
***        ELSE.
***          READ TABLE lt_031_outro_titular INTO DATA(ls_031_outro_titular) WITH KEY aufnr = ls_viaufks-aufnr
***                                                                                   vornr = ls_operations-activity.
***          IF sy-subrc EQ 0.
***            lv_outro_titular = 'X'.
***          ELSE.
***            IF ls_031-inativo = 'X'.
***              CONTINUE.
***            ENDIF.
***            IF ls_operations-sub_activity NE ls_031-suboper.
****            CONTINUE.
***              lv_outro_titular = 'X'.
***            ENDIF.
***          ENDIF.
***        ENDIF.
***
**** Busca OBJNR da Operação
***        IF ls_operations-sub_activity IS INITIAL.
***          READ TABLE lt_afvc INTO DATA(ls_afvc) WITH KEY aufnr = ls_viaufks-aufnr
***                                                         vornr = ls_operations-activity
***                                                         sumnr = space.
***        ELSE.
***          READ TABLE lt_afvc INTO DATA(ls_afvc_aux) WITH KEY aufnr = ls_viaufks-aufnr
***                                                             vornr = ls_operations-activity
***                                                             sumnr = space.
***          READ TABLE lt_afvc INTO ls_afvc WITH KEY aufnr = ls_viaufks-aufnr
***                                                   vornr = ls_operations-sub_activity
***                                                   sumnr = ls_afvc_aux-aplzl.
***        ENDIF.
***
**** Se não encontrar na AFVC não levar para o APP
***        IF ls_afvc IS INITIAL.
***          CONTINUE.
***        ENDIF.
***
***        lv_objnr = ls_afvc-objnr.
***        CLEAR ls_afvc.
***
***        CLEAR lv_desprezar.
***        CALL FUNCTION '/PTLOMS/MF008'
***          EXPORTING
***            im_objnr     = lv_objnr
***          IMPORTING
***            ex_desprezar = lv_desprezar.
***
***        IF lv_desprezar = 'X'.
***          CONTINUE.
***        ENDIF.
***
***        DATA(lv_tabix_ope) = sy-tabix.
***        CLEAR ls_operacoes_ordem.
***        MOVE-CORRESPONDING ls_operations TO ls_operacoes_ordem.
***        ls_operacoes_ordem-orderid = ls_ordem-orderid.
***        IF ls_operations-plant IS NOT INITIAL.
***          SELECT SINGLE name1 FROM t001w INTO ls_operacoes_ordem-name1 WHERE werks = ls_operations-plant.
***        ENDIF.
***        IF ls_operations-pers_no IS NOT INITIAL.
***          SELECT SINGLE sname FROM pa0001 INTO ls_operacoes_ordem-sname WHERE pernr = ls_operations-pers_no.
***        ENDIF.
***
**** Carrega textos das Operações
***        LOOP AT lt_texts INTO ls_texts WHERE activity     EQ ls_operations-activity
***                                         AND sub_activity EQ ls_operations-sub_activity.
***          LOOP AT lt_text_lines INTO ls_text_lines.
***            lv_tabix = sy-tabix.
***            IF lv_tabix BETWEEN ls_texts-textstart AND ls_texts-textend.
***              CLEAR ls_textos_operacoes.
***              MOVE-CORRESPONDING ls_text_lines TO ls_textos_operacoes.
***              ls_textos_operacoes-orderid      = ls_ordem-orderid.
***              ls_textos_operacoes-activity     = ls_texts-activity.
***              ls_textos_operacoes-sub_activity = ls_texts-sub_activity.
***              APPEND ls_textos_operacoes TO et_textos_operacoes.
***
***              IF ls_textos_operacoes-tdformat = '*' OR ls_textos_operacoes-tdformat IS INITIAL.
***                lv_tdformat = lv_quebra_linha.
***              ELSE.
****                lv_tdformat = |<>|.
***              ENDIF.
***
***              IF ls_operacoes_ordem-texto_longo IS NOT INITIAL.
***                ls_operacoes_ordem-texto_longo = ls_operacoes_ordem-texto_longo && | | && lv_tdformat && ls_textos_operacoes-tdline.
***              ELSE.
***                ls_operacoes_ordem-texto_longo = ls_textos_operacoes-tdline.
***              ENDIF.
***
***            ENDIF.
***          ENDLOOP.
***        ENDLOOP.
***
**** Carrega Status Mobile da Operãção
***        IF lv_outro_titular = 'X'.
***          ls_operacoes_ordem-status_mobile = 9.
***        ELSE.
***          READ TABLE lt_t430 TRANSPORTING NO FIELDS WITH KEY steus = ls_operations-control_key
***                                                             ruek  = '3'.
***          IF sy-subrc EQ 0.
***            ls_operacoes_ordem-status_mobile = 6.
***          ELSE.
***            ls_operacoes_ordem-status_mobile = 1.
***          ENDIF.
***        ENDIF.
***
***        ls_operacoes_ordem-calc_trab_real = lv_calc_trab_real.
***
***        APPEND ls_operacoes_ordem TO et_operacoes_ordem.
***
**** Carrega Confirmações da Operação - Início
***        SELECT rueck, rmzhl
***          FROM afru
***          INTO TABLE @DATA(lt_afru)
***          WHERE rueck  EQ @ls_operacoes_ordem-conf_no
***             AND pernr EQ @ls_operacoes_ordem-pers_no
***             AND stokz NE 'X'                           "GBE - 27/04 - Ajuste efetuado em 27/04 visando desconsiderar os registros estornados da seleção
***             AND stzhl EQ '00000000'.                   "GBE - 27/04 - Ajuste efetuado em 27/04 visando desconsiderar os registros estornados da seleção
****            AND ernam IN @rt_usuario_app.
***
***        IF sy-subrc EQ 0.
***          LOOP AT lt_afru INTO DATA(ls_afru).
***
***            CLEAR: ls_return_conf, ls_conf_detail.
***            CALL FUNCTION 'BAPI_ALM_CONF_GETDETAIL'
***              EXPORTING
***                confirmation        = ls_afru-rueck
***                confirmationcounter = ls_afru-rmzhl
***              IMPORTING
***                return              = ls_return_conf
***                conf_detail         = ls_conf_detail.
***
***            IF ls_conf_detail IS NOT INITIAL.
***              CLEAR ls_confirmacoes.
***
***              IF ls_conf_detail-exec_start_time = space. "GBE - 27/04 - Ajuste efetuado em 27/04 em função de erro ocorrido na Andina por deixar a hora de início em branco.
***                ls_conf_detail-exec_start_time = '000000'.
***              ENDIF.
***
***              IF ls_conf_detail-exec_fin_time = space.   "GBE - 27/04 - Ajuste efetuado em 27/04 em função de erro ocorrido na Andina por deixar as hora fim em branco.
***                ls_conf_detail-exec_fin_time = '000000'.
***              ENDIF.
***
***              MOVE-CORRESPONDING ls_conf_detail TO ls_confirmacoes.
***
***              IF NOT ls_conf_detail-exec_fin_date IN rt_data_conf_usuario.
***                CONTINUE.
***              ENDIF.
***
***              ls_confirmacoes-activity     = ls_conf_detail-operation.
***              ls_confirmacoes-sub_activity = ls_conf_detail-sub_oper.
***
***              IF ls_conf_detail-fin_conf IS NOT INITIAL.
***                ls_confirmacoes-complete = abap_true.
***              ELSE.
***                ls_confirmacoes-complete = abap_false.
***              ENDIF.
***
***              CLEAR: lv_data, lv_hora.
***              lv_data = ls_conf_detail-exec_start_date.
***              lv_hora = ls_conf_detail-exec_start_time.
***              ls_confirmacoes-data_hora_inicio = lv_data+6(2) && |/| &&
***                                                 lv_data+4(2) && |/| &&
***                                                 lv_data(4)   && | | &&
***                                                 lv_hora(2)   && |:| &&
***                                                 lv_hora+2(2) && |:| &&
***                                                 lv_hora+4(2).
***
***              CLEAR: lv_data, lv_hora.
***              lv_data = ls_conf_detail-exec_fin_date.
***              lv_hora = ls_conf_detail-exec_fin_time.
***              ls_confirmacoes-data_hora_fim = lv_data+6(2) && |/| &&
***                                              lv_data+4(2) && |/| &&
***                                              lv_data(4)   && | | &&
***                                              lv_hora(2)   && |:| &&
***                                              lv_hora+2(2) && |:| &&
***                                              lv_hora+4(2).
***
***              CLEAR lv_nome.
***              lv_nome = sy-mandt && ls_afru-rueck && ls_afru-rmzhl.
***
***              REFRESH lt_txt_read[].
***              CALL FUNCTION 'READ_TEXT'
***                EXPORTING
***                  id        = 'RMEL'
***                  language  = sy-langu
***                  name      = lv_nome
***                  object    = 'AUFK'
***                TABLES
***                  lines     = lt_txt_read
***                EXCEPTIONS
***                  not_found = 1.
***
***              LOOP AT lt_txt_read INTO DATA(ls_txt_read).
***                IF ls_confirmacoes-texto_longo IS INITIAL.
***                  ls_confirmacoes-texto_longo = ls_txt_read-tdline.
***                ELSE.
***                  ls_confirmacoes-texto_longo = ls_confirmacoes-texto_longo && lv_quebra_linha && ls_txt_read-tdline.
***                ENDIF.
***              ENDLOOP.
***
***              APPEND ls_confirmacoes TO et_confirmacoes.
***            ENDIF.
***          ENDLOOP.
***        ENDIF.
**** Carrega Confirmações da Operação - Fim
***
**** Carrega Filtro da Operação - Status da Mobile
***        IF ls_operacoes_ordem-status_mobile IS NOT INITIAL.
***          READ TABLE ls_ordem-et_filtro_op_status_mobile ASSIGNING FIELD-SYMBOL(<fs_filtro_op>) WITH KEY key = ls_operacoes_ordem-status_mobile.
***          IF sy-subrc NE 0.
***            CLEAR lv_val_dominio.
***            lv_val_dominio = ls_operacoes_ordem-status_mobile.
***            CONDENSE lv_val_dominio NO-GAPS.
***            READ TABLE lt_values_tab INTO DATA(ls_values_tab) WITH KEY domvalue_l = lv_val_dominio.
***            CLEAR ls_filtro.
***            ls_filtro-key   = ls_operacoes_ordem-status_mobile.
***            ls_filtro-text  = ls_values_tab-ddtext.
***            ls_filtro-count = 1.
***            APPEND ls_filtro TO ls_ordem-et_filtro_op_status_mobile.
***          ELSE.
***            <fs_filtro_op>-count = <fs_filtro_op>-count + 1.
***          ENDIF.
***        ENDIF.
***
**** Carrega Filtro da Operação - Operação
***        IF ls_operacoes_ordem-orderid      IS NOT INITIAL AND
***           ls_operacoes_ordem-activity     IS NOT INITIAL AND
***           ls_operacoes_ordem-sub_activity IS INITIAL.
***
***          READ TABLE ls_ordem-et_filtro_op_operacao ASSIGNING <fs_filtro_op> WITH KEY key = ls_operacoes_ordem-activity.
***          IF sy-subrc NE 0.
***            CLEAR ls_filtro.
***            ls_filtro-key   = ls_operacoes_ordem-activity.
***            ls_filtro-text  = ls_operacoes_ordem-description.
***            ls_filtro-count = 1.
***            APPEND ls_filtro TO ls_ordem-et_filtro_op_operacao.
***          ELSE.
***            <fs_filtro_op>-count = <fs_filtro_op>-count + 1.
***          ENDIF.
***        ENDIF.
***
***** Carrega Filtro da Operação - SubOperação
****        IF ls_operacoes_ordem-orderid      IS NOT INITIAL AND
****           ls_operacoes_ordem-activity     IS NOT INITIAL AND
****           ls_operacoes_ordem-sub_activity IS NOT INITIAL.
****
****          READ TABLE ls_ordem-et_filtro_op_sub_operacao ASSIGNING <fs_filtro_op> WITH KEY key = ls_operacoes_ordem-sub_activity.
****          IF sy-subrc NE 0.
****            CLEAR ls_filtro.
****            ls_filtro-key   = ls_operacoes_ordem-sub_activity.
****            ls_filtro-text  = ls_operacoes_ordem-description.
****            ls_filtro-count = 1.
****            APPEND ls_filtro TO ls_ordem-et_filtro_op_sub_operacao.
****          ELSE.
****            <fs_filtro_op>-count = <fs_filtro_op>-count + 1.
****          ENDIF.
****        ENDIF.
***
**** Carrega Filtro da Operação - Empregado
***        IF ls_operacoes_ordem-pers_no IS NOT INITIAL.
***          READ TABLE ls_ordem-et_filtro_op_empregado ASSIGNING <fs_filtro_op> WITH KEY key = ls_operacoes_ordem-pers_no.
***          IF sy-subrc NE 0.
***            IF ls_operacoes_ordem-pers_no IS NOT INITIAL.
***              SELECT SINGLE sname FROM pa0001 INTO @DATA(lv_sname) WHERE pernr = @ls_operacoes_ordem-pers_no.
***            ENDIF.
***            CLEAR ls_filtro.
***            ls_filtro-key   = ls_operacoes_ordem-pers_no.
***            ls_filtro-text  = lv_sname.
***            ls_filtro-count = 1.
***            APPEND ls_filtro TO ls_ordem-et_filtro_op_empregado.
***            CLEAR lv_sname.
***          ELSE.
***            <fs_filtro_op>-count = <fs_filtro_op>-count + 1.
***          ENDIF.
***        ENDIF.
***
**** Carrega Filtro da Operação - Centro de Trabalho
***        IF ls_operacoes_ordem-work_cntr IS NOT INITIAL.
***          READ TABLE ls_ordem-et_filtro_op_centro_trabalho ASSIGNING <fs_filtro_op> WITH KEY key = ls_operacoes_ordem-work_cntr.
***          IF sy-subrc NE 0.
***            CLEAR ls_filtro.
***            ls_filtro-key   = ls_operacoes_ordem-work_cntr.
***            ls_filtro-text  = ls_operacoes_ordem-work_cntr.
***            ls_filtro-count = 1.
***            APPEND ls_filtro TO ls_ordem-et_filtro_op_centro_trabalho.
***            CLEAR lv_sname.
***          ELSE.
***            <fs_filtro_op>-count = <fs_filtro_op>-count + 1.
***          ENDIF.
***        ENDIF.
***      ENDLOOP.
***
**** Recupera PERS_NO do usuário
***
***      IF lv_usuario IS NOT INITIAL.
***        SELECT matricula
***          FROM /ptloms/tb013
***          INTO @DATA(lv_matricula)
***          WHERE usuario EQ @lv_usuario.
***        ENDSELECT.
***
**** Verifica se há alguma Operação da ordem
***        READ TABLE et_operacoes_ordem TRANSPORTING NO FIELDS WITH KEY orderid = ls_viaufks-aufnr pers_no = lv_matricula.
***        IF sy-subrc NE 0.
***          CONTINUE.
***        ENDIF.
***
***      ELSE.
**** Verifica se há alguma Operação da ordem
***        READ TABLE et_operacoes_ordem TRANSPORTING NO FIELDS WITH KEY orderid = ls_viaufks-aufnr.
***        IF sy-subrc NE 0.
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
**** Carrega componentes da Ordem
***      LOOP AT lt_components INTO DATA(ls_components) WHERE delete_ind = space.
***
**** Verifica se Operação associada ao Componente foi considera na seleção de Operações
***        READ TABLE et_operacoes_ordem TRANSPORTING NO FIELDS WITH KEY orderid  = ls_viaufks-aufnr
***                                                                      activity = ls_components-activity.
***        IF sy-subrc NE 0.
***          CONTINUE.
***        ENDIF.
***
**** Verifica se Operação foi despachada para Usuário e/ou se está Foi Inciada no Dispositivo
***        READ TABLE lt_031 INTO ls_031 WITH KEY aufnr = ls_viaufks-aufnr
***                                               vornr = ls_components-activity.
***        IF sy-subrc NE 0.
***          CONTINUE.
***        ELSE.
***          IF ls_031-inativo = 'X'.
***            CONTINUE.
***          ENDIF.
***          IF ls_031-suboper IS NOT INITIAL.
***            CONTINUE.
***          ENDIF.
***        ENDIF.
***
***        CLEAR ls_componentes_ordem.
***        MOVE-CORRESPONDING ls_components TO ls_componentes_ordem.
***        SHIFT ls_componentes_ordem-reserv_no LEFT DELETING LEADING '0'.
***        SHIFT ls_componentes_ordem-res_item  LEFT DELETING LEADING '0'.
***        ls_componentes_ordem-reserva_item = ls_componentes_ordem-reserv_no && |/| && ls_componentes_ordem-res_item.
***        ls_componentes_ordem-orderid = ls_ordem-orderid.
***        IF ls_components-material IS NOT INITIAL.
***          SELECT SINGLE maktx FROM makt INTO ls_componentes_ordem-maktx WHERE matnr = ls_components-material AND spras = sy-langu.
***        ENDIF.
***        IF ls_components-plant IS NOT INITIAL.
***          SELECT SINGLE name1 FROM t001w INTO ls_componentes_ordem-name1 WHERE werks = ls_components-plant.
***        ENDIF.
***        IF ls_components-plant IS NOT INITIAL AND ls_components-stge_loc IS NOT INITIAL.
***          SELECT SINGLE lgobe FROM t001l INTO ls_componentes_ordem-lgobe WHERE werks = ls_components-plant AND lgort = ls_components-stge_loc.
***        ENDIF.
***
**** Busca estoque do Material do Componente
***        IF ls_components-material IS NOT INITIAL.
***          CLEAR ls_matnr.
***          ls_matnr-sign = 'I'.
***          ls_matnr-option = 'EQ'.
***          ls_matnr-low = ls_components-material.
***          APPEND ls_matnr TO rt_matnr.
***
***          IF ls_components-plant IS NOT INITIAL.
***            CLEAR ls_werks.
***            ls_werks-sign = 'I'.
***            ls_werks-option = 'EQ'.
***            ls_werks-low = ls_components-plant.
***            APPEND ls_werks TO rt_werks.
***
***            IF ls_components-stge_loc IS NOT INITIAL.
***              CLEAR ls_lgort.
***              ls_lgort-sign = 'I'.
***              ls_lgort-option = 'EQ'.
***              ls_lgort-low = ls_components-stge_loc.
***              APPEND ls_lgort TO rt_lgort.
***            ENDIF.
***
***            REFRESH lt_saldo_material[].
***            me->out_estoque_material(
***              EXPORTING
***                rt_matnr = rt_matnr
***                rt_werks = rt_werks
***                rt_lgort = rt_lgort
***              IMPORTING
***                et_saldo = lt_saldo_material ).
***
***            READ TABLE lt_saldo_material INTO DATA(ls_saldo_material) INDEX 1.
***            ls_componentes_ordem-labst = ls_saldo_material-labst.
***          ENDIF.
***        ENDIF.
***
**** Converte Unidade de Medida
***        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
***          EXPORTING
***            input          = ls_componentes_ordem-requirement_quantity_unit
***            language       = sy-langu
***          IMPORTING
***            output         = ls_componentes_ordem-requirement_quantity_unit
***          EXCEPTIONS
***            unit_not_found = 1
***            OTHERS         = 2.
***
***        APPEND ls_componentes_ordem TO et_componentes_ordem.
***      ENDLOOP.
***
**** Carrega imagens da Ordem
***      IF ls_033-anexo_ordem = 'X'.
***        CLEAR: ls_instid_a, ls_typeid_a.
***        REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.
***
***        ls_instid_a-sign = 'I'.
***        ls_instid_a-option = 'EQ'.
***        ls_instid_a-low = ls_viaufks-aufnr.
***        APPEND ls_instid_a TO r_instid_a.
***
***        ls_typeid_a-sign = 'I'.
***        ls_typeid_a-option = 'EQ'.
***        ls_typeid_a-low = 'BUS2007'.
***        APPEND ls_typeid_a TO r_typeid_a.
***
***        lt_anexo = me->out_imagem( rt_instid_a = r_instid_a
***                                   rt_typeid_a = r_typeid_a ).
***
***        IF lt_anexo[] IS NOT INITIAL.
***          APPEND LINES OF lt_anexo TO et_imagens_ordem.
***        ENDIF.
***      ENDIF.
***
**** Carrega imagens do Equipamento associado a ordem
***      IF ls_033-anexo_equi = 'X'.
***        IF ls_header-equipment IS NOT INITIAL.
***          CLEAR: ls_instid_a, ls_typeid_a.
***          REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.
***
***          ls_instid_a-sign = 'I'.
***          ls_instid_a-option = 'EQ'.
***          ls_instid_a-low = ls_header-equipment.
***          APPEND ls_instid_a TO r_instid_a.
***
***          ls_typeid_a-sign = 'I'.
***          ls_typeid_a-option = 'EQ'.
***          ls_typeid_a-low = 'EQUI'.
***          APPEND ls_typeid_a TO r_typeid_a.
***
***          lt_anexo = me->out_imagem( rt_instid_a = r_instid_a
***                                     rt_typeid_a = r_typeid_a ).
***
***          IF lt_anexo[] IS NOT INITIAL.
***            LOOP AT lt_anexo ASSIGNING FIELD-SYMBOL(<fs_anexo>).
***              <fs_anexo>-instid_a = ls_viaufks-aufnr.
***            ENDLOOP.
***            APPEND LINES OF lt_anexo TO et_imagens_ordem.
***          ENDIF.
***        ENDIF.
***      ENDIF.
***
**** Carrega imagens do Local de Instalação
***      IF ls_033-anexo_locl = 'X'.
***        IF ls_header-funct_loc IS NOT INITIAL.
***          CLEAR: ls_instid_a, ls_typeid_a.
***          REFRESH: r_instid_a[], r_typeid_a[], lt_anexo.
***
***          ls_instid_a-sign = 'I'.
***          ls_instid_a-option = 'EQ'.
***          ls_instid_a-low = ls_header-funct_loc.
***          APPEND ls_instid_a TO r_instid_a.
***
***          ls_typeid_a-sign = 'I'.
***          ls_typeid_a-option = 'EQ'.
***          ls_typeid_a-low = 'BUS0010'.
***          APPEND ls_typeid_a TO r_typeid_a.
***
***          lt_anexo = me->out_imagem( rt_instid_a = r_instid_a
***                                     rt_typeid_a = r_typeid_a ).
***
***          IF lt_anexo[] IS NOT INITIAL.
***            LOOP AT lt_anexo ASSIGNING <fs_anexo>.
***              <fs_anexo>-instid_a = ls_viaufks-aufnr.
***            ENDLOOP.
***            APPEND LINES OF lt_anexo TO et_imagens_ordem.
***          ENDIF.
***        ENDIF.
***      ENDIF.
***
**** Carrega descrições
***      IF ls_ordem-notif_no IS NOT INITIAL.
***        SELECT SINGLE qmart qmtxt FROM qmel INTO ( ls_ordem-qmart, ls_ordem-qmtxt ) WHERE qmnum = ls_ordem-notif_no.
***      ENDIF.
***      IF ls_ordem-funct_loc IS NOT INITIAL.
***        SELECT SINGLE pltxt FROM iflotx INTO ls_ordem-pltxt WHERE tplnr = ls_ordem-funct_loc AND spras = sy-langu.
***      ENDIF.
***      IF ls_ordem-equipment IS NOT INITIAL.
***        SELECT SINGLE eqktx FROM eqkt INTO ls_ordem-eqktx WHERE equnr = ls_ordem-equipment AND spras = sy-langu.
***        SELECT SINGLE tidnr rbnr FROM equz INTO ( ls_ordem-tidnr, ls_ordem-rbnr_equipment ) WHERE equnr = ls_ordem-equipment
***                                                            AND datbi = '99991231'.
****        SELECT tplnr UP TO 1 ROWS FROM v_equi INTO ( ls_ordem-funct_loc_equipemnt ) WHERE equnr = ls_ordem-equipment. ENDSELECT.
****        IF sy-subrc IS INITIAL.
****          SELECT SINGLE pltxt FROM iflotx INTO ( ls_ordem-pltxt_equipamento ) WHERE tplnr = ls_ordem-funct_loc_equipemnt AND spras = sy-langu.
****        ENDIF.
***      ENDIF.
***      IF ls_ordem-plangroup IS NOT INITIAL.
***        SELECT SINGLE innam FROM t024i INTO ls_ordem-innam WHERE ingrp = ls_ordem-plangroup.
***      ENDIF.
***      IF ls_ordem-mn_wkctr_id IS NOT INITIAL.
***        SELECT SINGLE arbpl FROM crhd INTO ls_ordem-arbpl WHERE objid = ls_ordem-mn_wkctr_id.
***      ENDIF.
***      IF ls_ordem-priotype IS NOT INITIAL AND ls_ordem-priority IS NOT INITIAL.
***        SELECT SINGLE priokx FROM t356_t INTO ls_ordem-priokx WHERE spras = sy-langu AND artpr = ls_ordem-priotype AND priok = ls_ordem-priority.
***      ENDIF.
***      IF ls_ordem-abcindic IS NOT INITIAL.
***        SELECT SINGLE abctx FROM t370c_t INTO ls_ordem-abctx WHERE spras = sy-langu AND abckz = ls_ordem-abcindic.
***      ENDIF.
***      IF ls_ordem-comp_code IS NOT INITIAL.
***        SELECT SINGLE butxt FROM t001 INTO ls_ordem-butxt WHERE bukrs = ls_ordem-comp_code.
***      ENDIF.
***      IF ls_ordem-costcenter IS NOT INITIAL.
***        SELECT SINGLE ltext FROM cskt INTO ls_ordem-ltext WHERE spras = sy-langu AND kostl = ls_ordem-costcenter.
***      ENDIF.
***      IF ls_ordem-mntplan IS NOT INITIAL.
***        SELECT SINGLE wptxt FROM mpla INTO ls_ordem-wptxt WHERE warpl = ls_ordem-mntplan.
***      ENDIF.
***      IF ls_ordem-pmacttype IS NOT INITIAL.
***        SELECT SINGLE ilatx FROM t353i_t INTO ls_ordem-ilatx WHERE spras = sy-langu AND ilart = ls_ordem-pmacttype.
***      ENDIF.
**** Dados do cliente
***      IF ls_header-equipment IS NOT INITIAL.
***        " Dados do cliente da aba Dds. série
***        SELECT SINGLE kunnr FROM eqbs INTO ls_ordem-kunnr WHERE equnr = ls_header-equipment.
***        IF sy-subrc IS INITIAL.
***          SELECT SINGLE name1 name2 telf1 stras ort01 pstlz regio adrnr ort02 FROM kna1 INTO ( ls_ordem-name1, ls_ordem-name2, ls_ordem-telf1, ls_ordem-stras, ls_ordem-ort01, ls_ordem-pstlz, ls_ordem-regio, wa_address-adrnr, wa_address-ort02 ) WHERE
***kunnr = ls_ordem-kunnr.
***          IF sy-subrc IS INITIAL.
***            SELECT name1 street house_num1 UP TO 1 ROWS
***              FROM adrc
***              INTO ( ls_ordem-name1, ls_ordem-stras, wa_address-house_num1 )
***              WHERE addrnumber = wa_address-adrnr.
***            ENDSELECT.
***          ENDIF.
***          ls_ordem-stras = |{ ls_ordem-stras }| & |{ ',' }| & | | & |{ wa_address-house_num1 }| & | | & |{ '-' }| & | | & |{ wa_address-ort02 }| & | | & |{ '-' }| & | | & |{ ls_ordem-ort01 }|.
***        ELSE.
***          " Dados do cliente da aba parceiro
***          SELECT SINGLE objnr FROM equi
***            INTO @DATA(objnr)
***            WHERE equnr = @ls_header-equipment.
***          IF sy-subrc IS INITIAL.
***            SELECT objnr, parvw, counter, parnr UP TO 1 ROWS
***              FROM ihpa
***              INTO @DATA(ls_ihpa)
***           WHERE objnr    = @objnr
***             AND parvw    = @lv_parvw
***             AND kzloesch = @space.
***            ENDSELECT.
***            IF sy-subrc IS INITIAL.
**** Busca Equipamentos do Cliente
***              SELECT objnr, parvw, counter, parnr
***                FROM ihpa UP TO 1 ROWS
***                INTO @DATA(ls_ihpa_parceiro)
***                WHERE parvw    = @lv_parvw
***                  AND obtyp    = @c_ieq
***                  AND parnr    = @ls_ihpa-parnr
***                  AND kzloesch = @space.
***              ENDSELECT.
***              IF sy-subrc IS INITIAL.
***                SELECT SINGLE kunnr name1 name2 telf1 ort01 pstlz regio adrnr ort02
***                  FROM kna1
***                  INTO ( ls_ordem-kunnr, ls_ordem-name1, ls_ordem-name2, ls_ordem-telf1, ls_ordem-ort01, ls_ordem-pstlz, ls_ordem-regio, wa_address-adrnr, wa_address-ort02 )
***                  WHERE kunnr = ls_ihpa_parceiro-parnr.
***                " Buscar o endereço completo comn 60 caracteres da ADRC - 23/03/2023
***                IF sy-subrc IS INITIAL.
****                  IF ls_ordem-kunnr IS NOT INITIAL.
****                    ls_ordem-kunnr = |{ ls_ordem-kunnr ALPHA = OUT }|.
****                  ENDIF.
***                  SELECT name1 street house_num1 UP TO 1 ROWS
***                    FROM adrc
***                    INTO ( ls_ordem-name1, ls_ordem-stras, wa_address-house_num1 )
***                    WHERE addrnumber = wa_address-adrnr.
***                  ENDSELECT.
***                ENDIF.
***                ls_ordem-stras = |{ ls_ordem-stras }| & |{ ',' }| & | | & |{ wa_address-house_num1 }| & | | & |{ '-' }| & | | & |{ wa_address-ort02 }| & | | & |{ '-' }| & | | & |{ ls_ordem-ort01 }|.
***              ENDIF.
***            ENDIF.
***          ENDIF.
***        ENDIF.
***        CLEAR: wa_address.
***      ENDIF.
***
**** Carrega Filtro ORDERID
***      IF ls_ordem-orderid IS NOT INITIAL.
***        READ TABLE et_filtro_ordem ASSIGNING FIELD-SYMBOL(<fs_filtro>) WITH KEY key = ls_ordem-orderid.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-orderid ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-short_text.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_ordem.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro NOTIF_NO
***      IF ls_ordem-notif_no IS NOT INITIAL.
***        READ TABLE et_filtro_nota ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-notif_no.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-notif_no ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-qmtxt.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_nota.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro ORDER_TYPE
***      IF ls_ordem-order_type IS NOT INITIAL.
***        READ TABLE et_filtro_tipo_ordem ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-order_type.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = ls_ordem-order_type.
***          SELECT SINGLE txt FROM t003p INTO ls_filtro-text WHERE spras = sy-langu AND auart = ls_ordem-order_type.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_tipo_ordem.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro START_DATE
***      IF ls_ordem-start_date IS NOT INITIAL.
***        READ TABLE et_filtro_inicio_base ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-start_date.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = ls_ordem-start_date.
***          ls_filtro-text = ls_ordem-start_date.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_inicio_base.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro FINISH_DATE
***      IF ls_ordem-finish_date IS NOT INITIAL.
***        READ TABLE et_filtro_fim_base ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-finish_date.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = ls_ordem-finish_date.
***          ls_filtro-text = ls_ordem-finish_date.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_fim_base.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro FUNCT_LOC
***      IF ls_ordem-funct_loc IS NOT INITIAL.
***        READ TABLE et_filtro_local_instalacao ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-funct_loc.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-funct_loc ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-pltxt.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_local_instalacao.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro EQUIPMENT
***      IF ls_ordem-equipment IS NOT INITIAL.
***        READ TABLE et_filtro_equipamento ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-equipment.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-equipment ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-eqktx.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_equipamento.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro PLANGROUP
***      IF ls_ordem-plangroup IS NOT INITIAL.
***        READ TABLE et_filtro_grupo_planejamento ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-plangroup.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-plangroup ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-innam.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_grupo_planejamento.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro MN_WKCTR_ID
***      IF ls_ordem-mn_wkctr_id IS NOT INITIAL.
***        READ TABLE et_filtro_centro_trabalho ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-mn_wkctr_id.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-mn_wkctr_id ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-arbpl.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_centro_trabalho.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro ABCINDIC
***      IF ls_ordem-abcindic IS NOT INITIAL.
***        READ TABLE et_filtro_codigo_abc ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-abcindic.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-abcindic ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-sortfield.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_codigo_abc.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro MNTPLAN
***      IF ls_ordem-mntplan IS NOT INITIAL.
***        READ TABLE et_filtro_plano_manutencao ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-mntplan.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-mntplan ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-wptxt.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_plano_manutencao.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Filtro PMACTTYPE
***      IF ls_ordem-pmacttype IS NOT INITIAL.
***        READ TABLE et_filtro_tipo_atvd_manutencao ASSIGNING <fs_filtro> WITH KEY key = ls_ordem-pmacttype.
***        IF sy-subrc NE 0.
***          CLEAR ls_filtro.
***          ls_filtro-key = |{ ls_ordem-pmacttype ALPHA = OUT }|.
***          ls_filtro-text = ls_ordem-ilatx.
***          ls_filtro-count = 1.
***          APPEND ls_filtro TO et_filtro_tipo_atvd_manutencao.
***        ELSE.
***          <fs_filtro>-count = <fs_filtro>-count + 1.
***        ENDIF.
***      ENDIF.
***
**** Carrega Status Mobile da Ordem
***      ls_ordem-status_mobile = 1.
***
***      ls_ordem-atribuir_oper = lv_atribuir_oper.
***
**** Carrega Semáforo
***      READ TABLE lt_034 INTO DATA(ls_034) WITH KEY auart = ls_viaufks-auart priok = ls_ordem-priority.
***      IF sy-subrc EQ 0.
***        IF ls_034-urgente = 'X'.
***          " Vermelho
***          ls_ordem-semaforo_icone = 'sap-icon://status-error'.
***          ls_ordem-semaforo_cor   = 'Error'.
***          ls_ordem-semaforo_descricao = 'Alerta Vermelho'(001).
***        ELSE.
***
***          IF ls_034-verde IS INITIAL AND ls_034-vermelho IS INITIAL AND ls_034-amarelo IS INITIAL.
***            ls_ordem-semaforo_cor = 'None'.
***            ls_ordem-semaforo_descricao = 'Sem Alerta'(002).
***          ELSE.
***            lv_data_referencia_verde = ls_ordem-start_date(4) && ls_ordem-start_date+4(2) && ls_ordem-start_date+6(4).
***            lv_data_referencia_verde = lv_data_referencia_verde + ls_034-verde.
***
***            lv_data_referencia_verme = ls_ordem-start_date(4) && ls_ordem-start_date+4(2) && ls_ordem-start_date+6(4).
***            lv_data_referencia_verme = lv_data_referencia_verme + ls_034-vermelho.
***            " Verde
***            IF sy-datum <= lv_data_referencia_verde.
***              ls_ordem-semaforo_icone = 'sap-icon://status-completed'.
***              ls_ordem-semaforo_cor   = 'Success'.
***              ls_ordem-semaforo_descricao = 'Alerta Verde'(003).
***              " Vermelho
***            ELSEIF sy-datum >= lv_data_referencia_verme.
***              ls_ordem-semaforo_icone = 'sap-icon://status-error'.
***              ls_ordem-semaforo_cor   = 'Error'.
***              ls_ordem-semaforo_descricao = 'Alerta Vermelho'(001).
***              " Amarelo
***            ELSE.
***              ls_ordem-semaforo_icone = 'sap-icon://status-critial'.
***              ls_ordem-semaforo_cor   = 'Warning'.
***              ls_ordem-semaforo_descricao = 'Alerta Amarelo'(004).
***            ENDIF.
***          ENDIF.
***        ENDIF.
***      ELSE.
***        ls_ordem-semaforo_cor = 'None'.
***        ls_ordem-semaforo_descricao = 'Sem Alerta'(002).
***      ENDIF.
***
***      ls_ordem-equipment = |{ ls_ordem-equipment ALPHA = OUT }|.
***
***      ls_ordem-kunnr = |{ ls_ordem-kunnr ALPHA = OUT }|.
***
***      " Verificar obrigatoriedade ou não de informar o catálogo
***      ls_ordem-catalogo = VALUE #( lt_022[ perfil = lv_perfil auart = ls_ordem-order_type ]-filtro_catalogo OPTIONAL ).
***
***      ls_ordem-mntplan = |{ ls_ordem-mntplan ALPHA = OUT }|.
***      ls_ordem-maintitem = |{ ls_ordem-maintitem ALPHA = OUT }|.
**** Carrega Ordem
***      APPEND ls_ordem TO et_ordens.
***
***    ENDLOOP.
***
  ENDMETHOD.


  METHOD OUT_ORDEM_PERFIL_USUARIO.

**    DATA: ls_ordem     LIKE LINE OF et_ordens,
**          lv_objnr     TYPE jsto-objnr,
**          lv_desprezar TYPE char1.
**
**    READ TABLE rt_usuario_app INTO DATA(ls_usuario_app) INDEX 1.
**
**    IF ls_usuario_app-sign = 'I' AND ls_usuario_app-option = 'EQ'.
**
**      DATA(lv_usuario) = ls_usuario_app-low.
**
**    ENDIF.
**
**    SELECT SINGLE *
**      FROM /ptloms/tb013
**      INTO @DATA(ls_usuario)
**      WHERE usuario EQ @lv_usuario.
**
**    IF sy-subrc IS INITIAL.
**
*** Busca Perfil x Tipo Ordem
**      SELECT *
**        FROM /ptloms/tb022
**        INTO TABLE @DATA(lt_tb022)
**        WHERE perfil = @ls_usuario-perfil.
**
**      IF sy-subrc IS INITIAL.
**
**        SORT lt_tb022 BY auart.
**
**        SELECT a~aufnr, a~auart, a~objnr, a~iwerk
**          FROM viaufks AS a INNER JOIN afko AS b ON a~aufnr = b~aufnr
**          INNER JOIN afvc AS c ON b~aufpl = c~aufpl
**          INNER JOIN afvv AS d ON c~aufpl = d~aufpl AND c~aplzl = d~aplzl
**          INTO TABLE @DATA(lt_viaufks)
**          FOR ALL ENTRIES IN @lt_tb022
**          WHERE a~auart = @lt_tb022-auart.
**
**      ENDIF.
**
**    ENDIF.
**
**    " monta tabelas de saída
**    LOOP AT lt_viaufks INTO DATA(ls_viaufks).
**
**      lv_objnr = ls_viaufks-objnr.
**
**      CLEAR lv_desprezar.
**      CALL FUNCTION '/PTLOMS/MF008'
**        EXPORTING
**          im_objnr     = lv_objnr
**        IMPORTING
**          ex_desprezar = lv_desprezar.
**
**      IF lv_desprezar = 'X'.
**        CONTINUE.
**      ENDIF.
**
**      APPEND VALUE #( aufnr = |{  ls_viaufks-aufnr ALPHA = OUT }| usuario_app = lv_usuario ) TO et_ordens.
**
**    ENDLOOP.

  ENDMETHOD.


  METHOD out_parceiro_negocio.
***
**** Declaração de tipos
***    TYPES: BEGIN OF ty_ihpa,
***             objnr   TYPE ihpa-objnr,
***             parvw   TYPE ihpa-parvw,
***             counter TYPE ihpa-counter,
***             obtyp   TYPE ihpa-obtyp,
***             parnr   TYPE ihpa-parnr,
***             lifnr   TYPE lfa1-lifnr,
***             kunnr   TYPE kna1-kunnr,
***             pernr   TYPE pa0001-pernr,
***           END OF ty_ihpa.
***
***** Declaração de range
****    DATA: r_objnr  TYPE RANGE OF ihpa-objnr,
****          ls_objnr LIKE LINE OF r_objnr.
***
**** Declaração de tabela interna
***    DATA: lt_ihpa TYPE /ptloms/cl007=>ct_ihpa. "ty_ihpa.
***
**** Declaração de estrutura
***    DATA: ls_parceiro_negocio LIKE LINE OF rt_parceiro_negocio,
***          ls_ihpa_aux         LIKE LINE OF lt_ihpa.
***
**** Declarações para a BAPI
***    DATA: lv_username     TYPE bapibname-bapibname,
***          ls_logondata    TYPE bapilogond,
***          ls_defaults     TYPE bapidefaul,
***          ls_address      TYPE bapiaddr3,
***          ls_company      TYPE bapiuscomp,
***          ls_snc          TYPE bapisncu,
***          ls_ref_user     TYPE bapirefus,
***          ls_alias        TYPE bapialias,
***          ls_uclass       TYPE bapiuclass,
***          ls_lastmodified TYPE bapimoddat,
***          ls_islocked     TYPE bapislockd,
***          lt_return       TYPE STANDARD TABLE OF bapiret2,
***          lt_addtel       TYPE STANDARD TABLE OF bapiadtel.
***
**** Verifica se parâmetro de entrada está preenchido
***    IF rt_objnr IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca Parceiros
****    SELECT objnr, parvw, counter, obtyp, parnr
****      FROM ihpa
****      INTO TABLE @lt_ihpa
****      WHERE objnr IN @r_objnr "rt_objnr
****        AND kzloesch <> 'X'.
***
***    /ptloms/cl007=>select_ihpa( EXPORTING rt_table_in  = rt_objnr
***                                IMPORTING rt_table_out = lt_ihpa ).
***
**** Carrega os campso Fornecedor(LIFNR), Cliente(KUNNR) e PERNR
***    LOOP AT lt_ihpa ASSIGNING FIELD-SYMBOL(<fs_ihpa>).
***      MOVE: <fs_ihpa>-parnr TO <fs_ihpa>-lifnr,
***            <fs_ihpa>-parnr TO <fs_ihpa>-kunnr,
***            <fs_ihpa>-parnr TO <fs_ihpa>-pernr.
***    ENDLOOP.
***
**** Verifica se encontrou Parceiro
***    IF lt_ihpa[] IS INITIAL.
***      RETURN.
***    ENDIF.
***
**** Busca Funções do Parceiro
***    SELECT parvw, nrart
***      FROM tpar
***      INTO TABLE @DATA(lt_tpar)
***      FOR ALL ENTRIES IN @lt_ihpa
***      WHERE parvw = @lt_ihpa-parvw.
***
***    IF lt_tpar[] IS NOT INITIAL.
**** Busca descrição para grupo de função
***      SELECT spras, parvw, vtext
***        FROM tpart
***        INTO TABLE @DATA(lt_tpart)
***        FOR ALL ENTRIES IN @lt_tpar
***        WHERE spras = @sy-langu
***          AND parvw = @lt_tpar-parvw.
***    ENDIF.
***
**** Busca Fornecedores
***    SELECT lifnr, name1, stras, telf1
***      FROM lfa1
***      INTO TABLE @DATA(lt_lfa1)
***      FOR ALL ENTRIES IN @lt_ihpa
***      WHERE lifnr = @lt_ihpa-lifnr.
***
**** Busca Clientes
***    SELECT kunnr, name1, stras, telf1
***      FROM kna1
***      INTO TABLE @DATA(lt_kna1)
***      FOR ALL ENTRIES IN @lt_ihpa
***      WHERE kunnr = @lt_ihpa-kunnr.
***
**** Busca Nº pessoal
***    SELECT pernr, subty, objps,sprps,
***           endda, begda, seqnr, sname
***      FROM pa0001
***      INTO TABLE @DATA(lt_pa0001)
***      FOR ALL ENTRIES IN @lt_ihpa
***      WHERE pernr = @lt_ihpa-pernr.
***
**** Monta dados de saída
***    LOOP AT lt_ihpa INTO DATA(ls_ihpa).
***
***      CLEAR ls_parceiro_negocio.
***
***      ls_parceiro_negocio-parnr = ls_ihpa-parnr.
***      ls_parceiro_negocio-objnr = ls_ihpa-objnr.
***
***      READ TABLE lt_tpar INTO DATA(ls_tpar) WITH KEY parvw = ls_ihpa-parvw.
***
***      IF sy-subrc EQ 0.
***
***        READ TABLE lt_tpart INTO DATA(ls_tpart) WITH KEY parvw = ls_tpar-parvw.
***        IF sy-subrc EQ 0.
***          ls_parceiro_negocio-vtext = ls_tpart-vtext.
***        ENDIF.
***
***        CASE ls_tpar-nrart.
***
***          WHEN 'LI'.
***            READ TABLE lt_lfa1 INTO DATA(ls_lfa1) WITH KEY lifnr = ls_ihpa-lifnr.
***            IF sy-subrc EQ 0.
***              MOVE-CORRESPONDING ls_lfa1 TO ls_parceiro_negocio.
***            ENDIF.
***          WHEN 'KU'.
***            READ TABLE lt_kna1 INTO DATA(ls_kna1) WITH KEY kunnr = ls_ihpa-kunnr.
***            IF sy-subrc EQ 0.
***              MOVE-CORRESPONDING ls_kna1 TO ls_parceiro_negocio.
***            ENDIF.
***          WHEN 'PE'.
***            READ TABLE lt_pa0001 INTO DATA(ls_pa0001) WITH KEY pernr = ls_ihpa-pernr.
***            IF sy-subrc EQ 0.
***              ls_parceiro_negocio-name1 = ls_pa0001-sname.
***            ENDIF.
***          WHEN 'US'.
***
***            MOVE ls_ihpa-parnr TO lv_username.
***
***            CALL FUNCTION 'BAPI_USER_GET_DETAIL'
***              EXPORTING
***                username     = lv_username
***              IMPORTING
***                ref_user     = ls_ref_user
***                alias        = ls_alias
***                snc          = ls_snc
***                company      = ls_company
***                address      = ls_address
***                defaults     = ls_defaults
***                logondata    = ls_logondata
***                uclass       = ls_uclass
***                lastmodified = ls_lastmodified
***                islocked     = ls_islocked
***              TABLES
***                return       = lt_return
***                addtel       = lt_addtel
***              EXCEPTIONS
***                OTHERS       = 01.
***
***            IF lt_addtel[] IS NOT INITIAL.
***              READ TABLE lt_addtel INTO DATA(ls_addtel) INDEX 1.
***              ls_parceiro_negocio-telf1 = ls_addtel-telephone.
***            ENDIF.
***
***            ls_parceiro_negocio-name1 = ls_address-fullname.
***
***          WHEN OTHERS.
***
***        ENDCASE.
***      ENDIF.
***
***      APPEND ls_parceiro_negocio TO rt_parceiro_negocio.
***
***
***    ENDLOOP.
***
  ENDMETHOD.


  METHOD OUT_PONTO_MEDICAO.
*
** Declaração de tipo
*    TYPES: BEGIN OF ty_imptt,
*             point TYPE imptt-point,
*             mpobj TYPE imptt-mpobj,
*             psort TYPE imptt-psort,
*             pttxt TYPE imptt-pttxt,
*             atinn TYPE imptt-atinn,
*             mrngu TYPE imptt-mrngu,
*             codgr TYPE imptt-codgr,
*             desir TYPE imptt-desir,
*             mrmin TYPE imptt-mrmin,
*             mrmax TYPE imptt-mrmax,
*             codct TYPE imptt-codct,
*           END OF ty_imptt.
*
** Declaração de estrutura
*    DATA: ls_ponto_medicao TYPE /ptloms/et003.
*
** Declaração de variável
*    DATA: lv_flstr(22).
*
** Verifica se parâmetro de entrada está preenchido
*    IF rt_objnr[] IS INITIAL.
*      RETURN.
*    ENDIF.
*
** Busca perfil do usuário
*    IF rt_usuario_app[] IS NOT INITIAL.
*      SELECT usuario, perfil
*        FROM /ptloms/tb013
*        INTO TABLE @DATA(lt_tb013)
*        WHERE usuario IN @rt_usuario_app.
*
*      IF sy-subrc EQ 0.
*        READ TABLE lt_tb013 INTO DATA(ls_tb013) INDEX 1.
** Verifica se possui autorização de Medição de Equipamentos
*        SELECT SINGLE *
*          FROM /ptloms/tb043
*          INTO @DATA(ls_tb043)
*          WHERE perfil      = @ls_tb013-perfil
*            AND autorizacao = '06'.
*        IF sy-subrc NE 0.
*          RETURN.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*** Atualiza range
**    LOOP AT rt_objnr INTO DATA(ls_objnr_aux).
**      CLEAR ls_objnr.
**      MOVE-CORRESPONDING ls_objnr_aux TO ls_objnr.
**      APPEND ls_objnr TO r_objnr.
**    ENDLOOP.
*
** Busca Ponto de Medição
**    SELECT point, mpobj, psort, pttxt, atinn,
**           mrngu, codgr, desir, mrmin, mrmax,
**           codct
**      FROM imptt
**      INTO TABLE @DATA(lt_imptt)
**      WHERE mpobj IN @r_objnr"rt_objnr
**        AND inact EQ @space.
*
*    DATA lt_imptt TYPE /ptloms/cl007=>ct_imptt.
*    /ptloms/cl007=>select_imptt( EXPORTING rt_table_in  = rt_objnr
*                                 IMPORTING rt_table_out = lt_imptt ).
*
** Verifica se encontrou ponto de medição referente ao(s) OBJNR(s)
*    IF lt_imptt[] IS INITIAL.
*      RETURN.
*    ENDIF.
*
** Busca Equipamentos
*    SELECT equnr, objnr
*      FROM equi
*      INTO TABLE @DATA(lt_equi)
*      FOR ALL ENTRIES IN @lt_imptt
*      WHERE objnr = @lt_imptt-mpobj.
*
** Busca Locais de Instalação
*    SELECT tplnr,objnr
*      FROM iflot
*            INTO TABLE @DATA(lt_iflot)
*          FOR ALL ENTRIES IN @lt_imptt
*          WHERE objnr = @lt_imptt-mpobj.
*
** Monta tabela de saída
*    LOOP AT lt_imptt INTO DATA(ls_imptt).
*
*      CLEAR ls_ponto_medicao.
*
*      MOVE-CORRESPONDING ls_imptt TO ls_ponto_medicao.
*
*      ls_ponto_medicao-objnr = ls_imptt-mpobj.
*
*      CLEAR lv_flstr.
*      CALL FUNCTION 'FLTP_CHAR_CONVERSION_FROM_SI'
*        EXPORTING
*          char_unit       = ls_imptt-mrngu
*          decimals        = '0'
*          exponent        = '0'
*          fltp_value_si   = ls_imptt-desir
*          indicator_value = 'X'
*        IMPORTING
*          char_value      = lv_flstr
*        EXCEPTIONS
*          no_unit_given   = 1
*          unit_not_found  = 2
*          OTHERS          = 3.
*
**      IF sy-subrc = 0.
*      CONDENSE lv_flstr.
*      MOVE lv_flstr TO ls_ponto_medicao-desir.
**      ENDIF.
*
*      CLEAR lv_flstr.
*      CALL FUNCTION 'FLTP_CHAR_CONVERSION_FROM_SI'
*        EXPORTING
*          char_unit       = ls_imptt-mrngu
*          decimals        = '0'
*          exponent        = '0'
*          fltp_value_si   = ls_imptt-mrmin
*          indicator_value = 'X'
*        IMPORTING
*          char_value      = lv_flstr
*        EXCEPTIONS
*          no_unit_given   = 1
*          unit_not_found  = 2
*          OTHERS          = 3.
*
**      IF sy-subrc = 0.
*      CONDENSE lv_flstr.
*      MOVE lv_flstr TO ls_ponto_medicao-mrmin.
**      ENDIF.
*
*      CLEAR lv_flstr.
*      CALL FUNCTION 'FLTP_CHAR_CONVERSION_FROM_SI'
*        EXPORTING
*          char_unit       = ls_imptt-mrngu
*          decimals        = '0'
*          exponent        = '0'
*          fltp_value_si   = ls_imptt-mrmax
*          indicator_value = 'X'
*        IMPORTING
*          char_value      = lv_flstr
*        EXCEPTIONS
*          no_unit_given   = 1
*          unit_not_found  = 2
*          OTHERS          = 3.
*
**      IF sy-subrc = 0.
*      CONDENSE lv_flstr.
*      MOVE lv_flstr TO ls_ponto_medicao-mrmax.
**      ENDIF.
*
*      READ TABLE lt_equi INTO DATA(ls_equi) WITH KEY objnr = ls_imptt-mpobj.
*      IF sy-subrc EQ 0.
*        ls_ponto_medicao-equnr = ls_equi-equnr.
*      ELSE.
*        READ TABLE lt_iflot INTO DATA(ls_iflot) WITH KEY objnr = ls_imptt-mpobj.
*        IF sy-subrc EQ 0.
*          ls_ponto_medicao-tplnr = ls_iflot-tplnr.
*        ENDIF.
*      ENDIF.
*
*      APPEND ls_ponto_medicao TO rt_ponto_medicao.
*    ENDLOOP.


  ENDMETHOD.


  METHOD OUT_PRIORIDADE.

*    SELECT a~priok b~priokx
*      FROM t356 AS a INNER JOIN t356_t AS b
*      ON a~artpr = b~artpr AND
*         a~priok = b~priok
*      INTO TABLE @DATA(it_prioridade)
*      WHERE b~spras= sy-langu.

  ENDMETHOD.


  METHOD OUT_PROGRAMACAO_ORDENS.

*** Declaração de tabela interna
**    DATA: lt_despacho TYPE /ptloms/ct079.
**
*** Declaração de objeto
**    DATA: o_cl008 TYPE REF TO /ptloms/cl008.
**
*** Declaração de variáveis
**    DATA: lv_f_tree TYPE flag,
**          lv_mat_at TYPE flag,
**          lv_oper   TYPE flag,
**          lv_ordens TYPE flag.
**
*** Verifica se Centro foi preenchido
**    IF rt_werks[] IS INITIAL.
**      RETURN.
**    ENDIF.
**
**    IF rt_f_tree[] IS NOT INITIAL.
**      lv_f_tree = 'X'.
**    ENDIF.
**    IF rt_mat_at[] IS NOT INITIAL.
**      lv_mat_at = 'X'.
**    ENDIF.
**    IF rt_oper[] IS NOT INITIAL.
**      lv_oper   = 'X'.
**    ELSE.
**      lv_ordens = 'X'.
**    ENDIF.
**
**    CREATE OBJECT o_cl008
**      EXPORTING
**        rt_werks      = rt_werks
**        rt_aufnr      = rt_aufnr
**        rt_vornr      = rt_vornr
**        rt_auart      = rt_auart
**        rt_qmnum      = rt_qmnum
**        rt_priok      = rt_priok
**        rt_tplnr      = rt_tplnr
**        rt_equnr      = rt_equnr
**        rt_iwerk      = rt_iwerk
**        rt_ingpr      = rt_ingpr
**        rt_ilart      = rt_ilart
**        rt_gewrk      = rt_gewrk
**        rt_gstrp      = rt_gstrp
**        rt_datope     = rt_datope
**        rt_usuapp     = rt_usuapp
**        im_f_tree     = lv_f_tree
**        im_mat_at     = lv_mat_at
**        im_oper       = lv_oper
**        im_ordens     = lv_ordens
**        rt_gstrp_ini  = rt_gstrp_ini
**        rt_datope_ini = rt_datope_ini
**        rt_gstrp_fim  = rt_gstrp_fim
**        rt_datope_fim = rt_datope_fim
**        rt_vlsch      = rt_vlsch
**        rt_ernam      = rt_ernam.
*** Busca dados Painel de Programação (Ordens)
**    o_cl008->busca_dados( EXPORTING origem = 'APP' IMPORTING it_despacho = it_despacho ).
**
**    LOOP AT it_despacho ASSIGNING FIELD-SYMBOL(<fs_despacho>).
**
**      <fs_despacho>-aufnr = |{ <fs_despacho>-aufnr ALPHA = OUT }|.
**      <fs_despacho>-qmnum = |{ <fs_despacho>-qmnum ALPHA = OUT }|.
**
*** Aufnr
**      out_filtro( EXPORTING im_value = <fs_despacho>-aufnr im_field = 'Aufnr' im_data_element = 'AUFNR' CHANGING it_filtro = it_filtro ).
***Vornr
**      out_filtro( EXPORTING im_value = <fs_despacho>-vornr im_field = 'Vornr' im_data_element = 'VORNR' CHANGING it_filtro = it_filtro ).
***Suboper
**      out_filtro( EXPORTING im_value = <fs_despacho>-suboper im_field = 'Suboper' im_data_element = 'UVORN'  CHANGING it_filtro = it_filtro ).
***DataAssociacao
**      out_filtro( EXPORTING im_value = <fs_despacho>-data_associacao im_field = 'DataAssociacao' im_data_element = 'Data Associacao' CHANGING it_filtro = it_filtro ).
***HoraAssociacao
**      out_filtro( EXPORTING im_value = <fs_despacho>-hora_associacao im_field = 'HoraAssociacao' im_data_element = 'Hora Associacao' CHANGING it_filtro = it_filtro ).
***Auart
**      out_filtro( EXPORTING im_value = <fs_despacho>-auart im_field = 'Auart' im_data_element = 'AUART' CHANGING it_filtro = it_filtro ).
***Qmnum
**      out_filtro( EXPORTING im_value = <fs_despacho>-qmnum im_field = 'Qmnum' im_data_element = 'QMNUM' CHANGING it_filtro = it_filtro ).
***Priok
**      out_filtro( EXPORTING im_value = <fs_despacho>-priok im_field = 'Priok' im_data_element = 'PRIOK' CHANGING it_filtro = it_filtro ).
***Gewrk
**      out_filtro( EXPORTING im_value = <fs_despacho>-gewrk im_field = 'Gewrk' im_data_element = 'LGWID' CHANGING it_filtro = it_filtro ).
***Arbpl
**      out_filtro( EXPORTING im_value = <fs_despacho>-arbpl im_field = 'Arbpl' im_data_element = 'ARBPL' CHANGING it_filtro = it_filtro ).
***Gstrp
**      out_filtro( EXPORTING im_value = <fs_despacho>-gstrp im_field = 'Gstrp' im_data_element = 'PM_ORDGSTRP' CHANGING it_filtro = it_filtro ).
***Gltrp
**      out_filtro( EXPORTING im_value = <fs_despacho>-gltrp im_field = 'Gltrp' im_data_element = 'CO_GLTRP' CHANGING it_filtro = it_filtro ).
***Idat1
**      out_filtro( EXPORTING im_value = <fs_despacho>-idat1 im_field = 'Idat1' im_data_element = 'AUFIDAT1' CHANGING it_filtro = it_filtro ).
***Ktext
**      out_filtro( EXPORTING im_value = <fs_despacho>-ktext im_field = 'Ktext' im_data_element = 'AUFTEXT' CHANGING it_filtro = it_filtro ).
***Iwerk
**      out_filtro( EXPORTING im_value = <fs_despacho>-iwerk im_field = 'Iwerk' im_data_element = 'IWERK' CHANGING it_filtro = it_filtro ).
***Ingpr
**      out_filtro( EXPORTING im_value = <fs_despacho>-ingpr im_field = 'Ingpr' im_data_element = 'INGRP' CHANGING it_filtro = it_filtro ).
***Tplnr
**      out_filtro( EXPORTING im_value = <fs_despacho>-tplnr im_field = 'Tplnr' im_data_element = 'TPLNR' CHANGING it_filtro = it_filtro ).
***Pltxt
**      out_filtro( EXPORTING im_value = <fs_despacho>-pltxt im_field = 'Pltxt' im_data_element = 'PLTXT' CHANGING it_filtro = it_filtro ).
***Equnr
**      out_filtro( EXPORTING im_value = <fs_despacho>-equnr im_field = 'Equnr' im_data_element = 'EQUNR' CHANGING it_filtro = it_filtro ).
***Eqktx
**      out_filtro( EXPORTING im_value = <fs_despacho>-eqktx im_field = 'Eqktx' im_data_element = 'KTX01' CHANGING it_filtro = it_filtro ).
***Objnr
**      out_filtro( EXPORTING im_value = <fs_despacho>-objnr im_field = 'Objnr' im_data_element = 'J_OBJNR' CHANGING it_filtro = it_filtro ).
***StatusUsu
**      out_filtro( EXPORTING im_value = <fs_despacho>-status_usu im_field = 'StatusUsu' im_data_element = 'StatusUsu' CHANGING it_filtro = it_filtro ).
***StatusSis
**      out_filtro( EXPORTING im_value = <fs_despacho>-status_sis im_field = 'StatusSis' im_data_element = 'StatusSis' CHANGING it_filtro = it_filtro ).
***Arbid
**      out_filtro( EXPORTING im_value = <fs_despacho>-arbid im_field = 'Arbid' im_data_element = 'CR_OBJID' CHANGING it_filtro = it_filtro ).
***Ltxa1
**      out_filtro( EXPORTING im_value = <fs_despacho>-ltxa1 im_field = 'Ltxa1' im_data_element = 'LTXA1' CHANGING it_filtro = it_filtro ).
***Artpr
**      out_filtro( EXPORTING im_value = <fs_despacho>-artpr im_field = 'Artpr' im_data_element = 'ARTPR' CHANGING it_filtro = it_filtro ).
***Priokx
**      out_filtro( EXPORTING im_value = <fs_despacho>-priokx im_field = 'Priokx' im_data_element = 'PRIOKX' CHANGING it_filtro = it_filtro ).
***Innam
**      out_filtro( EXPORTING im_value = <fs_despacho>-innam im_field = 'Innam' im_data_element = 'INNAM' CHANGING it_filtro = it_filtro ).
***Aufpl
**      out_filtro( EXPORTING im_value = <fs_despacho>-aufpl im_field = 'Aufpl' im_data_element = 'CO_AUFPL' CHANGING it_filtro = it_filtro ).
***Aplzl
**      out_filtro( EXPORTING im_value = <fs_despacho>-aplzl im_field = 'Aplzl' im_data_element = 'CO_APLZL' CHANGING it_filtro = it_filtro ).
***Sumnr
**      out_filtro( EXPORTING im_value = <fs_despacho>-sumnr im_field = 'Sumnr' im_data_element = 'SUMKNTNR' CHANGING it_filtro = it_filtro ).
***Pernr
**      out_filtro( EXPORTING im_value = <fs_despacho>-pernr im_field = 'Pernr' im_data_element = 'CO_PERNR' CHANGING it_filtro = it_filtro ).
***ObjnrOperSub
**      out_filtro( EXPORTING im_value = <fs_despacho>-objnr_oper_sub im_field = 'ObjnrOperSub' im_data_element = 'J_OBJNR' CHANGING it_filtro = it_filtro ).
***Arbei
**      out_filtro( EXPORTING im_value = <fs_despacho>-arbei im_field = 'Arbei' im_data_element = 'ARBEIT' CHANGING it_filtro = it_filtro ).
***Usuarioapp
**      out_filtro( EXPORTING im_value = <fs_despacho>-usuarioapp im_field = 'Usuarioapp' im_data_element = 'Usuarioapp' CHANGING it_filtro = it_filtro ).
***Matricula
**      out_filtro( EXPORTING im_value = <fs_despacho>-matricula im_field = 'Matricula' im_data_element = 'Matricula' CHANGING it_filtro = it_filtro ).
**
**    ENDLOOP.
**
  ENDMETHOD.


  METHOD OUT_PROGRAMACAO_USUARIOS.

*** Declaração de tabela interna
**    DATA: lt_despacho_tree TYPE /ptloms/ct080.
**
*** Declaração de objeto
**    DATA: o_cl009 TYPE REF TO /ptloms/cl009.
**
*** Declaração de variáveis
**    DATA: lv_f_tree TYPE flag,
**          lv_mat_at TYPE flag,
**          lv_oper   TYPE flag,
**          lv_ordens TYPE flag.
**
*** Verifica se Centro foi preenchido
**    IF rt_werks[] IS INITIAL.
**      RETURN.
**    ENDIF.
**
**    IF rt_f_tree[] IS NOT INITIAL.
**      lv_f_tree = 'X'.
**    ENDIF.
**    IF rt_mat_at[] IS NOT INITIAL.
**      lv_mat_at = 'X'.
**    ENDIF.
**    IF rt_oper[] IS NOT INITIAL.
**      lv_oper   = 'X'.
**    ENDIF.
**    IF rt_ordens[] IS NOT INITIAL.
**      lv_ordens = 'X'.
**    ENDIF.
**
**    CREATE OBJECT o_cl009
**      EXPORTING
**        rt_werks      = rt_werks
**        rt_aufnr      = rt_aufnr
**        rt_auart      = rt_auart
**        rt_qmnum      = rt_qmnum
**        rt_priok      = rt_priok
**        rt_tplnr      = rt_tplnr
**        rt_equnr      = rt_equnr
**        rt_iwerk      = rt_iwerk
**        rt_ingpr      = rt_ingpr
**        rt_ilart      = rt_ilart
**        rt_gewrk      = rt_gewrk
**        rt_gstrp      = rt_gstrp
**        rt_datope     = rt_datope
**        rt_usuapp     = rt_usuapp
**        im_f_tree     = lv_f_tree
**        im_mat_at     = lv_mat_at
**        im_oper       = lv_oper
**        im_ordens     = lv_ordens
**        rt_gstrp_ini  = rt_gstrp_ini
**        rt_datope_ini = rt_datope_ini
**        rt_gstrp_fim  = rt_gstrp_fim
**        rt_datope_fim = rt_datope_fim.
**
*** Busca dados Painel de Programação (Ordens)
**    o_cl009->monta_alv_tree( ).
**    o_cl009->get_gt_alv_tree( IMPORTING it_despacho_tree = it_despacho_tree ).
**    DELETE it_despacho_tree WHERE usuario IS INITIAL.
**
  ENDMETHOD.


  METHOD out_usuario.
***
***    DATA: ls_dados_usuario_app LIKE LINE OF et_dados_usuario_app.
***
**** Busca Uusário
***    SELECT *
***      FROM /ptloms/tb013
***      INTO TABLE @DATA(lt_dados_usuario)
***      WHERE usuario   IN @rt_usuario_app.
****        AND bloqueado = 'X'.
***
***    LOOP AT lt_dados_usuario INTO DATA(ls_dados_usuario).
***      CLEAR ls_dados_usuario_app.
***      MOVE-CORRESPONDING ls_dados_usuario TO ls_dados_usuario_app.
***      APPEND ls_dados_usuario_app TO et_dados_usuario_app.
***    ENDLOOP.
***
  ENDMETHOD.


METHOD OUT_VARIANT.

**  DATA: s_var_usuario  TYPE RANGE OF /ptloms/tb049-var_usuario,
**        ls_var_usuario LIKE LINE OF s_var_usuario.
**
**  IF rt_var_usuario[] IS NOT INITIAL.
**
***Monta Range S_WERKS
**    LOOP AT rt_var_usuario INTO DATA(ls_var_usuario_aux).
**      CLEAR ls_var_usuario.
**      MOVE-CORRESPONDING ls_var_usuario_aux TO ls_var_usuario.
**      APPEND ls_var_usuario TO s_var_usuario.
**    ENDLOOP.
**
**  ENDIF.
**
*** Busca dados na tabela de variantes
**  SELECT *
**    FROM /ptloms/tb049
**    INTO CORRESPONDING FIELDS OF TABLE @it_variant
**    WHERE var_usuario IN @s_var_usuario.

ENDMETHOD.


METHOD OUT_VARIANT_CREATE.

**  DATA: ls_variant TYPE /ptloms/tb049.
**
**  MOVE-CORRESPONDING iv_variant TO ls_variant.
**
**  MODIFY /ptloms/tb049 FROM ls_variant.
**
**  IF sy-subrc IS INITIAL.
**
**    COMMIT WORK.
**
**  ENDIF.

ENDMETHOD.


METHOD OUT_VARIANT_DELETE.

**  DELETE FROM /ptloms/tb049 WHERE var_key = iv_var_key.
**
**  IF sy-subrc IS INITIAL.
**
**    COMMIT WORK.
**
**  ENDIF.

ENDMETHOD.


METHOD OUT_VARIANT_UPDATE.

**  UPDATE /ptloms/tb049 SET var_id        = iv_variant-var_id
**                           var_name      = iv_variant-var_name
**                           var_global    = iv_variant-var_global
**                           var_def       = iv_variant-var_def
**                           var_overwrite = iv_variant-var_overwrite
**                           var_tile      = iv_variant-var_tile
**                           var_app       = iv_variant-var_app
**                           var_usuario   = iv_variant-var_usuario
**                           var_json      = iv_variant-var_json
**                           WHERE var_key = iv_variant-var_key.
**
**  IF sy-subrc IS INITIAL.
**
**    COMMIT WORK.
**
**  ENDIF.

ENDMETHOD.


METHOD OUT_VARIANT_VALUES.

*** Declaração de Tabela Interna
**  DATA: lt_variant_values TYPE TABLE OF rsparams.
**
*** Declaração de range
**  DATA: r_variant TYPE /iwbep/t_cod_select_options.
**
*** Declaração de Estrutura
**  DATA: ls_variant_values LIKE LINE OF it_variant_values,
**        ls_variant        LIKE LINE OF rt_variant.
**
*** Declaração de Variável
**  DATA: lv_report TYPE varid-report VALUE '/PTLOMS/MP004'.
**
**  IF rt_variant[] IS INITIAL.
**    SELECT SINGLE variant FROM /ptloms/tb033 INTO @DATA(lv_variant).
**    ls_variant-sign   = 'I'.
**    ls_variant-option = 'EQ'.
**    ls_variant-low    = lv_variant.
**    APPEND ls_variant TO r_variant.
**  ELSE.
**    r_variant = rt_variant.
**  ENDIF.
**
*** Busca dados na Tabela VARID
**  SELECT report, variant, flag1, flag2
**    FROM varid
**    INTO TABLE @DATA(lt_varid)
**    WHERE report EQ @lv_report
**     AND variant IN @r_variant.
**
**  IF sy-subrc EQ 0.
**
**    LOOP AT lt_varid INTO DATA(ls_varid).
**
**      REFRESH: lt_variant_values[].
**
**      CALL FUNCTION 'RS_VARIANT_VALUES_TECH_DATA'
**        EXPORTING
**          report         = ls_varid-report
**          variant        = ls_varid-variant
**        TABLES
**          variant_values = lt_variant_values.
**
***      APPEND LINES OF lt_variant_values TO it_variant_values.
**      LOOP AT lt_variant_values INTO DATA(ls_variant_values_aux).
**        CLEAR ls_variant_values.
**        MOVE-CORRESPONDING ls_variant_values_aux TO ls_variant_values.
**        ls_variant_values-variant = ls_varid-variant.
**        APPEND ls_variant_values TO it_variant_values.
**      ENDLOOP.
**
**    ENDLOOP.
**  ENDIF.

ENDMETHOD.
ENDCLASS.
