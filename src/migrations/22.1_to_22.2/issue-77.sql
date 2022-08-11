PROMPT >> Migration for Case-insensitive process variables (issue77)

-- 1. BEFORE MIGRATION STARTS, NEED TO CHECK (prov_prcs_id, prov_scope, upper (prov_var_name)) IS UNIQUE
-- 2. NEEDS TO RUN AFTER feature-172.sql (which creates prov_scope column)

alter table flow_process_variables add (prov_var_name_uc varchar2(50 char) generated always as (upper(prov_var_name)));
alter table flow_process_variables drop primary key;
alter table flow_process_variables add constraint prov_pk primary key (prov_prcs_id, prov_scope, prov_var_name_uc);
