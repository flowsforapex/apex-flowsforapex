create table flow_rest_event_log (
  lgrt_id                   number generated always as identity (start with 1) not null
, lgrt_call_guid            RAW(16) not null
, lgrt_client_id            VARCHAR2(400 char)   
, lgrt_log_info             VARCHAR2(400 char)
, lgrt_token                VARCHAR2(400 char) 
, lgrt_timestamp        		TIMESTAMP WITH TIME ZONE NOT NULL
, lgrt_http_method          VARCHAR2(20 char)
, lgrt_endpoint           	VARCHAR2(4000 char)
, lgrt_payload              CLOB 
, lgrt_error_code           number
, lgrt_error_msg            VARCHAR2(2000 CHAR)
, lgrt_error_stacktrace     CLOB
);
