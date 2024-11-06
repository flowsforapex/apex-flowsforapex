create or replace package flow_types_pkg
/* 
-- Flows for APEX - flow_types_pkg.pks
-- 
-- (c) Copyright MT AG, 2020-2022.
-- (c) Copyright Flowquest Limited. 2024.
--
-- Created  11-Sep-2020  Moritz Klein (MT AG)
-- Modified 09-Jan-2024  Richard Allen, Flowquest Limited
--
*/
  authid definer
as

  subtype t_bpmn_id             is varchar2(50 char);
  subtype t_bpmn_attributes_key is varchar2(50 char);
  subtype t_bpmn_attribute_vc2  is varchar2(4000 char);

  subtype t_vc200              is varchar2(200 char);
  subtype t_vc50               is varchar2(50 char);
  subtype t_vc20               is varchar2(20 char);
  subtype t_single_vc2         is varchar2(1 char);
  subtype t_boolean_num        is number(1);

  subtype t_expr_type          is varchar2(130 char);
  subtype t_expr_set           is varchar2(20 char);

  type flow_step_info is record
  ( dgrm_id                   flow_diagrams.dgrm_id%type
  , source_objt_tag           flow_objects.objt_tag_name%type
  , source_objt_id            flow_objects.objt_id%type
  , target_objt_id            flow_objects.objt_id%type
  , target_objt_name          flow_objects.objt_name%type
  , target_objt_ref           flow_objects.objt_bpmn_id%type
  , target_objt_tag           flow_objects.objt_tag_name%type
  , target_objt_treat_as_tag  flow_objects.objt_tag_name%type
  , target_objt_subtag        flow_objects.objt_sub_tag_name%type
  , target_objt_lane          flow_objects.objt_bpmn_id%type
  , target_objt_lane_name     flow_objects.objt_name%type
  , target_objt_lane_isRole   varchar2(10 char)
  , target_objt_lane_role     flow_subflows.sbfl_potential_groups%type
  , target_objt_attributes    flow_objects.objt_attributes%type
  , target_objt_iteration     flow_subflows.sbfl_iteration_type%type
  , target_objt_step_key      flow_subflows.sbfl_step_key%type
  );

  type t_subflow_context is record
  ( sbfl_id           flow_subflows.sbfl_id%type
  , step_key          flow_subflows.sbfl_step_key%type
  , route             flow_subflows.sbfl_route%type
  , scope             flow_subflows.sbfl_scope%type
  );

  -- Type              -- t_iteration_vars
  -- Purpose           -- used to hold the input, output, or description expression sub-components of an iteration definition
  -- type              -- gc_expr_type_sql_json_array
                       -- gc_expr_type_list
                       -- gc_expr_type_array 
  -- collection_var    -- if the expression is a process varuable, this contains the variable name
  -- collection_expr   -- if the expression is a SQL Query, PLSql function, etc., this contains the expression text
                       -- note that the expresion can be longer than a variable name, so you need to use this for the actual
                       -- expression
  -- inside_var        -- variable name to be used inside the iteration (so inport to these / export from these)
  -- description       -- the description string, typically contains substitution parameters
  type t_iteration_vars is record
  ( type            flow_types_pkg.t_vc20
  , collection_var  flow_process_variables.prov_var_name%type
  , collection_expr t_bpmn_attribute_vc2
  , inside_var      flow_process_variables.prov_var_name%type
  , description     varchar2(4000)
  );
  
  type t_iteration_status is record
  ( iteration_var   flow_process_variables.prov_var_name%type
  , var_scope       flow_subflows.sbfl_scope%type
  , iobj_id         flow_iterated_objects.iobj_id%type
  , num_iterations  number
  , is_complete     boolean
  );

end flow_types_pkg;
/
