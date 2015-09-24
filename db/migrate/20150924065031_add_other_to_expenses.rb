class AddOtherToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :other, :boolean, default: false
  end
end
