class Payment < ActiveRecord::Base
  has_many :expenses
end