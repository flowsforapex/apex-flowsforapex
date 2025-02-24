# Checklist of activities required to develop a new version of Flows for APEX

## "Version Infrastructure"

- [ ] Create a migration directory /migrations/current_version_to_next_version, copying appropriate files into new version
- [ ] Create copy and edit /migrations/fet_flows_version.sql with the new version number
- [ ] Update /src/data/install_default_config_data.sql with new version number for 'version_now_installed' and 'version_initial_installed'
- [ ] 

## BPMN Tutorials

## Doc

- [ ] Generate the API doc for flows_api_pkg, flows_admin_api, and flow_process_vars
- [ ] 

## Read Me / Release Notes