PROCESS BEFORE OUTPUT.
* MODULE STATUS_0200.
*
PROCESS AFTER INPUT.

* Validações para Usuário
  CHAIN.
    FIELD: wa_usuario-usuario,
           wa_usuario-nome MODULE valida_usuario.
  ENDCHAIN.

  MODULE user_command_0200.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_usuario-usuario MODULE help_usuario.
