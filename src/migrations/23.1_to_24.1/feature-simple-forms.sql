PROMPT >> Feature Simple Forms

create table flow_simple_form_templates (
  sfte_id        number generated by default as identity (start with 1) not null
, sfte_name      varchar2(150 char) not null
, sfte_static_id varchar2(150 char) not null
, sfte_content   clob
);

alter table flow_simple_form_templates add constraint sfte_pk primary key ( sfte_id );

alter table flow_simple_form_templates add constraint sfte_uk unique ( sfte_static_id );

alter table flow_simple_form_templates add constraint sfte_ck check ( sfte_content is json(strict) );