FactoryGirl.define do
  factory :event do
    from                           { Time.now }
    to                             { Time.now + 2.days }
    description                    { "Description" }
  end
end
