-- Installs test models, tests, test apps in test env

PROMPT >> Installing CE Test Packages

@install_all_tests.sql

PROMPT >> Install All CE Test models

@models/sql/import.sql
commit;

PROMPT >> Install App required for tests

@apps/A24_approval_comp_integration_apex22_2.sql

PROMPT>> Install Emp/Dept

@create_emp_dept.sql

