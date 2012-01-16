Factory.define :school do |f|
  f.sequence(:name) { |n| "School #{n}" } #n will increment each time a school factory is created
  f.address_1 'School Address 1'
  f.address_2 'School Address 2'
  f.city 'School City'
  f.state 'VA'
  f.zipcode '12345'
  f.phone '9876543210'
  f.approved true
end
