class Expense < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :detail, presence: true
  validates :amount, presence: true
end