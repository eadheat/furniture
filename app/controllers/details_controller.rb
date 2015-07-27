class DetailsController < ApplicationController
  def index
    today = Time.now.localtime.day
    current_month = Time.now.localtime.month
    current_year = Time.now.localtime.year
    
    @month = (1..12).include?(params[:month].to_i) ? params[:month].to_i : Time.now.month
    @year = (1.."#{current_year}".to_i).include?(params[:year].to_i) ? params[:year].to_i : Time.now.year
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq

    @paid_for_month = current_user.expenses.where('extract(year from date) = ?', @year)
    @paid_for_month = @paid_for_month.where('extract(month from date) = ?', @month)
    @paid_for_month = @paid_for_month.order("date desc, created_at desc")   

    if @month == current_month && @year == current_year
        days_in_month = today
    else
        days_in_month = Time.days_in_month(@month, @year)
    end

    @total = @paid_for_month.map(&:amount).sum
    @average = (@total / days_in_month).round(2)
  end
end