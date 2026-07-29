/*
  Migration Script for fix-879-iteration-objects

  Created  RAllen, Flowquest    20 Jul 2026 


  (c) Copyright Flowquest Limited and/or its affiliates.  2026.

*/
prompt >> Schema Changes for Iteration Objects Fix
prompt >> ---------------------------------------------------

alter table flow_iterated_objects
  drop constraint flow_iobj_uk;

alter table flow_iterated_objects
  add constraint flow_iobj_uk unique    ( iobj_prcs_id
                                        , iobj_iteration_var
                                        , iobj_var_scope
                                        , iobj_step_key );

prompt >> Finished Schema Changes for Iteration Objects Fix 
