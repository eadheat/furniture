class ExpensesController < ApplicationController
  before_action :authenticate_user!

  before_action :load_details

  def load_details
    @expense_details = current_user.expenses.map(&:detail).uniq.join(",")
  end

  def index   
    total_money_for_today
    @expenses = current_user.expenses.order(
                                        "date desc, created_at desc"
                                      ).paginate(
                                        :page => params[:page], :per_page => 30
                                      )
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
      total_money_for_today
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
      total_money_for_today
      render json: {
        date: expense.date.strftime("%d.%m.%Y"),
        detail: expense.detail,
        amount: expense.amount,
        credit: expense.credit ? "<span class='credit'>#{t('credit')}</span>" : t("cash"),
        is_credit: expense.credit,
        total_for_today: @current_date_total,
        total_of_this_month: current_user.total_of_this_month,
        average_of_this_month: current_user.average_of_this_month
      }
    else
      head(:forbidden)
    end
  end

  def expense_details
    expense = current_user.expenses.find(params[:id])
    if expense.present?
      render json: {
        date: expense.date.strftime("%d.%m.%Y"),
        detail: expense.detail,
        amount: expense.amount,
        credit: expense.credit ? "<span class='credit'>#{t('credit')}</span>" : t("cash"),
        is_credit: expense.credit
      }
    else
      head(:forbidden)
    end
  end

  def destroy
    current_user.expenses.find(params[:id]).destroy
    total_money_for_today
    render json: {
      success: true, 
      total_for_today: @current_date_total,
      total_of_this_month: current_user.total_of_this_month,
      average_of_this_month: current_user.average_of_this_month
    }
  end

  private
  def expenses_params
    params.require(:expense).permit(:date, :detail, :amount)
  end

  def total_money_for_today
    @current_date_total = current_user.expenses.where(:date => Time.current.to_date).map(&:amount).sum
  end

end