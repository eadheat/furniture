Expenses = {
  submitExpenseForm: function(){
    var tr_parent = $(this).parents("tr");
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
        var first_row = $("table#pay-list").find("tr#expense-form");          
        $(result).insertAfter($(first_row));
      },
      data: {
        "expense[date]": expense_date,
        "expense[detail]": expense_detail,
        "expense[amount]": expense_amount,
        "expense[credit]": expense_credit
      },
      timeout: 10000,
      type: "post",
      url: "/expenses"
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
      },
      timeout: 10000,
      type: "delete",
      url: "/expenses/"+expense_id
    });
  },
  editExpense: function(){
    var expense_id = $(this).attr("id"); 
    var tr_parent = $(this).parents("tr");

    $(tr_parent).find(".expense-text-show").hide();
    $(tr_parent).find(".expense-value").show();
  },
  cancelUpdateExpense: function(){
    var tr_parent = $(this).parents("tr");

    $(tr_parent).find(".expense-text-show").show();
    $(tr_parent).find(".expense-value").hide();
  },
  updateExpense: function(){
    var obj = $(this);
    var expense_id = $(this).attr("id"); 

    var tr_parent = $(this).parents("tr");
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
        if (result.success){
          $(tr_parent).find("#expense-date").text(result.date);
          $(tr_parent).find("#expense-detail").text(result.detail);
          $(tr_parent).find("#expense-amount").text(result.amount);
          $(tr_parent).find("#expense-credit").html(result.credit);          
        }
        $(tr_parent).find(".expense-text-show").show();
        $(tr_parent).find(".expense-value").hide();        
      },
      data: {
        "expense[date]": expense_date,
        "expense[detail]": expense_detail,
        "expense[amount]": expense_amount,
        "expense[credit]": expense_credit
      },
      timeout: 10000,
      type: "put",
      url: "/expenses/"+expense_id
    });
  },
  init: function(){
    $(document).on("click", "button#insert-expense", Expenses.submitExpenseForm);
    $(document).on("click", ".remove-expense", Expenses.removeExpense);
    $(document).on("click", ".edit-expense", Expenses.editExpense);
    $(document).on("click", ".cancel-update-expense", Expenses.cancelUpdateExpense);
    $(document).on("click", ".update-expense-btn", Expenses.updateExpense);
  }
};

$(Expenses.init);