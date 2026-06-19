PROCESS BEFORE OUTPUT.
  MODULE status_0100.

  MODULE pbo_0100.

* Determina aba ativa
  MODULE tabstrip_active_tab_set.

PROCESS AFTER INPUT.

* Procedimentos para clique nos botões de saída
  MODULE saida AT EXIT-COMMAND.

 MODULE USER_COMMAND_0100.
