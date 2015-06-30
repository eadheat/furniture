FactoryGirl.define do
  sequence(:user_email)            {|n| "email-#{n}@example.com" }
  factory :user do
    email                          { "#{FactoryGirl.generate(:user_email)}" }
    password                       { "asdqwe123" }
    password_confirmation          { "asdqwe123" }
  end
end
