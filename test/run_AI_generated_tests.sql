-- Run AI Generated Test Suites
-- This script executes the AI-generated test suites created for Flows for APEX

-- Test Suite 90A: Basic sequential model
exec ut.run('test_090_ai_basic_model');

-- Test Suite 90B: Basic model with variable expressions
exec ut.run('test_090_ai_basic_model_b');

-- Test Suite 90C: Gateway routing with process variables
exec ut.run('test_090_ai_gateway_routing');