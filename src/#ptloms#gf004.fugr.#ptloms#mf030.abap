FUNCTION /ptloms/mf030.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_AUFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_AUART) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_IWERK) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_INGPR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_BEBER) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ARBPL) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_PARNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_EQFNR) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_GSTRP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_STTXT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_ASTTX) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(IM_TOP) TYPE  INT4 OPTIONAL
*"     VALUE(IM_SKIP) TYPE  INT4 OPTIONAL
*"  EXPORTING
*"     VALUE(IT_ORDENS) TYPE  /PTLOMS/CT036
*"     VALUE(IT_TEXTOS_ORDEM) TYPE  /PTLOMS/CT037
*"     VALUE(IT_TEXTOS_OPERACOES) TYPE  /PTLOMS/CT037
*"     VALUE(IT_OPERACOES_ORDEM) TYPE  /PTLOMS/CT038
*"     VALUE(IT_COMPONENTES_ORDEM) TYPE  /PTLOMS/CT039
*"     VALUE(IT_CONFIRMACOES) TYPE  /PTLOMS/CT075
*"     VALUE(IT_IMAGENS_ORDEM) TYPE  /PTLOMS/CT072
*"     VALUE(IT_FILTRO_ORDEM) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_NOTA) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_TIPO_ORDEM) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_INICIO_BASE) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_FIM_BASE) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_LOCAL_INSTALACAO) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_EQUIPAMENTO) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_GRUPO_PLANEJAMENTO) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_CENTRO_TRABALHO) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_CODIGO_ABC) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_PLANO_MANUTENCAO) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_CICLO) TYPE  /PTLOMS/CT056
*"     VALUE(IT_FILTRO_TIPO_ATVD_MANUTENCAO) TYPE  /PTLOMS/CT056
*"     VALUE(EX_QUANTIDADE_ORDEM) TYPE  INT4
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_ordem( EXPORTING rt_aufnr                       = rt_aufnr
                              rt_auart                       = rt_auart
                              rt_iwerk                       = rt_iwerk
                              rt_ingpr                       = rt_ingpr
                              rt_beber                       = rt_beber
                              rt_arbpl                       = rt_arbpl
                              rt_parnr                       = rt_parnr
                              rt_eqfnr                       = rt_eqfnr
                              rt_gstrp                       = rt_gstrp
                              rt_sttxt                       = rt_sttxt
                              rt_asttx                       = rt_asttx
                              rt_usuario_app                 = rt_usuario_app
                              im_top                         = im_top
                              im_skip                        = im_skip
                    IMPORTING et_ordens                      = it_ordens
                              et_textos_ordem                = it_textos_ordem
                              et_operacoes_ordem             = it_operacoes_ordem
                              et_componentes_ordem           = it_componentes_ordem
                              et_confirmacoes                = it_confirmacoes
                              et_imagens_ordem               = it_imagens_ordem
                              et_filtro_ordem                = it_filtro_ordem
                              et_filtro_nota                 = it_filtro_nota
                              et_filtro_tipo_ordem           = it_filtro_tipo_ordem
                              et_filtro_inicio_base          = it_filtro_inicio_base
                              et_filtro_fim_base             = it_filtro_fim_base
                              et_filtro_local_instalacao     = it_filtro_local_instalacao
                              et_filtro_equipamento          = it_filtro_equipamento
                              et_filtro_grupo_planejamento   = it_filtro_grupo_planejamento
                              et_filtro_centro_trabalho      = it_filtro_centro_trabalho
                              et_filtro_codigo_abc           = it_filtro_codigo_abc
                              et_filtro_plano_manutencao     = it_filtro_plano_manutencao
                              et_filtro_ciclo                = it_filtro_ciclo
                              et_filtro_tipo_atvd_manutencao = it_filtro_tipo_atvd_manutencao
                              ex_quantidade_ordem            = ex_quantidade_ordem ).
*                                    et_filtro_op_status_mobile     = lt_filtro_op_status_mobile
*                                    et_filtro_op_operacao          = lt_filtro_op_operacao
*                                    et_filtro_op_sub_operacao      = lt_filtro_op_sub_operacao
*                                    et_filtro_op_empregado         = lt_filtro_op_empregado
*                                    et_filtro_op_centro_trabalho   = lt_filtro_op_centro_trabalho ).

ENDFUNCTION.
