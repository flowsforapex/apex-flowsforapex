PROMPT >> Prepare Connections table for Gateway Routing Expressions

alter table flow_connections
add
(   conn_sequence     NUMBER,        
    conn_attributes   CLOB  
);

alter table flow_connections add constraint conn_attributes_ck check ( conn_attributes is json );


