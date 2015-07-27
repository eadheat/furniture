class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq
    @year = params[:year].present? ? params[:year] : Time.now.year

    @months = {}
    @total_amount = 0
    current_user.expenses.where('extract(year from date) = ?', @year).map do |expense|
      @total_amount = @total_amount + expense.amount
      if @months.keys.include?("#{expense.date.to_date}")
        @months["#{expense.date.to_date}"] = (@months["#{expense.date.to_date}"] + expense.amount).to_f
      else
        @months["#{expense.date.to_date}"] = expense.amount.to_f
      end
    end 
  end
end