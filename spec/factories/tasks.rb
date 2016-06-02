FactoryGirl.define do
  factory :task do
    user nil
    image nil
    status 'new'
    params '{ "test": true }'
  end
end
