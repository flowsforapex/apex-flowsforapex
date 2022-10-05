/* 
-- Flows for APEX - pre-migration-check-issue-77.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2020,2022.
--
-- Created 5-Oct-2022   Richard Allen - Oracle Corporation
--
*/

PROMPT >> Check if Case-specific Process Variables exist

PROMPT>> Following Query returns any Process Variable Usage where multiple Process Variables with
PROMPT>> similar names exist in a Process.   In V <= 22.1, process variables are sometimes case dependant.
PROMPT>> v22.2 fixes this.   But first we have to check that a process doesnt have, for example both
PROMPT>> 'MyVar' and 'MYVAR' as separate and different variables.
PROMPT>> If any entries exist on this list, you MUST fix them before migrating to v22.2

select prov.prov_prcs_id Process_ID,  upper (prov.prov_var_name) Proc_Var_Name, count(*) "Variants"
from flow_process_variables prov
group by prov.prov_prcs_id,  upper (prov.prov_var_name)
having count(*) > 1;

-- Do we need this script to return an error and prevent migration?