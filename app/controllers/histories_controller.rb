class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
    my_expenses = params[:other_expense].present? ? current_user.expenses.other_expenses : current_user.expenses.my_expenses
    
    @expese_year_list = my_expenses.map(&:date).map(&:year).uniq
    @year = (1.."#{this_year}".to_i).include?(params[:year].to_i) ? params[:year].to_i : this_year

    @months = {}
    @total_amount = 0

    my_expenses.where('extract(year from date) = ?', @year).map do |expense|
      @total_amount = @total_amount + expense.amount
      if @months.keys.include?("#{expense.date.strftime('%B')}")
        @months["#{expense.date.strftime('%B')}"] = (@months["#{expense.date.strftime('%B')}"] + expense.amount).to_f
      else
        @months["#{expense.date.strftime('%B')}"] = expense.amount.to_f
      end
    end 
  end
end