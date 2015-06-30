class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.datetime  :date
      t.text      :detail
      t.decimal   :amount
      t.boolean   :credit,            default: false
      t.integer   :user_id
      t.timestamps
    end
    add_index :expenses, :user_id
  end
end
