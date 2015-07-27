class SummariesController < ApplicationController
  def index
    @years = current_user.expenses.map(&:date).map(&:year).uniq

    @total = 0
    @summaries = {}
    @years.each do |year|
      @summaries[year] = 0
      current_user.expenses.where('extract(year from date) = ?', year).map do |expense|
        @summaries[year] = @summaries[year] + expense.amount
      end
      @total = @total + @summaries[year]
    end
  end
end