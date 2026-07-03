# Checklist of activities required to develop a new version of Flows for APEX

## "Version Infrastructure"

- [ ] Create a migration directory /migrations/current_version_to_next_version, copying appropriate files into new version
- [ ] Create copy and edit /migrations/get_flows_version.sql with the new version number
- [ ] Update /src/data/install_default_config_data.sql with new version number for 'version_now_installed' and 'version_initial_installed'

## DEV environments

- [ ] Create new dev PDB on flowsforapex.com
- [ ] Update the app version number

## BPMN Tutorials

- [ ] Bulk edit the tutorials to new version number

## Doc

- [ ] Generate the API doc for flows_api_pkg, flows_admin_api, flow_globals, and flow_process_vars
- [ ] Update the bug reporting templates

## Read Me / Release Notes
