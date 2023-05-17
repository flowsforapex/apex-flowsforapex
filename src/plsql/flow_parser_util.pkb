create or replace package body flow_parser_util
as

  procedure split_property_name
  (
    pi_property_name  in        varchar2
  , po_namespace     out nocopy varchar2
  , po_key           out nocopy varchar2
  )
  as
    l_token_pos pls_integer;
  begin
    l_token_pos := instr( pi_property_name, ':' );
    if l_token_pos is not null then
      po_namespace := substr( pi_property_name, 1, instr(pi_property_name, ':') - 1);
      po_key       := substr( pi_property_name, instr(pi_property_name, ':') + 1 );
    else
      po_namespace := null;
      po_key       := pi_property_name;
    end if;

  end split_property_name;

  function get_property_key( pi_property_name in varchar2 )
    return varchar2
  as
    l_namespace varchar2(32767);
    l_key       varchar2(32767);
  begin
    split_property_name
    (
      pi_property_name => pi_property_name
    , po_namespace     => l_namespace
    , po_key           => l_key
    );
    return l_key;
  end get_property_key;

  procedure guarantee_apex_object
  (
    pio_attributes in out nocopy sys.json_object_t
  )
  as
    c_key constant varchar2(20) := 'apex';
  begin
    -- Initialize the main object if not done already
    pio_attributes := coalesce( pio_attributes, sys.json_object_t() );
    -- Create empty "apex" object if not existing
    if not pio_attributes.has( c_key ) then
      pio_attributes.put( c_key, sys.json_object_t() );
    end if;
  end guarantee_apex_object;

  procedure guarantee_bpmn_object
  (
    pio_attributes in out nocopy sys.json_object_t
  )
  as
    c_key constant varchar2(20) := 'bpmn';
  begin
    -- Initialize the main object if not done already
    pio_attributes := coalesce( pio_attributes, sys.json_object_t() );
    -- Create empty "bpmn" object if not existing
    if not pio_attributes.has( c_key ) then
      pio_attributes.put( c_key, sys.json_object_t() );
    end if;
  end guarantee_bpmn_object;

  procedure guarantee_named_object
  (
    pio_attributes in out nocopy sys.json_object_t
  , pi_key         in varchar2
  )
  as
  begin
    -- Initialize the main object if not done already
    pio_attributes := coalesce( pio_attributes, sys.json_object_t() );
    -- Create empty "pi_key" object if not existing
    if not pio_attributes.has( pi_key ) then
      pio_attributes.put( pi_key, sys.json_object_t() );
    end if;
  end guarantee_named_object;

  /**
   * Description: Takes a CLOB and splits it of linefeed or 4000 characters and emits a JSON_ARRAY_T representation
   *
   * Author:  Moritz Klein
   * Created: 4/20/2022
   *
   * Param: pi_str Input to tokenize at linefeed or 4000 characters
   * Return: JSON_ARRAY_T representation of input
   */
  function get_lines_array
  (
    pi_str in clob
  ) return sys.json_array_t
  as
    l_values apex_t_varchar2;
    l_return sys.json_array_t := sys.json_array_t();
  begin
    l_values := apex_string.split( p_str => pi_str );
    for i in 1..l_values.count loop
      if l_values(i) is not null then
        l_return.append( l_values(i) );
      else -- seems awkward, but this gives you an empty string instead of null into the JSON
        l_return.append( '' );
      end if;
    end loop;
    return l_return;
  end get_lines_array;

  procedure property_to_json
  (
    pi_property_name  in        varchar2
  , pi_value          in        clob
  , po_namespace     out nocopy varchar2
  , po_key           out nocopy varchar2
  , po_json_element  out nocopy sys.json_element_t
  )
  as
  begin

    split_property_name
    (
      pi_property_name => pi_property_name
    , po_namespace     => po_namespace
    , po_key           => po_key
    );

    if pi_property_name in ( flow_constants_pkg.gc_apex_task_plsql_code
                           , flow_constants_pkg.gc_bpmn_text
                           , flow_constants_pkg.gc_apex_servicetask_body_text
                           , flow_constants_pkg.gc_apex_servicetask_body_html
                           , flow_constants_pkg.gc_apex_servicetask_attachment
                           , flow_constants_pkg.gc_apex_expression
                           )
    then
      po_json_element := get_lines_array( pi_str => pi_value );
    elsif pi_property_name in ( flow_constants_pkg.gc_apex_servicetask_placeholder
                              , flow_constants_pkg.gc_apex_custom_extension
                              )
    then
      -- this is already JSON, better store differently
      po_json_element := sys.json_object_t.parse( replace( replace( pi_value, chr(38)||'amp;', chr(38) ), chr(10) ) );
    
    elsif po_key = 'priority'
    then
      -- if the attribute priority ends up here it is the pre 23.1 way
      -- we don't touch the diagram but will store the new definition in objt_attributes
      po_json_element := sys.json_object_t.parse( '{ "expressionType":"plsqlRawExpression","expression":["' || pi_value || '"]}' );
    else
      po_json_element := null;
    end if; 
  end property_to_json;

  function is_log_enabled
    return boolean
  as
    l_value flow_configuration.cfig_value%type;
  begin

    select cfig_value
      into l_value
      from flow_configuration
     where cfig_key = 'parser_log_enabled'
    ;

    return ( l_value = flow_constants_pkg.gc_vcbool_true );

  exception
    when no_data_found then
      return false;
  end is_log_enabled;

  procedure log
  (
    pi_plog_dgrm_id    in flow_parser_log.plog_dgrm_id%type
  , pi_plog_bpmn_id    in flow_parser_log.plog_bpmn_id%type
  , pi_plog_parse_step in flow_parser_log.plog_parse_step%type
  , pi_plog_payload    in flow_parser_log.plog_payload%type
  )
  as
    pragma autonomous_transaction;
  begin

    insert into flow_parser_log ( plog_dgrm_id, plog_bpmn_id, plog_parse_step, plog_payload, plog_log_time )
      values ( pi_plog_dgrm_id, pi_plog_bpmn_id, pi_plog_parse_step, pi_plog_payload, systimestamp )
    ;
    commit;

  end log;

end flow_parser_util;
/
