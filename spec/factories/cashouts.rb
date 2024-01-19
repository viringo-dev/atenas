FactoryBot.define do
  factory :cashout do
    sequence(:phone) { |n| "+51 " + (900000000 + rand(1000...100000)).to_s }
    association :bid, factory: :finished_bid

    after(:build) do |cashout|
      cashout.task = cashout.bid.task
    end
  end
end
