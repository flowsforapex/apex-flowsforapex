PROMPT >> Flows for APEX v22.2 Timer Migration
PROMPT >> ====================================
PROMPT >> This script migrates any timers that were set by Flows for APEX v22.1 and which are 
PROMPT >> waiting to fire under Flows for APEX v22.2.   
PROMPT >> Flows for APEX v22.2 now creates an APEX session for any processing that occurs once 
PROMPT >> the timer fires.  It uses (in order of preference):
PROMPT >> 1.  Session parameter info set up specifically for the timer, in process variables named
PROMPT >>     <timer_object_bpmn_id>||applicationID
PROMPT >>     <timer_object_bpmn_id>||pageID
PROMPT >>     <timer_object_bpmn_id>||username
PROMPT >> 2. default diagram level session parameters stored in the Process object in the BPMN Diagram, or
PROMPT >> 3. System-level Configuration Parameters, set in the Flows for APEX application Configurations page.
PROMPT >>
PROMPT >> Before running this script, you MIST do ONE OR BOTH of these steps:
PROMPT >> 1. Update your process diagrams to contain the session information on the Process object in your BPMN diagram.  If your diagram 
PROMPT >>    contains BPMN lane structures, theese are included in the Participant object. (Click on the right hand sie of the lane structure
PROMPT >>    to see Participant).   Without Lanes, click on the diagram canvas to get the Process object.
PROMPT >> 2. Set the default Application ID, PageID and Username in the System Configurations page of the 
PROMPT >>    Flows for APEX application.
PROMPT >> This script sets those parameters for timers that were created before the engine did that when the timers were set.

begin
  for timer in 
    (
    select timr.timr_id, timr.timr_prcs_id, timr.timr_sbfl_id
    from   flow_timers timr
    )
    loop
      flow_apex_session.set_async_proc_vars
        ( p_process_id => timer.timr_prcs_id
        , p_subflow_id => timer.timr_sbfl_id);
    end loop;

commit;
end;

