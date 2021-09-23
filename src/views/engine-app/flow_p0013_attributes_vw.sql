create or replace view flow_p0013_attributes_vw
as
  select objt.objt_bpmn_id
       , obat_key
       , case
           when obat_num_value is not null then cast(obat_num_value as varchar2(4000))
           when obat_date_value is not null then cast(obat_date_value as varchar2(4000))
           when obat_vc_value is not null then obat_vc_value
           when obat_clob_value is not null then '[clob]'
         end as obat_value
       , case when instr(obat_key, 'plsql') > 0 then '<pre><code class="language-plsql">' end as pretag
       , case when instr(obat_key, 'plsql') > 0 then '</code></pre>' end as posttag  
       , objt.objt_dgrm_id
    from flow_object_attributes obat
    join flow_objects objt
      on obat.obat_objt_id = objt.objt_id
with read only;
