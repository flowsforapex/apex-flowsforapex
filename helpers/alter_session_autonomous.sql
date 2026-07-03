/* Run this before installing engine message via install_engine_messages_en.sql */

-- Keep message reload deterministic on Autonomous DB.
begin
  execute immediate 'alter session disable parallel dml';
exception
  when others then
    -- ignore where unsupported, e.g. XE / older versions
    null;
end;
/
