# Flows for APEX Engine Regression Tests #

## Contents ##

- How to Install Tests in Your Environment
- Adding New Tests

## Installing Tests in Your Environment ##

Using the GitHub repository, go through the following steps to install the test environment on your system:

1. Ensure that you have utPLSQL installed and working in your environment.  
2. Install the test BPMN models / diagrams into your APEX workspace using the SQL install scripts in `test/models/sql`.
   a. Use the model files in  `test/models/sql`.
   b. Run import.sql to install these

3. Install the Test Scripts into your workspace.
   1. Run the `install_all_tests.sql` script (contained in `\test`).  This installs the test_helper package, plus a package for each test suite.
   
4. Install the EMP/DEPT Sample Dataset (use APEX or a script)

5. Install any Test Apps in the `test/apps` folder.   These contain things like APEX Approval Task Definitions.   You will need to install the version of these files that matches the APEX version installed in your test environment.
   
6. Using the Configurations Panel > Timers (or otherwise) make sure that your timers are enabled and running every 10 seconds.
   
7. Using the Configurations Panel > Engine.   Make sure that the default parameters use a valid AppID, App Page and Default User ID on the system under test.
   
8. Edit the Test Constants file (`test\plsql\test_constants.pks`) to set any appropriate User IDs and APEX APP IDs for the testing environment.


7. You should now be able to run all of the tests.

## Adding New Tests ##

- add a new plsql package for each suite.  You can see the naming conventions...
- create one or more models for the suite.  You can see the naming conventions...
- add the models to the `import.sql` manifest file
- if necessary, add any applications...
- make sure the `pkb` and `pks` files end with a line containing a `\` followed by a blank line.

## Common problems after installing tests in a new workspace / Flows installation.

1.  If you get lots of 'Can't create async session' type errors, ssing the Configurations Panel > Engine.   Make sure that the default parameters use a valid AppID, App Page and Default User ID on the system under test.  Many, many tests will error if this is not set correctly.
2.  If you get Incorrect Workspace type errors on tests involving APEX Human Tasks, chances are the default app / page info set in your model hasn't ben reset for the new envirobment.  Look in model properties panel > BPMN Process / Collaboration / Background Task Session on the failing models.
3.  If you get lots of errors on Timer related tests, check that the DBMS Scheduler job is still running.  Sometimes bad code crashes the Scheduler JOb.  Disable and Re-enable it and they normally go away.


or APEX application (the "engine app"), import the models into your workspace using the multiple file import feature.

## Need Help?

Any questions - please ask Richard, Louis or Moritz.

## Happy Testing! ##
