# Flows for APEX Engine Regression Tests #

## Contents ##

- How to Install Tests in Your Environment
- Adding New Tests

## Installing Tests in Your Environment ##

Using the github repository, go through the following steps to install the test environment on your system:

1. Ensure that you have utPLSQL installed and working in your environment.  
2. Install the test BPMN models / diagrams into your APEX workspace.
   1. Make a .zip file containing all of the files in `/test/models`.  This should include all of the `.bpmn` diagram files plus the manifest file `import.json`.
   2. Using the Flows for APEX application (the "engine app"), import the models into your workspace using the multiple file import feature.
3. Install the Test Scripts into your workspace.
   1. Run the `install_all_tests.sql` script (contained in `\test`).  This installs the test_helper package, plus a package for each test suite.
4. You should now be able to run all of the tests.

## Adding New Tests ##

- add a new plsql package for each suite.  You can see the naming conventions...
- create one or more models for the suite.  You can see the naming conventions...
- add the models to the manifest file

Any questions - please ask Richard, Louis or Moritz.

## Happy Testing! ##
