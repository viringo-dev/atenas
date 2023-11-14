FactoryBot.define do
  factory :payment do
    sequence(:payer) { |n| "payer-#{n}" }
    association :bid, factory: :bid
  end
end
