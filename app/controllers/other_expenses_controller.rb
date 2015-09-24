class OtherExpensesController < ApplicationController
  before_action :authenticate_user!

  before_action :load_details

  def load_details
    @expense_details = current_user.expenses.other_expenses.map(&:detail).uniq.join(",")
  end

  def index
    @expenses = current_user.expenses.other_expenses.order(
                                        "date desc, created_at desc"
                                      ).paginate(
                                        :page => params[:page], :per_page => 30
                                      )
  end

  def create
    @expense = Expense.new(expenses_params)
    @expense.user = current_user

    if @expense.save
      @total_of_this_month = current_user.total_of_this_month(other_expense: true)
      render "/expenses/create_success", layout: false
    else
      head(:forbidden)
    end
  end

  def update
    expense = current_user.expenses.other_expenses.find(params[:id])
    expense.assign_attributes(expenses_params)

    if expense.save
      render json: {
        date: expense.date.strftime("%d.%m.%Y"),
        detail: expense.detail,
        amount: expense.amount,
        total_for_today: 0,
        total_of_this_month: current_user.total_of_this_month(other_expense: true),
        average_of_this_month: 0
      }
    else
      head(:forbidden)
    end
  end

  def expense_details
    expense = current_user.expenses.other_expenses.find(params[:id])
    if expense.present?
      render json: {
        date: expense.date.strftime("%d.%m.%Y"),
        detail: expense.detail,
        amount: expense.amount
      }
    else
      head(:forbidden)
    end
  end

  def destroy
    current_user.expenses.other_expenses.find(params[:id]).destroy
    render json: {
      success: true, 
      total_for_today: 0,
      total_of_this_month: current_user.total_of_this_month(other_expense: true),
      average_of_this_month: 0
    }
  end

  private
  def expenses_params
    params.require(:expense).permit(:date, :detail, :amount, :other)
  end
end