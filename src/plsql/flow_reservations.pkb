create or replace package body flow_reservations
as 

  procedure reserve_step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_reservation        in flow_subflows.sbfl_reservation%type
    , p_called_internally  in boolean default false
    )
  is
    l_existing_reservation  flow_subflows.sbfl_reservation%type;
    e_reserved_by_other     exception;
    e_reserved_by_same      exception;
  begin
    apex_debug.message(p_message => 'Begin flow_reserve_step. Subflow '||p_subflow_id||' in Process '||p_process_id||' Reservation:'||p_reservation, p_level => 3) ;
    -- check step is not already reserved
    select sbfl_reservation
      into l_existing_reservation
      from flow_subflows sbfl 
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    if l_existing_reservation is not null then
      if p_reservation = l_existing_reservation then 
        -- step already reserved by required reservation
        raise e_reserved_by_same;
      else 
        raise e_reserved_by_other;
      end if;
    end if;
    -- place the reservation
    update flow_subflows sbfl
       set sbfl_reservation = p_reservation
     where sbfl_prcs_id = p_process_id
       and sbfl_id = p_subflow_id
    ;

  exception
    when no_data_found then
        apex_error.add_error
        ( p_message => 'Reservation unsuccessful.  Subflow '||p_subflow_id||' in Process '||p_process_id||' not found.'
        , p_display_location => apex_error.c_on_error_page
        );
    when e_reserved_by_other then
        apex_error.add_error
        ( p_message => 'Reservation unsuccessful.  Step already reserved by another user.'
        , p_display_location => apex_error.c_on_error_page
        );    
    when e_reserved_by_same then
        apex_error.add_error
        ( p_message => 'Reservation already placed on next task.'
        , p_display_location => apex_error.c_on_error_page
        );
  end reserve_step;

  procedure release_step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_called_internally  in boolean default false
    )
  is
    l_existing_reservation  flow_subflows.sbfl_reservation%type;
  begin
    apex_debug.message(p_message => 'Begin flow_release_step. Subflow '||p_subflow_id||' in Process '||p_process_id, p_level => 3) ;
    -- check step is not already reserved
    select sbfl_reservation
      into l_existing_reservation
      from flow_subflows sbfl 
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- place the reservation
    update flow_subflows sbfl
       set sbfl_reservation = null
     where sbfl_prcs_id = p_process_id
       and sbfl_id = p_subflow_id
    ;
  exception
    when no_data_found then
      apex_error.add_error
      ( p_message => 'Reservation unsuccessful.  Subflow '||p_subflow_id||' in Process '||p_process_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
  end release_step;

end flow_reservations;