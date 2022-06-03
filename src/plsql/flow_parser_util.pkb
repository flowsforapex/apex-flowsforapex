create or replace package body flow_parser_util
as

  -- Private Methods
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

  -- Public Methods
  procedure guarantee_apex_object
  (
    pio_objt_attributes in out nocopy sys.json_object_t
  )
  as
    c_key constant varchar2(20) := 'apex';
  begin
    -- Initialize the main object if not done already
    pio_objt_attributes := coalesce( pio_objt_attributes, sys.json_object_t() );
    -- Create empty "apex" object if not existing
    if not pio_objt_attributes.has( c_key ) then
      pio_objt_attributes.put( c_key, sys.json_object_t() );
    end if;
  end guarantee_apex_object;

  procedure guarantee_bpmn_object
  (
    pio_objt_attributes in out nocopy sys.json_object_t
  )
  as
    c_key constant varchar2(20) := 'bpmn';
  begin
    -- Initialize the main object if not done already
    pio_objt_attributes := coalesce( pio_objt_attributes, sys.json_object_t() );
    -- Create empty "bpmn" object if not existing
    if not pio_objt_attributes.has( c_key ) then
      pio_objt_attributes.put( c_key, sys.json_object_t() );
    end if;
  end guarantee_bpmn_object;

  procedure guarantee_named_object
  (
    pio_objt_attributes in out nocopy sys.json_object_t
  , pi_key              in varchar2
  )
  as
  begin
    -- Initialize the main object if not done already
    pio_objt_attributes := coalesce( pio_objt_attributes, sys.json_object_t() );
    -- Create empty "pi_key" object if not existing
    if not pio_objt_attributes.has( pi_key ) then
      pio_objt_attributes.put( pi_key, sys.json_object_t() );
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
                           )
    then
      po_json_element := get_lines_array( pi_str => pi_value );
    elsif pi_property_name = flow_constants_pkg.gc_apex_servicetask_placeholder
    then
      -- this is already JSON, better store differently
      po_json_element := sys.json_object_t.parse( pi_value );
    else
      po_json_element := null;
    end if; 
  end property_to_json;

end flow_parser_util;
/
