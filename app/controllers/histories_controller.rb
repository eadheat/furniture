class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq    
    
    @paid_for_month = current_user.expenses.where('extract(year from date) = ?', Time.now.year)
    @paid_for_month = @paid_for_month.where('extract(month from date) = ?', Time.now.month)
    @paid_for_month = @paid_for_month.order("date desc, created_at desc")

    @months = {}
    @paid_for_year = current_user.expenses.where('extract(year from date) = ?', Time.now.year).map do |expense|
      if @months.keys.include?("#{expense.date.strftime('%B')}")
        @months["#{expense.date.strftime('%B')}"] = (@months["#{expense.date.strftime('%B')}"] + expense.amount).to_f
      else
        @months["#{expense.date.strftime('%B')}"] = expense.amount.to_f
      end
    end 
  end
end