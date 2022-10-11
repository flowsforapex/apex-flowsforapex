create or replace package body flow_theme_api 
as
  subtype small_char is varchar2(128 byte);
  
  C_UNIVERSAL_THEME    constant number := 42;
  C_THEME_PLUGIN_CLASS constant small_char := 'THEME_PLUGIN_CLASS';
  C_FLOWS              constant small_char := 'FLOWS';
  C_FLOWS_DARK         constant small_char := 'FLOWS-DARK';
  C_VITA               constant small_char := 'Vita';
  C_VITA_DARK          constant small_char := 'Vita - Dark'; 
  C_LIGHT              constant small_char := 'light';
  C_DARK               constant small_char := 'dark';
  
  /* Helper */
  function file_exists(
    p_file_name in varchar2
  ) return boolean
  as
    l_file_exists binary_integer;
  begin
    select count(*)
      into l_file_exists
      from dual
     where exists(
           select null
             from apex_application_static_files
            where file_name = p_file_name
              and application_id = apex_application.g_flow_id);
    return l_file_exists = 1;
  end file_exists;
  
  function get_user_theme_preference(
    pi_theme_mode in varchar2
  ) return varchar2
  as
    l_theme_style_id apex_application_theme_styles.theme_style_id%type;
    l_theme_name     apex_application_theme_styles.name%type;
  begin
    l_theme_style_id := apex_theme.get_user_style(apex_application.g_flow_id, apex_application.g_user, C_UNIVERSAL_THEME);
    
    select s.name
      into l_theme_name
      from apex_application_theme_styles s
      join apex_application_themes t
        on s.application_id = t.application_id
       and s.theme_number = t.theme_number
     where s.application_id = apex_application.g_flow_id
       and s.theme_style_id = l_theme_style_id;
    return l_theme_name;
  exception
    when no_data_found then 
      return pi_theme_mode;
  end get_user_theme_preference;
  
  
  /* Interface */
  procedure switch_theme_mode(
    pi_request in varchar2
  ) 
  as
    l_theme_style_id     number;
    l_theme_name         small_char;
    l_theme_plugin_class small_char;
  begin

    apex_util.set_preference (
        p_preference => 'THEME_MODE',
        p_value      => 'static',
        p_user       => apex_application.g_user
    );
    
    case pi_request
      when 'LIGHT_MODE' then 
        l_theme_name := C_VITA; 
        l_theme_plugin_class := C_FLOWS;
      when 'DARK_MODE' then 
        l_theme_name := C_VITA_DARK; 
        l_theme_plugin_class := C_FLOWS_DARK;
      else null;
    end case;
    
    select s.theme_style_id
      into l_theme_style_id
      from apex_application_theme_styles s
      join apex_application_themes t
        on s.application_id = t.application_id
       and s.theme_number = t.theme_number
     where s.application_id = apex_application.g_flow_id
       and s.name = l_theme_name;

    apex_theme.set_user_style (
      p_application_id => apex_application.g_flow_id
    , p_user           => apex_application.g_user
    , p_theme_number   => C_UNIVERSAL_THEME
    , p_id             => l_theme_style_id
    );
  
    apex_theme.set_session_style(
      p_theme_number => C_UNIVERSAL_THEME
    , p_name         => l_theme_name
    );
    
    apex_util.set_session_state(
      p_name  => C_THEME_PLUGIN_CLASS
    , p_value => l_theme_plugin_class
    );
  end switch_theme_mode;

  procedure reset_theme_mode(
    pi_request in varchar2
  )
  as
    l_theme_style_id     number;
    l_theme_name         small_char;
    l_theme_plugin_class small_char;
  begin

    apex_util.set_preference (
      p_preference => 'THEME_MODE'
    , p_value      => 'automatic'
    , p_user       => apex_application.g_user
    );
    
    case pi_request 
      when 'RESET_LIGHT' then 
        l_theme_name := C_VITA; 
        l_theme_plugin_class := C_FLOWS;
      when 'RESET_DARK' then 
        l_theme_name := C_VITA_DARK; 
        l_theme_plugin_class := C_FLOWS_DARK;
      else null;
    end case;

    select s.theme_style_id
      into l_theme_style_id
      from apex_application_theme_styles s, apex_application_themes t
     where s.application_id = t.application_id
       and s.theme_number = t.theme_number
       and s.application_id = apex_application.g_flow_id
       and s.name = l_theme_name;

     apex_theme.set_user_style (
        p_application_id => apex_application.g_flow_id
      , p_user           => apex_application.g_user
      , p_theme_number   => C_UNIVERSAL_THEME
      , p_id             => l_theme_style_id 
    );
    
    apex_theme.set_session_style(
      p_theme_number => C_UNIVERSAL_THEME
    , p_name         => l_theme_name
    );
    
    apex_util.set_session_state(
      p_name  => C_THEME_PLUGIN_CLASS
    , p_value => l_theme_plugin_class
    );
  end reset_theme_mode;

  procedure set_init_theme_mode 
  as
    l_theme_style_id        number;
    l_theme_name            apex_application_theme_styles.name%type;
    l_theme_plugin_class    small_char;
    l_url                   varchar2(4000);
    l_theme_mode_preference small_char;
  begin

    l_theme_mode_preference := apex_util.get_preference (
        p_preference => 'THEME_MODE',
        p_user       => apex_application.g_user
    );
    
    if l_theme_mode_preference = 'automatic' then
        l_theme_name := v('P9999_THEME_MODE');
    end if;
    
    if l_theme_name is null then
        begin
            select s.name
              into l_theme_name
              from apex_application_theme_styles s, apex_application_themes t
             where s.application_id = t.application_id
               and s.theme_number = t.theme_number
               and s.application_id = apex_application.g_flow_id
               and s.theme_style_id = apex_theme.get_user_style(
                                        apex_application.g_flow_id
                                      , apex_application.g_user
                                      , C_UNIVERSAL_THEME
                                      );
        exception
            when no_data_found
            then l_theme_name := C_VITA;
        end;
    end if;
    
    select s.theme_style_id
      into l_theme_style_id
      from apex_application_theme_styles s, apex_application_themes t
     where s.application_id = t.application_id
       and s.theme_number = t.theme_number
       and s.application_id = apex_application.g_flow_id
       and s.name = l_theme_name;

    apex_theme.set_user_style (
        p_application_id => apex_application.g_flow_id
      , p_user           => apex_application.g_user
      , p_theme_number   => C_UNIVERSAL_THEME
      , p_id            => l_theme_style_id 
    );
    
    apex_theme.set_session_style(
      p_theme_number => C_UNIVERSAL_THEME
    , p_name => l_theme_name
    );
    
    case l_theme_name 
      when C_VITA then l_theme_plugin_class := C_FLOWS;
      when C_VITA_DARK then l_theme_plugin_class := C_FLOWS_DARK;
      else null;
    end case;
    
    apex_util.set_session_state(
        p_name => 'THEME_PLUGIN_CLASS',
        p_value => l_theme_plugin_class
    );
  end set_init_theme_mode;
  
  procedure css_tricks(
    pi_theme_plugin_class in varchar2
  )
  as
    l_user_style_id number;
    l_theme_mode        small_char;
    l_theme_css         small_char;
    l_directory         small_char;
    l_filename          small_char;
    l_filename_css      small_char;
    l_filename_minified small_char;
  begin
    -- Initialize
    l_theme_mode := case pi_theme_plugin_class when C_FLOWS then C_VITA else C_VITA_DARK end;
    
    -- Overwrite l_theme_mode with user preference if it exists
    l_theme_mode := get_user_theme_preference(l_theme_mode);
    
    l_theme_css := case l_theme_mode when C_VITA then C_LIGHT else C_DARK end;

    -- load theme specific file
    l_directory := 'css/';
    l_filename := 'flows4apex.' || l_theme_css;
    l_filename_css := l_directory || l_filename || '.css';
    l_filename_minified := l_filename || '#MIN#';

    if file_exists(l_filename_css) then   
      apex_css.add_file(
        p_name      => l_filename_minified
      , p_directory => '#APP_IMAGES#' || l_directory
      );
    end if;
    
    -- load version specific file
    select 'css/' || substr(version_no, 1, 4) || '/'
      into l_directory
      from apex_release;
    l_filename_css := l_directory || l_filename || '.css';

    if file_exists(l_filename_css) then
      apex_css.add_file(
        p_name      => l_filename_minified
      , p_directory => '#APP_IMAGES#' || l_directory
      );
    end if;
    
    -- load prism file
    apex_css.add_file(
      p_name      => 'prism' || case l_theme_mode when C_VITA_DARK then '.dark' end ||'#MIN#'
    , p_directory => '#APP_IMAGES#lib/prismjs/css/'
    ); 
  end css_tricks;

end flow_theme_api;
/