FactoryBot.define do
  factory :rating do
    value { rand(1..5) }
    comment { "This is a comment" }
    rating_type { Rating.rating_types[:task_owner] }
    association :bid, factory: :paid_bid

    trait :task_assignee do
      rating_type { Rating.rating_types[:task_assignee] }
    end

    after(:build) do |rating|
      rating.task = rating.bid.task
      rating.user = rating.task.user
      rating.rater = rating.bid.user
    end
  end
end
