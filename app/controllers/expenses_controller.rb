class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @expenses = current_user.expenses.order("date desc, created_at desc")
  end

  def create
    @expense = Expense.new(expenses_params)
    if params[:expense][:credit].present?
      @expense.credit = true
    else
      @expense.credit = false
    end
    @expense.user = current_user

    if @expense.save
      render "create_success", layout: false
    else
      head(:forbidden)
    end
  end

  def update
    expense = current_user.expenses.find(params[:id])
    expense.assign_attributes(expenses_params)
    if params[:expense][:credit].present?
      expense.credit = true
    else
      expense.credit = false
    end

    if expense.save
      render json: {
        date: expense.date.strftime("%d %B"),
        detail: expense.detail,
        amount: expense.amount,
        credit: expense.credit ? "<span class='credit'>Credit</span>" : "Cash",
        is_credit: expense.credit
      }
    else
      head(:forbidden)
    end
  end

  def expense_details
    expense = current_user.expenses.find(params[:id])
    if expense.present?
      render json: {
        date: expense.date.strftime("%d %B"),
        detail: expense.detail,
        amount: expense.amount,
        credit: expense.credit ? "<span class='credit'>Credit</span>" : "Cash",
        is_credit: expense.credit
      }
    else
      head(:forbidden)
    end
  end

  def destroy
    current_user.expenses.find(params[:id]).destroy
    render json: {success: true}
  end

  private
  def expenses_params
    params.require(:expense).permit(:date, :detail, :amount)
  end

end