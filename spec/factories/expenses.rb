FactoryGirl.define do
  factory :expense do
    date                           { Time.current }
    detail                         { "Breakfast" }
    amount                         { 80 }
  end
end
