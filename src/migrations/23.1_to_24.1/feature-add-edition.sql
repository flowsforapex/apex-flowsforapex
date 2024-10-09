/*
  Migration Script for adding Editions Infrastructure

  Created  RAllen   13 May 2024


  (c) Copyright Flowquest Limited and/or its affiliates.  2024.

*/

begin
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'license_edition'                               ,p_value => 'community' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'license_key'                                   ,p_value => '' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'licensed_to'                                   ,p_value => '' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'license_expiry_date'                           ,p_value => '' );
end;
/
