create or replace package body flow_parameters
as
/* 
-- Flows for APEX - flow_parameters.pkb
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates. 2026.
--
-- Created    07-Feb-2026  Richard Allen (Flowquest Limited)
--
-- Package for processing BPMN task input/output parameters
*/

  function process_input_parameters
  (
    pi_parameter_definitions  in clob
  , pi_user_input_data        in clob  
  , pi_process_id             in flow_processes.prcs_id%type
  , pi_subflow_id             in flow_subflows.sbfl_id%type default null
  , pi_scope                  in flow_subflows.sbfl_scope%type default 0
  ) return clob
  is
    l_param_defs       json_array_t;
    l_user_input       json_object_t;
    l_result_params    json_object_t;
    l_param            json_object_t;
    l_source           json_object_t;
    l_param_name       varchar2(128);
    l_expression_type  varchar2(50);
    l_expression       varchar2(4000);
    l_param_value      clob;
    l_proc_var         flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter('process_input_parameters', 'pi_process_id', pi_process_id, 'pi_scope', pi_scope);
    
    -- Initialize result object
    l_result_params := json_object_t();
    
    -- Parse user input if provided
    if pi_user_input_data is not null and pi_user_input_data is json then
      l_user_input := json_object_t(pi_user_input_data);
    else
      l_user_input := json_object_t();
    end if;
    
    -- Parse parameter definitions
    if pi_parameter_definitions is null or pi_parameter_definitions is not json then
      return l_result_params.to_clob();
    end if;
    
    l_param_defs := json_array_t(pi_parameter_definitions);
    
    -- Process each parameter definition
    for i in 0 .. l_param_defs.get_size - 1 loop
      l_param := json_object_t(l_param_defs.get(i));
      l_param_name := l_param.get_string('name');
      
      if l_param.has('source') then
        l_source := json_object_t(l_param.get('source'));
        l_expression_type := l_source.get_string('expressionType');
        
        case l_expression_type
          when 'userInput' then
            -- Get value from user input JSON
            if l_user_input.has(l_param_name) then
              l_param_value := l_user_input.get_string(l_param_name);
              l_result_params.put(l_param_name, l_param_value);
            end if;
            
          when 'processVariable' then
            -- Get value from process variable - handle all data types
            l_expression := l_source.get_string('expression');
            l_proc_var := flow_proc_vars_int.get_var_value
                         ( pi_prcs_id   => pi_process_id
                         , pi_var_name  => l_expression
                         , pi_scope     => pi_scope
                         );
            
            -- Convert to appropriate JSON value based on variable type
            case l_proc_var.var_type
              when flow_constants_pkg.gc_prov_var_type_varchar2 then
                if l_proc_var.var_vc2 is not null then
                  l_result_params.put(l_param_name, l_proc_var.var_vc2);
                end if;
              when flow_constants_pkg.gc_prov_var_type_number then
                if l_proc_var.var_num is not null then
                  l_result_params.put(l_param_name, l_proc_var.var_num);
                end if;
              when flow_constants_pkg.gc_prov_var_type_date then
                if l_proc_var.var_date is not null then
                  l_result_params.put(l_param_name, to_char(l_proc_var.var_date, 'YYYY-MM-DD"T"HH24:MI:SS'));
                end if;
              when flow_constants_pkg.gc_prov_var_type_clob then
                if l_proc_var.var_clob is not null then
                  -- For CLOB, try to parse as JSON if possible, otherwise treat as string
--                  if l_proc_var.var_clob is json then
--                    l_result_params.put_parse(l_param_name, l_proc_var.var_clob);
--                  else
                    l_result_params.put(l_param_name, l_proc_var.var_clob);
--
                end if;
              when flow_constants_pkg.gc_prov_var_type_tstz then
                if l_proc_var.var_tstz is not null then
                  l_result_params.put(l_param_name, to_char(l_proc_var.var_tstz, 'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM'));
                end if;
              else
                -- Default to varchar2 for unknown types
                if l_proc_var.var_vc2 is not null then
                  l_result_params.put(l_param_name, l_proc_var.var_vc2);
                end if;
            end case;
            
          when 'static' then
            -- Use static value from expression
            l_expression := l_source.get_string('expression');
            l_result_params.put(l_param_name, l_expression);
            
          else
            -- Future: expression, sqlQuery, systemValue, etc.
            apex_debug.warn('Unsupported expressionType: ' || l_expression_type);
        end case;
      end if;
    end loop;
    
    return l_result_params.to_clob();
    
  exception
    when others then
      apex_debug.error('Error in process_input_parameters: ' || sqlerrm);
      return json_object_t().to_clob();
  end process_input_parameters;

  function get_user_input_schema
  (
    pi_parameter_definitions  in clob
  ) return clob
  is
  begin
    -- Delegate to the parameters_to_json_schema function with user_data_only = true
    return parameters_to_json_schema(pi_parameter_definitions, true);
  end get_user_input_schema;

  function validate_parameters
  (
    pi_parameter_definitions  in clob
  , pi_parameter_values       in clob
  ) return boolean
  is
    l_param_defs     json_array_t;
    l_param_values   json_object_t;
    l_param          json_object_t;
    l_param_name     varchar2(128);
    l_is_required    boolean;
  begin
    -- Parse inputs
    if pi_parameter_definitions is null or pi_parameter_definitions is not json then
      return true; -- No definitions to validate against
    end if;
    
    if pi_parameter_values is null or pi_parameter_values is not json then
      return false; -- Invalid parameter values
    end if;
    
    l_param_defs := json_array_t(pi_parameter_definitions);
    l_param_values := json_object_t(pi_parameter_values);
    
    -- Check each required parameter
    for i in 0 .. l_param_defs.get_size - 1 loop
      l_param := json_object_t(l_param_defs.get(i));
      l_param_name := l_param.get_string('name');
      l_is_required := l_param.get_boolean('required');
      
      if l_is_required and not l_param_values.has(l_param_name) then
        apex_debug.error('Required parameter missing: ' || l_param_name);
        return false;
      end if;
    end loop;
    
    return true;
    
  exception
    when others then
      apex_debug.error('Error in validate_parameters: ' || sqlerrm);
      return false;
  end validate_parameters;

  function get_input_parameter_definitions
  (
    pi_objt_id  in flow_objects.objt_id%type
  ) return clob
  is
    l_objt_attributes clob;
    l_attributes_json json_object_t;
    l_apex_json       json_object_t;
  begin
    -- Get object attributes
    select objt.objt_attributes
      into l_objt_attributes  
      from flow_objects objt
     where objt.objt_id = pi_objt_id;
    
    if l_objt_attributes is null or l_objt_attributes is not json then
      return json_array_t().to_clob();
    end if;
    
    l_attributes_json := json_object_t(l_objt_attributes);

    if l_attributes_json.has('apex') then
      l_apex_json := json_object_t(l_attributes_json.get('apex'));
      if l_apex_json.has('inputParameters') then
        return l_apex_json.get_array('inputParameters').to_clob();
      end if;
    end if;

    return json_array_t().to_clob();
    
  exception
    when others then
      apex_debug.error('Error in get_input_parameter_definitions: ' || sqlerrm);
      return json_array_t().to_clob();
  end get_input_parameter_definitions;

  function get_output_parameter_definitions
  (
    pi_objt_id  in flow_objects.objt_id%type
  ) return clob  
  is
    l_objt_attributes clob;
    l_attributes_json json_object_t;
    l_apex_json       json_object_t;
  begin
    -- Get object attributes
    select objt.objt_attributes
      into l_objt_attributes
      from flow_objects objt  
     where objt.objt_id = pi_objt_id;
    
    if l_objt_attributes is null or l_objt_attributes is not json then
      return json_array_t().to_clob();
    end if;
    
    l_attributes_json := json_object_t(l_objt_attributes);

    if l_attributes_json.has('apex') then
      l_apex_json := json_object_t(l_attributes_json.get('apex'));
      if l_apex_json.has('outputParameters') then
        return l_apex_json.get_array('outputParameters').to_clob();
      end if;
    end if;

    return json_array_t().to_clob();
    
  exception
    when others then
      apex_debug.error('Error in get_output_parameter_definitions: ' || sqlerrm);
      return json_array_t().to_clob();
  end get_output_parameter_definitions;

  function parameters_to_json_schema
  (
    pi_parameters      in clob
  , pi_user_data_only  in boolean default false
  ) return clob
  is
    l_input_array     json_array_t;
    l_schema          json_object_t;
    l_properties      json_object_t;
    l_required_array  json_array_t;
    l_param           json_object_t;
    l_property        json_object_t;
    l_param_name      varchar2(128);
    l_param_type      varchar2(32);
    l_is_required     boolean;
    l_default_value   varchar2(4000);
    l_description     varchar2(4000);
    l_apex_props      json_object_t;
    l_source          json_object_t;
    l_expression_type varchar2(50);
  begin
    -- Return empty schema if no parameters provided
    if pi_parameters is null or pi_parameters is not json then
      l_schema := json_object_t();
      l_schema.put('type', 'object');
      l_schema.put('properties', json_object_t());
      return l_schema.to_clob();
    end if;

    -- Parse input parameters array
    l_input_array := json_array_t(pi_parameters);
    
    -- Initialize schema structure
    l_schema := json_object_t();
    l_schema.put('type', 'object');
    l_properties := json_object_t();
    l_required_array := json_array_t();

    -- Process each parameter
    for i in 0 .. l_input_array.get_size - 1 loop
      l_param := json_object_t(l_input_array.get(i));
      
      -- Check if we should include this parameter
      if pi_user_data_only then
        -- Only include userInput parameters when user_data_only = true
        if l_param.has('source') then
          l_source := json_object_t(l_param.get('source'));
          l_expression_type := l_source.get_string('expressionType');
          if l_expression_type != 'userInput' then
            continue; -- Skip this parameter
          end if;
        else
          continue; -- Skip parameters without source (shouldn't happen)
        end if;
      end if;
      
      -- Extract parameter details
      l_param_name := l_param.get_string('name');
      l_param_type := l_param.get_string('type');
      l_is_required := l_param.get_boolean('required');
      
      -- Create property object
      l_property := json_object_t();
      l_property.put('type', l_param_type);
      l_property.put('title', initcap(replace(l_param_name, '_', ' ')));
      
      -- Add default value if present
      if l_param.has('default') then
        l_default_value := l_param.get_string('default');
        l_property.put('default', l_default_value);
      end if;
      
      -- Handle APEX-specific properties and description
      l_apex_props := json_object_t();
      
      -- Add description as help text under apex object
      if l_param.has('description') then
        l_description := l_param.get_string('description');
        l_apex_props.put('help', l_description);
      end if;
      
      -- Add other APEX rendering properties if present
      if l_param.has('apexRendering') then
        declare
          l_apex_rendering json_object_t := json_object_t(l_param.get('apexRendering'));
          l_keys json_key_list := l_apex_rendering.get_keys();
          l_enum_object json_object_t;
          l_enum_keys json_key_list;
          l_enum_array json_array_t;
        begin
          -- Copy all apexRendering properties into the apex object
          for j in 1 .. l_keys.count loop
            l_apex_props.put(l_keys(j), l_apex_rendering.get(l_keys(j)));
          end loop;
          
          -- Special handling for enum - extract keys to main schema level
          if l_apex_rendering.has('enum') then
            begin
              -- Preferred shape: enum stored as JSON object.
              l_enum_object := json_object_t(l_apex_rendering.get('enum'));
            exception
              when others then
                begin
                  -- Backward-compatible/tolerant path: enum stored as JSON text.
                  l_enum_object := json_object_t.parse(l_apex_rendering.get_string('enum'));
                exception
                  when others then
                    l_enum_object := null;
                end;
            end;

            if l_enum_object is not null then
              l_enum_keys := l_enum_object.get_keys();
              l_enum_array := json_array_t();

              -- Add enum keys to main schema
              for k in 1 .. l_enum_keys.count loop
                l_enum_array.append(l_enum_keys(k));
              end loop;

              l_property.put('enum', l_enum_array);
            end if;
          end if;
        end;
      end if;
      
      -- Add apex object to property if it has any content
      if l_apex_props.get_size() > 0 then
        l_property.put('apex', l_apex_props);
      end if;
      
      -- Add to properties
      l_properties.put(l_param_name, l_property);
      
      -- Add to required array if required
      if l_is_required then
        l_required_array.append(l_param_name);
      end if;
    end loop;

    -- Build final schema
    l_schema.put('properties', l_properties);
    if l_required_array.get_size > 0 then
      l_schema.put('required', l_required_array);
    end if;

    return l_schema.to_clob();
    
  exception
    when others then
      -- Return basic schema on error
      l_schema := json_object_t();
      l_schema.put('type', 'object');
      l_schema.put('properties', json_object_t());
      l_schema.put('error', 'Failed to parse parameters: ' || sqlerrm);
      return l_schema.to_clob();
  end parameters_to_json_schema;

  function parameters_to_json_schema
  (
    pi_parameters        in clob
  , pi_user_data_only_yn in varchar2 default 'N'
  ) return clob
  is
  begin
    -- Convert varchar2 to boolean and delegate to boolean version
    return parameters_to_json_schema(
      pi_parameters      => pi_parameters,
      pi_user_data_only  => (pi_user_data_only_yn = 'Y')
    );
  end parameters_to_json_schema;

end flow_parameters;
/