create or replace package flow_parser_util
  authid definer
as
-- Holds all types needed during parsing and utility methods
-- The types are fitted to use natural keys
-- and are converted using the utility methods

-- Types
 type t_objt_rec is
    record
    (
      objt_name           flow_types_pkg.t_vc200
    , objt_tag_name       flow_types_pkg.t_bpmn_id
    , objt_parent_bpmn_id flow_types_pkg.t_bpmn_id
    , objt_sub_tag_name   flow_types_pkg.t_bpmn_id
    , objt_attached_to    flow_types_pkg.t_bpmn_id
    , objt_interrupting   flow_types_pkg.t_boolean_num
    , objt_attributes     sys.json_object_t
    );
  type t_objt_tab is table of t_objt_rec index by flow_types_pkg.t_bpmn_id;

  type t_expr_rec is
    record
    (
      expr_set        flow_object_expressions.expr_set%type
    , expr_order      flow_object_expressions.expr_order%type
    , expr_var_name   flow_object_expressions.expr_var_name%type
    , expr_var_type   flow_object_expressions.expr_var_type%type
    , expr_type       flow_object_expressions.expr_type%type
    , expr_expression flow_object_expressions.expr_expression%type
    );
  type t_expr_tab is table of t_expr_rec index by pls_integer;
  type t_objt_expr_tab is table of t_expr_tab index by flow_types_pkg.t_bpmn_id;

  type t_conn_rec is
    record
    (
      conn_name        flow_types_pkg.t_vc200
    , conn_src_bpmn_id flow_types_pkg.t_bpmn_id
    , conn_tgt_bpmn_id flow_types_pkg.t_bpmn_id
    , conn_tag_name    flow_types_pkg.t_bpmn_id
    , conn_origin      flow_types_pkg.t_bpmn_id
    );
  type t_conn_tab is table of t_conn_rec index by flow_types_pkg.t_bpmn_id;

  type t_bpmn_ref_tab is table of flow_types_pkg.t_bpmn_id index by flow_types_pkg.t_bpmn_id;
  type t_bpmn_id_tab is table of number index by flow_types_pkg.t_bpmn_id;

  type t_id_lookup_tab is table of number index by flow_types_pkg.t_bpmn_id;

  -- Methods

  procedure guarantee_apex_object
  (
    pio_objt_attributes in out nocopy sys.json_object_t
  );

  procedure guarantee_bpmn_object
  (
    pio_objt_attributes in out nocopy sys.json_object_t
  );

  procedure guarantee_named_object
  (
    pio_objt_attributes in out nocopy sys.json_object_t
  , pi_key              in varchar2
  );

  procedure property_to_json
  (
    pi_property_name  in varchar2
  , pi_value          in clob
  , po_namespace     out nocopy varchar2
  , po_key           out nocopy varchar2
  , po_json_element  out nocopy sys.json_element_t
  );

end flow_parser_util;
/
