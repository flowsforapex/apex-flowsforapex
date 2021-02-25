create or replace package body flow_p0007_api
as

  procedure delete_diagram
  (
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  , pi_cascade in varchar2
  )
  is
  begin
    if  pi_cascade = 'Y' then
      delete from flow_processes where prcs_dgrm_id = pi_dgrm_id;
    end if;
    delete from flow_diagrams where dgrm_id = pi_dgrm_id;
  end delete_diagram;

  function add_diagram_version
  (
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type
  ) return flow_diagrams.dgrm_id%type
  is
    l_dgrm_id flow_diagrams.dgrm_id%type;
    r_diagrams flow_diagrams%rowtype;
  begin
    select * 
      into r_diagrams
      from flow_diagrams
     where dgrm_id = pi_dgrm_id
    ;
    
    l_dgrm_id :=
      flow_bpmn_parser_pkg.upload_diagram
      (
        pi_dgrm_name => r_diagrams.dgrm_name
      , pi_dgrm_version => pi_dgrm_version
      , pi_dgrm_category => r_diagrams.dgrm_category
      , pi_dgrm_content => r_diagrams.dgrm_content
      , pi_dgrm_status => flow_constants_pkg.gc_dgrm_status_draft
      );
    
    flow_bpmn_parser_pkg.parse
    (
      pi_dgrm_id => l_dgrm_id
    );
    return l_dgrm_id;
  end add_diagram_version;

  procedure process_page
  (
    pio_dgrm_id      in out nocopy flow_diagrams.dgrm_id%type
  , pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_new_version   in flow_diagrams.dgrm_version%type
  , pi_cascade       in varchar2
  , pi_request       in varchar2
  )
  as
    l_dgrm_category flow_diagrams.dgrm_category%type;
  begin
    case pi_request
      when 'CREATE' then
        begin
          select dgrm_id
          into pio_dgrm_id
          from flow_diagrams
          where dgrm_name = pi_dgrm_name
          and dgrm_version = pi_dgrm_version;

          apex_error.add_error(
              p_message => apex_lang.message(p_name => 'DGRM_UK')
            , p_display_location => apex_error.c_on_error_page
          );
        exception when no_data_found then
          pio_dgrm_id :=
            flow_bpmn_parser_pkg.upload_diagram
            (
              pi_dgrm_name     => pi_dgrm_name
            , pi_dgrm_version  => pi_dgrm_version
            , pi_dgrm_category => pi_dgrm_category
            , pi_dgrm_content  => flow_constants_pkg.gc_default_xml
            , pi_dgrm_status   => flow_constants_pkg.gc_dgrm_status_draft
            );
          flow_bpmn_parser_pkg.parse
          (
            pi_dgrm_id => pio_dgrm_id
          );
        end;
      when 'SAVE' then
        select dgrm_category
          into l_dgrm_category
          from flow_diagrams
         where dgrm_id = pio_dgrm_id
        ;

        if coalesce(l_dgrm_category, chr(10)) != coalesce(pi_dgrm_category, chr(10) ) then
          update flow_diagrams
             set dgrm_category = pi_dgrm_category
           where dgrm_name = ( select dgrm_name from flow_diagrams where dgrm_id = pio_dgrm_id )
          ;
        end if;

        update flow_diagrams
           set dgrm_name = pi_dgrm_name
             , dgrm_version = pi_dgrm_version
             , dgrm_category = pi_dgrm_category
         where dgrm_id = pio_dgrm_id
        ;
      when 'DELETE' then
        delete_diagram
        (
          pi_dgrm_id => pio_dgrm_id
        , pi_cascade => pi_cascade
        );
      when 'ADD_VERSION' then
        pio_dgrm_id :=
          add_diagram_version
          (
            pi_dgrm_id      => pio_dgrm_id
          , pi_dgrm_version => pi_new_version
          );
      when 'RELEASE' then
        update flow_diagrams
           set dgrm_status = flow_constants_pkg.gc_dgrm_status_released
         where dgrm_id = pio_dgrm_id
        ;
      when 'DEPRECATE' then
        update flow_diagrams
           set dgrm_status = flow_constants_pkg.gc_dgrm_status_deprecated
         where dgrm_id = pio_dgrm_id
        ;
      when 'ARCHIVE' then
        update flow_diagrams
           set dgrm_status = flow_constants_pkg.gc_dgrm_status_archived
         where dgrm_id = pio_dgrm_id
        ;
      else
        raise_application_error(-20002, 'Unknown operation requested.');
    end case;
  end process_page;

end flow_p0007_api;
/
