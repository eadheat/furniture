class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
    current_year = Time.now.localtime.year
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq
    @year = (1.."#{current_year}".to_i).include?(params[:year].to_i) ? params[:year].to_i : Time.now.year

    @months = {}
    @total_amount = 0
    current_user.expenses.where('extract(year from date) = ?', @year).map do |expense|
      @total_amount = @total_amount + expense.amount
      if @months.keys.include?("#{expense.date.strftime('%B')}")
        @months["#{expense.date.strftime('%B')}"] = (@months["#{expense.date.strftime('%B')}"] + expense.amount).to_f
      else
        @months["#{expense.date.strftime('%B')}"] = expense.amount.to_f
      end
    end 
  end
end