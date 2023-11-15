FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "name-#{n}" }
    sequence(:description) { |n| "description-#{n}" }
    sequence(:reward) { |n| n * 10 }
    sequence(:deadline) { |n| Date.current + n.days }
    association :user, factory: :confirmed_user

    factory :unpaid_task do
      status { Task.statuses[:unpaid] }
    end
  end
end
