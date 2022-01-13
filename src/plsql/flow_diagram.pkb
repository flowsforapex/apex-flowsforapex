create or replace package body flow_diagram
as

  function create_diagram(
    pi_dgrm_name in flow_diagrams_vw.dgrm_name%type,
    pi_dgrm_category in flow_diagrams_vw.dgrm_category%type,
    pi_dgrm_version in flow_diagrams_vw.dgrm_version%type)
  return flow_diagrams_vw.dgrm_id%type
  as
    l_diagram_exists binary_integer;
    l_dgrm_id flow_diagrams_vw.dgrm_id%type;
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
    pi_dgrm_id in flow_diagrams_vw.dgrm_id%type,
    pi_dgrm_version in flow_diagrams_vw.dgrm_version%type)
  return flow_diagrams_vw.dgrm_id%type
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
    pi_dgrm_name in flow_diagrams_vw.dgrm_name%type,
    pi_dgrm_category in flow_diagrams_vw.dgrm_category%type,
    pi_dgrm_version in flow_diagrams_vw.dgrm_version%type,
    pi_dgrm_content in flow_diagrams_vw.dgrm_content%type,
    pi_force_overwrite in varchar2 default flow_constants_pkg.gc_false) 
  return flow_diagrams_vw.dgrm_id%type
  as
    l_dgrm_id flow_diagrams.dgrm_id%type;
    l_dgrm_exists binary_integer;
    l_dgrm_status flow_diagrams_vw.dgrm_status%type;
    l_diagram_unknown boolean;
    l_diagram_is_draft boolean;
  begin
    select count(*)
      into l_dgrm_exists
      from flow_diagrams_vw
     where dgrm_name = pi_dgrm_name
       and dgrm_version = pi_dgrm_version;

    if (l_dgrm_exists > 0) then
        select dgrm_status
        into l_dgrm_status
        from flow_diagrams_vw
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
    pi_dgrm_id in flow_diagrams_vw.dgrm_id%type)
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


  procedure delete_diagram(
    pi_dgrm_id in flow_diagrams_vw.dgrm_id%type,
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
    pi_dgrm_id in flow_diagrams_vw.dgrm_id%type,
    pi_dgrm_name in flow_diagrams_vw.dgrm_name%type,
    pi_dgrm_category in flow_diagrams_vw.dgrm_category%type,
    pi_dgrm_version in flow_diagrams_vw.dgrm_version%type)
  as
    l_dgrm_category flow_diagrams_vw.dgrm_category%type;
  begin
    -- get existing category
    select dgrm_category
      into l_dgrm_category
      from flow_diagrams_vw
     where dgrm_id = pi_dgrm_id;

    if coalesce(l_dgrm_category, chr(10)) != coalesce(pi_dgrm_category, chr(10) ) then
      -- category has changed
      update flow_diagrams
         set dgrm_category = pi_dgrm_category
       where dgrm_name = (
             select dgrm_name 
               from flow_diagrams_vw
              where dgrm_id = pi_dgrm_id);
    end if;

    update flow_diagrams
       set dgrm_name = pi_dgrm_name,
           dgrm_version = pi_dgrm_version,
           dgrm_category = pi_dgrm_category
     where dgrm_id = pi_dgrm_id;
  end edit_diagram;


  procedure release_diagram(
    pi_dgrm_id in flow_diagrams_vw.dgrm_id%type)
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
    pi_dgrm_id in flow_diagrams_vw.dgrm_id%type)
  as
  begin
    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_deprecated
     where dgrm_id = pi_dgrm_id;
  end deprecate_diagram;


  procedure archive_diagram(
    pi_dgrm_id in flow_diagrams_vw.dgrm_id%type)
  as
  begin
    update flow_diagrams
       set dgrm_status = flow_constants_pkg.gc_dgrm_status_archived
     where dgrm_id = pi_dgrm_id;
  end archive_diagram;   

end flow_diagram;
/