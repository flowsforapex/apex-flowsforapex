create or replace package body flow_parser_util
as

  -- Private Methods

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
    -- Create empty "bpmn" object if not existing
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
      l_return.append( l_values(i) );
    end loop;
    return l_return;
  end get_lines_array;

  procedure split_property_name
  (
    pi_prop_name in         varchar2
  , po_namespace out nocopy varchar2
  , po_attribute out nocopy varchar2
  )
  as
    l_token_pos pls_integer;
  begin
    l_token_pos := instr( pi_prop_name, ':' );
    if l_token_pos is not null then
      po_namespace := substr( pi_prop_name, 1, instr(pi_prop_name, ':') - 1);
      po_attribute := substr( pi_prop_name, instr(pi_prop_name, ':') + 1 );
    else
      po_namespace := null;
      po_attribute := pi_prop_name;
    end if;

  end split_property_name;

end flow_parser_util;
/
