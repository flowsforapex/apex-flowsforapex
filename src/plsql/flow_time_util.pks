create or replace package flow_time_util
as 
/* 
-- Flows for APEX - flow_time_util.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created    21-Nov-2022  Richard Allen (Oracle)
--
*/



  function calculate_due_date
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_due_date_def  flow_objects.objt_attributes%type
  ) return timestamp with time zone;

end flow_time_util;