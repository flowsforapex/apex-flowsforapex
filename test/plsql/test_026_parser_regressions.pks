create or replace package test_026_parser_regressions
/* 
-- Flows for APEX - test_026_parser_regressions.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created 01-Apr-2026   GitHub Copilot
--
*/
is
	--%suite(26 Parser Regressions)
	--%tags(ce,ee,short)
	--%rollback(manual)

	--%beforeall
	procedure set_up_tests;

	--%test('A26a - Association can reference sequenceFlow')
	procedure association_to_sequenceflow;

	--%afterall
	procedure tear_down_tests;

end test_026_parser_regressions;
/
