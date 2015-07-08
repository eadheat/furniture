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

  def average_expense_per_day_for_all
    (Expense.all.map(&:amount).sum / (Time.now.to_date - Expense.first.date.to_date).to_i).round(2)
  end

  def average_expense_per_month_for_all
    puts days = (Time.now.to_date - Expense.first.date.to_date).to_i
    months = days / 30
    if months > 0
      return (Expense.all.map(&:amount).sum / months).round(2)
    else
      return (Expense.all.map(&:amount).sum / 1).round(2)
    end
  end

  def paid_most(month = nil)
    if month.present?
    else
    end
  end
end
