-- Installs test models, tests, test apps in test env

spool install_ce_test_scratch.log

PROMPT >> Installing CE Test Packages

@install_all_tests.sql

PROMPT >> Install All CE Test models

@models/sql/import.sql
commit;

PROMPT >> Install Emp/Dept

@create_emp_dept.sql

PROMPT >> Install App required for tests

@apps/A24_approval_comp_integration_apex24_1.sql

PROMPT >> Create FLOWTESTER1 and FLOWTESTER2 in Workspace
PROMPT >> Update test_constants.pkg with new App ID for App A24. and recompile

PROMPT >> Update Config Parameters for Workspace ID, Default User, and App ID.


spool OFF
