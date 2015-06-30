class Expense < ActiveRecord::Base
  belongs_to :payment
end