Histories = {
  init: function(){
    $(document).on("change", "form#search-by-year select#year", function(){
      $("form#search-by-year").submit();
    });
  }
};

$(Histories.init);