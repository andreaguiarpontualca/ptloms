PROCESS BEFORE OUTPUT.
* MODULE STATUS_0200.

  MODULE trata_campos.

PROCESS AFTER INPUT.

* Validações para Perfil
  CHAIN.
    FIELD: wa_usuario-perfil MODULE valida_perfil.
  ENDCHAIN.

* Validações para Usuário
  CHAIN.
    FIELD: wa_usuario-usuario MODULE valida_usuario.
  ENDCHAIN.

* Validações para Usuário
  CHAIN.
    FIELD: wa_usuario-nome MODULE valida_nome.
  ENDCHAIN.

** Validações para Usuário SAP
*  CHAIN.
*    FIELD: wa_usuario-usuario_sap MODULE valida_usuario_sap.
*  ENDCHAIN.

* Validações para Matrícula
  CHAIN.
    FIELD: wa_usuario-matricula MODULE valida_matricula.
  ENDCHAIN.

* Validações para Unidade de tempo
  CHAIN.
    FIELD: wa_usuario-unidade_tempo MODULE valida_unid_tempo.
  ENDCHAIN.

* Validações para Centro de Trabalho
  CHAIN.
    FIELD: wa_usuario-objid MODULE valida_objid.
  ENDCHAIN.

** Validações para Senha e Conf.Senha
*  CHAIN.
*    FIELD: wa_usuario-senha,
*           wa_usuario-conf_senha MODULE valida_senha.
*  ENDCHAIN.

* Validações para Senha
  CHAIN.
    FIELD: wa_usuario-senha
    MODULE valida_senha ON CHAIN-REQUEST.
  ENDCHAIN.

* Validações para Conf.Senha
  CHAIN.
    FIELD: wa_usuario-conf_senha
    MODULE valida_confsenha ON CHAIN-REQUEST.
  ENDCHAIN.

** Validações para Senha e Conf.Senha
*  CHAIN.
*    FIELD: wa_usuario-senha,
*           wa_usuario-conf_senha MODULE valida_senha_confsenha.
*  ENDCHAIN.

** Validações para Status Senha
*  CHAIN.
*    FIELD: wa_usuario-usuario_sap,
*           wa_usuario-status_senha.
*           wa_usuario-senha_usuario_sap.
*    MODULE valida_senha_usuario_sap. "ON CHAIN-REQUEST.
*  ENDCHAIN.

* Validações do Horizonte de Visualização
  CHAIN.
    FIELD: wa_usuario-dia_inicio,
           wa_usuario-dias_retroativos,
           wa_usuario-dias_progressivos.
*IuryFSilva - Comentado devido a reestruturação no processo para a v 2
*    MODULE valida_horizonte.
  ENDCHAIN.

  MODULE user_command_0200.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_usuario-matricula     MODULE f_help_matricula.
  FIELD: wa_usuario-unidade_tempo MODULE f_help_unid_tempo.
