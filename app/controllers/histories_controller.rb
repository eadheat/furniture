class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq
    @year = (1.."#{this_year}".to_i).include?(params[:year].to_i) ? params[:year].to_i : this_year

    @expenses = {}  

    current_user.expenses.where('extract(year from date) = ?', @year).order("date desc").map do |expense|
      @expenses[expense.date.month] = {
        other_total: (@expenses[expense.date.month][:other_total] rescue 0) + expense.other_amount,
        expense_total: (@expenses[expense.date.month][:expense_total] rescue 0) + expense.expense_amount,
        income_total: (@expenses[expense.date.month][:income_total] rescue 0) + expense.income_amount,
        total: (@expenses[expense.date.month][:total] rescue 0) + expense.amount_except_income
      }
    end 
  end
end