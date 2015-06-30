class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def create
    puts params
  end

end