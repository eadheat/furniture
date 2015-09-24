class Expense < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :detail, presence: true
  validates :amount, presence: true

  scope :my_expenses, -> { where(other: false) }
  scope :other_expenses, -> { where(other: true) }

  def today
    self.date.to_date.to_s
  end
end