class User < ActiveRecord::Base
  has_many :expenses
  has_many :events
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def name_or_email
    self.name.present? ? self.name : self.email
  end

  def total_of_this_month
    paid_for_month = self.expenses.where('extract(year from date) = ?', Time.current.year)
    paid_for_month = paid_for_month.where('extract(month from date) = ?', Time.current.month)
    paid_for_month = paid_for_month.order("date desc, created_at desc") 

    return paid_for_month.map(&:amount).sum
  end

  def average_of_this_month
    paid_for_month = self.expenses.where('extract(year from date) = ?', Time.current.year)
    paid_for_month = paid_for_month.where('extract(month from date) = ?', Time.current.month)
    paid_for_month = paid_for_month.order("date desc, created_at desc") 

    days_in_month = User.get_days_in_month(paid_for_month)
    total = paid_for_month.map(&:amount).sum
    return User.get_average(days_in_month, total)
  end

  def self.get_days_in_month(paid_for_month)
    paid_for_month.map(&:date).map(&:to_date).uniq.size
  end

  def self.get_average(days_in_month, total)
    (days_in_month > 0) ? (total / days_in_month).round(2) : 0
  end

end
