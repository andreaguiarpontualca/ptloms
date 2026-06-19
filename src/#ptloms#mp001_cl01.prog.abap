*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP001_CL01
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       CLASS lcl_event_receiver_005 IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_event_receiver_005 IMPLEMENTATION.

  METHOD  handle_node_double_click.
  ENDMETHOD.                    "HANDLE_NODE_DOUBLE_CLICK

  METHOD handle_item_double_click.
    PERFORM dclik USING node_key.
  ENDMETHOD.                    "

  METHOD  handle_button_click.
  ENDMETHOD.                    "HANDLE_BUTTON_CLICK

  METHOD  handle_link_click.

  ENDMETHOD.                    "HANDLE_LINK_CLICK

ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
