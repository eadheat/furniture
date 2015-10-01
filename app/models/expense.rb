class Expense < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :detail, presence: true
  validates :amount, presence: true

  scope :my_expenses, -> { where(other: false).where(income: false) }
  scope :other_expenses, -> { where(other: true).where(income: false) }
  scope :incomes, -> { where(income: true) }

  def other_amount
    return 0 if self.income?

    self.other? ? self.amount : 0
  end

  def expense_amount
    return 0 if self.income?

    self.other? ? 0 : self.amount
  end

  def income_amount
    return 0 unless self.income?    
    self.amount
  end

  def amount_except_income
    return 0 if self.income?
    self.amount
  end

end