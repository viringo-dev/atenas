FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "name-#{n}" }
    sequence(:description) { |n| "description-#{n}" }
    sequence(:reward) { |n| n * 10 }
    sequence(:deadline) { |n| Date.current + n.days }
    association :user, factory: :confirmed_user
    # sequence(:surname) { |n| "surname-#{n}" }
    # sequence(:email) { |n| "username_#{n}@example.com" }
    # sequence(:username) { |n| "username_#{n}" }
    # sequence(:phone) { |n| "+51 " + (900000000 + rand(1000...100000)).to_s }
    # sequence(:city) { |n| "city-#{n}" }
    # birthdate { Date.current - 20.years }
    # gender { User.genders[:male] }
    # password { "p4$$w0rd" }
  end
end
