create or replace package flow_statistics
as
/* 
-- Flows for APEX - flow_statistics.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    11-Jan-2023  Richard Allen (Oracle)
--
*/

  procedure run_daily_stats;

  procedure purge_statistics;


end flow_statistics;
/
