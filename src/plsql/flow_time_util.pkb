create or replace package body flow_time_util
as 
/* 
-- Flows for APEX - flow_time_util.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created    23-Nov-2022  Richard Allen (Oracle)
--
*/

 /*       <apex:expressionType>processVariable</apex:type>       
        <apex:valueType>date</apex:valuetype>   
        <apex:value>F4A$MyVC2Var</apex:variable>
        <apex:dataType>varchar2</apex:dataType>
        <apex:formatMask>DD-MON-YYYY"T"HH24:MI:SS</apex:formatMask>
        <apex:timeZone>+8.00</apex:formatMask>
        */

  function calculate_due_date
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_due_date_def  flow_objects.objt_attributes%type
  ) return timestamp with time zone
  is
    l_json_def          sys.json_object_t;
    l_expression_type   flow_types_pkg.t_bpmn_attribute_vc2;
    l_value_type        flow_types_pkg.t_bpmn_attribute_vc2;
    l_value             flow_types_pkg.t_bpmn_attribute_vc2;
    l_data_type         flow_types_pkg.t_bpmn_attribute_vc2;
    l_format_mask       flow_types_pkg.t_bpmn_attribute_vc2;
    l_expression        flow_types_pkg.t_bpmn_attribute_vc2;
    l_function_body     flow_types_pkg.t_bpmn_attribute_vc2;
  begin
    -- split based on expression type
    l_json_def        := sys.json_object_t.parse( pi_due_date_def );

    l_expression_type    := l_json_config.get_string( 'expressionType' );
    l_value_type         := l_json_config.get_string( 'valueType' );
    l_value              := l_json_config.get_string( 'value' );
    l_data_type          := l_json_config.get_string( 'dataType' );
    l_format_mask        := l_json_config.get_string( 'formatMask' );
    l_expression         := l_json_config.get_string( 'expression' );
    l_function_body      := l_json_config.get_string( 'functionBody' );


    case l_expression_type 
    when flow_constants_pkg.gc_expr_type_process_variable then
      null;
    when flow_constants_pkg.gc_expr_type_static then
      null;
    when flow_constants_pkg.gc_expr_type_plsql_function_body then
      null;
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      null;
    end case;

    return systimestamp;
  end calculate_due_date;


end flow_time_util;
/
