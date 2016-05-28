FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Internet.user_name  }
    password { Faker::Internet.password }
  end
end
