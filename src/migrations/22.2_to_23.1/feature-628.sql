PROMPT >> Feature 628 - Adds Logging to Parser

create table flow_parser_log 
(
  plog_id         number generated always as identity increment by 1 start with 1 not null
, plog_dgrm_id    number not null
, plog_log_time   timestamp not null
, plog_bpmn_id    varchar2( 50 char)
, plog_parse_step varchar2(128 char)
, plog_payload    clob
);

alter table flow_parser_log
  add constraint flow_plog_pk primary key (plog_id)
;

create index flow_plog_ix1
  on flow_parser_log( plog_dgrm_id, plog_log_time )
;

begin
  insert into flow_configuration ( cfig_key, cfig_value )
    values ( 'parser_log_enabled', 'false' )
  ;
  commit;
end;
/
