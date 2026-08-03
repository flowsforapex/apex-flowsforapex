create or replace package body test_026_parser_regressions
/* 
-- Flows for APEX - test_026_parser_regressions.pkb
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created 01-Apr-2026   GitHub Copilot
--
*/
is
	-- uses model 26a
	g_model_a26a constant varchar2(100) := 'A26a - Association to SequenceFlow';

	g_dgrm_a26a_id flow_diagrams.dgrm_id%type;

	-- beforeall
	procedure set_up_tests
	is
	begin
		g_dgrm_a26a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a26a );
		flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a26a_id );
	end set_up_tests;

	-- test('A26a - Association can reference sequenceFlow')
	procedure association_to_sequenceflow
	is
		l_actual   sys_refcursor;
		l_expected sys_refcursor;
	begin
		-- Association with sourceRef to sequenceFlow should parse and be persisted.
		open l_expected for
			select 'bpmn:association' as conn_tag_name
					 , 'Y'                as src_is_null
					 , 'Y'                as tgt_is_not_null
				from dual;

		open l_actual for
			select conn.conn_tag_name
					 , case when conn.conn_src_objt_id is null then 'Y' else 'N' end as src_is_null
					 , case when conn.conn_tgt_objt_id is not null then 'Y' else 'N' end as tgt_is_not_null
				from flow_connections conn
			 where conn.conn_dgrm_id = g_dgrm_a26a_id
				 and conn.conn_bpmn_id = 'Association_sf2_to_comment';

		ut.expect( l_actual ).to_equal( l_expected );

		-- The referenced sequenceFlow connection should also exist in parsed data.
		open l_expected for
			select 1 as flow_exists
				from dual;

		open l_actual for
			select count(*) as flow_exists
				from flow_connections conn
			 where conn.conn_dgrm_id = g_dgrm_a26a_id
				 and conn.conn_bpmn_id = 'Flow_seqflow2';

		ut.expect( l_actual ).to_equal( l_expected );
	end association_to_sequenceflow;

	-- afterall
	procedure tear_down_tests
	is
	begin
		ut.expect( v('APP_SESSION') ).to_be_null;
	end tear_down_tests;

end test_026_parser_regressions;
/
