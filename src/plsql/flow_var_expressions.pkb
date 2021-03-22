create or replace package body flow_var_expressions
as 
  

  type t_expr_set is table of flow_object_expressions%rowtype;


  function get_expression_set
  ( pi_objt_id      flow_objects.objt_id%type
  , pi_phase        flow_object_expressions.expr_phase%type
  ) return t_expr_set
  as
    l_expressions   t_expr_set;
  begin
    select *
    bulk collect into l_expressions
      from flow_objects_expressions expr
     where expr.expr_objt_id = pi_objt_id
       and expr.expr_phase = pi_phase
     order by expr.expr_order asc
    ;
    return l_expressions;
  end get_expression_set;

  /**********************************************************************
  **
  ** Process various expression types
  **
  ***********************************************************************
  */

  procedure set_static
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  )
  as 
  begin
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_vc2_value => pi_expression.expr_expression
        );
    when flow_constants_pkg.gc_prov_var_type_number then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_num_value => pi_expression.expr_expression
        );
    when flow_constants_pkg.gc_prov_var_type_date then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_date_value => pi_expression.expr_expression
        );
    when flow_constants_pkg.gc_prov_var_type_clob then
        -- does this one make sense?
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_clob_value => pi_expression.expr_expression
        );  
    end case;
  end set_static;

  procedure set_proc_var
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  )
  as 
  begin
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_vc2_value => get_var_vc2 
                          ( pi_prcs_id => pi_prcs_id
                          , pi_var_name => pi_expression.expr_expression
                          )
        );      
    when flow_constants_pkg.gc_prov_var_type_date then
        flow_process_vars.set_var 
        ( pi_prcs_id    => pi_prcs_id
        , pi_var_name   => pi_expression.expr_var_name
        , pi_date_value => get_var_date 
                           ( pi_prcs_id  => pi_prcs_id
                           , pi_var_name => pi_expression.expr_expression
                           )
        );     
    when flow_constants_pkg.gc_prov_var_type_number then
        flow_process_vars.set_var 
        ( pi_prcs_id      => pi_prcs_id
        , pi_var_name     => pi_expression.expr_var_name
        , pi_number_value => get_var_number
                             ( pi_prcs_id  => pi_prcs_id
                             , pi_var_name => pi_expression.expr_expression
                             )
        );    
    when flow_constants_pkg.gc_prov_var_type_clob then
        flow_process_vars.set_var 
        ( pi_prcs_id    => pi_prcs_id
        , pi_var_name   => pi_expression.expr_var_name
        , pi_clob_value => get_var_clob 
                          ( pi_prcs_id  => pi_prcs_id
                          , pi_var_name => pi_expression.expr_expression
                          )
        );             
  end set_proc_var;

  procedure set_sql
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  )
  as 
  begin
    null;
  end set_sql;

  /**********************************************************************
  **
  ** Main Procedure
  **
  ***********************************************************************
  */

  procedure process_expressions
  ( pi_objt_id      flow_objects.objt_id%type
  , pi_phase        flow_object_expressions.expr_phase%type
  , pi_prcs_id      flow_processes.prcs_id%type
  )
  as
    l_expressions   t_expr_set;
  begin
    l_expressions := get_expression_set
    ( pi_objt_id => pi_objt_id
    , pi_phase => pi_phase
    );
    -- step through expressions
    for i in 1..l_expressions.count loop
      -- process expression
      case l_expressions(i).expr_type
        when flow_constants_pkg.gc_expr_type_static then
          set_static 
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i));
        when flow_constants_pkg.gc_expr_type_proc_var then
          set_proc_var
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i));
        when flow_constants_pkg.gc_expr_type_sql  then
          set_sql
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i));
        else
            null;
      end case;
    end loop;
  end process_expressions;
  
end flow_var_expressions;
/