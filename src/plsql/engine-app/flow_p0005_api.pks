create or replace package flow_p0005_api
  authid definer
as

  function get_file_name(
      p_dgrm_id in number,
      p_include_version in varchar2,
      p_include_status in varchar2,
      p_include_category in varchar2,
      p_include_last_change_date in varchar2,
      p_download_as in varchar2
  ) return varchar2;

  procedure download_file(
      p_dgrm_id in number,
      p_file_name in varchar2,
      p_download_as in varchar2
  );

end flow_p0005_api;
/
