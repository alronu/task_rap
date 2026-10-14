CLASS zcl_jr_task_generate_data DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: fill_task IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out,
      fill_task_details IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out,
      fill_task_objects IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_jr_task_generate_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*   me->fill_task( io_out = out ).
*   me->fill_task_details( io_out = out ).
    me->fill_task_objects( io_out = out ).
  ENDMETHOD.

  METHOD fill_task.
    TYPES: BEGIN OF ty_task,
             idtask       TYPE string,
             nombre       TYPE string,
             descripcion  TYPE string,
             paquete      TYPE string,
             area         TYPE string,
             Ticket       TYPE string,
             Departamento TYPE string,
             Lider        TYPE string,
             Estado       TYPE string,
           END OF ty_task.

    DATA: ls_task TYPE ty_task,
          lv_json TYPE string,
          lt_json TYPE STANDARD TABLE OF ty_task.

    TRY.

        /ui2/cl_json=>deserialize(
                                  EXPORTING
                                    json             = lv_json
                                    pretty_name      = abap_true
                                    assoc_arrays     = abap_true
                                    assoc_arrays_opt = abap_true
                                 CHANGING
                                    data             = lt_json
                                 ).

*      key task_uuid   : sysuuid_x16 not null;
*      task_id         : abap.numc(10);
*      name            : abap.char(200);
*      description_    : abap.char(800);
*      ticket          : abap.char(6);
*      created_date    : abap.dats;
*      delivery_date   : abap.dats;
*      package_        : abap.char(20) not null;
*      leader          : abap.char(40);
*      status          : zjr_de_status not null;
*      area            : zjr_de_area not null;
*      priority        : zjr_de_priority not null;

        DELETE FROM zjr_task.
        COMMIT WORK AND WAIT.

        LOOP AT lt_json INTO DATA(ls_json).
          DATA(ls_row) = VALUE zjr_task(
                                        client          = sy-mandt
                                        task_uuid       = ls_json-idtask
                                        task_id         = sy-tabix
                                        name            = ls_json-nombre
                                        description_    = ls_json-descripcion
                                        ticket          = ls_json-ticket
                                        package_        = ls_json-paquete
                                        leader          = ls_json-lider
                                        status          = COND #( WHEN ls_json-estado = 'Terminado' THEN '103'
                                                                  WHEN ls_json-estado = 'PruebasIntegrales' THEN '102'
                                                                  WHEN ls_json-estado = 'Creado' THEN '100'
                                                                  WHEN ls_json-estado = 'Analisis' THEN '101'
                                                                  WHEN ls_json-estado = 'Cancelled' THEN '104'
                                                                  WHEN ls_json-estado = 'EnProceso' THEN '101'
                                                                  WHEN ls_json-estado = 'Hold' THEN '105'
                                                                  WHEN ls_json-estado = 'PruebasUnitarias' THEN '102'
                                                                )
                                        area            = ls_json-area
                                        priority        = '1'
                                      ).
          INSERT zjr_task FROM @ls_row.
          COMMIT WORK AND WAIT.

        ENDLOOP.

      CATCH cx_ROOT INTO DATA(cx).
        io_out->write( cx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD fill_task_details.

    TYPES: BEGIN OF ty_task,
             tdsubtask   TYPE string,
             idtask      TYPE string,
             Orden       TYPE string,
             TipoOrden   TYPE string,
             Descripcion TYPE string,
             Estado      TYPE string,
             ticket      TYPE string,

           END OF ty_task.

    DATA: ls_task TYPE ty_task,
          lv_json TYPE string,
          lt_json TYPE STANDARD TABLE OF ty_task.

    TRY.

        /ui2/cl_json=>deserialize(
                                  EXPORTING
                                    json             = lv_json
                                    pretty_name      = abap_true
                                    assoc_arrays     = abap_true
                                    assoc_arrays_opt = abap_true
                                 CHANGING
                                    data             = lt_json
                                 ).

*      key client      : abap.clnt not null;
*      key task_uuid   : sysuuid_x16 not null;
*      key detail_uuid : sysuuid_x16 not null;
*      order_number    : abap.char(10);
*      order_type      : zjr_de_order_type;
*      status          : zjr_de_status_det;
*      description     : abap.char(200);
*      created_date    : abap.dats;
*      ticket          : abap.char(6);

        DELETE FROM zjr_task_details.
        COMMIT WORK AND WAIT.

        LOOP AT lt_json INTO DATA(ls_json).
          DATA(ls_row) = VALUE zjr_task_details(
                                        client          = sy-mandt
                                        task_uuid       = ls_json-idtask
                                        detail_uuid     = ls_json-tdsubtask
                                        order_number    = ls_json-orden
                                        order_type      = ls_json-tipoorden
                                        description     = ls_json-descripcion
                                        ticket          = ls_json-ticket
                                        status          = ls_json-estado
                                      ).
          INSERT zjr_task_details FROM @ls_row.
          COMMIT WORK AND WAIT.

        ENDLOOP.

      CATCH cx_ROOT INTO DATA(cx).
        io_out->write( cx->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

  METHOD fill_task_objects.
    TYPES: BEGIN OF ty_task,
             idtask   TYPE string,
             idobject TYPE string,
             tipo     TYPE string,
             nombre   TYPE string,
           END OF ty_task.

    DATA: ls_task TYPE ty_task,
          lv_json TYPE string,
          lt_json TYPE STANDARD TABLE OF ty_task.

    TRY.

        /ui2/cl_json=>deserialize(
                                  EXPORTING
                                    json             = lv_json
                                    pretty_name      = abap_true
                                    assoc_arrays     = abap_true
                                    assoc_arrays_opt = abap_true
                                 CHANGING
                                    data             = lt_json
                                 ).

*      key client      : abap.clnt not null;
*      key task_uuid   : sysuuid_x16 not null;
*      key object_uuid : sysuuid_x16 not null;
*      object_type     : zjr_de_object_type;
*      object_name     : abap.char(200);

        DELETE FROM zjr_task_objects.
        COMMIT WORK AND WAIT.

        LOOP AT lt_json INTO DATA(ls_json).
          DATA(ls_row) = VALUE zjr_task_objects(
                                        client          = sy-mandt
                                        task_uuid       = ls_json-idtask
                                        object_uuid     = ls_json-idobject
                                        object_type     = ls_json-tipo
                                        object_name     = ls_json-nombre
                                      ).
          INSERT zjr_task_objects FROM @ls_row.
          COMMIT WORK AND WAIT.

        ENDLOOP.

      CATCH cx_ROOT INTO DATA(cx).
        io_out->write( cx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
