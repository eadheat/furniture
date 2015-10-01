class DetailsController < ApplicationController
  def index
    if params[:other_expense].present?
      my_expenses = params[:other_expense] == "income" ? current_user.expenses.incomes : current_user.expenses.other_expenses
    else
      my_expenses = current_user.expenses.my_expenses
    end
    @expese_year_list = my_expenses.map(&:date).map(&:year).uniq
    
    @month = for_month(params)
    @year  = for_year(params)

    @paid_for_month = my_expenses.where('extract(year from date) = ?', @year)
    @paid_for_month = @paid_for_month.where('extract(month from date) = ?', @month)
    @paid_for_month = @paid_for_month.order("date desc, created_at desc")

    get_days_in_month # get days in month

    @total = @paid_for_month.map(&:amount).sum
    @average = get_average # get average per days count to add to the system

    render "index", layout: false
  end

  private
  def for_month(params)
    (1..12).include?(params[:month].to_i) ? params[:month].to_i : this_month
  end

  def for_year(params)
    (1.."#{this_year}".to_i).include?(params[:year].to_i) ? params[:year].to_i : this_year
  end

  def get_days_in_month
    @days_in_month = @paid_for_month.map(&:date).map(&:to_date).uniq.size
  end

  def get_average
    (@days_in_month > 0) ? (@total / @days_in_month).round(2) : 0
  end
end