# Flows for APEX Test Harness

This directory contains SQL scripts for running test suites via SQLcl or SQL*Plus from the command line or VS Code.

## Available Test Scripts

### `run_AI_generated_tests.sql`
Executes all AI-generated test suites including:
- Test Suite 90: Basic AI Model Creation (Sequential tasks)
- Future AI-generated test suites will be added here

### `run_full_regression_tests.sql`
Executes the complete Flows for APEX regression test suite including:
- Test Suites 001-027: Core engine functionality
- Gateway operations, process variables, call activities
- User tasks, script tasks, message flows
- Error handling and boundary events
- **Excludes**: AI-generated test suites (090+)

## How to Run Tests

### From VS Code (Recommended)
1. Open the SQL script in VS Code
2. Ensure you have SQLcl extension configured
3. Connect to your Flows for APEX database
4. Execute the entire script (Ctrl+Shift+E or Cmd+Shift+E)

### From Command Line with SQLcl
```bash
# Navigate to the test harness directory
cd /path/to/apex-flowsforapex/test/harness

# Run AI tests
sqlcl username/password@database @run_AI_generated_tests.sql
```

### From SQL*Plus
```bash
# Connect and run
sqlplus username/password@database @run_AI_generated_tests.sql
```

## Test Output

The scripts provide:
- Clear headers and timing information
- Automatic cleanup of previous test data
- Detailed test execution results via utPLSQL
- Summary of test outcomes
- Error messages for debugging

## Prerequisites

1. Flows for APEX engine installed and configured
2. utPLSQL framework installed
3. Test BPMN models loaded (via test/models/sql/* scripts)
4. Test packages compiled (test_090_ai_basic_model, etc.)

## Adding New Test Scripts

When creating new test harness scripts:
1. Follow the naming convention: `run_[purpose]_tests.sql`
2. Include proper headers and cleanup
3. Use consistent output formatting
4. Update this README with new scripts