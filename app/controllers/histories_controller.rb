class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq
    @year = (1.."#{this_year}".to_i).include?(params[:year].to_i) ? params[:year].to_i : this_year

    @my_expenses_total_amount = 0
    @my_expenses = {}
    @other_expenses_total_amount = 0
    @other_expenses = {}
    @total_amount = 0
    @all_expenses = {}
    

    current_user.expenses.where('extract(year from date) = ?', @year).map do |expense|
      get_all_expenses(expense)

      if expense.other?
        get_other_expenses(expense)
      else
        get_my_expenses(expense)
      end
    end 
  end

  def get_my_expenses(expense)
    @my_expenses_total_amount = @my_expenses_total_amount + expense.amount   

    if @my_expenses.keys.include?("#{expense.date.month}")
      @my_expenses["#{expense.date.month}"] = (@my_expenses["#{expense.date.month}"] + expense.amount).to_f
    else
      @my_expenses["#{expense.date.month}"] = expense.amount.to_f
    end
  end

  def get_other_expenses(expense)
    @other_expenses_total_amount = @other_expenses_total_amount + expense.amount   

    if @other_expenses.keys.include?("#{expense.date.month}")
      @other_expenses["#{expense.date.month}"] = (@other_expenses["#{expense.date.month}"] + expense.amount).to_f
    else
      @other_expenses["#{expense.date.month}"] = expense.amount.to_f
    end
  end

  def get_all_expenses(expense)
    @total_amount = @total_amount + expense.amount   
    if @all_expenses.keys.include?("#{expense.date.month}")
      @all_expenses["#{expense.date.month}"] = (@all_expenses["#{expense.date.month}"] + expense.amount).to_f
    else
      @all_expenses["#{expense.date.month}"] = expense.amount.to_f
    end
  end
end