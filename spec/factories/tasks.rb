FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "name-#{n}" }
    sequence(:description) { |n| "description-#{n}" }
    sequence(:reward) { |n| n * 10 }
    sequence(:deadline) { |n| Date.current + n.days }
    association :user, factory: :confirmed_user

    trait :task_with_file do
      after(:create) do |task|
        task.files.attach(io: File.open(Rails.root.join("public", "logo.png")), filename: "logo.png", content_type: "image/png")
      end
    end

    factory :unpaid_task do
      status { Task.statuses[:unpaid] }
    end

    factory :assigned_task do
      status { Task.statuses[:assigned] }
    end

    factory :finished_task do
      status { Task.statuses[:finished] }
    end
  end
end
