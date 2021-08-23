function initApp(){
  apex.theme42.util.configAPEXMsgs({
    autoDismiss: true,
    duration: 5000
  });
};

function initPage2(){
  initApp();
  $(function() {
    apex.actions.add(
      [
        {
          name: "edit-flow",
          action: function(event, focusElement){ 
            var dgrmId = apex.jQuery(focusElement).attr("data-dgrm");
            apex.item("P2_DGRM_ID").setValue(dgrmId);
            apex.page.submit("EDIT_FLOW");
          }
        },
        {
          name: "new-flow-version",
          action: function(event, focusElement){ 
            var dgrmId = apex.jQuery(focusElement).attr("data-dgrm"); 
            apex.item("P2_DGRM_ID").setValue(dgrmId);
            apex.theme.openRegion("new_version_reg");
          }
        },
        {
          name: "bulk-new-flow-version",
          action: function(event, focusElement){ 
            var dgrmId = apex.jQuery("input[name=f01]:checked").map(function(){return apex.jQuery(this).attr("value");}).get().join(":"); 
            apex.item("P2_DGRM_ID").setValue(dgrmId);
            apex.theme.openRegion("new_version_reg");
          }
        },
        {
          name: "bulk-copy-flow",
          action: function(event, focusElement){ 
            var dgrmId = apex.jQuery("input[name=f01]:checked").map(function(){return apex.jQuery(this).attr("value");}).get().join(":"); 
            apex.item("P2_DGRM_ID").setValue(dgrmId);
            apex.theme.openRegion("copy_flow_reg");
          }
        },
        {
          name: "copy-flow",
          action: function(event, focusElement){ 
            var dgrmId = apex.jQuery(focusElement).attr("data-dgrm"); 
            apex.item("P2_DGRM_ID").setValue(dgrmId);
            apex.theme.openRegion("copy_flow_reg");
          }
        }
      ])
    }
  );

  apex.jQuery(window).on('theme42ready', function() {
    $("#parsed_drgm table th.a-IRR-header--group").attr("colspan", "6").after('<th colspan="5" class="a-IRR-header a-IRR-header--group" id="instances_column_group_heading" style="text-align: center;">Instances</th>');

    $(".a-IRR-headerLabel, .a-IRR-headerLink").each(function() {
      var text = $(this).text();
      if (text == 'Created') {
        $(this).parent().addClass("created");
      }
      else if (text == 'Completed') {
        $(this).parent().addClass("completed");
      }
      else if (text == 'Running') {
        $(this).parent().addClass("running");
      }
      else if (text == 'Terminated') {
        $(this).parent().addClass("terminated");
      }
      else if (text == 'Error') {
        $(this).parent().addClass("error");
      }
    });

    $("th.a-IRR-header").each(function(i){
      if ( apex.jQuery(this).attr("id") === undefined) {
        apex.jQuery(this).find('input[type="checkbox"]').hide();
        apex.jQuery(this).find('button#header-action').hide();
      } else {
        apex.jQuery(this).addClass("u-alignMiddle");
      }
    });

    $( "#header_actions_menu" ).on( "menubeforeopen", function( event, ui ) {
      var menuItems = ui.menu.items;
      if ( apex.jQuery('#parsed_drgm_ir .a-IRR-tableContainer').find('input[type="checkbox"]:checked').length === 0 ) {
        menuItems = menuItems.map(function(item){ if (item.action !== "refresh") { item.disabled = true;} return item;});
      } else {
        menuItems = menuItems.map(function(item){ if (item.action !== "refresh") { item.disabled = false;} return item;});

        apex.jQuery('#parsed_drgm_ir .a-IRR-tableContainer').find('input[type="checkbox"]:checked').each(function(){
          var name = $(this).data("name");
          
          if ( apex.jQuery('#parsed_drgm_ir .a-IRR-tableContainer').find('input[type="checkbox"][data-name="' + name + '"]:checked').length > 1 ) {
            menuItems = menuItems.map(function(item){ if (item.action === "bulk-new-flow-version" || item.action === "bulk-copy-flow") { item.disabled = true;} return item;});
            return false;
          }
        });
      }
      ui.menu.items = menuItems;
    });

  });
}