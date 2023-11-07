create or replace package body flow_diagram
as
/* 
-- Flows for APEX - flow_diagram.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created  10-Dec-2021 Dennis Amthor - MT AG  
-- Modified 22-May-2022 Moritz Klein - MT AG
-- Modified 16-Mar-2023 Richard Allen - Oracle
--
*/
  


  function upload_diagram
  (
    pi_dgrm_name       in flow_diagrams.dgrm_name%type
  , pi_dgrm_version    in flow_diagrams.dgrm_version%type
  , pi_dgrm_category   in flow_diagrams.dgrm_category%type
  , pi_dgrm_content    in flow_diagrams.dgrm_content%type
  , pi_dgrm_status     in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_log_comment     in flow_flow_event_log.lgfl_comment%type default null
  , pi_force_overwrite in boolean default false
  ) return flow_diagrams.dgrm_id%type
  as
    l_cnt     number;
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin

    begin
      select dgrm_id
        into l_dgrm_id
        from flow_diagrams
       where dgrm_name = pi_dgrm_name
         and dgrm_version = pi_dgrm_version
      ;
    exception
      when no_data_found then
        l_dgrm_id := null;
    end;

    if l_dgrm_id is null then
      insert
        into flow_diagrams ( dgrm_name, dgrm_version, dgrm_category, dgrm_status, dgrm_last_update, dgrm_content )
        values ( pi_dgrm_name, pi_dgrm_version, pi_dgrm_category, 
                 pi_dgrm_status,  systimestamp, pi_dgrm_content )
      returning dgrm_id into l_dgrm_id
      ;
    else
      if (pi_force_overwrite) then
        update flow_diagrams
          set dgrm_content = pi_dgrm_content
            , dgrm_last_update = systimestamp
            , dgrm_status  = pi_dgrm_status
        where dgrm_id = l_dgrm_id
        ;
      end if;
    end if;

    flow_logging.log_diagram_event 
    ( p_dgrm_id         => l_dgrm_id
    , p_dgrm_name       => pi_dgrm_name
    , p_dgrm_version    => pi_dgrm_version
    , p_dgrm_status     => pi_dgrm_status
    , p_dgrm_category   => pi_dgrm_category
    , p_dgrm_content    => pi_dgrm_content
    , p_comment         => pi_log_comment
    );

    return l_dgrm_id;

  end upload_diagram;

  procedure upload_diagram
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_log_comment   in flow_flow_event_log.lgfl_comment%type default null
  , pi_force_overwrite in boolean default false
  )
  as
    l_dgrm_id       flow_diagrams.dgrm_id%type;
  begin
    l_dgrm_id := upload_diagram ( pi_dgrm_name => pi_dgrm_name, pi_dgrm_version => pi_dgrm_version,
                                  pi_dgrm_category => pi_dgrm_category, pi_dgrm_content => pi_dgrm_content,
                                  pi_dgrm_status => pi_dgrm_status, pi_force_overwrite => pi_force_overwrite,
                                  pi_log_comment => pi_log_comment
                                );
  end upload_diagram;

  procedure upload_and_parse
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_log_comment   in flow_flow_event_log.lgfl_comment%type default null 
  , pi_force_overwrite in boolean default false
  )
  as
    l_dgrm_id  flow_diagrams.dgrm_id%type;
  begin

    l_dgrm_id := upload_diagram ( pi_dgrm_name => pi_dgrm_name, pi_dgrm_version => pi_dgrm_version,
                                  pi_dgrm_category => pi_dgrm_category, pi_dgrm_content => pi_dgrm_content,
                                  pi_dgrm_status => pi_dgrm_status, pi_force_overwrite => pi_force_overwrite,
                                  pi_log_comment => pi_log_comment
                                );
    flow_bpmn_parser_pkg.parse ( pi_dgrm_id => l_dgrm_id);
  end upload_and_parse;

  procedure update_diagram
  (
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  )
  as
  begin

    update flow_diagrams
       set dgrm_content     = pi_dgrm_content
         , dgrm_last_update = systimestamp
     where dgrm_id = pi_dgrm_id
    ;

    flow_logging.log_diagram_event 
    ( p_dgrm_id         => pi_dgrm_id
    , p_dgrm_content    => pi_dgrm_content
    , p_comment         => 'Diagram updated'
    ); 

    flow_bpmn_parser_pkg.parse ( pi_dgrm_id => pi_dgrm_id);
  end update_diagram;

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
      l_dgrm_id := upload_diagram
            ( pi_dgrm_name     => pi_dgrm_name
            , pi_dgrm_version  => pi_dgrm_version
            , pi_dgrm_category => pi_dgrm_category
            , pi_dgrm_content  => replace ( flow_constants_pkg.gc_default_xml, '#RANDOM_PRCS_ID#',
                                            lower(sys.dbms_random.string('X',8))
                                          )
            , pi_dgrm_status   => flow_constants_pkg.gc_dgrm_status_draft
            );

            flow_logging.log_diagram_event 
            ( p_dgrm_id         => l_dgrm_id
            , p_dgrm_name       => pi_dgrm_name
            , p_dgrm_version    => pi_dgrm_version
            , p_dgrm_status     => flow_constants_pkg.gc_dgrm_status_draft
            , p_dgrm_category   => pi_dgrm_category
            , p_comment         => 'Diagram Created as template'
            );

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

    l_dgrm_id := upload_diagram 
                 ( pi_dgrm_name     => r_diagrams.dgrm_name
                 , pi_dgrm_version  => pi_dgrm_version
                 , pi_dgrm_category => r_diagrams.dgrm_category
                 , pi_dgrm_content  => r_diagrams.dgrm_content
                 , pi_dgrm_status   => flow_constants_pkg.gc_dgrm_status_draft
                 , pi_log_comment   => 'Add new version'
                 );

    --no need to log here - upload_diagram will log

    flow_bpmn_parser_pkg.parse ( pi_dgrm_id => l_dgrm_id);
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

    l_diagram_unknown  := l_dgrm_exists = 0;
    l_diagram_is_draft := l_dgrm_exists > 0 
                      and pi_force_overwrite = flow_constants_pkg.gc_true
                      and l_dgrm_status = flow_constants_pkg.gc_dgrm_status_draft;

    if l_diagram_unknown or l_diagram_is_draft then
      l_dgrm_id := upload_diagram
                   ( pi_dgrm_name       => pi_dgrm_name
                   , pi_dgrm_version    => pi_dgrm_version
                   , pi_dgrm_category   => pi_dgrm_category
                   , pi_dgrm_content    => pi_dgrm_content
                   , pi_force_overwrite => pi_force_overwrite = flow_constants_pkg.gc_true
                   , pi_log_comment     => 'import diagram'
                   );
      flow_bpmn_parser_pkg.parse ( pi_dgrm_id => l_dgrm_id );
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
      
      l_is_draft       := l_dgrm_status = flow_constants_pkg.gc_dgrm_status_draft;
      l_is_released    := l_dgrm_status = flow_constants_pkg.gc_dgrm_status_released;
      l_is_development := flow_engine_util.get_config_value(
                            p_config_key => 'engine_app_mode',
                            p_default_value => flow_constants_pkg.gc_config_default_engine_app_mode)
                        = 'development';
      return l_is_draft or (l_is_released and l_is_development);
    else
      return false;
    end if;
  end diagram_is_modifiable;

  function get_start_event
  ( p_dgrm_id                 in flow_diagrams.dgrm_id%type
  , p_process_id              in flow_processes.prcs_id%type
  , p_event_starting_object   in flow_objects.objt_bpmn_id%type default null
  ) return flow_objects%rowtype
  is 
    l_starting_object     flow_objects%rowtype;
  begin
    begin
      if p_event_starting_object is null then 
        -- get the starting object 
        select objt.*
          into l_starting_object
          from flow_objects objt
          join flow_objects parent
            on parent.objt_id       = objt.objt_objt_id
           and parent.objt_dgrm_id  = objt.objt_dgrm_id
           and parent.objt_tag_name = flow_constants_pkg.gc_bpmn_process
         where objt.objt_dgrm_id    = p_dgrm_id
           and objt.objt_tag_name   = flow_constants_pkg.gc_bpmn_start_event  
           and (    objt.objt_sub_tag_name is null 
               or   objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition )
        ;
      else 
        -- get the specified starting object
        select objt.*
          into l_starting_object
          from flow_objects objt
         where objt.objt_dgrm_id = p_dgrm_id
           and objt.objt_bpmn_id = p_event_starting_object
           and objt.objt_tag_name   = flow_constants_pkg.gc_bpmn_start_event 
        ;
      end if;

      apex_debug.info
      ( p_message => 'Found starting object %0'
      , p0 =>l_starting_object.objt_bpmn_id
      );
    exception
      when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'start-multiple-start-events'
        );
        -- $F4AMESSAGE 'start-multiple-start-events' || 'You have multiple starting events defined. Make sure your diagram has only one start event.'
      when no_data_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'start-no-start-event'
        );
        -- $F4AMESSAGE 'start-no-start-event' || 'No starting event is defined in the Flow diagram.'
    end;
    return l_starting_object;
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
    type t_prcs_id  is table of flow_processes.prcs_id%type
         index by binary_integer;
    l_running_instances   t_prcs_id;
  begin
    if pi_cascade = flow_constants_pkg.gc_true then
      select prcs_id
        bulk collect into l_running_instances
        from flow_processes
       where prcs_dgrm_id = pi_dgrm_id;
                               
      for i in 1..l_running_instances.count
      loop
        flow_instances.delete_process
        ( p_process_id  => l_running_instances(i)
        , p_comment     => 'Instance deleted on Diagram Deletion.'
        );
      end loop;
    end if;
    delete from flow_diagrams 
     where dgrm_id = pi_dgrm_id;

    flow_logging.log_diagram_event 
    ( p_dgrm_id         => pi_dgrm_id
    , p_comment         => 'Diagram deleted.'
    );

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


    flow_logging.log_diagram_event 
    ( p_dgrm_id         => pi_dgrm_id
    , p_dgrm_name       => pi_dgrm_name
    , p_dgrm_version    => pi_dgrm_version
    , p_dgrm_category   => pi_dgrm_category
    , p_comment         => 'Diagram meta-data edited'
    );

  end edit_diagram;

  procedure subscribe_diagram_message_starts
  ( pi_dgrm_id        in flow_diagrams.dgrm_id%type
  , pi_draft_suffix   in varchar2 default null
  )
  is
    l_subscription    flow_message_flow.t_subscription_details;
    l_msub_id         flow_message_subscriptions.msub_id%type;
  begin
    for message_start_events in 
      ( select objt.objt_dgrm_id
             , objt.objt_bpmn_id
             , objt.objt_sub_tag_name
             , objt.objt_attributes."apex"."messageName"."expression" message_name
             , objt.objt_attributes."apex"."payloadVariable" payload_var
          from flow_objects objt
         where objt_dgrm_id      = pi_dgrm_id
           and objt_tag_name     = flow_constants_pkg.gc_bpmn_start_event
           and objt_sub_tag_name = flow_constants_pkg.gc_bpmn_message_event_definition
      )
    loop

      l_subscription.message_name := message_start_events.message_name;
      l_subscription.dgrm_id      := pi_dgrm_id;
      l_subscription.callback     := flow_constants_pkg.gc_bpmn_start_event;
      l_subscription.callback_par := message_start_events.objt_bpmn_id;
      l_subscription.payload_var  := message_start_events.payload_var;

      l_msub_id := flow_message_flow.subscribe (p_subscription_details => l_subscription);

      apex_debug.message ( p_message => 'Message Start Event - Diagram %0 Start Event %1 Subscribed msub_id = %2.)'
      , p0 => pi_dgrm_id
      , p1 => message_start_events.objt_bpmn_id
      , p2 => l_msub_id
      );
    end loop;
  end subscribe_diagram_message_starts;


  procedure release_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  as
    l_dgrm_id_deprecated  flow_diagrams.dgrm_id%type;
    l_dgrm_content        clob;
  begin
/*    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_deprecated
     where dgrm_name = (
           select dgrm_name 
             from flow_diagrams
            where dgrm_id = pi_dgrm_id)
       and dgrm_status = flow_constants_pkg.gc_dgrm_status_released
    returning dgrm_id into l_dgrm_id_deprecated;

    if l_dgrm_id_deprecated is not null then 
      -- log deprecation of old diagram
      apex_debug.message ( p_message => 'Release Diagram - Diagram %0 being deprecated in favor of new diagram %1.)'
      , p0 => l_dgrm_id_deprecated
      , p1 => pi_dgrm_id
      );
      flow_logging.log_diagram_event 
      ( p_dgrm_id         => l_dgrm_id_deprecated
      , p_dgrm_status     => flow_constants_pkg.gc_dgrm_status_deprecated
      , p_comment         => 'Diagram deprecated when dgrm_id '||pi_dgrm_id||' released.'
      );
    end if; */

    -- depracate existing released version of model if one exists
    begin
      select dgrm_id
        into l_dgrm_id_deprecated
        from flow_diagrams
       where dgrm_status = flow_constants_pkg.gc_dgrm_status_released
         and dgrm_name = (
             select dgrm_name 
               from flow_diagrams
              where dgrm_id = pi_dgrm_id);
    exception
      when no_data_found then
        l_dgrm_id_deprecated := null;
    end;

    if l_dgrm_id_deprecated is not null then
      deprecate_diagram (pi_dgrm_id => l_dgrm_id_deprecated );
    end if;

    -- logging needs to include copy of the new production diagram for secure modes
    select dgrm_content
      into l_dgrm_content
      from flow_diagrams
     where dgrm_id = pi_dgrm_id;

    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_released
     where dgrm_id = pi_dgrm_id;

    subscribe_diagram_message_starts (pi_dgrm_id => pi_dgrm_id );

    apex_debug.message ( p_message => 'Release Diagram - Diagram %0 released.)'
    , p0 => pi_dgrm_id
    );

    flow_logging.log_diagram_event 
    ( p_dgrm_id         => pi_dgrm_id
    , p_dgrm_status     => flow_constants_pkg.gc_dgrm_status_released
    , p_dgrm_content    => l_dgrm_content
    , p_comment         => 'Diagram released.'
    );

  end release_diagram;


  procedure deprecate_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  as
  begin

    flow_message_util.cancel_diagram_subscriptions 
    ( p_dgrm_id   => pi_dgrm_id
    , p_callback  => flow_constants_pkg.gc_bpmn_start_event
    );

    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_deprecated
     where dgrm_id = pi_dgrm_id;

    apex_debug.message ( p_message => 'Release Diagram - Diagram %0 deprecated.)'
    , p0 => pi_dgrm_id
    );

    flow_logging.log_diagram_event 
    ( p_dgrm_id         => pi_dgrm_id
    , p_dgrm_status     => flow_constants_pkg.gc_dgrm_status_deprecated
    , p_comment         => 'Diagram deprecated.'
    );   

  end deprecate_diagram;


  procedure archive_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  as
    l_running_instances       number ;
    e_has_running_instances   exception;
  begin
    -- check that diagram has no current running process instances
    select count(prcs_id)
      into l_running_instances
      from flow_processes prcs
     where prcs.prcs_id in (
            select prdg.prdg_prcs_id
              from flow_instance_diagrams prdg
             where prdg.prdg_dgrm_id = pi_dgrm_id
            )
       and prcs.prcs_status not in  ( flow_constants_pkg.gc_prcs_status_completed
                                    , flow_constants_pkg.gc_prcs_status_terminated
                                    );
    if l_running_instances = 0 then
      update flow_diagrams
         set dgrm_status = flow_constants_pkg.gc_dgrm_status_archived
       where dgrm_id = pi_dgrm_id;

      flow_logging.log_diagram_event 
      ( p_dgrm_id         => pi_dgrm_id
      , p_dgrm_status     => flow_constants_pkg.gc_dgrm_status_archived
      , p_comment         => 'Diagram archived.'
      );
    else                     
      raise e_has_running_instances;
    end if;
  exception
    when e_has_running_instances then
          -- initial process start so call general error (instance not yet running)
          flow_errors.handle_general_error ( pi_message_key => 'diagram-archive-has-instances');
          -- $F4AMESSAGE 'version-not-found' || 'Cannot find specified diagram version.  Please check version specification.'
  end archive_diagram;   

  function get_diagram_name
    ( pi_dgrm_id       in flow_diagrams.dgrm_id%type)
  return flow_diagrams.dgrm_name%type
  is
    l_dgrm_name   flow_diagrams.dgrm_name%type;
  begin
    select dgrm_name
      into l_dgrm_name
      from flow_diagrams
     where dgrm_id = pi_dgrm_id
    ;
     return l_dgrm_name;
  end get_diagram_name;

end flow_diagram;
/
