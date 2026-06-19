FUNCTION /ptloms/mf023.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_EMPRESA_CENTRO) TYPE  CHAR1
*"     VALUE(IM_GRUPO_PLANEJAMENTO) TYPE  CHAR1
*"     VALUE(IM_AREA_OPERACIONAL) TYPE  CHAR1
*"     VALUE(IM_CENTRO_TRABALHO) TYPE  CHAR1
*"     VALUE(IM_TIPO_NOTA) TYPE  CHAR1
*"     VALUE(IM_TIPO_ORDEM) TYPE  CHAR1
*"     VALUE(IM_TIPO_PRIORIDADE_ORDEM) TYPE  CHAR1
*"     VALUE(IM_TIPO_PRIORIDADE_NOTA) TYPE  CHAR1
*"     VALUE(IM_TIPO_ATV_MANUTENCAO) TYPE  CHAR1
*"     VALUE(IM_CENTRO_CUSTO) TYPE  CHAR1
*"     VALUE(IM_CONDICAO_INST_ORDEM) TYPE  CHAR1
*"     VALUE(IM_TIPO_ATV_OPERACAO) TYPE  CHAR1
*"     VALUE(IM_TIPO_MATERIAL) TYPE  CHAR1
*"     VALUE(IM_CATEGORIA_ITEM_MATERIAL) TYPE  CHAR1
*"     VALUE(IM_DEPOSITO) TYPE  CHAR1
*"     VALUE(IM_CATEGORIA_EQUIPAMENTO) TYPE  CHAR1
*"     VALUE(IM_TIPO_OBJETO) TYPE  CHAR1
*"     VALUE(IM_CATEGORIA_LOC_INST) TYPE  CHAR1
*"     VALUE(IM_TIPO_ATV_ORDEM) TYPE  CHAR1
*"     VALUE(IM_CAUSA_DESVIO) TYPE  CHAR1
*"     VALUE(IM_MATRICULA) TYPE  CHAR1
*"     VALUE(IM_CHAVE_MODELO) TYPE  CHAR1
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(IM_CENTRO_PLANEJAMENTO) TYPE  CHAR1
*"     VALUE(IM_PRIORIDADE) TYPE  CHAR1
*"  EXPORTING
*"     VALUE(IT_EMPRESA_CENTRO) TYPE  /PTLOMS/CT006
*"     VALUE(IT_GRUPO_PLANEJAMENTO) TYPE  /PTLOMS/CT007
*"     VALUE(IT_AREA_OPERACIONAL) TYPE  /PTLOMS/CT008
*"     VALUE(IT_CENTRO_TRABALHO) TYPE  /PTLOMS/CT009
*"     VALUE(IT_TIPO_NOTA) TYPE  /PTLOMS/CT010
*"     VALUE(IT_TIPO_ORDEM) TYPE  /PTLOMS/CT011
*"     VALUE(IT_TIPO_PRIORIDADE_ORDEM) TYPE  /PTLOMS/CT012
*"     VALUE(IT_TIPO_PRIORIDADE_NOTA) TYPE  /PTLOMS/CT013
*"     VALUE(IT_TIPO_ATV_MANUTENCAO) TYPE  /PTLOMS/CT014
*"     VALUE(IT_CENTRO_CUSTO) TYPE  /PTLOMS/CT015
*"     VALUE(IT_CONDICAO_INST_ORDEM) TYPE  /PTLOMS/CT016
*"     VALUE(IT_TIPO_ATV_OPERACAO) TYPE  /PTLOMS/CT017
*"     VALUE(IT_TIPO_MATERIAL) TYPE  /PTLOMS/CT027
*"     VALUE(IT_CATEGORIA_ITEM_MATERIAL) TYPE  /PTLOMS/CT028
*"     VALUE(IT_DEPOSITO) TYPE  /PTLOMS/CT029
*"     VALUE(IT_CATEGORIA_EQUIPAMENTO) TYPE  /PTLOMS/CT034
*"     VALUE(IT_TIPO_OBJETO) TYPE  /PTLOMS/CT035
*"     VALUE(IT_CATEGORIA_LOC_INST) TYPE  /PTLOMS/CT040
*"     VALUE(IT_TIPO_ATV_ORDEM) TYPE  /PTLOMS/CT049
*"     VALUE(IT_CAUSA_DESVIO) TYPE  /PTLOMS/CT066
*"     VALUE(IT_MATRICULA) TYPE  /PTLOMS/CT073
*"     VALUE(IT_CHAVE_MODELO) TYPE  /PTLOMS/CT085
*"     VALUE(IT_CENTRO_PLANEJAMENTO) TYPE  /PTLOMS/CT111
*"     VALUE(IT_PRIORIDADE) TYPE  /PTLOMS/CT112
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_demais_dados_mestres(
    EXPORTING
      im_empresa_centro          = im_empresa_centro
      im_grupo_planejamento      = im_grupo_planejamento
      im_area_operacional        = im_area_operacional
      im_centro_trabalho         = im_centro_trabalho
      im_tipo_nota               = im_tipo_nota
      im_tipo_ordem              = im_tipo_ordem
      im_tipo_prioridade_ordem   = im_tipo_prioridade_ordem
      im_tipo_prioridade_nota    = im_tipo_prioridade_nota
      im_tipo_atv_manutencao     = im_tipo_atv_manutencao
      im_centro_custo            = im_centro_custo
      im_condicao_inst_ordem     = im_condicao_inst_ordem
      im_tipo_atv_operacao       = im_tipo_atv_operacao
      im_tipo_material           = im_tipo_material
      im_categoria_item_material = im_categoria_item_material
      im_deposito                = im_deposito
      im_categoria_equipamento   = im_categoria_equipamento
      im_tipo_objeto             = im_tipo_objeto
      im_categoria_loc_inst      = im_categoria_loc_inst
      im_tipo_atv_ordem          = im_tipo_atv_ordem
      im_causa_desvio            = im_causa_desvio
      im_matricula               = im_matricula
      im_chave_modelo            = im_chave_modelo
      rt_usuario_app             = rt_usuario_app
      im_centro_planejamento     = im_centro_planejamento
    IMPORTING
      et_empresa_centro          = it_empresa_centro
      et_grupo_planejamento      = it_grupo_planejamento
      et_area_operacional        = it_area_operacional
      et_centro_trabalho         = it_centro_trabalho
      et_tipo_nota               = it_tipo_nota
      et_tipo_ordem              = it_tipo_ordem
      et_tipo_prioridade_ordem   = it_tipo_prioridade_ordem
      et_tipo_prioridade_nota    = it_tipo_prioridade_nota
      et_tipo_atv_manutencao     = it_tipo_atv_manutencao
      et_centro_custo            = it_centro_custo
      et_condicao_inst_ordem     = it_condicao_inst_ordem
      et_tipo_atv_operacao       = it_tipo_atv_operacao
      et_tipo_material           = it_tipo_material
      et_categoria_item_material = it_categoria_item_material
      et_deposito                = it_deposito
      et_categoria_equipamento   = it_categoria_equipamento
      et_tipo_objeto             = it_tipo_objeto
      et_categoria_loc_inst      = it_categoria_loc_inst
      et_tipo_atv_ordem          = it_tipo_atv_ordem
      et_causa_desvio            = it_causa_desvio
      et_matriculas              = it_matricula
      et_chave_modelo            = it_chave_modelo
      et_centro_planejamento     = it_centro_planejamento ).


ENDFUNCTION.
