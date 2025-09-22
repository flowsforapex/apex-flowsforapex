/*
  Migration Script for adding new diagram table columns

  Created Dennis Amthor, Hyand Solutions GmbH, 05 Jun 2025

  (c) Hyand Solutions GmbH and/or its affiliates. 2025.

*/
PROMPT >> Add dgrm_short_description

  alter table flow_diagrams add dgrm_short_description varchar2(300 char);
  comment on column flow_diagrams.dgrm_short_description is 'brief explanation of the diagram';

PROMPT >> Add dgrm_description

  alter table flow_diagrams add dgrm_description varchar2(4000 char);
  comment on column flow_diagrams.dgrm_description is 'more detailed explanation of the diagram';

PROMPT >> Add dgrm_icon

  alter table flow_diagrams add dgrm_icon varchar2(50 char);
  comment on column flow_diagrams.dgrm_icon is 'icon for this diagram';

PROMPT >> Finished adding new diagram table columns
