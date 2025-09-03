PROMPT >> Update Rest endpoints

begin

  if flow_rest_install.is_rest_enabled(user) and flow_rest_install.is_module_published(user) then
    ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'v1',
      p_pattern        => 'diagrams/:dgrm_id/export',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => NULL);

    ORDS.DEFINE_HANDLER(
        p_module_name    => 'v1',
        p_pattern        => 'diagrams/:dgrm_id/export',
        p_method         => 'GET',
        p_source_type    => 'resource/lob',
        p_items_per_page => 0,
        p_mimes_allowed  => NULL,
        p_comments       => 'Get the XML BPMN of a specific diagram',
        p_source         => 
  'select ''application/xml''
      , content
      , TO_CHAR(SYSDATE, ''YYYYMMDD-HH24mi'') || ''_'' ||regexp_replace(name, ''\s+'', ''_'') || ''_'' || status  || ''_'' || version || ''.bpmn'' as filename
    from flow_rest_diagrams_vw 
    where 1 = (select flow_rest_auth.has_privilege_read(:current_user) from dual) 
      and dgrm_id = :dgrm_id');

    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'v1',
        p_pattern            => 'diagrams/:dgrm_id/export',
        p_method             => 'GET',
        p_name               => 'dgrm_id',
        p_bind_variable_name => 'dgrm_id',
        p_source_type        => 'URI',
        p_param_type         => 'DOUBLE',
        p_access_method      => 'IN',
        p_comments           => NULL);


    ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'v1',
      p_pattern        => 'processes/:prcs_id/activities',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => NULL);

    ORDS.DEFINE_HANDLER(
        p_module_name    => 'v1',
        p_pattern        => 'processes/:prcs_id/activities',
        p_method         => 'GET',
        p_source_type    => 'json/collection',
        p_mimes_allowed  => NULL,
        p_comments       => 'Get Running, Ended and Error process Activities',
        p_source         => 
  'with  current_activities as (
        select s."current" as sbfl_current
        from flow_rest_subflows_vw s
          ,  flow_rest_processes_vw p 
        where  s.prcs_id = p.prcs_id	 	 
        and    p.prcs_id = :prcs_id
        and    s.status != ''error''
      ),
      completed_activities as (
        select e.lgsf_objt_id
        from flow_rest_step_event_log_vw e
          , flow_rest_processes_vw      p 
        where  e.lgsf_prcs_id = p.prcs_id
        and    p.prcs_id      = :prcs_id
      ),
      error_activities as (
        select s."current" as sbfl_current
        from flow_rest_subflows_vw s
          ,  flow_rest_processes_vw p 
        where  s.prcs_id = p.prcs_id	 	 
        and    p.prcs_id = :prcs_id
        and    s.status  = ''error''
      )
      select (select json_arrayagg(sbfl_current order by sbfl_current) from current_activities) as "current",
            (select json_arrayagg(lgsf_objt_id order by lgsf_objt_id) from completed_activities) as "completed",
            (select json_arrayagg(sbfl_current order by sbfl_current) from error_activities) as "error"
      from    dual
      where 1 = (select flow_rest_auth.has_privilege_read(:current_user) from dual)');

    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'v1',
        p_pattern            => 'processes/:prcs_id/activities',
        p_method             => 'GET',
        p_name               => 'prcs_id',
        p_bind_variable_name => 'prcs_id',
        p_source_type        => 'URI',
        p_param_type         => 'DOUBLE',
        p_access_method      => 'IN',
        p_comments           => 'Process Instance Id');
  end if;

end;
/