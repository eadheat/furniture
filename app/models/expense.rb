class Expense < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :detail, presence: true
  validates :amount, presence: true

  scope :my_expenses, -> { where(other: false).where(income: false) }
  scope :other_expenses, -> { where(other: true).where(income: false) }
  scope :incomes, -> { where(income: true) }
end