create or replace package body flow_reservations
as 
  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

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
    apex_debug.enter
    ('reserve_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id
    , 'Reservation', p_reservation
    );
    -- check step is not already reserved
    select sbfl_reservation
      into l_existing_reservation
      from flow_subflows sbfl 
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
       for update of sbfl_reservation wait 2
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
    -- commit reservation if this is an external call
    if not p_called_internally then 
      commit;
    end if;

  exception
    when no_data_found then
        /*apex_error.add_error
        ( p_message => 'Reservation unsuccessful.  Subflow '||p_subflow_id||' in Process '||p_process_id||' not found.'
        , p_display_location => apex_error.c_on_error_page
        );*/
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-failed-not-found'
        , p0 => p_subflow_id         
	      , p1 => p_process_id
        , p2 => p_reservation
        );
        -- $F4AMESSAGE 'reservation-failed-not-found' || 'Reservation for %2 unsuccessful.  Subflow %0 in Process %1 not found.'
    when e_reserved_by_other then
        /*apex_error.add_error
        ( p_message => 'Reservation unsuccessful.  Step already reserved by another user.'
        , p_display_location => apex_error.c_on_error_page
        ); */
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-by-other_user'
        , p0 => p_reservation
        , p1 => l_existing_reservation
        );
        -- $F4AMESSAGE 'reservation-by-other_user' || 'Reservation for %0 unsuccessful.  Step already reserved by another user (%1).'           
    when e_reserved_by_same then
        /*apex_error.add_error
        ( p_message => 'Reservation already placed on next task.'
        , p_display_location => apex_error.c_on_error_page
        );*/
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-already-placed'
        );
        -- $F4AMESSAGE 'reservation-already-placed' || 'Reservation already placed on next task for you.'
    when lock_timeout then
        /*apex_error.add_error
        ( p_message => 'Subflow '||p_subflow_id||' currently locked by another user.  Try your reservation again later.'
        , p_display_location => apex_error.c_on_error_page
        );*/
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-lock-timeout'
        );
        -- $F4AMESSAGE 'reservation-lock-timeout' || 'Subflow currently locked (not reserved) by another user.  Try your reservation again later.'     
  end reserve_step;

  procedure release_step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_called_internally  in boolean default false
    )
  is
    l_existing_reservation  flow_subflows.sbfl_reservation%type;
  begin
    apex_debug.enter
    ( 'release_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id 
    );
    -- subflow should already be locked when calling internally
    if not p_called_internally then 
      -- lock  subflow if called externally
      select sbfl_reservation
        into l_existing_reservation
        from flow_subflows sbfl 
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
         for update of sbfl_reservation wait 2
      ;
    end if;
    -- release the reservation
    update flow_subflows sbfl
      set sbfl_reservation = null
    where sbfl_prcs_id = p_process_id
      and sbfl_id = p_subflow_id
    ;
    -- commit reservation if this is an external call
    if not p_called_internally then 
      commit;
    end if;

  exception
    when no_data_found then
      /*apex_error.add_error
      ( p_message => 'Reservation release unsuccessful.  Subflow '||p_subflow_id||' in Process '||p_process_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );*/
      flow_errors.handle_general_error
      ( pi_message_key    => 'reservation-release-not-found'
      , p0 => p_subflow_id
      , p1 => p_process_id
      );
      -- $F4AMESSAGE 'reservation-release-not-found' || 'Reservation release unsuccessful.  Subflow %0 in Process %1 not found.'
    when lock_timeout then
      /*apex_error.add_error
      ( p_message => 'Subflow '||p_subflow_id||' currently locked by another user.  Try to release your reservation later.'
      , p_display_location => apex_error.c_on_error_page
      );*/
      flow_errors.handle_general_error
      ( pi_message_key    => 'reservation-lock-timeout'
      , p0 => p_subflow_id
      , p1 => p_process_id
      );
      -- $F4AMESSAGE 'reservation-lock-timeout' || 'Subflow currently locked (not reserved) by another user.  Try your reservation again later.'

  end release_step;

end flow_reservations;
/