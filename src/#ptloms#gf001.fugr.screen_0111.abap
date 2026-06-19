PROCESS BEFORE OUTPUT.
* MODULE STATUS_0101.

PROCESS AFTER INPUT.

  CHAIN.
    FIELD: wa_grupo_planejamento-iwerk,
           wa_grupo_planejamento-name1,
           wa_grupo_planejamento-ingrp,
           wa_grupo_planejamento-innam.
    MODULE valida_grupo_planejamento.
  ENDCHAIN.

  MODULE user_command_0111.

PROCESS ON VALUE-REQUEST.
  FIELD: wa_grupo_planejamento-iwerk MODULE f_help_cod_adm_centro_grp_p,
         wa_grupo_planejamento-ingrp MODULE f_help_cod_adm_centro_grp_p.
                                            "f_help_cod_adm_grp_p.
