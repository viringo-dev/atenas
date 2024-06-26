FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name-#{n}" }
    sequence(:surname) { |n| "surname-#{n}" }
    sequence(:email) { |n| "slug_#{n}@example.com" }
    sequence(:slug) { |n| "slug_#{n}" }
    sequence(:phone) { |n| (900000000 + rand(1000...100000)).to_s }
    sequence(:city) { |n| "city-#{n}" }
    birthdate { Date.current - 20.years }
    gender { User.genders[:male] }
    password { "p4$$w0rd" }

    factory :confirmed_user do
      confirmed_at { Time.current }
    end
  end
end
