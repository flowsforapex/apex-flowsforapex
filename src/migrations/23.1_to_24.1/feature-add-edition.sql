/*
  Migration Script for adding Editions Infrastructure

  Created  RAllen   13 May 2024


  (c) Copyright Flowquest Consulting Limited and/or its affiliates.  2024.

*/

  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'licence_edition',p_value => 'community' );
