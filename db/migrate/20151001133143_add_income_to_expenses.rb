class AddIncomeToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :income, :boolean, default: false
  end
end
