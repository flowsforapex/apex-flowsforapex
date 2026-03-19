/*
-- Flows for APEX - grant_mcp_roles.sql
--
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created   18-Mar-2026 Richard Allen, Flowquest
--
-- File released under Flows for APEX Community Edition licence.
*/

/*
Purpose:
  Creates and maintains the standard MCP read-only roles for Flows for APEX.

Roles created:
  FLOW_MCP_READ
    Safe customer-facing read-only role based on supported reporting views.

  FLOW_MCP_DEV_READ
    Internal developer and support read-only role based on runtime metadata
    and diagnostic tables.

Usage notes:
  - Run this as the Flows for APEX parsing schema.
  - If the roles do not yet exist, the current user needs CREATE ROLE.
  - The optional grantee can be a database user or another role.
  - Sensitive data tables such as FLOW_PROCESS_VARIABLES and REST payload logs
    are intentionally excluded from these roles.
*/

whenever sqlerror exit rollback

set serveroutput on size unlimited
set define '^'
set concat '.'

PROMPT >> Flows for APEX MCP Role Grants
PROMPT >> ===============================
PROMPT >> This script creates or updates FLOW_MCP_READ and FLOW_MCP_DEV_READ.
PROMPT >>

ACCEPT mcp_grantee char default 'NONE' PROMPT 'Enter grantee for FLOW_MCP_READ and FLOW_MCP_DEV_READ [NONE] '

declare
  c_role_read   constant varchar2(30) := 'FLOW_MCP_READ';
  c_role_dev    constant varchar2(30) := 'FLOW_MCP_DEV_READ';
  c_grantee     constant varchar2(128) := case
                                             when nvl( upper( trim('^mcp_grantee.') ), 'NONE' ) = 'NONE'
                                               then null
                                             else upper( dbms_assert.simple_sql_name( trim('^mcp_grantee.') ) )
                                           end;

  type t_object_names is table of varchar2(128);

  l_read_objects t_object_names := t_object_names
  (
    'FLOW_DIAGRAMS_VW'
  , 'FLOW_INSTANCES_VW'
  , 'FLOW_SUBFLOWS_VW'
  , 'FLOW_INSTANCE_DETAILS_VW'
  , 'FLOW_VIEWER_VW'
  , 'FLOW_INSTANCE_EVENTS_VW'
  , 'FLOW_INSTANCE_TIMELINE_VW'
  , 'FLOW_MESSAGE_SUBSCRIPTIONS_VW'
  );

  l_dev_objects t_object_names := t_object_names
  (
    'FLOW_BPMN_TYPES'
  , 'FLOW_CONFIGURATION'
  , 'FLOW_CONNECTIONS'
  , 'FLOW_DIAGRAMS'
  , 'FLOW_FLOW_EVENT_LOG'
  , 'FLOW_INSTANCE_DIAGRAMS'
  , 'FLOW_INSTANCE_EVENT_LOG'
  , 'FLOW_ITERATED_OBJECTS'
  , 'FLOW_ITERATIONS'
  , 'FLOW_MESSAGE_SUBSCRIPTIONS'
  , 'FLOW_OBJECTS'
  , 'FLOW_PARSER_LOG'
  , 'FLOW_PROCESSES'
  , 'FLOW_STEP_EVENT_LOG'
  , 'FLOW_SUBFLOW_LOG'
  , 'FLOW_SUBFLOWS'
  , 'FLOW_TIMERS'
  );

  procedure ensure_role
  (
    p_role_name in varchar2
  )
  as
  begin
    execute immediate 'create role ' || dbms_assert.simple_sql_name( p_role_name );
    dbms_output.put_line( 'Created role ' || p_role_name );
  exception
    when others then
      case sqlcode
        when -1921 then
          dbms_output.put_line( 'Role ' || p_role_name || ' already exists.' );
        when -1031 then
          dbms_output.put_line( 'No CREATE ROLE privilege while checking ' || p_role_name || '. Assuming the role already exists.' );
        else
          raise;
      end case;
  end ensure_role;

  procedure grant_select_list
  (
    p_role_name    in varchar2
  , p_object_names in t_object_names
  )
  as
  begin
    for i in 1 .. p_object_names.count loop
      begin
        execute immediate
            'grant select on '
         || dbms_assert.simple_sql_name( p_object_names(i) )
         || ' to '
         || dbms_assert.simple_sql_name( p_role_name );

        dbms_output.put_line( 'Granted SELECT on ' || p_object_names(i) || ' to ' || p_role_name );
      exception
        when others then
          case sqlcode
            when -1917 then
              raise_application_error(
                  -20001
                , 'Role ' || p_role_name || ' does not exist. Create the role first or rerun this script as a user with CREATE ROLE.'
                );
            when -942 then
              raise_application_error(
                  -20002
                , 'Object ' || p_object_names(i) || ' does not exist in the current schema.'
                );
            else
              raise;
          end case;
      end;
    end loop;
  end grant_select_list;

  procedure grant_role_if_requested
  (
    p_role_name in varchar2
  )
  as
  begin
    if c_grantee is not null then
      execute immediate
          'grant '
       || dbms_assert.simple_sql_name( p_role_name )
       || ' to '
       || dbms_assert.simple_sql_name( c_grantee );

      dbms_output.put_line( 'Granted role ' || p_role_name || ' to ' || c_grantee );
    end if;
  exception
    when others then
      case sqlcode
        when -1917 then
          raise_application_error(
              -20003
            , 'User or role ' || c_grantee || ' does not exist.'
            );
        else
          raise;
      end case;
  end grant_role_if_requested;
begin
  ensure_role( c_role_read );
  ensure_role( c_role_dev );

  dbms_output.put_line( 'Applying customer-safe MCP grants...' );
  grant_select_list( c_role_read, l_read_objects );

  dbms_output.put_line( 'Applying developer MCP grants...' );
  grant_select_list( c_role_dev, l_dev_objects );

  grant_role_if_requested( c_role_read );
  grant_role_if_requested( c_role_dev );

  dbms_output.put_line( 'MCP role grant setup completed.' );
end;
/