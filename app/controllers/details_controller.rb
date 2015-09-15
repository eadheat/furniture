class DetailsController < ApplicationController
  def index
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq
    
    @month = for_month(params)
    @year  = for_year(params)

    @paid_for_month = current_user.expenses.where('extract(year from date) = ?', @year)
    @paid_for_month = @paid_for_month.where('extract(month from date) = ?', @month)
    @paid_for_month = @paid_for_month.order("date desc, created_at desc")

    get_days_in_month # get days in month

    @total = @paid_for_month.map(&:amount).sum
    @average = get_average # get average per days count to add to the system
  end

  private
  def for_month(params)
    (1..12).include?(params[:month].to_i) ? params[:month].to_i : current_month
  end

  def for_year(params)
    (1.."#{current_year}".to_i).include?(params[:year].to_i) ? params[:year].to_i : current_year
  end

  def get_days_in_month
    @days_in_month = @paid_for_month.map(&:date).map(&:to_date).uniq.size
  end

  def get_average
    (@days_in_month > 0) ? (@total / @days_in_month).round(2) : 0
  end
end