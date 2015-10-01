module ApplicationHelper
  def rest(income=0, total_expense=0)
    rest = income - total_expense
    number_to_currency(rest, unit: "")
    if rest < 0
      return "<span class='red'>#{number_to_currency(rest, unit: "")}</span>".html_safe
    else
      return "<span class='green'>#{number_to_currency(rest, unit: "")}</span>".html_safe
    end    
  end
end
