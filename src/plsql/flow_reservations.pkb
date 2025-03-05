create or replace package body flow_reservations
/* 
-- Flows for APEX - flow_reservations.pkb
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2021-2025.
--
-- Created 05-May-2021  Richard Allen (Flowquest)
-- Updated 25-Feb-2025  Richard Allen (Flowquest Limited)
--
*/
as 
  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  procedure reserve_step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_step_key           in flow_subflows.sbfl_step_key%type 
    , p_reservation        in flow_subflows.sbfl_reservation%type 
    , p_called_internally  in boolean default false
    )
  is
    l_sbfl_rec              flow_subflows%rowtype;
    e_reserved_by_other     exception;
    e_reserved_by_same      exception;
  begin
    apex_debug.enter
    ('reserve_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id
    , 'Step Key', p_step_key
    , 'Reservation', p_reservation
    );

    -- check step is not already reserved and lock the subflow
    l_sbfl_rec := flow_engine_util.get_subflow_info ( p_process_id => p_process_id
                                                    , p_subflow_id => p_subflow_id
                                                    , p_lock_subflow => true
                                                    );
    -- first check the step key
    if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                      , pi_sbfl_id  => p_subflow_id
                                      , pi_step_key_supplied  => p_step_key
                                      , pi_step_key_required => l_sbfl_rec.sbfl_step_key
                                      ) 
    then 
      -- step key valid
      if l_sbfl_rec.sbfl_reservation is not null then
        if p_reservation = l_sbfl_rec.sbfl_reservation then 
          -- step already reserved by required reservation
          raise e_reserved_by_same;
        else 
          raise e_reserved_by_other;
        end if;
      end if;
      -- place the reservation
      update flow_subflows sbfl
         set sbfl_reservation         = p_reservation
           , sbfl.sbfl_last_update    = systimestamp
           , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                 , sys_context('userenv','os_user')
                                                 , sys_context('userenv','session_user')
                                                 )  
       where sbfl_prcs_id = p_process_id
         and sbfl_id = p_subflow_id
      ;
      flow_logging.log_step_event
      ( p_sbfl_rec         => l_sbfl_rec
      , p_event            => flow_constants_pkg.gc_step_event_reserved
      , p_event_level      => flow_constants_pkg.gc_logging_level_routine
      , p_new_reservation  => p_reservation
      );
      -- commit reservation if this is an external call
      if not p_called_internally then 
        commit;
      end if;
    end if;

  exception
    when no_data_found then
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-failed-not-found'
        , p0 => p_subflow_id         
	      , p1 => p_process_id
        , p2 => p_reservation
        );
        -- $F4AMESSAGE 'reservation-failed-not-found' || 'Reservation for %2 unsuccessful.  Subflow %0 in Process %1 not found.'
    when e_reserved_by_other then
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-by-other_user'
        , p0 => p_reservation
        , p1 => l_sbfl_rec.sbfl_reservation
        );
        -- $F4AMESSAGE 'reservation-by-other_user' || 'Reservation for %0 unsuccessful.  Step already reserved by another user (%1).'           
    when e_reserved_by_same then
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-already-placed'
        );
        -- $F4AMESSAGE 'reservation-already-placed' || 'Reservation already placed on next task for you.'
    when lock_timeout then
        flow_errors.handle_general_error
        ( pi_message_key    => 'reservation-lock-timeout'
        );
        -- $F4AMESSAGE 'reservation-lock-timeout' || 'Subflow currently locked (not reserved) by another user.  Try your reservation again later.'     
  end reserve_step;

  procedure release_step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_step_key           in flow_subflows.sbfl_step_key%type default null
    , p_called_internally  in boolean default false
    )
  is
    l_existing_reservation      flow_subflows.sbfl_reservation%type;
    l_step_key_required         flow_subflows.sbfl_step_key%type;
    l_sbfl_rec                  flow_subflows%rowtype;
    e_reserved_wrong_step_key   exception;
  begin
    apex_debug.enter
    ( 'release_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id 
    , 'Step Key', p_step_key
    );
    -- get the subflow details (subflow should already be locked when calling internally)
    l_sbfl_rec := flow_engine_util.get_subflow_info ( p_process_id => p_process_id
                                                    , p_subflow_id => p_subflow_id
                                                    , p_lock_subflow => not p_called_internally
                                                    );
    -- check step key called externally
    if not p_called_internally then 
      -- check step key is valid (internal calls have already checked this so no need to check again)
      if not flow_engine_util.step_key_valid( pi_prcs_id           => p_process_id
                                            , pi_sbfl_id           => p_subflow_id
                                            , pi_step_key_supplied => p_step_key
                                            , pi_step_key_required => l_sbfl_rec.sbfl_step_key
                                            ) 
      then 
        raise e_reserved_wrong_step_key;
      end if;

    end if;
    -- release the reservation
    update flow_subflows sbfl
       set sbfl_reservation         = null
         , sbfl.sbfl_last_update    = systimestamp
         , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                               , sys_context('userenv','os_user')
                                               , sys_context('userenv','session_user')
                                               )  
    where sbfl_prcs_id = p_process_id
      and sbfl_id = p_subflow_id
    ;

    -- log the release
    flow_logging.log_step_event
    ( p_sbfl_rec         => l_sbfl_rec
    , p_event            => flow_constants_pkg.gc_step_event_released
    , p_event_level      => flow_constants_pkg.gc_logging_level_routine
    );

    -- commit reservation if this is an external call
    if not p_called_internally then 
      commit;
    end if;

  exception
    when no_data_found then
      flow_errors.handle_general_error
      ( pi_message_key    => 'reservation-release-not-found'
      , p0 => p_subflow_id
      , p1 => p_process_id
      );
      -- $F4AMESSAGE 'reservation-release-not-found' || 'Reservation release unsuccessful.  Subflow %0 in Process %1 not found.'
    when lock_timeout then
      flow_errors.handle_general_error
      ( pi_message_key    => 'reservation-lock-timeout'
      , p0 => p_subflow_id
      , p1 => p_process_id
      );
      -- $F4AMESSAGE 'reservation-lock-timeout' || 'Subflow currently locked (not reserved) by another user.  Try your reservation again later.'
    when e_reserved_wrong_step_key then
      flow_errors.handle_general_error
      ( pi_message_key    => 'reservation-incorrect-step-key'
      , p0 => p_subflow_id
      , p1 => p_process_id
      );      
      -- $F4AMESSAGE 'reservation-incorrect-step-key' || 'Task is no longer current.  Please refresh your Inbox.'
  end release_step;

end flow_reservations;
/
