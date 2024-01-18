FactoryBot.define do
  factory :payment do
    sequence(:payer) { |n| "payer-#{n}" }
    association :bid, factory: :bid_with_unpaid_task

    after(:build) do |payment|
      payment.task = payment.bid.task
    end
  end
end
