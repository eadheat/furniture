class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @expenses = Expense.all.order("date desc")
  end

  def create
    expense = Expense.new(expenses_params)
    if params[:expense][:credit].present?
      expense.credit = true
    else
      expense.credit = false
    end

    if expense.save
      render json: {
        success: true, 
        date: expense.date.strftime("%d.%m.%Y"),
        detail: expense.detail,
        amount: expense.amount,
        credit: expense.credit ? "Credit" : "Cash"
      }
    else
      render json: {success: false, error: "#{expense.errors.full_messages.join(', ')}"}
    end
  end

  private
  def expenses_params
    params.require(:expense).permit(:date, :detail, :amount)
  end

end