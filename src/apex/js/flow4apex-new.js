var f4a = f4a || {};

apex.jQuery(window).on('theme42ready', function() {
  apex.theme42.util.configAPEXMsgs( {
    autoDismiss: true,
    duration: 5000,
  });
});

f4a.util = {
  register: function () {
    null;
  }
};

f4a.ui = {

  addClassesToParents: function(pSelector, pParentSelector, pClasses) {
    apex
      .jQuery( pSelector )
      .parents( pParentSelector )
      .addClass( pClasses );
  }
}

f4a.app = {

  initPage3: function(){
    
  }
}
