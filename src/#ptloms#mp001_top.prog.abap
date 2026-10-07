*&---------------------------------------------------------------------*
*&  Include           /PTLOMS/MP001_TOP
*&---------------------------------------------------------------------*
PROGRAM /ptloms/mp001.

CLASS lcl_event_receiver_005 DEFINITION DEFERRED.

DATA: gv_okcode TYPE sy-ucomm.
DATA: o_oms TYPE REF TO /ptloms/cl002 ##NEEDED.

TYPES: BEGIN OF ty_expiration_alert,
         werks          TYPE werks_d,
         license_id     TYPE sysuuid_c32,
         valid_to       TYPE dats,
         days_remaining TYPE i,
         status         TYPE char15,
         message        TYPE string,
       END OF ty_expiration_alert,

       ty_t_expiration_alert TYPE STANDARD TABLE OF ty_expiration_alert
                        WITH DEFAULT KEY.

DATA: lo_license_service TYPE REF TO /ptloms/cl024,
      lt_alerts          TYPE table of ty_expiration_alert,"ty_t_expiration_alert,
      ls_alert           TYPE ty_expiration_alert.


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

*&SPWIZARD: DECLARATION OF TABLECONTROL '/PTLOMS/TC001' ITSELF
CONTROLS: /ptloms/tc001 TYPE TABLEVIEW USING SCREEN 0005.
