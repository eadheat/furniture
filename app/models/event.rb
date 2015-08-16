class Event < ActiveRecord::Base
  belongs_to :user

  validates :from, presence: true
  validates :to, presence: true
  validates :description, presence: true
end