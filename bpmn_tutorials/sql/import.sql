set define off;
set scan off;
spool tutorials.log
@"Tutorial 1  - Getting Started_25.1.sql";
@"Tutorial 2a - Basic Navigation with Gateways_25.1.sql";
@"Tutorial 2b - Parallel Gateways_25.1.sql";
@"Tutorial 2c - Inclusive Gateways_25.1.sql";
@"Tutorial 2d - Making your process pause_25.1.sql";
@"Tutorial 3a - Setting Process Variables from your Model_25.1.sql";
@"Tutorial 3b - Substitution and Bind Syntax_25.1.sql";
@"Tutorial 4a - Tasks Get Your Work Done!_25.1.sql";
@"Tutorial 4b - Reminders and Timeouts_25.1.sql";
@"Tutorial 4c - Task Priority and Due Dates_25.1.sql";
@"Tutorial 5a - Structure your Process with Sub Processes and Calls_25.1.sql";
@"Tutorial 5b - Introducing Sub Processes_25.1.sql";
@"Tutorial 5c - Handling Sub Process Error and Escalation Events_25.1.sql";
@"Tutorial 5d - Using CallActivities to call another diagram_25.1.sql";
@"Tutorial 5e - ship Goods (Called by Tutorial 5d)_25.1.sql";
@"Tutorial 5f - Making a Diagram Callable_25.1.sql";
@"Tutorial 6a - Collaborations, Lanes and Reservations_25.1.sql";
@"Tutorial 6b - Lanes and More Lanes_25.1.sql";
@"Tutorial 6c - User Assignment - Putting it all together_25.1.sql";
@"Tutorial 7a - MessageFlow Basics_25.1.sql";
@"Tutorial 7b - Process Collaboration and MessageFlow Example_25.1.sql";
@"Tutorial 7e - Introduction to Iterations and Tasks_25.1.sql";
@"Tutorial 7f - Iterations and Looped Sub Processes_25.1.sql";
@"Tutorial 7g - Iterations and Looped Nested Sub Processes_25.1.sql";
@"Tutorial 8a - The Full Monty (the top half!)_25.1.sql";
@"Tutorial 8c - Background Session Configuration_25.1.sql";

-- promote all activity tutorials to released

begin

  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 1  - Getting Started', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 2a - Basic Navigation with Gateways', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 2b - Parallel Gateways', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 2c - Inclusive Gateways', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 2d - Making your process pause', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 3a - Setting Process Variables from your Model', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 3b - Substitution and Bind Syntax', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 4a - Tasks Get Your Work Done!', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 4b - Reminders and Timeouts', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 4c - Task Priority and Due Dates', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 5a - Structure your Process with Sub Processes and Calls', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 5b - Introducing Sub Processes', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 5c - Handling Sub Process Error and Escalation Events', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 5d - Using CallActivities to call another diagram', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 5e - ship Goods (Called by Tutorial 5d)', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 5f - Making a Diagram Callable', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 6a - Collaborations, Lanes and Reservations', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 6b - Lanes and More Lanes', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 6c - User Assignment - Putting it all together', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 7a - MessageFlow Basics', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 7b - Process Collaboration and MessageFlow Example', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 7e - Introduction to Iterations and Tasks', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 7f - Iterations and Looped Sub Processes', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 7g - Iterations and Looped Nested Sub Processes', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 8a - The Full Monty (the top half!)', pi_dgrm_version => '25.1');
  flow_admin_api.release_diagram (pi_dgrm_name =>'Tutorial 8c - Background Session Configuration', pi_dgrm_version => '24.1');
end;
/

commit;
spool off

