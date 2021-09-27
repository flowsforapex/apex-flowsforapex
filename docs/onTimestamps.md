# About Timezones and Timestamps in FlowsForAPEX

### Introduction

Systems using workflow will often have users spread across different timezones, and need to handle the issues that arise from that.

Oracle timestamps provide several different approaches for handling multiple timezones.  This short note documents the approach that we have taken in the Flows for APEX engine, how we have handled that in the Flows for APEX application (the 'Engine Application'), and suggests how you should handle this in any applications that you develop for Flows for APEX.

### Timestamps in the Database

Our approach to recording database timestamps is that we are storing all timestamps in the timezone of the underlying Oracle database.

### Timestamps in the Engine Application

Timestamps being returned to users in the engine app are converted to the user's browser timezone.  This is achieved by converting timezones to the user's local timezone in the database views underneath the engine app using the syntax `...at time zone sessiontimezone...`

### Timestamps in your Application

If you want to return all timestamps to users in their local timezone, you should also convert timezones in the underlying views or in the APEX queries that drive the application.

As an example, one of the views underneath the engine app is shown below...

```sql
create or replace view flow_p0008_instance_log as
select lgpr.lgpr_prcs_id
, lgpr.lgpr_prcs_name
, lgpr.lgpr_business_id
, lgpr.lgpr_prcs_event
, case lgpr.lgpr_prcs_event
when 'started' then 'fa-play-circle-o'
when 'running' then 'fa-play-circle-o'
when 'created' then 'fa-plus-circle-o'
when 'completed' then 'fa-check-circle-o'
when 'terminated' then 'fa-stop-circle-o'
when 'error' then 'fa-exclamation-circle-o'
when 'reset' then 'fa-undo'
when 'restart step' then 'fa-undo'
end as lgpr_prcs_event_icon
, lgpr.lgpr_timestamp at time zone sessiontimezone as lgpr_timestamp
, lgpr.lgpr_user
, lgpr.lgpr_comment
, lgpr_error_info
, case when lgpr_error_info is not null then '<pre><code class="language-log">' end as pretag
, case when lgpr_error_info is not null then '</code></pre>' end as posttag
from flow_instance_event_log lgpr
with read only;
```
