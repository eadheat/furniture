class DetailsController < ApplicationController
  def index
    current_year = Time.now.year
    @month = (1..12).include?(params[:month].to_i) ? params[:month] : Time.now.month
    @year = (1.."#{current_year}".to_i).include?(params[:year].to_i) ? params[:year] : Time.now.year
    @expese_year_list = current_user.expenses.map(&:date).map(&:year).uniq

    @paid_for_month = current_user.expenses.where('extract(year from date) = ?', @year)
    @paid_for_month = @paid_for_month.where('extract(month from date) = ?', @month)
    @paid_for_month = @paid_for_month.order("date desc, created_at desc")

    @total = @paid_for_month.map(&:amount).sum
    @average = "-"
  end
end