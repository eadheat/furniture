class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.datetime  :date
      t.text      :detail
      t.decimal   :amount
      t.integer   :user_id
      t.integer   :payment_id
      t.timestamps
    end
    add_index :expenses, :user_id
    add_index :expenses, :payment_id
  end
end
