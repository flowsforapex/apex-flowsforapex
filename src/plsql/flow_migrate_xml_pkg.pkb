create or replace package body flow_migrate_xml_pkg
as

  function is_exporter_version_current(
    p_domdoc dbms_xmldom.DOMDocument
  ) return boolean
  as
    l_exporter varchar2(50);
    l_exporter_version varchar2(10);
    l_domnodelist dbms_xmldom.DOMNodeList;
    l_domnode dbms_xmldom.DOMNode;
    l_domelement dbms_xmldom.DOMElement;
    l_exporter_below_22 boolean;
  begin
    l_domnodelist := dbms_xmldom.getelementsbytagname(
      doc => p_domdoc
    , tagname => 'definitions'
    );
    for i in 0 .. dbms_xmldom.getlength(l_domnodelist) - 1
      loop
        l_domnode := dbms_xmldom.item(l_domnodelist, i);
        l_domelement := dbms_xmldom.makeelement(l_domnode);
        l_exporter := dbms_xmldom.getattribute(
                        elem => l_domelement
                      , name => 'exporter'
                      );
        l_exporter_version := dbms_xmldom.getattribute(
                              elem => l_domelement
                            , name => 'exporterVersion'
                            );
        l_exporter_below_22 := ( to_number(substr(l_exporter_version, 1, instr(l_exporter_version, '.') - 1)) < 22 );
      end loop;    
    return (l_exporter = 'Flows for APEX' and ( not l_exporter_below_22 or l_exporter_version = flow_constants_pkg.gc_version ));
  end is_exporter_version_current;
  
  procedure set_exporter(
    p_domdoc in out dbms_xmldom.DOMDocument
  , p_exporter varchar2
  , p_exporter_version varchar2
  )
  as
    l_domnodelist dbms_xmldom.DOMNodeList;
    l_domnode dbms_xmldom.DOMNode;
    l_domelement dbms_xmldom.DOMElement;
  begin
    l_domnodelist := dbms_xmldom.getelementsbytagname(
      doc => p_domdoc
    , tagname => 'definitions'
    );
    for i in 0 .. dbms_xmldom.getlength(l_domnodelist) - 1
      loop
        l_domnode := dbms_xmldom.item(l_domnodelist, i);
        l_domelement := dbms_xmldom.makeelement(l_domnode);
        dbms_xmldom.setattribute(
          elem => l_domelement
        , name => 'exporter'
        , newValue => p_exporter
        );
        dbms_xmldom.setattribute(
          elem => l_domelement
        , name => 'exporterVersion'
        , newValue => p_exporter_version
        );
      end loop;    
  end set_exporter;

  procedure append_page_item(
    p_domdoc in out dbms_xmldom.DOMDocument
  , p_page_items in out dbms_xmldom.DOMNode
  , p_item_name varchar2
  , p_item_value varchar2
  )
  as
    l_item_node dbms_xmldom.DOMNode;
    l_item_name_node dbms_xmldom.DOMNode;
    l_item_value_node dbms_xmldom.DOMNode;
    l_item_text_node dbms_xmldom.DOMNode;
  begin
    -- create page item node
    l_item_node := dbms_xmldom.makenode( 
      elem => dbms_xmldom.createelement( 
                doc => p_domdoc
              , tagName => 'apex:pageItem'
              , ns => flow_constants_pkg.gc_nsapex
              )
    );
    -- append
    l_item_node := dbms_xmldom.appendchild(
      n => p_page_items
    , newchild => l_item_node
    );
    -- create item name node 
    l_item_name_node := dbms_xmldom.makenode( 
      elem => dbms_xmldom.createelement( 
                doc => p_domdoc
              , tagName => 'apex:itemName'
              , ns => flow_constants_pkg.gc_nsapex
              ) 
    );
    -- create text node
    l_item_text_node := dbms_xmldom.makenode( 
      t => dbms_xmldom.createtextnode(
            doc => p_domdoc
          , data => p_item_name
          )
    );
    -- append text
    l_item_text_node := dbms_xmldom.appendchild(
      n => l_item_name_node
    , newchild => l_item_text_node
    );
    -- append
    l_item_name_node := dbms_xmldom.appendchild(
      n => l_item_node
    , newchild => l_item_name_node
    );
    -- create item value node 
    l_item_value_node := dbms_xmldom.makenode( 
      elem => dbms_xmldom.createelement( 
                doc => p_domdoc
              , tagName => 'apex:itemValue'
              , ns => flow_constants_pkg.gc_nsapex
              )
    );
     -- create text node
    l_item_text_node := dbms_xmldom.makenode( 
      t => dbms_xmldom.createtextnode(
            doc => p_domdoc
          , data => p_item_value
          )
    );
    -- append text
    l_item_text_node := dbms_xmldom.appendchild(
      n => l_item_value_node
    , newchild => l_item_text_node
    );
    -- append
    l_item_value_node := dbms_xmldom.appendchild(
      n => l_item_node
    , newchild => l_item_value_node
    );
  end append_page_item;    

  procedure update_apex_namespace(
    p_domdoc in out dbms_xmldom.DOMDocument
  )
  as
    l_domnodelist dbms_xmldom.DOMNodeList;
    l_domnode dbms_xmldom.DOMNode;
    l_domelement dbms_xmldom.DOMElement;
  begin
    l_domnodelist := dbms_xmldom.getelementsbytagname(
      doc => p_domdoc
    , tagname => 'definitions'
    );
    for i in 0 .. dbms_xmldom.getlength(l_domnodelist) - 1
      loop
        l_domnode := dbms_xmldom.item(l_domnodelist, i);
        l_domelement := dbms_xmldom.makeelement(l_domnode);
        dbms_xmldom.setattribute(
          elem => l_domelement
        , name => 'xmlns:apex'
        , newValue => flow_constants_pkg.gc_nsapex
        );
      end loop; 
  end update_apex_namespace;

  procedure migrate_xml(
    p_dgrm_content in out clob
  , p_has_changed out boolean  
  )
  as
    l_data XMLTYPE;
    l_domdoc dbms_xmldom.DOMDocument;
    l_domnodelist dbms_xmldom.DOMNodeList;
    -- task
    l_domnode dbms_xmldom.DOMNode;
    l_domelement dbms_xmldom.DOMElement;
    -- extension element
    l_extension_node dbms_xmldom.DOMNode;
    -- task type
    l_task_type_node dbms_xmldom.DOMNode;
    -- children (old)
    l_children dbms_xmldom.DOMNodeList;
    l_children_count number;
    l_child_node dbms_xmldom.DOMNode;
    -- child value
    l_child_text_node dbms_xmldom.DOMNode;
    -- children (new)
    l_ext_child_node dbms_xmldom.DOMNode;
    l_ext_child_tag_name varchar2(50);

    -- user task
    l_items varchar2(4000);
    l_items_arr apex_t_varchar2;
    l_values varchar2(4000);
    l_values_arr apex_t_varchar2;
    l_valid_items number;

    l_return clob;

    function get_or_create_ext_elements
    (
      p_domdoc  dbms_xmldom.DOMDocument
    , p_domnode dbms_xmldom.DOMNode
    , p_elem    dbms_xmldom.DOMElement
    )
      return dbms_xmldom.DOMNode
    as
      l_new_ext_node     dbms_xmldom.DOMNode;
      l_cur_ext_elements dbms_xmldom.DOMNodeList;
    begin
        
      l_cur_ext_elements :=
        dbms_xmldom.getchildrenbytagname
        (
          elem => p_elem
        , name => 'extensionElements'
        );

      if dbms_xmldom.getlength(l_cur_ext_elements) > 0 then
        l_new_ext_node := dbms_xmldom.item(l_cur_ext_elements, 0);
      else
        -- create extension element node 
        l_new_ext_node :=
          dbms_xmldom.makenode( elem => 
            dbms_xmldom.createelement
            ( 
              doc     => p_domdoc
            , tagName => 'extensionElements'
            )
          );
        -- append
        l_new_ext_node :=
          dbms_xmldom.appendchild
          (
            n        => p_domnode
          , newchild => l_new_ext_node
          );
      end if;
      return l_new_ext_node;
    end get_or_create_ext_elements
    ;
  begin
    -- get xml document
    l_data := XMLTYPE(p_dgrm_content);
    l_domdoc := dbms_xmldom.newDOMDocument(l_data);

    -- retrieve exporter version
    if not is_exporter_version_current(l_domdoc) then

      -- get tags
      l_domnodelist := dbms_xmldom.getelementsbytagname(
        doc => l_domdoc
      , tagname => '*'
      );
  
      -- loop over all tags
      for i in 0 .. dbms_xmldom.getlength(l_domnodelist) - 1
      loop
        l_domnode := dbms_xmldom.item(l_domnodelist, i);
        case
          -- user tasks
          when dbms_xmldom.getnodename(l_domnode) = 'bpmn:userTask' then
            l_domelement := dbms_xmldom.makeelement(l_domnode);
            -- set task type attribute
            dbms_xmldom.setattribute(
              elem => l_domelement
            , name => 'apex:type'
            , newValue => 'apexPage'
            , ns => flow_constants_pkg.gc_nsapex
            );

            l_extension_node :=
              get_or_create_ext_elements
              ( 
                p_domdoc  => l_domdoc
              , p_domnode => l_domnode
              , p_elem    => l_domelement
              );

            -- create apex page node 
            l_task_type_node := dbms_xmldom.makenode( 
              elem => dbms_xmldom.createelement( 
                doc => l_domdoc
              , tagName => 'apex:apexPage'
              , ns => flow_constants_pkg.gc_nsapex
              ) 
            );
            -- append
            l_task_type_node := dbms_xmldom.appendchild(
              n => l_extension_node
            , newchild => l_task_type_node
            );  
            -- get child nodes
            l_children := dbms_xmldom.getchildnodes(l_domnode);
            l_children_count := dbms_xmldom.getlength(l_children);
            -- loop over child nodes
            for j in 0 .. l_children_count - 1
            loop
              l_child_node := dbms_xmldom.item(l_children, j);
              case dbms_xmldom.getnodename(l_child_node)
                when 'apex:apex-application' then
                  l_ext_child_tag_name := 'apex:applicationId';
                when 'apex:apex-page' then
                  l_ext_child_tag_name := 'apex:pageId';
                when 'apex:apex-request' then
                  l_ext_child_tag_name := 'apex:request';
                when 'apex:apex-cache' then
                  l_ext_child_tag_name := 'apex:cache';
                when 'apex:apex-item' then
                  l_ext_child_tag_name := '';
                  -- get text
                  l_items := dbms_xmldom.getnodevalue(dbms_xmldom.getfirstchild(l_child_node));
                  -- remove old child
                  l_child_node := dbms_xmldom.removechild(
                    n => l_domnode
                  , oldchild => l_child_node
                  ); 
                when 'apex:apex-value' then
                  l_ext_child_tag_name := '';
                  -- get text
                  l_values := dbms_xmldom.getnodevalue(dbms_xmldom.getfirstchild(l_child_node));
                  -- remove old child
                  l_child_node := dbms_xmldom.removechild(
                    n => l_domnode
                  , oldchild => l_child_node
                  ); 
                else
                  l_ext_child_tag_name := '';
              end case;
              if length(l_ext_child_tag_name) > 0 then
                  -- create new child element node 
                  l_ext_child_node := dbms_xmldom.makenode( 
                    elem => dbms_xmldom.createelement( 
                              doc => l_domdoc
                            , tagName => l_ext_child_tag_name
                            , ns => flow_constants_pkg.gc_nsapex
                            ) 
                  );
                  -- get text node
                  l_child_text_node := dbms_xmldom.getfirstchild(l_child_node);
                  if not dbms_xmldom.isnull(l_child_text_node) then
                      -- add text node
                      l_child_text_node := dbms_xmldom.appendchild(
                        n => l_ext_child_node
                      , newchild => l_child_text_node
                      );
                      -- append
                      l_ext_child_node := dbms_xmldom.appendchild(
                        n => l_task_type_node
                      , newchild => l_ext_child_node
                      );
                  end if;      
                  -- remove old child
                  l_child_node := dbms_xmldom.removechild(
                    n => l_domnode
                  , oldchild => l_child_node
                  );  
              end if;
            end loop;
            -- add page items
            if (length(l_items) > 0 or length(l_values) > 0) then
              -- create new page items node 
              l_ext_child_node := dbms_xmldom.makenode( 
                elem => dbms_xmldom.createelement( 
                          doc => l_domdoc
                        , tagName => 'apex:pageItems'
                        , ns => flow_constants_pkg.gc_nsapex
                        )
              );
              -- append
              l_ext_child_node := dbms_xmldom.appendchild(
                n => l_task_type_node
              , newchild => l_ext_child_node
              );
              l_items_arr := apex_string.split(p_str => l_items, p_sep => ',');
              l_values_arr := apex_string.split(p_str => l_values, p_sep => ',');
              l_valid_items := least(l_items_arr.count, l_values_arr.count);
              for i in 1 .. l_valid_items
              loop
                append_page_item(
                  p_domdoc => l_domdoc
                , p_page_items => l_ext_child_node
                , p_item_name => l_items_arr(i)
                , p_item_value => l_values_arr(i)
                );
              end loop;
              -- item names without values
              if l_items_arr.count > l_valid_items then
                for i in l_valid_items+1 .. l_items_arr.count
                loop
                  append_page_item(
                    p_domdoc => l_domdoc
                  , p_page_items => l_ext_child_node
                  , p_item_name => l_items_arr(i)
                  , p_item_value => ''
                  );
                end loop;
              end if;    
              -- item values without names
              if l_values_arr.count > l_valid_items then
                for i in l_valid_items+1 .. l_values_arr.count
                loop
                  append_page_item(
                    p_domdoc => l_domdoc
                  , p_page_items => l_ext_child_node
                  , p_item_name => ''
                  , p_item_value => l_values_arr(i)
                  );
                end loop;
              end if;    
              -- reset variables
              l_items := null;
              l_values := null;
            end if;
            -- script + service tasks
          when dbms_xmldom.getnodename(l_domnode) = 'bpmn:scriptTask' or dbms_xmldom.getnodename(l_domnode) = 'bpmn:serviceTask' then  
              l_domelement := dbms_xmldom.makeelement(l_domnode);
              -- set task type attribute
              dbms_xmldom.setattribute(
                elem => l_domelement
              , name => 'apex:type'
              , newValue => 'executePlsql'
              , ns => flow_constants_pkg.gc_nsapex
              );

            l_extension_node :=
              get_or_create_ext_elements
              ( 
                p_domdoc  => l_domdoc
              , p_domnode => l_domnode
              , p_elem    => l_domelement
              );

              -- create execute Plsql node 
              l_task_type_node := dbms_xmldom.makenode( 
                elem => dbms_xmldom.createelement( 
                          doc => l_domdoc
                        , tagName => 'apex:executePlsql'
                        , ns => flow_constants_pkg.gc_nsapex
                        )
              );
              -- append
              l_task_type_node := dbms_xmldom.appendchild(
                n => l_extension_node
              , newchild => l_task_type_node
              );  
              -- get child nodes
              l_children := dbms_xmldom.getchildnodes(l_domnode);
              l_children_count := dbms_xmldom.getlength(l_children);
              -- loop over child nodes
              for j in 0 .. l_children_count - 1
              loop
                l_child_node := dbms_xmldom.item(l_children, j);
                case dbms_xmldom.getnodename(l_child_node)
                  when 'apex:engine' then
                    l_ext_child_tag_name := 'apex:engine';
                  when 'apex:autoBinds' then
                    l_ext_child_tag_name := 'apex:autoBinds';
                  when 'apex:plsqlCode' then
                    l_ext_child_tag_name := 'apex:plsqlCode';
                  else
                    l_ext_child_tag_name := '';
                end case;
                if length(l_ext_child_tag_name) > 0 then
                  -- create new child node 
                  l_ext_child_node := dbms_xmldom.makenode( 
                    elem => dbms_xmldom.createelement( 
                              doc => l_domdoc
                            , tagName => l_ext_child_tag_name
                            , ns => flow_constants_pkg.gc_nsapex
                            )
                  );
                  -- get text node
                  l_child_text_node := dbms_xmldom.getfirstchild(l_child_node);
                  if not dbms_xmldom.isnull(l_child_text_node) then
                      -- add text node
                      l_child_text_node := dbms_xmldom.appendchild(
                        n => l_ext_child_node
                      , newchild => l_child_text_node
                      );
                      -- append
                      l_ext_child_node := dbms_xmldom.appendchild(
                        n => l_task_type_node
                      , newchild => l_ext_child_node
                      );
                  end if;      
                  -- remove old child
                  l_child_node := dbms_xmldom.removechild(
                    n => l_domnode
                  , oldchild => l_child_node
                  );  
                end if;
              end loop;
          else null;
        end case;    
      end loop;
  
      -- set new exporter
      set_exporter(
        p_domdoc => l_domdoc
      , p_exporter => 'Flows for APEX'
      , p_exporter_version => flow_constants_pkg.gc_version
      );

      -- update apex namespace
      update_apex_namespace(l_domdoc);
  
      dbms_lob.createtemporary(l_return, false); 
      dbms_xmldom.writetoclob(
        doc => l_domdoc 
      , cl => l_return
      );
      p_dgrm_content := l_return;
      p_has_changed := true;
    else
      p_has_changed := false;
    end if;
  end migrate_xml;

end flow_migrate_xml_pkg;
/
