PROMPT >> Hotfix for issue #425
PROMPT >> Issue migrating BPMN models to v22.1 with variable expressions
PROMPT >> ========================================================

declare
  l_data XMLTYPE;
  l_domdoc dbms_xmldom.DOMDocument;
  l_domnodelist dbms_xmldom.DOMNodeList;
  
  l_domnode dbms_xmldom.DOMNode;
  l_domelement dbms_xmldom.DOMElement;
  
  l_ext_elements dbms_xmldom.DOMNodeList;
  l_ext_node_1 dbms_xmldom.DOMNode;
  l_ext_node_2 dbms_xmldom.DOMNode;
  l_ext_node_2_children dbms_xmldom.DOMNodeList;

  l_return_node dbms_xmldom.DOMNode;

  l_has_changed boolean default false;
  l_result clob;
begin
  -- loop over all diagrams
  for rec in ( select dgrm_id, dgrm_content from flow_diagrams ) loop
    -- get xml document
    l_data := XMLTYPE(rec.dgrm_content);
    l_domdoc := dbms_xmldom.newDOMDocument(l_data);
    -- get tags
    l_domnodelist := dbms_xmldom.getelementsbytagname(
        doc => l_domdoc
      , tagname => '*'
    );
    -- loop over all tags
    for i in 0 .. dbms_xmldom.getlength(l_domnodelist) - 1
    loop
      l_domnode := dbms_xmldom.item(l_domnodelist, i);
      -- for userTasks, scriptTasks and serviceTasks
      if dbms_xmldom.getnodename(l_domnode) in ('bpmn:userTask', 'bpmn:scriptTask', 'bpmn:serviceTask') then
        l_domelement := dbms_xmldom.makeelement(l_domnode);
        -- get extension elements
        l_ext_elements :=
        dbms_xmldom.getchildrenbytagname(
            elem => l_domelement
          , name => 'extensionElements'
        );
        -- if two nodes exist
        if dbms_xmldom.getlength(l_ext_elements) = 2 then
          -- mark as changed
          l_has_changed := true;
          -- store first extensionElements node
          l_ext_node_1 := dbms_xmldom.item(l_ext_elements, 0);
          -- store second extensionElements node
          l_ext_node_2 := dbms_xmldom.item(l_ext_elements, 1);
          -- get children of second node
          l_ext_node_2_children := 
            dbms_xmldom.getchildnodes(
              n => l_ext_node_2
            );
          -- append children to first node
          for j in 0 .. dbms_xmldom.getlength(l_ext_node_2_children) - 1
          loop
            l_return_node :=
            dbms_xmldom.appendchild(
                n        => l_ext_node_1
              , newchild => dbms_xmldom.item(l_ext_node_2_children, j)
            );
          end loop;
          -- remove second node
          l_return_node :=
            dbms_xmldom.removechild(
                n => l_domnode
              , oldchild => l_ext_node_2
            );
        end if;
      end if;
    end loop;
    -- if changed
    if l_has_changed then
      -- create clob
      dbms_lob.createtemporary(l_result, false); 
      dbms_xmldom.writetoclob(
          doc => l_domdoc 
        , cl => l_result
      );
      -- update diagram xml
      update flow_diagrams
         set dgrm_content = l_result
       where dgrm_id = rec.dgrm_id;
    end if;
  end loop;
  commit;
end;
/

PROMPT >> Hotfix for issue #425 applied
PROMPT >> =============================
