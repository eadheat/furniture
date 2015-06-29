Global = {
  init: function(){
    $('.pay-date').datetimepicker({
      format: "D.M.YYYY"
    });
  }
};

$(Global.init);