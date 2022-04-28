PROMPT >> Rename old table and remove Foreign Keys
alter table flow_object_attributes rename to flow_obat_old;
alter table flow_obat_old drop constraint obat_objt_fk;

PROMPT >> Add new attributes column to objects table
alter table flow_objects add ( objt_attributes clob );
alter table flow_objects add constraint objt_attributes_ck check ( objt_attributes is json );

PROMPT >> Migrate current attributes to new structure
begin
  -- TODO: Implementation or Reparsing required
  null;
  commit;
end;
/
