*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP001_TOP
*&---------------------------------------------------------------------*
PROGRAM /ptloms/mp001.

CLASS lcl_event_receiver_005 DEFINITION DEFERRED.

DATA: gv_okcode TYPE sy-ucomm.
DATA: o_oms TYPE REF TO /ptloms/cl002 ##NEEDED.

*---------------------------------------------------------------------*
*       CLASS lcl_event_receiver_005 DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_event_receiver_005 DEFINITION.

  PUBLIC SECTION.

    METHODS: handle_node_double_click
      FOR EVENT node_double_click
                  OF cl_gui_list_tree
      IMPORTING node_key.

    METHODS: handle_item_double_click
      FOR EVENT item_double_click
                  OF cl_gui_list_tree
      IMPORTING node_key item_name.

    METHODS: handle_button_click
      FOR EVENT button_click
                  OF cl_gui_list_tree
      IMPORTING node_key item_name.

    METHODS: handle_link_click
      FOR EVENT link_click
                  OF cl_gui_list_tree
      IMPORTING node_key item_name.

ENDCLASS.                    "lcl_event_receiver DEFINITION
