PROCESS BEFORE OUTPUT.
* MODULE STATUS_0300.

PROCESS AFTER INPUT.

* Valida motivo de desassociação
  CHAIN.
    FIELD /ptloms/tb026-motivo_desassociacao MODULE valida_motivo_des.
  ENDCHAIN.

  MODULE user_command_0300.

PROCESS ON VALUE-REQUEST.
  FIELD: /ptloms/tb026-motivo_desassociacao MODULE help_retirada.
