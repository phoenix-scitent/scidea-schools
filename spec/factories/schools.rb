FactoryGirl.define do
  factory :school do
    sequence(:name) { |n| "School #{n}" }
    address_1 'School Address 1'
    address_2 'School Address 2'
    city 'School City'
    state 'VA'
    zipcode '12345'
    phone '9876543210'
    approved true
  end
end
