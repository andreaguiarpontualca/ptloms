FUNCTION /ptloms/mf067.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_LAYOUT) TYPE  /PTLOMS/ET082
*"     VALUE(IT_LAYOUT_VALUES) TYPE  /PTLOMS/CT084
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl003.

  CREATE OBJECT o_oms.

  o_oms->in_layout( EXPORTING im_layout         = im_layout
                               it_layout_values = it_layout_values ).

ENDFUNCTION.
