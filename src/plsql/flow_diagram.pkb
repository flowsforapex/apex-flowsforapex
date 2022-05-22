/* 
-- Flows for APEX - flow_diagram.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created  10-Dec-2021 Dennis Amthor - MT AG  
-- Modified 22-May-2022 Moritz Klein - MT AG
--
*/
create or replace package body flow_diagram
as

  function create_diagram(
    pi_dgrm_name in flow_diagrams.dgrm_name%type,
    pi_dgrm_category in flow_diagrams.dgrm_category%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type)
  return flow_diagrams.dgrm_id%type
  as
    l_diagram_exists binary_integer;
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin
    select count(*)
      into l_diagram_exists
      from dual
     where exists(
           select null
             from flow_diagrams
            where dgrm_name = pi_dgrm_name
              and dgrm_version = pi_dgrm_version);

    if l_diagram_exists = 0 then
      l_dgrm_id :=
        flow_bpmn_parser_pkg.upload_diagram(
          pi_dgrm_name     => pi_dgrm_name,
          pi_dgrm_version  => pi_dgrm_version,
          pi_dgrm_category => pi_dgrm_category,
          pi_dgrm_content  => flow_constants_pkg.gc_default_xml,
          pi_dgrm_status   => flow_constants_pkg.gc_dgrm_status_draft);
      flow_bpmn_parser_pkg.parse(
        pi_dgrm_id => l_dgrm_id);
    else
      raise diagram_exists;
    end if;
    return l_dgrm_id;
  end create_diagram;


  function add_diagram_version(
    pi_dgrm_id in flow_diagrams.dgrm_id%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type)
  return flow_diagrams.dgrm_id%type
  as
    l_dgrm_id flow_diagrams.dgrm_id%type;
    r_diagrams flow_diagrams%rowtype;
  begin
    select * 
      into r_diagrams
      from flow_diagrams
     where dgrm_id = pi_dgrm_id;

    l_dgrm_id := flow_bpmn_parser_pkg.upload_diagram(
                   pi_dgrm_name => r_diagrams.dgrm_name,
                   pi_dgrm_version => pi_dgrm_version,
                   pi_dgrm_category => r_diagrams.dgrm_category,
                   pi_dgrm_content => r_diagrams.dgrm_content,
                   pi_dgrm_status => flow_constants_pkg.gc_dgrm_status_draft);

    flow_bpmn_parser_pkg.parse(
      pi_dgrm_id => l_dgrm_id);

    return l_dgrm_id;
  end add_diagram_version;


  function import_diagram(
    pi_dgrm_name in flow_diagrams.dgrm_name%type,
    pi_dgrm_category in flow_diagrams.dgrm_category%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type,
    pi_dgrm_content in flow_diagrams.dgrm_content%type,
    pi_force_overwrite in varchar2 default flow_constants_pkg.gc_false) 
  return flow_diagrams.dgrm_id%type
  as
    l_dgrm_id flow_diagrams.dgrm_id%type;
    l_dgrm_exists binary_integer;
    l_dgrm_status flow_diagrams.dgrm_status%type;
    l_diagram_unknown boolean;
    l_diagram_is_draft boolean;
  begin
    select count(*)
      into l_dgrm_exists
      from flow_diagrams
     where dgrm_name = pi_dgrm_name
       and dgrm_version = pi_dgrm_version;

    if (l_dgrm_exists > 0) then
        select dgrm_status
        into l_dgrm_status
        from flow_diagrams
        where dgrm_name = pi_dgrm_name
        and dgrm_version = pi_dgrm_version;
    end if;

    l_diagram_unknown := l_dgrm_exists = 0;
    l_diagram_is_draft := l_dgrm_exists > 0 
                      and pi_force_overwrite = flow_constants_pkg.gc_true
                      and l_dgrm_status = flow_constants_pkg.gc_dgrm_status_draft;

    if l_diagram_unknown or l_diagram_is_draft then
      l_dgrm_id := flow_bpmn_parser_pkg.upload_diagram(
        pi_dgrm_name => pi_dgrm_name,
        pi_dgrm_version => pi_dgrm_version,
        pi_dgrm_category => pi_dgrm_category,
        pi_dgrm_content => pi_dgrm_content,
        pi_force_overwrite => pi_force_overwrite = flow_constants_pkg.gc_true);
      flow_bpmn_parser_pkg.parse(
        pi_dgrm_id => l_dgrm_id);
    else
      if (l_dgrm_status = flow_constants_pkg.gc_dgrm_status_draft) then
        raise diagram_exists;
      else
        raise diagram_not_draft;
      end if;
    end if;
    return l_dgrm_id;
  end import_diagram;
  
  
  function diagram_is_modifiable(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  return boolean
  as
    l_dgrm_status flow_diagrams.dgrm_status%type;
    l_is_draft boolean;
    l_is_released boolean;
    l_is_development boolean;
  begin
    if pi_dgrm_id is not null then
      select dgrm_status
        into l_dgrm_status
        from flow_diagrams
       where dgrm_id = pi_dgrm_id;
      
      l_is_draft := l_dgrm_status = flow_constants_pkg.gc_dgrm_status_draft;
      l_is_released := l_dgrm_status = flow_constants_pkg.gc_dgrm_status_released;
      l_is_development := flow_engine_util.get_config_value(
                            p_config_key => 'engine_app_mode',
                            p_default_value => flow_constants_pkg.gc_config_default_engine_app_mode)
                        = 'development';
      return l_is_draft or (l_is_released and l_is_development);
    else
      return false;
    end if;
  end diagram_is_modifiable;

  function get_start_event(
    pi_dgrm_id    in flow_diagrams.dgrm_id%type,
    pi_prcs_id    in flow_processes.prcs_id%type)
  return flow_objects.objt_bpmn_id%type
  is
    e_unsupported_start_type exception;
    l_objt_bpmn_id           flow_subflows.sbfl_current%type;
  begin
      -- get the starting object 
      select objt.objt_bpmn_id
        into l_objt_bpmn_id
        from flow_objects objt
        join flow_objects parent
          on objt.objt_objt_id = parent.objt_id
       where objt.objt_dgrm_id = pi_dgrm_id
         and parent.objt_dgrm_id = pi_dgrm_id
         and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_start_event  
         and parent.objt_tag_name = flow_constants_pkg.gc_bpmn_process
         ;
    apex_debug.info
    ( p_message => 'Found starting object %0 in diagram %1'
    , p0 => l_objt_bpmn_id
    , p1 => pi_dgrm_id
    );
    return l_objt_bpmn_id;
  exception
    when too_many_rows then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'start-multiple-start-events'
      );
      -- $F4AMESSAGE 'start-multiple-start-events' || 'You have multiple starting events defined. Make sure your diagram has only one start event.'
    when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'start-no-start-event'
      );
      -- $F4AMESSAGE 'start-no-start-event' || 'No starting event is defined in the Flow diagram.'
  end get_start_event;

  function get_current_diagram
    ( pi_dgrm_name              in flow_diagrams.dgrm_name%type
    , pi_dgrm_calling_method    in flow_types_pkg.t_bpmn_attribute_vc2
    , pi_dgrm_version           in flow_diagrams.dgrm_version%type
    , pi_prcs_id                in flow_processes.prcs_id%type default null
    )
  return flow_diagrams.dgrm_id%type
    -- gets the current dgrm_id to be used for a diagram name.
    -- returns the current 'released' diagram or a 'draft' of version '0' 
  is
    l_dgrm_id     flow_diagrams.dgrm_id%type;
  begin
    case pi_dgrm_calling_method 
    when flow_constants_pkg.gc_dgrm_version_latest_version then
      begin 
        -- look for the 'released' version of the diagram
        select dgrm_id 
          into l_dgrm_id
          from flow_diagrams
         where dgrm_name = pi_dgrm_name
           and dgrm_status = flow_constants_pkg.gc_dgrm_status_released
        ;
        return l_dgrm_id;
      exception
        when no_data_found then
          -- look for the version 0 (default) of 'draft' of the diagram
          begin
            select dgrm_id
              into l_dgrm_id
              from flow_diagrams
             where dgrm_name = pi_dgrm_name
               and dgrm_status = flow_constants_pkg.gc_dgrm_status_draft
               and dgrm_version = '0'
            ;
            return l_dgrm_id;
          exception
            when no_data_found then
              if pi_prcs_id is null then 
                -- initial process start so call general error (instance not yet running)
                flow_errors.handle_general_error
                ( pi_message_key => 'version-no-rel-or-draft-v0'
                );
                -- $F4AMESSAGE 'version-no-rel-or-draft-v0' || 'Cannot find released diagram or draft version 0 of diagram - please specify a version or diagram_id'
              else 
                -- callActivity so log an instance error
                flow_errors.handle_instance_error
                ( pi_prcs_id     => pi_prcs_id
                , pi_message_key => 'version-no-rel-or-draft-v0'
                );
                -- $F4AMESSAGE 'version-no-rel-or-draft-v0' || 'Cannot find released diagram or draft version 0 of diagram - please specify a version or diagram_id'
              end if; 
          end;  
      end;

    when flow_constants_pkg.gc_dgrm_version_named_version then
      -- dgrm_version was specified
      begin
        select dgrm_id
          into l_dgrm_id
          from flow_diagrams
         where dgrm_name = pi_dgrm_name
           and dgrm_version = pi_dgrm_version
        ;
      exception
        when no_data_found then
          -- initial process start so call general error (instance not yet running)
          flow_errors.handle_general_error ( pi_message_key => 'version-not-found');
          -- $F4AMESSAGE 'version-not-found' || 'Cannot find specified diagram version.  Please check version specification.'
      end;
    end case;
    return l_dgrm_id;
  end get_current_diagram;


  procedure delete_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type,
    pi_cascade in varchar2)
  as
  begin
    if pi_cascade = flow_constants_pkg.gc_true then
      delete from flow_processes
       where prcs_dgrm_id = pi_dgrm_id;
    end if;
    delete from flow_diagrams 
     where dgrm_id = pi_dgrm_id;
  end delete_diagram;


  procedure edit_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type,
    pi_dgrm_name in flow_diagrams.dgrm_name%type,
    pi_dgrm_category in flow_diagrams.dgrm_category%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type)
  as
    l_dgrm_category flow_diagrams.dgrm_category%type;
  begin
    -- get existing category
    select dgrm_category
      into l_dgrm_category
      from flow_diagrams
     where dgrm_id = pi_dgrm_id;

    if coalesce(l_dgrm_category, chr(10)) != coalesce(pi_dgrm_category, chr(10) ) then
      -- category has changed
      update flow_diagrams
         set dgrm_category = pi_dgrm_category
       where dgrm_name = (
             select dgrm_name 
               from flow_diagrams
              where dgrm_id = pi_dgrm_id);
    end if;

    update flow_diagrams
       set dgrm_name = pi_dgrm_name,
           dgrm_version = pi_dgrm_version,
           dgrm_category = pi_dgrm_category
     where dgrm_id = pi_dgrm_id;
  end edit_diagram;


  procedure release_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  as
  begin
    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_deprecated
     where dgrm_name = (
           select dgrm_name 
             from flow_diagrams
            where dgrm_id = pi_dgrm_id)
       and dgrm_status = flow_constants_pkg.gc_dgrm_status_released;

    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_released
     where dgrm_id = pi_dgrm_id;
  end release_diagram;


  procedure deprecate_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  as
  begin
    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_deprecated
     where dgrm_id = pi_dgrm_id;
  end deprecate_diagram;


  procedure archive_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  as
  begin
    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_archived
     where dgrm_id = pi_dgrm_id;
  end archive_diagram;   

end flow_diagram;
/
