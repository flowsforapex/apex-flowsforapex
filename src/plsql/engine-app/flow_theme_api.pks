create or replace package flow_theme_api
  authid definer
as

  procedure switch_theme_mode(
    pi_request in varchar2
  );  

  procedure reset_theme_mode(
    pi_request in varchar2
  );  
  
  procedure set_init_theme_mode;
    
  procedure css_tricks(
    pi_theme_plugin_class in varchar2
  );
  
end flow_theme_api;
/