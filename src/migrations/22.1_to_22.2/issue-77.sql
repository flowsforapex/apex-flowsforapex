PROMPT >> Migration for Case-insensitive process variables (issue77)


-- 1. BEFORE MIGRATION STARTS, NEED TO CHECK (prov_prcs_id, prov_scope, upper (prov_var_name)) IS UNIQUE

-- 2. ADDING THE NEW INDEX NEEDS TO RUN AFTER feature-172.sql (which creates the PK including prov_scope)

-- 3.  NOT YET TESTED!

alter table flow_process_variables drop primary key;

create unique index on flow_process_variables (prov_prcs_id, prov_scope, upper (prov_var_name));

/
