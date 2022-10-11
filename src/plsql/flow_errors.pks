create or replace package flow_errors
  authid definer
as

  procedure handle_instance_error
  ( pi_prcs_id        in flow_processes.prcs_id%type
  , pi_sbfl_id        in flow_subflows.sbfl_id%type default null
  , pi_message_key    in varchar2
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  );

  procedure handle_general_error
  ( pi_message_key    in varchar2
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  );
  procedure set_error_status
  ( pi_prcs_id        in flow_processes.prcs_id%type
  , pi_sbfl_id        in flow_subflows.sbfl_id%type
  );
  
  function make_error_message
  ( pi_message_key    in flow_messages.fmsg_message_key%type 
  , pi_lang           in flow_messages.fmsg_lang%type
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  ) return flow_messages.fmsg_message_content%type;

   e_gateway_invalid_route exception;

end flow_errors;
/
