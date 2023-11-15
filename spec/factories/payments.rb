FactoryBot.define do
  factory :payment do
    sequence(:payer) { |n| "payer-#{n}" }
    association :bid, factory: :accepted_bid
  end
end
