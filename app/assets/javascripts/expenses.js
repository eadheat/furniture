Expenses = {
  submitExpenseForm: function(){
    alert(111);
    var tr_parent = $(this).parents("tr");
    var expense_date = $(tr_parent).find("name[expense_date]").val();
    var expense_detail = $(tr_parent).find("name[expense_detail]").val();
    var expense_amount = $(tr_parent).find("name[expense_amount]").val();
    var expense_payment_id = $(tr_parent).find("name[expense_payment_id]").val();

    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      dataType: 'html',
      success: function(result) {
      },
      data: {
        "expense[date]": expense_date,
        "expense[detail]": expense_detail,
        "expense[amount]": expense_amount,
        "expense[payment_id]": expense_payment_id
      },
      timeout: 10000,
      type: "post",
      url: "/expenses"
    });
  },
  init: function(){
    $(document).on("click", "button#insert-expense", Expenses.submitExpenseForm);
  }
};

$(Expenses.init);