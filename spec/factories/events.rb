FactoryGirl.define do
  factory :event do
    from                           { Time.current }
    to                             { Time.current + 2.days }
    description                    { "Description" }
  end
end
