OtherExpenses = {
  submitExpenseForm: function(event){
    var tr_parent = $(this).parents("tr");
    $(tr_parent).find("input.required").removeClass("error");
    OtherExpenses.disabledExpenseForm();
    
    var expense_date = $(tr_parent).find("input[name='expense_date']").val();
    var expense_detail = $(tr_parent).find("input[name='expense_detail']").val();
    var expense_amount = $(tr_parent).find("input[name='expense_amount']").val();    

    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'html',
      success: function(result) {
        var total_of_this_month = $(result).attr("total-of-this-month");
        $("#total_of_this_month").text(total_of_this_month);

        var first_row = $("table#pay-list").find("tr#expense-form");          
        $(result).insertAfter($(first_row));
        $("#expense-form input:not('.pay-date')").val('');

        OtherExpenses.enableExpenseForm();
      },
      error: function(){
        $(tr_parent).find("input.required").filter(function() {
          return !this.value;
        }).addClass("error").delay(1000).queue(function() {
          $(this).removeClass("error");
          $(this).dequeue();
        });
        OtherExpenses.enableExpenseForm();
      },
      data: {
        "expense[date]": expense_date,
        "expense[detail]": expense_detail,
        "expense[amount]": expense_amount,
        "expense[other]": true
      },
      timeout: 10000,
      type: "post",
      url: "/"+locale+"/other_expenses"
    });
  },
  removeExpense: function(){
    var obj = $(this);
    var expense_id = $(this).attr("id");    
    if (!confirm("Are you sure?")){
      return false;
    }
    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'json',
      success: function(result) {
        $(obj).parents("tr").remove();
        $("#total_paid_money_for_today").text(result.total_for_today);
        $("#total_of_this_month").text(result.total_of_this_month);
        $("#average_of_this_month").text(result.average_of_this_month);
      },
      timeout: 10000,
      type: "delete",
      url: "/"+locale+"/other_expenses/"+expense_id
    });
  },
  editExpense: function(){
    var expense_id = $(this).attr("id"); 
    var tr_parent = $(this).parents("tr");
    OtherExpenses.disabledExpenseForm();

    $(tr_parent).find(".expense-text-show").hide();
    $(tr_parent).find(".expense-value").show();
  },
  cancelUpdateExpense: function(){
    var expense_id = $(this).attr("id"); 
    var tr_parent = $(this).parents("tr");
    $(tr_parent).find("input.required").removeClass("error");
    OtherExpenses.enableExpenseForm();

    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'json',
      success: function(result) {  
        OtherExpenses.updateExpenseTextDetails(result, tr_parent);
        OtherExpenses.updateExpenseDetails(result, tr_parent);
      },
      error: function(){
      },
      timeout: 10000,
      type: "get",
      url: "/"+locale+"/other_expenses/"+expense_id+"/expense_details"
    });

    $(tr_parent).find(".expense-text-show").show();
    $(tr_parent).find(".expense-value").hide();
  },
  updateExpenseDetails: function(result, tr_parent){
    $(tr_parent).find("input[name='expense_date']").val(result.date);
    $(tr_parent).find("input[name='expense_detail']").val(result.detail);
    $(tr_parent).find("input[name='expense_amount']").val(result.amount);
  },
  updateExpenseTextDetails: function(result, tr_parent){
    $(tr_parent).find("#expense-date").text(result.date);
    $(tr_parent).find("#expense-detail").text(result.detail);
    $(tr_parent).find("#expense-amount").text(result.amount); 
  },
  updateExpense: function(event){
    var obj = $(this);
    var expense_id = $(this).attr("id"); 

    var tr_parent = $(this).parents("tr");
    $(tr_parent).find("input.required").removeClass("error");
    
    var expense_date = $(tr_parent).find("input[name='expense_date']").val();
    var expense_detail = $(tr_parent).find("input[name='expense_detail']").val();
    var expense_amount = $(tr_parent).find("input[name='expense_amount']").val();

    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'json',
      success: function(result) {        
        $("#total_paid_money_for_today").text(result.total_for_today);
        $("#total_of_this_month").text(result.total_of_this_month);
        $("#average_of_this_month").text(result.average_of_this_month);
        
        OtherExpenses.updateExpenseTextDetails(result, tr_parent);
        OtherExpenses.updateExpenseDetails(result, tr_parent);

        $(tr_parent).find(".expense-text-show").show();
        $(tr_parent).find(".expense-value").hide();  
        OtherExpenses.enableExpenseForm();      
      },
      error: function(){
        $(tr_parent).find("input.required").filter(function() {
          return !this.value;
        }).addClass("error");
        OtherExpenses.enableExpenseForm();
      },
      data: {
        "expense[date]": expense_date,
        "expense[detail]": expense_detail,
        "expense[amount]": expense_amount
      },
      timeout: 10000,
      type: "put",
      url: "/"+locale+"/other_expenses/"+expense_id
    });
  },
  disabledExpenseForm: function(){
    $("tr#expense-form").find("input, button").attr("disabled", true);
  },
  enableExpenseForm: function(){
    $("tr#expense-form").find("input, button").attr("disabled", false);
  },
  init: function(){
    $(document).on("click", "button#insert-expense", OtherExpenses.submitExpenseForm);
    $(document).on("click", ".remove-expense", OtherExpenses.removeExpense);
    $(document).on("click", ".edit-expense", OtherExpenses.editExpense);
    $(document).on("click", ".cancel-update-expense", OtherExpenses.cancelUpdateExpense);
    $(document).on("click", ".update-expense-btn", OtherExpenses.updateExpense);

    var availableTags = $("#expense-details-autocomplete").val().split(",");
    $( ".expense-detail-autocomplete" ).autocomplete({
      source: availableTags
    });
  }
};

var locale = window.location.pathname.split( '/' )[1];
if (locale.length < 1){
  locale = "th"
}

$(OtherExpenses.init);