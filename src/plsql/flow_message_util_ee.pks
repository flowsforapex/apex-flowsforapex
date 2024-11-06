create or replace package flow_message_util_ee
/* 
-- Flows for APEX - flow_message_util_ee.pks
-- 
-- (c) Copyright Flowqueat Limited and / or its affiliates, 2024.
-- Package Spec released under Flows for APEX Community Edition MIT licence.
--
-- Created  06-May-2024  Richard Allen (Flowquest Limited)
--
*/
as

    function correlate_start_event
    ( p_message_name  flow_message_subscriptions.msub_message_name%type 
    ) return flow_message_subscriptions%rowtype;

    procedure b_event_save_payload_and_callback
    ( p_msub           in flow_message_subscriptions%rowtype
    , p_payload        in clob default null
    , p_current        in flow_objects.objt_bpmn_id%type 
    , p_scope          in flow_subflows.sbfl_scope%type
    );

    procedure start_event_save_payload_and_callback
    ( p_msub           in flow_message_subscriptions%rowtype
    , p_payload        in clob default null
    );

    procedure cancel_diagram_subscriptions
    ( p_dgrm_id        in flow_diagrams.dgrm_id%type
    , p_callback       in flow_message_subscriptions.msub_callback%type
    );

    procedure end_event_send_message
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    );
    
end flow_message_util_ee;
/
