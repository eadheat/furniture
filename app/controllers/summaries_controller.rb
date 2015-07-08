class SummariesController < ApplicationController
  before_action :authenticate_user!

  def index
    @average = "Average for all."
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq
  end
end