FactoryBot.define do
  factory :bid do
    sequence(:description) { |n| "description-#{n}" }
    sequence(:amount) { |n| n * 10 }
    association :task, factory: :task
    association :user, factory: :confirmed_user

    factory :accepted_bid do
      status { Bid.statuses[:accepted] }
      association :task, factory: :unpaid_task
    end

    factory :finished_bid do
      status { Bid.statuses[:finished] }
      association :task, factory: :finished_task
    end

    factory :bid_with_unpaid_task do
      association :task, factory: :unpaid_task
    end
  end
end
