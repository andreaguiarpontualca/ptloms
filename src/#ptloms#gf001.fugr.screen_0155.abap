PROCESS BEFORE OUTPUT.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_equip_status_exclusivo-status.
    MODULE valida_status_exclusivo.
  ENDCHAIN.

  MODULE user_command_0154.

PROCESS ON VALUE-REQUEST.

  "f_seleciona_mult_status_exclusivo
  FIELD: wa_equip_status_exclusivo-status MODULE
f_help_status_exclusivo.
