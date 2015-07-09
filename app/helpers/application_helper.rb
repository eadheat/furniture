module ApplicationHelper
  def months
    [
      ["Jan", 1],
      ["Fab", 2],
      ["Mar", 3],
      ["Api", 4],
      ["May", 5],
      ["Jun", 6],
      ["July", 7],
      ["Aug", 8],
      ["Sep", 9],
      ["Oct", 10],
      ["Nov", 11],
      ["Dec", 12],
    ]
  end

  def summary(current_user)
    current_user.expenses.sum(:amount)
  end

  def average_expense_per_day_for_all(current_user)
    (current_user.expenses.map(&:amount).sum / (Time.now.to_date - current_user.expenses.first.date.to_date).to_i).round(2)
  end

  def average_expense_per_month_for_all(current_user)
    days = (Time.now.to_date - current_user.expenses.first.date.to_date).to_i
    months = (days / 30).to_i

    if months > 0
      return (current_user.expenses.map(&:amount).sum / months).round(2)
    else
      return (current_user.expenses.map(&:amount).sum / 1).round(2)
    end
  end

  def paid_the_most_per_day(current_user)
    current_user.expenses.select("SUM(amount) as sum_amount").group("DATE(date)").map(&:sum_amount).max
  end

  def paid_the_least_per_day(current_user)
    current_user.expenses.select("SUM(amount) as sum_amount").group("DATE(date)").map(&:sum_amount).min
  end

  def paid_the_most_per_month(current_user)
    current_user.expenses.select("SUM(amount) as sum_amount").group("DATE(date)").map(&:sum_amount).max
  end

  def paid_the_least_per_month(current_user)
    current_user.expenses.select("SUM(amount) as sum_amount").group("DATE(date)").map(&:sum_amount).min
  end
end
