FactoryBot.define do
  factory :bid do
    sequence(:description) { |n| "description-#{n}" }
    sequence(:amount) { |n| n * 10 }
    association :task, factory: :task
    association :user, factory: :confirmed_user
  end
end
