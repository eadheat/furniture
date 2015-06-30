class Expense < ActiveRecord::Base
  belongs_to :payment

  validates :date, presence: true
  validates :detail, presence: true
  validates :amount, presence: true
end