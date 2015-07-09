class AveragesController < ApplicationController
  before_action :authenticate_user!

  def index
    from = Expense.first.date.strftime("%d %B %Y")
    @summaries = "Summaies from #{from} to #{Time.now.strftime('%d %B %Y')}"
    @averages = "Averages from #{from} to #{Time.now.strftime('%d %B %Y')}"
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq    
  end
end