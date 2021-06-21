create or replace package body flow_plugin_process_variable_to_item as

   function execution (
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   ) return apex_plugin.t_process_exec_result 
   as
      l_result                   apex_plugin.t_process_exec_result;

    --attributes
      l_attribute1               p_process.attribute_01%type := p_process.attribute_01; -- Select Flow (Diagram) using
      l_attribute2               p_process.attribute_02%type := p_process.attribute_02; -- Flow name (items) & Flow version
      l_attribute3               p_process.attribute_03%type := p_process.attribute_03; -- Flow name (query)
      l_attribute4               p_process.attribute_04%type := p_process.attribute_04; -- Flow name (text)
      l_attribute5               p_process.attribute_05%type := p_process.attribute_05; -- Start instance (Y/N)
      l_attribute6               p_process.attribute_06%type := p_process.attribute_06; -- Set pocess variables (list)
      l_attribute7               p_process.attribute_07%type := p_process.attribute_07; -- Flow (Diagram) Selection
      l_attribute8               p_process.attribute_08%type := p_process.attribute_08; -- PV json
      l_attribute9               p_process.attribute_09%type := p_process.attribute_09; -- PV SQL
      l_attribute10              p_process.attribute_10%type := p_process.attribute_10; -- Business Reference
      l_attribute11              p_process.attribute_11%type := p_process.attribute_11; -- Instance Name (item)
      l_attribute12              p_process.attribute_12%type := p_process.attribute_12; -- Return Instance Id
      l_attribute13              p_process.attribute_13%type := p_process.attribute_13; -- Instance Name mode
      l_attribute14              p_process.attribute_14%type := p_process.attribute_14; -- Instance Name (text) 
      l_attribute15              p_process.attribute_15%type := p_process.attribute_15; -- Instance Name (SQL)
      l_g_attribute1             p_plugin.attribute_01%type := p_plugin.attribute_01; -- Global attribute
      l_context                  apex_exec.t_context;
      l_dgrm_id                  flow_diagrams.dgrm_id%type;
      l_dgrm_name                flow_diagrams.dgrm_name%type;
      l_dgrm_version             flow_diagrams.dgrm_version%type;
      l_prcs_name                flow_processes.prcs_name%type;
      l_prcs_id                  flow_processes.prcs_id%type;
      l_json                     clob;
      l_process_variables        json_array_t;
      l_process_variables_count  number;
      l_process_variable         json_object_t;
      l_var_name                 varchar2(4000);
      l_var_type                 varchar2(4000);
      l_split_values             apex_t_varchar2;
      l_sql_parameters           apex_exec.t_parameters;
   begin

      return l_result;
   end execution;

end flow_plugin_process_variable_to_item;