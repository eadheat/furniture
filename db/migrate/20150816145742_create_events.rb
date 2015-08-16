class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer       :user_id
      t.datetime      :from
      t.datetime      :to
      t.text          :description
      t.timestamps
    end
  end
end
