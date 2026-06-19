PROCESS BEFORE OUTPUT.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_equip_status_INCLUSIVO-status.
    MODULE valida_status_inclusivo.
  ENDCHAIN.

  MODULE user_command_0153.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_equip_status_INCLUSIVO-status MODULE
f_help_status_inclusivo.
