Expenses = {
  submitExpenseForm: function(event){
    var tr_parent = $(this).parents("tr");
    $(tr_parent).find("input.required").removeClass("error");
    
    var expense_date = $(tr_parent).find("input[name='expense_date']").val();
    var expense_detail = $(tr_parent).find("input[name='expense_detail']").val();
    var expense_amount = $(tr_parent).find("input[name='expense_amount']").val();

    var expense_credit = "";
    var credit = $(tr_parent).find("input[name='expense_credit']");
    if ($(credit).is(":checked")){
      expense_credit = true;
    }
    

    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'html',
      success: function(result) {
        var paid_for_today = $("#total_paid_money_for_today").text();
        var paid_total = parseFloat(paid_for_today) + parseFloat(expense_amount);
        $("#total_paid_money_for_today").text(paid_total.toFixed(2));

        var first_row = $("table#pay-list").find("tr#expense-form");          
        $(result).insertAfter($(first_row));
        $("#expense-form input:not('.pay-date')").val('');
        $(tr_parent).find("input[name='expense_credit']").attr("checked", false);
        $("input.expense-detail-autocomplete").focus();
      },
      error: function(){
        $(tr_parent).find("input.required").filter(function() {
          return !this.value;
        }).addClass("error").delay(1000).queue(function() {
          $(this).removeClass("error");
          $(this).dequeue();
        });
      },
      data: {
        "expense[date]": expense_date,
        "expense[detail]": expense_detail,
        "expense[amount]": expense_amount,
        "expense[credit]": expense_credit
      },
      timeout: 10000,
      type: "post",
      url: "/"+locale+"/expenses"
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
        $("#total_paid_money_for_today").text(result.tatol_for_today);
      },
      timeout: 10000,
      type: "delete",
      url: "/"+locale+"/expenses/"+expense_id
    });
  },
  editExpense: function(){
    var expense_id = $(this).attr("id"); 
    var tr_parent = $(this).parents("tr");

    $(tr_parent).find(".expense-text-show").hide();
    $(tr_parent).find(".expense-value").show();
  },
  cancelUpdateExpense: function(){
    var expense_id = $(this).attr("id"); 
    var tr_parent = $(this).parents("tr");
    $(tr_parent).find("input.required").removeClass("error");

    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'json',
      success: function(result) {  
        Expenses.updateExpenseTextDetails(result, tr_parent);
        Expenses.updateExpenseDetails(result, tr_parent);
      },
      error: function(){
      },
      timeout: 10000,
      type: "get",
      url: "/"+locale+"/expenses/"+expense_id+"/expense_details"
    });

    $(tr_parent).find(".expense-text-show").show();
    $(tr_parent).find(".expense-value").hide();
  },
  updateExpenseDetails: function(result, tr_parent){
    $(tr_parent).find("input[name='expense_date']").val(result.date);
    $(tr_parent).find("input[name='expense_detail']").val(result.detail);
    $(tr_parent).find("input[name='expense_amount']").val(result.amount);

    if (result.is_credit){
      $(tr_parent).find("input[name='expense_credit']").attr("checked", true);
    }else{
      $(tr_parent).find("input[name='expense_credit']").attr("checked", false);
    }
  },
  updateExpenseTextDetails: function(result, tr_parent){
    $(tr_parent).find("#expense-date").text(result.date);
    $(tr_parent).find("#expense-detail").text(result.detail);
    $(tr_parent).find("#expense-amount").text(result.amount);
    $(tr_parent).find("#expense-credit").html(result.credit);  
  },
  updateExpense: function(event){
    var obj = $(this);
    var expense_id = $(this).attr("id"); 

    var tr_parent = $(this).parents("tr");
    $(tr_parent).find("input.required").removeClass("error");
    
    var expense_date = $(tr_parent).find("input[name='expense_date']").val();
    var expense_detail = $(tr_parent).find("input[name='expense_detail']").val();
    var expense_amount = $(tr_parent).find("input[name='expense_amount']").val();

    var expense_credit = "";
    var credit = $(tr_parent).find("input[name='expense_credit']");
    if ($(credit).is(":checked")){
      expense_credit = true;
    }

    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'json',
      success: function(result) {        
        $("#total_paid_money_for_today").text(result.tatol_for_today);
        Expenses.updateExpenseTextDetails(result, tr_parent);
        Expenses.updateExpenseDetails(result, tr_parent);

        $(tr_parent).find(".expense-text-show").show();
        $(tr_parent).find(".expense-value").hide();        
      },
      error: function(){
        $(tr_parent).find("input.required").filter(function() {
          return !this.value;
        }).addClass("error");
      },
      data: {
        "expense[date]": expense_date,
        "expense[detail]": expense_detail,
        "expense[amount]": expense_amount,
        "expense[credit]": expense_credit
      },
      timeout: 10000,
      type: "put",
      url: "/"+locale+"/expenses/"+expense_id
    });
  },
  init: function(){
    $(document).on("click", "button#insert-expense", Expenses.submitExpenseForm);
    $(document).on("click", ".remove-expense", Expenses.removeExpense);
    $(document).on("click", ".edit-expense", Expenses.editExpense);
    $(document).on("click", ".cancel-update-expense", Expenses.cancelUpdateExpense);
    $(document).on("click", ".update-expense-btn", Expenses.updateExpense);

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

$(Expenses.init);