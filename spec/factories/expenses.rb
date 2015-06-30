FactoryGirl.define do
  factory :expense do
    date                           { Time.now }
    detail                         { "Breakfast" }
    amount                         { 80 }
  end
end
